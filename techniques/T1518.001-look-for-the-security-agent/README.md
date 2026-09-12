# T1518.001 — Software Discovery: Security Software Discovery

**Filter the process list for the name of a security product.**

| | |
| --- | --- |
| ATT&CK technique | [T1518.001](https://attack.mitre.org/techniques/T1518/001/) — Software Discovery: Security Software Discovery |
| Seen in the wild | MuddyWater |
| Source for that | MITRE ATT&CK Procedure Examples (T1518.001) - https://attack.mitre.org/techniques/T1518/001/ |
| Difficulty | easy |
| Criticality | medium |
| Operating system | Windows |

## Run it

```powershell
.\run.ps1
```

Run it on a machine you own, in a PowerShell window running as your ordinary account.
No administrator rights are needed. The line lists the running processes and filters that text for a keyword. It touches no security product, changes no setting and disables nothing — it only looks. Nothing is created, changed or deleted, and no admin rights are needed.

## What should fire

`detection.yml` in this folder is the rule: **Security Tools Keyword Lookup Via Findstr.EXE** (level: medium).
It reads `process_creation` events on Windows — so your SIEM needs that telemetry before it can catch anything here.

**If something fired:** Your tooling watches for its own name being looked for. Good — you would see an intruder casing your defences before testing them. On to the next one.

**If nothing fired:** The check for your agent went unseen — now you know. Not a verdict on your team; a specific, fixable gap you just found in a minute. The detection below closes it.

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

"It fired" means your EDR flagged the security-product keyword on the command line — note that the rule matches a list of vendor keywords, so a name outside that list, or a lookup made through an API rather than a filter, is a quieter path worth extending the rule for.

## The detection

`detection.yml` is quoted verbatim from the SigmaHQ rule repository, under the
[Detection Rule License 1.1](https://github.com/SigmaHQ/Detection-Rule-License). It is not modified here.

- Rule: [`proc_creation_win_findstr_security_keyword_lookup.yml`](https://github.com/SigmaHQ/sigma/blob/master/rules/windows/process_creation/proc_creation_win_findstr_security_keyword_lookup.yml)
- Sigma id: `4fe074b4-b833-4081-8f24-7dcfeca72b42`
- Its authors are credited in the `author:` field of `detection.yml` itself, unchanged, as the licence requires.
- Retrieved 2026-09-11; file sha256 `30e29aa6bbab1d6335f15757e5a13620ca3d70ce2b3e3c8cf42ce28f3b3c6d59`

---

Full write-up, with the incident it comes from and how to read the result: [https://cyray.io/test-your-soc/look-for-the-security-agent/](https://cyray.io/test-your-soc/look-for-the-security-agent/)
