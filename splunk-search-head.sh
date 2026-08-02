#!/bin/bash
exec > >(tee /var/log/splunk-bootstrap.log) 2>&1
set -x

SPLUNK_VERSION="9.4.0"
SPLUNK_BUILD="6b4ebe426ca6"
SPLUNK_PACKAGE="splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-linux-amd64.tgz"
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/${SPLUNK_VERSION}/linux/${SPLUNK_PACKAGE}"

dnf install -y wget

if ! id splunk >/dev/null 2>&1; then
    useradd --system --create-home --shell /bin/bash splunk
fi

# Find the unmounted data volume (nitro presents xvdb as nvme1n1)
DEVICE=""
for d in /dev/nvme1n1 /dev/xvdb /dev/sdb; do
    if [ -b "$d" ] && ! blkid "$d" >/dev/null 2>&1; then
        DEVICE="$d"
        break
    fi
done

if [ -n "$DEVICE" ]; then
    mkfs.xfs -f "$DEVICE"
    mkdir -p /opt/splunk
    echo "$DEVICE /opt/splunk xfs defaults,nofail 0 2" >> /etc/fstab
    mount /opt/splunk
fi

df -h /opt/splunk

# Stream extraction: never writes the tarball to disk
wget -qO- "${SPLUNK_URL}" | tar -xzf - -C /opt --no-same-owner --strip-components=1 -C /opt/splunk

chown -R splunk:splunk /opt/splunk

sudo -u splunk /opt/splunk/bin/splunk start \
    --accept-license --answer-yes --no-prompt --seed-passwd 'Pa55word'

/opt/splunk/bin/splunk enable boot-start -user splunk -systemd-managed 1 \
    --accept-license --answer-yes --no-prompt

systemctl daemon-reload
sudo -u splunk /opt/splunk/bin/splunk status