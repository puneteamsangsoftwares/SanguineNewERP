package com.sanguine.webclub.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sanguine.model.clsWebClubBankMasterModel;
import com.sanguine.model.clsWebClubBankMasterModel_ID;

@Repository("clsWebClubBankMasterDao")
public class clsWebClubBankMasterDaoImpl implements clsWebClubBankMasterDao {

	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void funAddUpdateBankMaster(clsWebClubBankMasterModel objMaster) {
		sessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	public clsWebClubBankMasterModel funGetBankMaster(String docCode, String clientCode) {
		return (clsWebClubBankMasterModel) sessionFactory.getCurrentSession().get(clsWebClubBankMasterModel.class, new clsWebClubBankMasterModel_ID(docCode, clientCode));
	}

}
