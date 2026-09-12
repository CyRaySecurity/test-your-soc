# T1070.003 — Indicator Removal: Clear Command History

**Delete your own PowerShell history file, then check your alerts.**

| | |
| --- | --- |
| ATT&CK technique | [T1070.003](https://attack.mitre.org/techniques/T1070/003/) — Indicator Removal: Clear Command History |
| Seen in the wild | Medusa |
| Source for that | CISA #StopRansomware: Medusa (AA25-071A) - https://www.cisa.gov/news-events/cybersecurity-advisories/aa25-071a |
| Difficulty | hard |
| Criticality | critical |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. It deletes only your own PowerShell history file — the same file Windows recreates the next time you open PowerShell. No admin rights, no payload, nothing downloaded, nothing to undo.

## What should fire

`detection.yml` in this folder is the rule: **PowerShell Console History File Deleted** (level: high).
It reads `file_delete` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** your tooling watches the PowerShell history file being deleted. Even an attacker who cleans up then leaves you the fact that they cleaned up — which is exactly the tripwire you want.

**If nothing fired:** the deletion went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The rule in `detection.yml` is what to hand them to close it.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is file-deletion logging on at all?** Sysmon event 23 / 26, or an EDR that reports file
   deletes. Without it there is no event for this rule to match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** Vendors rename `CommandLine` and `Image`. Map the
   Sigma field names in `detection.yml` to whatever your platform calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged the history file being deleted — note that clearing only the
in-memory history is a quieter action many rules will not catch. And a lab is not production: a
test box often logs differently from the real fleet. Treat a pass as a reason to go and check
production, not as a finish line.

## The detection

`detection.yml` for this technique is written by CyRay rather than taken from SigmaHQ, because the
behaviour is a file deletion rather than a process launch. It is expressed in Sigma so any team can
translate it into whatever they run. Public vendor equivalents:

- Elastic: [Clearing Windows Console History](https://www.elastic.co/docs/reference/security/prebuilt-rules/rules/windows/defense_evasion_clearing_windows_console_history)
- Splunk: [ConsoleHost History File Deletion](https://research.splunk.com/endpoint/a203040e-f8fd-49bb-8424-d2fabf277322/)

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/erase-the-trail/](https://cyray.io/test-your-soc/erase-the-trail/)
