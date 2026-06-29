# PowerShell profile — managed by chezmoi
# On Windows this maps to:
#   %USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# Edit the source with `chezmoi edit $PROFILE`, then `chezmoi apply`.

# --- XDG config home --------------------------------------------------------
# Make Neovim (and other XDG-aware tools) read ~/.config on Windows, so the
# same dot_config/nvim source works on macOS and Windows.
$env:XDG_CONFIG_HOME = Join-Path $HOME ".config"

# --- PSReadLine: better command-line editing & history ----------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# --- Modern CLI tools (eza, bat) --------------------------------------------
# Aliases have higher precedence than functions, so drop the built-in alias
# first, then define a function that forwards args to the new tool.
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --group-directories-first @args }
    function ll { eza -lah --git --group-directories-first @args }
    function la { eza -a @args }
    function lt { eza --tree --level=2 @args }
} else {
    Set-Alias ll Get-ChildItem
}
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue
    function cat { bat @args }
}
Set-Alias which Get-Command

# --- Git shortcuts ----------------------------------------------------------
function gs  { git status @args }
function gd  { git diff @args }
function gl  { git log --oneline --graph --decorate -20 @args }
if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    function lg { lazygit @args }   # standalone TUI; `git lg` is separate
}

# --- Prompt -----------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
} else {
    # Fallback prompt: current path + git branch.
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
}

# --- zoxide (smarter cd: `z <dir>`, `zi` for interactive pick) --------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- Local, untracked overrides ---------------------------------------------
$localProfile = Join-Path (Split-Path $PROFILE) "profile.local.ps1"
if (Test-Path $localProfile) { . $localProfile }
