package com.sanguine.webpms.service;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webclub.model.clsWebClubMemberPhotoModel;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.dao.clsGuestMasterDao;
import com.sanguine.webpms.model.clsGuestMasterHdModel;

@Service("objGuestMasterService")
public class clsGuestMasterServiceImpl implements clsGuestMasterService {
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsGuestMasterDao objGuestMasterDao;

	@Autowired
	private ServletContext servletContext;
	
	@Override
	public clsGuestMasterHdModel funPrepareGuestModel(clsGuestMasterBean objGuestMasterBean, String clientCode, String userCode,MultipartFile file) {
		clsGuestMasterHdModel objGuestMasterModel = new clsGuestMasterHdModel();
		long lastNo = 0;
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		// String formName="";
		String sql = "select strGuestCode from tblguestmaster where lngMobileNo='" + objGuestMasterBean.getIntMobileNo() + "' ";
		List list = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");

		if (objGuestMasterBean.getStrGuestCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetPMSMasterLastNo("tblguestmaster", "GuestMaster", "strGuestCode", clientCode);
			String guestCode = "GT" + String.format("%06d", lastNo);
			objGuestMasterModel.setStrGuestCode(guestCode);
			objGuestMasterModel.setStrUserCreated(userCode);
			objGuestMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			objGuestMasterModel.setStrGuestCode(objGuestMasterBean.getStrGuestCode());
			objGuestMasterModel.setStrUserCreated(userCode);
			objGuestMasterModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		}

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
		
		objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportExpiryDate(),"",objGuestMasterBean.getDtePassportExpiryDate()));
	   
		if(objGuestMasterModel.getDtePassportExpiryDate().length()>0)
		{
			objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDtePassportExpiryDate()));
		}
		
		objGuestMasterModel.setDtePassportIssueDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportIssueDate(),"",objGuestMasterBean.getDtePassportIssueDate()));
		
		if(objGuestMasterBean.getDtePassportIssueDate().length()>0)
		{
			objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funGetDate("yyyy-MM-dd", objGuestMasterBean.getDtePassportIssueDate()));
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
		objGuestMasterModel.setStrExternalID((objGlobal.funIfNull(objGuestMasterBean.getStrExternalID()," ",objGuestMasterBean.getStrExternalID())));
		objGuestMasterModel.setStrRemark((objGlobal.funIfNull(objGuestMasterBean.getStrRemark()," ",objGuestMasterBean.getStrRemark())));
        
		objGuestMasterModel.setDblClosingBalance(0.00);   
		
		// objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportExpiryDate(),"1900-01-01",objGuestMasterBean.getDtePassportExpiryDate()));
		// objGuestMasterModel.setDtePassportIssueDate(objGlobal.funIfNull(objGuestMasterBean.getDtePassportIssueDate(),"1900-01-01",objGuestMasterBean.getDtePassportIssueDate()));
		objGuestMasterModel.setStrClientCode(clientCode);

		return objGuestMasterModel;
	}

	
	
	@SuppressWarnings("finally")
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
