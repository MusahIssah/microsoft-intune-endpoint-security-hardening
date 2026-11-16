# Evidence Index

[Overview](../README.md) · [Publication instructions](../evidence/README.md)

**Publication status: no actual screenshots or raw logs supplied for this repository.** All filenames below are proposed locations, not existing artifacts or completed captures. They are plain code text intentionally, so the documentation has no broken image links. The lab observations are author supplied; independent reviewers cannot yet inspect the underlying screenshots.

| ID | Proposed screenshot location | Intended explanation | Status |
| --- | --- | --- | --- |
| E01 | `evidence/01_mdm_enrollment_scope.png` | MDM-only management scope; avoid exposing enrollment or tenant identifiers | Pending sanitized capture |
| E02 | `evidence/02_sync_and_checkin.png` | Successful November 15, 2026 9:46 AM sync and updated Intune check-in; do not invent an error screenshot | Pending sanitized capture |
| E03 | `evidence/03_bitlocker_state.png` | C: status, percentage, method, protection, and protector types only | Pending sanitized capture |
| E04 | `evidence/04_recovery_portal_observation.png` | Portal view supporting no key found; no recovery secrets or identifiers | Pending sanitized capture |
| E05 | `evidence/05_firewall_state_and_deployment.png` | All three profiles, inbound/outbound defaults, blocked logging, Intune success | Pending sanitized capture |
| E06 | `evidence/06_local_account_validation.png` | Built-in Administrator disabled; BTLabAdmin membership and current PasswordRequired True | Pending sanitized capture |
| E07 | `evidence/07_six_compliance_controls.png` | Six named controls reported Compliant | Pending sanitized capture |
| E08 | `evidence/08_platform_and_defender_status.png` | Secure Boot, four TPM properties, Defender AV/antispyware/real-time status | Pending sanitized capture |
| E09 | `evidence/09_defender_preferences_and_deployment.png` | Reported preferences and successful Intune AV deployment | Pending sanitized capture |
| E10 | `evidence/10_asr_settings_and_deployment.png` | 18 rules: 1 Block, 17 Audit; CFA Audit; successful ASR deployment | Pending sanitized capture |
| E11 | `evidence/11_asr_audit_summary.png` | Sanitized summary: ten recorded 1122 events, LSASS rule, svchost.exe/lsass.exe; window not supplied | Pending sanitized capture |

Multiple sanitized images may be needed for a row. Update the index to match actual filenames when evidence is available. Do not recreate historical screens, add a before-state that was not captured, or imply current captures prove past state. For E06, the reported False → True history remains an author observation unless historical evidence is available.

Keep collection date, relevant device context, source (portal or local), and observation window when known. Do not invent missing timestamps or use the planned filename as proof that a test ran. Add inline images to the matching implementation sections only after sanitized files actually exist.
