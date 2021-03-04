package com.sanguine.webpms.controller;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.sanguine.webpms.bean.clsUpdateHouseKeepingStatusBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.service.clsRoomCancellationService;



@Controller
public class clsUpdateHouseKeepingStatusController {
	@Autowired
	private clsRoomCancellationService objRoomCancellationService;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	// Open RoomCancellation
	@RequestMapping(value = "/frmUpdateHouseKeepingStatus", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
		List listOfProperty = objGlobalFunctionsService.funGetList("select strPropertyName from "+webStockDB+".tblpropertymaster");
		model.put("listOfProperty", listOfProperty);
		List listOfReservationType = new ArrayList<String>();
		listOfReservationType.add("All");
		model.put("listOfReservationType", listOfReservationType);

		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmUpdateHouseKeepingStatus", "command", new clsUpdateHouseKeepingStatusBean());
		} else {
			return new ModelAndView("frmUpdateHouseKeepingStatus", "command", new clsUpdateHouseKeepingStatusBean());
		}
	}
	
	
	@RequestMapping(value = "/loadHouseKeepingStatusOfRooms", method = RequestMethod.GET)
	private @ResponseBody Map funShowHouseKeepingStatus(@RequestParam(value = "fDate") String fDate, @RequestParam(value = "tDate") String tDate, HttpServletRequest req, HttpServletResponse resp)
	{
		Map hmRoomData=new HashMap<>();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		try{		
			String sqlRooms ="select a.strRoomCode,a.strRoomDesc from tblroom a where a.strStatus='Dirty' and a.strClientCode='"+clientCode+"' ";
			List listOfRooms = objGlobalFunctionsService.funGetListModuleWise(sqlRooms, "sql");
			
			if(listOfRooms!=null)
			{
				hmRoomData.put("Rooms", listOfRooms);
			}
			
			String sqlHousekeepingName ="select a.strHouseKeepCode,a.strHouseKeepName from tblhousekeepmaster a where a.strClientCode='"+clientCode+"' ";
			List listHousekeepingName = objGlobalFunctionsService.funGetListModuleWise(sqlHousekeepingName, "sql");
			
			if(listOfRooms!=null)
			{
				hmRoomData.put("HouseKeepingName", listHousekeepingName);
			}
			
			}catch(Exception ex)
			{
				ex.printStackTrace();				
			}
			finally
			{
				return hmRoomData;
			}		
	}
	
		

	// Save or Update RoomCancellation
	@RequestMapping(value = "/saveHouseKeepingStatus", method = RequestMethod.POST)
	public ModelAndView funSaveUpdateHouseKeepingStatus(@ModelAttribute("command") @Valid clsUpdateHouseKeepingStatusBean objBean, BindingResult result, HttpServletRequest req) {
		List listRooms = new ArrayList<>();
		List listHouseKeeping = new ArrayList<>();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String strPMSDate = req.getSession().getAttribute("PMSDate").toString();
		String strFormattedDate  = objGlobal.funGetDate("yyyy-MM-dd", strPMSDate);
		LocalTime time = LocalTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
		String strCurrTime = time.format(formatter);
		if (!result.hasErrors()) 
		{
			for(clsUpdateHouseKeepingStatusBean obj:objBean.getListUpdateHouseKeepingStatusBean())
			{
				if(obj.getStrRoomFlag()!=null)
				{
					listRooms.add(obj.getStrRoomNo());
				}
				if(obj.getStrHouseKeepingFlag()!=null)
				{
					listHouseKeeping.add(obj.getStrHouseKeepingCode());
				}				
			}
			for(int i=0;i<listRooms.size();i++)
			{
				if(!listHouseKeeping.isEmpty())
				{
					String sql="UPDATE `tblroom` SET `strStatus`='Free', `strHouseKeepingFlg`='Y' WHERE  `strRoomCode`='"+listRooms.get(i)+"' AND `strClientCode`='"+clientCode+"';";
					objWebPMSUtility.funExecuteUpdate(sql, "sql");
					for(int j=0;j<listHouseKeeping.size();j++)
					{
						String sqlDeletePrevData = "delete from tblroomhousekeepdtl  where strRoomCode='"+listRooms.get(i)+"' and strRoomCodeFlg='Y' and strHouseKeepCode='"+listHouseKeeping.get(j)+"'";
						objWebPMSUtility.funExecuteUpdate(sqlDeletePrevData, "sql");
						
						String sqlInsertData = "INSERT INTO tblroomhousekeepdtl (`strHouseKeepCode`, `strRoomCode`, `strUser`,`dteDate`, `strRemarks`,`strRoomCodeFlg`, `strClientCode`) VALUES ('"+listHouseKeeping.get(j)+"', '"+listRooms.get(i)+"', '"+userCode+"','"+strFormattedDate+"''" +strCurrTime+"', ' ', '"+"Y"+"','"+clientCode+"');";
						objWebPMSUtility.funExecuteUpdate(sqlInsertData, "sql");
					}					
					/*String sqlUpdateFlg = "update tblroom a set a.strHouseKeepingFlg='Y' where a.strRoomCode='"+objBeanData.getStrRoomCode()+"' and a.strClientCode='"+clientCode+"'";
					objWebPMSUtility.funExecuteUpdate(sqlUpdateFlg, "sql");*/
				}
				
			
			}
		} 
		else {
			return new ModelAndView("redirect:/frmUpdateHouseKeepingStatus.html?saddr=" + 1);
		}
		return new ModelAndView("redirect:/frmUpdateHouseKeepingStatus.html?saddr=" + 1);
	}
}
	

