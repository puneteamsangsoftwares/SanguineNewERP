package com.sanguine.webpms.bean;

import java.util.ArrayList;
import java.util.List;

import com.sanguine.webpms.model.clsRoomPackageDtl;

public class clsPMSGroupBookingBean{
//Variable Declaration
	private String strReservationID;

	private String strGroupCode;

	private String strGroupName;

	private String strGroupLeaderCode;

	private String strAddress;

	private String strCity;

	private String strCountry;

	private String strPin;

	private String strPhone;

	private String strMobile;

	private String strFax;

	private String strEmail;

	private String dteDob;

	private String strNationality;

	private String strCompCode;

	private String strCompName;

	private String strDesignation;

	private String strGICity;

	private String strGIPhone;

	private String strGIMobile;
	
	private String strGIFax;
	
	private String dteTravelDate;
	
	private String tmeTravelTime;

	private String strPickupRequired;

	private String dteCheckInDate;

	private String dteCheckoutDate;

	private String strPax;

	private String strSource;

	private String strGuestType;

	private String strExtraBed;

	private String strChild;

	private String strInfant;

	private String strSalesChannel;

	private String strRoomTypeDesc;

	private String strRoomType;

	private String strRoomTaxes;

	private String strOtherTaxes;

	private String strServiceCharges;

	private String strPayments;

	private String strDiscounts;

	private String strCard;

	private String strCash;

	private String strPaymentBtGroupLeader;

	private String strGuest;

	private String strRoom;

	private String strFandB;

	private String strTelephones;

	private String strExtras;

	private long intGid;

	private String dteDateCreated;

	private String dteDateEdited;

	private String strUserCreated;

	private String strUserEdited;

	private String strClientCode;
	
	private String strPackageCode;

	private List<clsPMSGroupBookingDetailBean> listPMSGroupBookingDetailBean;
	
	private List<clsRoomPackageDtl> listRoomPackageDtl = new ArrayList<clsRoomPackageDtl>();
	
	//Setter-Getter Methods
	public String getStrReservationID(){
		return strReservationID;
	}
	public void setStrReservationID(String strReservationID){
		this.strReservationID=strReservationID;
	}

	public String getStrGroupCode(){
		return strGroupCode;
	}
	public void setStrGroupCode(String strGroupCode){
		this.strGroupCode=strGroupCode;
	}

	public String getStrGroupName(){
		return strGroupName;
	}
	public void setStrGroupName(String strGroupName){
		this.strGroupName=strGroupName;
	}

	public String getStrGroupLeaderCode(){
		return strGroupLeaderCode;
	}
	public void setStrGroupLeaderCode(String strGroupLeaderCode){
		this.strGroupLeaderCode=strGroupLeaderCode;
	}

	public String getStrAddress(){
		return strAddress;
	}
	public void setStrAddress(String strAddress){
		this.strAddress=strAddress;
	}

	public String getStrCity(){
		return strCity;
	}
	public void setStrCity(String strCity){
		this.strCity=strCity;
	}

	public String getStrCountry(){
		return strCountry;
	}
	public void setStrCountry(String strCountry){
		this.strCountry=strCountry;
	}

	public String getStrPin(){
		return strPin;
	}
	public void setStrPin(String strPin){
		this.strPin=strPin;
	}

	public String getStrPhone(){
		return strPhone;
	}
	public void setStrPhone(String strPhone){
		this.strPhone=strPhone;
	}

	public String getStrMobile(){
		return strMobile;
	}
	public void setStrMobile(String strMobile){
		this.strMobile=strMobile;
	}

	public String getStrFax(){
		return strFax;
	}
	public void setStrFax(String strFax){
		this.strFax=strFax;
	}

	public String getStrEmail(){
		return strEmail;
	}
	public void setStrEmail(String strEmail){
		this.strEmail=strEmail;
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
		this.strNationality=strNationality;
	}

	public String getStrCompCode(){
		return strCompCode;
	}
	public List<clsRoomPackageDtl> getListRoomPackageDtl() {
		return listRoomPackageDtl;
	}
	public void setListRoomPackageDtl(List<clsRoomPackageDtl> listRoomPackageDtl) {
		this.listRoomPackageDtl = listRoomPackageDtl;
	}
	public void setStrCompCode(String strCompCode){
		this.strCompCode=strCompCode;
	}

	public String getStrCompName(){
		return strCompName;
	}
	public void setStrCompName(String strCompName){
		this.strCompName=strCompName;
	}

	public String getStrDesignation(){
		return strDesignation;
	}
	public void setStrDesignation(String strDesignation){
		this.strDesignation=strDesignation;
	}

	public String getStrGICity(){
		return strGICity;
	}
	public void setStrGICity(String strGICity){
		this.strGICity=strGICity;
	}

	public String getStrGIPhone(){
		return strGIPhone;
	}
	public void setStrGIPhone(String strGIPhone){
		this.strGIPhone=strGIPhone;
	}

	public String getStrGIMobile(){
		return strGIMobile;
	}
	
	public void setStrGIMobile(String strGIMobile){
		this.strGIMobile=strGIMobile;
	}

	public String getStrGIFax() {
		return strGIFax;
	}
	public void setStrGIFax(String strGIFax) {
		this.strGIFax = strGIFax;
	}
	
	public String getDteTravelDate(){
		return dteTravelDate;
	}
	public void setDteTravelDate(String dteTravelDate){
		this.dteTravelDate=dteTravelDate;
	}
	
	public String getTmeTravelTime(){
		return tmeTravelTime;
	}
	public void setTmeTravelTime(String tmeTravelTime){
		this.tmeTravelTime=tmeTravelTime;
	}
	
	public String getStrPickupRequired(){
		return strPickupRequired;
	}
	public void setStrPickupRequired(String strPickupRequired){
		this.strPickupRequired=strPickupRequired;
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
		this.strPax=strPax;
	}

	public String getStrSource(){
		return strSource;
	}
	public void setStrSource(String strSource){
		this.strSource=strSource;
	}

	public String getStrGuestType(){
		return strGuestType;
	}
	public void setStrGuestType(String strGuestType){
		this.strGuestType=strGuestType;
	}

	public String getStrExtraBed(){
		return strExtraBed;
	}
	public void setStrExtraBed(String strExtraBed){
		this.strExtraBed=strExtraBed;
	}

	public String getStrChild(){
		return strChild;
	}
	public void setStrChild(String strChild){
		this.strChild=strChild;
	}

	public String getStrInfant(){
		return strInfant;
	}
	public void setStrInfant(String strInfant){
		this.strInfant=strInfant;
	}

	public String getStrSalesChannel(){
		return strSalesChannel;
	}
	public void setStrSalesChannel(String strSalesChannel){
		this.strSalesChannel=strSalesChannel;
	}	

	public String getStrRoomType(){
		return strRoomType;
	}
	public void setStrRoomType(String strRoomType){
		this.strRoomType=strRoomType;
	}
	
	public String getStrRoomTypeDesc(){
		return strRoomTypeDesc;
	}
	public void setStrRoomTypeDesc(String strRoomTypeDesc){
		this.strRoomTypeDesc=strRoomTypeDesc;
	}

	public String getStrRoomTaxes(){
		return strRoomTaxes;
	}
	public void setStrRoomTaxes(String strRoomTaxes){
		this.strRoomTaxes=strRoomTaxes;
	}

	public String getStrOtherTaxes(){
		return strOtherTaxes;
	}
	public void setStrOtherTaxes(String strOtherTaxes){
		this.strOtherTaxes=strOtherTaxes;
	}

	public String getStrServiceCharges(){
		return strServiceCharges;
	}
	public void setStrServiceCharges(String strServiceCharges){
		this.strServiceCharges=strServiceCharges;
	}

	public String getStrPayments(){
		return strPayments;
	}
	public void setStrPayments(String strPayments){
		this.strPayments=strPayments;
	}

	public String getStrDiscounts(){
		return strDiscounts;
	}
	public void setStrDiscounts(String strDiscounts){
		this.strDiscounts=strDiscounts;
	}

	public String getStrCard(){
		return strCard;
	}
	public void setStrCard(String strCard){
		this.strCard=strCard;
	}

	public String getStrCash(){
		return strCash;
	}
	public void setStrCash(String strCash){
		this.strCash=strCash;
	}

	public String getStrPaymentBtGroupLeader(){
		return strPaymentBtGroupLeader;
	}
	public void setStrPaymentBtGroupLeader(String strPaymentBtGroupLeader){
		this.strPaymentBtGroupLeader=strPaymentBtGroupLeader;
	}

	public String getStrGuest(){
		return strGuest;
	}
	public void setStrGuest(String strGuest){
		this.strGuest=strGuest;
	}

	public String getStrRoom(){
		return strRoom;
	}
	public void setStrRoom(String strRoom){
		this.strRoom=strRoom;
	}

	public String getStrFandB(){
		return strFandB;
	}
	public void setStrFandB(String strFandB){
		this.strFandB=strFandB;
	}

	public String getStrTelephones(){
		return strTelephones;
	}
	public void setStrTelephones(String strTelephones){
		this.strTelephones=strTelephones;
	}

	public String getStrExtras(){
		return strExtras;
	}
	public void setStrExtras(String strExtras){
		this.strExtras=strExtras;
	}

	public long getIntGid(){
		return intGid;
	}
	public void setIntGid(long intGid){
		this.intGid=intGid;
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
		this.strUserCreated=strUserCreated;
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this.strUserEdited=strUserEdited;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}
	public List<clsPMSGroupBookingDetailBean> getListPMSGroupBookingDetailBean() {
		return listPMSGroupBookingDetailBean;
	}
	public void setListPMSGroupBookingDetailBean(
			List<clsPMSGroupBookingDetailBean> listPMSGroupBookingDetailBean) {
		this.listPMSGroupBookingDetailBean = listPMSGroupBookingDetailBean;
	}
	
	


}
