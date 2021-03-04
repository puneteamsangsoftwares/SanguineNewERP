package com.sanguine.webpms.dao;

import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;

public interface clsPMSFeedbackMasterDao{

	public void funAddUpdatePMSFeedbackMaster(clsPMSFeedbackMasterModel objMaster);

	public clsPMSFeedbackMasterModel funGetPMSFeedbackMaster(String docCode,String clientCode);

}
