# =============================================================================
#  Test your SOC - T1518.001  Software Discovery: Security Software Discovery
# =============================================================================
#  WHAT IT DOES:      Filter the process list for the name of a security
#                     product.
#  WHY:               this is the move MuddyWater is documented making. Run
#                     it on a machine YOU OWN, then open your own alerts
#                     and see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     The line lists the running processes and filters that
#                     text for a keyword. It touches no security product,
#                     changes no setting and disables nothing — it only
#                     looks. Nothing is created, changed or deleted, and no
#                     admin rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Security Tools Keyword Lookup Via Findstr.EXE - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/look-for-the-security-agent/
# =============================================================================

# Safe: read-only. Lists processes and filters the text. Nothing is changed, nothing to undo.
# STEP 1 - look for the security agent by name, the way an intruder checks what is watching.
cmd /c "tasklist | findstr /i defender"
# STEP 2 - open your SOC / EDR. Did security software discovery alert?
