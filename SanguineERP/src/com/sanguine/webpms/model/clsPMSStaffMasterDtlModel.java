package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@Table(name="tblstaffmasterdtl")
@IdClass(clsPMSStaffMasterDtlModel_ID.class)

public class clsPMSStaffMasterDtlModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPMSStaffMasterDtlModel(){}

	public clsPMSStaffMasterDtlModel(clsPMSStaffMasterDtlModel_ID objModelID){
		strStffCode = objModelID.getStrStffCode();
		strRoomCode = objModelID.getStrRoomCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
	@AttributeOverride(name="strStffCode",column=@Column(name="strStffCode")),
	@AttributeOverride(name="strRoomCode",column=@Column(name="strRoomCode")),
	@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strStffCode")
	private String strStffCode;

	@Column(name="strRoomCode")
	private String strRoomCode;

	@Column(name="strRoomDesc")
	private String strRoomDesc;	

	@Column(name="strClientCode")
	private String strClientCode;
	

	//Setter-Getter Methods
	public String getStrStffCode(){
		return strStffCode;
	}
	public void setStrStffCode(String strStffCode){
		this. strStffCode = (String) setDefaultValue( strStffCode, "NA");
	}

	public String getStrRoomCode(){
		return strRoomCode;
	}
	public void setStrRoomCode(String strRoomCode){
		this. strRoomCode = (String) setDefaultValue( strRoomCode, "NA");
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
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}


//Function to Set Default Values
	private Object setDefaultValue(Object value, Object defaultValue){
		if(value !=null && (value instanceof String && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Double && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Integer && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Long && value.toString().length()>0)){
			return value;
		}
		else{
			return defaultValue;
		}
	}

}
