package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

public class clsPMSMergeBillBean {
	
	private String strFromBillNo;
	
	private String strFolioNo;
	
	private String strCheckInNo;
	
	private double dblDblTotal;
	
	private String strMergeButton;
	
	private String strRevertButton;
	
	private String strToBillNo;
	
	private String strReasonCode;
	
	private String strReasonDesc;
	
	private String strRemarks;
	
	private String strIsBillSelected;
	
	private String strDocNo;
	
	
	
	List<clsPMSMergeBillBean> listMergeBill = new ArrayList<clsPMSMergeBillBean>();

	

	public String getStrFolioNo() {
		return strFolioNo;
	}

	public void setStrFolioNo(String strFolioNo) {
		this.strFolioNo = strFolioNo;
	}

	public String getStrCheckInNo() {
		return strCheckInNo;
	}

	public void setStrCheckInNo(String strCheckInNo) {
		this.strCheckInNo = strCheckInNo;
	}

	
	public List<clsPMSMergeBillBean> getListMergeBill() {
		return listMergeBill;
	}

	public void setListMergeBill(List<clsPMSMergeBillBean> listMergeBill) {
		this.listMergeBill = listMergeBill;
	}

	public double getDblDblTotal() {
		return dblDblTotal;
	}

	public void setDblDblTotal(double dblDblTotal) {
		this.dblDblTotal = dblDblTotal;
	}

	public String getStrMergeButton() {
		return strMergeButton;
	}

	public void setStrMergeButton(String strMergeButton) {
		this.strMergeButton = strMergeButton;
	}

	public String getStrRevertButton() {
		return strRevertButton;
	}

	public void setStrRevertButton(String strRevertButton) {
		this.strRevertButton = strRevertButton;
	}

	public String getStrFromBillNo() {
		return strFromBillNo;
	}

	public void setStrFromBillNo(String strFromBillNo) {
		this.strFromBillNo = strFromBillNo;
	}

	public String getStrToBillNo() {
		return strToBillNo;
	}

	public void setStrToBillNo(String strToBillNo) {
		this.strToBillNo = strToBillNo;
	}

	public String getStrReasonCode() {
		return strReasonCode;
	}

	public void setStrReasonCode(String strReasonCode) {
		this.strReasonCode = strReasonCode;
	}

	public String getStrReasonDesc() {
		return strReasonDesc;
	}

	public void setStrReasonDesc(String strReasonDesc) {
		this.strReasonDesc = strReasonDesc;
	}

	public String getStrRemarks() {
		return strRemarks;
	}

	public void setStrRemarks(String strRemarks) {
		this.strRemarks = strRemarks;
	}

	public String getStrIsBillSelected() {
		return strIsBillSelected;
	}

	public void setStrIsBillSelected(String strIsBillSelected) {
		this.strIsBillSelected = strIsBillSelected;
	}

	public String getStrDocNo() {
		return strDocNo;
	}

	public void setStrDocNo(String strDocNo) {
		this.strDocNo = strDocNo;
	}

}
