<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245
    GitHub          : github.com/cyberalain 
    Date Created    : 2025-03-26
    Last Modified   : 2025-03-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

# Define the registry value name and data
$registryName = "MaxSize"
$registryValue = 0x8000  # 32768 in hexadecimal (DWORD: 00008000)

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord

# Verify the change
Get-ItemProperty -Path $registryPath -Name $registryName
