package com.sanguine.webpms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sanguine.webpms.dao.clsBlockRoomMasterDao;
import com.sanguine.webpms.dao.clsRoomMasterDao;
import com.sanguine.webpms.dao.clsUnBlockRoomMasterDao;
import com.sanguine.webpms.model.clsBlockRoomModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsUnBlockRoomModel;


@Service("clsUnBlockRoomMasterService")
@Transactional(propagation = Propagation.REQUIRED, readOnly = false, value = "WebPMSTransactionManager")
public class clsUnBlockRoomMasterServiceImpl implements clsUnBlockRoomMasterService{
	@Autowired
	private clsUnBlockRoomMasterDao objUnBlockRoomMasterDao;

    @Override
	public List<String> funGetRoomTypeList(String clientCode) {
		return objUnBlockRoomMasterDao.funGetRoomTypeList(clientCode);
	}


	@Override
	public clsUnBlockRoomModel funGetRoomMaster(String roomCode,
			String clientCode) {
		// TODO Auto-generated method stub
		return null;
	}

	

	
	
}
