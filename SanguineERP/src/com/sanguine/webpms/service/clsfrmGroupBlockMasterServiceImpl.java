package com.sanguine.webpms.service;

import org.springframework.transaction.annotation.Transactional;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sanguine.webpms.dao.clsfrmGroupBlockMasterDao;
import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel;

@Service("clsfrmGroupBlockMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
public class clsfrmGroupBlockMasterServiceImpl implements clsfrmGroupBlockMasterService{
	@Autowired
	private clsfrmGroupBlockMasterDao objfrmGroupBlockMasterDao;

	@Override
	public void funAddUpdatefrmGroupBlockMaster(clsfrmGroupBlockMasterModel objMaster){
		objfrmGroupBlockMasterDao.funAddUpdatefrmGroupBlockMaster(objMaster);
	}

	@Override
	public clsfrmGroupBlockMasterModel funGetfrmGroupBlockMaster(String docCode,String clientCode){
		return objfrmGroupBlockMasterDao.funGetfrmGroupBlockMaster(docCode,clientCode);
	}



}
