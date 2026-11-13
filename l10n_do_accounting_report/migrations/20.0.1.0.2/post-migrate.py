from odoo import SUPERUSER_ID, api


def migrate(cr, version):
    """Completa la configuración DGII de impuestos y cuentas que faltaba (solo campos vacíos)."""
    env = api.Environment(cr, SUPERUSER_ID, {})
    env["account.tax"]._l10n_do_apply_dgii_report_defaults()
