package com.sanguine.webpms.dao;

import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel;

public interface clsfrmGroupBlockMasterDao{

	public void funAddUpdatefrmGroupBlockMaster(clsfrmGroupBlockMasterModel objMaster);

	public clsfrmGroupBlockMasterModel funGetfrmGroupBlockMaster(String docCode,String clientCode);

}
