package com.sanguine.webclub.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webclub.bean.clsWebClubPDCBean;
import com.sanguine.webclub.model.clsWebClubGroupMasterModel;
import com.sanguine.webclub.model.clsWebClubPDCModel;
import com.sanguine.webclub.service.clsWebClubPDCService;


@Controller
public class clsWebClubPDCController{

	@Autowired
	private clsWebClubPDCService objWebClubPDCService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

//Open WebClubPDC
	@RequestMapping(value = "/frmWebClubPDC", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
				
		return new ModelAndView("frmWebClubPDC","command", new clsWebClubPDCBean());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmWebClubPDC1", method = RequestMethod.POST)
	public @ResponseBody clsWebClubPDCBean funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsWebClubPDCBean objBean=new clsWebClubPDCBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsWebClubPDCBean objWebClubPDC = new clsWebClubPDCBean();
		return objWebClubPDC;
	}

		//Save or Update WebClubPDC
		@RequestMapping(value = "/saveWebClubPDC", method = RequestMethod.POST)
		public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsWebClubPDCBean objBean ,BindingResult result,HttpServletRequest req){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			
			if(objBean.getStrMemCodeRecieved()!=null||objBean.getStrMemCodeIssued()!=null)
			{
			if(objBean.getListPDCDtlRecieved()!=null&&objBean.getStrMemCodeRecieved()!=null){	
				
				String MemCode=objBean.getStrMemCodeRecieved();				
				String sql="SELECT a.strMemCode,a.strChequeNo,a.strDrawnOn,a.strType,a.dblChequeAmt,Date(a.dteChequeDate) FROM tblpdcdtl a WHERE a.strMemCode='"+MemCode+"' and a.strClientCode='"+clientCode+"' and a.strType='Received' ";
				List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if (!list.isEmpty()) {				
					objWebClubPDCService.funDeleteDtlRecieved(MemCode, clientCode);	
				}
				
				objGlobal = new clsGlobalFunctions();			
				for(int i=0;i<objBean.getListPDCDtlRecieved().size();i++)
				{
					clsWebClubPDCModel objModel = new clsWebClubPDCModel();
					clsWebClubPDCBean obj = objBean.getListPDCDtlRecieved().get(i);
					if(obj.getStrMemCode()!=null&obj.getDteChequeDate()!=null)
					{
					objModel.setStrMemCode(obj.getStrMemCode()+" 01");
					objModel.setStrChequeNo(obj.getStrChequeNo());
					objModel.setStrDrawnOn(obj.getStrDrawnOn());
					objModel.setStrType(obj.getStrType());
					objModel.setDblChequeAmt(obj.getDblChequeAmt());
					objModel.setDteChequeDate(objGlobal.funGetDate("yyyy-MM-dd", obj.getDteChequeDate()));
					objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setStrUserCreated(userCode);
					objModel.setStrUserEdited(userCode);
					objModel.setStrClientCode(clientCode);	
					
					objWebClubPDCService.funAddUpdateWebClubPDC(objModel);
					}				
				}				
			}	
			else if(objBean.getListPDCDtlRecieved()==null && objBean.getStrMemCodeRecieved()!=null)
			{
				String MemCode=objBean.getStrMemCodeRecieved();			
				String sql="SELECT a.strMemCode,a.strChequeNo,a.strDrawnOn,a.strType,a.dblChequeAmt,Date(a.dteChequeDate) FROM tblpdcdtl a WHERE a.strMemCode='"+MemCode+"' and a.strClientCode='"+clientCode+"' and a.strType='Received' ";
				List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if (!list.isEmpty()) {					
					objWebClubPDCService.funDeleteDtlRecieved(MemCode, clientCode);	
				}
			}
			if(objBean.getListPDCDtlIssued()!=null&&objBean.getStrMemCodeIssued()!=null){
				String MemCode=objBean.getStrMemCodeIssued();			
				String sql="SELECT a.strMemCode,a.strChequeNo,a.strDrawnOn,a.strType,a.dblChequeAmt,Date(a.dteChequeDate) FROM tblpdcdtl a WHERE a.strMemCode='"+MemCode+"' and a.strClientCode='"+clientCode+"' and a.strType='Issued' ";
				List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if (!list.isEmpty()) {					
					objWebClubPDCService.funDeleteDtlIssued(MemCode, clientCode);	
				}
				
				objGlobal = new clsGlobalFunctions();			
				for(int i=0;i<objBean.getListPDCDtlIssued().size();i++)
				{
					clsWebClubPDCModel objModel = new clsWebClubPDCModel();
					clsWebClubPDCBean obj = objBean.getListPDCDtlIssued().get(i);
					if(obj.getStrMemCode()!=null&obj.getDteChequeDate()!=null)
					{
					objModel.setStrMemCode(obj.getStrMemCode()+" 01");
					objModel.setStrChequeNo(obj.getStrChequeNo());
					objModel.setStrDrawnOn(obj.getStrDrawnOn());
					objModel.setStrType(obj.getStrType());
					objModel.setDblChequeAmt(obj.getDblChequeAmt());
					objModel.setDteChequeDate(objGlobal.funGetDate("yyyy-MM-dd", obj.getDteChequeDate()));
					objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setStrUserCreated(userCode);
					objModel.setStrUserEdited(userCode);
					objModel.setStrClientCode(clientCode);	
					
					objWebClubPDCService.funAddUpdateWebClubPDC(objModel);
					}		
				}			
			}		
			else if(objBean.getListPDCDtlIssued()==null && objBean.getStrMemCodeIssued()!=null)
				{
					String MemCode=objBean.getStrMemCodeIssued();			
					String sql="SELECT a.strMemCode,a.strChequeNo,a.strDrawnOn,a.strType,a.dblChequeAmt,Date(a.dteChequeDate) FROM tblpdcdtl a WHERE a.strMemCode='"+MemCode+"' and a.strClientCode='"+clientCode+"' and a.strType='Issued' ";
					List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					if (!list.isEmpty()) {					
						objWebClubPDCService.funDeleteDtlIssued(MemCode, clientCode);	
					}
				}
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Data Save Successfully");		
			return new ModelAndView("redirect:/frmWebClubPDC.html");
			}
			
			else{
				return new ModelAndView("frmWebClubPDC");
			}		
		}
	
	// Assign filed function to set data onto form for edit transaction.
		@RequestMapping(value = "/loadPDCMemberWiseData", method = RequestMethod.GET)
		public @ResponseBody List<clsWebClubPDCBean> funAssignPDCMemberData(@RequestParam("memCode") String memCode, HttpServletRequest req) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			clsWebClubPDCBean objBean = new clsWebClubPDCBean();
			objGlobal = new clsGlobalFunctions();
			List<clsWebClubPDCBean> listobj = new ArrayList<clsWebClubPDCBean>();
			//List list = objWebClubPDCService.funGetWebClubPDC(memCode, clientCode);
			String dbWebStock=req.getSession().getAttribute("WebStockDB").toString();
			String sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,Date(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+dbWebStock+".tblbankmaster c WHERE a.strMemCode='"+memCode+"' and a.strClientCode='"+clientCode+"' AND a.strClientCode=b.strClientCode AND b.strMemberCode='"+memCode+"' AND a.strDrawnOn=c.strBankName GROUP BY a.strType,a.strDrawnOn";
			List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (list.size() > 0){
				for(int i =0;i<list.size();i++)
				{
					clsWebClubPDCBean objBean1 =  new clsWebClubPDCBean();
					Object obj[] = (Object[]) list.get(i);
					objBean1.setStrMemName(obj[0].toString());
					objBean1.setStrDrawnOn(obj[2].toString());
					objBean1.setStrChequeNo(obj[1].toString());
					objBean1.setDteChequeDate(objGlobal.funGetDate("dd-MM-yyyy", obj[5].toString()));
					objBean1.setDblChequeAmt(Double.parseDouble(obj[4].toString()));
					objBean1.setStrType(obj[3].toString());	
					objBean1.setStrMemCode(obj[6].toString());
					listobj.add(objBean1);
				}
			}			
			else
			{
				objBean.setStrMemCode("Invalid Code");
			}
			return listobj;
		}
		
		// Assign filed function to set data onto form for edit transaction.
				@RequestMapping(value = "/loadWebBookBankCode", method = RequestMethod.GET)
				public @ResponseBody List funAssignBankCode(@RequestParam("bankCode") String bankCode, HttpServletRequest req) {
					String clientCode = req.getSession().getAttribute("clientCode").toString();
					String strWebStockDB=req.getSession().getAttribute("WebStockDB").toString();
					clsWebClubPDCBean objModel = new clsWebClubPDCBean();
					//List list = objWebClubPDCService.funGetWebClubPDC(memCode, clientCode);
					String sql="SELECT a.strBankName FROM "+strWebStockDB+".tblbankmaster a where a.strBankCode='"+bankCode+"' AND a.strClientCode='"+clientCode+"' ";
					List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
										
					return list;
				}
		
	
/*//Convert bean to model function
	private clsWebClubPDCModel funPrepareModel(clsWebClubPDCBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsWebClubPDCModel objModel = null;
		
		for(int i=0;i<objBean.getListPDCDtl().size();i++)
		{
			clsWebClubPDCBean obj = objBean.getListPDCDtl().get(i);
			objModel.setStrMemCode(obj.getStrMemCode());
			objModel.setStrChequeNo(obj.getStrChequeNo());
			objModel.setStrDrawnOn(obj.getStrDrawnOn());
			objModel.setStrType(obj.getStrType());
			objModel.setDblChequeAmt(obj.getDblChequeAmt());
			objModel.setDteChequeDate(obj.getDteChequeDate());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrUserCreated(userCode);
			objModel.setStrUserEdited(userCode);
			objModel.setStrClientCode(clientCode);			
		}		
		return objModel;

	}*/

}
