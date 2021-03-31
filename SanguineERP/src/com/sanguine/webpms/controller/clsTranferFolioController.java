package com.sanguine.webpms.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsFolioDtlBean;
import com.sanguine.webpms.bean.clsFolioHdBean;
import com.sanguine.webpms.bean.clsPMSPaymentBean;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.model.clsFolioHdModel;
import com.sanguine.webpms.model.clsFolioTaxDtl;
import com.sanguine.webpms.model.clsVoidBillDtlModel;
import com.sanguine.webpms.model.clsVoidBillHdModel;
import com.sanguine.webpms.model.clsVoidBillTaxDtlModel;
import com.sanguine.webpms.service.clsFolioService;
import com.sanguine.webpms.service.clsVoidBillService;




@Controller
public class clsTranferFolioController {
	
	
	
	@Autowired
	clsGlobalFunctions objGlobal;
	
	@Autowired
	clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Autowired
	clsFolioService objFolioService;
	
	@Autowired
	clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	clsVoidBillService objVoidBillService;

	
	// Open transfer folio
	
	@RequestMapping(value = "/frmTransferFolio", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		
		
		model.put("urlHits", urlHits);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmTransferFolio_1", "command", new clsFolioHdBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmTransferFolio", "command", new clsFolioHdBean());
		} else {
			return null;
		}
	}
	

	//Load From Folio Code
	@SuppressWarnings({ "rawtypes"})
	@RequestMapping(value = "/loadFromFolioData", method = RequestMethod.GET)
	public @ResponseBody List funloadFromFolioData(@RequestParam("FromFolioCode") String strFolioNo,HttpServletRequest request) {
		 
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
		
		
		String sql="select b.strFolioNo,DATE_FORMAT(b.dteDocDate,'%d-%m-%Y'),b.strDocNo, c.strRoomDesc, b.strPerticulars,b.dblDebitAmt from"
				+ "  tblfoliohd a ,tblfoliodtl b,tblroom c"
				+ " where a.strFolioNo=b.strFolioNo and a.strRoomNo=c.strRoomCode"
				+ "  and a.strClientCode=c.strClientCode and"
				+ " a.strFolioNo='"+strFolioNo+"' and a.strClientCode='"+clientCode+"' ;";
		
		
		List listFolioNo  = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");	
		
		return listFolioNo;		
	}
	
	
	//Save Transfer folio
	
	@SuppressWarnings({ "rawtypes"})
	@RequestMapping(value = "/saveTranferFolio", method = RequestMethod.POST)
	public ModelAndView  funsaveTranferFolio(@ModelAttribute("command") @Valid clsFolioHdBean objBean,HttpServletRequest request) {
		 
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
		String userCode = request.getSession().getAttribute("usercode").toString();
		String strToFolioNo=objBean.getStrToFolioNo();
			
		// old  Folio No means From Folio No (In JSP)
	    // New  folio No means To Folio No (In JSP)
		
		String strFromFolioNo="";
		String strFromDocNo="''";
		
		//Get the Doc No from selected folio(old  Folio No), for Folio Transfer 
		for(clsFolioDtlBean objDtlBean:objBean.getListFolioDtlBean())
		{
			strFromFolioNo=objDtlBean.getStrFolioNo();
			if(objDtlBean.getStrIsFolioSelected()!=null)
			{
				if(objDtlBean.getStrIsFolioSelected().equalsIgnoreCase("Y"))
				{
					if(strFromDocNo.equals("''"))
					{
						strFromDocNo="'"+objDtlBean.getStrDocNo()+"'";
					}
					else
					{
						strFromDocNo +=",'"+objDtlBean.getStrDocNo()+"'";
					}
				}
			}
			
		}
		
		//Old  Folio No Model
        clsFolioHdModel objFromFolioHd = objFolioService.funGetFolioList(strFromFolioNo, clientCode, "");
     
        //New  folio no Model
        clsFolioHdModel objToFolioHd = objFolioService.funGetFolioList(strToFolioNo, clientCode, "");

        
     
        //Audit Entry Start 
        //Means in Entry Void Table
        
        //Folio Hd Entry
		clsVoidBillHdModel objVoidHdModel=new clsVoidBillHdModel();
		
		objVoidHdModel.setStrBillNo(strFromFolioNo);//Old From Folio No
		objVoidHdModel.setDteBillDate(PMSDate);
		objVoidHdModel.setStrClientCode(clientCode);
		objVoidHdModel.setStrCheckInNo(objFromFolioHd.getStrCheckInNo());
		objVoidHdModel.setStrFolioNo(strToFolioNo);//New To folio no
		objVoidHdModel.setStrRoomNo(objFromFolioHd.getStrRoomNo());
		objVoidHdModel.setStrExtraBedCode(objFromFolioHd.getStrExtraBedCode());
		objVoidHdModel.setStrRegistrationNo(objFromFolioHd.getStrRegistrationNo());
		objVoidHdModel.setStrReservationNo(objFromFolioHd.getStrReservationNo());
		objVoidHdModel.setDblGrandTotal(0);
		objVoidHdModel.setStrUserCreated(userCode);
		objVoidHdModel.setStrUserEdited(userCode);
		objVoidHdModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objVoidHdModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objVoidHdModel.setStrBillSettled(" ");
		objVoidHdModel.setStrVoidType("Transfer Folio");
		objVoidHdModel.setStrReasonCode(objBean.getStrReasonCode());
		objVoidHdModel.setStrReasonName(objBean.getStrReasonDesc());
		objVoidHdModel.setStrRemark(objBean.getStrRemarks());
		List<clsVoidBillDtlModel> listVoidBillDtlModels=new ArrayList();
		
		 //Folio Dtl Entry
		String sql="select * from tblfoliodtl  a where a.strFolioNo='"+strFromFolioNo+"' and a.strDocNo in ("+strFromDocNo+")   and a.strClientCode='"+clientCode+"' ";
		List listBillDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		
		for (int j = 0; j < listBillDtl.size(); j++) {
			Object[] objMdl = (Object[]) listBillDtl.get(j);
			clsVoidBillDtlModel voidbillDtlModel = new clsVoidBillDtlModel();
			
				voidbillDtlModel.setStrFolioNo(objMdl[0].toString());
				voidbillDtlModel.setDteDocDate(objMdl[1].toString());
				voidbillDtlModel.setStrDocNo(objMdl[2].toString());
				voidbillDtlModel.setStrPerticulars(objMdl[3].toString());
				voidbillDtlModel.setStrRevenueType(objMdl[7].toString());
				voidbillDtlModel.setStrRevenueCode(objMdl[8].toString());
				voidbillDtlModel.setDblDebitAmt(Double.parseDouble(objMdl[4].toString()));
				voidbillDtlModel.setDblCreditAmt(Double.parseDouble(objMdl[5].toString()));
				voidbillDtlModel.setDblBalanceAmt(Double.parseDouble(objMdl[6].toString()));
				listVoidBillDtlModels.add(voidbillDtlModel);
			
		}
		objVoidHdModel.setListVoidBillDtlModels(listVoidBillDtlModels);
		
		 //Folio Tax Dtl Entry
		List<clsVoidBillTaxDtlModel> listVoidBillTaxDtlModels=new ArrayList();
		sql="select * from tblfoliotaxdtl  a where a.strFolioNo='"+strFromFolioNo+"' and a.strDocNo in ("+strFromDocNo+")   and a.strClientCode='"+clientCode+"' ";
		List listBillTaxDtl = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

		if(listBillTaxDtl.size()>0){
			for (int j = 0; j < listBillTaxDtl.size(); j++) {
				Object[] objMdl = (Object[]) listBillTaxDtl.get(j);
				clsVoidBillTaxDtlModel obVoidTaxDtl=new clsVoidBillTaxDtlModel();
				
				obVoidTaxDtl.setStrDocNo(objMdl[1].toString());
				obVoidTaxDtl.setStrTaxCode(objMdl[2].toString());
				obVoidTaxDtl.setStrTaxDesc(objMdl[3].toString());
				obVoidTaxDtl.setDblTaxableAmt(Double.parseDouble(objMdl[4].toString()));
				obVoidTaxDtl.setDblTaxAmt(Double.parseDouble(objMdl[5].toString()));
				
				listVoidBillTaxDtlModels.add(obVoidTaxDtl);
			}
		}
		
		objVoidHdModel.setListVoidBillTaxDtlModels(listVoidBillTaxDtlModels);
		
		objVoidBillService.funSaveVoidBillData(objVoidHdModel);
		//Audit Entry End

			
		//Tranfer Folio Entry Start
		
		//Update particulars for  only Income head post
		//For example Transfer-303 A(Room No)  DINNER(Income Head Name)
		
		sql=" UPDATE tblfoliohd a "
			+ " INNER join  tblfoliodtl b on a.strFolioNo = b.strFolioNo"
			+ " INNER join  tblroom c on a.strRoomNo =c.strRoomCode"
			+ " SET b.strPerticulars = CONCAT('Transfer-', c.strRoomDesc,' ', b.strPerticulars) "
			+ " where b.strDocNo in ("+strFromDocNo+") and a.strClientCode='"+clientCode+"' and b.strRevenueType='Income Head' " ;
		objWebPMSUtility.funExecuteUpdate(sql, "sql");
		
		
		//Update Old Folio No in  strOldFolioNo field ( Folio Dtl Table )
		sql="UPDATE tblfoliodtl a set a.strOldFolioNo=a.strFolioNo"
				+ " where a.strDocNo in ("+strFromDocNo+") and a.strClientCode='"+clientCode+"' ";
		objWebPMSUtility.funExecuteUpdate(sql, "sql");
		
		//Update the New Folio No in place of old folio NO in tblfoliodtl Table
		sql="UPDATE tblfoliodtl a set a.strFolioNo ='"+strToFolioNo+"' "
		 	+ " where a.strDocNo in ("+strFromDocNo+") and a.strClientCode='"+clientCode+"'   ";
		objWebPMSUtility.funExecuteUpdate(sql, "sql");
		
		//Update the New Folio No  in place of old folio No in tblfoliotaxdtl Table
		sql="UPDATE tblfoliotaxdtl a set a.strFolioNo ='"+strToFolioNo+"' "
			+ " where a.strDocNo in ("+strFromDocNo+") and a.strClientCode='"+clientCode+"'  ";
		objWebPMSUtility.funExecuteUpdate(sql, "sql");
		
		//Check Entry For Old Folio No in tblfoliodtl Table
		sql="select a.strFolioNo,a.dteDocDate,a.strDocNo from tblfoliodtl  a where a.strFolioNo='"+strFromFolioNo+"' and a.strClientCode='"+clientCode+"' ";
		List listFolioNo  = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(!(listFolioNo!=null && listFolioNo.size()>0))
		{
			//Update Room Status Free For Old Folio No
			sql="update tblroom a set a.strStatus='Free' where a.strRoomCode='"+objFromFolioHd.getStrRoomNo()+"' ";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
			
			//Delete  Old Folio No from tblfoliodtl Table
			sql="delete from tblfoliohd  where strFolioNo='"+strFromFolioNo+"' and strClientCode='"+clientCode+"' ";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
			
		}
		//Income Head
		//Tranfer Folio Entry Entry
		
			
        request.getSession().setAttribute("success", true);		
        request.getSession().setAttribute("FromFolioNo", strFromFolioNo);		
        request.getSession().setAttribute("ToFolioNO", strToFolioNo);		
		
		return new ModelAndView("redirect:/frmTransferFolio.html");
		
		
	}
	
	

}
