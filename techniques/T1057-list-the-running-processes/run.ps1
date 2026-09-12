# =============================================================================
#  Test your SOC - T1057  Process Discovery
# =============================================================================
#  WHAT IT DOES:      Pipe tasklist into findstr to filter the running
#                     process list.
#  WHY:               this is the move Akira is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     Both halves of the line are read-only: one lists the
#                     running processes, the other filters that text.
#                     Nothing is created, changed or deleted, so there is
#                     nothing to undo and no admin rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Recon Command Output Piped To Findstr.EXE - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/list-the-running-processes/
# =============================================================================

# Safe: read-only. Lists processes and filters the list. Nothing is changed, nothing to undo.
# STEP 1 - list what is running and filter it the way an intruder does.
cmd /c "tasklist | findstr /i explorer"
# STEP 2 - open your SOC / EDR. Did process discovery alert?
