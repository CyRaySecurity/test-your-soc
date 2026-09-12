# =============================================================================
#  Test your SOC - T1059.001  Command and Scripting Interpreter: PowerShell
# =============================================================================
#  WHAT IT DOES:      Run a PowerShell command line that decodes its own
#                     base64 string.
#  WHY:               this is the move Turla is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     The encoded string decodes to three plain letters,
#                     which are printed and nothing more. Nothing is
#                     downloaded, written to disk, installed or changed, so
#                     there is nothing to undo and no admin rights are
#                     needed. `-NoProfile` means your own PowerShell
#                     profile is not loaded either.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           none needed. Nothing is created, so nothing is left
#                     behind.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Base64 Encoded PowerShell Command Detected - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/decode-a-powershell-command/
# =============================================================================

# Safe: decodes one short, harmless string and prints it. Nothing is written, downloaded or changed.
# STEP 1 - the actual technique: a PowerShell command line that decodes its own contents.
powershell -NoProfile -Command "[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('U09D'))"
# STEP 2 - open your SOC / EDR. Did an encoded PowerShell command alert?
