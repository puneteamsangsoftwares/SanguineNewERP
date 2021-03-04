package com.sanguine.webpms.service;

import javax.servlet.http.HttpServletRequest;

import com.sanguine.webbooks.model.clsPaymentHdModel;
import com.sanguine.webpms.bean.clsPMSPaymentBean;
import com.sanguine.webpms.bean.clsRefundBean;
import com.sanguine.webpms.bean.clsWalkinBean;
import com.sanguine.webpms.model.clsPMSPaymentHdModel;
import com.sanguine.webpms.model.clsWalkinHdModel;

public interface clsRefundService {

	public void funAddUpdatePaymentHd(clsPMSPaymentHdModel objHdModel);

	public clsPMSPaymentHdModel funPrepareRefundModel(clsRefundBean objRefundBean, String clientCode, HttpServletRequest request, String userCode);

}
