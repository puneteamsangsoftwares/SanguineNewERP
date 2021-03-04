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
@Table(name="tblgroupblockmaster")
@IdClass(clsfrmGroupBlockMasterModel_ID.class)

public class clsfrmGroupBlockMasterModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsfrmGroupBlockMasterModel(){}

	public clsfrmGroupBlockMasterModel(clsfrmGroupBlockMasterModel_ID objModelID){
		strGroupBlockCode = objModelID.getStrGroupBlockCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strGroupBlockCode",column=@Column(name="strGroupBlockCode")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strGroupBlockCode")
	private String strGroupBlockCode;

	@Column(name="strGroupBlockName")
	private String strGroupBlockName;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="strDateCreated")
	private String strDateCreated;

	@Column(name="strDateEdited")
	private String strDateEdited;

	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	public String getStrGroupBlockCode(){
		return strGroupBlockCode;
	}
	public void setStrGroupBlockCode(String strGroupBlockCode){
		this. strGroupBlockCode = (String) setDefaultValue( strGroupBlockCode, "NA");
	}

	public String getStrGroupBlockName(){
		return strGroupBlockName;
	}
	public void setStrGroupBlockName(String strGroupBlockName){
		this. strGroupBlockName = (String) setDefaultValue( strGroupBlockName, "NA");
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

	public String getStrDateCreated(){
		return strDateCreated;
	}
	public void setStrDateCreated(String strDateCreated){
		this. strDateCreated = (String) setDefaultValue( strDateCreated, "NA");
	}

	public String getStrDateEdited(){
		return strDateEdited;
	}
	public void setStrDateEdited(String strDateEdited){
		this. strDateEdited = (String) setDefaultValue( strDateEdited, "NA");
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
