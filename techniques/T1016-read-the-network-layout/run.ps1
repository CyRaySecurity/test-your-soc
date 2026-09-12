# =============================================================================
#  Test your SOC - T1016  System Network Configuration Discovery
# =============================================================================
#  WHAT IT DOES:      Run ipconfig /all, arp -a and route print.
#  WHY:               this is the move Lazarus Group is documented making.
#                     Run it on a machine YOU OWN, then open your own
#                     alerts and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     All three lines only print settings this machine
#                     already holds. Nothing is created, changed or
#                     deleted, so there is nothing to undo and no admin
#                     rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Suspicious Network Command - see detection.yml in
#                     this folder.
#  PAGE:              https://cyray.io/test-your-soc/read-the-network-layout/
# =============================================================================

# Safe: three read-only lookups of this machine's own network settings. Nothing to undo.
# STEP 1 - the full network configuration, the way an intruder reads it.
ipconfig /all
# STEP 2 - the neighbours this machine has recently spoken to.
arp -a
# STEP 3 - the routing table, which shows what else is reachable from here.
route print
# STEP 4 - open your SOC / EDR. Did network configuration discovery alert?
