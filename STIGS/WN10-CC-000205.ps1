<#
.SYNOPSIS
    Configures Windows 10 Telemetry settings to comply with DISA STIG WN10-CC-000205.

.DESCRIPTION
    This script enforces the "Allow Telemetry" policy to the most secure setting (0 - Security [Enterprise Only]).
    This prevents excessive data collection and ensures compliance with DoD security requirements.

.NOTES
    Author          : Alain Anye  
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245  
    GitHub          : github.com/cyberalain  
    Date Created    : 2025-04-04 
    Last Modified   : 2025-04-04
    Version         : 1.0  
    CVEs            : N/A  
    Plugin IDs      : N/A  
    STIG-ID         : WN10-CC-000205  
    Rule-ID         : SV-220834r991589_rule  
    Vuln-ID         : V-220834  
    CCI             : CCI-000366  

.TESTED ON
    Date(s) Tested  : 2025-04-04  
    Tested By       : Your Name  
    Systems Tested  : Windows 10 Enterprise (v1909+)  
    PowerShell Ver. : 5.1  

.USAGE
    Run the script as an administrator to apply the policy.  
    Example:
    PS C:\> .\Set-WindowsTelemetryCompliance.ps1  

    To verify the change:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry"
#>

# STIG Compliance Configuration
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$RegistryName = "AllowTelemetry"
$RegistryValue = 0  # 0 = Security [Enterprise Only] (Most restrictive)

# Create registry key if missing
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
    Write-Host "Created registry key: $RegistryPath" -ForegroundColor Cyan
}

# Apply STIG-mandated setting
try {
    Set-ItemProperty -Path $RegistryPath -Name $RegistryName -Value $RegistryValue -Type DWord -Force
    Write-Host "Configured AllowTelemetry to $RegistryValue (Security [Enterprise Only])" -ForegroundColor Cyan
} catch {
    Write-Host "ERROR: Failed to set registry value" -ForegroundColor Red
    exit 1
}

# Verification
$CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $RegistryName -ErrorAction SilentlyContinue).$RegistryName

if ($CurrentValue -eq $RegistryValue) {
    Write-Host "SUCCESS: STIG WN10-CC-000205 compliance enforced (Telemetry restricted to Security level)." -ForegroundColor Green
} else {
    Write-Host "ERROR: Configuration failed. Current value: $CurrentValue" -ForegroundColor Red
    exit 1
}

# Optional: Force Group Policy update (if deployed via GPO)
# gpupdate /force
