package com.sanguine.model;

import java.sql.Blob;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;


@Entity
@Table(name = "tblcompanylogomodel")
public class clsCompanyLogoModel {

	@Id
	@Column(name = "strCompanyCode")
	private String strCompanyCode;

	@Column(name = "strCompanyLogo", length = 100000, nullable = false)
	@Lob
	@Basic(fetch = FetchType.LAZY)
	@JsonIgnore
	private byte[] strCompanyLogo;

	public String getStrCompanyCode() {
		return strCompanyCode;
	}

	public void setStrCompanyCode(String strCompanyCode) {
		this.strCompanyCode = strCompanyCode;
	}

	public byte[] getStrCompanyLogo() {
		return strCompanyLogo;
	}

	public void setStrCompanyLogo(byte[] strCompanyLogo) {
		this.strCompanyLogo = strCompanyLogo;
	}

}