package com.sanguine.webpms.model;

import java.io.Serializable;
import javax.persistence.Embeddable;

@Embeddable
public class clsPMSGroupBookingDtlModel implements Serializable {
	private static final long serialVersionUID = 1L;

	public clsPMSGroupBookingDtlModel() {
	}

	// Variable Declaration
	
	private String strPayee;

	private String strRoom;

	private String strFandB;

	private String strTelephone;

	private String strExtra;
	
	// Setter-Getter Methods
	public String getStrPayee() {
		return strPayee;
	}
	public void setStrPayee(String strPayee) {
		this.strPayee = strPayee;
	}
	public String getStrRoom() {
		return strRoom;
	}
	public void setStrRoom(String strRoom) {
		this.strRoom = strRoom;
	}
	public String getStrFandB() {
		return strFandB;
	}
	public void setStrFandB(String strFandB) {
		this.strFandB = strFandB;
	}
	public String getStrTelephone() {
		return strTelephone;
	}
	public void setStrTelephone(String strTelephone) {
		this.strTelephone = strTelephone;
	}
	public String getStrExtra() {
		return strExtra;
	}
	public void setStrExtra(String strExtra) {
		this.strExtra = strExtra;
	}	

	
	// Function to Set Default Values
	private Object setDefaultValue(Object value, Object defaultValue) {
		if (value != null && (value instanceof String && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Double && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Integer && value.toString().length() > 0)) {
			return value;
		} else if (value != null && (value instanceof Long && value.toString().length() > 0)) {
			return value;
		} else {
			return defaultValue;
		}
	}

}
