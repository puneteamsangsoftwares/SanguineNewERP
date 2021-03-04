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
@Table(name="tblpersonmaster")
@IdClass(clsWebClubPersonMasterModel_ID.class)

public class clsWebClubPersonMasterModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsWebClubPersonMasterModel(){}

	public clsWebClubPersonMasterModel(clsWebClubPersonMasterModel_ID objModelID){
		strPCode = objModelID.getStrPCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strPCode",column=@Column(name="strPCode")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strPCode")
	private String strPCode;

	@Column(name="strPName")
	private String strPName;

	@Column(name="strEmail")
	private String strEmail;

	@Column(name="strMobileNo")
	private String strMobileNo;

	@Column(name="intGId")
	private long intGId;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="dteDateCreated")
	private String dteDateCreated;

	@Column(name="dteDateEdited")
	private String dteDateEdited;

	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	public String getStrPCode(){
		return strPCode;
	}
	public void setStrPCode(String strPCode){
		this. strPCode = (String) setDefaultValue( strPCode, "NA");
	}

	public String getStrPName(){
		return strPName;
	}
	public void setStrPName(String strPName){
		this. strPName = (String) setDefaultValue( strPName, "NA");
	}

	public String getStrEmail(){
		return strEmail;
	}
	public void setStrEmail(String strEmail){
		this. strEmail = (String) setDefaultValue( strEmail, "NA");
	}

	public String getStrMobileNo(){
		return strMobileNo;
	}
	public void setStrMobileNo(String strMobileNo){
		this. strMobileNo = (String) setDefaultValue( strMobileNo, "NA");
	}

	public long getIntGId(){
		return intGId;
	}
	public void setIntGId(long intGId){
		this. intGId = (Long) setDefaultValue( intGId, "NA");
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

	public String getDteDateCreated(){
		return dteDateCreated;
	}
	public void setDteDateCreated(String dteDateCreated){
		this.dteDateCreated=dteDateCreated;
	}

	public String getDteDateEdited(){
		return dteDateEdited;
	}
	public void setDteDateEdited(String dteDateEdited){
		this.dteDateEdited=dteDateEdited;
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
