# T1016 — System Network Configuration Discovery

**Run ipconfig /all, arp -a and route print.**

| | |
| --- | --- |
| ATT&CK technique | [T1016](https://attack.mitre.org/techniques/T1016/) — System Network Configuration Discovery |
| Seen in the wild | Lazarus Group |
| Source for that | MITRE ATT&CK Procedure Examples (T1016) - https://attack.mitre.org/techniques/T1016/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. All three lines only print settings this machine already holds. Nothing is created, changed or deleted, so there is nothing to undo and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Suspicious Network Command** (level: low).
It reads `process_creation` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches the network-configuration lookups. Good — you would see an intruder drawing the map in the minutes before they used it. On to the next one.

**If nothing fired:** The map got drawn unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged one of the discovery commands — note that a single lookup is often a genuine help-desk call, so the catch worth tuning for is several of them together, or one launched by a parent that has no business asking.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_susp_network_command.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_susp_network_command.yml)
- Sigma id: `a29c1813-ab1f-4dde-b489-330b952e91ae`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `ea9b3d15a8419787940b14991faf715c0dd05628c311e18ac9d1558e7fbe120d`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/read-the-network-layout/](https://cyray.io/test-your-soc/read-the-network-layout/)
