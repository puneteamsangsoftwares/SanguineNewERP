package com.sanguine.webpms.controller;

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
import com.sanguine.webpms.bean.clsPMSStaffMasterBean;
import com.sanguine.webpms.model.clsPMSStaffMasterDtlModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel;
import com.sanguine.webpms.model.clsPMSStaffMasterModel_ID;
import com.sanguine.webpms.service.clsPMSStaffMasterService;

@Controller
public class clsPMSStaffMasterController{

	@Autowired
	private clsPMSStaffMasterService objPMSStaffMasterService;
			
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;
	

//Open PMSStaffMaster
	@RequestMapping(value = "/frmPMSStaffMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){
		return new ModelAndView("frmPMSStaffMaster","command", new clsPMSStaffMasterBean());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmPMSStaffMaster1", method = RequestMethod.POST)
	public @ResponseBody clsPMSStaffMasterModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("userCode").toString();
		clsPMSStaffMasterBean objBean=new clsPMSStaffMasterBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsPMSStaffMasterModel objPMSStaffMaster = new clsPMSStaffMasterModel();
		return objPMSStaffMaster;
	}

//Save or Update PMSStaffMaster
	@RequestMapping(value = "/savePMSStaffMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSStaffMasterBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			clsPMSStaffMasterModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objPMSStaffMasterService.funAddUpdatePMSStaffMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage",objModel.getStrStaffCode());
			return new ModelAndView("redirect:/frmPMSStaffMaster.html");
		}
		else{
			return new ModelAndView("frmPMSStaffMaster");
		}
	}
	
	@RequestMapping(value = "/loadPMSStaffMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPMSStaffMasterModel funAssignFields(@RequestParam("staffCode") String staffCode, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		clsPMSStaffMasterModel objLocCode = objPMSStaffMasterService.funGetObject(staffCode, clientCode);
		if (null == objLocCode) {
			objLocCode = new clsPMSStaffMasterModel();
		}
		return objLocCode;
	}
	
	// Load Staff Master Detail
	@RequestMapping(value = "/loadStaffMasterRoomsDtl", method = RequestMethod.GET)
	public @ResponseBody List funLoadFacilityMasterListData(@RequestParam("staffCode") String staffCode, HttpServletRequest req) {
		objGlobal = new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		List<String> list = objPMSStaffMasterService.funGetPMSStaffMasterDtl(staffCode,clientCode); 
		return list;					
	}
		
//Convert bean to model function
	private clsPMSStaffMasterModel funPrepareModel(clsPMSStaffMasterBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsPMSStaffMasterModel objModel = null;		
		clsPMSStaffMasterModel mpModel;
			if (objBean.getStrStaffCode().trim().length() == 0) {
				lastNo = objGlobalFunctionsService.funGetLastNo("tblpmsstaffmaster", "Staff Master", "intSTId", clientCode);
				String customerCode = "ST" + String.format("%06d", lastNo);
				mpModel = new clsPMSStaffMasterModel(new clsPMSStaffMasterModel_ID(customerCode, clientCode));
				mpModel.setIntSTId(lastNo);				
				mpModel.setStrStaffCode(customerCode);
				mpModel.setStrStaffName(objBean.getStrStaffName());
				mpModel.setDtCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));		
				mpModel.setDtEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));	
				mpModel.setStrClientCode(clientCode);
				mpModel.setStrUserCreated(userCode);			
				mpModel.setStrUserEdited(userCode);	
			} else {
				
				clsPMSStaffMasterModel objMemberProfile = objPMSStaffMasterService.funGetPMSStaffMaster(objBean.getStrStaffCode(), clientCode);
				if (null == objMemberProfile) {
					lastNo = objGlobalFunctionsService.funGetLastNo("tblpmsstaffmaster", "Staff Master", "intSTId", clientCode);
					String customerCode = "ST" + String.format("%06d", lastNo);
					mpModel = new clsPMSStaffMasterModel(new clsPMSStaffMasterModel_ID(customerCode, clientCode));
					mpModel.setIntSTId(lastNo);				
					mpModel.setStrStaffCode(customerCode);
					mpModel.setStrStaffName(objBean.getStrStaffName());
					mpModel.setDtCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));		
					mpModel.setDtEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));	
					mpModel.setStrClientCode(clientCode);
					mpModel.setStrUserCreated(userCode);			
					mpModel.setStrUserEdited(userCode);	
					
				} else {
					mpModel = new clsPMSStaffMasterModel(new clsPMSStaffMasterModel_ID(objBean.getStrStaffCode(), clientCode));	
					mpModel.setIntSTId(objMemberProfile.getIntSTId());				
					mpModel.setStrStaffCode(objBean.getStrStaffCode());
					mpModel.setStrStaffName(objBean.getStrStaffName());
					mpModel.setDtCreated(objMemberProfile.getDtCreated());						
					mpModel.setStrClientCode(objMemberProfile.getStrClientCode());
					mpModel.setStrUserCreated(objMemberProfile.getStrUserCreated());
					}
			}			
			mpModel.setStrUserEdited(userCode);			
			mpModel.setDtEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		
			//Staff Master Details			
			if(objBean.getListStaffMasterDtl()!=null)
			{
				objPMSStaffMasterService.funDeleteStaffMasterDtl(mpModel.getStrStaffCode(),clientCode);
				for(int i=0;i<objBean.getListStaffMasterDtl().size();i++)
				{
					clsPMSStaffMasterDtlModel objDtlModel = new clsPMSStaffMasterDtlModel();
					objDtlModel=objBean.getListStaffMasterDtl().get(i);
					if(objDtlModel.getStrRoomCode()!=null)
					{
						objDtlModel.setStrStffCode(mpModel.getStrStaffCode());
						objDtlModel.setStrRoomCode(objBean.getListStaffMasterDtl().get(i).getStrRoomCode());
						objDtlModel.setStrRoomDesc(objBean.getListStaffMasterDtl().get(i).getStrRoomDesc());
						objDtlModel.setStrClientCode(clientCode);
						objPMSStaffMasterService.funAddUpdatePMSStaffMasterDtl(objDtlModel);	
					}
				}
				
			}			
			return mpModel;		
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/loadRoomsDtlListForFloor", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomsDtlListForFloor(@RequestParam("floorCode") String floorCode, HttpServletRequest req) {
		String clientCode=req.getSession().getAttribute("clientCode").toString();
		String sqlRoomCode = "select a.strRoomCode,a.strRoomDesc from tblroom a,tblfloormaster b"
				+ " where a.strFloorCode=b.strFloorCode"
				+ " and a.strClientCode=b.strClientCode  and b.strFloorCode='"+floorCode+"' and a.strClientCode='"+clientCode+"'";
		List listRoomCode = objGlobalFunctionsService.funGetListModuleWise(sqlRoomCode, "sql");
		
		return listRoomCode;					
	}
	
	
			
	
	
	

}
