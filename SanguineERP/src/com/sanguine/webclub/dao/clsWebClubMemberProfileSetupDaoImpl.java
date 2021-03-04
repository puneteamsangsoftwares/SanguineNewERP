package com.sanguine.webclub.dao;

import javax.transaction.Transactional;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel;
import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel_ID;

@Repository("clsWebClubMemberProfileSetupDao")
public class clsWebClubMemberProfileSetupDaoImpl implements clsWebClubMemberProfileSetupDao{

	@Autowired
	private SessionFactory WebClubSessionFactory;

	@Override
	//@Transactional(value = "OtherTransactionManager")
	public void funAddUpdateWebClubMemberProfileSetup(clsWebClubMemberProfileSetupModel objMaster){
		WebClubSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	//@Transactional(value = "OtherTransactionManager")
	public clsWebClubMemberProfileSetupModel funGetWebClubMemberProfileSetup(String docCode,String clientCode){
		return (clsWebClubMemberProfileSetupModel) WebClubSessionFactory.getCurrentSession().get(clsWebClubMemberProfileSetupModel.class,new clsWebClubMemberProfileSetupModel_ID(docCode,clientCode));
	}


}
