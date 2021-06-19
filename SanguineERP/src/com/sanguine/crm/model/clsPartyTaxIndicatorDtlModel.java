package com.sanguine.crm.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@SuppressWarnings("serial")
// @Entity
// @Table(name="tblpartytaxdtl")
public class clsPartyTaxIndicatorDtlModel implements Serializable {
	// @GeneratedValue
	// @Id
	@Column(name = "intId")
	private long intId;


	@Column(name = "strTaxCode", columnDefinition = "VARCHAR(20) NOT NULL default ''")
	private String strTaxCode;

	public String getStrTaxCode() {
		return strTaxCode;
	}

	public void setStrTaxCode(String strTaxCode) {
		this.strTaxCode = strTaxCode;
	}

	
}
