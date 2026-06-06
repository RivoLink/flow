# Flow

Lightweight skill for AI automation **flow**s.

Set of commands to structure and drive the cycle of analysis, review, implementation and validation of a request or task.

## Installation

**Bash**

```bash
curl -fsSL https://github.com/RivoLink/flow/raw/main/scripts/install.sh | bash
```

**PowerShell**

```powershell
irm https://github.com/RivoLink/flow/raw/main/scripts/install.ps1 | iex
```

The script will prompt interactively for the harness (Claude, Codex, or Gemini).

### Advanced usage

To pass options, download the script first then run it with arguments.

**Bash**

```bash
curl -fsSL https://github.com/RivoLink/flow/raw/main/scripts/install.sh -o flow.sh
bash flow.sh --claude --user --as-command --fr
```

**PowerShell**

```powershell
irm https://github.com/RivoLink/flow/raw/main/scripts/install.ps1 -OutFile flow.ps1
./flow.ps1 -Claude -User -AsCommand -Fr
```

### Options

| Flag | Description | Default |
|---|---|---|
| `claude` \| `codex` \| `gemini` | Target harness | Interactive prompt |
| `user` \| `project` | Installation scope | `project` |
| `as-skill` \| `as-command` | Installation mode | `as-skill` |
| `en` \| `fr` | Language for .md files | `en` |

## Features

| Command | Description |
|---|---|
| `flow help` | Display available commands and workflow |
| `flow init` | Initialize the project working environment |
| `flow best-practices` | Add best practices to the project reference |
| `flow asking` | Create a request file from a prompt |
| `flow analysis` | Analyze a request without modifying code |
| `flow review` | Critical review of the analysis |
| `flow process` | Apply code modifications |
| `flow validate` | Critical review of code modifications |
| `flow re-process` | Fix code according to the validation report |

## Workflow

The cycle starts with `asking` and ends when `validate` returns `Valid`.

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Loop 1**: `analysis` and `review` until the analysis is consistent.
- **Loop 2**: `validate` and `re-process` until the status is "Valid".

## How it works

Flow drives a task through a fixed cycle. Each step reads and writes files
under `.flow/`, so progress is always inspectable on disk.

**Artifacts**

- `.flow/asks/<slug>.txt` : the reformulated request.
- `.flow/outs/<slug>-analysis.md` : the analysis. A `Review Report` section
  and then a `Validation Report` section are appended in place over the cycle.
- `.flow/docs/best-practices.md` : project conventions read by `process` and
  `re-process`.

**Two feedback loops**

- **Loop 1** : `analysis` ↔ `review`. Iterate until the analysis is coherent
  and every review question is answered.
- **Loop 2** : `validate` ↔ `re-process`. Iterate until the validation status
  is `Valid`.

**Exit**

The cycle ends when `validate` returns `Valid`.

## Commands

Workflow commands first, then setup and meta.

#### `flow asking <prompt>`

- **Purpose** : Turn a free-form prompt into a clean request file.
- **Input** : Prompt text.
- **Output** : `.flow/asks/<slug>.txt`.

#### `flow analysis <path>`

- **Purpose** : Produce a detailed analysis of the request. No code change.
- **Input** : `.flow/asks/<slug>.txt`.
- **Output** : `.flow/outs/<slug>-analysis.md`.

#### `flow review <path>`

- **Purpose** : Critique the analysis for inconsistencies, questions and risks.
- **Input** : Analysis path.
- **Output** : `Review Report` section appended to the analysis.

#### `flow process <path>`

- **Purpose** : Apply code modifications by following the analysis.
- **Input** : Analysis path.
- **Output** : Source code modifications.

#### `flow validate <path>`

- **Purpose** : Critique the code modifications against the analysis.
- **Input** : Analysis path.
- **Output** : `Validation Report` section appended to the analysis,
  with status `Valid` or `Not valid`.

#### `flow re-process <path>`

- **Purpose** : Fix the points raised by the last validation report.
- **Input** : Analysis path with a `Validation Report`.
- **Output** : Source code fixes.

#### `flow init`

- **Purpose** : Initialize the project working environment.
- **Input** : None.
- **Output** : `.gitignore` entry and the `.flow/` directory tree.

#### `flow best-practices <comment>`

- **Purpose** : Record project conventions used by `process` and `re-process`.
- **Input** : Comment text.
- **Output** : Appended to `.flow/docs/best-practices.md`.

#### `flow help`

- **Purpose** : Print the command list and the workflow diagram.
- **Input** : None.
- **Output** : Console message.

## Languages

Flow is available in English (`en`, default) and French (`fr`).

## License

[MIT](LICENSE)
