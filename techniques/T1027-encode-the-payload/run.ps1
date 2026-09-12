# =============================================================================
#  Test your SOC - T1027  Obfuscated Files or Information
# =============================================================================
#  WHAT IT DOES:      Encode a harmless file to base64 with certutil, then
#                     delete both.
#  WHY:               this is the move Kimsuky is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     The script creates two files in your own temp folder
#                     — a plain sentence and its base64 form — and the last
#                     line deletes exactly those two. Nothing is
#                     downloaded, nothing is executed, nothing existing is
#                     touched, and no admin rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           the script removes exactly what it created - see the
#                     final step below.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         File Encoded To Base64 Via Certutil.EXE - see
#                     detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/encode-the-payload/
# =============================================================================

# Safe: makes one small text file in your own temp folder, encodes it, then deletes both. No admin.
# STEP 1 - write a harmless marker file.
Set-Content -Path "$env:TEMP\CyRaySOCTest.txt" -Value 'harmless marker for a SOC test'
# STEP 2 - the actual technique: encode it so a content scanner reads nothing.
certutil -encode "$env:TEMP\CyRaySOCTest.txt" "$env:TEMP\CyRaySOCTest.b64"
# STEP 3 - open your SOC / EDR. Did encoding by certutil alert?
# STEP 4 - clean up: delete exactly the two files this script created.
Remove-Item "$env:TEMP\CyRaySOCTest.txt","$env:TEMP\CyRaySOCTest.b64" -Force
