echo -e "Creating group blackbox_exporter \n"
groupadd --system blackbox_exporter

echo -e "Creating user blackbox exporter \n"
useradd -s /sbin/nologin --system -g blackbox_exporter blackbox_exporter

wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.19.0/blackbox_exporter-0.19.0.linux-amd64.tar.gz -P /tmp

echo -e "Extracting blackbox exporter \n"
tar xvf blackbox_exporter-*.linux-amd64.tar.gz -C /tmp/
cd /tmp/blackbox_exporter*/

echo -e "Moving blackbox_exporter in /usr/local/bin/ \n"
cp /tmp/blackbox_exporter*/blackbox_exporter /usr/local/bin

echo -e "Moving blackbox exporter config"
cp /tmp/blackbox_exporter*/blackbox_.yml /etc/

echo -e "Creating blackbox_exporter.service \n"

tee /etc/systemd/system/blackbox_exporter.service<<EOF
[Unit]
Description=Blackbox Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=blackbox_exporter
Group=blackbox_exporter
Type=simple
ExecStart=/usr/local/bin/blackbox_exporter --config.file /etc/blackbox.yml

[Install]
WantedBy=multi-user.target
EOF

echo -e "Reloading daemons"
systemctl daemon-reload
echo -e "Starting blackbox service \n"
systemctl start blackbox_exporter
echo -e "Enabling blackbox service \n"
systemctl enable blackbox_exporter

echo -e "Waiting for status \n"
sleep 2
systemctl status blackbox_exporter

echo "End of configuration"
