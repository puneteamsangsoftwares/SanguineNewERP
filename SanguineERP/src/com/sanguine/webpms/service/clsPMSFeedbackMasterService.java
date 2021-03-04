package com.sanguine.webpms.service;

import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;

public interface clsPMSFeedbackMasterService{

	public void funAddUpdatePMSFeedbackMaster(clsPMSFeedbackMasterModel objMaster);

	public clsPMSFeedbackMasterModel funGetPMSFeedbackMaster(String docCode,String clientCode);

}
