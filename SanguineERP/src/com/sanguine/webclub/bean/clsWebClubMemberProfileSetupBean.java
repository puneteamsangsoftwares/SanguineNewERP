package com.sanguine.webclub.bean;

import java.util.ArrayList;
import java.util.List;

import com.sanguine.webclub.model.clsWebClubMemberProfileModel;

public class clsWebClubMemberProfileSetupBean{
	
	//Variable Declaration
	private String strFieldName;

	private String strFlag;

	private String strClientCode;

	private String strUserCreated;

	private String strUserEdited;
	
	List<clsWebClubMemberProfileSetupBean> listWebClubMemberProfileModel = new ArrayList<>();
	List<clsWebClubMemberProfileSetupBean> listOtherDtl = new ArrayList<>();
	
	
	
	public List<clsWebClubMemberProfileSetupBean> getListWebClubMemberProfileModel() {
		return listWebClubMemberProfileModel;
	}
	public void setListWebClubMemberProfileModel(
			List<clsWebClubMemberProfileSetupBean> listWebClubMemberProfileModel) {
		this.listWebClubMemberProfileModel = listWebClubMemberProfileModel;
	}
	
	
	//Setter-Getter Methods
	public String getStrFieldName(){
		return strFieldName;
	}
	public void setStrFieldName(String strFieldName){
		this.strFieldName=strFieldName;
	}

	public String getStrFlag(){
		return strFlag;
	}
	public void setStrFlag(String strFlag){
		this.strFlag=strFlag;
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
	public List<clsWebClubMemberProfileSetupBean> getListOtherDtl() {
		return listOtherDtl;
	}
	public void setListOtherDtl(List<clsWebClubMemberProfileSetupBean> listOtherDtl) {
		this.listOtherDtl = listOtherDtl;
	}
	
	
}
