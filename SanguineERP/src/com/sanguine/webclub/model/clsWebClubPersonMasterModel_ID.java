package com.sanguine.webclub.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsWebClubPersonMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strPCode")
	private String strPCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsWebClubPersonMasterModel_ID(){}
	public clsWebClubPersonMasterModel_ID(String strPCode,String strClientCode){
		this.strPCode=strPCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrPCode(){
		return strPCode;
	}
	public void setStrPCode(String strPCode){
		this. strPCode = strPCode;
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
		clsWebClubPersonMasterModel_ID objModelId = (clsWebClubPersonMasterModel_ID)obj;
		if(this.strPCode.equals(objModelId.getStrPCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strPCode.hashCode()+this.strClientCode.hashCode();
	}

}
