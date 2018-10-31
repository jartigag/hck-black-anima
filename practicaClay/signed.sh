#!/bin/bash
# -*- coding: utf-8 -*-
#
# try if some files are signed with a pub_key or another
# usage: bash signed.sh filesDir pub_keysDir signaturesDir

filesDir=($1/*)
pub_keysDir=($2/*)
signaturesDir=$3
for file in ${filesDir[@]}
do
	filename=$(basename $file)
	signature64=$signaturesDir/firma-$filename
	for key in ${pub_keysDir[@]}
	do
		base64 -d $signature64 >> decod$filename.txt
		echo "openssl dgst -sha256 -verify $key -signature decod$filename.txt $file"
		openssl dgst -sha256 -verify $key -signature decod$filename.txt $file
	done
done
