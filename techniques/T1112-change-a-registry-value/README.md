# T1112 — Modify Registry

**Import a one-value registry file with reg import, then delete it.**

| | |
| --- | --- |
| ATT&CK technique | [T1112](https://attack.mitre.org/techniques/T1112/) — Modify Registry |
| Seen in the wild | APT41 |
| Source for that | MITRE ATT&CK Procedure Examples (T1112) - https://attack.mitre.org/techniques/T1112/ |
| Difficulty | moderate |
| Criticality | high |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. The script creates one key with one value under your own user hive — a key that did not exist before — and one small file in your own temp folder. The last two lines delete exactly those two things. No machine-wide setting is touched, nothing existing is overwritten, and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Potential Suspicious Registry File Imported Via Reg.EXE** (level: medium).
It reads `process_creation` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for registry values arriving from a file in a temp folder. Good — an intruder wiring up persistence or quietly changing a setting would look the same. On to the next one.

**If nothing fired:** The value was written unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged `reg import` from a user-writable path — note that the same value can be written straight from a command line or from a script with no `reg.exe` at all, which this rule does not see, so pair it with a rule on the registry write itself.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_reg_import_from_suspicious_paths.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_reg_import_from_suspicious_paths.yml)
- Sigma id: `62e0298b-e994-4189-bc87-bc699aa62d97`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `474ae988dc5006ac83411276e80eebe57e4a518dedf497c457f1359bac3abf17`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/change-a-registry-value/](https://cyray.io/test-your-soc/change-a-registry-value/)
