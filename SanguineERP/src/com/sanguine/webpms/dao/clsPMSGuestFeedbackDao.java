package com.sanguine.webpms.dao;

import com.sanguine.webpms.model.clsPMSGuestFeedbackModel;

public interface clsPMSGuestFeedbackDao{

	public void funAddUpdatePMSGuestFeedback(clsPMSGuestFeedbackModel objMaster);

	public clsPMSGuestFeedbackModel funGetPMSGuestFeedback(String docCode,String clientCode);

}
