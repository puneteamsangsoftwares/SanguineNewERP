package com.sanguine.webpms.controller;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.swing.JOptionPane;
import javax.validation.Valid;

import org.apache.commons.collections4.map.HashedMap;
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
import com.sanguine.webpms.bean.clsPostRoomTerrifBean;
import com.sanguine.webpms.bean.clsTaxCalculation;
import com.sanguine.webpms.bean.clsTaxProductDtl;
import com.sanguine.webpms.dao.clsExtraBedMasterDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsCheckInHdModel;
import com.sanguine.webpms.model.clsExtraBedMasterModel;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsFolioTaxDtl;
import com.sanguine.webpms.model.clsPMSGroupBookingDtlModel;
import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;
import com.sanguine.webpms.model.clsReservationHdModel;
import com.sanguine.webpms.service.clsCheckInService;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsPMSGroupBookingService;
import com.sanguine.webpms.service.clsReservationService;

@Controller
public class clsPostRoomTerrifController {

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	clsPMSUtilityFunctions objPMSUtility;

	@Autowired
	clsFolioService objFolioService;

	@Autowired
	clsGlobalFunctions objGlobal;

	@Autowired
	private clsExtraBedMasterDao objExtraBedMasterDao;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	private clsCheckInService objCheckInService;
	
	@Autowired
	private clsPMSGroupBookingService objGroupBookingService;
	
	@Autowired
	private clsReservationService objReservationService;

	// Open Post Room Terrif
	@RequestMapping(value = "/frmPostRoomTerrif", method = RequestMethod.GET)
	public ModelAndView funOpenForm() {
		clsPostRoomTerrifBean objBean = new clsPostRoomTerrifBean();
		return new ModelAndView("frmPostRoomTerrif", "command", objBean);
	}

	// Load Header Table Data On Form
	@RequestMapping(value = "/loadRoomDetails", method = RequestMethod.GET)
	public @ResponseBody List funLoadRoomDetails(HttpServletRequest request) {

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String roomNo = request.getParameter("roomNo").toString();
		String PMSDate = request.getSession().getAttribute("PMSDate").toString();

		String []date=PMSDate.split("-");
		String datePMS=date[2]+"-"+date[1]+"-"+date[0];
		
		
		String sql=" SELECT d.strRoomCode,d.strRoomDesc,a.strRegistrationNo,c.strFirstName,c.strMiddleName,c.strLastName,"
				+ " e.dblRoomTerrif, IFNULL(a.strReservationNo,''), IFNULL(a.strWalkInNo,''),e.strRoomTypeCode,ifnull(sum(f.dblIncomeHeadAmt),0),a.strCheckInNo"
				+ " FROM tblcheckinhd a left outer join tblroompackagedtl f on a.strCheckInNo=f.strCheckInNo and f.strRoomNo='' AND a.strClientCode='"+clientCode+"' AND f.strClientCode='"+clientCode+"',tblcheckindtl b,tblguestmaster c,tblroom d,tblroomtypemaster e"
				+ " WHERE a.strCheckInNo=b.strCheckInNo AND b.strGuestCode=c.strGuestCode "
				+ " AND b.strRoomNo=d.strRoomCode AND d.strRoomTypeCode=e.strRoomTypeCode AND b.strRoomNo='"+roomNo+"' "
				+ " AND a.strCheckInNo NOT IN (SELECT strCheckInNo FROM tblbillhd WHERE strRoomNo='"+roomNo+"' AND strClientCode='"+clientCode+"' order by strCheckInNo desc) ";
		
		List listRoomDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(listRoomDtl.size()>0)
		{
			Object []arrObjRoom=(Object[])listRoomDtl.get(0);
			double dblTotalAmt=0.0;
			double dblRoomRate=0.0;
			double dblPkgAmt=0.0;
			dblRoomRate = Double.parseDouble(arrObjRoom[6].toString());
			String sqlRoomCount=" select count(b.strRoomNo) from tblcheckinhd a,tblcheckindtl b"
					+ " where a.strCheckInNo=b.strCheckInNo and a.strCheckInNo='"+arrObjRoom[11].toString()+"'  AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' ";
			List listRoomCnt= objGlobalFunctionsService.funGetListModuleWise(sqlRoomCount, "sql");
			BigInteger roomCnt=new BigInteger(listRoomCnt.get(0).toString());
			
			String sqlCheckTerrifBalanceAmt=" SELECT b.strFolioNo,b.dblDebitAmt,b.dblBalanceAmt,b.strRevenueType "
					+ " FROM tblfoliohd a,tblfoliodtl b "
					+ " WHERE a.strFolioNo=b.strFolioNo  and a.strRoomNo=b.strRevenueCode AND a.strCheckInNo='"+arrObjRoom[11].toString()+"' "
					+ " and  (b.strRevenueType='Package' or b.strRevenueType='Room')  and a.strRoomNo='"+roomNo+"' AND a.strClientCode='"+clientCode+"' AND b.strClientCode='"+clientCode+"' "
					+ " group by b.strRevenueType  ORDER BY b.dteDocDate DESC ";
			 List listTerriff = objGlobalFunctionsService.funGetListModuleWise(sqlCheckTerrifBalanceAmt, "sql");
			 if(listTerriff.size()>0)
			 {
				 for (int cnt = 0; cnt < listTerriff.size(); cnt++) 
				 {
						Object[] arrObjTerriff = (Object[]) listTerriff.get(cnt);
						if(arrObjTerriff[3].toString().equals("Package"))
						{
							dblPkgAmt=Double.valueOf(arrObjTerriff[2].toString());
						}
						else
						{
							dblRoomRate=Double.valueOf(arrObjTerriff[1].toString());
						}	
				 }	
				 dblTotalAmt=dblRoomRate+dblPkgAmt;
			 }
			 else
			 {
				 if(!arrObjRoom[7].toString().equals(""))
					{
					 String sqlRoomRate=" select a.dblRoomRate from  tblreservationroomratedtl a "
						        +" where a.strReservationNo='"+arrObjRoom[7].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[9].toString()+"' and a.dtDate='"+datePMS+"' ";
					 List listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
					 if(listRoomRate.size()>0)
					 {
					    dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
					 }
					}
					if(!arrObjRoom[8].toString().equals(""))
					{
					String sqlRoomRate=" select a.dblRoomRate from  tblwalkinroomratedtl a "
						        +" where a.strWalkinNo='"+arrObjRoom[8].toString()+"' and a.strClientCode='"+clientCode+"' and a.strRoomType='"+arrObjRoom[9].toString()+"' and a.dtDate='"+datePMS+"' ";
					 List listRoomRate = objGlobalFunctionsService.funGetListModuleWise(sqlRoomRate, "sql");
					 if(listRoomRate.size()>0)
					 {
					 dblRoomRate=Double.parseDouble(listRoomRate.get(0).toString());
					 }
					}
					dblPkgAmt=(Double.valueOf(arrObjRoom[10].toString())/roomCnt.intValue());
					dblTotalAmt=dblRoomRate+dblPkgAmt;
			 }
			 listRoomDtl.add(dblTotalAmt);
			 listRoomDtl.add(dblRoomRate);
			 listRoomDtl.add(dblPkgAmt);
		}
		return listRoomDtl;
	}

	// Save or Update Reservation
	@RequestMapping(value = "/postRoomTerrif", method = RequestMethod.POST)
	public ModelAndView funPostRoomTerrif(@ModelAttribute("command") @Valid clsPostRoomTerrifBean objBean, BindingResult result, HttpServletRequest req) {
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			String propCode = req.getSession().getAttribute("propertyCode").toString();
			String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", req.getSession().getAttribute("PMSDate").toString());
			String strTransactionType = "Post Room Terrif";

			String sql = "SELECT a.strFolioNo,a.strExtraBedCode,b.strComplimentry" + " FROM tblfoliohd a,tblcheckinhd b " + " WHERE a.strRoomNo='" + objBean.getStrRoomNo() + "' and a.strCheckInNo=b.strCheckInNo  AND a.strClientCode='" + clientCode + "' AND b.strClientCode='"+clientCode+"'";
			List listFolio = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			Object[] arrObjFolioDtl = (Object[]) listFolio.get(0);

			String folioNo = arrObjFolioDtl[0].toString();
			String extraBedCode = arrObjFolioDtl[1].toString();
			String strComplimentry = arrObjFolioDtl[2].toString();
			String docNo="";
			
			String sqlPostRommTariffCheck = "select a.strPerticulars from tblfoliodtl a where a.strFolioNo='"+folioNo+"' and a.dteDocDate='"+PMSDate+"' AND a.strClientCode='"+clientCode+"'";
			List listPostRommTariffCheck  = objGlobalFunctionsService.funGetListModuleWise(sqlPostRommTariffCheck, "sql");
			if(!listPostRommTariffCheck.isEmpty())
			{
				
				
					
					if(listPostRommTariffCheck.toString().contains("Room Tariff"))
					 {
						 req.getSession().setAttribute("WarningMsg", "Already Post room terrif is Done"); 
					 }
					 else
						{
							if(strComplimentry.equalsIgnoreCase("N"))
							{
							
								double totalRoomTarrif=objBean.getDblRoomTerrif();
								double totalPakageAmt=objBean.getDblPackageAmt();
								double actualPostingAmt=objBean.getDblActualPostingAmt();
								String roomNo=objBean.getStrRoomNo();
								if(actualPostingAmt>0)
								{
									if(totalPakageAmt>0 && totalPakageAmt<totalRoomTarrif)
									{
										if(actualPostingAmt>objBean.getDblPackageAmt())
										{
											objBean.setStrFolioType("Package");
											objBean.setDblRoomTerrif(totalPakageAmt);
											objBean.setDblOriginalPostingAmt(totalPakageAmt);
											docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
											
											if((actualPostingAmt-totalPakageAmt)>0)
											{
												objBean = new clsPostRoomTerrifBean();
												objBean.setStrFolioType("Room");
												objBean.setStrFolioNo(folioNo);
												objBean.setStrRoomNo(roomNo);
												objBean.setDblRoomTerrif(actualPostingAmt-totalPakageAmt);
												objBean.setDblOriginalPostingAmt(totalRoomTarrif);
												docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);		
											}
											
										}
										else
										{
											objBean.setStrFolioType("Package");
											objBean.setDblRoomTerrif(totalPakageAmt-actualPostingAmt);
											objBean.setDblOriginalPostingAmt(totalPakageAmt);
											docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);	
										}
										
									}
									else
									{
										objBean.setStrFolioType("Room");
										objBean.setDblRoomTerrif(actualPostingAmt);
										docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
									}
								}
							}
							else
							{
								double actualPostingAmt=0.0;
								objBean.setStrFolioType("Room");
								objBean.setDblRoomTerrif(actualPostingAmt);
								extraBedCode="";
								docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
							}
							//String docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode);
					
							req.getSession().setAttribute("success", true);
							req.getSession().setAttribute("successMessage", "Terrif Posted Successfully. " + docNo);
						
					
				}
				 
				//JOptionPane.showMessageDialog(null, "Already Post room terrif is Done");
				//JOptionPane.showMessageDialog(null,"ALERT MESSAGE","TITLE",JOptionPane.WARNING_MESSAGE);
			}
			else
			{
				if(strComplimentry.equalsIgnoreCase("N"))
				{
				
					double totalRoomTarrif=objBean.getDblRoomTerrif();
					double totalPakageAmt=objBean.getDblPackageAmt();
					double actualPostingAmt=objBean.getDblActualPostingAmt();
					String roomNo=objBean.getStrRoomNo();
					if(actualPostingAmt>0)
					{
						if(totalPakageAmt>0 && totalPakageAmt<totalRoomTarrif)
						{
							if(actualPostingAmt>objBean.getDblPackageAmt())
							{
								objBean.setStrFolioType("Package");
								objBean.setDblRoomTerrif(totalPakageAmt);
								objBean.setDblOriginalPostingAmt(totalPakageAmt);
								docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
								
								if((actualPostingAmt-totalPakageAmt)>0)
								{
									objBean = new clsPostRoomTerrifBean();
									objBean.setStrFolioType("Room");
									objBean.setStrFolioNo(folioNo);
									objBean.setStrRoomNo(roomNo);
									objBean.setDblRoomTerrif(actualPostingAmt-totalPakageAmt);
									objBean.setDblOriginalPostingAmt(totalRoomTarrif);
									docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);		
								}
								
							}
							else
							{
								objBean.setStrFolioType("Package");
								objBean.setDblRoomTerrif(totalPakageAmt-actualPostingAmt);
								objBean.setDblOriginalPostingAmt(totalPakageAmt);
								docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);	
							}
							
						}
						else
						{
							objBean.setStrFolioType("Room");
							objBean.setDblRoomTerrif(actualPostingAmt);
							docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
						}
					}
				}
				else
				{
					double actualPostingAmt=0.0;
					objBean.setStrFolioType("Room");
					objBean.setDblRoomTerrif(actualPostingAmt);
					extraBedCode="";
					docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode,strTransactionType,userCode);
				}
				//String docNo = funInsertFolioRecords(folioNo, clientCode, propCode, objBean, PMSDate, extraBedCode);
		
				req.getSession().setAttribute("success", true);
				req.getSession().setAttribute("successMessage", "Terrif Posted Successfully. " + docNo);
			}
			return new ModelAndView("redirect:/frmPostRoomTerrif.html");
		} else {
			return new ModelAndView("frmPostRoomTerrif");
		}
	}

	public String funInsertFolioRecords(String folioNo, String clientCode, String propCode, clsPostRoomTerrifBean objBean, String PMSDate, String extraBedCode,String strTransType,String strUserCode) {
		clsFolioHdModel objFolioHd = objFolioService.funGetFolioList(folioNo, clientCode, propCode);
		System.out.println(objFolioHd.getListFolioDtlModel().size());
		// long nextDocNo=objGlobalFunctionsService.funGetNextNo("tblfoliodtl",
		// "FolioPosting", "strDocNo", clientCode, "and left(strDocNo,2)='RM'");
		// docNo="RM"+String.format("%06d", nextDocNo);
		long doc = 0;
		doc = objPMSUtility.funGenerateFolioDocForRoom("RoomFolio");
		String docNo = "RM" + String.format("%06d", doc);
		double roomTerrif = objBean.getDblRoomTerrif();
		clsTaxProductDtl objTaxProductDtl = new clsTaxProductDtl();
		objTaxProductDtl.setStrTaxProdCode(objBean.getStrRoomNo());
		objTaxProductDtl.setStrTaxProdName("");
		objTaxProductDtl.setDblTaxProdAmt(roomTerrif);
		objTaxProductDtl.setDblTotalExtraBedAmt(0);
		// set department value here -- get department value from income head table 
		String sql = "select a.strDeptCode from tblincomehead a where a.strIncomeHeadCode = '"+objTaxProductDtl.getStrTaxProdCode()+"' AND a.strClientCode='"+clientCode+"'";
		List<clsTaxProductDtl> listTaxProdDtl = new ArrayList<clsTaxProductDtl>();
		String strComp="";
		// 
		
		String sqlDiscWalkIn = "select a.dblDiscount from tblwalkinroomratedtl a ,"
				+ "tblfoliohd b where a.strWalkinNo=b.strWalkInNo and b.strFolioNo='"+folioNo+"' AND a.strClientCode='"+clientCode+"'";
		
		List listDiscWalkIn = objGlobalFunctionsService.funGetListModuleWise(sqlDiscWalkIn, "sql");
		if(listDiscWalkIn!=null &&listDiscWalkIn.size()>0){
			objTaxProductDtl.setDblDiscountOnTariff(Double.parseDouble(listDiscWalkIn.get(0).toString()));	
		}
		
		
		String sqlComplimentryCheck = "SELECT a.strComplimentry "
				+ "FROM tblcheckinhd a "
				+ "WHERE a.strClientCode='"+clientCode+"' AND a.strCheckInNo in (select b.strCheckInNo from tblfoliohd b where b.strFolioNo='"+folioNo+"' AND b.strClientCode='"+clientCode+"')";
		List listComplimentryCheck = objGlobalFunctionsService.funGetListModuleWise(sqlComplimentryCheck, "sql");
		{
			strComp = listComplimentryCheck.get(0).toString();
			if(strComp.equalsIgnoreCase("Y"))
			{
				double dblExtraBedAmt = 0.0;
				//dblExtraBedAmt = dblExtraBedAmt + objTaxProductDtl.getDblTaxProdAmt();
				objTaxProductDtl.setDblTotalExtraBedAmt(dblExtraBedAmt);
			}
			else
			{
				String sqlExtraBedAmt = "select a.dblChargePerBed from tblextrabed a where a.strExtraBedTypeCode = '"+extraBedCode+"' AND a.strClientCode='"+clientCode+"'";
				List listExtraBedAmt = objGlobalFunctionsService.funGetListModuleWise(sqlExtraBedAmt, "sql");
				if(listExtraBedAmt!=null && listExtraBedAmt.size()>0)
				{
					double dblExtraBedAmt = Double.parseDouble(listExtraBedAmt.get(0).toString());
					//dblExtraBedAmt = dblExtraBedAmt + objTaxProductDtl.getDblTaxProdAmt();
					objTaxProductDtl.setDblTotalExtraBedAmt(dblExtraBedAmt);
				}
			}
		}
		clsCheckInHdModel objHdModel = objCheckInService.funGetCheckInData(objFolioHd.getStrCheckInNo().toString(), clientCode);

		clsReservationHdModel objModel = objReservationService.funGetReservationList(objHdModel.getStrReservationNo(), clientCode, propCode);
		if(objModel==null)
		{
			objModel=new clsReservationHdModel();
			objModel.setStrGroupCode("");
			objModel.setStrDontApplyTax("");
		}
		
		Map<String, List<clsTaxCalculation>> hmTaxCalDtl = new HashedMap<String, List<clsTaxCalculation>>();
		listTaxProdDtl.add(objTaxProductDtl);
		if(objFolioHd.getStrRoom().equalsIgnoreCase("Y"))
		{
			if(objModel!=null && objModel.getStrDontApplyTax().equals("N"))
			{
				//hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");
			}
			
			if(objHdModel.getStrDontApplyTax().equals("N") )
			{
				hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");
			}
			
		}
		
		

		List<clsFolioDtlModel> listFolioDtl = new ArrayList<clsFolioDtlModel>();
		List<clsFolioTaxDtl> listFolioTaxDtl = new ArrayList<clsFolioTaxDtl>();		
		List<String> listDocNo = new ArrayList<String>();
		boolean flgDupRoomTerrif=false;
		boolean flgDupExtraBed=false;

		
	    if(null!=objFolioHd.getListFolioDtlModel() && objFolioHd.getListFolioDtlModel().size()>0)
	    {
	    	for(clsFolioDtlModel obFolioDtlModel:objFolioHd.getListFolioDtlModel())
	    	{
	    		if(obFolioDtlModel.getStrRevenueType().equals(objBean.getStrFolioType()) && obFolioDtlModel.getDteDocDate().split(" ")[0].equals(PMSDate))
	    		{
	    			flgDupExtraBed=true;
	    			flgDupRoomTerrif=true;
	    			obFolioDtlModel.setDblDebitAmt(obFolioDtlModel.getDblDebitAmt());
	    			obFolioDtlModel.setDblBalanceAmt(objBean.getDblOriginalPostingAmt()-roomTerrif);
	    			break;
	    		}
	    		else
	    		{
	    			listFolioDtl=objFolioHd.getListFolioDtlModel();
	    			listFolioTaxDtl=objFolioHd.getListFolioTaxDtlModel();
	    		}
	    		
	    	}
	    }
	    clsFolioDtlModel objFolioDtl = null; 	    	
	    if(!flgDupRoomTerrif)
	    {
	    	if( objModel==null  || objModel.getStrGroupCode().equals(""))
	    	{
	    		objFolioDtl = new clsFolioDtlModel();
				objFolioDtl.setStrDocNo(docNo);
				objFolioDtl.setDteDocDate(PMSDate);
				objFolioDtl.setDblDebitAmt(roomTerrif);
				objFolioDtl.setDblBalanceAmt(objBean.getDblOriginalPostingAmt()-roomTerrif);
				objFolioDtl.setDblCreditAmt(0);
				objFolioDtl.setStrTransactionType(strTransType);
				objFolioDtl.setStrUserEdited(strUserCode);
				objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				if(objBean.getStrFolioType().equals("Room"))
				{
					objFolioDtl.setStrPerticulars("Room Tariff");
				}
				else
				{
					objFolioDtl.setStrPerticulars("Package");
				}
				objFolioDtl.setStrRevenueType(objBean.getStrFolioType());
				objFolioDtl.setStrTransactionType(strTransType);
				objFolioDtl.setStrRevenueCode(objBean.getStrRoomNo());
				objFolioDtl.setStrUserEdited(strUserCode);
				objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objFolioDtl.setStrRemark("");
				objFolioDtl.setDblDiscAmt(0.00);
				objFolioDtl.setDblDiscPer(0.00);
				objFolioDtl.setStrOldFolioNo(" ");
				listFolioDtl.add(objFolioDtl);
	    	}
	    	else
	    	{
	    		
	    		clsPMSGroupBookingHDModel objGroupBookingModel = objGroupBookingService.funGetPMSGroupBooking(objModel.getStrGroupCode(), clientCode);
	    		
	    		
	    		List<clsPMSGroupBookingDtlModel> listGroupDtl = objGroupBookingModel.getListPMSGroupBookingDtlModel();
	    		String strPayee = "";
	    		for(int i=0;i<listGroupDtl.size();i++)
	    		{
	    			clsPMSGroupBookingDtlModel objDtlModel =  listGroupDtl.get(i);
	    			
	    			if(objDtlModel.getStrRoom().equals("Y"))
	    			{
	    				strPayee = objDtlModel.getStrPayee();
	    			}
	    		}
	    		if(strPayee.equals("Guest"))
	    		{

		    		objFolioDtl = new clsFolioDtlModel();
					objFolioDtl.setStrDocNo(docNo);
					objFolioDtl.setDteDocDate(PMSDate);
					objFolioDtl.setDblDebitAmt(roomTerrif);
					objFolioDtl.setDblBalanceAmt(objBean.getDblOriginalPostingAmt()-roomTerrif);
					objFolioDtl.setDblCreditAmt(0);
					objFolioDtl.setStrTransactionType(strTransType);
					objFolioDtl.setStrUserEdited(strUserCode);
					objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					if(objBean.getStrFolioType().equals("Room"))
					{
						objFolioDtl.setStrPerticulars("Room Tariff");
					}
					else
					{
						objFolioDtl.setStrPerticulars("Package");
					}
					objFolioDtl.setStrRevenueType(objBean.getStrFolioType());
					objFolioDtl.setStrTransactionType(strTransType);
					objFolioDtl.setStrRevenueCode(objBean.getStrRoomNo());
					objFolioDtl.setStrUserEdited(strUserCode);
					objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					objFolioDtl.setStrRemark("");
					objFolioDtl.setDblDiscAmt(0.00);
					objFolioDtl.setDblDiscPer(0.00);
					objFolioDtl.setStrOldFolioNo(" ");
					listFolioDtl.add(objFolioDtl);
		    	
	    		}
	    		else
	    		{
	    			/*String strFolioCheckInDtl = "select * from tblfoliodtl a where a.strFolioNo='"+objFolioHd.getStrFolioNo()+"' and a.strClientCode='"+clientCode+"'";
		    		List listFolioEntryInDtl = objGlobalFunctionsService.funGetListModuleWise(strFolioCheckInDtl, "sql");

		    		if(listFolioEntryInDtl!=null && listFolioEntryInDtl.size()>0)
		    		{
		    			
		    		}
		    		else
		    		{*/
		    			String strCheckInNo = objHdModel.getStrCheckInNo();
			    		
			    		String strFolioCnt = "select COUNT(*) from tblfoliohd a where a.strCheckInNo='"+strCheckInNo+"'";
			    		
			    		List listFolioCnt = objGlobalFunctionsService.funGetListModuleWise(strFolioCnt, "sql");
			    		
			    		double dblCnt = 1;
			    		
			    		if(listFolioCnt!=null && listFolioCnt.size()>0)
			    		{
			    			dblCnt = Double.parseDouble(listFolioCnt.get(0).toString());
			    		}
			    		if(objFolioHd.getStrRoom().equalsIgnoreCase("Y"))
			    		{
			    		if(objGroupBookingModel.getStrGroupLeaderCode().equals(objFolioHd.getStrGuestCode()))
			    		{
			    			
			    			
			    			String strRoomRate = "SELECT (roomterrif),ifnull((ChangeRoomRate),0) from"
			    					+ " (SELECT c.dblRoomTerrif as roomterrif,d.dblRoomRate As ChangeRoomRate "
			    					+ " FROM tblfoliohd a "
			    					+ " LEFT OUTER "
			    					+ " JOIN tblroom b ON a.strRoomNo=b.strRoomCode "
			    					+ " LEFT OUTER "
			    					+ " JOIN tblroomtypemaster c ON b.strRoomTypeCode=c.strRoomTypeCode "
			    					+ " LEFT OUTER JOIN tblreservationroomratedtl d ON "
			    					+ "  d.strReservationNo=a.strReservationNo AND d.dtDate='"+PMSDate+"' "
			    					+ " WHERE a.strCheckInNo='"+strCheckInNo+"' AND a.strClientCode='"+clientCode+"' GROUP BY a.strRoomNo) a "
			    					+ " limit 1; ";
			    					
				    		List listRoomTariff = objGlobalFunctionsService.funGetListModuleWise(strRoomRate, "sql");
				    		if(listRoomTariff!=null && listRoomTariff.size()>0)
				    		{
				    			Object[] obj =(Object[])listRoomTariff.get(0);
				    			if(obj[1]!=null && Double.parseDouble(obj[1].toString())>0)
				    			{
				    				roomTerrif = Double.parseDouble(obj[1].toString());
				    			}
				    			else
				    			{
				    				roomTerrif = Double.parseDouble(obj[0].toString());
				    			}
				    			
				    		}
				    		String strRoomNo="select a.strFolioNo,a.strRoomNo from tblfoliohd a where a.strCheckInNo='"+strCheckInNo+"'"
				    				+ " group by a.strRoomNo; ";
				    		List listRoomNo = objGlobalFunctionsService.funGetListModuleWise(strRoomNo, "sql");
				    		if(listRoomNo!=null && listRoomNo.size()>0)
				    		{
				    			for(int i=0;i<listRoomNo.size();i++)
				    			{
				    				String docNoGroupDocNo=docNo;
				    				if(i !=0)
				    				{

				    					 doc = objPMSUtility.funGenerateFolioDocForRoom("RoomFolio");
				    					 docNoGroupDocNo = "RM" + String.format("%06d", doc);
				    				}
				    			
								    	
				    				
				    				Object[] objRoom=(Object[]) listRoomNo.get(i);
				    				

					    			objFolioDtl = new clsFolioDtlModel();
									objFolioDtl.setStrDocNo(docNoGroupDocNo);
									objFolioDtl.setDteDocDate(PMSDate);
									if(strComp.equalsIgnoreCase("Y"))
									{
										objFolioDtl.setDblDebitAmt(0);
									}
									else
									{
										objFolioDtl.setDblDebitAmt(roomTerrif);
									}
								
									objFolioDtl.setDblBalanceAmt(0.0);
									objFolioDtl.setDblCreditAmt(0);
									objFolioDtl.setStrTransactionType(strTransType);
									objFolioDtl.setStrUserEdited(strUserCode);
									objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
									if(objBean.getStrFolioType().equals("Room"))
									{
										objFolioDtl.setStrPerticulars("Room Tariff");
									}
									else
									{
										objFolioDtl.setStrPerticulars("Package");
									}
									objFolioDtl.setStrRevenueType(objBean.getStrFolioType());
									objFolioDtl.setStrTransactionType(strTransType);
									objFolioDtl.setStrRevenueCode(objRoom[1].toString());
									objFolioDtl.setStrUserEdited(strUserCode);
									objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
									objFolioDtl.setStrRemark("");
									objFolioDtl.setDblDiscAmt(0.00);
									objFolioDtl.setDblDiscPer(0.00);
									objFolioDtl.setStrOldFolioNo(" ");
									listFolioDtl.add(objFolioDtl);
									
					    		

						    		 //if group follio  tax calculation
					    	  
					    	    	if(listTaxProdDtl.size()>0) {
				    	    		if(strComp.equalsIgnoreCase("Y"))
									{
				    	    			listTaxProdDtl.get(0).setDblTaxProdAmt(0);
									}
				    	    		else
				    	    		{
				    	    			listTaxProdDtl.get(0).setDblTaxProdAmt(roomTerrif);
				    	    		}
					    	    		
					    	    	}	
					    			hmTaxCalDtl = objPMSUtility.funCalculatePMSTax(listTaxProdDtl, "Room Night");
						    		
						    	    if(!hmTaxCalDtl.isEmpty())
									{
										List<clsTaxCalculation> listTaxCal = hmTaxCalDtl.get(objBean.getStrRoomNo());
										for (clsTaxCalculation objTaxCal : listTaxCal) {
											clsFolioTaxDtl objFolioTaxDtl = new clsFolioTaxDtl();
											objFolioTaxDtl.setStrDocNo(docNoGroupDocNo);
											objFolioTaxDtl.setStrTaxCode(objTaxCal.getStrTaxCode());
											objFolioTaxDtl.setStrTaxDesc(objTaxCal.getStrTaxDesc());
											objFolioTaxDtl.setDblTaxableAmt(objTaxCal.getDblTaxableAmt());
											objFolioTaxDtl.setDblTaxAmt(objTaxCal.getDblTaxAmt());
											listFolioTaxDtl.add(objFolioTaxDtl);
										}
									}
									
						    	   
				    			}
				    		}
				    		
				    		

			    		}
			    		}
			    		else
			    		{
			    			roomTerrif = 0.0;
			    			objFolioDtl = new clsFolioDtlModel();
							objFolioDtl.setStrDocNo(docNo);
							objFolioDtl.setDteDocDate(PMSDate);
							objFolioDtl.setDblDebitAmt(roomTerrif);
							objFolioDtl.setDblBalanceAmt(0.0);
							objFolioDtl.setDblCreditAmt(0);
							objFolioDtl.setStrTransactionType(strTransType);
							objFolioDtl.setStrUserEdited(strUserCode);
							objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
							if(objBean.getStrFolioType().equals("Room"))
							{
								objFolioDtl.setStrPerticulars("Room Tariff");
							}
							else
							{
								objFolioDtl.setStrPerticulars("Package");
							}
							objFolioDtl.setStrRevenueType(objBean.getStrFolioType());
							objFolioDtl.setStrTransactionType(strTransType);
							objFolioDtl.setStrRevenueCode(objBean.getStrRoomNo());
							objFolioDtl.setStrUserEdited(strUserCode);
							objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
							objFolioDtl.setStrRemark("");
							objFolioDtl.setDblDiscAmt(0.00);
							objFolioDtl.setDblDiscPer(0.00);
							objFolioDtl.setStrOldFolioNo(" ");
							listFolioDtl.add(objFolioDtl);
							
			    		}

			    		
						
		    		
	    			
	    		}
	    		
	    	}
		    
	    }
	   
	    
	    if(objHdModel.getStrDontApplyTax().equals("N") && objModel.getStrGroupCode().equals(""))
		{
	    	if(!hmTaxCalDtl.isEmpty())
			{
				List<clsTaxCalculation> listTaxCal = hmTaxCalDtl.get(objBean.getStrRoomNo());
				for (clsTaxCalculation objTaxCal : listTaxCal) {
					clsFolioTaxDtl objFolioTaxDtl = new clsFolioTaxDtl();
					objFolioTaxDtl.setStrDocNo(docNo);
					objFolioTaxDtl.setStrTaxCode(objTaxCal.getStrTaxCode());
					objFolioTaxDtl.setStrTaxDesc(objTaxCal.getStrTaxDesc());
					objFolioTaxDtl.setDblTaxableAmt(objTaxCal.getDblTaxableAmt());
					objFolioTaxDtl.setDblTaxAmt(objTaxCal.getDblTaxAmt());
					listFolioTaxDtl.add(objFolioTaxDtl);
				}
			}
		}
		
		if(!flgDupExtraBed)
		{	
		if (!extraBedCode.isEmpty()) {
			List listExtraBed = objExtraBedMasterDao.funGetExtraBedMaster(extraBedCode, clientCode);
			if(listExtraBed!=null && listExtraBed.size()>0)
			{
			clsExtraBedMasterModel objExtraBedMaster = (clsExtraBedMasterModel) listExtraBed.get(0);

			doc = objPMSUtility.funGenerateFolioDocForRoom("RoomFolio");
			docNo = "RM" + String.format("%06d", doc);

			objFolioDtl = new clsFolioDtlModel();
			objFolioDtl.setStrDocNo(docNo);
			objFolioDtl.setDteDocDate(PMSDate);
			if(strComp.equalsIgnoreCase("Y"))
			{
				objFolioDtl.setDblDebitAmt(0.0);
			}
			else
			{
				objFolioDtl.setDblDebitAmt(objExtraBedMaster.getDblChargePerBed());
			}
			objFolioDtl.setDblBalanceAmt(0);
			objFolioDtl.setDblCreditAmt(0);
			objFolioDtl.setStrPerticulars("Extra Bed Charges");
			objFolioDtl.setStrRevenueType("ExtraBed");
			objFolioDtl.setStrRevenueCode(objExtraBedMaster.getStrExtraBedTypeCode());
			objFolioDtl.setStrTransactionType(strTransType);
			objFolioDtl.setStrUserEdited(strUserCode);
			objFolioDtl.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objFolioDtl.setStrRemark("");
			objFolioDtl.setDblDiscAmt(0.00);
			objFolioDtl.setDblDiscPer(0.00);
			objFolioDtl.setStrOldFolioNo(" ");
			listFolioDtl.add(objFolioDtl);

			objTaxProductDtl = new clsTaxProductDtl();
			objTaxProductDtl.setStrTaxProdCode(objExtraBedMaster.getStrExtraBedTypeCode());
			objTaxProductDtl.setStrTaxProdName("");
			if(strComp.equalsIgnoreCase("Y"))
			{
				objTaxProductDtl.setDblTaxProdAmt(0.0);
			}
			else
			{
				objTaxProductDtl.setDblTaxProdAmt(objExtraBedMaster.getDblChargePerBed());
			}
			
			
			List<clsTaxProductDtl> listTaxProdDtlForExtraBed = new ArrayList<clsTaxProductDtl>();
			listTaxProdDtlForExtraBed.add(objTaxProductDtl);
			Map<String, List<clsTaxCalculation>> hmTaxCalDtlForExtraBed = null;
			if(objHdModel.getStrDontApplyTax().equals("N"))
			{
				hmTaxCalDtlForExtraBed = objPMSUtility.funCalculatePMSTax(listTaxProdDtlForExtraBed, "Extra Bed");
			}
			
			if(hmTaxCalDtlForExtraBed.containsKey(objExtraBedMaster.getStrExtraBedTypeCode())){
			List<clsTaxCalculation> listTaxCalForExtraBed = hmTaxCalDtlForExtraBed.get(objExtraBedMaster.getStrExtraBedTypeCode());
			for (clsTaxCalculation objTaxCal : listTaxCalForExtraBed) {
				clsFolioTaxDtl objFolioTaxDtl = new clsFolioTaxDtl();
				objFolioTaxDtl.setStrDocNo(docNo);
				objFolioTaxDtl.setStrTaxCode(objTaxCal.getStrTaxCode());
				objFolioTaxDtl.setStrTaxDesc(objTaxCal.getStrTaxDesc());
				objFolioTaxDtl.setDblTaxableAmt(objTaxCal.getDblTaxableAmt());
				objFolioTaxDtl.setDblTaxAmt(objTaxCal.getDblTaxAmt());
				listFolioTaxDtl.add(objFolioTaxDtl);
			}
		}
		}
		}
	}
		//objWebPMSUtility.funExecuteUpdate("delete from tblfoliodtl where strFolioNo='"+objFolioHd.getStrFolioNo()+"' and strRevenueType='Room' or strRevenueType='Package' and strClientCode='"+clientCode+"'", "sql");
		objFolioHd.setListFolioDtlModel(listFolioDtl);
		objPMSUtility.funInsertFolioDtlBackup(objFolioHd.getStrFolioNo());
		objFolioHd.setListFolioTaxDtlModel(listFolioTaxDtl);
		objFolioService.funAddUpdateFolioHd(objFolioHd);

		return docNo;
	}

	
	@RequestMapping(value = "/cleanRoomStatus", method = RequestMethod.GET)
	public @ResponseBody String  funChangeStatus(@RequestParam("checkInNo") String checkInNo,HttpServletRequest request) {

		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String propCode = request.getSession().getAttribute("propertyCode").toString();
		String PMSDate = request.getSession().getAttribute("PMSDate").toString();
		String urlHits ="1";
		String strResponse = "";	
		
		String sqlHosueKeepMaster = "select b.strHouseKeepCode from tblhousekeepmaster b where b.strClientCode='"+clientCode+"'";
		List listHosueKeepMaster = objGlobalFunctionsService.funGetListModuleWise(sqlHosueKeepMaster, "sql");

		String sqlHouseKeepDtl = "select a.strHouseKeepCode from tblroomhousekeepdtl a where a.strRoomCode='"+checkInNo+"'";
		List listHouseKeepDtl = objGlobalFunctionsService.funGetListModuleWise(sqlHosueKeepMaster, "sql");

		if(listHosueKeepMaster!=null && listHosueKeepMaster.size()>0 && listHouseKeepDtl!=null && listHouseKeepDtl.size()>0)
		{
			int list1 = listHosueKeepMaster.size();
			int list2 = listHouseKeepDtl.size();
			
			if(list1==list2)
			{
				strResponse = "Room changes Successfully";
				
				String sqlChangeStatus = "update tblroom a set a.strStatus='Free' where a.strRoomDesc='"+checkInNo+"' "
						+ "and a.strClientCode='"+clientCode+"'";
				
				objWebPMSUtility.funExecuteUpdate(sqlChangeStatus, "sql");
			}
		}
		
		/*String sqlDirtyRoomCheck = "SELECT b.strStatus ,a.strRoomNo "
				+ "FROM tblcheckindtl a,tblroom b "
				+ "WHERE a.strCheckInNo='"+checkInNo+"' AND a.strRoomNo=b.strRoomCode "
				+ "AND a.strClientCode='"+clientCode+"'";
		
		
		List listDirtyRoomCheck = objGlobalFunctionsService.funGetListModuleWise(sqlDirtyRoomCheck, "sql");
		if(listDirtyRoomCheck!=null && listDirtyRoomCheck.size()>0)
		{
			for(int i=0;i<listDirtyRoomCheck.size();i++)
			{
				Object[] arr = (Object[]) listDirtyRoomCheck.get(i);
				String strStatus = arr[0].toString();
				String strRoomNo = arr[1].toString();
				
				if(strStatus.equalsIgnoreCase("Dirty"))
				{
					String sqlChangeStatus = "update tblroom a set a.strStatus='Free' where a.strRoomCode='"+strRoomNo+"' "
							+ "and a.strClientCode='"+clientCode+"'";
					
					objWebPMSUtility.funExecuteUpdate(sqlChangeStatus, "sql");
				}
				
			}
			
		}*/
		return strResponse;
		
		//return new ModelAndView("redirect:/frmRoomStatusDiary.html");
	}
}
