package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSGuestFeedbackModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strGuestFeedbackCode")
	private String strGuestFeedbackCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSGuestFeedbackModel_ID(){}
	public clsPMSGuestFeedbackModel_ID(String strGuestFeedbackCode,String strClientCode){
		this.strGuestFeedbackCode=strGuestFeedbackCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrGuestFeedbackCode(){
		return strGuestFeedbackCode;
	}
	public void setStrGuestFeedbackCode(String strGuestFeedbackCode){
		this. strGuestFeedbackCode = strGuestFeedbackCode;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsPMSGuestFeedbackModel_ID objModelId = (clsPMSGuestFeedbackModel_ID)obj;
		if(this.strGuestFeedbackCode.equals(objModelId.getStrGuestFeedbackCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strGuestFeedbackCode.hashCode()+this.strClientCode.hashCode();
	}

}
