package com.sanguine.webclub.dao;

import com.sanguine.webclub.model.clsWebClubPersonMasterModel;

public interface clsWebClubPersonMasterDao{

	public void funAddUpdateWebClubPersonMaster(clsWebClubPersonMasterModel objMaster);

	public clsWebClubPersonMasterModel funGetWebClubPersonMaster(String docCode,String clientCode);

}
