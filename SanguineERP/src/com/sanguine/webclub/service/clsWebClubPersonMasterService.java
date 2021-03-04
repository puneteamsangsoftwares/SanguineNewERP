package com.sanguine.webclub.service;

import com.sanguine.webclub.model.clsWebClubPersonMasterModel;

public interface clsWebClubPersonMasterService{

	public void funAddUpdateWebClubPersonMaster(clsWebClubPersonMasterModel objMaster);

	public clsWebClubPersonMasterModel funGetWebClubPersonMaster(String docCode,String clientCode);

}
