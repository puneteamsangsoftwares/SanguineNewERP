package com.sanguine.webpms.dao;

import com.sanguine.webbooks.model.clsPaymentHdModel;
import com.sanguine.webpms.model.clsPMSPaymentHdModel;
import com.sanguine.webpms.model.clsPMSPaymentReceiptDtl;

public interface clsRefundDao {

	public void funAddUpdatePaymentHd(clsPMSPaymentHdModel objHdModel);

	public clsPMSPaymentHdModel funGetPaymentModel(String receiptNo, String clientCode);
}
