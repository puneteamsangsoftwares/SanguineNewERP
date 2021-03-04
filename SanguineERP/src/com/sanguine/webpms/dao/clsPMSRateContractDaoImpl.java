package com.sanguine.webpms.dao;

import org.springframework.stereotype.Repository;
import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsPMSRateContractModel;
import com.sanguine.webpms.model.clsPMSRateContractModel_ID;

@Repository("clsPMSRateContractDao")
public class clsPMSRateContractDaoImpl implements clsPMSRateContractDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdatePMSRateContract(clsPMSRateContractModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsPMSRateContractModel funGetPMSRateContract(String docCode,String clientCode){
		return (clsPMSRateContractModel) webPMSSessionFactory.getCurrentSession().get(clsPMSRateContractModel.class,new clsPMSRateContractModel_ID(docCode,clientCode));
	}


}
