#!/usr/bin/env bash

echo -n "Enter username: "
read USER
if [ -f "$USER" ]; then
	echo "User file $USER exists. Please remove it first. Exiting."
	exit 1
fi

echo -n "Enter password for user '$USER': "
read -s PASS
echo
echo -n "Repeat password: "
read -s PASS_AGAIN

if [ ! "$PASS" == "$PASS_AGAIN" ]; then
	echo "Passwords not the same. Exiting."
	exit 1
fi

HASH="$(mkpasswd -m sha-512 $PASS)"

# Write password to user file and make read-only.
echo "$HASH" > "$USER"
chmod 400 "$USER"

echo
echo
echo "Changing owner of file '$USER' to root.root"
sudo chown root.root "$USER"

echo
echo "Please move file '$USER' to /persist/passwords/"
