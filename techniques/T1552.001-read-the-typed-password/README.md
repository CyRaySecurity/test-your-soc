# T1552.001 — Unsecured Credentials: Credentials In Files

**Read the last lines of your own PowerShell console history.**

| | |
| --- | --- |
| ATT&CK technique | [T1552.001](https://attack.mitre.org/techniques/T1552/001/) — Unsecured Credentials: Credentials In Files |
| Seen in the wild | Fox Kitten |
| Source for that | MITRE ATT&CK Procedure Examples (T1552.001) - https://attack.mitre.org/techniques/T1552/001/ |
| Difficulty | easy |
| Criticality | high |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. Both lines are read-only and they read only your own account's history file. Nothing is deleted, modified, copied off the machine or sent anywhere, so there is nothing to undo and no admin rights are needed. If you would rather not see the contents at all, run only the first line — locating the file is enough to test the detection.

## What should fire

`detection.yml` in this folder is the rule: **Potential PowerShell Console History Access Attempt via History File** (level: medium).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for the console history file being read. Good — you would see an intruder harvesting typed secrets before they used one. On to the next one.

**If nothing fired:** The file was read unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it. While you are here: whatever you saw in step two is worth rotating.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is process-creation logging on at all?** Windows Security event 4688 with command-line
   auditing enabled, or Sysmon event 1. Without the command line in the event, a rule that keys
   on command-line text can never match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** This rule keys on `CommandLine`.
   Platforms rename those. Map the Sigma field names in `detection.yml` to whatever yours calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged the history file being located or read from a command line — note that a file-access rule on the same path catches the quieter case where the file is opened without ever naming it on a command line, so the two rules are worth having together.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_powershell_console_history_file_access.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_powershell_console_history_file_access.yml)
- Sigma id: `f4ff7323-b5fc-4323-8b52-6b9408e15788`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `37e30936d9e4de3099c9502626204928f697d6eaea2a00f6a8e4ee5b2907e348`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/read-the-typed-password/](https://cyray.io/test-your-soc/read-the-typed-password/)
