#!/bin/bash

# Script para crear certificado autofirmado y configurar Apache automáticamente

echo "=== Configuración de HTTPS con certificado autofirmado ==="

# === Preguntar dominio ===
read -p "Introduce el nombre de dominio (ej: midominio.com): " DOMINIO

# === Preguntar metadatos para el certificado ===
read -p "País (C) [ej: ES]: " COUNTRY
read -p "Estado/Provincia (ST) [ej: Madrid]: " STATE
read -p "Localidad (L) [ej: Madrid]: " LOCALITY
read -p "Organización (O) [ej: MiEmpresa]: " ORGANIZATION
read -p "Unidad Organizativa (OU) [ej: IT]: " ORG_UNIT
read -p "Email (ej: admin@$DOMINIO): " EMAIL

# === Preguntar DocumentRoot ===
read -p "Introduce el directorio DocumentRoot (ej: /var/www/html): " DOCROOT

# === Rutas de archivos ===
CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"
CERT_FILE="$CERT_DIR/${DOMINIO}.crt"
KEY_FILE="$KEY_DIR/${DOMINIO}.key"
VHOST_FILE="/etc/apache2/sites-available/${DOMINIO}-ssl.conf"

# === Crear directorios si no existen ===
sudo mkdir -p $CERT_DIR
sudo mkdir -p $KEY_DIR
sudo mkdir -p $DOCROOT

echo "🔑 Generando certificado autofirmado para $DOMINIO ..."

# === Generar certificado autofirmado ===
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$DOMINIO/emailAddress=$EMAIL"

# Ajustar permisos
sudo chmod 600 "$KEY_FILE"
sudo chmod 644 "$CERT_FILE"

echo "📜 Certificado generado:"
echo "   - Certificado: $CERT_FILE"
echo "   - Clave privada: $KEY_FILE"

# === Activar módulo SSL de Apache ===
echo "⚙️ Activando módulo SSL en Apache..."
sudo a2enmod ssl

# === Crear VirtualHost SSL ===
echo "🌐 Creando VirtualHost HTTPS para $DOMINIO ..."

sudo bash -c "cat > $VHOST_FILE" <<EOF
<VirtualHost *:443>
    ServerName $DOMINIO
    DocumentRoot $DOCROOT

    SSLEngine on
    SSLCertificateFile $CERT_FILE
    SSLCertificateKeyFile $KEY_FILE

    <Directory $DOCROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${DOMINIO}_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMINIO}_access.log combined
</VirtualHost>
EOF

# === Activar VirtualHost ===
echo "✅ Activando VirtualHost..."
sudo a2ensite "${DOMINIO}-ssl.conf"

# === Recargar Apache ===
echo "🔄 Reiniciando Apache..."
sudo systemctl reload apache2

echo "🎉 Configuración completa. Ahora puedes acceder a https://$DOMINIO/"
