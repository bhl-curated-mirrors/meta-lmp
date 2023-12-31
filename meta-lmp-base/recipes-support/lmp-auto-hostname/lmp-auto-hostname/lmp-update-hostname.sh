#!/bin/sh
#
# SPDX-License-Identifier: MIT
#
# Copyright (c) 2019, Foundries.io Ltd.

# Default machine name and network interface from environment
MACHINE=${MACHINE}
NETDEVICE=${NETDEVICE}

# Default mode used to fetch the hardware specific data
# Supported modes: mac (requires netdevice), serial
MODE=${MODE}

# Set default mode to serial if not provided by the user
[ -n "$MODE" ] || MODE="serial"
# Set Default network device to eth0 if not provided
[ -n "$NETDEVICE" ] || NETDEVICE="eth0"

# Extract data from device-tree or via dmi, if available
if [ -d /proc/device-tree ]; then
	MODEL_SOURCE="/proc/device-tree/model"
	if [ -f /sys/devices/soc0/serial_number ]; then
		SERIAL_SOURCE="/sys/devices/soc0/serial_number"
	else
		SERIAL_SOURCE="/proc/device-tree/serial-number"
	fi
else
	MODEL_SOURCE="/sys/class/dmi/id/product_name"
	SERIAL_SOURCE="/sys/class/dmi/id/product_serial"
fi
if [ -f ${MODEL_SOURCE} ]; then
	# Lowercase and no spaces (can generate bad values with special chars)
	MODEL=$(sed -e 's/ /-/g' -e 's/+/plus/g' ${MODEL_SOURCE} | tr '[:upper:]' '[:lower:]' | tr -d '\0')
fi
if [ -x /usr/bin/fiovb_printenv ] && [ -n "${FIOVB_VAR}" ]; then
	# Fetch the serial number in the fiovb variable named "${FIOVB_VAR}".
	SERIAL_TMP=$(mktemp /tmp/lmp-update-hostname-fiovb.XXXXXXXXXX)
	trap 'rm -f ${SERIAL_TMP}' EXIT
	fiovb_printenv "${FIOVB_VAR}" > ${SERIAL_TMP} && SERIAL_SOURCE="${SERIAL_TMP}"
fi
if [ -f ${SERIAL_SOURCE} ]; then
	# Lowercase and no leading zeros
	SERIAL=$(sed -e 's/^0*//' ${SERIAL_SOURCE} | tr '[:upper:]' '[:lower:]' | tr -d '\0')
fi
# Network device mac address
if [ -f /sys/class/net/${NETDEVICE}/address ]; then
	MACADDRESS=$(sed -e 's/://g' /sys/class/net/${NETDEVICE}/address)
fi

[ -n "$MODEL" ] || MODEL="unknown"
[ -n "$MACADDRESS" ] || MACADDRESS="unknown"
[ -n "$SERIAL" ] || SERIAL="unknown"

# Prefer machine name if given by the user
[ -n "$MACHINE" ] && MODEL=${MACHINE}

if [ "$MODE" = "mac" ]; then
	NEW_HOSTNAME="${MODEL}-${MACADDRESS}"
else
	NEW_HOSTNAME="${MODEL}-${SERIAL}"
fi

echo "Updating system hostname to ${NEW_HOSTNAME}"
if [ -x /usr/bin/hostnamectl ]; then
    /usr/bin/hostnamectl --static --transient set-hostname ${NEW_HOSTNAME}
else
    echo ${NEW_HOSTNAME} > /etc/hostname
    /usr/bin/hostname -F /etc/hostname
fi

echo "Updating /etc/hosts with hostname ${NEW_HOSTNAME}"
if grep -q "^127.0.1.1" /etc/hosts; then
	sed -i -e "s/^127.0.1.1 .*/127.0.1.1 ${NEW_HOSTNAME}/g" /etc/hosts
else
	echo "127.0.1.1 ${NEW_HOSTNAME}" >> /etc/hosts
fi
