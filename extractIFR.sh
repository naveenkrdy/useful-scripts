#!/usr/bin/env bash
# extractIFR.sh
# Script to extract IFR from BIOS file
# Created by naveenkrdy on 7/06/2021

curr_dir=$(dirname "$0")
cd $curr_dir

if [[ $# == 0 ]]; then
    echo 'Usage : ./extractIFR <bios-file>'
    exit 1
else
    file="$1"
fi

if [[ ! -d bin ]]; then
    echo 'Missing bins folder'
    exit 1
else
    PATH="${curr_dir}/bin:${PATH}"
fi

#START
ver="1.0"
ifr_file="${file}_ifr.txt"
temp_dir="./temp"

echo
echo "IFR Extractor v$ver"
rm -rf $temp_dir $ifr_file

pattern="530079007300740065006D0020004C0061006E0067007500610067006500"
guid=$(UEFIFind $file body list $pattern)

if [[ ! "$guid" ]];then
	echo "Failed to find GUID"
	exit 1
fi
echo "Found IFR in GUID : $guid"

echo 'Extracting GUID'
UEFIExtract $file $guid -o temp -m body -t >/dev/null

echo 'Extracting IFR'
for bin in ${temp_dir}/*; do
    supress_error=$(ifrextract $bin $ifr_file >/dev/null)
done

echo "Saved as $ifr_file"
rm -rf $temp_dir
echo 'Done'
