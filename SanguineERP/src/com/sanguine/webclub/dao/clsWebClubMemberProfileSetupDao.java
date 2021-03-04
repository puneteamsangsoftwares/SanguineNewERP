package com.sanguine.webclub.dao;

import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel;

public interface clsWebClubMemberProfileSetupDao{

	public void funAddUpdateWebClubMemberProfileSetup(clsWebClubMemberProfileSetupModel objMaster);

	public clsWebClubMemberProfileSetupModel funGetWebClubMemberProfileSetup(String docCode,String clientCode);

}
