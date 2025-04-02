<#
.SYNOPSIS
    This PowerShell script disables Basic authentication in Windows Remote Management (WinRM) to comply with security best practices.

.DESCRIPTION
    The script enforces a security policy that prevents the use of Basic authentication in WinRM. 
    This helps improve system security by ensuring that credentials are not sent in an unencrypted format.

.NOTES
    Author          : Alain Anye  
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245  
    GitHub          : github.com/cyberalain  
    Date Created    : 2025-04-03  
    Last Modified   : 2025-04-03  
    Version         : 1.0  
    CVEs            : N/A  
    Plugin IDs      : N/A  
    STIG-ID         : WN10-CC-000345  

.TESTED ON
    Date(s) Tested  : 2025-04-03
    Tested By       : Your Name  
    Systems Tested  : Windows 10, Windows 11  
    PowerShell Ver. : 5.1 (Native to Windows 10)  

.USAGE
    Run the script as an administrator to apply the policy.  
    Example:
    PS C:\> .\Disable-WinRM-Basic-Auth.ps1  

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -Name "AllowBasic"
#>

# Define the registry path for WinRM Service settings
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"

# Define the registry key name and value
$registryName = "AllowBasic"
$registryValue = 0  # 0 = Disable Basic authentication in WinRM

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the policy to disable Basic authentication
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force

# Verify the change
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

if ($currentValue.AllowBasic -eq 0) {
    Write-Host "SUCCESS: Basic authentication for WinRM is now DISABLED (STIG WN10-CC-000345)." -ForegroundColor Green
} else {
    Write-Host "ERROR: Failed to disable Basic authentication for WinRM." -ForegroundColor Red
}

# Force Group Policy update to apply changes immediately
gpupdate /force
