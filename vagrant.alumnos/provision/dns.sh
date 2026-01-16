sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install bind9 -y && sudo apt-get install bind9-utils -y

cat <<EOF > /etc/hosts
127.0.0.1 localhost
127.0.1.1 dns.sistema.sol dns

192.168.56.100 dns.sistema.sol dns
192.168.56.101 tierra.sistema.sol tierra
EOF

cat <<EOF > /etc/resolv.conf
nameserver 192.168.56.100
search sistema.sol
EOF

cp /vagrant/bind/named.conf.local /etc/bind/named.conf.local

cp /vagrant/bind/db.sistema.sol /var/lib/bind/db.sistema.sol
cp /vagrant/bind/db.192.168.56 /var/lib/bind/db.192.168.56

named-checkzone sistema.sol /var/lib/bind/db.sistema.sol
named-checkzone 56.168.192.in-addr.arpa /var/lib/bind/db.192.168.56

cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    listen-on { any; };
    listen-on-v6 { any; };
    allow-query { any; };
    recursion yes;
    dnssec-validation auto;
};
EOF

systemctl restart bind9
