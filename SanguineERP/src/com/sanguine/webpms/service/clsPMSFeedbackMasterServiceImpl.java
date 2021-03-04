package com.sanguine.webpms.service;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsMarketSourceMasterBean;
import com.sanguine.webpms.model.clsMarketSourceMasterModel;
import com.sanguine.webpms.dao.clsPMSFeedbackMasterDao;
import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;

@Service("clsPMSFeedbackMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
public class clsPMSFeedbackMasterServiceImpl implements clsPMSFeedbackMasterService{
	@Autowired
	private clsPMSFeedbackMasterDao objPMSFeedbackMasterDao;

	@Override
	public void funAddUpdatePMSFeedbackMaster(clsPMSFeedbackMasterModel objMaster){
		objPMSFeedbackMasterDao.funAddUpdatePMSFeedbackMaster(objMaster);
	}

	@Override
	public clsPMSFeedbackMasterModel funGetPMSFeedbackMaster(String docCode,String clientCode){
		return objPMSFeedbackMasterDao.funGetPMSFeedbackMaster(docCode,clientCode);
	}



}
