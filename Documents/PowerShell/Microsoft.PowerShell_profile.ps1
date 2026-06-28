# PowerShell profile — managed by chezmoi
# On Windows this maps to:
#   %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# Edit the source with `chezmoi edit $PROFILE`, then `chezmoi apply`.

# --- PSReadLine: better command-line editing & history ----------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- Aliases ----------------------------------------------------------------
Set-Alias ll Get-ChildItem
Set-Alias which Get-Command

function gs  { git status @args }
function gd  { git diff @args }
function gl  { git log --oneline --graph --decorate -20 @args }

# --- Prompt: show git branch ------------------------------------------------
function prompt {
    $branch = ""
    try {
        $b = git rev-parse --abbrev-ref HEAD 2>$null
        if ($b) { $branch = " ($b)" }
    } catch { }
    Write-Host "$($executionContext.SessionState.Path.CurrentLocation)" -NoNewline -ForegroundColor Cyan
    Write-Host $branch -NoNewline -ForegroundColor Yellow
    return " $('>' * ($nestedPromptLevel + 1)) "
}

# --- Local, untracked overrides ---------------------------------------------
$localProfile = Join-Path (Split-Path $PROFILE) "profile.local.ps1"
if (Test-Path $localProfile) { . $localProfile }
