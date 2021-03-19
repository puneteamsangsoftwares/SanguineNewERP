package com.sanguine.webpms.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.text.DecimalFormat;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.model.clsPropertyMaster;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsPropertyMasterService;
import com.sanguine.webpms.bean.clsCheckInBean;
import com.sanguine.webpms.bean.clsCheckOutBean;
import com.sanguine.webpms.bean.clsCheckOutRoomDtlBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsBillDtlModel;
import com.sanguine.webpms.model.clsBillHdModel;
import com.sanguine.webpms.model.clsBillTaxDtlModel;
import com.sanguine.webpms.model.clsCheckInDtl;
import com.sanguine.webpms.model.clsCheckInHdModel;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsFolioTaxDtl;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.service.clsCheckInService;
import com.sanguine.webpms.service.clsCheckOutService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPropertySetupService;
import com.sanguine.webpms.service.clsRoomMasterService;

@Controller
public class clsCheckOutController {
	@Autowired
	private clsCheckOutService objCheckOutService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsPropertySetupService objPropertySetupService;

	@Autowired
	private clsGuestMasterService objGuestService;

	@Autowired
	private clsPropertyMasterService objPropertyMasterService;

	@Autowired
	private clsCheckOutService objcheckOutService;

	@Autowired
	private clsCheckInService objCheckInService;

	@Autowired
	clsRoomMasterService objRoomMaster;
	
	@Autowired
	private clsFolioService objFolioService;
	

	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	private clsBillPrintingController objBillPrintingController;

	// Open CheckIn
	@RequestMapping(value = "/frmCheckOut", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		clsCheckOutBean objBean = new clsCheckOutBean();
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
		
		// String
		// PMSStartDay=request.getSession().getAttribute("PMSStartDay").toString();
		
		model.put("PMSDate", PMSDate);
		request.getSession().setAttribute("checkOutNo", "");
		return new ModelAndView("frmCheckOut", "command", objBean);
	}

	// get room detail for checkout
	@RequestMapping(value = "/getRoomDtlList", method = RequestMethod.GET)
	public @ResponseBody List funLoadMasterData(@RequestParam("roomCode") String roomCode,HttpServletRequest request) {
		/*
		 * String sql=
		 * "select a.strCheckInNo,a.strRegistrationNo,ifnull(a.strReservationNo,'NA'),ifnull(a.strWalkinNo,'NA') "
		 * +
		 * " ,c.strCorporateCode,d.strRoomNo,d.strFolioNo,concat(f.strFirstName,' ',f.strMiddleName,' ',f.strLastName) as GuestName "
		 * +
		 * " ,date(a.dteArrivalDate),date(a.dteDepartureDate),ifnull(g.strCorporateCode,'NA'),ifnull(sum(e.dblDebitAmt),0)+ifnull(sum(h.dblTaxAmt),0) "
		 * +
		 * " from tblcheckinhd a left outer join tblcheckindtl b on a.strCheckInNo=b.strCheckInNo "
		 * +
		 * " left outer join tblreservationhd c on a.strReservationNo=c.strReservationNo "
		 * + " left outer join tblfoliohd d on a.strCheckInNo=d.strCheckInNo " +
		 * " left outer join tblfoliodtl e on d.strFolioNo=e.strFolioNo " +
		 * " left outer join tblfoliotaxdtl h on e.strFolioNo=h.strFolioNo and e.strDocNo=h.strDocNo "
		 * +
		 * " left outer join tblguestmaster f on b.strGuestCode=f.strGuestCode "
		 * + " left outer join tblwalkinhd g on a.strWalkInNo=g.strWalkinNo " +
		 * " where d.strRoomNo='"+roomCode+"' " + " group by e.strFolioNo ";
		 * List list = objGlobalFunctionsService.funGetListModuleWise(sql,
		 * "sql");
		 */
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String sql="";
		List<clsCheckOutRoomDtlBean> listCheckOutRoomDtl = new ArrayList<clsCheckOutRoomDtlBean>();
		if(request.getParameter("groupCheckIn")!=null)
		{
			request.getSession().setAttribute("GroupCheckIn", "Y");			
			/*sql = "select a.strCheckInNo,a.strRegistrationNo,ifnull(a.strReservationNo,'NA'),ifnull(a.strWalkinNo,'NA') " + " ,c.strCorporateCode,d.strRoomNo,d.strFolioNo,concat(IFNULL(f.strFirstName,''),' ',IFNULL(f.strMiddleName,''),' ',IFNULL(f.strLastName,'')) as GuestName " + " ,date(a.dteArrivalDate),date(a.dteDepartureDate),ifnull(g.strCorporateCode,'NA') "
					+ " from tblcheckinhd a left outer join tblcheckindtl b on a.strCheckInNo=b.strCheckInNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
					+ " left outer join tblreservationhd c on a.strReservationNo=c.strReservationNo AND c.strClientCode='"+clientCode+"'"
					+ " left outer join tblfoliohd d on a.strCheckInNo=d.strCheckInNo AND d.strClientCode='"+clientCode+"'" 
					+ " left outer join tblguestmaster f on b.strGuestCode=f.strGuestCode AND f.strClientCode='"+clientCode+"'" 
					+ " left outer join tblwalkinhd g on a.strWalkInNo=g.strWalkinNo AND g.strClientCode='"+clientCode+"'"
					+ " where d.strCheckInNo='" + roomCode + "' " + " and d.strGuestCode=f.strGuestCode group by d.strFolioNo ";	
             */
			
			sql = "select a.strCheckInNo,a.strRegistrationNo,ifnull(a.strReservationNo,'NA'),ifnull(a.strWalkinNo,'NA') " + " ,c.strCorporateCode,d.strRoomNo,d.strFolioNo,concat(IFNULL(f.strFirstName,''),' ',IFNULL(f.strMiddleName,''),' ',IFNULL(f.strLastName,'')) as GuestName " + " ,date(a.dteArrivalDate),date(a.dteDepartureDate),ifnull(g.strCorporateCode,'NA')  ,h.strRoomDesc,d.strRoom "
					+ " from tblcheckinhd a left outer join tblcheckindtl b on a.strCheckInNo=b.strCheckInNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
					+ " left outer join tblreservationhd c on a.strReservationNo=c.strReservationNo AND c.strClientCode='"+clientCode+"'"
					+ " left outer join tblfoliohd d on a.strCheckInNo=d.strCheckInNo AND d.strClientCode='"+clientCode+"'" 
					+ " left outer join tblguestmaster f on b.strGuestCode=f.strGuestCode AND f.strClientCode='"+clientCode+"'" 
					+ " left outer join tblwalkinhd g on a.strWalkInNo=g.strWalkinNo AND g.strClientCode='"+clientCode+"' ,tblroom h  "
					+ " where d.strRoomNo=h.strRoomCode AND d.strCheckInNo='" + roomCode + "' " + " and d.strGuestCode=f.strGuestCode group by d.strFolioNo ";	


			
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			for (int i = 0; i < list.size(); i++) {
				Object obj[] = (Object[]) list.get(i);
				clsCheckOutRoomDtlBean objCheckOutRoomDtlBean = new clsCheckOutRoomDtlBean();
				objCheckOutRoomDtlBean.setStrRoomNo(obj[5].toString());
				objCheckOutRoomDtlBean.setStrRegistrationNo(obj[1].toString());
				objCheckOutRoomDtlBean.setStrFolioNo(obj[6].toString());
				objCheckOutRoomDtlBean.setStrReservationNo(obj[2].toString());
				objCheckOutRoomDtlBean.setStrGuestName(obj[7].toString());
				objCheckOutRoomDtlBean.setDteCheckInDate(obj[8].toString());
				objCheckOutRoomDtlBean.setDteCheckOutDate(obj[9].toString());
				objCheckOutRoomDtlBean.setStrCorporate(obj[10].toString());
				objCheckOutRoomDtlBean.setDblAmount(0);
				objCheckOutRoomDtlBean.setStrRoomDesc(obj[11].toString());

				/*sql = "select a.strFolioNo,sum(b.dblDebitAmt) " + " from tblfoliohd a,tblfoliodtl b " + " where a.strFolioNo=b.strFolioNo and a.strRoomNo='" + obj[5].toString() + "' " + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'  and  a.strFolioNo='"+objCheckOutRoomDtlBean.getStrFolioNo()+"' group by a.strFolioNo";
				List listFolioAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioAmt.size(); cnt++) {
					Object[] arrObjFolio = (Object[]) listFolioAmt.get(cnt);
					objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() + Double.parseDouble(arrObjFolio[1].toString()));
				}*/

				/*sql = "select sum(b.dblDebitAmt),sum(c.dblTaxAmt) " + " from tblfoliohd a,tblfoliodtl b,tblfoliotaxdtl c " + " where a.strFolioNo=b.strFolioNo and b.strFolioNo=c.strFolioNo and b.strDocNo=c.strDocNo " + " and a.strRoomNo='" + obj[5].toString() + "' " + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' and  a.strFolioNo='"+objCheckOutRoomDtlBean.getStrFolioNo()+"' group by b.strFolioNo";
				List listFolioTaxAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioTaxAmt.size(); cnt++) {
					Object[] arrObjFolio = (Object[]) listFolioTaxAmt.get(cnt);
					if(!clientCode.equalsIgnoreCase("383.001"))
					{
						objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() + Double.parseDouble(arrObjFolio[1].toString()));
					}
					
				}*/
				sql="SELECT b.BillAmount - a.receiptamt +c.taxAmt "
						+ " FROM ( SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) AS receiptamt"
						+ " FROM "
						+ " ( SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt "
						+ " FROM tblreceipthd a, tblfoliohd b "
						+ " WHERE a.strReservationNo = b.strReservationNo AND b.strFolioNo='"+obj[6].toString()+"' AND b.strRoom='Y' ) AS a,"
						+ " ( SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1 FROM tblreceipthd a, tblfoliohd b"
						+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = b.strCheckInNo AND a.strFolioNo = '"+obj[6].toString()+"' AND a.strReservationNo = '') AS b) AS a, "
						+ " ( SELECT IFNULL(SUM(a.dblDebitAmt),0) AS BillAmount"
						+ " FROM tblfoliodtl a WHERE a.strFolioNo='"+obj[6].toString()+"') AS b,(SELECT IFNULL(sum(a.dblTaxAmt),0) AS taxAmt FROM tblfoliotaxdtl a ,tbltaxmaster b"
						+ " WHERE a.strTaxCode=b.strTaxCode AND "
						+ " b.strTaxCalculation='Forward' And"
						+ " a.strFolioNo='"+obj[6].toString()+"') AS  c ;" ;
		
				List listFolioBalAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioBalAmt.size(); cnt++) {
					
					
					objCheckOutRoomDtlBean.setDblAmount(Double.parseDouble( listFolioBalAmt.get(0).toString()));
					
				listCheckOutRoomDtl.add(objCheckOutRoomDtlBean);
				}
			}
		}	
		else
		{
			request.getSession().setAttribute("GroupCheckIn", "N");		
			/*sql = "select a.strCheckInNo,a.strRegistrationNo,ifnull(a.strReservationNo,'NA'),ifnull(a.strWalkinNo,'NA') " + " ,c.strCorporateCode,d.strRoomNo,d.strFolioNo,concat(IFNULL(f.strFirstName,''),' ',IFNULL(f.strMiddleName,''),' ',IFNULL(f.strLastName,'')) as GuestName " + " ,date(a.dteArrivalDate),date(a.dteDepartureDate),ifnull(g.strCorporateCode,'NA') "
					+ " from tblcheckinhd a left outer join tblcheckindtl b on a.strCheckInNo=b.strCheckInNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
					+ " left outer join tblreservationhd c on a.strReservationNo=c.strReservationNo AND c.strClientCode='"+clientCode+"'"
					+ " left outer join tblfoliohd d on a.strCheckInNo=d.strCheckInNo AND d.strClientCode='"+clientCode+"'" 
					+ " left outer join tblguestmaster f on b.strGuestCode=f.strGuestCode AND f.strClientCode='"+clientCode+"'" 
					+ " left outer join tblwalkinhd g on a.strWalkInNo=g.strWalkinNo AND g.strClientCode='"+clientCode+"'"
					+ " where d.strRoomNo='" + roomCode + "' " + " group by d.strFolioNo ";		
			*/
			sql = "select a.strCheckInNo,a.strRegistrationNo,ifnull(a.strReservationNo,'NA'),ifnull(a.strWalkinNo,'NA') " + " ,c.strCorporateCode,d.strRoomNo,d.strFolioNo,concat(IFNULL(f.strFirstName,''),' ',IFNULL(f.strMiddleName,''),' ',IFNULL(f.strLastName,'')) as GuestName " + " ,date(a.dteArrivalDate),date(a.dteDepartureDate),ifnull(g.strCorporateCode,'NA'), h.strRoomDesc "
					+ " from tblcheckinhd a left outer join tblcheckindtl b on a.strCheckInNo=b.strCheckInNo AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"'"
					+ " left outer join tblreservationhd c on a.strReservationNo=c.strReservationNo AND c.strClientCode='"+clientCode+"'"
					+ " left outer join tblfoliohd d on a.strCheckInNo=d.strCheckInNo AND d.strClientCode='"+clientCode+"'" 
					+ " left outer join tblguestmaster f on b.strGuestCode=f.strGuestCode AND f.strClientCode='"+clientCode+"'" 
					+ " left outer join tblwalkinhd g on a.strWalkInNo=g.strWalkinNo AND g.strClientCode='"+clientCode+"' ,tblroom h  "
					+ " where  d.strRoomNo=h.strRoomCode AND d.strRoomNo='" + roomCode + "' " + " group by d.strFolioNo ";	
			
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

			
			for (int i = 0; i < list.size(); i++) {
				Object obj[] = (Object[]) list.get(i);
				clsCheckOutRoomDtlBean objCheckOutRoomDtlBean = new clsCheckOutRoomDtlBean();
				objCheckOutRoomDtlBean.setStrRoomNo(obj[5].toString());
				objCheckOutRoomDtlBean.setStrRegistrationNo(obj[1].toString());
				objCheckOutRoomDtlBean.setStrFolioNo(obj[6].toString());
				objCheckOutRoomDtlBean.setStrReservationNo(obj[2].toString());
				objCheckOutRoomDtlBean.setStrGuestName(obj[7].toString());
				objCheckOutRoomDtlBean.setDteCheckInDate(obj[8].toString());
				objCheckOutRoomDtlBean.setDteCheckOutDate(obj[9].toString());
				objCheckOutRoomDtlBean.setStrCorporate(obj[10].toString());
				objCheckOutRoomDtlBean.setDblAmount(0);
				objCheckOutRoomDtlBean.setStrRoomDesc(obj[11].toString());

				/*sql = "select a.strFolioNo,sum(b.dblDebitAmt) " + " from tblfoliohd a,tblfoliodtl b " + " where a.strFolioNo=b.strFolioNo and a.strRoomNo='" + roomCode + "' " + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' group by a.strFolioNo";
				List listFolioAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioAmt.size(); cnt++) {
					Object[] arrObjFolio = (Object[]) listFolioAmt.get(cnt);
					objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() + Double.parseDouble(arrObjFolio[1].toString()));
				}
                if(!clientCode.equalsIgnoreCase("383.001"))
                {
					sql = "select sum(b.dblDebitAmt),sum(c.dblTaxAmt) " + " from tblfoliohd a,tblfoliodtl b,tblfoliotaxdtl c " + " where a.strFolioNo=b.strFolioNo and b.strFolioNo=c.strFolioNo and b.strDocNo=c.strDocNo " + " and a.strRoomNo='" + roomCode + "' " + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' group by b.strFolioNo";
					List listFolioTaxAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					for (int cnt = 0; cnt < listFolioTaxAmt.size(); cnt++) {
						Object[] arrObjFolio = (Object[]) listFolioTaxAmt.get(cnt);
						objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() + Double.parseDouble(arrObjFolio[1].toString()));
					}
                }
				sql = "select a.strReceiptNo,sum(b.dblSettlementAmt) " + " from tblreceipthd a,tblreceiptdtl b " + " where a.strReceiptNo=b.strReceiptNo and a.strRegistrationNo='" + objCheckOutRoomDtlBean.getStrRegistrationNo() + "' and a.strAgainst='Check-In' " + " AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' group by a.strReceiptNo";
				List listReceiptAmtAtCheckIN = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listReceiptAmtAtCheckIN.size(); cnt++) {
					Object[] arrObjFolio = (Object[]) listReceiptAmtAtCheckIN.get(cnt);
					objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() - Double.parseDouble(arrObjFolio[1].toString()));
				}
				
				sql = "SELECT ifnull(Sum(a.dblCreditAmt),0.0) from tblfoliodtl a where a.strFolioNo='"+obj[6].toString()+"' AND a.strClientCode='"+clientCode+"'";
				List listFolioDisc = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioDisc.size(); cnt++) {
					objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() - Double.parseDouble(listFolioDisc.get(cnt).toString()));
				}
	            
				boolean flgIsFullPayment=false;
				if(!objCheckOutRoomDtlBean.getStrReservationNo().toString().isEmpty())
				{
					sql="SELECT ifnull(SUM(c.dblSettlementAmt),0),ifnull(sum(b.dblGrandTotal),0)"
							+ " FROM tblreceipthd a left outer join tblbillhd b on a.strBillNo=b.strBillNo and a.strReservationNo and b.strReservationNo,tblreceiptdtl c"
							+ " WHERE a.strReceiptNo=c.strReceiptNo AND a.strReservationNo='"+objCheckOutRoomDtlBean.getStrReservationNo()+"'"; 
						List listCheckForFullPayment= objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
						for (int cnt = 0; cnt < listCheckForFullPayment.size(); cnt++) 
						{
							Object arrObjFolio[] = (Object[]) listCheckForFullPayment.get(cnt);
							if(Double.parseDouble(arrObjFolio[0].toString())>0)
							{
								if(Double.parseDouble(arrObjFolio[0].toString())==Double.parseDouble(arrObjFolio[1].toString()))
								{
									flgIsFullPayment=true;
									break;
								}
							}
						}
						if(!flgIsFullPayment)
						{
							sql = "select sum(b.dblSettlementAmt) " + " from tblreceipthd a,tblreceiptdtl b " + " where a.strReceiptNo=b.strReceiptNo and a.strReservationNo='" + objCheckOutRoomDtlBean.getStrReservationNo() + "' " + " and a.strAgainst='Reservation' " + " group by a.strReceiptNo";
							List listReceiptAmtAtReservation = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
							for (int cnt = 0; cnt < listReceiptAmtAtReservation.size(); cnt++) {
								Object arrObjFolio = (Object) listReceiptAmtAtReservation.get(cnt);
								objCheckOutRoomDtlBean.setDblAmount(objCheckOutRoomDtlBean.getDblAmount() - Double.parseDouble(arrObjFolio.toString()));
							}	
						}
				}
				*/
				String receiptAmt="a.dblReceiptAmt";
				if(obj[2].toString().equalsIgnoreCase("") )
				{
						receiptAmt="0";
				}
				
				sql="SELECT b.BillAmount - a.receiptamt +c.taxAmt "
						+ " FROM ( SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) AS receiptamt"
						+ " FROM "
						+ " ( SELECT IFNULL(SUM("+receiptAmt+"),0) AS receiptAmt "
						+ " FROM tblreceipthd a, tblfoliohd b "
						+ " WHERE a.strReservationNo = b.strReservationNo AND b.strFolioNo='"+obj[6].toString()+"' AND b.strRoom='Y' ) AS a,"
						+ " ( SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1 FROM tblreceipthd a, tblfoliohd b"
						+ " WHERE a.strFolioNo = b.strFolioNo AND a.strCheckInNo = b.strCheckInNo AND a.strFolioNo = '"+obj[6].toString()+"' AND a.strReservationNo = '') AS b) AS a, "
						+ " (SELECT IFNULL(SUM(a.dblDebitAmt),0) AS BillAmount"
						+ " FROM tblfoliodtl a WHERE a.strFolioNo='"+obj[6].toString()+"') AS b,(SELECT IFNULL(sum(a.dblTaxAmt),0) AS taxAmt FROM tblfoliotaxdtl a ,tbltaxmaster b"
						+ " WHERE a.strTaxCode=b.strTaxCode AND "
						+ " b.strTaxCalculation='Forward' And"
						+ " a.strFolioNo='"+obj[6].toString()+"') AS  c ;" ;
		
				List listFolioBalAmt = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int cnt = 0; cnt < listFolioBalAmt.size(); cnt++) {
					
					
					objCheckOutRoomDtlBean.setDblAmount(Double.parseDouble( listFolioBalAmt.get(0).toString()));
					
			
				}
				
				List<clsCheckOutRoomDtlBean> listRevenueTypeDtl= new ArrayList<>();
				
				sql="select b.strRevenueType, sum(b.dblDebitAmt) from tblfoliohd a ,tblfoliodtl b "
						+ " where a.strFolioNo=b.strFolioNo  and a.strCheckInNo='"+obj[0].toString()+"' "
						+ " group by b.strRevenueType ";
				List listRevenueType = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				for (int j = 0; j < listRevenueType.size(); j++) {
					Object objRevenueType[] = (Object[]) listRevenueType.get(j);
					clsCheckOutRoomDtlBean objRevenueTypeDtl = new clsCheckOutRoomDtlBean();
					objRevenueTypeDtl.setStrRevenueType(objRevenueType[0].toString());
					objRevenueTypeDtl.setDblAmount(Double.parseDouble(objRevenueType[1].toString()));
					listRevenueTypeDtl.add(objRevenueTypeDtl);
					
				}
				objCheckOutRoomDtlBean.setListRevenueTypeDtl(listRevenueTypeDtl);				
				listCheckOutRoomDtl.add(objCheckOutRoomDtlBean);				
				
			}
		}
		
		
	
		return listCheckOutRoomDtl;
	}

	// Save or Update CheckIn
	@RequestMapping(value = "/saveCheckOut", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsCheckOutBean objBean, BindingResult result, HttpServletRequest req,HttpServletResponse resp) {
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
 			urlHits = "1";
		}
		
		if(req.getSession().getAttribute("GroupCheckIn").toString().equalsIgnoreCase("Y"))			
		{
			req.getSession().removeAttribute("GroupCheckIn");
			ModelAndView model= funGetGroupCheckInBill(objBean, result,  req, resp);
			return model;
		}
		else
		{
			String strFolioNo="";
			boolean checkFolioStatus=false;
			if (!result.hasErrors()) {
				String clientCode = req.getSession().getAttribute("clientCode").toString();
				String userCode = req.getSession().getAttribute("usercode").toString();
				List<clsCheckOutRoomDtlBean> listCheckOutRoomDtlBeans = objBean.getListCheckOutRoomDtlBeans();
		   		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
				
	 			String RommNo = "";
				String GSTNo="";
				boolean flag=false;
				String companyName = req.getSession().getAttribute("companyName").toString();
				String propCode = req.getSession().getAttribute("propertyCode").toString();
				List<clsCheckOutRoomDtlBean> listRevenueDtlBeans = objBean.getListCheckOutRevenueDtlBeans();
	 			clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propCode, clientCode);  //pms property setup
	 			if (objModel != null) {
	 				GSTNo=objModel.getStrGSTNo();
				} 
	 			Map<String,String> mapRevenueType= new HashMap<>();
	 			for(int j=0;j<listRevenueDtlBeans.size();j++)
				{   
	 				clsCheckOutRoomDtlBean objRevenueBean=listRevenueDtlBeans.get(j);
	 				if(mapRevenueType.containsKey(objRevenueBean.getStrBillMergeNumber()))
					{
	 					String revenueType=mapRevenueType.get(objRevenueBean.getStrBillMergeNumber());
	 					mapRevenueType.put( objRevenueBean.getStrBillMergeNumber(),revenueType+",'"+objRevenueBean.getStrRevenueType()+"'"); 				
					}
	 				else
	 				{
	 	 				mapRevenueType.put( objRevenueBean.getStrBillMergeNumber(),"'"+objRevenueBean.getStrRevenueType()+"'"); 				

	 				}
				}
	 			String transaDate = objGlobal.funGetCurrentDateTime("dd-MM-yyyy").split(" ")[0];

			    String strMainBillNo = objGlobal.funGeneratePMSDocumentCode("frmBillHd", transaDate, req);
					
	 			boolean flagForIsSplitBill=true;
			    if(mapRevenueType.size() > 1)
			    {
			    	flagForIsSplitBill=false;//Bill is splited
			    }
			    
			    String strAllSplitedBills="";
			    
	 			for (Map.Entry<String,String> entry : mapRevenueType.entrySet())  
	 			{
	 	           
	 					String strRevenueType=entry.getValue(); 
	 					
	 					//billNo=billNo+"-"+entry.getKey();
	 					String billNo="";
	 					if(flagForIsSplitBill)
	 					{
	 						billNo=strMainBillNo;
	 					}
	 					else
	 					{
	 						billNo=strMainBillNo+"-"+entry.getKey();
	 					}
	 					if(strAllSplitedBills.isEmpty())
	 					{
	 						strAllSplitedBills=billNo;
	 					}
	 					else
	 					{
	 						strAllSplitedBills=strAllSplitedBills+"#"+billNo;
	 					}
	 					for (int i = 0; i < listCheckOutRoomDtlBeans.size(); i++) {
	 			            clsCheckOutRoomDtlBean objCheckOutRoomDtlBean = listCheckOutRoomDtlBeans.get(i);
	 						if(objCheckOutRoomDtlBean.getStrRemoveTax()==null)
	 						{
	 							objCheckOutRoomDtlBean.setStrRemoveTax("N");
	 						}
	 						
	  						clsFolioHdModel objFolioHdModel = objCheckOutService.funGetFolioHdModel(objCheckOutRoomDtlBean.getStrRoomNo(), objCheckOutRoomDtlBean.getStrRegistrationNo(), "", clientCode); 						
	 						if(objCheckOutRoomDtlBean.getStrRemoveTax().equals("Y"))
	 						{
	 							String sqlDeleteTaxes = "delete from tblfoliotaxdtl where strFolioNo='"+objFolioHdModel.getStrFolioNo()+"' and strClientCode='"+clientCode+"'";
	 							objWebPMSUtility.funExecuteUpdate(sqlDeleteTaxes, "sql");	

	 						}
	 							
	 							if (objFolioHdModel != null) {
	 								
	 								double balanceForPaymentCheck=0.00;
	 								
	 						
			 					
			 						     // generate billNo.
			 								
			 								
			 								                                                                        RommNo = objFolioHdModel.getStrRoomNo();
			 								clsBillHdModel objBillHdModel = new clsBillHdModel();
			 								
			 								List listBillNoCheck=new ArrayList<>();
			 								/*String sqlBillNoCheck = "select a.strBillNo,date(a.dteBillDate) from tblbillhd a where a.strFolioNo='"+objFolioHdModel.getStrFolioNo()+"' and a.strClientCode='"+clientCode+"'";
			 								
			 								List listBillNoCheck= objGlobalFunctionsService.funGetListModuleWise(sqlBillNoCheck, "sql");
			 			 					if(listBillNoCheck!=null && listBillNoCheck.size()>0)
			 								{
			 									Object[] arr = (Object[]) listBillNoCheck.get(0);
			 									billNo = arr[0].toString();
			 									PMSDate = arr[1].toString();
			 								}*/

			 								objBillHdModel.setStrBillNo(billNo);
			 								objBillHdModel.setDteBillDate(PMSDate);
			 								objBillHdModel.setStrClientCode(clientCode);
			 								objBillHdModel.setStrCheckInNo(objFolioHdModel.getStrCheckInNo());
			 								objBillHdModel.setStrFolioNo(objFolioHdModel.getStrFolioNo());
			 								strFolioNo=objFolioHdModel.getStrFolioNo();
			 								objBillHdModel.setStrRoomNo(objFolioHdModel.getStrRoomNo());
			 								objBillHdModel.setStrExtraBedCode(objFolioHdModel.getStrExtraBedCode());
			 								objBillHdModel.setStrRegistrationNo(objFolioHdModel.getStrRegistrationNo());
			 								objBillHdModel.setStrReservationNo(objFolioHdModel.getStrReservationNo());
			 								objBillHdModel.setDblGrandTotal(0.00);
			 								objBillHdModel.setStrUserCreated(userCode);
			 								objBillHdModel.setStrUserEdited(userCode);
			 								objBillHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			 								objBillHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			 								objBillHdModel.setStrGSTNo(GSTNo);
			 								objBillHdModel.setStrCompanyName(companyName);
			 								objBillHdModel.setStrGuestCode(objFolioHdModel.getStrGuestCode());

			 								double grandTotal = 0;

			 								List<clsBillDtlModel> listBillDtlModel = new ArrayList<clsBillDtlModel>();
			 							
			 								//List<clsFolioDtlModel> listFolioDtlModel = objFolioHdModel.getListFolioDtlModel();Commented code before below implementation
			 								String strRevenueTypeCode="";
			 								
			 								String sqlFolioDtlRevenueWise=" select * from tblfoliodtl a where a.strFolioNo='"+strFolioNo+"' "
			 										         + " and a.strRevenueType in ("+strRevenueType+");";
			 								List listFolioDtlRevenueWise = objGlobalFunctionsService.funGetListModuleWise(sqlFolioDtlRevenueWise, "sql");
			 			 					if(listFolioDtlRevenueWise!=null && listFolioDtlRevenueWise.size()>0)
			 								{
			 			 						for(int k=0;k<listFolioDtlRevenueWise.size();k++)
			 			 						{
			 	 									Object[] arrFolioDtlRevenueWise = (Object[]) listFolioDtlRevenueWise.get(k);
			 	 									clsBillDtlModel objBillDtlModel = new clsBillDtlModel();
			 	 									objBillDtlModel.setStrFolioNo(arrFolioDtlRevenueWise[0].toString());
			 	 									objBillDtlModel.setStrDocNo(arrFolioDtlRevenueWise[2].toString());
			 	 									objBillDtlModel.setStrPerticulars(arrFolioDtlRevenueWise[3].toString());
			 	 									objBillDtlModel.setDteDocDate(arrFolioDtlRevenueWise[1].toString());
			 	 									objBillDtlModel.setDblBalanceAmt(Double.parseDouble(arrFolioDtlRevenueWise[6].toString()));
			 	 									objBillDtlModel.setDblCreditAmt(Double.parseDouble(arrFolioDtlRevenueWise[5].toString()));
			 	 									objBillDtlModel.setDblDebitAmt(Double.parseDouble(arrFolioDtlRevenueWise[4].toString()));
			 	 									objBillDtlModel.setStrRevenueType(arrFolioDtlRevenueWise[7].toString());
			 	 									objBillDtlModel.setStrRevenueCode(arrFolioDtlRevenueWise[8].toString());
			 	 									objBillDtlModel.setStrUserEdited(arrFolioDtlRevenueWise[13].toString());
			 	 									objBillDtlModel.setDteDateEdited(arrFolioDtlRevenueWise[11].toString());
			 	 									objBillDtlModel.setStrTransactionType(arrFolioDtlRevenueWise[12].toString());
			 	 									
			 	 									if(strRevenueTypeCode.isEmpty())
													{
														strRevenueTypeCode="'"+arrFolioDtlRevenueWise[2].toString()+"'";
													
													}
													else
													{
														strRevenueTypeCode= strRevenueTypeCode +",'"+arrFolioDtlRevenueWise[2].toString()+"'";
													}
														
														
													grandTotal +=objBillDtlModel.getDblDebitAmt();
			 	 									listBillDtlModel.add(objBillDtlModel);
			 			 						}
			 								}
			 			 					
			 			 					
			 			 					
			 								/*
			 								 * List<clsBillDtlModel> listBillDtlModel = new ArrayList<clsBillDtlModel>();
			 								 * for (clsFolioDtlModel objFolioDtlModel : listFolioDtlModel) {
			 									
			 									clsBillDtlModel objBillDtlModel = new clsBillDtlModel();
												objBillDtlModel.setStrFolioNo(objFolioHdModel.getStrFolioNo());
												objBillDtlModel.setStrDocNo(objFolioDtlModel.getStrDocNo());
												objBillDtlModel.setStrPerticulars(objFolioDtlModel.getStrPerticulars());
												objBillDtlModel.setDteDocDate(objFolioDtlModel.getDteDocDate());
												objBillDtlModel.setDblBalanceAmt(objFolioDtlModel.getDblBalanceAmt());
												objBillDtlModel.setDblCreditAmt(objFolioDtlModel.getDblCreditAmt());
												objBillDtlModel.setDblDebitAmt(objFolioDtlModel.getDblDebitAmt());
												objBillDtlModel.setStrRevenueType(objFolioDtlModel.getStrRevenueType());
												objBillDtlModel.setStrRevenueCode(objFolioDtlModel.getStrRevenueCode());
												objBillDtlModel.setStrUserEdited(objFolioDtlModel.getStrUserEdited());
												objBillDtlModel.setDteDateEdited(objFolioDtlModel.getDteDateEdited());
												objBillDtlModel.setStrTransactionType(objFolioDtlModel.getStrTransactionType());
			 									// setBillDtlModel.add(objBillDtlModel);
			 								}*/
			 			 					
			 			 					
			 			 					
			 								if(listBillNoCheck!=null && listBillNoCheck.size()>0){
			 									String sqlBillDtl = "select * from tblbilldtl a where a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"'";
			 									List listBillDtl= objGlobalFunctionsService.funGetListModuleWise(sqlBillDtl, "sql");
			 									if(listBillDtl!=null && listBillDtl.size()>0)
			 									{
			 										for(int g=0;i<listBillDtl.size();i++)
			 										{
			 											Object[] arr = (Object[]) listBillDtl.get(i);
			 											clsBillDtlModel objBillDtlModel = new clsBillDtlModel();
			 											objBillDtlModel.setStrFolioNo(arr[1].toString());
			 											objBillDtlModel.setStrDocNo(arr[3].toString());
			 											objBillDtlModel.setStrPerticulars(arr[4].toString());
			 											objBillDtlModel.setDteDocDate(arr[2].toString());
			 											objBillDtlModel.setDblBalanceAmt(Double.parseDouble(arr[9].toString()));
			 											objBillDtlModel.setDblCreditAmt(Double.parseDouble(arr[8].toString()));
			 											objBillDtlModel.setDblDebitAmt(Double.parseDouble(arr[7].toString()));
			 											objBillDtlModel.setStrRevenueType(arr[5].toString());
			 											objBillDtlModel.setStrRevenueCode(arr[6].toString());
			 											objBillDtlModel.setStrUserEdited(arr[13].toString());
			 											objBillDtlModel.setDteDateEdited(arr[11].toString());
			 											objBillDtlModel.setStrTransactionType(arr[12].toString());
			 										
			 											
			 											
			 											grandTotal += Double.parseDouble(arr[7].toString());
			 											listBillDtlModel.add(objBillDtlModel);
			 										}
			 										
			 									}

			 								}
			 								DecimalFormat df = new DecimalFormat("0.00");
			 								List<clsBillTaxDtlModel> listBillTaxDtlModel = new ArrayList<clsBillTaxDtlModel>();
			 								
			 								
			 								
			 								List<clsFolioTaxDtl> listFolioTaxDtlModel = objFolioHdModel.getListFolioTaxDtlModel();
			 								String sqlFolioTaxDtlRevenueWise=" select * from tblfoliotaxdtl a where a.strFolioNo='"+strFolioNo+"' "
			 										                       + " and a.strDocNo in ("+strRevenueTypeCode+");";
			 								if(objCheckOutRoomDtlBean.getStrRemoveTax().equals("Y"))
			 								{
			 									
			 								}
			 								else
			 								{
			 									List listFolioTaxDtlRevenueWise = objGlobalFunctionsService.funGetListModuleWise(sqlFolioTaxDtlRevenueWise, "sql");
			 	 			 					if(listFolioTaxDtlRevenueWise!=null && listFolioTaxDtlRevenueWise.size()>0)
			 	 								{
			 	 			 						for(int m=0;m<listFolioTaxDtlRevenueWise.size();m++)
			 	 			 						{
			 	 	 									Object[] arrFolioTaxDtlRevenueWise = (Object[]) listFolioTaxDtlRevenueWise.get(m);
			 	 	 									clsBillTaxDtlModel objBillTaxDtlModel = new clsBillTaxDtlModel();
			 	 	 									objBillTaxDtlModel.setStrDocNo(arrFolioTaxDtlRevenueWise[1].toString());
			 	 	 									objBillTaxDtlModel.setStrTaxCode(arrFolioTaxDtlRevenueWise[2].toString());
			 	 	 									objBillTaxDtlModel.setStrTaxDesc(arrFolioTaxDtlRevenueWise[3].toString());
			 	 	 									objBillTaxDtlModel.setDblTaxableAmt(Double.parseDouble(arrFolioTaxDtlRevenueWise[4].toString()));
			 	 	 									objBillTaxDtlModel.setDblTaxAmt(Double.parseDouble(arrFolioTaxDtlRevenueWise[5].toString()));
			 	 	 									if(!clientCode.equalsIgnoreCase("383.001"))
			 	 	 									{
			 	 	 										grandTotal += objBillTaxDtlModel.getDblTaxAmt();

			 	 	 									}						
			 	 	 									listBillTaxDtlModel.add(objBillTaxDtlModel);
			 	 			 						}
			 	 								}
			 									
			 								   /* for (clsFolioTaxDtl objFolioTaxDtlModel : listFolioTaxDtlModel) {
			 									clsBillTaxDtlModel objBillTaxDtlModel = new clsBillTaxDtlModel();
			 									objBillTaxDtlModel.setStrDocNo(objFolioTaxDtlModel.getStrDocNo());
			 									objBillTaxDtlModel.setStrTaxCode(objFolioTaxDtlModel.getStrTaxCode());
			 									objBillTaxDtlModel.setStrTaxDesc(objFolioTaxDtlModel.getStrTaxDesc());
			 									objBillTaxDtlModel.setDblTaxableAmt(objFolioTaxDtlModel.getDblTaxableAmt());
			 									objBillTaxDtlModel.setDblTaxAmt(objFolioTaxDtlModel.getDblTaxAmt());
			 									if(!clientCode.equalsIgnoreCase("383.001"))
			 									{
			 										grandTotal += objBillTaxDtlModel.getDblTaxAmt();

			 									}						
			 									listBillTaxDtlModel.add(objBillTaxDtlModel);
			 									 }*/
			 									// setBillTaxDtlModel.add(objBillTaxDtlModel);
			 								
			 							   }
			 							objBillHdModel.setStrBillSettled("N");
			 							objBillHdModel.setDblGrandTotal(Double.parseDouble(df.format(grandTotal)));
			 							objBillHdModel.setListBillDtlModels(listBillDtlModel);
			 							objBillHdModel.setListBillTaxDtlModels(listBillTaxDtlModel);
			 							objBillHdModel.setStrRemark("");
			 							objBillHdModel.setStrMergedBillNo("");
			 							
			 							//update guestmaster Balance
			 							String sqlguest;
			 							double closingBal=Double.parseDouble(df.format(grandTotal));
			 							double openingBal=0.00;
			 						  
			 						    
			 						    String sql1="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+objFolioHdModel.getStrGuestCode()+"'";
			 							List guestlist =  objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");;
			 							
			 							if(guestlist!=null && guestlist.size()>0)
			 							{
			 						       openingBal=Double.parseDouble(guestlist.get(0).toString());
			 							}
			 						    
			 						   objBillHdModel.setDblOpeningBalance(openingBal);
			 						   closingBal=openingBal+closingBal;
			 			        	   sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+closingBal+"' where a.strGuestCode='"+objFolioHdModel.getStrGuestCode()+"'";
			 			      		   objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
			 			     		   objBillHdModel.setDblClosingBalance(closingBal);
			 			                  
			 							
			 			               // objBillHdModel.setSetBillDtlModels(setBillDtlModel);
			 							// objBillHdModel.setSetBillTaxDtlModels(setBillTaxDtlModel);
			 							
			 							LocalTime localTime = LocalTime.now();
			 							DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
			 							
			 							String strCurrentTime = localTime.format(dateTimeFormatter);
			 							String sqlUpdateCheckOutTime = "update tblcheckinhd a set a.tmeDepartureTime='"+strCurrentTime+"' where a.strCheckInNo='"+objBillHdModel.getStrCheckInNo()+"'  AND a.strClientCode='"+clientCode+"'";
			 							objWebPMSUtility.funExecuteUpdate(sqlUpdateCheckOutTime, "sql");
			 							
			 							String sqlUpdateCheckOutDate ="UPDATE tblcheckinhd a SET a.dteDepartureDate= CONCAT('"+PMSDate+"',' ','00:00:00') "
			 							+ "WHERE a.strCheckInNo='"+objBillHdModel.getStrCheckInNo()+"' AND a.strClientCode='"+clientCode+"'";
			 							
			 							
			 							objWebPMSUtility.funExecuteUpdate(sqlUpdateCheckOutDate, "sql");
			 							
			 							
			 							
			 							
			 							objCheckOutService.funSaveCheckOut(objFolioHdModel, objBillHdModel);
			 							
			 							clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propCode, clientCode);

			 								if(objPropertySetupModel.getStrEnableHousekeeping().equals("Y"))
			 								{
			 									String sqlRoomUpdate = "update tblroom a set a.strStatus='Dirty' " + " where a.strRoomCode='" + objBillHdModel.getStrRoomNo() + "' and a.strClientCode='" + objBillHdModel.getStrClientCode() + "'";
			 									/*webPMSSessionFactory.getCurrentSession().createSQLQuery(sql).executeUpdate();*/
			 									objWebPMSUtility.funExecuteUpdate(sqlRoomUpdate, "sql");
			 									
			 								}
			 								else
			 								{
			 									String sqlRoomUpdate = "update tblroom a set a.strStatus='Free' " + " where a.strRoomCode='" + objBillHdModel.getStrRoomNo() + "' and a.strClientCode='" + objBillHdModel.getStrClientCode() + "'";
			 									/*webPMSSessionFactory.getCurrentSession().createSQLQuery(sql).executeUpdate();*/
			 									objWebPMSUtility.funExecuteUpdate(sqlRoomUpdate, "sql");
			 									
			 								}
			 								
			 								String sqlBillPerticulars = "select a.strPerticulars from tblbilldtl a where a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"'";
			 								List listCheckForFullPayment= objGlobalFunctionsService.funGetListModuleWise(sqlBillPerticulars, "sql");
			 								String strParticulars = "";
			 								for(int j=0;j<listCheckForFullPayment.size();j++)
			 								{
			 									strParticulars = strParticulars+listCheckForFullPayment.get(j).toString()+",";
			 								}
			 								strParticulars=strParticulars.substring(0,strParticulars.length()-1);
			 								
			 								
			 							//Commented before new logic
			 							//objBillPrintingController.funGenerateBillPrintingReport(PMSDate, PMSDate, billNo, strParticulars, req, resp); 
			 	 							funSendSMSPayment(billNo, clientCode, RommNo, propCode);
			 	 							clsPropertySetupHdModel objModel1 = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
				 							if(objModel.getStrOnlineIntegration().equalsIgnoreCase("Yes"))
				 							{
				 								funCallAPI(objModel1,clientCode,PMSDate);
				 							}
				 							
				 							
				 							
				 							req.getSession().setAttribute("success", true);
				 							req.getSession().setAttribute("successMessage", "Room No. : ".concat(objBean.getStrSearchTextField()));
				 							flag=true;
			 								
			 							
	 								
			 							
		 							}
	 								
}
	 					
	 					
	 			} 
	 			if(flag)
	 			{
	 				String sql = "insert into tblfoliobckp (select * from tblfoliodtl where strFolioNo='"+strFolioNo+"' AND strclientCode='"+clientCode+"')";
	 			    objWebPMSUtility.funExecuteUpdate(sql, "sql");
	 					
	 	 			String sqlDeleteTaxes = "delete from tblfoliohd where strFolioNo='"+strFolioNo+"' and strClientCode='"+clientCode+"'";
	 				objWebPMSUtility.funExecuteUpdate(sqlDeleteTaxes, "sql");	
	 				
	 				sqlDeleteTaxes = "delete from tblfoliodtl where strFolioNo='"+strFolioNo+"' and strClientCode='"+clientCode+"'";
	 				objWebPMSUtility.funExecuteUpdate(sqlDeleteTaxes, "sql");	
	 				
	 				sqlDeleteTaxes = "delete from tblfoliotaxdtl where strFolioNo='"+strFolioNo+"' and strClientCode='"+clientCode+"'";
	 				objWebPMSUtility.funExecuteUpdate(sqlDeleteTaxes, "sql");	
	 			}
	 			req.getSession().setAttribute("successForSplitBill", true);
				req.getSession().setAttribute("successMessageForSplitBill",strAllSplitedBills);
				
	 			
				return new ModelAndView("redirect:/frmCheckOut.html?saddr=" + urlHits);
			} 
			else {
				return new ModelAndView("redirect:/frmCheckOut.html?saddr=" + urlHits);
			}

		}
		
}
	
	@RequestMapping(value = "/isCheckFolioStatus", method = RequestMethod.GET)
	public @ResponseBody boolean funIsCheckFolioStatus(@RequestParam("folioNo") String strFolioNo,@RequestParam("checkOutDate") String checkOutDate, HttpServletRequest req)
	{
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		boolean checkFolioStatus=true;
		String sql = " select TIME_FORMAT(SYSDATE(),'%H:%i%p')from DUAL";
		List listCheckFolio = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		String tmeCheckoutTime = "";
		String strTimeDiff =  "";
		if(listCheckFolio.size()>0)
		{
			tmeCheckoutTime = listCheckFolio.get(0).toString();
		}
		clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
		if(tmeCheckoutTime.contains("PM"))
		{
			checkFolioStatus=false;
		}
				
		
		return checkFolioStatus;
	}
	

	@RequestMapping(value = "/isPendingRoomTerrif", method = RequestMethod.POST)
	public @ResponseBody boolean funIsPendingRoomTerrif(@RequestParam("roomCode") String roomCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		boolean res = false;
		String PMSCheckOutTime = req.getSession().getAttribute("PMSCheckOutTime").toString();
		String[] time = PMSCheckOutTime.split(":");
		int hr = Integer.parseInt(time[0]);
		int min = Integer.parseInt(time[1]);
		int sec = Integer.parseInt(time[2]);
		Date dtCurrentDate = new Date();
		Date dtCheckOutDate = new Date(dtCurrentDate.getYear(), dtCurrentDate.getMonth(), dtCurrentDate.getDate(), hr, min, sec);
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());

		long diff = objGlobal.funCompareTime(dtCheckOutDate, dtCurrentDate);
		System.out.println(diff);
		if (diff < 0) {
			String sql = "select b.strDocNo " + " from tblfoliohd a,tblfoliodtl b " + " where a.strFolioNo=b.strFolioNo and a.strRoomNo='" + roomCode + "' and date(dteDocDate)='" + PMSDate + "' " + " and b.strRevenueType='Room' and a.strClientCode='" + clientCode + "' ";
			List listRoomTerrif = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (listRoomTerrif.size() == 0) {
				res = true;
			}
		}
		return res;
	}

	private void funSendSMSPayment(String billNo, String clientCode, String roomNo, String propCode) {

		String strMobileNo = "";
		clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propCode, clientCode);

		List listcheckOut = objCheckOutService.funGetCheckOut(roomNo, billNo, clientCode);

		clsBillHdModel objBillHdModel = (clsBillHdModel) listcheckOut.get(0);
		List listDtl = objBillHdModel.getListBillDtlModels();
		// clsBillDtlModel dtlModel=(clsBillDtlModel) listDtl.get(0);
		clsCheckInHdModel objHdModel = objCheckInService.funGetCheckInData(objBillHdModel.getStrCheckInNo(), clientCode);

		List listcheckDtl = objHdModel.getListCheckInDtl();

		for (int i = 0; i < listcheckDtl.size(); i++) {
			clsCheckInDtl obkCheckInDtl = (clsCheckInDtl) listcheckDtl.get(i);

			if (obkCheckInDtl.getStrPayee().equalsIgnoreCase("Y")) {
				List list1 = objGuestService.funGetGuestMaster(obkCheckInDtl.getStrGuestCode(), clientCode);
				clsGuestMasterHdModel objGuestModel = null;

				if (list1.size() > 0) {
					objGuestModel = (clsGuestMasterHdModel) list1.get(0);

				}

				String smsAPIUrl = objSetup.getStrSMSAPI();

				String smsContent = objSetup.getStrCheckOutSMSContent();

				if (!smsAPIUrl.equals("")) {
					if (smsContent.contains("%%CompanyName")) {
						List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
						smsContent = smsContent.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName());
					}
					if (smsContent.contains("%%PropertyName")) {
						clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
						smsContent = smsContent.replace("%%PropertyName", objProperty.getPropertyName());
					}

					if (smsContent.contains("%%billNo")) {
						smsContent = smsContent.replace("%%billNo", billNo);
					}

					if (smsContent.contains("%%Checkoutdate")) {
						smsContent = smsContent.replace("%%Checkoutdate", objBillHdModel.getDteBillDate());
					}
					if (smsContent.contains("%%GuestName")) {
						smsContent = smsContent.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
					}

					if (smsContent.contains("%%RoomNo")) {
						clsRoomMasterModel roomNo1 = objRoomMaster.funGetRoomMaster(obkCheckInDtl.getStrRoomNo(), clientCode);
						smsContent = smsContent.replace("%%RoomNo", roomNo1.getStrRoomDesc());
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
	
	@RequestMapping(value = "/frmCheckOut1", method = RequestMethod.GET)
	public ModelAndView funOpenForm1(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String strFolioNo = request.getParameter("docCode").toString();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String strRoomNo="";
		String sqlRoomNo = "select a.strRoomNo from tblfoliohd a where a.strFolioNo='"+strFolioNo+"' and a.strClientCode='"+clientCode+"'";
		List listRoomNo = objGlobalFunctionsService.funGetListModuleWise(sqlRoomNo, "sql");
		if(listRoomNo!=null && listRoomNo.size()>0)
		{
			strRoomNo = listRoomNo.get(0).toString();
		}
		try {
			urlHits = request.getParameter("saddr").toString();

		} catch (NullPointerException e) {
			urlHits = "1";
		}

		model.put("urlHits", urlHits);

		request.getSession().setAttribute("checkOutNo", strRoomNo);

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckOut_1", "command", new clsCheckOutBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckOut", "command", new clsCheckOutBean());
		} else {
			return null;
		}
	}
	private void funCallAPI(clsPropertySetupHdModel objModel,String clientCode,String pmsDate) 
	{
		try
		{
			JSONObject jobj= new JSONObject();
			JSONArray jArray = new JSONArray();
			String isoDatePattern = "yyyy-MM-dd'T'HH:mm:ss'Z'";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(isoDatePattern);
			String sqlRoomInvData = "select a.strClientCode ,'SANGUINEPMS' as OTA_Name ,a.strRoomTypeCode,a.strRateContractID,count(b.strRoomCode) from tblpmsratecontractdtl a "
					+ "left outer join  tblroom b on a.strRoomTypeCode=b.strRoomTypeCode where b.strStatus='Free' and a.strClientCode='"+clientCode+"' "
					+ "group by a.strRoomTypeCode ";
			List listRoomInvData = objGlobalFunctionsService.funGetListModuleWise(sqlRoomInvData, "sql");
			if(listRoomInvData!=null && listRoomInvData.size()>0)
			{
				for(int i=0;i<listRoomInvData.size();i++)
				{
					Object [] objArray = (Object[]) listRoomInvData.get(i);
					jobj.put("HotelId", objArray[0].toString());
					jobj.put("OTACode", objArray[1].toString());
					
					JSONObject jRoomObj  = new JSONObject();
					jRoomObj.put("RoomId", objArray[2].toString());
					jRoomObj.put("RateplanId", objArray[3].toString());
					Date date1=new SimpleDateFormat("yyyy-MM-dd").parse(pmsDate);  
					Date date2=new SimpleDateFormat("yyyy-MM-dd").parse(pmsDate);
					jRoomObj.put("FromDate", simpleDateFormat.format(date1));
					jRoomObj.put("ToDate", simpleDateFormat.format(date2));
					jRoomObj.put("Inventory", objArray[4].toString());
					jArray.add(jRoomObj);
					
				}
				jobj.put("Rooms", jArray);
				
				funCallingToRestAPI(objModel,jobj);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	public void funCallingToRestAPI(clsPropertySetupHdModel objModel,JSONObject jobj)
	{
		try
		{
			URL obj = new URL("http://"+objModel.getStrIntegrationUrl()+"/MaxiMojoIntegration/MaxiMojoIntegration/funPushInventory");
		    HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
		    postConnection.setDoOutput(true);
		    postConnection.setRequestMethod("POST");
		    postConnection.setRequestProperty("Content-Type", "application/json");
		    
		    OutputStream os = postConnection.getOutputStream();
			os.write(jobj.toJSONString().getBytes());
			os.flush();

			BufferedReader br = new BufferedReader(new InputStreamReader((postConnection.getInputStream())));

			String output="",op="";
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				op+=output;
			}
			System.out.println("Output :: "+op);
			
			/*JSONParser parser = new JSONParser();
		    JSONObject jObjMenuDownloaded = (JSONObject) parser.parse(op);*/

			postConnection.disconnect();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		
	}
	public ModelAndView funGetGroupCheckInBill(clsCheckOutBean objBean, BindingResult result, HttpServletRequest req,HttpServletResponse resp){
	
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
 			urlHits = "1";
		}
	String strFolioNo="";
	boolean checkFolioStatus=false;
	if (!result.hasErrors()) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		List<clsCheckOutRoomDtlBean> listCheckOutRoomDtlBeans = objBean.getListCheckOutRoomDtlBeans();
   		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
		String billNo = "";
			String RommNo = "";
		String GSTNo="";
		String companyName = req.getSession().getAttribute("companyName").toString();
		String propCode = req.getSession().getAttribute("propertyCode").toString();
			clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propCode, clientCode);  //pms property setup
			if (objModel != null) {
				GSTNo=objModel.getStrGSTNo();
		} 
		for (int i = 0; i < listCheckOutRoomDtlBeans.size(); i++) {
        clsCheckOutRoomDtlBean objCheckOutRoomDtlBean = listCheckOutRoomDtlBeans.get(i);
			if(objCheckOutRoomDtlBean.getStrRemoveTax()==null)
			{
				objCheckOutRoomDtlBean.setStrRemoveTax("N");
			}
			
			clsFolioHdModel objFolioHdModel = objCheckOutService.funGetFolioHdModel(objCheckOutRoomDtlBean.getStrRoomNo(), objCheckOutRoomDtlBean.getStrRegistrationNo(), "", clientCode);
			if(objCheckOutRoomDtlBean.getStrRemoveTax().equals("Y"))
			{
				String sqlDeleteTaxes = "delete from tblfoliotaxdtl where strFolioNo='"+objFolioHdModel.getStrFolioNo()+"' and strClientCode='"+clientCode+"'";
				objWebPMSUtility.funExecuteUpdate(sqlDeleteTaxes, "sql");	

			}
			
			if (objFolioHdModel != null) {
				
				
				double balanceForPaymentCheck=0.00;
				if(clientCode.equalsIgnoreCase("383.001"))
					{
						String receiptAmt="a.dblReceiptAmt";
						if(objFolioHdModel.getStrWalkInNo()!=null && objFolioHdModel.getStrWalkInNo().length()>0 )
						{
							receiptAmt="0";
						}
						
						
						String sql="SELECT b.BillAmount - a.receiptamt"
								+ " FROM (SELECT IFNULL(a.receiptAmt,0)+ IFNULL(b.receiptAmt1,0) AS receiptamt"
								+ " FROM ("
								+ " SELECT IFNULL(SUM("+receiptAmt+"),0) AS receiptAmt"
								+ " FROM tblreceipthd a, tblfoliohd b"
								+ "  WHERE a.strReservationNo = b.strReservationNo AND a.strReservationNo = '"+objFolioHdModel.getStrReservationNo()+"'  ) AS a, ("
								+ " SELECT IFNULL(SUM(a.dblReceiptAmt),0) AS receiptAmt1"
								+ " FROM tblreceipthd a, tblfoliohd b "
								+ " WHERE a.strFolioNo = b.strFolioNo AND "
								+ " a.strCheckInNo = b.strCheckInNo AND a.strFolioNo = '"+objFolioHdModel.getStrFolioNo()+"' AND  a.strReservationNo = '') AS b) AS a, ( "
								+ " SELECT SUM(a.dblDebitAmt) AS BillAmount"
								+ " FROM tblfoliodtl a "
								+ " WHERE a.strFolioNo='"+objFolioHdModel.getStrFolioNo()+"') AS b ;";
					 
						List balAmtlist =  objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
						
						if(balAmtlist!=null && balAmtlist.size()>0)
						{
							balanceForPaymentCheck=Double.parseDouble(balAmtlist.get(0).toString());
						}
						
						
					}	
					if(clientCode.equalsIgnoreCase("383.001") && balanceForPaymentCheck > 0 )
					{
						req.getSession().setAttribute("balanceForPaymentCheck", true);
						req.getSession().setAttribute("MessagebalanceForPaymentCheck","Payment is Pending !!!!");
						
			 			
						return new ModelAndView("redirect:/frmCheckOut.html?saddr=" + urlHits);
					}
					else
					{
						// generate billNo.
						String transaDate = objGlobal.funGetCurrentDateTime("dd-MM-yyyy").split(" ")[0];
							billNo = objGlobal.funGeneratePMSDocumentCode("frmBillHd", transaDate, req);
						RommNo = objFolioHdModel.getStrRoomNo();
						clsBillHdModel objBillHdModel = new clsBillHdModel();
						String sqlBillNoCheck = "select a.strBillNo,date(a.dteBillDate) from tblbillhd a where a.strFolioNo='"+objFolioHdModel.getStrFolioNo()+"' and a.strClientCode='"+clientCode+"'";
						
						List listBillNoCheck= objGlobalFunctionsService.funGetListModuleWise(sqlBillNoCheck, "sql");
							if(listBillNoCheck!=null && listBillNoCheck.size()>0)
						{
							Object[] arr = (Object[]) listBillNoCheck.get(0);
							billNo = arr[0].toString();
							PMSDate = arr[1].toString();
						}

						objBillHdModel.setStrBillNo(billNo);
						objBillHdModel.setDteBillDate(PMSDate);
						objBillHdModel.setStrClientCode(clientCode);
						objBillHdModel.setStrCheckInNo(objFolioHdModel.getStrCheckInNo());
						objBillHdModel.setStrFolioNo(objFolioHdModel.getStrFolioNo());
						strFolioNo=objFolioHdModel.getStrFolioNo();
						objBillHdModel.setStrRoomNo(objFolioHdModel.getStrRoomNo());
						objBillHdModel.setStrExtraBedCode(objFolioHdModel.getStrExtraBedCode());
						objBillHdModel.setStrRegistrationNo(objFolioHdModel.getStrRegistrationNo());
						objBillHdModel.setStrReservationNo(objFolioHdModel.getStrReservationNo());
						objBillHdModel.setDblGrandTotal(0.00);
						objBillHdModel.setStrUserCreated(userCode);
						objBillHdModel.setStrUserEdited(userCode);
						objBillHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
						objBillHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
						objBillHdModel.setStrGSTNo(GSTNo);
						objBillHdModel.setStrCompanyName(companyName);
						objBillHdModel.setStrGuestCode(objFolioHdModel.getStrGuestCode());

						double grandTotal = 0;

						List<clsBillDtlModel> listBillDtlModel = new ArrayList<clsBillDtlModel>();
						// Set<clsBillDtlModel> setBillDtlModel=new
						// TreeSet<clsBillDtlModel>();
						List<clsFolioDtlModel> listFolioDtlModel = objFolioHdModel.getListFolioDtlModel();
						for (clsFolioDtlModel objFolioDtlModel : listFolioDtlModel) {
							clsBillDtlModel objBillDtlModel = new clsBillDtlModel();
							objBillDtlModel.setStrFolioNo(objFolioHdModel.getStrFolioNo());
							objBillDtlModel.setStrDocNo(objFolioDtlModel.getStrDocNo());
							objBillDtlModel.setStrPerticulars(objFolioDtlModel.getStrPerticulars());
							objBillDtlModel.setDteDocDate(objFolioDtlModel.getDteDocDate());
							objBillDtlModel.setDblBalanceAmt(objFolioDtlModel.getDblBalanceAmt());
							objBillDtlModel.setDblCreditAmt(objFolioDtlModel.getDblCreditAmt());
							objBillDtlModel.setDblDebitAmt(objFolioDtlModel.getDblDebitAmt());
							objBillDtlModel.setStrRevenueType(objFolioDtlModel.getStrRevenueType());
							objBillDtlModel.setStrRevenueCode(objFolioDtlModel.getStrRevenueCode());
							objBillDtlModel.setStrUserEdited(objFolioDtlModel.getStrUserEdited());
							objBillDtlModel.setDteDateEdited(objFolioDtlModel.getDteDateEdited());
							objBillDtlModel.setStrTransactionType(objFolioDtlModel.getStrTransactionType());
							
							
							
							grandTotal += objFolioDtlModel.getDblDebitAmt();
							listBillDtlModel.add(objBillDtlModel);
							// setBillDtlModel.add(objBillDtlModel);
						}
						if(listBillNoCheck!=null && listBillNoCheck.size()>0){
							String sqlBillDtl = "select * from tblbilldtl a where a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"'";
							List listBillDtl= objGlobalFunctionsService.funGetListModuleWise(sqlBillDtl, "sql");
							if(listBillDtl!=null && listBillDtl.size()>0)
							{
								for(int g=0;i<listBillDtl.size();i++)
								{
									Object[] arr = (Object[]) listBillDtl.get(i);
									clsBillDtlModel objBillDtlModel = new clsBillDtlModel();
									objBillDtlModel.setStrFolioNo(arr[1].toString());
									objBillDtlModel.setStrDocNo(arr[3].toString());
									objBillDtlModel.setStrPerticulars(arr[4].toString());
									objBillDtlModel.setDteDocDate(arr[2].toString());
									objBillDtlModel.setDblBalanceAmt(Double.parseDouble(arr[9].toString()));
									objBillDtlModel.setDblCreditAmt(Double.parseDouble(arr[8].toString()));
									objBillDtlModel.setDblDebitAmt(Double.parseDouble(arr[7].toString()));
									objBillDtlModel.setStrRevenueType(arr[5].toString());
									objBillDtlModel.setStrRevenueCode(arr[6].toString());
									objBillDtlModel.setStrUserEdited(arr[13].toString());
									objBillDtlModel.setDteDateEdited(arr[11].toString());
									objBillDtlModel.setStrTransactionType(arr[12].toString());
									
									
									
									grandTotal += Double.parseDouble(arr[7].toString());
									listBillDtlModel.add(objBillDtlModel);
								}
								
							}

						}
						DecimalFormat df = new DecimalFormat("0.00");
						List<clsBillTaxDtlModel> listBillTaxDtlModel = new ArrayList<clsBillTaxDtlModel>();
						// Set<clsBillTaxDtlModel> setBillTaxDtlModel=new
						// TreeSet<clsBillTaxDtlModel>();
						List<clsFolioTaxDtl> listFolioTaxDtlModel = objFolioHdModel.getListFolioTaxDtlModel();
						if(objCheckOutRoomDtlBean.getStrRemoveTax().equals("Y"))
						{
							
						}
						else
						{
							
						for (clsFolioTaxDtl objFolioTaxDtlModel : listFolioTaxDtlModel) {
							clsBillTaxDtlModel objBillTaxDtlModel = new clsBillTaxDtlModel();
							objBillTaxDtlModel.setStrDocNo(objFolioTaxDtlModel.getStrDocNo());
							objBillTaxDtlModel.setStrTaxCode(objFolioTaxDtlModel.getStrTaxCode());
							objBillTaxDtlModel.setStrTaxDesc(objFolioTaxDtlModel.getStrTaxDesc());
							objBillTaxDtlModel.setDblTaxableAmt(objFolioTaxDtlModel.getDblTaxableAmt());
							objBillTaxDtlModel.setDblTaxAmt(objFolioTaxDtlModel.getDblTaxAmt());
							if(!clientCode.equalsIgnoreCase("383.001"))
							{
								grandTotal += objBillTaxDtlModel.getDblTaxAmt();

							}
							
							
							listBillTaxDtlModel.add(objBillTaxDtlModel);
							// setBillTaxDtlModel.add(objBillTaxDtlModel);
						 }
					   }
						objBillHdModel.setStrBillSettled("N");
						objBillHdModel.setDblGrandTotal(Double.parseDouble(df.format(grandTotal)));
						objBillHdModel.setListBillDtlModels(listBillDtlModel);
						objBillHdModel.setListBillTaxDtlModels(listBillTaxDtlModel);
						objBillHdModel.setStrRemark("");
						objBillHdModel.setStrMergedBillNo("");
						
						//update guestmaster Balance
						String sqlguest;
							double closingBal=Double.parseDouble(df.format(grandTotal));
						double openingBal=0.00;
					  
					    
					    String sql1="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+objFolioHdModel.getStrGuestCode()+"'";
						List guestlist =  objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");;
						
						if(guestlist!=null && guestlist.size()>0)
						{
					       openingBal=Double.parseDouble(guestlist.get(0).toString());
						}
					    
					   objBillHdModel.setDblOpeningBalance(openingBal);
					   closingBal=openingBal+closingBal;
		        	   sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+closingBal+"' where a.strGuestCode='"+objFolioHdModel.getStrGuestCode()+"'";
		      		   objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
		     		   objBillHdModel.setDblClosingBalance(closingBal);
		                  
						
		               // objBillHdModel.setSetBillDtlModels(setBillDtlModel);
						// objBillHdModel.setSetBillTaxDtlModels(setBillTaxDtlModel);
						
						LocalTime localTime = LocalTime.now();
						DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
						
						String strCurrentTime = localTime.format(dateTimeFormatter);
						String sqlUpdateCheckOutTime = "update tblcheckinhd a set a.tmeDepartureTime='"+strCurrentTime+"' where a.strCheckInNo='"+objBillHdModel.getStrCheckInNo()+"'  AND a.strClientCode='"+clientCode+"'";
						objWebPMSUtility.funExecuteUpdate(sqlUpdateCheckOutTime, "sql");
						
						String sqlUpdateCheckOutDate ="UPDATE tblcheckinhd a SET a.dteDepartureDate= CONCAT('"+PMSDate+"',' ','00:00:00') "
						+ "WHERE a.strCheckInNo='"+objBillHdModel.getStrCheckInNo()+"' AND a.strClientCode='"+clientCode+"'";
						
						
						objWebPMSUtility.funExecuteUpdate(sqlUpdateCheckOutDate, "sql");
						
						String sql = "insert into tblfoliobckp (select * from tblfoliodtl where strFolioNo='"+objFolioHdModel.getStrFolioNo()+"' AND strclientCode='"+clientCode+"')";
						objWebPMSUtility.funExecuteUpdate(sql, "sql");
						
						
						objCheckOutService.funSaveCheckOut(objFolioHdModel, objBillHdModel);
						objCheckOutService.funDeleteFolioHdModel(objFolioHdModel);
						
						clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propCode, clientCode);

						if(objPropertySetupModel.getStrEnableHousekeeping().equals("Y"))
						{
							String sqlRoomUpdate = "update tblroom a set a.strStatus='Dirty' " + " where a.strRoomCode='" + objBillHdModel.getStrRoomNo() + "' and a.strClientCode='" + objBillHdModel.getStrClientCode() + "'";
							/*webPMSSessionFactory.getCurrentSession().createSQLQuery(sql).executeUpdate();*/
							objWebPMSUtility.funExecuteUpdate(sqlRoomUpdate, "sql");
							
						}
						else
						{
							String sqlRoomUpdate = "update tblroom a set a.strStatus='Free' " + " where a.strRoomCode='" + objBillHdModel.getStrRoomNo() + "' and a.strClientCode='" + objBillHdModel.getStrClientCode() + "'";
							/*webPMSSessionFactory.getCurrentSession().createSQLQuery(sql).executeUpdate();*/
							objWebPMSUtility.funExecuteUpdate(sqlRoomUpdate, "sql");
							
						}
						
						String sqlBillPerticulars = "select a.strPerticulars from tblbilldtl a where a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"'";
						List listCheckForFullPayment= objGlobalFunctionsService.funGetListModuleWise(sqlBillPerticulars, "sql");
						String strParticulars = "";
						for(int j=0;j<listCheckForFullPayment.size();j++)
						{
							strParticulars = strParticulars+listCheckForFullPayment.get(j).toString()+",";
						}
						strParticulars=strParticulars.substring(0,strParticulars.length()-1);
						
						
						objBillPrintingController.funGenerateBillPrintingReport(PMSDate, PMSDate, billNo, strParticulars, req, resp);
					}
			
			
				
 
				
			}
			//funSendSMSPayment(billNo, clientCode, RommNo, propCode);
			clsPropertySetupHdModel objModel1 = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
			if(objModel.getStrOnlineIntegration().equalsIgnoreCase("Yes"))
			{
				funCallAPI(objModel1,clientCode,PMSDate);
			}
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Room No. : ".concat(objBean.getStrSearchTextField()));
		}
		return new ModelAndView("redirect:/frmCheckOut.html?saddr=" + urlHits);
	} else {
		return new ModelAndView("redirect:/frmCheckOut.html?saddr=" + urlHits);
	}
}
}
