package com.sanguine.webclub.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.hibernate.SessionFactory;
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
import com.sanguine.model.clsWebClubBankMasterModel;
import com.sanguine.model.clsWebClubBankMasterModel_ID;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webclub.bean.clsWebClubBankMasterBean;
import com.sanguine.webclub.service.clsWebClubBankMasterService;

@Controller
public class clsWebClubBankMasterController {

	@Autowired
	private clsWebClubBankMasterService objWebClubBankMasterService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal = null;
	
	@Autowired
	private SessionFactory sessionFactory;

	// Open BankMaster
	@RequestMapping(value = "/frmWebClubBankMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmWebClubBankMaster", "command", new clsWebClubBankMasterModel());
		} else {
			return new ModelAndView("frmWebClubBankMaster", "command", new clsWebClubBankMasterModel());
		}
	}

	// Load Master Data On Form
	@RequestMapping(value = "/loadWebClubBankMasterData", method = RequestMethod.GET)
	public @ResponseBody clsWebClubBankMasterModel funAssignFields(@RequestParam("bankCode") String bankCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubBankMasterModel objModel = objWebClubBankMasterService.funGetBankMaster(bankCode, clientCode);
		if (null == objModel) {
			objModel = new clsWebClubBankMasterModel();
			objModel.setStrBankCode("Invalid Code");
		}

		return objModel;
	}

	// Save or Update BankMaster
	@RequestMapping(value = "/saveBankMasterWebClub", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsWebClubBankMasterBean objBean, BindingResult result, HttpServletRequest req) {
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propCode = req.getSession().getAttribute("propertyCode").toString();
			clsWebClubBankMasterModel objModel = funPrepareModel(objBean, userCode, clientCode, propCode);
			objWebClubBankMasterService.funAddUpdateBankMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Bank Code : ".concat(objModel.getStrBankCode()));

			return new ModelAndView("redirect:/frmWebClubBankMaster.html?saddr=" + urlHits);
		} else {
			return new ModelAndView("redirect:/frmWebClubBankMaster.html?saddr=" + urlHits);
		}
	}

	// Convert bean to model function
	private clsWebClubBankMasterModel funPrepareModel(clsWebClubBankMasterBean objBean, String userCode, String clientCode, String propCode) {
		objGlobal = new clsGlobalFunctions();
		long lastNo = 0;
		clsWebClubBankMasterModel objModel;
		if (objBean.getStrBankCode().trim().length() == 0) {
			//lastNo = objGlobalFunctionsService.funGetLastNo("tblbankmaster", "BankMaster", "intGId", clientCode);
			lastNo = objGlobalFunctionsService.funGetLastNoModuleWise("tblbankmaster", "BankMaster", "intGId", clientCode,"1-WebStocks");
			String bankCode = String.format("%06d", lastNo);
			objModel = new clsWebClubBankMasterModel(new clsWebClubBankMasterModel_ID(bankCode, clientCode));
			objModel.setIntGId(lastNo);
		} else {
			objModel = new clsWebClubBankMasterModel(new clsWebClubBankMasterModel_ID(objBean.getStrBankCode(), clientCode));
		}

		objModel.setStrBankName(objBean.getStrBankName().toUpperCase());
		objModel.setStrBranch(objBean.getStrBranch());
		objModel.setStrMICR(objBean.getStrMICR());
		objModel.setStrUserCreated(userCode);
		objModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrUserModified(userCode);
		objModel.setDteLastModified(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		objModel.setStrPropertyCode(propCode);

		return objModel;

	}

}
