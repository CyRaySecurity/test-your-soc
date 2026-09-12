# T1018 — Remote System Discovery

**Run net view to enumerate reachable shares and sessions.**

| | |
| --- | --- |
| ATT&CK technique | [T1018](https://attack.mitre.org/techniques/T1018/) — Remote System Discovery |
| Seen in the wild | Conti |
| Source for that | MITRE ATT&CK Procedure Examples (T1018) - https://attack.mitre.org/techniques/T1018/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. Both lines only list what is already visible on the network — nothing is created, mounted, changed or deleted. There is nothing to undo and no admin rights are needed. If the command returns an error (a modern box often answers `net view` with error 6118), the test is still valid — the detection watches the command running, not what it prints.

## What should fire

`detection.yml` in this folder is the rule: **Share And Session Enumeration Using Net.EXE** (level: low).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches network enumeration. Good — you would see an intruder counting the doors before they walk through one. On to the next one.

**If nothing fired:** The sweep went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

## If nothing fired — what to check in your own SIEM

Work down this list before concluding the rule is missing:

1. **Is process-creation logging on at all?** Windows Security event 4688 with command-line
   auditing enabled, or Sysmon event 1. Without the command line in the event, a rule that keys
   on command-line text can never match.
2. **Is the endpoint you tested on actually shipping logs?** Search your SIEM for *any* event from
   that machine in the last 15 minutes. A silent rule and a silent agent look identical.
3. **Did the event arrive but the rule not run?** Search for the raw event first — the command line,
   or the file path — then check whether a rule is enabled over it.
4. **Is the rule scoped to a different field name?** This rule keys on `Image`, `OriginalFileName`, `CommandLine`.
   Platforms rename those. Map the Sigma field names in `detection.yml` to whatever yours calls them.
5. **Is it firing but suppressed?** Check exclusions, tuning rules and alert-suppression windows —
   a detection that is throttled to nothing is indistinguishable from one that does not exist.

## Reading the result honestly

"It fired" means your EDR flagged `net view` enumeration — note that a targeted `net view \\<one-host>` is a narrower action many rules deliberately ignore, so the catch here is the broad sweep.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_net_view_share_and_sessions_enum.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_net_view_share_and_sessions_enum.yml)
- Sigma id: `62510e69-616b-4078-b371-847da438cc03`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `46d7533fce00b99829f510a7b9f464315b6b1bf1316c951e016cf8cd54200a1f`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/enumerate-shares-and-sessions/](https://cyray.io/test-your-soc/enumerate-shares-and-sessions/)
