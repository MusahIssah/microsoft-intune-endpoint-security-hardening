# Lab Architecture and Trust Boundaries

[Overview](../README.md) · [Implementation](IMPLEMENTATION.md)

## Environment

BT-WIN11-01 is a Windows 11 Hyper-V VM managed through Intune MDM-only enrollment. It is not Entra joined; no additional registration state is asserted. The architecture diagram in the [overview](../README.md#architecture) represents logical relationships, not a complete network topology.

| Boundary | Security relevance | Assessment limit |
| --- | --- | --- |
| Administrator → cloud management | Authorized configuration and review | Administrative roles and authentication controls not supplied |
| Intune → guest MDM client | Policy delivery and reporting depend on connectivity | Check-in alone does not prove effective controls |
| Hyper-V host → guest | Virtual networking and platform services affect guest behavior | Host hardening, virtual switch settings, and host security not assessed |
| Local user → administrator | Administrative membership allows sensitive local changes | BTLabAdmin membership verified; least-privilege redesign not completed |
| Encryption → recovery custody | Protection and authorized recovery are separate requirements | Encryption verified; recovery visibility unresolved |
| Guest telemetry → public repository | Evidence may expose identities and secrets | Publish only sanitized images and summaries |

## Enrollment limitations

MDM management and Entra join are distinct. This lab does not establish Entra join, identity-dependent policy compatibility, or a working recovery-key escrow path. See [Microsoft's Windows MDM enrollment guidance](https://learn.microsoft.com/en-us/windows/client-management/mdm-enrollment-of-windows-devices).

Centralized local group membership policy was **not deployed**, pending MDM-only compatibility review. This is a project decision, not a blanket claim that every group management capability is unsupported in every MDM-only scenario. Review current prerequisites for the exact policy before deployment.

The BTLabAdmin PasswordRequired change was local. No centralized membership enforcement, Entra join migration, Windows LAPS deployment, or Conditional Access enforcement is established. Guest Secure Boot and TPM observations do not establish host security.

## Connectivity timeline

1. VM internet connectivity was lost; sync failed with `0x80072ee7`.
2. Connectivity was restored.
3. Sync succeeded November 15, 2026 at 9:46 AM; Intune check-in updated. Source time zone not supplied.

No outage duration, exact network repair commands, or security incident is inferred. No tenant IDs, device IDs, subnets, or additional infrastructure details are documented.
