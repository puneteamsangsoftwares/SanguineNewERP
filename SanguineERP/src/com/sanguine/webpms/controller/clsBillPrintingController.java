package com.sanguine.webpms.controller;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.crm.bean.clsInvoiceDtlBean;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.util.clsNumberToWords;
import com.sanguine.webpms.bean.clsBillPrintingBean;
import com.sanguine.webpms.bean.clsFolioPrintingBean;
import com.sanguine.webpms.bean.clsInvoiceFormatBean;
import com.sanguine.webpms.bean.clsVoidBillBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsPropertySetupService;

@Controller
public class clsBillPrintingController {
	@Autowired
	private clsFolioService objFolioService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private ServletContext servletContext;

	@Autowired
	private clsSetupMasterService objSetupMasterService;

	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

	@Autowired
	private clsPropertySetupService objPropertySetupService;
	
	@Autowired
	private intfBaseService objBaseService;

	// Open Folio Printing
	@RequestMapping(value = "/frmBillPrinting", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model,
			HttpServletRequest request) {
		String urlHits = "1";
		String strBillNo="";
		
		if(request.getParameter("docCode")==null)
		{
			strBillNo="";
			request.getSession().setAttribute("BillNo", strBillNo);
		}
		else
		{
			strBillNo = request.getParameter("docCode").toString();
			request.getSession().setAttribute("BillNo", strBillNo);
		}
		
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmBillPrinting_1", "command",new clsBillPrintingBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmBillPrinting", "command",new clsBillPrintingBean());
		} else {
			return null;
		}
	}

	// Save folio posting
	@RequestMapping(value = "/rptBillPrinting", method = RequestMethod.GET)
	public void funGenerateBillPrintingReport(@RequestParam("fromDate") String fromDate,@RequestParam("toDate") String toDate,
			@RequestParam("billNo") String billNo,@RequestParam("strSelectBill") String strSelectBill, HttpServletRequest req,HttpServletResponse resp) 
	{
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		
		if(clientCode.equalsIgnoreCase("383.001"))
		{
			funGenerateBillPrintingReportFormat1(fromDate, toDate, billNo, strSelectBill, req, resp);
		}
		else
		{
			
		
		try 
		{
			boolean flgBillRecord = false;
			String registrationNo = "";
			String reservationNo = "";
			double balance = 0.0;
			String GSTNo = "", companyName = "";
			String folio="";
			
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			
			String temp[] ={};
			if(strSelectBill.length()>0)
			{
				temp = strSelectBill.split(",");
			}
			
			String billNames = "";
			String pSupportVoucher="";
			String pSupportVoucherTextFielf="";
			double pRoomTariff=0.0;
			double dblTotalRoomTarrif = 0.0;
			int count=0;
			for (int i = 0; i < temp.length; i++) {
				if (billNames.length()>=0) {
					billNames+="'"+temp[i]+"',";
				}
			}
			
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode); // mms
																			// property
																			// setup
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}

			String reportName = servletContext
					.getRealPath("/WEB-INF/reports/webpms/rptBillPrinting.jrxml");
			String imagePath = servletContext
					.getRealPath("/resources/images/company_Logo.png");

			List<clsBillPrintingBean> dataList = new ArrayList<clsBillPrintingBean>();
			@SuppressWarnings("rawtypes")
			HashMap reportParams = new HashMap();
			Map<String,clsBillPrintingBean> hmTax=new HashMap<>();
			Map<String,clsBillPrintingBean> hmParticulars=new HashMap<>();
			// get all parameters
			/*
			 * String sqlParametersFromBill =
			 * "SELECT a.strFolioNo,a.strRoomNo,a.strRegistrationNo,a.strReservationNo"
			 * + " ,b.dteArrivalDate,b.tmeArrivalTime " +
			 * ",ifnull(b.dteDepartureDate,'NA'),ifnull(b.tmeDepartureTime,'NA') "
			 * +
			 * " ,ifnull(d.strGuestPrefix,''),ifnull(d.strFirstName,''),ifnull(d.strMiddleName,''),ifnull(d.strLastName,'') "
			 * + ",b.intNoOfAdults,b.intNoOfChild" + " ,a.strBillNo " +
			 * " FROM tblbillhd a LEFT OUTER JOIN tblreservationhd b ON a.strReservationNo=b.strReservationNo "
			 * +
			 * " LEFT OUTER JOIN tblreservationdtl c ON b.strReservationNo=c.strReservationNo AND a.strRoomNo=c.strRoomNo "
			 * +
			 * " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode "
			 * + " where a.strBillNo='" + billNo + "' ";
			 */

			List<String> listCheckInNo = new ArrayList<>();
			String checkInNo = "";
			String sqlParametersFromBill = " SELECT a.strFolioNo,e.strRoomDesc,a.strRegistrationNo,a.strReservationNo ,date(b.dteArrivalDate),b.tmeArrivalTime , "
					+ " ifnull(date(b.dteDepartureDate),'NA'),ifnull(b.tmeDepartureTime,'NA')  , ifnull(d.strGuestPrefix,''), "
					+ " ifnull(d.strFirstName,''),ifnull(d.strMiddleName,''),ifnull(d.strLastName,'') , "
					+ " b.intNoOfAdults,b.intNoOfChild ,a.strBillNo ,IFNULL(d.strGuestCode,''),a.strGSTNo,a.strCompanyName,b.strCheckInNo,c.strPayee"// 17
					+ " FROM tblbillhd a  "
					+ " LEFT OUTER JOIN tblcheckinhd  b ON a.strCheckInNo=b.strCheckInNo "
					+ " LEFT OUTER JOIN tblcheckindtl c ON b.strCheckInNo=c.strCheckInNo AND a.strRoomNo=c.strRoomNo  "
					+ " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode  "
					+ " LEFT OUTER JOIN tblroom e ON e.strRoomCode=a.strRoomNo "
					+ "where a.strBillNo='"
					+ billNo
					+ "' and a.strClientCode='"+clientCode+"' and b.strClientCode='"+clientCode+"' and c.strClientCode='"+clientCode+"' "
					+ "and d.strClientCode='"+clientCode+"' and e.strClientCode='"+clientCode+"'"
					+ " order by c.strPayee DESC ";

			List listOfParametersFromBill = objFolioService
					.funGetParametersList(sqlParametersFromBill);

			if (listOfParametersFromBill.size() > 0) {
				Object[] arr = (Object[]) listOfParametersFromBill.get(0);

				// String guestcode =
				// objGuestMaster.funAddUpdateGuestMaster(objGuestMasterModel);

				String guestDtl = " select ifnull(d.strDefaultAddr,''),ifnull(d.strAddressLocal,''),ifnull(d.strCityLocal,''),ifnull(d.strStateLocal,''),ifnull(d.strCountryLocal,''),IFNULL(d.intPinCodeLocal,''),"// 20
						+ " ifnull(d.strAddrPermanent,''),ifnull(d.strCityPermanent,''),ifnull(d.strStatePermanent,''),ifnull(d.strCountryPermanent,''),IFNULL(d.intPinCodePermanent,''), "// 25
						+ " ifnull(d.strAddressOfc,''),ifnull(d.strCityOfc,''),ifnull(d.strStateOfc,''),ifnull(d.strCountryOfc,''),IFNULL(d.intPinCodeOfc,''),IFNULL(d.strGSTNo,''),IFNULL(d.lngMobileNo,0) "
						+ "from tblguestmaster d where d.strGuestCode=  '"
						+ arr[15].toString() + "' AND d.strClientCode='"+clientCode+"'";
				List listguest = objFolioService.funGetParametersList(guestDtl);
				// '"+arr[15].toString()+"'
				String guestgstNO = "";
				String strCustNo="";
				for (int i = 0; i < listguest.size(); i++) {
					Object[] arGuest = (Object[]) listguest.get(i);
					guestgstNO = arGuest[16].toString();
					strCustNo = arGuest[17].toString();
				}
				folio = arr[0].toString();
				String roomNo = arr[1].toString();
				registrationNo = arr[2].toString();
				reservationNo = arr[3].toString();
				String arrivalDate = arr[4].toString();
				String arrivalTime = arr[5].toString();
				String departureDate = arr[6].toString();
				String departureTime = arr[7].toString();
				String gPrefix = arr[8].toString();
				String strPayee = arr[19].toString();
				String gFirstName = arr[9].toString();
				String gMiddleName = arr[10].toString();
				String gLastName = arr[11].toString();
				String adults = arr[12].toString();
				String childs = arr[13].toString();
				checkInNo  = arr[18].toString();
				
				listCheckInNo.add(checkInNo);
				if (!arr[16].toString().equals("")) {
					GSTNo = arr[16].toString();
				}
				if (!arr[17].toString().equals("")) {
					companyName = arr[17].toString();
				}
				String guestAddr = "";
				String guestCompanyAddress = "";
				if (listguest.size() > 0) {
					Object[] arrGuest = (Object[]) listguest.get(0);
					if (arrGuest[0].toString().equalsIgnoreCase("Permanent")) { // check
																				// default
																				// addr
						guestAddr = arrGuest[6].toString() + ","
								+ arrGuest[7].toString() + ","
								+ arrGuest[8].toString() + ","
								+ arrGuest[9].toString() + ","
								+ arrGuest[10].toString();
					} else if (arrGuest[0].toString()
							.equalsIgnoreCase("Office")) {
						guestAddr = arrGuest[11].toString() + ","
								+ arrGuest[12].toString() + ","
								+ arrGuest[13].toString() + ","
								+ arrGuest[14].toString() + ","
								+ arrGuest[15].toString();
					} else { // Local
						guestAddr = arrGuest[1].toString() + ","
								+ arrGuest[2].toString() + ","
								+ arrGuest[3].toString() + ","
								+ arrGuest[4].toString() + ","
								+ arrGuest[5].toString();
					}
					
					guestCompanyAddress = arrGuest[11].toString() + ","
							+ arrGuest[12].toString() + ","
							+ arrGuest[13].toString() + ","
							+ arrGuest[14].toString() + ","
							+ arrGuest[15].toString();
				}
				
				
				/*//Printing Opening Balance
				
				clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
				double debitAmt = Double.parseDouble(arr[16].toString());
				double creditAmt = 0.00;
				double bal = debitAmt - creditAmt;
				
                
				folioPrintingBean.setDteDocDate(" ");
				folioPrintingBean.setStrDocNo(" ");
				folioPrintingBean.setStrPerticulars("Opening Balance");
				String sqlguest="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+arr[15].toString()+"'";
				List guestlist = objFolioService.funGetParametersList(sqlguest);
				double closingBal=0.00;
				for(int j=0;j<guestlist.size();j++)
				{
					closingBal=Double.parseDouble(guestlist.get(0).toString());
					if(closingBal>0)
					{
						folioPrintingBean.setDblDebitAmt(closingBal);
						folioPrintingBean.setDblCreditAmt(0.00);
					}
					else
					{
						folioPrintingBean.setDblCreditAmt(closingBal);
						folioPrintingBean.setDblDebitAmt(0.00);
					}
				}
				folioPrintingBean.setDblBalanceAmt(bal);
				dataList.add(folioPrintingBean);
				*/
				
			
			    String remark="";
				String sql="SELECT a.strRemark FROM tblbilldiscount a WHERE a.strBillNo = '"+billNo+"' AND a.strClientCode='"+clientCode+"'";
				List listremark = objFolioService.funGetParametersList(sql);
				if(listremark!=null && listremark.size()>0){
					remark=listremark.get(0).toString();
				}
				// String billNo = arr[14].toString();

 				String sqlCheckOutTime = "select TIME_FORMAT(SUBSTR(a.dteDateEdited,11),'%h:%i %p') as Checkout_Time "
						+ "from tblbillhd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
 				List listCheckOutTime = objFolioService.funGetParametersList(sqlCheckOutTime);
				String chkOutTime=listCheckOutTime.get(0).toString();
				
				clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
//				String noOfRoom = objPropertySetupModel.getStrRoomLimit();.
				
				String hsnCode = objPropertySetupModel.getStrHscCode();
				String panno = objPropertySetupModel.getStrPanNo();
				String bankDtl = objPropertySetupModel.getStrBankAcName();
				String bankAcNo = objPropertySetupModel.getStrBankAcNumber();
				String bankIFSC = objPropertySetupModel.getStrBankIFSC();
				String branchnName = objPropertySetupModel.getStBranchName();
				reportParams.put("phsnCode", hsnCode);
				reportParams.put("ppanno", panno);
				reportParams.put("pbankDtl", bankDtl);
				reportParams.put("pbankAcNo", bankAcNo);
				reportParams.put("pbankIFSC", bankIFSC);
				reportParams.put("pbranchnName", branchnName);
				reportParams.put("pCompanyName", companyName);
				reportParams.put("pGSTNo", GSTNo);
				reportParams.put("pAddress1", objSetup.getStrAdd1() + ","+ objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2",objSetup.getStrState() + ","+ objSetup.getStrCountry() + ","+ objSetup.getStrPin());
				reportParams.put("pContactDetails", "");
				reportParams.put("strImagePath", imagePath);
				reportParams.put("pGuestName", gPrefix + " " + gFirstName + " "+ gMiddleName + " " + gLastName);
				reportParams.put("pFolioNo", folio);
				reportParams.put("pRoomNo", roomNo);
				reportParams.put("pRegistrationNo", registrationNo);
				reportParams.put("pReservationNo", reservationNo);
				reportParams.put("pArrivalDate",objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
				reportParams.put("pArrivalTime", arrivalTime);
				reportParams.put("pDepartureTime", chkOutTime);
				reportParams.put("pAdult", adults);
				
				reportParams.put("pGuestAddress", guestAddr);
				
				reportParams.put("strUserCode", userCode);
				reportParams.put("pBillNo", billNo);
				reportParams.put("pGuestNo", guestgstNO);
				reportParams.put("pGuestOfficeAddress", guestCompanyAddress);
				reportParams.put("pGuestNo", guestgstNO);
				reportParams.put("pstrCustNo", strCustNo);
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
				    reportParams.put("lblChild", "Remarks             :");
				    reportParams.put("pChild", remark);
				    reportParams.put("lblRemark", null);
				    reportParams.put("pRemarks",null);
				    
				    
				}
				else
				{
					reportParams.put("lblChild","Childs                 :" );
					reportParams.put("pChild", childs);
					reportParams.put("lblRemark", "Remarks             :");
					reportParams.put("pRemarks", remark);
				}
				
				if(clientCode.equalsIgnoreCase("320.001"))
				{
					String strIssue = "Issued Subject to Nashik Jurisdiction";
					String strAddr = "Mumbai Agra Road,Nashik-422009.Ph.+91253-2325000 E-mail:suryanasik@gmail.com";
					
					reportParams.put("pstrIssue", strIssue);
					reportParams.put("pstrAddr", strAddr);
				}
				
				
				// get bill details
				String sqlBillDtl="";
				if(!(billNames.length()>0))
				{
					sqlBillDtl = "SELECT DATE(b.dteDocDate),b.strDocNo,"
							+ "IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),"
							+ " b.dblDebitAmt,b.dblCreditAmt,"
							+ "b.dblBalanceAmt,ifnull(a.strReservationNo,'') ,b.strPerticulars FROM tblbillhd a INNER JOIN tblbilldtl b "
							+ "ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo "
							+ "WHERE a.strBillNo='"+billNo+"'"
							+ "group by b.strPerticulars";
				}
				else
				{
					sqlBillDtl = "SELECT DATE(b.dteDocDate),b.strDocNo,"
							+ "IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),b.dblDebitAmt,b.dblCreditAmt,"
							+ "b.dblBalanceAmt ,ifnull(a.strReservationNo,'') ,b.strPerticulars FROM tblbillhd a INNER JOIN tblbilldtl b "
							+ "ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo AND b.strPerticulars IN("+billNames.substring(0, billNames.length()-1)+") "
							+ "WHERE a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"' order by b.dblCreditAmt ,b.dteDocDate";
				}
				
				// + " and DATE(b.dteDocDate) BETWEEN '" + fromDate + "' AND '"
				// + toDate + "' ";
				List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
			String strReservationNo = "";
				for (int i = 0; i < billDtlList.size(); i++) {
					Object[] folioArr = (Object[]) billDtlList.get(i);

					String docDate = folioArr[0].toString();
					if (folioArr[1] == null) {
						continue;
					} 
					else 
					{
						dblTotalRoomTarrif=dblTotalRoomTarrif+Double.parseDouble(folioArr[3].toString());
						clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();
						String docNo = folioArr[1].toString();
						String particulars = folioArr[2].toString();
						strReservationNo = folioArr[6].toString();
						if(particulars.equalsIgnoreCase("Room Tariff"))
						{
							count++;
						}
						double debitAmount = Double.parseDouble(folioArr[3].toString());
						double creditAmount = Double.parseDouble(folioArr[4].toString());
						balance = balance + debitAmount - creditAmount;

						// String debitAmount = folioArr[3].toString();
						// String creditAmount = folioArr[4].toString();
						// String balance = folioArr[5].toString();

						billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
						billPrintingBean.setStrDocNo(docNo);
						if(folioArr[7].toString().equalsIgnoreCase("Folio Discount"))
						{
							double dblDiscPer = ((creditAmount*count)/dblTotalRoomTarrif)*100;
							particulars = particulars+" "+dblDiscPer+" %";
							billPrintingBean.setStrPerticulars(particulars);
						}
						
						else
						{
							billPrintingBean.setStrPerticulars(particulars);
						}
						billPrintingBean.setDblDebitAmt(debitAmount);
						billPrintingBean.setDblCreditAmt(creditAmount*count);
						billPrintingBean.setDblBalanceAmt(balance);
						double hmroomTariff = debitAmount; 
						
						if(strSelectBill.contains("Room Tariff"))
						{
							if(hmroomTariff>0.0)
							{
								reportParams.put("isRoomTariff", true);
							}
							else
							{
								reportParams.put("pHmRoomTariff", 0.0);
							}
						}
						else
						{
							reportParams.put("isRoomTariff", false);
						}
						
						dataList.add(billPrintingBean);
						
						if(hmParticulars.containsKey(particulars))
						{
							clsBillPrintingBean bean=hmParticulars.get(particulars);
							hmParticulars.put(particulars, bean);
						}
						else
						{
							hmParticulars.put(particulars,billPrintingBean);
						}
						
						String sqlSettlementPayment = "select a.strReceiptNo from tblreceipthd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
						List listSettlementTaxDtl = objWebPMSUtility.funExecuteQuery(sqlSettlementPayment, "sql");
						if(listSettlementTaxDtl !=null && listSettlementTaxDtl.size()<2)
						{
						if(listSettlementTaxDtl !=null && listSettlementTaxDtl.size()>0)
						{
							String strReceiptNo = listSettlementTaxDtl.get(0).toString();
							String sqlPaymentTax = "select c.strSettlementCode from tblreceiptdtl a,tblreceipthd b ,tblsettlementmaster c "
									+ "where a.strReceiptNo=b.strReceiptNo and a.strSettlementCode=c.strSettlementCode and a.strReceiptNo='"+strReceiptNo+"'";
							
							List listSettlementDescDtl = objWebPMSUtility.funExecuteQuery(sqlPaymentTax, "sql");
							if(listSettlementDescDtl!=null && listSettlementDescDtl.size()>0)
							{
								String strSettlementCode = listSettlementDescDtl.get(0).toString();
								
								String sqlTaxesAppliedOnBill = "select a.strTaxCode,a.dblTaxAmt from tblbilltaxdtl a where a.strBillNo ='"+billNo+"' and a.strClientCode='"+clientCode+"' "
										+ "group by a.strTaxCode;";
								
								List listTaxesAppliedOnBill = objWebPMSUtility.funExecuteQuery(sqlTaxesAppliedOnBill, "sql");
								if(listTaxesAppliedOnBill!=null && listTaxesAppliedOnBill.size()>0)
								{
									for( int b=0;b<listTaxesAppliedOnBill.size();b++)
									{
										Object[] obj = (Object[]) listTaxesAppliedOnBill.get(b);
										String strTaxOfBill = obj[0].toString();
										double dblTaxAmt = Double.parseDouble(obj[1].toString());
										String sqlApplicable = "select a.strApplicable from tblsettlementtax a where a.strSettlementCode='"+strSettlementCode+"' and a.strTaxCode='"+strTaxOfBill+"'";
										List listApplicable = objWebPMSUtility.funExecuteQuery(sqlApplicable, "sql");
										if(listApplicable!=null && listApplicable.size()>0)
										{
											if(listApplicable.get(0).toString().equalsIgnoreCase("N"))
											{
												funDeleteTaxesAndUpdateBillHd(strTaxOfBill,clientCode,billNo,dblTaxAmt);
											}
											
											
										}
									}
								}
								
								else
								{
									/*sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0,0 "
											+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
											+ " AND a.strBillNo='"
											+ billNo
											+ "' and a.strDocNo='" + docNo + "' ";*/
									
									sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt"
											+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
											+ " AND a.strBillNo='"
											+ billNo
											+ "' and a.strDocNo='" + docNo + "' ";
									// + " and DATE(a.dteDocDate) BETWEEN '" + fromDate +
									// "' AND '" + toDate + "' ";
									List listBillTaxDtl = objWebPMSUtility.funExecuteQuery(
											sqlBillDtl, "sql");
									for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
										Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
										billPrintingBean = new clsBillPrintingBean();
										billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (arrObjBillTaxDtl[0].toString())));
										if(folioArr[7].toString().contains("POS"))
										{
										}	
										else
										{
										billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
										billPrintingBean.setStrPerticulars(arrObjBillTaxDtl[2].toString());
										double debitAmt = Double.parseDouble(arrObjBillTaxDtl[3].toString());
										double creditAmt = Double.parseDouble(arrObjBillTaxDtl[4].toString());
										
										balance = balance + debitAmt - creditAmt;

										billPrintingBean.setDblDebitAmt(debitAmt);
										billPrintingBean.setDblCreditAmt(creditAmt);
										billPrintingBean.setDblBalanceAmt(balance);
										dataList.add(billPrintingBean);
										if(hmTax.containsKey(arrObjBillTaxDtl[2].toString())){
											clsBillPrintingBean bean1= new clsBillPrintingBean();
											bean1 =billPrintingBean;
											clsBillPrintingBean bean=hmTax.get(arrObjBillTaxDtl[2].toString());
											bean1.setDblBalanceAmt(balance);
											/*bean1.setDblBalanceAmt(bean.getDblBalanceAmt()+balance);*/
											hmTax.put(arrObjBillTaxDtl[2].toString(), bean1);
										}else{
											hmTax.put(arrObjBillTaxDtl[2].toString(), billPrintingBean);	
										}
										
										}
									}
								}
							}
						}

						}
						sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0 "
								+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
								+ " AND a.strBillNo='"
								+ billNo
								+ "' and a.strDocNo='" + docNo + "' AND a.strClientCode='"+clientCode+"'";
						// + " and DATE(a.dteDocDate) BETWEEN '" + fromDate +
						// "' AND '" + toDate + "' ";
						List listBillTaxDtl = objBaseService.funGetListForWebPMS(new StringBuilder(sqlBillDtl), "sql");
						for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
							Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
							billPrintingBean = new clsBillPrintingBean();
							billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (arrObjBillTaxDtl[0].toString())));
							if(folioArr[7].toString().contains("POS"))
							{
							}	
							else
							{
							billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
							billPrintingBean.setStrPerticulars(arrObjBillTaxDtl[2].toString());
							double debitAmt = Double.parseDouble(arrObjBillTaxDtl[3].toString());
							double creditAmt = Double.parseDouble(arrObjBillTaxDtl[4].toString());
							
							balance = balance + debitAmt - creditAmt;

							billPrintingBean.setDblDebitAmt(debitAmt);
							billPrintingBean.setDblCreditAmt(creditAmt);
							billPrintingBean.setDblBalanceAmt(balance);
							dataList.add(billPrintingBean);
							if(hmTax.containsKey(arrObjBillTaxDtl[2].toString())){
								clsBillPrintingBean bean1= new clsBillPrintingBean();
								bean1 =billPrintingBean;
								clsBillPrintingBean bean=hmTax.get(arrObjBillTaxDtl[2].toString());
								bean1.setDblBalanceAmt(balance);
								/*bean1.setDblBalanceAmt(bean.getDblBalanceAmt()+balance);*/
								hmTax.put(arrObjBillTaxDtl[2].toString(), bean1);
							}else{
								hmTax.put(arrObjBillTaxDtl[2].toString(), billPrintingBean);	
							}
							
							}
						}
						
						String sqlCheckOutDate = "SELECT Date(a.dteBillDate) as Date "
								+ "FROM tblbillhd a WHERE a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
						List listCheckOutDate = objWebPMSUtility.funExecuteQuery(
								sqlCheckOutDate, "sql");
						
						String strChkOutDate = listCheckOutDate.get(0).toString();
						reportParams.put("pDepartureDate",objGlobal.funGetDate("dd-MM-yyyy", strChkOutDate));

					}
				}

				flgBillRecord = true;
			}

			if (flgBillRecord) 
			{
				
				List paymentDtlList=new ArrayList<>();
				String sqlPaymentDtl="";
				// get payment details

				if(strSelectBill.contains("Room Tariff"))
				{
					 sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,IF(c.strAgainst='Bill',e.strSettlementDesc,CONCAT('ADVANCE ',e.strSettlementDesc)),'0.00' as debitAmt "
							+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
							+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode AND c.strFolioNo='"+folio+"' and d.strClientCode='"+clientCode+"'";
	
					 paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
					 for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} 
						else 
						{
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance = balance + debitAmount - creditAmount;
							// String debitAmount = paymentArr[3].toString();
							// String creditAmount = paymentArr[4].toString();
							// String balance = paymentArr[5].toString();
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
	
							dataList.add(folioPrintingBean);
						}
					}
					
					if (!(paymentDtlList.size() > 0)) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and c.strRegistrationNo='"
								+ registrationNo
								+ "' and c.strAgainst='Check-In' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List checkInReceiptDtl = objFolioService
								.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < checkInReceiptDtl.size(); i++) {
							Object[] paymentArr = (Object[]) checkInReceiptDtl.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
	
								double debitAmount = Double.parseDouble(paymentArr[3].toString());
								double creditAmount = Double.parseDouble(paymentArr[4].toString());
								balance = balance + debitAmount - creditAmount;
	
								// String debitAmount = paymentArr[3].toString();
								// String creditAmount = paymentArr[4].toString();
								// String balance = paymentArr[5].toString();
	
								folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
								folioPrintingBean.setStrDocNo(docNo);
								folioPrintingBean.setStrPerticulars(particulars);
								folioPrintingBean.setDblDebitAmt(debitAmount);
								folioPrintingBean.setDblCreditAmt(creditAmount);
								folioPrintingBean.setDblBalanceAmt(balance);
	
								dataList.add(folioPrintingBean);
							}
						}
	
					}
				}
				String sqlReservationAdvPayment = "select a.strReservationNo from tblbillhd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
				List listResAdvpayment = objGlobalFunctionsService.funGetDataList(sqlReservationAdvPayment, "sql");
				String strResNo = listResAdvpayment.get(0).toString();
				String sqlResPayment = "";
				if(strResNo.length()>0)
				{
					sqlResPayment="SELECT DATE(c.dteReceiptDate),c.strReceiptNo, CONCAT('ADVANCE ',e.strSettlementDesc),'0.00' AS debitAmt, "
							+ "d.dblSettlementAmt AS creditAmt,'0.00' AS balance "
							+ "FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ "WHERE c.strReceiptNo=d.strReceiptNo AND d.strSettlementCode=e.strSettlementCode "
							+ "AND c.strReservationNo='"+strResNo+"' AND d.strClientCode='"+clientCode+"' AND c.strReservationNo='"+strResNo+"' and c.strAgainst='Reservation' ";
					
					paymentDtlList = objGlobalFunctionsService.funGetDataList(sqlResPayment, "sql");
					 for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} 
						else 
						{
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance = balance + debitAmount - creditAmount;
							// String debitAmount = paymentArr[3].toString();
							// String creditAmount = paymentArr[4].toString();
							// String balance = paymentArr[5].toString();
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
	
							dataList.add(folioPrintingBean);
						}
					}
				}
				
				

				/*
				 * String sqlPaymentDtl =
				 * "SELECT date(b.dteDocDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt"
				 * + " ,d.dblSettlementAmt as creditAmt,'0.00' as balance " +
				 * " FROM tblbillhd a " +
				 * "LEFT OUTER JOIN tblbilldtl b ON a.strFolioNo=b.strFolioNo "
				 * +
				 * " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo and a.strReservationNo=c.strReservationNo "
				 * +
				 * " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo "
				 * +
				 * " left outer join tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode "
				 * + " WHERE a.strBillNo='" + billNo + "' "; //+
				 * " and DATE(b.dteDocDate) BETWEEN '" + fromDate + "' AND '" +
				 * toDate + "'"
				 */

				/*sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
						+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
						+ " FROM tblbillhd a,tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
						+ " where a.strBillNo=c.strBillNo and c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
						+ " and a.strBillNo='"
						+ billNo
						+ "' and c.strAgainst='Bill' ";

				List billReceitDtl = objFolioService
						.funGetParametersList(sqlPaymentDtl);
				for (int i = 0; i < billReceitDtl.size(); i++) {
					Object[] paymentArr = (Object[]) billReceitDtl.get(i);

					String docDate = paymentArr[0].toString();
					if (paymentArr[1] == null) {
						continue;
					} else {
						clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
						String docNo = paymentArr[1].toString();
						String particulars = paymentArr[2].toString();

						double debitAmount = Double.parseDouble(paymentArr[3]
								.toString());
						double creditAmount = Double.parseDouble(paymentArr[4]
								.toString());
						balance = balance + debitAmount - creditAmount;

						// String debitAmount = paymentArr[3].toString();
						// String creditAmount = paymentArr[4].toString();
						// String balance = paymentArr[5].toString();

						folioPrintingBean.setDteDocDate(objGlobal.funGetDate(
								"dd-MM-yyyy", (docDate)));
						folioPrintingBean.setStrDocNo(docNo);
						folioPrintingBean.setStrPerticulars(particulars);
						folioPrintingBean.setDblDebitAmt(debitAmount);
						folioPrintingBean.setDblCreditAmt(creditAmount);
						folioPrintingBean.setDblBalanceAmt(balance);

						dataList.add(folioPrintingBean);
					}
				}
*/
				String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
						+ " WHERE a.strBillNo='"
						+ billNo
						+ "' and strClientCode='" + clientCode + "' ";

				List billDiscList = objBaseService.funGetListForWebPMS(new StringBuilder(sqlDisc), "sql");
				for (int i = 0; i < billDiscList.size(); i++) {
					Object[] billDicArr = (Object[]) billDiscList.get(i);

					clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
					String docDate = billDicArr[0].toString();
					String docNo = billDicArr[1].toString();
					String particulars = billDicArr[2].toString();

					double debitAmount = Double.parseDouble(billDicArr[3].toString());
					double creditAmount = Double.parseDouble(billDicArr[4].toString());
					balance = balance + debitAmount - creditAmount;

					// String debitAmount = billDicArr[3].toString();
					// String creditAmount = billDicArr[4].toString();
					// String balance = billDicArr[5].toString();

					folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
					folioPrintingBean.setStrDocNo(docNo);
					folioPrintingBean.setStrPerticulars(particulars);
					folioPrintingBean.setDblDebitAmt(debitAmount);
					folioPrintingBean.setDblCreditAmt(creditAmount);
					folioPrintingBean.setDblBalanceAmt(balance);

					dataList.add(folioPrintingBean);
				}
				
				
				String walkIn = "";
				if(strSelectBill.contains("Room Tariff"))
				{
					String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
					List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
					for(int i = 0;i<listWalkIn.size();i++)
					{
						walkIn = listWalkIn.get(i).toString();
					}
					String walkInDiscount = "SELECT DATE(a.dtDate),'',CONCAT('Discount ',a.dblDiscount,'%' ),a.dblRoomRate,"
							+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
							+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"' group by a.dblDiscount";
					List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
					for (int i = 0; i < walkInBillDiscList.size(); i++) {
						Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
	
						clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
						String docDate = billWalkDicArr[0].toString();
						String docNo = billWalkDicArr[1].toString();
						String particulars = billWalkDicArr[2].toString();
						double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
						double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
						if(creditAmount==0)
						{
						}
						else
						{
							/*balance  = balance +  - (creditAmount/100)*debitAmount;*/
							creditAmount = debitAmount*creditAmount/100;
							if(count>0)
							{
								creditAmount = creditAmount*count;
							}
							balance = balance - creditAmount;
							// String debitAmount = billDicArr[3].toString();
							// String creditAmount = billDicArr[4].toString();
							// String balance = billDicArr[5].toString();
		
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(0.0);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
								
							dataList.add(folioPrintingBean);
						}
					}
				}
				

			}
			List<clsBillPrintingBean> listtax=new ArrayList<>();
			if(hmTax.size()>0){
				for(Map.Entry<String, clsBillPrintingBean> entry:hmTax.entrySet()){
					listtax.add(entry.getValue());
				}
			}
			
			String sqlCheckSupportVoucher="SELECT a.strPerticulars FROM tblbilldtl a,tblbillhd b WHERE b.strBillNo=a.strBillNo "
					+ " AND a.strBillNo ='"+billNo+"' AND a.strPerticulars!='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
			List list = objFolioService.funGetParametersList(sqlCheckSupportVoucher);
			if(list.size()>0)
			{
				pSupportVoucher="Yes";
				/*pSupportVoucherTextFielf = "Supporting Voucher";*/
			}
			else
			{
				pSupportVoucher="";
				/*pSupportVoucherTextFielf = "";*/
			}
			
			pRoomTariff = funGetRoomTariffData(billNo,folio,registrationNo,clientCode,checkInNo);
			String sql="select a.dblReceiptAmt from tblreceipthd a where a.strType='Refund Amt' and a.strBillNo='"+billNo+"'";
			List guestlist =  objGlobalFunctionsService.funGetListModuleWise(sql, "sql");;
			double refundAmt=0.00;
			if(guestlist!=null && guestlist.size()>0)
			{
				refundAmt=Double.parseDouble(guestlist.get(0).toString());
				reportParams.put("lblRefund", "Refund Amount");
				reportParams.put("dblRefund",String.valueOf( refundAmt));
			}
			else
			{
				reportParams.put("lblRefund", null);
				reportParams.put("dblRefund", null);
			}
			
			reportParams.put("listtax", listtax);
			reportParams.put("pSupportVoucher", pSupportVoucher);
			reportParams.put("pSupportVoucherTextFielf", pSupportVoucherTextFielf);
			reportParams.put("pHmRoomTariff", pRoomTariff);
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		}
	}

	private void funDeleteTaxesAndUpdateBillHd(String strTaxOfBill, String clientCode, String billNo, double dblTaxAmt) {
		try{
			
			
			String updateBillHd = "update tblbillhd a set a.dblGrandTotal=(a.dblGrandTotal-"+dblTaxAmt+") where a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"' ";
			objWebPMSUtility.funExecuteUpdate(updateBillHd, "sql");
			
		
			
			String sqlDelete =  "delete from tblbilltaxdtl  where strTaxCode='"+strTaxOfBill+"'  and strClientCode='"+clientCode+"' and strBillNo='"+billNo+"';";
			objWebPMSUtility.funExecuteUpdate(sqlDelete, "sql");
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
	}

	@RequestMapping(value = "/rptBillPrintingForCheckIn", method = RequestMethod.GET)
	public void funGenerateBillPrintingReporForCheckIn(
			@RequestParam("fromDate") String fromDate,
			@RequestParam("toDate") String toDate,
			@RequestParam("checkInNo") String checkInNo,
			@RequestParam("against") String against, HttpServletRequest req,
			HttpServletResponse resp) {
		try {
			boolean flgBillRecord = false;
			String registrationNo = "";
			String reservationNo = "";
			String pSupportVoucher = "";
			int count=0;
			String GSTNo = "", companyName = "";
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
			clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
			List billNo = new ArrayList();
			String folio = "";
			String roomNo = "";
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
			if(objModel.getStrBillFormat().equalsIgnoreCase("Format 1"))
			{
				String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptBillPrintingCheckIn.jrxml");
				List<clsBillPrintingBean> dataList = new ArrayList<clsBillPrintingBean>();
				@SuppressWarnings("rawtypes")
				HashMap reportParams = new HashMap();
				String sqlParametersFromBill = "SELECT a.strFolioNo,a.strRoomNo,a.strRegistrationNo,a.strReservationNo, DATE(b.dteArrivalDate),b.tmeArrivalTime, "
						+ " IFNULL(DATE(b.dteDepartureDate),'NA'), IFNULL(b.tmeDepartureTime,'NA'), IFNULL(d.strGuestPrefix,''),"
						+ " IFNULL(d.strFirstName,''), IFNULL(d.strMiddleName,''), IFNULL(d.strLastName,''), b.intNoOfAdults,b.intNoOfChild,"
						+ " a.strBillNo,IFNULL(d.strDefaultAddr,''), IFNULL(d.strAddressLocal,''), IFNULL(d.strCityLocal,''), "
						+ " IFNULL(d.strStateLocal,''), IFNULL(d.strCountryLocal,''),d.intPinCodeLocal, IFNULL(d.strAddrPermanent,''), "
						+ " IFNULL(d.strCityPermanent,''), IFNULL(d.strStatePermanent,''), IFNULL(d.strCountryPermanent,''),d.intPinCodePermanent, "
						+ " IFNULL(d.strAddressOfc,''), IFNULL(d.strCityOfc,''), IFNULL(d.strStateOfc,''), "
						+ " IFNULL(d.strCountryOfc,''),d.intPinCodeOfc,a.strGSTNo,a.strCompanyName, "
						+ "d.lngMobileNo,"
						+ "IFNULL(d.intPinCodeOfc,'')"
						+ " FROM tblbillhd a LEFT OUTER JOIN tblcheckinhd b ON a.strCheckInNo=b.strCheckInNo"
						+ " LEFT OUTER JOIN tblcheckindtl c ON b.strCheckInNo=c.strCheckInNo AND a.strRoomNo=c.strRoomNo"
						+ " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode"
						+ " WHERE a.strCheckInNo='"
						+ checkInNo
						+ "' AND c.strPayee='Y' AND a.strClientCode='"+clientCode+"' ORDER BY c.strPayee DESC";
	
				List listOfParametersFromBill = objFolioService.funGetParametersList(sqlParametersFromBill);
	
				if (listOfParametersFromBill.size() > 0) {
					Object[] arr = (Object[]) listOfParametersFromBill.get(0);
	
					// String folio = arr[0].toString();
					// String roomNo = arr[1].toString();
					registrationNo = arr[2].toString();
					reservationNo = arr[3].toString();
					String arrivalDate = arr[4].toString();
					String arrivalTime = arr[5].toString();
					String departureDate = arr[6].toString();
					String departureTime = arr[7].toString();
					String gPrefix = arr[8].toString();
					String gFirstName = arr[9].toString();
					String gMiddleName = arr[10].toString();
					String gLastName = arr[11].toString();
					String adults = arr[12].toString();
					String childs = arr[13].toString();
				    String billNumber = "";
	
					String guestAddr = "";
					if (arr[15].toString().equalsIgnoreCase("Permanent")) { // check
																			// default
																			// addr
						guestAddr = arr[21].toString() + "," + arr[22].toString()
								+ "," + arr[23].toString() + ","
								+ arr[24].toString() + "," + arr[25].toString();
					} else if (arr[15].toString().equalsIgnoreCase("Office")) {
						guestAddr = arr[26].toString() + "," + arr[27].toString()
								+ "," + arr[28].toString() + ","
								+ arr[29].toString() + "," + arr[30].toString();
					} else { // Local
						guestAddr = arr[16].toString() + "," + arr[17].toString()
								+ "," + arr[18].toString() + ","
								+ arr[19].toString() + "," + arr[20].toString();
					}
					GSTNo = arr[31].toString();
					companyName = arr[32].toString();
					String strMobileNo = arr[33].toString();
					String remark="";
					String sql="SELECT a.strRemark FROM tblbilldiscount a WHERE a.strBillNo = '"+billNo+"' AND a.strClientCode='"+clientCode+"'";
					List listremark = objFolioService.funGetParametersList(sql);
					if(listremark!=null && listremark.size()>0){
						remark=listremark.get(0).toString();
					}
					// String billNo = arr[14].toString();
					String sqlCheckOutTime = "select Distinct(TIME_FORMAT(SUBSTR(a.dteDateEdited,11),'%h:%i %p')) as Checkout_Time "
							+ "from tblbillhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
					List listCheckOutTime = objFolioService.funGetParametersList(sqlCheckOutTime);
					String chkOutTime=listCheckOutTime.get(0).toString();
					clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
					//String noOfRoom = objPropertySetupModel.getStrRoomLimit();.
					String hsnCode = objPropertySetupModel.getStrHscCode();
					String panno = objPropertySetupModel.getStrPanNo();
					String bankDtl = objPropertySetupModel.getStrBankAcName();
					String bankAcNo = objPropertySetupModel.getStrBankAcNumber();
					String bankIFSC = objPropertySetupModel.getStrBankIFSC();
					String branchnName = objPropertySetupModel.getStBranchName();
					String guestCompanyAddress="";
					guestCompanyAddress = arr[26].toString() + ","
							+ arr[27].toString() + ","
							+ arr[28].toString() + ","
							+ arr[29].toString() + ","
							+ arr[30].toString();				
					reportParams.put("phsnCode", hsnCode);
					reportParams.put("ppanno", panno);
					reportParams.put("pbankDtl", bankDtl);
					reportParams.put("pbankAcNo", bankAcNo);
					reportParams.put("pbankIFSC", bankIFSC);
					reportParams.put("pbranchnName", branchnName);
					reportParams.put("pCompanyName", companyName);
					reportParams.put("pGuestNo", GSTNo);
					reportParams.put("pAddress1", objSetup.getStrAdd1() + ","+ objSetup.getStrAdd2() + "," + objSetup.getStrCity());
					reportParams.put("pAddress2",objSetup.getStrState() + ","+ objSetup.getStrCountry() + ","+ objSetup.getStrPin());
					reportParams.put("pContactDetails", "");
					reportParams.put("strImagePath", imagePath);
					reportParams.put("pGuestName", gPrefix + " " + gFirstName + " "+ gMiddleName + " " + gLastName);
					reportParams.put("pFolioNo", folio);
					reportParams.put("pRoomNo", roomNo);
					reportParams.put("pRegistrationNo", registrationNo);
					reportParams.put("pReservationNo", reservationNo);
					reportParams.put("pArrivalDate",objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
					reportParams.put("pArrivalTime", arrivalTime);
					reportParams.put("pDepartureTime", chkOutTime);
					reportParams.put("pAdult", adults);
					reportParams.put("pChild", childs);
					reportParams.put("pGuestAddress", guestAddr);
					reportParams.put("pRemarks", remark);
					reportParams.put("strUserCode", userCode);
					reportParams.put("pBillNo", billNumber);
					reportParams.put("pstrCustNo", strMobileNo);
					reportParams.put("pDepartureDate",objGlobal.funGetDate("dd-MM-yyyy", departureDate));
					reportParams.put("pGuestOfficeAddress", guestCompanyAddress);
					reportParams.put("pGSTNo", GSTNo);
					if(clientCode.equalsIgnoreCase("320.001"))
					{
						String strIssue = "Issued Subject to Nashik Jurisdiction";
						String strAddr = "Mumbai Agra Road,Nashik-422009.Ph.+91253-2325000 E-mail:suryanasik@gmail.com";
						
						reportParams.put("pstrIssue", strIssue);
						reportParams.put("pstrAddr", strAddr);
					}
					// get bill details
					String sqlBillDtl = "SELECT date(b.dteDocDate),b.strDocNo,IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),b.dblDebitAmt,b.dblCreditAmt,b.dblBalanceAmt,a.strBillNo,c.strRoomDesc,a.strFolioNo"
							+ " FROM tblbillhd a inner join tblbilldtl b ON a.strFolioNo=b.strFolioNo ,tblroom c "
							+ " WHERE a.strCheckInNo='"
							+ checkInNo
							+ "' and a.strBillNo=b.strBillNo and a.strRoomNo=c.strRoomCode and a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' ORDER BY a.strBillNo";
					//
					// +
					// "and a.dteBillDate between '"+fromDate+"' and '"+toDate+"' "
	
					List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
					for (int i = 0; i < billDtlList.size(); i++) {
						Object[] folioArr = (Object[]) billDtlList.get(i);
	
						String docDate = folioArr[0].toString();
						if (folioArr[1] == null) {
							continue;
						} else {
							clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();
	
							String docNo = folioArr[1].toString();
							String strPerticulars = folioArr[2].toString();
							String debitAmount = folioArr[3].toString();
							String creditAmount = folioArr[4].toString();
							String balance = folioArr[5].toString();
							if (!billNo.contains(folioArr[6].toString())) {
								billNo.add(folioArr[6].toString());
							}
							if(strPerticulars.equalsIgnoreCase("Room Tariff"))
							{
								count++;
							}
							
							if (!roomNo.contains(folioArr[7].toString())) {
								roomNo = roomNo + "," + folioArr[7].toString();
							}
							if (!folio.contains(folioArr[8].toString())) {
								folio = folio + "," + folioArr[8].toString();
							}
	
							billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							billPrintingBean.setStrDocNo(docNo);
							billPrintingBean.setStrPerticulars(strPerticulars);
							billPrintingBean.setDblDebitAmt(Double.parseDouble(debitAmount));
							billPrintingBean.setDblCreditAmt(Double.parseDouble(creditAmount));
							billPrintingBean.setDblBalanceAmt(Double.parseDouble(balance));
							if(billPrintingBean.getDblDebitAmt()>0)
							{
								dataList.add(billPrintingBean);	
							}
							
							sqlBillDtl = " SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0 "
									+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo  "
									+ " AND a.strBillNo='"
									+ folioArr[6].toString()
									+ "'  and a.strDocNo='" + docNo + "' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
							// + " and DATE(a.dteDocDate) BETWEEN '" + fromDate +
							// "' AND '" + toDate + "' ";
							List listBillTaxDtl = objWebPMSUtility.funExecuteQuery(
									sqlBillDtl, "sql");
							for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
								Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
								billPrintingBean = new clsBillPrintingBean();
								billPrintingBean.setDteDocDate(objGlobal.funGetDate("yyyy-MM-dd",arrObjBillTaxDtl[0].toString()));
								if(folioArr[7].toString().contains("POS"))
								{
								}
								else
								{
								billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
								billPrintingBean.setStrPerticulars(arrObjBillTaxDtl[2].toString());
								billPrintingBean.setDblDebitAmt(Double.parseDouble(arrObjBillTaxDtl[3].toString()));
								billPrintingBean.setDblCreditAmt(Double.parseDouble(arrObjBillTaxDtl[4].toString()));
								billPrintingBean.setDblBalanceAmt(Double.parseDouble(arrObjBillTaxDtl[4].toString()));
								
								if(billPrintingBean.getDblDebitAmt()>0)
								{
									dataList.add(billPrintingBean);	
								}
							}
							}
						}
					}
					flgBillRecord = true;
				}
	
				if (flgBillRecord) {
					// get payment details
					String sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
							+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
							+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
							+ " and c.strReservationNo='"
							+ reservationNo
							+ "' and c.strAgainst='Reservation' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
					List paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
					for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							String debitAmount = paymentArr[3].toString();
							String creditAmount = paymentArr[4].toString();
							String balance = paymentArr[5].toString();
	
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(Double.parseDouble(debitAmount));
							folioPrintingBean.setDblCreditAmt(Double.parseDouble(creditAmount));
							folioPrintingBean.setDblBalanceAmt(Double.parseDouble(balance));
							if(folioPrintingBean.getDblDebitAmt()>0)
							{
								dataList.add(folioPrintingBean);	
							}
							
						}
					}
	
					if (!(paymentDtlList.size() > 0)) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and c.strRegistrationNo='"
								+ registrationNo
								+ "' and c.strAgainst='Check-In' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List checkInReceiptDtl = objFolioService.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < checkInReceiptDtl.size(); i++) {
							Object[] paymentArr = (Object[]) checkInReceiptDtl
									.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
								String debitAmount = paymentArr[3].toString();
								String creditAmount = paymentArr[4].toString();
								String balance = paymentArr[5].toString();
	
								folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
								folioPrintingBean.setStrDocNo(docNo);
								folioPrintingBean.setStrPerticulars(particulars);
								folioPrintingBean.setDblDebitAmt(Double.parseDouble(debitAmount));
								folioPrintingBean.setDblCreditAmt(Double.parseDouble(creditAmount));
								folioPrintingBean.setDblBalanceAmt(Double.parseDouble(balance));
	
								if(folioPrintingBean.getDblDebitAmt()>0)
								{
									dataList.add(folioPrintingBean);	
								}
								
							}
						}
					}
	
					for (int cnt = 0; cnt < billNo.size(); cnt++) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblbillhd a,tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where a.strBillNo=c.strBillNo and c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and a.strBillNo='"
								+ billNo.get(cnt)
								+ "' and c.strAgainst='Bill' AND a.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List billReceitDtl = objFolioService
								.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < billReceitDtl.size(); i++) {
							Object[] paymentArr = (Object[]) billReceitDtl.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
								String debitAmount = paymentArr[3].toString();
								String creditAmount = paymentArr[4].toString();
								String balance = paymentArr[5].toString();
	
								folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
								folioPrintingBean.setStrDocNo(docNo);
								folioPrintingBean.setStrPerticulars(particulars);
								folioPrintingBean.setDblDebitAmt(Double.parseDouble(debitAmount));
								folioPrintingBean.setDblCreditAmt(Double.parseDouble(creditAmount));
								folioPrintingBean.setDblBalanceAmt(Double.parseDouble(balance));
								if(folioPrintingBean.getDblDebitAmt()>0)
								{
									dataList.add(folioPrintingBean);	
								}
								
							}
						}
	
						String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
								+ " WHERE a.strBillNo='"
								+ billNo.get(cnt)
								+ "' and strClientCode='" + clientCode + "' ";
	
						List billDiscList = objFolioService.funGetParametersList(sqlDisc);
						for (int i = 0; i < billDiscList.size(); i++) {
							Object[] billDicArr = (Object[]) billDiscList.get(i);
	
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docDate = billDicArr[0].toString();
							String docNo = billDicArr[1].toString();
							String particulars = billDicArr[2].toString();
							String debitAmount = billDicArr[3].toString();
							String creditAmount = billDicArr[4].toString();
							String balance = billDicArr[4].toString();
	
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(Double.parseDouble(debitAmount));
							folioPrintingBean.setDblCreditAmt(Double.parseDouble(creditAmount));
							folioPrintingBean.setDblBalanceAmt(Double.parseDouble(balance));
							if(folioPrintingBean.getDblDebitAmt()>0)
							{
								dataList.add(folioPrintingBean);	
							}
							
						}
					}
				}
				String walkIn="";
				String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
				List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
				for(int i = 0;i<listWalkIn.size();i++)
				{
					walkIn = listWalkIn.get(i).toString();
				}
				String walkInDiscount = "SELECT DATE(a.dtDate),'',CONCAT('Discount ',a.dblDiscount,'%' ),a.dblRoomRate,"
						+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
						+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"' group by a.dblDiscount";
				List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
				for (int i = 0; i < walkInBillDiscList.size(); i++) {
					Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
	
					clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
					String docDate = billWalkDicArr[0].toString();
					String docNo = billWalkDicArr[1].toString();
					String particulars = billWalkDicArr[2].toString();
					double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
					double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
					double balance =0.0;
					if(creditAmount==0)
					{
					}
					else
					{
						balance  = balance +  - (creditAmount/100)*debitAmount;
						creditAmount = debitAmount*creditAmount/100;
						if(count>0)
						{
							creditAmount = creditAmount*count;
						}
						balance = balance - creditAmount;
						folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
						folioPrintingBean.setStrDocNo(docNo);
						folioPrintingBean.setStrPerticulars(particulars);
						folioPrintingBean.setDblDebitAmt(0.0);
						folioPrintingBean.setDblCreditAmt(creditAmount);
						folioPrintingBean.setDblBalanceAmt(0.0);
							
						if(folioPrintingBean.getDblDebitAmt()>0)
						{
							dataList.add(folioPrintingBean);	
						}
						
					}
				}
				
				String sqlCheckSupportVoucher="SELECT a.strPerticulars FROM tblbilldtl a,tblbillhd b WHERE b.strBillNo=a.strBillNo "
						+ " AND a.strBillNo ='"+billNo+"' AND a.strPerticulars!='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
				List list = objFolioService.funGetParametersList(sqlCheckSupportVoucher);
				if(list.size()>0)
				{
					pSupportVoucher="Yes";
				}
				else
				{
					pSupportVoucher="No";
				}
				reportParams.put("pSupportVoucher", pSupportVoucher);
	
				reportParams.put("pFolioNo", folio.substring(1, folio.length()));
				reportParams.put("pRoomNo", roomNo.substring(1, roomNo.length()));
				JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(
						dataList);
				JasperDesign jd = JRXmlLoader.load(reportName);
				JasperReport jr = JasperCompileManager.compileReport(jd);
				JasperPrint jp = JasperFillManager.fillReport(jr, reportParams,
						beanCollectionDataSource);
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
			else
			{
				//Format 2 Report
				
				if(checkInNo.contains(","))
				{
					String [] checkInNoArray = checkInNo.split(",");
					for(int q=0;q<checkInNoArray.length;q++)
					{
						String strCheckInNo = checkInNoArray[q];
						
						List listInvoice=new ArrayList();
						String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptInvoiceFormat.jrxml");
						imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");

						List<clsInvoiceFormatBean> dataList = new ArrayList<clsInvoiceFormatBean>();
						
						List listInvoiceSummary=new ArrayList();
						
						@SuppressWarnings("rawtypes")
						
						HashMap reportParams = new HashMap();
						int countt = 1;
						double total=0.0;
						double totalCount=0.0;
						String sqlParametersFromBill = "SELECT a.strFolioNo,a.strRoomNo,a.strRegistrationNo,a.strReservationNo, "
								+ "DATE(b.dteArrivalDate),b.tmeArrivalTime, IFNULL(DATE(b.dteDepartureDate),'NA'), "
								+ "IFNULL(b.tmeDepartureTime,'NA'), IFNULL(d.strGuestPrefix,''), IFNULL(d.strFirstName,''), "
								+ "IFNULL(d.strMiddleName,''), IFNULL(d.strLastName,''), b.intNoOfAdults,b.intNoOfChild, a.strBillNo, "
								+ "IFNULL(d.strDefaultAddr,''), IFNULL(d.strAddressLocal,''), IFNULL(d.strCityLocal,''), IFNULL(d.strStateLocal,''), "
								+ "IFNULL(d.strCountryLocal,''),IFNULL(d.intPinCodeLocal,''), IFNULL(d.strAddrPermanent,''), IFNULL(d.strCityPermanent,''), "
								+ "IFNULL(d.strStatePermanent,''), IFNULL(d.strCountryPermanent,''),IFNULL(d.intPinCodePermanent,''), IFNULL(d.strAddressOfc,''), "
								+ "IFNULL(d.strCityOfc,''), IFNULL(d.strStateOfc,''), IFNULL(d.strCountryOfc,''),IFNULL(d.intPinCodeOfc,''),IFNULL(a.strGSTNo,''),IFNULL(a.strCompanyName,''), IFNULL(d.lngMobileNo,'') "
								+ "FROM tblbillhd a "
								+ "LEFT OUTER "
								+ "JOIN tblcheckinhd b ON b.strCheckInNo in  (select SUBSTRING_INDEX(a.strCheckInNo,',',1) from tblbillhd a ) "
								+ "LEFT OUTER "
								+ "JOIN tblcheckindtl c ON b.strCheckInNo=c.strCheckInNo AND c.strRoomNo in(select SUBSTRING_INDEX(a.strRoomNo,',',1)) "
								+ "LEFT OUTER "
								+ "JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode";			
						List listOfParametersFromBill = objFolioService.funGetParametersList(sqlParametersFromBill);
			
						if (listOfParametersFromBill.size() > 0) {
							Object[] arr = (Object[]) listOfParametersFromBill.get(0);
							registrationNo = arr[2].toString();
							reservationNo = arr[3].toString();
							String arrivalDate = arr[4].toString();
							String arrivalTime = arr[5].toString();
							String departureDate = arr[6].toString();
							String departureTime = arr[7].toString();
							String gPrefix = arr[8].toString();
							String gFirstName = arr[9].toString();
							String gMiddleName = arr[10].toString();
							String gLastName = arr[11].toString();
							String adults = arr[12].toString();
							String childs = arr[13].toString();
						    String billNumber = arr[14].toString();
			
							String guestAddr = "";
							if (arr[15].toString().equalsIgnoreCase("Permanent")) { // check
																					// default
																					// addr
								guestAddr = arr[21].toString() + "," + arr[22].toString()
										+ "," + arr[23].toString() + ","
										+ arr[24].toString() + "," + arr[25].toString();
							} else if (arr[15].toString().equalsIgnoreCase("Office")) {
								guestAddr = arr[26].toString() + "," + arr[27].toString()
										+ "," + arr[28].toString() + ","
										+ arr[29].toString() + "," + arr[30].toString();
							} else { // Local
								guestAddr = arr[16].toString() + "," + arr[17].toString()
										+ "," + arr[18].toString() + ","
										+ arr[19].toString() + "," + arr[20].toString();
							}
							GSTNo = arr[31].toString();
							companyName = arr[32].toString();
							String strMobileNo = arr[33].toString();
							String remark="";
							String sql="SELECT a.strRemark FROM tblbilldiscount a WHERE a.strBillNo = '"+billNo+"' AND a.strClientCode='"+clientCode+"'";
							List listremark = objFolioService.funGetParametersList(sql);
							if(listremark!=null && listremark.size()>0){
								remark=listremark.get(0).toString();
							}
							String sqlCheckOutTime = "select Distinct(TIME_FORMAT(SUBSTR(a.dteDateEdited,11),'%h:%i %p')) as Checkout_Time "
									+ "from tblbillhd a where a.strCheckInNo='"+strCheckInNo+"' AND a.strClientCode='"+clientCode+"'";
							List listCheckOutTime = objFolioService.funGetParametersList(sqlCheckOutTime);
							String chkOutTime = "";
							if(listCheckOutTime!=null && listCheckOutTime.size()>0)
							{
								chkOutTime	= listCheckOutTime.get(0).toString();
							}
							
							clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
							String hsnCode = objPropertySetupModel.getStrHscCode();
							String panno = objPropertySetupModel.getStrPanNo();
							String bankDtl = objPropertySetupModel.getStrBankAcName();
							String bankAcNo = objPropertySetupModel.getStrBankAcNumber();
							String bankIFSC = objPropertySetupModel.getStrBankIFSC();
							String branchnName = objPropertySetupModel.getStBranchName();
							String guestCompanyAddress="";
							guestCompanyAddress = arr[26].toString() + ","
									+ arr[27].toString() + ","
									+ arr[28].toString() + ","
									+ arr[29].toString() + ","
									+ arr[30].toString();				
							
							//Fill data 					
							reportParams.put("pCompanyPAN", panno);
							reportParams.put("pCompanyName", companyName);
							reportParams.put("strImagePath", imagePath);
							reportParams.put("pGuestName", gPrefix + " " + gFirstName + " "+ gMiddleName + " " + gLastName);
							reportParams.put("pInvoiceDated",objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
							reportParams.put("pInvoiceNO", billNumber);reportParams.put("PBuyerAddress", guestCompanyAddress);
							reportParams.put("pCompanyGSTINTop", GSTNo);					
							reportParams.put("pForMessageBot","for SYMBIOSIS - SANDIPANI");
							reportParams.put("pCompanyGSTINAboveName","44 Sandipani Campus (2019-20)");
							reportParams.put("strImagePath", imagePath);
							String sqlBillDtl = "";
						
							if(clientCode.equalsIgnoreCase("320.001"))
							{
								String strIssue = "Issued Subject to Nashik Jurisdiction";
								String strAddr = "Mumbai Agra Road,Nashik-422009.Ph.+91253-2325000 E-mail:suryanasik@gmail.com";
							
								
							}
							String sqlBillNo = "SELECT a.strBillNo "
									+ "FROM tblbillhd a "
									+ "WHERE SUBSTRING_INDEX(a.strCheckInNo,',',1) = '"+strCheckInNo+"' and strClientCode='"+clientCode+"'";
							List billList = objFolioService.funGetParametersList(sqlBillNo);
							
							if(billList!=null && billList.size()>0)
							{
							// get bill details
								sqlBillDtl = "SELECT DATE(b.dteDocDate),b.strDocNo, IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''), "
									+ "ifnull(a.dblGrandTotal,0.0), SUM(b.dblCreditAmt), SUM(b.dblBalanceAmt),a.strBillNo,c.strRoomDesc,a.strFolioNo,d.strHsnSac "
									+ "FROM tblbillhd a "
									+ ", tblbilldtl b ,tblroom c,tblroomtypemaster d "
									+ "WHERE a.strBillNo='"+billList.get(0).toString()+"' AND a.strBillNo=b.strBillNo  AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
									+ "AND c.strClientCode='"+clientCode+"' AND d.strRoomTypeCode=c.strRoomTypeCode "
									+ "GROUP BY b.strPerticulars "
									+ "ORDER BY a.strBillNo";
						
							
							List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
							
							for (int i = 0; i < billDtlList.size(); i++) {
								Object[] folioArr = (Object[]) billDtlList.get(i);
			
								String docDate = folioArr[0].toString();
								if (folioArr[1] == null) {
									continue;
								} else {
									clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
			                        
									String docNo = folioArr[1].toString();
									String strPerticulars = folioArr[2].toString();
									String debitAmount = folioArr[3].toString();
									String creditAmount = folioArr[4].toString();
									String balance = folioArr[5].toString();
									if (!billNo.contains(folioArr[6].toString())) {
										billNo.add(folioArr[6].toString());
									}
									if(strPerticulars.equalsIgnoreCase("Room Tariff"))
									{
										count++;
									}
									
									if (!roomNo.contains(folioArr[7].toString())) {
										roomNo = roomNo + "," + folioArr[7].toString();
									}
									if (!folio.contains(folioArr[8].toString())) {
										folio = folio + "," + folioArr[8].toString();
									}
									clsInvoiceFormatBean objInvoiceFormatHsnBean = new clsInvoiceFormatBean();
									billPrintingBean.setStrDescGoods(strPerticulars);
									billPrintingBean.setStrDescGoodsOutput("");
									billPrintingBean.setStrAmount(Double.parseDouble(debitAmount));
									billPrintingBean.setStrRate("");
									total=total+Double.parseDouble(debitAmount);
									if(billPrintingBean.getStrAmount()>0)
									{
										totalCount=totalCount+Double.parseDouble(debitAmount);	
										billPrintingBean.setStrSrNo(String.valueOf(countt));
										dataList.add(billPrintingBean);
										countt++;
									}
								}
							}
						}
							for(int cnt=0;cnt<billNo.size();cnt++){
							String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
									+ " WHERE a.strBillNo='"
									+ billNo.get(cnt)
									+ "' and strClientCode='" + clientCode + "' ";

							List billDiscList = objFolioService.funGetParametersList(sqlDisc);
							for (int i = 0; i < billDiscList.size(); i++) {
								Object[] billDicArr = (Object[]) billDiscList.get(i);

								clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
								String docDate = billDicArr[0].toString();
								String docNo = billDicArr[1].toString();
								String particulars = billDicArr[2].toString();
								String debitAmount = billDicArr[3].toString();
								String creditAmount = billDicArr[4].toString();
								String balance = billDicArr[4].toString();
								folioPrintingBean.setStrDescGoods(particulars);
								folioPrintingBean.setDblAmount(Double.parseDouble(creditAmount));
								if(folioPrintingBean.getStrAmount()>0)
								{
									dataList.add(folioPrintingBean);
									totalCount=totalCount-Double.parseDouble(creditAmount);
									folioPrintingBean.setStrSrNo(String.valueOf(countt));
									total=total-Double.parseDouble(creditAmount);
									countt++;
								}
							}
							}
							
							sqlBillDtl = "SELECT DATE(a.dteBillDate),b.strTaxDesc,sum(b.dblTaxAmt),0,c.dblTaxValue,ifnull(f.strHsnSac,''),b.strTaxCode,"
									+ " sum(b.dblTaxableAmt),ifnull(CONCAT(f.strHsnSac,' - ',b.strTaxDesc),'')"
									+ " FROM tblbillhd a, tblbilltaxdtl b,tbltaxmaster c,tblroom  e,tblroomtypemaster f"
									+ " WHERE a.strBillNo=b.strBillNo and b.strTaxCode=c.strTaxCode"
									+ " AND a.strRoomNo=e.strRoomCode AND e.strRoomTypeCode=f.strRoomTypeCode"
									+ " AND a.strCheckInNo='"+strCheckInNo+"'  "
									+ " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
									+ " group by b.strTaxCode,f.strHsnSac;";
							List listBillTaxDtl = objWebPMSUtility.funExecuteQuery(
									sqlBillDtl, "sql");
							for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
								Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
								clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
								billPrintingBean.setStrDescGoods("");
								billPrintingBean.setStrDescGoodsOutput(arrObjBillTaxDtl[8].toString());
								billPrintingBean.setStrAmount(Double.parseDouble(arrObjBillTaxDtl[2].toString()));
								String converted=arrObjBillTaxDtl[4].toString();
								billPrintingBean.setStrRate(converted.split("\\.")[0]+"%");
								total=total+Double.parseDouble(arrObjBillTaxDtl[2].toString());
//								if(billPrintingBean.getStrAmount()>0)
//								{
									totalCount=totalCount+Double.parseDouble(arrObjBillTaxDtl[2].toString());	
									dataList.add(billPrintingBean);
								//}					     
							}
							
						    Map<String,clsInvoiceFormatBean> mapInvoice=new HashMap<>();
							String sqlTaxRTDtl="SELECT (a.dteBillDate),b.strTaxDesc,sum(b.dblTaxAmt),0,c.dblTaxValue,ifnull(f.strHsnSac,''),b.strTaxCode, "
		                                       + " sum(b.dblTaxableAmt),ifnull(CONCAT(f.strHsnSac,' - ',b.strTaxDesc),'')  "
		                                       + " FROM tblbillhd a,tblbilldtl g ,tblbilltaxdtl b,tbltaxmaster c,tblroom  e,tblroomtypemaster f  "
		                                       + " WHERE a.strBillNo=b.strBillNo  "
		                                       + " and a.strBillNo=g.strBillNo and g.strBillNo=b.strBillNo and g.strDocNo=b.strDocNo  "
		                                       + " and b.strTaxCode=c.strTaxCode  "
		                                       + " AND a.strRoomNo=e.strRoomCode  "
		                                       + " AND e.strRoomTypeCode=f.strRoomTypeCode AND a.strCheckInNo='"+strCheckInNo+"' and g.strPerticulars='Room Tariff'  "
		                                       + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'  "
		                                       + " group by b.strTaxCode,f.strHsnSac; ";
							List listTaxDetail = objWebPMSUtility.funExecuteQuery(sqlTaxRTDtl, "sql");
							if(listTaxDetail.size()>0)
							{
								clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
								for (int cnt = 0; cnt < listTaxDetail.size(); cnt++) 
								{
								
								
									Object[] arrObjRTTaxDtl = (Object[]) listTaxDetail.get(cnt);
									
									if(mapInvoice.containsKey(arrObjRTTaxDtl[5].toString()))
								    {
										billPrintingBean =mapInvoice.get(arrObjRTTaxDtl[5].toString());
										double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
										billPrintingBean.setDblTaxableValue(taxableAmt);
										if(arrObjRTTaxDtl[1].toString().contains("C.GST 6 % Room Rent"))
										{
											String converted=arrObjRTTaxDtl[4].toString();
											billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
											billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
										}
										if(arrObjRTTaxDtl[1].toString().contains("S.GST 6 % Room Rent"))
										{
											String converted=arrObjRTTaxDtl[4].toString();
											billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
											billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
										}
										 
									}
									else
									{
										billPrintingBean = new clsInvoiceFormatBean();
										billPrintingBean.setStrHsn(arrObjRTTaxDtl[5].toString());
										billPrintingBean.setDblTaxableValue(Double.parseDouble(arrObjRTTaxDtl[7].toString()));
										
										if(arrObjRTTaxDtl[1].toString().contains("C.GST 6 % Room Rent"))
										{
											String converted=arrObjRTTaxDtl[4].toString();
											double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
											billPrintingBean.setDblTaxableValue(taxableAmt);
											billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
											billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
											
										}
										if(arrObjRTTaxDtl[1].toString().contains("S.GST 6 % Room Rent"))
										{
											String converted=arrObjRTTaxDtl[4].toString();
											billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
											billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
										}
										mapInvoice.put(arrObjRTTaxDtl[5].toString(), billPrintingBean);								
									}							
								}
							}					
							
							String sqlTaxIHDtl="select (a.dteBillDate),c.strTaxDesc,sum(c.dblTaxAmt),0,d.dblTaxValue, f.strHsnSac,c.strTaxCode, "
												+ "sum(c.dblTaxableAmt),CONCAT(f.strHsnSac,' - ',c.strTaxDesc) "
												+ " from tblbillhd a ,tblbilldtl b,tblbilltaxdtl c,tbltaxmaster d ,tblincomehead f  "
												+ " where a.strBillNo=b.strBillNo and b.strBillNo=c.strBillNo and b.strDocNo=c.strDocNo  " 
												+ " and a.strBillNo=c.strBillNo and d.strIncomeHeadCode=f.strIncomeHeadCode AND b.strRevenueCode=f.strIncomeHeadCode "
												+ " and  a.strCheckInNo='"+strCheckInNo+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
												+ " group by c.strTaxCode;";
							listTaxDetail = objWebPMSUtility.funExecuteQuery(sqlTaxIHDtl, "sql");
							if(listTaxDetail.size()>0)
							{
								clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
								for (int cnt = 0; cnt < listTaxDetail.size(); cnt++) 
								{
		                            Object[] arrObjRTTaxDtl = (Object[]) listTaxDetail.get(cnt);
									if(mapInvoice.containsKey(arrObjRTTaxDtl[5].toString()))
								    {	
										billPrintingBean =mapInvoice.get(arrObjRTTaxDtl[5].toString());
										double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
										billPrintingBean.setDblTaxableValue(taxableAmt);
										String converted=arrObjRTTaxDtl[4].toString();
										billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
										billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
								    }
									else
									{
										billPrintingBean =new clsInvoiceFormatBean();
										billPrintingBean.setStrHsn(arrObjRTTaxDtl[5].toString());
										billPrintingBean.setDblTaxableValue(Double.parseDouble(arrObjRTTaxDtl[7].toString()));
										String converted=arrObjRTTaxDtl[4].toString();
										billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
										billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
										mapInvoice.put(arrObjRTTaxDtl[5].toString(), billPrintingBean);
									}
								}
							}
							
							for(Map.Entry<String,clsInvoiceFormatBean> entry : mapInvoice.entrySet()){
								clsInvoiceFormatBean objDtlBean =entry.getValue();
								double taxAmt=objDtlBean.getDblStateTaxAmount()+objDtlBean.getDblCentralTaxAmount();
								objDtlBean.setDblTotalAmt(taxAmt);
								listInvoice.add(entry.getValue());
								
							}
							flgBillRecord = true;
						}	
						if (flgBillRecord) {
							// get payment details
							String sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
									+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
									+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
									+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
									+ " and c.strReservationNo='"
									+ reservationNo
									+ "' and c.strAgainst='Reservation' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
			
							List paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
							for (int i = 0; i < paymentDtlList.size(); i++) {
								Object[] paymentArr = (Object[]) paymentDtlList.get(i);
			
								String docDate = paymentArr[0].toString();
								if (paymentArr[1] == null) {
									continue;
								} else {
									clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
									String docNo = paymentArr[1].toString();
									String particulars = paymentArr[2].toString();
									String debitAmount = paymentArr[3].toString();
									String creditAmount = paymentArr[4].toString();
									String balance = paymentArr[5].toString();
									folioPrintingBean.setStrDescGoodsOutput(particulars);
									if(folioPrintingBean.getStrAmount()>0)
									{
										dataList.add(folioPrintingBean);
										totalCount=totalCount+Double.parseDouble(creditAmount);	
									}
								}
							}
			
							if (!(paymentDtlList.size() > 0)) {
								sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
										+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
										+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
										+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
										+ " and c.strRegistrationNo='"
										+ registrationNo
										+ "' and c.strAgainst='Check-In' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
			
								List checkInReceiptDtl = objFolioService.funGetParametersList(sqlPaymentDtl);
								for (int i = 0; i < checkInReceiptDtl.size(); i++) {
									Object[] paymentArr = (Object[]) checkInReceiptDtl
											.get(i);
			
									String docDate = paymentArr[0].toString();
									if (paymentArr[1] == null) {
										continue;
									} else {
										clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
										String docNo = paymentArr[1].toString();
										String particulars = paymentArr[2].toString();
										String debitAmount = paymentArr[3].toString();
										String creditAmount = paymentArr[4].toString();
										String balance = paymentArr[5].toString();
										folioPrintingBean.setStrDescGoodsOutput(particulars);
										if(folioPrintingBean.getStrAmount()>0)
										{
											dataList.add(folioPrintingBean);
											totalCount=totalCount+Double.parseDouble(creditAmount);	
										}
										
									}
								}
							}
			
							for (int cnt = 0; cnt < billNo.size(); cnt++) {
								sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
										+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
										+ " FROM tblbillhd a,tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
										+ " where a.strBillNo=c.strBillNo and c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
										+ " and a.strBillNo='"
										+ billNo.get(cnt)
										+ "' and c.strAgainst='Bill' AND a.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
			
								List billReceitDtl = objFolioService
										.funGetParametersList(sqlPaymentDtl);
								for (int i = 0; i < billReceitDtl.size(); i++) {
									Object[] paymentArr = (Object[]) billReceitDtl.get(i);
			
									String docDate = paymentArr[0].toString();
									if (paymentArr[1] == null) {
										continue;
									} else {
										clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
										String docNo = paymentArr[1].toString();
										String particulars = paymentArr[2].toString();
										String debitAmount = paymentArr[3].toString();
										String creditAmount = paymentArr[4].toString();
										String balance = paymentArr[5].toString();
										folioPrintingBean.setStrDescGoodsOutput(particulars);
										if(folioPrintingBean.getStrAmount()>0)
										{
											dataList.add(folioPrintingBean);
											totalCount=totalCount+Double.parseDouble(creditAmount);	
										}
									}
								}
			
		 					
							}
						}
						String walkIn="";
						String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+strCheckInNo+"' AND a.strClientCode='"+clientCode+"'";
						List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
						for(int i = 0;i<listWalkIn.size();i++)
						{
							walkIn = listWalkIn.get(i).toString();
						}
						String walkInDiscount = "SELECT DATE(a.dtDate),'',CONCAT('Discount ',a.dblDiscount,'%' ),a.dblRoomRate,"
								+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
								+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"' group by a.dblDiscount";
						List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
						for (int i = 0; i < walkInBillDiscList.size(); i++) {
							Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
			
							clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
							String docDate = billWalkDicArr[0].toString();
							String docNo = billWalkDicArr[1].toString();
							String particulars = billWalkDicArr[2].toString();
							double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
							double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
							double balance =0.0;
							if(creditAmount==0)
							{
							}
							else
							{
								balance  = balance +  - (creditAmount/100)*debitAmount;
								creditAmount = debitAmount*creditAmount/100;
								if(count>0)
								{
									creditAmount = creditAmount*count;
								}
								balance = balance - creditAmount;
								folioPrintingBean.setStrDescGoodsOutput(particulars);	
								if(folioPrintingBean.getStrAmount()>0)
								{
									dataList.add(folioPrintingBean);
								}
								
							}
						}				
						String sqlCheckSupportVoucher="SELECT a.strPerticulars FROM tblbilldtl a,tblbillhd b WHERE b.strBillNo=a.strBillNo "
								+ " AND a.strBillNo ='"+billNo+"' AND a.strPerticulars!='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
						List list = objFolioService.funGetParametersList(sqlCheckSupportVoucher);
						if(list.size()>0)
						{
							pSupportVoucher="Yes";
						}
						else
						{
							pSupportVoucher="No";
						}
						clsNumberToWords obj1 = new clsNumberToWords();
						String totalInvoiceValueInWords = obj1.getNumberInWorld(totalCount, "");
						reportParams.put("listTaxDtl", listInvoice);
						reportParams.put("pAmtInWords",totalInvoiceValueInWords);
						reportParams.put("pTotalAmt",totalCount);
						
						JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(dataList);
						JasperDesign jd = JRXmlLoader.load(reportName);
						JasperReport jr = JasperCompileManager.compileReport(jd);
						JasperPrint jp = JasperFillManager.fillReport(jr, reportParams,
								beanCollectionDataSource);
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
				else
				{
				List listInvoice=new ArrayList();
				String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptInvoiceFormat.jrxml");
				List<clsInvoiceFormatBean> dataList = new ArrayList<clsInvoiceFormatBean>();
				
				List listInvoiceSummary=new ArrayList();
				
				@SuppressWarnings("rawtypes")
				
				HashMap reportParams = new HashMap();
				double total=0.0;
				double totalCount=0.0;
				String sqlParametersFromBill = "SELECT a.strFolioNo,a.strRoomNo,a.strRegistrationNo,a.strReservationNo, DATE(b.dteArrivalDate),b.tmeArrivalTime, "
						+ " IFNULL(DATE(b.dteDepartureDate),'NA'), IFNULL(b.tmeDepartureTime,'NA'), IFNULL(d.strGuestPrefix,''),"
						+ " IFNULL(d.strFirstName,''), IFNULL(d.strMiddleName,''), IFNULL(d.strLastName,''), b.intNoOfAdults,b.intNoOfChild,"
						+ " a.strBillNo,IFNULL(d.strDefaultAddr,''), IFNULL(d.strAddressLocal,''), IFNULL(d.strCityLocal,''), "
						+ " IFNULL(d.strStateLocal,''), IFNULL(d.strCountryLocal,''),d.intPinCodeLocal, IFNULL(d.strAddrPermanent,''), "
						+ " IFNULL(d.strCityPermanent,''), IFNULL(d.strStatePermanent,''), IFNULL(d.strCountryPermanent,''),d.intPinCodePermanent, "
						+ " IFNULL(d.strAddressOfc,''), IFNULL(d.strCityOfc,''), IFNULL(d.strStateOfc,''), "
						+ " IFNULL(d.strCountryOfc,''),d.intPinCodeOfc,a.strGSTNo,a.strCompanyName, "
						+ "d.lngMobileNo,"
						+ "IFNULL(d.intPinCodeOfc,'')"
						+ " FROM tblbillhd a LEFT OUTER JOIN tblcheckinhd b ON a.strCheckInNo=b.strCheckInNo"
						+ " LEFT OUTER JOIN tblcheckindtl c ON b.strCheckInNo=c.strCheckInNo AND a.strRoomNo=c.strRoomNo"
						+ " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode"
						+ " WHERE a.strCheckInNo='"
						+ checkInNo
						+ "' AND c.strPayee='Y' AND a.strClientCode='"+clientCode+"' ORDER BY c.strPayee DESC";
	
				List listOfParametersFromBill = objFolioService.funGetParametersList(sqlParametersFromBill);
	
				if (listOfParametersFromBill.size() > 0) {
					Object[] arr = (Object[]) listOfParametersFromBill.get(0);
					registrationNo = arr[2].toString();
					reservationNo = arr[3].toString();
					String arrivalDate = arr[4].toString();
					String arrivalTime = arr[5].toString();
					String departureDate = arr[6].toString();
					String departureTime = arr[7].toString();
					String gPrefix = arr[8].toString();
					String gFirstName = arr[9].toString();
					String gMiddleName = arr[10].toString();
					String gLastName = arr[11].toString();
					String adults = arr[12].toString();
					String childs = arr[13].toString();
				    String billNumber = arr[14].toString();
	
					String guestAddr = "";
					if (arr[15].toString().equalsIgnoreCase("Permanent")) { // check
																			// default
																			// addr
						guestAddr = arr[21].toString() + "," + arr[22].toString()
								+ "," + arr[23].toString() + ","
								+ arr[24].toString() + "," + arr[25].toString();
					} else if (arr[15].toString().equalsIgnoreCase("Office")) {
						guestAddr = arr[26].toString() + "," + arr[27].toString()
								+ "," + arr[28].toString() + ","
								+ arr[29].toString() + "," + arr[30].toString();
					} else { // Local
						guestAddr = arr[16].toString() + "," + arr[17].toString()
								+ "," + arr[18].toString() + ","
								+ arr[19].toString() + "," + arr[20].toString();
					}
					GSTNo = arr[31].toString();
					companyName = arr[32].toString();
					String strMobileNo = arr[33].toString();
					String remark="";
					String sql="SELECT a.strRemark FROM tblbilldiscount a WHERE a.strBillNo = '"+billNo+"' AND a.strClientCode='"+clientCode+"'";
					List listremark = objFolioService.funGetParametersList(sql);
					if(listremark!=null && listremark.size()>0){
						remark=listremark.get(0).toString();
					}
					String sqlCheckOutTime = "select Distinct(TIME_FORMAT(SUBSTR(a.dteDateEdited,11),'%h:%i %p')) as Checkout_Time "
							+ "from tblbillhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
					List listCheckOutTime = objFolioService.funGetParametersList(sqlCheckOutTime);
					String chkOutTime=listCheckOutTime.get(0).toString();
					clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
					String hsnCode = objPropertySetupModel.getStrHscCode();
					String panno = objPropertySetupModel.getStrPanNo();
					String bankDtl = objPropertySetupModel.getStrBankAcName();
					String bankAcNo = objPropertySetupModel.getStrBankAcNumber();
					String bankIFSC = objPropertySetupModel.getStrBankIFSC();
					String branchnName = objPropertySetupModel.getStBranchName();
					String guestCompanyAddress="";
					guestCompanyAddress = arr[26].toString() + ","
							+ arr[27].toString() + ","
							+ arr[28].toString() + ","
							+ arr[29].toString() + ","
							+ arr[30].toString();				
					
					//Fill data 					
					reportParams.put("pCompanyPAN", panno);
					reportParams.put("pCompanyName", companyName);
					reportParams.put("strImagePath", imagePath);
					reportParams.put("pGuestName", gPrefix + " " + gFirstName + " "+ gMiddleName + " " + gLastName);
					reportParams.put("pInvoiceDated",objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
					reportParams.put("pInvoiceNO", billNumber);reportParams.put("PBuyerAddress", guestCompanyAddress);
					reportParams.put("pCompanyGSTINTop", GSTNo);					
					reportParams.put("pForMessageBot","for SYMBIOSIS - SANDIPANI");
					reportParams.put("pCompanyGSTINAboveName","44 Sandipani Campus (2019-20)");

					
					int countt=1;
					if(clientCode.equalsIgnoreCase("320.001"))
					{
						String strIssue = "Issued Subject to Nashik Jurisdiction";
						String strAddr = "Mumbai Agra Road,Nashik-422009.Ph.+91253-2325000 E-mail:suryanasik@gmail.com";
					
						
					}
					// get bill details
					String sqlBillDtl = "SELECT date(b.dteDocDate),b.strDocNo,IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),'') "
							+ ",sum(b.dblDebitAmt),sum(b.dblCreditAmt),sum(b.dblBalanceAmt),a.strBillNo,c.strRoomDesc,a.strFolioNo,d.strHsnSac"
							+ " FROM tblbillhd a inner join tblbilldtl b ON a.strFolioNo=b.strFolioNo ,tblroom c ,tblroomtypemaster d"
							+ " WHERE a.strCheckInNo='"
							+ checkInNo
							+ "' and a.strBillNo=b.strBillNo and a.strRoomNo=c.strRoomCode and a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' and d.strRoomTypeCode=c.strRoomTypeCode "
						    + " group by b.strPerticulars"
									+ " ORDER BY a.strBillNo";
				
					
					List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
					
					for (int i = 0; i < billDtlList.size(); i++) {
						Object[] folioArr = (Object[]) billDtlList.get(i);
	
						String docDate = folioArr[0].toString();
						if (folioArr[1] == null) {
							continue;
						} else {
							clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
	                        
							String docNo = folioArr[1].toString();
							String strPerticulars = folioArr[2].toString();
							String debitAmount = folioArr[3].toString();
							String creditAmount = folioArr[4].toString();
							String balance = folioArr[5].toString();
							if (!billNo.contains(folioArr[6].toString())) {
								billNo.add(folioArr[6].toString());
							}
							if(strPerticulars.equalsIgnoreCase("Room Tariff"))
							{
								count++;
							}
							
							if (!roomNo.contains(folioArr[7].toString())) {
								roomNo = roomNo + "," + folioArr[7].toString();
							}
							if (!folio.contains(folioArr[8].toString())) {
								folio = folio + "," + folioArr[8].toString();
							}
							clsInvoiceFormatBean objInvoiceFormatHsnBean = new clsInvoiceFormatBean();
							billPrintingBean.setStrDescGoods(strPerticulars);
							billPrintingBean.setStrDescGoodsOutput("");
							billPrintingBean.setStrAmount(Double.parseDouble(debitAmount));
							billPrintingBean.setStrRate("");
							total=total+Double.parseDouble(debitAmount);
							if(billPrintingBean.getStrAmount()>0)
							{
								totalCount=totalCount+Double.parseDouble(debitAmount);	
								billPrintingBean.setStrSrNo(String.valueOf(countt));
								dataList.add(billPrintingBean);
								countt++;
							}
						}
					}
					for(int cnt=0;cnt<billNo.size();cnt++){
					String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
							+ " WHERE a.strBillNo='"
							+ billNo.get(cnt)
							+ "' and strClientCode='" + clientCode + "' ";

					List billDiscList = objFolioService.funGetParametersList(sqlDisc);
					for (int i = 0; i < billDiscList.size(); i++) {
						Object[] billDicArr = (Object[]) billDiscList.get(i);

						clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
						String docDate = billDicArr[0].toString();
						String docNo = billDicArr[1].toString();
						String particulars = billDicArr[2].toString();
						String debitAmount = billDicArr[3].toString();
						String creditAmount = billDicArr[4].toString();
						String balance = billDicArr[4].toString();
						folioPrintingBean.setStrDescGoods(particulars);
						folioPrintingBean.setDblAmount(Double.parseDouble(creditAmount));
						if(folioPrintingBean.getStrAmount()>0)
						{
							dataList.add(folioPrintingBean);
							totalCount=totalCount-Double.parseDouble(creditAmount);
							folioPrintingBean.setStrSrNo(String.valueOf(countt));
							total=total-Double.parseDouble(creditAmount);
							countt++;
						}
					}
					}
					
					sqlBillDtl = "SELECT DATE(a.dteBillDate),b.strTaxDesc,sum(b.dblTaxAmt),0,c.dblTaxValue,ifnull(f.strHsnSac,''),b.strTaxCode,"
							+ " sum(b.dblTaxableAmt),ifnull(CONCAT(f.strHsnSac,' - ',b.strTaxDesc),'')"
							+ " FROM tblbillhd a, tblbilltaxdtl b,tbltaxmaster c,tblroom  e,tblroomtypemaster f"
							+ " WHERE a.strBillNo=b.strBillNo and b.strTaxCode=c.strTaxCode"
							+ " AND a.strRoomNo=e.strRoomCode AND e.strRoomTypeCode=f.strRoomTypeCode"
							+ " AND a.strCheckInNo='"+checkInNo+"'  "
							+ " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
							+ " group by b.strTaxCode,f.strHsnSac;";
					List listBillTaxDtl = objWebPMSUtility.funExecuteQuery(
							sqlBillDtl, "sql");
					for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
						Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
						clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
						billPrintingBean.setStrDescGoods("");
						billPrintingBean.setStrDescGoodsOutput(arrObjBillTaxDtl[8].toString());
						billPrintingBean.setStrAmount(Double.parseDouble(arrObjBillTaxDtl[2].toString()));
						String converted=arrObjBillTaxDtl[4].toString();
						billPrintingBean.setStrRate(converted.split("\\.")[0]+"%");
						total=total+Double.parseDouble(arrObjBillTaxDtl[2].toString());
//						if(billPrintingBean.getStrAmount()>0)
//						{
							totalCount=totalCount+Double.parseDouble(arrObjBillTaxDtl[2].toString());	
							dataList.add(billPrintingBean);
						//}					     
					}
					
				    Map<String,clsInvoiceFormatBean> mapInvoice=new HashMap<>();
					String sqlTaxRTDtl="SELECT (a.dteBillDate),b.strTaxDesc,sum(b.dblTaxAmt),0,c.dblTaxValue,ifnull(f.strHsnSac,''),b.strTaxCode, "
                                       + " sum(b.dblTaxableAmt),ifnull(CONCAT(f.strHsnSac,' - ',b.strTaxDesc),'')  "
                                       + " FROM tblbillhd a,tblbilldtl g ,tblbilltaxdtl b,tbltaxmaster c,tblroom  e,tblroomtypemaster f  "
                                       + " WHERE a.strBillNo=b.strBillNo  "
                                       + " and a.strBillNo=g.strBillNo and g.strBillNo=b.strBillNo and g.strDocNo=b.strDocNo  "
                                       + " and b.strTaxCode=c.strTaxCode  "
                                       + " AND a.strRoomNo=e.strRoomCode  "
                                       + " AND e.strRoomTypeCode=f.strRoomTypeCode AND a.strCheckInNo='"+checkInNo+"' and g.strPerticulars='Room Tariff'  "
                                       + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'  "
                                       + " group by b.strTaxCode,f.strHsnSac; ";
					List listTaxDetail = objWebPMSUtility.funExecuteQuery(sqlTaxRTDtl, "sql");
					if(listTaxDetail.size()>0)
					{
						clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
						for (int cnt = 0; cnt < listTaxDetail.size(); cnt++) 
						{
						
						
							Object[] arrObjRTTaxDtl = (Object[]) listTaxDetail.get(cnt);
							
							if(mapInvoice.containsKey(arrObjRTTaxDtl[5].toString()))
						    {
								billPrintingBean =mapInvoice.get(arrObjRTTaxDtl[5].toString());
								double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
								billPrintingBean.setDblTaxableValue(taxableAmt);
								if(arrObjRTTaxDtl[1].toString().contains("C.GST 6 % Room Rent"))
								{
									String converted=arrObjRTTaxDtl[4].toString();
									billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
									billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
								}
								if(arrObjRTTaxDtl[1].toString().contains("S.GST 6 % Room Rent"))
								{
									String converted=arrObjRTTaxDtl[4].toString();
									billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
									billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
								}
								 
							}
							else
							{
								billPrintingBean = new clsInvoiceFormatBean();
								billPrintingBean.setStrHsn(arrObjRTTaxDtl[5].toString());
								billPrintingBean.setDblTaxableValue(Double.parseDouble(arrObjRTTaxDtl[7].toString()));
								
								if(arrObjRTTaxDtl[1].toString().contains("C.GST 6 % Room Rent"))
								{
									String converted=arrObjRTTaxDtl[4].toString();
									double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
									billPrintingBean.setDblTaxableValue(taxableAmt);
									billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
									billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
									
								}
								if(arrObjRTTaxDtl[1].toString().contains("S.GST 6 % Room Rent"))
								{
									String converted=arrObjRTTaxDtl[4].toString();
									billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
									billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
								}
								mapInvoice.put(arrObjRTTaxDtl[5].toString(), billPrintingBean);								
							}							
						}
					}					
					
					String sqlTaxIHDtl="select (a.dteBillDate),c.strTaxDesc,sum(c.dblTaxAmt),0,d.dblTaxValue, f.strHsnSac,c.strTaxCode, "
										+ "sum(c.dblTaxableAmt),CONCAT(f.strHsnSac,' - ',c.strTaxDesc) "
										+ " from tblbillhd a ,tblbilldtl b,tblbilltaxdtl c,tbltaxmaster d ,tblincomehead f  "
										+ " where a.strBillNo=b.strBillNo and b.strBillNo=c.strBillNo and b.strDocNo=c.strDocNo  " 
										+ " and a.strBillNo=c.strBillNo and d.strIncomeHeadCode=f.strIncomeHeadCode AND b.strRevenueCode=f.strIncomeHeadCode "
										+ " and  a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
										+ " group by c.strTaxCode;";
					listTaxDetail = objWebPMSUtility.funExecuteQuery(sqlTaxIHDtl, "sql");
					if(listTaxDetail.size()>0)
					{
						clsInvoiceFormatBean billPrintingBean = new clsInvoiceFormatBean();
						for (int cnt = 0; cnt < listTaxDetail.size(); cnt++) 
						{
                            Object[] arrObjRTTaxDtl = (Object[]) listTaxDetail.get(cnt);
							if(mapInvoice.containsKey(arrObjRTTaxDtl[5].toString()))
						    {	
								billPrintingBean =mapInvoice.get(arrObjRTTaxDtl[5].toString());
								double taxableAmt=billPrintingBean.getDblTaxableValue()+Double.parseDouble(arrObjRTTaxDtl[7].toString());
								billPrintingBean.setDblTaxableValue(taxableAmt);
								String converted=arrObjRTTaxDtl[4].toString();
								billPrintingBean.setStrStateTaxRate(converted.split("\\.")[0]+"%");
								billPrintingBean.setDblStateTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
						    }
							else
							{
								billPrintingBean =new clsInvoiceFormatBean();
								billPrintingBean.setStrHsn(arrObjRTTaxDtl[5].toString());
								billPrintingBean.setDblTaxableValue(Double.parseDouble(arrObjRTTaxDtl[7].toString()));
								String converted=arrObjRTTaxDtl[4].toString();
								billPrintingBean.setStrCentralTaxRate(converted.split("\\.")[0]+"%");
								billPrintingBean.setDblCentralTaxAmount(Double.parseDouble(arrObjRTTaxDtl[2].toString()));
								mapInvoice.put(arrObjRTTaxDtl[5].toString(), billPrintingBean);
							}
						}
					}
					
					for(Map.Entry<String,clsInvoiceFormatBean> entry : mapInvoice.entrySet()){
						clsInvoiceFormatBean objDtlBean =entry.getValue();
						double taxAmt=objDtlBean.getDblStateTaxAmount()+objDtlBean.getDblCentralTaxAmount();
						objDtlBean.setDblTotalAmt(taxAmt);
						listInvoice.add(entry.getValue());
						
					}
					flgBillRecord = true;
				}	
				if (flgBillRecord) {
					// get payment details
					String sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
							+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
							+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
							+ " and c.strReservationNo='"
							+ reservationNo
							+ "' and c.strAgainst='Reservation' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
					List paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
					for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							String debitAmount = paymentArr[3].toString();
							String creditAmount = paymentArr[4].toString();
							String balance = paymentArr[5].toString();
							folioPrintingBean.setStrDescGoodsOutput(particulars);
							if(folioPrintingBean.getStrAmount()>0)
							{
								dataList.add(folioPrintingBean);
								totalCount=totalCount+Double.parseDouble(creditAmount);	
							}
						}
					}
	
					if (!(paymentDtlList.size() > 0)) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and c.strRegistrationNo='"
								+ registrationNo
								+ "' and c.strAgainst='Check-In' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List checkInReceiptDtl = objFolioService.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < checkInReceiptDtl.size(); i++) {
							Object[] paymentArr = (Object[]) checkInReceiptDtl
									.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
								String debitAmount = paymentArr[3].toString();
								String creditAmount = paymentArr[4].toString();
								String balance = paymentArr[5].toString();
								folioPrintingBean.setStrDescGoodsOutput(particulars);
								if(folioPrintingBean.getStrAmount()>0)
								{
									dataList.add(folioPrintingBean);
									totalCount=totalCount+Double.parseDouble(creditAmount);	
								}
								
							}
						}
					}
	
					for (int cnt = 0; cnt < billNo.size(); cnt++) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblbillhd a,tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where a.strBillNo=c.strBillNo and c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and a.strBillNo='"
								+ billNo.get(cnt)
								+ "' and c.strAgainst='Bill' AND a.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List billReceitDtl = objFolioService
								.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < billReceitDtl.size(); i++) {
							Object[] paymentArr = (Object[]) billReceitDtl.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
								String debitAmount = paymentArr[3].toString();
								String creditAmount = paymentArr[4].toString();
								String balance = paymentArr[5].toString();
								folioPrintingBean.setStrDescGoodsOutput(particulars);
								if(folioPrintingBean.getStrAmount()>0)
								{
									dataList.add(folioPrintingBean);
									totalCount=totalCount+Double.parseDouble(creditAmount);	
								}
							}
						}
	
 					
					}
				}
				String walkIn="";
				String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
				List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
				for(int i = 0;i<listWalkIn.size();i++)
				{
					walkIn = listWalkIn.get(i).toString();
				}
				String walkInDiscount = "SELECT DATE(a.dtDate),'',CONCAT('Discount ',a.dblDiscount,'%' ),a.dblRoomRate,"
						+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
						+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"' group by a.dblDiscount";
				List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
				for (int i = 0; i < walkInBillDiscList.size(); i++) {
					Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
	
					clsInvoiceFormatBean folioPrintingBean = new clsInvoiceFormatBean();
					String docDate = billWalkDicArr[0].toString();
					String docNo = billWalkDicArr[1].toString();
					String particulars = billWalkDicArr[2].toString();
					double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
					double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
					double balance =0.0;
					if(creditAmount==0)
					{
					}
					else
					{
						balance  = balance +  - (creditAmount/100)*debitAmount;
						creditAmount = debitAmount*creditAmount/100;
						if(count>0)
						{
							creditAmount = creditAmount*count;
						}
						balance = balance - creditAmount;
						folioPrintingBean.setStrDescGoodsOutput(particulars);	
						if(folioPrintingBean.getStrAmount()>0)
						{
							dataList.add(folioPrintingBean);
						}
						
					}
				}				
				String sqlCheckSupportVoucher="SELECT a.strPerticulars FROM tblbilldtl a,tblbillhd b WHERE b.strBillNo=a.strBillNo "
						+ " AND a.strBillNo ='"+billNo+"' AND a.strPerticulars!='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
				List list = objFolioService.funGetParametersList(sqlCheckSupportVoucher);
				if(list.size()>0)
				{
					pSupportVoucher="Yes";
				}
				else
				{
					pSupportVoucher="No";
				}
				clsNumberToWords obj1 = new clsNumberToWords();
				String totalInvoiceValueInWords = obj1.getNumberInWorld(totalCount, "");
				reportParams.put("listTaxDtl", listInvoice);
				reportParams.put("pAmtInWords",totalInvoiceValueInWords);
				reportParams.put("pTotalAmt",totalCount);
				
				JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(dataList);
				JasperDesign jd = JRXmlLoader.load(reportName);
				JasperReport jr = JasperCompileManager.compileReport(jd);
				JasperPrint jp = JasperFillManager.fillReport(jr, reportParams,
						beanCollectionDataSource);
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
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value="/loadBillDetails",method=RequestMethod.GET)
	public @ResponseBody List<clsVoidBillBean> funLoadVoidBill(@RequestParam("strBillNo")String strBillNo,HttpServletRequest req)
	{
		List<clsVoidBillBean> listVoidDtl=new ArrayList();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String sql=" select a.strBillNo,a.strFolioNo,a.dteBillDate,a.dblGrandTotal ," //3
				+ " ifnull(b.strPerticulars,''),ifnull(sum(b.dblDebitAmt),0),ifnull(sum(b.dblCreditAmt),0),ifnull(b.dblBalanceAmt,0),"
				+ " c.strGuestCode,IFNULL(d.strFirstName,''),IFNULL(d.strLastName,''),e.strRoomDesc ,IFNULL(b.strDocNo,''),a.strRoomNo,IFNULL(b.strRevenueCode,'')"
				+ " from tblbillhd a left outer join tblbilldtl b on a.strBillNo=b.strBillNo "
				+ " left outer join tblcheckindtl c on a.strCheckInNo=c.strCheckInNo "
				+ " left outer join tblguestmaster d on c.strGuestCode=d.strGuestCode "
				+ " left outer join tblroom e on c.strRoomNo=e.strRoomCode "
				+ " where a.strBillNo='"+strBillNo+"' and a.strRoomNo=e.strRoomCode "
				+ " group by b.strDocNo;";
		
		List listBillDetails = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(null!=listBillDetails){
			if(listBillDetails.size()>0){
				clsVoidBillBean obVoidBean;
				for(int i=0;i<listBillDetails.size();i++){
					obVoidBean=new clsVoidBillBean();
					
					Object ob[]=(Object[]) listBillDetails.get(i);
					obVoidBean.setStrBillNo(ob[0].toString());
					obVoidBean.setStrFolioNo(ob[1].toString());
					obVoidBean.setStrBilldate(ob[2].toString());
					obVoidBean.setDblTotalAmt(Double.parseDouble(ob[3].toString()));
					obVoidBean.setStrMenuHead(ob[4].toString());
					obVoidBean.setDblIncomeHeadPrice(Double.parseDouble(ob[5].toString())-Double.parseDouble(ob[6].toString()));
					obVoidBean.setStrGuestCode(ob[8].toString());
					obVoidBean.setStrGuestName(ob[9].toString()+" "+ob[10].toString());
					obVoidBean.setStrRoomNo(ob[13].toString());
					obVoidBean.setStrDocNo(ob[12].toString());
					obVoidBean.setStrRoomName(ob[11].toString());
					obVoidBean.setStrRevenueCode(ob[14].toString());
					
					listVoidDtl.add(obVoidBean);
				}
			}
		}
		
		return listVoidDtl;
	}
	
	
	@RequestMapping(value="/loadBillDetailsForCheckin",method=RequestMethod.GET)
	public @ResponseBody List<clsVoidBillBean> funLoadCheckInBill(@RequestParam("strBillNo")String strCheckInNo,HttpServletRequest req)
	{
		List<clsVoidBillBean> listVoidDtl=new ArrayList();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String sql=" select a.strBillNo,a.strFolioNo,a.dteBillDate,a.dblGrandTotal ," //3
				+ " ifnull(b.strPerticulars,''),ifnull(sum(b.dblDebitAmt),0),ifnull(sum(b.dblCreditAmt),0),ifnull(b.dblBalanceAmt,0),"
				+ " c.strGuestCode,IFNULL(d.strFirstName,''),IFNULL(d.strLastName,''),e.strRoomDesc ,IFNULL(b.strDocNo,''),a.strRoomNo,IFNULL(b.strRevenueCode,'')"
				+ " from tblbillhd a left outer join tblbilldtl b on a.strBillNo=b.strBillNo "
				+ " left outer join tblcheckindtl c on a.strCheckInNo=c.strCheckInNo "
				+ " left outer join tblguestmaster d on c.strGuestCode=d.strGuestCode "
				+ " left outer join tblroom e on c.strRoomNo=e.strRoomCode "
				+ " where a.strCheckInNo='"+strCheckInNo+"' and a.strRoomNo=e.strRoomCode "
				+ " group by b.strDocNo;";
		
		List listBillDetails = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(null!=listBillDetails){
			if(listBillDetails.size()>0){
				clsVoidBillBean obVoidBean;
				for(int i=0;i<listBillDetails.size();i++){
					obVoidBean=new clsVoidBillBean();
					
					Object ob[]=(Object[]) listBillDetails.get(i);
					obVoidBean.setStrBillNo(ob[0].toString());
					obVoidBean.setStrFolioNo(ob[1].toString());
					obVoidBean.setStrBilldate(ob[2].toString());
					obVoidBean.setDblTotalAmt(Double.parseDouble(ob[3].toString()));
					obVoidBean.setStrMenuHead(ob[4].toString());
					obVoidBean.setDblIncomeHeadPrice(Double.parseDouble(ob[5].toString())-Double.parseDouble(ob[6].toString()));
					obVoidBean.setStrGuestCode(ob[8].toString());
					obVoidBean.setStrGuestName(ob[9].toString()+" "+ob[10].toString());
					obVoidBean.setStrRoomNo(ob[13].toString());
					obVoidBean.setStrDocNo(ob[12].toString());
					obVoidBean.setStrRoomName(ob[11].toString());
					obVoidBean.setStrRevenueCode(ob[14].toString());
					
					listVoidDtl.add(obVoidBean);
				}
			}
		}
		
		return listVoidDtl;
	}
	
	public double funGetRoomTariffData(String billNo,String folio, String registrationNo,String clientCode,String checkInNo ) throws Exception
	{
		double pRoomTariff=0.0;
		List dataList = new ArrayList<>();
		double balance=0.0;
		int count = 0;
		boolean flgBillRecord=false;
		Map<String,clsBillPrintingBean> hmTax=new HashMap<>();
		Map<String,clsBillPrintingBean> hmParticulars=new HashMap<>();
		String sqlBillDtl="";
		sqlBillDtl = "SELECT DATE(b.dteDocDate),b.strDocNo,"
					+ "IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),b.dblDebitAmt,b.dblCreditAmt,"
					+ "b.dblBalanceAmt FROM tblbillhd a INNER JOIN tblbilldtl b "
					+ "ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo "
					+ "WHERE a.strBillNo='"+billNo+"' and b.strPerticulars='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
		List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
		
		for (int i = 0; i < billDtlList.size(); i++) {
			Object[] folioArr = (Object[]) billDtlList.get(i);

			String docDate = folioArr[0].toString();
			if (folioArr[1] == null) {
				continue;
			} 
			else 
			{
				if(folioArr[2].toString().equals("Room Tariff"))
				{
					
					count++;
					clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();
					String docNo = folioArr[1].toString();
					String particulars = folioArr[2].toString();
					double debitAmount = Double.parseDouble(folioArr[3].toString());
					double creditAmount = Double.parseDouble(folioArr[4].toString());
					balance = balance + debitAmount - creditAmount;
					billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
					billPrintingBean.setStrDocNo(docNo);
					billPrintingBean.setStrPerticulars(particulars);
					billPrintingBean.setDblDebitAmt(debitAmount);
					billPrintingBean.setDblCreditAmt(creditAmount);
					billPrintingBean.setDblBalanceAmt(balance);
					pRoomTariff=balance;
					dataList.add(billPrintingBean);
					if(hmParticulars.containsKey(particulars))
					{
						clsBillPrintingBean bean=hmParticulars.get(particulars);
						hmParticulars.put(particulars, bean);
					}
					else
					{
						hmParticulars.put(particulars,billPrintingBean);
					}
					
					sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0"
							+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
							+ " AND a.strBillNo='"
							+ billNo
							+ "' and a.strDocNo='" + docNo + "' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
					List listBillTaxDtl = objBaseService.funGetListForWebPMS(new StringBuilder(sqlBillDtl), "sql");
					for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
						Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
						billPrintingBean = new clsBillPrintingBean();
						billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (arrObjBillTaxDtl[0].toString())));
						billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
						billPrintingBean.setStrPerticulars(arrObjBillTaxDtl[2].toString());
						double debitAmt = Double.parseDouble(arrObjBillTaxDtl[3].toString());
						double creditAmt = Double.parseDouble(arrObjBillTaxDtl[4].toString());
						balance = balance + debitAmt - creditAmt;

						billPrintingBean.setDblDebitAmt(debitAmt);
						billPrintingBean.setDblCreditAmt(creditAmt);
						billPrintingBean.setDblBalanceAmt(balance);
						pRoomTariff=balance;
						dataList.add(billPrintingBean);
						if(hmTax.containsKey(arrObjBillTaxDtl[2].toString())){
							clsBillPrintingBean bean1= new clsBillPrintingBean();
							bean1 =billPrintingBean;
							clsBillPrintingBean bean=hmTax.get(arrObjBillTaxDtl[2].toString());
							bean1.setDblBalanceAmt(bean.getDblBalanceAmt()+balance);
							hmTax.put(arrObjBillTaxDtl[2].toString(), bean1);
						}
						else
						{
							hmTax.put(arrObjBillTaxDtl[2].toString(), billPrintingBean);	
						}
					}
				}
				
			}
		}

		flgBillRecord = true;
	
	if (flgBillRecord) 
	{
		
		List paymentDtlList=new ArrayList<>();
		String sqlPaymentDtl="";

		sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,CONCAT('ADVANCE ',e.strSettlementDesc),'0.00' as debitAmt "
					+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
					+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
					+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode AND c.strFolioNo='"+folio+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";

		 paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
		 for (int i = 0; i < paymentDtlList.size(); i++) 
		 {
			Object[] paymentArr = (Object[]) paymentDtlList.get(i);
			String docDate = paymentArr[0].toString();
			if (paymentArr[1] == null) 
			{
				continue;
			} 
			else 
			{
				clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
				String docNo = paymentArr[1].toString();
				String particulars = paymentArr[2].toString();
				double debitAmount = Double.parseDouble(paymentArr[3].toString());
				double creditAmount = Double.parseDouble(paymentArr[4].toString());
				balance = balance + debitAmount - creditAmount;
				folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
				folioPrintingBean.setStrDocNo(docNo);
				folioPrintingBean.setStrPerticulars(particulars);
				folioPrintingBean.setDblDebitAmt(debitAmount);
				folioPrintingBean.setDblCreditAmt(creditAmount);
				folioPrintingBean.setDblBalanceAmt(balance);
				pRoomTariff=balance;
				dataList.add(folioPrintingBean);
			}
		}
			
		if (!(paymentDtlList.size() > 0)) 
		{
			sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
					+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
					+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
					+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
					+ " and c.strRegistrationNo='"+registrationNo+"' and c.strAgainst='Check-In' AND  c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";

			List checkInReceiptDtl = objFolioService.funGetParametersList(sqlPaymentDtl);
			for (int i = 0; i < checkInReceiptDtl.size(); i++) 
			{
				Object[] paymentArr = (Object[]) checkInReceiptDtl.get(i);
				String docDate = paymentArr[0].toString();
				if (paymentArr[1] == null) 
				{
					continue;
				}
				else 
				{
					clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
					balance = balance +  Double.parseDouble(paymentArr[3].toString()) - Double.parseDouble(paymentArr[4].toString());
					folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
					folioPrintingBean.setStrDocNo(paymentArr[1].toString());
					folioPrintingBean.setStrPerticulars( paymentArr[2].toString());
					folioPrintingBean.setDblDebitAmt( Double.parseDouble(paymentArr[3].toString()));
					folioPrintingBean.setDblCreditAmt(Double.parseDouble(paymentArr[4].toString()));
					folioPrintingBean.setDblBalanceAmt(balance);
					pRoomTariff=balance;
					dataList.add(folioPrintingBean);
				}
			}
		}
		
		String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
				+ " WHERE a.strBillNo='"+billNo+"' and strClientCode='" + clientCode + "' ";

		List billDiscList = objBaseService.funGetListForWebPMS(new StringBuilder(sqlDisc), "sql");
		for (int i = 0; i < billDiscList.size(); i++) 
		{
			Object[] billDicArr = (Object[]) billDiscList.get(i);

			clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
			String docDate = billDicArr[0].toString();
			String docNo = billDicArr[1].toString();
			String particulars = billDicArr[2].toString();

			double debitAmount = Double.parseDouble(billDicArr[3].toString());
			double creditAmount = Double.parseDouble(billDicArr[4].toString());
			balance = balance + debitAmount - creditAmount;
			folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
			folioPrintingBean.setStrDocNo(docNo);
			folioPrintingBean.setStrPerticulars(particulars);
			folioPrintingBean.setDblDebitAmt(debitAmount);
			folioPrintingBean.setDblCreditAmt(creditAmount);
			folioPrintingBean.setDblBalanceAmt(balance);
			pRoomTariff=balance;
			dataList.add(folioPrintingBean);
		}
			
		String walkIn = "";
		String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
		List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
		for(int i = 0;i<listWalkIn.size();i++)
		{
			walkIn = listWalkIn.get(i).toString();
		}
		String walkInDiscount = "SELECT DATE(a.dtDate),'','Discount',a.dblRoomRate,"
				+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
				+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"'";
		List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
		for (int i = 0; i < walkInBillDiscList.size(); i++) 
		{
			Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
			clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
			String docDate = billWalkDicArr[0].toString();
			String docNo = billWalkDicArr[1].toString();
			String particulars = billWalkDicArr[2].toString();
			double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
			double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
			if(creditAmount==0)
			{
				
			}
			else
			{
				/*balance  = balance   - (creditAmount/100)*debitAmount;*/
				creditAmount = debitAmount*creditAmount/100;
				if(count>0)
				{
					creditAmount = creditAmount*count;
				}
				balance = balance - creditAmount;
				folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
				folioPrintingBean.setStrDocNo(docNo);
				folioPrintingBean.setStrPerticulars(particulars);
				folioPrintingBean.setDblDebitAmt(0.0);
				folioPrintingBean.setDblCreditAmt(creditAmount);
				folioPrintingBean.setDblBalanceAmt(balance);
				pRoomTariff=balance;
				dataList.add(folioPrintingBean);
			}
		}
		}
		return pRoomTariff;
	}	
	
	//Bill Printing Format 1
	@RequestMapping(value = "/rptBillPrintingFormat1", method = RequestMethod.GET)
	public void funGenerateBillPrintingReportFormat1(@RequestParam("fromDate") String fromDate,@RequestParam("toDate") String toDate,
			@RequestParam("billNo") String billNo,@RequestParam("strSelectBill") String strSelectBill, HttpServletRequest req,HttpServletResponse resp) 
	{
		try 
		{
			boolean flgBillRecord = false;
			String registrationNo = "";
			String reservationNo = "";
			double balance = 0.0;
			String GSTNo = "", companyName = "";
			String folio="";
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		
			
			String pSupportVoucher="";
			String pSupportVoucherTextFielf="";
			double pRoomTariff=0.0;
			double dblTotalRoomTarrif = 0.0;
			int count=0;
			String billNames = "";
			
			String temp[] ={};
			if(strSelectBill.length()>0)
			{
				temp = strSelectBill.split(",");
			}
			
			for (int i = 0; i < temp.length; i++) {
				if (billNames.length()>=0) {
					billNames+="'"+temp[i]+"',";
				}
			}
			
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode); // mms
																			// property
																			// setup
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}

			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptBillPrintingFormat1.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");			
			String imagePath1 = "";
					/*servletContext
					.getRealPath("/resources/images/company_Logo1.png");*/

			List<clsBillPrintingBean> dataList = new ArrayList<clsBillPrintingBean>();
			@SuppressWarnings("rawtypes")
			HashMap reportParams = new HashMap();
			Map<String,clsBillPrintingBean> hmTax=new HashMap<>();
			Map<String,clsBillPrintingBean> hmParticulars=new HashMap<>();
			// get all parameters
			/*
			 * String sqlParametersFromBill =
			 * "SELECT a.strFolioNo,a.strRoomNo,a.strRegistrationNo,a.strReservationNo"
			 * + " ,b.dteArrivalDate,b.tmeArrivalTime " +
			 * ",ifnull(b.dteDepartureDate,'NA'),ifnull(b.tmeDepartureTime,'NA') "
			 * +
			 * " ,ifnull(d.strGuestPrefix,''),ifnull(d.strFirstName,''),ifnull(d.strMiddleName,''),ifnull(d.strLastName,'') "
			 * + ",b.intNoOfAdults,b.intNoOfChild" + " ,a.strBillNo " +
			 * " FROM tblbillhd a LEFT OUTER JOIN tblreservationhd b ON a.strReservationNo=b.strReservationNo "
			 * +
			 * " LEFT OUTER JOIN tblreservationdtl c ON b.strReservationNo=c.strReservationNo AND a.strRoomNo=c.strRoomNo "
			 * +
			 * " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode "
			 * + " where a.strBillNo='" + billNo + "' ";
			 */

			List<String> listCheckInNo = new ArrayList<>();
			String checkInNo = "";
			String sqlParametersFromBill = " SELECT a.strFolioNo,e.strRoomDesc,a.strRegistrationNo,a.strReservationNo ,date(b.dteArrivalDate),b.tmeArrivalTime , "
					+ " ifnull(date(b.dteDepartureDate),'NA'),ifnull(b.tmeDepartureTime,'NA')  , ifnull(d.strGuestPrefix,''), "
					+ " ifnull(d.strFirstName,''),ifnull(d.strMiddleName,''),ifnull(d.strLastName,'') , "
					+ " b.intNoOfAdults,b.intNoOfChild ,a.strBillNo ,IFNULL(d.strGuestCode,''),a.strGSTNo,a.strCompanyName,b.strCheckInNo,c.strPayee,g.strBookingTypeDesc,h.strPlanDesc"// 19
					+ " FROM tblbillhd a  "
					+ " LEFT OUTER JOIN tblcheckinhd  b ON a.strCheckInNo=b.strCheckInNo "
					+ " LEFT OUTER JOIN tblcheckindtl c ON b.strCheckInNo=c.strCheckInNo AND a.strRoomNo=c.strRoomNo  "
					+ " LEFT OUTER JOIN tblguestmaster d ON c.strGuestCode=d.strGuestCode  "
					+ " LEFT OUTER JOIN tblroom e ON e.strRoomCode=a.strRoomNo "
					+ " LEFT OUTER JOIN tblreservationhd f ON a.strReservationNo=f.strReservationNo "
					+ " LEFT OUTER JOIN tblbookingtype g ON f.strBookingTypeCode=g.strBookingTypeCode "
					+ " LEFT OUTER JOIN tblplanmaster h ON b.strPlanCode=h.strPlanCode "
					+ " where a.strBillNo='"
					+ billNo
					+ "' and a.strClientCode='"+clientCode+"' and b.strClientCode='"+clientCode+"' and c.strClientCode='"+clientCode+"' "
					+ "and d.strClientCode='"+clientCode+"' and e.strClientCode='"+clientCode+"'"
					+ " order by c.strPayee DESC ";

			List listOfParametersFromBill = objFolioService
					.funGetParametersList(sqlParametersFromBill);

			if (listOfParametersFromBill.size() > 0) {
				Object[] arr = (Object[]) listOfParametersFromBill.get(0);

				// String guestcode =
				// objGuestMaster.funAddUpdateGuestMaster(objGuestMasterModel);

				String guestDtl = " select ifnull(d.strDefaultAddr,''),ifnull(d.strAddressLocal,''),ifnull(d.strCityLocal,''),ifnull(d.strStateLocal,''),ifnull(d.strCountryLocal,''),IFNULL(d.intPinCodeLocal,''),"// 20
						+ " ifnull(d.strAddrPermanent,''),ifnull(d.strCityPermanent,''),ifnull(d.strStatePermanent,''),ifnull(d.strCountryPermanent,''),IFNULL(d.intPinCodePermanent,''), "// 25
						+ " ifnull(d.strAddressOfc,''),ifnull(d.strCityOfc,''),ifnull(d.strStateOfc,''),ifnull(d.strCountryOfc,''),IFNULL(d.intPinCodeOfc,''),IFNULL(d.strGSTNo,''),IFNULL(d.lngMobileNo,0) "
						+ "from tblguestmaster d where d.strGuestCode=  '"
						+ arr[15].toString() + "' AND d.strClientCode='"+clientCode+"'";
				List listguest = objFolioService.funGetParametersList(guestDtl);
				// '"+arr[15].toString()+"'
				String guestgstNO = "";
				String strCustNo="";
				for (int i = 0; i < listguest.size(); i++) {
					Object[] arGuest = (Object[]) listguest.get(i);
					guestgstNO = arGuest[16].toString();
					strCustNo = arGuest[17].toString();
				}
				folio = arr[0].toString();
				String roomNo = arr[1].toString();
				registrationNo = arr[2].toString();
				reservationNo = arr[3].toString();
				String arrivalDate = arr[4].toString();
				String arrivalTime = arr[5].toString();
				String departureDate = arr[6].toString();
				String departureTime = arr[7].toString();
				String gPrefix = arr[8].toString();
				String strPayee = arr[19].toString();
				String gFirstName = arr[9].toString();
				String gMiddleName = arr[10].toString();
				String gLastName = arr[11].toString();
				String adults = arr[12].toString();
				String childs = arr[13].toString();
				checkInNo  = arr[18].toString();
				
				listCheckInNo.add(checkInNo);
				if (!arr[16].toString().equals("")) {
					GSTNo = arr[16].toString();
				}
				if (!arr[17].toString().equals("")) {
					companyName = arr[17].toString();
				}
				String guestAddr = "";
				String guestCompanyAddress = "";
				if (listguest.size() > 0) {
					Object[] arrGuest = (Object[]) listguest.get(0);
					if (arrGuest[0].toString().equalsIgnoreCase("Permanent")) { // check
																				// default
																				// addr
						guestAddr = arrGuest[6].toString() + ","
								+ arrGuest[7].toString() + ","
								+ arrGuest[8].toString() + ","
								+ arrGuest[9].toString() + ","
								+ arrGuest[10].toString();
					} else if (arrGuest[0].toString()
							.equalsIgnoreCase("Office")) {
						guestAddr = arrGuest[11].toString() + ","
								+ arrGuest[12].toString() + ","
								+ arrGuest[13].toString() + ","
								+ arrGuest[14].toString() + ","
								+ arrGuest[15].toString();
					} else { // Local
						guestAddr = arrGuest[1].toString() + ","
								+ arrGuest[2].toString() + ","
								+ arrGuest[3].toString() + ","
								+ arrGuest[4].toString() + ","
								+ arrGuest[5].toString();
					}
					
					guestCompanyAddress = arrGuest[11].toString() + ","
							+ arrGuest[12].toString() + ","
							+ arrGuest[13].toString() + ","
							+ arrGuest[14].toString() + ","
							+ arrGuest[15].toString();
				}
				
				String remark="";
				String sql="SELECT a.strRemark FROM tblbilldiscount a WHERE a.strBillNo = '"+billNo+"' AND a.strClientCode='"+clientCode+"'";
				List listremark = objFolioService.funGetParametersList(sql);
				if(listremark!=null && listremark.size()>0){
					remark=listremark.get(0).toString();
				}
				// String billNo = arr[14].toString();

 				String sqlCheckOutTime = "select TIME_FORMAT(SUBSTR(a.dteDateEdited,11),'%h:%i %p') as Checkout_Time "
						+ "from tblbillhd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
 				List listCheckOutTime = objFolioService.funGetParametersList(sqlCheckOutTime);
				String chkOutTime=listCheckOutTime.get(0).toString();
				
				clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
//				String noOfRoom = objPropertySetupModel.getStrRoomLimit();.
				
				String hsnCode = objPropertySetupModel.getStrHscCode();
				String panno = objPropertySetupModel.getStrPanNo();
				String bankDtl = objPropertySetupModel.getStrBankAcName();
				String bankAcNo = objPropertySetupModel.getStrBankAcNumber();
				String bankIFSC = objPropertySetupModel.getStrBankIFSC();
				String branchnName = objPropertySetupModel.getStBranchName();
				reportParams.put("phsnCode", hsnCode);
				reportParams.put("ppanno", panno);
				reportParams.put("pbankDtl", bankDtl);
				reportParams.put("pbankAcNo", bankAcNo);
				reportParams.put("pbankIFSC", bankIFSC);
				reportParams.put("pbranchnName", branchnName);
				reportParams.put("pCompanyName", companyName);
				reportParams.put("pGSTNo", GSTNo);
				reportParams.put("pAddress1", objSetup.getStrAdd1() + ","+ objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2",objSetup.getStrState() + ","+ objSetup.getStrCountry() + ","+ objSetup.getStrPin());
				
				reportParams.put("strImagePath", imagePath);
				reportParams.put("pGuestName", gPrefix + " " + gFirstName + " "+ gMiddleName + " " + gLastName);
				//reportParams.put("pFolioNo", folio);
				reportParams.put("pRoomNo", roomNo);
				//reportParams.put("pRegistrationNo", registrationNo);
				//reportParams.put("pReservationNo", reservationNo);
				reportParams.put("pArrivalDate",objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
				reportParams.put("pArrivalTime", arrivalTime);
				reportParams.put("pDepartureTime", chkOutTime);
				reportParams.put("pAdult", adults);
				
				reportParams.put("pGuestAddress", guestAddr);
				
				reportParams.put("strUserCode", userCode);
				reportParams.put("pBillNo", billNo);
				reportParams.put("pGuestNo", guestgstNO);
				reportParams.put("pGuestOfficeAddress", guestCompanyAddress);
				reportParams.put("pGuestNo", guestgstNO);
				reportParams.put("pstrCustNo", strCustNo);
				String billFooter=objPropertySetupModel.getStrBillFooter();
				
				reportParams.put("pBillFooter", billFooter.split(",")[0]);
				reportParams.put("pBillFooter1",billFooter.split(",")[1]);
			
				reportParams.put("strImagePath2",imagePath1);
				
				reportParams.put("pChild", childs);
				//reportParams.put("pRemarks", remark);
				
				if(arr[21]!=null) 
				{
					reportParams.put("pPlan", arr[21].toString());
				}
				else
				{
					reportParams.put("pPlan", null);
				}
				if(arr[20]!=null)
				{
					reportParams.put("pBookedBy",arr[20].toString());
				}
				else
				{
					reportParams.put("pBookedBy",null);
					
				}
				
				
				if(clientCode.equalsIgnoreCase("320.001"))
				{
					String strIssue = "Issued Subject to Nashik Jurisdiction";
					String strAddr = "Mumbai Agra Road,Nashik-422009.Ph.+91253-2325000 E-mail:suryanasik@gmail.com";
					
					reportParams.put("pstrIssue", strIssue);
					reportParams.put("pstrAddr", strAddr);
				}
				
				
				// get bill details
				String sqlBillDtl="";
				if(!(billNames.length()>0))
				{
					sqlBillDtl = " SELECT DATE(b.dteDocDate),b.strDocNo,"
							+ " IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),b.dblDebitAmt,"
							+ " b.dblCreditAmt,"
							+ " b.dblBalanceAmt ,ifnull(a.strReservationNo,'') ,b.strPerticulars,c.strRoomDesc,d.intNoOfFolios  "
							+ " FROM tblbillhd a "
							+ " INNER JOIN tblbilldtl b "
							+ " ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo,tblroom c ,tblcheckindtl d "
							+ " WHERE a.strBillNo='"+billNo+"' "
							+ " and b.strRevenueCode=c.strRoomCode and a.strCheckInNo=d.strCheckInNo "
							+ " and d.strRoomNo=b.strRevenueCode  "
							+ " UNION"
							+ " SELECT DATE(b.dteDocDate),b.strDocNo, "
							+ " IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),"
							+ " b.dblDebitAmt, b.dblCreditAmt, b.dblBalanceAmt, IFNULL(a.strReservationNo,''),b.strPerticulars,'',''"
							+ " FROM tblbillhd a"
							+ " INNER JOIN tblbilldtl b ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo"
							+ " WHERE a.strBillNo='"+billNo+"'   AND b.strPerticulars!='Room Tariff'";
				}
				else
				{
					sqlBillDtl = " SELECT DATE(b.dteDocDate),b.strDocNo,"
							+ " IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),b.dblDebitAmt,b.dblCreditAmt,"
							+ " b.dblBalanceAmt ,ifnull(a.strReservationNo,'') ,b.strPerticulars ,c.strRoomDesc,d.intNoOfFolios FROM tblbillhd a INNER JOIN tblbilldtl b "
							+ " ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo AND b.strPerticulars IN("+billNames.substring(0, billNames.length()-1)+") "
							+ " ,tblroom c,tblcheckindtl d "
							+ " WHERE a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'"
							+ " and b.strRevenueCode=c.strRoomCode and a.strCheckInNo=d.strCheckInNo "
							+ " and d.strRoomNo=b.strRevenueCode  "
							+ " UNION"
							+ " SELECT DATE(b.dteDocDate),b.strDocNo, "
							+ " IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),"
							+ " b.dblDebitAmt, b.dblCreditAmt, b.dblBalanceAmt, IFNULL(a.strReservationNo,''),b.strPerticulars,'',''"
							+ " FROM tblbillhd a"
							+ " INNER JOIN tblbilldtl b ON a.strFolioNo=b.strFolioNo AND a.strBillNo=b.strBillNo"
							+ " WHERE a.strBillNo='"+billNo+"'   AND b.strPerticulars!='Room Tariff'";
				}
				
				// + " and DATE(b.dteDocDate) BETWEEN '" + fromDate + "' AND '"
				// + toDate + "' ";
				List billDtlList = objFolioService.funGetParametersList(sqlBillDtl);
			    String strReservationNo = "";
				for (int i = 0; i < billDtlList.size(); i++) {
					Object[] folioArr = (Object[]) billDtlList.get(i);

					String docDate = folioArr[0].toString();
					if (folioArr[1] == null) {
						continue;
					} 
					else 
					{
						dblTotalRoomTarrif=dblTotalRoomTarrif+Double.parseDouble(folioArr[3].toString());
						clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();
						String docNo = folioArr[1].toString();
						String particulars = folioArr[2].toString();
						strReservationNo = folioArr[6].toString();
						double debitAmount = Double.parseDouble(folioArr[3].toString());
						BigDecimal taxAmt=new BigDecimal(0);;
						if(clientCode.equalsIgnoreCase("383.001"))
						{
							String sqltaxes="SELECT SUM(b.dblTaxAmt) FROM tblbilldtl a, tblbilltaxdtl b "
                                    + " WHERE a.strDocNo=b.strDocNo AND a.strBillNo='"+billNo+"' "
                                    + " AND a.strClientCode='"+clientCode+"'  AND date(a.dteDocDate)='"+docDate+"' AND  a.strPerticulars='Room Tariff' "
                                    + " and a.strDocNo='"+docNo+"' ";
					         List billtaxAmt = objFolioService.funGetParametersList(sqltaxes);
					         if(billtaxAmt.size()>0 && billtaxAmt !=null)
					         {
					        	 taxAmt= (BigDecimal) billtaxAmt.get(0);
					        	 if(particulars.equalsIgnoreCase("Room Tariff"))
									{
						        		 if(taxAmt != null)
						        		 {
										  debitAmount=debitAmount-taxAmt.doubleValue();
						        		 }
									}
					         }
					         
					         
						}
														
						if(particulars.equalsIgnoreCase("Room Tariff"))
						{
							count++;
						}
						
						
						double creditAmount = Double.parseDouble(folioArr[4].toString());
						balance = balance + debitAmount - creditAmount;

						// String debitAmount = folioArr[3].toString();
						// String creditAmount = folioArr[4].toString();
						// String balance = folioArr[5].toString();

						billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
						billPrintingBean.setStrDocNo(docNo);
						if(folioArr[7].toString().equalsIgnoreCase("Folio Discount"))
						{
							double dblDiscPer = ((creditAmount*count)/dblTotalRoomTarrif)*100;
							particulars =folioArr[8].toString()+" - "+ particulars+" "+dblDiscPer+" %";
							billPrintingBean.setStrPerticulars(particulars );
						}
						
						else
						{
							billPrintingBean.setStrPerticulars(folioArr[8].toString()+" - "+particulars);
						}
						billPrintingBean.setDblDebitAmt(debitAmount);
						billPrintingBean.setDblCreditAmt(creditAmount*count);
						billPrintingBean.setDblBalanceAmt(balance);
						billPrintingBean.setStrPaxNo(folioArr[9].toString());
						double hmroomTariff = debitAmount; 
						
						if(strSelectBill.contains("Room Tariff"))
						{
							if(hmroomTariff>0.0)
							{
								reportParams.put("isRoomTariff", true);
							}
							else
							{
								reportParams.put("pHmRoomTariff", 0.0);
							}
						}
						else
						{
							reportParams.put("isRoomTariff", false);
						}
						
						dataList.add(billPrintingBean);
						
						if(hmParticulars.containsKey(particulars))
						{
							clsBillPrintingBean bean=hmParticulars.get(particulars);
							hmParticulars.put(particulars, bean);
						}
						else
						{
							hmParticulars.put(particulars,billPrintingBean);
						}
						
						String sqlSettlementPayment = "select a.strReceiptNo from tblreceipthd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
						List listSettlementTaxDtl = objWebPMSUtility.funExecuteQuery(sqlSettlementPayment, "sql");
						if(listSettlementTaxDtl !=null && listSettlementTaxDtl.size()<2)
						{
						if(listSettlementTaxDtl !=null && listSettlementTaxDtl.size()>0)
						{
							String strReceiptNo = listSettlementTaxDtl.get(0).toString();
							String sqlPaymentTax = "select c.strSettlementCode from tblreceiptdtl a,tblreceipthd b ,tblsettlementmaster c "
									+ "where a.strReceiptNo=b.strReceiptNo and a.strSettlementCode=c.strSettlementCode and a.strReceiptNo='"+strReceiptNo+"'";
							
							List listSettlementDescDtl = objWebPMSUtility.funExecuteQuery(sqlPaymentTax, "sql");
							if(listSettlementDescDtl!=null && listSettlementDescDtl.size()>0)
							{
								String strSettlementCode = listSettlementDescDtl.get(0).toString();								
								String sqlTaxesAppliedOnBill = "select a.strTaxCode,a.dblTaxAmt from tblbilltaxdtl a where a.strBillNo ='"+billNo+"' and a.strClientCode='"+clientCode+"' "
										+ "group by a.strTaxCode;";								
								List listTaxesAppliedOnBill = objWebPMSUtility.funExecuteQuery(sqlTaxesAppliedOnBill, "sql");
								if(listTaxesAppliedOnBill!=null && listTaxesAppliedOnBill.size()>0)
								{
									for( int b=0;b<listTaxesAppliedOnBill.size();b++)
									{
										Object[] obj = (Object[]) listTaxesAppliedOnBill.get(b);
										String strTaxOfBill = obj[0].toString();
										double dblTaxAmt = Double.parseDouble(obj[1].toString());
										String sqlApplicable = "select a.strApplicable from tblsettlementtax a where a.strSettlementCode='"+strSettlementCode+"' and a.strTaxCode='"+strTaxOfBill+"'";
										List listApplicable = objWebPMSUtility.funExecuteQuery(sqlApplicable, "sql");
										if(listApplicable!=null && listApplicable.size()>0)
										{
											if(listApplicable.get(0).toString().equalsIgnoreCase("N"))
											{
												funDeleteTaxesAndUpdateBillHd(strTaxOfBill,clientCode,billNo,dblTaxAmt);
											}																						
										}
									}
								}
								
								else
								{
									/*sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0,0 "
											+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
											+ " AND a.strBillNo='"
											+ billNo
											+ "' and a.strDocNo='" + docNo + "' ";*/
									
									sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt"
											+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
											+ " AND a.strBillNo='"
											+ billNo
											+ "' and a.strDocNo='" + docNo + "' ";
									// + " and DATE(a.dteDocDate) BETWEEN '" + fromDate +
									// "' AND '" + toDate + "' ";
									List listBillTaxDtl = objWebPMSUtility.funExecuteQuery(
											sqlBillDtl, "sql");
									for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
										Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
										billPrintingBean = new clsBillPrintingBean();
										billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (arrObjBillTaxDtl[0].toString())));
										if(folioArr[7].toString().contains("POS"))
										{
										}	
										else
										{
										billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
										billPrintingBean.setStrPerticulars(folioArr[8].toString()+" - "+arrObjBillTaxDtl[2].toString());
										double debitAmt = Double.parseDouble(arrObjBillTaxDtl[3].toString());
										double creditAmt = Double.parseDouble(arrObjBillTaxDtl[4].toString());
										
										balance = balance + debitAmt - creditAmt;

										billPrintingBean.setDblDebitAmt(debitAmt);
										billPrintingBean.setDblCreditAmt(creditAmt);
										billPrintingBean.setDblBalanceAmt(balance);
										dataList.add(billPrintingBean);
										if(hmTax.containsKey(arrObjBillTaxDtl[2].toString())){
											clsBillPrintingBean bean1= new clsBillPrintingBean();
											bean1 =billPrintingBean;
											clsBillPrintingBean bean=hmTax.get(arrObjBillTaxDtl[2].toString());
											bean1.setDblBalanceAmt(balance);
											/*bean1.setDblBalanceAmt(bean.getDblBalanceAmt()+balance);*/
											hmTax.put(arrObjBillTaxDtl[2].toString(), bean1);
										}else{
											hmTax.put(arrObjBillTaxDtl[2].toString(), billPrintingBean);	
										}
										
										}
									}
								}
							}
						}

						}
						sqlBillDtl = "SELECT date(a.dteDocDate),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0 "
								+ " FROM tblbilldtl a, tblbilltaxdtl b where a.strDocNo=b.strDocNo "
								+ " AND a.strBillNo='"
								+ billNo
								+ "' and a.strDocNo='" + docNo + "' AND a.strClientCode='"+clientCode+"'";
						// + " and DATE(a.dteDocDate) BETWEEN '" + fromDate +
						// "' AND '" + toDate + "' ";
						List listBillTaxDtl = objBaseService.funGetListForWebPMS(new StringBuilder(sqlBillDtl), "sql");
						
							for (int cnt = 0; cnt < listBillTaxDtl.size(); cnt++) {
								Object[] arrObjBillTaxDtl = (Object[]) listBillTaxDtl.get(cnt);
								billPrintingBean = new clsBillPrintingBean();
								billPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (arrObjBillTaxDtl[0].toString())));
								if(folioArr[7].toString().contains("POS"))
								{
								}	
								else
								{
								billPrintingBean.setStrDocNo(arrObjBillTaxDtl[1].toString());
								billPrintingBean.setStrPerticulars(folioArr[8].toString()+" - "+arrObjBillTaxDtl[2].toString());
								double debitAmt = Double.parseDouble(arrObjBillTaxDtl[3].toString());
								double creditAmt = Double.parseDouble(arrObjBillTaxDtl[4].toString());
								
								balance = balance + debitAmt - creditAmt;

								billPrintingBean.setDblDebitAmt(debitAmt);
								billPrintingBean.setDblCreditAmt(creditAmt);
								billPrintingBean.setDblBalanceAmt(balance);
								dataList.add(billPrintingBean);
 								if(hmTax.containsKey(arrObjBillTaxDtl[2].toString())){
									clsBillPrintingBean bean1= new clsBillPrintingBean();
									bean1 =billPrintingBean;
									clsBillPrintingBean bean=hmTax.get(arrObjBillTaxDtl[2].toString());
									bean1.setDblBalanceAmt(balance);
									/*bean1.setDblBalanceAmt(bean.getDblBalanceAmt()+balance);*/
									hmTax.put(arrObjBillTaxDtl[2].toString(), bean1);
								}else{
									hmTax.put(arrObjBillTaxDtl[2].toString(), billPrintingBean);	
								}
								
								}
							}
					
					
						
						String sqlCheckOutDate = "SELECT Date(a.dteBillDate) as Date "
								+ "FROM tblbillhd a WHERE a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
						List listCheckOutDate = objWebPMSUtility.funExecuteQuery(
								sqlCheckOutDate, "sql");
						
						String strChkOutDate = listCheckOutDate.get(0).toString();
						reportParams.put("pDepartureDate",objGlobal.funGetDate("dd-MM-yyyy", strChkOutDate));

					}
				}

				flgBillRecord = true;
			}

			if (flgBillRecord) 
			{
				
				List paymentDtlList=new ArrayList<>();
				String sqlPaymentDtl="";
				// get payment details
                String settlementType="";
                int cnt=0;
				if(strSelectBill.contains("Room Tariff") ||  strSelectBill.length()==0 || strSelectBill.contains("POS"))
				{
					 sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,IF(c.strAgainst='Bill',e.strSettlementDesc,CONCAT('ADVANCE ',e.strSettlementDesc)),'0.00' as debitAmt "
							+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
							+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode AND c.strFolioNo='"+folio+"' and d.strClientCode='"+clientCode+"'";
	
					 paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
					 
					 for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} 
						else 
						{
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance = balance + debitAmount - creditAmount;
							// String debitAmount = paymentArr[3].toString();
							// String creditAmount = paymentArr[4].toString();
							// String balance = paymentArr[5].toString();
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
							settlementType=particulars;
							dataList.add(folioPrintingBean);
							cnt++;
						}
					}
					if(cnt>0)
					{
						settlementType="MultiSettle";
					}
					if (!(paymentDtlList.size() > 0)) {
						sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
								+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
								+ " FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
								+ " where c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
								+ " and c.strRegistrationNo='"
								+ registrationNo
								+ "' and c.strAgainst='Check-In' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";
	
						List checkInReceiptDtl = objFolioService
								.funGetParametersList(sqlPaymentDtl);
						for (int i = 0; i < checkInReceiptDtl.size(); i++) {
							Object[] paymentArr = (Object[]) checkInReceiptDtl.get(i);
	
							String docDate = paymentArr[0].toString();
							if (paymentArr[1] == null) {
								continue;
							} else {
								clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
								String docNo = paymentArr[1].toString();
								String particulars = paymentArr[2].toString();
	
								double debitAmount = Double.parseDouble(paymentArr[3].toString());
								double creditAmount = Double.parseDouble(paymentArr[4].toString());
								balance = balance + debitAmount - creditAmount;
	
								// String debitAmount = paymentArr[3].toString();
								// String creditAmount = paymentArr[4].toString();
								// String balance = paymentArr[5].toString();
	
								folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
								folioPrintingBean.setStrDocNo(docNo);
								folioPrintingBean.setStrPerticulars(particulars);
								folioPrintingBean.setDblDebitAmt(debitAmount);
								folioPrintingBean.setDblCreditAmt(creditAmount);
								folioPrintingBean.setDblBalanceAmt(balance);
	
								dataList.add(folioPrintingBean);
							}
						}
	
					}
				}
				reportParams.put("pSettlementType",settlementType);
				
				String sqlReservationAdvPayment = "select a.strReservationNo from tblbillhd a where a.strBillNo='"+billNo+"' AND a.strClientCode='"+clientCode+"'";
				List listResAdvpayment = objGlobalFunctionsService.funGetDataList(sqlReservationAdvPayment, "sql");
				String strResNo = listResAdvpayment.get(0).toString();
				String sqlResPayment = "";
				if(strResNo.length()>0)
				{
					sqlResPayment="SELECT DATE(c.dteReceiptDate),c.strReceiptNo, CONCAT('ADVANCE ',e.strSettlementDesc),'0.00' AS debitAmt, "
							+ "d.dblSettlementAmt AS creditAmt,'0.00' AS balance "
							+ "FROM tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
							+ "WHERE c.strReceiptNo=d.strReceiptNo AND d.strSettlementCode=e.strSettlementCode "
							+ "AND c.strReservationNo='"+strResNo+"' AND d.strClientCode='"+clientCode+"' AND c.strReservationNo='"+strResNo+"' and c.strAgainst='Reservation' ";
					
					paymentDtlList = objGlobalFunctionsService.funGetDataList(sqlResPayment, "sql");
					 for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);
	
						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} 
						else 
						{
							clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance = balance + debitAmount - creditAmount;
							// String debitAmount = paymentArr[3].toString();
							// String creditAmount = paymentArr[4].toString();
							// String balance = paymentArr[5].toString();
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
	
							dataList.add(folioPrintingBean);
						}
					}
				}
				
				

				/*
				 * String sqlPaymentDtl =
				 * "SELECT date(b.dteDocDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt"
				 * + " ,d.dblSettlementAmt as creditAmt,'0.00' as balance " +
				 * " FROM tblbillhd a " +
				 * "LEFT OUTER JOIN tblbilldtl b ON a.strFolioNo=b.strFolioNo "
				 * +
				 * " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo and a.strReservationNo=c.strReservationNo "
				 * +
				 * " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo "
				 * +
				 * " left outer join tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode "
				 * + " WHERE a.strBillNo='" + billNo + "' "; //+
				 * " and DATE(b.dteDocDate) BETWEEN '" + fromDate + "' AND '" +
				 * toDate + "'"
				 */

				/*sqlPaymentDtl = "SELECT date(c.dteReceiptDate),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt "
						+ " ,d.dblSettlementAmt as creditAmt,'0.00' as balance "
						+ " FROM tblbillhd a,tblreceipthd c, tblreceiptdtl d, tblsettlementmaster e "
						+ " where a.strBillNo=c.strBillNo and c.strReceiptNo=d.strReceiptNo and d.strSettlementCode=e.strSettlementCode "
						+ " and a.strBillNo='"
						+ billNo
						+ "' and c.strAgainst='Bill' ";

				List billReceitDtl = objFolioService
						.funGetParametersList(sqlPaymentDtl);
				for (int i = 0; i < billReceitDtl.size(); i++) {
					Object[] paymentArr = (Object[]) billReceitDtl.get(i);

					String docDate = paymentArr[0].toString();
					if (paymentArr[1] == null) {
						continue;
					} else {
						clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
						String docNo = paymentArr[1].toString();
						String particulars = paymentArr[2].toString();

						double debitAmount = Double.parseDouble(paymentArr[3]
								.toString());
						double creditAmount = Double.parseDouble(paymentArr[4]
								.toString());
						balance = balance + debitAmount - creditAmount;

						// String debitAmount = paymentArr[3].toString();
						// String creditAmount = paymentArr[4].toString();
						// String balance = paymentArr[5].toString();

						folioPrintingBean.setDteDocDate(objGlobal.funGetDate(
								"dd-MM-yyyy", (docDate)));
						folioPrintingBean.setStrDocNo(docNo);
						folioPrintingBean.setStrPerticulars(particulars);
						folioPrintingBean.setDblDebitAmt(debitAmount);
						folioPrintingBean.setDblCreditAmt(creditAmount);
						folioPrintingBean.setDblBalanceAmt(balance);

						dataList.add(folioPrintingBean);
					}
				}
*/
				String sqlDisc = " select date(a.dteBillDate),'','Discount','0.00',a.dblDiscAmt from  tblbilldiscount a "
						+ " WHERE a.strBillNo='"
						+ billNo
						+ "' and strClientCode='" + clientCode + "' ";

				List billDiscList = objBaseService.funGetListForWebPMS(new StringBuilder(sqlDisc), "sql");
				for (int i = 0; i < billDiscList.size(); i++) {
					Object[] billDicArr = (Object[]) billDiscList.get(i);

					clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
					String docDate = billDicArr[0].toString();
					String docNo = billDicArr[1].toString();
					String particulars = billDicArr[2].toString();

					double debitAmount = Double.parseDouble(billDicArr[3].toString());
					double creditAmount = Double.parseDouble(billDicArr[4].toString());
					balance = balance + debitAmount - creditAmount;

					// String debitAmount = billDicArr[3].toString();
					// String creditAmount = billDicArr[4].toString();
					// String balance = billDicArr[5].toString();

					folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
					folioPrintingBean.setStrDocNo(docNo);
					folioPrintingBean.setStrPerticulars(particulars);
					folioPrintingBean.setDblDebitAmt(debitAmount);
					folioPrintingBean.setDblCreditAmt(creditAmount);
					folioPrintingBean.setDblBalanceAmt(balance);

					dataList.add(folioPrintingBean);
				}
				
				
				String walkIn = "";
				if(strSelectBill.contains("Room Tariff") ||  strSelectBill.length()==0 || strSelectBill.contains("POS"))
				{
					String sqlWalkInNo = "select a.strWalkInNo from tblcheckinhd a where a.strCheckInNo='"+checkInNo+"' AND a.strClientCode='"+clientCode+"'";
					List listWalkIn = objFolioService.funGetParametersList(sqlWalkInNo);
					for(int i = 0;i<listWalkIn.size();i++)
					{
						walkIn = listWalkIn.get(i).toString();
					}
					String walkInDiscount = "SELECT DATE(a.dtDate),'',CONCAT('Discount ',a.dblDiscount,'%' ),a.dblRoomRate,"
							+ "a.dblDiscount,'0.00' FROM tblwalkinroomratedtl a "
							+ "WHERE a.strWalkinNo='"+walkIn+"' AND a.strClientCode='"+clientCode+"' group by a.dblDiscount";
					List walkInBillDiscList = objFolioService.funGetParametersList(walkInDiscount);
					for (int i = 0; i < walkInBillDiscList.size(); i++) {
						Object[] billWalkDicArr = (Object[]) walkInBillDiscList.get(i);
	
						clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
						String docDate = billWalkDicArr[0].toString();
						String docNo = billWalkDicArr[1].toString();
						String particulars = billWalkDicArr[2].toString();
						double debitAmount = Double.parseDouble(billWalkDicArr[3].toString());
						double creditAmount = Double.parseDouble(billWalkDicArr[4].toString());
						if(creditAmount==0)
						{
						}
						else
						{
							/*balance  = balance +  - (creditAmount/100)*debitAmount;*/
							creditAmount = debitAmount*creditAmount/100;
							if(count>0)
							{
								creditAmount = creditAmount*count;
							}
							balance = balance - creditAmount;
							// String debitAmount = billDicArr[3].toString();
							// String creditAmount = billDicArr[4].toString();
							// String balance = billDicArr[5].toString();
		
							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-MM-yyyy", (docDate)));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(0.0);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);
								
							dataList.add(folioPrintingBean);
						}
					}
				}
				
			
				String sqlRefund="select DATE_FORMAT(a.dteReceiptDate,'%d-%m-%Y'),a.strReceiptNo,a.dblReceiptAmt from tblreceipthd a where a.strType='Refund Amt' and a.strBillNo='"+billNo+"'";
				List guestlist =  objGlobalFunctionsService.funGetListModuleWise(sqlRefund, "sql");;
				for (int i = 0; i < guestlist.size(); i++) {
					Object[]  arrRefund = (Object[]) guestlist.get(i);
					balance = balance + Double.parseDouble(arrRefund[2].toString());
					clsBillPrintingBean folioPrintingBean = new clsBillPrintingBean();
					folioPrintingBean.setDteDocDate(arrRefund[0].toString());
					folioPrintingBean.setStrDocNo(arrRefund[1].toString());
					folioPrintingBean.setStrPerticulars("Refund Amount");
					folioPrintingBean.setDblDebitAmt(Double.parseDouble(arrRefund[2].toString()));
					folioPrintingBean.setDblCreditAmt(0.00);
					folioPrintingBean.setDblBalanceAmt(balance);
							
					dataList.add(folioPrintingBean);
					
				}
				
				

			}
			List<clsBillPrintingBean> listtax=new ArrayList<>();
			if(hmTax.size()>0){
				for(Map.Entry<String, clsBillPrintingBean> entry:hmTax.entrySet()){
					listtax.add(entry.getValue());
				}
			}
			
			String sqlCheckSupportVoucher="SELECT a.strPerticulars FROM tblbilldtl a,tblbillhd b WHERE b.strBillNo=a.strBillNo "
					+ " AND a.strBillNo ='"+billNo+"' AND a.strPerticulars!='Room Tariff' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
			List list = objFolioService.funGetParametersList(sqlCheckSupportVoucher);
			if(list.size()>0)
			{
				pSupportVoucher="Yes";
				/*pSupportVoucherTextFielf = "Supporting Voucher";*/
			}
			else
			{
				pSupportVoucher="";
				/*pSupportVoucherTextFielf = "";*/
			}
			
			pRoomTariff = funGetRoomTariffData(billNo,folio,registrationNo,clientCode,checkInNo);
			
			String sql="select c.strSettlementDesc from tblreceipthd a,tblreceiptdtl b,tblsettlementmaster c  "
						+" where a.strReceiptNo=b.strReceiptNo AND b.strSettlementCode=c.strSettlementCode  "
						+"  and a.strBillNo='"+billNo+"' ";
			
			List settlist =  objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			
			if(settlist!=null && settlist.size()>0)
			{
				reportParams.put("pSettlementType",settlist.get(0).toString());
			}
			
			
			
			reportParams.put("listtax", listtax);
			reportParams.put("pSupportVoucher", pSupportVoucher);
			reportParams.put("pSupportVoucherTextFielf", pSupportVoucherTextFielf);
			reportParams.put("pHmRoomTariff", pRoomTariff);
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
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}

