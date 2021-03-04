package com.sanguine.webclub.controller;

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
import com.sanguine.webclub.bean.clsDependentMasterBean;
import com.sanguine.webclub.model.clsWebClubDependentMasterModel;
import com.sanguine.webclub.model.clsWebClubMemberProfileModel;
import com.sanguine.webclub.service.clsWebClubMemberProfileService;

@Controller
public class clsDependentMasterController {

	
	@Autowired
	clsGlobalFunctionsService objGlobalService;
	
	@Autowired
	private clsWebClubMemberProfileService objMemberProfileService;
	
	@Autowired
	clsGlobalFunctions objGlobal;
	
	// Open MemberProfile
	@RequestMapping(value = "/frmDependentMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmDependentMaster", "command", new clsDependentMasterBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmDependentMaster", "command", new clsDependentMasterBean());
		} else {
			return null;
		}

	}
	
	@RequestMapping(value = "/loadWebClubDependentMaster", method = RequestMethod.GET)
	public @ResponseBody List funMemberWiseFieldData(@RequestParam("deptCode") String deptCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String strWebPMSDB=req.getSession().getAttribute("WebPMSDB").toString();
		String sql="SELECT strFullname FROM "+strWebPMSDB+".tblmembermaster a WHERE a.strMemberCode='"+deptCode+"' AND a.strClientCode='"+clientCode+"' ";
		List list = objGlobalService.funGetList("SELECT strFullname FROM "+strWebPMSDB+".tblmembermaster a WHERE a.strMemberCode='"+deptCode+"' AND a.strClientCode='"+clientCode+"'", "sql");			
		
		return list;
		
		
	}
	
	@RequestMapping(value = "/saveDependentMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsDependentMasterBean depBean, BindingResult result, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		objGlobal=new clsGlobalFunctions();
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		
		if (!result.hasErrors()) {
			// for Dependent member
			clsWebClubMemberProfileModel objMemberProfile = objMemberProfileService.funGetMember(depBean.getStrDepCode(), clientCode);
			objMemberProfile.setStrMemberCode(depBean.getStrCDepCode());
			objMemberProfile.setStrFullName(depBean.getStrCDepName());			
			objMemberProfile.setStrUserModified(userCode);
			objMemberProfile.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objMemberProfileService.funAddUpdateMemberProfile(objMemberProfile);
		
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Dependent Code Change : "+depBean.getStrDepCode()+" To "+depBean.getStrCDepCode());
			return new ModelAndView("redirect:/frmDependentMaster.html?saddr=" + urlHits);
		}
		return new ModelAndView("redirect:/frmDependentMaster.html?saddr=" + urlHits);

	}

	
	
	
	
	
	
	
	
	
	
	
}
