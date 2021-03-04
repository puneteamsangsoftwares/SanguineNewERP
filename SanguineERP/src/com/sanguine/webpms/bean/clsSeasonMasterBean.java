package com.sanguine.webpms.bean;

public class clsSeasonMasterBean{
//Variable Declaration
	private String strSeasonCode;

	private String strSeasonDesc;

	private String strUserCreated;

	private String strUserEdited;

	private String dteDateCreated;

	private String dteDateEdited;

	private String strClientCode;
	
	private String dteFromDate;
	
	private String dteToDate;

//Setter-Getter Methods
	public String getStrSeasonCode(){
		return strSeasonCode;
	}
	public void setStrSeasonCode(String strSeasonCode){
		this.strSeasonCode=strSeasonCode;
	}

	public String getStrSeasonDesc(){
		return strSeasonDesc;
	}
	public void setStrSeasonDesc(String strSeasonDesc){
		this.strSeasonDesc=strSeasonDesc;
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

	public String getStrClientCode(){
		return strClientCode;
	}
	
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}

	public String getDteFromDate(){
		return dteFromDate;
	}	
	
	public void setDteFromDate(String dteFromDate) {
		this.dteFromDate = dteFromDate;
	}	
	
	public String getDteToDate() {
		return dteToDate;
	}
	
	public void setDteToDate(String dteToDate) {
		this.dteToDate = dteToDate;
	}

}
