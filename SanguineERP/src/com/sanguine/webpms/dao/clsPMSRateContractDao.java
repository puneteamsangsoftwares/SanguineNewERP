package com.sanguine.webpms.dao;

import com.sanguine.webpms.model.clsPMSRateContractModel;

public interface clsPMSRateContractDao{

	public void funAddUpdatePMSRateContract(clsPMSRateContractModel objMaster);

	public clsPMSRateContractModel funGetPMSRateContract(String docCode,String clientCode);

}
