package com.sanguine.webpms.dao;

import java.util.List;

import com.sanguine.webpms.model.clsGuestMasterHdModel;

public interface clsGuestMasterDao {

	public void funAddUpdateGuestMaster(clsGuestMasterHdModel objGuestMasterModel);

	public List funGetGuestMaster(String roomCode, String clientCode);

}
