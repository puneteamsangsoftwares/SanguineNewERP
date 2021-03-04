package com.sanguine.webclub.dao;

import java.util.List;

public interface clsWebClubGeneralMasterDao {

	public List funGetWebClubAllPaticulorMasterData(String tableName, String clientCode);

	public List funDelWebClubAllPaticulorMasterData(String currCode,String tableName, String clientCode);

	
}
