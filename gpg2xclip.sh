#!/bin/bash
# A small script that deals with ASCII armored GPG data.
# If it finds plaintext in X clipboard, it will replace it with its encrypted equivalent.
# If it finds ciphertest, it will do the reverse.
# The key ID to encrypt to is taken from $KEYID environment variable.
#
# For decrypting, you will also need pinentry and gpg-agent.

GPG="$(which gpg2)"
XCLIP="$(which xclip)"
XCLIP_OPTS="-selection clipboard" # Use X clipboard
ZENITY="$(which zenity)"
NOTIFY_SEND="$(which notify-send)"
NOTIFY_SEND_OPTS="gpg2xclip" # Set title

LC_MESSAGES=C

if [ -z $GPG ] || [ -z $XCLIP ] || [ -z $ZENITY ]; then
        echo "GPG2 or xclip or Zenity not found, please install it"
        exit 1
fi

# Set xclip options
XCLIP="$XCLIP $XCLIP_OPTS"

function notify() {
	if [ -z $NOTIFY_SEND ]; then
		$NOTIFY_SEND="echo"
		unset $NOTIFY_SEND_OPTS
	fi

	$NOTIFY_SEND "$NOTIFY_SEND_OPTS" "$1"
}

function encrypt() {
	if [ -z $KEYID ]; then
		KEYID=$(zenity --entry --text "Enter Key ID")
	fi

	($XCLIP -out | $GPG -r "${KEYID}" --armor -es | $XCLIP -in) && encrypt_success=1

	if [ $encrypt_success == "1" ]; then
		notify "Encrypted data in clipboard to key "${KEYID}""
	else
		notify "Failed to encrypt data in clipboard!"
		exit 2
	fi
}

function decrypt() {
	$XCLIP -out | $GPG -d | $XCLIP -in && decrypt_success=1
	chars=$($XCLIP -out | wc -m)
	if [ $decrypt_success == "1" ]; then
		notify "Decrypted in clipboard: $chars characters"
	else
		notify "Failed to decrypt encrypted data from keyboard!"
		exit 3
	fi
}


CONTENT="$($XCLIP -out)"

if [[ ${CONTENT} =~ "-----BEGIN PGP MESSAGE-----" ]]; then
	decrypt
else
	encrypt
fi
