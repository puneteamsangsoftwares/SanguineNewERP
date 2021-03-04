package com.sanguine.webpms.bean;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;


public class clsInvoiceFormatBean implements Serializable {

	// Variable Declaration
	
	private String strSrNo;
	
	private String  strDescGoods;
	
	private String strDescGoodsOutput;

	private String strHsn;

	private String strQuantity;

	private String strRate;

	private String strPer;

	private double dblAmount;
	
	private String strHsnTable2;

	private double dblTaxableValue;

	private double dblTaxableValueTotal;

	private double dblCentralTaxRate;

	private double dblCentralTaxAmount;

	private double dblCentralTaxAmountTotal;

	private double dblStateTaxRate;

	private double dblStateTaxAmount;

	private double dblStateTaxAmountTotal;
	
	private double dblTotalAmt;	
	
	private String strCentralTaxRate;

	private String strStateTaxRate;
	
	private double dblTotalAmtTotal;

	
	
	public double getDblAmount() {
		return dblAmount;
	}

	public void setDblAmount(double dblAmount) {
		this.dblAmount = dblAmount;
	}

	public String getStrCentralTaxRate() {
		return strCentralTaxRate;
	}

	public void setStrCentralTaxRate(String strCentralTaxRate) {
		this.strCentralTaxRate = strCentralTaxRate;
	}

	public String getStrStateTaxRate() {
		return strStateTaxRate;
	}

	public void setStrStateTaxRate(String strStateTaxRate) {
		this.strStateTaxRate = strStateTaxRate;
	}



	public double getDblTotalAmt() {
		return dblTotalAmt;
	}

	public void setDblTotalAmt(double dblTotalAmt) {
		this.dblTotalAmt = dblTotalAmt;
	}

	public void setStrDescGoodsOutput(String strDescGoodsOutput) {
		this.strDescGoodsOutput = strDescGoodsOutput;
	}

	public String getStrHsn() {
		return strHsn;
	}


	public void setStrHsn(String strHsn) {
		this.strHsn = strHsn;
	}

	public String getStrQuantity() {
		return strQuantity;
	}

	public void setStrQuantity(String strQuantity) {
		this.strQuantity = strQuantity;
	}

	public String getStrRate() {
		return strRate;
	}

	public void setStrRate(String strRate) {
		this.strRate = strRate;
	}

	public String getStrPer() {
		return strPer;
	}

	public void setStrPer(String strPer) {
		this.strPer = strPer;
	}

	public double getStrAmount() {
		return dblAmount;
	}

	public void setStrAmount(double dblAmount) {
		this.dblAmount = dblAmount;
	}

	public double getDblTaxableValue() {
		return dblTaxableValue;
	}

	public void setDblTaxableValue(double dblTaxableValue) {
		this.dblTaxableValue = dblTaxableValue;
	}

	public double getDblTaxableValueTotal() {
		return dblTaxableValueTotal;
	}
	public void setDblTaxableValueTotal(double dblTaxableValueTotal) {
		this.dblTaxableValueTotal = dblTaxableValueTotal;
	}

	public String getStrDescGoods() {
		return strDescGoods;
	}

	public void setStrDescGoods(String strDescGoods) {
		this.strDescGoods = strDescGoods;
	}

	public double getDblCentralTaxRate() {
		return dblCentralTaxRate;
	}

	public void setDblCentralTaxRate(double dblCentralTaxRate) {
		this.dblCentralTaxRate = dblCentralTaxRate;
	}
	
	public double getDblCentralTaxAmount() {
		return dblCentralTaxAmount;
	}

	public void setDblCentralTaxAmount(double dblCentralTaxAmount) {
		this.dblCentralTaxAmount = dblCentralTaxAmount;
	}

	public double getDblCentralTaxAmountTotal() {
		return dblCentralTaxAmountTotal;
	}

	public void setDblCentralTaxAmountTotal(double dblCentralTaxAmountTotal) {
		this.dblCentralTaxAmountTotal = dblCentralTaxAmountTotal;
	}

	public String getStrHsnTable2() {
		return strHsnTable2;
	}

	public void setStrHsnTable2(String strHsnTable2) {
		this.strHsnTable2 = strHsnTable2;
	}

	public String getStrDescGoodsOutput() {
		return strDescGoodsOutput;
	}

	public double getDblStateTaxRate() {
		return dblStateTaxRate;
	}

	public void setDblStateTaxRate(double dblStateTaxRate) {
		this.dblStateTaxRate = dblStateTaxRate;
	}


	public double getDblStateTaxAmount() {
		return dblStateTaxAmount;
	}


	public void setDblStateTaxAmount(double dblStateTaxAmount) {
		this.dblStateTaxAmount = dblStateTaxAmount;
	}

	public double getDblStateTaxAmountTotal() {
		return dblStateTaxAmountTotal;
	}


	public void setDblStateTaxAmountTotal(double dblStateTaxAmountTotal) {
		this.dblStateTaxAmountTotal = dblStateTaxAmountTotal;
	}

	
	public String getStrSrNo() {
		return strSrNo;
	}

	public void setStrSrNo(String strSrNo) {
		this.strSrNo = strSrNo;
	}


	
	
	public double getDblTotalAmtTotal() {
		return dblTotalAmtTotal;
	}

	public void setDblTotalAmtTotal(double dblTotalAmtTotal) {
		this.dblTotalAmtTotal = dblTotalAmtTotal;
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
