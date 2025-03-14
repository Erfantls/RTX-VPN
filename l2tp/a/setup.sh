#!/usr/bin/env bash

PSK=d
SERVERLOCALIP=172.18.0.1

XL2TPDFILE=/etc/xl2tpd/xl2tpd.conf
IPSECFILE=/etc/ipsec.conf
OPTIONSXL2TPD=/etc/ppp/options.xl2tpd
IPSECRETS=/etc/ipsec.secrets

set -e

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 1
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo
echo "Installing necessary packets..."

apt-get install strongswan xl2tpd

echo
echo "Installing configuration files..."
yes | cp -rf $DIR/ipsec.conf $IPSECFILE
yes | cp -rf $DIR/xl2tpd.conf $XL2TPDFILE
yes | cp -rf $DIR/options.xl2tpd $OPTIONSXL2TPD

echo -e "\n$SERVERLOCALIP %any : PSK \"$PSK\"" >> $IPSECRETS

echo "$IPSECRETS updated!"

service strongswan restart
service xl2tpd restart
