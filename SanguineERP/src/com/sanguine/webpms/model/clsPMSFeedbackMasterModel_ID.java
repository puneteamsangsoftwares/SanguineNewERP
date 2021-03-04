package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSFeedbackMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strFeedbackCode")
	private String strFeedbackCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSFeedbackMasterModel_ID(){}
	public clsPMSFeedbackMasterModel_ID(String strFeedbackCode,String strClientCode){
		this.strFeedbackCode=strFeedbackCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrFeedbackCode(){
		return strFeedbackCode;
	}
	public void setStrFeedbackCode(String strFeedbackCode){
		this. strFeedbackCode = strFeedbackCode;
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
		clsPMSFeedbackMasterModel_ID objModelId = (clsPMSFeedbackMasterModel_ID)obj;
		if(this.strFeedbackCode.equals(objModelId.getStrFeedbackCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strFeedbackCode.hashCode()+this.strClientCode.hashCode();
	}

}
