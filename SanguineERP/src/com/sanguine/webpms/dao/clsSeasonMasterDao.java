package com.sanguine.webpms.dao;

import java.util.List;

import com.sanguine.webpms.model.clsSeasonMasterModel;

public interface clsSeasonMasterDao{

	public void funAddUpdateSeasonMaster(clsSeasonMasterModel objMaster);

	public List funGetSeasonMaster(String docCode,String clientCode);

}
