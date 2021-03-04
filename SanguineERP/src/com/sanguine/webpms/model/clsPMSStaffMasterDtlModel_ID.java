package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPMSStaffMasterDtlModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strStffCode")
	private String strStffCode;

	@Column(name="strRoomCode")
	private String strRoomCode;
	
	@Column(name="strRoomDesc")
	private String strRoomDesc;	

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPMSStaffMasterDtlModel_ID(){}
	public clsPMSStaffMasterDtlModel_ID(String strStffCode,String strClientCode){
		this.strStffCode=strStffCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrStffCode(){
		return strStffCode;
	}
	public void setStrStffCode(String strStffCode){
		this. strStffCode = strStffCode;
	}

	public String getStrRoomCode(){
		return strRoomCode;
	}
	public void setStrRoomCode(String strRoomCode){
		this. strRoomCode = strRoomCode;
	}	

	public String getStrRoomDesc() {
		return strRoomDesc;
	}

	public void setStrRoomDesc(String strRoomDesc) {
		this.strRoomDesc = strRoomDesc;
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
		clsPMSStaffMasterDtlModel_ID objModelId = (clsPMSStaffMasterDtlModel_ID)obj;
		if(this.strStffCode.equals(objModelId.getStrStffCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strStffCode.hashCode()+this.strClientCode.hashCode();
	}

}
