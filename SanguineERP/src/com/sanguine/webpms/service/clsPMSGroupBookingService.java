package com.sanguine.webpms.service;

import com.sanguine.webpms.model.clsPMSGroupBookingHDModel;

public interface clsPMSGroupBookingService{

	public void funAddUpdatePMSGroupBooking(clsPMSGroupBookingHDModel objMaster);

	public clsPMSGroupBookingHDModel funGetPMSGroupBooking(String docCode,String clientCode);

}
