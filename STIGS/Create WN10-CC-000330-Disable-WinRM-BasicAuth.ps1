<#
.SYNOPSIS
    This PowerShell script disables Basic authentication for Windows Remote Management (WinRM) client.

.DESCRIPTION
    The script modifies the Windows Registry to disable Basic authentication in WinRM client,
    enforcing secure credential transmission. This implements DoD STIG requirement WN10-CC-000330
    to prevent insecure authentication methods.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245  
    GitHub          : github.com/cyberalain
    Date Created    : 2025-04-01
    Last Modified   : 2025-04-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000330
    Vuln-ID         : V-220862
    CCI             : CCI-000877

.TESTED ON
    Date(s) Tested  : 2025-04-01
    Tested By       : Alain Anye
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1 (Native to Windows 10)

.USAGE
    Run the script as an administrator to apply the policy.
    Example:
    PS C:\> .\Disable-WinRM-BasicAuth.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" -Name "AllowBasic"

.REFERENCES
    STIG Viewer Link: https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_MS_Windows_10_V3R2_STIG.zip
    800-171 Control: 3.7.5
#>

# Define the registry path for WinRM client settings
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"

# Define the registry key name and value
$registryName = "AllowBasic"
$registryValue = 0  # 0 = Disable Basic authentication

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator!"
    exit 1
}

# Check if the registry path exists; if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to disable Basic authentication
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the change
$result = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

if ($result.$registryName -eq 0) {
    Write-Host "[SUCCESS] WinRM Basic authentication has been disabled." -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to disable WinRM Basic authentication." -ForegroundColor Red
}

# Force Group Policy update to apply changes immediately (optional)
# gpupdate /force | Out-Null
