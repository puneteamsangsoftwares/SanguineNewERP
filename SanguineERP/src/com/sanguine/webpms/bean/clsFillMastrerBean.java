package com.sanguine.webpms.bean;

import java.util.List;

import com.sanguine.webpms.model.clsRoomMasterModel;

public class clsFillMastrerBean {
	
	private List<clsRoomTypeMasterBean> listRoomTypeMaster;
	
	private List<clsRoomMasterBean> listRoomMaster;
	
	private List<clsGuestMasterBean> listGuestMaster;

	public List<clsRoomTypeMasterBean> getListRoomTypeMaster() {
		return listRoomTypeMaster;
	}

	public void setListRoomTypeMaster(List<clsRoomTypeMasterBean> listRoomTypeMaster) {
		this.listRoomTypeMaster = listRoomTypeMaster;
	}

	public List<clsRoomMasterBean> getListRoomMaster() {
		return listRoomMaster;
	}

	public void setListRoomMaster(List<clsRoomMasterBean> listRoomMaster) {
		this.listRoomMaster = listRoomMaster;
	}

	public List<clsGuestMasterBean> getListGuestMaster() {
		return listGuestMaster;
	}

	public void setListGuestMaster(List<clsGuestMasterBean> listGuestMaster) {
		this.listGuestMaster = listGuestMaster;
	}

	

	

}
