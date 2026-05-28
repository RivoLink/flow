---
name: validate
description: >
  Perform a critical review of code modifications, without modifying source code.
  Verify consistency with the request and analysis, best practices, and regressions.
  Produce a validation report (Valid/Not valid) in the analysis.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Perform a critical review of code modifications without modifying source code.

**Parameter:** `$0`
**Additional information:** `$ARGUMENTS`

## Parameter resolution

- If the parameter is a request file (`ask.txt`, `ask.md`), find the corresponding analysis in `.flow/outs/` (same name without extension + `-analysis.md`).
- If the parameter is directly an `*-analysis.md` file, use it and find the corresponding request in `.flow/asks/` (same name without the `-analysis` suffix, in `.txt` or `.md` format).

## Prerequisite

The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

## Behavior

1. Perform a critical review of the code modifications made.
2. Verify the **consistency** between the modifications, the request, and the analysis.
3. Verify that the modifications respect the **best practices** defined in `.flow/docs/best-practices.md` if the file exists.
4. Check for **potential regressions** introduced by the modifications.
5. Update the analysis by adding (or updating) a **"Validation Report"** section containing:
   - The validation status: **Valid** or **Not valid**.
   - If **Not valid**: detailed notes, remarks, and questions, sufficiently documented to be actionable.
6. If a "Validation Report" section already exists:
   - Check whether previously raised points have been addressed.
   - Remove resolved points.
   - Keep unresolved points in the updated version of the section.

7. Display to the user the following command suggestion based on this logic:
   - If the status is **Valid** → do not suggest any command. Display:
     `Task validated. The workflow is complete.`
   - If the status is **Not valid**, evaluate the nature of the issues:
     - **Minor corrections** (style errors, small bugs, simple omissions, naming adjustments, formatting) → display:
       - Line 1: `To launch re-processing:`
       - Line 2: `/flow:re-process <path>`
     - **Major issues** (incorrect logic, inconsistency with the request, technical approach to be revised, functional regression) → display:
       - Line 1: `To rerun the analysis:`
       - Line 2: `/flow:analysis <path>`
   - `<path>` is the same parameter received by the command.

## Rules

- **Never modify source code.** This command only produces a validation report.
