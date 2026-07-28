$ErrorActionPreference = 'Stop'

$taskName = 'RubricSystemWebsiteServer'
$firewallRuleName = 'RubricSystemWebsiteServer-8080'
$websiteRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$hiddenScript = Join-Path $websiteRoot 'start-website-hidden.ps1'

if (-not (Test-Path $hiddenScript)) {
    throw "Missing startup script: $hiddenScript"
}

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    $pythonCommand = Get-Command py -ErrorAction SilentlyContinue
}

if (-not $pythonCommand -or -not (Test-Path $pythonCommand.Source)) {
    throw 'Python was not found.'
}

$pythonExecutable = $pythonCommand.Source

$action = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$hiddenScript`" -PythonExecutable `"$pythonExecutable`"" `
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

try {
    if (-not (Get-NetFirewallRule -Name $firewallRuleName -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule `
            -Name $firewallRuleName `
            -DisplayName 'Rubric System website (TCP 8080)' `
            -Direction Inbound `
            -Action Allow `
            -Protocol TCP `
            -LocalPort 8080 `
            -Profile Private `
            -ErrorAction Stop | Out-Null
    }
    Write-Host 'Windows Firewall allows TCP 8080 on private networks.'
}
catch {
    Write-Warning "Could not configure Windows Firewall. Run this installer as administrator to allow LAN access: $($_.Exception.Message)"
}

Write-Host "Installed scheduled task: $taskName"
Write-Host "The server will start hidden when this Windows user logs on."
Write-Host "You can also start it now from Task Scheduler, or run: Start-ScheduledTask -TaskName '$taskName'"