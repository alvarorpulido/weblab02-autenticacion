#
# Test `weblab-2` assignment.
#
# Usage:
#
#     hurl --test --variable site=domain weblab-2.hurl
#
# Example:
#
#     hurl --test --variable site=discovery.sistema.sol weblab-2.hurl
#
# Author: Fernando Raya
# Email: fraya@ieszaidinvergeles.org
#

# Pueden acceder todos los usuarios sin autenticación.
GET http://{{ site }}
HTTP 200

# Basic auth: Puede entrar ana.
GET http://{{ site }}/basic
[BasicAuth]
ana: ana
HTTP 301

# Puede entrar maria.
GET http://{{ site }}/basic
[BasicAuth]
maria: maria
HTTP 301

# Puede entrar arturo.
GET http://{{ site }}/basic
[BasicAuth]
arturo: arturo
HTTP 301

# Otros usuarios no pueden acceder.
GET http://{{ site }}/basic
[BasicAuth]
foo: bar 
HTTP 401

# En desarrollo sólo puede entrar ana
GET http://{{ site }}/basic/desarrollo
[BasicAuth]
ana: ana
HTTP 301

# En desarrollo no puede entrar maria
GET http://{{ site }}/basic/desarrollo
[BasicAuth]
maria: maria
HTTP 401

# En desarrollo no puede entrar arturo
GET http://{{ site }}/basic/desarrollo
[BasicAuth]
arturo: arturo
HTTP 401

# En ventas no puede entrar `ana`
GET http://{{ site }}/basic/ventas
[BasicAuth]
ana: ana
HTTP 401

# En ventas no puede entrar `maria`
GET http://{{ site }}/basic/ventas
[BasicAuth]
maria: maria
HTTP 401

# En ventas puede entrar `arturo`
GET http://{{ site }}/basic/ventas
[BasicAuth]
arturo: arturo
HTTP 301
