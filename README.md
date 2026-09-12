# Test your SOC

One real attacker technique per folder: a safe command you can run on a machine you own, and
the detection rule that catches it. Run one, look at your own alerts, and find out whether your
SOC would have seen it.

These are the scripts behind the **Test your SOC** series at
[cyray.io/test-your-soc](https://cyray.io/test-your-soc/). Each folder here holds the same command
the page publishes, the same Sigma rule, and notes on what to check if nothing fires.

## Safety

**Run these only on a machine you own or are authorised to test.** Every command in this repository
is safe and reversible: each one runs as your ordinary account with no administrator rights, and it
either changes nothing at all or creates one clearly named artifact that the same script then deletes.
Nothing is downloaded, nothing is installed, nothing persists after the script ends, and nothing is
sent anywhere — these scripts contact no CyRay service and collect no information about you or your
machine. They are ordinary built-in Windows commands; the point is not what they do, it is whether
your monitoring notices them. Read the script before you run it — that is true here and everywhere.

## The techniques

| ID | Technique | Difficulty | Criticality | OS | Read the page |
| --- | --- | --- | --- | --- | --- |
| [T1070.003](techniques/T1070.003-erase-the-trail/) | [Indicator Removal: Clear Command History](techniques/T1070.003-erase-the-trail/) | hard | critical | Windows | [cyray.io](https://cyray.io/test-your-soc/erase-the-trail/) |
| [T1087](techniques/T1087-enumerate-local-accounts/) | [Account Discovery](techniques/T1087-enumerate-local-accounts/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/enumerate-local-accounts/) |
| [T1018](techniques/T1018-enumerate-shares-and-sessions/) | [Remote System Discovery](techniques/T1018-enumerate-shares-and-sessions/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/enumerate-shares-and-sessions/) |
| [T1053.005](techniques/T1053.005-scheduled-task-creation/) | [Scheduled Task/Job: Scheduled Task](techniques/T1053.005-scheduled-task-creation/) | moderate | high | Windows | [cyray.io](https://cyray.io/test-your-soc/scheduled-task-creation/) |
| [T1082](techniques/T1082-inventory-the-machine/) | [System Information Discovery](techniques/T1082-inventory-the-machine/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/inventory-the-machine/) |
| [T1057](techniques/T1057-list-the-running-processes/) | [Process Discovery](techniques/T1057-list-the-running-processes/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/list-the-running-processes/) |
| [T1049](techniques/T1049-count-the-live-connections/) | [System Network Connections Discovery](techniques/T1049-count-the-live-connections/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/count-the-live-connections/) |
| [T1016](techniques/T1016-read-the-network-layout/) | [System Network Configuration Discovery](techniques/T1016-read-the-network-layout/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/read-the-network-layout/) |
| [T1518.001](techniques/T1518.001-look-for-the-security-agent/) | [Software Discovery: Security Software Discovery](techniques/T1518.001-look-for-the-security-agent/) | easy | medium | Windows | [cyray.io](https://cyray.io/test-your-soc/look-for-the-security-agent/) |
| [T1112](techniques/T1112-change-a-registry-value/) | [Modify Registry](techniques/T1112-change-a-registry-value/) | moderate | high | Windows | [cyray.io](https://cyray.io/test-your-soc/change-a-registry-value/) |
| [T1027](techniques/T1027-encode-the-payload/) | [Obfuscated Files or Information](techniques/T1027-encode-the-payload/) | moderate | high | Windows | [cyray.io](https://cyray.io/test-your-soc/encode-the-payload/) |
| [T1059.001](techniques/T1059.001-decode-a-powershell-command/) | [Command and Scripting Interpreter: PowerShell](techniques/T1059.001-decode-a-powershell-command/) | easy | high | Windows | [cyray.io](https://cyray.io/test-your-soc/decode-a-powershell-command/) |
| [T1552.001](techniques/T1552.001-read-the-typed-password/) | [Unsecured Credentials: Credentials In Files](techniques/T1552.001-read-the-typed-password/) | easy | high | Windows | [cyray.io](https://cyray.io/test-your-soc/read-the-typed-password/) |

## What is in each folder

| File | What it is |
| --- | --- |
| `run.ps1` | The command itself, with a header saying what it does and what it does not do. |
| `detection.yml` | The detection, in [Sigma](https://github.com/SigmaHQ/sigma) — the open, vendor-neutral format. Hand it to your detection team. |
| `README.md` | What should fire, and what to check in your own SIEM if nothing did. |

## Licence and credit

The scripts and the write-ups in this repository are MIT licensed — see [LICENSE](LICENSE).

The detection rules are not ours to relicense. 12 of the 13 `detection.yml` files are quoted
verbatim from the [SigmaHQ rule repository](https://github.com/SigmaHQ/sigma) under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License), unmodified, each crediting
its own author in the rule text as the licence requires.

The other 1 (`T1070.003-erase-the-trail`) is written by CyRay,
not taken from SigmaHQ, and carries no SigmaHQ attribution — claiming one where none exists
would be worse than claiming none.

ATT&CK technique names and ids are from [MITRE ATT&CK](https://attack.mitre.org/).
