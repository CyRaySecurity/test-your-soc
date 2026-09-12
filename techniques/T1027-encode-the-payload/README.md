# T1027 — Obfuscated Files or Information

**Encode a harmless file to base64 with certutil, then delete both.**

| | |
| --- | --- |
| ATT&CK technique | [T1027](https://attack.mitre.org/techniques/T1027/) — Obfuscated Files or Information |
| Seen in the wild | Kimsuky |
| Source for that | MITRE ATT&CK Procedure Examples (T1027) - https://attack.mitre.org/techniques/T1027/ |
| Difficulty | moderate |
| Criticality | high |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. The script creates two files in your own temp folder — a plain sentence and its base64 form — and the last line deletes exactly those two. Nothing is downloaded, nothing is executed, nothing existing is touched, and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **File Encoded To Base64 Via Certutil.EXE** (level: medium).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for a built-in utility being used to encode files. Good — you would see a payload being wrapped, or data being prepared to leave. On to the next one.

**If nothing fired:** The encoding passed unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged `certutil` encoding a file — note that legitimate certificate work uses the same flag, so the valuable version of this rule looks at what was encoded and where it came from, not just that encoding happened.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_certutil_encode.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_certutil_encode.yml)
- Sigma id: `e62a9f0c-ca1e-46b2-85d5-a6da77f86d1a`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `7772ab83ef885b07904dbcc7824ce86d2a907fa9eec9c95861251cae02ab9e76`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/encode-the-payload/](https://cyray.io/test-your-soc/encode-the-payload/)
