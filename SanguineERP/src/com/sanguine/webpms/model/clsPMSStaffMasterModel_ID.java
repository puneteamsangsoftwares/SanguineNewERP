package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSStaffMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strStaffCode")
	private String strStaffCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSStaffMasterModel_ID(){}
	public clsPMSStaffMasterModel_ID(String strStaffCode,String strClientCode){
		this.strStaffCode=strStaffCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrStaffCode(){
		return strStaffCode;
	}
	public void setStrStaffCode(String strStaffCode){
		this. strStaffCode = strStaffCode;
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
		clsPMSStaffMasterModel_ID objModelId = (clsPMSStaffMasterModel_ID)obj;
		if(this.strStaffCode.equals(objModelId.getStrStaffCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strStaffCode.hashCode()+this.strClientCode.hashCode();
	}

}
