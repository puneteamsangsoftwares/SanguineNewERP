package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSRateContractModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strRateContractID")
	private String strRateContractID;
	
	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSRateContractModel_ID(){}
	public clsPMSRateContractModel_ID(String strRateContractID ,String strClientCode){
		this.strRateContractID=strRateContractID;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	
	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}
	
	
	public String getStrRateContractID() {
		return strRateContractID;
	}
	public void setStrRateContractID(String strRateContractID) {
		this.strRateContractID = strRateContractID;
	}


//HashCode and Equals Funtions
	

	

}
