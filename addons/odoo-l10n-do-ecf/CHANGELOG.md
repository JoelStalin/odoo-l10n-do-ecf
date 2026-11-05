# Changelog — odoo-l10n-do-ecf

Formato: Keep a Changelog. Versionado: `20.0.x.y.z` (Odoo 20).

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
