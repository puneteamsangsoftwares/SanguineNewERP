package com.sanguine.webpms.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;
import com.sanguine.webpms.model.clsPMSGroupBookingHDModel_ID;
import com.sanguine.webpms.model.clsReservationHdModel;

@Repository("clsPMSGroupBookingDao")
public class clsPMSGroupBookingDaoImpl implements clsPMSGroupBookingDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public void funAddUpdatePMSGroupBooking(clsPMSGroupBookingHDModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public clsPMSGroupBookingHDModel funGetPMSGroupBooking(String docCode,String clientCode){
		

		Criteria cr = webPMSSessionFactory.getCurrentSession().createCriteria(clsPMSGroupBookingHDModel.class);
		cr.add(Restrictions.eq("strGroupCode", docCode));
		cr.add(Restrictions.eq("strClientCode", clientCode));
		List list = cr.list();

		clsPMSGroupBookingHDModel objModel = null;
		if (list.size() > 0) {
			objModel = (clsPMSGroupBookingHDModel) list.get(0);
			objModel.getListPMSGroupBookingDtlModel().size();
		}

		return objModel;
	
		
		//return (clsPMSGroupBookingHDModel) webPMSSessionFactory.getCurrentSession().get(clsPMSGroupBookingHDModel.class,new clsPMSGroupBookingHDModel_ID(docCode,clientCode));
	}


}
