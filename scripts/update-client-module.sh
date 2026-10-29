#!/usr/bin/env bash
# ==============================================================================
# GetUpSoft / EasyCount / ORCA — Script de Instalación y Sincronización Global
# Repositorio Global: https://github.com/JoelStalin/odoo-orca-global-addons
# ==============================================================================
set -euo pipefail

REPO_URL="${EASYCOUNT_GLOBAL_REPO_URL:-https://github.com/JoelStalin/odoo-orca-global-addons.git}"
BRANCH="${EASYCOUNT_GLOBAL_BRANCH:-main}"
TARGET_ADDONS_DIR="${1:-/opt/odoo/extra-addons}"
ODOO_DB="${2:-}"
ODOO_BIN="${ODOO_BIN:-/opt/odoo/odoo20-venv/bin/python3 /opt/odoo/odoo20/odoo-bin}"
ODOO_CONF="${ODOO_CONF:-/opt/odoo/config/odoo.conf}"

echo "=================================================================="
echo " GetUpSoft / EasyCount / ORCA — Sincronización Global de Addons"
echo " Repositorio : $REPO_URL ($BRANCH)"
echo " Destino     : $TARGET_ADDONS_DIR"
echo "=================================================================="

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "[1/3] Descargando última versión desde GitHub..."
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMP_DIR/repo"

echo "[2/3] Sincronizando módulos en $TARGET_ADDONS_DIR..."
mkdir -p "$TARGET_ADDONS_DIR"

for mod in l10n_do_accounting l10n_do_accounting_report l10n_do_hr_payroll orca_stock_logistics_barcode; do
  if [ -d "$TMP_DIR/repo/$mod" ]; then
    rm -rf "$TARGET_ADDONS_DIR/$mod"
    cp -r "$TMP_DIR/repo/$mod" "$TARGET_ADDONS_DIR/$mod"
    echo "  -> Módulo sincronizado: $mod"
  fi
done

if [ -n "$ODOO_DB" ]; then
  echo "[3/3] Instalando/actualizando módulos en la base de datos: $ODOO_DB..."
  $ODOO_BIN -c "$ODOO_CONF" -d "$ODOO_DB" \
    -i orca_stock_logistics_barcode \
    -u l10n_do_accounting,l10n_do_accounting_report,orca_stock_logistics_barcode \
    --stop-after-init
  echo "  -> Base de datos $ODOO_DB actualizada exitosamente."
else
  echo "[3/3] Archivos sincronizados. (Omitiendo -u/-i en BD porque no se especificó nombre de BD)."
fi

echo "=================================================================="
echo " Sincronización completada con éxito."
echo "=================================================================="
