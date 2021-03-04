package com.sanguine.webpms.service;

import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel;

public interface clsfrmGroupBlockMasterService{

	public void funAddUpdatefrmGroupBlockMaster(clsfrmGroupBlockMasterModel objMaster);

	public clsfrmGroupBlockMasterModel funGetfrmGroupBlockMaster(String docCode,String clientCode);

}
