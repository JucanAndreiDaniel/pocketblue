@echo off
setlocal EnableExtensions EnableDelayedExpansion

where fastboot || (pause & exit)

rem Panel variant: set PANEL=visionox for Visionox panels (default: samsung)
if "%PANEL%"=="" set PANEL=samsung
if "%PANEL%"=="samsung" set UBOT_IMG=images/u-boot-davinci-samsung.img
if "%PANEL%"=="visionox" set UBOT_IMG=images/u-boot-davinci-visionox.img

echo ^>^>^> Flashing xiaomi-davinci (panel: %PANEL%)

echo ^>^>^> Waiting for device to appear in fastboot...
fastboot getvar product 2>&1 | findstr /i davinci || (pause & exit)

echo ^>^>^> (1/6) Erasing DTBO
fastboot erase dtbo || (pause & exit)

echo ^>^>^> (2/6) Disabling verified boot
fastboot flash vbmeta images/vbmeta-disabled.img || (pause & exit)

echo ^>^>^> (3/6) Flashing U-Boot
fastboot flash boot %UBOT_IMG% || (pause & exit)

echo ^>^>^> (4/6) Flashing fedora_esp.raw into cache
fastboot flash cache images/fedora_esp.raw || (pause & exit)

echo ^>^>^> (5/6) Flashing fedora_rootfs.raw into userdata
fastboot flash userdata images/fedora_rootfs.raw || (pause & exit)

echo ^>^>^> (6/6) Writing to disk and rebooting (this may take a while, DO NOT DISCONNECT THE DEVICE)
fastboot reboot
pause
