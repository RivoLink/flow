---
name: analysis
description: >
  Analyze a request or task described in an ask file without modifying source code.
  Produce a detailed analysis in .flow/outs/.
argument-hint: <path/to/ask.txt> [comment]
disable-model-invocation: true
---

Analyze a request or task without modifying source code.

**Request file:** `$0`
**Additional information:** `$ARGUMENTS`

## Output file

The result is saved in `.flow/outs/` with the same name as the source (without extension), suffixed by `-analysis.md`.
- `.flow/asks/feature.txt` → `.flow/outs/feature-analysis.md`
- `.flow/asks/feature.md` → `.flow/outs/feature-analysis.md`

## Behavior

1. Read and analyze the request described in the request file.
2. Take into account additional information if provided.
3. If the output file already exists, check if it contains a **"Review Report"** section. If so:
   - Read each inconsistency and question identified in the review report.
   - Correct the relevant points in the analysis (reformulate, complete, or remove inconsistent parts).
   - Questions from the review report are answered manually by the user. Integrate their answers into the analysis.
   - If questions have not yet been answered, keep them in the "Review Report" section.
   - Once all points are addressed and all questions answered, remove the "Review Report" section from the updated analysis.
4. Explore the project source code to understand the technical context.
5. Produce (or update) a detailed Markdown analysis covering:
   - Understanding of the request
   - Impact on existing code
   - Recommended technical approach
   - Points of attention
6. Save the result to the output file.
7. Display to the user the following command suggestion based on this logic:
   - If this is the **first analysis** (the output file did not exist before this execution) → display:
     - Line 1: `To launch the review:`
     - Line 2: `/flow:review <path>`
   - If the file existed and contained a "Review Report" with remaining **unanswered questions** → do not suggest any command. Display:
     - Line 1: `Some review report questions have not yet been answered.`
     - Line 2: `Answer the questions in the file, then rerun:`
     - Line 3: `/flow:analysis <path>`
   - Otherwise (subsequent analysis with no pending questions) → display:
     - Line 1: `To rerun a review:`
     - Line 2: `/flow:review <path>`
     - Line 3: empty
     - Line 4: `To launch processing:`
     - Line 5: `/flow:process <path>`
   - `<path>` is the same parameter received by the command.

## Rules

- **Never modify source code.** This command only produces an analysis.
