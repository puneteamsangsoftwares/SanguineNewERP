package com.sanguine.webpms.controller;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsBlockRoomBean;
import com.sanguine.webpms.bean.clsRoomMasterBean;
import com.sanguine.webpms.bean.clsUnBlockRoomBean;
import com.sanguine.webpms.bean.clsUpdateHouseKeepingStatusBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsBlockRoomModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.service.clsBlockRoomMasterService;
import com.sanguine.webpms.service.clsRoomMasterService;

@Controller
public class clsUnBlockRoomController {
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@RequestMapping(value = "/frmUnBlockRoomMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		
		clsUnBlockRoomBean UnBlockRoomBean=   new clsUnBlockRoomBean();
		String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
		String sqlBlockRoom="SELECT a.strRoomCode,a.strRoomDesc , a.strRoomTypeCode, c.strRoomTypeDesc"
				+ " FROM tblroom a,tblblockroom b, tblroomtypemaster c"
				+ " WHERE a.strRoomCode = b.strRoomCode AND"
				+ " a.strRoomTypeCode = c.strRoomTypeCode AND"
				+ " b.strRoomType = c.strRoomTypeCode"
				+ " ORDER BY c.strRoomTypeDesc";
		List listOfBlockRooms = objGlobalFunctionsService.funGetListModuleWise(sqlBlockRoom,"sql");

		JSONObject objUnBlockRoomBean= new JSONObject();
		JSONArray jrr= new JSONArray();
		List<clsUnBlockRoomBean> listOfBLkRoom=new ArrayList<>();
		if(listOfBlockRooms!=null && listOfBlockRooms.size()>0)
		{
			for(int i=0;i<listOfBlockRooms.size();i++)
			{
			      Object[] obj=(Object[])listOfBlockRooms.get(i);
			      objUnBlockRoomBean= new JSONObject();
			      objUnBlockRoomBean.put("strRoomCode",obj[0].toString());
			      objUnBlockRoomBean.put("strRoomDesc",obj[1].toString());
			      objUnBlockRoomBean.put("strRoomTypeCode",obj[2].toString());
			      objUnBlockRoomBean.put("strRoomTypeDesc",obj[3].toString());	
			      jrr.add(objUnBlockRoomBean);
			}
		}
		UnBlockRoomBean.setJsonArrBlockRooms(jrr);
		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmUnBlockRoomMaster", "command", UnBlockRoomBean);
		} else {
			return new ModelAndView("frmUnBlockRoomMaster_1", "command",UnBlockRoomBean);
		}
	}
	
	@RequestMapping(value = "/saveUnBlockRoom", method = RequestMethod.POST)
	public ModelAndView funAddUpdateUnblockRoom(@ModelAttribute("command") @Valid clsUnBlockRoomBean objBean, BindingResult result, HttpServletRequest req) {
		List listOfUnblockRooms = new ArrayList<>();
		List listUnblockRooms= new ArrayList<>();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		
		String strPMSDate = req.getSession().getAttribute("PMSDate").toString();
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		if (!result.hasErrors()) {
		
			String roomCode="";
			for(clsUnBlockRoomBean obj:objBean.getListOfUnblockRoom())
			{
				if(obj.getStrUnBlockRoomFlag()!=null && obj.getStrUnBlockRoomFlag().equalsIgnoreCase("Y"))
				{
				roomCode=roomCode+","+"'"+obj.getStrRoomCode()+"'";
				}
				
			}
			roomCode=roomCode.substring(1);
			
					String sql="UPDATE `tblroom` SET strStatus='Free' WHERE  `strRoomCode` in ("+roomCode+") AND `strClientCode`='"+clientCode+"'";
					objWebPMSUtility.funExecuteUpdate(sql, "sql");
					
					String sqlDeletePrevData = "delete from tblblockroom  where strRoomCode in ("+roomCode+") ";
					objWebPMSUtility.funExecuteUpdate(sqlDeletePrevData, "sql");
			
			req.getSession().setAttribute("success", true);

		}
	   else {
			
			return new ModelAndView("redirect:/frmUnBlockRoomMaster.html?saddr=" + urlHits);
		}
		return new ModelAndView("redirect:/frmUnBlockRoomMaster.html?saddr=" + urlHits);
	}
	
	


}
