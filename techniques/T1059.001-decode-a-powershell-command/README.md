# T1059.001 — Command and Scripting Interpreter: PowerShell

**Run a PowerShell command line that decodes its own base64 string.**

| | |
| --- | --- |
| ATT&CK technique | [T1059.001](https://attack.mitre.org/techniques/T1059/001/) — Command and Scripting Interpreter: PowerShell |
| Seen in the wild | Turla |
| Source for that | MITRE ATT&CK Procedure Examples (T1059.001) - https://attack.mitre.org/techniques/T1059/001/ |
| Difficulty | easy |
| Criticality | high |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. The encoded string decodes to three plain letters, which are printed and nothing more. Nothing is downloaded, written to disk, installed or changed, so there is nothing to undo and no admin rights are needed. `-NoProfile` means your own PowerShell profile is not loaded either.

## What should fire

`detection.yml` in this folder is the rule: **Base64 Encoded PowerShell Command Detected** (level: high).
It reads `process_creation` events on windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for command lines that decode their own contents. Good — an attacker pasting an encoded script into a foothold would surface the same way. On to the next one.

**If nothing fired:** The self-decoding command ran unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged the decoding call on the command line — note that legitimate automation sometimes decodes strings too, and that an attacker can obfuscate the decoding call itself, so this rule is a floor rather than a ceiling. Script block logging is what gets you the decoded contents.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_powershell_frombase64string.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_powershell_frombase64string.yml)
- Sigma id: `e32d4572-9826-4738-b651-95fa63747e8a`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `1c3d9cf80c8c1641405ae62d2bcf9c5cc579bb8bbb7ffee010b88aea0750fbef`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/decode-a-powershell-command/](https://cyray.io/test-your-soc/decode-a-powershell-command/)
