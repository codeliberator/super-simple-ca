#!/bin/bash

# generate a server cert in this ca
SITE=$1

if [ "${SITE}" == "" ] ; then
  echo "Usage error, you need to give the site name as an argument"
  echo "eg. make-cert.sh server.example.com"
  exit 1
fi

SITE_KEY=${SITE}.key
SITE_CFG=${SITE}.cfg
SITE_CSR=${SITE}.csr
SITE_CRT=${SITE}.crt
SITE_EMAIL=root@${SITE}

if [ -f "${SITE_CRT}" ] ; then
  echo "Cert and Key for ${SITE} already exist."
  echo "If you want to regenerate these remove the current ones first: rm ${SITE}*"
  echo "Site Cert is in: ${SITE_CRT}"
  echo "Site Key  is in: ${SITE_KEY}"
  exit 1
fi

password=capass

# Make config file
cat > ${SITE_CFG} <<EOF
[ req ]
default_bits           = 2048
default_keyfile        = ${SITE_KEY}
distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no

[ req_distinguished_name ]
C                      = NZ
CN                     = "${SITE}"
emailAddress           = "${SITE_EMAIL}"

[ req_attributes ]
#challengePassword      = ""
EOF

export OPENSSL_CONF=./${SITE_CFG}

# Generate a key
openssl genrsa -out "${SITE_KEY}" 2048

# Generate a certificate signing request
openssl req -new -key "${SITE_KEY}" -out "${SITE_CSR}"

# Create the certificate
openssl x509 -req -in "${SITE_CSR}" -CA rootCAcrt.pem -CAkey rootCAkey.pem -CAcreateserial -out "${SITE_CRT}" -days 500 -sha256 -passin "pass:${password}"

if [ -f "${SITE_CRT}" ] ; then
  echo "Site Cert is in: ${SITE_CRT}"
  echo "Site Key  is in: ${SITE_KEY}"
fi
