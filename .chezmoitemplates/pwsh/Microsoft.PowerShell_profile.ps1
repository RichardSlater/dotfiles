if (Test-Path "~/.config/oh-my-posh/cloud-native-tokyo-night.omp.json") {
    oh-my-posh init pwsh --config '~/.config/oh-my-posh/cloud-native-tokyo-night.omp.json' | Invoke-Expression
} else {
    oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/RichardSlater/dotfiles/master/dot_config/oh-my-posh/cloud-native-tokyo-night.omp.json' | Invoke-Expression
}

if ((get-command hugo | Measure-Object).Count -gt 0) {
  hugo completion powershell | Out-String | Invoke-Expression
}

if ((Get-Command gpg-agent | Measure-Object).Count -gt 0) {
  if ((Get-Process -ProcessName gpg-agent -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
    & gpg-connect-agent /bye
  }
}

if ((get-command podman -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
    Set-Alias -Name docker -Value podman
    podman completion powershell | Out-String | Invoke-Expression
}

Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name ls -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem -Force

$env:VISUAL = "nvim"
$env:EDITOR = "nvim"

$openSshExecutable = "C:\Windows\System32\OpenSSH\ssh.exe";
if (Test-Path $openSshExecutable) {
    $env:GIT_SSH=$openSshExecutable;
}

$isWindowsPlatform = [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT
$isAdministrator = $false
if ($isWindows) {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    $isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if ($isWindowsPlatform -and -not $isAdministrator -and -not (Get-Process -Name gpg-agent -ErrorAction SilentlyContinue)) {
    if (Get-Command -Name gpgconf -ErrorAction SilentlyContinue) {
        gpgconf --launch gpg-agent
    }
}

Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key ctrl+l -Function ClearScreen
