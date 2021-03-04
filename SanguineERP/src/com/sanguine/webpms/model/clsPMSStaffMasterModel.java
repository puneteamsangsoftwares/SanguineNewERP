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
@Table(name="tblpmsstaffmaster")
@IdClass(clsPMSStaffMasterModel_ID.class)

public class clsPMSStaffMasterModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPMSStaffMasterModel(){}

	public clsPMSStaffMasterModel(clsPMSStaffMasterModel_ID objModelID){
		strStaffCode = objModelID.getStrStaffCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strStaffCode",column=@Column(name="strStaffCode")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strStaffCode",columnDefinition = "VARCHAR(10) NOT NULL")
	private String strStaffCode;

	@Column(name="strStaffName",columnDefinition = "VARCHAR(50) NOT NULL")
	private String strStaffName;

	@Column(name="strClientCode",columnDefinition = "VARCHAR(20) NOT NULL DEFAULT ''")
	private String strClientCode;

	@Column(name="strUserCreated",columnDefinition = "VARCHAR(20) NOT NULL DEFAULT ''")
	private String strUserCreated;

	@Column(name="strUserEdited",columnDefinition = "VARCHAR(20) NOT NULL DEFAULT ''")
	private String strUserEdited;
	
	@Column(name="dtCreated",columnDefinition = "DATETIME NOT NULL")
	private String dtCreated;
	
	@Column(name="dtEdited",columnDefinition = "DATETIME NOT NULL")
	private String dtEdited;
	
	@Column(name="IntSTId",columnDefinition = "BIGINT(20) NOT NULL")
	private long intSTId;
	

	

        public long getIntSTId() {
		return intSTId;
	}

	public void setIntSTId(long intSTId) {
		this.intSTId = intSTId;
	}

        public String getDtCreated() {
		return dtCreated;
	}

	public void setDtCreated(String dtCreated) {
		this.dtCreated = dtCreated;
	}

	public String getDtEdited() {
		return dtEdited;
	}

	public void setDtEdited(String dtEdited) {
		this.dtEdited = dtEdited;
	}

	//Setter-Getter Methods
	public String getStrStaffCode(){
		return strStaffCode;
	}
	public void setStrStaffCode(String strStaffCode){
		this. strStaffCode = (String) setDefaultValue( strStaffCode, "");
	}

	public String getStrStaffName(){
		return strStaffName;
	}
	public void setStrStaffName(String strStaffName){
		this. strStaffName = (String) setDefaultValue( strStaffName, "");
	}


	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "");
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this. strUserCreated = (String) setDefaultValue( strUserCreated, "");
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this. strUserEdited = (String) setDefaultValue( strUserEdited, "");
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
