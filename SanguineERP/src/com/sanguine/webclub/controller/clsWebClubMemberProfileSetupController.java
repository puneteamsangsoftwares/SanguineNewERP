package com.sanguine.webclub.controller;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSet;
import com.mysql.jdbc.ResultSetMetaData;
import com.mysql.jdbc.Statement;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsTreeMasterModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webclub.bean.clsWebClubMemberProfileSetupBean;
import com.sanguine.webclub.model.clsWebClubMemberProfileSetupModel;
import com.sanguine.webclub.service.clsWebClubMemberProfileService;
import com.sanguine.webclub.service.clsWebClubMemberProfileSetupService;


@Controller
public class clsWebClubMemberProfileSetupController{

	@Autowired
	private clsWebClubMemberProfileSetupService objWebClubMemberProfileSetupService;
	
	@Autowired
	private clsWebClubMemberProfileService objMemberProfileService;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

	@Autowired
	clsWebClubMemberProfileService objWebClubMemberProfileService; 
	
	//Open WebClubMemberProfileSetup
/*	@RequestMapping(value = "/frmWebClubMemberProfileSetup", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmWebClubMemberProfileSetup","command", new clsWebClubMemberProfileSetupModel());
	}
	*/
	
	//Open WebClubMemberProfileSetup
		@RequestMapping(value = "/frmWebClubMemberProfileSetup", method = RequestMethod.GET)
		public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request){
			String urlHits = "1";
			try {
				urlHits = request.getParameter("saddr").toString();
			} catch (NullPointerException e) {
				urlHits = "1";
			}
			model.put("urlHits", urlHits);			
			List<clsWebClubMemberProfileSetupBean> listWebClubMemberProfileModel = new ArrayList<>();
			List<clsWebClubMemberProfileSetupBean> listOtherDtl = new ArrayList<>();
			String WebPMSDB=request.getSession().getAttribute("WebCLUBDB").toString();
			
			//member master
		 	String sqlMemProSetup="SELECT * FROM "+WebPMSDB+".tblmempropertysetup ";
			List listMemProSetup =objGlobalFunctionsService.funGetList(sqlMemProSetup);		
			Map<String,String> hashMemProSetupFill = new LinkedHashMap<String,String>();
			
			if(listMemProSetup!=null)
			{
				for(int i=0;i<listMemProSetup.size();i++)
				{
					Object [] obj=(Object[]) listMemProSetup.get(i);
					hashMemProSetupFill.put(obj[0].toString(),obj[1].toString());
				}
			}		
				
			String sqlMemMaster="SELECT * FROM "+WebPMSDB+".tblmembermaster ";
			List listMemMaster =objGlobalFunctionsService.funGetList(sqlMemMaster);
			clsWebClubMemberProfileSetupBean objBean =null;
			Map<String,String> hashMapMemMaster = funDataBaseShrink(sqlMemMaster);			
			 for (Map.Entry<String,String> entry : hashMapMemMaster.entrySet()){  
		           // System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue()); 
		            objBean = new clsWebClubMemberProfileSetupBean ();
		            objBean.setStrFieldName("M_"+entry.getKey().toString());
		            if(hashMemProSetupFill.containsKey("M_"+entry.getKey().toString())&&hashMemProSetupFill.get("M_"+entry.getKey().toString()).equalsIgnoreCase("Y"))
		            {
		            	objBean.setStrFlag("true");
		            }
		            listWebClubMemberProfileModel.add(objBean);
			 }			
		
			String sqlOtherDtl="SELECT * FROM "+WebPMSDB+".tblotherdtl ";
			List list =objGlobalFunctionsService.funGetList(sqlOtherDtl);			
			Map<String,String> hashMapOtherDtl = funDataBaseShrink(sqlOtherDtl);
			 for (Map.Entry<String,String> entry : hashMapOtherDtl.entrySet()){  
		           // System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue()); 
		            objBean = new clsWebClubMemberProfileSetupBean ();
		            objBean.setStrFieldName("O_"+entry.getKey().toString());
		            if(hashMemProSetupFill.containsKey("O_"+entry.getKey().toString())&&hashMemProSetupFill.get("O_"+entry.getKey().toString()).equalsIgnoreCase("Y"))
		            {
		            	objBean.setStrFlag("true");
		            }
		            listOtherDtl.add(objBean);
			 }		
			List<clsTreeMasterModel> objTransactions = new ArrayList<clsTreeMasterModel>();
			List<clsTreeMasterModel> objReports = new ArrayList<clsTreeMasterModel>();

			/*for (Object ob : objModel) {
				Object[] arrOb = (Object[]) ob;
				String type = arrOb[2].toString();
				clsTreeMasterModel objTree = new clsTreeMasterModel();
			}*/
			clsWebClubMemberProfileSetupBean bean = new clsWebClubMemberProfileSetupBean();
			bean.setListWebClubMemberProfileModel(listWebClubMemberProfileModel);
			bean.setListOtherDtl(listOtherDtl);
			model.put("treeList", bean);
			return new ModelAndView("frmWebClubMemberProfileSetup","command", new clsWebClubMemberProfileSetupBean());
		}
	
	
	
	//Load Master Data On Form
	@RequestMapping(value = "/frmWebClubMemberProfileSetup1", method = RequestMethod.POST)
	public @ResponseBody clsWebClubMemberProfileSetupModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsWebClubMemberProfileSetupBean objBean=new clsWebClubMemberProfileSetupBean();
		String docCode=request.getParameter("docCode").toString();
		//List listModel=objGlobalFunctionsService.funGetList(sql);
		clsWebClubMemberProfileSetupModel objWebClubMemberProfileSetup = new clsWebClubMemberProfileSetupModel();
		return objWebClubMemberProfileSetup;
	}
	
	
	
	
	
	
	

	//Save or Update WebClubMemberProfileSetup
	@RequestMapping(value = "/saveWebClubMemberProfileSetup", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsWebClubMemberProfileSetupBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsWebClubMemberProfileSetupModel objModel = funPrepareModel(objBean,userCode,clientCode,req);
			//objWebClubMemberProfileSetupService.funAddUpdateWebClubMemberProfileSetup(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "");
			
			return new ModelAndView("redirect:/frmWebClubMemberProfileSetup.html");
		}
		else{
			return new ModelAndView("frmWebClubMemberProfileSetup");
		}
	}
	
	
	/*
	
	@RequestMapping(value = "/saveSecurityShell", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsSecurityShellBean objBean, BindingResult result, HttpServletRequest req) {
		objGlobal = new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String strModuleNo = req.getSession().getAttribute("moduleNo").toString();
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		if (!result.hasErrors()) {

			// System.out.println(objBean.getListTransactionForms().size());

			List<clsTreeMasterModel> listMasters = objBean.getListMasterForms();
			List<clsTreeMasterModel> listTransactions = objBean.getListTransactionForms();
			List<clsTreeMasterModel> listReports = objBean.getListReportForms();
			List<clsTreeMasterModel> listUtilitys = objBean.getListUtilityForms();
			//objSecurityShellService.funDeleteForms(objBean.getStrUserCode(), clientCode, strModuleNo);// to
																										// delete
					
					 * @Override
					public void funDeleteForms(String userCode, String clientCode, String module) {
						Query query = sessionFactory.getCurrentSession().createQuery("DELETE clsUserDtlModel WHERE strUserCode= :userCode and strClientCode=:clientCode and strModule=:module");
						query.setParameter("userCode", userCode);
						query.setParameter("clientCode", clientCode);
						query.setParameter("module", module);
						query.executeUpdate();
				
					}																					
									
						
																										// all
																										// forms
																										// B4
																										// new
																										// entry
																										// add
			if (null != listMasters && listMasters.size() > 0) {
				funSaveUserDtl(listMasters, "M", objBean.getStrUserCode(), req.getSession().getAttribute("usercode").toString(), clientCode, req);
			}
			// remove comment of report form list :RP
			req.getSession().setAttribute("success", true);
		}
		return new ModelAndView("redirect:/frmSecurityShell.html?saddr=" + urlHits);

	}

	@RequestMapping(value = "/loadUserAccessForm", method = RequestMethod.GET)
	// public @ResponseBody clsSecurityShellBean
	// funAssignFields(@RequestParam("userCode") String code)
	public ModelAndView funAssignFields(@ModelAttribute("command") @Valid clsSecurityShellBean objBean, BindingResult result, @RequestParam("userCode") String code) {

		return new ModelAndView("frmSecurityShell");
	}

	
	
	
	
	
	private void funSaveUserDtl(List<clsTreeMasterModel> listForms, String formType, String userCode, String loggedInUserCode, String clientCode, HttpServletRequest req) {
		boolean flgChecked = false;
		String strModuleNo = req.getSession().getAttribute("moduleNo").toString();
		String add = "false", edit = "false", view = "false", print = "false", authorize = "false", delete = "false", grant = "false";
		objGlobal = new clsGlobalFunctions();
		if (listForms.size() > 0) {
			for (int i = 0; i < listForms.size(); i++) {
				clsUserDtlModel objUserDtl = new clsUserDtlModel();
				flgChecked = false;
				add = "false";
				edit = "false";
				view = "false";
				print = "false";
				authorize = "false";
				delete = "false";
				grant = "false";
				clsTreeMasterModel objTemp = (clsTreeMasterModel) listForms.get(i);
				System.out.println("Form Desc=" + objTemp.getStrFormDesc());
				if (null != objTemp.getStrAdd()) {
					add = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrEdit()) {
					edit = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrDelete()) {
					delete = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrView()) {
					view = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrPrint()) {
					print = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrGrant()) {
					grant = "true";
					flgChecked = true;
				}
				if (null != objTemp.getStrAuthorise()) {
					authorize = "true";
					flgChecked = true;
				}

				if (flgChecked) {
					objUserDtl.setStrUserCode(userCode);
					objUserDtl.setStrFormName(objTemp.getStrFormName());
					objUserDtl.setStrAdd(add);
					objUserDtl.setStrEdit(edit);
					objUserDtl.setStrDelete(delete);
					objUserDtl.setStrView(view);
					objUserDtl.setStrPrint(print);
					objUserDtl.setStrAuthorise(authorize);
					objUserDtl.setStrGrant(grant);
					objUserDtl.setStrFormType(formType);
					objUserDtl.setIntFormKey(0);
					objUserDtl.setIntFormNo(0);
					objUserDtl.setStrUserCreated(loggedInUserCode);
					objUserDtl.setStrUserModified(loggedInUserCode);
					objUserDtl.setDtCreatedDate(objGlobal.funGetCurrentDate("yyyy-MM-dd"));
					objUserDtl.setDtLastModified(objGlobal.funGetCurrentDate("yyyy-MM-dd"));
					objUserDtl.setStrDesktop("");
					objUserDtl.setStrUserName("");
					objUserDtl.setStrModule(strModuleNo);
					objUserDtl.setStrClientCode(clientCode);

				//	objSecurityShellService.funAddUpdate(objUserDtl);
				}

				
				 * System.out.println("Form Name="+objTempMaster.getStrFormName()
				 * );
				 * System.out.println("Form Desc="+objTempMaster.getStrFormDesc
				 * ()); System.out.println("Add="+objTempMaster.getStrAdd());
				 * System.out.println("Edit="+objTempMaster.getStrEdit());
				 * System.out.println("Print="+objTempMaster.getStrPrint());
				 * System.out.println("View="+objTempMaster.getStrView());
				 
			}
		}
	}*/

	 public Map funDataBaseShrink(String Sql)
	    {
	    	  Map hmap = new LinkedHashMap();
	    	  List<String> list=new ArrayList<String>();
	    	  objGlobal=new clsGlobalFunctions();
	    	  //System.out.println("Getting Column Names Example!");
	    	  Connection con = null;
	    	  String url = "jdbc:mysql://localhost:3306/";
	    	  String db = "jdbctutorial";
	    	  String driver = "com.mysql.jdbc.Driver";
	    	  String user = "root";
	    	  String pass = "root";
	    	  String dbName="";
	    	  try{
	    	  Class.forName(driver);
	    	  con = (Connection) DriverManager.getConnection(objGlobal.urlwebclub, objGlobal.urluser, objGlobal.urlPassword);
	    	  try{
	    	  Statement st = (Statement) con.createStatement();
	    	  ResultSet rs = (ResultSet) st.executeQuery(Sql);
	    	  ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();
	    	  int col = md.getColumnCount();
	    	 /* System.out.println("Number of Column : "+ col);
	    	  System.out.println("Columns Name: ");*/
	    	  for (int i = 1; i <= col; i++){
	    	  String col_name = md.getColumnName(i);
	    	  String col_type = md.getColumnTypeName(i);
	    	  hmap.put(col_name, col_type);
	    	  //list.add(col_name.toString());
	    	  //System.out.println(col_name);
	    	  }
	    	  }
	    	  catch (SQLException s){
	    	  //System.out.println("SQL statement is not executed!");
	    	  }
	    	  }
	    	  catch (Exception e){
	    	  e.printStackTrace();
	    	  }
	    	  return hmap;
	    }
//Convert bean to model function
	private clsWebClubMemberProfileSetupModel funPrepareModel(clsWebClubMemberProfileSetupBean objBean,String userCode,String clientCode,HttpServletRequest req){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;		
		// Delete all table first all table data 
		String WebClubDB=req.getSession().getAttribute("WebCLUBDB").toString();
		objMemberProfileService.funExecuteQuery("DELETE FROM "+WebClubDB+".tblmempropertysetup ");
		
		//List<clsWebClubMemberProfileSetupBean> listWebClubMemberProfileModel = new ArrayList<>();		
		if(!objBean.getListOtherDtl().isEmpty())
		{
			clsWebClubMemberProfileSetupBean objBeanList =null;
			for(int i=0;i<objBean.getListOtherDtl().size();i++)
			{				 
				objBeanList =new clsWebClubMemberProfileSetupBean();
				objBeanList=objBean.getListOtherDtl().get(i);
				clsWebClubMemberProfileSetupModel objBeanListt =null;
				if(!objBeanList.getListOtherDtl().isEmpty()||objBeanList.getListOtherDtl()!=null)
				{
					objBeanListt =new clsWebClubMemberProfileSetupModel();
					objBeanListt.setStrFieldName(objBeanList.getStrFieldName());
					if(objBeanList.getStrFlag()!=null)
					{
						if(objBeanList.getStrFlag().equalsIgnoreCase("true"))
						{
							objBeanListt.setStrFlag("Y");
						}
					}
					else
					{
						objBeanListt.setStrFlag("N");
					}
					objBeanListt.setStrClientCode(clientCode);
					objBeanListt.setStrUserCreated("");
					objBeanListt.setStrUserEdited("");
					//listWebClubMemberProfileModel.add(objBeanListt);
					objWebClubMemberProfileSetupService.funAddUpdateWebClubMemberProfileSetup(objBeanListt);
				}
			}
		}
		if(!objBean.getListWebClubMemberProfileModel().isEmpty())
		{
			clsWebClubMemberProfileSetupBean objBeanList =null;
			for(int i=0;i<objBean.getListWebClubMemberProfileModel().size();i++)
			{				 
				objBeanList =new clsWebClubMemberProfileSetupBean();
				objBeanList=objBean.getListWebClubMemberProfileModel().get(i);
				clsWebClubMemberProfileSetupModel objBeanListt =null;
				if(!objBeanList.getListWebClubMemberProfileModel().isEmpty()||objBeanList.getListWebClubMemberProfileModel()!=null)
				{
					objBeanListt =new clsWebClubMemberProfileSetupModel();
					objBeanListt.setStrFieldName(objBeanList.getStrFieldName());
					if(objBeanList.getStrFlag()!=null)
					{
						if(objBeanList.getStrFlag().equalsIgnoreCase("true"))
						{
							objBeanListt.setStrFlag("Y");
						}
					}					
					else
					{
						objBeanListt.setStrFlag("N");
					}
					objBeanListt.setStrClientCode(clientCode);
					objBeanListt.setStrUserCreated("");
					objBeanListt.setStrUserEdited("");
					//listWebClubMemberProfileModel.add(objBeanListt);
					objWebClubMemberProfileSetupService.funAddUpdateWebClubMemberProfileSetup(objBeanListt);
				}
			}
		}
			clsWebClubMemberProfileSetupModel objModel = null;
		return objModel;

	}

}
