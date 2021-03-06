apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:certbot/certbot
apt-get update
apt-get install -y certbot 
apt-get install -y ocserv

systemctl stop ocserv.socket
systemctl stop ocserv
certbot certonly --standalone --agree-tos --email ${your_email} -d ${your_domain}
openssl x509 -in /etc/letsencrypt/live/${your_domain}/cert.pem  -sha1 -noout -fingerprint | sed -e 's/://g'




mkdir -p /etc/ocserv/config-per-user/
cat > /etc/ocserv/ocserv.conf <<EOF
auth = "plain[/etc/ocserv/ocpasswd]"
max-clients = 16
max-same-clients = 5
tcp-port = 443
udp-port = 443
listen-clear-file = /var/run/ocserv-conn.socket
keepalive = 32400
dpd = 90
try-mtu-discovery = false
server-cert = /etc/letsencrypt/live/${your_domain}/fullchain.pem
server-key = /etc/letsencrypt/live/${your_domain}/privkey.pem
tls-priorities = "NORMAL:%SERVER_PRECEDENCE:%COMPAT:-VERS-SSL3.0:-ARCFOUR-128"
auth-timeout = 40
cookie-timeout = 300
deny-roaming = false
rekey-time = 172800
rekey-method = ssl
use-utmp = true
use-occtl = true
pid-file = /var/run/ocserv.pid
socket-file = /var/run/ocserv-socket
run-as-user = nobody
run-as-group = daemon
device = vpns
predictable-ips = true
default-domain = example.com
ipv4-network = 192.168.9.0
ipv4-netmask = 255.255.255.0
dns = 8.8.8.8
ping-leases = false
cisco-client-compat = false
config-per-user = /etc/ocserv/config-per-user/
EOF


cat > /etc/ocserv/config-per-user/home153 <<EOF
ipv4-network = 192.168.8.0
ipv4-netmask = 255.255.255.0
EOF

your_password=
echo ${your_password} | ocpasswd -c /etc/ocserv/ocpasswd ${your_username}


iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.9.0/24 -o venet0:0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.8.0/24 -o venet0:0 -j MASQUERADE
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -A FORWARD -s 192.168.9.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.8.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -L
iptables -L -t nat
sysctl -w net.ipv4.ip_forward=1
echo 1 > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv4/ip_forward


systemctl start ocserv.socket
systemctl start ocserv

