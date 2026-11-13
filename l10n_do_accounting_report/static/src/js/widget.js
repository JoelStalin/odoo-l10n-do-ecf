import { _t } from "@web/core/l10n/translation";
import { registry } from "@web/core/registry";
import { session } from "@web/session";
import { standardFieldProps } from "@web/views/fields/standard_field_props";
import { Component, t, useProps, xml } from "@odoo/owl";

const RNC_URL = "https://dgii.gov.do/app/WebApps/ConsultasWeb/consultas/rnc.aspx";
const NCF_URL = "https://dgii.gov.do/app/WebApps/ConsultasWeb/consultas/ncf.aspx";
const NCF_PATTERN = /^[BE]\d{10}$/;

/**
 * Enlace a la consulta pública de la DGII para un RNC/cédula o un NCF/e-CF.
 * Devuelve "" si no se puede formar (sin valor, o un NCF sin RNC del emisor).
 */
export function dgiiConsultaUrl(value, { isRnc = false, isModify = false, recordData = {}, companyRnc = "" } = {}) {
    const text = (value || "").toString().trim();
    if (!text) {
        return "";
    }
    if (isRnc) {
        return `${RNC_URL}?txtRnc=${encodeURIComponent(text)}`;
    }
    if (isModify || NCF_PATTERN.test(text)) {
        const rnc = recordData.rnc_cedula || recordData.company_rnc_field || companyRnc || "";
        if (!rnc) {
            return "";
        }
        return `${NCF_URL}?txtRnc=${encodeURIComponent(rnc)}&txtNcf=${encodeURIComponent(text)}`;
    }
    return "";
}

export class DgiiReportsUrlField extends Component {
    static template = xml`
        <a t-if="this.url" t-att-href="this.url" target="_blank" rel="noopener noreferrer" class="o_field_text" t-out="this.value"/>
        <span t-else="" class="o_field_text" t-out="this.value"/>
    `;
    props = useProps({
        ...standardFieldProps,
        isRnc: t.boolean().optional(false),
        isModify: t.boolean().optional(false),
    });

    get value() {
        return this.props.record.data[this.props.name] || "";
    }

    get url() {
        return dgiiConsultaUrl(this.value, {
            isRnc: this.props.isRnc,
            isModify: this.props.isModify,
            recordData: this.props.record.data,
            companyRnc: session.company_rnc || "",
        });
    }
}

registry.category("fields").add("dgii_reports_url", {
    component: DgiiReportsUrlField,
    displayName: _t("Enlace a consulta DGII"),
    supportedTypes: ["char"],
    extractProps: ({ options }) => ({
        isRnc: Boolean(options.is_rnc),
        isModify: Boolean(options.is_modify),
    }),
});
