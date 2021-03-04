package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

public class clsPMSMergeBillBean {
	
	private String strBillNo;
	
	private String strFolioNo;
	
	private String strCheckInNo;
	
	private double dblDblTotal;
	
	private String strMergeButton;
	
	private String strRevertButton;
	
	
	
	List<clsPMSMergeBillBean> listMergeBill = new ArrayList<clsPMSMergeBillBean>();

	public String getStrBillNo() {
		return strBillNo;
	}

	public void setStrBillNo(String strBillNo) {
		this.strBillNo = strBillNo;
	}

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

}
