---
name: re-process
description: >
  Process the corrections identified in the validation report of an analysis.
  Modify code to resolve the report points without performing additional analysis.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Process the corrections identified in the validation report.

**Parameter:** `$0`
**Additional information:** `$ARGUMENTS`

## Parameter resolution

- If the parameter is a request file (`ask.txt`, `ask.md`), find the corresponding analysis in `.flow/outs/` (same name without extension + `-analysis.md`).
- If the parameter is directly an `*-analysis.md` file, use it and find the corresponding request in `.flow/asks/` (same name without the `-analysis` suffix, in `.txt` or `.md` format).

## Prerequisites

- The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis.
- The analysis must contain a **"Validation Report"** section. If it is missing, **ask the user** to first run a validation.
- Do not continue if any of these prerequisites are not met.

## Behavior

1. Read the **"Validation Report"** section in the analysis.
2. Process each point/note identified in the report.
3. Apply the necessary code corrections.
4. Respect the **norms and standards** of the existing code in the project.
5. Follow the **best practices** defined in `.flow/docs/best-practices.md` if the file exists.

6. Display to the user the following command suggestion:
   - Line 1: `To rerun validation:`
   - Line 2: `/flow:validate <path>`
   - `<path>` is the same parameter received by the command.

## Rules

- **Modify code** only to address the points in the validation report.
- **Do not perform any analysis.** Do not make decisions outside the scope of the report.
- **Do not modify the "Validation Report" section.** Updating it is the role of the validate command.
