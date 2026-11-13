from . import controllers
from . import models
from . import wizard


def post_init_hook(env):
    """Al instalar: completa la configuración DGII de impuestos y cuentas (606/607)."""
    env["account.tax"]._l10n_do_apply_dgii_report_defaults()
