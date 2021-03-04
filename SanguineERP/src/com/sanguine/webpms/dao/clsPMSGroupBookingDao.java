package com.sanguine.webpms.dao;

import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;

public interface clsPMSGroupBookingDao{

	public void funAddUpdatePMSGroupBooking(clsPMSGroupBookingHDModel objMaster);

	public clsPMSGroupBookingHDModel funGetPMSGroupBooking(String docCode,String clientCode);

}
