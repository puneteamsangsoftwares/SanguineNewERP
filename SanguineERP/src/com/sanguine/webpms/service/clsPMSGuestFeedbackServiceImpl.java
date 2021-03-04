package com.sanguine.webpms.service;


import java.util.ArrayList;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;

import com.sanguine.webpms.dao.clsPMSGuestFeedbackDao;
import com.sanguine.webpms.model.clsPMSGuestFeedbackModel;

@Service("clsPMSGuestFeedbackService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
public class clsPMSGuestFeedbackServiceImpl implements clsPMSGuestFeedbackService{
	@Autowired
	private clsPMSGuestFeedbackDao objPMSGuestFeedbackDao;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public void funAddUpdatePMSGuestFeedback(clsPMSGuestFeedbackModel objMaster){
		objPMSGuestFeedbackDao.funAddUpdatePMSGuestFeedback(objMaster);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public clsPMSGuestFeedbackModel funGetPMSGuestFeedback(String docCode,String clientCode){
		return objPMSGuestFeedbackDao.funGetPMSGuestFeedback(docCode,clientCode);
	}



}
