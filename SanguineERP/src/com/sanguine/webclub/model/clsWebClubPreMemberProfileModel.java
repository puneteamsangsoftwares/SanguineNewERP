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
@Table(name = "tblpremembermaster")
@IdClass(clsWebClubPreMemberProfileModel_ID.class)
public class clsWebClubPreMemberProfileModel implements Serializable {
	private static final long serialVersionUID = 1L;

	public clsWebClubPreMemberProfileModel() {
	}

	public clsWebClubPreMemberProfileModel(clsWebClubPreMemberProfileModel_ID objModelID) {
		strCustomerCode = objModelID.getStrCustomerCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strCustomerCode", column = @Column(name = "strCustomerCode")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
	// Variable Declaration
	@Column(name = "strCustomerCode")
	private String strCustomerCode;

	@Column(name = "strMemberCode")
	private String strMemberCode;

	@Column(name = "strPrefixCode")
	private String strPrefixCode;

	@Column(name = "intGId")
	private long intGId;

	@Column(name = "strFirstName")
	private String strFirstName;

	@Column(name = "strMiddleName")
	private String strMiddleName;

	@Column(name = "strLastName")
	private String strLastName;

	@Column(name = "strNameOnCard")
	private String strNameOnCard;

	@Column(name = "strFullName")
	private String strFullName;

	@Column(name = "strResidentAddressLine1")
	private String strResidentAddressLine1;

	@Column(name = "strResidentAddressLine2")
	private String strResidentAddressLine2;

	@Column(name = "strResidentAddressLine3")
	private String strResidentAddressLine3;

	@Column(name = "strResidentLandMark")
	private String strResidentLandMark;

	@Column(name = "strResidentAreaCode")
	private String strResidentAreaCode;
	
	public String getStrResidentAreaName() {
		return strResidentAreaName;
	}

	public void setStrResidentAreaName(String strResidentAreaName) {
		this.strResidentAreaName = strResidentAreaName;
	}

	public String getStrResidentCtName() {
		return strResidentCtName;
	}

	public void setStrResidentCtName(String strResidentCtName) {
		this.strResidentCtName = strResidentCtName;
	}

	public String getStrResidentStateName() {
		return strResidentStateName;
	}

	public void setStrResidentStateName(String strResidentStateName) {
		this.strResidentStateName = strResidentStateName;
	}

	public String getStrResidentRegionName() {
		return strResidentRegionName;
	}

	public void setStrResidentRegionName(String strResidentRegionName) {
		this.strResidentRegionName = strResidentRegionName;
	}

	public String getStrResidentCountryName() {
		return strResidentCountryName;
	}

	public void setStrResidentCountryName(String strResidentCountryName) {
		this.strResidentCountryName = strResidentCountryName;
	}

	public String getStrCompanyAreaName() {
		return strCompanyAreaName;
	}

	public void setStrCompanyAreaName(String strCompanyAreaName) {
		this.strCompanyAreaName = strCompanyAreaName;
	}

	public String getStrCompanyCtName() {
		return strCompanyCtName;
	}

	public void setStrCompanyCtName(String strCompanyCtName) {
		this.strCompanyCtName = strCompanyCtName;
	}

	public String getStrCompanyStateName() {
		return strCompanyStateName;
	}

	public void setStrCompanyStateName(String strCompanyStateName) {
		this.strCompanyStateName = strCompanyStateName;
	}

	public String getStrCompanyRegionName() {
		return strCompanyRegionName;
	}

	public void setStrCompanyRegionName(String strCompanyRegionName) {
		this.strCompanyRegionName = strCompanyRegionName;
	}

	public String getStrCompanyCountryName() {
		return strCompanyCountryName;
	}

	public void setStrCompanyCountryName(String strCompanyCountryName) {
		this.strCompanyCountryName = strCompanyCountryName;
	}

	public String getStrBillingAreaName() {
		return strBillingAreaName;
	}

	public void setStrBillingAreaName(String strBillingAreaName) {
		this.strBillingAreaName = strBillingAreaName;
	}

	public String getStrBillingCtName() {
		return strBillingCtName;
	}

	public void setStrBillingCtName(String strBillingCtName) {
		this.strBillingCtName = strBillingCtName;
	}

	public String getStrBillingStateName() {
		return strBillingStateName;
	}

	public void setStrBillingStateName(String strBillingStateName) {
		this.strBillingStateName = strBillingStateName;
	}

	public String getStrBillingRegionName() {
		return strBillingRegionName;
	}

	public void setStrBillingRegionName(String strBillingRegionName) {
		this.strBillingRegionName = strBillingRegionName;
	}

	public String getStrBillingCountryName() {
		return strBillingCountryName;
	}

	public void setStrBillingCountryName(String strBillingCountryName) {
		this.strBillingCountryName = strBillingCountryName;
	}

	@Column(name = "strResidentAreaName")
	private String strResidentAreaName;

	@Column(name = "strResidentCtCode")
	private String strResidentCtCode;
	
	@Column(name = "strResidentCtName")
	private String strResidentCtName;
	
	@Column(name = "strResidentStateCode")
	private String strResidentStateCode;

	@Column(name = "strResidentStateName")
	private String strResidentStateName;

	@Column(name = "strResidentRegionCode")
	private String strResidentRegionCode;
	
	@Column(name = "strResidentRegionName")
	private String strResidentRegionName;

	@Column(name = "strResidentCountryCode")
	private String strResidentCountryCode;
	
	@Column(name = "strResidentCountryName")
	private String strResidentCountryName;

	@Column(name = "strResidentPinCode")
	private String strResidentPinCode;

	@Column(name = "strResidentTelephone1")
	private String strResidentTelephone1;

	@Column(name = "strResidentTelephone2")
	private String strResidentTelephone2;

	@Column(name = "strResidentFax1")
	private String strResidentFax1;

	@Column(name = "strResidentFax2")
	private String strResidentFax2;

	@Column(name = "strResidentMobileNo")
	private String strResidentMobileNo;

	@Column(name = "strResidentEmailID")
	private String strResidentEmailID;

	@Column(name = "strCompanyCode")
	private String strCompanyCode;

	@Column(name = "strCompanyName")
	private String strCompanyName;

	@Column(name = "strHoldingCode")
	private String strHoldingCode;

	@Column(name = "strJobProfileCode")
	private String strJobProfileCode;

	@Column(name = "strCompanyAddressLine1")
	private String strCompanyAddressLine1;

	@Column(name = "strCompanyAddressLine2")
	private String strCompanyAddressLine2;

	@Column(name = "strCompanyAddressLine3")
	private String strCompanyAddressLine3;

	@Column(name = "strCompanyLandMark")
	private String strCompanyLandMark;

	@Column(name = "strCompanyAreaCode")
	private String strCompanyAreaCode;
	
	@Column(name = "strCompanyAreaName")
	private String strCompanyAreaName;

	@Column(name = "strCompanyCtCode")
	private String strCompanyCtCode;
	
	@Column(name = "strCompanyCtName")
	private String strCompanyCtName;

	@Column(name = "strCompanyStateCode")
	private String strCompanyStateCode;
	
	@Column(name = "strCompanyStateName")
	private String strCompanyStateName;

	@Column(name = "strCompanyRegionCode")
	private String strCompanyRegionCode;
	
	@Column(name = "strCompanyRegionName")
	private String strCompanyRegionName;

	@Column(name = "strCompanyCountryCode")
	private String strCompanyCountryCode;
	
	@Column(name = "strCompanyCountryName")
	private String strCompanyCountryName;

	@Column(name = "strCompanyPinCode")
	private String strCompanyPinCode;

	@Column(name = "strCompanyTelePhone1")
	private String strCompanyTelePhone1;

	@Column(name = "strCompanyTelePhone2")
	private String strCompanyTelePhone2;

	@Column(name = "strCompanyFax1")
	private String strCompanyFax1;

	@Column(name = "strCompanyFax2")
	private String strCompanyFax2;

	@Column(name = "strCompanyMobileNo")
	private String strCompanyMobileNo;

	@Column(name = "strCompanyEmailID")
	private String strCompanyEmailID;

	@Column(name = "strBillingAddressLine1")
	private String strBillingAddressLine1;

	@Column(name = "strBillingAddressLine2")
	private String strBillingAddressLine2;

	@Column(name = "strBillingAddressLine3")
	private String strBillingAddressLine3;

	@Column(name = "strBillingLandMark")
	private String strBillingLandMark;

	@Column(name = "strBillingAreaCode")
	private String strBillingAreaCode;
	
	@Column(name = "strBillingAreaName")
	private String strBillingAreaName;

	@Column(name = "strBillingCtCode")
	private String strBillingCtCode;
	
	@Column(name = "strBillingCtName")
	private String strBillingCtName;

	@Column(name = "strBillingStateCode")
	private String strBillingStateCode;
	
	@Column(name = "strBillingStateName")
	private String strBillingStateName;

	@Column(name = "strBillingRegionCode")
	private String strBillingRegionCode;
	
	@Column(name = "strBillingRegionName")
	private String strBillingRegionName;

	@Column(name = "strBillingCountryCode")
	private String strBillingCountryCode;
	
	@Column(name = "strBillingCountryName")
	private String strBillingCountryName;

	@Column(name = "strBillingPinCode")
	private String strBillingPinCode;

	@Column(name = "strBillingTelePhone1")
	private String strBillingTelePhone1;

	@Column(name = "strBillingTelePhone2")
	private String strBillingTelePhone2;

	@Column(name = "strBillingFax1")
	private String strBillingFax1;

	@Column(name = "strBillingFax2")
	private String strBillingFax2;

	@Column(name = "strBillingMobileNo")
	private String strBillingMobileNo;

	@Column(name = "strBillingEmailID")
	private String strBillingEmailID;

	@Column(name = "dteDateofBirth")
	private String dteDateofBirth;

	@Column(name = "strGender")
	private String strGender;

	@Column(name = "strMaritalStatus")
	private String strMaritalStatus;

	@Column(name = "strProfessionCode")
	private String strProfessionCode;

	@Column(name = "dteAnniversaryDate")
	private String dteAnniversaryDate;

	@Column(name = "strCategoryCode")
	private String strCategoryCode;

	@Column(name = "dteInterviewDate")
	private String dteInterviewDate;

	@Column(name = "strPanNumber")
	private String strPanNumber;

	@Column(name = "strProposerCode")
	private String strProposerCode;

	@Column(name = "strSeconderCode")
	private String strSeconderCode;

	@Column(name = "dteMembershipStartDate")
	private String dteMembershipStartDate;

	@Column(name = "dteMembershipEndDate")
	private String dteMembershipEndDate;

	@Column(name = "strBlocked")
	private String strBlocked;

	@Column(name = "strBlockedreasonCode")
	private String strBlockedreasonCode;

	@Column(name = "strLiquorPermitNo")
	private String strLiquorPermitNo;

	@Column(name = "dtePermitExpDate")
	private String dtePermitExpDate;

	@Column(name = "strQualification")
	private String strQualification;

	@Column(name = "strResNonRes")
	private String strResNonRes;

	@Column(name = "strDesignationCode")
	private String strDesignationCode;

	@Column(name = "strLocker")
	private String strLocker;

	@Column(name = "strLibrary")
	private String strLibrary;

	@Column(name = "strBillingFlag")
	private String strBillingFlag;

	@Column(name = "strInstation")
	private String strInstation;

	@Column(name = "strSeniorCitizen")
	private String strSeniorCitizen;

	@Column(name = "dblEntranceFee")
	private double dblEntranceFee;

	@Column(name = "dblSubscriptionFee")
	private double dblSubscriptionFee;

	@Column(name = "strGolfMemberShip")
	private String strGolfMemberShip;

	@Column(name = "strStopCredit")
	private String strStopCredit;

	@Column(name = "dteProfileCreationDate")
	private String dteProfileCreationDate;

	@Column(name = "strSalesStaffCode")
	private String strSalesStaffCode;

	@Column(name = "strDependentYesNo")
	private String strDependentYesNo;

	@Column(name = "strAttachment")
	private String strAttachment;

	@Column(name = "strRemark")
	private String strRemark;

	@Column(name = "strPhoto")
	private String strPhoto;

	@Column(name = "strDebtorCode")
	private String strDebtorCode;

	@Column(name = "strCustomerID")
	private String strCustomerID;

	@Column(name = "strPrimaryCustomerCode")
	private String strPrimaryCustomerCode;

	@Column(name = "strGuestEntry")
	private String strGuestEntry;

	@Column(name = "strDepedentRelation")
	private String strDepedentRelation;

	@Column(name = "strDependentMemberCode")
	private String strDependentMemberCode;

	@Column(name = "dteMembershipExpiryDate")
	private String dteMembershipExpiryDate;

	@Column(name = "dblCMSBalance")
	private double dblCMSBalance;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "dteCreationDate")
	private String dteCreationDate;

	@Column(name = "strUserModified")
	private String strUserModified;

	@Column(name = "dteModifiedDate")
	private String dteModifiedDate;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strPropertyId")
	private String strPropertyId;

	@Column(name = "strMemberYesNo")
	private String strMemberYesNo;

	@Column(name = "strAuthorisedMember")
	private String strAuthorisedMember;

	@Column(name = "strFatherMemberCode")
	private String strFatherMemberCode;

	@Column(name = "intFormNo")
	private long intFormNo;

	@Column(name = "chrCircularemail")
	private String chrCircularemail;

	@Column(name = "strNSuffixCode")
	private String strNSuffixCode;

	@Column(name = "strSSuffixCode")
	private String strSSuffixCode;

	@Column(name = "chkmail")
	private int chkmail;

	@Column(name = "strVirtualAccountCode")
	private String strVirtualAccountCode;

	@Column(name = "strAlternateMemberCode")
	private String strAlternateMemberCode;

	@Column(name = "strSendCircularNoticeThrough")
	private String strSendCircularNoticeThrough;

	@Column(name = "strSendInvThrough")
	private String strSendInvThrough;

	@Column(name = "strDisLikes")
	private String strDisLikes;

	@Column(name = "strLikes")
	private String strLikes;

	@Column(name = "strMemberStatusCode")
	private String strMemberStatusCode;

	@Column(name = "strDependentFullName")
	private String strDependentFullName;

	@Column(name = "strDependentReasonCode")
	private String strDependentReasonCode;

	@Column(name = "dteDependentDateofBirth")
	private String dteDependentDateofBirth;

	@Column(name = "dteMemberBlockDate")
	private String dteMemberBlockDate;

	// Setter-Getter Methods

	public String getStrCustomerCode() {
		return strCustomerCode;
	}

	public long getIntGId() {
		return intGId;
	}

	public void setIntGId(long intGId) {
		this.intGId = intGId;
	}

	public String getChrCircularemail() {
		return chrCircularemail;
	}

	public void setChrCircularemail(String chrCircularemail) {
		this.chrCircularemail = chrCircularemail;
	}

	public String getStrNSuffixCode() {
		return strNSuffixCode;
	}

	public void setStrNSuffixCode(String strNSuffixCode) {
		this.strNSuffixCode = (String) setDefaultValue(strNSuffixCode, "N");
		;
	}

	public String getStrSSuffixCode() {
		return strSSuffixCode;
	}

	public void setStrSSuffixCode(String strSSuffixCode) {
		this.strSSuffixCode = (String) setDefaultValue(strSSuffixCode, "N");
		;
	}

	public int getChkmail() {
		return chkmail;
	}

	public void setChkmail(int i) {
		this.chkmail = i;
	}

	public String getStrVirtualAccountCode() {
		return strVirtualAccountCode;
	}

	public void setStrVirtualAccountCode(String strVirtualAccountCode) {
		this.strVirtualAccountCode = (String) setDefaultValue(strVirtualAccountCode, "");
		;
	}

	public String getStrAlternateMemberCode() {
		return strAlternateMemberCode;
	}

	public void setStrAlternateMemberCode(String strAlternateMemberCode) {
		this.strAlternateMemberCode = (String) setDefaultValue(strAlternateMemberCode, "");
		;
	}

	public String getStrSendCircularNoticeThrough() {
		return strSendCircularNoticeThrough;
	}

	public void setStrSendCircularNoticeThrough(String strSendCircularNoticeThrough) {
		this.strSendCircularNoticeThrough = (String) setDefaultValue(strSendCircularNoticeThrough, "N");
	}

	public String getStrSendInvThrough() {
		return strSendInvThrough;
	}

	public void setStrSendInvThrough(String strSendInvThrough) {
		this.strSendInvThrough = (String) setDefaultValue(strSendInvThrough, "N");
		;
	}

	public String getStrDisLikes() {
		return strDisLikes;
	}

	public void setStrDisLikes(String strDisLikes) {
		this.strDisLikes = (String) setDefaultValue(strDisLikes, "N");
		;
	}

	public String getStrLikes() {
		return strLikes;
	}

	public void setStrLikes(String strLikes) {
		this.strLikes = (String) setDefaultValue(strLikes, "N");
		;
	}

	public String getStrMemberStatusCode() {
		return strMemberStatusCode;
	}

	public void setStrMemberStatusCode(String strMemberStatusCode) {
		this.strMemberStatusCode = (String) setDefaultValue(strMemberStatusCode, "N");
		;
	}

	public String getStrDependentFullName() {
		return strDependentFullName;
	}

	public void setStrDependentFullName(String strDependentFullName) {
		this.strDependentFullName = strDependentFullName;
	}

	public String getStrDependentReasonCode() {
		return strDependentReasonCode;
	}

	public void setStrDependentReasonCode(String strDependentReasonCode) {
		this.strDependentReasonCode = strDependentReasonCode;
	}

	public String getDteDependentDateofBirth() {
		return dteDependentDateofBirth;
	}

	public void setDteDependentDateofBirth(String dteDependentDateofBirth) {
		this.dteDependentDateofBirth = dteDependentDateofBirth;
	}

	public String getDteMemberBlockDate() {
		return dteMemberBlockDate;
	}

	public void setDteMemberBlockDate(String dteMemberBlockDate) {
		this.dteMemberBlockDate = dteMemberBlockDate;
	}

	public void setStrCustomerCode(String strCustomerCode) {
		this.strCustomerCode = (String) setDefaultValue(strCustomerCode, "");
	}

	public String getStrMemberCode() {
		return strMemberCode;
	}

	public void setStrMemberCode(String strMemberCode) {
		this.strMemberCode = (String) setDefaultValue(strMemberCode, "");
	}

	public String getStrPrefixCode() {
		return strPrefixCode;
	}

	public void setStrPrefixCode(String strPrefixCode) {
		this.strPrefixCode = (String) setDefaultValue(strPrefixCode, "");
	}

	public String getStrFirstName() {
		return strFirstName;
	}

	public void setStrFirstName(String strFirstName) {
		this.strFirstName = (String) setDefaultValue(strFirstName, "");
	}

	public String getStrMiddleName() {
		return strMiddleName;
	}

	public void setStrMiddleName(String strMiddleName) {
		this.strMiddleName = (String) setDefaultValue(strMiddleName, "");
	}

	public String getStrLastName() {
		return strLastName;
	}

	public void setStrLastName(String strLastName) {
		this.strLastName = (String) setDefaultValue(strLastName, "");
	}

	public String getStrNameOnCard() {
		return strNameOnCard;
	}

	public void setStrNameOnCard(String strNameOnCard) {
		this.strNameOnCard = (String) setDefaultValue(strNameOnCard, "");
	}

	public String getStrFullName() {
		return strFullName;
	}

	public void setStrFullName(String strFullName) {
		this.strFullName = (String) setDefaultValue(strFullName, "");
	}

	public String getStrResidentAddressLine1() {
		return strResidentAddressLine1;
	}

	public void setStrResidentAddressLine1(String strResidentAddressLine1) {
		this.strResidentAddressLine1 = (String) setDefaultValue(strResidentAddressLine1, "");
	}

	public String getStrResidentAddressLine2() {
		return strResidentAddressLine2;
	}

	public void setStrResidentAddressLine2(String strResidentAddressLine2) {
		this.strResidentAddressLine2 = (String) setDefaultValue(strResidentAddressLine2, "");
	}

	public String getStrResidentAddressLine3() {
		return strResidentAddressLine3;
	}

	public void setStrResidentAddressLine3(String strResidentAddressLine3) {
		this.strResidentAddressLine3 = (String) setDefaultValue(strResidentAddressLine3, "");
	}

	public String getStrResidentLandMark() {
		return strResidentLandMark;
	}

	public void setStrResidentLandMark(String strResidentLandMark) {
		this.strResidentLandMark = (String) setDefaultValue(strResidentLandMark, "");
	}

	public String getStrResidentAreaCode() {
		return strResidentAreaCode;
	}

	public void setStrResidentAreaCode(String strResidentAreaCode) {
		this.strResidentAreaCode = (String) setDefaultValue(strResidentAreaCode, "");
	}

	public String getStrResidentCtCode() {
		return strResidentCtCode;
	}

	public void setStrResidentCtCode(String strResidentCtCode) {
		this.strResidentCtCode = (String) setDefaultValue(strResidentCtCode, "");
	}

	public String getStrResidentStateCode() {
		return strResidentStateCode;
	}

	public void setStrResidentStateCode(String strResidentStateCode) {
		this.strResidentStateCode = (String) setDefaultValue(strResidentStateCode, "");
	}

	public String getStrResidentRegionCode() {
		return strResidentRegionCode;
	}

	public void setStrResidentRegionCode(String strResidentRegionCode) {
		this.strResidentRegionCode = (String) setDefaultValue(strResidentRegionCode, "");
	}

	public String getStrResidentCountryCode() {
		return strResidentCountryCode;
	}

	public void setStrResidentCountryCode(String strResidentCountryCode) {
		this.strResidentCountryCode = (String) setDefaultValue(strResidentCountryCode, "");
	}

	public String getStrResidentPinCode() {
		return strResidentPinCode;
	}

	public void setStrResidentPinCode(String strResidentPinCode) {
		this.strResidentPinCode = (String) setDefaultValue(strResidentPinCode, "");
	}

	public String getStrResidentTelephone1() {
		return strResidentTelephone1;
	}

	public void setStrResidentTelephone1(String strResidentTelephone1) {
		this.strResidentTelephone1 = (String) setDefaultValue(strResidentTelephone1, "");
	}

	public String getStrResidentTelephone2() {
		return strResidentTelephone2;
	}

	public void setStrResidentTelephone2(String strResidentTelephone2) {
		this.strResidentTelephone2 = (String) setDefaultValue(strResidentTelephone2, "");
	}

	public String getStrResidentFax1() {
		return strResidentFax1;
	}

	public void setStrResidentFax1(String strResidentFax1) {
		this.strResidentFax1 = (String) setDefaultValue(strResidentFax1, "");
	}

	public String getStrResidentFax2() {
		return strResidentFax2;
	}

	public void setStrResidentFax2(String strResidentFax2) {
		this.strResidentFax2 = (String) setDefaultValue(strResidentFax2, "");
	}

	public String getStrResidentMobileNo() {
		return strResidentMobileNo;
	}

	public void setStrResidentMobileNo(String strResidentMobileNo) {
		this.strResidentMobileNo = (String) setDefaultValue(strResidentMobileNo, "");
	}

	public String getStrResidentEmailID() {
		return strResidentEmailID;
	}

	public void setStrResidentEmailID(String strResidentEmailID) {
		this.strResidentEmailID = (String) setDefaultValue(strResidentEmailID, "");
	}

	public String getStrCompanyCode() {
		return strCompanyCode;
	}

	public void setStrCompanyCode(String strCompanyCode) {
		this.strCompanyCode = (String) setDefaultValue(strCompanyCode, "");
	}

	public String getStrCompanyName() {
		return strCompanyName;
	}

	public void setStrCompanyName(String strCompanyName) {
		this.strCompanyName = (String) setDefaultValue(strCompanyName, "");
	}

	public String getStrHoldingCode() {
		return strHoldingCode;
	}

	public void setStrHoldingCode(String strHoldingCode) {
		this.strHoldingCode = (String) setDefaultValue(strHoldingCode, "");
	}

	public String getStrJobProfileCode() {
		return strJobProfileCode;
	}

	public void setStrJobProfileCode(String strJobProfileCode) {
		this.strJobProfileCode = (String) setDefaultValue(strJobProfileCode, "");
	}

	public String getStrCompanyAddressLine1() {
		return strCompanyAddressLine1;
	}

	public void setStrCompanyAddressLine1(String strCompanyAddressLine1) {
		this.strCompanyAddressLine1 = (String) setDefaultValue(strCompanyAddressLine1, "");
	}

	public String getStrCompanyAddressLine2() {
		return strCompanyAddressLine2;
	}

	public void setStrCompanyAddressLine2(String strCompanyAddressLine2) {
		this.strCompanyAddressLine2 = (String) setDefaultValue(strCompanyAddressLine2, "");
	}

	public String getStrCompanyAddressLine3() {
		return strCompanyAddressLine3;
	}

	public void setStrCompanyAddressLine3(String strCompanyAddressLine3) {
		this.strCompanyAddressLine3 = (String) setDefaultValue(strCompanyAddressLine3, "");
	}

	public String getStrCompanyLandMark() {
		return strCompanyLandMark;
	}

	public void setStrCompanyLandMark(String strCompanyLandMark) {
		this.strCompanyLandMark = (String) setDefaultValue(strCompanyLandMark, "");
	}

	public String getStrCompanyAreaCode() {
		return strCompanyAreaCode;
	}

	public void setStrCompanyAreaCode(String strCompanyAreaCode) {
		this.strCompanyAreaCode = (String) setDefaultValue(strCompanyAreaCode, "");
	}

	public String getStrCompanyCtCode() {
		return strCompanyCtCode;
	}

	public void setStrCompanyCtCode(String strCompanyCtCode) {
		this.strCompanyCtCode = (String) setDefaultValue(strCompanyCtCode, "");
	}

	public String getStrCompanyStateCode() {
		return strCompanyStateCode;
	}

	public void setStrCompanyStateCode(String strCompanyStateCode) {
		this.strCompanyStateCode = (String) setDefaultValue(strCompanyStateCode, "");
	}

	public String getStrCompanyRegionCode() {
		return strCompanyRegionCode;
	}

	public void setStrCompanyRegionCode(String strCompanyRegionCode) {
		this.strCompanyRegionCode = (String) setDefaultValue(strCompanyRegionCode, "");
	}

	public String getStrCompanyCountryCode() {
		return strCompanyCountryCode;
	}

	public void setStrCompanyCountryCode(String strCompanyCountryCode) {
		this.strCompanyCountryCode = (String) setDefaultValue(strCompanyCountryCode, "");
	}

	public String getStrCompanyPinCode() {
		return strCompanyPinCode;
	}

	public void setStrCompanyPinCode(String strCompanyPinCode) {
		this.strCompanyPinCode = (String) setDefaultValue(strCompanyPinCode, "");
	}

	public String getStrCompanyTelePhone1() {
		return strCompanyTelePhone1;
	}

	public void setStrCompanyTelePhone1(String strCompanyTelePhone1) {
		this.strCompanyTelePhone1 = (String) setDefaultValue(strCompanyTelePhone1, "");
	}

	public String getStrCompanyTelePhone2() {
		return strCompanyTelePhone2;
	}

	public void setStrCompanyTelePhone2(String strCompanyTelePhone2) {
		this.strCompanyTelePhone2 = (String) setDefaultValue(strCompanyTelePhone2, "");
	}

	public String getStrCompanyFax1() {
		return strCompanyFax1;
	}

	public void setStrCompanyFax1(String strCompanyFax1) {
		this.strCompanyFax1 = (String) setDefaultValue(strCompanyFax1, "");
	}

	public String getStrCompanyFax2() {
		return strCompanyFax2;
	}

	public void setStrCompanyFax2(String strCompanyFax2) {
		this.strCompanyFax2 = (String) setDefaultValue(strCompanyFax2, "");
	}

	public String getStrCompanyMobileNo() {
		return strCompanyMobileNo;
	}

	public void setStrCompanyMobileNo(String strCompanyMobileNo) {
		this.strCompanyMobileNo = (String) setDefaultValue(strCompanyMobileNo, "");
	}

	public String getStrCompanyEmailID() {
		return strCompanyEmailID;
	}

	public void setStrCompanyEmailID(String strCompanyEmailID) {
		this.strCompanyEmailID = (String) setDefaultValue(strCompanyEmailID, "");
	}

	public String getStrBillingAddressLine1() {
		return strBillingAddressLine1;
	}

	public void setStrBillingAddressLine1(String strBillingAddressLine1) {
		this.strBillingAddressLine1 = (String) setDefaultValue(strBillingAddressLine1, "");
	}

	public String getStrBillingAddressLine2() {
		return strBillingAddressLine2;
	}

	public void setStrBillingAddressLine2(String strBillingAddressLine2) {
		this.strBillingAddressLine2 = (String) setDefaultValue(strBillingAddressLine2, "");
	}

	public String getStrBillingAddressLine3() {
		return strBillingAddressLine3;
	}

	public void setStrBillingAddressLine3(String strBillingAddressLine3) {
		this.strBillingAddressLine3 = (String) setDefaultValue(strBillingAddressLine3, "");
	}

	public String getStrBillingLandMark() {
		return strBillingLandMark;
	}

	public void setStrBillingLandMark(String strBillingLandMark) {
		this.strBillingLandMark = (String) setDefaultValue(strBillingLandMark, "");
	}

	public String getStrBillingAreaCode() {
		return strBillingAreaCode;
	}

	public void setStrBillingAreaCode(String strBillingAreaCode) {
		this.strBillingAreaCode = (String) setDefaultValue(strBillingAreaCode, "");
	}

	public String getStrBillingCtCode() {
		return strBillingCtCode;
	}

	public void setStrBillingCtCode(String strBillingCtCode) {
		this.strBillingCtCode = (String) setDefaultValue(strBillingCtCode, "");
	}

	public String getStrBillingStateCode() {
		return strBillingStateCode;
	}

	public void setStrBillingStateCode(String strBillingStateCode) {
		this.strBillingStateCode = (String) setDefaultValue(strBillingStateCode, "");
	}

	public String getStrBillingRegionCode() {
		return strBillingRegionCode;
	}

	public void setStrBillingRegionCode(String strBillingRegionCode) {
		this.strBillingRegionCode = (String) setDefaultValue(strBillingRegionCode, "");
	}

	public String getStrBillingCountryCode() {
		return strBillingCountryCode;
	}

	public void setStrBillingCountryCode(String strBillingCountryCode) {
		this.strBillingCountryCode = (String) setDefaultValue(strBillingCountryCode, "");
	}

	public String getStrBillingPinCode() {
		return strBillingPinCode;
	}

	public void setStrBillingPinCode(String strBillingPinCode) {
		this.strBillingPinCode = (String) setDefaultValue(strBillingPinCode, "");
	}

	public String getStrBillingTelePhone1() {
		return strBillingTelePhone1;
	}

	public void setStrBillingTelePhone1(String strBillingTelePhone1) {
		this.strBillingTelePhone1 = (String) setDefaultValue(strBillingTelePhone1, "");
	}

	public String getStrBillingTelePhone2() {
		return strBillingTelePhone2;
	}

	public void setStrBillingTelePhone2(String strBillingTelePhone2) {
		this.strBillingTelePhone2 = (String) setDefaultValue(strBillingTelePhone2, "");
	}

	public String getStrBillingFax1() {
		return strBillingFax1;
	}

	public void setStrBillingFax1(String strBillingFax1) {
		this.strBillingFax1 = (String) setDefaultValue(strBillingFax1, "");
	}

	public String getStrBillingFax2() {
		return strBillingFax2;
	}

	public void setStrBillingFax2(String strBillingFax2) {
		this.strBillingFax2 = (String) setDefaultValue(strBillingFax2, "");
	}

	public String getStrBillingMobileNo() {
		return strBillingMobileNo;
	}

	public void setStrBillingMobileNo(String strBillingMobileNo) {
		this.strBillingMobileNo = (String) setDefaultValue(strBillingMobileNo, "");
	}

	public String getStrBillingEmailID() {
		return strBillingEmailID;
	}

	public void setStrBillingEmailID(String strBillingEmailID) {
		this.strBillingEmailID = (String) setDefaultValue(strBillingEmailID, "");
	}

	public String getDteDateofBirth() {
		return dteDateofBirth;
	}

	public void setDteDateofBirth(String dteDateofBirth) {
		this.dteDateofBirth = dteDateofBirth;
	}

	public String getStrGender() {
		return strGender;
	}

	public void setStrGender(String strGender) {
		this.strGender = (String) setDefaultValue(strGender, "");
	}

	public String getStrMaritalStatus() {
		return strMaritalStatus;
	}

	public void setStrMaritalStatus(String strMaritalStatus) {
		this.strMaritalStatus = (String) setDefaultValue(strMaritalStatus, "");
	}

	public String getStrProfessionCode() {
		return strProfessionCode;
	}

	public void setStrProfessionCode(String strProfessionCode) {
		this.strProfessionCode = (String) setDefaultValue(strProfessionCode, "");
	}

	public String getDteAnniversaryDate() {
		return dteAnniversaryDate;
	}

	public void setDteAnniversaryDate(String dteAnniversaryDate) {
		this.dteAnniversaryDate = dteAnniversaryDate;
	}

	public String getStrCategoryCode() {
		return strCategoryCode;
	}

	public void setStrCategoryCode(String strCategoryCode) {
		this.strCategoryCode = (String) setDefaultValue(strCategoryCode, "");
	}

	public String getDteInterviewDate() {
		return dteInterviewDate;
	}

	public void setDteInterviewDate(String dteInterviewDate) {
		this.dteInterviewDate = dteInterviewDate;
	}

	public String getStrPanNumber() {
		return strPanNumber;
	}

	public void setStrPanNumber(String strPanNumber) {
		this.strPanNumber = (String) setDefaultValue(strPanNumber, "");
	}

	public String getStrProposerCode() {
		return strProposerCode;
	}

	public void setStrProposerCode(String strProposerCode) {
		this.strProposerCode = (String) setDefaultValue(strProposerCode, "");
	}

	public String getStrSeconderCode() {
		return strSeconderCode;
	}

	public void setStrSeconderCode(String strSeconderCode) {
		this.strSeconderCode = (String) setDefaultValue(strSeconderCode, "");
	}

	public String getDteMembershipStartDate() {
		return dteMembershipStartDate;
	}

	public void setDteMembershipStartDate(String dteMembershipStartDate) {
		this.dteMembershipStartDate = dteMembershipStartDate;
	}

	public String getDteMembershipEndDate() {
		return dteMembershipEndDate;
	}

	public void setDteMembershipEndDate(String dteMembershipEndDate) {
		this.dteMembershipEndDate = dteMembershipEndDate;
	}

	public String getStrBlocked() {
		return strBlocked;
	}

	public void setStrBlocked(String strBlocked) {
		this.strBlocked = (String) setDefaultValue(strBlocked, "N");
	}

	public String getStrBlockedreasonCode() {
		return strBlockedreasonCode;
	}

	public void setStrBlockedreasonCode(String strBlockedreasonCode) {
		this.strBlockedreasonCode = (String) setDefaultValue(strBlockedreasonCode, "");
	}

	public String getStrLiquorPermitNo() {
		return strLiquorPermitNo;
	}

	public void setStrLiquorPermitNo(String strLiquorPermitNo) {
		this.strLiquorPermitNo = (String) setDefaultValue(strLiquorPermitNo, "");
	}

	public String getDtePermitExpDate() {
		return dtePermitExpDate;
	}

	public void setDtePermitExpDate(String dtePermitExpDate) {
		this.dtePermitExpDate = dtePermitExpDate;
	}

	public String getStrQualification() {
		return strQualification;
	}

	public void setStrQualification(String strQualification) {
		this.strQualification = (String) setDefaultValue(strQualification, "");
	}

	public String getStrResNonRes() {
		return strResNonRes;
	}

	public void setStrResNonRes(String strResNonRes) {
		this.strResNonRes = (String) setDefaultValue(strResNonRes, "Y");
	}

	public String getStrDesignationCode() {
		return strDesignationCode;
	}

	public void setStrDesignationCode(String strDesignationCode) {
		this.strDesignationCode = (String) setDefaultValue(strDesignationCode, "");
	}

	public String getStrLocker() {
		return strLocker;
	}

	public void setStrLocker(String strLocker) {
		this.strLocker = (String) setDefaultValue(strLocker, "N");
	}

	public String getStrLibrary() {
		return strLibrary;
	}

	public void setStrLibrary(String strLibrary) {
		this.strLibrary = (String) setDefaultValue(strLibrary, "N");
	}

	public String getStrBillingFlag() {
		return strBillingFlag;
	}

	public void setStrBillingFlag(String strBillingFlag) {
		this.strBillingFlag = (String) setDefaultValue(strBillingFlag, "N");
	}

	public String getStrInstation() {
		return strInstation;
	}

	public void setStrInstation(String strInstation) {
		this.strInstation = (String) setDefaultValue(strInstation, "N");
	}

	public String getStrSeniorCitizen() {
		return strSeniorCitizen;
	}

	public void setStrSeniorCitizen(String strSeniorCitizen) {
		this.strSeniorCitizen = (String) setDefaultValue(strSeniorCitizen, "N");
	}

	public double getDblEntranceFee() {
		return dblEntranceFee;
	}

	public void setDblEntranceFee(double dblEntranceFee) {
		this.dblEntranceFee = (Double) setDefaultValue(dblEntranceFee, "");
	}

	public double getDblSubscriptionFee() {
		return dblSubscriptionFee;
	}

	public void setDblSubscriptionFee(double dblSubscriptionFee) {
		this.dblSubscriptionFee = (Double) setDefaultValue(dblSubscriptionFee, "");
	}

	public String getStrGolfMemberShip() {
		return strGolfMemberShip;
	}

	public void setStrGolfMemberShip(String strGolfMemberShip) {
		this.strGolfMemberShip = (String) setDefaultValue(strGolfMemberShip, "N");
	}

	public String getStrStopCredit() {
		return strStopCredit;
	}

	public void setStrStopCredit(String strStopCredit) {
		this.strStopCredit = (String) setDefaultValue(strStopCredit, "N");
	}

	public String getDteProfileCreationDate() {
		return dteProfileCreationDate;
	}

	public void setDteProfileCreationDate(String dteProfileCreationDate) {
		this.dteProfileCreationDate = dteProfileCreationDate;
	}

	public String getStrSalesStaffCode() {
		return strSalesStaffCode;
	}

	public void setStrSalesStaffCode(String strSalesStaffCode) {
		this.strSalesStaffCode = (String) setDefaultValue(strSalesStaffCode, "");
	}

	public String getStrDependentYesNo() {
		return strDependentYesNo;
	}

	public void setStrDependentYesNo(String strDependentYesNo) {
		this.strDependentYesNo = (String) setDefaultValue(strDependentYesNo, "N");
	}

	public String getStrAttachment() {
		return strAttachment;
	}

	public void setStrAttachment(String strAttachment) {
		this.strAttachment = (String) setDefaultValue(strAttachment, "N");
	}

	public String getStrRemark() {
		return strRemark;
	}

	public void setStrRemark(String strRemark) {
		this.strRemark = (String) setDefaultValue(strRemark, "");
	}

	public String getStrPhoto() {
		return strPhoto;
	}

	public void setStrPhoto(String strPhoto) {
		this.strPhoto = (String) setDefaultValue(strPhoto, "");
	}

	public String getStrDebtorCode() {
		return strDebtorCode;
	}

	public void setStrDebtorCode(String strDebtorCode) {
		this.strDebtorCode = (String) setDefaultValue(strDebtorCode, "");
	}

	public String getStrCustomerID() {
		return strCustomerID;
	}

	public void setStrCustomerID(String strCustomerID) {
		this.strCustomerID = (String) setDefaultValue(strCustomerID, "");
	}

	public String getStrPrimaryCustomerCode() {
		return strPrimaryCustomerCode;
	}

	public void setStrPrimaryCustomerCode(String strPrimaryCustomerCode) {
		this.strPrimaryCustomerCode = (String) setDefaultValue(strPrimaryCustomerCode, "");
	}

	public String getStrGuestEntry() {
		return strGuestEntry;
	}

	public void setStrGuestEntry(String strGuestEntry) {
		this.strGuestEntry = (String) setDefaultValue(strGuestEntry, "N");
	}

	public String getStrDepedentRelation() {
		return strDepedentRelation;
	}

	public void setStrDepedentRelation(String strDepedentRelation) {
		this.strDepedentRelation = (String) setDefaultValue(strDepedentRelation, "");
	}

	public String getStrDependentMemberCode() {
		return strDependentMemberCode;
	}

	public void setStrDependentMemberCode(String strDependentMemberCode) {
		this.strDependentMemberCode = (String) setDefaultValue(strDependentMemberCode, "");
	}

	public String getDteMembershipExpiryDate() {
		return dteMembershipExpiryDate;
	}

	public void setDteMembershipExpiryDate(String dteMembershipExpiryDate) {
		this.dteMembershipExpiryDate = dteMembershipExpiryDate;
	}

	public double getDblCMSBalance() {
		return dblCMSBalance;
	}

	public void setDblCMSBalance(double dblCMSBalance) {
		this.dblCMSBalance = (Double) setDefaultValue(dblCMSBalance, "");
	}

	public String getStrUserCreated() {
		return strUserCreated;
	}

	public void setStrUserCreated(String strUserCreated) {
		this.strUserCreated = (String) setDefaultValue(strUserCreated, "");
	}

	public String getDteCreationDate() {
		return dteCreationDate;
	}

	public void setDteCreationDate(String dteCreationDate) {
		this.dteCreationDate = dteCreationDate;
	}

	public String getStrUserModified() {
		return strUserModified;
	}

	public void setStrUserModified(String strUserModified) {
		this.strUserModified = (String) setDefaultValue(strUserModified, "");
	}

	public String getDteModifiedDate() {
		return dteModifiedDate;
	}

	public void setDteModifiedDate(String dteModifiedDate) {
		this.dteModifiedDate = dteModifiedDate;
	}

	public String getStrClientCode() {
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode) {
		this.strClientCode = (String) setDefaultValue(strClientCode, "");
	}

	public String getStrPropertyId() {
		return strPropertyId;
	}

	public void setStrPropertyId(String strPropertyId) {
		this.strPropertyId = (String) setDefaultValue(strPropertyId, "");
	}

	public String getStrMemberYesNo() {
		return strMemberYesNo;
	}

	public void setStrMemberYesNo(String strMemberYesNo) {
		this.strMemberYesNo = (String) setDefaultValue(strMemberYesNo, "N");
	}

	public String getStrAuthorisedMember() {
		return strAuthorisedMember;
	}

	public void setStrAuthorisedMember(String strAuthorisedMember) {
		this.strAuthorisedMember = (String) setDefaultValue(strAuthorisedMember, "N");
	}

	public String getStrFatherMemberCode() {
		return strFatherMemberCode;
	}

	public void setStrFatherMemberCode(String strFatherMemberCode) {
		this.strFatherMemberCode = (String) setDefaultValue(strFatherMemberCode, "");
	}

	public long getIntFormNo() {
		return intFormNo;
	}

	public void setIntFormNo(long intFormNo) {
		this.intFormNo = (Long) setDefaultValue(intFormNo, "");
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
