---
name: help
description: >
  Displays the list of flow commands with a brief description and the recommended workflow.
disable-model-invocation: true
---

Display the following message to the user:

**Flow** — Available commands:

1. **flow:init** — Initialize the project working environment.
2. **flow:best-practices** `<comment>` — Add best practices.
3. **flow:asking** `<prompt>` — Create a request file from a prompt.
4. **flow:analysis** `<path/to/ask.txt>` `<comment>` — Analyze a request without modifying code.
5. **flow:review** `<path>` `<comment>` — Critical review of the analysis.
6. **flow:process** `<path>` `<comment>` — Apply code modifications.
7. **flow:validate** `<path>` `<comment>` — Critical review of code modifications.
8. **flow:re-process** `<path>` `<comment>` — Fix code according to the validation report.

**Syntax:** `/flow:<command> [arguments]`

**Recommended workflow:**

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Loop 1**: `analysis` and `review` until the analysis is consistent.
- **Loop 2**: `validate` and `re-process` until the status is "Valid".
