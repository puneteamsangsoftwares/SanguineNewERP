package com.sanguine.webclub.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("clsWebClubOtherFieldCreationDao")
public class clsWebClubOtherFieldCreationDaoImpl implements clsWebClubOtherFieldCreationDao{

	@Autowired
	private SessionFactory WebClubSessionFactory;
	
	//
	/*@Override
	private void funExecuteQuery(String sql) {
		try {
			Query query = WebClubSessionFactory.getCurrentSession().createSQLQuery(sql);
			query.executeUpdate();
		} catch (Exception e) {
		} finally {
			
		}
	}*/
	
	@Override
	public void funExecuteQuery(String sql) {
		try {
			Query query = WebClubSessionFactory.getCurrentSession().createSQLQuery(sql);
			query.executeUpdate();
		} catch (Exception e) {
		} finally {
			
		}
		
	}
	
	
	

	@Override
	public List funExecuteList(String sql) {
		List list=null;
	
		try {
			Query query = WebClubSessionFactory.getCurrentSession().createSQLQuery(sql);
			list = query.list();
			query.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
		}
		return list;
	/*@Override
	public List funExecuteList(String sql) {
		Query query = WebClubSessionFactory.getCurrentSession().createSQLQuery(sql);
		//query.setParameter("OPCode", OPCode);
		//query.setParameter("clientCode", clientCode);
		List list = query.list();
		return list;
	}*/
	}

}
