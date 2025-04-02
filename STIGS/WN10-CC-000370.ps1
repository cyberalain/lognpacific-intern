<#
.SYNOPSIS
    This PowerShell script disables the convenience PIN sign-in feature in Windows to comply with security best practices.

.DESCRIPTION
    The script enforces a security policy that prevents users from using PIN-based authentication.
    It modifies the relevant registry settings to ensure compliance with STIG WN10-CC-000370.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245
    GitHub          : github.com/cyberalain
    Date Created    : 2025-04-02
    Last Modified   : 2025-04-02
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000370

.TESTED ON
    Date(s) Tested  : 2025-04-02
    Tested By       : Your Name
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1 (Native to Windows 10)

.USAGE
    Run the script as an administrator to apply the policy.
    Example:
    PS C:\> .\Disable-PIN-SignIn.ps1

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowDomainPINLogon"
#>

# Define the registry path for PIN sign-in settings
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Define the registry key name and value
$registryName = "AllowDomainPINLogon"
$registryValue = 0  # 0 = Disable PIN sign-in

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to disable PIN sign-in
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force

# Verify the change
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

if ($currentValue.AllowDomainPINLogon -eq 0) {
    Write-Host "SUCCESS: Convenience PIN sign-in is now DISABLED (STIG WN10-CC-000370)." -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to disable PIN sign-in." -ForegroundColor Red
}

# Force Group Policy update to apply changes immediately
gpupdate /force
