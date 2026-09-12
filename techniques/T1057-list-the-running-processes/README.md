# T1057 — Process Discovery

**Pipe tasklist into findstr to filter the running process list.**

| | |
| --- | --- |
| ATT&CK technique | [T1057](https://attack.mitre.org/techniques/T1057/) — Process Discovery |
| Seen in the wild | Akira |
| Source for that | MITRE ATT&CK Procedure Examples (T1057) - https://attack.mitre.org/techniques/T1057/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. Both halves of the line are read-only: one lists the running processes, the other filters that text. Nothing is created, changed or deleted, so there is nothing to undo and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Recon Command Output Piped To Findstr.EXE** (level: medium).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for recon output being piped into a filter. Good — you would see an intruder asking what is running before they act on the answer. On to the next one.

**If nothing fired:** The process listing went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged the piped recon command — note that this rule keys on the pipe appearing on one command line, so an attacker who runs the two commands separately, or reads the process list through an API instead, is a quieter path worth a second rule.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_findstr_recon_pipe_output.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_findstr_recon_pipe_output.yml)
- Sigma id: `ccb5742c-c248-4982-8c5c-5571b9275ad3`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `7dbffbfce7eb80aab5c87dd87f9dfde9a20b69b51a391ac5081de0b189b7d480`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/list-the-running-processes/](https://cyray.io/test-your-soc/list-the-running-processes/)
