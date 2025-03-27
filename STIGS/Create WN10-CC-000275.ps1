<#
.SYNOPSIS
    This PowerShell script disables local drive sharing in Remote Desktop sessions to comply with security best practices.

.DESCRIPTION
    The script enforces a security policy that prevents users from sharing their local drives when connecting via Remote Desktop. 
    It modifies the relevant registry settings, ensuring compliance with security standards.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245 
    GitHub          : github.com/cyberalain 
    Date Created    : 2025-03-27
    Last Modified   : 2025-03-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000275

.TESTED ON
    Date(s) Tested  : 2025-03-27
    Tested By       : Your Name
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1 (Native to Windows 10)

.USAGE
    Run the script as an administrator to apply the policy.
    Example:
    PS C:\> .\Disable-RDP-Drive-Sharing.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableCdm"
#>

# Define the registry path for Remote Desktop drive sharing
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services"

# Define the registry key name and value
$registryName = "fDisableCdm"
$registryValue = 1  # 1 = Disable local drive sharing in Remote Desktop

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to disable drive sharing
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the change
Get-ItemProperty -Path $registryPath -Name $registryName

# Force Group Policy update to apply changes immediately
gpupdate /force
