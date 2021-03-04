package com.sanguine.webpms.controller;
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


import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsPMSFeedbackMasterBean;
import com.sanguine.webpms.model.clsPMSFeedbackMasterModel;
import com.sanguine.webpms.service.clsPMSFeedbackMasterService;

@Controller
public class clsPMSFeedbackMasterController{

	@Autowired
	private clsPMSFeedbackMasterService objPMSFeedbackMasterService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

//Open PMSFeedbackMaster
	@RequestMapping(value = "/frmPMSFeedbackMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmPMSFeedbackMaster","command", new clsPMSFeedbackMasterBean());
		
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmPMSFeedbackMaster1", method = RequestMethod.GET)
	public @ResponseBody clsPMSFeedbackMasterModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsPMSFeedbackMasterBean objBean=new clsPMSFeedbackMasterBean();
		String docCode=request.getParameter("docCode").toString();
/*		List listModel=objGlobalFunctionsService.funGetList(sql);
*/		clsPMSFeedbackMasterModel objPMSFeedbackMaster = objPMSFeedbackMasterService.funGetPMSFeedbackMaster(docCode, clientCode);
		return objPMSFeedbackMaster;
	}

//Save or Update PMSFeedbackMaster
	@RequestMapping(value = "/savePMSFeedbackMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSFeedbackMasterBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsPMSFeedbackMasterModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objPMSFeedbackMasterService.funAddUpdatePMSFeedbackMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Feedback Code : ".concat(objModel.getStrFeedbackCode()));

			
			return new ModelAndView("redirect:/frmPMSFeedbackMaster.html");
		}
		else{
			return new ModelAndView("frmPMSFeedbackMaster");
		}
	}

//Convert bean to model function
	private clsPMSFeedbackMasterModel funPrepareModel(clsPMSFeedbackMasterBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsPMSFeedbackMasterModel objModel = new clsPMSFeedbackMasterModel();
		
		if (objBean.getStrFeedbackCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblpmsfeedbackmaster", "FeedbackMastter", "strFeedbackCode", clientCode);
			// lastNo=1;
			String feedbackCode = "FB" + String.format("%06d", lastNo);
			objModel.setStrFeedbackCode(feedbackCode);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrFeedbackCode(objBean.getStrFeedbackCode());

		}
		objModel.setStrFeedbackDesc(objBean.getStrFeedbackDesc());
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrUserCreated(userCode);
		objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		
		return objModel;

	}

}
