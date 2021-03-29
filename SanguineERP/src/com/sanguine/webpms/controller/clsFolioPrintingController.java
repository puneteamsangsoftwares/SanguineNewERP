package com.sanguine.webpms.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
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
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JRDesignQuery;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.Connection;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsFolioPrintingBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.service.clsFolioService;

@Controller
public class clsFolioPrintingController {
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

	// Open Folio Printing
	@RequestMapping(value = "/frmFolioPrinting", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmFolioPrinting_1", "command", new clsFolioPrintingBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmFolioPrinting", "command", new clsFolioPrintingBean());
		} else {
			return null;
		}
	}

	// Save folio posting
	@RequestMapping(value = "/rptFolioPrinting", method = RequestMethod.GET)
	public void funGenerateFolioPrintingReport(@RequestParam("folioNo") String folioNo, HttpServletRequest req, HttpServletResponse resp) {
		try {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String companyName = req.getSession().getAttribute("companyName").toString();
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptFolioPrinting.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
			String imagePath1 = servletContext.getRealPath("/resources/images/company_Logo1.png");
			
			double balance=0;
			List<clsFolioPrintingBean> dataList = new ArrayList<clsFolioPrintingBean>();
			@SuppressWarnings("rawtypes")
			HashMap reportParams = new HashMap();

			String sqlParametersFromFolio = "SELECT a.strFolioNo,e.strRoomDesc,a.strRegistrationNo,a.strReservationNo " + " ,date(b.dteArrivalDate),b.tmeArrivalTime ,ifnull(date(b.dteDepartureDate),'NA'),ifnull(b.tmeDepartureTime,'NA')" + " ,d.strGuestPrefix,d.strFirstName,d.strMiddleName,d.strLastName ,b.intNoOfAdults,b.intNoOfChild,'NA',d.strGuestCode,d.dblClosingBalance "
					+ " FROM tblfoliohd a LEFT OUTER JOIN tblreservationhd b ON a.strReservationNo=b.strReservationNo AND b.strClientCode='"+clientCode+"'" + " LEFT OUTER JOIN tblguestmaster d ON a.strGuestCode=d.strGuestCode AND d.strClientCode='"+clientCode+"'" + " LEFT OUTER JOIN tblroom e ON a.strRoomNo=e.strRoomCode AND e.strClientCode='"+clientCode+"'" + " where a.strFolioNo='" + folioNo + "' and a.strClientCode='" + clientCode + "'";

			String sqlFolio = "select strReservationNo,strWalkInNo,strCheckInNo from tblfoliohd where strFolioNo='" + folioNo + "' and strClientCode='" + clientCode + "' ";
			List folioDtl = objFolioService.funGetParametersList(sqlFolio);
			String CheckInNo="";
			if (folioDtl.size() > 0) {
				Object[] arrFolioDtl = (Object[]) folioDtl.get(0);
				CheckInNo=arrFolioDtl[2].toString();
				if (!arrFolioDtl[1].toString().isEmpty()) {
					sqlParametersFromFolio = "SELECT a.strFolioNo,e.strRoomDesc,a.strRegistrationNo,a.strReservationNo " + " ,date(b.dteWalkinDate),b.tmeWalkinTime ,ifnull(date(b.dteCheckOutDate),'NA'),ifnull(b.tmeCheckOutTime,'NA')" + " ,d.strGuestPrefix,d.strFirstName,d.strMiddleName,d.strLastName ,b.intNoOfAdults,b.intNoOfChild,'NA',d.strGuestCode,d.dblClosingBalance  "
							+ " FROM tblfoliohd a LEFT OUTER JOIN tblwalkinhd b ON a.strWalkinNo=b.strWalkinNo  AND b.strClientCode='"+clientCode+"'" + " LEFT OUTER JOIN tblguestmaster d ON a.strGuestCode=d.strGuestCode AND d.strClientCode='"+clientCode+"'" + " LEFT OUTER JOIN tblroom e ON a.strRoomNo=e.strRoomCode  AND e.strClientCode='"+clientCode+"'" + " where a.strFolioNo='" + folioNo + "' and a.strClientCode='" + clientCode + "'";
				}
			}

			
			
			
			// get all parameters

			List listOfParametersFromFolio = objFolioService.funGetParametersList(sqlParametersFromFolio);
			if (listOfParametersFromFolio.size() > 0) {
				Object[] arr = (Object[]) listOfParametersFromFolio.get(0);

				String folio = arr[0].toString();
				String roomNo = arr[1].toString();
				String registrationNo = arr[2].toString();
				String reservationNo = arr[3].toString();
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
				String billNo = arr[14].toString();
				String guestCode = arr[15].toString();
				String guestAddr = "";
				String sqlAddr	="SELECT IFNULL(d.strDefaultAddr,''), IFNULL(d.strAddressLocal,''), "
						+ "IFNULL(d.strCityLocal,''), IFNULL(d.strStateLocal,''), "
						+ "IFNULL(d.strCountryLocal,''), IFNULL(d.intPinCodeLocal,''), "
						+ "IFNULL(d.strAddrPermanent,''), IFNULL(d.strCityPermanent,''), "
						+ "IFNULL(d.strStatePermanent,''), IFNULL(d.strCountryPermanent,''), "
						+ "IFNULL(d.intPinCodePermanent,''), IFNULL(d.strAddressOfc,''), "
						+ "IFNULL(d.strCityOfc,''), IFNULL(d.strStateOfc,''), "
						+ "IFNULL(d.strCountryOfc,''), IFNULL(d.intPinCodeOfc,''), "
						+ "IFNULL(d.strGSTNo,'') FROM tblguestmaster d "
						+ "WHERE d.strGuestCode= '"+guestCode+"' AND d.strClientCode='"+clientCode+"'";
				
				List listguest = objFolioService.funGetParametersList(sqlAddr);
				
				if (listguest.size() > 0) {
					Object[] arrGuest = (Object[]) listguest.get(0);
					if (arrGuest[0].toString().equalsIgnoreCase("Permanent")) { // check
																				// default
																				// addr
						/*guestAddr = arrGuest[6].toString() + ","
								+ arrGuest[7].toString() + ","
								+ arrGuest[8].toString() + ","
								+ arrGuest[9].toString() + ","
								+ arrGuest[10].toString();*/
						guestAddr= arrGuest[6].toString() ;
						if(!arrGuest[6].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[6].toString();
						}
						else if(!arrGuest[7].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[7].toString();
						}
						else if(!arrGuest[8].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[8].toString();
						}
						else if(!arrGuest[9].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[9].toString();
						}
						else if(!arrGuest[10].toString().equalsIgnoreCase("0"))
						{
							guestAddr="," + arrGuest[10].toString();
						}
						else
						{
							guestAddr=guestAddr;
						}
					} else if (arrGuest[0].toString()
							.equalsIgnoreCase("Office")) {
						/*guestAddr = arrGuest[11].toString() + ","
								+ arrGuest[12].toString() + ","
								+ arrGuest[13].toString() + ","
								+ arrGuest[14].toString() + ","
								+ arrGuest[15].toString();*/
						guestAddr= arrGuest[11].toString() ;
						if(!arrGuest[12].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[12].toString();
						}
						else if(!arrGuest[13].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[13].toString();
						}
						else if(!arrGuest[14].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[14].toString();
						}
						else if(!arrGuest[15].toString().equalsIgnoreCase("0"))
						{
							guestAddr="," + arrGuest[15].toString();
						}
						else
						{
							guestAddr=guestAddr;
						}
					} else { // Local
						/*guestAddr = arrGuest[1].toString() + ","
								+ arrGuest[2].toString() + ","
								+ arrGuest[3].toString() + ","
								+ arrGuest[4].toString() + ","
								+ arrGuest[5].toString();*/
						guestAddr= arrGuest[1].toString() ;
						if(!arrGuest[2].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[2].toString();
						}
						else if(!arrGuest[3].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[3].toString();
						}
						else if(!arrGuest[4].toString().equalsIgnoreCase(""))
						{
							guestAddr="," + arrGuest[4].toString();
						}
						else if(!arrGuest[5].toString().equalsIgnoreCase("0"))
						{
							guestAddr="," + arrGuest[5].toString();
						}
						else
						{
							guestAddr=guestAddr;
						}
					}
				}
				
				//Printing Balance
				if(clientCode.equalsIgnoreCase("378.001"))
				{
				
					clsFolioPrintingBean folioBean = new clsFolioPrintingBean();
					double debitAmt = Double.parseDouble(arr[16].toString());
					double creditAmt = 0.00;
					double bal = debitAmt - creditAmt;
					
	                
					folioBean.setDteDocDate(" ");
					folioBean.setStrDocNo(" ");
					folioBean.setStrPerticulars("Opening Balance");
					String sql="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+guestCode+"'";
					List guestlist = objFolioService.funGetParametersList(sql);
					double closingBal=0.00;
					for(int j=0;j<guestlist.size();j++)
					{
						closingBal=Double.parseDouble(guestlist.get(0).toString());
						if(closingBal>0)
						{
							folioBean.setDblDebitAmt(closingBal);
							folioBean.setDblCreditAmt(0.00);
						}
						else
						{
							folioBean.setDblCreditAmt(closingBal);
							folioBean.setDblDebitAmt(0.00);
						}
					}
					folioBean.setDblBalanceAmt(bal);
					folioBean.setDblQuantity(0.00);
					dataList.add(folioBean);
				}
				

				reportParams.put("pCompanyName", companyName);
				reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
				reportParams.put("pContactDetails", "");
				reportParams.put("strImagePath", imagePath);
				reportParams.put("pGuestName", gPrefix + " " + gFirstName + " " + gMiddleName + " " + gLastName);
				reportParams.put("pFolioNo", folio);
				reportParams.put("pRoomNo", roomNo);
				reportParams.put("pRegistrationNo", registrationNo);
				reportParams.put("pReservationNo", reservationNo);
				reportParams.put("pArrivalDate", objGlobal.funGetDate("dd-MM-yyyy", arrivalDate));
				reportParams.put("pArrivalTime", arrivalTime);
				reportParams.put("pDepartureDate", objGlobal.funGetDate("dd-MM-yyyy", departureDate));
				reportParams.put("pDepartureTime", departureTime);
				//reportParams.put("pAdult", adults);
				//reportParams.put("pChild", childs);
				
				if(clientCode.equalsIgnoreCase("383.001"))
				{
					reportParams.put("strImagePath1", imagePath1);	
				}
				else
				{
					reportParams.put("strImagePath1", null);
				}
				
				
				reportParams.put("pGuestAddress", guestAddr);
				reportParams.put("pRemarks", "");
				reportParams.put("strUserCode", userCode);
				reportParams.put("pBillNo", billNo);
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("lblAdult", "Departure Date     :");
					reportParams.put("pAdult", objGlobal.funGetDate("dd-MM-yyyy", departureDate));
					reportParams.put("lblChild", "Departure Time     :");
					reportParams.put("pChild", departureTime);
					reportParams.put("lblDepartureDate", null);
					reportParams.put("pDepartureDate", null);
					reportParams.put("lblDepartureTime", null);
					reportParams.put("pDepartureTime", null);
					
				}
				else
				{
					reportParams.put("lblAdult", "Adults :");
					reportParams.put("pAdult",adults );
					reportParams.put("lblChild", "Childs :");
					reportParams.put("pChild", childs);
					reportParams.put("lblDepartureDate", "Departure Date     :");
					reportParams.put("pDepartureDate", objGlobal.funGetDate("dd-MM-yyyy", departureDate));
					reportParams.put("lblDepartureTime","Departure Time     :");
					reportParams.put("pDepartureTime", departureTime);
					
				}
				
				// get folio details
				
				String sqlFolioDtl = "SELECT DATE_FORMAT(b.dteDocDate,'%d-%m-%Y'),b.strDocNo, CONCAT(IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),' ',b.strRemark),"
						+ " b.dblQuantity,b.dblDebitAmt,b.dblCreditAmt,b.dblBalanceAmt ,CONCAT(b.strPerticulars,' ',b.strRemark),d.strRoomDesc,b.strOldFolioNo  " + ""
						+ " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'" + ", tblroom d  "
						+ " WHERE b.strRevenueCode=d.strRoomCode AND a.strFolioNo='" + folioNo + "' and b.strRevenueType!='Discount'"
						+ " order by b.dteDocDate ASC";

				if(clientCode.equalsIgnoreCase("383.001"))
				{
					
					sqlFolioDtl = "SELECT DATE_FORMAT(b.dteDocDate,'%d-%m-%Y'),b.strDocNo,"
							+ " CONCAT(IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),' ',b.strRemark),"
							+ " b.dblQuantity,b.dblDebitAmt -ifnull(SUM(c.dblTaxAmt),0),b.dblCreditAmt,b.dblBalanceAmt,"
							+ " CONCAT(b.strPerticulars,' ',b.strRemark),d.strRoomDesc,b.strOldFolioNo"
							+ " FROM tblfoliohd a"
							+ " LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo"
							+ " LEFT OUTER JOIN tblfoliotaxdtl c ON b.strFolioNo=c.strFolioNo and b.strDocNo=c.strDocNo "
							+ " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' ,tblroom d "
							+ " WHERE b.strRevenueCode=d.strRoomCode AND  a.strFolioNo='" + folioNo + "' AND b.strRevenueType!='Discount' "
							+ " and b.strPerticulars='Room Tariff'"
							+ " group by b.dteDocDate,b.strDocNo " 
							+ " Union All"
							+ " SELECT DATE_FORMAT(b.dteDocDate,'%d-%m-%Y'),b.strDocNo, CONCAT(IFNULL(SUBSTRING_INDEX(SUBSTRING_INDEX(b.strPerticulars,'(', -1),')',1),''),' ',b.strRemark),b.dblQuantity,b.dblDebitAmt,b.dblCreditAmt,b.dblBalanceAmt ,CONCAT(b.strPerticulars,' ',b.strRemark),'',strOldFolioNo  " + " "
							+ " FROM tblfoliohd a "
							+ " LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo "
							+ " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'" + ""
							+ " WHERE a.strFolioNo='" + folioNo + "' and b.strRevenueType!='Discount' and  b.strPerticulars<>'Room Tariff' "   ;
				
				}
				 						
				List folioDtlList = objFolioService.funGetParametersList(sqlFolioDtl);
				for (int i = 0; i < folioDtlList.size(); i++) {
					Object[] folioArr = (Object[]) folioDtlList.get(i);
					String docDate = folioArr[0].toString();
					if (folioArr[1] == null) {
						continue;
					} else {
						clsFolioPrintingBean folioPrintingBean = new clsFolioPrintingBean();
						String docNo = folioArr[1].toString();
						String particulars ;
						if(folioArr[9].toString().equalsIgnoreCase(" "))
						{
							particulars = folioArr[8].toString()+"-"+folioArr[2].toString();
						}
						else
						{
							particulars = "Transfer "+folioArr[8].toString()+"-"+folioArr[2].toString();
						}
					 
						double debitAmount = Double.parseDouble(folioArr[4].toString());
						double creditAmount = Double.parseDouble(folioArr[5].toString());
						balance += debitAmount - creditAmount;
 						String strCompletePertName = folioArr[7].toString();

						folioPrintingBean.setDteDocDate(docDate);
						folioPrintingBean.setStrDocNo(docNo);
						folioPrintingBean.setStrPerticulars(particulars);
						folioPrintingBean.setDblDebitAmt(debitAmount);
						folioPrintingBean.setDblCreditAmt(creditAmount);
						folioPrintingBean.setDblBalanceAmt(balance);
						folioPrintingBean.setDblQuantity(Double.parseDouble(folioArr[3].toString()));
						dataList.add(folioPrintingBean);
						

						if(!strCompletePertName.contains("POS"))
						{
						
							sqlFolioDtl = "SELECT DATE_FORMAT(date(a.dteDocDate),'%d-%m-%Y'),a.strDocNo,b.strTaxDesc,b.dblTaxAmt,0 " + " "
									+ " FROM tblfoliodtl a,tblfoliotaxdtl b"
									+ " where a.strDocNo=b.strDocNo " + " and  a.strFolioNo='" + folioNo + "' "
									+ " and a.strDocNo='" + docNo + "' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'";
							List listFolioTaxDtl = objWebPMSUtility.funExecuteQuery(sqlFolioDtl, "sql");
							for (int cnt = 0; cnt < listFolioTaxDtl.size(); cnt++) {
								Object[] arrObjFolioTaxDtl = (Object[]) listFolioTaxDtl.get(cnt);

								folioPrintingBean = new clsFolioPrintingBean();
								folioPrintingBean.setDteDocDate(arrObjFolioTaxDtl[0].toString());
								folioPrintingBean.setStrDocNo(arrObjFolioTaxDtl[1].toString());
								folioPrintingBean.setStrPerticulars(arrObjFolioTaxDtl[2].toString());
								folioPrintingBean.setDblDebitAmt(Double.parseDouble(arrObjFolioTaxDtl[3].toString()));
								folioPrintingBean.setDblCreditAmt(Double.parseDouble(arrObjFolioTaxDtl[4].toString()));
								folioPrintingBean.setDblBalanceAmt(Double.parseDouble(arrObjFolioTaxDtl[3].toString()) - Double.parseDouble(arrObjFolioTaxDtl[4].toString()));
								if(clientCode.equalsIgnoreCase("383.001"))
								{
									balance += folioPrintingBean.getDblDebitAmt() - folioPrintingBean.getDblCreditAmt();
									folioPrintingBean.setDblBalanceAmt(balance);

								}
							
								folioPrintingBean.setTax(true);
								dataList.add(folioPrintingBean);					   
						}
						
						}
					}
				}
				
				sqlFolioDtl = "SELECT DATE_FORMAT(b.dteDocDate,'%d-%m-%Y'),b.strDocNo,b.strPerticulars,b.dblDebitAmt,b.dblCreditAmt,b.dblBalanceAmt,b.strRevenueType" 
						+ " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'" 
						+ " WHERE  a.strFolioNo='" + folioNo + "' and b.strRevenueType='Discount'";
				folioDtlList = objFolioService.funGetParametersList(sqlFolioDtl);
				if(folioDtlList.size()>0)
				{
				for (int j = 0; j < folioDtlList.size(); j++) {
					clsFolioPrintingBean folioPrintingBean = new clsFolioPrintingBean();
					Object[] obj = (Object[])folioDtlList.get(0);
					BigDecimal bgDebit = (BigDecimal)obj[3];
					BigDecimal bgCredit = (BigDecimal)obj[4];
					folioPrintingBean.setDblCreditAmt(bgDebit.doubleValue());
					balance  += bgDebit.doubleValue() - bgCredit.doubleValue();

					folioPrintingBean.setDteDocDate(obj[0].toString());
					folioPrintingBean.setStrDocNo(obj[1].toString());
					folioPrintingBean.setStrPerticulars("Discount");
					folioPrintingBean.setDblDebitAmt(0);
					folioPrintingBean.setDblCreditAmt(bgCredit.doubleValue());
					folioPrintingBean.setDblBalanceAmt(balance);

					dataList.add(folioPrintingBean);
				}
				}
				
				// get payment details
				/*String sqlPaymentDtl = "Select IFNULL(DATE(b.dteDocDate),''),ifnull(c.strReceiptNo,''),ifnull(e.strSettlementDesc,''),'0.00' AS debitAmt,ifnull(d.dblSettlementAmt,0.0) AS creditAmt,'0.00' AS balance" + " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo " + " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo and a.strReservationNo=c.strReservationNo "
						+ " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo " + " left outer join tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode " + " WHERE  a.strFolioNo='" + folioNo + "' " + " group by a.strFolioNo ";*/
				/*
				String sqlPaymentDtl = "SELECT DATE_FORMAT(date(b.dteDocDate),'%d-%m-%Y'),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt,d.dblSettlementAmt as creditAmt" + " ,'0.00' as "
						+ " balance " + " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo AND a.strClientCode='"+clientCode+"' "
						+ " AND b.strClientCode='"+clientCode+"'" + " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo OR a.strReservationNo=c.strReservationNo "
						+ " AND c.strClientCode='"+clientCode+"'"
						+ " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo AND d.strClientCode='"+clientCode+"'" + " left outer join"
						+ "  tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode AND e.strClientCode='"+clientCode+"'" + " "
						+ " WHERE a.strFolioNo='" + folioNo + "' " + ""
						+ " GROUP BY d.strReceiptNo,d.strSettlementCode ";*/
				
				balance=Math.round(balance); 
				String sqlPaymentDtl = "SELECT DATE_FORMAT(date(b.dteDocDate),'%d-%m-%Y'),c.strReceiptNo,e.strSettlementDesc,'0.00' as debitAmt,d.dblSettlementAmt as creditAmt" + " ,'0.00' as "
						+ " balance " + " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo AND a.strClientCode='"+clientCode+"' "
						+ " AND b.strClientCode='"+clientCode+"'" + " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo  "
						+ " AND c.strClientCode='"+clientCode+"'"
						+ " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo AND d.strClientCode='"+clientCode+"'" + " left outer join"
						+ "  tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode AND e.strClientCode='"+clientCode+"'" + " "
						+ " WHERE a.strFolioNo='" + folioNo + "'  AND c.strAgainst='Folio-No'  "  + ""
						+ " GROUP BY d.strReceiptNo,d.strSettlementCode ";
				
				List paymentDtlList = objFolioService.funGetParametersList(sqlPaymentDtl);
				if(paymentDtlList!=null && paymentDtlList.size()>0){
				
					for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);

						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							clsFolioPrintingBean folioPrintingBean = new clsFolioPrintingBean();

							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							
							balance += debitAmount - creditAmount;

							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-mm-yyyy", docDate));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);

							dataList.add(folioPrintingBean);
						}
					}

				}
				
				

				String sqlPayDtlAgainstRes = "SELECT DATE_FORMAT(DATE(a.dteReceiptDate),'%d-%m-%Y'),a.strReceiptNo,c.strSettlementDesc,'0.00' AS debitAmt,"
						+ " b.dblSettlementAmt AS creditAmt,'0.00' AS balance"
						+ " FROM tblreceipthd a"
						+ " LEFT OUTER "
						+ " JOIN tblreceiptdtl b ON a.strReceiptNo=b.strReceiptNo "
						+ " LEFT OUTER "
						+ " JOIN tblsettlementmaster c ON b.strSettlementCode=c.strSettlementCode ,tblfoliohd d"
						+ " WHERE a.strReservationNo=d.strReservationNo AND  d.strFolioNo='"+folioNo+"' AND d.strRoom='Y' and "
						+ " a.strReservationNo='"+reservationNo+"' AND a.strAgainst='Reservation'  AND a.strClientCode='"+clientCode+"'; ";

						
				
				List paymentDtlListAgainstRes = objFolioService.funGetParametersList(sqlPayDtlAgainstRes);
				if(paymentDtlListAgainstRes!=null && paymentDtlListAgainstRes.size()>0){
					
					for (int i = 0; i < paymentDtlListAgainstRes.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlListAgainstRes.get(i);

						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							clsFolioPrintingBean folioPrintingBean = new clsFolioPrintingBean();

							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance += debitAmount - creditAmount;

							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-mm-yyyy", docDate));
							folioPrintingBean.setStrDocNo(docNo);
							folioPrintingBean.setStrPerticulars(particulars);
							folioPrintingBean.setDblDebitAmt(debitAmount);
							folioPrintingBean.setDblCreditAmt(creditAmount);
							folioPrintingBean.setDblBalanceAmt(balance);

							dataList.add(folioPrintingBean);
						}
					}

				}
				
				 sqlPayDtlAgainstRes = "SELECT DATE_FORMAT(DATE(a.dteReceiptDate),'%d-%m-%Y'),a.strReceiptNo,c.strSettlementDesc,'0.00' AS debitAmt,"
						+ " b.dblSettlementAmt AS creditAmt,'0.00' AS balance"
						+ " FROM tblreceipthd a"
						+ " LEFT OUTER "
						+ " JOIN tblreceiptdtl b ON a.strReceiptNo=b.strReceiptNo "
						+ " LEFT OUTER "
						+ " JOIN tblsettlementmaster c ON b.strSettlementCode=c.strSettlementCode ,tblfoliohd d "
						+ " WHERE a.strReservationNo=d.strReservationNo AND  d.strFolioNo='"+folioNo+"' AND d.strRoom='Y' and "
						+ " a.strCheckInNo='"+CheckInNo+"' AND a.strAgainst='Check-In' "
						+ " AND a.strClientCode='"+clientCode+"';";
				
				List paymentDtlListAgainstCheckin = objFolioService.funGetParametersList(sqlPayDtlAgainstRes);
				if(paymentDtlListAgainstCheckin!=null && paymentDtlListAgainstCheckin.size()>0){
					
					for (int i = 0; i < paymentDtlListAgainstCheckin.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlListAgainstCheckin.get(i);

						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							clsFolioPrintingBean folioPrintingBean = new clsFolioPrintingBean();

							String docNo = paymentArr[1].toString();
							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());
							balance += debitAmount - creditAmount;

							folioPrintingBean.setDteDocDate(objGlobal.funGetDate("dd-mm-yyyy", docDate));
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
			List<clsFolioPrintingBean> listTax=new ArrayList<>();
			for(clsFolioPrintingBean folioPrintingBean :dataList){
				if(folioPrintingBean.isTax()){
					listTax.add(folioPrintingBean);
					
				}
				
			}
			
			JRDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(dataList);
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
				resp.setHeader("Content-Disposition", "inline;filename=Folio.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
