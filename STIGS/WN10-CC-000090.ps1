<#
.SYNOPSIS
    This PowerShell script enforces the reprocessing of Group Policy Objects (GPOs) even if they have not changed.

.DESCRIPTION
    The script modifies the Windows Registry to ensure that Group Policy settings are always reapplied, preventing unauthorized configuration drift. 
    It ensures compliance with security best practices and regulatory frameworks.

.NOTES
    Author          : Alain Anye  
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245   
    GitHub          : github.com/cyberalain   
    Date Created    : 2025-03-28  
    Last Modified   : 2025-03-28  
    Version         : 1.0  
    CVEs            : N/A  
    Plugin IDs      : N/A  
    STIG-ID         : WN10-CC-000090  

.TESTED ON
    Date(s) Tested  : 2025-03-28  
    Tested By       : Your Name  
    Systems Tested  : Windows 10, Windows 11  
    PowerShell Ver. : 5.1 (Native to Windows 10)  

.USAGE
    Run the script as an administrator to apply the policy.
    Example:
    PS C:\> .\Enforce-GPO-Reprocessing.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -Name "NoGPOListChanges"
#>

# Define the registry path for Group Policy processing
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"

# Define the registry key name and value
$registryName = "NoGPOListChanges"
$registryValue = 0  # 0 = Forces GPO reprocessing even if no changes detected

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to enforce Group Policy reprocessing
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the change
Get-ItemProperty -Path $registryPath -Name $registryName

# Force Group Policy update to apply changes immediately
gpupdate /force
