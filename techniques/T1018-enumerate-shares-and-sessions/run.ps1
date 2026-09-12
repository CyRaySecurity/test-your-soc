# =============================================================================
#  Test your SOC - T1018  Remote System Discovery
# =============================================================================
#  WHAT IT DOES:      Run net view to enumerate reachable shares and
#                     sessions.
#  WHY:               this is the move Conti is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     Both lines only list what is already visible on the
#                     network — nothing is created, mounted, changed or
#                     deleted. There is nothing to undo and no admin rights
#                     are needed. If the command returns an error (a modern
#                     box often answers `net view` with error 6118), the
#                     test is still valid — the detection watches the
#                     command running, not what it prints.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Share And Session Enumeration Using Net.EXE - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/enumerate-shares-and-sessions/
# =============================================================================

# Safe: read-only enumeration. Nothing is changed, nothing to undo.
# STEP 1 - list the shares and sessions visible from this machine.
net view
# STEP 2 - the broader sweep an intruder runs to see everything reachable.
net view /all
# STEP 3 - open your SOC / EDR. Did share/session enumeration alert?
