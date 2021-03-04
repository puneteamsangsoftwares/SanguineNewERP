package com.sanguine.webpms.controller;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsfrmGroupBlockMasterBean;
import com.sanguine.webpms.model.clsBathTypeMasterModel;
import com.sanguine.webpms.model.clsfrmGroupBlockMasterModel;
import com.sanguine.webpms.service.clsfrmGroupBlockMasterService;

@Controller
public class clsfrmGroupBlockMasterController{

	@Autowired
	private clsfrmGroupBlockMasterService objfrmGroupBlockMasterService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

//Open frmGroupBlockMaster
	@RequestMapping(value = "/frmGroupBlockMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmGroupBlockMaster","command", new clsfrmGroupBlockMasterModel());
	}
//Load Master Data On Form
	@RequestMapping(value = "/loadGroupBlockData", method = RequestMethod.GET)
	public @ResponseBody clsfrmGroupBlockMasterModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsfrmGroupBlockMasterBean objBean=new clsfrmGroupBlockMasterBean();
		String docCode=request.getParameter("docCode").toString();
	
		clsfrmGroupBlockMasterModel objfrmGroupBlockMaster = objfrmGroupBlockMasterService.funGetfrmGroupBlockMaster(docCode, clientCode);
		return objfrmGroupBlockMaster;
	}

//Save or Update frmGroupBlockMaster
	@RequestMapping(value = "/savefrmGroupBlockMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsfrmGroupBlockMasterBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsfrmGroupBlockMasterModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objfrmGroupBlockMasterService.funAddUpdatefrmGroupBlockMaster(objModel);
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Group Block Code : ".concat(objModel.getStrGroupBlockCode()));

			return new ModelAndView("redirect:/frmGroupBlockMaster.html");
		}
		else{
			return new ModelAndView("frmGroupBlockMaster");
		}
	}

//Convert bean to model function
	private clsfrmGroupBlockMasterModel funPrepareModel(clsfrmGroupBlockMasterBean objBean,String userCode,String clientCode){

		clsfrmGroupBlockMasterModel objModel = new clsfrmGroupBlockMasterModel();
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		long lastNo = 0;

		if (objBean.getStrGroupBlockCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblgroupblockmaster", "GroupBlockMaster", "strGroupBlockCode", clientCode);
			// lastNo=1;
			String grpBlockCode = "GB" + String.format("%06d", lastNo);
			objModel.setStrGroupBlockCode(grpBlockCode);
			objModel.setStrUserCreated(userCode);
			objModel.setStrDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrGroupBlockCode(objBean.getStrGroupBlockCode());

		}
		objModel.setStrGroupBlockName(objBean.getStrGroupBlockName());
		objModel.setStrUserEdited(userCode);
		objModel.setStrUserCreated(userCode);
		objModel.setStrDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		objModel.setStrDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));

		return objModel;
	

	}

}
