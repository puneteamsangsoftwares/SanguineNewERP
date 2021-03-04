package com.sanguine.webpms.service;

import java.util.List;

import com.sanguine.webpms.model.clsPMSStaffMasterDtlModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel;

public interface clsPMSStaffMasterService{

	public void funAddUpdatePMSStaffMaster(clsPMSStaffMasterModel objMaster);

	public clsPMSStaffMasterModel funGetPMSStaffMaster(String docCode,String clientCode);
	
	public clsPMSStaffMasterModel funGetObject(String code, String clientCode);
	
	//Staff Master Details

	public void funAddUpdatePMSStaffMasterDtl(clsPMSStaffMasterDtlModel objMaster);

	public List<String> funGetPMSStaffMasterDtl(String staffCode,String clientCode);

	public void funDeleteStaffMasterDtl(String staffCode,String clientCode);

	
}
