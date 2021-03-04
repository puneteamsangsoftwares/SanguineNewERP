package com.sanguine.webclub.service;

import java.util.List;

import com.sanguine.webclub.model.clsWebClubTitleMasterModel;

public interface clsWebClubGeneralMasterService {

	public List funGetWebClubAllPaticulorMasterData(String tableName, String clientCode);

	public List funDelWebClubAllPaticulorMasterData(String currCode,String tableName, String clientCode);

	
	
}
