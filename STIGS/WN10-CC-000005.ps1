<#
.SYNOPSIS
    This PowerShell script disables camera access from the lock screen to comply with DISA STIG security recommendations.

.DESCRIPTION
    The script enforces a Group Policy setting that prevents the use of the camera when the device is locked.
    This is a critical security control to reduce unauthorized access or misuse of the system's camera.
    It updates the relevant registry key to ensure compliance.

.NOTES
    Author          : Alain Anye
    LinkedIn        : linkedin.com/in/alain-ade-anye-746804245
    GitHub          : github.com/cyberalain
    Date Created    : 2025-04-08
    Last Modified   : 2025-04-08
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000005
    SRG             : SRG-OS-000095-GPOS-00049
    CCI             : CCI-000381
    Vulnerability ID: V-220792

.TESTED ON
    Date(s) Tested  : 2025-04-08
    Tested By       : Your Name
    Systems Tested  : Windows 10, Windows 11
    PowerShell Ver. : 5.1 (Native to Windows 10 and above)

.USAGE
    Run this script as an Administrator to apply the STIG setting.
    Example:
    PS C:\> .\Disable-LockScreen-Camera.ps1

    To verify the registry setting:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera"

#>

# Define the registry path for the lock screen camera policy
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$registryName = "NoLockScreenCamera"
$registryValue = 1  # 1 = Disable camera access from the lock screen

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Output "Created registry path: $registryPath"
}

# Set the policy to disable camera on the lock screen
Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord
Write-Output "Camera access from lock screen has been disabled (STIG: WN10-CC-000005)"

# Verify the change
Get-ItemProperty -Path $registryPath -Name $registryName

# Optionally force group policy update
gpupdate /force
