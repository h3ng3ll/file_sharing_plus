#!/bin/bash



SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# scripts/ -> project root
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CURRENT_DIR_NAME="$(basename "$PROJECT_DIR")"

CURRENT_DIR_NAME="$(basename "$PROJECT_DIR")"
echo "CURRENT_DIR_NAME $CURRENT_DIR_NAME"



FORCE=false

for arg in "$@"; do
  if [[ "$arg" == "--force" || "$arg" == "-f" ]]; then
    FORCE=true
  elif [[ -z "$ZIP_NUMBER" ]]; then
    # First non-flag argument is the ZIP number, unless already set in the env.
    ZIP_NUMBER="$arg"
  fi
done

if [ -z "$ZIP_NUMBER" ]; then
  echo "Error: ZIP_NUMBER is not set (pass it as an argument, e.g. \`$0 1\`, or export ZIP_NUMBER)"
  exit 1
fi

# Load environment variables from .env file (relative to script location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

API_KEY="$(security find-generic-password -a "$USER" -s GEMINI_TOKEN -w)"

# Validate required variables
if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY is not set in $ENV_FILE"
  exit 1
fi

outputFolder="./${ZIP_NUMBER}"
screenshotsFolder="../screenshots/macos"
iconPattern="icon_512x512"
launcherIcon="../assets/flutter_launcher_icons/android/ic_launcher.png"

mkdir -p "$outputFolder"
cp "$screenshotsFolder"/* "$outputFolder"/

# Look for an existing icon AFTER copying screenshots, so a stale icon
# carried over from the screenshots folder gets cleared on --force.
existingIcon=$(find "$outputFolder" -maxdepth 1 -type f -name "${iconPattern}*" | head -n 1)

if [ -n "$existingIcon" ] && [ "$FORCE" = false ]; then
  echo "Icon already exists: $existingIcon"
  echo "Skipping generation. Use --force to regenerate."
else
  if [ -n "$existingIcon" ] && [ "$FORCE" = true ]; then
    echo "Force flag set — removing existing icon: $existingIcon"
    rm -f "$existingIcon"
  fi

  echo "Generating icon..."

  # Precompiled dart script
  app_icon_gen \
    --api-key "$API_KEY" \
    -s "$outputFolder/" \
    --output "$outputFolder/" \
    --sizes 512 \
    --auto-limit
fi

# Copy data

cp "$outputFolder/$iconPattern.png" "$launcherIcon"

