---
name: flow
description: >
  Set of commands to structure and drive the cycle of analysis, review, implementation
  and validation of a request or task. Available commands: help, init, best-practices,
  asking, analysis, review, process, validate, re-process.
argument-hint: <command> [arguments]
disable-model-invocation: true
---

# Flow

Execute command **$0**.

Identify the command among the sections below and follow its instructions. Additional arguments are: `$ARGUMENTS`.

## Parameter resolution

Applicable to commands that accept `<path/to/ask.txt|ask-analysis.md>`:

- If the parameter is a request file (`ask.txt`, `ask.md`), find the corresponding analysis in `.flow/outs/` (same name without extension + `-analysis.md`).
- If the parameter is directly an `*-analysis.md` file, use it and find the corresponding request in `.flow/asks/` (same name without the `-analysis` suffix, in `.txt` or `.md` format).

---

## Command: help

Display the following message to the user:

**Flow** — Available commands:

1. **flow init** — Initialize the project working environment.
2. **flow best-practices** `<comment>` — Add best practices.
3. **flow asking** `<prompt>` — Create a request file from a prompt.
4. **flow analysis** `<path/to/ask.txt>` `<comment>` — Analyze a request without modifying code.
5. **flow review** `<path>` `<comment>` — Critical review of the analysis.
6. **flow process** `<path>` `<comment>` — Apply code modifications.
7. **flow validate** `<path>` `<comment>` — Critical review of code modifications.
8. **flow re-process** `<path>` `<comment>` — Fix code according to the validation report.

**Syntax:** `/flow <command> [arguments]`

**Recommended workflow:**

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Loop 1**: `analysis` and `review` until the analysis is consistent.
- **Loop 2**: `validate` and `re-process` until the status is "Valid".

---

## Command: init

Initialize the project working environment.

1. Check if the `.gitignore` file exists at the project root. If not, create it.
2. Check if `.gitignore` contains the following block. If missing (in whole or in part), add or complete it:
   ```
   # flow
   /.flow
   ```
3. Create the following directory structure (skip directories/files that already exist):
   ```
   {project-dir}
   └── .flow
       ├── asks/
       ├── docs/
       │   └── best-practices.md
       ├── imgs/
       ├── outs/
       └── note.txt
   ```
4. Confirm the actions taken to the user.

---

## Command: best-practices

Add best practices to the project reference file.

**Arguments:** `<comment>` — Description of the best practices to add.

1. Open `.flow/docs/best-practices.md`. If the file does not exist, create it with a title `# Best Practices`.
2. Add the best practices described in `<comment>`, worded concisely.
3. Organize additions by thematic sections if applicable.
4. Confirm the added practices to the user.

---

## Command: asking

Create a request file from the user prompt.

**Arguments:**
- `<prompt>` — Free-form prompt describing the request.

**Output file:** `.flow/asks/<slug>.txt`.

**Behavior:**

1. If the prompt is empty, **interactively ask** the user to provide a prompt. Do not continue until a non-empty prompt is obtained.
2. **Reformulate** the prompt for clarity while strictly preserving the original meaning: fix syntax, clarify ambiguous phrasing, remove typos. Do not add information absent from the original.
3. Generate a **kebab-case** filename derived from the **reformulated prompt** (slug):
   - Keep only `[a-zA-Z0-9]` characters, convert to lowercase.
   - Replace any other character (spaces, punctuation, accents, symbols) with `-`.
   - Merge consecutive hyphens, remove leading/trailing hyphens.
   - **Intelligently shorten** the slug to keep it **expressive** while not exceeding **30 characters** (limit applied to the slug alone, before any suffix):
     - Remove stop words (articles, prepositions, conjunctions) to keep only meaningful words. Examples of stop words: le, la, les, de, du, des, un, une, au, aux, en, et, ou, pour, dans, sur, avec, par, the, an, of, to, in, on, for, and, or, with. This list is indicative — adapt it according to context and prompt language.
     - If the slug still exceeds the limit, shorten by keeping the most significant keywords (technical terms, proper nouns, action verbs) to preserve the overall meaning of the prompt. Favor meaningful keywords across the entire prompt length, not just those at the beginning.
     - Always cut at a **word boundary** (never in the middle of a word).
     - Re-trim trailing hyphens after shortening.
4. Target: `.flow/asks/<slug>.txt`.
5. **Name collision**: if `<slug>.txt` already exists, use incremental **numeric indexing** (`<slug>-1.txt`, `<slug>-2.txt`, ...) until a free name is found. No overwriting.
6. Create the `.flow/asks/` directory if it does not exist.
7. Write the **reformulated prompt** to the file (plain text, no header, no metadata). The text must be **well formatted** according to the following rules:
   - Limit each line to approximately **90-100 characters**. Lines should remain long enough to be readable but must not exceed this limit.
   - Insert line breaks **intelligently**, preferably cutting after a comma, period, semicolon, colon, or other punctuation mark.
   - Add **blank lines** between distinct ideas to space out the text.
   - Use **bullet points** (`- `) when the content contains multiple points or enumerated items, to structure the text.
   - Do not write a continuous block of text on a single line.
8. Display the result to the user formatted as follows, respecting line breaks:
   - Line 1: `File created:` followed by the path `.flow/asks/<slug>.txt`
   - Line 2: empty
   - Line 3: `To launch the analysis:`
   - Line 4: `/flow analysis .flow/asks/<slug>.txt`

**Rules:**
- **Never modify source code.** This command only produces a request file.
- **Do not trigger the analysis automatically.** Only suggest it.
- **Do not add a header** to the file (no date, no author, no title).
- **Do not alter the meaning of the prompt** during reformulation.

---

## Command: analysis

Analyze a request or task without modifying source code.

**Arguments:**
- `<path/to/ask.txt>` — Path to the request file (normally in `.flow/asks/`, usually `.txt`, can also be `.md`).
- `<comment>` — Additional information (optional).

**Output file:** `.flow/outs/` with the same name as the source (without extension), suffixed by `-analysis.md`.
- `.flow/asks/feature.txt` → `.flow/outs/feature-analysis.md`
- `.flow/asks/feature.md` → `.flow/outs/feature-analysis.md`

**Behavior:**

1. Read and analyze the request described in `<path/to/ask.txt>`.
2. Take into account additional information provided in `<comment>`.
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
     - Line 2: `/flow review <path>`
   - If the file existed and contained a "Review Report" with remaining **unanswered questions** → do not suggest any command. Display:
     - Line 1: `Some review report questions have not yet been answered.`
     - Line 2: `Answer the questions in the file, then rerun:`
     - Line 3: `/flow analysis <path>`
   - Otherwise (subsequent analysis with no pending questions) → display:
     - Line 1: `To rerun a review:`
     - Line 2: `/flow review <path>`
     - Line 3: empty
     - Line 4: `To launch processing:`
     - Line 5: `/flow process <path>`
   - `<path>` is the same parameter received by the command.

**Rules:**
- **Never modify source code.** This command only produces an analysis.

---

## Command: review

Perform a critical review of an existing analysis without modifying source code.

**Arguments:**
- `<path/to/ask.txt|ask-analysis.md>` — Path to the request file or directly to the analysis.
- `<comment>` — Additional information (optional).

**Prerequisite:** The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

**Behavior:**

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
   - Line 2: `/flow analysis <path>`
   - `<path>` is the same parameter received by the command.

**Rules:**
- **Never modify source code.** This command only produces a review.

---

## Command: process

Apply code modifications by strictly following an existing analysis.

**Arguments:**
- `<path/to/ask.txt|ask-analysis.md>` — Path to the request file or directly to the analysis.
- `<comment>` — Additional information (optional).

**Prerequisite:** The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

**Behavior:**

1. Read the corresponding analysis.
2. Apply the code modifications described in the analysis.
3. Respect the **norms and standards** of the existing code in the project.
4. Follow the **best practices** defined in `.flow/docs/best-practices.md` if the file exists.

5. Display to the user the following command suggestion:
   - Line 1: `To launch validation:`
   - Line 2: `/flow validate <path>`
   - `<path>` is the same parameter received by the command.

**Rules:**
- **Modify code** by strictly following the analysis.
- **Do not make decisions** outside the scope of the analysis.

---

## Command: validate

Perform a critical review of code modifications without modifying source code.

**Arguments:**
- `<path/to/ask.txt|ask-analysis.md>` — Path to the request file or directly to the analysis.
- `<comment>` — Additional information (optional).

**Prerequisite:** The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis. Do not continue without the analysis.

**Behavior:**

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
       - Line 2: `/flow re-process <path>`
     - **Major issues** (incorrect logic, inconsistency with the request, technical approach to be revised, functional regression) → display:
       - Line 1: `To rerun the analysis:`
       - Line 2: `/flow analysis <path>`
   - `<path>` is the same parameter received by the command.

**Rules:**
- **Never modify source code.** This command only produces a validation report.

---

## Command: re-process

Process the corrections identified in the validation report.

**Arguments:**
- `<path/to/ask.txt|ask-analysis.md>` — Path to the request file or directly to the analysis.
- `<comment>` — Additional information (optional).

**Prerequisites:**
- The corresponding analysis must exist in `.flow/outs/`. If it is missing, **ask the user** to first produce an analysis.
- The analysis must contain a **"Validation Report"** section. If it is missing, **ask the user** to first run a validation.
- Do not continue if any of these prerequisites are not met.

**Behavior:**

1. Read the **"Validation Report"** section in the analysis.
2. Process each point/note identified in the report.
3. Apply the necessary code corrections.
4. Respect the **norms and standards** of the existing code in the project.
5. Follow the **best practices** defined in `.flow/docs/best-practices.md` if the file exists.

6. Display to the user the following command suggestion:
   - Line 1: `To rerun validation:`
   - Line 2: `/flow validate <path>`
   - `<path>` is the same parameter received by the command.

**Rules:**
- **Modify code** only to address the points in the validation report.
- **Do not perform any analysis.** Do not make decisions outside the scope of the report.
- **Do not modify the "Validation Report" section.** Updating it is the role of the validate command.
