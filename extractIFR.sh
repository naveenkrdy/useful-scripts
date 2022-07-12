#!/usr/bin/env bash
# extractifr.sh
# Script to extract IFR from BIOS file
# Created by naveenkrdy on 7/06/2021

ver="1.1"
file="$1"
ifr_file="${file}_ifr.txt"
temp="./temp"
pwd=$(dirname "$0")

_print() {
  echo ":: $*"
}

_error() {
  echo >&2 "!! $*"
  exit 1
}

_find_guid(){
	local bin_file="$1"
	local pattern="530079007300740065006D0020004C0061006E0067007500610067006500"
	local guid=$(UEFIFind $bin_file body list $pattern)
	
	echo $guid
	
}

extract_guid(){
	local file="$1"
	local guid=$(_find_guid $file)
	if [[ ! $guid ]];then
		_error "Could not find GUID."
	fi
	
	_print "Found IFR in GUID : $guid"
	_print 'Extracting GUID'
	UEFIExtract $file $guid -o temp -m body -t >/dev/null
	
	_print 'Extracting IFR'
	for bin in ${temp}/*; do
	    local supress_error=$(ifrextract $bin $ifr_file >/dev/null)
	done

	_print "Saved to $ifr_file"
}

#START
cd $pwd

if [[ ! $file ]]; then
    _error 'Usage: ./extractIFR.sh <bios-file>'
fi

if [[ ! -d bin ]]; then
    _error 'Missing bins folder.'
else
    PATH="${pwd}/bin:${PATH}"
fi

_print "IFR Extractor v$ver"
rm -rf $temp $ifr_file
extract_guid $file
rm -rf $temp
_print 'Done'
