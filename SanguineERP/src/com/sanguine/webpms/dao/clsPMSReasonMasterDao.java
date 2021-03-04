package com.sanguine.webpms.dao;

import java.util.List;

import com.sanguine.webpms.model.clsPMSReasonMasterModel;

public interface clsPMSReasonMasterDao {
	public void funAddUpdateReasonMaster(clsPMSReasonMasterModel objReasonMasterModel);

	public List funGetPMSReasonMaster(String reasonCode, String clientCode);
}
