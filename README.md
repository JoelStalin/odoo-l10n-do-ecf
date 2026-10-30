# Odoo 20 ORCA & EasyCount Global Client Addons (`odoo-orca-global-addons`)

Repositorio global oficial de **GetUpSoft / ORCA / EasyCount** para el despliegue automatizado e instalación de módulos en instancias de clientes Odoo 20:

## Módulos Incluidos
1. **`orca_stock_logistics_barcode` (`20.0.1.0.0`)**:
   - Gestión avanzada de códigos de barras en inventarios (`stock.picking`, `stock.inventory`, `stock.quant`) basada en OCA v19 → v20.
   - **Jerarquía de Empaques (`product.packaging` vs Unidad)**: Búsqueda unificada en `product.product.barcode` y `product.packaging.barcode` con multiplicación automática por `qty_per_box` (`effective_unit_factor`).
   - **Detección Tipológica y Enriquecimiento API (`Open Food Facts`)**: Clasificación automática (`EAN-13`, `UPC-A`, `EAN-8`, `ITF-14`, `GS1` con peso incrustado) y creación de productos al vuelo.
   - **Rendimiento Extremo**: Caché local en cliente **OWL + IndexedDB** (`orca_barcode_cache_v20`) + cola de lotes RPC para pistola láser continua e índices parciales B-Tree en PostgreSQL.
2. **`l10n_do_accounting`**: Facturación Electrónica e-CF (DGII República Dominicana) + Conector EasyCount.
3. **`l10n_do_accounting_report`**: Reportes fiscales DGII (606, 607, 608).
4. **`l10n_do_hr_payroll`**: Nómina Dominicana (TSS / ISR / INFOTEP).

## Instalación Automática vía EasyCount One-Liner
```bash
curl -sSL https://easycount.me/api/v1/integrations/odoo/deploy-odoo20.sh | sudo bash -s -- --token="<TOKEN>" --rnc="<RNC>" --name="<EMPRESA>"
```

## Actualización Rápida en Servidores de Clientes Existentes
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JoelStalin/odoo-orca-global-addons/main/scripts/update-client-module.sh) /opt/odoo/extra-addons <odoo_db>
```
