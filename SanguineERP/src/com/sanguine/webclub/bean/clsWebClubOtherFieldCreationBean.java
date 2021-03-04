package com.sanguine.webclub.bean;

import java.util.List;

public class clsWebClubOtherFieldCreationBean{
//Variable Declaration
	
	private String strFieldName;
	
	private String strDataType;
	
	private long dblLength;

	private String strDefault;		
	
	private List<clsWebClubOtherFieldCreationBean> listTableCreation;
	// Setter-Getter Methods

	public List<clsWebClubOtherFieldCreationBean> getListTableCreation() {
		return listTableCreation;
	}

	public void setListTableCreation(List<clsWebClubOtherFieldCreationBean> listTableCreation) {
		this.listTableCreation = listTableCreation;
	}

	public String getStrFieldName() {
		return strFieldName;
	}

	public void setStrFieldName(String strFieldName) {
		this.strFieldName = strFieldName;
	}

	public String getStrDataType() {
		return strDataType;
	}

	public void setStrDataType(String strDataType) {
		this.strDataType = strDataType;
	}

	public long getDblLength() {
		return dblLength;
	}

	public void setDblLength(long dblLength) {
		this.dblLength = dblLength;
	}

	public String getStrDefault() {
		return strDefault;
	}

	public void setStrDefault(String strDefault) {
		this.strDefault = strDefault;
	}
	
	
	
	
	
	// Setter-Getter Methods
	
	



}
