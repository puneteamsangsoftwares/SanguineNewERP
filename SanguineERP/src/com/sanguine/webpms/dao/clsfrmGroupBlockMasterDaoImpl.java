package com.sanguine.webpms.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel;
import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel_ID;

@Repository("clsfrmGroupBlockMasterDao")
public class clsfrmGroupBlockMasterDaoImpl implements clsfrmGroupBlockMasterDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
	public void funAddUpdatefrmGroupBlockMaster(clsfrmGroupBlockMasterModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
	public clsfrmGroupBlockMasterModel funGetfrmGroupBlockMaster(String docCode,String clientCode){
		return (clsfrmGroupBlockMasterModel) webPMSSessionFactory.getCurrentSession().get(clsfrmGroupBlockMasterModel.class,new clsfrmGroupBlockMasterModel_ID(docCode,clientCode));
	}


}
