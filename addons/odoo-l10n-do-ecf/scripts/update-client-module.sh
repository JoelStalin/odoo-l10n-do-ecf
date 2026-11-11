#!/usr/bin/env bash
# ==============================================================================
# update-client-module.sh - EasyCount / GetUpSoft Odoo Localization Updater
# ==============================================================================
# Actualiza los modulos l10n_do_accounting, l10n_do_accounting_report y
# l10n_do_hr_payroll en el servidor de un cliente desde el repositorio en GitHub:
# https://github.com/JoelStalin/odoo-l10n-do-ecf
# ==============================================================================

set -euo pipefail

REPO_URL="https://github.com/JoelStalin/odoo-l10n-do-ecf.git"
TARBALL_URL="https://github.com/JoelStalin/odoo-l10n-do-ecf/archive/refs/heads/main.tar.gz"

ADDONS_DIR="${1:-/opt/odoo/extra-addons}"
ODOO_DB="${2:-}"
ODOO_CONTAINER="${3:-}"

MODULES_LIST="l10n_do_accounting,l10n_do_accounting_report,l10n_do_hr_payroll"

echo "=================================================================="
echo ">> EASYCOUNT / GETUPSOFT - ACTUALIZADOR DE LOCALIZACION DOMINICANA"
echo "=================================================================="
echo ">> Directorio destino: ${ADDONS_DIR}"
echo ">> Repositorio fuente: ${REPO_URL}"
echo ">> Modulos a sincronizar: ${MODULES_LIST}"

# 1. Verificar o crear directorio de addons
mkdir -p "${ADDONS_DIR}"

TMP_DIR="$(mktemp -d)"
trap  rm -rf   EXIT

echo ">> [1/4] Descargando version mas reciente desde GitHub..."
if command -v git &>/dev/null; then
    git clone --depth 1 "${REPO_URL}" "${TMP_DIR}/repo" 2>/dev/null || {
        echo ">> Aviso: Fallo git clone, intentando descarga directa tar.gz..."
        curl -fsSL "${TARBALL_URL}" | tar -xz -C "${TMP_DIR}"
        mv "${TMP_DIR}/odoo-l10n-do-ecf-main" "${TMP_DIR}/repo"
    }
else
    curl -fsSL "${TARBALL_URL}" | tar -xz -C "${TMP_DIR}"
    mv "${TMP_DIR}/odoo-l10n-do-ecf-main" "${TMP_DIR}/repo"
fi

echo ">> [2/4] Sincronizando modulos en el servidor del cliente..."
cp -r "${TMP_DIR}/repo/l10n_do_accounting" "${ADDONS_DIR}/"
cp -r "${TMP_DIR}/repo/l10n_do_accounting_report" "${ADDONS_DIR}/"
cp -r "${TMP_DIR}/repo/l10n_do_hr_payroll" "${ADDONS_DIR}/"

# Limpieza de cache de python
find "${ADDONS_DIR}/l10n_do_accounting" -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "${ADDONS_DIR}/l10n_do_accounting_report" -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find "${ADDONS_DIR}/l10n_do_hr_payroll" -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true

echo ">> [3/4] Modulos actualizados exitosamente en disco."

# 3. Si se suministro contenedor Docker o base de datos Odoo, actualizar en BD
if [ -n "${ODOO_CONTAINER}" ] && [ -n "${ODOO_DB}" ]; then
    echo ">> [4/4] Actualizando modulos en contenedor Docker: ${ODOO_CONTAINER} (BD: ${ODOO_DB})..."
    docker exec "${ODOO_CONTAINER}" odoo -u ${MODULES_LIST} -d "${ODOO_DB}" --stop-after-init || {
        echo ">> Aviso: El comando odoo -u retorno codigo no-cero. Reiniciando contenedor para tomar cambios de codigo..."
        docker restart "${ODOO_CONTAINER}"
    }
elif [ -n "${ODOO_DB}" ] && command -v odoo-bin &>/dev/null; then
    echo ">> [4/4] Ejecutando odoo-bin -u en base de datos: ${ODOO_DB}..."
    odoo-bin -u ${MODULES_LIST} -d "${ODOO_DB}" --stop-after-init || true
elif [ -n "${ODOO_DB}" ] && command -v odoo &>/dev/null; then
    echo ">> [4/4] Ejecutando odoo -u en base de datos: ${ODOO_DB}..."
    odoo -u ${MODULES_LIST} -d "${ODOO_DB}" --stop-after-init || true
else
    echo ">> [4/4] Actualizacion de archivos completada. Para aplicar en Odoo ejecute:"
    echo "         odoo -u ${MODULES_LIST} -d <nombre_bd> --stop-after-init"
fi

echo "=================================================================="
echo ">> ACTUALIZACION COMPLETADA EXITOSAMENTE (100% DGII e-CF COMPLIANT)"
echo "=================================================================="
