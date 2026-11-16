# Sanitized Remediation Tracker

[Overview](../README.md) · [Finding details and closure criteria](../docs/SECURITY_FINDINGS.md)

Statuses reflect supplied observations, not new work executed during repository authoring. Owners and due dates were not supplied and are not invented.

| Item | Recorded state / action | Status | Next evidence or decision |
| --- | --- | --- | --- |
| BL-01 | Encryption verified; no recovery key found in Entra portal | **OPEN** | Verify supported custody/escrow and authorized retrieval; satisfy documented closure criteria |
| ASR-01 | Ten LSASS-rule audit events; no incident conclusion | **Under Review** | Contextual review, compatibility assessment, approved disposition and validation |
| Local PasswordRequired property | BTLabAdmin False → True through local remediation | Locally remediated, author verified | [Before/after evidence published](../docs/IMPLEMENTATION.md#4-local-accounts); no central enforcement or password strength claim |
| Centralized administrator membership | Not deployed pending MDM-only compatibility review | Deferred / not deployed | Review exact policy prerequisites before deployment decision |
| VM connectivity | Internet restored after sync failure 0x80072ee7; sync succeeded November 15, 2026 at 9:46 AM; check-in updated | Resolved in supplied lab observation | [Sync evidence published](../docs/IMPLEMENTATION.md#1-enrollment-and-connectivity); source time zone unspecified |
| Network Protection | EnableNetworkProtection = 0, disabled | Observed; no remediation claimed | Assess intended requirements separately; no approved change supplied |

Do not mark BL-01 closed merely because BitLocker is Compliant. Do not mark ASR-01 remediated merely because deployment succeeded. Record actual completion dates, validation, and residual-risk decisions only after the corresponding work occurs. No credentials, raw logs, tenant/device IDs, recovery material, or backups belong in this tracker.
