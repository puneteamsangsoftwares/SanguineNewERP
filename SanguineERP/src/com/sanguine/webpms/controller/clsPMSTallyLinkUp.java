package com.sanguine.webpms.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.bean.clsOpeningStkBean;
import com.sanguine.bean.clsPOSLinkUpBean;
import com.sanguine.bean.clsTallyLinkUpBean;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPOSLinkUpModel;
import com.sanguine.model.clsTallyLinkUpModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsTallyLinkUpService;

@Controller
public class clsPMSTallyLinkUp {

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsTallyLinkUpService objTallyLinkUpService;

	private clsGlobalFunctions objGlobal = null;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.setAutoGrowCollectionLimit(1000000);
	}
	
	//@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/frmPMSTallyLinkUp", method = RequestMethod.GET)
	public ModelAndView funOpenForm( @ModelAttribute("command") clsTallyLinkUpBean objBean,Map<String, Object> model, HttpServletRequest request) {

		String dbWebStock=request.getSession().getAttribute("WebStockDB").toString();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
			String sql = "";
			//if (objBean.getStrLinkup().equals("Room Type")) {
				sql = " select a.strRoomTypeCode,a.strRoomTypeDesc,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') "
						+ " from tblroomtypemaster a "
						+ "left outer join "+dbWebStock+".tbltallylinkup b on a.strRoomTypeCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			//}

			ArrayList list = (ArrayList) objGlobalFunctionsService.funGetDataList(sql, "sql");
			List listTallyLinkUp = new ArrayList<clsTallyLinkUpModel>();
			for (int cnt = 0; cnt < list.size(); cnt++) {
				clsTallyLinkUpModel objModel = new clsTallyLinkUpModel();
				Object[] arrObj = (Object[]) list.get(cnt);
				objModel.setStrGroupCode(arrObj[0].toString());
				objModel.setStrGroupName(arrObj[1].toString());
				objModel.setStrGDes(arrObj[2].toString());
				objModel.setStrTallyCode(arrObj[3].toString());
				listTallyLinkUp.add(objModel);
			}

			objBean.setListTallyLinkUp(listTallyLinkUp);
			model.put("TallyLinkUpList", objBean);

		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSTallyLinkUp_1", "command", objBean);

		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSTallyLinkUp", "command", objBean);
		} else {
			return null;
		}
	}

	// Save or Update LinkUp
	@RequestMapping(value = "/savePMSTallyLinkUp", method = RequestMethod.POST)
	public ModelAndView funPMSAddUpdate(@ModelAttribute("command") @Valid clsTallyLinkUpBean objBean, BindingResult result, HttpServletRequest req) {
		if (!result.hasErrors()) {
			
			String dbWebStock=req.getSession().getAttribute("WebStockDB").toString();
			objGlobal = new clsGlobalFunctions();
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			List<clsTallyLinkUpModel> listTallyLinkUp = objBean.getListTallyLinkUp();
			for (int cnt = 0; cnt < listTallyLinkUp.size(); cnt++) {
				clsTallyLinkUpModel objModel = listTallyLinkUp.get(cnt);
				objModel.setStrClientCode(clientCode);
				// objTallyLinkUpService.funAddUpdatePOSLinkUp(objModel);
				String delete = " delete from "+dbWebStock+".tbltallylinkup where strGroupCode='" + objModel.getStrGroupCode() + "' and strClientCode='" + clientCode + "' ";
				objTallyLinkUpService.funExecute(delete);
				objModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				;
				objModel.setDteLastModified(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objModel.setStrUserCreated(userCode);
				objModel.setStrUserEdited(userCode);
				objTallyLinkUpService.funAddUpdate(objModel);
			}

			return new ModelAndView("redirect:/frmPMSTallyLinkUp.html");
		} else {
			return new ModelAndView("frmPMSTallyLinkUp");
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/loadLinkUpPMSData", method = RequestMethod.POST)
	public ModelAndView loadLinkUpPMSData(@ModelAttribute("command") clsTallyLinkUpBean objBean, Map<String, Object> model, HttpServletRequest request) {

		String dbWebStock=request.getSession().getAttribute("WebStockDB").toString();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String urlHits = "1";
		try {
			// urlHits=request.getParameter("saddr").toString();
			String sql = "";
			if (objBean.getStrLinkup().equals("Room Type")) {
				sql = " select a.strRoomTypeCode,a.strRoomTypeDesc,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') "
						+ " from tblroomtypemaster a "
						+ "left outer join "+dbWebStock+".tbltallylinkup b on a.strRoomTypeCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}

			if (objBean.getStrLinkup().equals("Package")) {
				sql = " select a.strPackageCode,a.strPackageName,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') from tblpackagemasterhd a "
						+ " left outer join "+dbWebStock+".tbltallylinkup b ON a.strPackageCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}

			if (objBean.getStrLinkup().equals("Tax")) {
				sql = " select a.strTaxCode,a.strTaxDesc,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'')  from tbltaxmaster a "
						+ " left outer join "+dbWebStock+".tbltallylinkup b on a.strTaxCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}
			if (objBean.getStrLinkup().equals("Guest")) {
				sql = " select a.strGuestCode,CONCAT(a.strFirstName,' ',a.strMiddleName,' ',a.strLastName),ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') "
						+ " from tblguestmaster a "
						+ " left outer join "+dbWebStock+".tbltallylinkup b on a.strGuestCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}
			if (objBean.getStrLinkup().equals("Income Head")) {
				sql = "select a.strIncomeHeadCode,a.strIncomeHeadDesc,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') "
						+ " from tblincomehead a "
						+ " left outer join "+dbWebStock+".tbltallylinkup b on a.strIncomeHeadCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}
			if (objBean.getStrLinkup().equals("Settlement")) {
				sql = "SELECT a.strSettlementCode,a.strSettlementDesc,ifnull(b.strGDes,''),ifnull(b.strTallyCode,'') "
						+ " from tblsettlementmaster a "
						+ " left outer join "+dbWebStock+".tbltallylinkup b  ON a.strSettlementCode=b.strGroupCode"
						+ " where a.strClientCode='"+clientCode+"';";
			}

			ArrayList list = (ArrayList) objGlobalFunctionsService.funGetDataList(sql, "sql");
			List listTallyLinkUp = new ArrayList<clsTallyLinkUpModel>();
			for (int cnt = 0; cnt < list.size(); cnt++) {
				clsTallyLinkUpModel objModel = new clsTallyLinkUpModel();
				Object[] arrObj = (Object[]) list.get(cnt);
				objModel.setStrGroupCode(arrObj[0].toString());
				objModel.setStrGroupName(arrObj[1].toString());
				objModel.setStrGDes(arrObj[2].toString());
				objModel.setStrTallyCode(arrObj[3].toString());
				listTallyLinkUp.add(objModel);
			}

			objBean.setListTallyLinkUp(listTallyLinkUp);
			model.put("TallyLinkUpList", objBean);

		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSTallyLinkUp_1", "command", objBean);

		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSTallyLinkUp", "command", objBean);
		} else {
			return null;
		}
	}

}
