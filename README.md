# super-simple-ca
Very simple bash scripts to create  CA and create TLS certificates.

This is handy to create TLS certs for test or development environments.

run the make-ca.sh script to create the CA.
run the make-cert.sh script to create certs.

## Example:

copy the two .sh files to your PATH, eg: cp *.sh /usr/local/bin

Create a directory for your super simple ca:


mkdir myca

cd myca

make-ca.sh

make-cert.sh server.example.com

## Notes:

rootCA.crt can be imported into your trust store on your clients so that the client will trust certs generated by your CA.

server.example.com.key and server.example.com.crt are used on your server/application.

## Dependecies

This is expected to run on most Linuxes without modifications.
openssl and bash are required.

## Development and Test Environment

- Fedora release 30 (Thirty)
- openssl-1.1.1d-2.fc30.x86_64
- bash-5.0.11-1.fc30.x86_64
