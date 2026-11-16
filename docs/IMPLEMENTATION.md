# Implementation and Validation

[Overview](../README.md) · [Findings](SECURITY_FINDINGS.md) · [Evidence index](EVIDENCE_INDEX.md)

## Evidence model

Recorded work and repeat-verification procedures are separated below. Policy names, assignment groups, unreported settings, and screenshots are not invented. Locate the matching Windows endpoint security or compliance policy in Intune and compare configuration, assignment, and per-device status. Portal navigation can change.

The commands are read-only procedures, not a claim that this exact sequence produced every supplied observation. Use elevated 64-bit Windows PowerShell on the lab endpoint; review output before sharing.

## 1. Enrollment and connectivity

Recorded: MDM-only enrollment, not Entra joined. Internet loss caused sync error `0x80072ee7`. Connectivity was restored; sync succeeded November 15, 2026 at 9:46 AM, and Intune check-in updated. The timestamp's source time zone and exact repair commands were not supplied.

For repeat validation, inspect the Windows work/school management connection, manually sync through Windows Settings, and compare its result with Intune check-in. Do not publish account or enrollment identifiers. Identity diagnostics can expose identifiers and are intentionally excluded from the collector.

## 2. Firewall

Intune firewall policy deployment succeeded. Local Domain/Private/Public profiles were Enabled; inbound Block, outbound Allow, log blocked True.

```powershell
Get-NetFirewallProfile -PolicyStore ActiveStore |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction, LogBlocked
```

Compare effective profiles with the device deployment status. Traffic behavior tests were not supplied.

## 3. BitLocker

C: was FullyEncrypted, 100%, Protection On, XtsAes128. TPM and RecoveryPassword protector types existed. No Intune encryption policy deployment result was supplied.

```powershell
$volume = Get-BitLockerVolume -MountPoint 'C:'
[pscustomobject]@{
    MountPoint = $volume.MountPoint
    VolumeStatus = [string]$volume.VolumeStatus
    EncryptionPercentage = $volume.EncryptionPercentage
    ProtectionStatus = [string]$volume.ProtectionStatus
    EncryptionMethod = [string]$volume.EncryptionMethod
    ProtectorTypes = @($volume.KeyProtector | ForEach-Object { [string]$_.KeyProtectorType })
}
```

Do not print complete volume or KeyProtector objects in public evidence. Do not retrieve recovery passwords for screenshots. No recovery key was found in Entra portal; [BL-01](SECURITY_FINDINGS.md#bl-01--recovery-key-visibility) remains open. Other locations are not excluded.

## 4. Local accounts

Built-in Administrator was disabled; BTLabAdmin belonged to Administrators. BTLabAdmin PasswordRequired was False and was remediated **locally** to True. The modifying command was not supplied and is not reconstructed here. Centralized membership policy was **not deployed**, pending MDM-only compatibility review.

Use SIDs for built-in identities to avoid localized display-name assumptions:

```powershell
Get-LocalUser |
    Where-Object { $_.SID.Value -match '-500$' -or $_.Name -eq 'BTLabAdmin' } |
    Select-Object Name, Enabled, PasswordRequired

Get-LocalGroupMember -SID 'S-1-5-32-544' |
    Select-Object Name, ObjectClass, PrincipalSource
```

Names can identify users or domains; sanitize before publication. PasswordRequired True does not prove strength, rotation, or central enforcement.

## 5. Compliance and platform security

The six Intune controls were BitLocker, Secure Boot, Firewall, TPM, Antivirus, and Antispyware; all reported Compliant. No other compliance settings or grace periods are supplied.

```powershell
Confirm-SecureBootUEFI
Get-Tpm | Select-Object TpmPresent, TpmReady, TpmEnabled, TpmActivated
Get-MpComputerStatus |
    Select-Object AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled
```

Independent observations: Secure Boot True; all four TPM properties True; Defender AV, antispyware, and real-time protection True. Missing cmdlets, firmware support, or permissions are collection limitations, not automatic proof of noncompliance.

## 6. Defender Antivirus

Intune AV policy deployed successfully. Compare local preferences with its device result:

```powershell
Get-MpPreference | Select-Object MAPSReporting, CloudBlockLevel, SubmitSamplesConsent,
    PUAProtection, DisableRealtimeMonitoring, DisableBehaviorMonitoring,
    DisableScriptScanning, DisableArchiveScanning, DisableIOAVProtection,
    EnableNetworkProtection
```

| Preference | Observed value |
| --- | --- |
| MAPSReporting | 1 |
| CloudBlockLevel | 2 (High) |
| SubmitSamplesConsent | 1 |
| PUAProtection | 1 |
| DisableRealtimeMonitoring | False |
| DisableBehaviorMonitoring | False |
| DisableScriptScanning | False |
| DisableArchiveScanning | False |
| DisableIOAVProtection | False |
| EnableNetworkProtection | 0 (disabled) |

No Network Protection enablement or malware challenge test is claimed.

## 7. ASR and Controlled Folder Access

Intune ASR policy deployed successfully. Local state: 18 rules, one Block and 17 Audit; Controlled Folder Access Audit. The Block rule was vulnerable signed drivers, `56a863a9-875e-4185-98a7-b882c64b5ce5`. The [collector](../scripts/verify-endpoint-security.ps1) pairs each returned rule ID and action by index. Do not infer the identities of unreported rules.

Ten recorded Event ID 1122 audit events involved LSASS protection rule `9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2` and svchost.exe/lsass.exe. Review context locally in **Microsoft-Windows-Windows Defender/Operational**. Publish a sanitized summary only: event ID, rule ID, relevant executable basenames, count, and an observation window when available. No observation window was supplied for these ten events.

The collector intentionally excludes event logs and does not reconstruct this count. Audit telemetry is not proof of compromise. See [ASR-01](SECURITY_FINDINGS.md#asr-01--lsass-protection-audit-review).

## Verification boundaries

Repository validation parses the script without executing security queries and checks Markdown paths and whitespace. Endpoint execution of the new script, recovery testing, enforcement rollout, and remediation of open findings remain unclaimed. The script does not modify policy, sync the device, repair connectivity, escrow keys, or remediate findings.
