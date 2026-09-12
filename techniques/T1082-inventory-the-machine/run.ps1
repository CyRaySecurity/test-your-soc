# =============================================================================
#  Test your SOC - T1082  System Information Discovery
# =============================================================================
#  WHAT IT DOES:      Run systeminfo to read the machine's full
#                     specification.
#  WHY:               this is the move Black Basta is documented making.
#                     Run it on a machine YOU OWN, then open your own
#                     alerts and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     One read-only command that prints the machine's own
#                     specification. Nothing is created, changed or
#                     deleted, so there is nothing to undo and no admin
#                     rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Suspicious Execution of Systeminfo - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/inventory-the-machine/
# =============================================================================

# Safe: one read-only lookup. Nothing is created, changed or deleted.
# STEP 1 - the inventory an intruder takes the minute they land.
systeminfo
# STEP 2 - open your SOC / EDR. Did system information discovery alert?
