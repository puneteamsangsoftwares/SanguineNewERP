package com.sanguine.webpms.service;

import java.util.List;

import com.sanguine.webpms.bean.clsSeasonMasterBean;
import com.sanguine.webpms.model.clsSeasonMasterModel;

public interface clsSeasonMasterService{

	
	public clsSeasonMasterModel funPrepareSeasonModel(clsSeasonMasterBean objBathTypeMasterBean, String clientCode, String userCode);
	public void funAddUpdateSeasonMaster(clsSeasonMasterModel objMaster);

	public List funGetSeasonMaster(String docCode,String clientCode);

}
