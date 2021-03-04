package com.sanguine.webpms.bean;


import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;



public class clsUnBlockRoomBean {
	
	private String strRoomCode;
	private String strRoomType;
	private String strClientCode;
	private String strRemarks;
	private String strReason;
	
	private String dteValidFrom;
	private String dteValidTo;
	private String strRoomDesc;
	private String strRoomTypeDesc;
	private String strUnBlockRoomFlag;
	private List<clsUnBlockRoomBean> listOfUnblockRoom = new ArrayList<clsUnBlockRoomBean>();;
	
	private JSONArray jsonArrBlockRooms= new JSONArray();
	
	public List<clsUnBlockRoomBean> getListOfUnblockRoom() {
		return listOfUnblockRoom;
	}
	public void setListOfUnblockRoom(List<clsUnBlockRoomBean> listOfUnblockRoom) {
		this.listOfUnblockRoom = listOfUnblockRoom;
	}
	
	public String getStrUnBlockRoomFlag() {
		return strUnBlockRoomFlag;
	}
	public void setStrUnBlockRoomFlag(String strUnBlockRoomFlag) {
		this.strUnBlockRoomFlag = strUnBlockRoomFlag;
	}
	public String getStrRoomCode() {
		return strRoomCode;
	}
	public void setStrRoomCode(String strRoomCode) {
		this.strRoomCode = strRoomCode;
	}
	public String getStrRoomType() {
		return strRoomType;
	}
	public void setStrRoomType(String strRoomType) {
		this.strRoomType = strRoomType;
	}
	public String getStrClientCode() {
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode) {
		this.strClientCode = strClientCode;
	}
	public String getStrRemarks() {
		return strRemarks;
	}
	public void setStrRemarks(String strRemarks) {
		this.strRemarks = strRemarks;
	}
	public String getStrReason() {
		return strReason;
	}
	public void setStrReason(String strReason) {
		this.strReason = strReason;
	}
	public String getDteValidFrom() {
		return dteValidFrom;
	}
	public void setDteValidFrom(String dteValidFrom) {
		this.dteValidFrom = dteValidFrom;
	}
	public String getDteValidTo() {
		return dteValidTo;
	}
	public void setDteValidTo(String dteValidTo) {
		this.dteValidTo = dteValidTo;
	}
	public String getStrRoomDesc() {
		return strRoomDesc;
	}
	public void setStrRoomDesc(String strRoomDesc) {
		this.strRoomDesc = strRoomDesc;
	}
	public String getStrRoomTypeDesc() {
		return strRoomTypeDesc;
	}
	public void setStrRoomTypeDesc(String strRoomTypeDesc) {
		this.strRoomTypeDesc = strRoomTypeDesc;
	}
	public JSONArray getJsonArrBlockRooms() {
		return jsonArrBlockRooms;
	}
	public void setJsonArrBlockRooms(JSONArray jsonArrBlockRooms) {
		this.jsonArrBlockRooms = jsonArrBlockRooms;
	}
	

}
