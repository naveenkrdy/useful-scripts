#!/bin/bash
# smbiosGen.sh
# Script to generate SMBIOS data.
# Created by naveenkrdy on 18/09/2019

curr_dir=$(dirname "$0")
cd $curr_dir

if [[ ! -d bin ]]; then
    echo 'Missing bins folder'
    exit 1
else
    PATH="${curr_dir}/bin:${PATH}"
fi

# START
ver="1.0"
echo
echo "SMBIOS Data Generator v$ver"

function generate_smbios() {
	uuid="$(uuidgen)"
	echo
	read -p "Enter smbios: " SMBIOS
	echo
	echo "     SMBIOS    |    SERIAL    |     MLB   "
	macserial -a | grep -i "$SMBIOS" | head -1
	echo
	echo "                       UUID"
	echo "         $uuid"
}

while ! [[ $REPLY =~ [Ee] ]]; do
	generate_smbios
	echo
	read -p "Press [Enter] to re-generate or [E] to exit. " -n 1 -r
done
