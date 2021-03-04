package com.sanguine.webclub.dao;

import com.sanguine.model.clsWebClubBankMasterModel;


public interface clsWebClubBankMasterDao {

	public void funAddUpdateBankMaster(clsWebClubBankMasterModel objMaster);

	public clsWebClubBankMasterModel funGetBankMaster(String docCode, String clientCode);

}
