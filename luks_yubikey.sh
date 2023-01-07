#!/usr/bin/env bash

# Before running, do
# nix develop github:chfanghr/nixos-yubikey-luks

DEVICES=$@
for dev in $DEVICES; do
  cryptsetup isLuks "$dev"
  res=$?
  if [ "$res" -eq 1 ]; then
    echo "ERROR: $dev is not a LUKS device"
  fi
  if [ "$res" -ne 0 ]; then
    exit 1
  fi
done

: ${SALTFILE:=/boot/crypt-storage/default}
: ${SALT_LENGTH:=16}
: ${SALT:="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"}
: ${KEY_LENGTH:=512}
: ${ITERATIONS:=1000000}

echo "Please enter the passphrase. Leave empty if you don't want 2FA"
read -s USER_PASSPHRASE

echo "Connect your YubiKey. Touch it when it blinks."
CHALLENGE="$(echo -n $SALT | openssl dgst -binary -sha512 | rbtohex)"
RESPONSE=
until [ -n "$RESPONSE" ]; do
  RESPONSE=$(ykchalresp -2 -x $CHALLENGE 2>/dev/null)
  if [ -z "$RESPONSE" ]; then
    sleep 1
  fi
done


if [ -n "$USER_PASSPHRASE" ]; then
  LUKS_KEY="$(echo -n $USER_PASSPHRASE | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $RESPONSE | rbtohex)"
else
  LUKS_KEY="$(echo | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $RESPONSE | rbtohex)"
fi

echo $LUKS_KEY

echo "==DANGER ZONE=="
echo "Writing salt and iterations to $SALTFILE. OK? [y/N]"
OK=
read OK
if [ "$OK" != "y" ]; then
  echo "Aborting!"
  exit 3
fi
mkdir -p "$(dirname "$SALTFILE")"
echo -ne "$SALT\n$ITERATIONS" > "$SALTFILE"

echo "Now going to add the key to devices $DEVICES. OK? [y/N]"
OK=
read OK
if [ "$OK" != "y" ]; then
  echo "Aborting!"
  exit 3
fi

for dev in $DEVICES; do
  cryptsetup luksAddKey "$dev" <( (cat <<< $LUKS_KEY) | head -c -1 | hextorb)
done
