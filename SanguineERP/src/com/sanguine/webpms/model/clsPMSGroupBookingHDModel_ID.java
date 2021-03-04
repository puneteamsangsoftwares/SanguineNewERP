package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSGroupBookingHDModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strGroupCode")
	private String strGroupCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSGroupBookingHDModel_ID(){}
	public clsPMSGroupBookingHDModel_ID(String strGroupCode,String strClientCode){
		this.strGroupCode=strGroupCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrGroupCode(){
		return strGroupCode;
	}
	public void setStrGroupCode(String strGroupCode){
		this. strGroupCode = strGroupCode;
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
		clsPMSGroupBookingHDModel_ID objModelId = (clsPMSGroupBookingHDModel_ID)obj;
		if(this.strGroupCode.equals(objModelId.getStrGroupCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strGroupCode.hashCode()+this.strClientCode.hashCode();
	}

}
