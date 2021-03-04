package com.sanguine.webpms.controller;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.swing.ImageIcon;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpms.bean.clsFillMastrerBean;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.bean.clsPropertySetupBean;
import com.sanguine.webpms.bean.clsRoomMasterBean;
import com.sanguine.webpms.bean.clsRoomTypeMasterBean;
import com.sanguine.webpms.dao.clsGuestMasterDao;
import com.sanguine.webpms.dao.clsRoomTypeMasterDao;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsRoomMasterModel;
import com.sanguine.webpms.model.clsRoomMasterModel_ID;
import com.sanguine.webpms.model.clsRoomTypeMasterModel;
import com.sanguine.webpms.service.clsRoomMasterService;

@Controller
public class clsFillPMSMastersController {
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	@Autowired
	private clsRoomTypeMasterDao objRoomTypeMasterDao;
	@Autowired
	private clsRoomMasterService objRoomMasterService;
	@Autowired
	private clsGlobalFunctions objGlobal;
	@Autowired
	private clsGuestMasterDao objGuestMasterDao;
	@Autowired
	private ServletContext servletContext;

	@RequestMapping(value = "/frmPMSFillMasters", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		
		List<clsRoomTypeMasterBean> listRoomTypeMaster = new ArrayList<clsRoomTypeMasterBean>();
		
		clsRoomTypeMasterBean objRoomTypeMasterBean = null;
		
		String[] arr = {"Single Room","Double Room","Tripple Room"};
		for(int i=0;i<arr.length;i++)
		{
			objRoomTypeMasterBean = new clsRoomTypeMasterBean();
			objRoomTypeMasterBean.setStrRoomTypeDesc(arr[i]);
			
			listRoomTypeMaster.add(objRoomTypeMasterBean);
		}
		
		model.put("listRoomTypeMaster", listRoomTypeMaster);
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSFillMasters_1", "command", new clsRoomTypeMasterModel());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPMSFillMasters", "command", new clsRoomTypeMasterModel());
		} else {
			return null;
		}
	}
	
	
	@RequestMapping(value = "/saveFillMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsFillMastrerBean objBean, BindingResult result, HttpServletRequest req) {
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		
		if (!result.hasErrors()) {
			String propertyCode = req.getSession().getAttribute("propertyCode").toString();
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			req.getSession().setAttribute("success", true);
			for(clsRoomTypeMasterBean obj:objBean.getListRoomTypeMaster())
			{
				if(obj.getDblRoomTerrif()>0)
				{
					clsRoomTypeMasterModel objModel = funPrepareModel(obj, clientCode, userCode);
					objRoomTypeMasterDao.funAddUpdateRoomMaster(objModel);
				}
				
			}
			
			if(objBean.getListRoomMaster()!=null){
			
				for(clsRoomMasterBean obj:objBean.getListRoomMaster())
				{
					if(!obj.getStrRoomTypeDesc().equals(""))
					{
						clsRoomMasterModel objModel = funPrepareRoomMasterModel(obj, userCode, clientCode, propertyCode);
						objRoomMasterService.funAddUpdateRoomMaster(objModel);

					}
					
				}

			}
			if(objBean.getListGuestMaster()!=null)
			{
			MultipartFile file = null;
			for(clsGuestMasterBean obj:objBean.getListGuestMaster())
			{
				if(!obj.getStrFirstName().equals(""))
				{
					clsGuestMasterHdModel objModel = funPrepareGuestModel(obj, clientCode, userCode,file);
					objGuestMasterDao.funAddUpdateGuestMaster(objModel);

				}
				
			}
			}

/*			req.getSession().setAttribute("successMessage", "Property Code. : ".concat());
*/			return new ModelAndView("redirect:/frmPMSFillMasters.html?saddr=" + urlHits);
		} else {
			return new ModelAndView("frmPMSFillMasters?saddr=" + urlHits);
		}
	}

	clsRoomTypeMasterModel objRoomTypeMasterModel;
	private clsRoomTypeMasterModel funPrepareModel(clsRoomTypeMasterBean objBean,
			String clientCode, String userCode) {
		objRoomTypeMasterModel = new clsRoomTypeMasterModel();
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		long lastNo = 0;

		if (objBean.getStrRoomTypeCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblroomtypemaster", "RoomTypeMaster", "strRoomTypeCode", clientCode);
			String roomTypeCode = "RT" + String.format("%06d", lastNo);
			// String deptCode="D0000001";
			objRoomTypeMasterModel.setStrRoomTypeCode(roomTypeCode);
			objRoomTypeMasterModel.setStrUserCreated(userCode);
			objRoomTypeMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objRoomTypeMasterModel.setStrRoomTypeCode(objBean.getStrRoomTypeCode());

		}

		objRoomTypeMasterModel.setStrRoomTypeDesc(objBean.getStrRoomTypeDesc());
		objRoomTypeMasterModel.setDblRoomTerrif(objBean.getDblRoomTerrif()); 
		objRoomTypeMasterModel.setDblDoubleTariff(objBean.getDblDoubleTariff());
		objRoomTypeMasterModel.setDblTrippleTariff(objBean.getDblTrippleTariff());
		objRoomTypeMasterModel.setStrUserEdited(userCode);
		objRoomTypeMasterModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objRoomTypeMasterModel.setStrClientCode(clientCode);
		objRoomTypeMasterModel.setStrHsnSac("");
		objRoomTypeMasterModel.setStrGuestCapcity(objBean.getStrGuestCapcity());

		return objRoomTypeMasterModel;

	}

	private clsRoomMasterModel funPrepareRoomMasterModel(clsRoomMasterBean objBean, String userCode, String clientCode, String propertyCode) {
		long lastNo = 0;
		clsRoomMasterModel objModel;
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblroom", "RoomMaster", "strRoomCode", clientCode);
			String roomCode = "RC" + String.format("%06d", lastNo);
			objModel = new clsRoomMasterModel(new clsRoomMasterModel_ID(roomCode, clientCode));
		
		objModel.setStrRoomDesc(objBean.getStrRoomDesc());
		objModel.setStrRoomTypeCode(objBean.getStrRoomType());
		objModel.setStrFloorCode(objGlobal.funIfNull(objBean.getStrFloorCode(), "", objBean.getStrFloorCode()));
		objModel.setStrBedType(objGlobal.funIfNull(objBean.getStrBedType(), "", objBean.getStrBedType()));
		objModel.setStrFurniture(objGlobal.funIfNull(objBean.getStrFurniture(), "", objBean.getStrFurniture()));
		objModel.setStrExtraBedCode(objGlobal.funIfNull(objBean.getStrExtraBed(), "", objBean.getStrExtraBed()));
		objModel.setStrUpholstery(objGlobal.funIfNull(objBean.getStrUpholstery(), "", objBean.getStrUpholstery()));
		objModel.setStrLocation(objGlobal.funIfNull(objBean.getStrLocation(), "", objBean.getStrLocation()));
		objModel.setStrBathTypeCode(objGlobal.funIfNull(objBean.getStrBathTypeCode(), "", objBean.getStrBathTypeCode()));
		objModel.setStrColorScheme(objGlobal.funIfNull(objBean.getStrColourScheme(), "", objBean.getStrColourScheme()));
		objModel.setStrPolishType(objGlobal.funIfNull(objBean.getStrPolishType(), "", objBean.getStrPolishType()));
		objModel.setStrGuestAmenities(objGlobal.funIfNull(objBean.getStrGuestAmenities(), "", objBean.getStrGuestAmenities()));
		objModel.setStrInterConnectRooms(objGlobal.funIfNull(objBean.getStrInterConnectRooms(), "", objBean.getStrInterConnectRooms()));
		objModel.setStrProvisionForSmokingYN(objBean.getStrProvisionForSmokingYN());
		objModel.setStrDeactiveYN(objBean.getStrDeactiveYN());
		objModel.setStrUserCreated(userCode);
		objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrUserEdited(userCode);
		objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrStatus("Free");
		objModel.setStrAccountCode(objBean.getStrAccountCode());
		objModel.setStrRoomTypeDesc(objBean.getStrRoomTypeDesc());

		return objModel;
	}
	
	public clsGuestMasterHdModel funPrepareGuestModel(clsGuestMasterBean objGuestMasterBean, String clientCode, String userCode,MultipartFile file) {
		clsGuestMasterHdModel objGuestMasterModel = new clsGuestMasterHdModel();
		long lastNo = 0;
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		// String formName="";
		String sql = "select strGuestCode from tblguestmaster where lngMobileNo='" + objGuestMasterBean.getIntMobileNo() + "' ";
		List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

		
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblguestmaster", "GuestMaster", "strGuestCode", clientCode);
			String guestCode = "GT" + String.format("%06d", lastNo);
			objGuestMasterModel.setStrGuestCode(guestCode);
			objGuestMasterModel.setStrUserCreated(userCode);
			objGuestMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		

		objGuestMasterModel.setStrGuestPrefix(objGuestMasterBean.getStrGuestPrefix());
		objGuestMasterModel.setStrFirstName(objGuestMasterBean.getStrFirstName());
		objGuestMasterModel.setStrMiddleName(objGuestMasterBean.getStrMiddleName());
		objGuestMasterModel.setStrLastName(objGuestMasterBean.getStrLastName());
		objGuestMasterModel.setStrGender(objGlobal.funIfNull(objGuestMasterBean.getStrGender(), "M", objGuestMasterBean.getStrGender()));
		objGuestMasterModel.setStrDesignation(objGlobal.funIfNull(objGuestMasterBean.getStrDesignation(), "NA", objGuestMasterBean.getStrDesignation()));
		if (null == objGuestMasterBean.getDteDOB()) {
			objGuestMasterModel.setDteDOB("1900-01-01");
		} else {
			
			objGuestMasterModel.setDteDOB(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDteDOB()));
			
		}

		if (file!=null && file.getSize() != 0) {
			System.out.println(file.getOriginalFilename());
			File imgFolder = new File(System.getProperty("user.dir") + "\\ProductIcon");
			if (!imgFolder.exists()) {
				if (imgFolder.mkdir()) {
					System.out.println("Directory is created! " + imgFolder.getAbsolutePath());
				} else {
					System.out.println("Failed to create directory!");
				}
			}
			
			try {
			File fileImageIcon = new File(System.getProperty("user.dir") + "\\ProductIcon\\" + file.getOriginalFilename());
			String formatName = "jpg";
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			BufferedImage bufferedImage = ImageIO.read(funInputStreamToBytearrayInputStrean(file.getInputStream()));
			String path = fileImageIcon.getPath().toString();			
			ImageIO.write(bufferedImage, "jpg", new File(path));			
			BufferedImage bfImg = scaleImage(150, 155, path);
			ImageIO.write(bfImg, "jpg", byteArrayOutputStream);
			byte[] imageBytes = byteArrayOutputStream.toByteArray();
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
			
				if (fileImageIcon.exists()) {
					fileImageIcon.delete();
					objGuestMasterModel.setStrGuestImage(imageBytes);
				}
				else {
					//objModel.setStrMemberImage(funBlankBlob());
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			String imagePath = servletContext.getRealPath("/resources/images/NoImageAlternate.png");
			

			/*System.out.println(file.getOriginalFilename());*/
			File imgFolder = new File(imagePath);
			if (!imgFolder.exists()) {
				if (imgFolder.mkdir()) {
					System.out.println("Directory is created! " + imgFolder.getAbsolutePath());
				} else {
					System.out.println("Failed to create directory!");
				}
			}
			
			try {
				if(file!=null){
			File fileImageIcon = new File(System.getProperty("user.dir") + "\\ProductIcon\\" + file.getOriginalFilename());
			String formatName = "jpg";
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			BufferedImage bufferedImage = ImageIO.read(funInputStreamToBytearrayInputStrean(file.getInputStream()));
			String path = fileImageIcon.getPath().toString();	
			
			if(bufferedImage!=null)
			{
				ImageIO.write(bufferedImage, "jpg", new File(imagePath));	
			}
				
			
					
			BufferedImage bfImg = scaleImage(150, 155, imagePath);
			ImageIO.write(bfImg, "jpg", byteArrayOutputStream);
			byte[] imageBytes = byteArrayOutputStream.toByteArray();
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
			
				if (fileImageIcon.exists()) {
					fileImageIcon.delete();
					objGuestMasterModel.setStrGuestImage(imageBytes);
				}
				}
				else {
					//objModel.setStrMemberImage(funBlankBlob());
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
			//image code end 
		
		
		// objGuestMasterModel.setDteDOB(objGlobal.funIfNull(objGuestMasterBean.getDteDOB(),"1900-01-01",objGuestMasterBean.getDteDOB()));
		objGuestMasterModel.setStrAddress(objGlobal.funIfNull(objGuestMasterBean.getStrAddress(), "NA", objGuestMasterBean.getStrAddress()));
		objGuestMasterModel.setStrCity(objGlobal.funIfNull(objGuestMasterBean.getStrCity(), "NA", objGuestMasterBean.getStrCity()));
		objGuestMasterModel.setStrState(objGlobal.funIfNull(objGuestMasterBean.getStrState(), "NA", objGuestMasterBean.getStrState()));
		objGuestMasterModel.setStrCountry(objGlobal.funIfNull(objGuestMasterBean.getStrCountry(), "NA", objGuestMasterBean.getStrCountry()));
		objGuestMasterModel.setStrNationality(objGlobal.funIfNull(objGuestMasterBean.getStrNationality(), "NA", objGuestMasterBean.getStrNationality()));
		objGuestMasterModel.setIntPinCode(objGuestMasterBean.getIntPinCode());
		objGuestMasterModel.setLngMobileNo(objGuestMasterBean.getIntMobileNo());
		objGuestMasterModel.setLngFaxNo(objGuestMasterBean.getIntFaxNo());
		objGuestMasterModel.setStrEmailId(objGlobal.funIfNull(objGuestMasterBean.getStrEmailId(), "NA", objGuestMasterBean.getStrEmailId()));
		objGuestMasterModel.setStrPANNo(objGlobal.funIfNull(objGuestMasterBean.getStrPANNo(), "NA", objGuestMasterBean.getStrPANNo()));
		objGuestMasterModel.setStrArrivalFrom(objGlobal.funIfNull(objGuestMasterBean.getStrArrivalFrom(), "NA", objGuestMasterBean.getStrArrivalFrom()));
		objGuestMasterModel.setStrProceedingTo(objGlobal.funIfNull(objGuestMasterBean.getStrProceedingTo(), "NA", objGuestMasterBean.getStrProceedingTo()));
		objGuestMasterModel.setStrStatus(objGlobal.funIfNull(objGuestMasterBean.getStrStatus(), "NA", objGuestMasterBean.getStrStatus()));
		objGuestMasterModel.setStrVisitingType(objGlobal.funIfNull(objGuestMasterBean.getStrVisitingType(), "NA", objGuestMasterBean.getStrVisitingType()));
		objGuestMasterModel.setStrCorporate(objGlobal.funIfNull(objGuestMasterBean.getStrCorporate(), "N", objGuestMasterBean.getStrCorporate()));
		objGuestMasterModel.setStrPassportNo(objGlobal.funIfNull(objGuestMasterBean.getStrPassportNo(), "NA", objGuestMasterBean.getStrPassportNo()));
		objGuestMasterModel.setStrUserEdited(userCode);
		objGuestMasterModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objGuestMasterModel.setStrProceedingTo(objGlobal.funIfNull(objGuestMasterBean.getStrProceedingTo(), "NA", objGuestMasterBean.getStrProceedingTo()));

		if (null == objGuestMasterBean.getDtePassportExpiryDate()) {
			objGuestMasterModel.setDtePassportExpiryDate("1900-01-01");
		} else {
			objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDtePassportExpiryDate()));
		}

		if (null == objGuestMasterBean.getDtePassportIssueDate()) {
			objGuestMasterModel.setDtePassportIssueDate("1900-01-01");
		} else {
			objGuestMasterModel.setDtePassportIssueDate(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDtePassportIssueDate()));
		}

		objGuestMasterModel.setStrGSTNo(objGuestMasterBean.getStrGSTNo());
		objGuestMasterModel.setStrUIDNo(objGuestMasterBean.getStrUIDNo());
		
		if (null == objGuestMasterBean.getDteAnniversaryDate()) {
			objGuestMasterModel.setDteAnniversaryDate("1900-01-01");
		} else {
			objGuestMasterModel.setDteAnniversaryDate(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDteAnniversaryDate()));
		}
		
		objGuestMasterModel.setStrDefaultAddr(objGuestMasterBean.getStrDefaultAddr());
		
		objGuestMasterModel.setStrAddressLocal(objGuestMasterBean.getStrAddressLocal());
		objGuestMasterModel.setStrCityLocal(objGuestMasterBean.getStrCityLocal());
		objGuestMasterModel.setStrStateLocal(objGuestMasterBean.getStrStateLocal());
		objGuestMasterModel.setStrCountryLocal(objGuestMasterBean.getStrCountryLocal());
		objGuestMasterModel.setIntPinCodeLocal(objGuestMasterBean.getIntPinCodeLocal());
		
		objGuestMasterModel.setStrAddrPermanent(objGuestMasterBean.getStrAddrPermanent());
		objGuestMasterModel.setStrCityPermanent(objGuestMasterBean.getStrCityPermanent());
		objGuestMasterModel.setStrStatePermanent(objGuestMasterBean.getStrStatePermanent());
		objGuestMasterModel.setStrCountryPermanent(objGuestMasterBean.getStrCountryPermanent());
		objGuestMasterModel.setIntPinCodePermanent(objGuestMasterBean.getIntPinCodePermanent());
		
		objGuestMasterModel.setStrAddressOfc(objGuestMasterBean.getStrAddressOfc());
		objGuestMasterModel.setStrCityOfc(objGuestMasterBean.getStrCityOfc());
		objGuestMasterModel.setStrStateOfc(objGuestMasterBean.getStrStateOfc());
		objGuestMasterModel.setStrCountryOfc(objGuestMasterBean.getStrCountryOfc());
		objGuestMasterModel.setIntPinCodeOfc(objGuestMasterBean.getIntPinCodeOfc());

		// objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportExpiryDate(),"1900-01-01",objGuestMasterBean.getDtePassportExpiryDate()));
		// objGuestMasterModel.setDtePassportIssueDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportIssueDate(),"1900-01-01",objGuestMasterBean.getDtePassportIssueDate()));
		objGuestMasterModel.setStrClientCode(clientCode);

		return objGuestMasterModel;
	}
	
	private ByteArrayInputStream funInputStreamToBytearrayInputStrean(InputStream ins) {
		ByteArrayInputStream byteArrayInputStream = null;
		try {
			byte[] buff = new byte[8000];

			int bytesRead = 0;

			ByteArrayOutputStream bao = new ByteArrayOutputStream();

			while ((bytesRead = ins.read(buff)) != -1) {
				bao.write(buff, 0, bytesRead);
			}

			byte[] data = bao.toByteArray();

			byteArrayInputStream = new ByteArrayInputStream(data);

		} catch (Exception ex) {
			ex.printStackTrace();

		} finally {
			return byteArrayInputStream;
		}
	}
	
	public BufferedImage scaleImage(int WIDTH, int HEIGHT, String filename) {
		BufferedImage bi = null;
		try {
			ImageIcon ii = new ImageIcon(filename);// path to image
			bi = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
			Graphics2D gra2d = (Graphics2D) bi.createGraphics();
			gra2d.addRenderingHints(new RenderingHints(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY));
			gra2d.drawImage(ii.getImage(), 0, 0, WIDTH, HEIGHT, null);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return bi;
	}
	

	public List funGetGuestMaster(String guestCode, String clientCode) {
		return objGuestMasterDao.funGetGuestMaster(guestCode, clientCode);
	}
}
