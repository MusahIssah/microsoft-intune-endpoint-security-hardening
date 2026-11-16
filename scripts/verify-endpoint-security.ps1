#Requires -Version 5.1
<#
.SYNOPSIS
Collects selected local endpoint security properties without changing settings.
.DESCRIPTION
Run in elevated 64-bit Windows PowerShell on the intended Windows endpoint.
Console objects only: no files, network requests, event logs, registry writes,
remediation, recovery password output, or full BitLocker protector objects.
Local administrator names may identify users/domains; sanitize before sharing.
This does not validate Intune deployment, compliance, join state, or escrow.
Missing commands/access failures are collection errors, not compliance failures.
#>
[CmdletBinding()]
param()

Set-StrictMode -Version 2.0

function Invoke-SecurityCheck {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$Query
    )
    try {
        # Local scope: do not change the caller's preference variables.
        $ErrorActionPreference = 'Stop'
        $result = @(& $Query)
        [pscustomobject]@{
            Check = $Name
            CollectionStatus = 'Collected'
            Data = $result
            ErrorType = $null
        }
    }
    catch {
        # Error messages and full exception objects may include sensitive data.
        [pscustomobject]@{
            Check = $Name
            CollectionStatus = 'CollectionError'
            Data = @()
            ErrorType = $_.Exception.GetType().Name
        }
    }
}

function Convert-ASRAction {
    param([int]$Value)
    switch ($Value) {
        0 { 'Disabled' }
        1 { 'Block' }
        2 { 'Audit' }
        6 { 'Warn' }
        default { 'Unknown' }
    }
}

if ($env:OS -ne 'Windows_NT') {
    throw 'This collector requires Windows. No checks were performed.'
}
if (-not [Environment]::Is64BitProcess) {
    throw 'Use 64-bit Windows PowerShell. No checks were performed.'
}
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run as administrator on the intended endpoint. No checks were performed.'
}

Invoke-SecurityCheck -Name 'BitLocker C:' -Query {
    $volume = Get-BitLockerVolume -MountPoint 'C:' -ErrorAction Stop
    # Never emit $volume, full KeyProtector objects, IDs, or recovery passwords.
    [pscustomobject]@{
        MountPoint = [string]$volume.MountPoint
        VolumeStatus = [string]$volume.VolumeStatus
        EncryptionPercentage = $volume.EncryptionPercentage
        ProtectionStatus = [string]$volume.ProtectionStatus
        EncryptionMethod = [string]$volume.EncryptionMethod
        ProtectorTypes = @($volume.KeyProtector | ForEach-Object {
            [string]$_.KeyProtectorType
        })
    }
}

Invoke-SecurityCheck -Name 'Effective firewall profiles' -Query {
    Get-NetFirewallProfile -PolicyStore ActiveStore -ErrorAction Stop |
        Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, LogBlocked
}

Invoke-SecurityCheck -Name 'Defender status' -Query {
    Get-MpComputerStatus -ErrorAction Stop |
        Select-Object AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled
}

Invoke-SecurityCheck -Name 'Defender preferences' -Query {
    Get-MpPreference -ErrorAction Stop |
        Select-Object MAPSReporting, CloudBlockLevel, SubmitSamplesConsent,
            PUAProtection, DisableRealtimeMonitoring, DisableBehaviorMonitoring,
            DisableScriptScanning, DisableArchiveScanning, DisableIOAVProtection,
            EnableNetworkProtection
}

Invoke-SecurityCheck -Name 'Secure Boot' -Query {
    [pscustomobject]@{ SecureBootEnabled = Confirm-SecureBootUEFI -ErrorAction Stop }
}

Invoke-SecurityCheck -Name 'TPM' -Query {
    Get-Tpm -ErrorAction Stop |
        Select-Object TpmPresent, TpmReady, TpmEnabled, TpmActivated
}

Invoke-SecurityCheck -Name 'Local Administrators membership' -Query {
    Get-LocalGroupMember -SID 'S-1-5-32-544' -ErrorAction Stop |
        Select-Object Name, ObjectClass, PrincipalSource
}

Invoke-SecurityCheck -Name 'Selected local account properties' -Query {
    Get-LocalUser -ErrorAction Stop |
        Where-Object { $_.SID.Value -match '-500$' -or $_.Name -eq 'BTLabAdmin' } |
        Select-Object Name, Enabled, PasswordRequired
}

Invoke-SecurityCheck -Name 'ASR and Controlled Folder Access' -Query {
    $preferences = Get-MpPreference -ErrorAction Stop
    $ids = @($preferences.AttackSurfaceReductionRules_Ids)
    $actions = @($preferences.AttackSurfaceReductionRules_Actions)
    # Some versions return null when no rules are configured.
    if ($null -eq $preferences.AttackSurfaceReductionRules_Ids) { $ids = @() }
    if ($null -eq $preferences.AttackSurfaceReductionRules_Actions) { $actions = @() }
    if ($ids.Count -ne $actions.Count) {
        throw 'ASR rule ID and action counts differ; no mapping inferred.'
    }
    $rules = @(for ($i = 0; $i -lt $ids.Count; $i++) {
        $action = [int]$actions[$i]
        [pscustomobject]@{
            RuleId = [string]$ids[$i]
            ActionValue = $action
            Action = Convert-ASRAction -Value $action
        }
    })
    $cfaValue = [int]$preferences.EnableControlledFolderAccess
    $cfaMode = switch ($cfaValue) {
        0 { 'Disabled' }
        1 { 'Enabled' }
        2 { 'Audit' }
        3 { 'BlockDiskModificationOnly' }
        4 { 'AuditDiskModificationOnly' }
        default { 'Unknown' }
    }
    [pscustomobject]@{
        RuleCount = $rules.Count
        BlockCount = @($rules | Where-Object { $_.ActionValue -eq 1 }).Count
        AuditCount = @($rules | Where-Object { $_.ActionValue -eq 2 }).Count
        Rules = $rules
        ControlledFolderAccessValue = $cfaValue
        ControlledFolderAccessMode = $cfaMode
    }
}
