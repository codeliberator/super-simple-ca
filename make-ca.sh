#!/bin/bash

if [ -f "rootCAkey.pem" ] ; then
  echo "CA already exists"
  echo "If you want a new CA: rm rootCA* ,before running this script again"
  exit 1
fi

password=capass
echo
echo "The password for the CA is: ${password}"
echo
export OPENSSL_CONF=./rootCA.cfg

cat <<EOF >"${OPENSSL_CONF}"
[ req ]
default_bits           = 2048
default_keyfile        = rootCAkey.pem
distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no
#output_password        = ""

[ req_distinguished_name ]
C                      = NZ
CN                     = "rootCA"
emailAddress           = "root@localhost"

[ req_attributes ]

EOF

openssl genrsa -des3 -passout "pass:${password}" -out rootCAkey.pem 4096
openssl req -passin "pass:${password}" -x509 -new -nodes -key rootCAkey.pem -sha256 -days 1024 -out rootCAcrt.pem
