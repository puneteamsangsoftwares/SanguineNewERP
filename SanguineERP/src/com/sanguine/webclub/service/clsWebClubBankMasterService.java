package com.sanguine.webclub.service;

import com.sanguine.model.clsWebClubBankMasterModel;


public interface clsWebClubBankMasterService {

	public void funAddUpdateBankMaster(clsWebClubBankMasterModel objMaster);
	
	public clsWebClubBankMasterModel funGetBankMaster(String docCode, String clientCode);
	
}
