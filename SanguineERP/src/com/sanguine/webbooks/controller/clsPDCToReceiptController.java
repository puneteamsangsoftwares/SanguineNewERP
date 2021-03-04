package com.sanguine.webbooks.controller;

import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webbooks.bean.clsLetterProcessingBean;
import com.sanguine.webbooks.bean.clsReceiptBean;
import com.sanguine.webbooks.bean.clsReceiptDetailBean;
import com.sanguine.webbooks.model.clsEmployeeMasterModel;
import com.sanguine.webbooks.model.clsReceiptDebtorDtlModel;
import com.sanguine.webbooks.model.clsReceiptDtlModel;
import com.sanguine.webbooks.model.clsReceiptHdModel;
import com.sanguine.webbooks.model.clsReceiptInvDtlModel;
import com.sanguine.webbooks.model.clsSundaryCreditorMasterModel;
import com.sanguine.webbooks.model.clsSundryDebtorMasterModel;
import com.sanguine.webbooks.service.clsReceiptService;
import com.sanguine.webbooks.service.clsSundryCreditorMasterService;
import com.sanguine.webbooks.service.clsSundryDebtorMasterService;
import com.sanguine.webclub.bean.clsWebClubPDCFlashBean;

@Controller
public class clsPDCToReceiptController {
	
	@Autowired
	clsGlobalFunctionsService objGlobalService;
	
	@Autowired
	private clsSetupMasterService objSetupMasterService;
	
	@Autowired
	private clsReceiptService objReceiptService;

	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsSundryDebtorMasterService objSundryDebtorMasterService;
	@Autowired
	private clsSundryCreditorMasterService objSundryCreditorMasterService;
	@Autowired
	clsEmployeeMasterController objEmployeeMasterController;
	
	@Autowired
	private intfBaseService objBaseService;
	
	@RequestMapping(value = "/frmPDCToReceipt", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmPDCToReceipt", "command", new clsReceiptBean());
		} else {
			return new ModelAndView("frmPDCToReceipt", "command", new clsReceiptBean());
		}
	}
	
	@RequestMapping(value = "/savePDCToReceipt", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsReceiptBean objBean, BindingResult result, HttpServletRequest req) throws Exception {
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propCode = req.getSession().getAttribute("propertyCode").toString();
			String startDate = req.getSession().getAttribute("startDate").toString();
			String strVoucherNo = "";
			//String strCFCode=objBean.getStrCFCode();
			//List<clsReceiptBean> listReceiptModel = new ArrayList<clsReceiptBean>();
			
		/*	listReceiptModel.add(objReceiptModel);
			String docNo="";
			for(clsReceiptBean i:objBean.getListReceiptBean()){
				listReceiptModel.add(i);
			}
			objBean.setListReceiptBean(listReceiptModel);*/
			String documentNo = objGlobal.funGenerateDocumentCodeWebBook("frmReceipt", objGlobal.funGetCurrentDate("dd-MM-yyyy"), req);
			Map<String,List<clsReceiptBean>> linkhm = new LinkedHashMap<String, List<clsReceiptBean>>();
			String dtorCode="";
			int count=0;
			List<clsReceiptBean> list;
			/*for(clsReceiptBean i : objBean.getListReceiptBean())
			{
				list = new ArrayList<clsReceiptBean>();					
				linkhm.put(i.getStrDebtorCode(), list);								
			}*/
			list = new ArrayList<clsReceiptBean>();	
			for(clsReceiptBean i : objBean.getListReceiptBean())
			{
				if(i.getStrTransMode()!=null)
				{
					if(linkhm.containsKey(i.getStrDebtorCode()))
					{
						linkhm.get(i.getStrDebtorCode()).add(i);
						linkhm.put(i.getStrDebtorCode(), linkhm.get(i.getStrDebtorCode()));
					}
					else
					{
						list = new ArrayList<clsReceiptBean>();	
						list.add(i);
						linkhm.put(i.getStrDebtorCode(),list);
					}	
				}
			}
			clsReceiptHdModel objHdModell=new clsReceiptHdModel();
			for (Map.Entry<String,List<clsReceiptBean>> entry : linkhm.entrySet()) {
				objBean.setListReceiptBean(entry.getValue());
				clsReceiptHdModel objHdModel = funPrepareHdModel(objBean, userCode, clientCode, propCode, req,objBean.getStrCFCode());
				objHdModell=objHdModel;
				objReceiptService.funAddUpdateReceiptHd(objHdModel);
			}
			
			strVoucherNo = strVoucherNo+objHdModell.getStrVouchNo()+" ";
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Receipt No : ".concat(objHdModell.getStrVouchNo()));
			req.getSession().setAttribute("rptVoucherNo",strVoucherNo );
		
			return new ModelAndView("redirect:/frmPDCToReceipt.html");
		} else {
			return new ModelAndView("frmPDCToReceipt");
		}
	}
	
	public clsReceiptHdModel funPrepareHdModel(clsReceiptBean objBean, String userCode, String clientCode, String propertyCode, HttpServletRequest request,String strCFCode) throws Exception {

		
		clsReceiptHdModel objModel = new clsReceiptHdModel();
//		String strCurr = request.getSession().getAttribute("currValue").toString();
		objBean.setStrCFCode(strCFCode);
		clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
//		double currConversion = 1.0;
//		if (objSetup != null) {
//			clsCurrencyMasterModel objCurrModel = objCurrencyMasterService.funGetCurrencyMaster(objBean.getStrCurrency(), clientCode);
//			if (objCurrModel != null) {
//				currConversion = objCurrModel.getDblConvToBaseCurr();
//
//			}
//
//		}
		double currConversion = 1.0;
		if(objBean.getDblConversion()>0)
		{
			currConversion=objBean.getDblConversion();
		}
		try{
		StringBuilder hql=new StringBuilder("select strAccountCode,strAccountName from clsWebBooksAccountMasterModel where strClientCode='" + clientCode + "' and strDebtor='Yes' ");
		List listAcc=objBaseService.funGetListForWebBooks(hql, "hql");
		//List listAcc=objBaseService.funGetListModuleWise(hql, "hql", "WebBooks");
				if(listAcc!=null && listAcc.size()>0){
					Object[] ob=(Object[]) listAcc.get(0);
					objBean.setStrDebtorAccCode(ob[0].toString());					
				}		
		}catch(Exception e){
			e.printStackTrace();
		}		
		Map<String, clsReceiptDtlModel> hmReceiptDtl = new HashMap<String, clsReceiptDtlModel>();		
		String documentNo = objGlobal.funGenerateDocumentCodeWebBook("frmReceipt", objGlobal.funGetCurrentDate("dd-MM-yyyy"), request);
		//linkhm.put(documentNo, documentNo);
		
		objModel.setStrVouchNo(documentNo);
		objModel.setStrUserCreated(userCode);
		objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrCFCode(objBean.getStrCFCode());
		objModel.setStrType(objGlobal.funIfNull(objBean.getStrType(), "Cheque", objBean.getStrType()));
		//objModel.setStrDebtorCode(objGlobal.funIfNull(objBean.getStrDebtorCode(), "", objBean.getStrDebtorCode()));
		objModel.setStrReceivedFrom(objGlobal.funIfNull(objBean.getStrReceivedFrom(), "", objBean.getStrReceivedFrom()));
		String chequNo="";
		for(clsReceiptBean objTempBean :objBean.getListReceiptBean())
		{
			if(objTempBean.getStrChequeNo()!=null)
			{
				chequNo+=objTempBean.getStrChequeNo();
				objModel.setStrChequeNo(chequNo);	
			}
			chequNo=chequNo+",";
		}
		//objModel.setStrChequeNo(objBean.getStrChequeNo());
		objModel.setStrDrawnOn(objGlobal.funIfNull(objBean.getStrDrawnOn(), "", objBean.getStrDrawnOn()));
		objModel.setStrBranch(objGlobal.funIfNull(objBean.getStrBranch(), "", objBean.getStrBranch()));
		objModel.setStrNarration(objGlobal.funIfNull(objBean.getStrNarration(), "NA", objBean.getStrNarration()));
		objModel.setStrSancCode(objGlobal.funIfNull(objBean.getStrSancCode(), "NA", objBean.getStrSancCode()));
		objModel.setDblAmt(objBean.getDblAmt() * currConversion);
		objModel.setStrCrDr(objBean.getStrCrDr());
		objModel.setDteVouchDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setDteChequeDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setIntVouchMonth(objGlobal.funGetMonth());
		objModel.setIntVouchNum(0);
		objModel.setStrTransMode("R");
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrDebtorCode(objBean.getStrDebtorCode());
		objModel.setStrReceiptType("MR");		
		if (request.getSession().getAttribute("selectedModuleName").toString().equalsIgnoreCase("8-WebBookAPGL")) {
			objModel.setStrModuleType("APGL");

		} else {
			objModel.setStrModuleType("AP");
		}
		objModel.setStrPropertyCode(propertyCode);
		objModel.setStrClientCode(clientCode);
		objModel.setDteClearence(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrReceivedFrom(objGlobal.funIfNull(objBean.getStrReceivedFrom(), "", objBean.getStrReceivedFrom()));
		objModel.setIntOnHold(0);

		
		
		clsReceiptBean objReceiptModel = new clsReceiptBean();					
		objReceiptModel.setStrDebtorAccCode(objBean.getStrCFCode());
		objReceiptModel.setStrBankName(objBean.getStrDebtorName());
		objReceiptModel.setStrCrDr("Dr");
		objReceiptModel.setStrTransMode("");
		objReceiptModel.setDteChequeDate(objGlobal.funGetCurrentDate("dd-MM-yyyy"));		
		objBean.getListReceiptBean().add(objReceiptModel);
		
		clsReceiptDtlModel objReceiptDtlModel ;
		int count=0;
		double dblCreAmt=0.0;
		for(clsReceiptBean i : objBean.getListReceiptBean())
		{
			if(i.getStrTransMode()!=null)
			{	
				objReceiptDtlModel = new clsReceiptDtlModel();
				objReceiptDtlModel.setStrAccountCode("");				
				objReceiptDtlModel.setStrAccountCode(objBean.getStrDebtorAccCode());	
				objReceiptDtlModel.setStrAccountName(i.getStrDebtorName());
				if(i.getStrBankName()!=null){
					objReceiptDtlModel.setStrAccountName(i.getStrBankName());
					objReceiptDtlModel.setStrAccountCode(i.getStrDebtorAccCode());
				}	
				else
				{
					if(!i.getStrDebtorName().equals("") )
					{
						StringBuilder sqlDebtorName = new StringBuilder();
						sqlDebtorName.append("select a.strAccountName from tblacmaster  a "
								+ "where a.strAccountCode='"+objBean.getStrDebtorAccCode()+"' and a.strClientCode='"+clientCode+"'");
						List listAcc=objBaseService.funGetListForWebBooks(sqlDebtorName, "sql");
						if(listAcc!=null && listAcc.size()>0){
							objReceiptDtlModel.setStrAccountName(listAcc.get(0).toString());
						}

					}
				}
				objReceiptDtlModel.setStrCrDr(objGlobal.funIfNull(i.getStrCrDr(), "Cr", i.getStrCrDr()));
				objReceiptDtlModel.setStrNarration("");
				objReceiptDtlModel.setDblCrAmt(i.getDblAmt() * currConversion);			
				if(objReceiptDtlModel.getStrCrDr().equalsIgnoreCase("Cr"))
				{
					objReceiptDtlModel.setDblCrAmt(0.0);						
				}				
				objReceiptDtlModel.setDblCrAmt(i.getDblAmt() * currConversion);
				objReceiptDtlModel.setStrPropertyCode(propertyCode);
				dblCreAmt=dblCreAmt+objReceiptDtlModel.getDblCrAmt();
				if(i.getStrCrDr()!=null)
				{
					if(i.getStrCrDr().equalsIgnoreCase("Dr"))
					{
						objReceiptDtlModel.setDblDrAmt(dblCreAmt);
					}
				}				
				hmReceiptDtl.put(String.valueOf(count), objReceiptDtlModel);
				count++;
			}
		}
		
	
		List<clsReceiptDtlModel> listReceiptDtlModel = new ArrayList<clsReceiptDtlModel>();
		for (Map.Entry<String, clsReceiptDtlModel> entry : hmReceiptDtl.entrySet()) {
			listReceiptDtlModel.add(entry.getValue());
		}
		objModel.setListReceiptDtlModel(listReceiptDtlModel);
		String debtorCode = "";
		String debtorName = "";
		List<clsReceiptDebtorDtlModel> listReceiptDebtorDtlModel = new ArrayList<clsReceiptDebtorDtlModel>();
		int countt=0;
		double dblAmt=0.0;
		clsReceiptBean i;
		for(int j=0;j<objBean.getListReceiptBean().size();j++)
		{
			i=new clsReceiptBean();
			i=objBean.getListReceiptBean().get(j);
			if(i.getStrTransMode()!=null)
			{
				clsReceiptDetailBean objReceiptDetails=new clsReceiptDetailBean();
				clsReceiptDebtorDtlModel objReceiptDebtorDtlModel = new clsReceiptDebtorDtlModel();
					
				debtorCode = "";
				clsSundryDebtorMasterModel objSunDrModel = objSundryDebtorMasterService.funGetSundryDebtorMaster(debtorCode, clientCode);
				if (objSunDrModel != null) {
					objReceiptDebtorDtlModel.setStrDebtorName(i.getStrDebtorName());
					debtorName = i.getStrDebtorName();
				} else {
					objReceiptDebtorDtlModel.setStrDebtorName("");
				}
				clsSundryDebtorMasterModel objSunDebtor = objSundryDebtorMasterService.funGetSundryDebtorMaster(objReceiptDetails.getStrDebtorCode(), clientCode);
				if(i.getStrBankName()==null){
					debtorCode = "";
					debtorName = "";
					objReceiptDebtorDtlModel.setStrDebtorName(i.getStrDebtorName());				
					objReceiptDebtorDtlModel.setStrDebtorCode(i.getStrDebtorCode());
					objReceiptDebtorDtlModel.setStrAccountCode(objBean.getStrDebtorAccCode());
					objReceiptDebtorDtlModel.setStrNarration("");
					objReceiptDebtorDtlModel.setStrPropertyCode(propertyCode);
					objReceiptDebtorDtlModel.setStrCrDr("Cr");
					objReceiptDebtorDtlModel.setDblAmt(i.getDblAmt() * currConversion);	
					objReceiptDebtorDtlModel.setStrBillNo("");
					objReceiptDebtorDtlModel.setStrInvoiceNo("");
					objReceiptDebtorDtlModel.setStrGuest("");
					objReceiptDebtorDtlModel.setStrCreditNo("");
					objReceiptDebtorDtlModel.setDteBillDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objReceiptDebtorDtlModel.setDteInvoiceDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objReceiptDebtorDtlModel.setDteDueDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					dblAmt=dblAmt+i.getDblAmt() * currConversion;
					
					if(i.getStrDebtorCode().startsWith("D"))
					{
						objReceiptDebtorDtlModel.setDblAmt(dblAmt);	
						objReceiptDebtorDtlModel.setStrAccountCode("");							
						
						if(!listReceiptDebtorDtlModel.isEmpty())
						{
							if(listReceiptDebtorDtlModel.get(j-1).getStrDebtorCode().equalsIgnoreCase(i.getStrDebtorCode()))
							{
								listReceiptDebtorDtlModel.set(j-1,objReceiptDebtorDtlModel);
							}
						}
						else
						{
							listReceiptDebtorDtlModel.add(objReceiptDebtorDtlModel);
						}
						
							
					}
					
					/*if(j>=objBean.getListReceiptBean().size()-2)
					{
						objReceiptDebtorDtlModel.setDblAmt(dblAmt);							
						listReceiptDebtorDtlModel.add(objReceiptDebtorDtlModel);						
					}*/
					countt++;
				}		
			}
		}
		
		//objModel.setStrDebtorCode(debtorCode);
		objModel.setStrDebtorName(debtorName);
		objModel.setListReceiptDebtorDtlModel(listReceiptDebtorDtlModel);

		List<clsReceiptInvDtlModel> listReceiptInvDtl = new ArrayList<clsReceiptInvDtlModel>();
		clsReceiptInvDtlModel objReceitInvdtl = new clsReceiptInvDtlModel();
		objReceitInvdtl.setDblInvAmt(1 * currConversion);
		objReceitInvdtl.setDblPayedAmt(1* currConversion);
		objReceitInvdtl.setStrPropertyCode(propertyCode);
		objReceitInvdtl.setDteBillDate(objGlobal.funGetCurrentDate("yyyy-MM-dd"));
		objReceitInvdtl.setDteInvDate(objGlobal.funGetCurrentDate("yyyy-MM-dd"));
		objReceitInvdtl.setStrInvBIllNo("");
		objReceitInvdtl.setDteInvDueDate("");
		objReceitInvdtl.setStrInvCode("");
		if(objBean.getStrBankName()==null){
			listReceiptInvDtl.add(objReceitInvdtl);
		}		
		objModel.setListReceiptInvDtlModel(listReceiptInvDtl);
		objModel.setStrCurrency("Rupee");
		objModel.setDblConversion(currConversion);	
		return objModel;
	}

}
