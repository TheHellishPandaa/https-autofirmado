# install-autocert

# Script de Configuración HTTPS con Certificado Autofirmado en Apache

Este repositorio contiene un script en Bash que permite generar un **certificado autofirmado** y configurar automáticamente un **VirtualHost HTTPS en Apache**. Está diseñado para entornos de prueba o desarrollo local, donde no se requiere un certificado emitido por una autoridad certificadora.

---

## 📋 Características

- Generación automática de **certificado autofirmado** y clave privada.
- Configuración de un **VirtualHost HTTPS** en Apache.
- Activación automática del módulo SSL de Apache.
- Permite personalizar:
  - Nombre de dominio.
  - Metadatos del certificado (país, estado, localidad, organización, unidad organizativa, email).
  - Directorio `DocumentRoot` del sitio web.
- Activación automática del sitio y recarga de Apache.

---

## ⚙️ Requisitos

- Servidor Linux con **Apache2** instalado.
- Permisos de **sudo** para crear certificados y modificar configuración de Apache.

---

## 🚀 Uso

1. Clonar el repositorio:

````
git clone https://github.com/TheHellishPandaa/https-autofirmado
cd https-autofirmado
chmod +x https-autofirmado
./https-autofirmado
````
⚠️ Notas

Este script crea certificados autofirmados, por lo que los navegadores mostrarán advertencias de seguridad.

📝 Personalización

Se puede adaptar fácilmente para múltiples dominios o para integración con scripts de automatización más grandes.

📄 Licencia

Este proyecto está bajo la licencia MIT.
