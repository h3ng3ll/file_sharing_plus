#!/bin/bash
#
# configure_codemagic.sh — configure codemagic.yaml and its Codemagic app.
#
# The script decides for itself what is required. It does not carry a hardcoded
# credential list: it derives one by reading codemagic.yaml, then reconciles it
# against what the Codemagic application already stores.
#
#   1. __PLACEHOLDER__ tokens  (__BUNDLE_ID__, …)  -> substituted in the file
#   2. $VAR credentials the yaml consumes but never assigns
#                                                  -> uploaded to the app
#
# For (2) it asks Codemagic which variables already exist and prompts ONLY for
# the missing ones; --force walks through every one, including those already
# set. Secure variables are write-only in the Codemagic API, so an existing
# secure value can be kept without ever being read back.
#
# KEY MATERIAL (*_P8, *_PRIVATE_KEY, *_CERTIFICATE, *_PEM) is asked for as a
# FILE PATH, never as a paste. A single-line `read` stops at the first newline,
# so pasting a .p8 would capture nothing and spill its remaining lines into the
# shell as stray commands. Type PASTE to use a heredoc terminated by a lone EOF
# line if the file is not on disk.
#
# The API token is never typed or stored here — it is read from the macOS
# keychain via the `security` utility.
#
# USAGE
#   scripts/configure_codemagic.sh [options]
#
# OPTIONS
#   --app-name=<name>   Codemagic application name (default: file_sharing_plus)
#   --force             Prompt for every required variable, even if already set
#   --placeholders-only Only substitute __PLACEHOLDER__ tokens; touch no remote
#   --no-remote         Alias for --placeholders-only
#   --dry-run           Report what would change; write nothing
#   --non-interactive   Never prompt (implies --dry-run); for CI inspection
#   --restore           Restore codemagic.yaml from its .bak and exit
#   -h, --help          Show this help
#
# Add the token once with:
#   security add-generic-password -s HENGELL_CODEMAGIC_TOKEN -a "$USER" -w
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# scripts/ -> project root
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
YAML="$PROJECT_DIR/codemagic.yaml"
BACKUP="$YAML.bak"

KEYCHAIN_SERVICE='HENGELL_CODEMAGIC_TOKEN'
APP_NAME='file_sharing_plus'
FORCE=false
PLACEHOLDERS_ONLY=false
DRY_RUN=false
RESTORE=false
NON_INTERACTIVE=false

# Real production value for the bundle id placeholder.
DEFAULT_BUNDLE_ID='com.hengell.file-sharing-plus.ios'

C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
C_RED=$'\033[31m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_CYAN=$'\033[36m'

ok()    { printf '%s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn()  { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
err()   { printf '%s✗%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
info()  { printf '%s\n' "$*"; }
head1() { printf '\n%s%s%s\n' "$C_BOLD" "$*" "$C_RESET"; }
die()   { err "$*"; exit 1; }
usage() { sed -n '2,41p' "${BASH_SOURCE[0]}" | sed 's/^#\{1,2\} \{0,1\}//; s/^#$//'; }

for arg in "$@"; do
  case "$arg" in
    --app-name=*)                 APP_NAME="${arg#*=}" ;;
    --force|-f)                   FORCE=true ;;
    --placeholders-only|--no-remote) PLACEHOLDERS_ONLY=true ;;
    --dry-run)                    DRY_RUN=true ;;
    --non-interactive)            NON_INTERACTIVE=true ;;
    --restore)                    RESTORE=true ;;
    -h|--help)                    usage; exit 0 ;;
    *)                            die "Unknown option: $arg (try --help)" ;;
  esac
done

if [[ "$RESTORE" == true ]]; then
  [[ -f "$BACKUP" ]] || die "No backup to restore at $BACKUP"
  cp "$BACKUP" "$YAML"; ok "Restored codemagic.yaml from $(basename "$BACKUP")"; exit 0
fi
[[ -f "$YAML" ]] || die "codemagic.yaml not found at $YAML"

# With no controlling terminal (CI, a pipe) prompting can only hang, so fall
# back to reporting the derived requirements instead of blocking on read.
if [[ ! -t 0 ]] && [[ "$NON_INTERACTIVE" != true ]]; then
  NON_INTERACTIVE=true
  DRY_RUN=true
fi

ask() {  # ask <prompt> <default>  -> echoes the answer, never empty
  local prompt="$1" def="${2:-}" reply=''
  if [[ "$NON_INTERACTIVE" == true ]]; then printf '%s' "${def:-<unset>}"; return 0; fi
  while true; do
    if [[ -n "$def" ]]; then
      read -e -r -p "  $prompt [$def]: " reply </dev/tty || reply=''
      reply="${reply:-$def}"
    else
      read -e -r -p "  $prompt: " reply </dev/tty || reply=''
    fi
    if [[ -z "$reply" ]]; then
      warn "  A value is required."
    elif [[ "$reply" =~ ^__[A-Z0-9_]+__$ ]]; then
      warn "  That is still a placeholder."
    else
      printf '%s' "$reply"; return 0
    fi
  done
}

# True for credentials whose value is PEM/key material rather than a short
# scalar: those must never go through a single-line read.
is_multiline_var() {
  case "$1" in
    *_P8|*_PRIVATE_KEY|*_CERTIFICATE|*_KEY_CONTENT|*_PEM) return 0 ;;
    *) return 1 ;;
  esac
}

# ask_multiline <VAR_NAME> -> echoes the full multi-line value.
#
# Prefers a file path (tab-completable, paste-proof). Falls back to a heredoc
# paste terminated by a lone "EOF" line, which tolerates embedded newlines
# because it keeps reading until the sentinel instead of stopping at line 1.
ask_multiline() {
  local var="$1" path='' value='' line=''
  if [[ "$NON_INTERACTIVE" == true ]]; then printf '<unset>'; return 0; fi
  info "  ${C_DIM}${var} holds multi-line key material.${C_RESET}" >&2
  info "  ${C_DIM}Give the path to the .p8/.pem file (recommended), or type PASTE.${C_RESET}" >&2
  while true; do
    read -e -r -p "  file path (or PASTE): " path </dev/tty || path=''
    # Trim quotes and whitespace a drag-and-drop into the terminal adds.
    path="${path#\"}"; path="${path%\"}"
    path="${path#\'}"; path="${path%\'}"
    path="${path## }"; path="${path%% }"
    if [[ "$path" == 'PASTE' ]]; then
      info "  Paste the key, then a line containing only EOF:" >&2
      value=''
      while IFS= read -r line </dev/tty; do
        [[ "$line" == 'EOF' ]] && break
        value+="$line"$'\n'
      done
      value="${value%$'\n'}"
    elif [[ -z "$path" ]]; then
      warn "  A path is required (or type PASTE)."; continue
    else
      # Expand a leading ~ that the shell does not expand inside a variable.
      [[ "$path" == '~'* ]] && path="${HOME}${path#\~}"
      if [[ ! -f "$path" ]]; then warn "  No such file: $path"; continue; fi
      if [[ ! -r "$path" ]]; then warn "  Not readable: $path"; continue; fi
      value="$(cat "$path")"
    fi
    if [[ -z "${value//[[:space:]]/}" ]]; then
      warn "  Empty value; nothing captured."; continue
    fi
    # A .p8 must be a private key; catch the common mistake of passing the
    # public cert, a .mobileprovision, or the wrong file entirely.
    if ! printf '%s' "$value" | grep -q 'BEGIN .*PRIVATE KEY'; then
      warn "  That does not look like a PRIVATE KEY (no BEGIN … PRIVATE KEY header)."
      read -e -r -p "  use it anyway? [y/N]: " yn </dev/tty || yn=''
      [[ "$yn" =~ ^[Yy]$ ]] || continue
    fi
    printf '%s' "$value"; return 0
  done
}

# ===========================================================================
# 1. Token — keychain only.
# ===========================================================================
head1 "Codemagic API token"
TOKEN=''
if TOKEN=$(security find-generic-password -s "$KEYCHAIN_SERVICE" -w 2>/dev/null) \
   && [[ -n "$TOKEN" ]]; then
  # Masked fingerprint only — enough to distinguish two tokens, never the value.
  ok "keychain:$KEYCHAIN_SERVICE (${#TOKEN} chars, ends …${TOKEN: -4})"
else
  TOKEN=''
  warn "No token in keychain service $KEYCHAIN_SERVICE"
  info "  security add-generic-password -s $KEYCHAIN_SERVICE -a \"\$USER\" -w"
  PLACEHOLDERS_ONLY=true
fi

# ===========================================================================
# 2. Derive what codemagic.yaml requires.
# ===========================================================================
head1 "Requirements derived from codemagic.yaml"

PLACEHOLDERS=$(grep -oE '__[A-Z0-9_]+__' "$YAML" | sort -u || true)
if [[ -n "$PLACEHOLDERS" ]]; then
  info "Placeholders:"
  while read -r ph; do
    [[ -n "$ph" ]] || continue
    printf '  %s%s%s %s(line %s)%s\n' "$C_CYAN" "$ph" "$C_RESET" "$C_DIM" \
      "$(grep -nF -- "$ph" "$YAML" | cut -d: -f1 | paste -sd, -)" "$C_RESET"
  done <<< "$PLACEHOLDERS"
else
  ok "No placeholders left in the file."
fi

# A $VAR is a credential only if the yaml never assigns it. Anything set inside
# an inline build script (COUNT=, LOCALE=, …) is shell-local, not a secret, and
# Codemagic's own built-ins are provided by the platform.
BUILTINS='HOME PATH PWD USER SHELL CM_BUILD_ID CM_BUILD_DIR CM_BRANCH CM_COMMIT FCI_BUILD_ID'
REQUIRED_VARS=$(python3 - "$YAML" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
referenced = set(re.findall(r'\$\{?([A-Z][A-Z0-9_]{2,})\}?', text))
# Assigned anywhere in the file: VAR=..., read VAR, for VAR in, yaml "VAR:" keys.
assigned  = set(re.findall(r'^\s*([A-Z][A-Z0-9_]{2,})=',          text, re.M))
assigned |= set(re.findall(r'\b([A-Z][A-Z0-9_]{2,})=\$\(',        text))
for stmt in re.findall(r'\bread\s+((?:-\w+\s+)*[A-Z][A-Z0-9_ ]*)', text):
    assigned |= set(re.findall(r'[A-Z][A-Z0-9_]{2,}', stmt))
assigned |= set(re.findall(r'\bfor\s+([A-Z][A-Z0-9_]{2,})\s+in\b', text))
assigned |= set(re.findall(r'^\s+([A-Z][A-Z0-9_]{2,}):\s',        text, re.M))
print('\n'.join(sorted(referenced - assigned)))
PY
)
for b in $BUILTINS; do
  REQUIRED_VARS=$(printf '%s\n' "$REQUIRED_VARS" | grep -vx "$b" || true)
done
REQUIRED_VARS=$(printf '%s\n' "$REQUIRED_VARS" | grep -v '^$' || true)

# The group the yaml expects these variables to live in.
GROUP=$(awk '/^[[:space:]]*groups:[[:space:]]*$/{f=1;next}
             f&&/^[[:space:]]*-[[:space:]]/{print $2; exit}
             f{f=0}' "$YAML")
GROUP="${GROUP:-Default}"

if [[ -n "$REQUIRED_VARS" ]]; then
  info ''
  info "Credentials the yaml consumes but never assigns (group ${C_CYAN}$GROUP${C_RESET}):"
  printf '%s\n' "$REQUIRED_VARS" | sed "s/^/  /"
fi

# ===========================================================================
# 3. Substitute placeholders.
# ===========================================================================
declare -a PH_KEYS=() PH_VALS=()
if [[ -n "$PLACEHOLDERS" ]]; then
  head1 "Placeholder values"
  while read -r ph; do
    [[ -n "$ph" ]] || continue
    case "$ph" in
      __BUNDLE_ID__)         desc='iOS bundle identifier'; def="$DEFAULT_BUNDLE_ID" ;;
      __APP_STORE_CONNECT__) desc='Codemagic App Store Connect integration name'; def='' ;;
      *)                     desc="value for $ph"; def='' ;;
    esac
    printf '\n%s%s%s — %s\n' "$C_BOLD" "$ph" "$C_RESET" "$desc"
    val="$(ask 'value' "$def")"
    PH_KEYS+=("$ph"); PH_VALS+=("$val")
  done <<< "$PLACEHOLDERS"
fi

# ===========================================================================
# 4. Reconcile credentials against the app — ask only for what is missing.
# ===========================================================================
APP_ID=''
# Names already stored on the app. Set together with VAR_KEYS below, and read
# again by the apply loop to pick add-vs-set; defaulted here so the loop cannot
# trip `set -u` if a future edit separates the two.
PRESENT=''
declare -a VAR_KEYS=() VAR_VALS=() VAR_SECURE=()
if [[ "$PLACEHOLDERS_ONLY" != true && -n "$REQUIRED_VARS" ]]; then
  head1 "Codemagic application"
  if ! command -v codemagic_repo >/dev/null 2>&1; then
    warn "codemagic_repo CLI not on PATH — skipping the credential step"
    PLACEHOLDERS_ONLY=true
  else
    APP_ID=$(codemagic_repo apps --token "$TOKEN" 2>/dev/null \
      | awk -v n="$APP_NAME" '$2 == n {print $1; exit}') || true
    if [[ -z "$APP_ID" ]]; then
      warn "Application '$APP_NAME' not visible to this token"
      PLACEHOLDERS_ONLY=true
    else
      ok "$APP_NAME -> $APP_ID"
      EXISTING=$(codemagic_repo list --app="$APP_ID" --token "$TOKEN" 2>&1 || true)
      # Variable names already present on the app, whatever group they are in.
      # Skip the CLI's table header row; keep only real variable names.
      PRESENT=$(printf '%s\n' "$EXISTING" \
        | awk 'NR>1 && $1 ~ /^[A-Z][A-Z0-9_]{2,}$/ {print $1}' | sort -u || true)
      if [[ -n "$PRESENT" ]]; then
        info "Already set on the app:"; printf '%s\n' "$PRESENT" | sed 's/^/  /'
      else
        warn "The app stores no variables yet — every credential is missing."
      fi

      head1 "Credentials"
      [[ "$FORCE" == true ]] && info "${C_DIM}--force: prompting for all, including those already set.${C_RESET}"
      while read -r var; do
        [[ -n "$var" ]] || continue
        if [[ "$FORCE" != true ]] && printf '%s\n' "$PRESENT" | grep -qx "$var"; then
          ok "$var — already set, skipping"
          continue
        fi
        printf '\n%s%s%s\n' "$C_BOLD" "$var" "$C_RESET"
        if [[ "$FORCE" == true ]] && printf '%s\n' "$PRESENT" | grep -qx "$var"; then
          info "  ${C_DIM}already set; blank keeps the current value${C_RESET}"
          if [[ "$NON_INTERACTIVE" == true ]]; then ok "  kept"; continue; fi
          if is_multiline_var "$var"; then
            # Reuse the multiline reader, but let a blank first answer mean
            # "keep what is already stored" rather than forcing a new value.
            read -e -r -p "  replace key material? [y/N]: " yn </dev/tty || yn=''
            [[ "$yn" =~ ^[Yy]$ ]] || { ok "  kept"; continue; }
            val="$(ask_multiline "$var")"
          else
            read -e -r -p "  value (blank = keep): " val </dev/tty || val=''
            [[ -z "$val" ]] && { ok "  kept"; continue; }
          fi
        elif is_multiline_var "$var"; then
          val="$(ask_multiline "$var")"
        else
          val="$(ask 'value' '')"
        fi
        if [[ "$NON_INTERACTIVE" == true ]]; then
          sec=true
        else
          read -e -r -p "  secure? [Y/n]: " sec </dev/tty || sec=''
          [[ "$sec" =~ ^[Nn]$ ]] && sec=false || sec=true
        fi
        VAR_KEYS+=("$var"); VAR_VALS+=("$val"); VAR_SECURE+=("$sec")
      done <<< "$REQUIRED_VARS"
    fi
  fi
fi

# ===========================================================================
# 5. Summary, confirm, apply.
# ===========================================================================
head1 "Summary"
if ((${#PH_KEYS[@]})); then
  info "codemagic.yaml substitutions:"
  for i in "${!PH_KEYS[@]}"; do printf '  %-24s -> %s\n' "${PH_KEYS[$i]}" "${PH_VALS[$i]}"; done
fi
if ((${#VAR_KEYS[@]})); then
  info "Upload to $APP_NAME / group $GROUP:"
  for i in "${!VAR_KEYS[@]}"; do
    if [[ "${VAR_SECURE[$i]}" == true ]]; then
      printf '  %-24s = %s %s(secure)%s\n' "${VAR_KEYS[$i]}" '********' "$C_DIM" "$C_RESET"
    else
      printf '  %-24s = %s\n' "${VAR_KEYS[$i]}" "${VAR_VALS[$i]}"
    fi
  done
fi
if ((${#PH_KEYS[@]} == 0 && ${#VAR_KEYS[@]} == 0)); then
  ok "Nothing to do — everything required is already configured."
  exit 0
fi

if [[ "$DRY_RUN" == true ]]; then
  info ''; ok "Dry run — nothing written."; exit 0
fi
printf '\n'
if [[ "$NON_INTERACTIVE" == true ]]; then
  info "Non-interactive: refusing to write without confirmation."; exit 0
fi
read -e -r -p "Apply? [y/N]: " reply </dev/tty || reply=''
[[ "$reply" =~ ^[Yy]$ ]] || { info "Aborted; nothing written."; exit 0; }

if ((${#PH_KEYS[@]})); then
  cp "$YAML" "$BACKUP"
  TMP="$(mktemp)"; cp "$YAML" "$TMP"
  for i in "${!PH_KEYS[@]}"; do
    # python, not sed: a value containing / & or \ must not corrupt the file.
    KEY="${PH_KEYS[$i]}" VAL="${PH_VALS[$i]}" python3 - "$TMP" <<'PY'
import os, sys
path, key, val = sys.argv[1], os.environ['KEY'], os.environ['VAL']
text = open(path).read()
if key not in text:
    sys.exit(f'placeholder vanished before substitution: {key}')
open(path, 'w').write(text.replace(key, val))
PY
  done
  mv "$TMP" "$YAML"
  ok "codemagic.yaml updated (backup: $(basename "$BACKUP"))"
fi

FAILED=0
# Temp files carry private key material; shred them however we exit.
VF_LIST=()
cleanup_vf() { ((${#VF_LIST[@]})) && rm -f "${VF_LIST[@]}"; }
trap cleanup_vf EXIT INT TERM
for i in "${!VAR_KEYS[@]}"; do
  KEY="${VAR_KEYS[$i]}"

  # Reset per iteration. Without this, VF still holds the PREVIOUS multi-line
  # variable's temp file, so a later fallback could upload the wrong key
  # material under this variable's name.
  VF=''

  # Multi-line material goes through --value-file so the value never becomes
  # an argv entry; `--value=<multi-line>` is dropped by the argument parser.
  if is_multiline_var "$KEY"; then
    VF="$(mktemp)"; VF_LIST+=("$VF")
    printf '%s' "${VAR_VALS[$i]}" > "$VF"
    chmod 600 "$VF"
    value_args=(--value-file "$VF")
  else
    value_args=(--value "${VAR_VALS[$i]}")
  fi

  # Choose the verb from whether the key already exists, NOT from `add`'s exit
  # status. `add` SUCCEEDS on an existing app-level key (the bulk-import
  # endpoint accepts it), so the old "add failed => must be an update" fallback
  # never reflected what actually happened and reported the wrong verb.
  if printf '%s\n' "$PRESENT" | grep -qx "$KEY"; then
    verb=set;  verb_past=updated
  else
    verb=add;  verb_past=uploaded
  fi

  args=("$verb" --app="$APP_ID" --group="$GROUP"
        --key "$KEY" "${value_args[@]}" --token "$TOKEN")
  [[ "${VAR_SECURE[$i]}" == true ]] && args+=(--secure)

  if out=$(codemagic_repo "${args[@]}" 2>&1); then
    ok "$verb_past $KEY"
    continue
  fi

  # One retry with the opposite verb, for the genuine races: the variable was
  # created or removed between the earlier listing and now.
  [[ "$verb" == add ]] && alt=set || alt=add
  alt_args=("$alt" --app="$APP_ID" --group="$GROUP"
            --key "$KEY" "${value_args[@]}" --token "$TOKEN")
  [[ "${VAR_SECURE[$i]}" == true ]] && alt_args+=(--secure)

  if alt_out=$(codemagic_repo "${alt_args[@]}" 2>&1); then
    ok "$KEY (via $alt — the app's state had changed since listing)"
    continue
  fi

  # Report both CLI messages: a silent failure here previously looked
  # identical to a success.
  err "failed $KEY"
  printf '%s\n' "$out"     | sed "s|^|      $verb: |" >&2
  printf '%s\n' "$alt_out" | sed "s|^|      $alt: |" >&2
  FAILED=$((FAILED+1))
done

head1 "Result"
LEFT=$(grep -oE '__[A-Z0-9_]+__' "$YAML" | sort -u || true)
if [[ -n "$LEFT" ]]; then
  warn "Placeholders still present:"; printf '%s\n' "$LEFT" | sed 's/^/  /'
fi
((FAILED)) && die "$FAILED credential(s) failed to upload."
ok "Done."
[[ -f "$BACKUP" ]] && info "Revert the yaml with: scripts/$(basename "${BASH_SOURCE[0]}") --restore"
exit 0
