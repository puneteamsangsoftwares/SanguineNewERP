package com.sanguine.webpms.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

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
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsPMSGroupBookingBean;
import com.sanguine.webpms.bean.clsPMSGroupBookingDetailBean;
import com.sanguine.webpms.bean.clsReservationDetailsBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsPMSGroupBookingDtlModel;
import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;
import com.sanguine.webpms.model.clsReservationDtlModel;
import com.sanguine.webpms.service.clsPMSGroupBookingService;

@Controller
public class clsPMSGroupBookingController{

	@Autowired
	private clsPMSGroupBookingService objPMSGroupBookingService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
//Open PMSGroupBooking
	@RequestMapping(value = "/frmPMSGroupReservation", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmPMSGroupReservation","command", new clsPMSGroupBookingBean());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmPMSGroupReservation1", method = RequestMethod.POST)
	public @ResponseBody clsPMSGroupBookingHDModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("userCode").toString();
		clsPMSGroupBookingBean objBean=new clsPMSGroupBookingBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsPMSGroupBookingHDModel objPMSGroupBooking = new clsPMSGroupBookingHDModel();
		return objPMSGroupBooking;
	}
	
	@RequestMapping(value = "/frmPMSGroupReservationForReservation", method = RequestMethod.GET)
	public ModelAndView funOpenFormForReservation(Map<String, Object> model,
			HttpServletRequest request,
			@RequestParam("lblCorporateDesc") String lblCorporateDesc,
			@RequestParam("strPaxCnt") String strPaxCnt,
			@RequestParam("strDepartureTime") String strDepartureTime,
			@RequestParam("strArrivalTime") String strArrivalTime,
			@RequestParam("strDepartureDate") String strDepartureDate,
			@RequestParam("strCorporateCode") String strCorporateCode,
			@RequestParam("strArrDate") String strArrDate,
			@RequestParam("gRoomTypeCode") String gRoomTypeCode,
			@RequestParam("gRoomTypeDesc") String gRoomTypeDesc){
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		clsPMSGroupBookingBean objBean =new clsPMSGroupBookingBean();
		objBean.setStrCompName(lblCorporateDesc);
		objBean.setStrPax(strPaxCnt);
		objBean.setDteCheckoutDate(strDepartureDate);
		objBean.setStrCompCode(strCorporateCode);
		objBean.setDteCheckInDate(strArrDate);        
		objBean.setStrRoomType(gRoomTypeCode);
		objBean.setStrRoomTypeDesc(gRoomTypeDesc);
		
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSGroupReservation", "command", objBean);
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSGroupReservation", "command", objBean);
		} else {
			return null;
		}

	}
	

//Save or Update PMSGroupBooking
	@RequestMapping(value = "/savePMSGroupReservation", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSGroupBookingBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsPMSGroupBookingHDModel objModel = funPrepareModel(objBean,userCode,clientCode,req);
			objPMSGroupBookingService.funAddUpdatePMSGroupBooking(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", objModel.getStrGroupCode());
			req.getSession().setAttribute("GroupCodeAndRoomCode", objModel.getStrGroupCode()+"#"+objBean.getStrRoomType()+"#"+objBean.getStrCompCode());
			return new ModelAndView("redirect:/frmPMSGroupReservation.html");
			//return new ModelAndView("frmPMSGroupReservation");
		}
		else{
			return new ModelAndView("frmPMSGroupReservation");
		}
	}

	
	// Load data from database to form
		@RequestMapping(value = "/loadGroupCode", method = RequestMethod.GET)
		public @ResponseBody clsPMSGroupBookingHDModel funFetchGuestMasterData(@RequestParam("groupCode") String groupCode, HttpServletRequest req) {
			clsGlobalFunctions objGlobal = new clsGlobalFunctions();
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			clsPMSGroupBookingHDModel objPMSGroupBookingModel = objPMSGroupBookingService.funGetPMSGroupBooking(groupCode, clientCode);
			objPMSGroupBookingModel.setDteTravelDate(objGlobal.funGetDate("dd-MM-yyyy",objPMSGroupBookingModel.getDteTravelDate()));
			objPMSGroupBookingModel.setDteCheckInDate(objGlobal.funGetDate("dd-MM-yyyy",objPMSGroupBookingModel.getDteCheckInDate()));
			objPMSGroupBookingModel.setDteCheckoutDate(objGlobal.funGetDate("dd-MM-yyyy",objPMSGroupBookingModel.getDteCheckoutDate()));
			objPMSGroupBookingModel.setDteDob(objGlobal.funGetDate("dd-MM-yyyy",objPMSGroupBookingModel.getDteDob()));
			return objPMSGroupBookingModel;
		}
	
	
//Convert bean to model function
	private clsPMSGroupBookingHDModel funPrepareModel(clsPMSGroupBookingBean objBean,String userCode,String clientCode,HttpServletRequest req){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;	
		objGlobal = new clsGlobalFunctions();
		clsPMSGroupBookingHDModel objModel = new clsPMSGroupBookingHDModel();

		if (objBean.getStrGroupCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblgroupbookinghd", "GroupMaster", "strGroupCode", clientCode);
			String groupCode = "GR" + String.format("%06d", lastNo);
			objModel.setStrGroupCode(groupCode);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrGroupCode(objBean.getStrGroupCode());
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		}
		
		objModel.setStrReservationID(objBean.getStrReservationID());
		objModel.setStrGroupName(objBean.getStrGroupName());
		objModel.setStrGroupLeaderCode(objBean.getStrGroupLeaderCode());
		objModel.setStrAddress(objBean.getStrAddress());
		objModel.setStrCity(objBean.getStrCity());
		objModel.setStrCountry(objBean.getStrCountry());
		objModel.setStrPin(objBean.getStrPin());
		objModel.setStrPhone(objBean.getStrPhone());
		objModel.setStrMobile(objBean.getStrMobile());
		objModel.setStrFax(objBean.getStrFax());
		objModel.setStrEmail(objBean.getStrEmail());
		objModel.setDteDob(objGlobal.funGetDate("yyyy-MM-dd",objBean.getDteDob()));
		objModel.setStrNationality(objBean.getStrNationality());
		
		//14
		
		objModel.setStrCompCode(objBean.getStrCompCode());
		objModel.setStrCompName(objBean.getStrCompName());
		objModel.setStrDesignation(objBean.getStrDesignation());
		objModel.setStrGICity(objBean.getStrGICity());
		objModel.setStrGIPhone(objBean.getStrGIPhone());
		objModel.setStrGIMobile(objBean.getStrGIMobile());
		objModel.setStrGIFax(objBean.getStrGIFax());
		
		//21
		
		objModel.setDteTravelDate(objGlobal.funGetDate("yyyy-MM-dd",objBean.getDteTravelDate()));
		objModel.setTmeTravelTime(objBean.getTmeTravelTime());
		objModel.setStrPickupRequired(objBean.getStrPickupRequired());
		
		//25		
		objModel.setDteCheckInDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteCheckInDate()));
		objModel.setDteCheckoutDate(objGlobal.funGetDate("yyyy-MM-dd",objBean.getDteCheckoutDate()));
		objModel.setStrPax(objBean.getStrPax());
		objModel.setStrSource(objBean.getStrSource());
		objModel.setStrGuestType(objBean.getStrGuestType());
		objModel.setStrExtraBed(objBean.getStrExtraBed());
		objModel.setStrChild(objBean.getStrChild());
		objModel.setStrInfant(objBean.getStrInfant());
		objModel.setStrSalesChannel(objBean.getStrSalesChannel());
		
		//34
		
		objModel.setStrRoomType(objBean.getStrRoomType());
		objModel.setStrRoomTypeDesc(objBean.getStrRoomTypeDesc());
		objModel.setStrRoomTaxes(objBean.getStrRoomTaxes());
		objModel.setStrOtherTaxes(objBean.getStrOtherTaxes());
		objModel.setStrServiceCharges(objBean.getStrServiceCharges());
		objModel.setStrPayments(objBean.getStrPayments());
		objModel.setStrDiscounts(objBean.getStrDiscounts());
		
		//41
		
		objModel.setStrCard(objBean.getStrCard());
		objModel.setStrCash(objBean.getStrCash());
		objModel.setStrPaymentBtGroupLeader(objBean.getStrPaymentBtGroupLeader());
		objModel.setStrGuest(objBean.getStrGuest());
		objModel.setStrRoom(objBean.getStrRoom());
		objModel.setStrFandB(objBean.getStrFandB());
		objModel.setStrTelephones(objBean.getStrTelephones());
		objModel.setStrExtras(objBean.getStrExtras());
		
		
		//50			
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);

		//add list data in to tblgroupbookingdtl table		
		List<clsPMSGroupBookingDtlModel> listPMSGroupBookingDtlModel = new ArrayList<clsPMSGroupBookingDtlModel>();
		HashMap<String,clsPMSGroupBookingDtlModel> hmap = new LinkedHashMap<String,clsPMSGroupBookingDtlModel>();
		clsPMSGroupBookingDtlModel objGroupLeader = new clsPMSGroupBookingDtlModel();
		clsPMSGroupBookingDtlModel objGuest = new clsPMSGroupBookingDtlModel();
		for (clsPMSGroupBookingDetailBean objPMSGroupBookingDetailBean: objBean.getListPMSGroupBookingDetailBean()) {
			//clsPMSGroupBookingDtlModel obj = new clsPMSGroupBookingDtlModel();
			if(objPMSGroupBookingDetailBean.getStrPayee().equalsIgnoreCase("Group Leader"))
			{
				if(hmap.containsKey(objPMSGroupBookingDetailBean.getStrPayee()))
				{
					objGroupLeader=hmap.get(objPMSGroupBookingDetailBean.getStrPayee());
					objGroupLeader.setStrRoom(funEquals(objPMSGroupBookingDetailBean.getStrRoom(),objGroupLeader.getStrRoom()));
					objGroupLeader.setStrPayee(objPMSGroupBookingDetailBean.getStrPayee());
					objGroupLeader.setStrFandB(funEquals(objPMSGroupBookingDetailBean.getStrFandB(),objGroupLeader.getStrFandB()));
					objGroupLeader.setStrTelephone(funEquals(objPMSGroupBookingDetailBean.getStrTelephone(),objGroupLeader.getStrTelephone()));
					objGroupLeader.setStrExtra(funEquals(objPMSGroupBookingDetailBean.getStrExtra(),objGroupLeader.getStrExtra()));
					hmap.put(objPMSGroupBookingDetailBean.getStrPayee(), objGroupLeader);
				}
				else
				{
					objGroupLeader.setStrRoom(funEquals(objPMSGroupBookingDetailBean.getStrRoom(),objGroupLeader.getStrRoom()));
					objGroupLeader.setStrPayee(objPMSGroupBookingDetailBean.getStrPayee());
					objGroupLeader.setStrFandB(funEquals(objPMSGroupBookingDetailBean.getStrFandB(),objGroupLeader.getStrFandB()));
					objGroupLeader.setStrTelephone(funEquals(objPMSGroupBookingDetailBean.getStrTelephone(),objGroupLeader.getStrTelephone()));
					objGroupLeader.setStrExtra(funEquals(objPMSGroupBookingDetailBean.getStrExtra(),objGroupLeader.getStrExtra()));
					hmap.put(objPMSGroupBookingDetailBean.getStrPayee(), objGroupLeader);		
				}				
			}
			else
			{
				if(hmap.containsKey(objPMSGroupBookingDetailBean.getStrPayee()))
				{
					objGuest=hmap.get(objPMSGroupBookingDetailBean.getStrPayee());
					objGuest.setStrRoom(funEquals(objPMSGroupBookingDetailBean.getStrRoom(),objGuest.getStrRoom()));
					objGuest.setStrPayee(objPMSGroupBookingDetailBean.getStrPayee());
					objGuest.setStrFandB(funEquals(objPMSGroupBookingDetailBean.getStrFandB(),objGuest.getStrFandB()));
					objGuest.setStrTelephone(funEquals(objPMSGroupBookingDetailBean.getStrTelephone(),objGuest.getStrTelephone()));
					objGuest.setStrExtra(funEquals(objPMSGroupBookingDetailBean.getStrExtra(),objGuest.getStrExtra()));
					hmap.put(objPMSGroupBookingDetailBean.getStrPayee(), objGuest);
				}
				else
				{
					objGuest.setStrRoom(funEquals(objPMSGroupBookingDetailBean.getStrRoom(),objGuest.getStrRoom()));
					objGuest.setStrPayee(objPMSGroupBookingDetailBean.getStrPayee());
					objGuest.setStrFandB(funEquals(objPMSGroupBookingDetailBean.getStrFandB(),objGuest.getStrFandB()));
					objGuest.setStrTelephone(funEquals(objPMSGroupBookingDetailBean.getStrTelephone(),objGuest.getStrTelephone()));
					objGuest.setStrExtra(funEquals(objPMSGroupBookingDetailBean.getStrExtra(),objGuest.getStrExtra()));
					hmap.put(objPMSGroupBookingDetailBean.getStrPayee(), objGuest);	
				}				
			}
		}
			if(!hmap.containsKey("Group Leader"))
			{
				objGroupLeader.setStrRoom("N");
				objGroupLeader.setStrPayee("Group Leader");
				objGroupLeader.setStrFandB("N");
				objGroupLeader.setStrTelephone("N");
				objGroupLeader.setStrExtra("N");
				
			}
			else if(!hmap.containsKey("Guest"))
			{
				objGuest.setStrRoom("N");
				objGuest.setStrPayee("Guest");
				objGuest.setStrFandB("N");
				objGuest.setStrTelephone("N");
				objGuest.setStrExtra("N");
			}			
		
		listPMSGroupBookingDtlModel.add(objGroupLeader);
		listPMSGroupBookingDtlModel.add(objGuest);
		objModel.setListPMSGroupBookingDtlModel(listPMSGroupBookingDtlModel);		
		return objModel;
		

	}
	
	public String funEquals(String input, String defaultValue) {
		String op = "N";
		
		if(input!=null)
		{
			op="Y";
			
		}	
		else if(defaultValue=="Y")
		{
			op="Y";
		}
			
		return op;
	}

}
