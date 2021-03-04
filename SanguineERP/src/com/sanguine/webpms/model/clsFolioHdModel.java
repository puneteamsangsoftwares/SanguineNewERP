package com.sanguine.webpms.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.Table;
import javax.persistence.Transient;


@Entity
@Table(name = "tblfoliohd")
@IdClass(clsFolioModel_ID.class)
public class clsFolioHdModel implements Serializable {
	private static final long serialVersionUID = 1L;

	public clsFolioHdModel() {
	}

	public clsFolioHdModel(clsFolioModel_ID objModelID) {
		strFolioNo = objModelID.getStrFolioNo();
		strClientCode = objModelID.getStrClientCode();
	}

	@ElementCollection(fetch = FetchType.LAZY)
	@JoinTable(name = "tblfoliodtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strFolioNo") })
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strFolioNo", column = @Column(name = "strFolioNo")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
	private List<clsFolioDtlModel> listFolioDtlModel = new ArrayList<clsFolioDtlModel>();

	@ElementCollection(fetch = FetchType.LAZY)
	@JoinTable(name = "tblfoliotaxdtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strFolioNo") })
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strFolioNo", column = @Column(name = "strFolioNo")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
	private List<clsFolioTaxDtl> listFolioTaxDtlModel = new ArrayList<clsFolioTaxDtl>();

	// Variable Declaration
	@Column(name = "strFolioNo")
	private String strFolioNo;

	@Column(name = "strRoomNo")
	private String strRoomNo;

	@Column(name = "strRegistrationNo")
	private String strRegistrationNo;

	@Column(name = "strCheckInNo")
	private String strCheckInNo;

	@Column(name = "strReservationNo")
	private String strReservationNo;

	@Column(name = "dteArrivalDate")
	private String dteArrivalDate;

	@Column(name = "dteDepartureDate")
	private String dteDepartureDate;

	@Column(name = "tmeArrivalTime")
	private String tmeArrivalTime;

	@Column(name = "tmeDepartureTime")
	private String tmeDepartureTime;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strExtraBedCode")
	private String strExtraBedCode;

	@Column(name = "strGuestCode")
	private String strGuestCode;

	@Column(name = "strWalkInNo")
	private String strWalkInNo;
	
	//For Group booking
	
	@Column(name = "strRoom")
	private String strRoom;
	
	@Column(name = "strFandB")
	private String strFandB;
	
	@Column(name = "strTelephone")
	private String strTelephone;
	
	@Column(name = "strExtra")
	private String strExtra;

	
	
	@Transient
	private String strBillNo;

	// Setter-Getter Methods
	public String getStrFolioNo() {
		return strFolioNo;
	}

	public List<clsFolioTaxDtl> getListFolioTaxDtlModel() {
		return listFolioTaxDtlModel;
	}

	public void setListFolioTaxDtlModel(List<clsFolioTaxDtl> listFolioTaxDtlModel) {
		this.listFolioTaxDtlModel = listFolioTaxDtlModel;
	}

	public void setStrFolioNo(String strFolioNo) {
		this.strFolioNo = (String) setDefaultValue(strFolioNo, "");
	}

	public String getStrRoomNo() {
		return strRoomNo;
	}

	public void setStrRoomNo(String strRoomNo) {
		this.strRoomNo = (String) setDefaultValue(strRoomNo, "");
	}

	public String getStrRegistrationNo() {
		return strRegistrationNo;
	}

	public void setStrRegistrationNo(String strRegistrationNo) {
		this.strRegistrationNo = (String) setDefaultValue(strRegistrationNo, "");
	}

	public String getStrReservationNo() {
		return strReservationNo;
	}

	public void setStrReservationNo(String strReservationNo) {
		this.strReservationNo = (String) setDefaultValue(strReservationNo, "");
	}

	public String getDteArrivalDate() {
		return dteArrivalDate;
	}

	public void setDteArrivalDate(String dteArrivalDate) {
		this.dteArrivalDate = dteArrivalDate;
	}

	public String getDteDepartureDate() {
		return dteDepartureDate;
	}

	public void setDteDepartureDate(String dteDepartureDate) {
		this.dteDepartureDate = dteDepartureDate;
	}

	public String getStrClientCode() {
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode) {
		this.strClientCode = (String) setDefaultValue(strClientCode, "");
	}

	public List<clsFolioDtlModel> getListFolioDtlModel() {
		return listFolioDtlModel;
	}

	public void setListFolioDtlModel(List<clsFolioDtlModel> listFolioDtlModel) {
		this.listFolioDtlModel = listFolioDtlModel;
	}

	public String getTmeArrivalTime() {
		return tmeArrivalTime;
	}

	public void setTmeArrivalTime(String tmeArrivalTime) {
		this.tmeArrivalTime = tmeArrivalTime;
	}

	public String getTmeDepartureTime() {
		return tmeDepartureTime;
	}

	public void setTmeDepartureTime(String tmeDepartureTime) {
		this.tmeDepartureTime = tmeDepartureTime;
	}

	public String getStrCheckInNo() {
		return strCheckInNo;
	}

	public void setStrCheckInNo(String strCheckInNo) {
		this.strCheckInNo = strCheckInNo;
	}

	public String getStrExtraBedCode() {
		return strExtraBedCode;
	}

	public void setStrExtraBedCode(String strExtraBedCode) {
		this.strExtraBedCode = strExtraBedCode;
	}

	public String getStrGuestCode() {
		return strGuestCode;
	}

	public void setStrGuestCode(String strGuestCode) {
		this.strGuestCode = strGuestCode;
	}

	public String getStrWalkInNo() {
		return strWalkInNo;
	}

	public void setStrWalkInNo(String strWalkInNo) {
		this.strWalkInNo = strWalkInNo;
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

	public String getStrBillNo() {
		return strBillNo;
	}

	public void setStrBillNo(String strBillNo) {
		this.strBillNo = strBillNo;
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

}
