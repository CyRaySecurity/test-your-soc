# =============================================================================
#  Test your SOC - T1552.001  Unsecured Credentials: Credentials In Files
# =============================================================================
#  WHAT IT DOES:      Read the last lines of your own PowerShell console
#                     history.
#  WHY:               this is the move Fox Kitten is documented making. Run
#                     it on a machine YOU OWN, then open your own alerts
#                     and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     Both lines are read-only and they read only your own
#                     account's history file. Nothing is deleted, modified,
#                     copied off the machine or sent anywhere, so there is
#                     nothing to undo and no admin rights are needed. If
#                     you would rather not see the contents at all, run
#                     only the first line — locating the file is enough to
#                     test the detection.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Potential PowerShell Console History Access Attempt
#                     via History File - see detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/read-the-typed-password/
# =============================================================================

# Safe: reads your own PowerShell history file. Read-only, nothing changed, nothing to undo.
# STEP 1 - ask PowerShell where its own console history is kept.
powershell -NoProfile -Command "(Get-PSReadLineOption).HistorySavePath"
# STEP 2 - the actual technique: read that file, the way an intruder harvests typed secrets.
powershell -NoProfile -Command "Get-Content (Get-PSReadLineOption).HistorySavePath -Tail 20"
# STEP 3 - open your SOC / EDR. Did console history access alert?
