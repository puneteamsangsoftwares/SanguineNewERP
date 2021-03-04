package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsSeasonMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strSeasonCode")
	private String strSeasonCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsSeasonMasterModel_ID(){}
	public clsSeasonMasterModel_ID(String strSeasonCode,String strClientCode){
		this.strSeasonCode=strSeasonCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrSeasonCode(){
		return strSeasonCode;
	}
	public void setStrSeasonCode(String strSeasonCode){
		this. strSeasonCode = strSeasonCode;
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
		clsSeasonMasterModel_ID objModelId = (clsSeasonMasterModel_ID)obj;
		if(this.strSeasonCode.equals(objModelId.getStrSeasonCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strSeasonCode.hashCode()+this.strClientCode.hashCode();
	}

}
