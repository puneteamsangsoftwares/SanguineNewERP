package com.sanguine.webpms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.dao.clsPMSStaffMasterDao;
import com.sanguine.webpms.model.clsPMSStaffMasterDtlModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel;

@Service("clsPMSStaffMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
public class clsPMSStaffMasterServiceImpl implements clsPMSStaffMasterService{
	@Autowired
	private clsPMSStaffMasterDao objPMSStaffMasterDao;

	@Override
	public void funAddUpdatePMSStaffMaster(clsPMSStaffMasterModel objMaster){
		objPMSStaffMasterDao.funAddUpdatePMSStaffMaster(objMaster);
	}

	@Override
	public clsPMSStaffMasterModel funGetPMSStaffMaster(String docCode,String clientCode){
		return objPMSStaffMasterDao.funGetPMSStaffMaster(docCode,clientCode);
	}

	
	public clsPMSStaffMasterModel funGetObject(String code, String clientCode) {
		return objPMSStaffMasterDao.funGetObject(code, clientCode);
	}

	//Staff Master 
	
	@Override
	public void funAddUpdatePMSStaffMasterDtl(clsPMSStaffMasterDtlModel objMaster){
		objPMSStaffMasterDao.funAddUpdatePMSStaffMasterDtl(objMaster);
	}

	@Override
	public List<String> funGetPMSStaffMasterDtl(String staffCode,String clientCode){
		return objPMSStaffMasterDao.funGetPMSStaffMasterDtl(staffCode,clientCode);
	}

	@Override
	public void funDeleteStaffMasterDtl(String staffCode,String clientCode){
		objPMSStaffMasterDao.funDeleteStaffMasterDtl(staffCode,clientCode);
	}

	

}
