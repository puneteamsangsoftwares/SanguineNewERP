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
import com.sanguine.webpms.bean.clsSeasonMasterBean;
import com.sanguine.webpms.dao.clsSeasonMasterDao;
import com.sanguine.webpms.model.clsBathTypeMasterModel;
import com.sanguine.webpms.model.clsSeasonMasterModel;
import com.sanguine.webpms.service.clsSeasonMasterService;





@Controller
public class clsSeasonMasterController{

	@Autowired
	private clsSeasonMasterService objSeasonMasterService;
	
	@Autowired
	private clsSeasonMasterDao objSeasonMasterDao;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	

//Open SeasonMaster
	@RequestMapping(value = "/frmSeasonMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request){
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if (urlHits.equalsIgnoreCase("1")) {

			return new ModelAndView("frmSeasonMaster", "command", new clsSeasonMasterModel());
		} else {
			return new ModelAndView("frmSeasonMaster_1", "command", new clsSeasonMasterModel());
		}
		/*return new ModelAndView("frmSeasonMaster","command", new clsSeasonMasterModel());*/
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmSeasonMaster1", method = RequestMethod.POST)
	public @ResponseBody clsSeasonMasterModel funLoadMasterData(HttpServletRequest request){
	
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("userCode").toString();
		clsSeasonMasterBean objBean=new clsSeasonMasterBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsSeasonMasterModel objSeasonMaster = new clsSeasonMasterModel();
		return objSeasonMaster;
	}

//Save or Update SeasonMaster
	@RequestMapping(value = "/saveSeasonMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsSeasonMasterBean objSeasonMasterBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsSeasonMasterModel objModel = objSeasonMasterService.funPrepareSeasonModel(objSeasonMasterBean, clientCode, userCode);
			objSeasonMasterDao.funAddUpdateSeasonMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Season Code : ".concat(objModel.getStrSeasonCode()));
			return new ModelAndView("redirect:/frmSeasonMaster.html");
		}
		else{
			return new ModelAndView("frmSeasonMaster");
		}
	}
	
	
	@RequestMapping(value = "/loadSeasonMasterData", method = RequestMethod.GET)
	public @ResponseBody clsSeasonMasterModel funFetchBathTypeMasterData(@RequestParam("SeasonCode") String SeasonCode, HttpServletRequest req) {
		clsSeasonMasterModel objSeasonMasterModel = null;
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		List listBathTypeData = objSeasonMasterDao.funGetSeasonMaster(SeasonCode, clientCode);
		objSeasonMasterModel = (clsSeasonMasterModel) listBathTypeData.get(0);
		objSeasonMasterModel.setDteFromDate(objGlobal.funGetDate("dd-MM-yyyy",objSeasonMasterModel.getDteFromDate()));
		objSeasonMasterModel.setDteToDate(objGlobal.funGetDate("dd-MM-yyyy",objSeasonMasterModel.getDteToDate()));
		return objSeasonMasterModel;
	}

//Convert bean to model function
	/*private clsSeasonMasterModel funPrepareModel(clsSeasonMasterBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsSeasonMasterModel objModel;
		return objModel;

	}*/

}
