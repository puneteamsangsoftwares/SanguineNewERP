package com.sanguine.webclub.dao;

import java.util.List;

import com.sanguine.webclub.model.clsWebClubMemberProfileModel;
import com.sanguine.webclub.model.clsWebClubPreMemberProfileModel;

public interface clsWebClubMemberProfileDao {

	public void funAddUpdateMemberProfile(clsWebClubMemberProfileModel objMaster);

	public clsWebClubMemberProfileModel funGetCustomer(String customerCode, String clientCode);

	public List<clsWebClubMemberProfileModel> funGetAllMember(String primaryCode, String clientCode);
	
	public List<clsWebClubPreMemberProfileModel> funGetAllMemberPreProfile(String primaryCode, String clientCode);

	public clsWebClubMemberProfileModel funGetMember(String memberCode, String clientCode);

	public clsWebClubMemberProfileModel funGetWebClubAreaMaster(String areaCode, String clientCode);

	public String funGetCustomerID(String customerCode, String clientCode);
	
	public void funExecuteQuery(String sql);
	

}
