<#
.SYNOPSIS
    This PowerShell script disables administrator account enumeration during elevation.

.DESCRIPTION
    The script modifies the Windows Registry to prevent administrator accounts from being displayed
    when a user attempts to elevate privileges. This enhances security by ensuring unauthorized users
    cannot see which administrator accounts exist on the system.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245  
    GitHub          : github.com/cyberalain
    Date Created    : 2025-03-30
    Last Modified   : 2025-03-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID        : WN10-CC-000200

.TESTED ON
    Date(s) Tested  : 2025-03-28
    Tested By       : Your Name
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1 (Native to Windows 10)

.USAGE
    Run the script as an administrator to apply the policy.
    Example:
    PS C:\> .\Disable-Admin-Enumeration.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI" -Name "EnumerateAdministrators"
#>

# Define the registry path for administrator account enumeration settings
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI"

# Define the registry key name and value
$registryName = "EnumerateAdministrators"
$registryValue = 0  # 0 = Disable administrator account enumeration

# Check if the registry path exists; if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to disable administrator enumeration
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the change
Get-ItemProperty -Path $registryPath -Name $registryName

# Force Group Policy update to apply changes immediately
gpupdate /force
