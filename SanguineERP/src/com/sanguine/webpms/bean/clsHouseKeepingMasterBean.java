package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;

public class clsHouseKeepingMasterBean{
//Variable Declaration
	private String strHouseKeepCode;

	private String strHouseKeepName;

	private String strRemarks;

	private long intId;

	private String dteDateCreated;

	private String dteDateEdited;

	private String strUserCreated;

	private String strUserEdited;

	private String strClientCode;
	
	private String strIsRoomTypeSelected;
	
	private List<clsHouseKeepingMasterBean> listOfHouseKeeping = new ArrayList<clsHouseKeepingMasterBean>();
	
	private JSONArray jsonArrHouseKeeping= new JSONArray();

   
	//Setter-Getter Methods
	public String getStrHouseKeepCode(){
		return strHouseKeepCode;
	}
	public void setStrHouseKeepCode(String strHouseKeepCode){
		this.strHouseKeepCode=strHouseKeepCode;
	}

	public String getStrHouseKeepName(){
		return strHouseKeepName;
	}
	public void setStrHouseKeepName(String strHouseKeepName){
		this.strHouseKeepName=strHouseKeepName;
	}

	public String getStrRemarks(){
		return strRemarks;
	}
	public void setStrRemarks(String strRemarks){
		this.strRemarks=strRemarks;
	}

	public long getIntId(){
		return intId;
	}
	public void setIntId(long intId){
		this.intId=intId;
	}

	public String getDteDateCreated(){
		return dteDateCreated;
	}
	public void setDteDateCreated(String dteDateCreated){
		this.dteDateCreated=dteDateCreated;
	}

	public String getDteDateEdited(){
		return dteDateEdited;
	}
	public void setDteDateEdited(String dteDateEdited){
		this.dteDateEdited=dteDateEdited;
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this.strUserCreated=strUserCreated;
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this.strUserEdited=strUserEdited;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}
	public String getStrIsRoomTypeSelected() {
		return strIsRoomTypeSelected;
	}
	public void setStrIsRoomTypeSelected(String strIsRoomTypeSelected) {
		this.strIsRoomTypeSelected = strIsRoomTypeSelected;
	}
	public List<clsHouseKeepingMasterBean> getListOfHouseKeeping() {
		return listOfHouseKeeping;
	}
	public void setListOfHouseKeeping(
			List<clsHouseKeepingMasterBean> listOfHouseKeeping) {
		this.listOfHouseKeeping = listOfHouseKeeping;
	}
	public JSONArray getJsonArrHouseKeeping() {
		return jsonArrHouseKeeping;
	}
	public void setJsonArrHouseKeeping(JSONArray jsonArrHouseKeeping) {
		this.jsonArrHouseKeeping = jsonArrHouseKeeping;
	}
	



}
