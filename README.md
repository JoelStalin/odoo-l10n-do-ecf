# Módulo Oficial Odoo: Localización Dominicana y Facturación Electrónica e-CF (DGII)

[![Odoo Version](https://img.shields.io/badge/Odoo-20.0%20%7C%2018.0-714B67.svg)](https://www.odoo.com)
[![DGII Compliance](https://img.shields.io/badge/DGII-Ley%2032--23%20e--CF-blue.svg)](https://dgii.gov.do)
[![EasyCount Integration](https://img.shields.io/badge/Engine-EasyCount%20API-emerald.svg)](https://easycount.getupsoft.com)

Repositorio centralizado y canónico del módulo de **Localización Dominicana y Facturación Electrónica (e-CF)** para **Odoo ERP**. Este repositorio actúa como la **única fuente de verdad** para todos los clientes y despliegues de **EasyCount** y **GetUpSoft**.

Cualquier actualización regulatoria de la **DGII** (cambios en tipos de comprobantes, tasas de ITBIS, normativas de retención, formatos 606/607/608 o validaciones técnicas) se implementa en este repositorio y se propaga automáticamente a todos los entornos de clientes.

---

## 📦 Contenido del Repositorio

| Módulo / Directorio | Descripción |
| :--- | :--- |
| `l10n_do_accounting/` | Módulo base de localización dominicana: Catálogo oficial de comprobantes e-CF (`E31`, `E32`, `E33`, `E34`, `E41`, `E43`, `E44`, `E45`, `E46`, `E47`), secuencias fiscales NCF/e-CF, retenciones de ley (ISR e ITBIS) y wizard de conexión directa a la API de EasyCount. |
| `l10n_do_accounting_report/` | Módulo de generación de reportes fiscales para la DGII: Formato 606 (Compras), Formato 607 (Ventas) y Formato 608 (Comprobantes Anulados). |
| `scripts/update-client-module.sh` | Script automatizado para actualizar los módulos en el servidor de cualquier cliente en 1 solo comando. |

---

## 🏛️ Normativas DGII Implementadas

- **Ley 32-23:** Régimen de Facturación Electrónica obligatoria en la República Dominicana.
- **Ley 11-92:** Código Tributario de la República Dominicana.
- **Norma General 02-05:** Retención del 100% de ITBIS en servicios profesionales prestados por personas físicas a sociedades.
- **Norma General 07-07:** Retención del 10% de ISR en servicios profesionales de personas físicas (Art. 309).
- **Norma General 07-2018:** Obligatoriedad de RNC/Cédula en facturas de consumo iguales o superiores a RD$ 250,000.00.
- **Regímenes Especiales (`E44`):** Facturación obligatoria con tasa Exenta (0% ITBIS) para empresas bajo carnet de exención fiscal DGII (Zonas Francas, Ley 8-90, etc.).

---

## 🚀 Instalación en un Servidor de Cliente

### Método 1: Clonar como Git Submodule o Repositorio en `extra-addons`
```bash
cd /opt/odoo/extra-addons  # o la ruta de addons de su servidor
git clone https://github.com/JoelStalin/odoo-l10n-do-ecf.git .
```

### Método 2: Despliegue Rápido One-Liner (curl)
```bash
curl -fsSL https://raw.githubusercontent.com/JoelStalin/odoo-l10n-do-ecf/main/scripts/update-client-module.sh | bash -s -- /ruta/a/sus/addons
```

---

## 🔄 Actualización Masiva a Clientes (Admin Command)

Cuando la DGII publique una nueva resolución o cambio de especificación:

1. Se realiza la modificación y prueba en este repositorio (`odoo-l10n-do-ecf`).
2. Se hace push a la rama `main` (o se genera un tag de release, ej. `v20.1.0`).
3. El Administrador de EasyCount / GetUpSoft ejecuta el comando de actualización masiva desde la consola o el Panel de Integración:

```bash
# Comando ejecutado en el servidor del cliente:
bash <(curl -fsSL https://raw.githubusercontent.com/JoelStalin/odoo-l10n-do-ecf/main/scripts/update-client-module.sh) /ruta/addons nombre_db_cliente
```

O en entornos Dockerizados:
```bash
docker exec -it <contenedor_odoo> odoo -u l10n_do_accounting,l10n_do_accounting_report -d <nombre_db> --stop-after-init
```

---

## 🔐 Seguridad y Restricción de Instaladores

> **Importante:** La descarga de paquetes ZIP y herramientas de despliegue en infraestructura de clientes está **restringida estrictamente a los Administradores de Plataforma**. Los usuarios de empresas clientes operan a través del portal y de sus credenciales API sin acceso directo a los archivos binarios de instalación.

---

## 📄 Licencia y Autoría

Desarrollado y mantenido por **GetUpSoft** & **EasyCount**.  
Contacto: `soporte@getupsoft.com` | `https://getupsoft.com`
