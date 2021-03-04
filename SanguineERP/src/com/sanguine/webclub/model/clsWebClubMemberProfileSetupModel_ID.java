package com.sanguine.webclub.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsWebClubMemberProfileSetupModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strFieldName")
	private String strFieldName;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsWebClubMemberProfileSetupModel_ID(){}
	public clsWebClubMemberProfileSetupModel_ID(String strFieldName,String strClientCode){
		this.strFieldName=strFieldName;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrFieldName(){
		return strFieldName;
	}
	public void setStrFieldName(String strFieldName){
		this. strFieldName = strFieldName;
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
		clsWebClubMemberProfileSetupModel_ID objModelId = (clsWebClubMemberProfileSetupModel_ID)obj;
		if(this.strFieldName.equals(objModelId.getStrFieldName())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strFieldName.hashCode()+this.strClientCode.hashCode();
	}

}
