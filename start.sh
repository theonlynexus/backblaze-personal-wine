#!/bin/bash

echo "User set timezone $TZ"
echo "Setting the timezone."
echo $TZ | sudo tee /etc/timezone
DEBIAN_FRONTEND=noninteractive TZ=$TZ sudo dpkg-reconfigure --frontend noninteractive tzdata

DRIVE_C=$WINEPREFIX/drive_c
INSTALL_FILE=/config/install_backblaze.exe
PROGRAM_FILES=$DRIVE_C/Program\ Files
#ASIDE_FILE=$PROGRAM_FILES/Backblaze/bzbui.exe.aside
#EXE_FILE=$PROGRAM_FILES/Backblaze/bzbui.exe
URL=https://www.backblaze.com/win32/install_backblaze.exe
export WINEARCH=win32

configure_wine () {
	if [ ${#COMPUTER_NAME} -gt 15 ]; then
		echo "Error: computer name cannot be longer than 15 characters"
		exit 1
	fi

	echo "Setting the wine computer name"
	wine reg add "HKCU\\SOFTWARE\\Wine\\Network\\" /v UseDnsComputerName /f /d N
	wine reg add "HKLM\\SYSTEM\\CurrentControlSet\\Control\\ComputerName\\ComputerName" /v ComputerName /f /d $COMPUTER_NAME
	wine reg add "HKLM\\SYSTEM\\CurrentControlSet\\Control\\ComputerName\\ActiveComputerName" /v ComputerName /f /d $COMPUTER_NAME
	winetricks -q corefonts
	winetricks -q cjkfonts
}

check_dirs () {
	if [ ! -d /data ]; then
		mkdir -p /data
	fi
	if [ ! -d "${WINEPREFIX}/dosdevices/d:" ]; then
		ln -s /data "${WINEPREFIX}/dosdevices/d:"
	fi
	if [ -d "$WINEPREFIX/dosdevices/z:" ]; then
		unlink "$WINEPREFIX/dosdevices/z:"
	fi
        if [ ! -d "${PROGRAM_FILES}" ]; then
                mkdir -p "${PROGRAM_FILES}"
        fi
}

echo "Initializing the wine prefix"
#wineboot -i -u
check_dirs
configure_wine

echo "Downloading the Backblaze personal installer..."
wget -c "$URL" -P "/config"

echo "Backblaze installer started, please go through the graphical setup"
wine "$INSTALL_FILE"


