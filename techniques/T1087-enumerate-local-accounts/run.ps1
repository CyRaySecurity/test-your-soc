# =============================================================================
#  Test your SOC - T1087  Account Discovery
# =============================================================================
#  WHAT IT DOES:      Run net user and whoami /all to list local accounts.
#  WHY:               this is the move Scattered Spider is documented
#                     making. Run it on a machine YOU OWN, then open your
#                     own alerts and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     Every line is a read-only lookup — it lists accounts
#                     and prints your own privileges. Nothing is created,
#                     changed or deleted, so there is nothing to undo and
#                     no admin rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Local Accounts Discovery - see detection.yml in this
#                     folder.
#  PAGE:              https://cyray.io/test-your-soc/enumerate-local-accounts/
# =============================================================================

# Safe: these are read-only lookups. Nothing is changed, nothing to undo.
# STEP 1 - list the local accounts, the way an intruder maps who lives here.
net user
# STEP 2 - read back exactly what the current account is allowed to do.
whoami /all
# STEP 3 - open your SOC / EDR. Did account enumeration alert?
