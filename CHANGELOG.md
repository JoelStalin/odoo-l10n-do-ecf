# Changelog — odoo-l10n-do-ecf

Formato: Keep a Changelog. Versionado: `20.0.x.y.z` (Odoo 20).

## [20.0.1.2.0] — 2026-11-11

Unifica en la localización global los cambios que estaban solo en Chefalitas (repo `JoelStalin/Chefalitas`,
commits 9eac350, 6d8a7f3, bd1fdc5, 565c9e2, cfb2ee2 y a8a740e) y en el servidor de Super Colmado Domingo Torres
(emulador de Modo Prueba). Se fusionó a mano: nada de lo que ya tenía este repositorio se quitó.

### Añadido

- **Emisión: espera de 85 s** (`ISSUE_TIMEOUT`) al llamar a `/invoices/issue`. Con 30 s Odoo cortaba mientras la DGII
  aún respondía y deshacía la factura aunque el e-CF ya se hubiera enviado. 85 s queda por debajo del límite de
  Cloudflare (100 s) y de Odoo (120 s).
- **Cabecera `User-Agent`** propia del cliente EasyCount.
- **Heartbeat con EasyCount** (`/heartbeat`): estado de conexión, bloqueo por plan o mensualidad y URL del túnel,
  visibles en Ajustes (campos relacionados con la compañía). El emulador también lo responde.
- **Modo Prueba local** (`EasyCountLocalTestEmulator`, venía del servidor de Domingo): solo en ambiente **TesteCF** y con
  token `TEST-`/`MODO-PRUEBA`/`SANDBOX-` o URL `emulador://`. Genera e-NCF, código de seguridad y XML de prueba
  **sin enviar nada a la DGII**. Implementa también heartbeat y validación de secuencias.
- **Clientes por RNC/Cédula**: al escribir un RNC/cédula válido en un campo de cliente se busca por `vat`; si no existe y la
  DGII lo conoce, se crea con nombre, tipo y régimen. Autocompletado al escribir el RNC o el nombre en el formulario,
  nombre mostrado `Nombre (RNC)` y caché de 10 min de las consultas a la DGII.
- **Factura**: si el cliente se llama solo con un RNC/cédula, se completa desde la DGII al elegirlo en la factura.

### Corregido

- **606/607**: el ITBIS facturado de ventas se reporta en positivo y el ITBIS ya no se duplica en "otros impuestos".
- **Ajustes de EasyCount**: los campos de estado son relacionados con la compañía (en Chefalitas se redefinían como
  campos propios del asistente y no mostraban el estado real).
- **Serie de los diarios de venta**: un emisor e-CF usa solo la serie **E** (`_get_journal_codes` devolvía E y B). Es lo
  que exige `test_ecf_enabled_flag` desde la versión inicial y lo que ya hacía Chefalitas.

### Sin cambios a propósito

- URL por defecto de EasyCount: `https://easycount.me` (antes `https://api.getupsoft.com.do`; ambas responden).
  Solo afecta a compañías nuevas.

### Conocido (previo a este cambio)

- `test_04_deferred_company_keeps_invoice_pending_when_offline` falla desde #6: con EasyCount caído tampoco se puede
  asignar el e-NCF, así que una empresa con envío diferido no puede publicar. Requiere decidir la asignación en contingencia.

### Instalación

- Actualizar el módulo (`-u l10n_do_accounting,l10n_do_accounting_report`): hay campos nuevos en `res.company`.

## [20.0.1.1.0] — 2026-10-16

Compatibilidad real con Odoo 20 en `l10n_do_hr_payroll`. Los otros dos módulos ya estaban migrados.

### Corregido

- **ACL al formato de Odoo 20**: `security/ir.model.access.csv` (perm_read/perm_write/perm_create/
  perm_unlink) → **`security/ir.access.csv`** (id,name,model_id,group_id/id,operation,domain).
  `operation` es un subconjunto de `crud` con semántica verificada en el core:
  r = read, u = write, c = create, d = unlink. Sin esto Odoo 20 aborta con
  `KeyError: 'ir.model.access'` porque el modelo se llama `ir.access`.
- **`<tree>` → `<list>`** (2 apariciones).
- **`attrs="{'readonly': ...}"` → `readonly="..."`** (7 campos): Odoo 20 aborta con
  "Since 17.0, the attrs and states attributes are no longer used".
- **`states="..."` en botones → `invisible="..."`** (2 botones).
- **Versión**: 20.0.1.0.0 → 20.0.1.1.0.

### Instalación para clientes

- Requiere **Odoo 20 CE**. El módulo es **LGPL-3**; no incluye ni depende de Odoo Enterprise.
- Depende de `hr` y `l10n_do_accounting` (de este repositorio).
- Al actualizar hay que **actualizar el módulo** (`-u l10n_do_hr_payroll` o Apps → Actualizar):
  cambió el nombre del archivo de ACL, no basta con reiniciar.

### Verificación

- Escáner de compatibilidad Odoo 20: **0 hallazgos** en los 3 módulos.
- Todos los XML parsean tras la migración; 57 archivos .py compilan.
