oh-my-posh init pwsh --config 'C:\source\dotsettings\shared\cloud-native.omp.json' | Invoke-Expression

hugo completion powershell | Out-String | Invoke-Expression

Set-Alias -Name docker -Value podman
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

$env:EDITOR = "nvim"
