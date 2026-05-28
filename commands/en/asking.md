---
name: asking
description: >
  Create a request file (ask) from a user prompt in
  .flow/asks/ and suggest launching the analysis.
argument-hint: <prompt>
disable-model-invocation: true
---

Create a request file from the user prompt.

**Prompt:** `$ARGUMENTS`

## Behavior

1. If `$ARGUMENTS` is empty, **interactively ask** the user to provide a prompt. Do not continue until a non-empty prompt is obtained.
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
   - Line 4: `/flow:analysis .flow/asks/<slug>.txt`

## Rules

- **Never modify source code.** This command only produces a request file.
- **Do not trigger the analysis automatically.** Only suggest it.
- **Do not add a header** to the file (no date, no author, no title).
- **Do not alter the meaning of the prompt** during reformulation.
