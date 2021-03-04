package com.sanguine.webpms.service;

import com.sanguine.webpms.model.clsPMSGuestFeedbackModel;

public interface clsPMSGuestFeedbackService{

	public void funAddUpdatePMSGuestFeedback(clsPMSGuestFeedbackModel objMaster);

	public clsPMSGuestFeedbackModel funGetPMSGuestFeedback(String docCode,String clientCode);

}
