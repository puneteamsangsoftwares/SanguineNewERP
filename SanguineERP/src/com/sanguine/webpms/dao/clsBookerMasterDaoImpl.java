package com.sanguine.webpms.dao;

import javax.persistence.Query;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsBookerMasterHdModel;
import com.sanguine.webpms.model.clsBookerMasterModel_ID;

@Repository("clsBookerMasterDao")
public class clsBookerMasterDaoImpl implements clsBookerMasterDao {

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdateBookerMaster(clsBookerMasterHdModel objMaster) {
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsBookerMasterHdModel funGetBookerMaster(String docCode, String clientCode) {
		return (clsBookerMasterHdModel) webPMSSessionFactory.getCurrentSession().get(clsBookerMasterHdModel.class, new clsBookerMasterModel_ID(docCode, clientCode));
	}
	
	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public int funExecutePMSQuery(String sql) {
		try {
			Query query = webPMSSessionFactory.getCurrentSession().createSQLQuery(sql);
			query.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
		} finally {
			return 0;
		}
	}

}
