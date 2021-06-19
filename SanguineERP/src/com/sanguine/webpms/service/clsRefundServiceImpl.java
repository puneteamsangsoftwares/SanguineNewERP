package com.sanguine.webpms.service;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsPMSPaymentBean;
import com.sanguine.webpms.bean.clsRefundBean;
import com.sanguine.webpms.dao.clsPMSPaymentDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsBillHdModel;
import com.sanguine.webpms.model.clsPMSPaymentHdModel;
import com.sanguine.webpms.model.clsPMSPaymentReceiptDtl;

@Service("clsRefundService")
public class clsRefundServiceImpl implements clsRefundService {

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
	public clsPMSPaymentHdModel funPrepareRefundModel(clsRefundBean objRefundBean, String clientCode, HttpServletRequest request, String userCode) {
		String reservationNo = "";
		String registrationNo = "";
		String folioNo = "";
		String checkInNo = "";
		String billNo =objGlobal.funIfNull(objRefundBean.getStrDocNo(), "", objRefundBean.getStrDocNo());
		//String PMSDate = objGlobal.funGetDate("yyyy-MM-dd", request.getSession().getAttribute("PMSDate").toString());
		

		clsPMSPaymentHdModel objModel = new clsPMSPaymentHdModel();

		if (objRefundBean.getStrReceiptNo().isEmpty()) {
			String transaDate = objGlobal.funGetCurrentDateTime("dd-MM-yyyy").split(" ")[0];
			String documentNo = objGlobal.funGeneratePMSDocumentCode("frmRefund", transaDate, request);
			objModel.setStrReceiptNo(documentNo);
			objModel.setStrUserCreated(userCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objModel.setStrReceiptNo(objRefundBean.getStrReceiptNo());
		}
		objModel.setStrAgainst(objRefundBean.getStrAgainst());
		objModel.setDblPaidAmt(0.00);
		objModel.setDblReceiptAmt(-1 * objRefundBean.getDblReceiptAmt());
        objModel.setDteReceiptDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrCheckInNo(" ");
		objModel.setStrBillNo(billNo);
		objModel.setStrRegistrationNo(" ");
		objModel.setStrReservationNo(reservationNo);
		objModel.setStrFolioNo(" "); //Use For Receipt Type
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrClientCode(clientCode);
		objModel.setStrFlagOfAdvAmt(objRefundBean.getStrFlagOfAdvAmt());
		objModel.setStrType("Refund Amt");
		

		List<clsPMSPaymentReceiptDtl> listPaymentReceiptDtlModel = new ArrayList<clsPMSPaymentReceiptDtl>();
		clsPMSPaymentReceiptDtl objPaymentReceiptDtlModel = new clsPMSPaymentReceiptDtl();
		objPaymentReceiptDtlModel.setDblSettlementAmt(-1 * objRefundBean.getDblReceiptAmt());

		objPaymentReceiptDtlModel.setDteExpiryDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objPaymentReceiptDtlModel.setStrCardNo(objRefundBean.getStrCardNo());
		objPaymentReceiptDtlModel.setStrRemarks(objRefundBean.getStrRemarks());
		objPaymentReceiptDtlModel.setStrSettlementCode(objRefundBean.getStrSettlementCode());
		objPaymentReceiptDtlModel.setStrCustomerCode(objRefundBean.getStrCustomerCode());
		listPaymentReceiptDtlModel.add(objPaymentReceiptDtlModel);
		
		String sql="select a.dblClosingBalance from tblguestmaster a where  a.strGuestCode='"+objRefundBean.getStrCustomerCode()+"'";
		List guestlist = objGlobalFunctionsService.funGetDataList(sql, "sql");
		double balance=0.00;
		if(guestlist!=null && guestlist.size()>0)
		{
			balance=Double.parseDouble(guestlist.get(0).toString());
		}
		    
	/*	double amount1=balance+objRefundBean.getDblReceiptAmt();
		String sqlguest=" update tblguestmaster a set a.dblClosingBalance='"+amount1+"' where a.strGuestCode='"+objRefundBean.getStrCustomerCode()+ "' ";
		objWebPMSUtility.funExecuteUpdate(sqlguest, "sql");
		
		clsBillHdModel objBillHdModel = objBillService.funLoadBill(billNo, clientCode);
		
		objBillHdModel.setDblOpeningBalance(amount1);
		objBillHdModel.setDblClosingBalance(objRefundBean.getDblReceiptAmt());
		objBillService.funAddUpdateBillHd(objBillHdModel);
*/
		objModel.setListPaymentRecieptDtlModel(listPaymentReceiptDtlModel);
		return objModel;
	}
}
