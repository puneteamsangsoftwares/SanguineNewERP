package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

public class clsCheckOutRoomDtlBean {

	// Variable Declaration

	private String strRoomNo;
	private String strRegistrationNo;
	private String strFolioNo;
	private String strReservationNo;
	private String strGuestName;
	private double dblAmount;
	private String dteCheckInDate;
	private String dteCheckOutDate;
	private String strCorporate;
	private String strRoomDesc;
	private String strRemoveTax;
	// getters and setters
	private String strRevenueType;
	
	private String strBillMergeNumber;
	
	public String getStrBillMergeNumber() {
		return strBillMergeNumber;
	}

	public void setStrBillMergeNumber(String strBillMergeNumber) {
		this.strBillMergeNumber = strBillMergeNumber;
	}

	List<clsCheckOutRoomDtlBean> listRevenueTypeDtl= new ArrayList<>();
	
	
	public List<clsCheckOutRoomDtlBean> getListRevenueTypeDtl() {
		return listRevenueTypeDtl;
	}

	public void setListRevenueTypeDtl(List<clsCheckOutRoomDtlBean> listRevenueTypeDtl) {
		this.listRevenueTypeDtl = listRevenueTypeDtl;
	}

	public String getStrRoomNo() {
		return strRoomNo;
	}

	public void setStrRoomNo(String strRoomNo) {
		this.strRoomNo = strRoomNo;
	}

	public String getStrRegistrationNo() {
		return strRegistrationNo;
	}

	public void setStrRegistrationNo(String strRegistrationNo) {
		this.strRegistrationNo = strRegistrationNo;
	}

	public String getStrFolioNo() {
		return strFolioNo;
	}

	public void setStrFolioNo(String strFolioNo) {
		this.strFolioNo = strFolioNo;
	}

	public String getStrGuestName() {
		return strGuestName;
	}

	public void setStrGuestName(String strGuestName) {
		this.strGuestName = strGuestName;
	}

	public double getDblAmount() {
		return dblAmount;
	}

	public void setDblAmount(double dblAmount) {
		this.dblAmount = dblAmount;
	}

	public String getDteCheckInDate() {
		return dteCheckInDate;
	}

	public void setDteCheckInDate(String dteCheckInDate) {
		this.dteCheckInDate = dteCheckInDate;
	}

	public String getDteCheckOutDate() {
		return dteCheckOutDate;
	}

	public void setDteCheckOutDate(String dteCheckOutDate) {
		this.dteCheckOutDate = dteCheckOutDate;
	}

	public String getStrCorporate() {
		return strCorporate;
	}

	public void setStrCorporate(String strCorporate) {
		this.strCorporate = strCorporate;
	}

	public String getStrReservationNo() {
		return strReservationNo;
	}

	public void setStrReservationNo(String strReservationNo) {
		this.strReservationNo = strReservationNo;
	}

	public String getStrRoomDesc() {
		return strRoomDesc;
	}

	public void setStrRoomDesc(String strRoomDesc) {
		this.strRoomDesc = strRoomDesc;
	}

	public String getStrRemoveTax() {
		return strRemoveTax;
	}

	public void setStrRemoveTax(String strRemoveTax) {
		this.strRemoveTax = strRemoveTax;
	}

	public String getStrRevenueType() {
		return strRevenueType;
	}

	public void setStrRevenueType(String strRevenueType) {
		this.strRevenueType = strRevenueType;
	}

	

}
