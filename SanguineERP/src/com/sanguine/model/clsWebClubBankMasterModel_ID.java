package com.sanguine.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@SuppressWarnings("serial")
public class clsWebClubBankMasterModel_ID implements Serializable {

	// Variable Declaration
	@Column(name = "strBankCode")
	private String strBankCode;

	@Column(name = "strClientCode")
	private String strClientCode;

	public clsWebClubBankMasterModel_ID() {
	}

	public clsWebClubBankMasterModel_ID(String strBankCode, String strClientCode) {
		this.strBankCode = strBankCode;
		this.strClientCode = strClientCode;
	}

	// Setter-Getter Methods
	public String getStrBankCode() {
		return strBankCode;
	}

	public void setStrBankCode(String strBankCode) {
		this.strBankCode = strBankCode;
	}

	public String getStrClientCode() {
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode) {
		this.strClientCode = strClientCode;
	}

	// HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsWebClubBankMasterModel_ID objModelId = (clsWebClubBankMasterModel_ID) obj;
		if (this.strBankCode.equals(objModelId.getStrBankCode()) && this.strClientCode.equals(objModelId.getStrClientCode())) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strBankCode.hashCode() + this.strClientCode.hashCode();
	}

}
