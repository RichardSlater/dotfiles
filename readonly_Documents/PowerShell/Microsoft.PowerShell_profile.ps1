oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/RichardSlater/dotfiles/master/dot_config/oh-my-posh/cloud-native.omp.json' | Invoke-Expression

hugo completion powershell | Out-String | Invoke-Expression

Set-Alias -Name docker -Value podman
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

$env:VISUAL = "nvim"
$env:EDITOR = "nvim"

$openSshExecutable = "C:\Windows\System32\OpenSSH\ssh.exe";
if (Test-Path $openSshExecutable) {
    $env:GIT_SSH=$openSshExecutable;
}
