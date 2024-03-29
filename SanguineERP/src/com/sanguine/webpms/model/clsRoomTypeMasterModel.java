package com.sanguine.webpms.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tblroomtypemaster")
public class clsRoomTypeMasterModel {
	@Id
	@Column(name = "strRoomTypeCode")
	private String strRoomTypeCode;

	@Column(name = "strRoomTypeDesc")
	private String strRoomTypeDesc;

	@Column(name = "strUserCreated", updatable = false)
	private String strUserCreated;

	@Column(name = "strUserEdited")
	private String strUserEdited;

	@Column(name = "dteDateCreated", updatable = false)
	private String dteDateCreated;

	@Column(name = "dteDateEdited")
	private String dteDateEdited;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "dblRoomTerrif")
	private double dblRoomTerrif;
	
	@Column(name = "dblDoubleTariff")
	private double dblDoubleTariff;
	
	@Column(name = "dblTrippleTariff")
	private double dblTrippleTariff;
	
	@Column(name = "strHsnSac")
	private String strHsnSac;
	
	@Column(name = "strIsHouseKeeping")
	private String strIsHouseKeeping;
	
	@Column(name = "strGuestCapcity")
	private String strGuestCapcity;

	public String getStrGuestCapcity()
	{
		return strGuestCapcity;
	}

	public void setStrGuestCapcity(String strGuestCapcity) {
		this.strGuestCapcity = strGuestCapcity;
	}

	public String getStrHsnSac() {
		return strHsnSac;
	}

	public void setStrHsnSac(String strHsnSac) {
		this.strHsnSac = strHsnSac;
	}

	public String getStrRoomTypeCode() {
		return strRoomTypeCode;
	}

	public void setStrRoomTypeCode(String strRoomTypeCode) {
		this.strRoomTypeCode = strRoomTypeCode;
	}

	public String getStrRoomTypeDesc() {
		return strRoomTypeDesc;
	}

	public void setStrRoomTypeDesc(String strRoomTypeDesc) {
		this.strRoomTypeDesc = strRoomTypeDesc;
	}

	public String getStrUserCreated() {
		return strUserCreated;
	}

	public void setStrUserCreated(String strUserCreated) {
		this.strUserCreated = strUserCreated;
	}

	public String getStrUserEdited() {
		return strUserEdited;
	}

	public void setStrUserEdited(String strUserEdited) {
		this.strUserEdited = strUserEdited;
	}

	public String getDteDateCreated() {
		return dteDateCreated;
	}

	public void setDteDateCreated(String dteDateCreated) {
		this.dteDateCreated = dteDateCreated;
	}

	public String getDteDateEdited() {
		return dteDateEdited;
	}

	public void setDteDateEdited(String dteDateEdited) {
		this.dteDateEdited = dteDateEdited;
	}

	public String getStrClientCode() {
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode) {
		this.strClientCode = strClientCode;
	}

	public double getDblRoomTerrif() {
		return dblRoomTerrif;
	}

	public void setDblRoomTerrif(double dblRoomTerrif) {
		this.dblRoomTerrif = dblRoomTerrif;
	}

	public double getDblDoubleTariff() {
		return dblDoubleTariff;
	}

	public void setDblDoubleTariff(double dblDoubleTariff) {
		this.dblDoubleTariff = dblDoubleTariff;
	}
	
	
	public double getDblTrippleTariff() {
		return dblTrippleTariff;
	}

	public void setDblTrippleTariff(double dblTrippleTariff) {
		this.dblTrippleTariff = dblTrippleTariff;
	
	}
	public String getstrIsHouseKeeping() {
		return strIsHouseKeeping;
	}

	public void setstrIsHouseKeeping(String strIsHouseKeeping) {
		this.strIsHouseKeeping = strIsHouseKeeping;
	}
	

}
