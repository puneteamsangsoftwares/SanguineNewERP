package com.sanguine.webpms.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsBillDtlModel;
import com.sanguine.webpms.model.clsBillHdBackupModel;
import com.sanguine.webpms.model.clsBillHdModel;
import com.sanguine.webpms.model.clsBillModel_ID;
import com.sanguine.webpms.model.clsBillTaxDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;

@Repository("clsBillDao")
public class clsBillDaoImpl implements clsBillDao {

	@Autowired
	private SessionFactory webPMSSessionFactory;

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdateBillHd(clsBillHdModel objHdModel) {
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objHdModel);
	}

	public void funAddUpdateBillDtl(clsBillDtlModel objDtlModel) {
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objDtlModel);
	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsBillHdModel funLoadBill(String docCode, String clientCode) {
		//clsBillHdModel hdModel = (clsBillHdModel) webPMSSessionFactory.getCurrentSession().get(clsBillHdModel.class, new clsBillModel_ID(docCode, clientCode));
		
		Criteria cr = webPMSSessionFactory.getCurrentSession().createCriteria(clsBillHdModel.class);
		cr.add(Restrictions.eq("strBillNo", docCode));
		cr.add(Restrictions.eq("strClientCode", clientCode));
		List list = cr.list();

		clsBillHdModel objModel = null;
		if (list.size() > 0) {
			objModel = (clsBillHdModel) list.get(0);
			objModel.getListBillDtlModels().size();
			objModel.getListBillTaxDtlModels().size();
		}
		return objModel;
		/*
		 * List<clsBillDtlModel> list = hdModel.getListBillDtlModels();
		 * hdModel.setListBillDtlModels(list); List<clsBillTaxDtlModel> list2 =
		 * hdModel.getListBillTaxDtlModels();
		 * hdModel.setListBillTaxDtlModels(list2); clsBillHdModel hdModelRet
		 * =hdModel;
		 */
		//return hdModel;
	}

	public List<clsBillDtlModel> funLoadBillDtl(String docCode, String clientCode) {
		List<clsBillDtlModel> objListDtl = null;
		try {
			Session currentsess = webPMSSessionFactory.getCurrentSession();
			Query query = currentsess.createQuery("from clsBillDtlModel where strBillNo= :billNo and strClientCode= :clientCode ");
			query.setParameter("billNo", docCode);
			query.setParameter("clientCode", clientCode);
			objListDtl = query.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			return objListDtl;
		}

	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funDeleteBill(clsBillHdModel objBillHdModel) {
		webPMSSessionFactory.getCurrentSession().delete(objBillHdModel);
	}
	
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdateBillHdBackup(clsBillHdBackupModel objHdBackupModel) {
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objHdBackupModel);
	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsBillHdBackupModel funLoadBillBackup(String docCode,
			String clientCode) {

		//clsBillHdModel hdModel = (clsBillHdModel) webPMSSessionFactory.getCurrentSession().get(clsBillHdModel.class, new clsBillModel_ID(docCode, clientCode));
		
		Criteria cr = webPMSSessionFactory.getCurrentSession().createCriteria(clsBillHdBackupModel.class);
		cr.add(Restrictions.eq("strBillNo", docCode));
		cr.add(Restrictions.eq("strClientCode", clientCode));
		List list = cr.list();

		clsBillHdBackupModel objModel = null;
		if (list.size() > 0) {
			objModel = (clsBillHdBackupModel) list.get(0);
			objModel.getListBillDtlModels().size();
			objModel.getListBillTaxDtlModels().size();
		}
		return objModel;
		/*
		 * List<clsBillDtlModel> list = hdModel.getListBillDtlModels();
		 * hdModel.setListBillDtlModels(list); List<clsBillTaxDtlModel> list2 =
		 * hdModel.getListBillTaxDtlModels();
		 * hdModel.setListBillTaxDtlModels(list2); clsBillHdModel hdModelRet
		 * =hdModel;
		 */
		//return hdModel;
	
	}
	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funDeleteBillBackup(clsBillHdBackupModel objBillHdModel) {
		webPMSSessionFactory.getCurrentSession().delete(objBillHdModel);
	}

}
