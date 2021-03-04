package com.sanguine.webpms.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsPMSGuestFeedbackModel;
import com.sanguine.webpms.model.clsPMSGuestFeedbackModel_ID;

@Repository("clsPMSGuestFeedbackDao")
public class clsPMSGuestFeedbackDaoImpl implements clsPMSGuestFeedbackDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public void funAddUpdatePMSGuestFeedback(clsPMSGuestFeedbackModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public clsPMSGuestFeedbackModel funGetPMSGuestFeedback(String docCode,String clientCode){
		return (clsPMSGuestFeedbackModel) webPMSSessionFactory.getCurrentSession().get(clsPMSGuestFeedbackModel.class,new clsPMSGuestFeedbackModel_ID(docCode,clientCode));
	}


}
