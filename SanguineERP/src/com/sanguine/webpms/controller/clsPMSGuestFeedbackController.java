package com.sanguine.webpms.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;


import com.sanguine.service.clsSetupMasterService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.util.clsReportBean;
import com.sanguine.webpms.bean.clsBillPrintingBean;
import com.sanguine.webpms.bean.clsPMSFeedbackMasterBean;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsGuestMasterModel_ID;
import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPMSFeedbackMasterService;
import com.sanguine.webpms.service.clsPropertySetupService;
import com.sanguine.webpms.bean.clsPMSGuestFeedbackBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsPMSGuestFeedbackModel;
import com.sanguine.webpms.service.clsPMSGuestFeedbackService;

@Controller
public class clsPMSGuestFeedbackController{

	@Autowired
	private clsPMSGuestFeedbackService objPMSGuestFeedbackService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private clsSetupMasterService objSetupMasterService;
	@Autowired
	private clsGuestMasterService objGuestMasterService;

	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

	@Autowired
	private clsPropertySetupService objPropertySetupService;
	
	@Autowired
	private intfBaseService objBaseService;


	@Autowired

//Open PMSGuestFeedback
	@RequestMapping(value = "/frmPMSGuestFeedback", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmPMSGuestFeedback","command", new clsPMSGuestFeedbackBean());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmPMSGuestFeedback1", method = RequestMethod.POST)
	public @ResponseBody List<clsPMSGuestFeedbackBean> funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsPMSGuestFeedbackBean objBean=new clsPMSGuestFeedbackBean();
		String docCode=request.getParameter("doccode").toString();
		List<clsPMSGuestFeedbackBean> listRet = new ArrayList<clsPMSGuestFeedbackBean>();
		String sql = "select a.strGuestFeedbackCode,a.strGuestCode,a.strFeedbackCode,a.strExcellent,a.strGood,a.strFair,a.strPoor,a.strRemark,b.strFeedbackDesc from tblguestfeedback a ,tblpmsfeedbackmaster b where a.strFeedbackCode=b.strFeedbackCode and  a.strClientCode='"+clientCode+"' and a.strGuestFeedbackCode='"+docCode+"'";
		List listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");

		for(int i=0;i<listModel.size();i++)
		{
			clsPMSGuestFeedbackBean objBean2 = new clsPMSGuestFeedbackBean();
			Object[] arr = (Object[]) listModel.get(i);
			
			objBean2.setStrGuestFeedbackCode(arr[0].toString());
			objBean2.setStrGuestCode(arr[1].toString());
			objBean2.setStrFeedbackCode(arr[2].toString());
			objBean2.setStrExcellent(arr[3].toString());
			objBean2.setStrGood(arr[4].toString());
			objBean2.setStrFair(arr[5].toString());
			objBean2.setStrPoor(arr[6].toString());
			objBean2.setStrRemark(arr[7].toString());
			objBean2.setStrFeedbackDesc(arr[8].toString());
			
			listRet.add(objBean2);
			
		}
		
		return listRet;
	}
	
	@RequestMapping(value = "/loadAllFeedbacks", method = RequestMethod.POST)
	public @ResponseBody List<clsPMSFeedbackMasterBean >funLoadAllFeedbacks(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String docCode=request.getParameter("doccode").toString();
		List<clsPMSFeedbackMasterBean> listReturn = new ArrayList<clsPMSFeedbackMasterBean>();

		if(docCode.equals(""))
		{
			
			
			String sql="select a.strFeedbackCode,a.strFeedbackDesc from tblpmsfeedbackmaster a where a.strClientCode='"+clientCode+"' ";
			String userCode=request.getSession().getAttribute("usercode").toString();
			clsPMSGuestFeedbackBean objBean=new clsPMSGuestFeedbackBean();
			List listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");
			clsPMSFeedbackMasterBean objFeedbackMasterBean = null;
			if(listModel!=null && listModel.size()>0)
			{
				for(int i=0;i<listModel.size();i++)
				{
					listReturn = new ArrayList<clsPMSFeedbackMasterBean>();
					Object[] arr = (Object[]) listModel.get(i);
					objFeedbackMasterBean = new clsPMSFeedbackMasterBean();
					
					objFeedbackMasterBean.setStrFeedbackCode(arr[0].toString());
					objFeedbackMasterBean.setStrFeedbackDesc(arr[1].toString());
					
					objFeedbackMasterBean.setStrExcellent("N");
					objFeedbackMasterBean.setStrGood("N");
					objFeedbackMasterBean.setStrFair("N");
					objFeedbackMasterBean.setStrPoor("N");
					
					listReturn.add(objFeedbackMasterBean);
					
				}
			}
		}
		else
		{
			String sql = "select a.strGuestFeedbackCode,a.strGuestCode,a.strFeedbackCode,a.strExcellent,a.strGood,a.strFair,a.strPoor,a.strRemark,b.strFeedbackDesc,Concat(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName) from tblguestfeedback a ,tblpmsfeedbackmaster b,tblguestmaster c  where a.strFeedbackCode=b.strFeedbackCode and  a.strClientCode='"+clientCode+"' AND a.strGuestCode='"+docCode+"' and a.strGuestCode=c.strGuestCode ";
			List listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");

			if(listModel!=null && listModel.size()>0)
			{
				for(int i=0;i<listModel.size();i++)
				{
					clsPMSFeedbackMasterBean objBean2 = new clsPMSFeedbackMasterBean();
					Object[] arr = (Object[]) listModel.get(i);
					objBean2.setStrGuestFeedbackCode(arr[0].toString());
					objBean2.setStrGuestCode(arr[1].toString());
					objBean2.setStrFeedbackCode(arr[2].toString());
					objBean2.setStrExcellent(arr[3].toString());
					objBean2.setStrGood(arr[4].toString());
					objBean2.setStrFair(arr[5].toString());
					objBean2.setStrPoor(arr[6].toString());
					objBean2.setStrRemark(arr[7].toString());
					objBean2.setStrFeedbackDesc(arr[8].toString());
					objBean2.setStrGuestName(arr[9].toString());
					
					listReturn.add(objBean2);
					
				}
			}
			else
			{
				sql="select a.strFeedbackCode,a.strFeedbackDesc from tblpmsfeedbackmaster a where a.strClientCode='"+clientCode+"' ";
				String userCode=request.getSession().getAttribute("usercode").toString();
				clsPMSGuestFeedbackBean objBean=new clsPMSGuestFeedbackBean();
				listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");
				clsPMSFeedbackMasterBean objFeedbackMasterBean = null;
				if(listModel!=null && listModel.size()>0)
				{
					for(int i=0;i<listModel.size();i++)
					{
						Object[] arr = (Object[]) listModel.get(i);
						objFeedbackMasterBean = new clsPMSFeedbackMasterBean();
						
						objFeedbackMasterBean.setStrFeedbackCode(arr[0].toString());
						objFeedbackMasterBean.setStrFeedbackDesc(arr[1].toString());
						
						objFeedbackMasterBean.setStrExcellent("N");
						objFeedbackMasterBean.setStrGood("N");
						objFeedbackMasterBean.setStrFair("N");
						objFeedbackMasterBean.setStrPoor("N");
						
						listReturn.add(objFeedbackMasterBean);
						
					}
				}
			}
			
			
		}
		
		
		return listReturn;
	}

//Save or Update PMSGuestFeedback
	@RequestMapping(value = "/savePMSGuestFeedback", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSGuestFeedbackBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			String strGuestCode = objBean.getStrGuestCode();
			if(strGuestCode!=null && !strGuestCode.equals(""))
			{
				String deleteOldRecord = "delete from  tblguestfeedback  where strGuestCode='"+strGuestCode+"'";
				objWebPMSUtility.funExecuteUpdate(deleteOldRecord,"sql");
			}
				for(clsPMSGuestFeedbackBean objBean1 : objBean.getListBean())
				{
					
					clsPMSGuestFeedbackModel objModel = funPrepareModel(objBean1,userCode,clientCode);
					objPMSGuestFeedbackService.funAddUpdatePMSGuestFeedback(objModel);
						
					req.getSession().setAttribute("success", true);
					req.getSession().setAttribute("successMessage", "Feedback Code : ".concat(objModel.getStrGuestFeedbackCode()));

					
				}
			
			
			
			return new ModelAndView("redirect:/frmPMSGuestFeedback.html");
		}
		else{
			return new ModelAndView("frmPMSGuestFeedback");
		}
	}

//Convert bean to model function
	private clsPMSGuestFeedbackModel funPrepareModel(clsPMSGuestFeedbackBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsPMSGuestFeedbackModel objModel = new clsPMSGuestFeedbackModel();
		
		if (objBean.getStrGuestFeedbackCode().trim().length() == 0 || objBean.getStrGuestFeedbackCode().equals("undefined")) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblguestfeedback", "GuestFeedbackMastter", "strGuestFeedbackCode", clientCode);
			// lastNo=1;
			String feedbackCode = "FF" + String.format("%06d", lastNo);
			objModel.setStrGuestFeedbackCode(feedbackCode);
			objModel.setStrGuestCode(objBean.getStrGuestCode());
			objModel.setStrExcellent(objGlobal.funIfNull(objBean.getStrExcellent(), "N", objBean.getStrExcellent()));
			objModel.setStrGood(objGlobal.funIfNull(objBean.getStrGood(),"N",objBean.getStrGood()));
			objModel.setStrFeedbackCode(objBean.getStrFeedbackCode());
			objModel.setStrFair(objGlobal.funIfNull(objBean.getStrFair(),"N",objBean.getStrFair()));
			objModel.setStrPoor(objGlobal.funIfNull(objBean.getStrPoor(),"N",objBean.getStrPoor()));
			objModel.setStrRemark(objBean.getStrRemark());
			objModel.setStrUserEdited(userCode);
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrClientCode(clientCode);
			
		} else {
			
		objModel.setStrGuestFeedbackCode(objBean.getStrGuestFeedbackCode());
		objModel.setStrGuestCode(objBean.getStrGuestCode());
		objModel.setStrExcellent(objGlobal.funIfNull(objBean.getStrExcellent(), "N", objBean.getStrExcellent()));
		objModel.setStrGood(objGlobal.funIfNull(objBean.getStrGood(),"N",objBean.getStrGood()));
		objModel.setStrFeedbackCode(objBean.getStrFeedbackCode());
		objModel.setStrFair(objGlobal.funIfNull(objBean.getStrFair(),"N",objBean.getStrFair()));
		objModel.setStrPoor(objGlobal.funIfNull(objBean.getStrPoor(),"N",objBean.getStrPoor()));
		objModel.setStrRemark(objBean.getStrRemark());
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrUserCreated(userCode);
		objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		
		}
		return objModel;

	}
	
	@RequestMapping(value = "/printGuestFeedback", method = RequestMethod.GET)
	public void printGuestFeedback(	@RequestParam("guestCode") String guestCode,HttpServletResponse resp, HttpServletRequest req) {
		clsReportBean objReportBean = new clsReportBean();
		objReportBean.setStrSOCode(guestCode);
		objReportBean.setStrDocCode(guestCode);
		objReportBean.setStrDocType("40");
		
		try 
		{
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();

			
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode); // mms
																			// property
																			// setup
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}

			String reportName = servletContext
					.getRealPath("/WEB-INF/reports/webpms/rptGuestFeedbackForm.jrxml");
			String imagePath = servletContext
					.getRealPath("/resources/images/company_Logo.png");

			List<clsPMSFeedbackMasterBean> dataList = new ArrayList<clsPMSFeedbackMasterBean>();
			@SuppressWarnings("rawtypes")
			HashMap reportParams = new HashMap();
			
			
			if(guestCode.equals(""))
			{
				
				
				String sql="select a.strFeedbackCode,a.strFeedbackDesc from tblpmsfeedbackmaster a where a.strClientCode='"+clientCode+"' ";
				clsPMSGuestFeedbackBean objBean=new clsPMSGuestFeedbackBean();
				List listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");
				clsPMSFeedbackMasterBean objFeedbackMasterBean = null;
				if(listModel!=null && listModel.size()>0)
				{
					for(int i=0;i<listModel.size();i++)
					{
						Object[] arr = (Object[]) listModel.get(i);
						objFeedbackMasterBean = new clsPMSFeedbackMasterBean();
						
						objFeedbackMasterBean.setStrFeedbackCode(arr[0].toString());
						objFeedbackMasterBean.setStrFeedbackDesc(arr[1].toString());
						
						objFeedbackMasterBean.setStrExcellent("N");
						objFeedbackMasterBean.setStrGood("N");
						objFeedbackMasterBean.setStrFair("N");
						objFeedbackMasterBean.setStrPoor("N");
						
						dataList.add(objFeedbackMasterBean);
						
					}
				}
			}
			else
			{
				String sql = "select a.strGuestFeedbackCode,a.strGuestCode,a.strFeedbackCode,a.strExcellent,a.strGood,a.strFair,a.strPoor,a.strRemark,b.strFeedbackDesc,Concat(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName) from tblguestfeedback a ,tblpmsfeedbackmaster b,tblguestmaster c  where a.strFeedbackCode=b.strFeedbackCode and  a.strClientCode='"+clientCode+"' AND a.strGuestCode='"+guestCode+"' and a.strGuestCode=c.strGuestCode ";
				List listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");

				if(listModel!=null && listModel.size()>0)
				{
					for(int i=0;i<listModel.size();i++)
					{
						clsPMSFeedbackMasterBean objBean2 = new clsPMSFeedbackMasterBean();
						Object[] arr = (Object[]) listModel.get(i);
						objBean2.setStrGuestFeedbackCode(arr[0].toString());
						objBean2.setStrGuestCode(arr[1].toString());
						objBean2.setStrFeedbackCode(arr[2].toString());
						objBean2.setStrExcellent(arr[3].toString());
						objBean2.setStrGood(arr[4].toString());
						objBean2.setStrFair(arr[5].toString());
						objBean2.setStrPoor(arr[6].toString());
						objBean2.setStrRemark(arr[7].toString());
						objBean2.setStrFeedbackDesc(arr[8].toString());
						objBean2.setStrGuestName(arr[9].toString());
						
						dataList.add(objBean2);
						
					}
				}
				else
				{
					sql="select a.strFeedbackCode,a.strFeedbackDesc from tblpmsfeedbackmaster a where a.strClientCode='"+clientCode+"' ";
					clsPMSGuestFeedbackBean objBean=new clsPMSGuestFeedbackBean();
					listModel=objGlobalFunctionsService.funGetListModuleWise(sql,"sql");
					clsPMSFeedbackMasterBean objFeedbackMasterBean = null;
					if(listModel!=null && listModel.size()>0)
					{
						for(int i=0;i<listModel.size();i++)
						{
							Object[] arr = (Object[]) listModel.get(i);
							objFeedbackMasterBean = new clsPMSFeedbackMasterBean();
							
							objFeedbackMasterBean.setStrFeedbackCode(arr[0].toString());
							objFeedbackMasterBean.setStrFeedbackDesc(arr[1].toString());
							
							objFeedbackMasterBean.setStrExcellent("N");
							objFeedbackMasterBean.setStrGood("N");
							objFeedbackMasterBean.setStrFair("N");
							objFeedbackMasterBean.setStrPoor("N");
							
							dataList.add(objFeedbackMasterBean);
							
						}
					}
				}
				reportParams.put("pAddress1", objSetup.getStrAdd1() + ","+ objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2",objSetup.getStrState() + ","+ objSetup.getStrCountry() + ","+ objSetup.getStrPin());
				reportParams.put("pContactDetails", "");
				reportParams.put("strImagePath", imagePath);
				String strname = "";
				String sqlName = "SELECT CONCAT(IFNULL(a.strFirstName,''),' ' ,IFNULL(a.strMiddleName,''),' ', IFNULL(a.strLastName,'')) "
						+ "FROM tblguestmaster a "
						+ "WHERE a.strGuestCode='"+guestCode+ "'";
				List listname=objGlobalFunctionsService.funGetListModuleWise(sqlName,"sql");
				if(listname!=null && listname.size()>0)
				{
					strname = listname.get(0).toString();
				}
				//reportParams.put("pGuestName", objGuestMasterModel.getStrFirstName()+" "+objGuestMasterModel.getStrMiddleName()+" "+objGuestMasterModel.getStrLastName());

			reportParams.put("pCompanyName","");
			reportParams.put("pGuestName",strname);
			JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(dataList);
			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);
			JasperPrint jp = JasperFillManager.fillReport(jr, reportParams,beanCollectionDataSource);
			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			if (jp != null) {
				jprintlist.add(jp);
				ServletOutputStream servletOutputStream = resp.getOutputStream();
				JRExporter exporter = new JRPdfExporter();
				resp.setContentType("application/pdf");
				exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST,jprintlist);
				exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM,servletOutputStream);
				exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS,Boolean.TRUE);
				resp.setHeader("Content-Disposition","inline;filename=Bill.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}
		} 
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	

}
