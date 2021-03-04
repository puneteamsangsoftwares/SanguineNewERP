package com.sanguine.webpms.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.model.clsPMSStaffMasterDtlModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel_ID;

@Repository("clsPMSStaffMasterDao")
public class clsPMSStaffMasterDaoImpl implements clsPMSStaffMasterDao{

	@Autowired
	private SessionFactory webPMSSessionFactory;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdatePMSStaffMaster(clsPMSStaffMasterModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsPMSStaffMasterModel funGetPMSStaffMaster(String docCode,String clientCode){
		return (clsPMSStaffMasterModel) webPMSSessionFactory.getCurrentSession().get(clsPMSStaffMasterModel.class,new clsPMSStaffMasterModel_ID(docCode,clientCode));
	}

	public clsPMSStaffMasterModel funGetObject(String code, String clientCode) {
		return (clsPMSStaffMasterModel) webPMSSessionFactory.getCurrentSession().get(clsPMSStaffMasterModel.class, new clsPMSStaffMasterModel_ID(code, clientCode));
	}

	//Staff Master Details
	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funAddUpdatePMSStaffMasterDtl(clsPMSStaffMasterDtlModel objMaster){
		webPMSSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	/*@Override
	@Transactional(value = "WebPMSTransactionManager")
	public clsPMSStaffMasterDtlModel funGetPMSStaffMasterDtl(String staffCode,String clientCode){
		return (clsPMSStaffMasterDtlModel) webPMSSessionFactory.getCurrentSession().get(clsPMSStaffMasterDtlModel.class,new clsPMSStaffMasterDtlModel_ID(staffCode,clientCode));
	}*/
	
	@Override
	public List<String> funGetPMSStaffMasterDtl(String staffCode,String strClientCode) {
		Query query=null;
		List<String> objListItem = new ArrayList<String>();		
		try {
				String sql = "select a.strStffCode,a.strRoomCode,a.strRoomDesc from tblstaffmasterdtl a where a.strStffCode='"+staffCode+"' and a.strClientCode='"+strClientCode+"' ";
				objListItem = webPMSSessionFactory.getCurrentSession().createSQLQuery(sql).list();
		} catch (Exception e) {
			e.printStackTrace();
		}				
		return  objListItem;
	}	
	
	
	@Override
	@Transactional(value = "WebPMSTransactionManager")
	public void funDeleteStaffMasterDtl(String staffCode,String clientCode){

		objWebPMSUtility.funExecuteUpdate("delete from tblstaffmasterdtl where strStffCode='"+staffCode+"' and strClientCode='"+clientCode+"' ", "sql");	
		
	}
	
	
	
	
	
}
