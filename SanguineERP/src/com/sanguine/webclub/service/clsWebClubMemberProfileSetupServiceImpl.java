package com.sanguine.webclub.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webclub.dao.clsWebClubMemberProfileSetupDao;
import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel;

@Service("clsWebClubMemberProfileSetupService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebClubTransactionManager")
public class clsWebClubMemberProfileSetupServiceImpl implements clsWebClubMemberProfileSetupService{
	@Autowired
	private clsWebClubMemberProfileSetupDao objWebClubMemberProfileSetupDao;

	@Override
	public void funAddUpdateWebClubMemberProfileSetup(clsWebClubMemberProfileSetupModel objMaster){
		objWebClubMemberProfileSetupDao.funAddUpdateWebClubMemberProfileSetup(objMaster);
	}

	@Override
	public clsWebClubMemberProfileSetupModel funGetWebClubMemberProfileSetup(String docCode,String clientCode){
		return objWebClubMemberProfileSetupDao.funGetWebClubMemberProfileSetup(docCode,clientCode);
	}



}
