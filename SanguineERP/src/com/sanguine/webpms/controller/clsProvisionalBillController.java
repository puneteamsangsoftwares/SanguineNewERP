package com.sanguine.webpms.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.text.SimpleDateFormat;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsBillPrintingBean;
import com.sanguine.webpms.bean.clsFolioPrintingBean;
import com.sanguine.webpms.bean.clsPaymentReciptBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;

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


@Controller
public class clsProvisionalBillController 
{
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private clsSetupMasterService objSetupMasterService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@RequestMapping(value = "/frmProvisionBill", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";

		List<String> listAgainst = new ArrayList<>();
		listAgainst.add("Reservation");
		// listAgainst.add("Check-In");
		listAgainst.add("Folio-No");
		listAgainst.add("Bill");
		model.put("listAgainst", listAgainst);

		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if (urlHits.equalsIgnoreCase("1")) {

			return new ModelAndView("frmProvisionBill", "command", new clsBillPrintingBean());
		} else {
			return new ModelAndView("frmProvisionBill_1", "command", new clsBillPrintingBean());
		}
	}
	
	
	
	@RequestMapping(value = "/rptProvisionBillPrinting", method = RequestMethod.GET)
	public void funGenerateProvisionalBillPrintingReportForReservation(@RequestParam("fromDate") String fromDate, @RequestParam("toDate") String toDate,@RequestParam("docNo") String docNo, @RequestParam("against") String against, HttpServletRequest req, HttpServletResponse resp) {
		try {
			boolean flgBillRecord = false;
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String companyName = req.getSession().getAttribute("companyName").toString();
			clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
			if (objSetup == null) {
				objSetup = new clsPropertySetupModel();
			}
			String reportName = "";
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
            String strFolioNo="";
			List<clsBillPrintingBean> dataList = new ArrayList<clsBillPrintingBean>();
			@SuppressWarnings("rawtypes")
			HashMap reportParams = new HashMap();
			Map<String,clsBillPrintingBean> mapFolio = new HashMap<>();
			reportParams.put("pCompanyName", companyName);
			reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
			reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
			reportParams.put("pContactDetails", "");
			reportParams.put("strImagePath", imagePath);
			reportParams.put("strUserCode", userCode);
			reportParams.put("pFromDate", fromDate);
			reportParams.put("pTtoDate", toDate);
			if(against.equalsIgnoreCase("Reservation"))
			{
				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptProvisionalBillForReservation.jrxml");
				reportParams.put("pDocName", "Reservation No");	
			}
			else
			{
				reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptProvisionalBillForCheckIn.jrxml");
				reportParams.put("pDocName", "Check In No");
			}
			reportParams.put("pDocNo", docNo);	
			
			String[] fromDteArr = fromDate.split("-");
			String dteFromDate = fromDteArr[2]+"-"+fromDteArr[1]+"-"+fromDteArr[0];
			String[] toDateForQueryeArr = fromDate.split("-");
			String toDateForQuery = toDateForQueryeArr[2]+"-"+toDateForQueryeArr[1]+"-"+toDateForQueryeArr[0];
			// get bill details
			if(against.equalsIgnoreCase("Reservation"))
			{
				/*String sqlBillDtl = "SELECT a.strReservationNo,b.dblRoomRate,b.strRoomType, DATEDIFF(a.dteDepartureDate, a.dteArrivalDate), "
								+ " a.dteReservationDate,c.strRoomTypeDesc,CONCAT(d.strFirstName,' ',d.strMiddleName,' ',d.strLastName),ifnull(sum(g.dblIncomeHeadAmt),0) "
								+ " FROM tblreservationhd a left outer join tblroompackagedtl g on a.strReservationNo=g.strReservationNo,tblreservationroomratedtl b,tblroomtypemaster c,tblguestmaster d, "
								+ " tblreservationdtl e "
								+ " WHERE a.strReservationNo=b.strReservationNo AND a.strReservationNo=e.strReservationNo " 
								+ " AND e.strRoomType=c.strRoomTypeCode "
								+ " AND e.strGuestcode=d.strGuestCode "
								+ " AND a.strReservationNo='"+docNo+"' and date(a.dteDepartureDate)>='"+toDateForQuery+"'"
								+ " GROUP BY e.strRoomType,e.strGuestCode";
			
				
				
				
				List billDtlList = objWebPMSUtility.funExecuteQuery(sqlBillDtl, "sql");
				for (int i = 0; i < billDtlList.size(); i++) 
				{
					Object[] billArr = (Object[]) billDtlList.get(i);
					double billAmount=0.0;
					clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();

					String roomNo = billArr[2].toString();
					
					int noOfNights = Integer.valueOf(billArr[3].toString());
	                if(noOfNights==0)
	                {
	                	noOfNights=1;
	                }
					billPrintingBean.setDteDocDate(billArr[4].toString());
					billPrintingBean.setStrDocNo(billArr[0].toString());
					billPrintingBean.setStrRoomNo(roomNo);
					billPrintingBean.setStrRoomName(billArr[5].toString());
					if(Double.parseDouble(billArr[7].toString())>0)
					{
						billPrintingBean.setStrBillIncluded("Tariff + Package");
						billPrintingBean.setDblBalanceAmt((Double.parseDouble(billArr[1].toString())*noOfNights) + Double.parseDouble(billArr[7].toString()));
						billAmount = (Double.parseDouble(billArr[1].toString())*noOfNights) + Double.parseDouble(billArr[7].toString());
					}
					else
					{
						billPrintingBean.setStrBillIncluded("Tariff");
						billPrintingBean.setDblBalanceAmt(Double.parseDouble(billArr[1].toString())*noOfNights);
						billAmount = (Double.parseDouble(billArr[1].toString())*noOfNights);
					}
					billPrintingBean.setStrGuestName(billArr[6].toString());
					dataList.add(billPrintingBean);
					
					double pkgsAmt=0,totalRoomBill=0;
					billPrintingBean = new clsBillPrintingBean();
					billPrintingBean.setStrRoomNo("");
					billPrintingBean.setDblBalanceAmt(billAmount);
					billPrintingBean.setStrRoomName("");
					billPrintingBean.setStrBillIncluded("Total:");
					billPrintingBean.setStrGuestName("");
					dataList.add(billPrintingBean);
				}
				reportParams.put("pRoomNo","Room Type");
				reportParams.put("pRoomName","Room Type Name");
				*/
				
				
				String sql="select a.strReservationNo,b.strGuestCode,CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),b.strRoomType,"
						+ " DATEDIFF(a.dteDepartureDate, a.dteArrivalDate), a.dteReservationDate "
						+ " from tblreservationhd a,tblreservationdtl b,tblguestmaster c "
						+ " where a.strReservationNo=b.strReservationNo and b.strGuestCode=c.strGuestCode "
						+ " and a.strReservationNo='"+docNo+"' and date(a.dteDepartureDate)>='"+toDateForQuery+"'  AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'"
						+ " group by b.strRoomType";

					
				List listReservData = objWebPMSUtility.funExecuteQuery(sql, "sql");
				if(listReservData.size()>0)
				{
					int count=listReservData.size();
					for(int i=0;i<listReservData.size();i++)
					{
						Object[] obj = (Object[])listReservData.get(i);
						
						double billAmount=0.0;
						clsBillPrintingBean billPrintingBean = new clsBillPrintingBean();
						String roomType = obj[3].toString();
						double packageAmt=0;
						int noOfNights = Integer.valueOf(obj[4].toString());
		                if(noOfNights==0)
		                {
		                	noOfNights=1;
		                }
						billPrintingBean.setDteDocDate(obj[5].toString());
						billPrintingBean.setStrDocNo(obj[0].toString());
						billPrintingBean.setStrRoomNo(roomType);
						billPrintingBean.setStrGuestName(obj[2].toString());
						
						
						String sqlPaymentAmt=" SELECT IFNULL(SUM(a.dblIncomeHeadAmt),0) ,a.strRoomNo,IFNULL(b.strRoomTypeDesc,'') "
								+ " FROM tblroompackagedtl a LEFT OUTER JOIN tblroomtypemaster b ON a.strRoomNo=b.strRoomTypeCode"
								+ " WHERE a.strReservationNo='"+docNo+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' GROUP BY a.strRoomNo";
						List listPaymentAmt = objWebPMSUtility.funExecuteQuery(sqlPaymentAmt, "sql");
						if(listPaymentAmt.size()>0)
						{
							for(int cnt=0;cnt<listPaymentAmt.size();cnt++)
							{
								Object[] objPayment = (Object[])listPaymentAmt.get(cnt);
								if(obj[3].toString().equals(objPayment[1].toString()))
								{
									billPrintingBean.setStrRoomName(objPayment[2].toString());
									billPrintingBean.setStrBillIncluded("Tariff + Package");
									if(packageAmt>0)
									{
										billPrintingBean.setDblBalanceAmt(Double.parseDouble(objPayment[0].toString())+(packageAmt/count));
										billAmount =Double.parseDouble(objPayment[0].toString())+(packageAmt/count);
									}
								}
								else if(objPayment[1].toString().isEmpty())
								{
									packageAmt=Double.parseDouble(objPayment[0].toString());
								}
							}
						}
						else
						{
							sqlPaymentAmt="SELECT IFNULL(SUM(a.dblRoomRate),0),b.strRoomTypeCode,b.strRoomTypeDesc "
								+ " FROM tblreservationroomratedtl a,tblroomtypemaster b "
								+ " WHERE a.strRoomType=b.strRoomTypeCode AND a.strReservationNo='"+docNo+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
								+ " GROUP BY a.strRoomType";
							listPaymentAmt = objWebPMSUtility.funExecuteQuery(sqlPaymentAmt, "sql");
							if(listPaymentAmt.size()>0)
							{
								for(int cnt=0;cnt<listPaymentAmt.size();cnt++)
								{
									Object[] objPayment = (Object[])listPaymentAmt.get(cnt);
									if(obj[3].toString().equals(objPayment[1].toString()))
									{
										billPrintingBean.setStrRoomName(objPayment[2].toString());
										billPrintingBean.setStrBillIncluded("Tariff");
										billPrintingBean.setDblBalanceAmt(Double.parseDouble(objPayment[0].toString()));
										billAmount = (Double.parseDouble(objPayment[0].toString()));
									}	
									
								}
							}
						}
						
						dataList.add(billPrintingBean);
						double pkgsAmt=0,totalRoomBill=0;
						billPrintingBean = new clsBillPrintingBean();
						billPrintingBean.setStrRoomNo("");
						billPrintingBean.setDblBalanceAmt(billAmount);
						billPrintingBean.setStrRoomName("");
						billPrintingBean.setStrBillIncluded("Total:");
						billPrintingBean.setStrGuestName("");
						dataList.add(billPrintingBean);
					}	
					
				}
				reportParams.put("pRoomNo","Room Type");
				reportParams.put("pRoomName","Room Type Name");	
				
			}
			else
			{
				
				String sqlBillDtl="";
				int roomCount=0;
				Object[] arrObj=null;
				String sql = "select a.strReservationNo,a.strWalkInNo,count(b.strRoomNo) "
						+ " from tblcheckinhd a,tblcheckindtl b "
						+ " where a.strCheckInNo=b.strCheckInNo "
						+ " and a.strCheckInNo='"+docNo+"' and date(a.dteDepartureDate)>='"+toDateForQuery+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
					    + " group by a.strCheckInNo";
				List list = objWebPMSUtility.funExecuteQuery(sql, "sql");
				if(list.size()>0)
				{
					for (int cnt = 0; cnt < list.size(); cnt++) 
					{
						 arrObj = (Object[]) list.get(cnt);
						roomCount=Integer.valueOf(arrObj[2].toString());
						if(!arrObj[0].toString().isEmpty())
						{
							sqlBillDtl= " SELECT a.strCheckInNo,0,b.strRoomNo, DATEDIFF(a.dteDepartureDate, a.dteArrivalDate),"
									+ " a.dteCheckInDate,d.strRoomDesc,b.strFolioNo, CONCAT(f.strFirstName,' ',f.strMiddleName,' ',f.strLastName), IFNULL((g.dblIncomeHeadAmt),0),e.dtDate,h.strPackageName,ifnull(f.lngMobileNo,''),ifnull(f.strAddressLocal,'') "
									+ " FROM tblcheckinhd a"
									+ " LEFT OUTER JOIN tblroompackagedtl g ON a.strCheckInNo=g.strCheckInNo AND g.strRoomNo='', tblfoliohd b,tblroom d,"
									+ " tblreservationroomratedtl e,tblguestmaster f,tblpackagemasterhd h"
									+ " WHERE a.strCheckInNo=b.strCheckInNo AND b.strRoomNo=d.strRoomCode AND a.strReservationNo=e.strReservationNo "
									+ " AND d.strRoomTypeCode=e.strRoomType AND b.strGuestCode=f.strGuestCode and g.strPackageCode=h.strPackageCode AND a.strCheckInNo='"+docNo+"' "
									+ " AND DATE(a.dteDepartureDate)>='"+toDateForQuery+"'  and g.strType='IncomeHead'"
									+ " GROUP BY g.strType"
									+ " Union All "
									+ " SELECT a.strCheckInNo,e.dblRoomRate,b.strRoomNo, DATEDIFF(a.dteDepartureDate, a.dteArrivalDate),a.dteCheckInDate,d.strRoomDesc,b.strFolioNo, CONCAT(f.strFirstName,' ',f.strMiddleName,' ',f.strLastName),0,e.dtDate,'',ifnull(f.lngMobileNo,''),ifnull(f.strAddressLocal,'')"
									+ " FROM tblcheckinhd a left outer join tblroompackagedtl g on a.strCheckInNo=g.strCheckInNo ,tblfoliohd b,tblroom d,tblreservationroomratedtl e,tblguestmaster f"
									+ " WHERE a.strCheckInNo=b.strCheckInNo AND b.strRoomNo=d.strRoomCode AND a.strReservationNo=e.strReservationNo"
									+ " AND d.strRoomTypeCode=e.strRoomType AND b.strGuestCode=f.strGuestCode AND a.strCheckInNo='"+docNo+"' "
									+ " and date(a.dteDepartureDate)>='"+toDateForQuery+"' and g.strType='RoomTariff' and  g.dblIncomeHeadAmt <> 0"
									+ " GROUP BY e.dtDate,b.strRoomNo ";
						}
						else
						{
							sqlBillDtl= " SELECT a.strCheckInNo,e.dblRoomRate,b.strRoomNo, DATEDIFF(a.dteDepartureDate, a.dteArrivalDate),a.dteCheckInDate,d.strRoomDesc,b.strFolioNo, CONCAT(f.strFirstName,' ',f.strMiddleName,' ',f.strLastName),ifnull(sum(g.dblIncomeHeadAmt),0),e.dtDate,ifnull(f.lngMobileNo,''),ifnull(f.strAddressLocal,'')"
									+ " FROM tblcheckinhd a left outer join tblroompackagedtl g on a.strCheckInNo=g.strCheckInNo and g.strRoomNo='' AND a.strClientCode='"+clientCode+"' AND g.strClientCode='"+clientCode+"' ,tblfoliohd b,tblroom d,tblwalkinroomratedtl e,tblguestmaster f"
									+ " WHERE a.strCheckInNo=b.strCheckInNo AND b.strRoomNo=d.strRoomCode AND a.strWalkInNo=e.strWalkInNo"
									+ " AND d.strRoomTypeCode=e.strRoomType AND b.strGuestCode=f.strGuestCode AND a.strCheckInNo='"+docNo+"' "
									+ " and date(a.dteDepartureDate)>='"+toDateForQuery+"' AND b.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' AND f.strClientCode='"+clientCode+"'"
									+ " GROUP BY e.dtDate,b.strRoomNo ";
						}
						
					}
				}
				
				clsBillPrintingBean billPrintingBean =null;
				double billAmount=0.0;
				double dblTerrifAmount=0;
				List billDtlList = objWebPMSUtility.funExecuteQuery(sqlBillDtl, "sql");
				int sizelist= billDtlList.size()-1;
				for (int i = 0; i < billDtlList.size(); i++) 
				{
					Object[] billArr = (Object[]) billDtlList.get(i);
					billPrintingBean = new clsBillPrintingBean();				
					String roomNo = billArr[2].toString();					
					int noOfNights = Integer.valueOf(billArr[3].toString());
	                if(noOfNights==0)
	                {
	                	noOfNights=1;
	                }
	                if(!arrObj[0].toString().isEmpty()){
	                	reportParams.put("mobileNo",billArr[11].toString());
	 					reportParams.put("guestAdd",billArr[12].toString());
	                }
	                else
	                {
	                	 reportParams.put("mobileNo",billArr[10].toString());
	 					 reportParams.put("guestAdd",billArr[11].toString());
	                }
	               
	                String []spDocDate=billArr[9].toString().split("-");
					billPrintingBean.setDteDocDate(spDocDate[2]+"-"+spDocDate[1]+"-"+spDocDate[0]);
					
					billPrintingBean.setStrDocNo(billArr[0].toString());
					
					billPrintingBean.setDblBalanceAmt(Double.parseDouble(billArr[1].toString()));
					billPrintingBean.setStrRoomName(billArr[5].toString());
					
					if(mapFolio.get(billArr[7].toString() +" "+roomNo) ==null)
					{
						billPrintingBean.setStrGuestName(billArr[7].toString());
						billPrintingBean.setStrRoomNo(roomNo);
						billPrintingBean.setStrRoomName(billArr[5].toString());
					}
					else
					{
						billPrintingBean.setStrGuestName("");
						billPrintingBean.setStrRoomNo("");
						billPrintingBean.setStrRoomName("");
					}	
					
					
					if(Double.parseDouble(billArr[8].toString())>0)
					{
						billPrintingBean.setStrBillIncluded(billArr[10] + " Package");
						billPrintingBean.setDblBalanceAmt((Double.parseDouble(billArr[1].toString()))+Double.parseDouble(billArr[8].toString())/roomCount);
						billAmount += (Double.parseDouble(billArr[1].toString()))+Double.parseDouble(billArr[8].toString())/roomCount;
						billPrintingBean.setStrGuestName(billArr[7].toString());
						billPrintingBean.setStrRoomNo(roomNo);
						billPrintingBean.setStrRoomName(billArr[5].toString());
						dataList.add(billPrintingBean);
					}
					else
					{
						billPrintingBean.setStrBillIncluded("Tariff");
						billAmount += Double.parseDouble(billArr[1].toString());
						dblTerrifAmount +=Double.parseDouble(billArr[1].toString());
						billPrintingBean.setDblBalanceAmt(dblTerrifAmount);
						billPrintingBean.setStrGuestName(billArr[7].toString());
						billPrintingBean.setStrRoomNo(roomNo);
						billPrintingBean.setStrRoomName(billArr[5].toString());
						if(sizelist==i)
						{
							dataList.add(billPrintingBean);
						}
					}
									
					mapFolio.put(billArr[7].toString() +" "+roomNo,billPrintingBean);		
					
					strFolioNo=billArr[6].toString();
					
					
					
					
				}
				
				Map<String,clsBillPrintingBean> mapFolioPostingForIncomeHead=new HashMap<>();
				String sqlCheckInListDtl = " select b.strFolioNo,b.strPerticulars,b.dblDebitAmt, DATE_FORMAT( DATE(b.dteDocDate),'%d-%m-%Y') "
						+ " from tblfoliohd a,tblfoliodtl b "
						+ " where b.strFolioNo='"+strFolioNo+"' and  b.strRevenueType!='Package' and b.strRevenueType!='Room' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ " GROUP by b.strDocNo ";
				
				List packagesList = objWebPMSUtility.funExecuteQuery(sqlCheckInListDtl, "sql");;
				for (int j = 0; j < packagesList.size(); j++) {					
					Object[] pkgsArr = (Object[]) packagesList.get(j);
					billPrintingBean = new clsBillPrintingBean();					
				    //billAmount+=Double.parseDouble(pkgsArr[2].toString());
					billPrintingBean.setStrRoomNo("");
					billPrintingBean.setDblBalanceAmt(Double.parseDouble(pkgsArr[2].toString()));
					billPrintingBean.setStrRoomName("");
					billPrintingBean.setStrBillIncluded(pkgsArr[1].toString());
					billPrintingBean.setStrGuestName("");
					billPrintingBean.setDteDocDate("");
					billPrintingBean.setDteDocDate(pkgsArr[3].toString());
				   
					if(mapFolioPostingForIncomeHead.get(pkgsArr[1].toString())!=null)
					{
						clsBillPrintingBean objBill=mapFolioPostingForIncomeHead.get(pkgsArr[1].toString());
						objBill.setDblBalanceAmt(mapFolioPostingForIncomeHead.get(pkgsArr[1].toString()).getDblBalanceAmt() + Double.parseDouble(pkgsArr[2].toString()) );
						mapFolioPostingForIncomeHead.put(pkgsArr[1].toString(), objBill);
					}
					else
					{
						mapFolioPostingForIncomeHead.put(pkgsArr[1].toString(), billPrintingBean);
					}
					
				}
				
			 for (Map.Entry<String,clsBillPrintingBean> entry : mapFolioPostingForIncomeHead.entrySet()) 
        	 {
				 billAmount+=entry.getValue().getDblBalanceAmt();
				 dataList.add(entry.getValue());
        	 }
				
			
				
				Map<String,clsBillPrintingBean> mapForAdvancePayment = new HashMap<>();
				String sqlPaymentDtl = "SELECT DATE_FORMAT(date(b.dteDocDate),'%d-%m-%Y'),c.strReceiptNo,CONCAT(e.strSettlementDesc,'   ','(', DATE_FORMAT(DATE(c.dteReceiptDate),'%d-%m-%Y'),')'),'0.00' as debitAmt,d.dblSettlementAmt as creditAmt" + " ,'0.00' as "
						+ " balance " + " FROM tblfoliohd a LEFT OUTER JOIN tblfoliodtl b ON a.strFolioNo=b.strFolioNo AND a.strClientCode='"+clientCode+"' "
						+ " AND b.strClientCode='"+clientCode+"'" + " left outer join tblreceipthd c on a.strFolioNo=c.strFolioNo OR a.strReservationNo=c.strReservationNo "
						+ " AND c.strClientCode='"+clientCode+"'"
						+ " left outer join tblreceiptdtl d on c.strReceiptNo=d.strReceiptNo AND d.strClientCode='"+clientCode+"'" + " left outer join"
						+ "  tblsettlementmaster e on d.strSettlementCode=e.strSettlementCode AND e.strClientCode='"+clientCode+"'" + " "
						+ " WHERE a.strFolioNo='" + strFolioNo + "' " + ""
						+ " GROUP BY d.strReceiptNo,d.strSettlementCode"
						+ " Order By c.dteReceiptDate ";
				
				List paymentDtlList =  objWebPMSUtility.funExecuteQuery(sqlPaymentDtl, "sql");
				if(paymentDtlList!=null && paymentDtlList.size()>0){
					
					for (int i = 0; i < paymentDtlList.size(); i++) {
						Object[] paymentArr = (Object[]) paymentDtlList.get(i);

						String docDate = paymentArr[0].toString();
						if (paymentArr[1] == null) {
							continue;
						} else {
							billPrintingBean = new clsBillPrintingBean();		

							String particulars = paymentArr[2].toString();
							double debitAmount = Double.parseDouble(paymentArr[3].toString());
							double creditAmount = Double.parseDouble(paymentArr[4].toString());

						
							
							billPrintingBean = new clsBillPrintingBean();
							billPrintingBean.setStrRoomNo("");
							billPrintingBean.setDblBalanceAmt(creditAmount);
							billPrintingBean.setStrRoomName("");
							billPrintingBean.setStrBillIncluded(particulars);
							billPrintingBean.setStrGuestName("");
							billPrintingBean.setDteDocDate("");
							if(mapForAdvancePayment.get(particulars) !=null)
							{
								clsBillPrintingBean billPrintBean= mapForAdvancePayment.get(particulars);					
								billPrintingBean.setDblBalanceAmt( billPrintBean.getDblBalanceAmt() + creditAmount);
								mapForAdvancePayment.put(particulars, billPrintingBean);
							}
							else
							{
								mapForAdvancePayment.put(particulars, billPrintingBean);
							}
							
						
						}
					}

				}
				 for (Map.Entry<String,clsBillPrintingBean> entryPay : mapForAdvancePayment.entrySet()) 
	        	 {
					 billAmount -=entryPay.getValue().getDblBalanceAmt();
					 dataList.add(entryPay.getValue());
	        	 }
			
				
				billPrintingBean = new clsBillPrintingBean();
				billPrintingBean.setStrRoomNo("");
				billPrintingBean.setDblBalanceAmt(billAmount);
				billPrintingBean.setStrRoomName("");
				billPrintingBean.setStrBillIncluded("Total:");
				billPrintingBean.setStrGuestName("");
				billPrintingBean.setDteDocDate("");
				dataList.add(billPrintingBean);
	
				reportParams.put("pRoomNo","Room No");
				reportParams.put("pRoomName","Room Name");
				reportParams.put("dblTotalBill",billAmount);
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
				resp.setHeader("Content-Disposition", "inline;filename=ProvisionBill.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


}
