package com.sanguine.webclub.service;

import java.util.List;

import org.hibernate.Query;

import com.sanguine.webclub.bean.clsWebClubPDCBean;
import com.sanguine.webclub.model.clsWebClubPDCModel;

public interface clsWebClubOtherFieldCreationService{
	
	public void funExecuteQuery(String sql);
	public List funExecuteList(String sql);
}
