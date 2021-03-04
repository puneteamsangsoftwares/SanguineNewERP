package com.sanguine.webclub.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webclub.dao.clsWebClubPersonMasterDao;
import com.sanguine.webclub.model.clsWebClubPersonMasterModel;

@Service("clsWebClubPersonMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebClubTransactionManager")
public class clsWebClubPersonMasterServiceImpl implements clsWebClubPersonMasterService{
	@Autowired
	private clsWebClubPersonMasterDao objWebClubPersonMasterDao;

	@Override
	public void funAddUpdateWebClubPersonMaster(clsWebClubPersonMasterModel objMaster){
		objWebClubPersonMasterDao.funAddUpdateWebClubPersonMaster(objMaster);
	}

	@Override
	public clsWebClubPersonMasterModel funGetWebClubPersonMaster(String docCode,String clientCode){
		return objWebClubPersonMasterDao.funGetWebClubPersonMaster(docCode,clientCode);
	}



}
