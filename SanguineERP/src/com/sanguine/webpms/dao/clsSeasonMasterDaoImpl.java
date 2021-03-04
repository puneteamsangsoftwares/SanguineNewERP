package com.sanguine.webpms.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsBathTypeMasterModel;
import com.sanguine.webpms.model.clsSeasonMasterModel;
import com.sanguine.webpms.model.clsSeasonMasterModel_ID;

@Repository("clsSeasonMasterDao")
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public class clsSeasonMasterDaoImpl implements clsSeasonMasterDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	/*@Transactional(value = "WebPMSTransactionManager")*/
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	public void funAddUpdateSeasonMaster(clsSeasonMasterModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}
	@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
	@Override
	public List funGetSeasonMaster(String docCode,String clientCode){
		
		List list = null;
		try {
			Criteria cr = webPMSSessionFactory.getCurrentSession().createCriteria(clsSeasonMasterModel.class);
			cr.add(Restrictions.eq("strSeasonCode", docCode));
			cr.add(Restrictions.eq("strClientCode", clientCode));
			list = cr.list();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
		
		/*return (clsSeasonMasterModel) webPMSSessionFactory.getCurrentSession().get(clsSeasonMasterModel.class,new clsSeasonMasterModel_ID(docCode,clientCode));*/
	}
	
	
	


}
