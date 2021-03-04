package com.sanguine.webpms.controller;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;
import javax.validation.Valid;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webpms.bean.clsGuestMasterBean;
import com.sanguine.webpms.dao.clsGuestMasterDao;
import com.sanguine.webpms.dao.clsWebPMSDBUtilityDao;
import com.sanguine.webpms.model.clsGuestMasterHdModel;
import com.sanguine.webpms.model.clsPropertySetupHdModel;
import com.sanguine.webpms.service.clsGuestMasterService;
import com.sanguine.webpms.service.clsPropertySetupService;

@Controller
public class clsGuestMasterController {
	@Autowired
	private clsGuestMasterService objGuestMasterService;

	@Autowired
	private clsGuestMasterDao objGuestMasterDao;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;
	
	@Autowired
	private clsWebPMSDBUtilityDao objWebPMSUtility;

	@Autowired
	private clsPropertySetupService objPropertySetupService;


	// Open GuestMaster
	@RequestMapping(value = "/frmGuestMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String clientCode = request.getSession().getAttribute("clientCode").toString();
		String urlHits = "1";

		List<String> listPrefix = new ArrayList<>();
		listPrefix.add("Mr.");
		listPrefix.add("Mrs.");
		listPrefix.add("Both");
		model.put("prefix", listPrefix);

		List<String> listGender = new ArrayList<>();
		listGender.add("M");
		listGender.add("F");
		model.put("gender", listGender);
//WebStockDB
		String webStockDB=request.getSession().getAttribute("WebStockDB").toString();
		String sql = "select strCityName from "+webStockDB+".tblcitymaster where strClientCode='" + clientCode + "'";
		List list = objGlobalFunctionsService.funGetList(sql, "sql");
		List<String> listCity = new ArrayList<>();
		for (int cnt = 0; cnt < list.size(); cnt++) {
			listCity.add(list.get(cnt).toString());
		}
		model.put("listCity", listCity);

		sql = "select strStateName from "+webStockDB+".tblstatemaster where strClientCode='" + clientCode + "'";
		List listStateDetails = objGlobalFunctionsService.funGetList(sql, "sql");
		List<String> listState = new ArrayList<>();
		for (int cnt = 0; cnt < listStateDetails.size(); cnt++) {
			listState.add(listStateDetails.get(cnt).toString());
		}
		model.put("listState", listState);

		sql = "select strCountryName from "+webStockDB+".tblcountrymaster where strClientCode='" + clientCode + "'";
		List listCountryDetails = objGlobalFunctionsService.funGetList(sql, "sql");
		List<String> listCountry = new ArrayList<>();
		for (int cnt = 0; cnt < listCountryDetails.size(); cnt++) {
			listCountry.add(listCountryDetails.get(cnt).toString());
		}
		model.put("listCountry", listCountry);

		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		if (urlHits.equalsIgnoreCase("1")) {
			return new ModelAndView("frmGuestMaster", "command", new clsGuestMasterBean());
		} else {
			return new ModelAndView("frmGuestMaster_1", "command", new clsGuestMasterBean());
		}
	}

	// Save or Update GuestMaster
	@RequestMapping(value = "/saveGuestMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdateGuestMaster(@ModelAttribute("command") @Valid clsGuestMasterBean objBean, BindingResult result, HttpServletRequest req, @RequestParam("memberImage") MultipartFile file) {
		if (!result.hasErrors()) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();
			String userCode = req.getSession().getAttribute("usercode").toString();
			clsGuestMasterHdModel objModel = objGuestMasterService.funPrepareGuestModel(objBean, clientCode, userCode,file);
			objGuestMasterDao.funAddUpdateGuestMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Guest Code : ".concat(objModel.getStrGuestCode()));
			req.getSession().setAttribute("GuestDetails", objModel.getStrGuestCode()+"#"+objModel.getStrFirstName()+" "+objModel.getStrLastName()+"#"+objModel.getLngMobileNo());
			return new ModelAndView("redirect:/frmGuestMaster.html");
		} else {
			return new ModelAndView("frmGuestMaster");
		}
	}

	// Load data from database to form
	@RequestMapping(value = "/loadGuestCode", method = RequestMethod.GET)
	public @ResponseBody clsGuestMasterHdModel funFetchGuestMasterData(@RequestParam("guestCode") String guestCode, HttpServletRequest req) {
		clsGlobalFunctions objGlobal = new clsGlobalFunctions();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		List listGuestData = objGuestMasterDao.funGetGuestMaster(guestCode, clientCode);
		clsGuestMasterHdModel objGuestMasterModel = (clsGuestMasterHdModel) listGuestData.get(0);
		objGuestMasterModel.setDteDOB(objGlobal.funGetDate("dd-MM-yyyy", objGuestMasterModel.getDteDOB()));
		objGuestMasterModel.setDtePassportExpiryDate(objGlobal.funGetDate("dd-MM-yyyy", objGuestMasterModel.getDtePassportExpiryDate()));
		objGuestMasterModel.setDtePassportIssueDate(objGlobal.funGetDate("dd-MM-yyyy", objGuestMasterModel.getDtePassportIssueDate()));
		objGuestMasterModel.setDteAnniversaryDate(objGlobal.funGetDate("dd-MM-yyyy", objGuestMasterModel.getDteAnniversaryDate()));

		return objGuestMasterModel;
	}
	@RequestMapping(value = "/checkGuestMobileNo", method = RequestMethod.GET)
	public @ResponseBody int funCheckGuestMobileNo(@RequestParam("mobileNo") String mobileNo, HttpServletRequest req) {
	
		clsGuestMasterHdModel objGuestMasterModel= new clsGuestMasterHdModel();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsGuestMasterBean objGuestMasterBean = new clsGuestMasterBean();
		objGuestMasterBean.setIntMobileNo(objGuestMasterModel.getLngMobileNo());
		String sql = "";
		int retunVal=0;
		sql = "select count(1) from tblguestmaster a where a.lngMobileNo='" + mobileNo + "' AND a.strClientCode='"+clientCode+"'";
		List listGuestMaster = objGlobalFunctionsService.funGetListModuleWise(sql, "sql");
		if(!listGuestMaster.isEmpty())
		{
			BigInteger bigintVal = (BigInteger) listGuestMaster.get(0);
			retunVal =bigintVal.intValue();
		}
		return retunVal;
	}
	


	//loadMembProfileImage
		@SuppressWarnings("resource")
		@RequestMapping(value = "/loadGuestImage", method = RequestMethod.GET)
		public void getImage(@RequestParam("guestCode") String guestCode, HttpServletRequest req, HttpServletResponse response) {
			String clientCode = req.getSession().getAttribute("clientCode").toString();			
			List listGuestData = objGuestMasterDao.funGetGuestMaster(guestCode, clientCode);
			clsGuestMasterHdModel objGuestMasterModel = (clsGuestMasterHdModel) listGuestData.get(0);
		
			try {
				//Blob image = null;
				byte[] imgData = null;
					imgData =objGuestMasterModel.getStrGuestImage();
					response.setContentType("image/jpeg, image/jpg, image/png, image/gif");
					OutputStream o = response.getOutputStream();
					o.write(imgData);
					o.flush();
					o.close();
				//}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		@RequestMapping(value = "/frmGuestImageChange", method = RequestMethod.GET)
		public ModelAndView funOpenForm(HttpServletRequest request,@RequestParam("guestCode") String guestCode,@RequestParam("code") String code) {
			//String exportUOM = request.getParameter("exportUOM");
			//request.getSession().removeAttribute("exportUOM");
			String propertyCode = request.getSession().getAttribute("propertyCode").toString();
			String clientCode = request.getSession().getAttribute("clientCode").toString();
			request.getSession().setAttribute("guestCode", guestCode);
			request.getSession().setAttribute("code", code);
			String strFormName = "";
			clsPropertySetupHdModel objSetup = objPropertySetupService.funGetPropertySetup(propertyCode, clientCode);

			if(objSetup.getStrEnableWebCam().equals("Y"))
			{
				strFormName = "frmCaptureImage";
			}
			else
			{
				strFormName = "frmGuestImageChange";
			}
			return new ModelAndView(strFormName);
			
		}
		
		
		@SuppressWarnings({ "rawtypes" })
		@RequestMapping(value = "/ChangeGuestImage", method = RequestMethod.POST)
		public @ResponseBody List upload(@RequestParam("file") MultipartFile file, HttpServletRequest request, HttpServletResponse res) throws Exception {
			List list = new ArrayList<>();
			String guestCode = request.getSession().getAttribute("guestCode").toString();
			request.getSession().removeAttribute("guestCode");
			/*String code = request.getSession().getAttribute("code").toString();
			request.getSession().removeAttribute("code");*/
			//String formname = request.getParameter("formname").toString();
			try {
			String clientCode = request.getSession().getAttribute("clientCode").toString();			
			List listGuestData = objGuestMasterDao.funGetGuestMaster(guestCode, clientCode);
			clsGuestMasterHdModel objGuestMasterModel = (clsGuestMasterHdModel) listGuestData.get(0);
			
			if (file.getSize() != 0) {
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
					e.printStackTrace();
				}
			}
			objGuestMasterDao.funAddUpdateGuestMaster(objGuestMasterModel);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			return list;
		}
		
		
				
		@SuppressWarnings("resource")
		@RequestMapping(value = "/loadImageForGuestMaster", method = RequestMethod.POST)
		public @ResponseBody List funLoadLocation(@RequestParam("file") MultipartFile file, HttpServletRequest request, HttpServletResponse res) {
			String clientCode = request.getSession().getAttribute("clientCode").toString();
			
			List list = new ArrayList<>();
			String guestCode = request.getSession().getAttribute("guestCode").toString();
			request.getSession().removeAttribute("guestCode");
			/*String code = request.getSession().getAttribute("code").toString();
			request.getSession().removeAttribute("code");*/
			//String formname = request.getParameter("formname").toString();
			try {
			List listGuestData = objGuestMasterDao.funGetGuestMaster(guestCode, clientCode);
			clsGuestMasterHdModel objGuestMasterModel = (clsGuestMasterHdModel) listGuestData.get(0);
			if (file.getSize() != 0) {
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
				File fileImageIcon = new File(System.getProperty("user.dir") + "\\ProductIcon\\" + objGuestMasterModel.getStrGuestCode()+".jpeg");
				String formatName = "jpg";
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				BufferedImage bufferedImage = ImageIO.read(funInputStreamToBytearrayInputStrean(file.getInputStream()));
				String path = fileImageIcon.getPath().toString();			
				ImageIO.write(bufferedImage, "jpeg", new File(path));			
				BufferedImage bfImg = scaleImage(150, 155, path);
				ImageIO.write(bfImg, "jpeg", byteArrayOutputStream);
				byte[] imageBytes = byteArrayOutputStream.toByteArray();
				ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
				
					if (fileImageIcon.exists()) {
						/*fileImageIcon.delete();*/
						objGuestMasterModel.setStrGuestImage(imageBytes);
					}
					else {
						//objModel.setStrMemberImage(funBlankBlob());
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if(objGuestMasterModel.getStrGuestImage().equals("") || objGuestMasterModel.getStrGuestImage()!=null)
			{
				String deletePrevImage = "delete from tblguestmaster where strGuestCode = '"+objGuestMasterModel.getStrGuestCode()+"' AND `strClientCode`='"+clientCode+"';";
				objWebPMSUtility.funExecuteUpdate(deletePrevImage, "sql");
			}
			objGuestMasterDao.funAddUpdateGuestMaster(objGuestMasterModel);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			return list;
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


}
