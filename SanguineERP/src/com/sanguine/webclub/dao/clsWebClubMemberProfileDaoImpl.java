package com.sanguine.webclub.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sanguine.webclub.model.clsWebClubMemberProfileModel;
import com.sanguine.webclub.model.clsWebClubMemberProfileModel_ID;
import com.sanguine.webclub.model.clsWebClubPreMemberProfileModel;

@Repository("clsMemberProfileDao")
public class clsWebClubMemberProfileDaoImpl implements clsWebClubMemberProfileDao {
	@Autowired
	private SessionFactory WebClubSessionFactory;

	@Override
	public void funAddUpdateMemberProfile(clsWebClubMemberProfileModel objMaster) {
		WebClubSessionFactory.getCurrentSession().saveOrUpdate(objMaster);
	}

	public clsWebClubMemberProfileModel funGetCustomer(String customerCode, String clientCode) {
		return (clsWebClubMemberProfileModel) WebClubSessionFactory.getCurrentSession().get(clsWebClubMemberProfileModel.class, new clsWebClubMemberProfileModel_ID(customerCode, clientCode));
	}

	public List<clsWebClubMemberProfileModel> funGetAllMember(String primaryCode, String clientCode) {
		// clsWebClubMemberProfileModel objModel = null;

		Query query = WebClubSessionFactory.getCurrentSession().createQuery(" from clsWebClubMemberProfileModel where strPrimaryCode=:primaryCode and strClientCode=:clientCode ");
		query.setParameter("primaryCode", primaryCode);
		query.setParameter("clientCode", clientCode);

		List list = query.list();

		// if(list.size()>0)
		// {
		// clsWebClubMemberProfileModel objModel =
		// (clsWebClubMemberProfileModel) list.get(0);
		//
		// }
		return list;
	}
	
	public List<clsWebClubPreMemberProfileModel> funGetAllMemberPreProfile(String primaryCode, String clientCode) {
		Query query = WebClubSessionFactory.getCurrentSession().createQuery(" from clsWebClubPreMemberProfileModel where strCustomerCode=:primaryCode and strClientCode=:clientCode ");
		query.setParameter("primaryCode", primaryCode);
		query.setParameter("clientCode", clientCode);
		List list = query.list();
		return list;
	}
	

	public clsWebClubMemberProfileModel funGetMember(String memberCode, String clientCode) {
		clsWebClubMemberProfileModel objModel = null;
		Query query = WebClubSessionFactory.getCurrentSession().createQuery(" from clsWebClubMemberProfileModel where strMemberCode=:memberCode and strClientCode=:clientCode ");
		query.setParameter("memberCode", memberCode);
		query.setParameter("clientCode", clientCode);
		@SuppressWarnings("rawtypes")
		List list = query.list();
		if (list.size() > 0) {
			objModel = (clsWebClubMemberProfileModel) list.get(0);

		}
		return objModel;
	}

	@Override
	public clsWebClubMemberProfileModel funGetWebClubAreaMaster(String docCode, String clientCode) {
		return (clsWebClubMemberProfileModel) WebClubSessionFactory.getCurrentSession().get(clsWebClubMemberProfileModel.class, new clsWebClubMemberProfileModel_ID(docCode, clientCode));
	}

	public String funGetCustomerID(String customerCode, String clientCode) {
		String custID = "01";
		Query query = WebClubSessionFactory.getCurrentSession().createQuery(" from clsWebClubMemberProfileModel where strCustomerCode=:customerCode and strClientCode=:clientCode ");
		query.setParameter("customerCode", customerCode);
		query.setParameter("clientCode", clientCode);
		@SuppressWarnings("rawtypes")
		List list = query.list();

		if (list.size() > 0) {
			clsWebClubMemberProfileModel objModel = new clsWebClubMemberProfileModel();
			objModel = (clsWebClubMemberProfileModel) list.get(0);
			custID = objModel.getStrCustomerID();
		}

		return custID;
	}
	
	
	
	
	@SuppressWarnings({ "finally", "rawtypes" })
	public void funExecuteQuery(String query) {		
			WebClubSessionFactory.getCurrentSession().createSQLQuery(query).executeUpdate();		
			/*Query query = sessionFactory.getCurrentSession().createSQLQuery(sql);
			query.();*/
	}
	


}
