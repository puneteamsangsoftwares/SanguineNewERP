package com.sanguine.webpms.bean;


import java.util.ArrayList;
import java.util.List;

public class clsPMSGuestFeedbackBean{
//Variable Declaration
	private String strGuestFeedbackCode;

	private String strGuestCode;

	private String strFeedbackCode;

	private String strFeedbackDesc;

	
	private String strExcellent;

	private String strGood;

	private String strFair;

	private String strPoor;
	
	private String strRemark;	
	
	private String strUserCreated;

	private String strUserEdited;

	private String dteDateCreated;

	private String dteDateEdited;

	private String strClientCode;

	List<clsPMSGuestFeedbackBean> listBean = new ArrayList<clsPMSGuestFeedbackBean>();
//Setter-Getter Methods
	

	public String getStrRemark() {
		return strRemark;
	}
	public void setStrRemark(String strRemark) {
		this.strRemark = strRemark;
	}

	public String getStrGuestFeedbackCode(){
		return strGuestFeedbackCode;
	}
	public void setStrGuestFeedbackCode(String strGuestFeedbackCode){
		this.strGuestFeedbackCode=strGuestFeedbackCode;
	}

	public String getStrGuestCode(){
		return strGuestCode;
	}
	public void setStrGuestCode(String strGuestCode){
		this.strGuestCode=strGuestCode;
	}

	public String getStrFeedbackCode(){
		return strFeedbackCode;
	}
	public void setStrFeedbackCode(String strFeedbackCode){
		this.strFeedbackCode=strFeedbackCode;
	}

	public String getStrExcellent(){
		return strExcellent;
	}
	public void setStrExcellent(String strExcellent){
		this.strExcellent=strExcellent;
	}

	public String getStrGood(){
		return strGood;
	}
	public void setStrGood(String strGood){
		this.strGood=strGood;
	}

	public String getStrFair(){
		return strFair;
	}
	public void setStrFair(String strFair){
		this.strFair=strFair;
	}

	public String getStrPoor(){
		return strPoor;
	}
	public void setStrPoor(String strPoor){
		this.strPoor=strPoor;
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
	public List<clsPMSGuestFeedbackBean> getListBean() {
		return listBean;
	}
	public void setListBean(List<clsPMSGuestFeedbackBean> listBean) {
		this.listBean = listBean;
	}
	public String getStrFeedbackDesc() {
		return strFeedbackDesc;
	}
	public void setStrFeedbackDesc(String strFeedbackDesc) {
		this.strFeedbackDesc = strFeedbackDesc;
	}



}
