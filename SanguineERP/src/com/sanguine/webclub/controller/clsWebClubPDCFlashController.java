package com.sanguine.webclub.controller;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ibm.icu.math.BigDecimal;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webclub.bean.clsWebClubPDCBean;
import com.sanguine.webclub.bean.clsWebClubPDCFlashBean;
import com.sanguine.webclub.service.clsWebClubPDCService;


@Controller
public class clsWebClubPDCFlashController{

	@Autowired
	private clsWebClubPDCService objWebClubPDCService;
	
	@Autowired
	clsGlobalFunctionsService objGlobalService;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	private clsGlobalFunctions objGlobal=null;

	//Open WebClubPDC
	@RequestMapping(value = "/frmWebClubPDCFlash", method = RequestMethod.GET)
	public ModelAndView funOpenForm(){				
		return new ModelAndView("frmWebClubPDCFlash","command", new clsWebClubPDCFlashBean());
	}
	//Load Master Data On Form
	@RequestMapping(value = "/frmWebClubPDCFlash1", method = RequestMethod.POST)
	public @ResponseBody clsWebClubPDCFlashBean funLoadMasterData(HttpServletRequest request){
		objGlobal=new clsGlobalFunctions();
		String sql="";
		String clientCode=request.getSession().getAttribute("clientCode").toString();
		String userCode=request.getSession().getAttribute("usercode").toString();
		clsWebClubPDCBean objBean=new clsWebClubPDCBean();
		String docCode=request.getParameter("docCode").toString();
		List listModel=objGlobalFunctionsService.funGetList(sql);
		clsWebClubPDCFlashBean objWebClubPDC = new clsWebClubPDCFlashBean();
		return objWebClubPDC;
	}
	
	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadDateWiseMemberData", method = RequestMethod.GET)
	public @ResponseBody List funLoadDateWiseMemberData(@RequestParam("fromDate") String fromDate,@RequestParam("toDate") String toDate,@RequestParam("chequeType") String chequeType,@RequestParam("memCode") String memCode, HttpServletRequest req) {
		objGlobal=new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String webStock=req.getSession().getAttribute("WebStockDB").toString();
		String sql="";
		String webCLub = req.getSession().getAttribute("WebCLUBDB").toString();
		List<clsWebClubPDCBean> ojbBeanModel = new ArrayList<clsWebClubPDCBean>();
		String strFromDate=objGlobal.funGetDate("yyyy-MM-dd", fromDate);
		String strToDate=objGlobal.funGetDate("yyyy-MM-dd", toDate);
		//export logic
		if(memCode.equalsIgnoreCase(""))
		{
			sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE a.strMemCode=b.strMemberCode AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";
		}
		else if(memCode.equalsIgnoreCase("undefined"))
		{
			sql="SELECT Concat(c.strFirstName,' ', c.strMiddleName,' ', c.strLastName),a.strChequeNo,b.strBankName,a.strType,a.dblChequeAmt, DATE(a.dteChequeDate),c.strAccNo,c.strDebtorCode FROM "+webCLub+".tblpdcdtl a,"+webStock+".tblbankmaster b,"+webCLub+".tblmembermaster c WHERE a.strClientCode='"+clientCode+"'  AND a.strMemCode=c.strMemberCode AND a.strType='"+chequeType+"' AND c.strClientCode=a.strClientCode AND a.strDrawnOn=b.strBankName AND DATE(a.dteChequeDate) BETWEEN '"+strFromDate+"' AND '"+strToDate+"'  GROUP BY a.strChequeNo";
		}
		else{	
			sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE  a.strMemCode=b.strMemberCode AND  a.strMemCode='"+memCode+"' AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";			
		}
		List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if (list.isEmpty()) {				
			list.add("Invalid Code");
		}
		else
		{
			for(int i=0;i<list.size();i++)
			{
				list.get(i);
				Object obj[] = (Object[])list.get(i);
				clsWebClubPDCBean objBean = new clsWebClubPDCBean();
				objBean.setStrMemName(obj[0].toString());
				objBean.setStrChequeNo(obj[1].toString());
				objBean.setStrDrawnOn(obj[2].toString());
				objBean.setStrType(obj[3].toString());
				objBean.setDblChequeAmt(Double.parseDouble(obj[4].toString()));
				objBean.setDteChequeDate(objGlobal.funGetDate("dd-MM-yyyy", obj[5].toString()));
				if(memCode.equals("undefined")){
				objBean.setStrAccCode(obj[6].toString());
				objBean.setStrDebtorCode(obj[7].toString());
				}
				ojbBeanModel.add(objBean);
			}
			
		}
		return ojbBeanModel;
	}		
		
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/exportPDCSalesFlash", method = RequestMethod.GET)
	private ModelAndView funExportSettlementWisePMSSalesFlash(@RequestParam("fromDate") String fromDate,@RequestParam("toDate") String toDate,@RequestParam("chequeType") String chequeType,@RequestParam("memCode") String memCode,HttpServletRequest request)
	{    			
		objGlobal=new clsGlobalFunctions();
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String userCode = request.getSession().getAttribute("usercode").toString();
		String webStock=request.getSession().getAttribute("WebStockDB").toString();
		String sql="";
		String strFromDate=objGlobal.funGetDate("yyyy-MM-dd", fromDate);
		String strToDate=objGlobal.funGetDate("yyyy-MM-dd", toDate);
		if(memCode.equalsIgnoreCase(""))
		{
			sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE a.strMemCode=b.strMemberCode AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";
			//sql="SELECT c.strFirstName,a.strChequeNo,b.strBankName,a.strType,a.dblChequeAmt, DATE(a.dteChequeDate) FROM tblpdcdtl a,"+webStock+".tblbankmaster b,tblmembermaster c WHERE a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strMemCode=c.strMemberCode AND c.strClientCode=a.strClientCode AND a.strDrawnOn=b.strBankName AND DATE(a.dteChequeDate) BETWEEN '"+strFromDate+"' AND '"+strToDate+"' ";
		}
		else{
			sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE  a.strMemCode=b.strMemberCode AND  a.strMemCode='"+memCode+"' AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";
			//sql="SELECT c.strFirstName,a.strChequeNo,b.strBankName,a.strType,a.dblChequeAmt, DATE(a.dteChequeDate) FROM tblpdcdtl a,"+webStock+".tblbankmaster b,tblmembermaster c WHERE a.strMemCode='"+memCode+"' AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strMemCode=c.strMemberCode AND c.strClientCode=a.strClientCode AND a.strDrawnOn=b.strBankName AND DATE(a.dteChequeDate) BETWEEN '"+strFromDate+"' AND '"+strToDate+"' ";				
		}		
		List retList = new ArrayList();
		List detailList = new ArrayList();
		List headerList = new ArrayList();
		List totalsList = new ArrayList();
		DecimalFormat df = new DecimalFormat("0.00");
		BigDecimal dblTotalValue = new BigDecimal(0);	
		double total=0.0;
		List listSettlementDtl = objGlobalService.funGetListModuleWise(sql,"sql");
		if (!listSettlementDtl.isEmpty()) {
			for (int i = 0; i < listSettlementDtl.size(); i++) {
				Object[] arr2 = (Object[]) listSettlementDtl.get(i);
				List DataList = new ArrayList<>();
				DataList.add(arr2[0].toString());
				DataList.add(arr2[2].toString());
				DataList.add(arr2[1].toString());
				DataList.add(objGlobal.funGetDate("dd-MM-yyyy", arr2[5].toString()));
				DataList.add(df.format(Double.parseDouble(arr2[4].toString())));
				DataList.add(arr2[3].toString());
				detailList.add(DataList);
				total=total+Double.parseDouble(arr2[4].toString());
			}
		}				
		retList.add("PDCSalesFlashData_" + strFromDate + "to" + strToDate + "_" + userCode);
		List titleData = new ArrayList<>();
		titleData.add("PDC Sales Flash Report");
		retList.add(titleData);			
		List filterData = new ArrayList<>();			
		filterData.add("From Date");
		filterData.add(fromDate);
		filterData.add("To Date");
		filterData.add(toDate);
		filterData.add("");
		/*filterData.add("Cheque Type:");
		filterData.add(chequeType);
        if(!memCode.equalsIgnoreCase(""))
        {
        	filterData.add("");
        	filterData.add("Member Wise:");
        	filterData.add(memCode);
	       
        }*/
        retList.add(filterData);	        
		headerList.add("Member Name");
		headerList.add("Drawn On");
		headerList.add("Cheque No");
		headerList.add("Cheque Date");
		headerList.add("Amount");
		headerList.add("Type");			
		Object[] objHeader = (Object[]) headerList.toArray();
		String[] ExcelHeader = new String[objHeader.length];
		for (int k = 0; k < objHeader.length; k++) {
			ExcelHeader[k] = objHeader[k].toString();
		}				
		List blankList = new ArrayList();
		detailList.add(blankList);// Blank Row at Bottom
		totalsList.add("");
		totalsList.add("");
		totalsList.add("");
		totalsList.add("Total");
		totalsList.add(String.valueOf(total));
	    detailList.add(totalsList);		
        retList.add(ExcelHeader);
		retList.add(detailList);
		return new ModelAndView("excelViewFromToDteReportName", "listFromToDateReportName", retList);
    }
	
	
	
	// Assign filed function to set data onto form for edit transaction.
			@RequestMapping(value = "/loadDateWiseForPDCToReceiptMemberData", method = RequestMethod.GET)
			public @ResponseBody List funLoadDateWiseForPDCToReceiptMemberData(@RequestParam("fromDate") String fromDate,@RequestParam("toDate") String toDate,@RequestParam("chequeType") String chequeType,@RequestParam("memCode") String memCode, HttpServletRequest req) {
				objGlobal=new clsGlobalFunctions();
				String clientCode = req.getSession().getAttribute("clientCode").toString();
				String webStock=req.getSession().getAttribute("WebStockDB").toString();
				String sql="";
				String webCLub = req.getSession().getAttribute("WebCLUBDB").toString();
				List<clsWebClubPDCBean> ojbBeanModel = new ArrayList<clsWebClubPDCBean>();
				String strFromDate=objGlobal.funGetDate("yyyy-MM-dd", fromDate);
				String strToDate=objGlobal.funGetDate("yyyy-MM-dd", toDate);
				//export logic
				/*if(memCode.equalsIgnoreCase(""))
				{
					sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE a.strMemCode=b.strMemberCode AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";
				}*/
				if(memCode.equalsIgnoreCase("undefined"))
				{
					sql="SELECT Concat(c.strFirstName,' ', c.strMiddleName,' ', c.strLastName),a.strChequeNo,b.strBankName,a.strType,a.dblChequeAmt, DATE(a.dteChequeDate),c.strAccNo,c.strDebtorCode FROM "+webCLub+".tblpdcdtl a,"+webStock+".tblbankmaster b,"+webCLub+".tblmembermaster c WHERE a.strClientCode='"+clientCode+"'  AND a.strMemCode=c.strMemberCode AND a.strType='"+chequeType+"' AND c.strClientCode=a.strClientCode AND a.strDrawnOn=b.strBankName AND DATE(a.dteChequeDate) BETWEEN '"+strFromDate+"' AND '"+strToDate+"'  GROUP BY a.strChequeNo";
				}
				/*else{	
					sql="SELECT b.strFirstName,a.strChequeNo,c.strBankName,a.strType,a.dblChequeAmt,DATE(a.dteChequeDate),a.strMemCode FROM tblpdcdtl a,tblmembermaster b,"+webStock+".tblbankmaster c  WHERE  a.strMemCode=b.strMemberCode AND  a.strMemCode='"+memCode+"' AND a.strClientCode='"+clientCode+"' AND a.strType='"+chequeType+"' AND a.strDrawnOn=c.strBankName AND a.strClientCode=b.strClientCode AND Date(a.dteChequeDate)  BETWEEN '"+strFromDate+"' AND '"+strToDate+"'   ";			
				}*/
				List list=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
				if (list.isEmpty()) {				
					list.add("Invalid Code");
				}
				else
				{
					for(int i=0;i<list.size();i++)
					{
						list.get(i);
						Object obj[] = (Object[])list.get(i);				
						sql=" SELECT ifnull(a.strChequeNo,'') from tblreceipthd a,tblreceiptdebtordtl b WHERE b.strDebtorCode='"+obj[7].toString()+"' AND a.strVouchNo=b.strVouchNo GROUP BY a.strChequeNo ";			
						List listChequeNo=objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
						Map hmap = new HashMap<>();
						if(listChequeNo.size()>0)
						{
							if(!listChequeNo.get(0).toString().equalsIgnoreCase(""))
							{
								for(int k=0;k<listChequeNo.size();k++)
								{
									String str[]=listChequeNo.get(k).toString().split(",");
									for(String stra:str)
									{
										hmap.put(stra,stra);
									}
								}								
							}							
						}						
						if(!hmap.containsKey(obj[1].toString()))
						{
							clsWebClubPDCBean objBean = new clsWebClubPDCBean();
							objBean.setStrMemName(obj[0].toString());
							objBean.setStrChequeNo(obj[1].toString());
							objBean.setStrDrawnOn(obj[2].toString());
							objBean.setStrType(obj[3].toString());
							objBean.setDblChequeAmt(Double.parseDouble(obj[4].toString()));
							objBean.setDteChequeDate(objGlobal.funGetDate("dd-MM-yyyy", obj[5].toString()));
							if(memCode.equals("undefined"))
							{
								objBean.setStrAccCode(obj[6].toString());
								objBean.setStrDebtorCode(obj[7].toString());
							}
							ojbBeanModel.add(objBean);
						}
					}
					
				}
				return ojbBeanModel;
			}	
}
