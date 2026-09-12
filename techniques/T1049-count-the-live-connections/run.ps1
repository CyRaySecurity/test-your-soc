# =============================================================================
#  Test your SOC - T1049  System Network Connections Discovery
# =============================================================================
#  WHAT IT DOES:      Run net use to list connections this machine already
#                     holds.
#  WHY:               this is the move Volt Typhoon is documented making.
#                     Run it on a machine YOU OWN, then open your own
#                     alerts and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     `net use` with no arguments only prints the
#                     connections that already exist — it creates, mounts
#                     and removes nothing. There is nothing to undo and no
#                     admin rights are needed. If the list comes back
#                     empty, the test is still valid: the detection watches
#                     the command running, not what it prints.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         System Network Connections Discovery Via Net.EXE -
#                     see detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/count-the-live-connections/
# =============================================================================

# Safe: read-only. Lists connections that already exist; creates none. Nothing to undo.
# STEP 1 - list the connections this machine already holds.
net use
# STEP 2 - open your SOC / EDR. Did network connection discovery alert?
