package com.sanguine.webpms.controller;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.text.DecimalFormat;
import com.ibm.icu.text.NumberFormat;
import com.ibm.icu.util.Calendar;
import com.itextpdf.text.pdf.hyphenation.TernaryTree.Iterator;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsGuestListReportBean;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.bean.clsRoomStatusDiaryBean;
import com.sanguine.webpms.bean.clsRoomStatusDtlBean;
import com.sanguine.webpms.bean.clsVoidBillBean;
import com.sanguine.webpms.model.clsBusinessSourceMasterModel;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsFolioTaxDtl;
import com.sanguine.webpms.service.clsBusinessSourceMasterService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsRoomMasterService;
import com.sanguine.webpms.service.clsRoomTypeMasterService;

@Controller
public class clsRoomStatusDiaryController {
	@Autowired
	private clsRoomMasterService objRoomMasterService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsFolioService objFolioService;

	// Open Room Status Diary
	@RequestMapping(value = "/frmRoomStatusDiary", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		List listRoom = new ArrayList<>();		
		String sqlRoomType = "select a.strRoomTypeDesc from tblroomtypemaster a where a.strClientCode='"+clientCode+"'";
		listRoom = objGlobalFunctionsService.funGetListModuleWise(sqlRoomType, "sql");
		//listRoom.add("Select room type");
		listRoom.add(0, "SELECT ROOM TYPE");
		/*for (int cnt1 = 0; cnt1 < listRoom.size(); cnt1++) 
		{
			Object[] arrObjRooms = (Object[]) listRoom.get(cnt1);
			model.put("prefix", arrObjRooms[cnt1]).toString();
		}*/
		model.put("prefix", listRoom);
		model.put("urlHits", urlHits);
		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmRoomStatusDiary", "command", new clsRoomStatusDiaryBean());
		} else {
			return new ModelAndView("frmRoomStatusDiary_1", "command", new clsRoomStatusDiaryBean());
		}
	}

	// get Room Status Data
	@RequestMapping(value = "/getRoomStatusList", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatus(@RequestParam("viewDate") String viewDate, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();		
		List listViewDates = new ArrayList();
		String[] arrViewDate = viewDate.split("-");
		GregorianCalendar cd = new GregorianCalendar();
		cd.set(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		Date dt = new Date(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		// System.out.println(dt.getDay());
		// System.out.println(dt);
		cd.setTime(dt);
		for (int cnt = 0; cnt < 7; cnt++) {
			String day = funGetDayOfWeek(cd.getTime().getDay());
			String transDate = (cd.getTime().getYear() + 1900) + "-" + (cd.getTime().getMonth() + 1) + "-" + cd.getTime().getDate();
//			/*String date = day + " " + cd.getTime().getDate() + "-" + (cd.getTime().getMonth() + 1) + "-" + (cd.getTime().getYear() + 1900);*/
			String date = day + ", " + cd.getTime().getDate() ;
			System.out.println(date);
			listViewDates.add(date);
			cd.add(Calendar.DATE, 1);
		}
		System.out.println(listViewDates);
		return listViewDates;
	}
	
	//For one Day
	@RequestMapping(value = "/getRoomStatusListForOneDay", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatusForOneDay(@RequestParam("viewDate") String viewDate, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();		
		List listViewDates = new ArrayList();
		String[] arrViewDate = viewDate.split("-");
		GregorianCalendar cd = new GregorianCalendar();
		cd.set(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		Date dt = new Date(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		// System.out.println(dt.getDay());
		// System.out.println(dt);
		cd.setTime(dt);
		for (int cnt = 0; cnt < 1; cnt++) {
			String day = funGetDayOfWeek(cd.getTime().getDay());
			String transDate = (cd.getTime().getYear() + 1900) + "-" + (cd.getTime().getMonth() + 1) + "-" + cd.getTime().getDate();
//			/*String date = day + " " + cd.getTime().getDate() + "-" + (cd.getTime().getMonth() + 1) + "-" + (cd.getTime().getYear() + 1900);*/
			String date = day + ", " + cd.getTime().getDate() ;
			System.out.println(date);
			listViewDates.add(date );
			cd.add(Calendar.DATE, 1);
		}
		System.out.println(listViewDates);
		return listViewDates;
	}
	
	//House Keeping View
	@RequestMapping(value = "/getRoomStatusListForHouseKeeping", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatusForHouseKeeping(@RequestParam("viewDate") String viewDate, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();		
		List listViewDates = new ArrayList();
		String[] arrViewDate = viewDate.split("-");
		GregorianCalendar cd = new GregorianCalendar();
		cd.set(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		Date dt = new Date(Integer.parseInt(arrViewDate[2]) - 1900, Integer.parseInt(arrViewDate[1]) - 1, Integer.parseInt(arrViewDate[0]));
		// System.out.println(dt.getDay());
		// System.out.println(dt);
		cd.setTime(dt);
		for (int cnt = 0; cnt < 1; cnt++) {
			String day = funGetDayOfWeek(cd.getTime().getDay());
			String transDate = (cd.getTime().getYear() + 1900) + "-" + (cd.getTime().getMonth() + 1) + "-" + cd.getTime().getDate();
//			/*String date = day + " " + cd.getTime().getDate() + "-" + (cd.getTime().getMonth() + 1) + "-" + (cd.getTime().getYear() + 1900);*/
			String date = day + ", " + cd.getTime().getDate() ;
			System.out.println(date);
			listViewDates.add(date);
			cd.add(Calendar.DATE, 1);
		}
		System.out.println(listViewDates);
		return listViewDates;
	}
	
	
	// get Room Status Data
	@RequestMapping(value = "/getRoomStatusDtlList", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatusDetails(@RequestParam("viewDate") String viewDate,@RequestParam("Selection") String strSelection, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",request.getSession().getAttribute("PMSDate").toString());
		String date1 = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
		String[] arrViewDate = viewDate.split("-");
		viewDate = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
		clsRoomStatusDtlBean objRoomStatusDtl=null;
		clsGuestMasterBean objGuestDtl = null;
		Map<String,List> hmap= new LinkedHashMap<>(); //hmap for group reservation
		List objTemp = null;
		List objGroupReservation = null;
		List listTotal = new ArrayList<>();;
		List listRoomStatusBeanDtl = new ArrayList<>();
		Map objRoomTypeWise = new HashMap<>();
		Map returnObject = new HashMap<>();
		
		
		//For Virtual Room
		String sqlVirtualRoom="";	
		sqlVirtualRoom = "select a.strRoomCode,a.strRoomDesc,b.strRoomTypeDesc,a.strStatus,a.strRoomTypeCode from tblroom a,tblroomtypemaster b where a.strRoomTypeCode=b.strRoomTypeCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'  and b.strIsHouseKeeping='N' "
						+ " group by a.strRoomTypeCode order by b.strRoomTypeCode,a.strRoomDesc; ";			
		List listVirtualRoom = objGlobalFunctionsService.funGetListModuleWise(sqlVirtualRoom, "sql");	
	
		for (int cnt1 = 0; cnt1 < listVirtualRoom.size(); cnt1++) 
		{
			objRoomStatusDtl = new clsRoomStatusDtlBean();
			Object[] arrObjRooms = (Object[]) listVirtualRoom.get(cnt1);
			objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
			objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
			objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
			TreeMap<Integer, List<clsGuestListReportBean>> mapGuestListPerDay=new TreeMap<>();
			List<clsGuestListReportBean> listMainGuestDetailsBean=new ArrayList<>();
			String sql1="";
			objGroupReservation=new ArrayList<>();
			//Virtual Reservation Query
/*			String sqlGroupReservation="SELECT a.strReservationNo,d.strRoomTypeCode,'Virtual Room', (a.intNoOfAdults+a.intNoOfChild), "
					+ " 'VIRTUAL RESERVATION', DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'),  "
					+ "DATEDIFF(DATE(a.dteDepartureDate), DATE(a.dteArrivalDate)),LEFT(TIMEDIFF(a.tmeDepartureTime,(SELECT a.tmeCheckOutTime FROM tblpropertysetup a)),6), "
					+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(SELECT a.tmeCheckInTime FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'),DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"'),a.strNoRoomsBooked,f.strGroupName "
					+ "FROM tblreservationhd a,tblreservationdtl b,tblroom d,tblbookingtype e ,tblgroupbookinghd f "
					+ "WHERE a.strReservationNo=b.strReservationNo  "
					+ "AND a.strBookingTypeCode=e.strBookingTypeCode AND a.strGroupCode=f.strGroupCode AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY)   "
					+ "AND a.strReservationNo NOT IN (SELECT strReservationNo FROM tblcheckinhd) AND a.strCancelReservation='N' AND a.strGroupCode!='' AND b.strRoomType='"+arrObjRooms[4].toString()+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' group by a.strReservationNo ";
						*/
			
			String sqlGroupReservation="SELECT a.strReservationNo,d.strRoomTypeCode,'Virtual Room', (a.intNoOfAdults+a.intNoOfChild), 'VIRTUAL RESERVATION', "					
					+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'),  "
					+ "DATEDIFF(DATE(a.dteDepartureDate), DATE(a.dteArrivalDate)), "
					+ " IFNULL(LEFT(TIMEDIFF(a.tmeDepartureTime,(SELECT a.tmeCheckOutTime FROM tblpropertysetup a)),6),''), "
					+ " IFNULL(LEFT(TIMEDIFF(a.tmeArrivalTime,(SELECT a.tmeCheckInTime FROM tblpropertysetup a)),6),''),a.tmeArrivalTime, "
					+ "a.tmeDepartureTime, DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'), DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"'), "
					+ "count(d.strRoomCode),concat(f.strFirstName,' ',f.strMiddleName,' ',f.strLastName)"
					+ "FROM tblreservationhd a,tblreservationdtl b,tblroom d,tblbookingtype e,tblguestmaster f "
					+ "WHERE a.strReservationNo=b.strReservationNo AND a.strBookingTypeCode=e.strBookingTypeCode  "
					+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY)  "
					+ "AND a.strReservationNo NOT IN (SELECT strReservationNo FROM tblcheckinhd) AND a.strCancelReservation='N'  "
					+ "AND b.strRoomNo=''  "
					+ "AND b.strRoomType='"+arrObjRooms[4].toString()+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
					+ "AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' and f.strGuestCode=b.strGuestCode "
					+ "GROUP BY a.strReservationNo ;";
			
			
			
				//For Group Reservation
				List listsVirtualRoom= objGlobalFunctionsService.funGetListModuleWise(sqlGroupReservation, "sql");
				if (listsVirtualRoom.size() > 0) 
				{
					for(int i=0;i<listsVirtualRoom.size();i++)
					{
						int intArrivalCnt = 0;
						int intDepartureCnt = 0;
						objGuestDtl = new clsGuestMasterBean();
						Object[] arrObjRoomDtl = (Object[]) listsVirtualRoom.get(i);
						objGuestDtl.setStrFirstName(arrObjRoomDtl[3].toString());
						objGuestDtl.setDteArrivalDate(arrObjRoomDtl[5].toString());
						objGuestDtl.setDteDepartureDate(arrObjRoomDtl[6].toString());
						objGuestDtl.setStRoomNo(arrObjRoomDtl[2].toString());
						objGuestDtl.setStrNoOfNights(arrObjRoomDtl[7].toString());
						objGuestDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objGuestDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+arrObjRoomDtl[0].toString()+"' AND a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' AND a.strClientCode='"+clientCode+"'";
						List listFolioNo = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");
						String strFolioNo = "";
						objGroupReservation=new ArrayList<>();
						objTemp=new ArrayList<>();
						objRoomStatusDtl=new clsRoomStatusDtlBean();
						//objRoomStatusDtl.setStrRoomNo(arrObjRoomDtl[3].toString()+" PAX");
						objRoomStatusDtl.setStrRoomNo("");						
						objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
						objRoomStatusDtl.setStrReservationNo(arrObjRoomDtl[0].toString());
						objRoomStatusDtl.setStrGuestName(arrObjRoomDtl[15].toString());
						objRoomStatusDtl.setDteArrivalDate(arrObjRoomDtl[5].toString()+" "+ arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setDteDepartureDate(arrObjRoomDtl[6].toString()+" "+ arrObjRoomDtl[11].toString());
						objRoomStatusDtl.setStrNoOfDays(arrObjRoomDtl[7].toString());
						objRoomStatusDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(arrObjRoomDtl[14].toString()));
						objRoomStatusDtl.setStrSource(arrObjRoomDtl[4].toString());
						objRoomStatusDtl.setStrRoomStatus("VIRTUAL RESERVATION");
						intArrivalCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
						intDepartureCnt=Integer.parseInt(arrObjRoomDtl[13].toString());						
						if (intArrivalCnt<=0 && 0<=intDepartureCnt)   {							
							objRoomStatusDtl.setStrDay1(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=1 && 1<=intDepartureCnt)   {							
							 objRoomStatusDtl.setStrDay2(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=2 && 2<=intDepartureCnt)   {							
							 objRoomStatusDtl.setStrDay3(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=3 && 3<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay4(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=4 && 4<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay5(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=5 && 5<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay6(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=6 && 6<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay7(" "+objRoomStatusDtl.getStrGuestName());
						}
						
						if(arrObjRoomDtl[8].toString().contains("-"))
						{
							if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
						}
						
						if(arrObjRoomDtl[9].toString().contains("-"))
						{
							if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckInAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckInAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
						}						
						//objRoomStatusDtl.setDblRoomCnt(listsVirtualRoom.size());
						if(strSelection.equalsIgnoreCase("VIRTUAL RESERVATION")||strSelection.equalsIgnoreCase(""))
						{
							objGroupReservation.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase(""))
						{
							objGroupReservation.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase("VIRTUAL RESERVATION")||strSelection.equalsIgnoreCase(""))
						{
							if(hmap.containsKey(objRoomStatusDtl.getStrRoomType()))
							{
								List list=new ArrayList<>();
								list=hmap.get(objRoomStatusDtl.getStrRoomType());
								list.add(objRoomStatusDtl);
								hmap.put(objRoomStatusDtl.getStrRoomType(),list);
							}
							else
							{							
									hmap.put(objRoomStatusDtl.getStrRoomType(),objGroupReservation);							
							}			
						}
					}
				}
		}
		
		
		
		//For Group Reservation
		String sql="";	
			sql = "select a.strRoomCode,a.strRoomDesc,b.strRoomTypeDesc,a.strStatus,a.strRoomTypeCode from tblroom a,tblroomtypemaster b where a.strRoomTypeCode=b.strRoomTypeCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
				+ " group by a.strRoomTypeCode order by b.strRoomTypeCode,a.strRoomDesc; ";			
		List listRoomGroupWise = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");		
		for (int cnt1 = 0; cnt1 < listRoomGroupWise.size(); cnt1++) 
		{
			objRoomStatusDtl = new clsRoomStatusDtlBean();
			Object[] arrObjRooms = (Object[]) listRoomGroupWise.get(cnt1);
			objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
			objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
			objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
			TreeMap<Integer, List<clsGuestListReportBean>> mapGuestListPerDay=new TreeMap<>();
			List<clsGuestListReportBean> listMainGuestDetailsBean=new ArrayList<>();
			String sql1="";
			objGroupReservation=new ArrayList<>();
			//Group Reservation Query
			String sqlGroupReservation="SELECT a.strReservationNo,d.strRoomTypeCode,'Virtual Room', (a.intNoOfAdults+a.intNoOfChild), "
					+ " 'GROUP RESERVATION', DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'),  "
					+ "DATEDIFF(DATE(a.dteDepartureDate), DATE(a.dteArrivalDate)),LEFT(TIMEDIFF(a.tmeDepartureTime,(SELECT a.tmeCheckOutTime FROM tblpropertysetup a)),6), "
					+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(SELECT a.tmeCheckInTime FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'),DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"'),a.strNoRoomsBooked,f.strGroupName "
					+ "FROM tblreservationhd a,tblreservationdtl b,tblroom d,tblbookingtype e ,tblgroupbookinghd f "
					+ "WHERE a.strReservationNo=b.strReservationNo  "
					+ "AND a.strBookingTypeCode=e.strBookingTypeCode AND a.strGroupCode=f.strGroupCode AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY)   "
					+ "AND a.strReservationNo NOT IN (SELECT strReservationNo FROM tblcheckinhd) AND a.strCancelReservation='N' AND a.strGroupCode!='' AND b.strRoomType='"+arrObjRooms[4].toString()+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' group by a.strReservationNo ";
						
				//For Group Reservation
				List listsGroupReservation = objGlobalFunctionsService.funGetListModuleWise(sqlGroupReservation, "sql");
				if (listsGroupReservation.size() > 0) 
				{
					for(int i=0;i<listsGroupReservation.size();i++)
					{
						int intArrivalCnt = 0;
						int intDepartureCnt = 0;
						objGuestDtl = new clsGuestMasterBean();
						Object[] arrObjRoomDtl = (Object[]) listsGroupReservation.get(i);
						objGuestDtl.setStrFirstName(arrObjRoomDtl[3].toString());
						objGuestDtl.setDteArrivalDate(arrObjRoomDtl[5].toString());
						objGuestDtl.setDteDepartureDate(arrObjRoomDtl[6].toString());
						objGuestDtl.setStRoomNo(arrObjRoomDtl[2].toString());
						objGuestDtl.setStrNoOfNights(arrObjRoomDtl[7].toString());
						objGuestDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objGuestDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+arrObjRoomDtl[0].toString()+"' AND a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' AND a.strClientCode='"+clientCode+"'";
						List listFolioNo = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");
						String strFolioNo = "";
						objGroupReservation=new ArrayList<>();
						objTemp=new ArrayList<>();
						objRoomStatusDtl=new clsRoomStatusDtlBean();
						//objRoomStatusDtl.setStrRoomNo(arrObjRoomDtl[3].toString()+" PAX");
						objRoomStatusDtl.setStrRoomNo("");	
						objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
						objRoomStatusDtl.setStrReservationNo(arrObjRoomDtl[0].toString());
						objRoomStatusDtl.setStrGuestName(arrObjRoomDtl[15].toString());
						objRoomStatusDtl.setDteArrivalDate(arrObjRoomDtl[5].toString()+" "+ arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setDteDepartureDate(arrObjRoomDtl[6].toString()+" "+ arrObjRoomDtl[11].toString());
						objRoomStatusDtl.setStrNoOfDays(arrObjRoomDtl[7].toString());
						objRoomStatusDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(arrObjRoomDtl[14].toString()));
						objRoomStatusDtl.setStrSource(arrObjRoomDtl[4].toString());
						objRoomStatusDtl.setStrRoomStatus("Room Count "+arrObjRoomDtl[14].toString());
						intArrivalCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
						intDepartureCnt=Integer.parseInt(arrObjRoomDtl[13].toString());						
						if (intArrivalCnt<=0 && 0<=intDepartureCnt)   {							
							objRoomStatusDtl.setStrDay1(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=1 && 1<=intDepartureCnt)   {							
							 objRoomStatusDtl.setStrDay2(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=2 && 2<=intDepartureCnt)   {							
							 objRoomStatusDtl.setStrDay3(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=3 && 3<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay4(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=4 && 4<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay5(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=5 && 5<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay6(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (intArrivalCnt<=6 && 6<=intDepartureCnt) {							
							 objRoomStatusDtl.setStrDay7(" "+objRoomStatusDtl.getStrGuestName());
						}
						
						if(arrObjRoomDtl[8].toString().contains("-"))
						{
							if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
						}
						
						if(arrObjRoomDtl[9].toString().contains("-"))
						{
							if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckInAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckInAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
						}						
						objRoomStatusDtl.setDblRoomCnt(listRoomGroupWise.size());
						if(strSelection.equalsIgnoreCase("GROUP RESERVATION")||strSelection.equalsIgnoreCase(""))
						{
							objGroupReservation.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase(""))
						{
							objGroupReservation.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase("GROUP RESERVATION")||strSelection.equalsIgnoreCase(""))
						{
							if(hmap.containsKey(objRoomStatusDtl.getStrRoomType()))
							{
								List list=new ArrayList<>();
								list=hmap.get(objRoomStatusDtl.getStrRoomType());
								list.add(objRoomStatusDtl);
								hmap.put(objRoomStatusDtl.getStrRoomType(),list);
							}
							else
							{							
								hmap.put(objRoomStatusDtl.getStrRoomType(),objGroupReservation);							
							}						
						}
					}
				}
		}
		sql = "select a.strRoomCode,a.strRoomDesc,b.strRoomTypeDesc,a.strStatus,a.strRoomTypeCode from tblroom a,tblroomtypemaster b where a.strRoomTypeCode=b.strRoomTypeCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
				+ " order by b.strRoomTypeCode,a.strRoomDesc; ";
		List listRoom = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		
		//for room filling
		for (int cnt1 = 0; cnt1 < listRoom.size(); cnt1++) 
		{
			objRoomStatusDtl = new clsRoomStatusDtlBean();
			Object[] arrObjRooms = (Object[]) listRoom.get(cnt1);
			objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
		    objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
			objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
			TreeMap<Integer, List<clsGuestListReportBean>> mapGuestListPerDay=new TreeMap<>();
			List<clsGuestListReportBean> listMainGuestDetailsBean=new ArrayList<>();
			String sql1="";
			if(strSelection.equalsIgnoreCase("Waiting")||strSelection.equalsIgnoreCase("Reservation"))//same for reservation and waiting
			{					
				sql= "SELECT a.strReservationNo,d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName), "
						+ "'RESERVATION', DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ "DATEDIFF(DATE(a.dteDepartureDate),DATE(a.dteArrivalDate)),LEFT(TIMEDIFF(a.tmeDepartureTime,(select a.tmeCheckOutTime from tblpropertysetup a )),6), "
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(select a.tmeCheckInTime from tblpropertysetup a )),6),a.tmeArrivalTime,a.tmeDepartureTime , DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'),DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"')"
						+ "FROM tblreservationhd a,tblreservationdtl b,tblguestmaster c,tblroom d,tblbookingtype e "
						+ "WHERE a.strReservationNo=b.strReservationNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode "
						+ "AND a.strBookingTypeCode=e.strBookingTypeCode AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"',INTERVAL 7 DAY) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ "AND a.strReservationNo NOT IN (SELECT strReservationNo FROM tblcheckinhd) AND a.strCancelReservation='N' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'";				
			}			
			//Occupied
			else if(strSelection.equalsIgnoreCase("Occupied"))
			{				
				sql= "SELECT IF(a.strCheckInNo='','',a.strCheckInNo),d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),d.strStatus, "
					+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
					+ "DATEDIFF('"+PMSDate+"',DATE(a.dteDepartureDate)),LEFT(TIMEDIFF(a.tmeDepartureTime,(select a.tmeCheckOutTime from tblpropertysetup a )),6), "
					+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(select a.tmeCheckInTime from tblpropertysetup a )),6),a.tmeArrivalTime,a.tmeDepartureTime , DATEDIFF(DATE(a.dteArrivalDate),'"+PMSDate+"'), DATEDIFF(DATE(a.dteDepartureDate),'"+PMSDate+"')"
					+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblfoliohd e "
					+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode "
					//+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"',INTERVAL 7 DAY) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' AND a.strCheckInNo=e.strCheckInNo "
					+ "AND '"+viewDate+"' BETWEEN DATE(a.dteArrivalDate) AND DATE(a.dteDepartureDate) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' AND a.strCheckInNo=e.strCheckInNo "
					 
					+ "AND a.strCheckInNo NOT IN (SELECT strCheckInNo FROM tblbillhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' ";
			}				
			//Checked Out
			else if(strSelection.equalsIgnoreCase("Checked Out"))
			{					
				sql= "SELECT e.strBillNo,d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),'Checked Out', DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'),"
						+ " DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), DATEDIFF('"+PMSDate+"', DATE(a.dteDepartureDate)),"
						+ "LEFT(TIMEDIFF(a.tmeDepartureTime,(SELECT a.tmeCheckOutTime "
						+ "FROM tblpropertysetup a)),6),"
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,("
						+ "SELECT a.tmeCheckInTime "
						+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime,"
						+ "DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'), DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"') "
						+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblbillhd e "
						+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY)"
						+ "	AND b.strRoomNo='"+arrObjRooms[0].toString()+"' AND a.dteDepartureDate NOT IN ('"+PMSDate+"') AND a.strCheckInNo=e.strCheckInNo  AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ "AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' group by d.strRoomDesc ;";					
			}			
			else
			{
				sql=" SELECT IF(a.strCheckInNo='','',a.strCheckInNo),d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),d.strStatus, "
						+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ "DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"') as arrDipDiff,LEFT(TIMEDIFF(a.tmeDepartureTime,(select a.tmeCheckOutTime from tblpropertysetup a )),6), "
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(select a.tmeCheckInTime from tblpropertysetup a )),6),a.tmeArrivalTime,a.tmeDepartureTime  "
						+ " ,DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"')"
						+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblfoliohd e "
						+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode "
						+ "AND  '"+viewDate+"'  BETWEEN DATE(a.dteArrivalDate) AND DATE(a.dteDepartureDate) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ " AND a.strCheckInNo=e.strCheckInNo "
						+ "AND a.strCheckInNo NOT IN (SELECT strCheckInNo FROM tblbillhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ " AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' "
						+ " "
						+ " UNION "
						+ " "
						+ "SELECT a.strReservationNo,d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName), "
						+ "'RESERVATION', DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ "DATEDIFF(DATE(a.dteDepartureDate),DATE(a.dteArrivalDate)) as arrDipDiff,LEFT(TIMEDIFF(a.tmeDepartureTime,"
						+ " (select a.tmeCheckOutTime from tblpropertysetup a )),6), "
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,(select a.tmeCheckInTime from tblpropertysetup a )),6),a.tmeArrivalTime,a.tmeDepartureTime  "
						+ " , DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"') "
						+ "FROM tblreservationhd a,tblreservationdtl b,tblguestmaster c,tblroom d,tblbookingtype e "
						+ "WHERE a.strReservationNo=b.strReservationNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode "
						+ "AND a.strBookingTypeCode=e.strBookingTypeCode AND  '"+viewDate+"'  BETWEEN DATE(a.dteArrivalDate) AND DATE(a.dteDepartureDate)"
						+ "  AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ " AND a.strReservationNo NOT IN (SELECT strReservationNo FROM tblcheckinhd) AND a.strCancelReservation='N' "
						+ " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' "
						+ " AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"'"
						+ " "
						+ " UNION "
						+ " "
						+ "SELECT a.strWalkinNo,d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),'Waiting', "
						+ "DATE_FORMAT(DATE(a.dteWalkinDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteCheckOutDate),'%d-%m-%Y'), "
						+ "DATEDIFF(DATE(a.dteCheckOutDate),'"+viewDate+"') as arrDipDiff ,LEFT(TIMEDIFF(a.tmeCheckOutTime,(select a.tmeCheckOutTime "
						+ " from tblpropertysetup a )),6), "
						+ "LEFT(TIMEDIFF(a.tmeWalkInTime,(select a.tmeCheckInTime from tblpropertysetup a )),6),a.tmeWalkInTime,a.tmeCheckOutTime  "
						+ " ,DATEDIFF(DATE(a.dteCheckOutDate),'"+viewDate+"') "
						+ "FROM tblwalkinhd a,tblwalkindtl b,tblguestmaster c,tblroom d "
						+ "WHERE a.strWalkinNo=b.strWalkinNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode "
						+ "AND '"+viewDate+"' BETWEEN  DATE(a.dteWalkinDate) AND DATE(a.dteCheckOutDate)  AND b.strRoomNo='"+arrObjRooms[0].toString()+"'"
						+ "  AND a.strWalkinNo NOT IN (SELECT strWalkinNo FROM tblcheckinhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"'"
						+ " "
						+ "UNION "
						+ "  "
						+ "SELECT e.strBillNo,d.strRoomCode,d.strRoomDesc, CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),'Checked Out', "
						+ " DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ " DATEDIFF( DATE(a.dteDepartureDate),'"+viewDate+"') as arrDipDiff ,"
						+ "LEFT(TIMEDIFF(a.tmeDepartureTime,(SELECT a.tmeCheckOutTime "
						+ "FROM tblpropertysetup a)),6),"
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,("
						+ "SELECT a.tmeCheckInTime "
						+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime"
						+ ", DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"') "
						+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblbillhd e "
						+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode AND b.strRoomNo=d.strRoomCode AND '"+viewDate+"' "
						+ "  BETWEEN DATE(a.dteArrivalDate) AND DATE(a.dteDepartureDate) "
						+ "	AND b.strRoomNo='"+arrObjRooms[0].toString()+"' AND a.dteDepartureDate NOT IN ('"+PMSDate+"') "
						+ " AND a.strCheckInNo=e.strCheckInNo  AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ "AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' group by d.strRoomDesc ;";
			}			
				
				List listRoomDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				objTemp= new ArrayList<>();
				if (listRoomDtl.size() > 0) 
				{
					for(int i=0;i<listRoomDtl.size();i++)
					{						
						int intArrivalCnt = 0;
						int intDepartureCnt = 0;
						objGuestDtl = new clsGuestMasterBean();
						Object[] arrObjRoomDtl = (Object[]) listRoomDtl.get(i);
						objGuestDtl.setStrFirstName(arrObjRoomDtl[3].toString());
						objGuestDtl.setDteArrivalDate(arrObjRoomDtl[5].toString());
						objGuestDtl.setDteDepartureDate(arrObjRoomDtl[6].toString());
						objGuestDtl.setStRoomNo(arrObjRoomDtl[2].toString());
						objGuestDtl.setStrNoOfNights(arrObjRoomDtl[7].toString());
						objGuestDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objGuestDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+arrObjRoomDtl[0].toString()+"' AND a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' AND a.strClientCode='"+clientCode+"'";
						List listFolioNo = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");
						String strFolioNo = "";						
						if(listFolioNo!=null && listFolioNo.size()>0)
						{
							strFolioNo = listFolioNo.get(0).toString();
						}						
						objRoomStatusDtl=new clsRoomStatusDtlBean();
						objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
						objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
						objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
						if(arrObjRoomDtl[4].toString().equalsIgnoreCase("Occupied"))
						{
							objRoomStatusDtl.setStrReservationNo(strFolioNo);
						}
						else
						{
							objRoomStatusDtl.setStrReservationNo(arrObjRoomDtl[0].toString());
						}
						objRoomStatusDtl.setStrGuestName(arrObjRoomDtl[3].toString());
						objRoomStatusDtl.setDteArrivalDate(arrObjRoomDtl[5].toString()+" "+ arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setDteDepartureDate(arrObjRoomDtl[6].toString()+" "+ arrObjRoomDtl[11].toString());
						objRoomStatusDtl.setStrNoOfDays(arrObjRoomDtl[7].toString());
						objRoomStatusDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objRoomStatusDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						if(arrObjRoomDtl[4].toString().equalsIgnoreCase("RESERVATION"))
						{
							String sqlPaymentCheck = "select a.strReceiptNo from tblreceipthd a where "
									+ "a.strReservationNo='"+arrObjRoomDtl[0].toString()+"' and a.strClientCode='"+clientCode+"'";
							
							List listPaymentCheck = objGlobalFunctionsService.funGetListModuleWise(sqlPaymentCheck, "sql");
							if(listPaymentCheck!=null && listPaymentCheck.size()>0)
							{
								objRoomStatusDtl.setStrRoomStatus(arrObjRoomDtl[4].toString());
							}
							else
							{
								objRoomStatusDtl.setStrRoomStatus("Waiting");
							}
						}else
						{
							objRoomStatusDtl.setStrRoomStatus(arrObjRoomDtl[4].toString());
						}						
						if(arrObjRoomDtl[4].toString().equals("Occupied")){
						objRoomStatusDtl.setDblRemainingAmt(funGetDblRemainingAmt(strFolioNo,clientCode,arrObjRoomDtl[0].toString()));
						}
					//	intArrivalCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
						intDepartureCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
						
						if ( 0<=intDepartureCnt) 							
						{							
							 objRoomStatusDtl.setStrDay1(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if (1<=intDepartureCnt) 
						{
							
							 objRoomStatusDtl.setStrDay2(" "+objRoomStatusDtl.getStrGuestName());
						} 
						if ( 2<=intDepartureCnt) 
						{							
							 objRoomStatusDtl.setStrDay3(" "+objRoomStatusDtl.getStrGuestName());
						} if ( 3<=intDepartureCnt) {
							
							 objRoomStatusDtl.setStrDay4(" "+objRoomStatusDtl.getStrGuestName());
						} if ( 4<=intDepartureCnt) {
							
							 objRoomStatusDtl.setStrDay5(" "+objRoomStatusDtl.getStrGuestName());
						} if ( 5<=intDepartureCnt) {
							
							 objRoomStatusDtl.setStrDay6(" "+objRoomStatusDtl.getStrGuestName());
						} if ( 6<=intDepartureCnt) {
							
							 objRoomStatusDtl.setStrDay7(" "+objRoomStatusDtl.getStrGuestName());
						}
						
						if(arrObjRoomDtl[8].toString().contains("-"))
						{
							if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckOutAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
						}
						
						if(arrObjRoomDtl[9].toString().contains("-"))
						{
							if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
							{
								objRoomStatusDtl.setTmeCheckInAMPM("PM");
							}
							else
							{
								objRoomStatusDtl.setTmeCheckInAMPM("AM");
							}
						}
						else
						{
							if(arrObjRoomDtl[8].toString().equals("00:00:"))
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
						}
						
						String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
						List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
						if(listRoomCnt!=null && listRoomCnt.size()>0)
						{
							objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
						}
						if(strSelection.equalsIgnoreCase("Waiting")||strSelection.equalsIgnoreCase("Reservation")||strSelection.equalsIgnoreCase("Occupied")||strSelection.equalsIgnoreCase("Checked Out"))
						{
							objTemp.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase(""))
						{
							objTemp.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase("Waiting")||strSelection.equalsIgnoreCase("Reservation")||strSelection.equalsIgnoreCase("Occupied")||strSelection.equalsIgnoreCase("Checked Out")||strSelection.equalsIgnoreCase(""))
						{
							if(hmap.containsKey(objRoomStatusDtl.getStrRoomType()))
							{
								List list=new ArrayList<>();
								list=hmap.get(objRoomStatusDtl.getStrRoomType());
								list.add(objRoomStatusDtl);
								hmap.put(objRoomStatusDtl.getStrRoomType(),list);
							}
							else
							{
								if(strSelection.equalsIgnoreCase("Waiting")||strSelection.equalsIgnoreCase("Reservation")||strSelection.equalsIgnoreCase("Occupied")||strSelection.equalsIgnoreCase("Checked Out")||strSelection.equalsIgnoreCase(""))
								{
									hmap.put(objRoomStatusDtl.getStrRoomType(),objTemp);
								}
							}
						}
					}
				}
				else
				{		// dirty rooms add here					
						objRoomStatusDtl=new clsRoomStatusDtlBean();
						objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
						objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
						objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());						
						String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
						List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
						if(listRoomCnt!=null && listRoomCnt.size()>0)
						{
							objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
						}
						if((strSelection.equalsIgnoreCase("Blocked")||strSelection.equalsIgnoreCase("Dirty"))&&(objRoomStatusDtl.getStrRoomStatus().equalsIgnoreCase("Blocked")||objRoomStatusDtl.getStrRoomStatus().equalsIgnoreCase("Dirty")))
						{
							objTemp.add(objRoomStatusDtl);
						}
						if(strSelection.equalsIgnoreCase(""))
						{
							objTemp.add(objRoomStatusDtl);
						}
						if(!strSelection.equalsIgnoreCase("GROUP RESERVATION"))
						{
							if(hmap.containsKey(objRoomStatusDtl.getStrRoomType()))
							{
								List list=new ArrayList<>();
								list=hmap.get(objRoomStatusDtl.getStrRoomType());
								list.add(objRoomStatusDtl);
								hmap.put(objRoomStatusDtl.getStrRoomType(),list);
							}
							else
							{
								hmap.put(objRoomStatusDtl.getStrRoomType(),objTemp);
							}
						}
				}
				
				if(objRoomStatusDtl.getStrRoomStatus().equalsIgnoreCase("Blocked"))
				{
					String sqlBlock = "SELECT DATEDIFF('"+PMSDate+"',b.dteValidTo) FROM tblroom a,tblblockroom b "
							+ "WHERE a.strRoomCode=b.strRoomCode AND a.strRoomDesc='"+objRoomStatusDtl.getStrRoomNo()+"' AND a.strClientCode='"+clientCode+"' ";
					List listBlockRoom = objGlobalFunctionsService.funGetListModuleWise(sqlBlock, "sql");
					if (listBlockRoom.size() > 0) 
					{
						BigInteger diff = (BigInteger) listBlockRoom.get(0);
						String strBlockRoomDiff=diff.toString();
						if(strBlockRoomDiff.startsWith("-"))
						{
							if(Integer.parseInt(strBlockRoomDiff.substring(1))==0)
							{
								objRoomStatusDtl.setStrDay1("Blocked Room");
							}
							else if(Integer.parseInt(strBlockRoomDiff.substring(1))>0)
							{
								for(int i=0;i<=Integer.parseInt(strBlockRoomDiff.substring(1));i++)
								{
									if(i==0)
									{
										i=i+1;
									}
									objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
								}
							}
						}
						else
						{
							if(Integer.parseInt(strBlockRoomDiff)==0)
							{
								objRoomStatusDtl.setStrDay1("Blocked Room");
							}
							else if(Integer.parseInt(strBlockRoomDiff)>0)
							{
								for(int i=0;i<=Integer.parseInt(strBlockRoomDiff);i++)
								{
									if(i==0)
									{
										i=i+1;
									}
									objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
								}
							}
						}
					}
				}
		}
		
		listRoomStatusBeanDtl.add(objRoomTypeWise);	
		for (Map.Entry<String,List> entry : hmap.entrySet())  
		{
            List list = new ArrayList<>();
				list=entry.getValue();
				for(int i=0;i<list.size();i++)
				{
					listTotal.add(list.get(i));
				}
		} 
		return listTotal;		
	}
	
	//Dairy for one day view	
	@RequestMapping(value = "/getRoomStatusDtlListForOneDay", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatusDetailsForOneDay(@RequestParam("viewDate") String viewDate,HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",request.getSession().getAttribute("PMSDate").toString());
		String date1 = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
		String[] arrViewDate = viewDate.split("-");
		viewDate = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
		clsRoomStatusDtlBean objRoomStatusDtl=null;
		clsGuestMasterBean objGuestDtl = null;
		List objTemp = null;
		List listRoomStatusBeanDtl = new ArrayList<>();
		Map objRoomTypeWise = new HashMap<>();
		Map returnObject = new HashMap<>();
		String sql = "select a.strRoomCode,a.strRoomDesc,b.strRoomTypeDesc,a.strStatus from tblroom a,tblroomtypemaster b where a.strRoomTypeCode=b.strRoomTypeCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' and b.strIsHouseKeeping='N' "
					+ " order by b.strRoomTypeCode,a.strRoomDesc; ";
		
		List listRoom = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		objTemp=new ArrayList<>();
		for (int cnt1 = 0; cnt1 < listRoom.size(); cnt1++) 
		{
			objRoomStatusDtl = new clsRoomStatusDtlBean();
			Object[] arrObjRooms = (Object[]) listRoom.get(cnt1);
			objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
			objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
			objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
			TreeMap<Integer, List<clsGuestListReportBean>> mapGuestListPerDay=new TreeMap<>();
			List<clsGuestListReportBean> listMainGuestDetailsBean=new ArrayList<>();
			
			sql= " SELECT IF(a.strCheckInNo='','',a.strCheckInNo),d.strRoomCode,d.strRoomDesc, "
					+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),d.strStatus, "
					+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), "
					+ "DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
					+ "DATEDIFF('"+PMSDate+"', DATE(a.dteDepartureDate)),"
					+ "LEFT(TIMEDIFF(a.tmeDepartureTime,( "
					+ "SELECT a.tmeCheckOutTime "
					+ "FROM tblpropertysetup a)),6),"
					+ "LEFT(TIMEDIFF(a.tmeArrivalTime,( "
					+ "SELECT a.tmeCheckInTime "
					+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, "
					+ "DATEDIFF(DATE(a.dteArrivalDate),'"+PMSDate+"'),"
					+ "DATEDIFF(DATE(a.dteDepartureDate),'"+PMSDate+"'),'Website',"
					+ "(a.intNoOfAdults+intNoOfChild),d.strRoomTypeCode,a.strRemarks "
					+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblfoliohd e "
					+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode "
					+ "AND b.strRoomNo=d.strRoomCode "
					+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) "
					+ "AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
					+ "AND a.strCheckInNo=e.strCheckInNo AND a.strCheckInNo NOT IN ( "
					+ "SELECT strCheckInNo "
					+ "FROM tblbillhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
					+ "AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' "
					+ "AND e.strClientCode='"+clientCode+"'  "
					+ "UNION"
					+ " SELECT a.strReservationNo,d.strRoomCode,d.strRoomDesc, "
					+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName), 'RESERVATION', "
					+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
					+ "DATEDIFF(DATE(a.dteDepartureDate), "
					+ "DATE(a.dteArrivalDate)), "
					+ "LEFT(TIMEDIFF(a.tmeDepartureTime,( "
					+ "SELECT a.tmeCheckOutTime "
					+ "FROM tblpropertysetup a)),6), "
					+ "LEFT(TIMEDIFF(a.tmeArrivalTime,( "
					+ "SELECT a.tmeCheckInTime "
					+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, "
					+ "DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'), "
					+ "DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"'),a.strBusinessSourceCode,"
					+ "(a.intNoOfAdults+a.intNoOfChild),d.strRoomTypeCode,b.strRemark "
					+ "FROM tblreservationhd a,tblreservationdtl b,tblguestmaster c,tblroom d,tblbookingtype e "
					+ "WHERE a.strReservationNo=b.strReservationNo AND b.strGuestCode=c.strGuestCode "
					+ "AND b.strRoomNo=d.strRoomCode "
					+ "AND a.strBookingTypeCode=e.strBookingTypeCode "
					+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' "
					+ "AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
					+ "AND a.strReservationNo NOT IN ( "
					+ "SELECT strReservationNo "
					+ "FROM tblcheckinhd) AND a.strCancelReservation='N' AND a.strClientCode='"+clientCode+"' "
					+ "AND b.strClientCode='"+clientCode+"' "
					+ " AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' "
					+ " UNION "
					+ " SELECT a.strWalkinNo,d.strRoomCode,d.strRoomDesc, "
					+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),'Waiting', "
					+ "DATE_FORMAT(DATE(a.dteWalkinDate),'%d-%m-%Y'), "
					+ "DATE_FORMAT(DATE(a.dteCheckOutDate),'%d-%m-%Y'), DATEDIFF('"+PMSDate+"', DATE(a.dteCheckOutDate)), "
					+ "LEFT(TIMEDIFF(a.tmeCheckOutTime,( "
					+ "SELECT a.tmeCheckOutTime "
					+ "FROM tblpropertysetup a)),6), "
					+ "LEFT(TIMEDIFF(a.tmeWalkInTime,( "
					+ "SELECT a.tmeCheckInTime "
					+ "FROM tblpropertysetup a)),6),a.tmeWalkInTime,a.tmeCheckOutTime, "
					+ "DATEDIFF(DATE(a.dteWalkinDate),'"+viewDate+"'), "
					+ "DATEDIFF(DATE(a.dteCheckOutDate),'"+viewDate+"'),'Meeting',"
					+ "(a.intNoOfAdults+a.intNoOfChild),d.strRoomTypeCode,a.strRemarks "
					+ "FROM tblwalkinhd a,tblwalkindtl b,tblguestmaster c,tblroom d "
					+ "WHERE a.strWalkinNo=b.strWalkinNo AND b.strGuestCode=c.strGuestCode "
					+ "AND b.strRoomNo=d.strRoomCode "
					+ "AND DATE(a.dteCheckOutDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) "
					+ "AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
					+ "AND a.strWalkinNo NOT IN ( "
					+ "SELECT strWalkinNo "
					+ "FROM tblcheckinhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
					+ "AND c.strClientCode='"+clientCode+"' "
					+ "AND d.strClientCode='"+clientCode+"'  group by d.strRoomDesc ;";
			
			List listRoomDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if (listRoomDtl.size() > 0) 
				{
					for(int i=0;i<listRoomDtl.size();i++)
					{						
						int intArrivalCnt = 0;
						int intDepartureCnt = 0;
						objGuestDtl = new clsGuestMasterBean();
						Object[] arrObjRoomDtl = (Object[]) listRoomDtl.get(i);
						objGuestDtl.setStrFirstName(arrObjRoomDtl[3].toString());
						objGuestDtl.setDteArrivalDate(arrObjRoomDtl[5].toString());
						objGuestDtl.setDteDepartureDate(arrObjRoomDtl[6].toString());
						objGuestDtl.setStRoomNo(arrObjRoomDtl[2].toString());
						objGuestDtl.setStrNoOfNights(arrObjRoomDtl[7].toString());
						objGuestDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
						objGuestDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
						
							String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+arrObjRoomDtl[0].toString()+"' AND a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' AND a.strClientCode='"+clientCode+"'";
							List listFolioNo = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");
							String strFolioNo = "";
							if(listFolioNo!=null && listFolioNo.size()>0)
							{
								strFolioNo = listFolioNo.get(0).toString();
							}
							
							objRoomStatusDtl=new clsRoomStatusDtlBean();
							objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
							objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
							objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
							if(arrObjRoomDtl[4].toString().equalsIgnoreCase("Occupied"))
							{
								objRoomStatusDtl.setStrReservationNo(strFolioNo);
							}
							else
							{
								objRoomStatusDtl.setStrReservationNo(arrObjRoomDtl[0].toString());
							}
							objRoomStatusDtl.setStrGuestName(arrObjRoomDtl[3].toString());
							objRoomStatusDtl.setDteArrivalDate(arrObjRoomDtl[5].toString()+" "+ arrObjRoomDtl[10].toString());
							objRoomStatusDtl.setDteDepartureDate(arrObjRoomDtl[6].toString()+" "+ arrObjRoomDtl[11].toString());
							objRoomStatusDtl.setStrNoOfDays(arrObjRoomDtl[7].toString());
							objRoomStatusDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
							objRoomStatusDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
							objRoomStatusDtl.setDblPax(Double.parseDouble(arrObjRoomDtl[15].toString()));
							objRoomStatusDtl.setStrSpclInstruction(arrObjRoomDtl[17].toString());
							String strRoomCode = arrObjRoomDtl[16].toString();
							
							String sqlRoomRate = "select a.dblRoomTerrif from tblroomtypemaster a "
									+ "where a.strRoomTypeCode='"+strRoomCode+"' and a.strClientCode='"+clientCode+"'";
							List listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
							
							if(listRoomRate!=null && listRoomRate.size()>0)
							{
								objRoomStatusDtl.setDblRoomRate(Double.parseDouble(listRoomRate.get(0).toString()));
							}
							else
							{
								objRoomStatusDtl.setDblRoomRate(0);
							}
							if(arrObjRoomDtl[4].toString().equalsIgnoreCase("RESERVATION"))
							{
								String strSourceCode = arrObjRoomDtl[14].toString();
								
								String sqlSource = "select a.strDescription from tblbusinesssource a "
										+ "where a.strBusinessSourceCode='"+strSourceCode+"' and a.strClientCode='"+clientCode+"'";
								List listSource = objGlobalFunctionsService.funGetListModuleWise(sqlSource, "sql");
								if(listSource.size()>0 && listSource!=null)
								{
									objRoomStatusDtl.setStrSource(listSource.get(0).toString());
								}
								else
								{
									objRoomStatusDtl.setStrSource("");
								}
								
								
								String sqlPaymentCheck = "select a.strReceiptNo from tblreceipthd a where "
										+ "a.strReservationNo='"+arrObjRoomDtl[0].toString()+"' and a.strClientCode='"+clientCode+"'";
								
								List listPaymentCheck = objGlobalFunctionsService.funGetListModuleWise(sqlPaymentCheck, "sql");
								if(listPaymentCheck!=null && listPaymentCheck.size()>0)
								{
									objRoomStatusDtl.setStrRoomStatus(arrObjRoomDtl[4].toString());
								}
								else
								{
									objRoomStatusDtl.setStrRoomStatus("Waiting");
								}
							}else
							{
								objRoomStatusDtl.setStrSource(arrObjRoomDtl[14].toString());
								objRoomStatusDtl.setStrRoomStatus(arrObjRoomDtl[4].toString());
							}
							
							if(arrObjRoomDtl[4].toString().equals("Occupied")){
							objRoomStatusDtl.setDblRemainingAmt(funGetDblRemainingAmt(strFolioNo,clientCode,arrObjRoomDtl[0].toString()));
							}
							intArrivalCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
							intDepartureCnt=Integer.parseInt(arrObjRoomDtl[13].toString());
							
							if (intArrivalCnt<=0 && 0<=intDepartureCnt) 
								
							{
								
								 objRoomStatusDtl.setStrDay1(" "+objRoomStatusDtl.getStrGuestName());
							} 
							if (intArrivalCnt<=1 && 1<=intDepartureCnt) 
							{
								
								 objRoomStatusDtl.setStrDay2(" "+objRoomStatusDtl.getStrGuestName());
							} 
							if (intArrivalCnt<=2 && 2<=intDepartureCnt) 
							{
								
								 objRoomStatusDtl.setStrDay3(" "+objRoomStatusDtl.getStrGuestName());
							} if (intArrivalCnt<=3 && 3<=intDepartureCnt) {
								
								 objRoomStatusDtl.setStrDay4(" "+objRoomStatusDtl.getStrGuestName());
							} if (intArrivalCnt<=4 && 4<=intDepartureCnt) {
								
								 objRoomStatusDtl.setStrDay5(" "+objRoomStatusDtl.getStrGuestName());
							} if (intArrivalCnt<=5 && 5<=intDepartureCnt) {
								
								 objRoomStatusDtl.setStrDay6(" "+objRoomStatusDtl.getStrGuestName());
							} if (intArrivalCnt<=6 && 6<=intDepartureCnt) {
								
								 objRoomStatusDtl.setStrDay7(" "+objRoomStatusDtl.getStrGuestName());
							}
							
							if(arrObjRoomDtl[8].toString().contains("-"))
							{
								if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckOutAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[8].toString().equals("00:00:"))
								{
									if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
									{
										objRoomStatusDtl.setTmeCheckOutAMPM("PM");
									}
									else
									{
										objRoomStatusDtl.setTmeCheckOutAMPM("AM");
									}
								}
								else
								{
									if(arrObjRoomDtl[11].toString().contains("PM") || arrObjRoomDtl[11].toString().contains("pm"))
									{
										objRoomStatusDtl.setTmeCheckOutAMPM("PM");
									}
									else
									{
										objRoomStatusDtl.setTmeCheckOutAMPM("AM");
									}
								}
							}
							
							if(arrObjRoomDtl[9].toString().contains("-"))
							{
								if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
								{
									objRoomStatusDtl.setTmeCheckInAMPM("PM");
								}
								else
								{
									objRoomStatusDtl.setTmeCheckInAMPM("AM");
								}
							}
							else
							{
								if(arrObjRoomDtl[8].toString().equals("00:00:"))
								{
									if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
									{
										objRoomStatusDtl.setTmeCheckInAMPM("PM");
									}
									else
									{
										objRoomStatusDtl.setTmeCheckInAMPM("AM");
									}
								}
								else
								{
									if(arrObjRoomDtl[10].toString().contains("PM") || arrObjRoomDtl[10].toString().contains("pm"))
									{
										objRoomStatusDtl.setTmeCheckInAMPM("PM");
									}
									else
									{
										objRoomStatusDtl.setTmeCheckInAMPM("AM");
									}
								}
							}
							
							String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
							List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
							if(listRoomCnt!=null && listRoomCnt.size()>0)
							{
								objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
							}
							
							objTemp.add(objRoomStatusDtl);
					}
				}
				else
				{
						objRoomStatusDtl=new clsRoomStatusDtlBean();
						objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
						objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
						objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());						
						String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
						List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
						if(listRoomCnt!=null && listRoomCnt.size()>0)
						{
							objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
						}						
						objTemp.add(objRoomStatusDtl);						
				}
				
				if(objRoomStatusDtl.getStrRoomStatus().equalsIgnoreCase("Blocked"))
				{
					String sqlBlock = "SELECT DATEDIFF('"+PMSDate+"',b.dteValidTo) FROM tblroom a,tblblockroom b "
							+ "WHERE a.strRoomCode=b.strRoomCode AND a.strRoomDesc='"+objRoomStatusDtl.getStrRoomNo()+"' AND a.strClientCode='"+clientCode+"' ";
					List listBlockRoom = objGlobalFunctionsService.funGetListModuleWise(sqlBlock, "sql");
					if (listBlockRoom.size() > 0) 
					{
						BigInteger diff = (BigInteger) listBlockRoom.get(0);
						String strBlockRoomDiff=diff.toString();
						if(strBlockRoomDiff.startsWith("-"))
						{
							if(Integer.parseInt(strBlockRoomDiff.substring(1))==0)
							{
								objRoomStatusDtl.setStrDay1("Blocked Room");
							}
							else if(Integer.parseInt(strBlockRoomDiff.substring(1))>0)
							{
								for(int i=0;i<=Integer.parseInt(strBlockRoomDiff.substring(1));i++)
								{
									if(i==0)
									{
										i=i+1;
									}
									objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
								}
							}
						}
						else
						{
							if(Integer.parseInt(strBlockRoomDiff)==0)
							{
								objRoomStatusDtl.setStrDay1("Blocked Room");
							}
							else if(Integer.parseInt(strBlockRoomDiff)>0)
							{
								for(int i=0;i<=Integer.parseInt(strBlockRoomDiff);i++)
								{
									if(i==0)
									{
										i=i+1;
									}
									objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
								}
							}
						}
					}
				}
		}
		listRoomStatusBeanDtl.add(objRoomTypeWise);		
		return objTemp;
	}
	
	//Dairy for House Keeping view	
	@RequestMapping(value = "/getRoomStatusDtlListForHouseKeeping", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomStatusDetailsForHouseKeeping(@RequestParam("viewDate") String viewDate,HttpServletRequest request) {
			String clientCode = request.getSession().getAttribute("clientCode").toString();
			String userCode = request.getSession().getAttribute("usercode").toString();
			String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",request.getSession().getAttribute("PMSDate").toString());
			String date1 = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
			String[] arrViewDate = viewDate.split("-");
			viewDate = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
			clsRoomStatusDtlBean objRoomStatusDtl=null;
			clsGuestMasterBean objGuestDtl = null;
			List objTemp = null;
			List listRoomStatusBeanDtl = new ArrayList<>();
			Map objRoomTypeWise = new HashMap<>();
			Map returnObject = new HashMap<>();
			String sql = "select a.strRoomCode,a.strRoomDesc,b.strRoomTypeDesc,a.strStatus from tblroom a,tblroomtypemaster b where a.strRoomTypeCode=b.strRoomTypeCode AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
					+ " order by b.strRoomTypeCode,a.strRoomDesc; ";				
			
			List listRoom = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			objTemp=new ArrayList<>();
			for (int cnt1 = 0; cnt1 < listRoom.size(); cnt1++) 
			{
				objRoomStatusDtl = new clsRoomStatusDtlBean();
				Object[] arrObjRooms = (Object[]) listRoom.get(cnt1);
				objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
				objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
				objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
				TreeMap<Integer, List<clsGuestListReportBean>> mapGuestListPerDay=new TreeMap<>();
				List<clsGuestListReportBean> listMainGuestDetailsBean=new ArrayList<>();
				
				sql= " SELECT IF(a.strCheckInNo='','',a.strCheckInNo),d.strRoomCode,d.strRoomDesc, "
						+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),d.strStatus, "
						+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), "
						+ "DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ "DATEDIFF('"+PMSDate+"', DATE(a.dteDepartureDate)),"
						+ "LEFT(TIMEDIFF(a.tmeDepartureTime,( "
						+ "SELECT a.tmeCheckOutTime "
						+ "FROM tblpropertysetup a)),6),"
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,( "
						+ "SELECT a.tmeCheckInTime "
						+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, "
						+ "DATEDIFF(DATE(a.dteArrivalDate),'"+PMSDate+"'),"
						+ "DATEDIFF(DATE(a.dteDepartureDate),'"+PMSDate+"'),'Website',"
						+ "(a.intNoOfAdults+intNoOfChild),d.strRoomTypeCode,a.strRemarks "
						+ "FROM tblcheckinhd a,tblcheckindtl b,tblguestmaster c,tblroom d,tblfoliohd e "
						+ "WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode "
						+ "AND b.strRoomNo=d.strRoomCode "
						+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) "
						+ "AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ "AND a.strCheckInNo=e.strCheckInNo AND a.strCheckInNo NOT IN ( "
						+ "SELECT strCheckInNo "
						+ "FROM tblbillhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ "AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' "
						+ "AND e.strClientCode='"+clientCode+"'  "
						+ "UNION"
						+ " SELECT a.strReservationNo,d.strRoomCode,d.strRoomDesc, "
						+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName), 'RESERVATION', "
						+ "DATE_FORMAT(DATE(a.dteArrivalDate),'%d-%m-%Y'), DATE_FORMAT(DATE(a.dteDepartureDate),'%d-%m-%Y'), "
						+ "DATEDIFF(DATE(a.dteDepartureDate), "
						+ "DATE(a.dteArrivalDate)), "
						+ "LEFT(TIMEDIFF(a.tmeDepartureTime,( "
						+ "SELECT a.tmeCheckOutTime "
						+ "FROM tblpropertysetup a)),6), "
						+ "LEFT(TIMEDIFF(a.tmeArrivalTime,( "
						+ "SELECT a.tmeCheckInTime "
						+ "FROM tblpropertysetup a)),6),a.tmeArrivalTime,a.tmeDepartureTime, "
						+ "DATEDIFF(DATE(a.dteArrivalDate),'"+viewDate+"'), "
						+ "DATEDIFF(DATE(a.dteDepartureDate),'"+viewDate+"'),a.strBusinessSourceCode,"
						+ "(a.intNoOfAdults+a.intNoOfChild),d.strRoomTypeCode,b.strRemark "
						+ "FROM tblreservationhd a,tblreservationdtl b,tblguestmaster c,tblroom d,tblbookingtype e "
						+ "WHERE a.strReservationNo=b.strReservationNo AND b.strGuestCode=c.strGuestCode "
						+ "AND b.strRoomNo=d.strRoomCode "
						+ "AND a.strBookingTypeCode=e.strBookingTypeCode "
						+ "AND DATE(a.dteDepartureDate) BETWEEN '"+viewDate+"' "
						+ "AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ "AND a.strReservationNo NOT IN ( "
						+ "SELECT strReservationNo "
						+ "FROM tblcheckinhd) AND a.strCancelReservation='N' AND a.strClientCode='"+clientCode+"' "
						+ "AND b.strClientCode='"+clientCode+"' "
						+ " AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' "
						+ " UNION "
						+ " SELECT a.strWalkinNo,d.strRoomCode,d.strRoomDesc, "
						+ "CONCAT(c.strFirstName,' ',c.strMiddleName,' ',c.strLastName),'Waiting', "
						+ "DATE_FORMAT(DATE(a.dteWalkinDate),'%d-%m-%Y'), "
						+ "DATE_FORMAT(DATE(a.dteCheckOutDate),'%d-%m-%Y'), DATEDIFF('"+PMSDate+"', DATE(a.dteCheckOutDate)), "
						+ "LEFT(TIMEDIFF(a.tmeCheckOutTime,( "
						+ "SELECT a.tmeCheckOutTime "
						+ "FROM tblpropertysetup a)),6), "
						+ "LEFT(TIMEDIFF(a.tmeWalkInTime,( "
						+ "SELECT a.tmeCheckInTime "
						+ "FROM tblpropertysetup a)),6),a.tmeWalkInTime,a.tmeCheckOutTime, "
						+ "DATEDIFF(DATE(a.dteWalkinDate),'"+viewDate+"'), "
						+ "DATEDIFF(DATE(a.dteCheckOutDate),'"+viewDate+"'),'Meeting',"
						+ "(a.intNoOfAdults+a.intNoOfChild),d.strRoomTypeCode,a.strRemarks "
						+ "FROM tblwalkinhd a,tblwalkindtl b,tblguestmaster c,tblroom d "
						+ "WHERE a.strWalkinNo=b.strWalkinNo AND b.strGuestCode=c.strGuestCode "
						+ "AND b.strRoomNo=d.strRoomCode "
						+ "AND DATE(a.dteCheckOutDate) BETWEEN '"+viewDate+"' AND DATE_ADD('"+viewDate+"', INTERVAL 7 DAY) "
						+ "AND b.strRoomNo='"+arrObjRooms[0].toString()+"' "
						+ "AND a.strWalkinNo NOT IN ( "
						+ "SELECT strWalkinNo "
						+ "FROM tblcheckinhd) AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
						+ "AND c.strClientCode='"+clientCode+"' "
						+ "AND d.strClientCode='"+clientCode+"'  group by d.strRoomDesc ;";
				
				List listRoomDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					if (listRoomDtl.size() > 0) 
					{
						for(int i=0;i<listRoomDtl.size();i++)
						{							
							int intArrivalCnt = 0;
							int intDepartureCnt = 0;
							objGuestDtl = new clsGuestMasterBean();
							Object[] arrObjRoomDtl = (Object[]) listRoomDtl.get(i);
							objGuestDtl.setStrFirstName(arrObjRoomDtl[3].toString());
							objGuestDtl.setDteArrivalDate(arrObjRoomDtl[5].toString());
							objGuestDtl.setDteDepartureDate(arrObjRoomDtl[6].toString());
							objGuestDtl.setStRoomNo(arrObjRoomDtl[2].toString());
							objGuestDtl.setStrNoOfNights(arrObjRoomDtl[7].toString());
							objGuestDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
							objGuestDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());							
							String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+arrObjRoomDtl[0].toString()+"' AND a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' AND a.strClientCode='"+clientCode+"'";
							List listFolioNo = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");
							String strFolioNo = "";
							if(listFolioNo!=null && listFolioNo.size()>0)
							{
								strFolioNo = listFolioNo.get(0).toString();
							}
							
							objRoomStatusDtl=new clsRoomStatusDtlBean();
							objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
							objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
							objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
							if(arrObjRoomDtl[4].toString().equalsIgnoreCase("Occupied"))
							{
								objRoomStatusDtl.setStrReservationNo(strFolioNo);
							}
							else
							{
								objRoomStatusDtl.setStrReservationNo(arrObjRoomDtl[0].toString());
							}
							objRoomStatusDtl.setStrGuestName(arrObjRoomDtl[3].toString());
							objRoomStatusDtl.setDteArrivalDate(arrObjRoomDtl[5].toString()+" "+ arrObjRoomDtl[10].toString());
							objRoomStatusDtl.setDteDepartureDate(arrObjRoomDtl[6].toString()+" "+ arrObjRoomDtl[11].toString());
							objRoomStatusDtl.setStrNoOfDays(arrObjRoomDtl[7].toString());
							objRoomStatusDtl.setTmeArrivalTime(arrObjRoomDtl[10].toString());
							objRoomStatusDtl.setTmeDepartureTime(arrObjRoomDtl[11].toString());
							objRoomStatusDtl.setDblPax(Double.parseDouble(arrObjRoomDtl[15].toString()));
							objRoomStatusDtl.setStrSpclInstruction(arrObjRoomDtl[17].toString());
							String strRoomCode = arrObjRoomDtl[16].toString();
							String sqlAvailability="";
							List listAvailability=null;
							String strAvailability=arrObjRoomDtl[4].toString();
							if(arrObjRoomDtl[4].toString().equalsIgnoreCase("Clean")||arrObjRoomDtl[4].toString().equalsIgnoreCase("Dirty"))
							{
								sqlAvailability ="select b.strStatus from tblfoliohd a,tblroom b where a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' and a.strRoomNo=b.strRoomCode and a.strClientCode=b.strClientCode;";
								listAvailability = objGlobalFunctionsService.funGetListModuleWise(sqlAvailability, "sql");	
								strAvailability="Occupied";
								if(listAvailability.get(0).toString().equalsIgnoreCase(""))
								{
									strAvailability="Free";
								}
							}
							
							intArrivalCnt=Integer.parseInt(arrObjRoomDtl[12].toString());
							intDepartureCnt=Integer.parseInt(arrObjRoomDtl[13].toString());	
							
							 objRoomStatusDtl.setStrDay1(" "+arrObjRoomDtl[4].toString());								 								
							 objRoomStatusDtl.setStrDay2(" "+strAvailability);							
							 objRoomStatusDtl.setStrDay3(" "+arrObjRoomDtl[15].toString());							
							 objRoomStatusDtl.setStrDay5(" "+arrObjRoomDtl[17].toString());
							 objRoomStatusDtl.setStrDay6(" ");
							 objRoomStatusDtl.setStrDay7(" ");
							
							String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
							List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
							if(listRoomCnt!=null && listRoomCnt.size()>0)
							{
								objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
							}		
							if(arrObjRooms[0].toString()!="")
							{
								String sqlStaffName = "select ifnull(b.strStaffName,'') from tblstaffmasterdtl a,tblpmsstaffmaster b where a.strRoomCode='"+arrObjRooms[0].toString()+"' and a.strStffCode=b.strStaffCode and a.strClientCode=b.strClientCode and a.strClientCode='"+clientCode+"'";
								List listStaffName = objGlobalFunctionsService.funGetListModuleWise(sqlStaffName, "sql");
								objRoomStatusDtl.setStrDay4("");
								if(!listStaffName.isEmpty())
								{
									objRoomStatusDtl.setStrDay4(listStaffName.get(0).toString());
								}									
							}
							objTemp.add(objRoomStatusDtl);							
						}
					}
					else
					{
							objRoomStatusDtl=new clsRoomStatusDtlBean();
							objRoomStatusDtl.setStrRoomNo(arrObjRooms[1].toString());
							objRoomStatusDtl.setStrRoomType(arrObjRooms[2].toString());
							objRoomStatusDtl.setStrRoomStatus(arrObjRooms[3].toString());
							if(!listRoomDtl.isEmpty())
							{
							Object[] arrObjRoomDtl = (Object[]) listRoomDtl.get(0);
							
							String sqlAvailability="";
							List listAvailability=null;
							String strAvailability=arrObjRoomDtl[4].toString();
							if(arrObjRoomDtl[4].toString().equalsIgnoreCase("Clean")||arrObjRoomDtl[4].toString().equalsIgnoreCase("Dirty"))
							{
								sqlAvailability ="select b.strStatus from tblfoliohd a,tblroom b where a.strRoomNo='"+arrObjRoomDtl[1].toString()+"' and a.strRoomNo=b.strRoomCode and a.strClientCode=b.strClientCode;";
								listAvailability = objGlobalFunctionsService.funGetListModuleWise(sqlAvailability, "sql");	
								strAvailability="Occupied";
								if(listAvailability.get(0).toString().equalsIgnoreCase(""))
								{
									strAvailability="Free";
								}							
								 objRoomStatusDtl.setStrDay1(" "+arrObjRoomDtl[4].toString());								 								
								 objRoomStatusDtl.setStrDay2(" "+strAvailability);							
								 objRoomStatusDtl.setStrDay3(" "+arrObjRoomDtl[15].toString());
								 objRoomStatusDtl.setStrDay5(" "+arrObjRoomDtl[17].toString());
								 objRoomStatusDtl.setStrDay6(" ");
								 objRoomStatusDtl.setStrDay7(" ");
								}
							}
							String sqlRoomCnt = "select count(*) from tblroom a where a.strRoomTypeDesc='"+arrObjRooms[2].toString()+"' and a.strClientCode='"+clientCode+"'";
							List listRoomCnt = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCnt, "sql");
							if(listRoomCnt!=null && listRoomCnt.size()>0)
							{
								objRoomStatusDtl.setDblRoomCnt(Double.parseDouble(listRoomCnt.get(0).toString()));
							}										
							if(arrObjRooms[0].toString()!="")
							{
								String sqlStaffName = "select ifnull(b.strStaffName,'') from tblstaffmasterdtl a,tblpmsstaffmaster b where a.strRoomCode='"+arrObjRooms[0].toString()+"' and a.strStffCode=b.strStaffCode and a.strClientCode=b.strClientCode and a.strClientCode='"+clientCode+"'";
								List listStaffName = objGlobalFunctionsService.funGetListModuleWise(sqlStaffName, "sql");
								objRoomStatusDtl.setStrDay4("");
								if(!listStaffName.isEmpty())
								{
									objRoomStatusDtl.setStrDay4(listStaffName.get(0).toString());
								}									
							}							
							objTemp.add(objRoomStatusDtl);							
					}
					
					if(objRoomStatusDtl.getStrRoomStatus().equalsIgnoreCase("Blocked"))
					{
						String sqlBlock = "SELECT DATEDIFF('"+PMSDate+"',b.dteValidTo) FROM tblroom a,tblblockroom b "
								+ "WHERE a.strRoomCode=b.strRoomCode AND a.strRoomDesc='"+objRoomStatusDtl.getStrRoomNo()+"' AND a.strClientCode='"+clientCode+"' ";
						List listBlockRoom = objGlobalFunctionsService.funGetListModuleWise(sqlBlock, "sql");
						if (listBlockRoom.size() > 0) 
						{
							BigInteger diff = (BigInteger) listBlockRoom.get(0);
							String strBlockRoomDiff=diff.toString();
							if(strBlockRoomDiff.startsWith("-"))
							{
								if(Integer.parseInt(strBlockRoomDiff.substring(1))==0)
								{
									objRoomStatusDtl.setStrDay1("Blocked Room");
								}
								else if(Integer.parseInt(strBlockRoomDiff.substring(1))>0)
								{
									for(int i=0;i<=Integer.parseInt(strBlockRoomDiff.substring(1));i++)
									{
										if(i==0)
										{
											i=i+1;
										}
										objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
									}
								}
							}
							else
							{
								if(Integer.parseInt(strBlockRoomDiff)==0)
								{
									objRoomStatusDtl.setStrDay1("Blocked Room");
								}
								else if(Integer.parseInt(strBlockRoomDiff)>0)
								{
									for(int i=0;i<=Integer.parseInt(strBlockRoomDiff);i++)
									{
										if(i==0)
										{
											i=i+1;
										}
										objRoomStatusDtl.setStrDay("Day"+i+"Blocked Room");
									}
								}
							}
						}
					}					
			}
			listRoomStatusBeanDtl.add(objRoomTypeWise);		
			return objTemp;
		}
	
	private double funGetDblRemainingAmt(String strFolioNo,String clintCode,String strCheckInNo) {		
		
		String sqlRecipt="SELECT b.BillAmount - a.receiptamt +c.taxAmt"
				+ " FROM "
				+ "( SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) + IFNULL(c.recieptFolioAmt,0)  AS receiptamt"
				+ " FROM "
				+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt"
				+ " FROM tblreceipthd a, tblfoliohd b"
				+ " WHERE a.strReservationNo = b.strReservationNo AND b.strFolioNo='"+strFolioNo+"' AND b.strRoom='Y' "
				+ " AND a.strFlagOfAdvAmt='Y' AND LENGTH(b.strWalkInNo)=0  )  AS a , "//Advance payment,group reservation,reservation,Group leeader payee
				+ " ( SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1"
				+ " FROM tblreceipthd a, tblfoliohd b"
				+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = b.strCheckInNo AND a.strFolioNo = '"+strFolioNo+"'"
				+ " AND a.strReservationNo = '') AS b, " //Folio payment ,walk in 
				+ " (SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS recieptFolioAmt"
				+ " FROM tblreceipthd a, tblfoliohd b"
				+ " WHERE a.strReservationNo = b.strReservationNo  AND a.strFolioNo=b.strFolioNo"
				+ " AND b.strFolioNo='"+strFolioNo+"' "
				+ " AND a.strFlagOfAdvAmt='N' AND LENGTH(b.strWalkInNo)=0 ) AS c )  AS a, "//Folio payment ,group reservation,reservation,Non Group leeader payee
				+ " (SELECT IFNULL(SUM(a.dblDebitAmt),0) - IFNULL(SUM(a.dblDiscAmt ),0)   AS BillAmount"
				+ " FROM tblfoliodtl a"
				+ " WHERE a.strFolioNo='"+strFolioNo+"') AS b,"//total Folio Amount
				+ " (SELECT IFNULL(SUM(a.dblTaxAmt),0) AS taxAmt"
				+ " FROM tblfoliotaxdtl a,tbltaxmaster b"
				+ " WHERE a.strTaxCode=b.strTaxCode AND b.strTaxCalculation='Forward' AND a.strFolioNo='"+strFolioNo+"') AS c ;" ;////total FolioTax  Amount
	
	
		
		List listRecipt = objGlobalFunctionsService.funGetListModuleWise(sqlRecipt, "sql");
		double reciptAmt=0.0;
		if(listRecipt.size()>0)
		{
			reciptAmt=Double.parseDouble(listRecipt.get(0).toString());	
			
		}
		return reciptAmt;
	}

	private String funGetDayOfWeek(int day) {
		String dayOfWeek = "Sun";

		switch (day) {
		case 0:
			dayOfWeek = "Sunday";
			break;

		case 1:
			dayOfWeek = "Monday";
			break;

		case 2:
			dayOfWeek = "Tuesday";
			break;

		case 3:
			dayOfWeek = "Wednesday";
			break;

		case 4:
			dayOfWeek = "Thursday";
			break;

		case 5:
			dayOfWeek = "Friday";
			break;

		case 6:
			dayOfWeek = "Saturday";
			break;
		}
		return dayOfWeek;
	}
	
	@RequestMapping(value = "/getRoomTypeWiseList", method = RequestMethod.GET)
	public @ResponseBody Map funLoadRoomTypeWiseStatus(@RequestParam("viewDate") String viewDate, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",request.getSession().getAttribute("PMSDate").toString());
		Map returnObject=new HashMap<>();

		try
		{
		Map jObjStayViewData=new HashMap<>(); 
		List mainArrObj = new ArrayList<>();
		NumberFormat formatter = new DecimalFormat("#0");
		NumberFormat decformat = new DecimalFormat("#0.00");
		String dd = viewDate.split("-")[0]; 
		String mm=	 viewDate.split("-")[1] ;
		String yy= viewDate.split("-")[2];
		String strCompDate = objGlobal.funGetDate("yyyy-MM-dd", viewDate);
			
			Map objRoomStatusDtlBean = new HashMap<>();
			List listRoomStatus= new ArrayList<>();
			if(PMSDate.equalsIgnoreCase(strCompDate))
			{
				String sql=" select a.strRoomTypeDesc from tblroom a,tblroomtypemaster b  "
						+ " where a.strClientCode='"+clientCode+"'  and a.strRoomTypeCode=b.strRoomTypeCode "
						+ " and b.strIsHouseKeeping='N' "
						+ " group by  a.strRoomTypeDesc ";
				List listRoomDesc = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				//while(listRoomDesc.size()>0)
				for(int j=0;j<listRoomDesc.size();j++)
				{
					String tempPMSDate=objGlobal.funGetDate("yyyy-MM-dd", viewDate);
					String strRoomData="";
					sql="select count(*) from tblroom a where a.strRoomTypeDesc='"+listRoomDesc.get(j)+"' AND a.strClientCode='"+clientCode+"'";
					
					List listRoomData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					if(listRoomData.size()>0)
					{
						int intRoomAccupied=0;
						for(int i=1;i<=7;i++)
						{
							if(PMSDate.equals(tempPMSDate))
							{
								sql="  select sum(checkInCount) from "
										+ "(select COUNT((b.strRoomCode)) as checkInCount "
										+ " from  tblcheckindtl a,tblroom b,tblcheckinhd c where a.strCheckInNo=c.strCheckInNo and"
										+ " a.strRoomNo=b.strRoomCode and date(c.dteCheckInDate) <= '"+tempPMSDate+"'  "
										+ "  and date(c.dteDepartureDate)>='"+tempPMSDate+"' and b.strRoomTypeDesc='"+listRoomDesc.get(j)+"' and b.strStatus='Occupied' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'"
										+ " and c.strCheckInNo not  in (select a.strCheckInNo from tblbillhd a) "
										+ " Union  "
										+ " SELECT count(a.strReservationNo) as resCount "
										+ " FROM tblreservationdtl a,tblroomtypemaster b,tblreservationhd c "
										+ " WHERE  DATE(c.dteArrivalDate) <= '"+tempPMSDate+"' AND DATE(c.dteDepartureDate)>='"+tempPMSDate+"' AND b.strRoomTypeDesc='"+listRoomDesc.get(j)+"' AND a.strRoomType=b.strRoomTypeCode "
										+ " AND a.strClientCode='"+clientCode+"' and a.strRoomNo!='' AND a.strReservationNo=c.strReservationNo AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'"
										+ " and c.strReservationNo not  in (select a.strReservationNo from tblcheckinhd a) ) b";
								
								List listCheckInData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
								String dd1=String.valueOf((Integer.parseInt(dd)+i));

								if(listCheckInData.size()>0)
								{
									if(strRoomData.isEmpty())
									{
										strRoomData=listRoomDesc.get(j)+"/"+listCheckInData.get(0);
									}
									else
									{
										strRoomData=strRoomData+"/"+listCheckInData.get(0);
									}
								}
								tempPMSDate=yy+"-"+mm+"-"+dd1;
							}
							else
							{
								sql="  select sum(checkInCount) from "
										+ "(select COUNT((b.strRoomCode)) as checkInCount "
										+ " from  tblcheckindtl a,tblroom b,tblcheckinhd c where a.strCheckInNo=c.strCheckInNo and"
										+ " a.strRoomNo=b.strRoomCode and date(c.dteCheckInDate) <= '"+tempPMSDate+"'  "
										+ "  and date(c.dteDepartureDate)>='"+tempPMSDate+"' and b.strRoomTypeDesc='"+listRoomDesc.get(j)+"' and b.strStatus='Occupied' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'"
										+ " and c.strCheckInNo not  in (select a.strCheckInNo from tblbillhd a) "
										+ " Union  "
										+ " SELECT count(a.strReservationNo) as resCount "
										+ " FROM tblreservationdtl a,tblroomtypemaster b,tblreservationhd c "
										+ " WHERE  DATE(c.dteArrivalDate) <= '"+tempPMSDate+"' AND DATE(c.dteDepartureDate)>='"+tempPMSDate+"' AND b.strRoomTypeDesc='"+listRoomDesc.get(j)+"' AND a.strRoomType=b.strRoomTypeCode "
										+ " AND a.strClientCode='"+clientCode+"' and a.strRoomNo!='' AND a.strReservationNo=c.strReservationNo AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"'"
										+ " and c.strReservationNo not  in (select a.strReservationNo from tblcheckinhd a) ) b";
								List listCheckInData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
								
								String dd1=String.valueOf((Integer.parseInt(dd)+i));

								if(listCheckInData.size()>0)
								{
									if(strRoomData.isEmpty())
									{
										strRoomData=listRoomDesc.get(j)+"/"+listCheckInData.get(0);
									}
									else
									{
										strRoomData=strRoomData+"/"+listCheckInData.get(0);
									}
								}
								tempPMSDate=yy+"-"+mm+"-"+dd1;
							}
							objRoomStatusDtlBean.put(listRoomDesc.get(j),strRoomData);
						}
					}							
				}
			}
			else
			{
			
			String sql=" select a.strRoomTypeDesc from tblroom a,tblroomtypemaster b "
					+ " where a.strClientCode='"+clientCode+"' "
					+ " and a.strRoomTypeCode=b.strRoomTypeCode "
					+ " and b.strIsHouseKeeping='N'"
					+ " group by a.strRoomTypeDesc ";
			List listRoomDesc = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			//while(listRoomDesc.size()>0)
			for(int j=0;j<listRoomDesc.size();j++)
			{
				String tempPMSDate=objGlobal.funGetDate("yyyy-MM-dd", viewDate);
				String strRoomData="";
				sql="select count(*) from tblroom a where a.strRoomTypeDesc='"+listRoomDesc.get(j)+"' AND a.strClientCode='"+clientCode+"'";
				
				List listRoomData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if(listRoomData.size()>0)
				{
					int intRoomAccupied=0;
					for(int i=1;i<=7;i++)
					{
						sql=" select count(*) "
								+ " from  tblcheckindtl a,tblroom b,tblcheckinhd c where a.strCheckInNo=c.strCheckInNo and"
								+ " a.strRoomNo=b.strRoomCode and date(c.dteCheckInDate) <= '"+tempPMSDate+"'  "
								+ "  and date(c.dteDepartureDate)>='"+tempPMSDate+"' and b.strRoomTypeDesc='"+listRoomDesc.get(j)+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' group by b.strRoomDesc";
						
						List listCheckInData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
						String dd1=String.valueOf((Integer.parseInt(dd)+i));

						if(listCheckInData.size()>0)
						{
							if(strRoomData.isEmpty())
							{
								strRoomData=listRoomDesc.get(j)+"/"+listCheckInData.size()+"-"+listRoomData.get(0);
							}
							else
							{
								strRoomData=strRoomData+"/"+listCheckInData.size()+"-"+listRoomData.get(0);	
							}
						}
						else
						{
							strRoomData=strRoomData+"/"+0+"-"+listRoomData.get(0);
						}
						tempPMSDate=yy+"-"+mm+"-"+dd1;
					}
					objRoomStatusDtlBean.put(listRoomDesc.get(j),strRoomData);
					/*listRoomStatus.put(objRoomStatusDtlBean);*/
					/*objRoomStatusData.put(rsRoomInfo1.getString(1), strRoomData);*/
				}
			}
		}
		returnObject.put("RoomTypeCount", objRoomStatusDtlBean);
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return returnObject;	
	}
	
	@RequestMapping(value = "/getInformation", method = RequestMethod.GET)
	public @ResponseBody List funLoadInformation(@RequestParam("code") String code, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",request.getSession().getAttribute("PMSDate").toString());
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String dteDepartureDate = "";
		List listReturn=new ArrayList<>();
		try
		{
			DecimalFormat df = new DecimalFormat("#.##");
			code = code.split(",")[1];
			if(code.startsWith("F"))
			{
				clsFolioHdModel objFolioHd = objFolioService.funGetFolioList(code, clientCode, propCode);
				double dblTaxAmt = 0.0;
				double dblRMTaxAmt =0.0;
				double dblIHtaxAmt=0.0;
				for(clsFolioTaxDtl objTaxData :objFolioHd.getListFolioTaxDtlModel()){
					dblTaxAmt = dblTaxAmt+objTaxData.getDblTaxAmt();
					if(clientCode.equalsIgnoreCase("383.001"))
					{
						if(objTaxData.getStrDocNo().startsWith("RM"))
						{
							dblRMTaxAmt=dblRMTaxAmt+objTaxData.getDblTaxAmt();
						}
						else
						{
							dblIHtaxAmt= dblIHtaxAmt+objTaxData.getDblTaxAmt();	
						}
					}
				}
				
			
			StringBuilder sbSql = new StringBuilder();
			/*sbSql.append("select concat(d.strFirstName,' ',d.strMiddleName,' ',d.strLastName),DATE_FORMAT(e.dteArrivalDate,'%d-%m-%Y'),b.strRegistrationNo,a.strFolioNo,f.strRoomDesc,a.dblDebitAmt,DATEDIFF('"+PMSDate+"',date(e.dteCheckInDate)),d.strGuestCode , DATE_FORMAT(e.dteDepartureDate,'%d-%m-%Y')"
					+ "from tblfoliodtl a , tblfoliohd b , tblcheckindtl c , tblguestmaster d,tblcheckinhd e,tblroom f  "
					+ " where a.strFolioNo='"+code+"' "
					+ "and a.strFolioNo=b.strFolioNo and b.strCheckInNo=c.strCheckInNo "
					+ "and c.strGuestCode=d.strGuestCode  and c.strCheckInNo=e.strCheckInNo "
					+ "and b.strRoomNo = f.strRoomCode and a.strPerticulars='Room Tariff' Group by d.strGuestCode ");*/
			sbSql.append("select concat(d.strFirstName,' ',d.strMiddleName,' ',d.strLastName),DATE_FORMAT(e.dteArrivalDate,'%d-%m-%Y'),b.strRegistrationNo,a.strFolioNo,f.strRoomDesc,a.dblDebitAmt,DATEDIFF('"+PMSDate+"',date(e.dteCheckInDate)),d.strGuestCode , DATE_FORMAT(e.dteDepartureDate,'%d-%m-%Y')"
					+ "from tblfoliodtl a , tblfoliohd b , tblcheckindtl c , tblguestmaster d,tblcheckinhd e,tblroom f  "
					+ " where a.strFolioNo='"+code+"' "
					+ "and a.strFolioNo=b.strFolioNo and b.strCheckInNo=c.strCheckInNo "
					+ "and c.strGuestCode=d.strGuestCode  and c.strCheckInNo=e.strCheckInNo "
					+ "and b.strRoomNo = f.strRoomCode Group by d.strGuestCode ");
			List listData = objGlobalFunctionsService.funGetListModuleWise(sbSql.toString(), "sql");
			String strGuestCode="";
			if(listData!=null && listData.size()>0){
				for(int i=0;i<listData.size();i++){
				Object[] arr = (Object[]) listData.get(i);
				listReturn.add(arr[0]);
				listReturn.add(arr[1]);
				listReturn.add(arr[2]);
				listReturn.add(arr[3]);
				listReturn.add(arr[4]);
				if(clientCode.equalsIgnoreCase("383.001"))
				{
					double amount=Double.parseDouble(arr[5].toString());
					amount=amount-dblRMTaxAmt;
					listReturn.add(df.format(amount));
					if(dblTaxAmt>0)
					{
					listReturn.add(Double.parseDouble(df.format(dblTaxAmt)));	
					}
					else
					{
						listReturn.add(0);	
					}
				}
				else
				{
					listReturn.add(arr[5]);
					if(dblTaxAmt>0)
					{
						listReturn.add(Double.parseDouble(df.format(dblTaxAmt)));	
					}
					else
					{
						listReturn.add(0);	
					}	
				}
				
				
				listReturn.add(arr[6]);				
				strGuestCode=arr[7].toString();				
				dteDepartureDate = arr[8].toString();
				}
			}
			
			if(!code.equals("")){
				String sqlExtraBed = "select b.dblChargePerBed from tblfoliohd a , tblextrabed b where a.strFolioNo='"+code+"' and a.strExtraBedCode=b.strExtraBedTypeCode and a.strClientCode='"+clientCode+"'";
				List listExtraBed = objGlobalFunctionsService.funGetListModuleWise(sqlExtraBed, "sql");
				if(listExtraBed!=null && listExtraBed.size()>0)
				{
					listReturn.add(Double.parseDouble(listExtraBed.get(0).toString()));
				}
				else
				{
					listReturn.add(0);
				}
				listReturn.add(strGuestCode);
				listReturn.add(dteDepartureDate);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return listReturn;		
	}
	
	
	@RequestMapping(value="/loadDataReservation",method=RequestMethod.GET)
	public @ResponseBody List funLoadCheckInBill(@RequestParam("viewDate") String viewDate ,HttpServletRequest request)
	{
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String PMSDate=objGlobal.funGetDate("yyyy-MM-dd",viewDate);

		List listReturn=new ArrayList();
		
		String sqlArrivalCnt = "select a.strReservationNo from tblreservationhd a where date(a.dteArrivalDate)='"+PMSDate+"'";
		
		List listArrivalCnt = objGlobalFunctionsService.funGetListModuleWise(sqlArrivalCnt, "sql");

		if(listArrivalCnt!=null && listArrivalCnt.size()>0)
		{
			listReturn.add(listArrivalCnt.size());
		}
		else
		{
			listReturn.add(0);
		}
		
		
		String sqlDeparture = "select a.strCheckInNo from tblcheckinhd a where date(a.dteDepartureDate)='"+PMSDate+"'";
					
		List listDeparture = objGlobalFunctionsService.funGetListModuleWise(sqlDeparture, "sql");

		if(listDeparture!=null && listDeparture.size()>0)
		{
			listReturn.add(listDeparture.size());
		}
		else
		{
			listReturn.add(0);
		}
		
		
		
		String sqlBookedRooms = "select a.strRoomDesc from tblroom a "
				+ "where a.strStatus='Occupied' and a.strClientCode='"+clientCode+"'";
					
		List listData = objGlobalFunctionsService.funGetListModuleWise(sqlBookedRooms, "sql");

		if(listData!=null && listData.size()>0)
		{
			listReturn.add(listData.size());
		}
		else
		{
			listReturn.add(0);
		}
		
		return listReturn;
	}
	
}
