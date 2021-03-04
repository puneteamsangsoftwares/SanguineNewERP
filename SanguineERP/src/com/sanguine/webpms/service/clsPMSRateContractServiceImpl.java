package com.sanguine.webpms.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.dao.clsPMSRateContractDao;
import com.sanguine.webpms.model.clsPMSRateContractModel;


@Service("clsPMSRateContractService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false,value = "WebPMSTransactionManager")
public class clsPMSRateContractServiceImpl implements clsPMSRateContractService{
	@Autowired
	private clsPMSRateContractDao objPMSRateContractDao;

	@Override
	public void funAddUpdatePMSRateContract(clsPMSRateContractModel objMaster){
		objPMSRateContractDao.funAddUpdatePMSRateContract(objMaster);
	}

	@Override
	public clsPMSRateContractModel funGetPMSRateContract(String docCode,String clientCode){
		return objPMSRateContractDao.funGetPMSRateContract(docCode,clientCode);
	}



}
