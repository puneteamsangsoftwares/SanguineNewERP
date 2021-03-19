package com.sanguine.webpms.service;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsPMSPaymentBean;
import com.sanguine.webpms.dao.clsPMSPaymentDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsBillHdModel;
import com.sanguine.webpms.model.clsPMSPaymentHdModel;
import com.sanguine.webpms.model.clsPMSPaymentReceiptDtl;

@Service("clsPMSPaymentService")
public class clsPMSPaymentServiceImpl implements clsPMSPaymentService {

	@Autowired
	private clsPMSPaymentDao objPaymentDao;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsBillService objBillService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;
	

	@Override
	public void funAddUpdatePaymentHd(clsPMSPaymentHdModel objHdModel) {
		// TODO Auto-generated method stub
	}

	@Override
	public clsPMSPaymentHdModel funPreparePaymentModel(clsPMSPaymentBean objPaymentBean, String clientCode, HttpServletRequest request, String userCode) {
		String reservationNo = "";
		String registrationNo = "";
		String folioNo = "";
		String checkInNo = "";
		String billNo = "";
		
		String guestCode="";
		//String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
 		String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());

		clsPMSPaymentHdModel objModel = new clsPMSPaymentHdModel();

		if (objPaymentBean.getStrReceiptNo().isEmpty()) {
			String transaDate = objGlobal.funGetCurrentDateTime("dd-MM-yyyy").split(" ")[0];
			String documentNo = objGlobal.funGeneratePMSDocumentCode("frmPMSPayment", transaDate, request);
			objModel.setStrReceiptNo(documentNo);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrReceiptNo(objPaymentBean.getStrReceiptNo());
		}
		objModel.setStrAgainst(objPaymentBean.getStrAgainst());
		objModel.setDblPaidAmt(objPaymentBean.getDblReceiptAmt());
		objModel.setDblReceiptAmt(objPaymentBean.getDblReceiptAmt());

		if (objPaymentBean.getStrAgainst().equals("Reservation")) {
			String sql = "select ifnull(b.strCheckInNo,''),ifnull(b.strRegistrationNo,''),a.strReservationNo" + " ,ifnull(b.strFolioNo,''),c.strGuestCode  " + " from tblreservationhd a left outer join tblfoliohd b on a.strReservationNo=b.strReservationNo,tblreservationdtl c " + " where a.strReservationNo=c.strReservationNo AND  a.strReservationNo='" + objPaymentBean.getStrDocNo() + "' ";
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (list.size() > 0) {
 				for (int cnt = 0; cnt < list.size(); cnt++) {
					Object[] arrObj = (Object[]) list.get(cnt);
					checkInNo = arrObj[0].toString();
					registrationNo = arrObj[1].toString();
					reservationNo = arrObj[2].toString();
					folioNo = arrObj[3].toString();
					guestCode=arrObj[4].toString();
					objPaymentBean.setStrCustomerCode(guestCode);
					billNo = "";
					
					String sql1="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+guestCode+"' ";
					List guestlist = objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");
					double balance=0.00;
 					if(guestlist!=null && guestlist.size()>0)
					{
 						balance=Double.parseDouble(guestlist.get(0).toString());
					}
				   
 					double amount1=balance - objPaymentBean.getDblReceiptAmt();
					
 					String sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+amount1+"' where  a.strGuestCode='"+guestCode+"' ";
 					objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
				}
			}
		} else if (objPaymentBean.getStrAgainst().equals("Check-In")) {
			/*String sql = " select b.strCheckInNo,a.strRegistrationNo,b.strReservationNo,b.strFolioNo " + " from tblcheckinhd a,tblfoliohd b " + " where a.strCheckInNo=b.strCheckInNo and a.strCheckInNo='" + objPaymentBean.getStrDocNo() + "' ";*/
			String sql=" SELECT b.strCheckInNo,b.strRegistrationNo,b.strReservationNo,b.strFolioNo,b.strGuestCode "
						+" FROM tblfoliohd b,tblcheckindtl c "
						+" WHERE c.strCheckInNo='"+objPaymentBean.getStrDocNo()+"' AND b.strCheckInNo=c.strCheckInNo "
						+" AND b.strRoomNo=c.strRoomNo "
						+" AND c.strPayee='Y' AND b.strRoom='Y' "
						+" GROUP BY b.strFolioNo; ";
			
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (list.size() > 0) {
				for (int cnt = 0; cnt < list.size(); cnt++) {
					Object[] arrObj = (Object[]) list.get(cnt);
					checkInNo = arrObj[0].toString();
					registrationNo = arrObj[1].toString();
					reservationNo = arrObj[2].toString();
					folioNo = arrObj[3].toString();
					objPaymentBean.setStrCustomerCode(arrObj[4].toString());
					billNo = "";
				}
			}
		}

		else if (objPaymentBean.getStrAgainst().equals("Folio-No")) {
			String sql = " select b.strCheckInNo,a.strRegistrationNo,b.strReservationNo,b.strFolioNo,b.strGuestCode  " + " from tblcheckinhd a,tblfoliohd b " + " where a.strCheckInNo=b.strCheckInNo and b.strFolioNo='" + objPaymentBean.getStrDocNo() + "' ";
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (list.size() > 0) {
				for (int cnt = 0; cnt < list.size(); cnt++) {
					Object[] arrObj = (Object[]) list.get(cnt);
					checkInNo = arrObj[0].toString();
					registrationNo = arrObj[1].toString();
					reservationNo = arrObj[2].toString();
					folioNo = arrObj[3].toString();
					guestCode = arrObj[4].toString();
					billNo = "";
					objPaymentBean.setStrCustomerCode(guestCode);
					
					String sql1="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+guestCode+"' ";
					List guestlist = objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");
					double balance=0.00;
 					if(guestlist!=null && guestlist.size()>0)
					{
 						balance=Double.parseDouble(guestlist.get(0).toString());
					}
				   
 					double amount1=balance - objPaymentBean.getDblReceiptAmt();
					
 					String sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+amount1+"' where  a.strGuestCode='"+guestCode+"' ";
 					objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
					
				}
			}
		}
		
		else if (objPaymentBean.getStrAgainst().equals("Banquet")) {
			
				
					checkInNo = "";
					registrationNo = "";
					reservationNo = objPaymentBean.getStrDocNo();
					folioNo = "";
					billNo = "";
				
		}

		else {
			String sql = " select a.strCheckInNo,a.strRegistrationNo,a.strReservationNo,a.strFolioNo,b.strGuestCode " + " from tblbillhd a,tblcheckindtl b  " + " where a.strCheckInNo=b.strCheckInNo AND a.strBillNo='" + objPaymentBean.getStrDocNo() + "'";
			List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
			if (list.size() > 0) {
				for (int cnt = 0; cnt < list.size(); cnt++) {
					Object[] arrObj = (Object[]) list.get(cnt);
					checkInNo = arrObj[0].toString();
					registrationNo = arrObj[1].toString();
					reservationNo = arrObj[2].toString();
					folioNo = arrObj[3].toString();
					billNo = objPaymentBean.getStrDocNo();
					guestCode=arrObj[4].toString();
					objPaymentBean.setStrCustomerCode(guestCode);
					clsBillHdModel objBillHdModel = objBillService.funLoadBill(billNo, clientCode);
					String sqlReceipt=" SELECT ifnull(SUM(a.dblReceiptAmt),0) FROM tblreceipthd a WHERE a.strFolioNo='"+folioNo+"' ";
					List listReceipt = objGlobalFunctionsService.funGetListModuleWise(sqlReceipt, "sql");
					double balanceAmt=0.00;
					if(listReceipt.size()>0)
					{
						balanceAmt=Double.parseDouble(listReceipt.get(0).toString());
						if(objBillHdModel.getDblGrandTotal()-balanceAmt-objPaymentBean.getDblReceiptAmt()==0.0)
							objBillHdModel.setStrBillSettled("Y");
							
						else
							objBillHdModel.setStrBillSettled("N");
					}
					objBillHdModel.setStrRemark("");
					objBillHdModel.setStrMergedBillNo("");
					
					String sql1="select a.dblClosingBalance from tblguestmaster a where a.strGuestCode='"+guestCode+"' ";
					List guestlist = objGlobalFunctionsService.funGetListModuleWise(sql1, "sql");
					double balance=0.00;
 					if(guestlist!=null && guestlist.size()>0)
					{
 						balance=Double.parseDouble(guestlist.get(0).toString());
					}
				   
 					double amount1=balance + objPaymentBean.getDblPaidAmt();
					
 					double amount2=objBillHdModel.getDblGrandTotal()-balanceAmt-objPaymentBean.getDblReceiptAmt();
 					objBillHdModel.setDblOpeningBalance(amount1);
					objBillHdModel.setDblClosingBalance(amount2);
  					objBillService.funAddUpdateBillHd(objBillHdModel);
					
					
					String sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+amount2+"' where  a.strGuestCode='"+guestCode+"' ";
 					objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
				}
			}
		}
		
		

	    objModel.setDteReceiptDate(PMSDate);
		//objModel.setDteReceiptDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrCheckInNo(checkInNo);
		objModel.setStrBillNo(billNo);
		objModel.setStrRegistrationNo(registrationNo);
		objModel.setStrReservationNo(reservationNo);
		objModel.setStrFolioNo(folioNo);
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		objModel.setStrFlagOfAdvAmt(objPaymentBean.getStrFlagOfAdvAmt());
		objModel.setStrType("Payment");

		List<clsPMSPaymentReceiptDtl> listPaymentReceiptDtlModel = new ArrayList<clsPMSPaymentReceiptDtl>();
		clsPMSPaymentReceiptDtl objPaymentReceiptDtlModel = new clsPMSPaymentReceiptDtl();
		objPaymentReceiptDtlModel.setDblSettlementAmt(objPaymentBean.getDblReceiptAmt());

		String[] newDate = objPaymentBean.getDteExpiryDate().split("-");
		if (newDate[0].length() >= 3) {
			objPaymentReceiptDtlModel.setDteExpiryDate(objPaymentBean.getDteExpiryDate());
		} else {
			objPaymentReceiptDtlModel.setDteExpiryDate(objGlobal.funGetDate("yyyy/MM/dd", objPaymentBean.getDteExpiryDate()));
		}
		objPaymentReceiptDtlModel.setStrCardNo(objPaymentBean.getStrCardNo());
		objPaymentReceiptDtlModel.setStrRemarks(objPaymentBean.getStrRemarks());
		objPaymentReceiptDtlModel.setStrSettlementCode(objPaymentBean.getStrSettlementCode());
		objPaymentReceiptDtlModel.setStrCustomerCode(objPaymentBean.getStrCustomerCode());
		listPaymentReceiptDtlModel.add(objPaymentReceiptDtlModel);

		objModel.setListPaymentRecieptDtlModel(listPaymentReceiptDtlModel);
		return objModel;
	}
}
