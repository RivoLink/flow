---
name: review
description: >
  Perform a critical review of the analysis associated with a request, without modifying source code.
  Detect inconsistencies, potential regressions, and ask questions.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Perform a critical review of an existing analysis without modifying source code.

**Parameter:** `$0`
**Additional information:** `$ARGUMENTS`

## Parameter resolution

- If the parameter is a request file (`ask.txt`, `ask.md`), find the corresponding analysis in `.flow/outs/` (same name without extension + `-analysis.md`).
- If the parameter is directly an `*-analysis.md` file, use it and find the corresponding request in `.flow/asks/` (same name without the `-analysis` suffix, in `.txt` or `.md` format).

## Prerequisite

The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

## Behavior

1. Read the original request and the corresponding analysis.
2. Detect **inconsistencies** between the request and the analysis.
3. Detect **internal inconsistencies** within the analysis itself.
4. Detect **potential regressions** if applicable.
5. Ask **questions** if areas of uncertainty remain.
6. For each question, suggest **2 to 3 possible answers** to guide the user in their choice. The user remains free to choose a suggestion or to write their own answer in the "Answer:" field.
7. Among the suggestions, clearly indicate the **recommended** one by adding the mention `(recommended)`. Format:

   **Q1: [Question title]**
   - a) [Suggestion 1]
   - b) [Suggestion 2] **(recommended)**
   - c) [Suggestion 3]
   **Answer:**

8. Update the `*-analysis.md` file to add a **"Review Report"** section containing the inconsistencies and questions identified. Inconsistencies remain in free text. If **no inconsistency**, no question, and no potential regression is detected, still add the section with a positive status:
   ```
   ## Review Report

   No inconsistency detected. The analysis is consistent with the request.
   ```
9. Display to the user the following command suggestion:
   - Line 1: `To rerun the analysis:`
   - Line 2: `/flow:analysis <path>`
   - `<path>` is the same parameter received by the command.

## Rules

- **Never modify source code.** This command only produces a review.
