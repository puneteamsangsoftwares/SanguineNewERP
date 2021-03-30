package com.sanguine.webpms.controller;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.util.clsReportBean;
import com.sanguine.webpms.bean.clsCheckInListReportBean;
import com.sanguine.webpms.bean.clsFolioPrintingBean;
import com.sanguine.webpms.service.clsFolioService;

@Controller
public class clsCheckInListReportController {

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

	// Open Folio Printing
	@RequestMapping(value = "/frmCheckInList", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckInList_1", "command", new clsCheckInListReportBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckInList", "command", new clsCheckInListReportBean());
		} else {
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rptCheckInList", method = RequestMethod.GET)
	public void funGenerateCheckInListReport(@RequestParam("fromDate") String fromDate, @RequestParam("toDate") String toDate, HttpServletRequest req, HttpServletResponse resp) {
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
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptCheckInList.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");

			List<clsFolioPrintingBean> dataList = new ArrayList<clsFolioPrintingBean>();
			@SuppressWarnings("rawtypes")
			String propNameSql = "select a.strPropertyName from "+webStockDB+".tblpropertymaster a " + " where a.strPropertyCode='" + propertyCode + "' and a.strClientCode='" + clientCode + "' ";
			List listPropName = objGlobalFunctionsService.funGetDataList(propNameSql, "sql");
			String propName = "";
			if (listPropName.size() > 0) {
				propName = listPropName.get(0).toString();
			}

			HashMap reportParams = new HashMap();

			reportParams.put("pCompanyName", companyName);
			reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
			reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
			reportParams.put("pContactDetails", "");
			reportParams.put("strImagePath", imagePath);
			reportParams.put("strUserCode", userCode);
			reportParams.put("pFromDate", objGlobal.funGetDate("dd-MM-yyyy", fromDate));
			reportParams.put("pTtoDate", objGlobal.funGetDate("dd-MM-yyyy", toDate));
			reportParams.put("propName", propName);

			// get all parameters
			/*String sqlParametersCheckInList = " SELECT ch.strReservationNo, IFNULL(h.strBookingTypeDesc,'NA'), " + " DATE_FORMAT(ch.dteDateCreated,'%d-%m-%Y'),IFNULL(c.strCorporateDesc,'NA'), " + " IFNULL(k.strBookerName,'NA'), DATE_FORMAT(a.dteCancelDate,'%d-%m-%Y'), " + " IFNULL(f.strDescription,'NA'),IFNULL(g.strBillingInstDesc,'NA'), "
					+ " CONCAT(j.strFirstName,' ',j.strMiddleName,' ',j.strLastName),j.strGuestCode,ch.strCheckInNo,sum(i.dblReceiptAmt),b.strRoomNo " 
					+ " FROM tblcheckinhd ch " + " LEFT OUTER JOIN tblreservationhd a ON a.strReservationNo = ch.strReservationNo and a.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblreservationdtl b ON a.strReservationNo=b.strReservationNo and b.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblcorporatemaster c ON a.strCorporateCode=c.strCorporateCode and c.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblbusinesssource f ON a.strBusinessSourceCode=f.strBusinessSourceCode and f.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblbillinginstructions g ON a.strBillingInstCode=g.strBillingInstCode and g.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblbookingtype h ON a.strBookingTypeCode=h.strBookingTypeCode and h.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblreceipthd i ON ch.strCheckInNo=i.strCheckInNo And i.strAgainst='Check-In' and i.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblguestmaster j ON j.strGuestCode=b.strGuestCode and j.strClientCode='"
					+ clientCode
					+ "' "
					+ " LEFT OUTER JOIN tblbookermaster k ON k.strBookerCode=a.strBookerCode AND k.strClientCode='"
					+ clientCode + "' " + " WHERE DATE(a.dteArrivalDate) BETWEEN '" + fromDate + "' and '" + toDate + "' " + " AND ch.strClientCode='" + clientCode + "' AND a.strPropertyCode='" + propertyCode + "' " + " group by ch.strReservationNo ";*/

			String sqlParametersCheckInList = "SELECT a.strCheckInNo,a.strType, DATE(a.dteArrivalDate),c.strRoomDesc,"
					+ "c.strRoomTypeDesc,d.strFirstName, "
					+ "d.strMiddleName,d.strLastName,Concat(d.strAddressLocal,' ',d.strCityLocal,' ',"
					+ "d.strStateLocal,' ',d.strCountryLocal,' ',d.intPinCodeLocal),d.strArrivalFrom "
					+ "FROM tblcheckinhd a,tblcheckindtl b,tblroom c,tblguestmaster d "
					+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strRoomNo=c.strRoomCode "
					+ "AND b.strGuestCode=d.strGuestCode  "
					+ "and Date(a.dteCheckInDate) between '"+fromDate+"' and '"+toDate+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"'";
			
			List listOfCheckIn = objGlobalFunctionsService.funGetDataList(sqlParametersCheckInList, "sql");
			ArrayList fieldList = new ArrayList();

			for (int i = 0; i < listOfCheckIn.size(); i++) {
				Object[] arr = (Object[]) listOfCheckIn.get(i);
				clsCheckInListReportBean checkInListBean = new clsCheckInListReportBean();

				checkInListBean.setStrCheckInNo(arr[0].toString());
				checkInListBean.setStrBookingTypeDesc(arr[1].toString());
				checkInListBean.setDteDateCreated(objGlobal.funGetDate("dd-MM-yyyy", arr[2].toString()));
				checkInListBean.setStrRoomTypeCode(arr[3].toString());
				checkInListBean.setStrRoomTypeDesc(arr[4].toString());
				checkInListBean.setStrFirstName(arr[5].toString());
				checkInListBean.setStrMiddleName(arr[6].toString());
				checkInListBean.setStrLastName(arr[7].toString());
				checkInListBean.setStrAddress(arr[8].toString());
				//checkInListBean.setDblReceiptAmt(Double.parseDouble(arr[9].toString()));
				checkInListBean.setStrArrivalFrom(arr[9].toString());
				
				
				fieldList.add(checkInListBean);
				
			/*	String sqlCheckInListDtl = " select a.strFirstName,a.strMiddleName,a.strLastName,b.strRoomTypeDesc,a.strAddress," 
						+ " a.strArrivalFrom,a.strProceedingTo,b.strRoomTypeCode"
						+ " from tblguestmaster a,tblroomtypemaster b,tblcheckinhd c,tblroom d,tblcheckindtl e " + " where  date(c.dteArrivalDate) between '" + fromDate + "' and '" + toDate + "' and c.strCheckInNo='" + strCheckInCode + "' "
						+ " and c.strCheckInNo=e.strCheckInNo and e.strGuestCode=a.strGuestCode" + " and e.strRoomNo=d.strRoomCode and  d.strRoomTypeCode=b.strRoomTypeCode" + " and  a.strClientCode='" + clientCode + "' and  b.strClientCode='" + clientCode + "' " + " and  c.strClientCode='" + clientCode + "' and  d.strClientCode='" + clientCode + "' " + " and  e.strClientCode='" + clientCode
						+ "' ";
				List checkInDtlList = objGlobalFunctionsService.funGetDataList(sqlCheckInListDtl, "sql");
				for (int j = 0; j < checkInDtlList.size(); j++) {
					Object[] GuestArr = (Object[]) checkInDtlList.get(j);
					checkInListBean.setGuestFirstName(GuestArr[0].toString());
					checkInListBean.setStrMiddleName(GuestArr[1].toString());
					checkInListBean.setStrLastName(GuestArr[2].toString());
					checkInListBean.setStrRoomTypeDesc(GuestArr[3].toString());
					checkInListBean.setStrAddress(GuestArr[4].toString());
					checkInListBean.setStrArrivalFrom(GuestArr[5].toString());
					checkInListBean.setStrProceedingTo(GuestArr[6].toString());
					
					fieldList.add(checkInListBean);
				}*/
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
				resp.setHeader("Content-Disposition", "inline;filename=CheckInList.pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/rptOccupancyReportExport", method = RequestMethod.POST)
	private ModelAndView funExportOccupancyReport(HttpServletResponse resp, HttpServletRequest req, clsReportBean objBean) {
		objGlobal = new clsGlobalFunctions();
		Connection con = objGlobal.funGetConnection(req);
		List ExportList = new ArrayList();
		
		
			
			List listStock = new ArrayList();
			String userCode = req.getSession().getAttribute("usercode").toString();

			ExportList.add("OccupancyReport");

			List titleData = new ArrayList<>();
			titleData.add("Occupancy Report");
			ExportList.add(titleData);

			List filterData = new ArrayList<>();
			filterData.add(" ");
			filterData.add(objGlobal.funGetCurrentDate("dd-MM-yyyy"));
			ExportList.add(filterData);
			
			String[] ExcelHeader = { "Room No", "Guest Name","Room Type", "CheckIn Date","CheckOut Date","Pax", "Plan", "Final Amount", "Booked By"};
			ExportList.add(ExcelHeader);
			
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			Map<String,List> hmDtl=new HashMap<String,List>();
			Set setHeader=new HashSet();
			int totPax=0;
			double totRoomAmount=0.00;
			int count=0;
			
			String sql=" SELECT e.strRoomDesc AS RoomDesc, CONCAT(IFNULL(f.strFirstName,''),' ',"
					+ " IFNULL(f.strMiddleName,''),' ', IFNULL(f.strLastName,'')) AS GuestName,g.strRoomTypeDesc,"
					+ " DATE_FORMAT(c.dteCheckInDate,'%d-%m-%Y'), DATE_FORMAT(c.dteDepartureDate,'%d-%m-%Y'),"
					+ " (d.intNoOfFolios) AS Pax, IFNULL(j.strPlanDesc,'') AS PlanDesc,(SUM(b.dblDebitAmt)) AS FinalAmt,"
					+ " IFNULL(i.strBookingTypeDesc,c.strUserCreated) AS BookedBy "
					+ " FROM tblfoliohd a, tblfoliodtl b, tblcheckinhd c "
					+ " LEFT OUTER JOIN tblplanmaster j ON c.strPlanCode=j.strPlanCode "
					+ " LEFT OUTER JOIN tblreservationhd h ON c.strReservationNo=h.strReservationNo "
					+ " LEFT OUTER JOIN  "
					+ " tblbookingtype i ON  h.strBookingTypeCode=i.strBookingTypeCode, "
					+ " tblcheckindtl d, tblroom e, tblguestmaster f, tblroomtypemaster g "
					+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = c.strCheckInNo  "
					+ " AND a.strCheckInNo = c.strCheckInNo AND a.strRoomNo = d.strRoomNo"
					+ " AND c.strCheckInNo = d.strCheckInNo AND a.strRoomNo = e.strRoomCode "
					+ " AND a.strGuestCode = f.strGuestCode AND e.strRoomTypeCode = g.strRoomTypeCode GROUP BY e.strRoomCode ORDER BY e.strRoomDesc Asc ";			
			List finalList=new ArrayList();
			List listOccupancy = objGlobalFunctionsService.funGetDataList(sql, "sql");
			if(listOccupancy.size()>0)
			{
				for(int i=0;i<listOccupancy.size();i++)
				{
					List dataList = new ArrayList<>();
					Object[] ob = (Object[]) listOccupancy.get(i);
					dataList.add(ob[0].toString());//RoomNo
					dataList.add(ob[1].toString());//Guest Name 
					dataList.add(ob[2].toString());//Room Type
					dataList.add(ob[3].toString()); //CheckIn Date
					dataList.add(ob[4].toString());//CheckOut Date
					dataList.add(ob[5].toString());//Pax
					if(ob[6] != null)
					{
						dataList.add(ob[6].toString());//Plan
					}
					else
					{
						dataList.add(" ");
					}
					dataList.add(ob[7].toString());//Final Amt
					dataList.add(ob[8].toString());//Booked By
					finalList.add(dataList);
					totPax=totPax+ Integer.parseInt(ob[5].toString());
					totRoomAmount=totRoomAmount + Double.parseDouble(ob[7].toString());
					count++;
				}
			}
			
			List blank = new ArrayList<>();
			blank.add("");
			finalList.add(blank);
			
			List totallist=new ArrayList<>();
			totallist.add(" Total-     " +count);
			totallist.add(" ");
			totallist.add(" ");
			totallist.add(" ");
			totallist.add(" ");
			totallist.add(totPax);
			totallist.add(" ");
			totallist.add(totRoomAmount);
			totallist.add(" ");
			totallist.add(" ");
			finalList.add(totallist);
			
			
		
	     ExportList.add(finalList);
			
		return new ModelAndView("excelViewFromDateTodateWithReportName", "listFromDateTodateWithReportName", ExportList);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/rptInHouseReportExport", method = RequestMethod.POST)
	private ModelAndView funExportInHouseReport(HttpServletResponse resp, HttpServletRequest req) {
		objGlobal = new clsGlobalFunctions();
		Connection con = objGlobal.funGetConnection(req);
		List ExportList = new ArrayList();
		
			List listStock = new ArrayList();
			String userCode = req.getSession().getAttribute("usercode").toString();

			ExportList.add("InHouseReport");

			List titleData = new ArrayList<>();
			titleData.add("InHouse Report");
			ExportList.add(titleData);

			List filterData = new ArrayList<>();
			filterData.add(" ");
			filterData.add(objGlobal.funGetCurrentDate("dd-MM-yyyy"));
			

			ExportList.add(filterData);
			
			String[] ExcelHeader = { "Room No", "Guest Name","Room Type","CheckIn Date","CheckOut Date", "Pax", "Plan", "Booked By"};
			ExportList.add(ExcelHeader);
			
			
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			
		    String sql=" SELECT e.strRoomDesc AS RoomDesc, CONCAT(IFNULL(f.strFirstName,''),' ',"
					+ " IFNULL(f.strMiddleName,''),' ', IFNULL(f.strLastName,'')) AS GuestName,g.strRoomTypeDesc,"
					+ " DATE_FORMAT(c.dteCheckInDate,'%d-%m-%Y'), DATE_FORMAT(c.dteDepartureDate,'%d-%m-%Y'),"
					+ " (d.intNoOfFolios) AS Pax, IFNULL(j.strPlanDesc,'') AS PlanDesc,"
					+ " IFNULL(i.strBookingTypeDesc,c.strUserCreated) AS BookedBy "
					+ " FROM tblfoliohd a, tblfoliodtl b, tblcheckinhd c "
					+ " LEFT OUTER JOIN tblplanmaster j ON c.strPlanCode=j.strPlanCode "
					+ " LEFT OUTER JOIN tblreservationhd h ON c.strReservationNo=h.strReservationNo "
					+ " LEFT OUTER JOIN  "
					+ " tblbookingtype i ON  h.strBookingTypeCode=i.strBookingTypeCode, "
					+ " tblcheckindtl d, tblroom e, tblguestmaster f, tblroomtypemaster g "
					+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = c.strCheckInNo  "
					+ " AND a.strCheckInNo = c.strCheckInNo AND a.strRoomNo = d.strRoomNo"
					+ " AND c.strCheckInNo = d.strCheckInNo AND a.strRoomNo = e.strRoomCode "
					+ " AND a.strGuestCode = f.strGuestCode AND e.strRoomTypeCode = g.strRoomTypeCode GROUP BY e.strRoomCode";			
		
			List finalList = new ArrayList();
            
			List listInHouse = objGlobalFunctionsService.funGetDataList(sql, "sql");
			if(listInHouse.size()>0)
			{
				for(int i=0;i<listInHouse.size();i++)
				{
					List dataList = new ArrayList<>();
					Object[] ob = (Object[]) listInHouse.get(i);
					dataList.add(ob[0].toString());//RoomNo
					dataList.add(ob[1].toString());//Guest Name 
					dataList.add(ob[2].toString());//Room Type
					dataList.add(ob[3].toString());//CheckIn Date 
                    dataList.add(ob[4].toString());//CheckOut Date 
                    dataList.add(ob[5].toString());//Pax
                    if(ob[6] != null)
					{
						dataList.add(ob[6].toString());//Plan
					}
					else
					{
						dataList.add(" ");
					}
					dataList.add(ob[7].toString());//Booked By
					finalList.add(dataList);
				}
			}
			
		
	     ExportList.add(finalList);
			
		return new ModelAndView("excelViewFromDateTodateWithReportName", "listFromDateTodateWithReportName", ExportList);
	}
}
