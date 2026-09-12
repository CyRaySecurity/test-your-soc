# T1053.005 — Scheduled Task/Job: Scheduled Task

**Create a harmless scheduled task with schtasks, then delete it.**

| | |
| --- | --- |
| ATT&CK technique | [T1053.005](https://attack.mitre.org/techniques/T1053/005/) — Scheduled Task/Job: Scheduled Task |
| Seen in the wild | APT29 |
| Source for that | MITRE ATT&CK Procedure Examples (T1053.005) - https://attack.mitre.org/techniques/T1053/005/ |
| Difficulty | moderate |
| Criticality | high |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. The task does nothing but exit, runs as your own account (no admin), and the final line deletes exactly the task the script created. Nothing else on the machine is touched.

## What should fire

`detection.yml` in this folder is the rule: **Scheduled Task Creation Via Schtasks.EXE** (level: low).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for new scheduled tasks. Good — an intruder wiring up persistence would show up the same way. On to the next one.

**If nothing fired:** The new task appeared unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is process-creation logging on at all?** Windows Security event 4688 with command-line
   auditing enabled, or Sysmon event 1. Without the command line in the event, a rule that keys
   on command-line text can never match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** This rule keys on `Image`, `CommandLine`, `User`, `ParentImage`.
   Platforms rename those. Map the Sigma field names in `detection.yml` to whatever yours calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged `schtasks /create` — note that a task created from an XML file or through the Task Scheduler API is a quieter path some rules miss, so treat this as one door of several.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_schtasks_creation.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_schtasks_creation.yml)
- Sigma id: `92626ddd-662c-49e3-ac59-f6535f12d189`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `2f8ca8539179e6851171dd23f0d2e5a690e59b30d949aa6e29d04e7b33f82227`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/scheduled-task-creation/](https://cyray.io/test-your-soc/scheduled-task-creation/)
