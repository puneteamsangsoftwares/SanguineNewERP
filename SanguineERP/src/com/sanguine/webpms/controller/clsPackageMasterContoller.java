package com.sanguine.webpms.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsFloorMasterBean;
import com.sanguine.webpms.bean.clsPackageMasterBean;
import com.sanguine.webpms.bean.clsReservationBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsPackageMasterDtl;
import com.sanguine.webpms.model.clsPackageMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.model.clsReservationRoomRateModelDtl;
import com.sanguine.webpms.model.clsRoomPackageDtl;


@Controller
public class clsPackageMasterContoller {

	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	private intfBaseService objBaseService;
	
	// Open Package Master
		@RequestMapping(value = "/frmPackageMaster", method = RequestMethod.GET)
		public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
			String urlHits = "1";
			try {
				urlHits = request.getParameter("saddr").toString();
			} catch (NullPointerException e) {
				urlHits = "1";
			}
			
			if ("2".equalsIgnoreCase(urlHits)) {
				return new ModelAndView("frmPackageMaster_1", "command", new clsPackageMasterBean());
			} else if ("1".equalsIgnoreCase(urlHits)) {
				return new ModelAndView("frmPackageMaster", "command", new clsPackageMasterBean());
			} else {
				return null;
			}
		}
		
		@RequestMapping(value="/savePackageMaster", method = RequestMethod.GET)
		public ModelAndView  funAddUpdatePackageMaster(@ModelAttribute("command") @Valid clsPackageMasterBean objPackageMasterBean, BindingResult result, HttpServletRequest req) 
		{
			String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			
			long lastNo=0;
			boolean flgData=false;
			String packageCode="";
			clsPackageMasterHdModel objPkgHdModel=null;
			if (objPackageMasterBean.getStrPackageCode().trim().length() == 0) 
			{
				lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblpackagemasterhd", "PackageMaster", "strPackageCode", clientCode);
				packageCode = "PK" + String.format("%06d", lastNo);
			} 
			else
			{
				packageCode=objPackageMasterBean.getStrPackageCode();
			}
			objPkgHdModel=new clsPackageMasterHdModel();
			objPkgHdModel.setStrPackageCode(packageCode);
			objPkgHdModel.setStrPackageName(objPackageMasterBean.getStrPackageName());			
			objPkgHdModel.setDblPackageAmt(Double.parseDouble(objPackageMasterBean.getStrPackageAmount()));
		    objPkgHdModel.setStrUserCreated(userCode);
			objPkgHdModel.setStrUserEdited(userCode);
			objPkgHdModel.setDteDateCreated(PMSDate);
			objPkgHdModel.setDteDateEdited(PMSDate);
			objPkgHdModel.setStrClientCode(clientCode);
			objPkgHdModel.setStrPackageInclusiveRoomTerrif(objGlobal.funIfNull(objPackageMasterBean.getStrPackageInclusiveRoomTerrif(), "N", objPackageMasterBean.getStrPackageInclusiveRoomTerrif()));

			List<clsPackageMasterDtl> listPkgDtlModel = new ArrayList<clsPackageMasterDtl>();				
			clsPackageMasterDtl objPkdDtl=new clsPackageMasterDtl();
			objPkdDtl.setStrIncomeHeadCode(objPackageMasterBean.getStrIncomeHeadCode());
			objPkdDtl.setDblAmt(Double.parseDouble(objPackageMasterBean.getStrPackageAmount()));
			listPkgDtlModel.add(objPkdDtl);
			
			
			objPkgHdModel.setListPackageDtl(listPkgDtlModel);
			try {
				objBaseService.funSaveForPMS(objPkgHdModel);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Package Code : ".concat(objPkgHdModel.getStrPackageCode()));

			
			return new ModelAndView("redirect:/frmPackageMaster.html");
	

		}

		
		// Load selected package data
		@RequestMapping(value = "/loadPackageDataFromMaster", method = RequestMethod.GET)
		public @ResponseBody clsPackageMasterBean funLoadPackageMasterData(HttpServletRequest request) {

			String clientCode = request.getSession().getAttribute("clientCode").toString();
			String propCode = request.getSession().getAttribute("propertyCode").toString();
			String packageCode = request.getParameter("docCode").toString();
			clsPackageMasterBean objPackageMasterBean=new clsPackageMasterBean();
			List list = objGlobalFunctionsService.funGetListModuleWise("SELECT a.strPackageCode,a.strPackageName,b.strIncomeHeadCode,b.dblAmt,c.strIncomeHeadDesc,a.strPackageInclusiveRoomTerrif "
					+ " FROM tblpackagemasterhd a,tblpackagemasterdtl b,tblincomehead c "
					+ " where a.strPackageCode=b.strPackageCode and b.strIncomeHeadCode=c.strIncomeHeadCode "
					+ " and a.strPackageCode ='"+packageCode+"' and a.strClientCode='"+clientCode+"' "
					+ " group by b.strIncomeHeadCode", "sql");
			if(list.size()>0)
			{
				Object[] obj =(Object[])list.get(0);
				objPackageMasterBean.setStrPackageCode(packageCode);
				objPackageMasterBean.setStrPackageName(obj[1].toString());
				objPackageMasterBean.setStrIncomeHeadCode(obj[2].toString());
				objPackageMasterBean.setStrIncomeHeadName(obj[4].toString());
				objPackageMasterBean.setStrPackageAmount(obj[3].toString());
				objPackageMasterBean.setStrPackageAmount(obj[3].toString());
				objPackageMasterBean.setStrPackageInclusiveRoomTerrif(obj[5].toString());

			}	
			
			return objPackageMasterBean;
		}
		
}
