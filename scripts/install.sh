#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/RivoLink/flow/main"

COMMAND_FILES=(
    analysis.md
    asking.md
    best-practices.md
    help.md
    init.md
    process.md
    re-process.md
    review.md
    validate.md
)

harness=""
scope="project"
lang="en"
mode="skill"

scope_set=0
lang_set=0
mode_set=0

usage() {
    cat <<'EOF'
Usage: install.sh [options]

Options:
  --claude          Install for Claude Code
  --codex           Install for Codex CLI
  --gemini          Install for Gemini CLI
  --user            Install at user level (~/)
  --project         Install at project level (./) [default]
  --fr              Use French .md files
  --en              Use English .md files [default]
  --as-command      Install as individual commands (Claude only)
  --as-skill        Install as a single skill file [default]
  -h, --help        Show this help message
EOF
}

error() {
    echo "Error: $1" >&2
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --claude)
            [[ -n "$harness" ]] && error "Cannot combine --$harness with --claude."
            harness="claude"
            ;;
        --codex)
            [[ -n "$harness" ]] && error "Cannot combine --$harness with --codex."
            harness="codex"
            ;;
        --gemini)
            [[ -n "$harness" ]] && error "Cannot combine --$harness with --gemini."
            harness="gemini"
            ;;
        --user)
            [[ "$scope_set" -eq 1 && "$scope" != "user" ]] && error "Cannot combine --user with --project."
            scope="user"
            scope_set=1
            ;;
        --project)
            [[ "$scope_set" -eq 1 && "$scope" != "project" ]] && error "Cannot combine --project with --user."
            scope="project"
            scope_set=1
            ;;
        --fr)
            [[ "$lang_set" -eq 1 && "$lang" != "fr" ]] && error "Cannot combine --fr with --en."
            lang="fr"
            lang_set=1
            ;;
        --en)
            [[ "$lang_set" -eq 1 && "$lang" != "en" ]] && error "Cannot combine --en with --fr."
            lang="en"
            lang_set=1
            ;;
        --as-command)
            [[ "$mode_set" -eq 1 && "$mode" != "command" ]] && error "Cannot combine --as-command with --as-skill."
            mode="command"
            mode_set=1
            ;;
        --as-skill)
            [[ "$mode_set" -eq 1 && "$mode" != "skill" ]] && error "Cannot combine --as-skill with --as-command."
            mode="skill"
            mode_set=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
    shift
done

if ! command -v curl &>/dev/null; then
    error "curl is required but not found. Please install curl and try again."
fi

prompted=0
if [[ -z "$harness" ]]; then
    echo "Select a harness:"
    echo "  1) claude"
    echo "  2) codex"
    echo "  3) gemini"
    read -rp "Choice [1-3]: " choice
    case "$choice" in
        1|claude)  harness="claude" ;;
        2|codex)   harness="codex" ;;
        3|gemini)  harness="gemini" ;;
        *) error "Invalid choice: $choice" ;;
    esac
    prompted=1
fi

if [[ "$mode" == "command" && "$harness" == "codex" ]]; then
    error "--as-command is not supported for Codex.
Codex prompts are deprecated and have naming limitations.
Use --as-skill instead (default)."
fi

if [[ "$mode" == "command" && "$harness" == "gemini" ]]; then
    error "--as-command is not supported for Gemini.
Gemini commands use .toml format, incompatible with .md files.
Use --as-skill instead (default)."
fi

if [[ "$scope" == "user" ]]; then
    root="$HOME/.$harness"
else
    root=".$harness"
fi

if [[ "$mode" == "skill" ]]; then
    target_dir="$root/skills/flow"
else
    target_dir="$root/commands/flow"
fi

mkdir -p "$target_dir"

download() {
    local url="$1"
    local dest="$2"
    if ! curl -fsSL "$url" -o "$dest"; then
        error "Failed to download: $url"
    fi
}

downloaded=0

if [[ "$mode" == "skill" ]]; then
    if [[ "$lang" == "fr" ]]; then
        src_url="$BASE_URL/SKILL.fr.md"
    else
        src_url="$BASE_URL/SKILL.md"
    fi
    download "$src_url" "$target_dir/SKILL.md"
    downloaded=1
else
    for file in "${COMMAND_FILES[@]}"; do
        src_url="$BASE_URL/commands/$lang/$file"
        download "$src_url" "$target_dir/$file"
        downloaded=$((downloaded + 1))
    done
fi

[[ "$prompted" -eq 1 ]] && echo ""
echo "Flow installed successfully!"
echo "  Harness: $harness"
echo "  Mode:    $mode"
echo "  Scope:   $scope"
echo "  Lang:    $lang"
echo "  Files:   $downloaded"
echo "  Target:  $target_dir"
echo "  Source:  https://github.com/RivoLink/flow"
