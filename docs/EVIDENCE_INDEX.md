# Evidence Index

[Overview](../README.md#evidence-walkthrough) · [Implementation](IMPLEMENTATION.md) · [Publication instructions](../evidence/README.md)

## Published artifacts

31 actual screenshots and 10 reviewed text exports are published. Nine screenshots were cropped and/or redacted using ordinary pixel operations; 22 were copied unchanged. The author approved sanitizing copies, and the source files were preserved outside the repository. No image generation or reconstructed screens were used.

The text exports contain selected security state, lab account details, or ASR rule settings; they are not output from the new repository collector. No sensitive raw event export, backup, recovery secret, tenant ID, or device ID is included. The ASR GUIDs are public rule identifiers.

| Evidence file | Section | What it demonstrates | Publication treatment |
| --- | --- | --- | --- |
| [01_Intune_Device_Enrollment_Status.png](../evidence/01_Intune_Device_Enrollment_Status.png) | Enrollment | Initial Intune device overview; historical check-in precedes sync recovery | Crop + solid redaction |
| [03_Work_School_Connection.png](../evidence/03_Work_School_Connection.png) | Enrollment | Windows management connection lists Defender and Security policies | Crop |
| [04_MDM_Synchronization_Status.png](../evidence/04_MDM_Synchronization_Status.png) | Enrollment | Sync failure 0x80072ee7 before connectivity restoration | Crop |
| [04_MDM_Synchronization_Success.png](../evidence/04_MDM_Synchronization_Success.png) | Enrollment | Successful sync on November 15, 2026 at 9:46:23 AM | Crop |
| [05_Intune_Device_CheckIn_Confirmed.png](../evidence/05_Intune_Device_CheckIn_Confirmed.png) | Enrollment | Intune check-in updated to November 15, 2026 at 9:46 AM | Crop + solid redaction |
| [08_Entra_Device_Registration_Status.png](../evidence/08_Entra_Device_Registration_Status.png) | Enrollment | Entra device properties show Intune MDM and a blank join-type field | Crop + solid redaction |
| [02_Windows11_Entra_Device_Status.txt](../evidence/02_Windows11_Entra_Device_Status.txt) | Enrollment | Local identity status reports AzureAdJoined NO | Reviewed text; UTF-8 normalized, values unchanged |
| [11_Intune_Firewall_Policy_Status.png](../evidence/11_Intune_Firewall_Policy_Status.png) | Firewall | Intune firewall policy reports one successful device | Reviewed image; unchanged |
| [12_Firewall_Device_Policy_Settings_Verified.png](../evidence/12_Firewall_Device_Policy_Settings_Verified.png) | Firewall | Visible firewall per-setting deployment results succeeded | Reviewed image; unchanged |
| [10_Defender_Firewall_Status.txt](../evidence/10_Defender_Firewall_Status.txt) | Firewall | Effective firewall settings for Domain, Private, and Public | Reviewed text; UTF-8 normalized, values unchanged |
| [06_BitLocker_Encryption_Status.txt](../evidence/06_BitLocker_Encryption_Status.txt) | BitLocker | C: encryption method, percentage, and protection state | Reviewed text; UTF-8 normalized, values unchanged |
| [07_BitLocker_Protector_Types.txt](../evidence/07_BitLocker_Protector_Types.txt) | BitLocker | Protector types only; no recovery password or protector ID | Reviewed text; UTF-8 normalized, values unchanged |
| [09_Entra_BitLocker_Key_Not_Found.png](../evidence/09_Entra_BitLocker_Key_Not_Found.png) | BitLocker | Portal reports no BitLocker recovery key found for the reviewed device | Crop |
| [15_Local_Admin_Password_Requirement_Before.png](../evidence/15_Local_Admin_Password_Requirement_Before.png) | Local accounts | Historical local BTLabAdmin Password required No | Crop; source named 15_Intune_Account_Protection_Baseline.png |
| [13_Local_Admin_Group_Membership.txt](../evidence/13_Local_Admin_Group_Membership.txt) | Local accounts | Local Administrators group membership | Reviewed text; UTF-8 normalized, values unchanged |
| [14_Local_Admin_Account_Status.txt](../evidence/14_Local_Admin_Account_Status.txt) | Local accounts | Built-in Administrator disabled; historical PasswordRequired state | Reviewed text; UTF-8 normalized, values unchanged |
| [16_Local_Admin_Password_Requirement_After.txt](../evidence/16_Local_Admin_Password_Requirement_After.txt) | Local accounts | Local validation after remediation: Password required Yes | Reviewed text; UTF-8 normalized, values unchanged |
| [17_Intune_Local_Group_Profile_Selected.png](../evidence/17_Intune_Local_Group_Profile_Selected.png) | Local accounts | Local user group membership profile selection; not deployment | Reviewed image; unchanged |
| [18_Local_Admin_Policy_Basics.png](../evidence/18_Local_Admin_Policy_Basics.png) | Local accounts | Draft local administrator policy name and description | Reviewed image; unchanged |
| [19_Local_Admin_Configuration_Before.png](../evidence/19_Local_Admin_Configuration_Before.png) | Local accounts | Draft group configuration before values were added | Reviewed image; unchanged |
| [20_Local_Admin_Policy_Compatibility_Review.png](../evidence/20_Local_Admin_Policy_Compatibility_Review.png) | Local accounts | Draft administrator group selection during compatibility review | Reviewed image; unchanged |
| [21_Intune_Compliance_Policy_Overview.png](../evidence/21_Intune_Compliance_Policy_Overview.png) | Compliance | Compliance policy editing overview | Reviewed image; unchanged |
| [22_Intune_Device_Health_Requirements.png](../evidence/22_Intune_Device_Health_Requirements.png) | Compliance | BitLocker and Secure Boot selected as required | Reviewed image; unchanged |
| [23_Intune_System_Security_Password.png](../evidence/23_Intune_System_Security_Password.png) | Compliance | Password settings shown as not configured; grey values are not enforcement evidence | Reviewed image; unchanged |
| [24_Intune_System_Security_Controls.png](../evidence/24_Intune_System_Security_Controls.png) | Compliance | Firewall, TPM, antivirus, and antispyware selected as required | Reviewed image; unchanged |
| [26_Intune_Device_Compliance_Results.png](../evidence/26_Intune_Device_Compliance_Results.png) | Compliance | All six evaluated controls reported Compliant | Reviewed image; unchanged |
| [25_Device_Security_Compliance_Verification.txt](../evidence/25_Device_Security_Compliance_Verification.txt) | Compliance | Independent Secure Boot, TPM, and Defender status | Reviewed text; UTF-8 normalized, values unchanged |
| [27_Intune_Configuration_Profiles.png](../evidence/27_Intune_Configuration_Profiles.png) | Defender AV | Inventory of firewall, AV, and ASR configuration profiles | Reviewed image; unchanged |
| [28_Defender_AV_Policy_Deployment.png](../evidence/28_Defender_AV_Policy_Deployment.png) | Defender AV | Intune AV policy reports one successful device | Reviewed image; unchanged |
| [30_Defender_AV_Configuration_Verification.txt](../evidence/30_Defender_AV_Configuration_Verification.txt) | Defender AV | Local Defender preferences including Network Protection disabled | Reviewed text; UTF-8 normalized, values unchanged |
| [31_Defender_ASR_Policy_Deployment.png](../evidence/31_Defender_ASR_Policy_Deployment.png) | ASR | Intune ASR policy reports one successful device | Reviewed image; unchanged |
| [33_Defender_ASR_Configuration_Verification.txt](../evidence/33_Defender_ASR_Configuration_Verification.txt) | ASR | 18 local ASR rule/action pairs and CFA value 2 | Reviewed text; UTF-8 normalized, values unchanged |
| [34_Defender_ASR_Audit_Events.png](../evidence/34_Defender_ASR_Audit_Events.png) | ASR | Ten returned audit events; query was limited to the latest ten matches | Crop |
| [35_ASR_Vulnerable_Drivers_Block.png](../evidence/35_ASR_Vulnerable_Drivers_Block.png) | ASR | Vulnerable signed drivers Block; Adobe Reader child processes Audit | Unchanged; source Screenshot 2026-11-15 144704.png |
| [36_ASR_LSASS_Audit.png](../evidence/36_ASR_LSASS_Audit.png) | ASR | LSASS credential protection shown in Audit mode | Unchanged; source Screenshot 2026-11-15 144747.png |
| [37_ASR_Executable_And_Script_Audit.png](../evidence/37_ASR_Executable_And_Script_Audit.png) | ASR | Executable reputation and obfuscated script rules in Audit | Unchanged; source Screenshot 2026-11-15 144819.png |
| [38_ASR_Script_And_Office_Audit.png](../evidence/38_ASR_Script_And_Office_Audit.png) | ASR | Script and Office executable creation rules in Audit | Unchanged; source Screenshot 2026-11-15 144848.png |
| [39_ASR_Office_And_WMI_Audit.png](../evidence/39_ASR_Office_And_WMI_Audit.png) | ASR | Office, WMI, and PSExec-related rules in Audit | Unchanged; source Screenshot 2026-11-15 144922.png |
| [40_ASR_USB_And_Macro_Audit.png](../evidence/40_ASR_USB_And_Macro_Audit.png) | ASR | USB and Office macro rules in Audit | Unchanged; source Screenshot 2026-11-15 144946.png |
| [41_ASR_Ransomware_And_System_Tools.png](../evidence/41_ASR_Ransomware_And_System_Tools.png) | ASR | Ransomware/system tool audit settings; server webshell rule not configured | Unchanged; source Screenshot 2026-11-15 145020.png |
| [42_Controlled_Folder_Access_Audit.png](../evidence/42_Controlled_Folder_Access_Audit.png) | ASR | Controlled Folder Access selected as Audit Mode | Unchanged; source Screenshot 2026-11-15 145107.png |

## Interpretation and provenance

- Filenames retain supplied names except the misleading local account screenshot and eight timestamp-named ASR captures, renamed as documented above. Their content is not represented as output from a new test.
- Enrollment crops exclude management account, serial, Exchange/enrollment identifier, and unrelated host details. Entra device/object ID values are covered with opaque pixels in the flattened copy.
- The local account and ASR event crops remove host window titles and unrelated desktop content. The recovery portal crop preserves the no-key-found message.
- The initial overview has an older check-in than the later confirmed check-in image; these represent different stages.
- The Entra properties view shows a blank join-type field and N/A compliance, not a new compliant-state claim. Local identity output supports not Entra joined; the six-control compliance result comes from Intune.
- Local group policy screenshots are drafts, not evidence of deployment. Disabled password fields in the compliance editor do not establish password enforcement.
- The ten returned ASR events are a query-limited sample. Their timestamps do not establish a defined collection window or all endpoint events. The private raw export was reviewed for the documented LSASS rule/process association but is not uploaded.
- The tiny source image `Screenshot 2026-11-15 144914.png` was excluded because it shows only a dropdown value without rule context.
- The raw ASR event text export, duplicate finding narrative, and original CSV remain outside the repository; the existing findings and sanitized remediation tracker carry their relevant status.

BL-01 remains OPEN and ASR-01 remains Under Review. No new endpoint test or remediation completion is inferred from publication.
