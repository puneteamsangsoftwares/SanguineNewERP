package com.sanguine.webpms.service;

import com.sanguine.webpms.model.clsPMSRateContractModel;

public interface clsPMSRateContractService{

	public void funAddUpdatePMSRateContract(clsPMSRateContractModel objMaster);

	public clsPMSRateContractModel funGetPMSRateContract(String docCode,String clientCode);

}
