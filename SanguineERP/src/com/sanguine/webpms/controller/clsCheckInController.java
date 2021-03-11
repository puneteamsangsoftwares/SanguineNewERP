package com.sanguine.webpms.controller;

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

import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.model.clsPropertyMaster;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsPropertyMasterService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsCheckInBean;
import com.sanguine.webpms.bean.clsCheckInDetailsBean;
import com.sanguine.webpms.bean.clsFolioHdBean;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.bean.clsPostRoomTerrifBean;
import com.sanguine.webpms.bean.clsReservationDetailsBean;
import com.sanguine.webpms.bean.clsTaxCalculation;
import com.sanguine.webpms.bean.clsTaxProductDtl;
import com.sanguine.webpms.dao.clsExtraBedMasterDao;
import com.sanguine.webpms.dao.clsGuestMasterDao;
import com.sanguine.webpms.dao.clsRoomTypeMasterDao;
import com.sanguine.webpms.dao.clsWalkinDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsCheckInDtl;
import com.sanguine.webpms.model.clsCheckInHdModel;
import com.sanguine.webpms.model.clsExtraBedMasterModel;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsPMSGroupBookingDtlModel;
import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;
import com.sanguine.webpms.model.clsPackageMasterDtl;
import com.sanguine.webpms.model.clsPackageMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.model.clsReservationDtlModel;
import com.sanguine.webpms.model.clsReservationHdModel;
import com.sanguine.webpms.model.clsReservationRoomRateModelDtl;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsRoomPackageDtl;
import com.sanguine.webpms.model.clsRoomTypeMasterModel;
import com.sanguine.webpms.model.clsWalkinHdModel;
import com.sanguine.webpms.model.clsWalkinRoomRateDtlModel;
import com.sanguine.webpms.service.clsCheckInService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPMSGroupBookingService;
import com.sanguine.webpms.service.clsPropertySetupService;
import com.sanguine.webpms.service.clsReservationService;
import com.sanguine.webpms.service.clsRoomMasterService;
import com.sanguine.webpms.service.clsWalkinService;

import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.validation.BindingResult;

import javassist.bytecode.stackmap.BasicBlock.Catch;

import javax.validation.Valid;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sun.misc.BASE64Encoder;

@Controller
public class clsCheckInController {

	@Autowired
	private clsCheckInService objCheckInService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsGuestMasterService objGuestMasterService;

	@Autowired
	private clsGuestMasterDao objGuestMasterDao;

	@Autowired
	private clsFolioController objFolioController;

	@Autowired
	private clsFolioService objFolioService;

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
	clsPMSUtilityFunctions objPMSUtility;
	
	@Autowired 
	clsReservationService objReservationService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

	@Autowired
	private intfBaseService objBaseService;
	
	
	@Autowired
	private clsWalkinDao objWalkinDao;
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private clsSetupMasterService objSetupMasterService;
	

	@Autowired
	private clsGlobalFunctionsService objGlobalFunService;
	
	@Autowired
	private clsPostRoomTerrifController objPostRoomTerrif;
	@Autowired
	private clsRoomTypeMasterDao objRoomTypeMasterDao;

	@Autowired
	private clsPMSGroupBookingService objPMSGroupBookingService;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.setAutoGrowCollectionLimit(1000000);
	}
	// Open CheckIn
	@RequestMapping(value = "/frmCheckIn", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn_1", "command", new clsCheckInBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn", "command", new clsCheckInBean());
		} else {
			return null;
		}
	}

	@RequestMapping(value = "/frmCheckIn1", method = RequestMethod.GET)
	public ModelAndView funOpenForm1(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String checkInNo = request.getParameter("docCode").toString();

		try {
			urlHits = request.getParameter("saddr").toString();

		} catch (NullPointerException e) {
			urlHits = "1";
		}

		model.put("urlHits", urlHits);

		request.getSession().setAttribute("checkInNo", checkInNo);

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn_1", "command", new clsCheckInBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn", "command", new clsCheckInBean());
		} else {
			return null;
		}
	}
	
	
	
	@RequestMapping(value = "/frmQuickCheckIn", method = RequestMethod.GET)
	public ModelAndView funOpenQuickCheckInForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String walkinNo=request.getParameter("walkinNo").toString();
		request.setAttribute("walkinNo", walkinNo);
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn_1", "command", new clsCheckInBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmCheckIn", "command", new clsCheckInBean());
		} else {
			return null;
		}
	}

	// Load Header Table Data On Form
	@RequestMapping(value = "/loadCheckInData", method = RequestMethod.GET)
	public @ResponseBody clsCheckInBean funLoadHdData(HttpServletRequest request) {

		String sql = "";
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		clsCheckInBean objBean = new clsCheckInBean();
		String docCode = request.getParameter("docCode").toString();
		clsCheckInHdModel objCheckIn = objCheckInService.funGetCheckInData(docCode, clientCode);
		objBean.setStrCheckInNo(objCheckIn.getStrCheckInNo());
		objBean.setStrRegistrationNo(objCheckIn.getStrRegistrationNo());
		objBean.setStrType(objCheckIn.getStrType());
		if (objCheckIn.getStrType().equals("Reservation")) {
			objBean.setStrAgainstDocNo(objCheckIn.getStrReservationNo());
		} else {
			objBean.setStrAgainstDocNo(objCheckIn.getStrWalkInNo());
		}
		objBean.setDteArrivalDate(objGlobal.funGetDate("yyyy/MM/dd", objCheckIn.getDteArrivalDate()));
		objBean.setDteDepartureDate(objGlobal.funGetDate("yyyy/MM/dd", objCheckIn.getDteDepartureDate()));
		objBean.setTmeArrivalTime(objCheckIn.getTmeArrivalTime());
		objBean.setTmeDepartureTime(objCheckIn.getTmeDepartureTime());

		sql = "select a.strRoomDesc,b.strRoomTypeDesc from tblroom a,tblroomtypemaster b " + " where a.strRoomTypeCode=b.strRoomTypeCode and a.strRoomCode='" + objCheckIn.getStrRoomNo() + "' ";
		List listRoomData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

		if (!listRoomData.isEmpty()) {
			Object[] arrObjRoomData = (Object[]) listRoomData.get(0);
			objBean.setStrRoomNo(objCheckIn.getStrRoomNo());
			objBean.setStrRoomDesc(arrObjRoomData[0].toString());
		} else {
			objBean.setStrRoomNo("");
			objBean.setStrRoomDesc("");
		}

		if (!objCheckIn.getStrExtraBedCode().equals("")) {
			List listExtraBedData = objExtraBedMasterDao.funGetExtraBedMaster(objCheckIn.getStrExtraBedCode(), clientCode);
			clsExtraBedMasterModel objExtraBedMasterModel = (clsExtraBedMasterModel) listExtraBedData.get(0);
			objBean.setStrExtraBedCode(objCheckIn.getStrExtraBedCode());
			objBean.setStrExtraBedDesc(objExtraBedMasterModel.getStrExtraBedTypeDesc());
		} else {
			objBean.setStrExtraBedCode("");
			objBean.setStrExtraBedDesc("");
		}
		objBean.setIntNoOfAdults(objCheckIn.getIntNoOfAdults());
		objBean.setIntNoOfChild(objCheckIn.getIntNoOfChild());
		objBean.setStrNoPostFolio(objCheckIn.getStrNoPostFolio());
		objBean.setStrPlanCode(objCheckIn.getStrPlanCode());
		
		List<clsCheckInDetailsBean> listCheckInDtlBean = new ArrayList<clsCheckInDetailsBean>();
		for (clsCheckInDtl objCheckInDtlModel : objCheckIn.getListCheckInDtl()) {
			clsCheckInDetailsBean objCheckInDtlBean = new clsCheckInDetailsBean();
			objCheckInDtlBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());

			sql = "select strFirstName,strMiddleName,strLastName,lngMobileNo from tblguestmaster " + " where strGuestCode='" + objCheckInDtlModel.getStrGuestCode() + "' and strClientCode='" + clientCode + "' ";
			List listGuestMaster = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

			// listGuestMaster.forEach(obj-> {});

			for (int cnt = 0; cnt < listGuestMaster.size(); cnt++) {
				Object[] arrObjGuest = (Object[]) listGuestMaster.get(cnt);
				String guestName = arrObjGuest[0] + " " + arrObjGuest[1] + " " + arrObjGuest[2];
				objCheckInDtlBean.setStrGuestName(guestName);
				objCheckInDtlBean.setLngMobileNo(Long.parseLong(arrObjGuest[3].toString()));
			}

			sql = "select a.strRoomDesc,b.strRoomTypeDesc,b.strRoomTypeCode from tblroom a,tblroomtypemaster b " + " where a.strRoomTypeCode=b.strRoomTypeCode and a.strRoomCode='" + objCheckInDtlModel.getStrRoomNo() + "' ";
			List listRoomData1 = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			Object[] arrObjRoomData1 = (Object[]) listRoomData1.get(0);
			objCheckInDtlBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
			objCheckInDtlBean.setStrRoomDesc(arrObjRoomData1[0].toString());

			if (!objCheckInDtlModel.getStrExtraBedCode().equals("")) {
				List listExtraBedData = objExtraBedMasterDao.funGetExtraBedMaster(objCheckInDtlModel.getStrExtraBedCode(), clientCode);
				clsExtraBedMasterModel objExtraBedMasterModel = (clsExtraBedMasterModel) listExtraBedData.get(0);
				objCheckInDtlBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
				objCheckInDtlBean.setStrExtraBedDesc(objExtraBedMasterModel.getStrExtraBedTypeDesc());
			} else {
				objCheckInDtlBean.setStrExtraBedCode("");
				objCheckInDtlBean.setStrExtraBedDesc("");
			}
			objCheckInDtlBean.setStrPayee(objCheckInDtlModel.getStrPayee());
			objCheckInDtlBean.setStrRoomType(objCheckInDtlModel.getStrRoomType());
			listCheckInDtlBean.add(objCheckInDtlBean);
		}
		objBean.setListCheckInDetailsBean(listCheckInDtlBean);
		
		
		if (objCheckIn.getStrType().equals("Reservation")) 
		{
			clsReservationHdModel objReservationModel = objReservationService.funGetReservationList(objBean.getStrAgainstDocNo(), clientCode, propCode);
			objBean.setlistReservationRoomRateDtl(objReservationModel.getListReservationRoomRateDtl());
		}
		else
		{
			List listWalkinData = objWalkinDao.funGetWalkinDataDtl(objBean.getStrAgainstDocNo(), clientCode);
			clsWalkinHdModel objWalkinHdModel = (clsWalkinHdModel) listWalkinData.get(0);
			objBean.setListWalkinRoomRateDtl(objWalkinHdModel.getListWalkinRoomRateDtlModel());
		}
		objBean.setListRoomPackageDtl(objCheckInService.funGetCheckInIncomeList(docCode, clientCode));
		for (clsRoomPackageDtl objPkgDtlModel : objBean.getListRoomPackageDtl()) 
		{
			objBean.setStrPackageCode(objPkgDtlModel.getStrPackageCode());
			objBean.setStrPackageName(objPkgDtlModel.getStrPackageName());
			break;
		}

		return objBean;
	}

	// Save or Update CheckIn
	@RequestMapping(value = "/saveCheckIn", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsCheckInBean objBean, BindingResult result, HttpServletRequest req) {
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propCode = req.getSession().getAttribute("propertyCode").toString();
			String startDate = req.getSession().getAttribute("startDate").toString();
			String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
 
			String sqlFolioNo = "select a.strFolioNo from tblfoliohd a where a.strCheckInNo='"+objBean.getStrCheckInNo()+"' and a.strClientCode='"+clientCode+"'";
			String strFolioNo="";
			List listFolioNo  = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNo, "sql");	
			String strPackageInclusiveRoomTerrif="N";
			
			String sqldte = "select date(max(dtePMSDate)),strStartDay  from tbldayendprocess " + " where strPropertyCode='01' and strClientCode='" + clientCode + "' " + " and strDayEnd='N' ";
			List listdate = objGlobalFunctionsService.funGetListModuleWise(sqldte, "sql");
			Object[] arrObjDayEnd = (Object[]) listdate.get(0);
			
			if(listFolioNo.size()>0)
			{
				strFolioNo = listFolioNo.get(0).toString();
				String sqlFolioNoDtl = "select a.strPerticulars from tblfoliodtl a where a.strFolioNo='"+strFolioNo+"'";
				List listFolioNoDtl  = objGlobalFunctionsService.funGetListModuleWise(sqlFolioNoDtl, "sql");			
				if(listFolioNoDtl.size()>0)
				{
					if(objBean.getStrType().equals("Reservation"))
					{
						clsReservationHdModel objReservationModel = objReservationService.funGetReservationList(objBean.getStrAgainstDocNo(), clientCode, propCode);
						List<clsReservationRoomRateModelDtl> listRommRate = new ArrayList<clsReservationRoomRateModelDtl>();
						if(null!=objBean.getlistReservationRoomRateDtl())
						{
						for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getlistReservationRoomRateDtl()) 
						{
							String date=objRommDtlBean.getDtDate();
							if(date.split("-")[0].toString().length()<3)
							{	
							 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
							}
							listRommRate.add(objRommDtlBean);
						}
					    }
						objReservationModel.setListReservationRoomRateDtl(listRommRate);
						objReservationService.funAddUpdateReservationHd(objReservationModel, objReservationModel.getStrBookingTypeCode());	
						
					}
					else
					{
						List listWalkinData = objWalkinDao.funGetWalkinDataDtl(objBean.getStrAgainstDocNo(), clientCode);
						clsWalkinHdModel objWalkinHdModel = (clsWalkinHdModel) listWalkinData.get(0);
						List<clsWalkinRoomRateDtlModel> listRommRate = new ArrayList<clsWalkinRoomRateDtlModel>();
						//listRommRate=objWalkinHdModel.getListWalkinRoomRateDtlModel();
						if(null!=objBean.getListWalkinRoomRateDtl()){
							for (clsWalkinRoomRateDtlModel objRommDtlBean :objBean.getListWalkinRoomRateDtl()) {
							
								String date=objRommDtlBean.getDtDate();
								if(date.split("-")[0].toString().length()<3)
								{	
								 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
								}
								listRommRate.add(objRommDtlBean);
							}
						}
						objWalkinHdModel.setListWalkinRoomRateDtlModel(listRommRate);
						objWalkinDao.funAddUpdateWalkinHd(objWalkinHdModel);
					}
					
					String sqlCheckIn="	UPDATE tblcheckinhd a SET a.dteDepartureDate='"+objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteDepartureDate())+"' WHERE a.strCheckInNo='"+objBean.getStrCheckInNo()+"' ";
					objWebPMSUtility.funExecuteUpdate(sqlCheckIn, "sql"); 
					
					req.getSession().setAttribute("WarningMsg", "checkin Departure Date  has been edited Successfully");

					
				}
				
				else
				{
				
				
				if (objBean.getStrType().equalsIgnoreCase("Reservation")) {
					Map<Long, String> hmGuestMbWithCode = new HashMap<Long, String>();
					List<clsCheckInDetailsBean> listCheckInDtlBean = objBean.getListCheckInDetailsBean();
	                for (clsCheckInDetailsBean objCheckInDtlBean : listCheckInDtlBean) {
						/*clsGuestMasterBean objGuestMasterBean = new clsGuestMasterBean();
						objGuestMasterBean.setStrGuestCode(objCheckInDtlBean.getStrGuestCode());
						objGuestMasterBean.setStrGuestPrefix("");
						String[] arrSpGuest = objCheckInDtlBean.getStrGuestName().split(" ");
						objGuestMasterBean.setStrFirstName(arrSpGuest[0]);
						if(arrSpGuest.length>1){
							objGuestMasterBean.setStrMiddleName(arrSpGuest[1]);
							if(arrSpGuest.length==2){
							objGuestMasterBean.setStrLastName(arrSpGuest[2]);
							}
							}
						objGuestMasterBean.setIntFaxNo(0);
						objGuestMasterBean.setIntPinCode(0);
						objGuestMasterBean.setDteDOB("01-01-1900");
						objGuestMasterBean.setIntMobileNo(objCheckInDtlBean.getLngMobileNo());
						clsGuestMasterHdModel objGuestMasterModel = objGuestMasterService.funPrepareGuestModel(objGuestMasterBean, clientCode, userCode);
						objGuestMasterDao.funAddUpdateGuestMaster(objGuestMasterModel);
						*/hmGuestMbWithCode.put(objCheckInDtlBean.getLngMobileNo(), objCheckInDtlBean.getStrGuestCode());
						
					}
					List<clsCheckInDetailsBean> listCheckInDetailBean = new ArrayList<clsCheckInDetailsBean>();
					for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) {
						if (null != hmGuestMbWithCode.get(objCheckInDtlBean.getLngMobileNo())) {
							objCheckInDtlBean.setStrGuestCode(hmGuestMbWithCode.get(objCheckInDtlBean.getLngMobileNo()));
						}
						listCheckInDetailBean.add(objCheckInDtlBean);
					}
					objBean.setListCheckInDetailsBean(listCheckInDetailBean);
				}

				clsCheckInHdModel objHdModel = funPrepareHdModel(objBean, userCode, clientCode, req);

				/*
				 * List<clsCheckInDtl>
				 * listCheckInDtlModel=objHdModel.getListCheckInDtl();
				 * for(clsCheckInDtl objCheckInDtlModel:listCheckInDtlModel) {
				 * clsFolioHdBean objFolioBean=new clsFolioHdBean(); int
				 * cntFolios=0;
				 * 
				 * while(cntFolios<objCheckInDtlModel.getIntNoOfFolios()) {
				 * objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
				 * objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
				 * objFolioBean
				 * .setStrRegistrationNo(objHdModel.getStrRegistrationNo());
				 * objFolioBean
				 * .setStrReservationNo(objHdModel.getStrReservationNo());
				 * objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
				 * objFolioBean
				 * .setDteDepartureDate(objHdModel.getDteDepartureDate());
				 * objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
				 * objFolioBean
				 * .setTmeDepartureTime(objHdModel.getTmeDepartureTime());
				 * objFolioBean
				 * .setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
				 * clsFolioHdModel
				 * objFolioHdModel=objFolioController.funPrepareFolioModel
				 * (objFolioBean, clientCode, req);
				 * objFolioService.funAddUpdateFolioHd(objFolioHdModel);
				 * cntFolios++; } }
				 */

				List<clsCheckInDtl> listCheckInDtlModel = objHdModel.getListCheckInDtl();
				// for(clsCheckInDtl objCheckInDtlModel:listCheckInDtlModel)
				// {
				// clsFolioHdBean objFolioBean=new clsFolioHdBean();
				// int cntFolios=0;
				//
				// if(null!=objCheckInDtlModel.getStrPayee())
				// {
				// if(objCheckInDtlModel.getStrPayee().equals("Y"))
				// {
				// objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
				// objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
				// objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
				// objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
				// objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
				// objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
				// objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
				// objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
				// objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
				// objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
				// clsFolioHdModel
				// objFolioHdModel=objFolioController.funPrepareFolioModel(objFolioBean,
				// clientCode, req);
				// objFolioService.funAddUpdateFolioHd(objFolioHdModel);
				// cntFolios++;
				// }
				// }
				// }
				
				String sql1 = "select strfoliono from tblfoliohd " + " where strCheckInNo ='" + objBean.getStrCheckInNo() + "' ";
				List listCheckIn = objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");

				

				String folioN = "";
				if(listCheckIn!=null && listCheckIn.size()>0)
				{
					 folioN = (String) listCheckIn.get(0);
				}

				
				List<String> listCheckRomm = new ArrayList<String>();
				List<clsFolioDtlModel> listFolioDtl = new ArrayList<clsFolioDtlModel>();
				for (clsCheckInDtl objCheckInDtlModel : listCheckInDtlModel) {
					clsFolioHdBean objFolioBean = new clsFolioHdBean();
					int cntFolios = 0;
					if (!listCheckRomm.contains(objCheckInDtlModel.getStrRoomNo())) {
						objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
						objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
						objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
						objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
						objFolioBean.setStrWalkInNo(objHdModel.getStrWalkInNo());
						objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
						objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
						objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
						objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
						objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
						objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
						objFolioBean.setStrFolioNo(folioN);
						
						
						clsFolioHdModel objFolioHdModel = objFolioController.funPrepareFolioModel(objFolioBean, clientCode, req);
						
						
//			@@@@			if(!(objHdModel.getStrReservationNo().equalsIgnoreCase("")))
//						{
//							
//							
//						}
//						
//						long doc = objPMSUtility.funGenerateFolioDocForRoom("RoomFolio");
//						String docNo = "RM" + String.format("%06d", doc);
//						double roomTerrif = 0.0;
//						clsFolioDtlModel objFolioDtl = new clsFolioDtlModel();
//						objFolioDtl.setStrDocNo(docNo);
//						objFolioDtl.setDteDocDate(PMSDate);
//						objFolioDtl.setDblDebitAmt(roomTerrif);
//						objFolioDtl.setDblBalanceAmt(0);
//						objFolioDtl.setDblCreditAmt(0);
//						objFolioDtl.setStrPerticulars("Room Revenue");
//						objFolioDtl.setStrRevenueType("Room");
//						objFolioDtl.setStrRevenueCode(objCheckInDtlModel.getStrRoomNo());
//						listFolioDtl.add(objFolioDtl);
//						if(objHdModel.getStrReservationNo().equalsIgnoreCase(""))
//						{
//							List<clsReservationRoomRateModelDtl>listReservationRoomRate= objReservationService.funGetReservationRoomRateList( objHdModel.getStrReservationNo(),  clientCode,  objCheckInDtlModel.getStrRoomNo()) ;
//						    	
//						
//						
//		@@				}
						objFolioService.funAddUpdateFolioHd(objFolioHdModel);
						
						cntFolios++;

					}
					listCheckRomm.add(objCheckInDtlModel.getStrRoomNo());
				}

				objCheckInService.funAddUpdateCheckInHd(objHdModel);
				
				if(objBean.getStrType().equals("Reservation"))
				{
					clsReservationHdModel objReservationModel = objReservationService.funGetReservationList(objBean.getStrAgainstDocNo(), clientCode, propCode);
					List<clsReservationRoomRateModelDtl> listRommRate = new ArrayList<clsReservationRoomRateModelDtl>();
					if(null!=objBean.getlistReservationRoomRateDtl())
					{
					for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getlistReservationRoomRateDtl()) 
					{
						String date=objRommDtlBean.getDtDate();
						if(date.split("-")[0].toString().length()<3)
						{	
						 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
						}
						listRommRate.add(objRommDtlBean);
					}
				    }
					objReservationModel.setListReservationRoomRateDtl(listRommRate);
					objReservationService.funAddUpdateReservationHd(objReservationModel, objReservationModel.getStrBookingTypeCode());	
					
				}
				else
				{
					List listWalkinData = objWalkinDao.funGetWalkinDataDtl(objBean.getStrAgainstDocNo(), clientCode);
					clsWalkinHdModel objWalkinHdModel = (clsWalkinHdModel) listWalkinData.get(0);
					List<clsWalkinRoomRateDtlModel> listRommRate = new ArrayList<clsWalkinRoomRateDtlModel>();
					//listRommRate=objWalkinHdModel.getListWalkinRoomRateDtlModel();
					if(null!=objBean.getListWalkinRoomRateDtl()){
						for (clsWalkinRoomRateDtlModel objRommDtlBean : objWalkinHdModel.getListWalkinRoomRateDtlModel()) {
						
							String date=objRommDtlBean.getDtDate();
							if(date.split("-")[0].toString().length()<3)
							{	
							 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
							}
							listRommRate.add(objRommDtlBean);
						}
						}
					objWalkinHdModel.setListWalkinRoomRateDtlModel(listRommRate);
					objWalkinDao.funAddUpdateWalkinHd(objWalkinHdModel);
				}
				
				
				if(null!=objBean.getListRoomPackageDtl() && objBean.getListRoomPackageDtl().size()>0 )
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
					objPkgHdModel.setDblPackageAmt(Double.valueOf(objBean.getStrTotalPackageAmt()));
					objPkgHdModel.setStrUserCreated(userCode);
					objPkgHdModel.setStrUserEdited(userCode);
					objPkgHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objPkgHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objPkgHdModel.setStrClientCode(clientCode);
					List<clsPackageMasterDtl> listPkgDtlModel = new ArrayList<clsPackageMasterDtl>();
					String insertPkgDtl= "INSERT INTO `tblroompackagedtl` (`strWalkinNo`, `strReservationNo`,"
							+ " `strCheckInNo`, `strPackageCode`, `strIncomeHeadCode`, `dblIncomeHeadAmt`, "
							+ "`strType`,`strRoomNo`,`strClientCode`) VALUES";
					
					if(objBean.getStrType().equals("Reservation"))
					{
						objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strReservationNo='"+objHdModel.getStrReservationNo()+"' and strClientCode='"+clientCode+"'", "sql");
						objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strCheckInNo='"+objHdModel.getStrCheckInNo()+"' and strReservationNo='"+objHdModel.getStrReservationNo()+"' and strClientCode='"+clientCode+"'", "sql");
						for (clsRoomPackageDtl objPkgDtlBean : objBean.getListRoomPackageDtl()) 
						{
							insertSql+=",('','"+objHdModel.getStrReservationNo()+"','"+objHdModel.getStrCheckInNo()+"' "
									+ ",'"+packageCode+"','"+objPkgDtlBean.getStrIncomeHeadCode()+"','"+Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt())+"'"
									+ ",'IncomeHead','','"+clientCode+"')";
								flgData=true;
								
							clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
							objPkdDtl.setStrIncomeHeadCode(objPkgDtlBean.getStrIncomeHeadCode());
							objPkdDtl.setDblAmt(Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt()));
							listPkgDtlModel.add(objPkdDtl);
						}
						for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getlistReservationRoomRateDtl()) 
						{
							for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) 
							{
								if(objRommDtlBean.getStrRoomType().equals(objCheckInDtlBean.getStrRoomType()))
								{
									insertSql+=",('','"+objHdModel.getStrReservationNo()+"','"+objHdModel.getStrCheckInNo()+"' "
											+ ",'"+packageCode+"','','"+objRommDtlBean.getDblRoomRate()+"' "
											+ ",'RoomTariff','"+objCheckInDtlBean.getStrRoomNo()+"','"+clientCode+"')";
									
								}
							}
						 }
					}
					else
					{
						objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strWalkinNo='"+objHdModel.getStrWalkInNo()+"' and strClientCode='"+clientCode+"'", "sql");
						objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strCheckInNo='"+objHdModel.getStrCheckInNo()+"' and strWalkinNo='"+objHdModel.getStrWalkInNo()+"' and strClientCode='"+clientCode+"'", "sql");
						for (clsRoomPackageDtl objPkgDtlBean : objBean.getListRoomPackageDtl()) 
						{
							insertSql+=",('"+objHdModel.getStrWalkInNo()+"','','"+objHdModel.getStrCheckInNo()+"' "
									+ ",'"+packageCode+"','"+objPkgDtlBean.getStrIncomeHeadCode()+"','"+Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt())+"'"
									+ ",'IncomeHead','','"+clientCode+"')";
								flgData=true;
								
							clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
							objPkdDtl.setStrIncomeHeadCode(objPkgDtlBean.getStrIncomeHeadCode());
							objPkdDtl.setDblAmt(Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt()));
							listPkgDtlModel.add(objPkdDtl);
						}
						if(strPackageInclusiveRoomTerrif.equalsIgnoreCase("Y"))
						{
							for (clsWalkinRoomRateDtlModel objRommDtlBean : objBean.getListWalkinRoomRateDtl()) 
							{
								for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) 
								{
									if(objRommDtlBean.getStrRoomType().equals(objCheckInDtlBean.getStrRoomType()))
									{
										insertSql+=",('"+objHdModel.getStrWalkInNo()+"','','"+objHdModel.getStrCheckInNo()+"' "
									    		 + ",'"+packageCode+"','','"+objRommDtlBean.getDblRoomRate()+"' "
													+ ",'RoomTariff','"+objCheckInDtlBean.getStrRoomNo()+"','"+clientCode+"')";
										
									}
								}
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
						//	objBaseService.funSaveForPMS(objPkgHdModel);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					
			    }
				
				///Change for saving changed roomtype details....
				if(null!=listCheckInDtlModel)
				{
					for (clsCheckInDtl objCheckInDtlModel : listCheckInDtlModel) 
					{
						String date="",oldRoomType="",oldRoomNo="";
						boolean isFound=false;
						String sql = " select a.strDocNo,a.strRoomType,a.dteToDate,a.strRoomNo from tblchangedroomtypedtl a where a.strDocNo='"+objHdModel.getStrCheckInNo()+"' "
								+ " and a.strClientCode='"+clientCode+"'  and a.strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' ";
						List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
						if(list.size()>0)
						{
							for (int cnt = 0; cnt < list.size(); cnt++) {
								Object[] arrObjRoom = (Object[]) list.get(cnt);
								if(!arrObjRoom[1].toString().isEmpty())
								{
									date=arrObjRoom[2].toString();
									if(!objCheckInDtlModel.getStrRoomNo().equals(arrObjRoom[3]))
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
										oldRoomNo=(String) arrObjRoom[3];
									}
								}
							}	
						}
						
					if(oldRoomType.isEmpty())
					{
						oldRoomType=objCheckInDtlModel.getStrRoomType();	
						oldRoomNo=objCheckInDtlModel.getStrRoomNo();
					}
					
					objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrCheckInNo()+"' and strRoomType='"+oldRoomType+"' and strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");	
					
					String insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
							+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
							+ " `dteToDate`, `strClientCode`) "
							+ " VALUES ('"+objHdModel.getStrCheckInNo()+"','CheckIn','"+oldRoomNo+"','"+oldRoomType+"',"
							+ " '"+objCheckInDtlModel.getStrGuestCode()+"','"+PMSDate+"','"+date+"','"+clientCode+"') ";
					objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");	

						if(isFound)
						{
							objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrCheckInNo()+"' and strRoomType='"+objCheckInDtlModel.getStrRoomType()+"' and strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");
							insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
									+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
									+ " `dteToDate`, `strClientCode`) "
									+ " VALUES ('"+objHdModel.getStrCheckInNo()+"','CheckIn','"+objCheckInDtlModel.getStrRoomNo()+"','"+objCheckInDtlModel.getStrRoomType()+"',"
									+ " '"+objCheckInDtlModel.getStrGuestCode()+"','"+PMSDate+"','','"+clientCode+"') ";
							objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");
							
							sql="update tblroom a set a.strStatus='Occupied' where a.strRoomCode='"+objCheckInDtlModel.getStrRoomNo()+"'";
							objWebPMSUtility.funExecuteUpdate(sql, "sql"); 
							sql="update tblroom a set a.strStatus='Free' where a.strRoomCode='"+oldRoomNo+"'";
							objWebPMSUtility.funExecuteUpdate(sql, "sql"); 
							sql="update tblreservationdtl a set a.strRoomType='"+objCheckInDtlModel.getStrRoomType()+"' , a.strRoomNo='"+objCheckInDtlModel.getStrRoomNo()+"' where a.strReservationNo='"+objHdModel.getStrReservationNo()+"' and a.strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' ";
							objWebPMSUtility.funExecuteUpdate(sql, "sql"); 
						}
					}
				}
			
				
				
				
				funSendSMSCheckIn(objHdModel.getStrCheckInNo(), clientCode, propCode);
				req.getSession().setAttribute("success", true);
				req.getSession().setAttribute("successMessage", "Check In No : ".concat(objHdModel.getStrCheckInNo()));
				req.getSession().setAttribute("AdvanceAmount", objHdModel.getStrCheckInNo());
				req.getSession().setAttribute("against", objHdModel.getStrType());
				}
			}			
			else
			{
			
			
			if (objBean.getStrType().equalsIgnoreCase("Reservation")) {
				Map<Long, String> hmGuestMbWithCode = new HashMap<Long, String>();
				List<clsCheckInDetailsBean> listCheckInDtlBean = objBean.getListCheckInDetailsBean();
                for (clsCheckInDetailsBean objCheckInDtlBean : listCheckInDtlBean) {
					/*clsGuestMasterBean objGuestMasterBean = new clsGuestMasterBean();
					objGuestMasterBean.setStrGuestCode(objCheckInDtlBean.getStrGuestCode());
					objGuestMasterBean.setStrGuestPrefix("");
					String[] arrSpGuest = objCheckInDtlBean.getStrGuestName().split(" ");
					objGuestMasterBean.setStrFirstName(arrSpGuest[0]);
					if(arrSpGuest.length>1){
						objGuestMasterBean.setStrMiddleName(arrSpGuest[1]);
						if(arrSpGuest.length==2){
						objGuestMasterBean.setStrLastName(arrSpGuest[2]);
						}
						}
					objGuestMasterBean.setIntFaxNo(0);
					objGuestMasterBean.setIntPinCode(0);
					objGuestMasterBean.setDteDOB("01-01-1900");
					objGuestMasterBean.setIntMobileNo(objCheckInDtlBean.getLngMobileNo());
					clsGuestMasterHdModel objGuestMasterModel = objGuestMasterService.funPrepareGuestModel(objGuestMasterBean, clientCode, userCode);
					objGuestMasterDao.funAddUpdateGuestMaster(objGuestMasterModel);
					*/hmGuestMbWithCode.put(objCheckInDtlBean.getLngMobileNo(), objCheckInDtlBean.getStrGuestCode());
					
				}
				List<clsCheckInDetailsBean> listCheckInDetailBean = new ArrayList<clsCheckInDetailsBean>();
				for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) {
					if (null != hmGuestMbWithCode.get(objCheckInDtlBean.getLngMobileNo())) {
						objCheckInDtlBean.setStrGuestCode(hmGuestMbWithCode.get(objCheckInDtlBean.getLngMobileNo()));
					}
					listCheckInDetailBean.add(objCheckInDtlBean);
				}
				objBean.setListCheckInDetailsBean(listCheckInDetailBean);
			}

			clsCheckInHdModel objHdModel = funPrepareHdModel(objBean, userCode, clientCode, req);

			/*
			 * List<clsCheckInDtl>
			 * listCheckInDtlModel=objHdModel.getListCheckInDtl();
			 * for(clsCheckInDtl objCheckInDtlModel:listCheckInDtlModel) {
			 * clsFolioHdBean objFolioBean=new clsFolioHdBean(); int
			 * cntFolios=0;
			 * 
			 * while(cntFolios<objCheckInDtlModel.getIntNoOfFolios()) {
			 * objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
			 * objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
			 * objFolioBean
			 * .setStrRegistrationNo(objHdModel.getStrRegistrationNo());
			 * objFolioBean
			 * .setStrReservationNo(objHdModel.getStrReservationNo());
			 * objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
			 * objFolioBean
			 * .setDteDepartureDate(objHdModel.getDteDepartureDate());
			 * objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
			 * objFolioBean
			 * .setTmeDepartureTime(objHdModel.getTmeDepartureTime());
			 * objFolioBean
			 * .setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
			 * clsFolioHdModel
			 * objFolioHdModel=objFolioController.funPrepareFolioModel
			 * (objFolioBean, clientCode, req);
			 * objFolioService.funAddUpdateFolioHd(objFolioHdModel);
			 * cntFolios++; } }
			 */

			List<clsCheckInDtl> listCheckInDtlModel = objHdModel.getListCheckInDtl();
			// for(clsCheckInDtl objCheckInDtlModel:listCheckInDtlModel)
			// {
			// clsFolioHdBean objFolioBean=new clsFolioHdBean();
			// int cntFolios=0;
			//
			// if(null!=objCheckInDtlModel.getStrPayee())
			// {
			// if(objCheckInDtlModel.getStrPayee().equals("Y"))
			// {
			// objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
			// objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
			// objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
			// objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
			// objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
			// objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
			// objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
			// objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
			// objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
			// objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
			// clsFolioHdModel
			// objFolioHdModel=objFolioController.funPrepareFolioModel(objFolioBean,
			// clientCode, req);
			// objFolioService.funAddUpdateFolioHd(objFolioHdModel);
			// cntFolios++;
			// }
			// }
			// }
			
			String sql1 = "select strfoliono from tblfoliohd " + " where strCheckInNo ='" + objBean.getStrCheckInNo() + "' ";
			List listCheckIn = objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");

			

			String folioN = "";
			if(listCheckIn!=null && listCheckIn.size()>0)
			{
				 folioN = (String) listCheckIn.get(0);
			} 

			List<clsPMSGroupBookingDtlModel> listGroupBookingDtlModel=new ArrayList<clsPMSGroupBookingDtlModel>();
			
			// load reservation then check is group reservation or not
			clsReservationHdModel objReservationModel1 = objReservationService.funGetReservationList(objBean.getStrAgainstDocNo(), clientCode, propCode);
			boolean isGroupReservation=false;
			if(objReservationModel1!=null)
			{
			String strGroupCode = objReservationModel1.getStrGroupCode();
			
			clsPMSGroupBookingHDModel objPMSGroupBookingModel = objPMSGroupBookingService.funGetPMSGroupBooking(strGroupCode, clientCode);
			
			if(objPMSGroupBookingModel!=null)
			{
				listGroupBookingDtlModel = objPMSGroupBookingModel.getListPMSGroupBookingDtlModel();
				isGroupReservation=true;
				
				
			}
			}
			
			
			//listGroupBookingDtlModel 
			
			
			
			List<String> listCheckRomm = new ArrayList<String>();
			List<clsFolioDtlModel> listFolioDtl = new ArrayList<clsFolioDtlModel>();
			for (clsCheckInDtl objCheckInDtlModel : listCheckInDtlModel) {
				clsFolioHdBean objFolioBean = new clsFolioHdBean();
				int cntFolios = 0;
				
				if (!listCheckRomm.contains(objCheckInDtlModel.getStrRoomNo())) {
					
					
					//check group reservation
					if(objCheckInDtlModel.getStrPayee()!=null && objCheckInDtlModel.getStrPayee().equalsIgnoreCase("Y") && isGroupReservation  ){
						
						// normal extry  for payee as guest
						objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
						objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
						objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
						objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
						objFolioBean.setStrWalkInNo(objHdModel.getStrWalkInNo());
						objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
						objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
						objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
						objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
						objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
						objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
						objFolioBean.setStrFolioNo(folioN);
						
						if(listGroupBookingDtlModel !=null && listGroupBookingDtlModel.size()>0)//  objeGroupdlt list >0 
						{
							for(clsPMSGroupBookingDtlModel objN:listGroupBookingDtlModel){
								 if(objN.getStrPayee().equalsIgnoreCase("Guest")){
									 	objFolioBean.setStrRoom(objN.getStrRoom());
										objFolioBean.setStrFandB(objN.getStrFandB());
										objFolioBean.setStrTelephone(objN.getStrTelephone());
										objFolioBean.setStrExtra(objN.getStrExtra());
								 }
							}
						     //list    
						}
						
						// set 4 para -- room yes fb y , tel y extra y
						
						clsFolioHdModel objFolioHdModel = objFolioController.funPrepareFolioModel(objFolioBean, clientCode, req);
						objFolioService.funAddUpdateFolioHd(objFolioHdModel);
						
						/////
						// Extra entry -- this entry for room payee
						 // 
						
						objFolioBean=new clsFolioHdBean();
						
						objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
						objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
						objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
						objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
						objFolioBean.setStrWalkInNo(objHdModel.getStrWalkInNo());
						objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
						objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
						objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
						objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
						objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
						objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
						objFolioBean.setStrFolioNo(folioN);
						
						if(listGroupBookingDtlModel !=null && listGroupBookingDtlModel.size()>0)//  objeGroupdlt list >0 
						{
							for(clsPMSGroupBookingDtlModel objN:listGroupBookingDtlModel){
								 if(objN.getStrPayee().equalsIgnoreCase("Group Leader")){
									 	objFolioBean.setStrRoom(objN.getStrRoom());
										objFolioBean.setStrFandB(objN.getStrFandB());
										objFolioBean.setStrTelephone(objN.getStrTelephone());
										objFolioBean.setStrExtra(objN.getStrExtra());
								 }
							}
							
							clsFolioHdModel objFolioHdModel1 = objFolioController.funPrepareFolioModel(objFolioBean, clientCode, req);
							objFolioService.funAddUpdateFolioHd(objFolioHdModel1);
							
						     //list    
						}
						
					}else{
						// normal extry
						objFolioBean.setStrRoomNo(objCheckInDtlModel.getStrRoomNo());
						objFolioBean.setStrCheckInNo(objHdModel.getStrCheckInNo());
						objFolioBean.setStrRegistrationNo(objHdModel.getStrRegistrationNo());
						objFolioBean.setStrReservationNo(objHdModel.getStrReservationNo());
						objFolioBean.setStrWalkInNo(objHdModel.getStrWalkInNo());
						objFolioBean.setDteArrivalDate(objHdModel.getDteArrivalDate());
						objFolioBean.setDteDepartureDate(objHdModel.getDteDepartureDate());
						objFolioBean.setTmeArrivalTime(objHdModel.getTmeArrivalTime());
						objFolioBean.setTmeDepartureTime(objHdModel.getTmeDepartureTime());
						objFolioBean.setStrExtraBedCode(objCheckInDtlModel.getStrExtraBedCode());
						objFolioBean.setStrGuestCode(objCheckInDtlModel.getStrGuestCode());
						objFolioBean.setStrFolioNo(folioN);
						
						if(listGroupBookingDtlModel !=null && listGroupBookingDtlModel.size()>0)//  objeGroupdlt list >0 
							{
								for(clsPMSGroupBookingDtlModel objN:listGroupBookingDtlModel){
									 if(objN.getStrPayee().equalsIgnoreCase("Guest")){
										 	objFolioBean.setStrRoom(objN.getStrRoom());
											objFolioBean.setStrFandB(objN.getStrFandB());
											objFolioBean.setStrTelephone(objN.getStrTelephone());
											objFolioBean.setStrExtra(objN.getStrExtra());
									 }
								}
							     //list    
							}else{
								objFolioBean.setStrRoom("Y");
								objFolioBean.setStrFandB("Y");
								objFolioBean.setStrTelephone("Y");
								objFolioBean.setStrExtra("Y");
								//  set 4 para -- room yes fb y , tel y extra y 
							}
						
						
						clsFolioHdModel objFolioHdModel = objFolioController.funPrepareFolioModel(objFolioBean, clientCode, req);
						objFolioService.funAddUpdateFolioHd(objFolioHdModel);
					}
					
					
					
					cntFolios++;

				}
				listCheckRomm.add(objCheckInDtlModel.getStrRoomNo());
			}

			objCheckInService.funAddUpdateCheckInHd(objHdModel);
			
			if(objBean.getStrType().equals("Reservation"))
			{
				clsReservationHdModel objReservationModel = objReservationService.funGetReservationList(objBean.getStrAgainstDocNo(), clientCode, propCode);
				List<clsReservationRoomRateModelDtl> listRommRate = new ArrayList<clsReservationRoomRateModelDtl>();
				if(null!=objBean.getlistReservationRoomRateDtl())
				{
				for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getlistReservationRoomRateDtl()) 
				{
					String date=objRommDtlBean.getDtDate();
					if(date.split("-")[0].toString().length()<3)
					{	
					 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
					}
					listRommRate.add(objRommDtlBean);
				}
			    }
				objReservationModel.setListReservationRoomRateDtl(listRommRate);
				objReservationService.funAddUpdateReservationHd(objReservationModel, objReservationModel.getStrBookingTypeCode());	
				
			}
			else
			{
				List listWalkinData = objWalkinDao.funGetWalkinDataDtl(objBean.getStrAgainstDocNo(), clientCode);
				clsWalkinHdModel objWalkinHdModel = (clsWalkinHdModel) listWalkinData.get(0);
				List<clsWalkinRoomRateDtlModel> listRommRate = new ArrayList<clsWalkinRoomRateDtlModel>();
				//listRommRate=objWalkinHdModel.getListWalkinRoomRateDtlModel();
				if(null!=objBean.getListWalkinRoomRateDtl()){
					for (clsWalkinRoomRateDtlModel objRommDtlBean :objBean.getListWalkinRoomRateDtl()) {
					
						String date=objRommDtlBean.getDtDate();
						if(date.split("-")[0].toString().length()<3)
						{	
						 objRommDtlBean.setDtDate(objGlobal.funGetDate("yyyy-MM-dd",date));
						}
						listRommRate.add(objRommDtlBean);
					}
					}
				objWalkinHdModel.setListWalkinRoomRateDtlModel(listRommRate);
				objWalkinDao.funAddUpdateWalkinHd(objWalkinHdModel);
			}
			
			
			if(null!=objBean.getListRoomPackageDtl() && objBean.getListRoomPackageDtl().size()>0 )
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
				objPkgHdModel.setDblPackageAmt(Double.valueOf(objBean.getStrTotalPackageAmt()));
				objPkgHdModel.setStrUserCreated(userCode);
				objPkgHdModel.setStrUserEdited(userCode);
				objPkgHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objPkgHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objPkgHdModel.setStrClientCode(clientCode);
				List<clsPackageMasterDtl> listPkgDtlModel = new ArrayList<clsPackageMasterDtl>();
				String insertPkgDtl= "INSERT INTO `tblroompackagedtl` (`strWalkinNo`, `strReservationNo`,"
						+ " `strCheckInNo`, `strPackageCode`, `strIncomeHeadCode`, `dblIncomeHeadAmt`, "
						+ "`strType`,`strRoomNo`,`strClientCode`) VALUES";
				
				if(objBean.getStrType().equals("Reservation"))
				{
					objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strReservationNo='"+objHdModel.getStrReservationNo()+"' and strClientCode='"+clientCode+"'", "sql");
					objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strCheckInNo='"+objHdModel.getStrCheckInNo()+"' and strReservationNo='"+objHdModel.getStrReservationNo()+"' and strClientCode='"+clientCode+"'", "sql");
					for (clsRoomPackageDtl objPkgDtlBean : objBean.getListRoomPackageDtl()) 
					{
						insertSql+=",('','"+objHdModel.getStrReservationNo()+"','"+objHdModel.getStrCheckInNo()+"' "
								+ ",'"+packageCode+"','"+objPkgDtlBean.getStrIncomeHeadCode()+"','"+Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt())+"'"
								+ ",'IncomeHead','','"+clientCode+"')";
							flgData=true;
							
						clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
						objPkdDtl.setStrIncomeHeadCode(objPkgDtlBean.getStrIncomeHeadCode());
						objPkdDtl.setDblAmt(Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt()));
						listPkgDtlModel.add(objPkdDtl);
					}
					if(strPackageInclusiveRoomTerrif.equalsIgnoreCase("Y"))
					{
						for (clsReservationRoomRateModelDtl objRommDtlBean : objBean.getlistReservationRoomRateDtl()) 
						{
							for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) 
							{
								if(objRommDtlBean.getStrRoomType().equals(objCheckInDtlBean.getStrRoomType()))
								{
									insertSql+=",('','"+objHdModel.getStrReservationNo()+"','"+objHdModel.getStrCheckInNo()+"' "
											+ ",'"+packageCode+"','','"+objRommDtlBean.getDblRoomRate()+"' "
											+ ",'RoomTariff','"+objCheckInDtlBean.getStrRoomNo()+"','"+clientCode+"')";									
								}
							}
						 }
					}
					
				}
				else
				{
					objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strWalkinNo='"+objHdModel.getStrWalkInNo()+"' and strClientCode='"+clientCode+"'", "sql");
					objWebPMSUtility.funExecuteUpdate("delete from tblroompackagedtl where strCheckInNo='"+objHdModel.getStrCheckInNo()+"' and strWalkinNo='"+objHdModel.getStrWalkInNo()+"' and strClientCode='"+clientCode+"'", "sql");
					for (clsRoomPackageDtl objPkgDtlBean : objBean.getListRoomPackageDtl()) 
					{
						insertSql+=",('"+objHdModel.getStrWalkInNo()+"','','"+objHdModel.getStrCheckInNo()+"' "
								+ ",'"+packageCode+"','"+objPkgDtlBean.getStrIncomeHeadCode()+"','"+Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt())+"'"
								+ ",'IncomeHead','','"+clientCode+"')";
							flgData=true;
							
						clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
						objPkdDtl.setStrIncomeHeadCode(objPkgDtlBean.getStrIncomeHeadCode());
						objPkdDtl.setDblAmt(Double.valueOf(objPkgDtlBean.getDblIncomeHeadAmt()));
						listPkgDtlModel.add(objPkdDtl);
					}
					if(strPackageInclusiveRoomTerrif.equalsIgnoreCase("Y"))
					{
						for (clsWalkinRoomRateDtlModel objRommDtlBean : objBean.getListWalkinRoomRateDtl()) 
						{
							for (clsCheckInDetailsBean objCheckInDtlBean : objBean.getListCheckInDetailsBean()) 
							{
								if(objRommDtlBean.getStrRoomType().equals(objCheckInDtlBean.getStrRoomType()))
								{
									insertSql+=",('"+objHdModel.getStrWalkInNo()+"','','"+objHdModel.getStrCheckInNo()+"' "
								    		 + ",'"+packageCode+"','','"+objRommDtlBean.getDblRoomRate()+"' "
												+ ",'RoomTariff','"+objCheckInDtlBean.getStrRoomNo()+"','"+clientCode+"')";
									
								}
							}
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
						e.printStackTrace();
					}
				}
				
		    }
			
			///Change for saving changed roomtype details....
			if(null!=listCheckInDtlModel)
			{
				for (clsCheckInDtl objCheckInDtlModel : listCheckInDtlModel) 
				{
					String date="",oldRoomType="",oldRoomNo="";
					boolean isFound=false;
					String sql = " select a.strDocNo,a.strRoomType,a.dteToDate,a.strRoomNo from tblchangedroomtypedtl a where a.strDocNo='"+objHdModel.getStrCheckInNo()+"' "
							+ " and a.strClientCode='"+clientCode+"'  and a.strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' ";
					List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
					if(list.size()>0)
					{
						for (int cnt = 0; cnt < list.size(); cnt++) {
							Object[] arrObjRoom = (Object[]) list.get(cnt);
							if(!arrObjRoom[1].toString().isEmpty())
							{
								date=arrObjRoom[2].toString();
								if(!objCheckInDtlModel.getStrRoomNo().equals(arrObjRoom[3]))
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
									oldRoomNo=(String) arrObjRoom[3];
								}
							}
						}	
					}
					
				if(oldRoomType.isEmpty())
				{
					oldRoomType=objCheckInDtlModel.getStrRoomType();	
					oldRoomNo=objCheckInDtlModel.getStrRoomNo();
				}
				
				objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrCheckInNo()+"' and strRoomType='"+oldRoomType+"' and strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");	
				
				String insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
						+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
						+ " `dteToDate`, `strClientCode`) "
						+ " VALUES ('"+objHdModel.getStrCheckInNo()+"','CheckIn','"+oldRoomNo+"','"+oldRoomType+"',"
						+ " '"+objCheckInDtlModel.getStrGuestCode()+"','"+PMSDate+"','"+date+"','"+clientCode+"') ";
				objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");	

					if(isFound)
					{
						objWebPMSUtility.funExecuteUpdate("delete from tblchangedroomtypedtl where strDocNo='"+objHdModel.getStrCheckInNo()+"' and strRoomType='"+objCheckInDtlModel.getStrRoomType()+"' and strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' and strClientCode='"+clientCode+"'", "sql");
						insertChangedRoomType = "INSERT INTO `tblchangedroomtypedtl` (`strDocNo`, `strType`,"
								+ " `strRoomNo`, `strRoomType`, `strGuestCode`, `dteFromDate`, "
								+ " `dteToDate`, `strClientCode`) "
								+ " VALUES ('"+objHdModel.getStrCheckInNo()+"','CheckIn','"+objCheckInDtlModel.getStrRoomNo()+"','"+objCheckInDtlModel.getStrRoomType()+"',"
								+ " '"+objCheckInDtlModel.getStrGuestCode()+"','"+PMSDate+"','','"+clientCode+"') ";
						objWebPMSUtility.funExecuteUpdate(insertChangedRoomType, "sql");
						
						/*sql="update tblroom a set a.strStatus='Free' where a.strRoomCode='"+oldRoomNo+"'";
						objWebPMSUtility.funExecuteUpdate(sql, "sql");*/ 
						
						sql="update tblroom a set a.strStatus='Occupied' where a.strRoomCode='"+objCheckInDtlModel.getStrRoomNo()+"'";
						objWebPMSUtility.funExecuteUpdate(sql, "sql"); 
						
						sql="update tblreservationdtl a set a.strRoomType='"+objCheckInDtlModel.getStrRoomType()+"' , a.strRoomNo='"+objCheckInDtlModel.getStrRoomNo()+"' where a.strReservationNo='"+objHdModel.getStrReservationNo()+"' and a.strGuestCode='"+objCheckInDtlModel.getStrGuestCode()+"' ";
						objWebPMSUtility.funExecuteUpdate(sql, "sql"); 
					}
				}
			}
			
 
			funPostRoomTarrif(objHdModel.getStrCheckInNo(),clientCode,PMSDate,propCode,userCode);
			
			funSendSMSCheckIn(objHdModel.getStrCheckInNo(), clientCode, propCode);
			
			clsPropertySetupHdModel objModel = objPropertySetupService.funGetPropertySetup(propCode, clientCode);
			if(objModel.getStrOnlineIntegration().equalsIgnoreCase("Yes"))
			{
				funCallAPI(objModel,clientCode,PMSDate);
			}
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Check In No : ".concat(objHdModel.getStrCheckInNo()));
			req.getSession().setAttribute("AdvanceAmount", objHdModel.getStrCheckInNo());
			req.getSession().setAttribute("against", objHdModel.getStrType());
			}
			return new ModelAndView("redirect:/frmCheckIn.html");
		} else {
			return new ModelAndView("frmCheckIn");
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

	private void funPostRoomTarrif(String strCheckInNo,String clientCode,String strpmsDate,String propCode,String userCode) 
	{
		String[] arrSpDate = strpmsDate.split("-");
		Date dtNextDate = new Date(Integer.parseInt(arrSpDate[0]), Integer.parseInt(arrSpDate[1]), Integer.parseInt(arrSpDate[2]));
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(dtNextDate);
		cal.add(Calendar.DATE, 1);
		String newStartDate = cal.getTime().getYear() + "-" + (cal.getTime().getMonth()) + "-" + (cal.getTime().getDate());
		List<String> listRoomTerrifDocNo = new ArrayList<String>();
		String strTransactionType = "Check In";
		String sqlPostRoom = "SELECT a.strFolioNo,a.strRoomNo,c.dblRoomTerrif,a.strExtraBedCode, "
				+ "IFNULL(a.strReservationNo,''), IFNULL(a.strWalkInNo,''),c.strRoomTypeCode, "
				+ "IFNULL(SUM(d.dblIncomeHeadAmt),0), IFNULL(e.strComplimentry,'N'),ifnull(d.strPackageCode,'') "
				+ "FROM tblfoliohd a LEFT OUTER JOIN tblroompackagedtl d ON a.strCheckInNo=d.strCheckInNo,"
				+ "tblroom b,tblroomtypemaster c,tblcheckinhd e WHERE a.strRoomNo=b.strRoomCode "
				+ "AND b.strRoomTypeCode=c.strRoomTypeCode AND a.strCheckInNo=e.strCheckInNo "
				+ "and e.strCheckInNo='"+strCheckInNo+"' AND a.strClientCode='"+clientCode+"'  AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' GROUP BY a.strFolioNo ";
		
		List listRoomInfo = objGlobalFunctionsService.funGetListModuleWise(sqlPostRoom, "sql");
		String strPackageInclusiveRoomTerrif="N";
		
		for (int cnt = 0; cnt < listRoomInfo.size(); cnt++) 
		{
			
			clsPostRoomTerrifBean objPostRoomTerrifBean = new clsPostRoomTerrifBean();
			Object[] arrObjRoom = (Object[]) listRoomInfo.get(cnt);
			double dblRoomRate=0.0;
			List listPackage = objGlobalFunctionsService.funGetListModuleWise("select a.strPackageCode,a.strPackageInclusiveRoomTerrif from tblpackagemasterhd "
					+ " a where a.strPackageCode='"+arrObjRoom[9].toString()+"' and a.strClientCode='"+clientCode+"' ", "sql");
			if(listPackage!=null && listPackage.size()>0 )
			{
				Object[] obj=(Object[])listPackage.get(0);
				strPackageInclusiveRoomTerrif=obj[1].toString();
			}
			
			if(!arrObjRoom[4].toString().equals(""))
			{
				 String sqlRoomRate=" select a.dblRoomRate from  tblreservationroomratedtl a "
					        +" where a.strReservationNo='"+arrObjRoom[4].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[6].toString()+"' and a.dtDate='"+strpmsDate+"' ";
				 List listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
				 
				 	/*String sqlUpdateDepartureDate = "update tblcheckinhd a set a.dteDepartureDate='"+newStartDate+"' where a.strClientCode='"+clientCode+"' AND a.strReservationNo='"+arrObjRoom[4].toString()+"' ";
					objWebPMSUtility.funExecuteUpdate(sqlUpdateDepartureDate, "sql");*/ 

				 
				 if(listRoomRate.size()>0)
				 {
					 dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
				 }
				 else
				 {
					  sqlRoomRate=" select a.dblRoomRate from  tblreservationroomratedtl a "
						        +" where a.strReservationNo='"+arrObjRoom[4].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[6].toString()+"' order by date(a.dtDate) desc ";
					  listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
					 if(listRoomRate.size()>0)
					 {
						 dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
					 }
				 }
			}
			if(!arrObjRoom[5].toString().equals(""))
			{
				String sqlRoomRate=" select a.dblRoomRate from  tblwalkinroomratedtl a "
					        +" where a.strWalkinNo='"+arrObjRoom[5].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[6].toString()+"' and a.dtDate='"+strpmsDate+"' ";
				 List listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
				 
				 	/*String sqlUpdateDepartureDate = "update tblcheckinhd a set a.dteDepartureDate='"+newStartDate+"' where a.strClientCode='"+clientCode+"' AND a.strWalkInNo='"+arrObjRoom[5].toString()+"' ";
					objWebPMSUtility.funExecuteUpdate(sqlUpdateDepartureDate, "sql"); */

				 
				 if(listRoomRate.size()>0)
				 {
				    dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
				 }
				 else
				 {
					sqlRoomRate=" select a.dblRoomRate from  tblwalkinroomratedtl a "
						        +" where a.strWalkinNo='"+arrObjRoom[5].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[6].toString()+"'  order by date(a.dtDate) desc ";
					  listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
					 if(listRoomRate.size()>0)
					 {
					    dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
					 }
				 }
			}
			objPostRoomTerrifBean = new clsPostRoomTerrifBean();
			objPostRoomTerrifBean.setStrFolioNo(arrObjRoom[0].toString());
			objPostRoomTerrifBean.setStrRoomNo(arrObjRoom[1].toString());
			if(arrObjRoom[8].toString().equals("Y"))
			{
				objPostRoomTerrifBean.setDblRoomTerrif(0.0);
				objPostRoomTerrifBean.setDblOriginalPostingAmt(0.0);
			}
			else
			{
				objPostRoomTerrifBean.setDblRoomTerrif(dblRoomRate);
				objPostRoomTerrifBean.setDblOriginalPostingAmt(dblRoomRate);
			}
			objPostRoomTerrifBean.setStrFolioType("Room");
			String folioNo = arrObjRoom[0].toString();
			if(Double.valueOf(arrObjRoom[7].toString())>0)
			{
				if(strPackageInclusiveRoomTerrif.equalsIgnoreCase("Y"))
				{
					String docNo = objPostRoomTerrif.funInsertFolioRecords(folioNo, clientCode, propCode, objPostRoomTerrifBean,  strpmsDate, arrObjRoom[3].toString(),strTransactionType,userCode);
					listRoomTerrifDocNo.add(docNo);
				}
			}
			else
			{
				
			    String docNo = objPostRoomTerrif.funInsertFolioRecords(folioNo, clientCode, propCode, objPostRoomTerrifBean,  strpmsDate, arrObjRoom[3].toString(),strTransactionType,userCode);
			    listRoomTerrifDocNo.add(docNo);
				
			}
			
			
			if(Double.valueOf(arrObjRoom[7].toString())>0)
			{   
				dblRoomRate=Double.valueOf(arrObjRoom[7].toString());
				objPostRoomTerrifBean = new clsPostRoomTerrifBean();
				objPostRoomTerrifBean.setStrFolioNo(arrObjRoom[0].toString());
				objPostRoomTerrifBean.setStrRoomNo(arrObjRoom[1].toString());
				objPostRoomTerrifBean.setDblRoomTerrif(dblRoomRate);
				objPostRoomTerrifBean.setDblOriginalPostingAmt(dblRoomRate);
				objPostRoomTerrifBean.setStrFolioType("Package");
				folioNo = arrObjRoom[0].toString();
				String docNo=objPostRoomTerrif.funInsertFolioRecords(folioNo, clientCode, propCode, objPostRoomTerrifBean,strpmsDate, arrObjRoom[3].toString(),strTransactionType,userCode);	
				listRoomTerrifDocNo.add(docNo);
			} 
			
			
			
		
		}
		
		
	}

	//check in slip
		@SuppressWarnings("unchecked")
		@RequestMapping(value = "/rptCheckInSlip", method = RequestMethod.GET)	
        public void funGeneratePaymentRecipt(@RequestParam("checkInNo") String reciptNo,@RequestParam("cmbAgainst") String strAgainst , HttpServletRequest req, HttpServletResponse resp) {
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
					// Object[] userData = (Object[]) listOfUser.get(0);
					userName = listOfUser.get(0).toString();
				}
				clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
				HashMap reportParams = new HashMap();			
				ArrayList datalist = new ArrayList();
				String reportName;
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportName= servletContext.getRealPath("/WEB-INF/reports/webpms/rptCheckInSlip1.jrxml");			
				}
				else
				{
					reportName= servletContext.getRealPath("/WEB-INF/reports/webpms/rptCheckInSlip.jrxml");
				}
				
				if(strAgainst.equalsIgnoreCase("Walk In")){
				String sql = "SELECT a.strCheckInNo,a.strGuestCode,f.strRoomDesc,"
						+ "ifnull(a.strExtraBedCode,''), b.strRoomTypeDesc,"
						+ "c.dblRoomRate, IFNULL(c.dblDiscount,0.0),d.intNoOfAdults,"
						+ " DATE_FORMAT(d.dteCheckInDate,'%d-%m-%Y'),e.strGSTNo,"
						+ "e.strPANNo, d.tmeArrivalTime,ifnull(g.dblChargePerBed,0), "
						+ "e.strFirstName,e.strMiddleName,e.strLastName, "
						+ "IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), "
						+ "IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''), "
						+ " IFNULL(e.intPinCodeOfc,''),IFNULL(e.lngMobileNo,0),d.strComplimentry,DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y'),e.strAddressLocal,e.strEmailId,  "
						+ " e.strPassportNo,e.dtePassportExpiryDate,e.dtePassportIssueDate,e.strNationality "
						+ "FROM tblroomtypemaster b,tblwalkinroomratedtl c, "
						+ "tblcheckinhd d,tblguestmaster e,tblroom f, "
						+ "tblcheckindtl a left outer join  tblextrabed g on "
						+ "g.strExtraBedTypeCode=a.strExtraBedCode  AND g.strClientCode='"+clientCode+"'"
						+ "WHERE a.strRoomType=b.strRoomTypeCode "
						+ "AND c.strWalkinNo=d.strWalkInNo "
						+ "AND a.strGuestCode=e.strGuestCode "
						+ "AND a.strCheckInNo=d.strCheckInNo  "
						+ "AND d.strCheckInNo = '"+reciptNo+"' "
						+ "AND a.strRoomNo=f.strRoomCode "
						+ "AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' AND f.strClientCode='"+clientCode+"'  ; ";
				
				List listCheckInsData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				Object[] arrObjRoomData = (Object[]) listCheckInsData.get(0);
				clsCheckInBean objCheckInBean = new clsCheckInBean();
				objCheckInBean.setStrCheckInNo(arrObjRoomData[0].toString());
				String guestCode = arrObjRoomData[1].toString();
				objCheckInBean.setStrRoomNo(arrObjRoomData[2].toString());
				objCheckInBean.setStrExtraBedCode(arrObjRoomData[3].toString());
				String roomType = arrObjRoomData[4].toString();
				double roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[5].toString());					
				double discount  = Double.parseDouble(arrObjRoomData[6].toString());
				objCheckInBean.setIntNoOfAdults(Integer.parseInt(arrObjRoomData[7].toString()));
				objCheckInBean.setDteArrivalDate(arrObjRoomData[8].toString());
				String gstNo = arrObjRoomData[9].toString();
				String paNo = arrObjRoomData[10].toString();
				objCheckInBean.setTmeArrivalTime(arrObjRoomData[11].toString());
				double dblExtraBedAmt = Double.parseDouble(arrObjRoomData[12].toString());
				if(!objCheckInBean.getStrExtraBedCode().isEmpty())
				{
					roomTarrifWithExtraBed = dblExtraBedAmt+roomTarrifWithExtraBed;
				}
				String gFirstName = arrObjRoomData[13].toString();
				String gMiddleName = arrObjRoomData[14].toString();
				String gLastName = arrObjRoomData[15].toString();
				/*String guestCompanyAddr = arrObjRoomData[16].toString() + ","
						+ arrObjRoomData[17].toString() + ","
						+ arrObjRoomData[18].toString() + ","
						+ arrObjRoomData[19].toString() + ","
						+ arrObjRoomData[20].toString();*/
				String guestCompanyAddr= arrObjRoomData[15].toString() ;
				if(!arrObjRoomData[16].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[16].toString();
				}
				else if(!arrObjRoomData[17].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[17].toString();
				}
				else if(!arrObjRoomData[18].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[18].toString();
				}
				else if(!arrObjRoomData[19].toString().equalsIgnoreCase("0"))
				{
					guestCompanyAddr="," + arrObjRoomData[19].toString();
				}
				else
				{
					guestCompanyAddr=guestCompanyAddr;
				}
				//clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
				String strMobileNo = arrObjRoomData[21].toString();
				String strComplimentry = arrObjRoomData[22].toString();
				
				 String arrDate = arrObjRoomData[23].toString();
			     String depDate = arrObjRoomData[24].toString();
			     
			     Date arrivalDte=new SimpleDateFormat("dd-MM-yyyy").parse(arrDate);  
			     Date departureDte=new SimpleDateFormat("dd-MM-yyyy").parse(depDate); 
			     long arrTme=arrivalDte.getTime();
			     long deptTme=departureDte.getTime();
			     long difference = departureDte.getTime()- arrivalDte.getTime();
			     double daysBetween = (difference / (1000*60*60*24));
			     
				 double roomTarrif = Double.parseDouble(arrObjRoomData[5].toString());
				//List<clsTaxProductDtl> listTaxProdDtl = new ArrayList<clsTaxProductDtl>();
				//Map<String, List<clsTaxCalculation>> hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");

				Date dt = new Date();
				String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();
				double finalTax = 0.0;
				double tariffAmt = roomTarrifWithExtraBed-((roomTarrifWithExtraBed*discount)/100);
				double discAmt = ((roomTarrifWithExtraBed*discount)/100);
                if(!clientCode.equalsIgnoreCase("383.001"))
                {
                	String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
    						+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
    						+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
    						+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' AND strClientCode = '"+clientCode+"'";
    				
    				List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
    				
    				
    				String strTaxOn="";
    				for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
    					String taxCalType = "Forward";
    					Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
    					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
    					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
    					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
    					if(fromRate<(tariffAmt)&& (tariffAmt)<=toRate)
    					{
    						double taxAmt = 0;
    						if (taxCalType.equals("Forward")) // Forward Tax
                                            // Calculation
    					    {
    							taxAmt = (tariffAmt * taxValue) / 100;
    						} 
    						else // Backward Tax Calculation
    						{
    							taxAmt = tariffAmt * 100 / (100 + taxValue);
    							taxAmt = tariffAmt - taxAmt;
    						}
    						finalTax = finalTax+taxAmt;
    					}
    					else
    					{
    						
    					}
    				}
    				
                }
			
				datalist.add(objCheckInBean);
				
				//reportParams.put("pgstno", gstNo);
				reportParams.put("ppanno", paNo);
				reportParams.put("pguestCode", guestCode);
				reportParams.put("proomType", roomType);
				reportParams.put("pCompanyName", companyName);
				reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
				reportParams.put("pContactDetails", "");
				reportParams.put("strImagePath", imagePath);
				reportParams.put("userName", userName);
				reportParams.put("pGuestName", gFirstName + " "+ gMiddleName + " " + gLastName);
				//reportParams.put("pguestCompanyAddr", guestCompanyAddr);
				reportParams.put("pguestCompanyAddr", arrObjRoomData[24].toString());
				reportParams.put("pstrMobileNo", strMobileNo);
				
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("pDepartureDate", depDate);
					reportParams.put("pDepartureTime", objPropertySetupModel.getTmeCheckOutTime());
					reportParams.put("pCity",  arrObjRoomData[17].toString());
					reportParams.put("pCountry", arrObjRoomData[18].toString());
					reportParams.put("pEmail",  arrObjRoomData[26].toString());
					
					
					reportParams.put("pPassportNo",  arrObjRoomData[27].toString());
					reportParams.put("pDateOfExpiry",  arrObjRoomData[28].toString());
					reportParams.put("pDateOfIssue",  arrObjRoomData[29].toString());
					reportParams.put("pNationality", arrObjRoomData[30].toString());
					reportParams.put("pPlaceOfIssue",  " ");
					
				}
				
				if(clientCode.equalsIgnoreCase("383.001"))
				{
					reportParams.put("strImagePath1", imagePath1);	
				}
				else
				{
					reportParams.put("strImagePath1", null);
				}
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("pNote1", objPropertySetupModel.getStrCheckInFooter());
					reportParams.put("pNote2",null);
				}
				else
				{
					reportParams.put("pNote1", "1. Advance paid is non-refundable");
					reportParams.put("pNote2","2. Above information read and accepted");
				}
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("pNote", null);
					reportParams.put("pCustomerGST",null);
					reportParams.put("pgstno", null);
					reportParams.put("lblTax", null);
					reportParams.put("plblDaysForAccomodation", "Total Days For Accomodation :");
					reportParams.put("daysForAccomodation", daysBetween);
					reportParams.put("pPolicy1", null);
					reportParams.put("pPolicy2", null); 
                  
				}
				else
				{
					reportParams.put("pNote", "Note");
					reportParams.put("pCustomerGST","Customer GST :");
					reportParams.put("pgstno", gstNo);
					reportParams.put("lblTax", "Tax  :");
					reportParams.put("plblDaysForAccomodation", null);
					reportParams.put("daysForAccomodation",null );
					reportParams.put("pPolicy1", "1. Advance paid is non-refundable");
					reportParams.put("pPolicy2", "2. Above information read and accepted");
				}
				
				
				if(strComplimentry.equalsIgnoreCase("N"))
				{
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					else
					{
						reportParams.put("ptaxAmt", finalTax);
					}
				
				
				reportParams.put("proomTarrif", roomTarrif);
				reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
				reportParams.put("pdiscount", discAmt);
				}
				else
				{
					finalTax=0.0;
					roomTarrif=0.0;
					discAmt = 0.0;
					roomTarrifWithExtraBed=0.0;

					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					else
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					
					reportParams.put("proomTarrif", roomTarrif);
					reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
					reportParams.put("pdiscount", discAmt);
				}
				}
				else
				{
					String sqlReservation ="SELECT a.strCheckInNo,a.strGuestCode,"
							+ "f.strRoomDesc, IFNULL(a.strExtraBedCode,''),"
							+ "b.strRoomTypeDesc,b.dblRoomTerrif,d.intNoOfAdults, "
							+ "DATE_FORMAT(d.dteCheckInDate,'%d-%m-%Y'),e.strGSTNo,"
							+ "e.strPANNo, d.tmeArrivalTime, IFNULL(g.dblChargePerBed,0), "
							+ "e.strFirstName,e.strMiddleName,e.strLastName, "
							+ "IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), "
							+ "IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''), "
							+ "IFNULL(e.intPinCodeOfc,''), IFNULL(e.lngMobileNo,0) ,d.strComplimentry,DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y') ,h.dblRoomRate,e.strAddressLocal,e.strEmailId, "
							+ " e.strPassportNo,e.dtePassportExpiryDate,e.dtePassportIssueDate,e.strNationality "
							+ "FROM tblroomtypemaster b ,tblguestmaster e,"
							+ "tblroom f, tblcheckindtl a "
							+ "LEFT OUTER JOIN tblextrabed g ON g.strExtraBedTypeCode=a.strExtraBedCode "
							+ ", tblcheckinhd d"
							+ " LEFT OUTER"
							+ " JOIN tblreservationroomratedtl h ON h.strReservationNo=d.strReservationNo "
							+ "WHERE a.strRoomType=b.strRoomTypeCode AND a.strGuestCode=e.strGuestCode  "
							+ "AND a.strCheckInNo=d.strCheckInNo  AND d.strCheckInNo = '"+reciptNo+"' "
							+ "AND a.strRoomNo=f.strRoomCode ; ";
					List listCheckInRes = objGlobalFunctionsService.funGetListModuleWise(sqlReservation, "sql");

					Object[] arrObjRoomData = (Object[]) listCheckInRes.get(0);
					clsCheckInBean objCheckInBean = new clsCheckInBean();
					objCheckInBean.setStrCheckInNo(arrObjRoomData[0].toString());
					String guestCode = arrObjRoomData[1].toString();
					objCheckInBean.setStrRoomNo(arrObjRoomData[2].toString());
					objCheckInBean.setStrExtraBedCode(arrObjRoomData[3].toString());
					String roomType = arrObjRoomData[4].toString();
					double roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[5].toString());					
					/*double discount  = Double.parseDouble(arrObjRoomData[6].toString());*/
					objCheckInBean.setIntNoOfAdults(Integer.parseInt(arrObjRoomData[6].toString()));
					objCheckInBean.setDteArrivalDate(arrObjRoomData[7].toString());
					String gstNo = arrObjRoomData[8].toString();
					String paNo = arrObjRoomData[9].toString();
					objCheckInBean.setTmeArrivalTime(arrObjRoomData[10].toString());
					double dblExtraBedAmt = Double.parseDouble(arrObjRoomData[11].toString());
					if(!objCheckInBean.getStrExtraBedCode().isEmpty())
					{
						roomTarrifWithExtraBed = dblExtraBedAmt+roomTarrifWithExtraBed;
					}
					String gFirstName = arrObjRoomData[12].toString();
					String gMiddleName = arrObjRoomData[13].toString();
					String gLastName = arrObjRoomData[14].toString();
					/*String guestCompanyAddr = arrObjRoomData[15].toString() + ","
							+ arrObjRoomData[16].toString() + ","
							+ arrObjRoomData[17].toString() + ","
							+ arrObjRoomData[18].toString() + ","
							+ arrObjRoomData[19].toString();*/
					String guestCompanyAddr= arrObjRoomData[15].toString() ;
					if(!arrObjRoomData[16].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[16].toString();
					}
					else if(!arrObjRoomData[17].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[17].toString();
					}
					else if(!arrObjRoomData[18].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[18].toString();
					}
					else if(!arrObjRoomData[19].toString().equalsIgnoreCase("0"))
					{
						guestCompanyAddr="," + arrObjRoomData[19].toString();
					}
					else
					{
						guestCompanyAddr=guestCompanyAddr;
					}
					
					String strMobileNo = arrObjRoomData[20].toString();
					String strComplimentry = arrObjRoomData[21].toString();
					
					 String arrDate = arrObjRoomData[22].toString();
				     String depDate = arrObjRoomData[23].toString();
				   
				     Date arrivalDte=new SimpleDateFormat("dd-MM-yyyy").parse(arrDate);  
				     Date departureDte=new SimpleDateFormat("dd-MM-yyyy").parse(depDate); 
				     
				     long arrTme=arrivalDte.getTime();
				     long deptTme=departureDte.getTime();
				     long difference = departureDte.getTime()- arrivalDte.getTime();
				     double daysBetween = (difference / (1000*60*60*24));
				     double roomTarrif=0;
				     double roomTarrifRoomrateChange=0;
				     if(listCheckInRes!=null && listCheckInRes.size()>0)
				     {
				    	 for(int i=0;i<listCheckInRes.size();i++)
				    	 {
				    		 Object[] obj=( Object[] )listCheckInRes.get(i);
				    		 if(Double.parseDouble(obj[24].toString())>0)
				    		 {
				    			  roomTarrifRoomrateChange += Double.parseDouble(obj[24].toString());
				    		 }
				    		 else
				    		 {
				    			 roomTarrif += Double.parseDouble(obj[5].toString());
				    		 }
				    	 }
				    
				    	
				     }
					
					
					
					
					//List<clsTaxProductDtl> listTaxProdDtl = new ArrayList<clsTaxProductDtl>();
					//Map<String, List<clsTaxCalculation>> hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");

					Date dt = new Date();
					String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();
					double finalTax = 0.0;
					double discount=0.0;
					double tariffAmt = roomTarrifWithExtraBed-((roomTarrifWithExtraBed*discount)/100);
					double discAmt = ((roomTarrifWithExtraBed*discount)/100);
					String strTaxOn="";
					
					if(!clientCode.equalsIgnoreCase("383.001"))
		            {
						String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
								+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
								+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
								+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' ";
						
						List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
						
						for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
							String taxCalType = "Forward";
							Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
							double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
							double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
							double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
							if(fromRate<(tariffAmt)&& (tariffAmt)<=toRate)
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
																	// Calculation
								{
									taxAmt = (tariffAmt * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = tariffAmt * 100 / (100 + taxValue);
									taxAmt = tariffAmt - taxAmt;
								}
								finalTax = finalTax+taxAmt;
							}
							else
							{
								
							}
						} 
		            }
					
					datalist.add(objCheckInBean);
					
					
					
					reportParams.put("ppanno", paNo);
					reportParams.put("pguestCode", guestCode);
					reportParams.put("proomType", roomType);
					reportParams.put("pCompanyName", companyName);
					reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
					reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
					reportParams.put("pContactDetails", "");
					reportParams.put("strImagePath", imagePath);
					reportParams.put("userName", userName);
					reportParams.put("pGuestName", gFirstName + " "+ gMiddleName + " " + gLastName);
					//reportParams.put("pguestCompanyAddr", guestCompanyAddr);
					reportParams.put("pguestCompanyAddr", arrObjRoomData[25].toString());
					reportParams.put("pstrMobileNo", strMobileNo);
					
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("pDepartureDate", depDate);
						reportParams.put("pDepartureTime", objPropertySetupModel.getTmeCheckOutTime());
						reportParams.put("pCity",  arrObjRoomData[17].toString());
						reportParams.put("pCountry", arrObjRoomData[18].toString());
						reportParams.put("pEmail",  arrObjRoomData[26].toString());
						
						
						reportParams.put("pPassportNo",  arrObjRoomData[27].toString());
						reportParams.put("pDateOfExpiry",  arrObjRoomData[28].toString());
						reportParams.put("pDateOfIssue",  arrObjRoomData[29].toString());
						reportParams.put("pNationality", arrObjRoomData[30].toString());
					}
				
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("pNote1", objPropertySetupModel.getStrCheckInFooter());
						reportParams.put("pNote2",null);
					}
					else
					{
						reportParams.put("pNote1", "1. Advance paid is non-refundable");
						reportParams.put("pNote2","2. Above information read and accepted");
					}
					
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("pNote", null);
						reportParams.put("pCustomerGST",null);
						reportParams.put("pgstno", null);
						reportParams.put("lblTax", null);
						reportParams.put("plblDaysForAccomodation", "Total Days For Accomodation :");
						reportParams.put("daysForAccomodation", daysBetween);
						reportParams.put("pPolicy1", null);
						reportParams.put("pPolicy2", null);
					
					}
					else
					{
						reportParams.put("pNote", "Note");
						reportParams.put("pCustomerGST","Customer GST :");
						reportParams.put("pgstno", gstNo);
						reportParams.put("lblTax", "Tax  :");
						reportParams.put("plblDaysForAccomodation", null);
						reportParams.put("daysForAccomodation",null );
						reportParams.put("pPolicy1", "1. Advance paid is non-refundable");
						reportParams.put("pPolicy2", "2. Above information read and accepted");
					}
					
					if(strComplimentry.equalsIgnoreCase("N"))
					{
						
						if(clientCode.equalsIgnoreCase("378.001"))
						{
							reportParams.put("ptaxAmt",0.00 );
						}
						else
						{
							reportParams.put("ptaxAmt", finalTax);
						}
						reportParams.put("proomTarrif", roomTarrif);
						if(roomTarrifRoomrateChange>0)
						{
							roomTarrifWithExtraBed=roomTarrifRoomrateChange + dblExtraBedAmt;
						}
						reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
						reportParams.put("pdiscount", discAmt);
					}
					else
					{
						finalTax=0.0;
						roomTarrif=0.0;
						discAmt = 0.0;
						roomTarrifWithExtraBed=0.0;
						if(clientCode.equalsIgnoreCase("378.001"))
						{
							reportParams.put("ptaxAmt", 0.00);
						}
						else
						{
							reportParams.put("ptaxAmt", finalTax);
						}
						
						reportParams.put("proomTarrif", roomTarrif);
						reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
						reportParams.put("pdiscount", discAmt);
					}
				}
				
				double dblPackageAmount=0;
				String sqlFolioPackage="select b.strPerticulars,b.dblDebitAmt from tblfoliohd a,tblfoliodtl b"
						+ " where a.strFolioNo=b.strFolioNo and a.strCheckInNo='"+reciptNo+"'and a.strClientCode='"+clientCode+"'  and"
						+ " b.strPerticulars='Package'";
				
				List listFolioPackage = objGlobalFunctionsService.funGetListModuleWise(sqlFolioPackage, "sql");

				if(listFolioPackage!=null && listFolioPackage.size()>0)
				{
					for(int i=0;i<listFolioPackage.size();i++)
					{
						Object[] obj =(Object[])listFolioPackage.get(i);
						dblPackageAmount+=Double.parseDouble(obj[1].toString());
					}
					
				}
				reportParams.put("pdblPackgeAmt", dblPackageAmount);
				reportParams.put("strUserCode",userCode);

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
				
				
			}
			 catch (Exception e) {
					e.printStackTrace();
				}
		}
	
	/*	public void funGeneratePaymentRecipt(@RequestParam("checkInNo") String reciptNo,@RequestParam("cmbAgainst") String strAgainst , HttpServletRequest req, HttpServletResponse resp) {
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
					// Object[] userData = (Object[]) listOfUser.get(0);
					userName = listOfUser.get(0).toString();
				}
				clsPropertySetupHdModel objPropertySetupModel = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
				HashMap reportParams = new HashMap();			
				ArrayList datalist = new ArrayList();
				String reportName = servletContext.getRealPath("/WEB-INF/reports/webpms/rptCheckInSlip.jrxml");			
				if(strAgainst.equalsIgnoreCase("Walk In")){
				String sql = "SELECT a.strCheckInNo,a.strGuestCode,f.strRoomDesc,"
						+ "ifnull(a.strExtraBedCode,''), b.strRoomTypeDesc,"
						+ "c.dblRoomRate, IFNULL(c.dblDiscount,0.0),d.intNoOfAdults,"
						+ " DATE_FORMAT(d.dteCheckInDate,'%d-%m-%Y'),e.strGSTNo,"
						+ "e.strPANNo, d.tmeArrivalTime,ifnull(g.dblChargePerBed,0), "
						+ "e.strFirstName,e.strMiddleName,e.strLastName, "
						+ "IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), "
						+ "IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''), "
						+ "IFNULL(e.intPinCodeOfc,''),IFNULL(e.lngMobileNo,0),d.strComplimentry,DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y')"
						+ "FROM tblroomtypemaster b,tblwalkinroomratedtl c, "
						+ "tblcheckinhd d,tblguestmaster e,tblroom f, "
						+ "tblcheckindtl a left outer join  tblextrabed g on "
						+ "g.strExtraBedTypeCode=a.strExtraBedCode  AND g.strClientCode='"+clientCode+"'"
						+ "WHERE a.strRoomType=b.strRoomTypeCode "
						+ "AND c.strWalkinNo=d.strWalkInNo "
						+ "AND a.strGuestCode=e.strGuestCode "
						+ "AND a.strCheckInNo=d.strCheckInNo  "
						+ "AND d.strCheckInNo = '"+reciptNo+"' "
						+ "AND a.strRoomNo=f.strRoomCode "
						+ "AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' AND c.strClientCode='"+clientCode+"' AND d.strClientCode='"+clientCode+"' AND e.strClientCode='"+clientCode+"' AND f.strClientCode='"+clientCode+"'  ; ";
				
				List listCheckInsData = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				Object[] arrObjRoomData = (Object[]) listCheckInsData.get(0);
				clsCheckInBean objCheckInBean = new clsCheckInBean();
				objCheckInBean.setStrCheckInNo(arrObjRoomData[0].toString());
				String guestCode = arrObjRoomData[1].toString();
				objCheckInBean.setStrRoomNo(arrObjRoomData[2].toString());
				objCheckInBean.setStrExtraBedCode(arrObjRoomData[3].toString());
				String roomType = arrObjRoomData[4].toString();
				double roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[5].toString());					
				double discount  = Double.parseDouble(arrObjRoomData[6].toString());
				objCheckInBean.setIntNoOfAdults(Integer.parseInt(arrObjRoomData[7].toString()));
				objCheckInBean.setDteArrivalDate(arrObjRoomData[8].toString());
				String gstNo = arrObjRoomData[9].toString();
				String paNo = arrObjRoomData[10].toString();
				objCheckInBean.setTmeArrivalTime(arrObjRoomData[11].toString());
				double dblExtraBedAmt = Double.parseDouble(arrObjRoomData[12].toString());
				if(!objCheckInBean.getStrExtraBedCode().isEmpty())
				{
					roomTarrifWithExtraBed = dblExtraBedAmt+roomTarrifWithExtraBed;
				}
				String gFirstName = arrObjRoomData[13].toString();
				String gMiddleName = arrObjRoomData[14].toString();
				String gLastName = arrObjRoomData[15].toString();
				String guestCompanyAddr = arrObjRoomData[16].toString() + ","
						+ arrObjRoomData[17].toString() + ","
						+ arrObjRoomData[18].toString() + ","
						+ arrObjRoomData[19].toString() + ","
						+ arrObjRoomData[20].toString();
				String guestCompanyAddr= arrObjRoomData[15].toString() ;
				if(!arrObjRoomData[16].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[16].toString();
				}
				else if(!arrObjRoomData[17].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[17].toString();
				}
				else if(!arrObjRoomData[18].toString().equalsIgnoreCase(""))
				{
					guestCompanyAddr="," + arrObjRoomData[18].toString();
				}
				else if(!arrObjRoomData[19].toString().equalsIgnoreCase("0"))
				{
					guestCompanyAddr="," + arrObjRoomData[19].toString();
				}
				else
				{
					guestCompanyAddr=guestCompanyAddr;
				}
				//clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
				String strMobileNo = arrObjRoomData[21].toString();
				String strComplimentry = arrObjRoomData[22].toString();
				
				 String arrDate = arrObjRoomData[23].toString();
			     String depDate = arrObjRoomData[24].toString();
			     
			     Date arrivalDte=new SimpleDateFormat("dd-MM-yyyy").parse(arrDate);  
			     Date departureDte=new SimpleDateFormat("dd-MM-yyyy").parse(depDate); 
			     long arrTme=arrivalDte.getTime();
			     long deptTme=departureDte.getTime();
			     long difference = departureDte.getTime()- arrivalDte.getTime();
			     double daysBetween = (difference / (1000*60*60*24));
			     
				 double roomTarrif = Double.parseDouble(arrObjRoomData[5].toString());
				//List<clsTaxProductDtl> listTaxProdDtl = new ArrayList<clsTaxProductDtl>();
				//Map<String, List<clsTaxCalculation>> hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");

				Date dt = new Date();
				String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();
				double finalTax = 0.0;
				double tariffAmt = roomTarrifWithExtraBed-((roomTarrifWithExtraBed*discount)/100);
				double discAmt = ((roomTarrifWithExtraBed*discount)/100);
                if(!clientCode.equalsIgnoreCase("383.001"))
                {
                	String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
    						+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
    						+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
    						+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' AND strClientCode = '"+clientCode+"'";
    				
    				List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
    				
    				
    				String strTaxOn="";
    				for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
    					String taxCalType = "Forward";
    					Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
    					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
    					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
    					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
    					if(fromRate<(tariffAmt)&& (tariffAmt)<=toRate)
    					{
    						double taxAmt = 0;
    						if (taxCalType.equals("Forward")) // Forward Tax
    															// Calculation
    						{
    							taxAmt = (tariffAmt * taxValue) / 100;
    						} 
    						else // Backward Tax Calculation
    						{
    							taxAmt = tariffAmt * 100 / (100 + taxValue);
    							taxAmt = tariffAmt - taxAmt;
    						}
    						finalTax = finalTax+taxAmt;
    					}
    					else
    					{
    						
    					}
    				}
    				
                }
			
				datalist.add(objCheckInBean);
				
				//reportParams.put("pgstno", gstNo);
				reportParams.put("ppanno", paNo);
				reportParams.put("pguestCode", guestCode);
				reportParams.put("proomType", roomType);
				reportParams.put("pCompanyName", companyName);
				reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
				reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
				reportParams.put("pContactDetails", "");
				reportParams.put("strImagePath", imagePath);
				reportParams.put("userName", userName);
				reportParams.put("pGuestName", gFirstName + " "+ gMiddleName + " " + gLastName);
				reportParams.put("pguestCompanyAddr", guestCompanyAddr);
				reportParams.put("pstrMobileNo", strMobileNo);
				if(clientCode.equalsIgnoreCase("383.001"))
				{
					reportParams.put("strImagePath1", imagePath1);	
				}
				else
				{
					reportParams.put("strImagePath1", null);
				}
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("pNote1", objPropertySetupModel.getStrCheckInFooter());
					reportParams.put("pNote2",null);
				}
				else
				{
					reportParams.put("pNote1", "1. Advance paid is non-refundable");
					reportParams.put("pNote2","2. Above information read and accepted");
				}
				
				if(clientCode.equalsIgnoreCase("378.001"))
				{
					reportParams.put("pNote", null);
					reportParams.put("pCustomerGST",null);
					reportParams.put("pgstno", null);
					reportParams.put("lblTax", null);
					reportParams.put("plblDaysForAccomodation", "Total Days For Accomodation :");
					reportParams.put("daysForAccomodation", daysBetween);
					reportParams.put("pPolicy1", null);
					reportParams.put("pPolicy2", null); 
                  
				}
				else
				{
					reportParams.put("pNote", "Note");
					reportParams.put("pCustomerGST","Customer GST :");
					reportParams.put("pgstno", gstNo);
					reportParams.put("lblTax", "Tax  :");
					reportParams.put("plblDaysForAccomodation", null);
					reportParams.put("daysForAccomodation",null );
					reportParams.put("pPolicy1", "1. Advance paid is non-refundable");
					reportParams.put("pPolicy2", "2. Above information read and accepted");
				}
				
				
				if(strComplimentry.equalsIgnoreCase("N"))
				{
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					else
					{
						reportParams.put("ptaxAmt", finalTax);
					}
				
				
				reportParams.put("proomTarrif", roomTarrif);
				reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
				reportParams.put("pdiscount", discAmt);
				}
				else
				{
					finalTax=0.0;
					roomTarrif=0.0;
					discAmt = 0.0;
					roomTarrifWithExtraBed=0.0;

					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					else
					{
						reportParams.put("ptaxAmt", 0.00);
					}
					
					reportParams.put("proomTarrif", roomTarrif);
					reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
					reportParams.put("pdiscount", discAmt);
				}
				}
				else
				{
					String sqlReservation ="SELECT a.strCheckInNo,a.strGuestCode,"
							+ "f.strRoomDesc, IFNULL(a.strExtraBedCode,''),"
							+ "b.strRoomTypeDesc,b.dblRoomTerrif,d.intNoOfAdults, "
							+ "DATE_FORMAT(d.dteCheckInDate,'%d-%m-%Y'),e.strGSTNo,"
							+ "e.strPANNo, d.tmeArrivalTime, IFNULL(g.dblChargePerBed,0), "
							+ "e.strFirstName,e.strMiddleName,e.strLastName, "
							+ "IFNULL(e.strAddressOfc,''), IFNULL(e.strCityOfc,''), "
							+ "IFNULL(e.strStateOfc,''), IFNULL(e.strCountryOfc,''), "
							+ "IFNULL(e.intPinCodeOfc,''), IFNULL(e.lngMobileNo,0) ,d.strComplimentry,DATE_FORMAT(d.dteArrivalDate,'%d-%m-%Y'),DATE_FORMAT(d.dteDepartureDate,'%d-%m-%Y') ,h.dblRoomRate "
							+ "FROM tblroomtypemaster b ,tblguestmaster e,"
							+ "tblroom f, tblcheckindtl a "
							+ "LEFT OUTER JOIN tblextrabed g ON g.strExtraBedTypeCode=a.strExtraBedCode "
							+ ", tblcheckinhd d"
							+ " LEFT OUTER"
							+ " JOIN tblreservationroomratedtl h ON h.strReservationNo=d.strReservationNo "
							+ "WHERE a.strRoomType=b.strRoomTypeCode AND a.strGuestCode=e.strGuestCode  "
							+ "AND a.strCheckInNo=d.strCheckInNo  AND d.strCheckInNo = '"+reciptNo+"' "
							+ "AND a.strRoomNo=f.strRoomCode ; ";
					List listCheckInRes = objGlobalFunctionsService.funGetListModuleWise(sqlReservation, "sql");

					Object[] arrObjRoomData = (Object[]) listCheckInRes.get(0);
					clsCheckInBean objCheckInBean = new clsCheckInBean();
					objCheckInBean.setStrCheckInNo(arrObjRoomData[0].toString());
					String guestCode = arrObjRoomData[1].toString();
					objCheckInBean.setStrRoomNo(arrObjRoomData[2].toString());
					objCheckInBean.setStrExtraBedCode(arrObjRoomData[3].toString());
					String roomType = arrObjRoomData[4].toString();
					double roomTarrifWithExtraBed = Double.parseDouble(arrObjRoomData[5].toString());					
					double discount  = Double.parseDouble(arrObjRoomData[6].toString());
					objCheckInBean.setIntNoOfAdults(Integer.parseInt(arrObjRoomData[6].toString()));
					objCheckInBean.setDteArrivalDate(arrObjRoomData[7].toString());
					String gstNo = arrObjRoomData[8].toString();
					String paNo = arrObjRoomData[9].toString();
					objCheckInBean.setTmeArrivalTime(arrObjRoomData[10].toString());
					double dblExtraBedAmt = Double.parseDouble(arrObjRoomData[11].toString());
					if(!objCheckInBean.getStrExtraBedCode().isEmpty())
					{
						roomTarrifWithExtraBed = dblExtraBedAmt+roomTarrifWithExtraBed;
					}
					String gFirstName = arrObjRoomData[12].toString();
					String gMiddleName = arrObjRoomData[13].toString();
					String gLastName = arrObjRoomData[14].toString();
					String guestCompanyAddr = arrObjRoomData[15].toString() + ","
							+ arrObjRoomData[16].toString() + ","
							+ arrObjRoomData[17].toString() + ","
							+ arrObjRoomData[18].toString() + ","
							+ arrObjRoomData[19].toString();
					String guestCompanyAddr= arrObjRoomData[15].toString() ;
					if(!arrObjRoomData[16].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[16].toString();
					}
					else if(!arrObjRoomData[17].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[17].toString();
					}
					else if(!arrObjRoomData[18].toString().equalsIgnoreCase(""))
					{
						guestCompanyAddr="," + arrObjRoomData[18].toString();
					}
					else if(!arrObjRoomData[19].toString().equalsIgnoreCase("0"))
					{
						guestCompanyAddr="," + arrObjRoomData[19].toString();
					}
					else
					{
						guestCompanyAddr=guestCompanyAddr;
					}
					
					String strMobileNo = arrObjRoomData[20].toString();
					String strComplimentry = arrObjRoomData[21].toString();
					
					 String arrDate = arrObjRoomData[22].toString();
				     String depDate = arrObjRoomData[23].toString();
				   
				     Date arrivalDte=new SimpleDateFormat("dd-MM-yyyy").parse(arrDate);  
				     Date departureDte=new SimpleDateFormat("dd-MM-yyyy").parse(depDate); 
				     
				     long arrTme=arrivalDte.getTime();
				     long deptTme=departureDte.getTime();
				     long difference = departureDte.getTime()- arrivalDte.getTime();
				     double daysBetween = (difference / (1000*60*60*24));
				     double roomTarrif=0;
				     double roomTarrifRoomrateChange=0;
				     if(listCheckInRes!=null && listCheckInRes.size()>0)
				     {
				    	 for(int i=0;i<listCheckInRes.size();i++)
				    	 {
				    		 Object[] obj=( Object[] )listCheckInRes.get(i);
				    		  if(Double.parseDouble(obj[24].toString())>0)
				    		 {
				    			  roomTarrifRoomrateChange += Double.parseDouble(obj[24].toString());
				    		 }
				    		 else
				    		 {
				    			 roomTarrif += Double.parseDouble(obj[5].toString());
				    		 }
				    	 }
				    
				    	
				     }
					
					
					
					
					//List<clsTaxProductDtl> listTaxProdDtl = new ArrayList<clsTaxProductDtl>();
					//Map<String, List<clsTaxCalculation>> hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");

					Date dt = new Date();
					String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();
					double finalTax = 0.0;
					double discount=0.0;
					double tariffAmt = roomTarrifWithExtraBed-((roomTarrifWithExtraBed*discount)/100);
					double discAmt = ((roomTarrifWithExtraBed*discount)/100);
					String strTaxOn="";
					
					if(!clientCode.equalsIgnoreCase("383.001"))
		            {
						String sqlTax = "SELECT strTaxCode,strTaxDesc,strIncomeHeadCode,"
								+ "strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,"
								+ "dblToRate FROM tbltaxmaster WHERE DATE(dteValidFrom)<='"+date+"' "
								+ "and  date(dteValidTo)>='"+date+"' and strTaxOnType = 'Room Night' ";
						
						List listTaxDtl = objGlobalFunService.funGetListModuleWise(sqlTax, "sql");
						
						for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
							String taxCalType = "Forward";
							Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
							double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
							double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
							double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
							if(fromRate<(tariffAmt)&& (tariffAmt)<=toRate)
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
																	// Calculation
								{
									taxAmt = (tariffAmt * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = tariffAmt * 100 / (100 + taxValue);
									taxAmt = tariffAmt - taxAmt;
								}
								finalTax = finalTax+taxAmt;
							}
							else
							{
								
							}
						} 
		            }
					
					datalist.add(objCheckInBean);
					
					
					
					reportParams.put("ppanno", paNo);
					reportParams.put("pguestCode", guestCode);
					reportParams.put("proomType", roomType);
					reportParams.put("pCompanyName", companyName);
					reportParams.put("pAddress1", objSetup.getStrAdd1() + "," + objSetup.getStrAdd2() + "," + objSetup.getStrCity());
					reportParams.put("pAddress2", objSetup.getStrState() + "," + objSetup.getStrCountry() + "," + objSetup.getStrPin());
					reportParams.put("pContactDetails", "");
					reportParams.put("strImagePath", imagePath);
					reportParams.put("userName", userName);
					reportParams.put("pGuestName", gFirstName + " "+ gMiddleName + " " + gLastName);
					reportParams.put("pguestCompanyAddr", guestCompanyAddr);
					reportParams.put("pstrMobileNo", strMobileNo);
				
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("pNote1", objPropertySetupModel.getStrCheckInFooter());
						reportParams.put("pNote2",null);
					}
					else
					{
						reportParams.put("pNote1", "1. Advance paid is non-refundable");
						reportParams.put("pNote2","2. Above information read and accepted");
					}
					
					if(clientCode.equalsIgnoreCase("378.001"))
					{
						reportParams.put("pNote", null);
						reportParams.put("pCustomerGST",null);
						reportParams.put("pgstno", null);
						reportParams.put("lblTax", null);
						reportParams.put("plblDaysForAccomodation", "Total Days For Accomodation :");
						reportParams.put("daysForAccomodation", daysBetween);
						reportParams.put("pPolicy1", null);
						reportParams.put("pPolicy2", null);
					
					}
					else
					{
						reportParams.put("pNote", "Note");
						reportParams.put("pCustomerGST","Customer GST :");
						reportParams.put("pgstno", gstNo);
						reportParams.put("lblTax", "Tax  :");
						reportParams.put("plblDaysForAccomodation", null);
						reportParams.put("daysForAccomodation",null );
						reportParams.put("pPolicy1", "1. Advance paid is non-refundable");
						reportParams.put("pPolicy2", "2. Above information read and accepted");
					}
					
					if(strComplimentry.equalsIgnoreCase("N"))
					{
						
						if(clientCode.equalsIgnoreCase("378.001"))
						{
							reportParams.put("ptaxAmt",0.00 );
						}
						else
						{
							reportParams.put("ptaxAmt", finalTax);
						}
						reportParams.put("proomTarrif", roomTarrif);
						if(roomTarrifRoomrateChange>0)
						{
							roomTarrifWithExtraBed=roomTarrifRoomrateChange + dblExtraBedAmt;
						}
						reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
						reportParams.put("pdiscount", discAmt);
					}
					else
					{
						finalTax=0.0;
						roomTarrif=0.0;
						discAmt = 0.0;
						roomTarrifWithExtraBed=0.0;
						if(clientCode.equalsIgnoreCase("378.001"))
						{
							reportParams.put("ptaxAmt", 0.00);
						}
						else
						{
							reportParams.put("ptaxAmt", finalTax);
						}
						
						reportParams.put("proomTarrif", roomTarrif);
						reportParams.put("proomTarrifWithExtBed", roomTarrifWithExtraBed);
						reportParams.put("pdiscount", discAmt);
					}
				}
				
				double dblPackageAmount=0;
				String sqlFolioPackage="select b.strPerticulars,b.dblDebitAmt from tblfoliohd a,tblfoliodtl b"
						+ " where a.strFolioNo=b.strFolioNo and a.strCheckInNo='"+reciptNo+"'and a.strClientCode='"+clientCode+"'  and"
						+ " b.strPerticulars='Package'";
				
				List listFolioPackage = objGlobalFunctionsService.funGetListModuleWise(sqlFolioPackage, "sql");

				if(listFolioPackage!=null && listFolioPackage.size()>0)
				{
					for(int i=0;i<listFolioPackage.size();i++)
					{
						Object[] obj =(Object[])listFolioPackage.get(i);
						dblPackageAmount+=Double.parseDouble(obj[1].toString());
					}
					
				}
				reportParams.put("pdblPackgeAmt", dblPackageAmount);
				reportParams.put("strUserCode",userCode);

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
				
				
			}
			 catch (Exception e) {
					e.printStackTrace();
				}
		}
	
*/	
	// Convert bean to model function
	public clsCheckInHdModel funPrepareHdModel(clsCheckInBean objBean, String userCode, String clientCode, HttpServletRequest req) {

		// Insert or update Walkin HD Details
		clsCheckInHdModel objModel = new clsCheckInHdModel();

		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
		if (objBean.getStrRegistrationNo().isEmpty()) // New Entry
		{
			String transaDate = objGlobal.funGetCurrentDateTime("dd-MM-yyyy").split(" ")[0];
			String checkInNo = objGlobal.funGeneratePMSDocumentCode("frmCheckIn", transaDate, req);
			String regNo = objGlobal.funGeneratePMSDocumentCode("frmCheckInRegNo", transaDate, req);

			objModel.setStrCheckInNo(checkInNo);
			objModel.setStrRegistrationNo(regNo);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else // Update
		{
			objModel.setStrCheckInNo(objBean.getStrCheckInNo());
			objModel.setStrRegistrationNo(objBean.getStrRegistrationNo());
		}

		objModel.setDteCheckInDate(PMSDate);
		objModel.setStrType(objBean.getStrType());
		if (objBean.getStrType().equals("Reservation")) {
			objModel.setStrReservationNo(objBean.getStrAgainstDocNo());
			objModel.setStrWalkInNo("");
		} else {
			objModel.setStrReservationNo("");
			objModel.setStrWalkInNo(objBean.getStrAgainstDocNo());
		}
		objModel.setDteArrivalDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteArrivalDate()));
		objModel.setDteDepartureDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteDepartureDate()));
		objModel.setTmeArrivalTime(objBean.getTmeArrivalTime());
		objModel.setTmeDepartureTime(objBean.getTmeDepartureTime());
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		objModel.setStrRoomNo("");
		if (objBean.getStrExtraBedCode() != null) {
			objModel.setStrExtraBedCode(objBean.getStrExtraBedCode());
		} else {
			objModel.setStrExtraBedCode("");
		}
		objModel.setStrComplimentry(objBean.getStrComplimentry());

		objModel.setIntNoOfAdults(objBean.getIntNoOfAdults());
		objModel.setIntNoOfChild(objBean.getIntNoOfChild());
		if(objBean.getStrReasonCode().equals(""))
		{
			objModel.setStrReasonCode("");
		}
		else
		{
			objModel.setStrReasonCode(objBean.getStrReasonCode());
		}
		if(objBean.getStrRemarks().equals(""))
		{
			objModel.setStrRemarks("");
		}
		else
		{
			objModel.setStrRemarks(objBean.getStrRemarks());
		}

		List<clsCheckInDtl> listCheckinDtlModel = new ArrayList<clsCheckInDtl>();
		if (objBean.getListCheckInDetailsBean().size() > 0) {
			for (clsCheckInDetailsBean objCheckinDetails : objBean.getListCheckInDetailsBean()) {
				clsCheckInDtl objClsCheckinDtlModel = new clsCheckInDtl();
				objClsCheckinDtlModel.setStrRegistrationNo(objModel.getStrRegistrationNo());
				objClsCheckinDtlModel.setStrGuestCode(objCheckinDetails.getStrGuestCode());
				objClsCheckinDtlModel.setStrRoomNo(objCheckinDetails.getStrRoomNo());
				objClsCheckinDtlModel.setStrExtraBedCode(objCheckinDetails.getStrExtraBedCode());
				objClsCheckinDtlModel.setIntNoOfFolios(objCheckinDetails.getIntNoOfFolios());
				System.out.println("PAYEE=" + objCheckinDetails.getStrPayee());
				if (objCheckinDetails.getStrPayee() != null) {
					objClsCheckinDtlModel.setStrPayee(objCheckinDetails.getStrPayee());
				} else {
					objClsCheckinDtlModel.setStrPayee("N");
				}
				objClsCheckinDtlModel.setStrRoomType(objCheckinDetails.getStrRoomType());
				/*
				 * if(objBean.getStrPayeeGuestCode().equals(objCheckinDetails.
				 * getStrGuestCode())) { objCheckinDetails.setStrPayee("Y");
				 * }else { objCheckinDetails.setStrPayee("N"); }
				 */

				listCheckinDtlModel.add(objClsCheckinDtlModel);
			}
		}
		objModel.setListCheckInDtl(listCheckinDtlModel);
		objModel.setStrNoPostFolio(objGlobal.funIfNull(objBean.getStrNoPostFolio(), "N", objBean.getStrNoPostFolio()));
		objModel.setStrComplimentry(objGlobal.funIfNull(objBean.getStrComplimentry(), "N",objBean.getStrComplimentry()));
		objModel.setStrDontApplyTax(objGlobal.funIfNull(objBean.getStrDontApplyTax(), "N", objBean.getStrDontApplyTax()));
        objModel.setStrPlanCode(objBean.getStrPlanCode());
		/*objModel.setStrRemarks("");
		objModel.setStrReasonCode("");*/
		

		
		return objModel;
	}

	private void funSendSMSCheckIn(String checkInNo, String clientCode, String propCode) {

		String strMobileNo = "";
		clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propCode, clientCode);

		// clsCheckInDtl
		// objModel=objCheckInService.funGetCheckInDtlData(checkInNo,
		// clientCode);
		clsCheckInHdModel objHdModel = objCheckInService.funGetCheckInData(checkInNo, clientCode);
		clsCheckInDtl objDtlModel = null;

		String smsAPIUrl = objSetup.getStrSMSAPI();

		String smsContent = objSetup.getStrCheckInSMSContent();

		if (!smsAPIUrl.equals("")) {
			if (smsContent.contains("%%CompanyName")) {
				List<clsCompanyMasterModel> listCompanyModel = objPropertySetupService.funGetListCompanyMasterModel(clientCode);
				smsContent = smsContent.replace("%%CompanyName", listCompanyModel.get(0).getStrCompanyName());
			}
			if (smsContent.contains("%%PropertyName")) {
				clsPropertyMaster objProperty = objPropertyMasterService.funGetProperty(propCode, clientCode);
				smsContent = smsContent.replace("%%PropertyName", objProperty.getPropertyName());
			}

			if (smsContent.contains("%%CheckIn")) {
				smsContent = smsContent.replace("%%CheckIn", checkInNo);
			}

			if (smsContent.contains("%%CheckInDate")) {
				smsContent = smsContent.replace("%%CheckInDate", objHdModel.getDteCheckInDate());
			}

			List listcheckIn = objHdModel.getListCheckInDtl();

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
	}
	
	@RequestMapping(value = "/loadRoomRateCheckIn", method = RequestMethod.POST)
	public @ResponseBody List funLoadRoomRate(String arrivalDate, String departureDate,String roomDescList, HttpServletRequest req) throws ParseException {
		
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String strPMSDate = req.getSession().getAttribute("PMSDate").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		String arrvDate=objGlobal.funGetDate("yyyy-MM-dd", arrivalDate);
		String deptDate=objGlobal.funGetDate("yyyy-MM-dd", departureDate);
		
		List<List> returnList=new ArrayList();
		List listRoomCode = new ArrayList();
        Map<String,List> mapRoom= new HashMap();
		String fromDate = req.getParameter("arrivalDate");
		String toDate = req.getParameter("departureDate");
		DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");
//		DateTimeFormatter formatter = DateTimeFormatter.BASIC_ISO_DATE;
		LocalDate localArrvDate = dtf.parseLocalDate(arrvDate);
		roomDescList=roomDescList.substring(1);
		LocalDate localDdeptDate = dtf.parseLocalDate(deptDate);
		clsPropertySetupHdModel objPropertySetupModel= objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
		String roomCode="";
		String roomNumber="";
		int cntRoom = 0;
		if(roomDescList!="")
		{
			String[] roomCodeList = roomDescList.split(",");
			for(int i=0; i<roomCodeList.length; i++)
			{
				String[] roomTypeRoomNo=roomCodeList[i].split(" ");
				roomCode=roomTypeRoomNo[0];
				roomNumber=roomTypeRoomNo[1];
				if(!(listRoomCode.contains(roomCode) &&listRoomCode.contains(roomNumber)) )
				{
					for(int j=0;j<roomCodeList.length;j++)
					{
						String[] roomTypeRoomNumber=roomCodeList[j].split(" ");
						if(roomCode.equalsIgnoreCase(roomTypeRoomNumber[0]) && roomNumber.equalsIgnoreCase(roomTypeRoomNumber[1]))
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
			if(objPropertySetupModel.getStrRatepickUpFrom().equalsIgnoreCase("Rate Management"))
			{
				roomRate = objGlobal.funGetDblRoomTariffFromRateManagement(roomCode,cntRoom,strPMSDate,clientCode);
			}
			else
			{
				
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
			}
			
			
			
			roomTypedesc=objRoomTypeMasterModel.getStrRoomTypeDesc();
		}
		
		for (LocalDate date = localArrvDate;(date.isBefore(localDdeptDate)|| date.isEqual(localDdeptDate)); date = date.plusDays(1))
		{
			
		    if(mapRoom.containsKey(date.toString() +"!"+roomTypedesc))
		    {
		    	List listRoom=mapRoom.get(date.toString() +"!"+roomTypedesc);
		    	double rate=Double.parseDouble(listRoom.get(1).toString());
		    	listRoom.remove(1);
		    	listRoom.add(1, rate+roomRate);
		    	
		    }
		    else
		    {
		    	
		    	List listRoomRate=new ArrayList();
		    	listRoomRate.add(date.toString());
				listRoomRate.add(roomRate);
				listRoomRate.add(roomTypedesc);
				listRoomRate.add(roomCode);	
				mapRoom.put(date.toString() +"!"+roomTypedesc,listRoomRate);
				
		    }
			
			
			
		}
		listRoomCode.add(roomCode);
		listRoomCode.add(roomNumber);
		cntRoom=0;
		}
		
		}
			for(Map.Entry<String, List> entry:mapRoom.entrySet())
			{
				returnList.add(entry.getValue());
			}
			
		}
		return returnList;
	}
}
