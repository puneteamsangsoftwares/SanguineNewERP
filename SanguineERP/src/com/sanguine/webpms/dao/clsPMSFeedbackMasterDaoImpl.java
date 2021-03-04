package com.sanguine.webpms.dao;


import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;
import com.sanguine.webpms.model.clsPMSFeedbackMasterModel_ID;

@Repository("clsPMSFeedbackMasterDao")
public class clsPMSFeedbackMasterDaoImpl implements clsPMSFeedbackMasterDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public void funAddUpdatePMSFeedbackMaster(clsPMSFeedbackMasterModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public clsPMSFeedbackMasterModel funGetPMSFeedbackMaster(String docCode,String clientCode){
		return (clsPMSFeedbackMasterModel) webPMSSessionFactory.getCurrentSession().get(clsPMSFeedbackMasterModel.class,new clsPMSFeedbackMasterModel_ID(docCode,clientCode));
	}


}
