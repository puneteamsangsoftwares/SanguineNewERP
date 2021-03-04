package com.sanguine.webpms.service;

import com.sanguine.webpms.bean.clsPMSReasonMasterBean;
import com.sanguine.webpms.model.clsPMSReasonMasterModel;

public interface clsPMSReasonMasterService {

	public clsPMSReasonMasterModel funPrepareReasonModel(clsPMSReasonMasterBean objReasonMasterBean, String clientCode, String userCode);

}
