package com.sanguine.webclub.controller;

import java.util.List;

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
import com.sanguine.webclub.bean.clsWebClubPersonMasterBean;
import com.sanguine.webclub.model.clsWebClubFacilityMasterModel;
import com.sanguine.webclub.model.clsWebClubPersonMasterModel;
import com.sanguine.webclub.model.clsWebClubPersonMasterModel_ID;
import com.sanguine.webclub.service.clsWebClubPersonMasterService;

@Controller
public class clsWebClubPersonMasterController{

	@Autowired
	private clsWebClubPersonMasterService objWebClubPersonMasterService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

//Open WebClubPersonMaster
	@RequestMapping(value = "/frmWebClubPersonMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmWebClubPersonMaster","command", new clsWebClubPersonMasterModel());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmWebClubPersonMaster1", method = RequestMethod.POST)
	public @ResponseBody clsWebClubPersonMasterModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsWebClubPersonMasterBean objBean=new clsWebClubPersonMasterBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsWebClubPersonMasterModel objWebClubPersonMaster = new clsWebClubPersonMasterModel();
		return objWebClubPersonMaster;
	}

//Save or Update WebClubPersonMaster
	@RequestMapping(value = "/saveWebClubPersonMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsWebClubPersonMasterBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsWebClubPersonMasterModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objWebClubPersonMasterService.funAddUpdateWebClubPersonMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Facility Code : ".concat(objModel.getStrPCode()));
			return new ModelAndView("redirect:/frmWebClubPersonMaster.html");
		}
		else{
			return new ModelAndView("frmWebClubPersonMaster");
		}
	}

	//Convert bean to model function
	private clsWebClubPersonMasterModel funPrepareModel(clsWebClubPersonMasterBean objBean,String userCode,String clientCode){
		objGlobal = new clsGlobalFunctions();
		long lastNo = 0;
		String strOperationalNY="N"; 
		clsWebClubPersonMasterModel objModel;
		if (objBean.getStrPCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetLastNo("tblpersonmaster", "PersonMaster", "intGId", clientCode);
			String strPCode = "P" + String.format("%06d", lastNo);
			objModel = new clsWebClubPersonMasterModel(new clsWebClubPersonMasterModel_ID(strPCode, clientCode));
			objModel.setIntGId(lastNo);
			objModel.setStrPCode(strPCode);
			objModel.setStrPName(objBean.getStrPName());		
			objModel.setStrEmail(objBean.getStrEmail());	
			objModel.setStrMobileNo(objBean.getStrMobileNo());	
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));			
			objModel.setStrUserCreated(userCode);			
		} else {
			
		    clsWebClubPersonMasterModel objPersonModel = objWebClubPersonMasterService.funGetWebClubPersonMaster(objBean.getStrPCode(), clientCode);
			objModel = new clsWebClubPersonMasterModel(new clsWebClubPersonMasterModel_ID(objBean.getStrPCode(), clientCode));
			objModel.setStrPCode(objPersonModel.getStrPCode());
			objModel.setStrPName(objBean.getStrPName());	
			objModel.setStrEmail(objBean.getStrEmail());
			objModel.setStrMobileNo(objBean.getStrMobileNo());
			objModel.setDteDateCreated(objPersonModel.getDteDateCreated());	
			objModel.setStrUserCreated(objPersonModel.getStrUserCreated());						
			
		}
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));		
		return objModel;
	}
	
	
	// Assign filed function to set data onto form for edit transaction.
		@RequestMapping(value = "/loadWebClubPersonMasterData", method = RequestMethod.GET)
		public @ResponseBody clsWebClubPersonMasterModel funAssignFields(@RequestParam("docCode") String PersonCode, HttpServletRequest req) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			clsWebClubPersonMasterModel objPersonModel = objWebClubPersonMasterService.funGetWebClubPersonMaster(PersonCode, clientCode);
			if (null == objPersonModel) {
				objPersonModel = new clsWebClubPersonMasterModel();
				objPersonModel.setStrPCode("Invalid Code");
			}

			return objPersonModel;
		}


}
