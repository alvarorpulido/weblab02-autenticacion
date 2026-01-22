sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 -y && sudo apt-get install bind9-utils -y
sudo apt-get install -y openssl

cat <<EOF > /etc/hosts
127.0.0.1 localhost
127.0.1.1 tierra.sistema.sol tierra

192.168.56.101 tierra.sistema.sol tierra
192.168.56.100 dns.sistema.sol dns
EOF

cat <<EOF > /etc/resolv.conf
nameserver 192.168.56.100
search sistema.sol
EOF

mkdir -p /var/www/discovery.sistema.sol/basic/{ventas,desarrollo}
mkdir -p /var/www/discovery.sistema.sol/digest

echo "<h1>Discovery principal</h1>" > /var/www/discovery.sistema.sol/index.html
echo "<h1>Zona Basic</h1>" > /var/www/discovery.sistema.sol/basic/index.html
echo "<h1>Ventas</h1>" > /var/www/discovery.sistema.sol/basic/ventas/index.html
echo "<h1>Desarrollo</h1>" > /var/www/discovery.sistema.sol/basic/desarrollo/index.html
echo "<h1>Bienvenido comandante</h1>" > /var/www/discovery.sistema.sol/digest/hello.html

a2enmod auth_basic
a2enmod authn_core
a2enmod auth_digest

htpasswd -bc /etc/apache2/.htpasswd_basic arturo arturo
htpasswd -b  /etc/apache2/.htpasswd_basic ana ana
htpasswd -b  /etc/apache2/.htpasswd_basic maria maria

cat <<EOF > /etc/apache2/.htgroups
ventas: arturo
desarrollo: ana
EOF

#Configuración del commander
echo "commander:astronauts:$(printf "commander:astronauts:commander" | md5sum | awk '{print $1}')" \
> /etc/apache2/.htpasswd_digest

cp /vagrant/apache/discovery.sistema.sol.conf /etc/apache2/sites-available/
a2ensite discovery.sistema.sol.conf


# Weblab04:
grep -q "Listen 443" /etc/apache2/ports.conf || echo "Listen 443" >> /etc/apache2/ports.conf
a2enmod ssl
mkdir -p /etc/apache2/ssl

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/discovery.key \
  -out /etc/apache2/ssl/discovery.crt \
  -subj "/C=ES/ST=Andalucia/L=Granada/O=Sistema/OU=IT/CN=discovery.sistema.sol"


cp /vagrant/apache/discovery.sistema.sol-ssl.conf /etc/apache2/sites-available/
a2ensite discovery.sistema.sol-ssl.conf


apachectl configtest

#Reinicio del servisio
systemctl restart apache2
