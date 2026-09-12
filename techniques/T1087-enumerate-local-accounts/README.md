# T1087 — Account Discovery

**Run net user and whoami /all to list local accounts.**

| | |
| --- | --- |
| ATT&CK technique | [T1087](https://attack.mitre.org/techniques/T1087/) — Account Discovery |
| Seen in the wild | Scattered Spider |
| Source for that | MITRE ATT&CK Procedure Examples (T1087) - https://attack.mitre.org/techniques/T1087/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. Every line is a read-only lookup — it lists accounts and prints your own privileges. Nothing is created, changed or deleted, so there is nothing to undo and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Local Accounts Discovery** (level: low).
It reads `process_creation` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches account-enumeration utilities. Good — you would see an intruder drawing the same map, in the minutes before they act on it. On to the next one.

**If nothing fired:** The enumeration went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below is exactly what to hand them to close it.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is process-creation logging on at all?** Windows Security event 4688 with command-line
   auditing enabled, or Sysmon event 1. Without the command line in the event, a rule that keys
   on command-line text can never match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** Vendors rename `CommandLine` and `Image`. Map the
   Sigma field names in `detection.yml` to whatever your platform calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged `net`/`whoami` account enumeration — note that a single lookup can be ordinary admin activity, so a good rule watches for it running from an unexpected parent, which is the harder and more valuable catch.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_susp_local_system_owner_account_discovery.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_susp_local_system_owner_account_discovery.yml)
- Sigma id: `502b42de-4306-40b4-9596-6f590c81f073`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `ddb20029d804c7a434cc6600659aaac2b646b67cd150470e9b1ef4be47c16e06`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/enumerate-local-accounts/](https://cyray.io/test-your-soc/enumerate-local-accounts/)
