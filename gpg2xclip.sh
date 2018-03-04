#!/bin/bash
# A small script that deals with ASCII armored GPG data.
# If it finds plaintext in X clipboard, it will replace it with its encrypted equivalent.
# If it finds ciphertest, it will do the reverse.
# The key ID to encrypt to is taken from $KEYID environment variable.
#
# For decrypting, you will also need pinentry and gpg-agent.

GPG="$(which gpg2)"
XCLIP="$(which xclip)"

if [ -z $GPG ] || [ -z $XCLIP ]; then
	echo "GPG2 or xclip not found, please install it"
	exit 1
fi

function encrypt() {
	if [ -z $KEYID ]; then
		echo "Key ID to encrypt to not set! Please set the \$KEYID variable."
		exit 2
	fi
	$XCLIP -out | $GPG -r "${KEYID}" --armor -es | $XCLIP -in
}

function decrypt() {
	$XCLIP -out | $GPG -d | $XCLIP -in
}


CONTENT="$($XCLIP -out)"

if [[ ${CONTENT} =~ "-----BEGIN PGP MESSAGE-----" ]]; then
	decrypt
else
	encrypt
fi