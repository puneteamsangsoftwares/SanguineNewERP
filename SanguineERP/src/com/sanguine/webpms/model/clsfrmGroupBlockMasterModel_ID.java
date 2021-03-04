package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsfrmGroupBlockMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strGroupBlockCode")
	private String strGroupBlockCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsfrmGroupBlockMasterModel_ID(){}
	public clsfrmGroupBlockMasterModel_ID(String strGroupBlockCode,String strClientCode){
		this.strGroupBlockCode=strGroupBlockCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrGroupBlockCode(){
		return strGroupBlockCode;
	}
	public void setStrGroupBlockCode(String strGroupBlockCode){
		this. strGroupBlockCode = strGroupBlockCode;
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
		clsfrmGroupBlockMasterModel_ID objModelId = (clsfrmGroupBlockMasterModel_ID)obj;
		if(this.strGroupBlockCode.equals(objModelId.getStrGroupBlockCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strGroupBlockCode.hashCode()+this.strClientCode.hashCode();
	}

}
