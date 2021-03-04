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
@Table(name="tblguestfeedback")
@IdClass(clsPMSGuestFeedbackModel_ID.class)

public class clsPMSGuestFeedbackModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPMSGuestFeedbackModel(){}

	public clsPMSGuestFeedbackModel(clsPMSGuestFeedbackModel_ID objModelID){
		strGuestFeedbackCode = objModelID.getStrGuestFeedbackCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strGuestFeedbackCode",column=@Column(name="strGuestFeedbackCode")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strGuestFeedbackCode")
	private String strGuestFeedbackCode;

	@Column(name="strGuestCode")
	private String strGuestCode;

	@Column(name="strFeedbackCode")
	private String strFeedbackCode;

	@Column(name="strExcellent")
	private String strExcellent;

	@Column(name="strGood")
	private String strGood;

	@Column(name="strFair")
	private String strFair;

	@Column(name="strPoor")
	private String strPoor;
	
	@Column(name="strRemark")
	private String strRemark;
	
	

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
	public String getStrGuestFeedbackCode(){
		return strGuestFeedbackCode;
	}
	public void setStrGuestFeedbackCode(String strGuestFeedbackCode){
		this. strGuestFeedbackCode = (String) setDefaultValue( strGuestFeedbackCode, "NA");
	}

	public String getStrGuestCode(){
		return strGuestCode;
	}
	public void setStrGuestCode(String strGuestCode){
		this. strGuestCode = (String) setDefaultValue( strGuestCode, "NA");
	}

	public String getStrFeedbackCode(){
		return strFeedbackCode;
	}
	public void setStrFeedbackCode(String strFeedbackCode){
		this. strFeedbackCode = (String) setDefaultValue( strFeedbackCode, "NA");
	}

	public String getStrExcellent(){
		return strExcellent;
	}
	public void setStrExcellent(String strExcellent){
		this. strExcellent = (String) setDefaultValue( strExcellent, "NA");
	}

	public String getStrGood(){
		return strGood;
	}
	public void setStrGood(String strGood){
		this. strGood = (String) setDefaultValue( strGood, "NA");
	}

	public String getStrFair(){
		return strFair;
	}
	public void setStrFair(String strFair){
		this. strFair = (String) setDefaultValue( strFair, "NA");
	}

	public String getStrPoor(){
		return strPoor;
	}
	public void setStrPoor(String strPoor){
		this. strPoor = (String) setDefaultValue( strPoor, "NA");
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

	public String getStrRemark() {
		return strRemark;
	}

	public void setStrRemark(String strRemark) {
		this.strRemark = strRemark;
	}

}
