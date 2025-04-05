<#
.SYNOPSIS
    This PowerShell script disables user control over software installs to comply with DISA STIG requirements.

.DESCRIPTION
    The script enforces the Windows security policy "Allow user control over installs" to be Disabled.
    This setting ensures only administrators can make system-wide software installations, mitigating risks
    from unauthorized or untrusted application installs.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245
    GitHub          : github.com/cyberalain
    Date Created    : 2025-04-05
    Last Modified   : 2025-04-05
    Version         : 1.0
    STIG-ID         : WN10-CC-000310
    Vuln-ID         : V-220856
    Rule-ID         : SV-220856r1016416_rule
    CCI             : CCI-001812, CCI-003980
    References      : ISO/IEC-27001 A.12.6.2, NIST 800-171 3.4.9, GDPR 32.1.b

.TESTED ON
    Date(s) Tested  : 2025-04-05
    Tested By       : Your Name
    Systems Tested  : Windows 10 Pro, Windows 11 Pro
    PowerShell Ver. : 5.1 (Native on Windows 10/11)

.USAGE
    Run the script as Administrator to apply the policy:
    Example:
    PS C:\> .\Disable-UserControlOverInstalls.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name "EnableUserControl"
#>

# Define registry path for policy setting
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\Installer"

# Registry value to be set
$registryName = "EnableUserControl"
$registryValue = 0  # 0 = Disabled (Do not allow users control over installs)

# Ensure the registry path exists
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Created registry path: $registryPath"
}

# Apply the security policy
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord
Write-Host "'Allow user control over installs' has been set to 'Disabled' (0)" -ForegroundColor Green

# Verify the setting was applied
$currentSetting = Get-ItemProperty -Path $registryPath -Name $registryName
Write-Host "Current Value: $($currentSetting.$registryName)" -ForegroundColor Yellow

# Optionally, update Group Policy
Write-Host "Updating Group Policy..."
gpupdate /force
