<#
.SYNOPSIS
    Disables unencrypted traffic for the WinRM client to comply with STIG WN10-CC-000335.

.DESCRIPTION
    Enforces secure communication over Windows Remote Management by disabling unencrypted traffic on the WinRM client.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245
    GitHub          : github.com/cyberalain
    Date Created    : 2025-04-11
    Last Modified   : 2025-04-11
    Version         : 1.0
    STIG-ID         : WN10-CC-000335

.TESTED ON
    Date(s) Tested  : 2025-04-11
    Tested By       : Your Name
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1+

.USAGE
    Run this script as Administrator.
    Example:
    PS C:\> .\Disable-WinRM-Unencrypted-Traffic.ps1
#>

# Registry path and value details
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$registryName = "AllowUnencryptedTraffic"
$registryValue = 0  # 0 = Disabled

# Create the registry path if it does not exist
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy value
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force

# Validate and output the result
$current = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
if ($current.AllowUnencryptedTraffic -eq 0) {
    Write-Host "SUCCESS: 'Allow unencrypted traffic' is now DISABLED for WinRM Client. (STIG WN10-CC-000335)" -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to disable unencrypted traffic for WinRM Client." -ForegroundColor Red
}

# Optional: Apply Group Policy immediately
gpupdate /force
