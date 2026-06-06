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

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Loop 1**: `analysis` and `review` until the analysis is consistent.
- **Loop 2**: `validate` and `re-process` until the status is "Valid".

## Languages

Flow is available in English (`en`, default) and French (`fr`).

## License

[MIT](LICENSE)
