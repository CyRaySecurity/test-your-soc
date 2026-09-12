# T1082 — System Information Discovery

**Run systeminfo to read the machine's full specification.**

| | |
| --- | --- |
| ATT&CK technique | [T1082](https://attack.mitre.org/techniques/T1082/) — System Information Discovery |
| Seen in the wild | Black Basta |
| Source for that | MITRE ATT&CK Procedure Examples (T1082) - https://attack.mitre.org/techniques/T1082/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. One read-only command that prints the machine's own specification. Nothing is created, changed or deleted, so there is nothing to undo and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Suspicious Execution of Systeminfo** (level: low).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for machines being inventoried. Good — an intruder sizing up a box would surface the same way. On to the next one.

**If nothing fired:** The inventory passed unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below is exactly what to hand them to close it.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is process-creation logging on at all?** Windows Security event 4688 with command-line
   auditing enabled, or Sysmon event 1. Without the command line in the event, a rule that keys
   on command-line text can never match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** This rule keys on `Image`, `OriginalFileName`.
   Platforms rename those. Map the Sigma field names in `detection.yml` to whatever yours calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged `systeminfo` running — note that a lone run is often legitimate, so the valuable catch is `systeminfo` launched by an unexpected parent, or alongside other discovery commands in the same minute.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_systeminfo_execution.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_systeminfo_execution.yml)
- Sigma id: `0ef56343-059e-4cb6-adc1-4c3c967c5e46`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `932bbd8e70ad177d6de617aee50942dec1264453e89dcd3ca84aca65c771920f`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/inventory-the-machine/](https://cyray.io/test-your-soc/inventory-the-machine/)
