# =============================================================================
#  Test your SOC - T1070.003  Indicator Removal: Clear Command History
# =============================================================================
#  WHAT IT DOES:      Delete your own PowerShell history file, then check
#                     your alerts.
#  WHY:               this is the move Medusa is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     It deletes only your own PowerShell history file —
#                     the same file Windows recreates the next time you
#                     open PowerShell. No admin rights, no payload, nothing
#                     downloaded, nothing to undo.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         PowerShell Console History File Deleted - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/erase-the-trail/
# =============================================================================

# TEST YOUR SOC — run on a machine you own. Safe: Windows recreates the file.
# STEP 1 — leave something in the history worth erasing.
whoami; Get-Process | Select-Object -First 1 | Out-Null

# STEP 2 — Medusa's exact move: delete the PowerShell history file on disk.
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force

# STEP 3 — open your SOC / EDR. Did anything alert on the deletion?
# Nothing to clean up. A new history file is created automatically.
