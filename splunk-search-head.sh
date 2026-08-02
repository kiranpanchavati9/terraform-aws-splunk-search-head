#!/bin/bash
set -e

SPLUNK_VERSION="9.4.0"
SPLUNK_BUILD="6b4ebe426ca6"
SPLUNK_PACKAGE="splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-linux-amd64.tgz"
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/${SPLUNK_VERSION}/linux/${SPLUNK_PACKAGE}"

echo "===================================================="
echo " Installing Splunk Enterprise"
echo "===================================================="

dnf install -y wget

# Download only if not already present
if [ ! -f "/tmp/${SPLUNK_PACKAGE}" ]; then
    wget -O "/tmp/${SPLUNK_PACKAGE}" "${SPLUNK_URL}"
fi

# Create splunk user if it doesn't exist
if ! id splunk >/dev/null 2>&1; then
    useradd --system --create-home splunk
fi

# Install only if Splunk is not already installed
if [ ! -d /opt/splunk ]; then
    tar -xzf "/tmp/${SPLUNK_PACKAGE}" -C /opt
fi

rm -f "/tmp/${SPLUNK_PACKAGE}"

chown -R splunk:splunk /opt/splunk

echo "===================================================="
echo " Starting Splunk for first-time setup"
echo "===================================================="

runuser -l splunk -c "/opt/splunk/bin/splunk start \
    --accept-license \
    --answer-yes \
    --no-prompt \
    --seed-passwd Pa55word"

echo "===================================================="
echo " Enabling Boot Start"
echo "===================================================="

/opt/splunk/bin/splunk enable boot-start \
    -user splunk \
    --accept-license \
    --answer-yes \
    --no-prompt

systemctl daemon-reload
systemctl enable Splunkd

echo "===================================================="
echo " Restarting Splunk using systemd"
echo "===================================================="

runuser -l splunk -c "/opt/splunk/bin/splunk stop"

systemctl restart Splunkd

echo "===================================================="
echo " Waiting for Splunk to start"
echo "===================================================="

sleep 20

systemctl status Splunkd --no-pager

runuser -l splunk -c "/opt/splunk/bin/splunk status"

echo "===================================================="
echo " Splunk Installation Complete"
echo "===================================================="

echo "Splunk Enterprise"
head -1 /opt/splunk/etc/splunk.version

echo
echo "Splunk has been installed and started successfully."
echo "Web UI: https://$(hostname -I | awk '{print $1}'):8000"
echo
echo "HAPPY SPLUNKING!"