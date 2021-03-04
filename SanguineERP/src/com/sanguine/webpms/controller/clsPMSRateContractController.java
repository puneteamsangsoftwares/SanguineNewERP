package com.sanguine.webpms.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsPMSRateContractBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsPMSRateContractModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.service.clsPMSRateContractService;
import com.sanguine.webpms.service.clsPropertySetupService;

import sun.misc.BASE64Encoder;

@Controller
public class clsPMSRateContractController{

	@Autowired
	private clsPMSRateContractService objPMSRateContractService;
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

	@Autowired
	private clsPropertySetupService objPropertySetupService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

//Open PMSRateContract
	@RequestMapping(value = "/frmPMSRateContract", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request){
		String clientCode=request.getSession().getAttribute("clientCode").toString();

		String sqlRoomTypes = "select a.strRoomTypeCode,a.strRoomTypeDesc from tblroomtypemaster a where a.strClientCode='"+clientCode+"'";
		
		List list = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTypes, "sql");
		List roomTypeCode = new ArrayList<>();
		List roomTypeDesc = new ArrayList<>();
		if(list!=null && list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				Object[] arr = (Object[]) list.get(i);
				
				roomTypeCode.add(arr[0].toString());
				roomTypeDesc.add(arr[1].toString());
				
			}
			
			

		}
		model.put("RoomType", roomTypeCode);
		model.put("RoomDesc", roomTypeDesc);

		String sqlSeason = "select a.strSeasonCode,a.strSeasonDesc  from tblseasonmaster a  where a.strClientCode='"+clientCode+"'";
		
		List listSeason = objGlobalFunctionsService.funGetListModuleWise(sqlSeason, "sql");
		List seasonType = new ArrayList<>();
		List seasonDesc = new ArrayList<>();

		if(listSeason!=null && listSeason.size()>0)
		{
			
			for(int i=0;i<listSeason.size();i++)
			{
				Object[] arr = (Object[]) listSeason.get(i);
				
				seasonType.add(arr[0].toString());
				seasonDesc.add(arr[1].toString());
				
			}
			

		}
		model.put("Season", seasonType);
		model.put("SeasonDesc", seasonDesc);
		
		return new ModelAndView("frmPMSRateContract","command", new clsPMSRateContractModel());
	}
//Load Master Data On Form
	@RequestMapping(value = "/frmLRateContract1", method = RequestMethod.POST)
	public @ResponseBody clsPMSRateContractModel funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("userCode").toString();
		clsPMSRateContractBean objBean=new clsPMSRateContractBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsPMSRateContractModel objPMSRateContract = new clsPMSRateContractModel();
		return objPMSRateContract;
	}
	
	@RequestMapping(value = "/loadPMSRateCode", method = RequestMethod.GET)
	public @ResponseBody clsPMSRateContractModel funFetchSettlementMasterData(@RequestParam("code") String code, HttpServletRequest req) {
		clsPMSRateContractModel objPMSRateContractModel = null;
		objGlobal=new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		objPMSRateContractModel = objPMSRateContractService.funGetPMSRateContract(code, clientCode);
		objPMSRateContractModel.setDteFromDate(objGlobal.funGetDate("dd-MM-yyyy", objPMSRateContractModel.getDteFromDate()));
		objPMSRateContractModel.setDteToDate(objGlobal.funGetDate("dd-MM-yyyy", objPMSRateContractModel.getDteToDate()));
		String sqlRoomTypeCode = "select a.strRoomTypeDesc from tblroomtypemaster a where a.strRoomTypeCode='"+objPMSRateContractModel.getStrRoomTypeCode()+"'";
		List listROomtypeCode = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTypeCode, "sql");
		if(listROomtypeCode!=null && listROomtypeCode.size()>0)
		{
			objPMSRateContractModel.setStrRoomTypeCode(listROomtypeCode.get(0).toString());
		}
		String sqlSeasonCode = "select a.strSeasonDesc from tblseasonmaster a where a.strSeasonCode='"+objPMSRateContractModel.getStrSeasonCode()+"'";
		List listSeasonCode = objGlobalFunctionsService.funGetListModuleWise(sqlSeasonCode, "sql");
		if(listSeasonCode!=null && listSeasonCode.size()>0)
		{
			objPMSRateContractModel.setStrSeasonCode(listSeasonCode.get(0).toString());
		}

		
		return objPMSRateContractModel;
	}

//Save or Update PMSRateContract
	@RequestMapping(value = "/savePMSRateContract", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPMSRateContractBean objBean ,BindingResult result,HttpServletRequest req){
		if(!result.hasErrors()){
			String clientCode=req.getSession().getAttribute("clientCode").toString();
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String userCode=req.getSession().getAttribute("usercode").toString();
			String sqlRoomTypeCode = "select a.strRoomTypeCode from tblroomtypemaster a where a.strRoomTypeDesc='"+objBean.getStrRoomTypeCode()+"'";
			List listROomtypeCode = objGlobalFunctionsService.funGetListModuleWise(sqlRoomTypeCode, "sql");
			if(listROomtypeCode!=null && listROomtypeCode.size()>0)
			{
				objBean.setStrRoomTypeCode(listROomtypeCode.get(0).toString());
			}
			String sqlSeasonCode = "select a.strSeasonCode from tblseasonmaster a where a.strSeasonDesc='"+objBean.getStrSeasonCode()+"'";
			List listSeasonCode = objGlobalFunctionsService.funGetListModuleWise(sqlSeasonCode, "sql");
			if(listSeasonCode!=null && listSeasonCode.size()>0)
			{
				objBean.setStrSeasonCode(listSeasonCode.get(0).toString());
			}

			clsPMSRateContractModel objModel = funPrepareModel(objBean,userCode,clientCode);
			objPMSRateContractService.funAddUpdatePMSRateContract(objModel);
			clsPropertySetupHdModel objModel1 = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);
			String pmsDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
			if(objModel1.getStrOnlineIntegration().equalsIgnoreCase("Yes"))
			{
				funCallAPI(objModel1,clientCode,pmsDate,objBean);
			}
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Rate management code : ".concat(objModel.getStrRateContractID()));

			
			return new ModelAndView("redirect:/frmPMSRateContract.html");
		}
		else{
			return new ModelAndView("frmPMSRateContract");
		}
	}

	private void funCallAPI(clsPropertySetupHdModel objModel1, String clientCode,String pmsDate,clsPMSRateContractBean objBean) 
	{
		try{
			JSONObject JMainObject = new JSONObject();		
			String isoDatePattern = "yyyy-MM-dd'T'HH:mm:ss'Z'";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(isoDatePattern);
			String sql = "select a.strClientCode ,'SANGUINEPMS' as OTA_Name ,a.strRoomTypeCode,a.strRateContractID,a.dblSingleTariWeekDays,a.dblDoubleTariWeekDays, "
					+ "a.dblTrippleTariWeekDays,a.dblExtraBedTariWeekDays,a.dblChildTariWeekDays,a.dblYouthTariWeekDays from tblpmsratecontractdtl a "
					+ "left outer join  tblroom b on a.strRoomTypeCode=b.strRoomTypeCode where b.strStatus='Free' and a.strClientCode='"+clientCode+"' "
					+ "AND a.strRateContractID='"+objBean.getStrRateContractID()+"' GROUP BY a.strRateContractID ";
			
			List listData = objWebPMSUtility.funExecuteQuery(sql, "sql"); 
			if(listData!=null && listData.size()>0)
			{
				JSONObject JroomObj = new JSONObject();
				JSONArray jsonArray = new JSONArray();
				for(int i=0;i<listData.size();i++)
				{
					Object [] obj = (Object[]) listData.get(i);
					JMainObject.put("HotelId", obj[0].toString());
					JMainObject.put("OTACode", obj[1].toString());										
					
					JroomObj = new JSONObject();
					JroomObj.put("RoomId", obj[2].toString());
					JroomObj.put("RateplanId", obj[3].toString());					
					
					Date date1=new SimpleDateFormat("yyyy-MM-dd").parse(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteFromDate()));  
					Date date2=new SimpleDateFormat("yyyy-MM-dd").parse(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteToDate()));
					JroomObj.put("FromDate", simpleDateFormat.format(date1));
					JroomObj.put("ToDate", simpleDateFormat.format(date2));
					
					JSONObject jObjj = new JSONObject();
					JSONArray jArray = new JSONArray();
					//single tarrif
					jObjj.put("NumberOfGuest", "1");
					jObjj.put("Amount", obj[4].toString());
					jArray.add(jObjj);
					
					//double tarrif
					jObjj = new JSONObject();					
					jObjj.put("NumberOfGuest", "2");
					jObjj.put("Amount", obj[5].toString());
					jArray.add(jObjj);
					
					//tripple tarrif
					jObjj = new JSONObject();
					jObjj.put("NumberOfGuest", "3");
					jObjj.put("Amount", obj[6].toString());
					jArray.add(jObjj);
					JroomObj.put("Rates", jArray);
					
					//Additonal Rates
					jArray = new JSONArray();
					jObjj = new JSONObject();
					jObjj.put("OccupantsAgeCode", "10");
					jObjj.put("Amount", obj[7].toString());
					jArray.add(jObjj);
					
					jObjj = new JSONObject();
					jObjj.put("OccupantsAgeCode", "8");
					jObjj.put("Amount", obj[8].toString());
					jArray.add(jObjj);
					JroomObj.put("AdditionalRates", jArray);					
				}
				jsonArray.add(JroomObj);
				JMainObject.put("Rooms", jsonArray);	
				funCallingToRestAPI(objModel1,JMainObject);
				System.out.println(JMainObject);
				
			}
			
		}
		catch(Exception e)
		{
			e.printStackTrace();			
		}
		
		
		
		
	}
	
	
	public void funCallingToRestAPI(clsPropertySetupHdModel objModel,JSONObject jobj)
    {
            try
            {
                URL obj = new URL("http://"+objModel.getStrIntegrationUrl()+"/MaxiMojoIntegration/MaxiMojoIntegration/funPushRates");
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setRequestMethod("POST");
                postConnection.setRequestProperty("Content-Type", "application/json");
                
                OutputStream os = postConnection.getOutputStream();
                    os.write(jobj.toJSONString().getBytes());
                    os.flush();

                    BufferedReader br = new BufferedReader(new InputStreamReader((postConnection.getInputStream())));

                    String output="",op="";
                    System.out.println("Output from Server .... \n");
                    while ((output = br.readLine()) != null) {
                            op+=output;
                    }
                    System.out.println("Output :: "+op);
                    postConnection.disconnect();
            }
            catch(Exception e)
            {
                    e.printStackTrace();
            }            
            
    }
	
//Convert bean to model function
	private clsPMSRateContractModel funPrepareModel(clsPMSRateContractBean objBean,String userCode,String clientCode){
		objGlobal=new clsGlobalFunctions();
		long lastNo=0;
		clsPMSRateContractModel objModel = new clsPMSRateContractModel();
		if (objBean.getStrRateContractID().trim().length() == 0) {
			
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblpmsratecontractdtl", "pmsRateContractdtl", "strRateContractID", clientCode);
			String rateCode = "RQ" + String.format("%06d", lastNo);
			objModel.setStrRateContractID(rateCode);
			objModel.setDblChildTariWeekDays(objBean.getDblChildTariWeekDays());
			objModel.setDblChildTariWeekend(objBean.getDblChildTariWeekend());
			objModel.setDblDoubleTariWeekDays(objBean.getDblDoubleTariWeekDays());
			objModel.setDblDoubleTariWeekend(objBean.getDblDoubleTariWeekend());
			objModel.setDblExtraBedTariWeekDays(objBean.getDblExtraBedTariWeekDays());
			objModel.setDblExtraBedTariWeekend(objBean.getDblExtraBedTariWeekend());
			objModel.setDblSingleTariWeekDays(objBean.getDblSingleTariWeekDays());
			objModel.setDblSingleTariWeekend(objBean.getDblSingleTariWeekDays());
			objModel.setDblTrippleTariWeekDays(objBean.getDblTrippleTariWeekDays());
			objModel.setDblTrippleTariWeekend(objBean.getDblTrippleTariWeekend());
			objModel.setDblYouthTariWeekDays(objBean.getDblYouthTariWeekDays());
			objModel.setDblYouthTariWeekend(objBean.getDblYouthTariWeekend());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteFromDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteFromDate()));
			objModel.setDteToDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteToDate()));
			objModel.setIntNoOfNights(objBean.getIntNoOfNights());
			objModel.setStrClientCode(clientCode);
			objModel.setStrFriday(objGlobal.funIfNull(objBean.getStrFriday(), "N", objBean.getStrFriday()));
			objModel.setStrIncludeTax(objGlobal.funIfNull(objBean.getStrIncludeTax(), "N", objBean.getStrIncludeTax()));
			objModel.setStrMonday(objGlobal.funIfNull(objBean.getStrMonday(), "N", objBean.getStrMonday()));
			objModel.setStrRoomTypeCode(objBean.getStrRoomTypeCode());
			objModel.setStrSaturday(objGlobal.funIfNull(objBean.getStrSaturday(), "N", objBean.getStrSaturday()));
			objModel.setStrSeasonCode(objBean.getStrSeasonCode());
			objModel.setStrSunday(objGlobal.funIfNull(objBean.getStrSunday(), "N", objBean.getStrSunday()));
			objModel.setStrThursday(objGlobal.funIfNull(objBean.getStrThursday(), "N", objBean.getStrThursday()));
			objModel.setStrTuesday(objGlobal.funIfNull(objBean.getStrTuesday(), "N", objBean.getStrTuesday()));
			objModel.setStrUserCreated(userCode);
			objModel.setStrUserEdited(userCode);
			objModel.setStrWednesday(objGlobal.funIfNull(objBean.getStrWednesday(), "N", objBean.getStrWednesday()));
			objModel.setStrRateContractName(objBean.getStrRateContractName());
			
		}
		else
		{
			objModel.setStrRateContractID(objBean.getStrRateContractID());
			objModel.setDblChildTariWeekDays(objBean.getDblChildTariWeekDays());
			objModel.setDblChildTariWeekend(objBean.getDblChildTariWeekend());
			objModel.setDblDoubleTariWeekDays(objBean.getDblDoubleTariWeekDays());
			objModel.setDblDoubleTariWeekend(objBean.getDblDoubleTariWeekend());
			objModel.setDblExtraBedTariWeekDays(objBean.getDblExtraBedTariWeekDays());
			objModel.setDblExtraBedTariWeekend(objBean.getDblExtraBedTariWeekend());
			objModel.setDblSingleTariWeekDays(objBean.getDblSingleTariWeekDays());
			objModel.setDblSingleTariWeekend(objBean.getDblSingleTariWeekDays());
			objModel.setDblTrippleTariWeekDays(objBean.getDblTrippleTariWeekDays());
			objModel.setDblTrippleTariWeekend(objBean.getDblTrippleTariWeekend());
			objModel.setDblYouthTariWeekDays(objBean.getDblYouthTariWeekDays());
			objModel.setDblYouthTariWeekend(objBean.getDblYouthTariWeekend());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteFromDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteFromDate()));
			objModel.setDteToDate(objGlobal.funGetDate("yyyy-MM-dd", objBean.getDteToDate()));
			objModel.setIntNoOfNights(objBean.getIntNoOfNights());
			objModel.setStrClientCode(clientCode);
			objModel.setStrFriday(objGlobal.funIfNull(objBean.getStrFriday(), "N", objBean.getStrFriday()));
			objModel.setStrIncludeTax(objGlobal.funIfNull(objBean.getStrIncludeTax(), "N", objBean.getStrIncludeTax()));
			objModel.setStrMonday(objGlobal.funIfNull(objBean.getStrMonday(), "N", objBean.getStrMonday()));
			objModel.setStrRoomTypeCode(objBean.getStrRoomTypeCode());
			objModel.setStrSaturday(objGlobal.funIfNull(objBean.getStrSaturday(), "N", objBean.getStrSaturday()));
			objModel.setStrSeasonCode(objBean.getStrSeasonCode());
			objModel.setStrSunday(objGlobal.funIfNull(objBean.getStrSunday(), "N", objBean.getStrSunday()));
			objModel.setStrThursday(objGlobal.funIfNull(objBean.getStrThursday(), "N", objBean.getStrThursday()));
			objModel.setStrTuesday(objGlobal.funIfNull(objBean.getStrTuesday(), "N", objBean.getStrTuesday()));
			objModel.setStrUserCreated(objBean.getStrUserCreated());
			objModel.setStrUserEdited(userCode);
			objModel.setStrWednesday(objGlobal.funIfNull(objBean.getStrWednesday(), "N", objBean.getStrWednesday()));
			objModel.setStrRateContractName(objBean.getStrRateContractName());
		}
		
		return objModel;

	}

}
