package com.sanguine.webpms.bean;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;


public class clsInvoiceFormatHsnBean implements Serializable {

	// Variable Declaration	
	private String strHsn;

	private double dblTaxableValue;

	private String strCentralTaxRate;

	private double dblCentralTaxAmount;

	private String strStateTaxRate;

	private double dblStateTaxAmount;

	private double dblTotalAmt;

	
	
	public String getStrHsn() {
		return strHsn;
	}



	public void setStrHsn(String strHsn) {
		this.strHsn = strHsn;
	}



	public double getDblTaxableValue() {
		return dblTaxableValue;
	}



	public void setDblTaxableValue(double dblTaxableValue) {
		this.dblTaxableValue = dblTaxableValue;
	}



	public String getStrCentralTaxRate() {
		return strCentralTaxRate;
	}



	public void setStrCentralTaxRate(String strCentralTaxRate) {
		this.strCentralTaxRate = strCentralTaxRate;
	}



	public double getDblCentralTaxAmount() {
		return dblCentralTaxAmount;
	}



	public void setDblCentralTaxAmount(double dblCentralTaxAmount) {
		this.dblCentralTaxAmount = dblCentralTaxAmount;
	}



	public String getDblStateTaxRate() {
		return strStateTaxRate;
	}



	public void setStrStateTaxRate(String strStateTaxRate) {
		this.strStateTaxRate = strStateTaxRate;
	}



	public double getDblStateTaxAmount() {
		return dblStateTaxAmount;
	}



	public void setDblStateTaxAmount(double dblStateTaxAmount) {
		this.dblStateTaxAmount = dblStateTaxAmount;
	}



	public double getDblTotalAmt() {
		return dblTotalAmt;
	}



	public void setDblTotalAmt(double dblTotalAmt) {
		this.dblTotalAmt = dblTotalAmt;
	}



	// Function to Set Default Values
	private Object setDefaultValue(Object value, Object defaultValue) {
		if (value != null && (value instanceof String && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Double && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Integer && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Long && value.toString().length() > 0)) {
			return value;
		} else {
			return defaultValue;
		}
	}
	
	

}
