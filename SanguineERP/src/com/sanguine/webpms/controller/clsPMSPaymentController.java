package com.sanguine.webpms.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.model.clsPropertyMaster;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsPropertyMasterService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsFolioDtlBean;
import com.sanguine.webpms.bean.clsPMSPaymentBean;
import com.sanguine.webpms.bean.clsPaymentReciptBean;
import com.sanguine.webpms.dao.clsPMSPaymentDao;
import com.sanguine.webpms.dao.clsPMSSettlementMasterDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsCheckInDtl;
import com.sanguine.webpms.model.clsCheckInHdModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsPMSPaymentHdModel;
import com.sanguine.webpms.model.clsPMSPaymentReceiptDtl;
import com.sanguine.webpms.model.clsPMSSettlementMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.model.clsReservationDtlModel;
import com.sanguine.webpms.model.clsReservationHdModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.service.clsCheckInService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPMSPaymentService;
import com.sanguine.webpms.service.clsPropertySetupService;
import com.sanguine.webpms.service.clsReservationService;
import com.sanguine.webpms.service.clsRoomMasterService;

@Controller
public class clsPMSPaymentController {
	@Autowired
	private clsPMSPaymentService objPaymentService;

	@Autowired
	private clsPMSPaymentDao objPaymentDao;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private ServletContext servletContext;

	@Autowired
	private clsSetupMasterService objSetupMasterService;

	@Autowired
	private clsPropertySetupService objPropertySetupService;

	@Autowired
	private clsGuestMasterService objGuestService;

	@Autowired
	private clsPropertyMasterService objPropertyMasterService;

	@Autowired
	clsPMSPaymentDao objDao;

	@Autowired
	private clsReservationService objReservationService;
	@Autowired
	private clsFolioService objFolioService;

	@Autowired
	clsCheckInService objCheckInService;

	@Autowired
	clsPMSSettlementMasterDao objtPMSSettlement;

	@Autowired
	clsRoomMasterService objRoomMaster;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	// Open Payment
	@RequestMapping(value = "/frmPMSPayment", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String strModule = request.getSession().getAttribute("selectedModuleName").toString();

		if(strModule.equalsIgnoreCase("3-WebPMS"))
		{
		List<String> listAgainst = new ArrayList<>();
		listAgainst.add("Reservation");
		//listAgainst.add("Check-In");
		listAgainst.add("Folio-No");
		listAgainst.add("Bill");
		listAgainst.add("Deposit");
		model.put("listAgainst", listAgainst);
		
		List<String> listSettlement = new ArrayList<>();
		listSettlement.add("Part Settlement");
		listSettlement.add("Full Settlement");

		model.put("listSettlement", listSettlement);
		
		}
		else
		{
			List<String> listAgainst = new ArrayList<>();
			listAgainst.add("Banquet");
			
			model.put("listAgainst", listAgainst);
			
			List<String> listSettlement = new ArrayList<>();
			listSettlement.add("Part Settlement");
			listSettlement.add("Full Settlement");

			model.put("listSettlement", listSettlement);
		}
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if (urlHits.equalsIgnoreCase("1")) {

			return new ModelAndView("frmPMSPayment", "command", new clsPMSPaymentBean());
		} else {
			return new ModelAndView("frmPMSPayment_1", "command", new clsPMSPaymentBean());
		}
	}

	// Load Payemt Data
	@RequestMapping(value = "/loadReceiptData", method = RequestMethod.GET)
	public @ResponseBody clsPMSPaymentBean funLoadReceiptData(@RequestParam("receiptNo") String receiptNo, HttpServletRequest request) {

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		clsPMSPaymentBean objPaymentRecBean = new clsPMSPaymentBean();
		clsPMSPaymentHdModel objPaymentModel = objPaymentDao.funGetPaymentModel(receiptNo, clientCode);

		objPaymentRecBean.setStrReceiptNo(objPaymentModel.getStrReceiptNo());
		objPaymentRecBean.setStrAgainst(objPaymentModel.getStrAgainst());

		if (objPaymentModel.getStrAgainst().equals("Reservation")) {
			objPaymentRecBean.setStrDocNo(objPaymentModel.getStrReservationNo());
		} else if (objPaymentModel.getStrAgainst().equals("Folio-No")) {
			objPaymentRecBean.setStrDocNo(objPaymentModel.getStrFolioNo());

		} else if (objPaymentModel.getStrAgainst().equals("Check-In")) {
			objPaymentRecBean.setStrDocNo(objPaymentModel.getStrCheckInNo());
		}
		else if (objPaymentModel.getStrAgainst().equals("Banquet")) {
			objPaymentRecBean.setStrDocNo(objPaymentModel.getStrReservationNo());

		}
		else {
			objPaymentRecBean.setStrDocNo(objPaymentModel.getStrBillNo());
		}
		
		objPaymentRecBean.setStrFolioNo(objPaymentModel.getStrFolioNo());
		objPaymentRecBean.setStrRegistrationNo(objPaymentModel.getStrRegistrationNo());
		objPaymentRecBean.setStrFlagOfAdvAmt(objPaymentModel.getStrFlagOfAdvAmt());
		clsPMSPaymentReceiptDtl objPaymentDtlModel = objPaymentModel.getListPaymentRecieptDtlModel().get(0);
		objPaymentRecBean.setStrRemarks(objPaymentDtlModel.getStrRemarks());
		objPaymentRecBean.setStrCardNo(objPaymentDtlModel.getStrCardNo());
		objPaymentRecBean.setStrSettlementCode(objPaymentDtlModel.getStrSettlementCode());
		objPaymentRecBean.setDblPaidAmt(objPaymentModel.getDblPaidAmt());
		objPaymentRecBean.setDblReceiptAmt(objPaymentModel.getDblReceiptAmt());
		objPaymentRecBean.setDblSettlementAmt(objPaymentDtlModel.getDblSettlementAmt());
		objPaymentRecBean.setDteExpiryDate(objGlobal.funGetDate("yyyy/MM/dd", objPaymentDtlModel.getDteExpiryDate()));

		return objPaymentRecBean;
	}

	// Save or Update Payment
	@RequestMapping(value = "/savePMSPayment", method = RequestMethod.GET)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSPaymentBean objBean, BindingResult result, HttpServletRequest req) {
		
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			clsPMSPaymentHdModel objHdModel = objPaymentService.funPreparePaymentModel(objBean, clientCode, req, userCode);
			objPaymentDao.funAddUpdatePaymentHd(objHdModel);
			String propCode = req.getSession().getAttribute("propertyCode").toString();
//			funSendSMSPayment(objHdModel.getStrReceiptNo(), clientCode, propCode);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Payment Code : ".concat(objHdModel.getStrReceiptNo()));
			req.getSession().setAttribute("GenerateSlip", objHdModel.getStrReceiptNo());
			req.getSession().setAttribute("Against", objHdModel.getStrAgainst());
			return new ModelAndView("redirect:/frmPMSPayment.html");
		} else {
			return new ModelAndView("frmPMSPayment.jsp");
		}
	}

	// Load Table Data On Form
	@RequestMapping(value = "/loadPaymentGuestDetails", method = RequestMethod.GET)
	public @ResponseBody List funLoadPaymentGuestDetails(@RequestParam("docCode") String docCode, @RequestParam("docName") String docName, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String sql = "";
		List listGuestDataDtl = new ArrayList();
		
		if (docName.equals("Bill")) 
		{
			sql = " SELECT c.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName FROM tblbillhd a,tblguestmaster c "
				+ " WHERE a.strGuestCode=c.strGuestCode AND a.strBillNo='"+docCode+"'; ";
			List listBillData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			
			if(listBillData.size()>0)
			{  
				for(int i=0;i<listBillData.size();i++)
				{
					Object[] obj = (Object[])listBillData.get(i);
					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrGuestCode(obj[0].toString());
					objPaymentReciptBean.setStrFirstName(obj[1].toString());
					objPaymentReciptBean.setStrMiddleName(obj[2].toString());
					objPaymentReciptBean.setStrLastName(obj[3].toString());		
					
					
					
					String sqlPayment="SELECT b.BillAmount - a.receiptamt +c.taxAmt "
							+ " FROM "
							+ " ("
							+ " "
							+ " SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) + "
							+ " IFNULL(c.recieptFolioAmt,0) + ifnull(recieptBillAmt,0) + ifnull(e.recieptRefundAmt,0) AS receiptamt FROM "
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt"
							+ " FROM tblreceipthd a, tblbillhd b"
							+ " WHERE a.strReservationNo = b.strReservationNo"
							+ " AND b.strBillNo='"+docCode+"' "
							+ " AND a.strFlagOfAdvAmt='Y' ) AS a,"
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1"
							+ "  FROM tblreceipthd a, tblbillhd b"
							+ "  WHERE a.strFolioNo = b.strFolioNo"
							+ " AND a.strCheckInNo = b.strCheckInNo  AND a.strBillNo='"+docCode+"' "
							+ " AND a.strReservationNo = '') AS b,"
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS recieptFolioAmt"
							+ " FROM tblreceipthd a, tblbillhd b"
							+ " WHERE a.strReservationNo = b.strReservationNo AND a.strFolioNo=b.strFolioNo "
							+ " and a.strBillNo='' AND b.strBillNo='"+docCode+"'  AND a.strFlagOfAdvAmt='N') AS c ,"
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS recieptBillAmt"
							+ " FROM tblreceipthd a, tblbillhd b"
							+ " WHERE a.strReservationNo = b.strReservationNo AND a.strFolioNo=b.strFolioNo "
							+ " and a.strBillNo=b.strBillNo"
							+ " AND b.strBillNo='"+docCode+"' AND a.strFlagOfAdvAmt='N' ) AS d,"
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS recieptRefundAmt"
							+ " FROM tblreceipthd a, tblbillhd b"
							+ " WHERE a.strBillNo=b.strBillNo AND b.strBillNo='"+docCode+"'  "
							+ " AND a.strType='Refund Amt' ) as e  ) AS a, "
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblDebitAmt),0) - IFNULL(SUM(a.dblDiscAmt),0) AS BillAmount"
							+ " FROM tblbilldtl a"
							+ " WHERE a.strBillNo='"+docCode+"'  ) AS b,"
							+ " "
							+ " (SELECT IFNULL(SUM(a.dblTaxAmt),0) AS taxAmt"
							+ " FROM tblbilltaxdtl a,tbltaxmaster b"
							+ " WHERE a.strTaxCode=b.strTaxCode AND b.strTaxCalculation='Forward' "
							+ " AND a.strBillNo='"+docCode+"'  )  AS c ;";
					List listBillPaymentData = objGlobalFunctionsService.funGetListModuleWise(sqlPayment, "sql");
					
					if(listBillPaymentData!=null &&  listBillPaymentData.size()>0)
					{  
						objPaymentReciptBean.setDblBalanceAmount(Double.parseDouble(listBillPaymentData.get(0).toString()));
					}
					listGuestDataDtl.add(objPaymentReciptBean);
				}
			}
		 
	}


		else if (docName.equals("Reservation")) 
		{
			
			sql="select b.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName "
				+ " from tblreservationhd a,tblreservationdtl b,tblguestmaster c "
				+ " where a.strReservationNo=b.strReservationNo and b.strGuestCode=c.strGuestCode "
				+ " and a.strReservationNo='"+docCode+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' ";

			
			List listReservData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			
			if(listReservData.size()>0)
			{
				for(int i=0;i<listReservData.size();i++)
				{
					Object[] obj = (Object[])listReservData.get(i);
					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					
					String sqlRecipt="SELECT IFNULL(SUM(a.dblReceiptAmt),0),IFNULL(SUM(d.dblGrandTotal),0)"
							+ " FROM tblreceipthd a left outer join tblbillhd d on a.strBillNo=d.strBillNo and a.strFolioNo=d.strFolioNo AND a.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"',"
							+ " tblreceiptdtl b, tblreservationhd c"
							+ " WHERE a.strReceiptNo=b.strReceiptNo AND a.strReservationNo=c.strReservationNo "
							+ " AND c.strReservationNo='" + docCode + "' ";	
					
				
				    boolean flgIsFullPaymentFound=false;
					List listRecipt = objGlobalFunctionsService.funGetListModuleWise(sqlRecipt, "sql");
					double reciptAmt=0.0;
					for(int cnt=0;cnt<listRecipt.size();cnt++)
					{
						Object[] objReceipt = (Object[])listRecipt.get(cnt);
						if(Double.parseDouble(objReceipt[0].toString())==Double.parseDouble(objReceipt[1].toString()))
						{
							flgIsFullPaymentFound=true;
							break;
						}
						else
						{
							reciptAmt=Double.parseDouble(objReceipt[0].toString());
						}
					}
					objPaymentReciptBean.setStrGuestCode(obj[0].toString());
					objPaymentReciptBean.setStrFirstName(obj[1].toString());
					objPaymentReciptBean.setStrMiddleName(obj[2].toString());
					objPaymentReciptBean.setStrLastName(obj[3].toString());
					
					if(!flgIsFullPaymentFound)
					{
						String sqlPaymentAmt=" select withPkgAmt,withoutPkgAmt from "
								+ " (select ifnull(sum(a.dblIncomeHeadAmt),0) withPkgAmt from tblroompackagedtl a where a.strReservationNo='" + docCode + "' ) a,"
								+ " (select ifnull(sum(a.dblRoomRate),0) withoutPkgAmt from tblreservationroomratedtl a where a.strReservationNo='" + docCode + "' ) b ";
						List listPaymentAmt = objGlobalFunctionsService.funGetListModuleWise(sqlPaymentAmt, "sql");
						if(listPaymentAmt.size()>0)
						{
							for(int cnt=0;cnt<listPaymentAmt.size();cnt++)
							{
								Object[] objPayment = (Object[])listPaymentAmt.get(cnt);
		
								if(Double.parseDouble(objPayment[0].toString())>0)
								{
									objPaymentReciptBean.setDblBalanceAmount(0);//objPaymentReciptBean.setDblBalanceAmount((Double.parseDouble(objPayment[0].toString()))-reciptAmt);
								}
								else
								{
									objPaymentReciptBean.setDblBalanceAmount(0);//objPaymentReciptBean.setDblBalanceAmount((Double.parseDouble(objPayment[1].toString()))-reciptAmt);		
								}
								
							}
						}	
					}
							
				
				
				//objPaymentReciptBean.setDblBalanceAmount(Double.parseDouble(obj[4].toString())-reciptAmt);	
				listGuestDataDtl.add(objPaymentReciptBean);
				}
			}
			else 
			{
				sql = " select c.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName " + " from tblcheckindtl a,tblguestmaster c " + " where a.strGuestCode=c.strGuestCode " + " and a.strCheckInNo='" + docCode + "' and a.strPayee='Y'";
				List listData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if(listData.size()>0)
				{
					for(int i=0;i<listData.size();i++)
					{
					Object[] obj = (Object[])listData.get(i);
					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrGuestCode(obj[0].toString());
					objPaymentReciptBean.setStrFirstName(obj[1].toString());
					objPaymentReciptBean.setStrMiddleName(obj[2].toString());
					objPaymentReciptBean.setStrLastName(obj[3].toString());
					objPaymentReciptBean.setDblBalanceAmount(0);
					listGuestDataDtl.add(objPaymentReciptBean);
					}
				}
			}
			

		} 
		else if (docName.equals("Folio-No")) 
		{
			clsFolioDtlBean objFolioDtlBean = new clsFolioDtlBean();
				
			sql="SELECT a.strGuestCode,a.strFirstName,a.strMiddleName,a.strLastName,IFNULL(SUM(amount - IFNULL(discount,0)),0),a.strReservationNo ,a.strCheckInNo,a.strRoom"
			 +" FROM(SELECT c.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName, SUM(e.dblDebitAmt) AS amount, "
			 +" a.strCheckInNo,f.strReservationNo,d.strRoom  FROM tblcheckindtl a,tblguestmaster c,tblfoliohd d,tblfoliodtl e,tblcheckinhd f "
			 +" WHERE a.strGuestCode=c.strGuestCode AND a.strGuestCode=d.strGuestCode AND a.strCheckInNo=d.strCheckInNo  "
			 +" AND a.strRegistrationNo =d.strRegistrationNo AND d.strFolioNo='" + docCode + "' "
			 +" AND a.strPayee='Y' AND e.strRevenueType!='discount' AND d.strFolioNo=e.strFolioNo AND a.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' AND f.strClientCode='"+clientCode+"' and a.strCheckInNo=f.strCheckInNo) AS a, ( "
			 +" SELECT c.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName, SUM(e.dblDebitAmt) AS discount,d.strRoom "
			 +" FROM tblcheckindtl a,tblguestmaster c,tblfoliohd d,tblfoliodtl e "
			 +" WHERE a.strGuestCode=c.strGuestCode AND a.strGuestCode=d.strGuestCode " 
			 +" AND a.strCheckInNo=d.strCheckInNo AND a.strRegistrationNo =d.strRegistrationNo " 
			 +" AND d.strFolioNo='" + docCode + "' AND a.strPayee='Y' AND e.strRevenueType='Discount'  "
			 +" AND d.strFolioNo=e.strFolioNo AND a.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"') AS b;" ;
			
			List listFoliaData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			
			if(listFoliaData.size()>0)
			{
				for(int i=0;i<listFoliaData.size();i++)
				{
				Object[] obj = (Object[])listFoliaData.get(i);
				clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
				
				String sqlRecipt="";
				String receiptAmt="a.dblReceiptAmt";
				if(obj[5].toString().equalsIgnoreCase("") )
				{
						receiptAmt="0";
				}
				
				sqlRecipt="SELECT b.BillAmount - a.receiptamt +c.taxAmt"
						+ " FROM "
						+ "( SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) + IFNULL(c.recieptFolioAmt,0)  AS receiptamt"
						+ " FROM "
						+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt"
						+ " FROM tblreceipthd a, tblfoliohd b"
						+ " WHERE a.strReservationNo = b.strReservationNo AND b.strFolioNo='"+docCode+"' AND b.strRoom='Y' "
						+ " AND a.strFlagOfAdvAmt='Y' AND LENGTH(b.strWalkInNo)=0  )  AS a , "//Advance payment,group reservation,reservation,Group leeader payee
						+ " ( SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1"
						+ " FROM tblreceipthd a, tblfoliohd b"
						+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = b.strCheckInNo AND a.strFolioNo = '"+docCode+"'"
						+ " AND a.strReservationNo = '') AS b, " //Folio payment ,walk in 
						+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS recieptFolioAmt"
						+ " FROM tblreceipthd a, tblfoliohd b"
						+ " WHERE a.strReservationNo = b.strReservationNo  AND a.strFolioNo=b.strFolioNo"
						+ " AND b.strFolioNo='"+docCode+"' "
						+ " AND a.strFlagOfAdvAmt='N' AND LENGTH(b.strWalkInNo)=0 ) AS c )  AS a, "//Folio payment ,group reservation,reservation,Non Group leeader payee
						+ " (SELECT IFNULL(SUM(a.dblDebitAmt),0) - IFNULL(SUM(a.dblDiscAmt ),0)   AS BillAmount"
						+ " FROM tblfoliodtl a"
						+ " WHERE a.strFolioNo='"+docCode+"') AS b,"//total Folio Amount
						+ " (SELECT IFNULL(SUM(a.dblTaxAmt),0) AS taxAmt"
						+ " FROM tblfoliotaxdtl a,tbltaxmaster b"
						+ " WHERE a.strTaxCode=b.strTaxCode AND b.strTaxCalculation='Forward' AND a.strFolioNo='"+docCode+"') AS c ;" ;////total FolioTax  Amount
			
			
				
				List listRecipt = objGlobalFunctionsService.funGetListModuleWise(sqlRecipt, "sql");
				double reciptAmt=0.0;
				if(listRecipt.size()>0)
				{
					reciptAmt=Double.parseDouble(listRecipt.get(0).toString());	
					
				}
				NumberFormat formatter = new DecimalFormat("0.00");
				double dblBal=0.00;
				dblBal = reciptAmt;
				objPaymentReciptBean.setStrGuestCode(obj[0].toString());
				objPaymentReciptBean.setStrFirstName(obj[1].toString());
				objPaymentReciptBean.setStrMiddleName(obj[2].toString());
				objPaymentReciptBean.setStrLastName(obj[3].toString());
				objPaymentReciptBean.setDblBalanceAmount(Double.parseDouble(formatter.format(dblBal)));
				listGuestDataDtl.add(objPaymentReciptBean);
				}
			}
		}
		else if(docName.equalsIgnoreCase("Banquet"))
		{
			clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
			String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
			String sqlPaymentLoad = "select b.strPCode,b.strPName,a.dblSubTotal "
					+ "from tblbqbookinghd a,"+webStockDB+".tblpartymaster b "
					+ "where a.strCustomerCode=b.strPCode and a.strClientCode='"+clientCode+"' "
					+ "and b.strClientCode='"+clientCode+"' and a.strBookingNo='"+docCode+"'";
			List listData=objGlobalFunctionsService.funGetListModuleWise(sqlPaymentLoad, "sql");
			if(listData.size()>0 && listData!=null)
			{
				for(int i=0;i<listData.size();i++)
				{
					Object[] obj = (Object[])listData.get(i);
					
					objPaymentReciptBean.setStrGuestCode(obj[0].toString());
					objPaymentReciptBean.setStrFirstName(obj[1].toString());
					objPaymentReciptBean.setDblBalanceAmount(Double.parseDouble(obj[2].toString()));
					objPaymentReciptBean.setStrMiddleName("");
					objPaymentReciptBean.setStrLastName("");
				}
				
			}
			
			
			listGuestDataDtl.add(objPaymentReciptBean);
		}
		else 
		{
			sql = " select c.strGuestCode,c.strFirstName,c.strMiddleName,c.strLastName " + " from tblcheckindtl a,tblguestmaster c " + " where a.strGuestCode=c.strGuestCode " + " and a.strCheckInNo='" + docCode + "' and a.strPayee='Y'";
			List listData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if(listData.size()>0)
			{
				for(int i=0;i<listData.size();i++)
				{
				Object[] obj = (Object[])listData.get(i);
				clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
				objPaymentReciptBean.setStrGuestCode(obj[0].toString());
				objPaymentReciptBean.setStrFirstName(obj[1].toString());
				objPaymentReciptBean.setStrMiddleName(obj[2].toString());
				objPaymentReciptBean.setStrLastName(obj[3].toString());
				objPaymentReciptBean.setDblBalanceAmount(0);
				listGuestDataDtl.add(objPaymentReciptBean);
				}
			}
		}
		
		return listGuestDataDtl;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rptReservationPaymentRecipt", method = RequestMethod.GET)
	public void funGeneratePaymentRecipt(@RequestParam("reciptNo") String reciptNo, @RequestParam("checkAgainst") String checkAgainst, HttpServletRequest req, HttpServletResponse resp) {
		try {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String companyName = req.getSession().getAttribute("companyName").toString();
			String webStockDB=req.getSession().getAttribute("WebStockDB").toString();
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}

			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
			String userName = "";
			String sqlUserName = "select strUserName from "+webStockDB+".tbluserhd where strUserCode='" + userCode + "' ";

			List listOfUser = objGlobalFunctionsService.funGetDataList(sqlUserName, "sql");
			if (listOfUser.size() > 0) {
				// Object[] userData = (Object[]) listOfUser.get(0);
				userName = listOfUser.get(0).toString();
			}

			HashMap reportParams = new HashMap();
			reportParams.put("pCompanyName", companyName);
			reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
			reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
			reportParams.put("pContactDetails", "");
			reportParams.put("strImagePath", imagePath);
			reportParams.put("userName", userName);
			if(clientCode.equalsIgnoreCase("378.001"))
			{
				reportParams.put("lblChild", null);
			}
			else
			{
			    reportParams.put("lblChild", "Child                    :")	;
			}
			ArrayList datalist = new ArrayList();
			String reportName = "";
			if (checkAgainst.equalsIgnoreCase("Reservation")) {
				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptReservationPaymentRecipt.jrxml");
				/*String sqlPayment = "select a.strReceiptNo,ifnull(d.intNoOfAdults,''),ifnull(d.intNoOfChild,'')  ,ifnull(a.strReservationNo,'')" + ",ifnull(c.strRoomType,''),DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y'),f.strFirstName" + ",f.strMiddleName,f.strLastName,ifnull(e.strSettlementDesc,''),a.dblPaidAmt,b.strRemarks"
						+ ",DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y') " + "from tblreceipthd a left outer join  tblreceiptdtl b on a.strReceiptNo=b.strReceiptNo " + "left outer join  tblreservationdtl c on a.strReservationNo=c.strReservationNo " + "left outer join  tblreservationhd d on a.strReservationNo=d.strReservationNo "
						+ "left outer join  tblsettlementmaster e on b.strSettlementCode=e.strSettlementCode " + "left outer join  tblguestmaster f    on c.strGuestCode=f.strGuestCode " + "where a.strReceiptNo='" + reciptNo + "' and a.strClientCode='" + clientCode + "'  ";
				*/
				String sqlPayment = "select a.strReceiptNo,ifnull(d.intNoOfAdults,''),ifnull(d.intNoOfChild,'')  ,ifnull(a.strReservationNo,'')" 
					    + ",ifnull(c.strRoomType,''),DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y'),f.strFirstName" 
					    + ",f.strMiddleName,f.strLastName,ifnull(e.strSettlementDesc,''),a.dblPaidAmt,b.strRemarks"
					    + ",DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y'),g.strRoomTypeDesc,IFNULL(h.strRoomDesc,'') " 
					    + "from tblreceipthd a left outer join  tblreceiptdtl b on a.strReceiptNo=b.strReceiptNo AND b.strClientCode='"+clientCode+"'" 
				  	    + "left outer join  tblreservationdtl c on a.strReservationNo=c.strReservationNo AND c.strClientCode='"+clientCode+"'"
					    + "left outer join  tblreservationhd d on a.strReservationNo=d.strReservationNo  AND d.strClientCode='"+clientCode+"'"
					    + "left outer join  tblsettlementmaster e on b.strSettlementCode=e.strSettlementCode  AND e.strClientCode='"+clientCode+"'" 
					    + "left outer join  tblguestmaster f    on c.strGuestCode=f.strGuestCode AND f.strClientCode='"+clientCode+"'"
					    + "LEFT OUTER JOIN tblroom h ON h.strRoomCode=c.strRoomNo  "
					    + ",tblroomtypemaster g " 
					    + "where c.strRoomType=g.strRoomTypeCode "
					    + "and a.strReceiptNo='" + reciptNo + "' and a.strClientCode='" + clientCode + "' "
					    + "  AND g.strClientCode='"+clientCode+"'"
					    + " group by a.strReceiptNo ";
			
				List listOfPayment = objGlobalFunctionsService.funGetDataList(sqlPayment, "sql");

				for (int i = 0; i < listOfPayment.size(); i++) {
					Object PaymentData[] = (Object[]) listOfPayment.get(i);

					String strReceiptNo = PaymentData[0].toString();
					String intNoOfAdults = PaymentData[1].toString();
					String intNoOfChild ;
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						intNoOfChild=null;
					}
					else
					{
						intNoOfChild = PaymentData[2].toString();
					}
					String strReservationNo = PaymentData[3].toString();
					String strRoomType = PaymentData[14].toString();
					String dteArrivalDate = PaymentData[5].toString();
					String dteDepartureDate = PaymentData[6].toString();
					String strFirstName = PaymentData[7].toString();
					String strMiddleName = PaymentData[8].toString();
					String strLastName = PaymentData[9].toString();
					String strSettlementDesc = PaymentData[10].toString();
					String dblPaidAmt = PaymentData[11].toString();
					String strRemarks = PaymentData
							[12].toString();
					String dteReciptDate = PaymentData[13].toString();
					String dteModifiedDate = PaymentData[13].toString();

					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrReceiptNo(strReceiptNo);
					objPaymentReciptBean.setIntNoOfAdults(intNoOfAdults);
					objPaymentReciptBean.setIntNoOfChild(intNoOfChild);
					objPaymentReciptBean.setStrReservationNo(strReservationNo);
					objPaymentReciptBean.setStrRoomType(strRoomType);
					objPaymentReciptBean.setDteArrivalDate(dteArrivalDate);
					objPaymentReciptBean.setDteDepartureDate(dteDepartureDate);
					objPaymentReciptBean.setStrFirstName(strFirstName+" ");
					objPaymentReciptBean.setStrMiddleName(strMiddleName+" ");
					objPaymentReciptBean.setStrLastName(strLastName);
					objPaymentReciptBean.setStrSettlementDesc(strSettlementDesc);
					objPaymentReciptBean.setDblPaidAmt(dblPaidAmt);
					objPaymentReciptBean.setStrRemarks(strRemarks);
					objPaymentReciptBean.setDteReciptDate(dteReciptDate);
					objPaymentReciptBean.setDteModifiedDate(dteModifiedDate);
					datalist.add(objPaymentReciptBean);
				}
			} else if (checkAgainst.equalsIgnoreCase("Banquet")) {
				reportName = servletContext.getRealPath("/WEB-INF/reports/webbanquet/rptBanquetPaymentRecipt.jrxml");
				

				String sqlPayment = "SELECT a.strReceiptNo,c.strBookingNo,b.strPName,e.strSettlementDesc,a.dblPaidAmt, DATE_FORMAT(DATE(a.dteReceiptDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDateEdited),'%d-%m-%Y') "
						+ "FROM tblreceipthd a,"+webStockDB+".tblpartymaster b,tblbqbookinghd c,tblreceiptdtl d,tblsettlementmaster e "
						+ "WHERE a.strReceiptNo='"+reciptNo+"' AND b.strPCode=c.strCustomerCode AND a.strReservationNo=c.strBookingNo AND a.strReceiptNo=d.strReceiptNo AND d.strSettlementCode=e.strSettlementCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'";
				List listOfPayment = objGlobalFunctionsService.funGetDataList(sqlPayment, "sql");

				for (int i = 0; i < listOfPayment.size(); i++) {
					Object PaymentData[] = (Object[]) listOfPayment.get(i);

					String strReceiptNo = PaymentData[0].toString();
					String strBookingNo = PaymentData[1].toString();
					String strFirstName = PaymentData[2].toString();
					String strSettlementDesc = PaymentData[3].toString();
					String dblPaidAmt = PaymentData[4].toString();
					String dteReciptDate = PaymentData[5].toString();
					String dteModifiedDate = PaymentData[5].toString();

					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrReceiptNo(strReceiptNo);
					objPaymentReciptBean.setStrFirstName(strFirstName+" ");
					objPaymentReciptBean.setStrSettlementDesc(strSettlementDesc);
					objPaymentReciptBean.setDblPaidAmt(dblPaidAmt);
					objPaymentReciptBean.setDteReciptDate(dteReciptDate);
					objPaymentReciptBean.setDteModifiedDate(dteModifiedDate);
					objPaymentReciptBean.setStrReservationNo(strBookingNo);
					datalist.add(objPaymentReciptBean);
				}
			} 
			else if (checkAgainst.equalsIgnoreCase("Bill")) {
				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptBillNoPaymentRecipt.jrxml");
				/*
				 * String sqlPayment=
				 * "select a.strReceiptNo,ifnull(e.intNoOfAdults,'NA'),ifnull(e.intNoOfChild,'NA'),a.strReservationNo ,c.strBillNo,ifnull(e.strRoomType,'NA') "
				 * +
				 * ",DATE_FORMAT(g.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(g.dteDepartureDate,'%d-%m-%Y'),ifnull(f.strFirstName,'NA'),ifnull(f.strMiddleName,'NA')"
				 * +
				 * ",ifnull(f.strLastName,'NA'),d.strSettlementDesc,a.dblPaidAmt,b.strRemarks,DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y') "
				 * +
				 * "from tblreceipthd a left outer join  tblreceiptdtl b on a.strReceiptNo=b.strReceiptNo "
				 * +
				 * "left outer join tblbillhd c on a.strRegistrationNo=c.strRegistrationNo  "
				 * +
				 * "left outer join  tblsettlementmaster d on b.strSettlementCode=d.strSettlementCode "
				 * +
				 * "left outer join tblreservationdtl e on a.strReservationNo=e.strReservationNo "
				 * +
				 * "left outer join tblreservationhd g on a.strReservationNo=g.strReservationNo "
				 * +
				 * "left outer join tblguestmaster f on e.strGuestCode=f.strGuestCode "
				 * +"where a.strReceiptNo='"+reciptNo+"' and a.strClientCode='"+
				 * clientCode+"'  ";
				 */

				String sqlPayment = " select a.strReceiptNo ,ifnull(c.intNoOfAdults,''),ifnull(c.intNoOfChild,''),a.strReservationNo,e.strBillNo, " 
						+ " ifnull(j.strRoomTypeDesc,'') ,DATE_FORMAT(c.dteArrivalDate,'%d-%m-%Y'), DATE_FORMAT(c.dteDepartureDate,'%d-%m-%Y'), " 
						+ " ifnull(h.strFirstName,''), ifnull(h.strMiddleName,''),ifnull(h.strLastName,''), "
						+ " f.strSettlementDesc,a.dblPaidAmt,b.strRemarks, DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y') " 
						+ " from tblreceipthd a ,tblreceiptdtl b,tblcheckinhd c ,tblcheckindtl d ,tblbillhd e , " + " tblsettlementmaster f ,tblguestmaster h, tblroom i,tblroomtypemaster j " 
						+ " where a.strReceiptNo=b.strReceiptNo and a.strCheckInNo =c.strCheckInNo  "
						+ " and c.strCheckInNo=d.strCheckInNo   and a.strReservationNo =c.strReservationNo " 
						+ " and a.strCheckInNo = e.strCheckInNo    " 
						+ " and a.strReservationNo =e.strReservationNo " 
						+ " and d.strCheckInNo = e.strCheckInNo    " 
						+ " and c.strCheckInNo = e.strCheckInNo  and d.strRoomNo = e.strRoomNo " 
						+ "  and d.strRoomNo = i.strRoomCode and i.strRoomTypeCode=j.strRoomTypeCode "
						+ " and b.strSettlementCode=f.strSettlementCode and d.strGuestCode=h.strGuestCode " 
						+ " and a.strReceiptNo='" + reciptNo + "' and a.strClientCode='" + clientCode + "'  AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'  AND f.strClientCode='"+clientCode+"' AND h.strClientCode='"+clientCode+"' AND i.strClientCode='"+clientCode+"' AND j.strClientCode='"+clientCode+"'"
								+ " group by a.strReceiptNo ";

				List listOfPayment = objGlobalFunctionsService.funGetDataList(sqlPayment, "sql");

				for (int i = 0; i < listOfPayment.size(); i++) {
					Object PaymentData[] = (Object[]) listOfPayment.get(i);

					String strReceiptNo = PaymentData[0].toString();
					String intNoOfAdults = PaymentData[1].toString();
					String intNoOfChild ; 
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						intNoOfChild=null;
					}
					else
					{
						intNoOfChild = PaymentData[2].toString();
					}
					String strReservationNo = PaymentData[3].toString();
					String strBillNo = PaymentData[4].toString();
					String strRoomType = PaymentData[5].toString();
					String dteArrivalDate = PaymentData[6].toString();
					String dteDepartureDate = PaymentData[7].toString();
					String strFirstName = PaymentData[8].toString();
					String strMiddleName = PaymentData[9].toString();
					String strLastName = PaymentData[10].toString();
					String strSettlementDesc = PaymentData[11].toString();
					String dblPaidAmt = PaymentData[12].toString();
					String strRemarks = PaymentData[13].toString();
					String dteReciptDate = PaymentData[14].toString();
					String dteModifiedDate = PaymentData[14].toString();

					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrReceiptNo(strReceiptNo);
					objPaymentReciptBean.setIntNoOfAdults(intNoOfAdults);
					objPaymentReciptBean.setIntNoOfChild(intNoOfChild);
					objPaymentReciptBean.setStrReservationNo(strReservationNo);
					objPaymentReciptBean.setStrRoomType(strRoomType);
					objPaymentReciptBean.setDteArrivalDate(dteArrivalDate);
					objPaymentReciptBean.setDteDepartureDate(dteDepartureDate);
					objPaymentReciptBean.setStrFirstName(strFirstName+" ");
					objPaymentReciptBean.setStrMiddleName(strMiddleName+" ");
					objPaymentReciptBean.setStrLastName(strLastName);
					objPaymentReciptBean.setStrSettlementDesc(strSettlementDesc);
					objPaymentReciptBean.setDblPaidAmt(dblPaidAmt);
					objPaymentReciptBean.setStrRemarks(strRemarks);
					objPaymentReciptBean.setDteReciptDate(dteReciptDate);
					objPaymentReciptBean.setDteModifiedDate(dteModifiedDate);
					objPaymentReciptBean.setStrBillNo(strBillNo);
					datalist.add(objPaymentReciptBean);
				}
			}
			else if(checkAgainst.equalsIgnoreCase("Deposit"))
			{

 				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptDepositPaymentRecipt.jrxml");

 				String sqlPayment = "SELECT a.strReceiptNo, IFNULL(c.intNoOfAdults,''), IFNULL(c.intNoOfChild,''),"
 						+ " IFNULL(a.strReservationNo,''),IFNULL(c.strCheckInNo,''), IFNULL(g.strRoomTypeDesc,''),"
 						+ " IFNULL(DATE_FORMAT(c.dteArrivalDate,'%d-%m-%Y'),''),IFNULL( DATE_FORMAT(c.dteDepartureDate,'%d-%m-%Y'),''), "
 						+ " IFNULL(f.strFirstName,''), IFNULL(f.strMiddleName,''), IFNULL(f.strLastName,''),IFNULL(d.strSettlementDesc,''),a.dblPaidAmt,IFNULL( b.strRemarks,''),"
 						+ " IFNULL(DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y'),''), IFNULL(h.strRoomDesc,'')"
 						+ " FROM tblreceipthd a"
 						+ " LEFT OUTER"
 						+ " JOIN tblreceiptdtl b ON a.strReceiptNo=b.strReceiptNo AND a.strClientCode='"+clientCode+"'"
 						+ " LEFT OUTER"
 						+ " JOIN tblguestmaster f ON f.strGuestCode=b.strCustomerCode "
 						+ " LEFT OUTER"
 						+ " JOIN tblcheckinhd c ON a.strRegistrationNo=c.strRegistrationNo AND b.strClientCode='"+clientCode+"'"
 						+ " LEFT OUTER"
 						+ " JOIN tblcheckindtl e ON a.strCheckInNo=e.strCheckInNo AND c.strClientCode='"+clientCode+"'"
 						+ " LEFT OUTER"
 						+ " JOIN tblroomtypemaster g ON g.strRoomTypeCode=e.strRoomType AND e.strClientCode='"+clientCode+"'"
 						+ "  LEFT OUTER"
 						+ " JOIN tblroom h ON e.strRoomNo=h.strRoomCode AND g.strClientCode='"+clientCode+"'"
 						+ " LEFT OUTER"
 						+ " JOIN tblsettlementmaster d ON b.strSettlementCode=d.strSettlementCode AND f.strClientCode='"+clientCode+"'"
 						+ " AND d.strClientCode='"+clientCode+"'"
 						+ " WHERE a.strReceiptNo='"+reciptNo+"' and a.strType='Deposit' "
 						+ " GROUP BY a.strReceiptNo";
				List listOfPayment = objGlobalFunctionsService.funGetDataList(sqlPayment, "sql");

				for (int i = 0; i < listOfPayment.size(); i++) {
					Object PaymentData[] = (Object[]) listOfPayment.get(i);
					
					String strCGS;
					String strSGST;
					String strReceiptNo = PaymentData[0].toString();
					String intNoOfAdults = PaymentData[1].toString();
					String intNoOfChild = PaymentData[2].toString();
					String strReservationNo = PaymentData[3].toString();
					String strCheckInNo = PaymentData[4].toString();
					String strRoomType = PaymentData[5].toString();
					String dteArrivalDate = PaymentData[6].toString();
					String dteDepartureDate = PaymentData[7].toString();
					String strFirstName = PaymentData[8].toString();
					String strMiddleName = PaymentData[9].toString();
					String strLastName = PaymentData[10].toString();
					String strSettlementDesc = PaymentData[11].toString();
					String dblPaidAmt = PaymentData[12].toString();
					String strRemarks = PaymentData[13].toString();
					String dteReciptDate = PaymentData[14].toString();
					String dteModifiedDate = PaymentData[14].toString();
					String strRoomDesc = PaymentData[15].toString();
					
					reportParams.put("pstrRoomDesc", strRoomDesc);
					
					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrReceiptNo(strReceiptNo);
					objPaymentReciptBean.setIntNoOfAdults(intNoOfAdults);
					objPaymentReciptBean.setIntNoOfChild(intNoOfChild);
					objPaymentReciptBean.setStrReservationNo(strReservationNo);
					objPaymentReciptBean.setStrRoomType(strRoomType);
					objPaymentReciptBean.setDteArrivalDate(dteArrivalDate);
					objPaymentReciptBean.setDteDepartureDate(dteDepartureDate);
					objPaymentReciptBean.setStrFirstName(strFirstName+" ");
					objPaymentReciptBean.setStrMiddleName(strMiddleName+" ");
					objPaymentReciptBean.setStrLastName(strLastName);
					objPaymentReciptBean.setStrSettlementDesc(strSettlementDesc);
					objPaymentReciptBean.setDblPaidAmt(dblPaidAmt);
					objPaymentReciptBean.setStrRemarks(strRemarks);
					objPaymentReciptBean.setDteReciptDate(dteReciptDate);
					objPaymentReciptBean.setDteModifiedDate(dteModifiedDate);
					objPaymentReciptBean.setStrCheckInNo(strCheckInNo);
					datalist.add(objPaymentReciptBean);
				}
			
			}
			
			else {
 				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptCheckInPaymentRecipt.jrxml");

 				String sqlPayment = "SELECT a.strReceiptNo, IFNULL(c.intNoOfAdults,''), "
						+ "IFNULL(c.intNoOfChild,''), a.strReservationNo,c.strCheckInNo, "
						+ "IFNULL(g.strRoomTypeDesc,''),  DATE_FORMAT(c.dteArrivalDate,'%d-%m-%Y'), "
						+ "DATE_FORMAT(c.dteDepartureDate,'%d-%m-%Y'),   IFNULL(f.strFirstName,''), "
						+ "IFNULL(f.strMiddleName,''), IFNULL(f.strLastName,''),   "
						+ "IFNULL(d.strSettlementDesc,''),a.dblPaidAmt, b.strRemarks, "
						+ "DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y'),ifnull(h.strRoomDesc,'') "
						+ "FROM tblreceipthd a "
						+ "LEFT OUTER JOIN tblreceiptdtl b ON a.strReceiptNo=b.strReceiptNo AND a.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblcheckinhd c ON a.strRegistrationNo=c.strRegistrationNo AND b.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblcheckindtl e ON a.strCheckInNo=e.strCheckInNo AND c.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblroomtypemaster g ON g.strRoomTypeCode=e.strRoomType AND e.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblroom h ON e.strRoomNo=h.strRoomCode AND g.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblguestmaster f ON e.strGuestCode=f.strGuestCode AND h.strClientCode='"+clientCode+"'"
						+ "LEFT OUTER JOIN tblsettlementmaster d ON b.strSettlementCode=d.strSettlementCode AND f.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"'"
						+ "WHERE a.strReceiptNo='"+reciptNo+"'"
						+ " group by a.strReceiptNo ";
				List listOfPayment = objGlobalFunctionsService.funGetDataList(sqlPayment, "sql");

				for (int i = 0; i < listOfPayment.size(); i++) {
					Object PaymentData[] = (Object[]) listOfPayment.get(i);
					
					String strCGS;
					String strSGST;
					String strReceiptNo = PaymentData[0].toString();
					String intNoOfAdults = PaymentData[1].toString();
					String intNoOfChild = PaymentData[2].toString();
					String strReservationNo = PaymentData[3].toString();
					String strCheckInNo = PaymentData[4].toString();
					String strRoomType = PaymentData[5].toString();
					String dteArrivalDate = PaymentData[6].toString();
					String dteDepartureDate = PaymentData[7].toString();
					String strFirstName = PaymentData[8].toString();
					String strMiddleName = PaymentData[9].toString();
					String strLastName = PaymentData[10].toString();
					String strSettlementDesc = PaymentData[11].toString();
					String dblPaidAmt = PaymentData[12].toString();
					String strRemarks = PaymentData[13].toString();
					String dteReciptDate = PaymentData[14].toString();
					String dteModifiedDate = PaymentData[14].toString();
					String strRoomDesc = PaymentData[15].toString();
					
					reportParams.put("pstrRoomDesc", strRoomDesc);
					
					clsPaymentReciptBean objPaymentReciptBean = new clsPaymentReciptBean();
					objPaymentReciptBean.setStrReceiptNo(strReceiptNo);
					objPaymentReciptBean.setIntNoOfAdults(intNoOfAdults);
					objPaymentReciptBean.setIntNoOfChild(intNoOfChild);
					objPaymentReciptBean.setStrReservationNo(strReservationNo);
					objPaymentReciptBean.setStrRoomType(strRoomType);
					objPaymentReciptBean.setDteArrivalDate(dteArrivalDate);
					objPaymentReciptBean.setDteDepartureDate(dteDepartureDate);
					objPaymentReciptBean.setStrFirstName(strFirstName+" ");
					objPaymentReciptBean.setStrMiddleName(strMiddleName+" ");
					objPaymentReciptBean.setStrLastName(strLastName);
					objPaymentReciptBean.setStrSettlementDesc(strSettlementDesc);
					objPaymentReciptBean.setDblPaidAmt(dblPaidAmt);
					objPaymentReciptBean.setStrRemarks(strRemarks);
					objPaymentReciptBean.setDteReciptDate(dteReciptDate);
					objPaymentReciptBean.setDteModifiedDate(dteModifiedDate);
					objPaymentReciptBean.setStrCheckInNo(strCheckInNo);
					datalist.add(objPaymentReciptBean);
				}
			}

			JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(datalist);
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
				resp.setHeader("Content-Disposition", "inline;filename=PaymentRecipt.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	// Open Payment
	@RequestMapping(value = "/frmPMSPaymentAdvanceAmount", method = RequestMethod.GET)
	public ModelAndView funOpenMSPaymentAdvanceAmount(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";

		List<String> listAgainst = new ArrayList<>();
		listAgainst.add("Reservation");
		listAgainst.add("Folio-No");
		listAgainst.add("Bill");
		
		String AdvAmount = request.getParameter("AdvAmount").toString();
		// String checkAgainst=request.getParameter("checkAgainst").toString();
		double dblBalanceAmt=0.0;
		if(AdvAmount.charAt(2)=='R')
		{
			String sqlReservation="select ifnull(sum(a.dblIncomeHeadAmt),0)-ifnull(b.dblReceiptAmt,0) from tblroompackagedtl a left outer join  tblreceipthd b   on  a.strReservationNo=b.strReservationNo "
					 +" where a.strReservationNo='"+AdvAmount+"'  group by a.strReservationNo " ;
			List listResevation = objGlobalFunctionsService.funGetDataList(sqlReservation, "sql");
			if (listResevation.size()>0) 
			{
				dblBalanceAmt=Double.parseDouble(listResevation.get(0).toString());
			}
			else
			{
				/*sqlReservation="select ifnull(a.dblRoomRate,0)-ifnull(b.dblReceiptAmt,0) from tblreservationroomratedtl a left outer join  tblreceipthd b   on  a.strReservationNo=b.strReservationNo "
						 +" where a.strReservationNo='"+AdvAmount+"'  group by a.strReservationNo " ;
				listResevation = objGlobalFunctionsService.funGetDataList(sqlReservation, "sql");

				if (listResevation.size()>0) 
				{
					dblBalanceAmt=Double.parseDouble(listResevation.get(0).toString());
				}*/
				dblBalanceAmt=0.00;
			}
		}
		if(AdvAmount.charAt(2)=='C'){
			
			/*String sqlCheckIn = "SELECT a.dblRoomTerrif FROM tblroomtypemaster a,tblcheckindtl  b "
			 		+ "WHERE b.strCheckInNo = '"+AdvAmount+"' and a.strRoomTypeCode=b.strRoomType";*/
			String strType="";
			String sqlCheckIn="";
			String resCode="";
			if(request.getSession().getAttribute("reservationCode")!=null)
			{
			    resCode=request.getSession().getAttribute("reservationCode").toString();
				request.getSession().removeAttribute("reservationCode");
			}
			
			if(request.getParameter("against")!=null)
			{
				strType=request.getParameter("against").toString();
			}
			
			if( strType.equalsIgnoreCase("Reservation"))
			{

				 sqlCheckIn = "SELECT  d.roomRate -  e.PaidAmt FROM "
				 		+ " (SELECT IFNULL(SUM(a.dblRoomRate),0) AS roomRate"
				 		+ " FROM tblreservationroomratedtl a,tblcheckinhd b,tblcheckindtl c"
				 		+ " WHERE a.strReservationNo=b.strReservationNo AND b.strCheckInNo=c.strCheckInNo "
				 		+ " AND b.strCheckInNo = '"+AdvAmount+"') d,"
				 		+ " (SELECT IFNULL(a.dblReceiptAmt,0) AS PaidAmt FROM tblcheckinhd b"
				 		+ " LEFT OUTER JOIN  tblreceipthd a ON b.strReservationNo=a.strReservationNo "
				 		+ " WHERE b.strReservationNo='"+resCode+"') e;" ;
			}
			else
			{
				sqlCheckIn =" SELECT sum(a.dblRoomRate) "
						+ " FROM tblwalkinroomratedtl a,tblcheckinhd b ,tblcheckindtl c"
						+ " WHERE a.strWalkinNo=b.strWalkInNo  and b.strCheckInNo=c.strCheckInNo  and b.strCheckInNo = '"+AdvAmount+"' " ;
			}
			/*String sqlCheckIn = "SELECT c.dblRoomRate FROM tblroomtypemaster a,tblcheckindtl b,tblreservationroomratedtl c,tblcheckinhd d"
					+ "	WHERE b.strCheckInNo = '"+AdvAmount+"' AND a.strRoomTypeCode=b.strRoomType and a.strRoomTypeCode=c.strRoomType and d.strReservationNo=c.strReservationNo "
							+ " and a.strClientCode=b.strClientCode and b.strClientCode=c.strClientCode and c.strClientCode=d.strClientCode";
		*/			
			/*String sqlCheckIn="SELECT ifnull(ROUND(dblRoomRate-(temp2.dblRoomRate*temp2.dblDiscount)/100+ SUM(d.dblTaxAmt)),0) FROM "
					+ "( SELECT temp.dblRoomRate,temp.dblDiscount,c.strFolioNo FROM ( SELECT b.dblRoomRate,b.dblDiscount,a.strCheckInNo FROM tblcheckinhd a "
					+ "LEFT OUTER JOIN tblwalkinroomratedtl b ON b.strWalkinNo=a.strWalkInNo WHERE a.strCheckInNo='"+AdvAmount+"') temp "
					+ ",tblfoliohd c WHERE temp.strCheckInNo=c.strCheckInNo) temp2,tblfoliotaxdtl d "
					+ "WHERE temp2.strFolioNo=d.strFolioNo";*/
			List listResevation = objGlobalFunctionsService.funGetDataList(sqlCheckIn, "sql");
			if (listResevation.size()>0) 
			{
				dblBalanceAmt=Double.parseDouble(listResevation.get(0).toString());
			}
			 listAgainst.add(0, "Check-In");
		}
		request.setAttribute("code", AdvAmount);
		request.setAttribute("dblBalanceAmt", dblBalanceAmt);
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		model.put("listAgainst", listAgainst);

		if (urlHits.equalsIgnoreCase("1")) {

			return new ModelAndView("frmPMSPayment", "command", new clsPMSPaymentBean());
		} else {
			return new ModelAndView("frmPMSPayment_1", "command", new clsPMSPaymentBean());
		}
	}

	private void funSendSMSPayment(String paymentNo, String clientCode, String propCode) {

		String strMobileNo = "";
		clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
		String settleDesc = "";
		String strGuesCode = "";
		clsPMSPaymentHdModel modelData = objDao.funGetPaymentModel(paymentNo, clientCode);

		List listPayemntDtl = modelData.getListPaymentRecieptDtlModel();
		clsPMSPaymentReceiptDtl objPaymentReceiptDtl = (clsPMSPaymentReceiptDtl) listPayemntDtl.get(0);

		List listSettle = objtPMSSettlement.funGetPMSSettlementMaster(objPaymentReceiptDtl.getStrSettlementCode(), clientCode);
		if (listSettle.size() > 0) {
			clsPMSSettlementMasterHdModel objSettlemode = (clsPMSSettlementMasterHdModel) listSettle.get(0);
			settleDesc = objSettlemode.getStrSettlementDesc();
		}
		if (modelData.getStrAgainst().equalsIgnoreCase("Reservation")) {
			clsReservationHdModel objModel = objReservationService.funGetReservationList(modelData.getStrReservationNo(), clientCode, propCode);
			List<clsReservationDtlModel> listReservationmodel = objModel.getListReservationDtlModel();

			if (listReservationmodel.size() > 0) {
				for (int i = 0; i < listReservationmodel.size(); i++) {
					clsReservationDtlModel objDtl = listReservationmodel.get(i);
					if (objDtl.getStrPayee().equals("Y")) {
						strGuesCode = objDtl.getStrGuestCode();
						List list = objGuestService.funGetGuestMaster(objDtl.getStrGuestCode(), clientCode);
						clsGuestMasterHdModel objGuestModel = null;

						if (list.size() > 0) {
							objGuestModel = (clsGuestMasterHdModel) list.get(0);
						}
						String smsAPIUrl = objSetup.getStrSMSAPI();
						String smsContent = objSetup.getStrAdvAmtSMSContent();
						if (!smsAPIUrl.equals("")) {
							if (smsContent.contains("%%CompanyName")) {
								List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
								smsContent = smsContent.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName());
							}
							if (smsContent.contains("%%PropertyName")) {
								clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
								smsContent = smsContent.replace("%%PropertyName", objProperty.getPropertyName());
							}
							if (smsContent.contains("%%PaymentNo")) {
								smsContent = smsContent.replace("%%RNo", paymentNo);
							}
							if (smsContent.contains("%%SettlementDesc")) {
								smsContent = smsContent.replace("%%SettlementDesc", settleDesc);
							}
							if (smsContent.contains("%%GuestName")) {
								smsContent = smsContent.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
							}
							if (smsContent.contains("%%Amount")) {
								smsContent = smsContent.replace("%%Amount", String.valueOf(modelData.getDblPaidAmt()));
							}

							if (smsContent.contains("%%RoomNo")) {
								clsRoomMasterModel roomNo = objRoomMaster.funGetRoomMaster(objModel.getStrRoomNo(), clientCode);
								smsContent = smsContent.replace("%%RoomNo", roomNo.getStrRoomDesc());
							}

							if (smsAPIUrl.contains("ReceiverNo")) {

								smsAPIUrl = smsAPIUrl.replace("ReceiverNo", String.valueOf(objGuestModel.getLngMobileNo()));
								strMobileNo = String.valueOf(objGuestModel.getLngMobileNo());
							}
							if (smsAPIUrl.contains("MsgContent")) {
								smsAPIUrl = smsAPIUrl.replace("MsgContent", smsContent);
								smsAPIUrl = smsAPIUrl.replace(" ", "%20");
							}

							URL url;
							HttpURLConnection uc = null;
							StringBuilder output = new StringBuilder();

							try {
								url = new URL(smsAPIUrl);
								uc = (HttpURLConnection) url.openConnection();
								if (String.valueOf(objGuestModel.getLngMobileNo()).length() >= 10) {
									BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), Charset.forName("UTF-8")));
									String inputLine;
									while ((inputLine = in.readLine()) != null) {
										output.append(inputLine);
									}
									in.close();
								}

							} catch (Exception e) {
								e.printStackTrace();
							} finally {
								uc.disconnect();
							}
						}
					}
				}
			}
		}

		if (modelData.getStrAgainst().equalsIgnoreCase("Folio-No")) {
			clsFolioHdModel objFolioModel = objFolioService.funGetFolioList(modelData.getStrFolioNo(), clientCode, propCode);

			clsCheckInHdModel objHdModel = objCheckInService.funGetCheckInData(objFolioModel.getStrCheckInNo().toString(), clientCode);
			clsCheckInDtl objDtlModel = null;

			List listcheckIn = objHdModel.getListCheckInDtl();
			String smsAPIUrl = objSetup.getStrSMSAPI();
			String smsContent = objSetup.getStrAdvAmtSMSContent();
			if (listcheckIn.size() > 0) {
				for (int i = 0; i < listcheckIn.size(); i++) {
					clsCheckInDtl objDtl = (clsCheckInDtl) listcheckIn.get(i);
					if (objDtl.getStrPayee().equals("Y")) {
						List list1 = objGuestService.funGetGuestMaster(objDtl.getStrGuestCode(), clientCode);
						clsGuestMasterHdModel objGuestModel = null;
						if (list1.size() > 0) {
							objGuestModel = (clsGuestMasterHdModel) list1.get(0);
						}
						if (smsContent.contains("%%GuestName")) {
							smsContent = smsContent.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
						}
						if (smsContent.contains("%%CompanyName")) {
							List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
							smsContent = smsContent.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName());
						}
						if (smsContent.contains("%%PropertyName")) {
							clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
							smsContent = smsContent.replace("%%PropertyName", objProperty.getPropertyName());
						}
						if (smsContent.contains("%%PaymentNo")) {
							smsContent = smsContent.replace("%%RNo", paymentNo);
						}
						if (smsContent.contains("%%SettlementDesc")) {
							smsContent = smsContent.replace("%%SettlementDesc", settleDesc);
						}
						if (smsContent.contains("%%GuestName")) {
							smsContent = smsContent.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
						}
						if (smsContent.contains("%%Amount")) {
							smsContent = smsContent.replace("%%Amount", String.valueOf(modelData.getDblPaidAmt()));
						}
						if (smsContent.contains("%%RoomNo")) {
							clsRoomMasterModel roomNo = objRoomMaster.funGetRoomMaster(objDtl.getStrRoomNo(), clientCode);
							smsContent = smsContent.replace("%%RoomNo", roomNo.getStrRoomDesc());
						}

						if (smsAPIUrl.contains("ReceiverNo")) {

							smsAPIUrl = smsAPIUrl.replace("ReceiverNo", String.valueOf(objGuestModel.getLngMobileNo()));
							strMobileNo = String.valueOf(objGuestModel.getLngMobileNo());
						}
						if (smsAPIUrl.contains("MsgContent")) {
							smsAPIUrl = smsAPIUrl.replace("MsgContent", smsContent);
							smsAPIUrl = smsAPIUrl.replace(" ", "%20");
						}
						URL url;
						HttpURLConnection uc = null;
						StringBuilder output = new StringBuilder();
						try {
							url = new URL(smsAPIUrl);
							uc = (HttpURLConnection) url.openConnection();
							if (String.valueOf(objGuestModel.getLngMobileNo()).length() >= 10) {
								BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream(), Charset.forName("UTF-8")));
								String inputLine;
								while ((inputLine = in.readLine()) != null) {
									output.append(inputLine);
								}
								in.close();
							}

						} catch (Exception e) {
							e.printStackTrace();
						} finally {
							uc.disconnect();
						}
					}
				}
			}

		}

		if (modelData.getStrAgainst().equalsIgnoreCase("BillNo")) {

		}

	}
}
