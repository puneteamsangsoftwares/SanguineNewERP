package com.sanguine.webclub.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.model.clsWebClubBankMasterModel;
import com.sanguine.webclub.dao.clsWebClubBankMasterDao;

@Service("clsWebClubBankMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false)
public class clsWebClubBankMasterServiceImpl implements clsWebClubBankMasterService {
	@Autowired
	private clsWebClubBankMasterDao objWebClubBankMasterDao;

	@Override
	public void funAddUpdateBankMaster(clsWebClubBankMasterModel objMaster) {
		objWebClubBankMasterDao.funAddUpdateBankMaster(objMaster);
	}

	@Override
	public clsWebClubBankMasterModel funGetBankMaster(String docCode, String clientCode) {
		return objWebClubBankMasterDao.funGetBankMaster(docCode, clientCode);
	}

}
