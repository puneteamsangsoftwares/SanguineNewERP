package com.sanguine.webpms.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Id;

@Entity
@Table(name="tblpmsratecontractdtl")
@IdClass(clsPMSRateContractModel_ID.class)

public class clsPMSRateContractModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPMSRateContractModel(){}

	public clsPMSRateContractModel(clsPMSRateContractModel_ID objModelID){
		strRateContractID = objModelID.getStrRateContractID();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="lngRateContractID",column=@Column(name="lngRateContractID")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strRateContractID")
	private String strRateContractID;
	
	@Column(name="strRoomTypeCode")
	private String strRoomTypeCode;

	@Column(name="strSeasonCode")
	private String strSeasonCode;

	@Column(name="strIncludeTax")
	private String strIncludeTax;

	@Column(name="intNoOfNights")
	private long intNoOfNights;

	@Column(name="dteFromDate")
	private String dteFromDate;

	@Column(name="dteToDate")
	private String dteToDate;

	@Column(name="strSunday")
	private String strSunday;

	@Column(name="strMonday")
	private String strMonday;

	@Column(name="strTuesday")
	private String strTuesday;

	@Column(name="strWednesday")
	private String strWednesday;

	@Column(name="strThursday")
	private String strThursday;

	@Column(name="strFriday")
	private String strFriday;

	@Column(name="strSaturday")
	private String strSaturday;

	@Column(name="dblSingleTariWeekDays")
	private double dblSingleTariWeekDays;

	@Column(name="dblDoubleTariWeekDays")
	private double dblDoubleTariWeekDays;

	@Column(name="dblTrippleTariWeekDays")
	private double dblTrippleTariWeekDays;

	@Column(name="dblExtraBedTariWeekDays")
	private double dblExtraBedTariWeekDays;

	@Column(name="dblChildTariWeekDays")
	private double dblChildTariWeekDays;

	@Column(name="dblYouthTariWeekDays")
	private double dblYouthTariWeekDays;

	@Column(name="dblSingleTariWeekend")
	private double dblSingleTariWeekend;

	@Column(name="dblDoubleTariWeekend")
	private double dblDoubleTariWeekend;

	@Column(name="dblTrippleTariWeekend")
	private double dblTrippleTariWeekend;

	@Column(name="dblExtraBedTariWeekend")
	private double dblExtraBedTariWeekend;

	@Column(name="dblChildTariWeekend")
	private double dblChildTariWeekend;

	@Column(name="dblYouthTariWeekend")
	private double dblYouthTariWeekend;

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
	
	
	@Column(name="strRateContractName")
	private String strRateContractName;



	//Setter-Getter Methods
	public String getStrRoomTypeCode(){
		return strRoomTypeCode;
	}
	public void setStrRoomTypeCode(String strRoomTypeCode){
		this. strRoomTypeCode = (String) setDefaultValue( strRoomTypeCode, "NA");
	}

	public String getStrSeasonCode(){
		return strSeasonCode;
	}
	public void setStrSeasonCode(String strSeasonCode){
		this. strSeasonCode = (String) setDefaultValue( strSeasonCode, "NA");
	}

	public String getStrIncludeTax(){
		return strIncludeTax;
	}
	public void setStrIncludeTax(String strIncludeTax){
		this. strIncludeTax = (String) setDefaultValue( strIncludeTax, "NA");
	}

	public long getIntNoOfNights(){
		return intNoOfNights;
	}
	public void setIntNoOfNights(long intNoOfNights){
		this. intNoOfNights = (Long) setDefaultValue( intNoOfNights, "NA");
	}

	public String getDteFromDate(){
		return dteFromDate;
	}
	public void setDteFromDate(String dteFromDate){
		this.dteFromDate=dteFromDate;
	}

	public String getDteToDate(){
		return dteToDate;
	}
	public void setDteToDate(String dteToDate){
		this.dteToDate=dteToDate;
	}

	public String getStrSunday(){
		return strSunday;
	}
	public void setStrSunday(String strSunday){
		this. strSunday = (String) setDefaultValue( strSunday, "NA");
	}

	public String getStrMonday(){
		return strMonday;
	}
	public void setStrMonday(String strMonday){
		this. strMonday = (String) setDefaultValue( strMonday, "NA");
	}

	public String getStrTuesday(){
		return strTuesday;
	}
	public void setStrTuesday(String strTuesday){
		this. strTuesday = (String) setDefaultValue( strTuesday, "NA");
	}

	public String getStrWednesday(){
		return strWednesday;
	}
	public void setStrWednesday(String strWednesday){
		this. strWednesday = (String) setDefaultValue( strWednesday, "NA");
	}

	public String getStrThursday(){
		return strThursday;
	}
	public void setStrThursday(String strThursday){
		this. strThursday = (String) setDefaultValue( strThursday, "NA");
	}

	public String getStrFriday(){
		return strFriday;
	}
	public void setStrFriday(String strFriday){
		this. strFriday = (String) setDefaultValue( strFriday, "NA");
	}

	public String getStrSaturday(){
		return strSaturday;
	}
	public void setStrSaturday(String strSaturday){
		this. strSaturday = (String) setDefaultValue( strSaturday, "NA");
	}

	public double getDblSingleTariWeekDays(){
		return dblSingleTariWeekDays;
	}
	public void setDblSingleTariWeekDays(double dblSingleTariWeekDays){
		this. dblSingleTariWeekDays = (Double) setDefaultValue( dblSingleTariWeekDays, "NA");
	}

	public double getDblDoubleTariWeekDays(){
		return dblDoubleTariWeekDays;
	}
	public void setDblDoubleTariWeekDays(double dblDoubleTariWeekDays){
		this. dblDoubleTariWeekDays = (Double) setDefaultValue( dblDoubleTariWeekDays, "NA");
	}

	public double getDblTrippleTariWeekDays(){
		return dblTrippleTariWeekDays;
	}
	public void setDblTrippleTariWeekDays(double dblTrippleTariWeekDays){
		this. dblTrippleTariWeekDays = (Double) setDefaultValue( dblTrippleTariWeekDays, "NA");
	}

	public double getDblExtraBedTariWeekDays(){
		return dblExtraBedTariWeekDays;
	}
	public void setDblExtraBedTariWeekDays(double dblExtraBedTariWeekDays){
		this. dblExtraBedTariWeekDays = (Double) setDefaultValue( dblExtraBedTariWeekDays, "NA");
	}

	public double getDblChildTariWeekDays(){
		return dblChildTariWeekDays;
	}
	public void setDblChildTariWeekDays(double dblChildTariWeekDays){
		this. dblChildTariWeekDays = (Double) setDefaultValue( dblChildTariWeekDays, "NA");
	}

	public double getDblYouthTariWeekDays(){
		return dblYouthTariWeekDays;
	}
	public void setDblYouthTariWeekDays(double dblYouthTariWeekDays){
		this. dblYouthTariWeekDays = (Double) setDefaultValue( dblYouthTariWeekDays, "NA");
	}

	public double getDblSingleTariWeekend(){
		return dblSingleTariWeekend;
	}
	public void setDblSingleTariWeekend(double dblSingleTariWeekend){
		this. dblSingleTariWeekend = (Double) setDefaultValue( dblSingleTariWeekend, "NA");
	}

	public double getDblDoubleTariWeekend(){
		return dblDoubleTariWeekend;
	}
	public void setDblDoubleTariWeekend(double dblDoubleTariWeekend){
		this. dblDoubleTariWeekend = (Double) setDefaultValue( dblDoubleTariWeekend, "NA");
	}

	public double getDblTrippleTariWeekend(){
		return dblTrippleTariWeekend;
	}
	public void setDblTrippleTariWeekend(double dblTrippleTariWeekend){
		this. dblTrippleTariWeekend = (Double) setDefaultValue( dblTrippleTariWeekend, "NA");
	}

	public double getDblExtraBedTariWeekend(){
		return dblExtraBedTariWeekend;
	}
	public void setDblExtraBedTariWeekend(double dblExtraBedTariWeekend){
		this. dblExtraBedTariWeekend = (Double) setDefaultValue( dblExtraBedTariWeekend, "NA");
	}

	public double getDblChildTariWeekend(){
		return dblChildTariWeekend;
	}
	public void setDblChildTariWeekend(double dblChildTariWeekend){
		this. dblChildTariWeekend = (Double) setDefaultValue( dblChildTariWeekend, "NA");
	}

	public double getDblYouthTariWeekend(){
		return dblYouthTariWeekend;
	}
	public void setDblYouthTariWeekend(double dblYouthTariWeekend){
		this. dblYouthTariWeekend = (Double) setDefaultValue( dblYouthTariWeekend, "NA");
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

	
	public String getStrRateContractID() {
		return strRateContractID;
	}

	public void setStrRateContractID(String strRateContractID) {
		this.strRateContractID = strRateContractID;
	}
	
	public String getStrRateContractName() {
		return strRateContractName;
	}

	public void setStrRateContractName(String strRateContractName) {
		this.strRateContractName = strRateContractName;
	}

}
