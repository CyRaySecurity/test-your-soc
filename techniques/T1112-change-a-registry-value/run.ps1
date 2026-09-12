# =============================================================================
#  Test your SOC - T1112  Modify Registry
# =============================================================================
#  WHAT IT DOES:      Import a one-value registry file with reg import,
#                     then delete it.
#  WHY:               this is the move APT41 is documented making. Run it
#                     on a machine YOU OWN, then open your own alerts and
#                     see whether anything fired.
#
#  WHAT IT DOES NOT DO:
#                     The script creates one key with one value under your
#                     own user hive — a key that did not exist before — and
#                     one small file in your own temp folder. The last two
#                     lines delete exactly those two things. No
#                     machine-wide setting is touched, nothing existing is
#                     overwritten, and no admin rights are needed.
#                     It sends nothing anywhere. It contacts no CyRay
#                     service. It collects nothing about you or your
#                     machine.
#
#  CLEANUP:           the script removes exactly what it created - see the
#                     final step below.
#  ELEVATION:         none. Runs as your own account.
#  DETECTION:         Potential Suspicious Registry File Imported Via
#                     Reg.EXE - see detection.yml in this folder.
#  PAGE:              https://cyray.io/test-your-soc/change-a-registry-value/
# =============================================================================

# Safe: writes ONE marker value under your own user hive, then deletes exactly that key. No admin.
# STEP 1 - build a one-value registry file in your own temp folder.
Set-Content -Path "$env:TEMP\CyRaySOCTest.reg" -Value @('Windows Registry Editor Version 5.00','','[HKEY_CURRENT_USER\Software\CyRaySOCTest]','"Marker"="test-your-soc"')
# STEP 2 - the actual technique: import it, which writes the value.
reg import "$env:TEMP\CyRaySOCTest.reg"
# STEP 3 - open your SOC / EDR. Did a registry modification alert?
# STEP 4 - clean up: remove exactly the key and the file this script created.
reg delete "HKCU\Software\CyRaySOCTest" /f
Remove-Item "$env:TEMP\CyRaySOCTest.reg" -Force
