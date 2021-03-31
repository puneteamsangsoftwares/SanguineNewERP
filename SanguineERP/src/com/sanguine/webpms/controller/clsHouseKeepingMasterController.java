package com.sanguine.webpms.controller;

import javax.servlet.http.HttpServletRequest;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsHouseKeepingMasterBean;
import com.sanguine.webpms.bean.clsUnBlockRoomBean;
import com.sanguine.webpms.dao.clsHouseKeepingMasterDao;
import com.sanguine.webpms.model.clsHouseKeepingMasterModel;
import com.sanguine.webpms.model.clsPMSReasonMasterModel;
import com.sanguine.webpms.service.clsHouseKeepingMasterService;

@Controller
public class clsHouseKeepingMasterController{

	@Autowired
	private clsHouseKeepingMasterService objHouseKeepingMasterService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	@Autowired
	private clsHouseKeepingMasterDao objHouseKeepDao;
	
	private clsGlobalFunctions objGlobal=null;

    //Open HouseKeepingMaster
	@RequestMapping(value = "/frmHouseKeepingMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request){
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		clsHouseKeepingMasterBean objHouseKeepingMasterBean =new clsHouseKeepingMasterBean();
		   
        String sqlHouseKeeping="SELECT a.strRoomTypeCode,a.strRoomTypeDesc"
    		               +" FROM tblroomtypemaster a";
        List listOfHouseKeep = objGlobalFunctionsService.funGetListModuleWise(sqlHouseKeeping,"sql");
         
        JSONObject objHouseKeepingMaster= new JSONObject();
		JSONArray jArr= new JSONArray();
		List<clsHouseKeepingMasterBean> listOfHouseKeepm=new ArrayList<>();
		if(listOfHouseKeep!=null && listOfHouseKeep.size()>0)
		{
			for(int i=0;i<listOfHouseKeep.size();i++)
			{
			      Object[] obj=(Object[])listOfHouseKeep.get(i);
			      objHouseKeepingMaster= new JSONObject();
			      objHouseKeepingMaster.put("strRoomTypeCode",obj[0].toString());
			      objHouseKeepingMaster.put("strRoomTypeDesc",obj[1].toString());	
			      jArr.add(objHouseKeepingMaster);
			}
		}
		objHouseKeepingMasterBean.setJsonArrHouseKeeping(jArr);
		return new ModelAndView("frmHouseKeepingMaster","command", objHouseKeepingMasterBean);
	}

	//Load Master Data On Form
	@RequestMapping(value = "/frmHouseKeepingMaster1", method = RequestMethod.POST)
	public @ResponseBody clsHouseKeepingMasterModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("userCode").toString();
		clsHouseKeepingMasterBean objBean=new clsHouseKeepingMasterBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsHouseKeepingMasterModel objHouseKeepingMaster = new clsHouseKeepingMasterModel();
		return objHouseKeepingMaster;
	}

//Save or Update HouseKeepingMaster
	@RequestMapping(value = "/saveHouseKeepingMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsHouseKeepingMasterBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsHouseKeepingMasterModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objHouseKeepingMasterService.funAddUpdateHouseKeepingMaster(objModel);
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Business Code : ".concat(objModel.getStrHouseKeepCode()));

			return new ModelAndView("redirect:/frmHouseKeepingMaster.html");
		}
		else{
			return new ModelAndView("frmHouseKeepingMaster");
		}
	}

//Convert bean to model function
	private clsHouseKeepingMasterModel funPrepareModel(clsHouseKeepingMasterBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsHouseKeepingMasterModel objModel = new clsHouseKeepingMasterModel();
		
		if (objBean.getStrHouseKeepCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblhousekeepmaster", "HouseKeepingMaster", "strHouseKeepCode", clientCode);
			String houseKeepCode = "HK" + String.format("%06d", lastNo);
			objModel.setStrHouseKeepCode(houseKeepCode);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrHouseKeepCode(objBean.getStrHouseKeepCode());
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));

		}
		
		String roomTypeCode="";
		for(clsHouseKeepingMasterBean obj:objBean.getListOfHouseKeeping())
		{
			if(obj.getStrIsRoomTypeSelected()!=null && obj.getStrIsRoomTypeSelected().equalsIgnoreCase("Y"))
			{
				roomTypeCode=roomTypeCode+","+obj.getStrHouseKeepCode();
			}
			
		}
		if(roomTypeCode.length()>0)
		{		
		roomTypeCode=roomTypeCode.substring(1);
		}
		objModel.setStrClientCode(clientCode);
		objModel.setStrHouseKeepName(objBean.getStrHouseKeepName());
		objModel.setStrRemarks(objBean.getStrRemarks());
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrRoomTypeCode(roomTypeCode);
		
		
		return objModel;

	}
	
	@RequestMapping(value = "/loadHouseKeepData", method = RequestMethod.GET)
	public @ResponseBody clsHouseKeepingMasterModel funFetchReasonMasterData(@RequestParam("houseKeepCode") String strHouseKKeepCode, HttpServletRequest req) {

		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsHouseKeepingMasterModel objHouseKepModel = objHouseKeepDao.funGetHouseKeepingMaster(strHouseKKeepCode, clientCode);
		return objHouseKepModel;
	}


}
