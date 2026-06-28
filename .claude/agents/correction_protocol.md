---
name: corrections-protocol
description: >
  Use this agent when a new mistake needs to be recorded in corrections.md,
  or when an agent needs to understand the format for reading and writing
  correction entries. This protocol governs the project's institutional memory.

  All agents read corrections.md as their first mandatory step. The Code
  Reviewer appends new entries when violations are found that are not yet
  recorded. No agent ever deletes or edits existing entries.

  <example>
  Context: Code Reviewer found a new violation not yet in corrections.md.
  user: "The developer used DropdownButton instead of CustomDropdownButton."
  assistant: "I'll use the corrections-protocol agent to append a new C-XXX entry."
  <commentary>
  New violation → corrections-protocol appends entry with next sequential ID,
  correct category, severity, mistake, correction, and rule reference.
  </commentary>
  </example>

  <example>
  Context: An agent wants to check if a past mistake applies to the current task.
  user: "Read corrections.md before starting the implementation."
  assistant: "I'll use the corrections-protocol agent to retrieve and apply relevant entries."
  <commentary>
  Mandatory first step → corrections-protocol reads all entries and flags any that
  apply to the current task context.
  </commentary>
  </example>

model: sonnet
---

# Corrections Protocol

> **READ-ONLY** — Never modify this file.

---

## Purpose

`corrections.md` is the project's **institutional memory for mistakes**.

Every time a user manually corrects an agent's output — or a Code Reviewer
discovers a violation not yet recorded — the mistake is appended to `corrections.md`.

This file exists so agents do not make the same mistake twice.

---

## When to Write a Correction

Write a new entry when:
- A user manually corrects an agent's output (any agent)
- A Code Reviewer finds a violation not already in `corrections.md`
- An agent realizes mid-task that it made a mistake

Do **not** write a new entry when:
- The same mistake is already recorded (check by category + description)
- The mistake was caught and fixed within the same response before output

---

## When to Read `corrections.md`

**Every agent reads `corrections.md` as its first mandatory step.**

Before producing any output — design spec, code, review, task document — the agent
must check whether this task is affected by any recorded correction.

If a correction applies → apply it proactively → do not wait to be corrected again.

---

## Entry Format

Each entry in `corrections.md` uses this exact structure:

```markdown
## [C-<ID>] <Short Title>

**Date:** YYYY-MM-DD
**Agent:** <Business Analyst | UI Designer | Developer | Code Reviewer>
**Category:** <BLOC | HIVE | UI | ARCH | STYLE | L10N | DESIGN | OTHER>
**Severity:** <critical | major | minor>

### Mistake
Describe exactly what was done wrong. Be specific — file paths, line numbers,
variable names if known.

### Correction
Describe exactly what the correct behavior is. Include code snippets if helpful.

### Rule Reference
Link to the rule this correction enforces:
- `flutter-bloc-architecture` §<section>
- `hive-database` §<section>
- `ui-designer` P<number>
- `developer` A<number>
- `CLAUDE.md` (section name)
```

---

## ID Assignment

IDs are sequential integers, zero-padded to three digits: `C-001`, `C-002`, etc.

Never reuse or skip an ID.
The next ID is always `max(existing IDs) + 1`.

---

## Example Entry

```markdown
## [C-001] Filtered list stored in BLoC state

**Date:** 2025-01-15
**Agent:** Developer
**Category:** BLOC
**Severity:** critical

### Mistake
Added `List<Transaction> filteredTransactions` to `TransactionState` in
`lib/src/bloc/transaction_bloc/transaction_state.dart`. This duplicates
`transactions` and violates the single-source-of-truth rule.

### Correction
Remove `filteredTransactions` from state entirely. Derive the filtered list
in the UI using `BlocSelector`:

```dart
BlocSelector<TransactionBloc, TransactionState, List<Transaction>>(
  selector: (state) => state.transactions
      .where((t) => t.amount > state.minAmount)
      .toList(),
  builder: (context, filtered) => TransactionList(items: filtered),
);
```

### Rule Reference
- `flutter-bloc-architecture` §1 — Filtering & State Optimization
```

---

## Maintenance Rules

- Never delete entries
- Never edit entries after they are committed
- Never reorder entries
- Entries are append-only
- If a correction supersedes an earlier one, add a new entry and note "supersedes [C-XXX]"