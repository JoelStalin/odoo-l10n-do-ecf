# Módulo Oficial Odoo: Localización Dominicana, Nómina TSS/DGII y Facturación Electrónica e-CF

[![Odoo Version](https://img.shields.io/badge/Odoo-20.0%20%7C%2018.0-714B67.svg)](https://www.odoo.com)
[![DGII Compliance](https://img.shields.io/badge/DGII-Ley%2032--23%20e--CF-blue.svg)](https://dgii.gov.do)
[![Payroll TSS/DGII](https://img.shields.io/badge/Payroll-TSS%20%7C%20ISR%20Art.%20296-indigo.svg)](https://tss.gob.do)
[![EasyCount Integration](https://img.shields.io/badge/Engine-EasyCount%20API-emerald.svg)](https://easycount.getupsoft.com)

Repositorio centralizado y canónico del conjunto de módulos de **Localización Dominicana, Nómina TSS/DGII, Gastos Empresariales y Facturación Electrónica (e-CF)** para **Odoo ERP**. Este repositorio actúa como la **única fuente de verdad** para todos los clientes y despliegues de **EasyCount** y **GetUpSoft**.

Cualquier actualización regulatoria de la **DGII** (cambios en tipos de comprobantes, tasas de ITBIS, normativas de retención, formatos 606/607/608 o validaciones técnicas) o de la **TSS** (topes salariales mínimos, aportes SFS/AFP/SRL/INFOTEP) se implementa en este repositorio y se propaga automáticamente a todos los entornos de clientes.

---

## 📦 Contenido del Repositorio

| Módulo / Directorio | Descripción |
| :--- | :--- |
| `l10n_do_accounting/` | Módulo base de localización dominicana: Catálogo oficial de comprobantes e-CF (`E31`, `E32`, `E33`, `E34`, `E41`, `E43`, `E44`, `E45`, `E46`, `E47`), secuencias fiscales NCF/e-CF, retenciones de ley (15% ISR y 100% ITBIS para personas físicas), los 11 tipos oficiales de costos y gastos DGII, y wizard de conexión directa a la API de EasyCount. |
| `l10n_do_accounting_report/` | Módulo de generación de reportes fiscales para la DGII: Formato 606 (Compras), Formato 607 (Ventas) y Formato 608 (Comprobantes Anulados). |
| `l10n_do_hr_payroll/` | Módulo de Nómina Dominicana: Cálculo de retenciones de ley TSS (SFS 3.04%, AFP 2.87% con topes legales), retención progresiva de ISR sobre asalariados según Escala Anual/Mensual DGII (Art. 296), aportes patronales (SFS 7.09%, AFP 7.10%, SRL 1.20%, INFOTEP 1.00%) e imputación contable automática al gasto `01 - Gastos de Personal`. |
| `scripts/update-client-module.sh` | Script automatizado para actualizar los 3 módulos en el servidor de cualquier cliente en 1 solo comando. |

---

## 🏛️ Normativas DGII y Laborales Implementadas

### 1. Facturación Electrónica y Fiscalidad (DGII)
- **Ley 32-23:** Régimen de Facturación Electrónica obligatoria en la República Dominicana.
- **Ley 11-92:** Código Tributario de la República Dominicana.
- **Norma General 02-05:** Retención del 100% de ITBIS en servicios profesionales prestados por personas físicas a sociedades.
- **Retención del 15% de ISR:** Tasa vigente de retención de Impuesto Sobre la Renta (15%) para servicios profesionales, honorarios, comisiones y alquileres prestados por personas físicas a sociedades (conforme a las modificaciones normativas de la DGII / Ley 30-26).
- **Norma General 07-2018:** Obligatoriedad de RNC/Cédula en facturas de consumo iguales o superiores a RD$ 250,000.00.
- **Regímenes Especiales (`E44`):** Facturación obligatoria con tasa Exenta (0% ITBIS) para empresas bajo carnet de exención fiscal DGII (Zonas Francas, Ley 8-90, etc.).

### 2. Clasificación de Costos y Gastos Empresariales (Norma 07-2018)
El sistema clasifica de forma nativa e inmutable los 11 tipos oficiales de costos y gastos requeridos para el **Formato 606** y los comprobantes de compras **e-CF (`E41`, `E43`, `E44`, `E45`)**:
- `01`: **Gastos de Personal** (Nómina ordinaria, bonificaciones, preaviso y cesantía)
- `02`: **Gastos por Trabajos, Suministros y Servicios** (Honorarios profesionales con retención 15% ISR / 100% ITBIS)
- `03`: **Arrendamientos** (Alquiler de locales comerciales, naves o equipos)
- `04`: **Gastos de Activos Fijos** (Mantenimiento mayor y reparaciones que no se capitalizan)
- `05`: **Gastos de Representación** (Comidas, viajes y atenciones a clientes con límites de deducibilidad)
- `06`: **Otras Deducciones Admitidas** (Pérdidas extraordinarias, donaciones autorizadas Ley 11-92)
- `07`: **Gastos Financieros** (Intereses bancarios, comisiones y gastos por financiamiento)
- `08`: **Gastos Extraordinarios** (Operaciones no habituales del giro de negocio)
- `09`: **Compras y Gastos que forman parte del Costo de Venta** (Materia prima, mercancía para reventa, fletes directos)
- `10`: **Adquisiciones de Activos** (Compra de maquinaria, mobiliario, vehículos y activos fijos sujetos a depreciación Cat. 1, 2 y 3)
- `11`: **Gastos de Seguros** (Pólizas contra incendios, vehículos de la empresa, responsabilidad civil)

### 3. Nómina Dominicana y Seguridad Social (`l10n_do_hr_payroll`)
- **Ley 87-01:** Sistema Dominicano de Seguridad Social (SDSS).
- **Deducciones al Empleado:**
  - **SFS (Seguro Familiar de Salud):** `3.04%` (Tope legal: 10 Salarios Mínimos Nacionales = RD$ 193,525.00).
  - **AFP (Fondo de Pensiones):** `2.87%` (Tope legal: 20 Salarios Mínimos Nacionales = RD$ 387,050.00).
- **Retención de ISR Empleados (Art. 296 Código Tributario):**
  - Aplicado sobre la **Renta Neta Imponible** (`Salario Bruto - Aportes TSS Empleado`):
    - Hasta RD$ 34,685.00 mensual (RD$ 416,220.00 anual): **Exento (0%)**.
    - Desde RD$ 34,685.01 hasta RD$ 52,027.42 mensual: **15%** del excedente de RD$ 34,685.00.
    - Desde RD$ 52,027.43 hasta RD$ 72,260.25 mensual: **RD$ 2,601.36 + 20%** del excedente de RD$ 52,027.42.
    - Superior a RD$ 72,260.25 mensual: **RD$ 6,647.92 + 25%** del excedente de RD$ 72,260.25.
- **Aportes Patronales (Costos de la Empresa):**
  - **SFS Patronal:** `7.09%` (Tope: 10 SMN).
  - **AFP Patronal:** `7.10%` (Tope: 20 SMN).
  - **SRL (Riesgos Laborales):** `1.20%` base (Tope: 4 SMN).
  - **INFOTEP:** `1.00%` sobre la nómina total (sin tope).
- **Asiento Contable Automático:**
  - Los asientos de nómina generan automáticamente partidas de débito contra cuentas de gasto clasificadas bajo el tipo **`01 - Gastos de Personal`**, y créditos a pasivos de TSS por Pagar, DGII ISR Retenciones por Pagar (IR-3 / IR-4) y Sueldos por Pagar.

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

Cuando la DGII o la TSS publiquen una nueva resolución o cambio de especificación:

1. Se realiza la modificación y prueba en este repositorio (`odoo-l10n-do-ecf`).
2. Se hace push a la rama `main` (o se genera un tag de release, ej. `v20.1.0`).
3. El Administrador de EasyCount / GetUpSoft ejecuta el comando de actualización masiva desde la consola o el Panel de Integración:

```bash
# Comando ejecutado en el servidor del cliente:
bash <(curl -fsSL https://raw.githubusercontent.com/JoelStalin/odoo-l10n-do-ecf/main/scripts/update-client-module.sh) /ruta/addons nombre_db_cliente
```

O en entornos Dockerizados:
```bash
docker exec -it <contenedor_odoo> odoo -u l10n_do_accounting,l10n_do_accounting_report,l10n_do_hr_payroll -d <nombre_db> --stop-after-init
```

---

## 🔐 Seguridad y Restricción de Instaladores

> **Importante:** La descarga de paquetes ZIP y herramientas de despliegue en infraestructura de clientes está **restringida estrictamente a los Administradores de Plataforma**. Los usuarios de empresas clientes operan a través del portal y de sus credenciales API sin acceso directo a los archivos binarios de instalación.

---

## 📄 Licencia y Autoría

Desarrollado y mantenido por **GetUpSoft** & **EasyCount**.  
Contacto: `soporte@getupsoft.com` | `https://getupsoft.com`
