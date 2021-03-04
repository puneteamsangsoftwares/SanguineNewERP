package com.sanguine.webclub.service;

import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel;

public interface clsWebClubMemberProfileSetupService{

	public void funAddUpdateWebClubMemberProfileSetup(clsWebClubMemberProfileSetupModel objMaster);

	public clsWebClubMemberProfileSetupModel funGetWebClubMemberProfileSetup(String docCode,String clientCode);

}
