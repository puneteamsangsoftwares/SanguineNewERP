package com.sanguine.webpms.service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsSeasonMasterBean;
import com.sanguine.webpms.dao.clsSeasonMasterDao;
import com.sanguine.webpms.model.clsSeasonMasterModel;

@Service("clsSeasonMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
public class clsSeasonMasterServiceImpl implements clsSeasonMasterService{
	@Autowired
	private clsSeasonMasterDao objSeasonMasterDao;
	clsSeasonMasterModel objSeasonMasterModel;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Override
	public clsSeasonMasterModel funPrepareSeasonModel(clsSeasonMasterBean objSeasonMasterBean, String clientCode,String userCode) {
		objSeasonMasterModel = new clsSeasonMasterModel();
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		long lastNo = 0;

		if (objSeasonMasterBean.getStrSeasonCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblseasonmaster", "SeasonMaster", "strSeasonCode", clientCode);
			// lastNo=1;
			String SeasonCode = "SC" + String.format("%06d", lastNo);
			objSeasonMasterModel.setStrSeasonCode(SeasonCode);
			objSeasonMasterModel.setStrUserCreated(userCode);
			objSeasonMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objSeasonMasterModel.setStrSeasonCode(objSeasonMasterBean.getStrSeasonCode());

		}
		objSeasonMasterModel.setStrSeasonDesc(objSeasonMasterBean.getStrSeasonDesc());
		objSeasonMasterModel.setStrUserEdited(userCode);
		objSeasonMasterModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objSeasonMasterModel.setStrClientCode(clientCode);
		objSeasonMasterModel.setStrUserCreated(userCode);
		objSeasonMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objSeasonMasterModel.setDteFromDate(objGlobal.funGetDate("yyyy-MM-dd", objSeasonMasterBean.getDteFromDate()));
		objSeasonMasterModel.setDteToDate(objGlobal.funGetDate("yyyy-MM-dd", objSeasonMasterBean.getDteToDate()));
		return objSeasonMasterModel;
	}

	

	@Override
	public void funAddUpdateSeasonMaster(clsSeasonMasterModel objMaster){
		objSeasonMasterDao.funAddUpdateSeasonMaster(objMaster);
	}

	@Override
	public List funGetSeasonMaster(String docCode,String clientCode){
		return objSeasonMasterDao.funGetSeasonMaster(docCode,clientCode);
	}



}
