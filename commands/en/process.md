---
name: process
description: >
  Apply code modifications according to an existing analysis.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Apply code modifications by strictly following an existing analysis.

**Parameter:** `$0`
**Additional information:** `$ARGUMENTS`

## Parameter resolution

- If the parameter is a request file (`ask.txt`, `ask.md`), find the corresponding analysis in `.flow/outs/` (same name without extension + `-analysis.md`).
- If the parameter is directly an `*-analysis.md` file, use it and find the corresponding request in `.flow/asks/` (same name without the `-analysis` suffix, in `.txt` or `.md` format).

## Prerequisite

The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

## Behavior

1. Read the corresponding analysis.
2. Apply the code modifications described in the analysis.
3. Respect the **norms and standards** of the existing code in the project.
4. Follow the **best practices** defined in `.flow/docs/best-practices.md` if the file exists.

5. Display to the user the following command suggestion:
   - Line 1: `To launch validation:`
   - Line 2: `/flow:validate <path>`
   - `<path>` is the same parameter received by the command.

## Rules

- **Modify code** by strictly following the analysis.
- **Do not make decisions** outside the scope of the analysis.
