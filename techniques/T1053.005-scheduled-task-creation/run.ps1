# =============================================================================
#  Test your SOC - T1053.005  Scheduled Task/Job: Scheduled Task
# =============================================================================
#  WHAT IT DOES:      Create a harmless scheduled task with schtasks, then
#                     delete it.
#  WHY:               this is the move APT29 is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     The task does nothing but exit, runs as your own
#                     account (no admin), and the final line deletes
#                     exactly the task the script created. Nothing else on
#                     the machine is touched.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           the script removes exactly what it created - see the
#                     final step below.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Scheduled Task Creation Via Schtasks.EXE - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/scheduled-task-creation/
# =============================================================================

# Safe: creates one harmless task that only exits, then deletes it. Runs as you, no admin.
# STEP 1 - the real persistence move: register a scheduled task via schtasks.
schtasks /create /tn "CyRaySOCTest" /tr "cmd /c exit" /sc once /st 23:59 /f
# STEP 2 - open your SOC / EDR. Did scheduled-task creation alert?
# STEP 3 - clean up: delete exactly the task this script created.
schtasks /delete /tn "CyRaySOCTest" /f
