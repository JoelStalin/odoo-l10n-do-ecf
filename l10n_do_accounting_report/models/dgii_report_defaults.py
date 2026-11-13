"""Configuración de impuestos y cuentas que necesitan los formatos 606/607 (Norma General 07-2018).

El plan contable dominicano de Odoo crea los impuestos sin "Tipo de Impuesto en Compra" ni tipo de retención de ISR y
las cuentas sin tipo fiscal. Con eso el 606 reporta 0 en ITBIS retenido, ISR retenido e ITBIS llevado al costo.
Aquí se completa solo lo que esté vacío (nunca se cambia algo configurado a mano).

Base: Formato 606 (columnas ITBIS facturado, sujeto a proporcionalidad, llevado al costo, retenido, ISR retenido y
tipo de retención ISR); Código Tributario arts. 343, 346 y 349; Reglamento 293-11; Normas 02-05, 07-07, 08-10, 05-19.
"""
import logging

from odoo import api, models

_logger = logging.getLogger(__name__)

# Sufijo del xml_id del plan l10n_do de Odoo ("account.<id compañía>_<sufijo>") -> tipo de impuesto en compra
ITBIS_PAID = {
    "tax_18_purch", "tax_16_purch", "tax_18_purch_serv", "tax_18_importation", "tax_18_10_total_mount",
    "tax_18_property_cost", "tax_18_serv_cost", "tax_16_property_cost",
}
ITBIS_WITHHELD = {
    "ret_100_tax_security", "ret_100_tax_nonprofit", "ret_100_tax_person", "ret_75_tax_nonformal", "ret_30_tax_moral",
}
# ISR retenido -> tipo de retención del 606 (01 Alquileres, 02 Honorarios, 03 Otras rentas)
ISR_WITHHELD = {
    "ret_15_income_rent": "01",
    "ret_15_income_person": "02",
    "ret_3_income_person": "03",
    "ret_2_income_transfer": "03",
    "ret_3_income_article_70": "03",
    "ret_10_income_dividend": False,  # dividendos: van en el IR-17, no tienen tipo en el 606
}
# Pagos al exterior: van en el 609
FOREIGN = {"ret_27_income_remittance", "ret_15_income_foreign_royalties_technology"}
# Impuestos cuyo ITBIS se lleva al costo: su cuenta es la del ITBIS llevado al costo (tipo fiscal A51)
COST_TAXES = {"tax_18_property_cost", "tax_18_serv_cost", "tax_16_property_cost"}


class AccountTax(models.Model):
    _inherit = "account.tax"

    @api.model
    def _l10n_do_tax_suffix(self, tax):
        data = self.env["ir.model.data"].sudo().search(
            [("model", "=", "account.tax"), ("res_id", "=", tax.id), ("module", "in", ("account", "l10n_do"))], limit=1
        )
        if not data:
            return False
        name = data.name
        prefix = f"{tax.company_id.id}_"
        return name[len(prefix):] if name.startswith(prefix) else name

    @api.model
    def _l10n_do_apply_dgii_report_defaults(self):
        """Completa tipo de impuesto en compra, tipo de retención ISR y tipo fiscal A51. Devuelve los cambios hechos."""
        changes = []
        taxes = self.with_context(active_test=False).search([("type_tax_use", "=", "purchase")])
        for tax in taxes:
            suffix = self._l10n_do_tax_suffix(tax)
            if not suffix:
                continue
            vals = {}
            if tax.purchase_tax_type in (False, "none"):
                if suffix in ITBIS_PAID:
                    vals["purchase_tax_type"] = "itbis"
                elif suffix in ITBIS_WITHHELD:
                    vals["purchase_tax_type"] = "ritbis"
                elif suffix in ISR_WITHHELD:
                    vals["purchase_tax_type"] = "isr"
                elif suffix in FOREIGN:
                    vals["purchase_tax_type"] = "rext"
            if suffix in ISR_WITHHELD and ISR_WITHHELD[suffix] and not tax.isr_retention_type:
                vals["isr_retention_type"] = ISR_WITHHELD[suffix]
            if vals:
                tax.write(vals)
                changes.append((tax.name, vals))
            if suffix in COST_TAXES:
                accounts = tax.invoice_repartition_line_ids.filtered(lambda r: r.repartition_type == "tax").account_id
                accounts |= tax.refund_repartition_line_ids.filtered(lambda r: r.repartition_type == "tax").account_id
                for account in accounts.filtered(lambda a: not a.account_fiscal_type):
                    account.account_fiscal_type = "A51"
                    changes.append((account.display_name, {"account_fiscal_type": "A51"}))
        for name, vals in changes:
            _logger.info("l10n_do_accounting_report: %s -> %s", name, vals)
        return changes
