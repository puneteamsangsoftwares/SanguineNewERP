package com.sanguine.webpms.dao;

import java.util.List;

import com.sanguine.webpms.model.clsBlockRoomModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsUnBlockRoomModel;

public interface clsUnBlockRoomMasterDao {
	
	public void funAddUpdateRoomMaster(clsUnBlockRoomModel objMaster);

	//public clsUnBlockRoomModel funGetRoomMaster(String roomCode, String clientCode);

	public List<String> funGetRoomTypeList(String clientCode);

}
