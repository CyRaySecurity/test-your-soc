# T1049 — System Network Connections Discovery

**Run net use to list connections this machine already holds.**

| | |
| --- | --- |
| ATT&CK technique | [T1049](https://attack.mitre.org/techniques/T1049/) — System Network Connections Discovery |
| Seen in the wild | Volt Typhoon |
| Source for that | MITRE ATT&CK Procedure Examples (T1049) - https://attack.mitre.org/techniques/T1049/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. `net use` with no arguments only prints the connections that already exist — it creates, mounts and removes nothing. There is nothing to undo and no admin rights are needed. If the list comes back empty, the test is still valid: the detection watches the command running, not what it prints.

## What should fire

`detection.yml` in this folder is the rule: **System Network Connections Discovery Via Net.EXE** (level: low).
It reads `process_creation` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for connection enumeration. Good — you would see an intruder reading the shortlist before they used it. On to the next one.

**If nothing fired:** The enumeration went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged `net use` — note that the same question can be asked with `netstat` or from PowerShell, which this rule does not cover, so treat it as one door of several.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_net_use_network_connections_discovery.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_net_use_network_connections_discovery.yml)
- Sigma id: `1c67a717-32ba-409b-a45d-0fb704a73a81`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `587ddac96c64ddbb4b51f3a80060faadeb7b1aef1d817de092786e06be0f4fd8`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/count-the-live-connections/](https://cyray.io/test-your-soc/count-the-live-connections/)
