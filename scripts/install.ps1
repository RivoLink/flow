param(
    [switch]$Claude,
    [switch]$Codex,
    [switch]$Gemini,
    [switch]$User,
    [switch]$Project,
    [switch]$Fr,
    [switch]$En,
    [switch]$AsCommand,
    [switch]$AsSkill,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/RivoLink/flow/main"

$CommandFiles = @(
    "analysis.md"
    "asking.md"
    "best-practices.md"
    "help.md"
    "init.md"
    "process.md"
    "re-process.md"
    "review.md"
    "validate.md"
)

function Show-Usage {
    Write-Host @"
Usage: install.ps1 [options]

Options:
  -Claude          Install for Claude Code
  -Codex           Install for Codex CLI
  -Gemini          Install for Gemini CLI
  -User            Install at user level (~/)
  -Project         Install at project level (./) [default]
  -Fr              Use French .md files
  -En              Use English .md files [default]
  -AsCommand       Install as individual commands (Claude only)
  -AsSkill         Install as a single skill file [default]
  -Help            Show this help message
"@
}

function Exit-WithError {
    param([string]$Message)
    Write-Error $Message
    exit 1
}

if ($Help) {
    Show-Usage
    exit 0
}

$harnessList = @()
if ($Claude) { $harnessList += "claude" }
if ($Codex)  { $harnessList += "codex" }
if ($Gemini) { $harnessList += "gemini" }

if ($harnessList.Count -gt 1) {
    Exit-WithError "Cannot combine multiple harness flags: $($harnessList -join ', ')."
}

$harness = if ($harnessList.Count -eq 1) { $harnessList[0] } else { "" }

if ($User -and $Project) {
    Exit-WithError "Cannot combine -User with -Project."
}
$scope = if ($User) { "user" } else { "project" }

if ($Fr -and $En) {
    Exit-WithError "Cannot combine -Fr with -En."
}
$lang = if ($Fr) { "fr" } else { "en" }

if ($AsCommand -and $AsSkill) {
    Exit-WithError "Cannot combine -AsCommand with -AsSkill."
}
$mode = if ($AsCommand) { "command" } else { "skill" }

$prompted = $false
if ($harness -eq "") {
    Write-Host "Select a harness:"
    Write-Host "  1) claude"
    Write-Host "  2) codex"
    Write-Host "  3) gemini"
    $choice = Read-Host "Choice [1-3]"
    switch ($choice) {
        { $_ -in "1", "claude" }  { $harness = "claude" }
        { $_ -in "2", "codex" }   { $harness = "codex" }
        { $_ -in "3", "gemini" }  { $harness = "gemini" }
        default { Exit-WithError "Invalid choice: $choice" }
    }
    $prompted = $true
}

if ($mode -eq "command" -and $harness -eq "codex") {
    Exit-WithError @"
--as-command is not supported for Codex.
Codex prompts are deprecated and have naming limitations.
Use --as-skill instead (default).
"@
}

if ($mode -eq "command" -and $harness -eq "gemini") {
    Exit-WithError @"
--as-command is not supported for Gemini.
Gemini commands use .toml format, incompatible with .md files.
Use --as-skill instead (default).
"@
}

if ($scope -eq "user") {
    $root = Join-Path $HOME ".$harness"
} else {
    $root = ".$harness"
}

if ($mode -eq "skill") {
    $targetDir = Join-Path (Join-Path $root "skills") "flow"
} else {
    $targetDir = Join-Path (Join-Path $root "commands") "flow"
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

function Download-File {
    param(
        [string]$Url,
        [string]$Dest
    )
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
    } catch {
        Exit-WithError "Failed to download: $Url"
    }
}

$downloaded = 0

if ($mode -eq "skill") {
    if ($lang -eq "fr") {
        $srcUrl = "$BaseUrl/SKILL.fr.md"
    } else {
        $srcUrl = "$BaseUrl/SKILL.md"
    }
    Download-File -Url $srcUrl -Dest (Join-Path $targetDir "SKILL.md")
    $downloaded = 1
} else {
    foreach ($file in $CommandFiles) {
        $srcUrl = "$BaseUrl/commands/$lang/$file"
        Download-File -Url $srcUrl -Dest (Join-Path $targetDir $file)
        $downloaded++
    }
}

if ($prompted) { Write-Host "" }
Write-Host "Flow installed successfully!"
Write-Host "  Harness: $harness"
Write-Host "  Mode:    $mode"
Write-Host "  Scope:   $scope"
Write-Host "  Lang:    $lang"
Write-Host "  Files:   $downloaded"
Write-Host "  Target:  $targetDir"
Write-Host "  Source:  https://github.com/RivoLink/flow"
