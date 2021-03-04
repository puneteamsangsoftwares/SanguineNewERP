package com.sanguine.webpms.bean;

import java.util.List;

import com.sanguine.webclub.model.clsWebClubFacilityMasterModel;
import com.sanguine.webpms.model.clsPMSStaffMasterDtlModel;

public class clsPMSStaffMasterBean{
//Variable Declaration
	private String strStaffCode;

	private String strStaffName;

	private String strClientCode;

	private String strUserCreated;

	private String strUserEdited;
	
	private String dtCreated;
	
	private String dtEdited;

	private String IntGId;	
	
	private List<clsPMSStaffMasterDtlModel> listStaffMasterDtl;
	
	public String getIntGId() {
		return IntGId;
	}
	public void setIntGId(String intGId) {
		IntGId = intGId;
	}
	//Setter-Getter Methods
	public String getStrStaffCode(){
		return strStaffCode;
	}
	public void setStrStaffCode(String strStaffCode){
		this.strStaffCode=strStaffCode;
	}

	public String getStrStaffName(){
		return strStaffName;
	}
	public void setStrStaffName(String strStaffName){
		this.strStaffName=strStaffName;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
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

	public String getDtCreated() {
		return dtCreated;
	}
	public void setDtCreated(String dtCreated) {
		this.dtCreated = dtCreated;
	}
	public String getDtEdited() {
		return dtEdited;
	}
	public void setDtEdited(String dtEdited) {
		this.dtEdited = dtEdited;
	}	

	public List<clsPMSStaffMasterDtlModel> getListStaffMasterDtl() {
		return listStaffMasterDtl;
	}

	public void setListStaffMasterDtl(
			List<clsPMSStaffMasterDtlModel> listStaffMasterDtl) {
			this.listStaffMasterDtl = listStaffMasterDtl;
	}


}
