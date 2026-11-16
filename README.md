# Microsoft Intune Endpoint Security Hardening, Compliance Validation & Risk Assessment

**Windows 11 · Microsoft Intune · Hyper-V · PowerShell · Endpoint security · Risk assessment**

## Overview

This personal lab documents endpoint configuration, compliance validation, and risk assessment for **BT-WIN11-01**, a Windows 11 Hyper-V VM managed by Intune through **MDM-only enrollment**. The device is **not Microsoft Entra joined**.

The project distinguishes successful policy deployment, independent local verification, and compliance evaluation. All six evaluated compliance controls reported Compliant, while recovery-key visibility and ASR audit review remained unresolved. Compliance status does not resolve every operational risk.

Results are the author's supplied lab observations. Repository validation checks documentation and script syntax; it does not repeat endpoint testing. Reviewed screenshots and selected text exports are displayed inline below and in the implementation guide. Identifier-bearing images were cropped or redacted on copies; sensitive raw event logs are excluded.

## Business scenario

A security team needs a managed Windows endpoint with encryption, host firewall protection, antimalware controls, and measurable compliance. Beyond deployment status, the team must evaluate recoverability, local administrator governance, and whether attack surface reduction rules audit or block activity.

## Architecture

```mermaid
flowchart LR
    Admin[Lab administrator] --> Intune[Intune management plane]
    Intune <-->|MDM policy delivery and reporting over internet| VM[BT-WIN11-01: Windows 11 VM]
    Host[Hyper-V host and virtual network] --> VM
    VM --> Controls[BitLocker, Firewall, Defender, ASR]
    VM --> Platform[Secure Boot and TPM]
    Entra[Entra portal recovery-key review] -.-> Gap[BL-01: recovery visibility unresolved]
```

MDM management does not establish Entra join. Centralized local group membership policy was **not deployed**, pending MDM-only compatibility review. See [architecture and trust boundaries](docs/ARCHITECTURE.md).

## Technology stack

| Technology | Role |
| --- | --- |
| Windows 11 / Hyper-V | Single virtual lab endpoint |
| Microsoft Intune | Endpoint security deployment and compliance evaluation |
| Microsoft Defender Antivirus / ASR | Antimalware settings and audit telemetry |
| BitLocker / TPM / Secure Boot | Encryption and platform state |
| Windows Defender Firewall | Host firewall profile settings |
| PowerShell | Independent read-only verification |
| NIST SP 800-53 Rev. 5 | Contextual security control mapping |

## Methodology

1. Establish enrollment scope and restore management connectivity.
2. Record policy configuration and per-device deployment outcomes separately.
3. Compare portal results with local PowerShell observations.
4. Assess recovery-key visibility, local accounts, and ASR audit telemetry.
5. Document findings, remediation recommendations, closure criteria, and untested areas.

Initial sync failed with `0x80072ee7` after VM internet connectivity was lost. Connectivity was restored; sync succeeded **November 15, 2026 at 9:46 AM**, and Intune check-in updated. The supplied timestamp's displayed time zone was not specified. No security incident is inferred from the connectivity failure.

See [implementation and validation procedures](docs/IMPLEMENTATION.md).

## Results matrix

“Not established” means the supplied observations do not establish that stage; it does not mean failure.

| Control | Configured / scope | Deployment | Locally verified | Intune compliance | Finding / untested |
| --- | --- | --- | --- | --- | --- |
| Management | MDM-only; not Entra joined | Sync recovered; check-in updated | VM internet restored | Not an evaluated control | Enrollment migration untested |
| BitLocker | C: encrypted; Intune encryption settings not supplied | Encryption policy deployment not established | FullyEncrypted, 100%, Protection On, XtsAes128; TPM and RecoveryPassword protector types | Compliant | **BL-01 OPEN**; recovery exercise untested |
| Firewall | All profiles enabled; inbound Block; outbound Allow; log blocked True | Intune firewall policy succeeded | Domain/Private/Public and listed settings verified | Compliant | Traffic behavior tests not supplied |
| Local accounts | Built-in Administrator disabled; BTLabAdmin in Administrators | Centralized membership policy **not deployed** | PasswordRequired False → True, remediated locally | Not an evaluated control | Password strength and central enforcement untested |
| Defender AV | Preferences below | Intune AV policy succeeded | AV, antispyware, real-time protection True; preferences verified | Antivirus and Antispyware Compliant | Malware challenge testing not supplied |
| Secure Boot | Platform state | Intune deployment not established | True | Compliant | Boot tamper testing not supplied |
| TPM | Platform state | Intune deployment not established | Present, ready, enabled, activated True | Compliant | Recovery testing not supplied |
| ASR / CFA | 18 rules: 1 Block, 17 Audit; Controlled Folder Access Audit | Intune ASR policy succeeded | Rule distribution and 10 recorded Event ID 1122 audit events | Not an evaluated control | **ASR-01 Under Review**; block-mode rollout untested |
| Network Protection | EnableNetworkProtection = 0, disabled | Deployment intent not established | Local preference verified | Not an evaluated control | No enablement or enforcement test claimed |

The six evaluated compliance controls were **BitLocker, Secure Boot, Firewall, TPM, Antivirus, and Antispyware**; all reported **Compliant**. This scoped Intune result is not certification or a full compliance assessment.

### Verified Defender preferences

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

### ASR observations

The vulnerable signed driver rule, `56a863a9-875e-4185-98a7-b882c64b5ce5`, was the one Block rule. The other 17 rules were Audit. Controlled Folder Access was Audit.

Ten recorded Event ID **1122** events involved the LSASS credential protection rule, `9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2`, and `svchost.exe` / `lsass.exe`. This is **audit telemetry, not proof of compromise**. No observation window or complete event corpus is supplied; the count is not a claim about all events on the endpoint.

## Evidence walkthrough

The evidence appears alongside the corresponding result. Expanded policy screenshots and complete reviewed text exports appear under each matching procedure in [Implementation](docs/IMPLEMENTATION.md). These are historical lab artifacts, not output from the newly authored collector.

### 1. Enrollment and sync recovery

Local identity status reports `AzureAdJoined : NO`. The failed sync and subsequent success are shown in order; after connectivity restoration, the portal check-in updated.

*Sync failure 0x80072ee7 before connectivity restoration*

![Sync failure 0x80072ee7 before connectivity restoration](evidence/04_MDM_Synchronization_Status.png)

*Successful sync on November 15, 2026 at 9:46:23 AM*

![Successful sync on November 15, 2026 at 9:46:23 AM](evidence/04_MDM_Synchronization_Success.png)

*Intune check-in updated to November 15, 2026 at 9:46 AM*

![Intune check-in updated to November 15, 2026 at 9:46 AM](evidence/05_Intune_Device_CheckIn_Confirmed.png)

### 2. BitLocker and recovery visibility

Encryption and protector types are verified separately from recovery-key availability. No recovery password is included.

**Recorded output — [06_BitLocker_Encryption_Status.txt](evidence/06_BitLocker_Encryption_Status.txt):**

```text
MountPoint           : C:
VolumeStatus         : FullyEncrypted
ProtectionStatus     : On
EncryptionPercentage : 100
EncryptionMethod     : XtsAes128
```

**Recorded output — [07_BitLocker_Protector_Types.txt](evidence/07_BitLocker_Protector_Types.txt):**

```text
KeyProtectorType
----------------
RecoveryPassword
             Tpm
```

*Portal reports no BitLocker recovery key found for the reviewed device*

![Portal reports no BitLocker recovery key found for the reviewed device](evidence/09_Entra_BitLocker_Key_Not_Found.png)

**BL-01 remains OPEN.** The portal observation does not prove that recovery material is absent everywhere.

### 3. Firewall deployment and local verification

*Intune firewall policy reports one successful device*

![Intune firewall policy reports one successful device](evidence/11_Intune_Firewall_Policy_Status.png)

**Recorded output — [10_Defender_Firewall_Status.txt](evidence/10_Defender_Firewall_Status.txt):**

```text
Firewall Assessment - 11/15/2026 10:52:08


Name                  : Domain
Enabled               : True
DefaultInboundAction  : Block
DefaultOutboundAction : Allow
LogAllowed            : False
LogBlocked            : True

Name                  : Private
Enabled               : True
DefaultInboundAction  : Block
DefaultOutboundAction : Allow
LogAllowed            : False
LogBlocked            : True

Name                  : Public
Enabled               : True
DefaultInboundAction  : Block
DefaultOutboundAction : Allow
LogAllowed            : False
LogBlocked            : True
```

### 4. Local administrator review

Built-in Administrator was disabled. BTLabAdmin belonged to Administrators and initially had PasswordRequired False. The local remediation changed that property to True; centralized group policy was not deployed.

*Historical local BTLabAdmin Password required No*

![Historical local BTLabAdmin Password required No](evidence/15_Local_Admin_Password_Requirement_Before.png)

**Recorded output — [14_Local_Admin_Account_Status.txt](evidence/14_Local_Admin_Account_Status.txt):**

```text
Name          Enabled PasswordRequired PasswordLastSet
----          ------- ---------------- ---------------
Administrator   False             True
BTLabAdmin       True            False 11/9/2026 5:45:21 PM
```

**Recorded output — [16_Local_Admin_Password_Requirement_After.txt](evidence/16_Local_Admin_Password_Requirement_After.txt):**

```text
User name                    BTLabAdmin
Full Name
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            11/9/2026 5:45:21 PM
Password expires             Never
Password changeable          11/9/2026 5:45:21 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   11/15/2026 9:32:56 AM

Logon hours allowed          All

Local Group Memberships      *Administrators
Global Group memberships     *None
The command completed successfully.
```

*Draft administrator group selection during compatibility review*

![Draft administrator group selection during compatibility review](evidence/20_Local_Admin_Policy_Compatibility_Review.png)

*The policy wizard is a draft under compatibility review, not proof of Intune deployment.*

### 5. Compliance and independent platform verification

*All six evaluated controls reported Compliant*

![All six evaluated controls reported Compliant](evidence/26_Intune_Device_Compliance_Results.png)

**Recorded output — [25_Device_Security_Compliance_Verification.txt](evidence/25_Device_Security_Compliance_Verification.txt):**

```text
Device Security Verification - 11/15/2026 14:09:04
=== SECURE BOOT ===
True

=== TPM ===


TpmPresent   : True
TpmReady     : True
TpmEnabled   : True
TpmActivated : True




=== MICROSOFT DEFENDER ===


AMServiceEnabled              : True
AntivirusEnabled              : True
AntispywareEnabled            : True
RealTimeProtectionEnabled     : True
AntivirusSignatureLastUpdated : 11/13/2026 5:47:57 AM
```

### 6. Defender Antivirus

*Intune AV policy reports one successful device*

![Intune AV policy reports one successful device](evidence/28_Defender_AV_Policy_Deployment.png)

**Recorded output — [30_Defender_AV_Configuration_Verification.txt](evidence/30_Defender_AV_Configuration_Verification.txt):**

```text
Defender Antivirus Verification - 11/15/2026 14:39:18


MAPSReporting             : 1
CloudBlockLevel           : 2
SubmitSamplesConsent      : 1
PUAProtection             : 1
DisableRealtimeMonitoring : False
DisableBehaviorMonitoring : False
DisableScriptScanning     : False
DisableArchiveScanning    : False
DisableIOAVProtection     : False
EnableNetworkProtection   : 0
```

### 7. ASR configuration and audit review

*Intune ASR policy reports one successful device*

![Intune ASR policy reports one successful device](evidence/31_Defender_ASR_Policy_Deployment.png)

*Vulnerable signed drivers Block; Adobe Reader child processes Audit*

![Vulnerable signed drivers Block; Adobe Reader child processes Audit](evidence/35_ASR_Vulnerable_Drivers_Block.png)

*LSASS credential protection shown in Audit mode*

![LSASS credential protection shown in Audit mode](evidence/36_ASR_LSASS_Audit.png)

*Controlled Folder Access selected as Audit Mode*

![Controlled Folder Access selected as Audit Mode](evidence/42_Controlled_Folder_Access_Audit.png)

**Recorded output — [33_Defender_ASR_Configuration_Verification.txt](evidence/33_Defender_ASR_Configuration_Verification.txt):**

```text
ASR Verification - 11/15/2026 15:02:36
01443614-cd74-433a-b99e-2ecdc07bfc25 : 2
26190899-1602-49e8-8b27-eb1d0a1ce869 : 2
33ddedf1-c6e0-47cb-833e-de6133960387 : 2
3B576869-A4EC-4529-8536-B80A7769E899 : 2
56a863a9-875e-4185-98a7-b882c64b5ce5 : 1
5BEB7EFE-FD9A-4556-801D-275E5FFC04CC : 2
75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84 : 2
7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c : 2
92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B : 2
9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2 : 2
b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4 : 2
BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 : 2
c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb : 2
c1db55ab-c21a-4637-bb3f-a12568109d35 : 2
d1e49aac-8f56-4280-b9ba-993a6d77406c : 2
D3E037E1-3EB8-44C8-A917-57927947596D : 2
D4F940AB-401B-4EFC-AADC-AD5F3C50688A : 2
e6db77e5-3df2-4cf1-b95a-636979351e5b : 2
Controlled Folder Access: 2
```

*Ten returned audit events; query was limited to the latest ten matches*

![Ten returned audit events; query was limited to the latest ten matches](evidence/34_Defender_ASR_Audit_Events.png)

The screenshot query was limited to ten matching events. It does not establish the total number of events or a monitoring window. **ASR-01 remains Under Review**; audit telemetry is not proof of compromise. The sensitive raw event export is not published.

## Security findings

| ID | Status | Observation | Next step |
| --- | --- | --- | --- |
| BL-01 | **OPEN** | No recovery key found in Entra portal | Verify a supported recovery/escrow workflow and authorized retrieval; do not infer absence everywhere |
| ASR-01 | **Under Review** | LSASS protection audit activity requires contextual review | Review legitimate behavior and compatibility before staged enforcement decisions |

See [evidence, impact, remediation, and closure criteria](docs/SECURITY_FINDINGS.md) and the [remediation tracker](remediation/README.md).

## Read-only verification

Run the [verification script](scripts/verify-endpoint-security.ps1) in **64-bit Windows PowerShell 5.1 as administrator on the lab endpoint**:

```powershell
.\scripts\verify-endpoint-security.ps1 | ConvertTo-Json -Depth 6
```

The script returns selected properties to the console. It does not change settings, write files, contact cloud services, or output recovery passwords, protector IDs, tenant IDs, or device IDs. BitLocker protector **types only** are projected. Local administrator names can identify users or domains: review output before sharing. Errors expose only a check name and exception type, not raw error text.

The JSON is displayed in the console, not saved or uploaded. The script cannot establish cloud escrow, Intune deployment, or compliance status. **Endpoint execution of this new script is not claimed**; previously supplied observations were not produced by it. Repository verification passed Windows PowerShell 5.1 syntax parsing, parsing of the six PowerShell examples, relative Markdown link/anchor checks, and whitespace checks. These are authoring checks, not endpoint security test results.

## Framework context

| NIST SP 800-53 Rev. 5 | Relevant project context |
| --- | --- |
| AC-2 — Account Management | Local administrator review and account property remediation |
| CM-6 — Configuration Settings | Documented settings and verification |
| SI-3 — Malicious Code Protection | Defender AV preferences |
| SI-4 — System Monitoring | ASR audit telemetry review |
| SC-28 — Protection of Information at Rest | BitLocker state and recovery considerations |

These mappings provide context only, not complete control implementation or a claim of NIST compliance.

## Limitations and lessons learned

- A single Hyper-V lab device is not a production deployment or representative fleet sample.
- MDM enrollment does not establish Entra join or compatibility with every identity-dependent policy.
- Successful deployment and Compliant status require separate local verification and risk review.
- Encryption does not demonstrate recoverability; portal visibility does not establish every recovery location.
- Audit telemetry does not demonstrate blocking or compromise.
- PasswordRequired True is a local property change, not proof of password strength or central policy enforcement.
- Network Protection remained disabled; no enabling change or additional finding is invented.
- No recovery exercise, malware execution, ASR block-mode rollout, Conditional Access enforcement, or production incident response is claimed.

## Documentation and evidence

| Resource | Contents |
| --- | --- |
| [Architecture](docs/ARCHITECTURE.md) | Trust boundaries and enrollment limitations |
| [Implementation](docs/IMPLEMENTATION.md) | Recorded configuration and validation procedures |
| [Security findings](docs/SECURITY_FINDINGS.md) | BL-01 and ASR-01 |
| [Evidence index](docs/EVIDENCE_INDEX.md) | Published filenames, descriptions, and screenshot treatment |
| [Remediation tracker](remediation/README.md) | Status and closure requirements |
| [Evidence instructions](evidence/README.md) | Sanitization and publication requirements |

The evidence index lists the actual published files. Images are original lab captures, with cropping or solid redaction where needed; no screenshots were generated or reconstructed.

## Technical references

- [Microsoft: Windows MDM enrollment](https://learn.microsoft.com/en-us/windows/client-management/mdm-enrollment-of-windows-devices).
- [Microsoft: ASR rule reference](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference).
- [Microsoft: ASR events](https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-windows-events), including Event ID 1122 audit activity.
- [NIST SP 800-53 Rev. 5](https://doi.org/10.6028/NIST.SP.800-53r5).

## Author

**Musah Issah** · Cybersecurity · Information Assurance · Governance, Risk & Compliance

[GitHub](https://github.com/MusahIssah)

*Educational lab. No recovery keys, passwords, tenant IDs, device IDs, sensitive raw logs, or backups are published.*
