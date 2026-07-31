$ErrorActionPreference = 'Stop'

$taskName = 'RubricSystemWebsiteServer'
$firewallRuleName = 'RubricSystemWebsiteServer-8080'

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
	Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
	Write-Host "Removed scheduled task: $taskName"
}
else {
	Write-Host "Scheduled task not found: $taskName"
}

try {
	if (Get-NetFirewallRule -Name $firewallRuleName -ErrorAction SilentlyContinue) {
		Remove-NetFirewallRule -Name $firewallRuleName -ErrorAction Stop
		Write-Host "Removed firewall rule: $firewallRuleName"
	}
	else {
		Write-Host "Firewall rule not found: $firewallRuleName"
	}
}
catch {
	Write-Warning "Could not remove firewall rule. Run this script as administrator if needed: $($_.Exception.Message)"
}