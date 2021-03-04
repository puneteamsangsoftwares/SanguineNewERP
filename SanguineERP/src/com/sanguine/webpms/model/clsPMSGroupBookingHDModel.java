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

@Entity
@Table(name="tblgroupbookinghd")
@IdClass(clsPMSGroupBookingHDModel_ID.class)

public class clsPMSGroupBookingHDModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPMSGroupBookingHDModel(){}

	public clsPMSGroupBookingHDModel(clsPMSGroupBookingHDModel_ID objModelID){
		strGroupCode = objModelID.getStrGroupCode();
		strClientCode = objModelID.getStrClientCode();
	}
/*
	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strGroupCode",column=@Column(name="strGroupCode")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})*/
	
	
	@ElementCollection(fetch = FetchType.LAZY)
	@JoinTable(name = "tblgroupbookingdtl", joinColumns = { @JoinColumn(name = "strClientCode"), @JoinColumn(name = "strGroupCode") })
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strGroupCode", column = @Column(name = "strGroupCode")), 
	@AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
	private List<clsPMSGroupBookingDtlModel> listPMSGroupBookingDtlModel = new ArrayList<clsPMSGroupBookingDtlModel>();



	//Variable Declaration
	@Column(name="strReservationID")
	private String strReservationID;

	@Column(name="strGroupCode")
	private String strGroupCode;

	@Column(name="strGroupName")
	private String strGroupName;

	@Column(name="strGroupLeaderCode")
	private String strGroupLeaderCode;

	@Column(name="strAddress")
	private String strAddress;

	@Column(name="strCity")
	private String strCity;

	@Column(name="strCountry")
	private String strCountry;

	@Column(name="strPin")
	private String strPin;

	@Column(name="strPhone")
	private String strPhone;

	@Column(name="strMobile")
	private String strMobile;

	@Column(name="strFax")
	private String strFax;

	@Column(name="strEmail")
	private String strEmail;

	@Column(name="dteDob")
	private String dteDob;

	@Column(name="strNationality")
	private String strNationality;
	
	

	@Column(name="strCompCode")
	private String strCompCode;

	@Column(name="strCompName")
	private String strCompName;

	@Column(name="strDesignation")
	private String strDesignation;

	@Column(name="strGICity")
	private String strGICity;

	@Column(name="strGIPhone")
	private String strGIPhone;

	@Column(name="strGIMobile")
	private String strGIMobile;
	
	@Column(name="strGIFax")
	private String strGIFax;	
	
	

	@Column(name="dteTravelDate")
	private String dteTravelDate;
	
	@Column(name="tmeTravelTime")
	private String tmeTravelTime;	

	@Column(name="strPickupRequired")
	private String strPickupRequired;
	
	

	@Column(name="dteCheckInDate")
	private String dteCheckInDate;

	@Column(name="dteCheckoutDate")
	private String dteCheckoutDate;

	@Column(name="strPax")
	private String strPax;

	@Column(name="strSource")
	private String strSource;

	@Column(name="strGuestType")
	private String strGuestType;

	@Column(name="strExtraBed")
	private String strExtraBed;

	@Column(name="strChild")
	private String strChild;

	@Column(name="strInfant")
	private String strInfant;

	@Column(name="strSalesChannel")
	private String strSalesChannel;
	
	

	@Column(name="strRoomType")
	private String strRoomType;

	@Column(name="strRoomTypeDesc ")
	private String strRoomTypeDesc ;

	@Column(name="strRoomTaxes")
	private String strRoomTaxes;

	@Column(name="strOtherTaxes")
	private String strOtherTaxes;

	@Column(name="strServiceCharges")
	private String strServiceCharges;

	@Column(name="strPayments")
	private String strPayments;

	@Column(name="strDiscounts")
	private String strDiscounts;
	
	

	@Column(name="strCard")
	private String strCard;

	@Column(name="strCash")
	private String strCash;

	@Column(name="strPaymentBtGroupLeader")
	private String strPaymentBtGroupLeader;

	@Column(name="strGuest")
	private String strGuest;

	@Column(name="strRoom")
	private String strRoom;

	@Column(name="strFandB")
	private String strFandB;

	@Column(name="strTelephones")
	private String strTelephones;

	@Column(name="strExtras")
	private String strExtras;
	

	@Column(name="intGid")
	private long intGid;

	@Column(name="dteDateCreated")
	private String dteDateCreated;

	@Column(name="dteDateEdited")
	private String dteDateEdited;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	public String getStrReservationID(){
		return strReservationID;
	}
	public void setStrReservationID(String strReservationID){
		this. strReservationID = (String) setDefaultValue( strReservationID, "NA");
	}

	public String getStrGroupCode(){
		return strGroupCode;
	}
	public void setStrGroupCode(String strGroupCode){
		this. strGroupCode = (String) setDefaultValue( strGroupCode, "NA");
	}

	public String getStrGroupName(){
		return strGroupName;
	}
	public void setStrGroupName(String strGroupName){
		this. strGroupName = (String) setDefaultValue( strGroupName, "NA");
	}

	public String getStrGroupLeaderCode(){
		return strGroupLeaderCode;
	}
	public void setStrGroupLeaderCode(String strGroupLeaderCode){
		this. strGroupLeaderCode = (String) setDefaultValue( strGroupLeaderCode, "NA");
	}

	public String getStrAddress(){
		return strAddress;
	}
	public void setStrAddress(String strAddress){
		this. strAddress = (String) setDefaultValue( strAddress, "NA");
	}

	public String getStrCity(){
		return strCity;
	}
	public void setStrCity(String strCity){
		this. strCity = (String) setDefaultValue( strCity, "NA");
	}

	public String getStrCountry(){
		return strCountry;
	}
	public void setStrCountry(String strCountry){
		this. strCountry = (String) setDefaultValue( strCountry, "NA");
	}

	public String getStrPin(){
		return strPin;
	}
	public void setStrPin(String strPin){
		this. strPin = (String) setDefaultValue( strPin, "NA");
	}

	public String getStrPhone(){
		return strPhone;
	}
	public void setStrPhone(String strPhone){
		this. strPhone = (String) setDefaultValue( strPhone, "NA");
	}

	public String getStrMobile(){
		return strMobile;
	}
	public void setStrMobile(String strMobile){
		this. strMobile = (String) setDefaultValue( strMobile, "NA");
	}

	public String getStrFax(){
		return strFax;
	}
	public void setStrFax(String strFax){
		this. strFax = (String) setDefaultValue( strFax, "NA");
	}

	public String getStrEmail(){
		return strEmail;
	}
	public void setStrEmail(String strEmail){
		this. strEmail = (String) setDefaultValue( strEmail, "NA");
	}

	public String getDteDob(){
		return dteDob;
	}
	public void setDteDob(String dteDob){
		this.dteDob=dteDob;
	}

	public String getStrNationality(){
		return strNationality;
	}
	public void setStrNationality(String strNationality){
		this. strNationality = (String) setDefaultValue( strNationality, "NA");
	}

	public String getStrCompCode(){
		return strCompCode;
	}
	public void setStrCompCode(String strCompCode){
		this. strCompCode = (String) setDefaultValue( strCompCode, "NA");
	}

	public String getStrCompName(){
		return strCompName;
	}
	public void setStrCompName(String strCompName){
		this. strCompName = (String) setDefaultValue( strCompName, "NA");
	}

	public String getStrDesignation(){
		return strDesignation;
	}
	public void setStrDesignation(String strDesignation){
		this. strDesignation = (String) setDefaultValue( strDesignation, "NA");
	}

	public String getStrGICity(){
		return strGICity;
	}
	public void setStrGICity(String strGICity){
		this. strGICity = (String) setDefaultValue( strGICity, "NA");
	}

	public String getStrGIPhone(){
		return strGIPhone;
	}
	public void setStrGIPhone(String strGIPhone){
		this. strGIPhone = (String) setDefaultValue( strGIPhone, "NA");
	}

	public String getStrGIMobile(){
		return strGIMobile;
	}
	public void setStrGIMobile(String strGIMobile){
		this. strGIMobile = (String) setDefaultValue( strGIMobile, "NA");
	}
	
	public String getStrGIFax(){
		return strGIFax;
	}
	public void setStrGIFax(String strGIFax){
		this. strGIFax = (String) setDefaultValue( strGIFax, "NA");
	}
	
	public String getDteTravelDate(){
		return dteTravelDate;
	}
	public void setDteTravelDate(String dteTravelDate){
		this.dteTravelDate=dteTravelDate;
	}

	public String getStrPickupRequired(){
		return strPickupRequired;
	}
	public void setStrPickupRequired(String strPickupRequired){
		this. strPickupRequired = (String) setDefaultValue( strPickupRequired, "NA");
	}

	public String getDteCheckInDate(){
		return dteCheckInDate;
	}
	public void setDteCheckInDate(String dteCheckInDate){
		this.dteCheckInDate=dteCheckInDate;
	}

	public String getDteCheckoutDate(){
		return dteCheckoutDate;
	}
	public void setDteCheckoutDate(String dteCheckoutDate){
		this.dteCheckoutDate=dteCheckoutDate;
	}

	public String getStrPax(){
		return strPax;
	}
	public void setStrPax(String strPax){
		this. strPax = (String) setDefaultValue( strPax, "NA");
	}

	public String getStrSource(){
		return strSource;
	}
	public void setStrSource(String strSource){
		this. strSource = (String) setDefaultValue( strSource, "NA");
	}

	public String getStrGuestType(){
		return strGuestType;
	}
	public void setStrGuestType(String strGuestType){
		this. strGuestType = (String) setDefaultValue( strGuestType, "NA");
	}

	public String getStrExtraBed(){
		return strExtraBed;
	}
	public void setStrExtraBed(String strExtraBed){
		this. strExtraBed = (String) setDefaultValue( strExtraBed, "NA");
	}

	public String getStrChild(){
		return strChild;
	}
	public void setStrChild(String strChild){
		this. strChild = (String) setDefaultValue( strChild, "NA");
	}

	public String getStrInfant(){
		return strInfant;
	}
	public void setStrInfant(String strInfant){
		this. strInfant = (String) setDefaultValue( strInfant, "NA");
	}

	public String getStrSalesChannel(){
		return strSalesChannel;
	}
	public void setStrSalesChannel(String strSalesChannel){
		this. strSalesChannel = (String) setDefaultValue( strSalesChannel, "NA");
	}

	public String getStrRoomType(){
		return strRoomType;
	}
	public void setStrRoomType(String strRoomType){
		this. strRoomType = (String) setDefaultValue( strRoomType, "NA");
	}

	public String getStrRoomTypeDesc(){
		return strRoomTypeDesc ;
	}
	public void setStrRoomTypeDesc(String strRoomTypeDesc ){
		this. strRoomTypeDesc  = (String) setDefaultValue( strRoomTypeDesc , "");
	}

	public String getStrRoomTaxes(){
		return strRoomTaxes;
	}
	public void setStrRoomTaxes(String strRoomTaxes){
		this. strRoomTaxes = (String) setDefaultValue( strRoomTaxes, "");
	}

	public String getStrOtherTaxes(){
		return strOtherTaxes;
	}
	public void setStrOtherTaxes(String strOtherTaxes){
		this. strOtherTaxes = (String) setDefaultValue( strOtherTaxes, "NA");
	}

	public String getStrServiceCharges(){
		return strServiceCharges;
	}
	public void setStrServiceCharges(String strServiceCharges){
		this. strServiceCharges = (String) setDefaultValue( strServiceCharges, "NA");
	}

	public String getStrPayments(){
		return strPayments;
	}
	public void setStrPayments(String strPayments){
		this. strPayments = (String) setDefaultValue( strPayments, "NA");
	}

	public String getStrDiscounts(){
		return strDiscounts;
	}
	public void setStrDiscounts(String strDiscounts){
		this. strDiscounts = (String) setDefaultValue( strDiscounts, "NA");
	}

	public String getStrCard(){
		return strCard;
	}
	public void setStrCard(String strCard){
		this. strCard = (String) setDefaultValue( strCard, "NA");
	}

	public String getStrCash(){
		return strCash;
	}
	public void setStrCash(String strCash){
		this. strCash = (String) setDefaultValue( strCash, "NA");
	}

	public String getStrPaymentBtGroupLeader(){
		return strPaymentBtGroupLeader;
	}
	public void setStrPaymentBtGroupLeader(String strPaymentBtGroupLeader){
		this. strPaymentBtGroupLeader = (String) setDefaultValue( strPaymentBtGroupLeader, "NA");
	}

	public String getStrGuest(){
		return strGuest;
	}
	public void setStrGuest(String strGuest){
		this. strGuest = (String) setDefaultValue( strGuest, "NA");
	}

	public String getStrRoom(){
		return strRoom;
	}
	public void setStrRoom(String strRoom){
		this. strRoom = (String) setDefaultValue( strRoom, "NA");
	}

	public String getStrFandB(){
		return strFandB;
	}
	public void setStrFandB(String strFandB){
		this. strFandB = (String) setDefaultValue( strFandB, "NA");
	}

	public String getStrTelephones(){
		return strTelephones;
	}
	public void setStrTelephones(String strTelephones){
		this. strTelephones = (String) setDefaultValue( strTelephones, "NA");
	}

	public String getStrExtras(){
		return strExtras;
	}
	public void setStrExtras(String strExtras){
		this. strExtras = (String) setDefaultValue( strExtras, "NA");
	}

	public long getIntGid(){
		return intGid;
	}
	public void setIntGid(long intGid){
		this. intGid = (Long) setDefaultValue( intGid, "NA");
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

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getTmeTravelTime() {
		return tmeTravelTime;
	}

	public void setTmeTravelTime(String tmeTravelTime) {
		this.tmeTravelTime = tmeTravelTime;
	}


	public List<clsPMSGroupBookingDtlModel> getListPMSGroupBookingDtlModel() {
		return listPMSGroupBookingDtlModel;
	}

	public void setListPMSGroupBookingDtlModel(
			List<clsPMSGroupBookingDtlModel> listPMSGroupBookingDtlModel) {
		this.listPMSGroupBookingDtlModel = listPMSGroupBookingDtlModel;
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
