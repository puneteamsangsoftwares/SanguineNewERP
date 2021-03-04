package com.sanguine.webclub.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

@Entity
@Table(name="tblmempropertysetup")
@IdClass(clsWebClubMemberProfileSetupModel_ID.class)

public class clsWebClubMemberProfileSetupModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsWebClubMemberProfileSetupModel(){}

	public clsWebClubMemberProfileSetupModel(clsWebClubMemberProfileSetupModel_ID objModelID){
		strFieldName = objModelID.getStrFieldName();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strFieldName",column=@Column(name="strFieldName")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strFieldName")
	private String strFieldName;

	@Column(name="strFlag")
	private String strFlag;

	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

//Setter-Getter Methods
	public String getStrFieldName(){
		return strFieldName;
	}
	public void setStrFieldName(String strFieldName){
		this. strFieldName = (String) setDefaultValue( strFieldName, "NA");
	}

	public String getStrFlag(){
		return strFlag;
	}
	public void setStrFlag(String strFlag){
		this. strFlag = (String) setDefaultValue( strFlag, "NA");
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this. strUserCreated = (String) setDefaultValue( strUserCreated, "NA");
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this. strUserEdited = (String) setDefaultValue( strUserEdited, "NA");
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
