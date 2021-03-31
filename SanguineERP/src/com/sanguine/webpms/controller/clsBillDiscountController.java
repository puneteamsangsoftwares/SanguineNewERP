package com.sanguine.webpms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsBillDiscountBean;
import com.sanguine.webpms.bean.clsTaxCalculation;
import com.sanguine.webpms.bean.clsVoidBillBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsBillDiscountHdModel;
import com.sanguine.webpms.model.clsBillHdModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsVoidBillDtlModel;
import com.sanguine.webpms.model.clsVoidBillHdModel;
import com.sanguine.webpms.model.clsVoidBillTaxDtlModel;
import com.sanguine.webpms.model.clsWalkinRoomRateDtlModel;
import com.sanguine.webpms.service.clsBillDiscountService;
import com.sanguine.webpms.service.clsBillService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsRoomMasterService;
import com.sanguine.webpms.service.clsVoidBillService;

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

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.validation.BindingResult;

import javax.validation.Valid;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class clsBillDiscountController {

	@Autowired
	private clsBillDiscountService objBillDiscountService;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Autowired
	private clsGlobalFunctions objGlobal = null;

	@Autowired
	private clsBillService objBillService;
	
	
	@Autowired
	clsFolioService objFolioService;

	@Autowired
	private clsRoomMasterService objRoomService;

	@Autowired 
	private clsVoidBillService objVoidBillService;
	
	@Autowired
	private ServletContext servletContext;
	@Autowired
	private clsSetupMasterService objSetupMasterService;
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunService;
	Map<String,String> hmReason=new HashMap<>();
	// Open BillDiscount
	@RequestMapping(value = "/frmBillDiscount", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String sql="select strReasonCode,strReasonDesc from tblreasonmaster where strClientCode='"+clientCode+"'";
		List listReason = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		
		if(null!=listReason){
			if(listReason.size()>0){
				for(int i=0;i<listReason.size();i++){
					Object ob[]=(Object[]) listReason.get(i);	
					hmReason.put(ob[0].toString(), ob[1].toString());
				}
			}
		}
		model.put("listReason", hmReason);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmBillDiscount_1", "command", new clsBillDiscountBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmBillDiscount", "command", new clsBillDiscountBean());
		} else {
			return null;
		}
	}

	// Save or Update BillDiscount
	@RequestMapping(value = "/saveBillDiscount", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsBillDiscountBean objBean, BindingResult result, HttpServletRequest req) {

		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		if (!result.hasErrors()) {
			if(objBean.getStrDiscountMode().equalsIgnoreCase("Folio"))
			{
				
				  ModelAndView model=	funCalculateDiscountFolioWise(objBean,result,req);
				  return model;
	
			}
			else
			{
				String clientCode = req.getSession().getAttribute("clientCode").toString();
				String userCode = req.getSession().getAttribute("usercode").toString();
				String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
				clsBillHdModel objBillModel=objVoidBillService.funGetBillData(objBean.getStrRoomNo(), objBean.getStrBillNo(), clientCode);
				clsBillDiscountHdModel objModel = funPrepareModel(objBean, userCode, clientCode);
				String strBillNo="";
				double dblSumTariffAmt=0;
				double dblDiscAmt=0;
				double dblGrandTotal = 0;
				double dblRoomTariff = 0;
				double dblTaxAmt=0;
				double dblDiscPerDay = 0;
				//Save in void bill
				if(objBean.getStrDiscOn().equalsIgnoreCase("Room Tariff"))
				{
					String sqlRoomTariffAmt = "select a.dblDebitAmt from tblbilldtl a where a.strPerticulars='Room Tariff' and a.strBillNo='"+objBean.getStrBillNo()+"' AND a.strClientCode='"+clientCode+"';";
					List listRoomTariffAmt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTariffAmt, "sql");
					if(listRoomTariffAmt!=null && listRoomTariffAmt.size()>0)
					{
						for(int i=0;i<listRoomTariffAmt.size();i++)
						{
							dblSumTariffAmt = dblSumTariffAmt + Double.parseDouble(listRoomTariffAmt.get(i).toString());
							dblRoomTariff = Double.parseDouble(listRoomTariffAmt.get(i).toString());
						}
					}
					dblGrandTotal = objBillModel.getDblGrandTotal();
				    
					if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
					{
						dblDiscAmt =objBean.getDblDiscAmt();
						dblGrandTotal=dblGrandTotal - dblDiscAmt;
					}
					else//per
					{
						dblDiscAmt = (dblSumTariffAmt*objBean.getDblDiscPer())/100;
						dblGrandTotal=dblGrandTotal - dblDiscAmt;
					}
				
					objModel.setDblDiscAmt(dblDiscAmt);
					objModel.setDblGrandTotal(dblGrandTotal);
					if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
					{
						
						double discPer = (objBean.getDblDiscAmt() / dblRoomTariff) * 100;
						dblDiscPerDay = dblSumTariffAmt * (discPer / 100);
						
					}
					else//per
					{
						dblDiscPerDay = (dblRoomTariff*objBean.getDblDiscPer())/100;
					}
				
					//Logic for recalculating tax
					
					dblRoomTariff = dblRoomTariff-dblDiscPerDay;
					
					
					Date dt = new Date();
					String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();

					String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
							+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
							+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
							+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' AND strClientCode='"+clientCode+"'";
					
					List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
					double finalTax = 0.0;
					
					String strTaxOn="";
					for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
						String taxCalType = "Forward";
						if(clientCode.equalsIgnoreCase("383.001"))
						{
							 taxCalType = "Backward";
						}
						Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
						double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
						double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
						double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
						String strTaxDesc = arrObjTaxDtl[1].toString();
						
						if(fromRate<=(dblRoomTariff)&& (dblRoomTariff)<=toRate)
						{
							double taxAmt = 0;
							if (taxCalType.equals("Forward")) // Forward Tax
																// Calculation
							{
								taxAmt = (dblRoomTariff * taxValue) / 100;
								dblTaxAmt = taxAmt;
							} 
							else // Backward Tax Calculation
							{
								taxAmt = dblRoomTariff * 100 / (100 + taxValue);
								taxAmt = dblRoomTariff - taxAmt;
							}
							finalTax = finalTax+taxAmt;
							
						}
						else
						{
							
						}
					}
					String sqlTaxDesc = "select a.strTaxDesc from tblbilltaxdtl a where a.strBillNo='"+objBean.getStrBillNo()+"' and a.strClientCode='"+clientCode+"'";
					List listTaxDesc = objGlobalFunService.funGetListModuleWise(sqlTaxDesc, "sql");
					for (int cnt = 0; cnt < listTaxDesc.size(); cnt++) {
						String strTaxDesc = listTaxDesc.get(cnt).toString();
						if(strTaxDesc.contains("Room Rent"))
						{
							String sqlUpdate = "update tblbilltaxdtl a set a.dblTaxAmt='"+dblTaxAmt+"' where a.strBillNo='"+objBean.getStrBillNo()+"' and a.strClientCode='"+clientCode+"' ";
							objWebPMSUtility.funExecuteUpdate(sqlUpdate, "sql");
						}
					}
					
					
				}
				else if (objBean.getStrDiscOn().equalsIgnoreCase("Income Head"))
				{
					dblGrandTotal = objBillModel.getDblGrandTotal();
					String sqlBillDtl = "select * from tblbilldtl a where a.strBillNo='"+objBean.getStrBillNo()+"' and a.strClientCode='"+clientCode+"'";
					List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlBillDtl, "sql");
					for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
						Object[] arrObjBillDtl = (Object[]) listTaxDtl.get(cnt);
						
						if(arrObjBillDtl[3].toString().contains("IN"))
						{
							
							double dblIncomeHeadAmt = Double.parseDouble(arrObjBillDtl[7].toString());
							dblDiscAmt = (dblIncomeHeadAmt*objBean.getDblDiscPer())/100;
							dblIncomeHeadAmt=dblIncomeHeadAmt-dblDiscAmt;
							objModel.setDblDiscAmt(dblDiscAmt);
							
							//Tax recalculation Logic
							String strPericulars = arrObjBillDtl[4].toString();
							
							String sqlTaxOnIncomeHead = "select a.strTaxDesc, a.dblTaxValue from tbltaxmaster a where a.strTaxOnType='Department' and a.strClientCode='"+clientCode+"'";
							List listTaxOnIncomeHead = objGlobalFunService.funGetListModuleWise(sqlTaxOnIncomeHead, "sql");
							for(int cnt2=0;cnt2<listTaxOnIncomeHead.size();cnt2++)
							{
								Object[] arrObjTaxOnIncomeHead = (Object[]) listTaxOnIncomeHead.get(cnt2);
								String strTaxDescOnIncomeHead = arrObjTaxOnIncomeHead[0].toString();
								if(strTaxDescOnIncomeHead.contains(strPericulars))
								{
									double dblTaxOnIncomeHeadAmt = 0;
									dblTaxOnIncomeHeadAmt=Double.parseDouble(arrObjTaxOnIncomeHead[1].toString());
									double dblNewTaxAmt=(dblTaxOnIncomeHeadAmt*dblIncomeHeadAmt)/100;
									String sqlUpdateTaxInBillTaxDtl = "update tblbilltaxdtl  a set a.dblTaxAmt='"+dblNewTaxAmt+"' where a.strBillNo='"+objBean.getStrBillNo()+"' and a.strDocNo like 'IN%' and a.strClientCode='"+clientCode+"'";
									objWebPMSUtility.funExecuteUpdate(sqlUpdateTaxInBillTaxDtl, "sql");
								}
							}
						}
					
					}
					
				}
				else
				{
				
				if(objBillModel!=null){
					strBillNo=objBillModel.getStrBillNo();
					clsVoidBillHdModel objVoidHdModel=new clsVoidBillHdModel();
					objVoidHdModel.setStrBillNo(objBillModel.getStrBillNo());
					objVoidHdModel.setDteBillDate(PMSDate);
					objVoidHdModel.setStrClientCode(clientCode);
					objVoidHdModel.setStrCheckInNo(objBillModel.getStrCheckInNo());
					objVoidHdModel.setStrFolioNo(objBillModel.getStrFolioNo());
					objVoidHdModel.setStrRoomNo(objBillModel.getStrRoomNo());
					objVoidHdModel.setStrExtraBedCode(objBillModel.getStrExtraBedCode());
					objVoidHdModel.setStrRegistrationNo(objBillModel.getStrRegistrationNo());
					objVoidHdModel.setStrReservationNo(objBillModel.getStrReservationNo());
					objVoidHdModel.setDblGrandTotal(objBillModel.getDblGrandTotal());
					objVoidHdModel.setStrUserCreated(objBillModel.getStrUserCreated());
					objVoidHdModel.setStrUserEdited(userCode);
					objVoidHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objVoidHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objVoidHdModel.setStrVoidType("modifyBill");
					objVoidHdModel.setStrReasonCode(objBean.getStrReason());
					objVoidHdModel.setStrReasonName(hmReason.get(objBean.getStrReason()));
					objVoidHdModel.setStrRemark(objBean.getStrRemark());
					List<clsVoidBillDtlModel> listVoidBillDtlModels=new ArrayList();
					
					String sql = " Select *  from tblbilldtl a where a.strBillNo='" + strBillNo + "' and a.strClientCode='" + clientCode + "' ";
					List listBillDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					
					for (int j = 0; j < listBillDtl.size(); j++) {
						Object[] objMdl = (Object[]) listBillDtl.get(j);
						clsVoidBillDtlModel voidbillDtlModel = new clsVoidBillDtlModel();
						
							voidbillDtlModel.setStrFolioNo(objMdl[1].toString());
							voidbillDtlModel.setDteDocDate(objMdl[2].toString());
							voidbillDtlModel.setStrDocNo(objMdl[3].toString());
							voidbillDtlModel.setStrPerticulars(objMdl[4].toString());
							voidbillDtlModel.setStrRevenueType(objMdl[5].toString());
							voidbillDtlModel.setStrRevenueCode(objMdl[6].toString());
							voidbillDtlModel.setDblDebitAmt(Double.parseDouble(objMdl[7].toString()));
							voidbillDtlModel.setDblCreditAmt(Double.parseDouble(objMdl[8].toString()));
							voidbillDtlModel.setDblBalanceAmt(Double.parseDouble(objMdl[9].toString()));
							listVoidBillDtlModels.add(voidbillDtlModel);
						
					}
					objVoidHdModel.setListVoidBillDtlModels(listVoidBillDtlModels);
					
					List<clsVoidBillTaxDtlModel> listVoidBillTaxDtlModels=new ArrayList();
					sql = " Select *  from tblbilltaxdtl a where a.strBillNo='" + strBillNo + "' and a.strClientCode='" + clientCode + "' ";
					List listBillTaxDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

					if(listBillTaxDtl.size()>0){
						for (int j = 0; j < listBillTaxDtl.size(); j++) {
							Object[] objMdl = (Object[]) listBillTaxDtl.get(j);
							clsVoidBillTaxDtlModel obVoidTaxDtl=new clsVoidBillTaxDtlModel();
							
							obVoidTaxDtl.setStrDocNo(objMdl[1].toString());
							obVoidTaxDtl.setStrTaxCode(objMdl[2].toString());
							obVoidTaxDtl.setStrTaxDesc(objMdl[3].toString());
							obVoidTaxDtl.setDblTaxableAmt(Double.parseDouble(objMdl[4].toString()));
							obVoidTaxDtl.setDblTaxAmt(Double.parseDouble(objMdl[5].toString()));
							
							listVoidBillTaxDtlModels.add(obVoidTaxDtl);
						}
					}
					
					objVoidHdModel.setListVoidBillTaxDtlModels(listVoidBillTaxDtlModels);
					
					
					
					//Update BillHd
					
					objBillModel.setDblGrandTotal(objBean.getDblGrandTotal());
					objBillModel.setStrUserEdited(userCode);
					objBillModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					
					objVoidBillService.funUpdateVoidBillItemData(objBillModel,objVoidHdModel);
					
				}
			}
				
				
				
				//Save in to bill discount
				
				if (objModel != null) {
					objBillDiscountService.funAddUpdateBillDiscount(objModel);
				}
				req.getSession().setAttribute("success", true);
				req.getSession().setAttribute("successMessage", "Bill Modify Succesfully");
				return new ModelAndView("redirect:/frmBillDiscount.html?saddr=" + urlHits);
			}

		} else {
			return new ModelAndView("redirect:/frmBillDiscount.html?saddr=" + urlHits);
		}
		
	}

	// Convert bean to model function
	private clsBillDiscountHdModel funPrepareModel(clsBillDiscountBean objBean, String userCode, String clientCode) {
		objGlobal = new clsGlobalFunctions();
		long lastNo = 0;
		clsBillDiscountHdModel objModel = null;

		boolean flgDelete =true;// objBillDiscountService.funDeleteBillDiscount(objBean.getStrBillNo(), clientCode);

		if (flgDelete) {
			objModel = new clsBillDiscountHdModel();
			objModel.setStrBillNo(objBean.getStrBillNo());
			objModel.setStrCheckInNo(objBean.getStrCheckInNo());
			objModel.setStrFolioNo(objBean.getStrFolioNo());
			objModel.setStrRoomNo(objBean.getStrRoomNo());
			objModel.setStrUserCreated(userCode);
			objModel.setStrUserEdited(userCode);
			objModel.setStrClientCode(clientCode);
			if(objBean.getStrDiscountType().equalsIgnoreCase("Amount")){
				objModel.setDblDiscAmt(objBean.getDblDiscAmt());
			}else{
				objModel.setDblDiscAmt(objBean.getDblTotal()*(objBean.getDblDiscPer()/100));
			}
			
			objModel.setDblGrandTotal(objBean.getDblGrandTotal());
			objModel.setDteBillDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteBillDate()));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrReasonCode(objGlobal.funIfNull(objBean.getStrReason(), "", objBean.getStrReason())  );
			objModel.setStrReasonName(objGlobal.funIfNull(objBean.getStrReasonName(), "", objBean.getStrReasonName()));
			objModel.setStrRemark(objGlobal.funIfNull(objBean.getStrRemark(), "", objBean.getStrRemark()));
		}

		return objModel;

	}

	// Load Master Data On Form
	@RequestMapping(value = "/getBillData", method = RequestMethod.POST)
	public @ResponseBody clsBillDiscountBean funLoadBillData(HttpServletRequest request) {
		objGlobal = new clsGlobalFunctions();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		clsBillDiscountBean objBean = null;
		String docCode = request.getParameter("docCode").toString();
		clsBillHdModel objBillhd = objBillService.funLoadBill(docCode, clientCode);
		if (objBillhd != null) {
			objBean = new clsBillDiscountBean();
			objBean.setStrBillNo(objBillhd.getStrBillNo());
			objBean.setStrCheckInNo(objBillhd.getStrCheckInNo());
			objBean.setStrFolioNo(objBillhd.getStrFolioNo());
			if (objBillhd.getStrRoomNo() != "") {
				clsRoomMasterModel roomModel = objRoomService.funGetRoomMaster(objBillhd.getStrRoomNo(), clientCode);
				objBean.setStrRoomNo(objBillhd.getStrRoomNo());
			} else {
				objBean.setStrRoomNo("");
			}

			objBean.setDteBillDate(objGlobal.funGetDate("dd-MM-yyyy", objBillhd.getDteBillDate()));
			objBean.setDblDiscAmt(0.00);
			objBean.setDblGrandTotal(objBillhd.getDblGrandTotal());
		} else {
			objBean = new clsBillDiscountBean();
			objBean.setStrBillNo("Invalid Bill No");
		}
		return objBean;
	}


	@RequestMapping(value = "/frmModifyBillReport", method = RequestMethod.GET)
	public ModelAndView funOpenReportForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmModifyBillReport_1", "command", new clsVoidBillBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmModifyBillReport", "command", new clsVoidBillBean());
		} else {
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rptModifyBill", method = RequestMethod.GET)
	public void funGenerateVoidBillReport(@RequestParam("fromDate") String fromDate, @RequestParam("toDate") String toDate, HttpServletRequest req, HttpServletResponse resp) {
		try {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String companyName = req.getSession().getAttribute("companyName").toString();
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptModifyBillReport.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");

			
			HashMap reportParams = new HashMap();

			reportParams.put("pCompanyName", companyName);
			reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
			reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
			reportParams.put("pContactDetails", "");
			reportParams.put("strImagePath", imagePath);
			reportParams.put("strUserCode", userCode);
			reportParams.put("pFromDate", fromDate);
			reportParams.put("pTtoDate", toDate);

			String sqlPax = " select a.strBillNo,DATE_FORMAT(a.dteBillDate,'%d-%m-%Y'),a.dblGrandTotal as subtotal,b.dblDiscAmt ,c.dblGrandTotal,a.strReasonName,a.strRemark,"
					+ " a.strUserCreated,a.strUserEdited,c.strCheckInNo,d.strRoomDesc,CONCAT(f.strGuestPrefix,\" \",f.strFirstName,\" \",f.strLastName) As gName "
							+ " FROM tblvoidbillhd a,tblbilldiscount b,tblbillhd c,tblroom d, "
							+ " tblcheckindtl e ,tblguestmaster f "
							+ " where a.strBillNo=b.strBillNo and c.strBillNo=b.strBillNo "
							+ " and c.strRoomNo=d.strRoomCode and c.strCheckInNo=e.strCheckInNo and e.strPayee='Y' and e.strGuestCode=f.strGuestCode and "
							+ " a.strVoidType='modifyBill'"
							+ " and Date(a.dteBillDate) between '"+fromDate+"' and '"+toDate+"'"
							+ " order by a.dteBillDate; " ; 

			List listOfPax = objGlobalFunctionsService.funGetDataList(sqlPax, "sql");
			ArrayList<clsVoidBillBean> fieldList = new ArrayList<clsVoidBillBean>();

			for (int i = 0; i < listOfPax.size(); i++) {
				Object[] arr = (Object[]) listOfPax.get(i);
				clsVoidBillBean objVoidBean = new clsVoidBillBean();
				objVoidBean.setStrBillNo(arr[0].toString());
				objVoidBean.setStrBilldate(arr[1].toString().split(" ")[0]);
				objVoidBean.setDblSubTotal(Double.parseDouble(arr[2].toString()));
				objVoidBean.setDblDiscountAmt(Double.parseDouble(arr[3].toString()));
				objVoidBean.setDblTotalAmt(Double.parseDouble(arr[4].toString()));
				objVoidBean.setStrReason(arr[5].toString());
				objVoidBean.setStrRemark(arr[6].toString());
				
				objVoidBean.setStrUserCreated(arr[7].toString());
				objVoidBean.setStrVoidedUser(arr[8].toString());
				objVoidBean.setStrRoomName(arr[10].toString());
				objVoidBean.setStrGuestName(arr[11].toString());
				fieldList.add(objVoidBean);

			}
			
			JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(fieldList);
			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);
			JasperPrint jp = JasperFillManager.fillReport(jr, reportParams, beanCollectionDataSource);
			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			if (jp != null) {
				jprintlist.add(jp);
				ServletOutputStream servletOutputStream = resp.getOutputStream();
				JRExporter exporter = new JRPdfExporter();
				resp.setContentType("application/pdf");
				exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
				exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
				exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
				resp.setHeader("Content-Disposition", "inline;filename=PaxReport.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	@RequestMapping(value = "/loadFolioDataForFolioDisc", method = RequestMethod.GET)
	public @ResponseBody clsFolioHdModel funLoadFolioDataForFolioDisc(@RequestParam("folioNo") String folioNo, HttpServletRequest req) {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		clsFolioHdModel objFolioHdModel = objFolioService.funGetFolioList(folioNo, clientCode, propertyCode);
		if (objFolioHdModel == null) {
			objFolioHdModel = new clsFolioHdModel();
			objFolioHdModel.setStrFolioNo("Invalid Code");
		}
		return objFolioHdModel;
	}
	
	private ModelAndView funCalculateDiscountFolioWise(clsBillDiscountBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}		
		
		if(objBean.getStrDiscOn().equalsIgnoreCase("Room Tariff"))
		{
			funCalculateDiscountRoomWise(objBean,result,req,"Room Tariff");
		}
		else if (objBean.getStrDiscOn().equalsIgnoreCase("Income Head"))
		{
			funCalculateDiscountIncomeheadwise(objBean,result,req,"Income Head");
		}
		else if (objBean.getStrDiscOn().equalsIgnoreCase("All"))
		{
			funCalculateDiscountRoomWise(objBean,result,req,"All");
			funCalculateDiscountIncomeheadwise(objBean,result,req,"All");
		}			
		req.getSession().setAttribute("success", true);
		req.getSession().setAttribute("successMessage", "Bill Modify Succesfully");
		
		return new ModelAndView("redirect:/frmBillDiscount.html?saddr=" + urlHits);
	}
	@RequestMapping(value = "/loadFolioDataRevenueWise", method = RequestMethod.GET)
	public @ResponseBody List funLoadFolioDataRevenueWise(@RequestParam("discOn") String strDiscOn,@RequestParam("folioNo") String strFolioNo, HttpServletRequest req) {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		
		String sql="select IFNULL(sum(a.dblDebitAmt),0) from tblfoliodtl a"
				+ " where a.strFolioNo='"+strFolioNo+"' "			
				+ " and a.strPerticulars not like '%POS%' ";
		if(!strDiscOn.equals("All"))
		{
			if(strDiscOn.equals("Room Tariff"))
			{
				sql +=" and a.strPerticulars='"+strDiscOn+"' ";
			}
			else if(strDiscOn.equals("Income Head"))
			{
				sql +=" and a.strRevenueType='"+strDiscOn+"' ";
			}
			
		}
	
		List listFolioDataRevenueWise = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(listFolioDataRevenueWise!=null && listFolioDataRevenueWise.size()>0)
		{
			return listFolioDataRevenueWise;
		}
		else
		{
			 listFolioDataRevenueWise.set(0, 0);			 
			 return listFolioDataRevenueWise;
		}
		
						
	}
	
	private void funCalculateDiscountRoomWise(clsBillDiscountBean objBean, BindingResult result, HttpServletRequest req,String strDiscType)
	{

		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());				
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		clsFolioHdModel objFolioHdModel = objFolioService.funGetFolioList(objBean.getStrFolioNo(), clientCode, propertyCode);
		clsBillDiscountHdModel objModel = funPrepareModel(objBean, userCode, clientCode);

		
	
		double dblSumTariffAmt=0;
		
		double dblRoomTariff = 0;
	
		Map<String,Double> mapDisc= new HashMap<>();
		double dblDiscPerDay = 0;
		double dblTaxAmt=0;
		String sqlRoomTariffAmt = "select (a.dblDebitAmt),a.strRevenueCode,Date(a.dteDocDate),a.strDocNo from tblfoliodtl a "
				+ " where a.strPerticulars='Room Tariff' "
				+ " and a.strFolioNo='"+objBean.getStrBillNo()+"' "
				+ " AND a.strClientCode='"+clientCode+"'";
				
		List listRoomTariffAmt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTariffAmt, "sql");
		if(listRoomTariffAmt!=null && listRoomTariffAmt.size()>0)
		{
			for(int i=0;i<listRoomTariffAmt.size();i++)
			{
				Object[] obj=(Object[])listRoomTariffAmt.get(i);
				dblSumTariffAmt = dblSumTariffAmt + Double.parseDouble(obj[0].toString());
				dblRoomTariff = Double.parseDouble(obj[0].toString());
				mapDisc.put(obj[1].toString()+"#"+obj[2].toString()+"#"+obj[3].toString(),dblRoomTariff);					
			}
		}

		for(Map.Entry<String,Double> entry:mapDisc.entrySet())
		{
			
			if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
			{					
				double discPer = (objBean.getDblDiscAmt() / entry.getValue()) * 100;
				dblDiscPerDay = entry.getValue() * (discPer / 100);
			}
			else//per
			{
				dblDiscPerDay = (entry.getValue()*objBean.getDblDiscPer())/100;
			}		
			objModel.setDblDiscAmt(dblDiscPerDay);
			objModel.setDblGrandTotal(entry.getValue());
			objModel.setStrRoomNo(entry.getKey().split("#")[2]);//Reffered for doc No
			objModel.setDteBillDate(entry.getKey().split("#")[1]);
			objModel.setStrDiscType(strDiscType);
			
			if (objModel != null) {
				objBillDiscountService.funAddUpdateBillDiscount(objModel);
			}
		}
		
		

		
		Date dt = new Date();
		String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();

		String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
				+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
				+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
				+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' AND strClientCode='"+clientCode+"'";
		
		List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
		
		
		
		
		sqlRoomTariffAmt = "select a.dblDebitAmt,a.strRevenueCode,date(a.dteDocDate),a.strDocNo from tblfoliodtl a "
				+ " where a.strPerticulars='Room Tariff' "
				+ " and a.strFolioNo='"+objBean.getStrBillNo()+"' "
				+ " AND a.strClientCode='"+clientCode+"' ;";
				
		List listRoomTariffAmtDatewise = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTariffAmt, "sql");
		if(listRoomTariffAmtDatewise!=null && listRoomTariffAmtDatewise.size()>0)
		{
			for(int i=0;i<listRoomTariffAmtDatewise.size();i++)
			{
				Object[] obj=(Object[])listRoomTariffAmtDatewise.get(i);
				if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
				{					
					double discPer = (objBean.getDblDiscAmt() / Double.parseDouble(obj[0].toString())) * 100;
					dblDiscPerDay =  Double.parseDouble(obj[0].toString()) * (discPer / 100);
					objBean.setDblDiscPer(discPer);
				}
				else//per
				{
					dblDiscPerDay = ( Double.parseDouble(obj[0].toString())*objBean.getDblDiscPer())/100;
				}
				
				String sqlUpdateFoliodtl = "update tblfoliodtl  a set a.dblDiscAmt='"+dblDiscPerDay+"',a.dblDiscPer='"+objBean.getDblDiscPer()+"'"
						+ "  where a.strFolioNo='"+objBean.getStrBillNo()+"' and  date(a.dteDocDate)='"+obj[2].toString()+"'"
						+ " and  a.strDocNo='"+obj[3].toString()+"' and a.strClientCode='"+clientCode+"' ";

				objWebPMSUtility.funExecuteUpdate(sqlUpdateFoliodtl, "sql");
				
				
				//Logic for recalculating tax
				double dblRoomTerrifWithDisc= Double.parseDouble(obj[0].toString())-dblDiscPerDay;
				
				
				
				double finalTax = 0.0;
				
				for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
					double taxAmt = 0;
					String taxCalType = "Forward";
					if(clientCode.equalsIgnoreCase("383.001"))
					{
						 taxCalType = "Backward";
					}
					Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
					
					
					if(fromRate<=(dblRoomTerrifWithDisc)&& (dblRoomTerrifWithDisc)<=toRate)
					{
						
						if (taxCalType.equals("Forward")) // Forward Tax
															// Calculation
						{
							taxAmt = (dblRoomTerrifWithDisc * taxValue) / 100;
							dblTaxAmt = taxAmt;
						} 
						else // Backward Tax Calculation
						{
							taxAmt = dblRoomTerrifWithDisc * 100 / (100 + taxValue);
							taxAmt = dblRoomTerrifWithDisc - taxAmt;
							taxAmt=taxAmt/2;
						}
						finalTax = finalTax+taxAmt;
						
					}
					if(taxAmt>0)
					{
						String sqlUpdate = "update tblfoliotaxdtl a set a.dblTaxableAmt='"+dblRoomTerrifWithDisc+"' ,a.dblTaxAmt='"+taxAmt+"' "
								+ " where a.strFolioNo='"+objBean.getStrBillNo()+"' and a.strDocNo='"+obj[3].toString()+"' and a.strClientCode='"+clientCode+"' and a.strTaxCode='"+arrObjTaxDtl[0].toString()+"' ";
						objWebPMSUtility.funExecuteUpdate(sqlUpdate, "sql");
					}
				
					
				}
			
				
				
				}
									
			}
		
	
	
	
	
	}
	
	private void funCalculateDiscountIncomeheadwise(clsBillDiscountBean objBean, BindingResult result, HttpServletRequest req,String strDiscType)
	{

		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());				
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		clsFolioHdModel objFolioHdModel = objFolioService.funGetFolioList(objBean.getStrFolioNo(), clientCode, propertyCode);
		clsBillDiscountHdModel objModel = funPrepareModel(objBean, userCode, clientCode);

		
		
		Map<String,Double> mapDisc= new HashMap<>();
		double dblDiscPerDay = 0;
		double dblTaxAmt=0;
		double dblSumIncomeHeadAmt=0;
		String sqlIncomeHeadAmt = "select (a.dblDebitAmt),a.strRevenueCode,Date(a.dteDocDate),a.strDocNo from tblfoliodtl a "
				+ " where a.strRevenueType='Income Head' "
				+ " and a.strFolioNo='"+objBean.getStrBillNo()+"' "
				+ " AND a.strClientCode='"+clientCode+"'";
		List listIncomeHeadAmt = objGlobalFunctionsService.funGetListModuleWise(sqlIncomeHeadAmt, "sql");
		if(listIncomeHeadAmt!=null && listIncomeHeadAmt.size()>0)
		{
			for(int i=0;i<listIncomeHeadAmt.size();i++)
			{
				Object[] obj=(Object[])listIncomeHeadAmt.get(i);
				dblSumIncomeHeadAmt = dblSumIncomeHeadAmt + Double.parseDouble(obj[0].toString());
				double dblIncomeHeadAmt = Double.parseDouble(obj[0].toString());
				mapDisc.put(obj[1].toString()+"#"+obj[2].toString()+"#"+obj[3].toString(),dblIncomeHeadAmt);					

			}
		}

		for(Map.Entry<String,Double> entry:mapDisc.entrySet())
		{
			
			if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
			{					
				double discPer = (objBean.getDblDiscAmt() / entry.getValue()) * 100;
				dblDiscPerDay = entry.getValue() * (discPer / 100);
			}
			else//per
			{
				dblDiscPerDay = (entry.getValue()*objBean.getDblDiscPer())/100;
			}
			
			
			objModel.setDblDiscAmt(dblDiscPerDay);
			objModel.setDblGrandTotal(entry.getValue());
			objModel.setStrRoomNo(entry.getKey().split("#")[2]);//Reffered for doc No
			objModel.setDteBillDate(entry.getKey().split("#")[1]);
			objModel.setStrDiscType(strDiscType);
			
			if (objModel != null) {
				objBillDiscountService.funAddUpdateBillDiscount(objModel);
			}
		}
		
		Date dt = new Date();
		String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();

		String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
				+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
				+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
				+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Department' AND strClientCode='"+clientCode+"'";
		
		List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
		
		
		
		
		sqlIncomeHeadAmt = "select a.dblDebitAmt,a.strRevenueCode,date(a.dteDocDate),a.strDocNo "
				+ " from tblfoliodtl a "
				+ " where    a.strRevenueType='Income Head' "
				+ " and a.strFolioNo='"+objBean.getStrBillNo()+"' "
				+ " AND a.strClientCode='"+clientCode+"' ;";
				
		List lisIncomeHeadDatewise = objGlobalFunctionsService.funGetListModuleWise(sqlIncomeHeadAmt, "sql");
		if(lisIncomeHeadDatewise!=null && lisIncomeHeadDatewise.size()>0)
		{
			for(int i=0;i<lisIncomeHeadDatewise.size();i++)
			{
				Object[] obj=(Object[])lisIncomeHeadDatewise.get(i);
				if(objBean.getStrDiscountType().equalsIgnoreCase("Amount"))
				{					
					double discPer = (objBean.getDblDiscAmt() / Double.parseDouble(obj[0].toString())) * 100;
					dblDiscPerDay =  Double.parseDouble(obj[0].toString()) * (discPer / 100);
					objBean.setDblDiscPer(discPer);
				}
				else//per
				{
					dblDiscPerDay = ( Double.parseDouble(obj[0].toString())*objBean.getDblDiscPer())/100;
				}
				
				String sqlUpdateFoliodtl = "update tblfoliodtl  a set a.dblDiscAmt='"+dblDiscPerDay+"',a.dblDiscPer='"+objBean.getDblDiscPer()+"'"
						+ "  where a.strFolioNo='"+objBean.getStrBillNo()+"' and  date(a.dteDocDate)='"+obj[2].toString()+"'"
						+ " and  a.strDocNo='"+obj[3].toString()+"' and a.strClientCode='"+clientCode+"' ";

				objWebPMSUtility.funExecuteUpdate(sqlUpdateFoliodtl, "sql");
				
				
				//Logic for recalculating tax
				double dblIncomeHeadWithDisc= Double.parseDouble(obj[0].toString())-dblDiscPerDay;
				
				double finalTax = 0.0;
				
				for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
					double taxAmt = 0;
					String taxCalType = "Forward";
					if(clientCode.equalsIgnoreCase("383.001"))
					{
						 taxCalType = "Backward";
					}
					Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
											
					if(fromRate<=(dblIncomeHeadWithDisc)&& (dblIncomeHeadWithDisc)<=toRate)
					{
						
						if (taxCalType.equals("Forward")) // Forward Tax
															// Calculation
						{
							taxAmt = (dblIncomeHeadWithDisc * taxValue) / 100;
							dblTaxAmt = taxAmt;
						} 
						else // Backward Tax Calculation
						{
							taxAmt = dblIncomeHeadWithDisc * 100 / (100 + taxValue);
							taxAmt = dblIncomeHeadWithDisc - taxAmt;
							taxAmt=taxAmt/2;
						}
						finalTax = finalTax+taxAmt;
						
					}
					if(taxAmt>0)
					{
						String sqlUpdate = "update tblfoliotaxdtl a set a.dblTaxableAmt='"+dblIncomeHeadWithDisc+"' ,a.dblTaxAmt='"+taxAmt+"' "
								+ " where a.strFolioNo='"+objBean.getStrBillNo()+"' and a.strDocNo='"+obj[3].toString()+"' and a.strClientCode='"+clientCode+"' and a.strTaxCode='"+arrObjTaxDtl[0].toString()+"' ";
						objWebPMSUtility.funExecuteUpdate(sqlUpdate, "sql");
					}
				
					
				}
			
				
				
				}
									
			}
		
	
		
	
	}
	
	
}
