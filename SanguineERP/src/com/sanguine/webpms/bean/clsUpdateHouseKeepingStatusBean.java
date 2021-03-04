package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

public class clsUpdateHouseKeepingStatusBean {
	// Variable Declaration

	private String strRoomNo;
	private String strRoomDesc;
	private String strRoomFlag;
	private String strHouseKeepingCode;
	private String strHouseKeepingName;
	private String strHouseKeepingFlag;
	
	
	List<clsUpdateHouseKeepingStatusBean> listUpdateHouseKeepingStatusBean = new ArrayList<clsUpdateHouseKeepingStatusBean>();

	
	
	// Setter-Getter Methods
	public String getStrRoomNo() {
		return strRoomNo;
	}
	public void setStrRoomNo(String strRoomNo) {
		this.strRoomNo = strRoomNo;
	}
	public String getStrRoomFlag() {
		return strRoomFlag;
	}
	public void setStrRoomFlag(String strRoomFlag) {
		this.strRoomFlag = strRoomFlag;
	}
	public String getStrHouseKeepingName() {
		return strHouseKeepingName;
	}
	public void setStrHouseKeepingName(String strHouseKeepingName) {
		this.strHouseKeepingName = strHouseKeepingName;
	}
	public String getStrHouseKeepingFlag() {
		return strHouseKeepingFlag;
	}
	public void setStrHouseKeepingFlag(String strHouseKeepingFlag) {
		this.strHouseKeepingFlag = strHouseKeepingFlag;
	}
	

	public String getStrHouseKeepingCode() {
		return strHouseKeepingCode;
	}
	public void setStrHouseKeepingCode(String strHouseKeepingCode) {
		this.strHouseKeepingCode = strHouseKeepingCode;
	}


	public List<clsUpdateHouseKeepingStatusBean> getListUpdateHouseKeepingStatusBean() {
		return listUpdateHouseKeepingStatusBean;
	}
	public void setListUpdateHouseKeepingStatusBean(
			List<clsUpdateHouseKeepingStatusBean> listUpdateHouseKeepingStatusBean) {
		this.listUpdateHouseKeepingStatusBean = listUpdateHouseKeepingStatusBean;
	}
	
	
	public String getStrRoomDesc() {
		return strRoomDesc;
	}
	public void setStrRoomDesc(String strRoomDesc) {
		this.strRoomDesc = strRoomDesc;
	}
	


	

}
