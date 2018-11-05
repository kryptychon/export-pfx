#!/bin/bash

### Begin Config Section
home_path=/home/ruben/.acme.sh
export_password_file="/var/containers/pound/export-password.txt"
### End Config Section

cert_name=$1

cert_directory=$home_path/$cert_name
cert_file=$cert_directory/$cert_name.cer
key_file=$cert_directory/$cert_name.key
export_password="file:$export_password_file"


pfx_file=$cert_directory/$cert_name.pfx

if ! [ -f $cert_file ]; then
	echo -e "\e[31m\"$cert_file\" not found!\e[0m"
	exit 1
fi

if ! [ -f $key_file ]; then
	echo -e "\e[31m\"$key_file\" not found!\e[0m"
	exit 1
fi

if ! [ -f $export_password_file ]; then
	echo -e "\e[31mExport password file \"$export_password_file\" not found!\e[0m"
	exit 1
fi

cat $cert_file $key_file > $pfx_file.tmp

if ! [ -f $pfx_file.tmp ]; then
	echo -e "\e[31m\"$pfx_file.tmp\" not found!\e[0m"
	exit 1
fi

openssl pkcs12 -export -password $export_password -in $pfx_file.tmp -out $pfx_file

if [ -f $pfx_file ] && [ 0 -eq $? ]; then
	echo -e "\e[32mThe certificate \"$cert_name\" has been successfully exported to \"$pfx_file\".\e[0m"
	rm $pfx_file.tmp
	exit 0
else
	echo -e "\e[31mThere was an error exporting the certificate \"$cert_name\"."
fi

exit 1
