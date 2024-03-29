package com.sanguine.webpms.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;






import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsFolioDtlBean;
import com.sanguine.webpms.bean.clsTaxCalculation;
import com.sanguine.webpms.bean.clsTaxProductDtl;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsFolioDtlBackupModel;
import com.sanguine.webpms.model.clsFolioDtlModel;
import com.sanguine.webpms.service.clsFolioService;

@Controller
public class clsPMSUtilityFunctions {

	@Autowired
	clsGlobalFunctionsService objGlobalFunService;

	@Autowired
	clsWebPMSDBUtilityDao objWebPMSUtility;
	
	@Autowired
	clsFolioService objFolioService;

	public Map<String, List<clsTaxCalculation>> funCalculatePMSTax(List<clsTaxProductDtl> listTaxProdDtl, String taxOnType) {
		Map<String, List<clsTaxCalculation>> hmTaxCalDtl = new HashMap<String, List<clsTaxCalculation>>();

		Date dt = new Date();
		String date = (dt.getYear() + 1900) + "-" + (dt.getMonth() + 1) + "-" + dt.getDate();

		String sql = "select strTaxCode,strTaxDesc,strIncomeHeadCode,strTaxType,dblTaxValue,strTaxOn,strDeptCode,dblFromRate,dblToRate,strClientCode from tbltaxmaster where date(dteValidFrom) <='" + date + "' and date(dteValidTo)>='" + date + "'"
				+ " and strTaxOnType ='" + taxOnType + "'";
 		List listTaxDtl = objGlobalFunService.funGetListModuleWise(sql, "sql");

		double tariffAmt = 0.0;
		String strTaxOn="";
		for (clsTaxProductDtl objTaxProdDtl : listTaxProdDtl) {
			List<clsTaxCalculation> listTaxCalDtl = new ArrayList<clsTaxCalculation>();
			for (int cnt = 0; cnt < listTaxDtl.size(); cnt++) {
				String taxCalType = "Forward";
				
				Object[] arrObjTaxDtl = (Object[]) listTaxDtl.get(cnt);
				tariffAmt = objTaxProdDtl.getDblTaxProdAmt();
				strTaxOn=arrObjTaxDtl[5].toString();
				String clientCode=arrObjTaxDtl[9].toString();
				if(clientCode.equalsIgnoreCase("383.001"))
				{
					 taxCalType = "Backward";
				}
				if (taxOnType.equalsIgnoreCase("Income Head")) 
				{
					if (arrObjTaxDtl[2].toString().equals(objTaxProdDtl.getStrTaxProdCode())) 
					{
						clsTaxCalculation objTaxCal = new clsTaxCalculation();
						double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
						// Check for Tax Type Per/Amt
						if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage"))
						{
							double taxAmt = 0;
							// Forward Tax Calculation
							if (taxCalType.equals("Forward")) 
							{
								taxAmt = (objTaxProdDtl.getDblTaxProdAmt() * taxValue) / 100;
							} 
							else // Backward Tax Calculation
							{
								taxAmt = objTaxProdDtl.getDblTaxProdAmt() * 100 / (100 + taxValue);
								taxAmt = objTaxProdDtl.getDblTaxProdAmt() - taxAmt;
								taxAmt=taxAmt/2;
							}
							if (taxAmt > 0) 
							{
								objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
								objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
								objTaxCal.setStrTaxType(taxCalType);
								objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
								objTaxCal.setDblTaxAmt(taxAmt);
								listTaxCalDtl.add(objTaxCal);
							}
						} 
						else {
						}
					}
					
				} 
				else if(taxOnType.equalsIgnoreCase("Department")){
					if(arrObjTaxDtl[6].toString().equals(objTaxProdDtl.getStrDeptCode()))  
					{
						clsTaxCalculation objTaxCal = new clsTaxCalculation();
						double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
						// Check for Tax Type Per/Amt
						if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage"))
						{
							double taxAmt = 0;
							// Forward Tax Calculation
							if (taxCalType.equals("Forward")) 
							{
								taxAmt = (objTaxProdDtl.getDblTaxProdAmt() * taxValue) / 100;
							} 
							else // Backward Tax Calculation
							{
								taxAmt = objTaxProdDtl.getDblTaxProdAmt() * 100 / (100 + taxValue);
								taxAmt = objTaxProdDtl.getDblTaxProdAmt() - taxAmt;
								taxAmt=taxAmt/2;
							}
							if (taxAmt > 0) 
							{
								objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
								objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
								objTaxCal.setStrTaxType(taxCalType);
								objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
								objTaxCal.setDblTaxAmt(taxAmt);
								listTaxCalDtl.add(objTaxCal);
							}
						} 
						else {
						}
					}
				}
				else if(taxOnType.equalsIgnoreCase("Extra Bed")){
					// Extra Bed Tax Calculation
					clsTaxCalculation objTaxCal = new clsTaxCalculation();
					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
					if(strTaxOn.equals("Gross Amount"))
					{
						if(fromRate<=tariffAmt && tariffAmt<=toRate){
							if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage")) // Check for Tax Type Per/Amt
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
								{
									taxAmt = (objTaxProdDtl.getDblTaxProdAmt() * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = objTaxProdDtl.getDblTaxProdAmt() * 100 / (100 + taxValue);
									taxAmt = objTaxProdDtl.getDblTaxProdAmt() - taxAmt;
									taxAmt=taxAmt/2;
								}
								if (taxAmt > 0) {
									objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
									objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
									objTaxCal.setStrTaxType(taxCalType);
									objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
									objTaxCal.setDblTaxAmt(taxAmt);

									listTaxCalDtl.add(objTaxCal);
								}
							}
						}
						else 
						{
							
						}
					}
					else
					{
						//Discount
						//tariffAmt = tariffAmt-(tariffAmt*discountPer)/100;
						//double dblTarrifAndExtraBedAmtForSlabCheck=tariffAmt+ objTaxProdDtl.getDblTotalExtraBedAmt();
						if(fromRate<=tariffAmt&& tariffAmt<=toRate){
							if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage")) // Check  for Tax Type Per/Amt
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
																	// Calculation
								{
									taxAmt = (tariffAmt * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = tariffAmt * 100 / (100 + taxValue);
									taxAmt = tariffAmt - taxAmt;
									taxAmt=taxAmt/2;
								}
								if (taxAmt > 0) {
									objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
									objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
									objTaxCal.setStrTaxType(taxCalType);
									objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
									objTaxCal.setDblTaxAmt(taxAmt);

									listTaxCalDtl.add(objTaxCal);
								}
							}
						}
						else 
						{
							
						}
					}
				
				}
				else 
				{// room tariff
					clsTaxCalculation objTaxCal = new clsTaxCalculation();
					double taxValue = Double.parseDouble(arrObjTaxDtl[4].toString());
					double fromRate = Double.parseDouble(arrObjTaxDtl[7].toString());
					double toRate = Double.parseDouble(arrObjTaxDtl[8].toString());
					if(strTaxOn.equals("Gross Amount"))
					{
						if(fromRate<=tariffAmt && tariffAmt<=toRate){
							if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage")) // Check																// Per/Amt
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
																	// Calculation
								{
									taxAmt = (objTaxProdDtl.getDblTaxProdAmt() * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = objTaxProdDtl.getDblTaxProdAmt() * 100 / (100 + taxValue);
									taxAmt = objTaxProdDtl.getDblTaxProdAmt() - taxAmt;
									taxAmt=taxAmt/2;
								}
								if (taxAmt > 0) {
									objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
									objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
									objTaxCal.setStrTaxType(taxCalType);
									objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
									objTaxCal.setDblTaxAmt(taxAmt);

									listTaxCalDtl.add(objTaxCal);
								}
							}
						}
						else 
						{
							
						}
					}
					else
					{
						//Discount
						double discountPer = objTaxProdDtl.getDblDiscountOnTariff();
						tariffAmt = tariffAmt-(tariffAmt*discountPer)/100;
						double dblTarrifAndExtraBedAmtForSlabCheck=tariffAmt+ objTaxProdDtl.getDblTotalExtraBedAmt();
						if(fromRate<=(tariffAmt)&& (tariffAmt)<=toRate){
							if (arrObjTaxDtl[3].toString().equalsIgnoreCase("Percentage")) // Check  for Tax Type Per/Amt
							{
								double taxAmt = 0;
								if (taxCalType.equals("Forward")) // Forward Tax
																	// Calculation
								{
									taxAmt = (tariffAmt * taxValue) / 100;
								} 
								else // Backward Tax Calculation
								{
									taxAmt = tariffAmt * 100 / (100 + taxValue);
									taxAmt = tariffAmt - taxAmt;
									taxAmt=taxAmt/2;
								}
								if (taxAmt > 0) {
									objTaxCal.setStrTaxCode(arrObjTaxDtl[0].toString());
									objTaxCal.setStrTaxDesc(arrObjTaxDtl[1].toString());
									objTaxCal.setStrTaxType(taxCalType);
									objTaxCal.setDblTaxableAmt(objTaxProdDtl.getDblTaxProdAmt());
									objTaxCal.setDblTaxAmt(taxAmt);

									listTaxCalDtl.add(objTaxCal);
								}
							}
						}
						else 
						{
							
						}
					}
					
					
				}
			}
			if (listTaxCalDtl.size() > 0) {
				hmTaxCalDtl.put(objTaxProdDtl.getStrTaxProdCode(), listTaxCalDtl);
			}
		}

		return hmTaxCalDtl;
	}

	public long funGenerateFolioNo(String transType) {
		long docNo = 1;
		String sql = "select lngDocNo,strTransactionType from tblinternal where strTransactionType='Folio' ";
		List list = objWebPMSUtility.funExecuteQuery(sql, "sql");

		if (list.size() > 0) {
			Object[] arrObjDocNo = (Object[]) list.get(0);
			docNo = Long.parseLong(arrObjDocNo[0].toString());
			docNo = docNo + 1;

			sql = "update tblinternal set lngDocNo='" + docNo + "' where strTransactionType='Folio' ";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		} else {
			sql = "insert into tblinternal values ('Folio','" + docNo + "')";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		}

		return docNo;
	}

	public long funGenerateFolioDocForIncomeHead(String transType) {
		long docNo = 1;
		String sql = "select lngDocNo,strTransactionType from tblinternal where strTransactionType='IncomeHeadFolio' ";
		List list = objWebPMSUtility.funExecuteQuery(sql, "sql");

		if (list.size() > 0) {
			Object[] arrObjDocNo = (Object[]) list.get(0);
			docNo = Long.parseLong(arrObjDocNo[0].toString());
			docNo = docNo + 1;

			sql = "update tblinternal set lngDocNo='" + docNo + "' where strTransactionType='IncomeHeadFolio' ";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		} else {
			sql = "insert into tblinternal values ('IncomeHeadFolio','" + docNo + "')";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		}

		return docNo;
	}

	public long funGenerateFolioDocForRoom(String transType) {
		long docNo = 1;
		String sql = "select lngDocNo,strTransactionType from tblinternal where strTransactionType='RoomFolio' ";
		List list = objWebPMSUtility.funExecuteQuery(sql, "sql");

		if (list.size() > 0) {
			Object[] arrObjDocNo = (Object[]) list.get(0);
			docNo = Long.parseLong(arrObjDocNo[0].toString());
			docNo = docNo + 1;

			sql = "update tblinternal set lngDocNo='" + docNo + "' where strTransactionType='RoomFolio' ";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		} else {
			sql = "insert into tblinternal values ('RoomFolio','" + docNo + "')";
			objWebPMSUtility.funExecuteUpdate(sql, "sql");
		}

		return docNo;
	}
	
	public void funInsertFolioDtlBackup(String folioNo)
	{
		if(!folioNo.isEmpty())
		{
			
			//String sql = "insert into tblfoliobckp (select * from tblfoliodtl where strFolioNo='"+folioNo+"')";
			//objWebPMSUtility.funExecuteUpdate(sql, "sql");
			
			/*for(int i=0;i<list.size();i++)
			{
				clsFolioDtlModel objModel = list.get(i);
				
				clsFolioDtlBackupModel objBackupModel = new clsFolioDtlBackupModel();
				
				objBackupModel.setDblBalanceAmt(objModel.getDblBalanceAmt());
				objBackupModel.setDblCreditAmt(objModel.getDblCreditAmt());
				objBackupModel.setDblDebitAmt(objModel.getDblDebitAmt());
				objBackupModel.setDblQuantity(objModel.getDblQuantity());
				objBackupModel.setDteDocDate(objModel.getDteDocDate());
				objBackupModel.setStrDocNo(objModel.getStrDocNo());
				objBackupModel.setStrPerticulars(objModel.getStrPerticulars());
				objBackupModel.setStrRevenueCode(objModel.getStrRevenueCode());
				objBackupModel.setStrRevenueType(objModel.getStrRevenueType());
				
				
				//objFolioService.funAddUpdateFolioBackupDtl(objBackupModel);
				
			}*/
		}
	}
	
	
	public double funGetOpeningBalanceForOneGuest(String strGuestCode)
	{
		double openingBal=0;
		
		String sql="select b.totalDebitAmt - a.totalCreditAmt as guestOpeningBalance from"
				+ "  (select ifnull(sum(a.dblSettlementAmt),0) as totalCreditAmt   from tblreceiptdtl a,tblreceipthd b"
				+ " where  a.strReceiptNo=b.strReceiptNo and a.strCustomerCode ='"+strGuestCode+"'"
				+ "  and b.strFolioNo not in (  select a.strFolioNo from tblfoliohd a )"
				+ " and b.strReservationNo not in (  select a.strReservationNo from tblfoliohd a ) ) as a ,"
				+ " ( Select ifnull(sum(a.dblGrandTotal),0) as totalDebitAmt from tblbillhd a where a.strGuestCode='"+strGuestCode+"') "
				+ " as b" ;
		
		List listOpeningBalnce = objGlobalFunService.funGetListModuleWise(sql, "sql");
	    if(listOpeningBalnce!=null && listOpeningBalnce.size()>0)
	    {
	    	openingBal=Double.parseDouble(listOpeningBalnce.get(0).toString());
	    }
		return openingBal;
				
				
	}
	

	
	
	
	//All guest closing balance
/*	select ifnull(b.totalDebitAmt - a.totalCreditAmt,0) as guestOpeningBalance, b.billGuestCode,d.strFirstName from 
	tblguestmaster d 
	left outer join 
	(select ifnull(sum(a.dblSettlementAmt),0) as totalCreditAmt ,a.strCustomerCode as PaymentGuestCode   from tblreceiptdtl a,tblreceipthd b
	where  a.strReceiptNo=b.strReceiptNo
	group by a.strCustomerCode) as a on a.PaymentGuestCode=d.strGuestCode 

	left outer join ( Select ifnull(sum(a.dblGrandTotal),0) as totalDebitAmt,a.strGuestCode as billGuestCode from tblbillhd a 
	group by a.strGuestCode) 
	as b  on  b.billGuestCode=d.strGuestCode  

	left outer join 
	(select ifnull(sum(a.dblDebitAmt),0) , b.strGuestCode as folioGuestCode
	from tblfoliodtl a, tblfoliohd b 
	where a.strFolioNo=b.strFolioNo 
	group by b.strGuestCode ) as c  on c.folioGuestCode=d.strGuestCode

	having guestOpeningBalance>0*/
	
	
	


}
