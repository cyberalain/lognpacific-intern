<#
.SYNOPSIS
    This PowerShell script enforces STIG compliance by enabling the "NoNameReleaseOnDemand" setting to improve NetBIOS security.

.DESCRIPTION
    The script ensures that the system ignores NetBIOS name release requests except from WINS servers.  
    This helps prevent unauthorized NetBIOS name resolution attacks and strengthens overall network security.

.NOTES
    Author          : Alain Anye  
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245   
    GitHub          : github.com/cyberalain  
    Date Created    : 2025-04-04  
    Last Modified   : 2025-04-04  
    Version         : 1.0  
    CVEs            : N/A  
    Plugin IDs      : N/A  
    STIG-ID         : WN10-CC-000035  

.TESTED ON
    Date(s) Tested  : 2025-04-04  
    Tested By       : Your Name  
    Systems Tested  : Windows 10, Windows 11  
    PowerShell Ver. : 5.1 (Native to Windows 10)  

.USAGE
    Run the script as an administrator to apply the policy.  
    Example:
    PS C:\> .\Enable-NoNameReleaseOnDemand.ps1  

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "NoNameReleaseOnDemand"
#>

# Ensure the script runs with administrative privileges
$adminCheck = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $adminCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Please run this script as an Administrator!" -ForegroundColor Red
    exit
}

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters"
$registryName = "NoNameReleaseOnDemand"
$registryValue = 1  # 1 = Enabled, 0 = Disabled

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Apply the setting to enable NoNameReleaseOnDemand
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force

# Verify the change
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

if ($currentValue.NoNameReleaseOnDemand -eq 1) {
    Write-Host "SUCCESS: NoNameReleaseOnDemand is now ENABLED (STIG WN10-CC-000035)." -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to enable NoNameReleaseOnDemand." -ForegroundColor Red
}

# Force Group Policy update to apply changes immediately
gpupdate /force
