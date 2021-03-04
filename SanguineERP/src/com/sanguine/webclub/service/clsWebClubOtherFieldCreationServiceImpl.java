package com.sanguine.webclub.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webclub.dao.clsWebClubOtherFieldCreationDao;

@Service("clsWebClubOtherFieldCreationService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebClubTransactionManager")
public class clsWebClubOtherFieldCreationServiceImpl implements clsWebClubOtherFieldCreationService{
	
	@Autowired
	private clsWebClubOtherFieldCreationDao objWebClubOtherFieldCreationDao;

	@Override
	public void funExecuteQuery(String sql){
		objWebClubOtherFieldCreationDao.funExecuteQuery(sql);
	}
	@Override
	public List funExecuteList(String sql){
		return objWebClubOtherFieldCreationDao.funExecuteList(sql);
	}
}
