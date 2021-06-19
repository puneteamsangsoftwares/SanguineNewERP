package com.sanguine.webpms.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import net.sf.jasperreports.engine.JRException;
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

import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.controller.clsSendEmailController;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.model.clsPropertyMaster;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsPropertyMasterService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.util.clsClientDetails;
import com.sanguine.webpms.bean.clsCheckInBean;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.bean.clsReservationBean;
import com.sanguine.webpms.bean.clsReservationDetailsBean;
import com.sanguine.webpms.dao.clsExtraBedMasterDao;
import com.sanguine.webpms.dao.clsGuestMasterDao;
import com.sanguine.webpms.dao.clsIncomeHeadMasterDao;
import com.sanguine.webpms.dao.clsRoomTypeMasterDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsExtraBedMasterModel;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsPackageMasterDtl;
import com.sanguine.webpms.model.clsPackageMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.model.clsReservationDtlModel;
import com.sanguine.webpms.model.clsReservationHdModel;
import com.sanguine.webpms.model.clsReservationRoomRateModelDtl;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsRoomPackageDtl;
import com.sanguine.webpms.model.clsRoomTypeMasterModel;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPropertySetupService;
import com.sanguine.webpms.service.clsReservationService;
import com.sanguine.webpms.service.clsRoomMasterService;

@Controller
public class clsReservationController {

	@Autowired
	private clsReservationService objReservationService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsGuestMasterService objGuestMasterService;

	@Autowired
	private clsGuestMasterDao objGuestMasterDao;

	@Autowired
	private clsRoomMasterService objRoomMasterService;

	@Autowired
	private clsExtraBedMasterDao objExtraBedMasterDao;

	@Autowired
	private clsPropertySetupService objPropertySetupService;

	@Autowired
	private clsGuestMasterService objGuestService;

	@Autowired
	private clsPropertyMasterService objPropertyMasterService;

	@Autowired
	clsRoomMasterService objRoomMaster;
	
	@Autowired
	private clsIncomeHeadMasterDao objIncomeHeadMasterDao;
	
	@Autowired
	private clsRoomTypeMasterDao objRoomTypeMasterDao;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	private intfBaseService objBaseService;
	
	@Autowired
	private clsSendEmailController objSendEmail;
	
	@Autowired
	private clsSetupMasterService objSetupMasterService;
	
	@Autowired
	private ServletContext servletContext;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.setAutoGrowCollectionLimit(1000000);
	}
	// Open Reservation
	@RequestMapping(value = "/frmReservation", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
		List listOfProperty = objGlobalFunctionsService.funGetList("select strPropertyName from "+webStockDB+".tblpropertymaster where strPropertyCode='" + propCode + "' ");
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		model.put("listOfProperty", listOfProperty);

		model.put("urlHits", urlHits);
		clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
		
		String tmeCheckOutTime = objModel.getTmeCheckOutTime();
		model.put("tmeCheckOutPropertySetupTime", tmeCheckOutTime);

//		clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
//		String noOfRoom = objPropertySetupModel.getStrRoomLimit();
//		
//		model.put("noOfRoom", noOfRoom);
		
		request.getSession().setAttribute("TempPMSDateForReservation",request.getSession().getAttribute("PMSDate").toString());

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmReservation_1", "command", new clsReservationBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmReservation", "command", new clsReservationBean());
		} else {
			return null;
		}
	}

	@RequestMapping(value = "/frmReservation1", method = RequestMethod.GET)
	public ModelAndView funOpenForm1(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String reservationNo = request.getParameter("docCode").toString();
		String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
		String strRoomNo = request.getParameter("roomNo").toString();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		int rootIndex = Integer.parseInt(request.getParameter("rootIndex").toString())-1;
		String strPMSDate=request.getSession().getAttribute("PMSDate").toString();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		String strRoomCode = funGetRoomCode(strRoomNo,clientCode);
		try
		{
			Date date1=new SimpleDateFormat("dd-MM-yyyy").parse(strPMSDate);
			Calendar c = Calendar.getInstance();
			c.setTime(date1);
			c.add(Calendar.DAY_OF_MONTH, rootIndex);
			String newDate = sdf.format(c.getTime()); 
			request.getSession().setAttribute("TempPMSDateForReservation", newDate);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		
		try 
		{
			urlHits = request.getParameter("saddr").toString();
		} catch (Exception e) {
			urlHits = "1";
		}

		List listOfProperty = objGlobalFunctionsService.funGetList("select strPropertyName from "+webStockDB+".tblpropertymaster");
		model.put("listOfProperty", listOfProperty);

		model.put("urlHits", urlHits);

		request.getSession().setAttribute("ResNo", reservationNo);
		request.getSession().setAttribute("RoomCode", strRoomCode);

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmReservation_1", "command", new clsReservationBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmReservation", "command", new clsReservationBean());
		} else {
			return null;
		}
	}

	private String funGetRoomCode(String strRoomNo, String clientCode) {
		String strRoomCode = "";
		String sqlRoomCode = "select a.strRoomCode from tblroom a where a.strRoomDesc='"+strRoomNo+"' and a.strClientCode='"+clientCode+"'";
		List listRoomCode = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCode, "sql");
		if(listRoomCode!=null && listRoomCode.size()>0)
		{
			strRoomCode = listRoomCode.get(0).toString();
		}
		return strRoomCode;
	}

	// Load Header Table Data On Form
	@RequestMapping(value = "/loadReservation", method = RequestMethod.GET)
	public @ResponseBody clsReservationBean funLoadHdData(HttpServletRequest request) {

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String reservationNo = request.getParameter("docCode").toString();
		clsReservationHdModel objReservationModel = objReservationService.funGetReservationList(reservationNo, clientCode, propCode);

		clsReservationBean objBean = new clsReservationBean();
		objBean.setStrReservationNo(objReservationModel.getStrReservationNo());

		objBean.setStrRemarks(objReservationModel.getStrRemarks());
		objBean.setStrAgentCode(objReservationModel.getStrAgentCode());
		objBean.setStrBillingInstCode(objReservationModel.getStrBillingInstCode());
		objBean.setStrBookerCode(objReservationModel.getStrBookerCode());

		objBean.setStrBookingTypeCode(objReservationModel.getStrBookingTypeCode());
		objBean.setStrBusinessSourceCode(objReservationModel.getStrBusinessSourceCode());
		objBean.setStrCancelReservation(objReservationModel.getStrCancelReservation());
		objBean.setStrContactPerson(objReservationModel.getStrContactPerson());

		objBean.setStrCorporateCode(objReservationModel.getStrCorporateCode());
		objBean.setStrEmailId(objReservationModel.getStrEmailId());
		objBean.setStrPropertyCode(objReservationModel.getStrPropertyCode());

		objBean.setStrPayeeGuestCode(objReservationModel.getStrGuestcode());
		objBean.setStrNoRoomsBooked(objReservationModel.getStrNoRoomsBooked());
		/*
		 * objBean.setStrGuestCode(objReservationModel.getStrGuestCode()); String
		 * sql=
		 * "select strGuestPrefix,strFirstName,strMiddleName,strLastName from tblguestmaster where strGuestCode='"
		 * +objReservationModel.getStrGuestCode()+"'"; List
		 * list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		 * 
		 * if(list.size()>0) { Object[] arrObjGuestInfo=(Object[])list.get(0);
		 * objBean.setStrGuestPrefix(arrObjGuestInfo[0].toString());
		 * objBean.setStrFirstName(arrObjGuestInfo[1].toString());
		 * objBean.setStrMiddleName(arrObjGuestInfo[2].toString());
		 * objBean.setStrLastName(arrObjGuestInfo[3].toString()); } else {
		 * objBean.setStrGuestPrefix(""); objBean.setStrFirstName("");
		 * objBean.setStrMiddleName(""); objBean.setStrLastName(""); }
		 */

		objBean.setStrRemarks(objReservationModel.getStrRemarks());
		objBean.setIntNoOfNights(objReservationModel.getIntNoOfNights());
		objBean.setIntNoRoomsBooked(Integer.parseInt(objReservationModel.getStrNoRoomsBooked()));
		objBean.setIntNoOfAdults(objReservationModel.getIntNoOfAdults());
		objBean.setDteArrivalDate(objGlobal.funGetDate("yyyy/MM/dd", objReservationModel.getDteArrivalDate()));

		objBean.setDteDepartureDate(objGlobal.funGetDate("yyyy/MM/dd", objReservationModel.getDteDepartureDate()));
		objBean.setDteCancelDate(objGlobal.funGetDate("yyyy/MM/dd", objReservationModel.getDteCancelDate()));
		objBean.setDteConfirmDate(objGlobal.funGetDate("yyyy/MM/dd", objReservationModel.getDteConfirmDate()));
		objBean.setTmeArrivalTime(objReservationModel.getTmeArrivalTime());
		objBean.setTmeDepartureTime(objReservationModel.getTmeDepartureTime());
		objBean.setStrOTANo(objReservationModel.getStrOTANo());
		objBean.setStrMarketSourceCode(objReservationModel.getStrMarketSourceCode());
		objBean.setStrIncomeHeadCode(objReservationModel.getStrIncomeHeadCode());
		objBean.setTmePickUpTime(objReservationModel.getTmePickUpTime());
		objBean.setTmeDropTime(objReservationModel.getTmeDropTime());
		objBean.setStrDontApplyTax(objReservationModel.getStrDontApplyTax());
		objBean.setStrBillToCorporate(objReservationModel.getStrBillToCorporate());
		objBean.setStrExternalNo(objReservationModel.getStrExternalNo());
		objBean.setStrPlanCode(objReservationModel.getStrPlanCode());
		objBean.setStrGroupCode(objGlobal.funIfNull(objReservationModel.getStrGroupCode(),"",objReservationModel.getStrGroupCode()));
		clsRoomMasterModel objRoomMasterModel = objRoomMasterService.funGetRoomMaster(objReservationModel.getStrRoomNo(), clientCode);
		objBean.setStrRoomNo(objReservationModel.getStrRoomNo());
		if (objRoomMasterModel != null) {
			objBean.setStrRoomDesc(objRoomMasterModel.getStrRoomDesc());
		} else {
			objBean.setStrRoomDesc("");
		}
		

		if (!objReservationModel.getStrExtraBedCode().isEmpty()) {
			List listExtraBedData = objExtraBedMasterDao.funGetExtraBedMaster(objReservationModel.getStrExtraBedCode(), clientCode);
			clsExtraBedMasterModel objExtraBedMasterModel = (clsExtraBedMasterModel) listExtraBedData.get(0);
			objBean.setStrExtraBedCode(objReservationModel.getStrExtraBedCode());
			objBean.setStrExtraBedDesc(objExtraBedMasterModel.getStrExtraBedTypeDesc());
		} else {
			objBean.setStrExtraBedCode("");
			objBean.setStrExtraBedDesc("");
		}
		objBean.setIntNoOfAdults(objReservationModel.getIntNoOfAdults());
		objBean.setIntNoOfChild(objReservationModel.getIntNoOfChild());

		String sql = "";
		List<clsReservationDetailsBean> listResDetailsBean = new ArrayList<clsReservationDetailsBean>();
		for (clsReservationDtlModel objResDtlModel : objReservationModel.getListReservationDtlModel()) {
			clsReservationDetailsBean objReservationDtlBean = new clsReservationDetailsBean();
			objReservationDtlBean.setStrGuestCode(objResDtlModel.getStrGuestCode());
			objReservationDtlBean.setStrPayee(objResDtlModel.getStrPayee());
			objReservationDtlBean.setStrRemark(objResDtlModel.getStrRemark());

			sql = "select strFirstName,strMiddleName,strLastName,lngMobileNo,strAddress from tblguestmaster " + " where strGuestCode='" + objResDtlModel.getStrGuestCode() + "' and strClientCode='" + clientCode + "' ";
			List listGuestMaster = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			for (int cnt = 0; cnt < listGuestMaster.size(); cnt++) {
				Object[] arrObjGuest = (Object[]) listGuestMaster.get(cnt);
				String guestName = arrObjGuest[0] + " " + arrObjGuest[1] + " " + arrObjGuest[2];
				objReservationDtlBean.setStrGuestName(guestName);
				objReservationDtlBean.setLngMobileNo(Long.parseLong(arrObjGuest[3].toString()));
				objReservationDtlBean.setStrAddress(arrObjGuest[4].toString());
			}

			objReservationDtlBean.setStrGuestCode(objResDtlModel.getStrGuestCode());

			clsRoomMasterModel objRoomMasterModel1 = objRoomMasterService.funGetRoomMaster(objResDtlModel.getStrRoomNo(), clientCode);
			if (objRoomMasterModel1 != null) {
				objReservationDtlBean.setStrRoomNo(objResDtlModel.getStrRoomNo());
				objReservationDtlBean.setStrRoomDesc(objRoomMasterModel1.getStrRoomDesc());
			} else {
				objReservationDtlBean.setStrRoomNo("");
				objReservationDtlBean.setStrRoomDesc("");
			}

			if (!objResDtlModel.getStrExtraBedCode().isEmpty()) {
				List listExtraBedData = objExtraBedMasterDao.funGetExtraBedMaster(objResDtlModel.getStrExtraBedCode(), clientCode);
				clsExtraBedMasterModel objExtraBedMasterModel = (clsExtraBedMasterModel) listExtraBedData.get(0);
				objReservationDtlBean.setStrExtraBedCode(objResDtlModel.getStrExtraBedCode());
				objReservationDtlBean.setStrExtraBedDesc(objExtraBedMasterModel.getStrExtraBedTypeDesc());
			} else {
				objReservationDtlBean.setStrExtraBedCode("");
				objReservationDtlBean.setStrExtraBedDesc("");
			}

			objReservationDtlBean.setStrRoomType(objResDtlModel.getStrRoomType());
			listResDetailsBean.add(objReservationDtlBean);
		}
		objBean.setListReservationDetailsBean(listResDetailsBean);
	
		objBean.setListReservationRoomRateDtl(objReservationModel.getListReservationRoomRateDtl());
		
		objBean.setListRoomPackageDtl(objReservationService.funGetReservationIncomeList(reservationNo, clientCode));
		for (clsRoomPackageDtl objPkgDtlModel : objBean.getListRoomPackageDtl()) 
		{
			objBean.setStrPackageCode(objPkgDtlModel.getStrPackageCode());
			objBean.setStrPackageName(objPkgDtlModel.getStrPackageName());
			break;
		}
		try
		{
			String sql2 = "select b.strGroupLeaderCode from tblreservationhd a,tblgroupbookinghd b " + " where a.strReservationNo='" + objReservationModel.getStrReservationNo() + "' and a.strGroupCode=b.strGroupCode and a.strClientCode=b.strClientCode and a.strClientCode='" + clientCode + "' ";
			List ListgroupCode = objGlobalFunctionsService.funGetListModuleWise(sql2, "sql");
			if(ListgroupCode!=null && ListgroupCode.size()>0) {
				objBean.setStrGuestCode(ListgroupCode.get(0).toString());	
			}
		}
		catch(Exception e) {
			  e.printStackTrace();
			}
		return objBean;
	}

	// Save or Update Reservation
	@RequestMapping(value = "/saveReservation", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsReservationBean objBean, BindingResult result, HttpServletRequest req) {
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propCode = req.getSession().getAttribute("propertyCode").toString();
			String startDate = req.getSession().getAttribute("startDate").toString();
			String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
			Map<Long, String> hmGuestMbWithCode = new HashMap<Long, String>();
			List<clsReservationDetailsBean> listResDtlBean = objBean.getListReservationDetailsBean();
			String strGSTNo = "";
			String strEmailAddress = "";
			for (clsReservationDetailsBean objResDtlBean : listResDtlBean) 
			{
				/*if (null != objResDtlBean.getStrGuestCode() && !objResDtlBean.getStrGuestCode().equals(""))
					
				{
					clsGuestMasterBean objGuestMasterBean = new clsGuestMasterBean();
					objGuestMasterBean.setStrGuestCode(objResDtlBean.getStrGuestCode());
					objGuestMasterBean.setStrGuestPrefix("");
					List listGuestData = objGuestMasterDao.funGetGuestMaster(objResDtlBean.getStrGuestCode(), clientCode);
					clsGuestMasterHdModel obj =new clsGuestMasterHdModel();
					if(listGuestData!=null && listGuestData.size()>0)
					{
						 obj = (clsGuestMasterHdModel) listGuestData.get(0);
					
					}
					
					
//					clsGuestMasterHdModel objGuestMasterModel1 = (clsGuestMasterHdModel) listGuestData.get(0);
					//objGuestMasterModel.setDteDOB(objGlobal.funGetDate("dd-MM-yyyy", objGuestMasterModel.getDteDOB()));

					String[] arrSpGuest = objResDtlBean.getStrGuestName().split(" ");
					objGuestMasterBean.setStrFirstName(arrSpGuest[0]);
					if(arrSpGuest.length>1)
					{
						obj.setStrMiddleName(objGlobal.funIfNull(arrSpGuest[1], "", arrSpGuest[1]));
					}else{
						objGuestMasterBean.setStrMiddleName("");
					}
					if(arrSpGuest.length>2)
					{
						obj.setStrLastName(objGlobal.funIfNull(arrSpGuest[2], "", arrSpGuest[2]));
					}
					else
					{
						obj.setStrLastName("");
					}
					
					objGuestMasterBean.setIntFaxNo(0);
					objGuestMasterBean.setIntPinCode(0);
//					objGuestMasterBean.setDteDOB("01-01-1900");
					
					objGuestMasterBean.setIntMobileNo(objResDtlBean.getLngMobileNo());
					objGuestMasterBean.setStrAddress(objResDtlBean.getStrAddress());
					objGuestMasterBean.setStrGSTNo(strGSTNo);
					objGuestMasterBean.setStrEmailId(strEmailAddress);
					///////
					String sql="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+objResDtlBean.getStrGuestCode()+"'";
					List list = objGlobalFunctionsService.funGetDataList(sql, "sql");
					double closingBal=0.00 ;
					if(list!=null && list.size()>0)
					{
						closingBal = Double.parseDouble(list.get(0).toString());
					}
                    
                    clsGuestMasterHdModel objGuestMasterModel = objGuestMasterService.funPrepareGuestModel(objGuestMasterBean, clientCode, userCode, null);
					objGuestMasterDao.funAddUpdateGuestMaster(objGuestMasterModel);
					hmGuestMbWithCode.put(objResDtlBean.getLngMobileNo(), objGuestMasterModel.getStrGuestCode());	
					String sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+closingBal+"' where  a.strGuestCode='"+objResDtlBean.getStrGuestCode()+"' ";
					objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
				}*/
			}

			List<clsReservationDetailsBean> listReservationDtlBean = new ArrayList<clsReservationDetailsBean>();
			for (clsReservationDetailsBean objResDtlBean : objBean.getListReservationDetailsBean()) 
			{
				if (null != objResDtlBean.getStrGuestCode())
				{
					if (null != hmGuestMbWithCode.get(objResDtlBean.getLngMobileNo())) 
					{
						objResDtlBean.setStrGuestCode(hmGuestMbWithCode.get(objResDtlBean.getLngMobileNo()));
					}
					listReservationDtlBean.add(objResDtlBean);	
				}
			}
			objBean.setListReservationDetailsBean(listReservationDtlBean);
			List<clsReservationRoomRateModelDtl> listRommRate = new ArrayList<clsReservationRoomRateModelDtl>();
			if(null!=objBean.getListReservationRoomRateDtl())
			{
			for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getListReservationRoomRateDtl()) 
			{
			
				String date=objRommDtlBean.getDtDate();
				if(date.split("-")[0].toString().length()<3)
				{	
				 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
				}
				listRommRate.add(objRommDtlBean);
			}
		    }
			

			clsReservationHdModel objHdModel = funPrepareHdModel(objBean, userCode, clientCode, req, propCode);
			objHdModel.setListReservationRoomRateDtl(listRommRate);
			String sql = "select strBookingTypeDesc from tblbookingtype " + " where strBookingTypeCode='" + objBean.getStrBookingTypeCode() + "' and strClientCode='" + clientCode + "' ";
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			String bookingTypeDesc = (String) list.get(0);
			
			objReservationService.funAddUpdateReservationHd(objHdModel, bookingTypeDesc);	
			funSendSMSReservation(objHdModel.getStrReservationNo(), clientCode, propCode);
			try {
				funSendEmailReservation(objHdModel.getStrReservationNo(), clientCode, propCode,req);
			} catch (JRException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			
			if(null!=objBean.getListRoomPackageDtl() && objBean.getListRoomPackageDtl().size()>0  )
			{
				long lastNo=0;
				boolean flgData=false;
				String packageCode="",insertSql="";
				clsPackageMasterHdModel objPkgHdModel=null;
				if (objBean.getStrPackageCode().trim().length() == 0) 
				{
					lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblpackagemasterhd", "PackageMaster", "strPackageCode", clientCode);
					packageCode = "PK" + String.format("%06d", lastNo);
				} 
				else
				{
					packageCode=objBean.getStrPackageCode();
				}
				String strPackageInclusiveRoomTerrif="N";
				List listPackage = objGlobalFunctionsService.funGetListModuleWise("select a.strPackageCode,a.strPackageInclusiveRoomTerrif from tblpackagemasterhd "
						+ " a where a.strPackageCode='"+packageCode+"' and a.strClientCode='"+clientCode+"' ", "sql");
				if(listPackage!=null && listPackage.size()>0 )
				{
					Object[] obj=(Object[])listPackage.get(0);
					strPackageInclusiveRoomTerrif=obj[1].toString();
				}
				objPkgHdModel=new clsPackageMasterHdModel();
				objPkgHdModel.setStrPackageCode(packageCode);
				objPkgHdModel.setStrPackageName(objBean.getStrPackageName());
				int noOfPax=objBean.getIntNoOfAdults()+objBean.getIntNoOfChild();
				
				objPkgHdModel.setDblPackageAmt(Double.valueOf(objBean.getStrTotalPackageAmt()));
			    objPkgHdModel.setStrUserCreated(userCode);
				objPkgHdModel.setStrUserEdited(userCode);
				objPkgHdModel.setDteDateCreated(PMSDate);
				objPkgHdModel.setDteDateEdited(PMSDate);
				objPkgHdModel.setStrClientCode(clientCode);
				objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strReservationNo='"+objHdModel.getStrReservationNo()+"' and strClientCode='"+clientCode+"'", "sql");	
				List<clsPackageMasterDtl> listPkgDtlModel = new ArrayList<clsPackageMasterDtl>();
				String insertPkgDtl= "INSERT INTO `tblroompackagedtl` (`strWalkinNo`, `strReservationNo`,"
						+ " `strCheckInNo`, `strPackageCode`, `strIncomeHeadCode`, `dblIncomeHeadAmt`, "
						+ "`strType`,`strRoomNo`,`strClientCode`) VALUES";
				for (clsRoomPackageDtl objPkgDtlBean : objBean.getListRoomPackageDtl()) 
				{
					insertSql+=",('','"+objHdModel.getStrReservationNo()+"','' "
							+ ",'"+packageCode+"','"+objPkgDtlBean.getStrIncomeHeadCode()+"','"+Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt())*noOfPax+"'"
							+ ",'IncomeHead','','"+clientCode+"')";
						flgData=true;
						
					clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
					objPkdDtl.setStrIncomeHeadCode(objPkgDtlBean.getStrIncomeHeadCode());
					objPkdDtl.setDblAmt(Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt()));
					listPkgDtlModel.add(objPkdDtl);
				}
				
				
				if(null!=objBean.getListReservationRoomRateDtl())
				{
					if(strPackageInclusiveRoomTerrif.equalsIgnoreCase("Y"))
					{
						for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getListReservationRoomRateDtl()) 
						{
						     insertSql+=",('','"+objHdModel.getStrReservationNo()+"','' "
									+ ",'"+packageCode+"','','"+objRommDtlBean.getDblRoomRate()+"' "
									+ ",'RoomTariff','"+objRommDtlBean.getStrRoomType()+"','"+clientCode+"')";
						}
					}
					
			    }
				if(flgData)
				{
					insertSql=insertSql.substring(1,insertSql.length());
					insertPkgDtl+=" "+insertSql;
					objWebPMSUtility.funExecuteUpdate(insertPkgDtl, "sql");
					objPkgHdModel.setListPackageDtl(listPkgDtlModel);
					try {
						//objBaseService.funSaveForPMS(objPkgHdModel);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
		    }
			
			
			
			///Change for saving changed roomtype details....
			if(null!=objBean.getListReservationDetailsBean())
			{
				for (clsReservationDetailsBean objRommDtlBean : objBean.getListReservationDetailsBean()) 
				{
					String date="",oldRoomType="",strRoomNo="";
					boolean isFound=false;
					sql = " select a.strDocNo,a.strRoomType,a.dteToDate from tblchangedroomtypedtl a where a.strDocNo='"+objHdModel.getStrReservationNo()+"' "
							+ " and a.strClientCode='"+clientCode+"'  and a.strGuestCode='"+objRommDtlBean.getStrGuestCode()+"' ";
					list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					if(list.size()>0)
					{
						for (int cnt = 0; cnt < list.size(); cnt++) {
							Object[] arrObjRoom = (Object[]) list.get(cnt);
							if(!arrObjRoom[1].toString().isEmpty())
							{
								date=arrObjRoom[2].toString();
								if(!objRommDtlBean.getStrRoomType().equals(arrObjRoom[1]))
								{
									if(arrObjRoom[2].toString().equalsIgnoreCase(""))
									{
										String []spDate=PMSDate.split("-");
										int changedDate=Integer.valueOf(spDate[2])-1;
										if(changedDate<10)
										{
											date=spDate[0]+"-"+spDate[1]+"-0"+changedDate;
										}
										else
										{
											date=spDate[0]+"-"+spDate[1]+"-"+changedDate;
										}
										isFound=true;
									}
									oldRoomType=(String) arrObjRoom[1];
								}
							}
						}	
					}
					
				if(oldRoomType.isEmpty())
				{
					oldRoomType=objRommDtlBean.getStrRoomType();	
					strRoomNo=objRommDtlBean.getStrRoomNo();
				}
				
				objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrReservationNo()+"' and strRoomType='"+oldRoomType+"' and strGuestCode='"+objRommDtlBean.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");	
				
				String insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
						+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
						+ " `dteToDate`, `strClientCode`) "
						+ " VALUES ('"+objHdModel.getStrReservationNo()+"','Reservation','"+strRoomNo+"','"+oldRoomType+"',"
						+ " '"+objRommDtlBean.getStrGuestCode()+"','"+PMSDate+"','"+date+"','"+clientCode+"') ";
				objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");	
					
				if(isFound)
				{
					objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrReservationNo()+"' and strRoomType='"+objRommDtlBean.getStrRoomType()+"' and strGuestCode='"+objRommDtlBean.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");
					insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
							+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
							+ " `dteToDate`, `strClientCode`) "
							+ " VALUES ('"+objHdModel.getStrReservationNo()+"','Reservation','"+strRoomNo+"','"+objRommDtlBean.getStrRoomType()+"',"
							+ " '"+objRommDtlBean.getStrGuestCode()+"','"+PMSDate+"','','"+clientCode+"') ";
					objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");		
				}
				}
			}
		

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Reservation No : ".concat(objHdModel.getStrReservationNo()));
			req.getSession().setAttribute("AdvanceAmount", objHdModel.getStrReservationNo());
			return new ModelAndView("redirect:/frmReservation.html");
		} else {
			return new ModelAndView("frmReservation");
		}
	}

	private void funSendEmailReservation(String strReservationNo,
			String clientCode, String propCode,HttpServletRequest req) throws JRException {

		String strModuleName = "Reservation";
		clsReservationHdModel objModel = objReservationService.funGetReservationList(strReservationNo, clientCode, propCode);
		
		clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propCode, clientCode);
		
		String strReservationMessege = objPropertySetupModel.getStrReservationEmailContent();
		
		List<clsReservationDtlModel> listReservationmodel = objModel.getListReservationDtlModel();

		if (listReservationmodel.size() > 0) {
			for (int i = 0; i < listReservationmodel.size(); i++) {
				clsReservationDtlModel objDtl = listReservationmodel.get(i);
				if (objDtl.getStrPayee().equals("Y")) {

					List list = objGuestService.funGetGuestMaster(objDtl.getStrGuestCode(), clientCode);
					clsGuestMasterHdModel objGuestModel = null;
					if (list.size() > 0) {
						objGuestModel = (clsGuestMasterHdModel) list.get(0);
		
		
		
			if(strReservationMessege!=null)
				{
			if (strReservationMessege.contains("%%CompanyName")) {
			List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
			strReservationMessege = strReservationMessege.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName()+" ");
			
		}
		if (strReservationMessege.contains("%%PropertyName")) {
			clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
			strReservationMessege = strReservationMessege.replace("%%PropertyName", objProperty.getPropertyName()+" ");
			
		}

		if (strReservationMessege.contains("%%RNo")) {
			strReservationMessege = strReservationMessege.replace("%%RNo", strReservationNo+" ");
			
		}

		if (strReservationMessege.contains("%%RDate")) {
			strReservationMessege = strReservationMessege.replace("%%RDate", objGlobal.funGetDate("dd-MM-yyyy", objModel.getDteReservationDate()+" "));
			
		}

		if (strReservationMessege.contains("%%NoNights")) {
			strReservationMessege = strReservationMessege.replace("%%NoNights", String.valueOf(objModel.getIntNoOfNights())+" ");
			
		}
		
		if (strReservationMessege.contains("%%GuestName")) {
			strReservationMessege = strReservationMessege.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
		}

		if (strReservationMessege.contains("%%RoomNo")) {
			clsRoomMasterModel roomNo = objRoomMaster.funGetRoomMaster(objDtl.getStrRoomNo(), clientCode);
			strReservationMessege = strReservationMessege.replace("%%RoomNo", roomNo.getStrRoomDesc());
		}
		
					}
				}
			}
		}
	}
		
		//objSendEmail.doSendReservationEmail(strReservationNo,strReservationMessege,strModuleName,req);
		
		
		

	}

	// Convert bean to model function
	private clsReservationHdModel funPrepareHdModel(clsReservationBean objBean, String userCode, String clientCode, HttpServletRequest request, String propertyCode) {

		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
		clsReservationHdModel objModel = new clsReservationHdModel();
		if (objBean.getStrReservationNo().isEmpty()) // New Entry
		{
			/*
			 * Date dt=new Date(); String
			 * date=dt.getDate()+"-"+dt.getMonth()+"-"+dt.getYear();
			 */
			String date = objGlobal.funGetCurrentDate("DD-MM-yyyy");
			String documentNo = objGlobal.funGeneratePMSDocumentCode("frmReservation", date, request);
			objModel.setStrReservationNo(documentNo);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(PMSDate);
			objModel.setStrUserEdited(userCode);
			objModel.setDteDateEdited(PMSDate);
		} else // Update
		{
			objModel.setStrUserEdited(userCode);
			objModel.setDteDateEdited(PMSDate);
			objModel.setStrReservationNo(objBean.getStrReservationNo());
		}

		// objModel.setStrGuestCode(objBean.getStrGuestCode());

		objModel.setDteReservationDate(PMSDate);
		objModel.setStrPropertyCode(propertyCode);
		objModel.setStrBookingTypeCode(objGlobal.funIfNull(objBean.getStrBookingTypeCode(), "", objBean.getStrBookingTypeCode()));
		objModel.setStrCorporateCode(objGlobal.funIfNull(objBean.getStrCorporateCode(), "", objBean.getStrCorporateCode()));
		objModel.setDteArrivalDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteArrivalDate()));
		objModel.setDteDepartureDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteDepartureDate()));
		objModel.setTmeArrivalTime(objBean.getTmeArrivalTime());
		objModel.setTmeDepartureTime(objBean.getTmeDepartureTime());
		objModel.setIntNoOfNights(objBean.getIntNoOfNights());
		objModel.setStrContactPerson(objGlobal.funIfNull(objBean.getStrContactPerson(), "", objBean.getStrContactPerson()));
		objModel.setStrEmailId(objGlobal.funIfNull(objBean.getStrEmailId(), "", objBean.getStrEmailId()));
		objModel.setStrBookerCode(objGlobal.funIfNull(objBean.getStrBookerCode(), "", objBean.getStrBookerCode()));
		objModel.setStrBusinessSourceCode(objGlobal.funIfNull(objBean.getStrBusinessSourceCode(), "", objBean.getStrBusinessSourceCode()));
		objModel.setStrBillingInstCode(objGlobal.funIfNull(objBean.getStrBillingInstCode(), "", objBean.getStrBillingInstCode()));
		objModel.setStrAgentCode(objGlobal.funIfNull(objBean.getStrAgentCode(), "", objBean.getStrAgentCode()));
		objModel.setStrRemarks(objGlobal.funIfNull(objBean.getStrRemarks(), "", objBean.getStrRemarks()));
		objModel.setDteCancelDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteCancelDate()));
		objModel.setDteConfirmDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteConfirmDate()));
		objModel.setStrCancelReservation(objGlobal.funIfNull(objBean.getStrCancelReservation(), "N", objBean.getStrCancelReservation()));
		objModel.setStrClientCode(clientCode);
		objModel.setStrRoomNo(objBean.getStrRoomNo());
		objModel.setStrExtraBedCode(objBean.getStrExtraBedCode());
		objModel.setIntNoOfAdults(objBean.getIntNoOfAdults());
		objModel.setIntNoOfChild(objBean.getIntNoOfChild());
		objModel.setStrNoRoomsBooked(String.valueOf(objBean.getIntNoRoomsBooked()));
		objModel.setStrOTANo(objBean.getStrOTANo());
		objModel.setStrMarketSourceCode(objGlobal.funIfNull(objBean.getStrMarketSourceCode(), "", objBean.getStrMarketSourceCode()));
		objModel.setStrIncomeHeadCode(objBean.getStrIncomeHeadCode());
		objModel.setTmePickUpTime(objBean.getTmePickUpTime());
		objModel.setTmeDropTime(objBean.getTmeDropTime());
		objModel.setStrDontApplyTax(objGlobal.funIfNull(objBean.getStrDontApplyTax(), "N", "Y"));
		objModel.setStrBillToCorporate(objGlobal.funIfNull(objBean.getStrBillToCorporate(), "N", "Y"));
		objModel.setStrGroupCode(objBean.getStrGroupCode());
		objModel.setStrExternalNo(objBean.getStrExternalNo());
		objModel.setStrPlanCode(objBean.getStrPlanCode());
		
		List<clsReservationDtlModel> listResDtlModel = new ArrayList<clsReservationDtlModel>();

		for (clsReservationDetailsBean objResDtl : objBean.getListReservationDetailsBean()) {
			clsReservationDtlModel objResDtlModel = new clsReservationDtlModel();
			if (objBean.getStrPayeeGuestCode().equals(objResDtl.getStrGuestCode())) {
				objResDtlModel.setStrPayee("Y");
				objResDtlModel.setStrRoomNo(objResDtl.getStrRoomNo());
				objModel.setStrGuestcode(objBean.getStrPayeeGuestCode());
			} else {
				objResDtlModel.setStrPayee("N");
				objModel.setStrGuestcode("");
			}
			/*
			 * if(objModel.getStrGuestcode().equals("")||objModel.getStrGuestcode
			 * ().equals(null)) { objModel.setStrGuestcode(""); }
			 */
			objResDtlModel.setStrGuestCode(objResDtl.getStrGuestCode());
			objModel.setStrGuestcode(objResDtl.getStrGuestCode());
			objResDtlModel.setStrRoomNo(objResDtl.getStrRoomNo());
			objResDtlModel.setStrExtraBedCode(objResDtl.getStrExtraBedCode());
			objResDtlModel.setStrRoomType(objResDtl.getStrRoomType());
			objResDtlModel.setStrRemark(objResDtl.getStrRemark());
			objResDtlModel.setStrAddress(objResDtl.getStrAddress());
			

			listResDtlModel.add(objResDtlModel);
		}
		objModel.setListReservationDtlModel(listResDtlModel);

		return objModel;
	}

	private void funSendSMSReservation(String reservationNo, String clientCode, String propCode) {

		String strMobileNo = "";
		clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propCode, clientCode);

		clsReservationHdModel objModel = objReservationService.funGetReservationList(reservationNo, clientCode, propCode);

		String smsAPIUrl = objSetup.getStrSMSAPI();

		String smsContent = objSetup.getStrReservationSMSContent();

		if (!smsAPIUrl.equals("")) {
			if (smsContent.contains("%%CompanyName")) {
				List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
				smsContent = smsContent.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName()+" ");
				smsAPIUrl = smsAPIUrl.replace(" ", "%20");
			}
			if (smsContent.contains("%%PropertyName")) {
				clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
				smsContent = smsContent.replace("%%PropertyName", objProperty.getPropertyName()+" ");
				smsAPIUrl = smsAPIUrl.replace(" ", "%20");
			}

			if (smsContent.contains("%%RNo")) {
				smsContent = smsContent.replace("%%RNo", reservationNo+" ");
				smsAPIUrl = smsAPIUrl.replace(" ", "%20");
			}

			if (smsContent.contains("%%RDate")) {
				smsContent = smsContent.replace("%%RDate", objGlobal.funGetDate("dd-MM-yyyy", objModel.getDteReservationDate()+" "));
				smsAPIUrl = smsAPIUrl.replace(" ", "%20");
			}

			if (smsContent.contains("%%NoNights")) {
				smsContent = smsContent.replace("%%NoNights", String.valueOf(objModel.getIntNoOfNights())+" ");
				smsAPIUrl = smsAPIUrl.replace(" ", "%20");
			}

			List<clsReservationDtlModel> listReservationmodel = objModel.getListReservationDtlModel();

			if (listReservationmodel.size() > 0) {
				for (int i = 0; i < listReservationmodel.size(); i++) {
					clsReservationDtlModel objDtl = listReservationmodel.get(i);
					if (objDtl.getStrPayee().equals("Y")) {

						List list = objGuestService.funGetGuestMaster(objDtl.getStrGuestCode(), clientCode);
						clsGuestMasterHdModel objGuestModel = null;
						if (list.size() > 0) {
							objGuestModel = (clsGuestMasterHdModel) list.get(0);

						}
						if (smsContent.contains("%%GuestName")) {
							smsContent = smsContent.replace("%%GuestName", objGuestModel.getStrFirstName() + " " + objGuestModel.getStrMiddleName() + " " + objGuestModel.getStrLastName());
						}

						if (smsContent.contains("%%RoomNo")) {
							clsRoomMasterModel roomNo = objRoomMaster.funGetRoomMaster(objDtl.getStrRoomNo(), clientCode);
							smsContent = smsContent.replace("%%RoomNo", roomNo.getStrRoomDesc());
						}

						if (smsAPIUrl.contains("<PHONE>")) {

							smsAPIUrl = smsAPIUrl.replace("<PHONE>", String.valueOf(objGuestModel.getLngMobileNo()));
							strMobileNo = String.valueOf(objGuestModel.getLngMobileNo());
						}
						if (smsAPIUrl.contains("MSG")) {
							smsAPIUrl = smsAPIUrl.replace("MSG", smsContent);
							smsAPIUrl = smsAPIUrl.replace(" ", "%20");
						}
						
						if (smsAPIUrl.contains("<USERNAME>")) {
							smsAPIUrl = smsAPIUrl.replace("<USERNAME>", "SanguineERP");
							smsAPIUrl = smsAPIUrl.replace(" ", "%20");
						}
						if (smsAPIUrl.contains("<PASSWORD>")) {
							smsAPIUrl = smsAPIUrl.replace("<PASSWORD>", "2017@SanguineERP@2017");
							smsAPIUrl = smsAPIUrl.replace(" ", "%20");
						}
						if (smsAPIUrl.contains("<SENDERID>")) {
							smsAPIUrl = smsAPIUrl.replace("<SENDERID>", "SANPOS");
							smsAPIUrl = smsAPIUrl.replace(" ", "%20");
						}
						
						URL url;
						HttpURLConnection uc = null;
						StringBuilder output = new StringBuilder();

						try {
							url = new URL(smsAPIUrl);
							uc = (HttpURLConnection) url.openConnection();
							if (strMobileNo.length() >= 10) {
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
	
	// For Check Room Limt while making Reservation
	
	@RequestMapping(value = "/loadRoomLimit", method = RequestMethod.GET)
	public @ResponseBody int loadRoomLimit(String ArrivalDate, String DepartureDate, HttpServletRequest req) throws ParseException {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		
		SimpleDateFormat formatter1=new SimpleDateFormat("dd-MM-yyyy");  
		Date arrvDate=formatter1.parse(ArrivalDate);
		Date deptDate=formatter1.parse(DepartureDate);
		
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		String arrDte= formatter.format(arrvDate);
		String dptDte= formatter.format(deptDate);
		
	
		clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
		
		clsReservationBean objReservationBean = new clsReservationBean();
		objReservationBean.setStrRoomLimit(objPropertySetupModel.getStrRoomLimit());
		
		String sql = "";
		int retunVal=0;
		sql = "select count(*) from tblreservationdtl a, tblreservationhd b " 
										+ " where b.dteArrivalDate between '" + arrDte + "' and '" + dptDte + "' and " 
										+ " b.dteDepartureDate between '" + arrDte + "' and '" + dptDte + "' and " 
										+ " a.strReservationNo=b.strReservationNo and a.strClientCode='" + clientCode + "' ";
		
		List listPropertySetup = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		
		
		String RoomLimit = objPropertySetupModel.getStrRoomLimit();
		if(RoomLimit==null || RoomLimit.equalsIgnoreCase(""))
		{
			retunVal = 1;
		}else{
		int countRoom = Integer.parseInt(RoomLimit);
		int listcnt = 0;
		if(listPropertySetup!=null){
			listcnt = Integer.parseInt(listPropertySetup.get(0).toString());
		}

		if(countRoom>listcnt){
			
			retunVal = 1;
			
		}
		}
		
		return retunVal;
		
	}
	
	
	
	@RequestMapping(value = "/loadRoomRate", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomRate(String arrivalDate, String departureDate,String roomDescList,String noOfNights, HttpServletRequest req) throws ParseException {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		String arrvDate=objGlobal.funGetDate("yyyy-MM-dd", arrivalDate);
		String deptDate=objGlobal.funGetDate("yyyy-MM-dd", departureDate);
		double dblDoubleRoomRate = 0.0;

		List returnList=new ArrayList();
		List listRoomCode = new ArrayList();

		String fromDate = req.getParameter("arrivalDate");
		String toDate = req.getParameter("departureDate");
		DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
//		DateTimeFormatter formatter = DateTimeFormatter.BASIC_ISO_DATE;
		LocalDate localArrvDate = dtf.parseLocalDate(arrvDate);
		int cntRoom=0;
		LocalDate localDdeptDate = dtf.parseLocalDate(deptDate);
		clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
		String roomCode="";
		if(roomDescList!="")
		{
			String[] roomCodeList = roomDescList.split(",");
			for(int i=0; i<roomCodeList.length; i++)
			{
				roomCode = roomCodeList[i];
				int noOfDay=Integer.valueOf(noOfNights);
				if(!listRoomCode.contains(roomCode))
				{
		
					for(int j=0;j<roomCodeList.length;j++)
					{
						if(roomCode.equalsIgnoreCase(roomCodeList[j]))
						{
							cntRoom++;
						}
					}
//		clsRoomMasterModel objRoomMaster=objRoomMasterService.funGetRoomMaster(roomCode, clientCode);
//		String roomType="";
//		if(!objRoomMaster.getStrRoomTypeCode().equals(""))
//		{
//			roomType=objRoomMaster.getStrRoomTypeCode();
//		}
		List listRoomData = objRoomTypeMasterDao.funGetRoomTypeMaster(roomCode, clientCode);
		double roomRate=0.0;
		String roomTypedesc="";
		if(null!=listRoomData && listRoomData.size()>0)
		{
			clsRoomTypeMasterModel objRoomTypeMasterModel = (clsRoomTypeMasterModel) listRoomData.get(0);
			
			if(cntRoom==1)
			{
				roomRate=objRoomTypeMasterModel.getDblRoomTerrif();	
			}
			else if(cntRoom==2)
			{
				roomRate=objRoomTypeMasterModel.getDblDoubleTariff();	
			}
			else 
			{
				roomRate=objRoomTypeMasterModel.getDblTrippleTariff();	
			}
			/*roomRate=objRoomTypeMasterModel.getDblRoomTerrif();
			dblDoubleRoomRate = objRoomTypeMasterModel.getDblDoubleTariff();*/
			//roomRate = funCalculateTax(roomRate);
			
			roomTypedesc=objRoomTypeMasterModel.getStrRoomTypeDesc();
		}
		
		for (LocalDate date = localArrvDate;(date.isBefore(localDdeptDate)|| date.isEqual(localDdeptDate)); date = date.plusDays(1))
		{
			List listRoomRate=new ArrayList();
			listRoomRate.add(date.toString());
			listRoomRate.add(roomRate);
			listRoomRate.add(roomTypedesc);
			listRoomRate.add(roomCode);
			listRoomRate.add(dblDoubleRoomRate);
			
			if(noOfDay==0)
			{
				returnList.add(listRoomRate);
				break;
			}
			else
			{
				returnList.add(listRoomRate);
				noOfDay=noOfDay-1;
				if(noOfDay==0)
				{
					break;
				}
			}
			
		}
		listRoomCode.add(roomCode);
		cntRoom=0;
		}
		
		}
			
		}
		return returnList;
	}
	
	
	private double funCalculateTax(double roomRate) {
	
		String sql = "select a.strTaxType,a.dblTaxValue from tbltaxmaster a where "
				+ "a.dblFromRate <= '"+roomRate+"' and a.dblToRate>= '"+roomRate+"' ";
		
		List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		
		String taxType = "";
		double dblTax = 0;
		
		
		for (int cnt = 0; cnt < list.size(); cnt++) 
		{
			Object[] arrObj = (Object[]) list.get(cnt);
			taxType= arrObj[0].toString(); 
			dblTax = Double.parseDouble(arrObj[1].toString());
			if(taxType.equalsIgnoreCase("Percentage"))
			{
				roomRate = roomRate+(roomRate*dblTax)/100;
			}
			else
			{
				roomRate = roomRate+dblTax;
			}
		}
		
		return roomRate;
	}

	@RequestMapping(value = "/loadRoomDesc", method = RequestMethod.GET)
	public @ResponseBody String funLoadRoomDesc(String roomNo, HttpServletRequest req) throws ParseException {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		
		clsRoomMasterModel objRoomMasterModel = objRoomMasterService.funGetRoomMaster(roomNo, clientCode) ;
		String roomDesc = objRoomMasterModel.getStrRoomDesc();
		
		return roomDesc;
	}
	@RequestMapping(value = "/CheckRoomAvailability", method = RequestMethod.GET)
	public @ResponseBody List funCheckRoomAvailability(String roomNo, HttpServletRequest req) throws ParseException {
		
		
		String RoomNo=req.getParameter("RoomNo").toString();
		String ArrivalDate=objGlobal.funGetDate("yyyy-MM-dd",  req.getParameter("ArrivalDate").toString()); 
		String departureDate=getPreviousDate(objGlobal.funGetDate("yyyy-MM-dd", req.getParameter("departureDate").toString()));
		
		
		List list=new ArrayList<>();
		String sql="select a.strReservationNo,DATE_FORMAT(date(a.dteArrivalDate),'%d-%m-%Y') ,"
				+ " DATE_FORMAT(date(a.dteDepartureDate),'%d-%m-%Y') from tblreservationhd a ,tblreservationdtl b."
				+ " where a.strReservationNo=b.strReservationNo and b.strRoomNo='"+RoomNo+"'"
				+ " and ('"+ArrivalDate+"' BETWEEN date(a.dteArrivalDate) and date(a.dteDepartureDate)"
				+ " OR '"+departureDate+"' BETWEEN date(a.dteArrivalDate) and date(a.dteDepartureDate))";
	    list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(list!=null && list.size()>0)
		{			
							
		}
		else
		{
			list.add("Valid");
		}
		return list;
		
		
	}
	public static String getPreviousDate(String  curDate) throws ParseException {
		  final SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
		  final Date date = format1.parse(curDate);
		  final Calendar calendar = Calendar.getInstance();
		  calendar.setTime(date);
		  calendar.add(Calendar.DAY_OF_YEAR, -1);
		  return format1.format(calendar.getTime()); 
  }
	
	
	
	@RequestMapping(value = "/getGuestCode", method = RequestMethod.GET)
	public @ResponseBody clsGuestMasterHdModel fungetGuestCode(@RequestParam("guestCode") String guestCode, HttpServletRequest req){
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		
		clsGuestMasterBean objGuestMasterBean = new clsGuestMasterBean();
		clsGuestMasterHdModel objGuestMasterModel = new clsGuestMasterHdModel();
		
		long lastNo = 0;
		
		if (guestCode.length()==0) {
		
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblguestmaster", "GuestMaster", "strGuestCode", clientCode);
			String guestCode1 = "GT" + String.format("%06d", lastNo);
			objGuestMasterModel.setStrGuestCode(guestCode1);
			objGuestMasterModel.setStrUserCreated(userCode);
			objGuestMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objGuestMasterModel.setStrGuestCode(objGuestMasterBean.getStrGuestCode());
			objGuestMasterModel.setStrUserCreated(userCode);
			objGuestMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		}
	
		return objGuestMasterModel;
	
	}
	
	
	// Load selected package data
		@RequestMapping(value = "/loadPackageMaster", method = RequestMethod.GET)
		public @ResponseBody clsPackageMasterHdModel funLoadPackageData(HttpServletRequest request) {

			String clientCode = request.getSession().getAttribute("clientCode").toString();
			String propCode = request.getSession().getAttribute("propertyCode").toString();
			String packageCode = request.getParameter("docCode").toString();
			clsPackageMasterHdModel objHdModel=new clsPackageMasterHdModel();
			List<clsPackageMasterDtl> listPkgDtl=new ArrayList<>();
			String packageName="";
			List list = objGlobalFunctionsService.funGetListModuleWise("SELECT a.strPackageCode,a.strPackageName,b.strIncomeHeadCode,b.dblAmt,c.strIncomeHeadDesc "
					+ " FROM tblpackagemasterhd a,tblpackagemasterdtl b,tblincomehead c "
					+ " where a.strPackageCode=b.strPackageCode and b.strIncomeHeadCode=c.strIncomeHeadCode "
					+ " and a.strPackageCode ='"+packageCode+"' and a.strClientCode='"+clientCode+"' "
					+ " group by b.strIncomeHeadCode", "sql");
			if(list.size()>0)
			{
				for (int cnt = 0; cnt < list.size(); cnt++) 
				{
					Object[] arrObj = (Object[]) list.get(cnt);
					clsPackageMasterDtl objPkg=new clsPackageMasterDtl();
					objPkg.setStrIncomeHeadCode(arrObj[2].toString()+"#"+arrObj[4].toString());
					objPkg.setDblAmt(Double.valueOf(arrObj[3].toString()));
					listPkgDtl.add(objPkg);
					packageName=arrObj[1].toString();
				}
			}	
			objHdModel.setStrPackageCode(packageCode);
			objHdModel.setStrPackageName(packageName);
			objHdModel.setListPackageDtl(listPkgDtl);
			return objHdModel;
		}
		
       //Reservation Slip
		
			@SuppressWarnings("unchecked")
			@RequestMapping(value = "/rptReservationSlip", method = RequestMethod.GET)
			public void funGeneratePaymentRecipt(@RequestParam("reservationNo") String reservationNo, HttpServletRequest req, HttpServletResponse resp) {
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
					String imagePath1 = servletContext.getRealPath("/resources/images/company_Logo1.png");
					String userName = "";
					String sqlUserName = "select strUserName from "+webStockDB+".tbluserhd where strUserCode='" + userCode + "' ";
					List listOfUser = objGlobalFunctionsService.funGetDataList(sqlUserName, "sql");
					if (listOfUser.size() > 0) {
						userName = listOfUser.get(0).toString();
					}

					HashMap reportParams = new HashMap();			
					ArrayList datalist = new ArrayList();
					String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptReservationSlip.jrxml");			
	
					
					/*String sqlReservation=" SELECT a.strReservationNo,a.strGuestCode,f.strRoomDesc, IFNULL(a.strExtraBedCode,''),b.strRoomTypeDesc, "
										  + "	b.dblRoomTerrif,d.intNoOfAdults, DATE_FORMAT(d.dteReservationDate,'%d-%m-%Y'),e.strGSTNo,e.strPANNo,  "
										  + "	d.tmeArrivalTime, IFNULL(g.dblChargePerBed,0), e.strFirstName,e.strMiddleName,e.strLastName,  " 
										  + "	IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''),  " 
										  + "	IFNULL(e.intPinCodeOfc,''), IFNULL(e.lngMobileNo,0) ,  "
										  + "	DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'), DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y')  "
										  + "	FROM tblroomtypemaster b, tblreservationhd d,tblguestmaster e,tblroom f, tblreservationdtl a  "
										  + "	LEFT OUTER  "
										  + "	JOIN tblextrabed g ON g.strExtraBedTypeCode=a.strExtraBedCode  "
										  + "	WHERE a.strRoomType=b.strRoomTypeCode AND a.strGuestCode=e.strGuestCode AND a.strReservationNo=d.strReservationNo   "
										  + "	AND d.strReservationNo = '"+reservationNo+"' AND a.strRoomNo=f.strRoomCode ; ";	
					*/
				
					/*String sqlReservation=" SELECT a.strReservationNo,a.strGuestCode,f.strRoomDesc, IFNULL(a.strExtraBedCode,''),b.strRoomTypeDesc, "
							  + "	b.dblRoomTerrif,d.intNoOfAdults, DATE_FORMAT(d.dteReservationDate,'%d-%m-%Y'),e.strGSTNo,e.strPANNo,  "
							  + "	d.tmeArrivalTime, IFNULL(g.dblChargePerBed,0), e.strFirstName,e.strMiddleName,e.strLastName,  " 
							  + "	IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''),  " 
							  + "	IFNULL(e.intPinCodeOfc,''), IFNULL(e.lngMobileNo,0) ,  "
							  + "	DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'), DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y'),h.dblRoomRate  "
							  + "	FROM tblroomtypemaster b, tblreservationhd d LEFT OUTER JOIN tblreservationroomratedtl h on  d.strReservationNo=h.strReservationNo, "
							  + "   tblguestmaster e,tblroom f, tblreservationdtl a  "
							  + "	LEFT OUTER  "
							  + "	JOIN tblextrabed g ON g.strExtraBedTypeCode=a.strExtraBedCode  "
							  + "	WHERE a.strRoomType=b.strRoomTypeCode AND a.strGuestCode=e.strGuestCode AND a.strReservationNo=d.strReservationNo   "
							  + "	AND d.strReservationNo = '"+reservationNo+"' AND a.strRoomNo=f.strRoomCode ; ";	
		*/
					//New for Group Reservation
					String sqlReservation="SELECT  a.strReservationNo,e.strRoomTypeDesc, '', g.strFirstName,g.strMiddleName,g.strLastName,DATE_FORMAT(a.dteReservationDate,'%d-%m-%Y'),DATE_FORMAT(a.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(a.dteDepartureDate,'%d-%m-%Y'),IFNULL(g.lngMobileNo,0),	IFNULL(g.strAddressOfc,''), IFNULL(g.strCityOfc,''), IFNULL(g.strStateOfc,''),IFNULL(g.strCountryOfc,''), IFNULL(g.intPinCodeOfc,''), "
										+" e.dblRoomTerrif,SUM(a.intNoOfAdults +a.intNoOfChild),b.dblRoomRate "
										+"  FROM tblreservationhd a LEFT OUTER "
										+" JOIN tblreservationroomratedtl b ON a.strReservationNo=b.strReservationNo, "
										+" tblreservationdtl c LEFT OUTER JOIN tblextrabed d ON c.strExtraBedCode=d.strExtraBedTypeCode "
										+" ,tblroomtypemaster e,tblgroupbookinghd f LEFT OUTER JOIN tblguestmaster g ON f.strGroupLeaderCode=g.strGuestCode "
										+" WHERE a.strGroupCode=f.strGroupCode AND "
										+" a.strReservationNo=c.strReservationNo AND c.strRoomType=e.strRoomTypeCode AND "
										+" a.strReservationNo='"+reservationNo+"'; ";
					//New for Reservation
					/*String sqlReservation="SELECT d.strReservationNo,b.strRoomTypeDesc, f.strRoomDesc, e.strFirstName,e.strMiddleName,e.strLastName, "
										+"  DATE_FORMAT(d.dteReservationDate,'%d-%m-%Y'), DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'), "
										+"  DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y'), IFNULL(e.lngMobileNo,0), IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''), IFNULL(e.intPinCodeOfc,''), b.dblRoomTerrif, "
										+" SUM(d.intNoOfAdults +d.intNoOfChild),h.dblRoomRate "
										+" FROM tblroomtypemaster b, tblreservationhd d "
										+" LEFT OUTER "
										+" JOIN tblreservationroomratedtl h ON d.strReservationNo=h.strReservationNo, tblguestmaster e,tblroom f, tblreservationdtl a "
										+" LEFT OUTER "
										+" JOIN tblextrabed g ON g.strExtraBedTypeCode=a.strExtraBedCode "
										+" WHERE a.strRoomType=b.strRoomTypeCode AND a.strGuestCode=e.strGuestCode AND a.strReservationNo=d.strReservationNo AND d.strReservationNo = '"+reservationNo+"' AND a.strRoomNo=f.strRoomCode ;";

					*/
						List listCheckInRes = objGlobalFunctionsService.funGetListModuleWise(sqlReservation, "sql");
                        
						
						if(listCheckInRes!=null && listCheckInRes.size()>0)
						{
							Object[] arrObjRoomData = (Object[]) listCheckInRes.get(0);
						
							String roomType = arrObjRoomData[1].toString();
							double roomTarrifWithExtraBed = 0.0;	
							if(arrObjRoomData[17]!=null)
							{
								roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[17].toString());
							}
							else
							{
								roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[15].toString());
							}
							
							
							
							
							String gFirstName = arrObjRoomData[3].toString();
							String gMiddleName = arrObjRoomData[4].toString();
							String gLastName = arrObjRoomData[5].toString();
							
							String guestCompanyAddr= arrObjRoomData[15].toString() ;
							if(!arrObjRoomData[10].toString().equalsIgnoreCase(""))
							{
								guestCompanyAddr="," + arrObjRoomData[10].toString();
							}
							else if(!arrObjRoomData[11].toString().equalsIgnoreCase(""))
							{
								guestCompanyAddr="," + arrObjRoomData[11].toString();
							}
							else if(!arrObjRoomData[12].toString().equalsIgnoreCase(""))
							{
								guestCompanyAddr="," + arrObjRoomData[13].toString();
							}
							else if(!arrObjRoomData[14].toString().equalsIgnoreCase("0"))
							{
								guestCompanyAddr="," + arrObjRoomData[14].toString();
							}
							else
							{
								guestCompanyAddr=guestCompanyAddr;
							}
							
							String strMobileNo = arrObjRoomData[9].toString();
						
							
							 String arrDate = arrObjRoomData[7].toString();
						     String depDate = arrObjRoomData[8].toString();
						   
						     Date arrivalDte=new SimpleDateFormat("dd-MM-yyyy").parse(arrDate);  
						     Date departureDte=new SimpleDateFormat("dd-MM-yyyy").parse(depDate); 
						     
						     long arrTme=arrivalDte.getTime();
						     long deptTme=departureDte.getTime();
						     long difference = departureDte.getTime() - arrivalDte.getTime() ;
						     double daysBetween = (difference / (1000*60*60*24));
							
							//double roomTarrif = Double.parseDouble(arrObjRoomData[5].toString());
							
							
							
							reportParams.put("pGuestName", gFirstName + " "+ gMiddleName + " " + gLastName);
							reportParams.put("pReservationDte", arrObjRoomData[6].toString());
							reportParams.put("proomType", roomType);
							reportParams.put("pArrivalDate", arrDate);
							reportParams.put("pDepartureDate", depDate);
							reportParams.put("pstrMobileNo", strMobileNo);
							reportParams.put("pDaysForAccomodation",daysBetween);
							reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
							reportParams.put("pguestCompanyAddr", guestCompanyAddr);
							reportParams.put("strImagePath", imagePath);
							reportParams.put("pNoOfPerson",  arrObjRoomData[16].toString());
							reportParams.put("pRoomNo",  " ");
							if(clientCode.equalsIgnoreCase("383.001"))
							{
								reportParams.put("strImagePath1", imagePath1);	
							}
							else
							{
								reportParams.put("strImagePath1", null);
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
						resp.setHeader("Content-Disposition", "inline;filename=ReservationSlip.pdf");
						exporter.exportReport();
						servletOutputStream.flush();
						servletOutputStream.close();
					}
					
					
				}
				 catch (Exception e) {
						e.printStackTrace();
					}
			}
}
