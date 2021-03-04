package com.sanguine.webclub.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webclub.model.clsWebClubPersonMasterModel;
import com.sanguine.webclub.model.clsWebClubPersonMasterModel_ID;

@Repository("clsWebClubPersonMasterDao")
public class clsWebClubPersonMasterDaoImpl implements clsWebClubPersonMasterDao{

	@Autowired
	private SessionFactory WebClubSessionFactory;

	@Override
	public void funAddUpdateWebClubPersonMaster(clsWebClubPersonMasterModel objMaster){
		WebClubSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	public clsWebClubPersonMasterModel funGetWebClubPersonMaster(String docCode,String clientCode){
		return (clsWebClubPersonMasterModel) WebClubSessionFactory.getCurrentSession().get(clsWebClubPersonMasterModel.class,new clsWebClubPersonMasterModel_ID(docCode,clientCode));
	}


}
