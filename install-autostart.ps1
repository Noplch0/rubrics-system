$ErrorActionPreference = 'Stop'

$taskName = 'RubricSystemWebsiteServer'
$websiteRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$hiddenScript = Join-Path $websiteRoot 'start-website-hidden.ps1'

if (-not (Test-Path $hiddenScript)) {
    throw "Missing startup script: $hiddenScript"
}

$action = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$hiddenScript`"" `
    -WorkingDirectory $websiteRoot

$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Days 0)

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description 'Start rubric-system local website server in the background at logon.' `
    -Force | Out-Null

Write-Host "Installed scheduled task: $taskName"
Write-Host "The server will start hidden when this Windows user logs on."
Write-Host "You can also start it now from Task Scheduler, or run: Start-ScheduledTask -TaskName '$taskName'"