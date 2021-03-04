package com.sanguine.webclub.controller;

import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;
import javax.validation.Valid;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

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

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSet;
import com.mysql.jdbc.ResultSetMetaData;
import com.mysql.jdbc.Statement;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.webbanquets.bean.clsFunctionProspectusBean;
import com.sanguine.webbooks.model.clsSundryDebtorMasterModel;
import com.sanguine.webbooks.model.clsSundryDebtorMasterModel_ID;
import com.sanguine.webbooks.service.clsSundryDebtorMasterService;
import com.sanguine.webclub.bean.clsWebClubFacilityMasterBean;
import com.sanguine.webclub.bean.clsWebClubMemberProfileBean;
import com.sanguine.webclub.bean.clsWebClubMemberProfileSetupBean;
import com.sanguine.webclub.bean.clsWebClubOtheInfoBean;
import com.sanguine.webclub.model.clsWebClubDependentMasterModel;
import com.sanguine.webclub.model.clsWebClubMemberPhotoModel;
import com.sanguine.webclub.model.clsWebClubMemberPhotoModel_ID;
import com.sanguine.webclub.model.clsWebClubMemberProfileModel;
import com.sanguine.webclub.model.clsWebClubMemberProfileModel_ID;
import com.sanguine.webclub.model.clsWebClubPreMemberProfileModel;
import com.sanguine.webclub.service.clsWebClubAreaMasterService;
import com.sanguine.webclub.service.clsWebClubCityMasterService;
import com.sanguine.webclub.service.clsWebClubCountryMasterService;
import com.sanguine.webclub.service.clsWebClubDependentMasterService;
import com.sanguine.webclub.service.clsWebClubMemberPhotoService;
import com.sanguine.webclub.service.clsWebClubMemberProfileService;
import com.sanguine.webclub.service.clsWebClubRegionMasterService;
import com.sanguine.webclub.service.clsWebClubStateMasterService;

@Controller
public class clsWebClubMemberProfileController {
	
	@Autowired
	clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	private clsWebClubMemberProfileService objMemberProfileService;

	@Autowired
	private clsWebClubAreaMasterService objAreaMasterService;

	@Autowired
	private clsWebClubRegionMasterService objRegionMasterService;

	@Autowired
	private clsWebClubStateMasterService objStateMasterService;

	@Autowired
	private clsWebClubCountryMasterService objCountryMasterService;

	@Autowired
	private clsWebClubCityMasterService objCityMasterService;

	@Autowired
	private clsWebClubDependentMasterService objDependentMasterService;

	@Autowired
	private clsWebClubMemberPhotoService objWebClubMemberPhotoService;
	
	@Autowired
	private clsSetupMasterService objSetupMasterService;
	
	@Autowired
	private clsSundryDebtorMasterService objSundryDebtorMasterService;
	
	@Autowired
	private intfBaseService objBaseService;
	
	@Autowired
	private ServletContext servletContext;
	
	// Open MemberProfile
	@RequestMapping(value = "/frmMemberProfile", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		//member master
		List<clsWebClubMemberProfileSetupBean> listWebClubMemberProfileBean = new ArrayList<>();
		List list  = new ArrayList<>();
		clsWebClubMemberProfileBean objWebClubMemberProfileBean = new clsWebClubMemberProfileBean();
		String WebCLUBDB=request.getSession().getAttribute("WebCLUBDB").toString();		
	 	String sqlMemProSetup="SELECT * FROM "+WebCLUBDB+".tblmempropertysetup ";
		List listMemProSetup =objGlobalFunctionsService.funGetList(sqlMemProSetup);		
		Map<String,String> hashMemProSetupFill = new LinkedHashMap<String,String>();
		if(listMemProSetup!=null && listMemProSetup.size()>0)
		{
			for(int i=0;i<listMemProSetup.size();i++)
			{
				Object [] obj=(Object[]) listMemProSetup.get(i);
				hashMemProSetupFill.put(obj[0].toString(),obj[1].toString());
			}
		}			
		String sqlMemMaster="SELECT * FROM "+WebCLUBDB+".tblmempropertysetup ";
		List listMemMaster =objGlobalFunctionsService.funGetList(sqlMemMaster);
		clsWebClubMemberProfileSetupBean objBean =null;
		for(int i=0;i<listMemMaster.size();i++)
		{
			Object [] obj = (Object []) listMemMaster.get(i);
			String str=obj[0].toString().split("_")[0];
			if(obj[0].toString()!=null)
			{
				if(obj[1].toString().equalsIgnoreCase("Y"))
				{	
					list.add(obj[0].toString().split("_")[1]);
				}
			}			
		}
		request.setAttribute("ListMemberValidation", list);
		
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmMemberProfile", "command", new clsWebClubMemberProfileBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmMemberProfile", "command", new clsWebClubMemberProfileBean());
		} else {
			return null;
		}

	}

	@RequestMapping(value = "/savefrmWebClubMemberProfile", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsWebClubMemberProfileBean memProfileBean, BindingResult result, HttpServletRequest req, @RequestParam("memberImage") MultipartFile file) throws IOException {
		
		String userCode = req.getSession().getAttribute("usercode").toString();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		String urlHits = "1";
		try {
			urlHits = req.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}		
		if (!result.hasErrors()) {
			// for primary member
			clsSundryDebtorMasterModel objDebtorModel = null;
			clsWebClubMemberProfileModel objMemProfileModel = funPrepareModel(memProfileBean, req,file);
			clsCompanyMasterModel objCompModel = objSetupMasterService.funGetObject(clientCode);
			if (objCompModel.getStrWebBookModule().equalsIgnoreCase("Yes")) {
				
				objDebtorModel = funPrepareDebtorModel(memProfileBean, userCode, clientCode, propertyCode);
				objSundryDebtorMasterService.funAddUpdateSundryDebtorMaster(objDebtorModel);
				objMemProfileModel.setStrDebtorCode(objDebtorModel.getStrDebtorCode());
			} else {
				objMemProfileModel.setStrDebtorCode("");
			}
			objMemberProfileService.funAddUpdateMemberProfile(objMemProfileModel);

			if(!memProfileBean.getStrMaritalStatus().equalsIgnoreCase("Single"))
			{
				// for Spouse member
				clsWebClubMemberProfileModel objMemberProfileSpouseModel = funPrepardSpouseModel(memProfileBean, objMemProfileModel, req);
				objMemberProfileService.funAddUpdateMemberProfile(objMemberProfileSpouseModel);

			}
			if(!memProfileBean.getListDependentMember().isEmpty()){
				// for Dependent member
				funPrepardDependentModel(memProfileBean, objMemProfileModel, req);
			}		
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Member Code : ".concat(objMemProfileModel.getStrMemberCode().split(" ")[0]));
			return new ModelAndView("redirect:/frmMemberProfile.html?saddr=" + urlHits);
		}
		return new ModelAndView("redirect:/frmMemberProfile.html?saddr=" + urlHits);
	}
	
    public Map funDataBaseShrink()
    {
    	  Map hmap = new LinkedHashMap();
    	  List<String> list=new ArrayList<String>();
    	  objGlobal=new clsGlobalFunctions();
    	  //System.out.println("Getting Column Names Example!");
    	  Connection con = null;
    	  String url = "jdbc:mysql://localhost:3306/";
    	  String db = "jdbctutorial";
    	  String driver = "com.mysql.jdbc.Driver";
    	  String user = "root";
    	  String pass = "root";
    	  String dbName="";
    	  try{
    	  Class.forName(driver);
    	  con = (Connection) DriverManager.getConnection(objGlobal.urlwebclub, objGlobal.urluser, objGlobal.urlPassword);
    	  try{
    	  Statement st = (Statement) con.createStatement();
    	  ResultSet rs = (ResultSet) st.executeQuery("SELECT * FROM tblotherdtl");
    	  ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();
    	  int col = md.getColumnCount();
    	 /* System.out.println("Number of Column : "+ col);
    	  System.out.println("Columns Name: ");*/
    	  for (int i = 1; i <= col; i++){
    	  String col_name = md.getColumnName(i);
    	  String col_type = md.getColumnTypeName(i);
    	  hmap.put(col_name, col_type);
    	  //list.add(col_name.toString());
    	  //System.out.println(col_name);
    	  }
    	  }
    	  catch (SQLException s){
    	  //System.out.println("SQL statement is not executed!");
    	  }
    	  }
    	  catch (Exception e){
    	  e.printStackTrace();
    	  }
    	  return hmap;
    }

	
	
	
	private clsWebClubMemberProfileModel funPrepareModel(clsWebClubMemberProfileBean memProfileBean, HttpServletRequest req,MultipartFile file)throws IOException {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String propCode = req.getSession().getAttribute("propertyCode").toString();
		objGlobal = new clsGlobalFunctions();
		long lastNo = 0;
		
		
		//image code
		objGlobal = new clsGlobalFunctions();
		clsWebClubMemberPhotoModel objModel;
		objModel = new clsWebClubMemberPhotoModel(new clsWebClubMemberPhotoModel_ID(memProfileBean.getStrMemberCode(), clientCode));

		objModel.setStrPropertyCode(propCode);
		objModel.setStrUserCreated(userCode);
		objModel.setStrMemberCode(memProfileBean.getStrMemberCode()+" 01");
		objModel.setStrUserModified(userCode);
		objModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setDteLastModified(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		objModel.setStrMemberName(memProfileBean.getStrFirstName());
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

			//Blob blobProdImage = Hibernate.createBlob(byteArrayInputStream);
			//objModel.setStrMemberImage(blobProdImage);

			if (fileImageIcon.exists()) {
				fileImageIcon.delete();
				objModel.setStrMemberImage(imageBytes);
			}
			else {
				//objModel.setStrMemberImage(funBlankBlob());
			}
			objWebClubMemberPhotoService.funAddUpdateWebClubMemberPhoto(objModel);
		}
			//image code end 
		
		
		
		// Fileds Code
		String memberCode = memProfileBean.getStrMemberCode();
		String WebCLUBDB=req.getSession().getAttribute("WebCLUBDB").toString();
		
		if (memberCode.length() > 0) {
			memberCode.split(" ");

		}
	
		String sql="SELECT * FROM "+WebCLUBDB+".tblotherdtl a WHERE a.strMemberCode='"+memberCode+" 01' ";
		List list =objGlobalFunctionsService.funGetList("SELECT * FROM "+WebCLUBDB+".tblotherdtl a WHERE a.strMemberCode='"+memberCode+" 01' ");
		Map mhasMap = funDataBaseShrink();
		if(list!=null)
		{			
		if(list.isEmpty())
		{		
			if(memProfileBean.listField!=null)
			{	
				StringBuilder sbSql= new StringBuilder (); 
				sbSql.append("INSERT INTO tblotherdtl (strMemberCode,strClientCode");
				int count=0;
				for(int i=0;i<memProfileBean.listField.size();i++)
				{
					
					clsWebClubMemberProfileBean obj = new clsWebClubMemberProfileBean();
					obj=memProfileBean.listField.get(i);
					if(obj.getStrFieldValue()!=null&&!obj.getStrFieldValue().equalsIgnoreCase(""))
					{
						/*if(i==0)
						{
							sbSql.append(obj.getStrFieldName());
						}
						else 
						{*/
							sbSql.append(","+obj.getStrFieldName());
						//}	
							count++;
					}
				}
				if(count>0)
				{
					sbSql.append(") VALUES ('"+memProfileBean.getStrMemberCode() + " 01','"+clientCode+ "' ");
				}
				
				for(int i=0;i<memProfileBean.listField.size();i++)
				{
					
					clsWebClubMemberProfileBean obj = new clsWebClubMemberProfileBean();
					obj=memProfileBean.listField.get(i);
					if(obj.getStrFieldValue()!=null&&!obj.getStrFieldValue().equalsIgnoreCase(""))
					{
						if(i==0)
						{	if(mhasMap.get(obj.getStrFieldName())=="VARCHAR"||mhasMap.get(obj.getStrFieldName())=="DATE"||mhasMap.get(obj.getStrFieldName())=="TIME"||mhasMap.get(obj.getStrFieldName())=="DATETIME")
							{
								sbSql.append(",'"+obj.getStrFieldValue()+"'");
							}
							else
							{
								sbSql.append(obj.getStrFieldValue());
							}					
						}
						else 
						{
							if(mhasMap.get(obj.getStrFieldName())=="VARCHAR"||mhasMap.get(obj.getStrFieldName())=="DATE"||mhasMap.get(obj.getStrFieldName())=="TIME"||mhasMap.get(obj.getStrFieldName())=="DATETIME")
							{
								sbSql.append(",'"+obj.getStrFieldValue()+"'");
							}
							else
							{
								sbSql.append(","+obj.getStrFieldValue());
							}					
						}	
					}
				}
				if(count>0)
				{
					sbSql.append(");");
					objMemberProfileService.funExecuteQuery(sbSql.toString());
				}				
				//objGlobal.funGetList(sbSql.toString());
				}
			}
			else
			{
				if(memProfileBean.listField!=null)
				{	
					StringBuilder sbsqll= new StringBuilder ();				
					sbsqll.append("UPDATE  "+WebCLUBDB+".tblotherdtl a SET ");	
					int count=0;
					for(int i=0;i<memProfileBean.listField.size();i++)
					{						
						clsWebClubMemberProfileBean obj = new clsWebClubMemberProfileBean();
						obj=memProfileBean.listField.get(i);
						if(obj.getStrFieldValue()!=null)
						{														
							if(i==0)
							{	
								if(mhasMap.get(obj.getStrFieldName())=="VARCHAR"||mhasMap.get(obj.getStrFieldName())=="TIME"||mhasMap.get(obj.getStrFieldName())=="DATETIME")
								{
									sbsqll.append("a."+obj.getStrFieldName()+"='"+obj.getStrFieldValue()+"'");
								}
								else if(mhasMap.get(obj.getStrFieldName())=="DATE")
								{
									if(!obj.getStrFieldValue().equalsIgnoreCase(""))
									{
										sbsqll.append(",a."+obj.getStrFieldName()+"='"+obj.getStrFieldValue()+"'");
									}
								}
								else
								{
									sbsqll.append("a."+obj.getStrFieldName()+"="+obj.getStrFieldValue()+"");
								}	
								count ++;
							}
							else 
							{
								if(mhasMap.get(obj.getStrFieldName())=="VARCHAR"||mhasMap.get(obj.getStrFieldName())=="TIME"||mhasMap.get(obj.getStrFieldName())=="DATETIME")
								{
									sbsqll.append(",a."+obj.getStrFieldName()+"='"+obj.getStrFieldValue()+"'");
								}
								else if(mhasMap.get(obj.getStrFieldName())=="DATE")
								{
									if(!obj.getStrFieldValue().equalsIgnoreCase(""))
									{
										sbsqll.append(",a."+obj.getStrFieldName()+"='"+obj.getStrFieldValue()+"'");
									}
								}
								else
								{
									sbsqll.append(",a."+obj.getStrFieldName()+"="+obj.getStrFieldValue()+"");
								}									
							}							
						}					
					}
					if(count>0)
					{
						Object [] objj = (Object[]) list.get(0);					
						sbsqll.append(" WHERE a.strMemberCode= '"+objj[0].toString()+"' AND a.strClientCode='"+objj[1].toString()+"'");
						objMemberProfileService.funExecuteQuery(sbsqll.toString());						
					}
				}	
			}
		}
		
		//end field cods
		
		
		clsWebClubMemberProfileModel mpModel;
		if (memProfileBean.getStrCustomerCode().trim().length() == 0) {
			lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
			String customerCode = "C" + String.format("%06d", lastNo);
			mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(customerCode, clientCode));
			mpModel.setIntGId(lastNo);
			mpModel.setStrCustomerID("01");
			mpModel.setStrUserCreated(userCode);
			mpModel.setStrUserModified(userCode);
			mpModel.setStrPropertyCode(propCode);
			mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			mpModel.setStrPrimaryCode(customerCode);
		} else {
			clsWebClubMemberProfileModel objMemberProfile = objMemberProfileService.funGetCustomer(memProfileBean.getStrCustomerCode(), clientCode);
			if (null == objMemberProfile) {
				lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
				String customerCode = "C" + String.format("%06d", lastNo);
				mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(customerCode, clientCode));
				mpModel.setIntGId(lastNo);
				mpModel.setStrCustomerID("01");
				mpModel.setStrUserCreated(userCode);
				mpModel.setStrUserModified(userCode);
				mpModel.setStrPropertyCode(propCode);
				mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setStrPrimaryCode(customerCode);
			} else {
				mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(memProfileBean.getStrCustomerCode(), clientCode));
				mpModel.setStrUserModified(userCode);
				mpModel.setStrPropertyCode(propCode);
				mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setStrPrimaryCode(memProfileBean.getStrCustomerCode());
			}
		}	
		mpModel.setStrMemberCode(memProfileBean.getStrMemberCode() + " 01");				
		mpModel.setStrUserCreated(userCode);
		mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		mpModel.setStrPrefixCode(memProfileBean.getStrPrefixCode());
		mpModel.setStrFirstName(memProfileBean.getStrFirstName());
		mpModel.setStrMiddleName(memProfileBean.getStrMiddleName());
		mpModel.setStrLastName(memProfileBean.getStrLastName());
		mpModel.setStrFullName(memProfileBean.getStrFirstName()+" "+memProfileBean.getStrMiddleName()+" "+memProfileBean.getStrLastName());
		mpModel.setStrNameOnCard(memProfileBean.getStrNameOnCard());
		
		// Residence Address
		mpModel.setStrResidentAddressLine1(memProfileBean.getStrResidentAddressLine1());
		mpModel.setStrResidentAddressLine2(memProfileBean.getStrResidentAddressLine2());
		mpModel.setStrResidentAddressLine3(memProfileBean.getStrResidentAddressLine3());
		mpModel.setStrResidentAreaCode(memProfileBean.getStrResidentAreaCode());
		mpModel.setStrResidentAreaName(memProfileBean.getStrResidentAreaName());
		mpModel.setStrResidentCtCode(memProfileBean.getStrResidentCtCode());
		mpModel.setStrResidentCtName(memProfileBean.getStrResidentCtName());
		mpModel.setStrResidentStateCode(memProfileBean.getStrResidentStateCode());
		mpModel.setStrResidentStateName(memProfileBean.getStrResidentStateName());
		mpModel.setStrResidentCountryCode(memProfileBean.getStrResidentCountryCode());
		mpModel.setStrResidentCountryName(memProfileBean.getStrResidentCountryName());
		mpModel.setStrResidentRegionCode(memProfileBean.getStrResidentRegionCode());
		mpModel.setStrResidentRegionName(memProfileBean.getStrResidentRegionName());
		mpModel.setStrResidentEmailID(memProfileBean.getStrResidentEmailID());
		mpModel.setStrResidentFax1(memProfileBean.getStrResidentFax1());
		mpModel.setStrResidentFax2(memProfileBean.getStrResidentFax2());
		mpModel.setStrResidentLandMark(memProfileBean.getStrResidentLandMark());
		mpModel.setStrResidentMobileNo(memProfileBean.getStrResidentMobileNo());
		mpModel.setStrResidentPinCode(memProfileBean.getStrResidentPinCode());
		mpModel.setStrResidentTelephone1(memProfileBean.getStrResidentTelephone1());
		mpModel.setStrResidentTelephone2(memProfileBean.getStrResidentTelephone2());

		// Company Address
		mpModel.setStrCompanyAddressLine1(memProfileBean.getStrCompanyAddressLine1());
		mpModel.setStrCompanyAddressLine2(memProfileBean.getStrCompanyAddressLine2());
		mpModel.setStrCompanyAddressLine3(memProfileBean.getStrCompanyAddressLine3());
		mpModel.setStrCompanyAreaCode(memProfileBean.getStrCompanyAreaCode());
		mpModel.setStrCompanyAreaName(memProfileBean.getStrCompanyAreaName());
		mpModel.setStrCompanyCtCode(memProfileBean.getStrCompanyCtCode());
		mpModel.setStrCompanyCtName(memProfileBean.getStrCompanyCtName());
		mpModel.setStrCompanyStateCode(memProfileBean.getStrCompanyStateCode());
		mpModel.setStrCompanyStateName(memProfileBean.getStrCompanyStateName());
		mpModel.setStrCompanyCountryCode(memProfileBean.getStrCompanyCountryCode());
		mpModel.setStrCompanyCountryName(memProfileBean.getStrCompanyCountryName());
		mpModel.setStrCompanyRegionCode(memProfileBean.getStrCompanyRegionCode());
		mpModel.setStrCompanyRegionName(memProfileBean.getStrCompanyRegionName());
		mpModel.setStrCompanyCode(memProfileBean.getStrCompanyCode());
		mpModel.setStrCompanyEmailID(memProfileBean.getStrCompanyEmailID());
		mpModel.setStrCompanyFax1(memProfileBean.getStrCompanyFax1());
		mpModel.setStrCompanyFax2(memProfileBean.getStrCompanyFax2());
		mpModel.setStrCompanyLandMark(memProfileBean.getStrCompanyLandMark());
		mpModel.setStrCompanyMobileNo(memProfileBean.getStrCompanyMobileNo());
		mpModel.setStrCompanyName(memProfileBean.getStrCompanyName());
		mpModel.setStrCompanyPinCode(memProfileBean.getStrCompanyPinCode());
		mpModel.setStrCompanyTelePhone1(memProfileBean.getStrCompanyTelePhone1());
		mpModel.setStrCompanyTelePhone2(memProfileBean.getStrCompanyTelePhone2());
		mpModel.setStrHoldingCode("");
		//mpModel.setStrHoldingCode(memProfileBean.getStrHoldingCode());
		mpModel.setStrJobProfileCode(memProfileBean.getStrJobProfileCode());

		// Bill Address
		mpModel.setStrBillingAddressLine1(memProfileBean.getStrBillingAddressLine1());
		mpModel.setStrBillingAddressLine2(memProfileBean.getStrBillingAddressLine2());
		mpModel.setStrBillingAddressLine3(memProfileBean.getStrBillingAddressLine3());
		mpModel.setStrBillingAreaCode(memProfileBean.getStrBillingAreaCode());
		mpModel.setStrBillingAreaName(memProfileBean.getStrBillingAreaName());
		mpModel.setStrBillingCtCode(memProfileBean.getStrBillingCtCode());
		mpModel.setStrBillingCtName(memProfileBean.getStrBillingCtName());
		mpModel.setStrBillingStateCode(memProfileBean.getStrBillingStateCode());
		mpModel.setStrBillingStateName(memProfileBean.getStrBillingStateName());
		mpModel.setStrBillingCountryCode(memProfileBean.getStrBillingCountryCode());
		mpModel.setStrBillingCountryName(memProfileBean.getStrBillingCountryName());
		mpModel.setStrBillingRegionCode(memProfileBean.getStrBillingRegionCode());
		mpModel.setStrBillingRegionName(memProfileBean.getStrBillingRegionName());
		mpModel.setStrBillingEmailID(memProfileBean.getStrBillingEmailID());
		mpModel.setStrBillingFax1(memProfileBean.getStrBillingFax1());
		mpModel.setStrBillingFax2(memProfileBean.getStrBillingFax2());
		mpModel.setStrBillingFlag(memProfileBean.getStrBillingFlag());
		mpModel.setStrBillingLandMark(memProfileBean.getStrBillingLandMark());
		mpModel.setStrBillingMobileNo(memProfileBean.getStrBillingMobileNo());
		mpModel.setStrBillingPinCode(memProfileBean.getStrBillingPinCode());
		mpModel.setStrBillingTelePhone1(memProfileBean.getStrBillingTelePhone1());
		mpModel.setStrBillingTelePhone2(memProfileBean.getStrBillingTelePhone2());

		// Personal Information
		mpModel.setStrGender(memProfileBean.getStrGender());
		mpModel.setDteDateofBirth(objGlobal.funGetDate("yyyy-MM-dd",memProfileBean.getDteDateofBirth()));
		mpModel.setStrMaritalStatus(memProfileBean.getStrMaritalStatus());
		//mpModel.setDteDateofBirth(memProfileBean.getDteDateofBirth());

		//Bank Information
		mpModel.setStrBankCode(memProfileBean.getStrBankCode());
		mpModel.setStrIfscCOde(memProfileBean.getStrIfscCOde());
		mpModel.setStrBranchName(memProfileBean.getStrBranchName());
		mpModel.setStrAccNo(memProfileBean.getStrAccNo());		
		mpModel.setStrProfessionCode(memProfileBean.getStrProfessionCode());
		mpModel.setDteMembershipStartDate(objGlobal.funGetDate("yyyy-MM-dd", memProfileBean.getDteMembershipStartDate()));
		mpModel.setDteMembershipEndDate(objGlobal.funGetDate("yyyy-MM-dd", memProfileBean.getDteMembershipEndDate()));
		//mpModel.setDteMembershipStartDate(memProfileBean.getDteMembershipStartDate());
		//mpModel.setDteMembershipEndDate(memProfileBean.getDteMembershipEndDate());
		//mpModel.setDteAnniversary(memProfileBean.getDteAnniversary());
		mpModel.setDteAnniversary(objGlobal.funGetDate("yyyy-MM-dd",memProfileBean.getDteAnniversary()));
		
		
		
		// Member Information
		mpModel.setStrCategoryCode(memProfileBean.getStrCategoryCode());
		mpModel.setStrProposerCode(memProfileBean.getStrProposerCode());
		mpModel.setStrSeconderCode(memProfileBean.getStrSeconderCode());
		mpModel.setStrFatherMemberCode(memProfileBean.getStrFatherMemberCode());
		mpModel.setStrInstation(memProfileBean.getStrInstation());
		//mpModel.setStrBlocked(memProfileBean.getStrBlocked());
		mpModel.setStrAlternateMemberCode("");
		mpModel.setStrAttachment("");

		// Card Authontication Check Box
		// mpModel.setStrReasonCode(memProfileBean.getStrBlockedreasonCode());
		mpModel.setStrQualification(memProfileBean.getStrQualification());
		mpModel.setStrDesignationCode(memProfileBean.getStrDesignationCode());
		mpModel.setDblEntranceFee(memProfileBean.getDblEntranceFee());
		mpModel.setDblSubscriptionFee(memProfileBean.getDblSubscriptionFee());
		mpModel.setStrPanNumber(memProfileBean.getStrPanNumber());
		mpModel.setStrDepMobileNo(memProfileBean.getStrDepMobileNo());		
		mpModel.setStrDepEmailID(memProfileBean.getStrDepEmailID());		
		mpModel.setStrDepAadharCardNo(memProfileBean.getStrDepAadharCardNo());		
		mpModel.setStrAadharCardNo(memProfileBean.getStrAadharCardNo());
		mpModel.setStrVoterIdNo(memProfileBean.getStrVoterIdNo());
		mpModel.setStrPassportNo(memProfileBean.getStrPassportNo());
		mpModel.setStrAccNo(memProfileBean.getStrAccNo());
		mpModel.setStrBranchName(memProfileBean.getStrBranchName());
		mpModel.setStrIfscCOde(memProfileBean.getStrIfscCOde());
		// Bill Detail
		mpModel.setStrLocker(memProfileBean.getStrLocker());
		mpModel.setStrLibrary(memProfileBean.getStrLibrary());
		mpModel.setStrSeniorCitizen(memProfileBean.getStrSeniorCitizen());
		mpModel.setStrStopCredit(memProfileBean.getStrStopCredit());
		// Rescident Yes/No
		mpModel.setStrInstation(memProfileBean.getStrInstation());
		mpModel.setStrGolfMemberShip(memProfileBean.getStrGolfMemberShip());
		mpModel.setStrBlocked(memProfileBean.getStrBlocked());
		mpModel.setStrBlockedreasonCode(memProfileBean.getStrBlockedreasonCode());
		mpModel.setStrResident(memProfileBean.getStrResident());
		mpModel.setStrSendCircularNoticeThrough(memProfileBean.getStrSendCircularNoticeThrough());
		mpModel.setStrSendInvThrough(memProfileBean.getStrSendInvThrough());
		mpModel.setStrDepedentRelation("");
		mpModel.setDtePermitExpDate("1990-01-01 00:00:00");
		mpModel.setStrLiquorPermitNo("");
		mpModel.setIntFormNo(0);
		mpModel.setStrGuestEntry("Y");
		mpModel.setStrVirtualAccountCode("");
		mpModel.setChkmail(0);
		mpModel.setStrSSuffixCode("0");
		mpModel.setStrNSuffixCode("0");
		mpModel.setChrCircularemail("0");
		mpModel.setStrAuthorisedMember("");
		mpModel.setStrMemberStatusCode("");
		mpModel.setStrLikes("");
		mpModel.setStrDisLikes("");
		mpModel.setDteInterviewDate("1990-01-01 00:00:00");
		mpModel.setDblCMSBalance(0.00);
		mpModel.setStrPhoto("");
		mpModel.setStrRemark("");
		mpModel.setStrDependentYesNo("N");
		mpModel.setStrSalesStaffCode("");
		mpModel.setDteProfileCreationDate("1990-01-01 00:00:00");
		mpModel.setStrResNonRes("Y");
		mpModel.setDteDependentDateofBirth("1990-01-01 00:00:00");
		mpModel.setDteMemberBlockDate("1990-01-01 00:00:00");		
		mpModel.setDteMembershipExpiryDate(objGlobal.funGetDate("yyyy-MM-dd", memProfileBean.getDteMembershipEndDate()));
		//mpModel.setDteMembershipExpiryDate(memProfileBean.getDteMembershipEndDate());
		mpModel.setStrDebtorCode("");
		mpModel.setStrDependentFullName("");
		mpModel.setStrDependentMemberCode("");
		mpModel.setStrDependentReasonCode("");		
		mpModel.setStrAadharCardNo(memProfileBean.getStrAadharCardNo());
		mpModel.setStrVoterIdNo(memProfileBean.getStrVoterIdNo());
		mpModel.setStrPassportNo(memProfileBean.getStrPassportNo());		
		mpModel.setStrCustomerID("");
 		mpModel.setStrBillingFlag("N");
		mpModel.setStrMemberYesNo("");
		mpModel.setStrSeconderCode("");
		mpModel.setStrFatherMemberCode("");
		mpModel.setStrProposerCode("");		
		mpModel.setStrSendInvThrough("");
		mpModel.setStrResident("");
		mpModel.setStrSendCircularNoticeThrough("");
		return mpModel;
	}

	private void funPrepardDependentModel(clsWebClubMemberProfileBean memProfileBean, clsWebClubMemberProfileModel objMemberProfile, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String propCode = req.getSession().getAttribute("propertyCode").toString();
		objGlobal = new clsGlobalFunctions();
		List<clsWebClubDependentMasterModel> listDependentMaster = memProfileBean.getListDependentMember();
		if (null != listDependentMaster && listDependentMaster.size() > 0) {
			for (clsWebClubDependentMasterModel obDM : listDependentMaster) {
				long lastNo = 1;
				clsWebClubMemberProfileModel mpModel = new clsWebClubMemberProfileModel();
				if(obDM.getStrMemberCode()!=null)
				{							
				String dependentMember = obDM.getStrMemberCode();				
				String[] arrCustID = dependentMember.split(" ");

				if (obDM.getStrCustomerCode() == null) {

					lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
					String customerCode = "C" + String.format("%06d", lastNo);
					obDM.setStrCustomerCode(customerCode);
					obDM.setIntGId(lastNo);

					obDM.setStrUserCreated(userCode);
					obDM.setStrUserModified(userCode);
					obDM.setStrPropertyCode(propCode);
					obDM.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
					obDM.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));

					mpModel.setStrCustomerID(arrCustID[0]);
					mpModel.setStrCustomerCode(obDM.getStrCustomerCode());
					mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());

				} else {
					clsWebClubMemberProfileModel objMemProfile = objMemberProfileService.funGetCustomer(obDM.getStrCustomerCode(), clientCode);
					if (null == objMemProfile) {
						lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
						String customerCode = "C" + String.format("%06d", lastNo);

						obDM.setStrCustomerCode(customerCode);
						obDM.setStrUserCreated(userCode);
						obDM.setStrUserModified(userCode);
						obDM.setStrPropertyCode(propCode);
						obDM.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
						obDM.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
						mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());
						mpModel.setStrCustomerID(arrCustID[1]);
						mpModel.setStrCustomerCode(obDM.getStrCustomerCode());
						mpModel.setIntGId(lastNo);
					} else {
						mpModel.setIntGId(objMemProfile.getIntGId());
						mpModel.setStrCustomerID(arrCustID[1]);
						mpModel.setStrCustomerCode(obDM.getStrCustomerCode());
						mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());
					}
				}

				mpModel.setStrMemberCode(obDM.getStrMemberCode());
				mpModel.setStrUserCreated(userCode);
				mpModel.setStrUserModified(userCode);
				mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setStrPropertyCode(propCode);
				obDM.setDteMemberBlockDate("1990-01-01 00:00:00");
				mpModel.setStrClientCode(clientCode);
				mpModel.setStrDepedentRelation(obDM.getStrDepedentRelation());
				mpModel.setStrPrefixCode("");
				mpModel.setStrFirstName("");
				mpModel.setStrMiddleName("");
				mpModel.setStrLastName("");
				mpModel.setStrFullName(obDM.getStrDependentFullName());
				mpModel.setStrNameOnCard(obDM.getStrDependentFullName());

				// Residence Address
				mpModel.setStrResidentAddressLine1(memProfileBean.getStrResidentAddressLine1());
				mpModel.setStrResidentAddressLine2(memProfileBean.getStrResidentAddressLine2());
				mpModel.setStrResidentAddressLine3(memProfileBean.getStrResidentAddressLine3());
				mpModel.setStrResidentAreaCode(memProfileBean.getStrResidentAreaCode());
				mpModel.setStrResidentAreaName(memProfileBean.getStrResidentAreaName());
				mpModel.setStrResidentCountryCode(memProfileBean.getStrResidentCountryCode());
				mpModel.setStrResidentCountryName(memProfileBean.getStrResidentCountryName());
				mpModel.setStrResidentCtCode(memProfileBean.getStrResidentCtCode());
				mpModel.setStrResidentCtName(memProfileBean.getStrResidentCtName());
				mpModel.setStrResidentEmailID(memProfileBean.getStrResidentEmailID());
				mpModel.setStrResidentFax1(memProfileBean.getStrResidentFax1());
				mpModel.setStrResidentFax2(memProfileBean.getStrResidentFax2());
				mpModel.setStrResidentLandMark(memProfileBean.getStrResidentLandMark());
				mpModel.setStrResidentMobileNo(memProfileBean.getStrResidentMobileNo());
				mpModel.setStrResidentPinCode(memProfileBean.getStrResidentPinCode());
				mpModel.setStrResidentRegionCode(memProfileBean.getStrResidentRegionCode());
				mpModel.setStrResidentRegionName(memProfileBean.getStrResidentRegionName());
				mpModel.setStrResidentStateCode(memProfileBean.getStrResidentStateCode());
				mpModel.setStrResidentStateName(memProfileBean.getStrResidentStateName());
				mpModel.setStrResidentTelephone1(memProfileBean.getStrResidentTelephone1());
				mpModel.setStrResidentTelephone2(memProfileBean.getStrResidentTelephone2());
								
				// Company Address
				mpModel.setStrCompanyAddressLine1("");
				mpModel.setStrCompanyAddressLine2("");
				mpModel.setStrCompanyAddressLine3("");
				mpModel.setStrCompanyCode("");
				mpModel.setStrCompanyEmailID("");
				mpModel.setStrCompanyFax1("");
				mpModel.setStrCompanyFax2("");
				mpModel.setStrCompanyLandMark("");
				mpModel.setStrCompanyMobileNo("");
				mpModel.setStrCompanyName("");
				mpModel.setStrCompanyPinCode("");
				mpModel.setStrCompanyTelePhone1("");
				mpModel.setStrCompanyTelePhone2("");
				mpModel.setStrHoldingCode("");
				mpModel.setStrJobProfileCode("");				
				mpModel.setStrCompanyAreaCode("");
				mpModel.setStrCompanyAreaName("");
				mpModel.setStrCompanyCtCode("");
				mpModel.setStrCompanyCtName("");
				mpModel.setStrCompanyStateCode("");
				mpModel.setStrCompanyStateName("");
				mpModel.setStrCompanyCountryCode("");
				mpModel.setStrCompanyCountryName("");
				mpModel.setStrCompanyRegionCode("");
				mpModel.setStrCompanyRegionName("");
				
				// Bill Address
				mpModel.setStrBillingAddressLine1("");
				mpModel.setStrBillingAddressLine2("");
				mpModel.setStrBillingAddressLine3("");
				mpModel.setStrBillingEmailID("");
				mpModel.setStrBillingFax1("");
				mpModel.setStrBillingFax2("");
				mpModel.setStrBillingFlag("");
				mpModel.setStrBillingLandMark("");
				mpModel.setStrBillingMobileNo("");
				mpModel.setStrBillingPinCode("");
				mpModel.setStrBillingTelePhone1("");
				mpModel.setStrBillingTelePhone2("");				
				mpModel.setStrBillingAreaCode("");
				mpModel.setStrBillingAreaName("");
				mpModel.setStrBillingCtCode("");
				mpModel.setStrBillingCtName("");
				mpModel.setStrBillingStateCode("");
				mpModel.setStrBillingStateName("");
				mpModel.setStrBillingCountryCode("");
				mpModel.setStrBillingCountryName("");
				mpModel.setStrBillingRegionCode("");
				mpModel.setStrBillingRegionName("");				
				mpModel.setStrResident(memProfileBean.getStrResident());
				mpModel.setStrSendCircularNoticeThrough(memProfileBean.getStrSendCircularNoticeThrough());
				mpModel.setStrSendInvThrough(memProfileBean.getStrSendInvThrough());
				
				
				// Personal Information
				mpModel.setStrGender(obDM.getStrGender());
				mpModel.setDteDateofBirth(objGlobal.funGetDate("yyyy-MM-dd", obDM.getDteDependentDateofBirth()));
				//mpModel.setDteDateofBirth(obDM.getDteDependentDateofBirth());
				mpModel.setStrMaritalStatus(obDM.getStrMaritalStatus());
				mpModel.setStrProfessionCode(obDM.getStrProfessionCode());
				mpModel.setDteAnniversary("1990-01-01 00:00:00");			

				// Member Information
				mpModel.setStrCategoryCode("");
				mpModel.setStrProposerCode("");
				mpModel.setStrSeconderCode("");
				mpModel.setStrFatherMemberCode("");
				mpModel.setDteMembershipEndDate(objGlobal.funGetDate("yyyy-MM-dd", obDM.getDteMembershipExpiryDate()));
				mpModel.setDteMembershipStartDate(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteMembershipStartDate()));
				
				//mpModel.setDteMembershipStartDate(memProfileBean.getDteMembershipStartDate());
				//mpModel.setDteMembershipEndDate(obDM.getDteMembershipExpiryDate());

				// Card Authontication Check Box
				mpModel.setStrQualification("");
				mpModel.setStrDesignationCode("");
				mpModel.setDblEntranceFee(new Double(0));
				mpModel.setDblSubscriptionFee(new Double(0));
				mpModel.setStrPanNumber("");
				mpModel.setStrDepMobileNo(obDM.getStrDepMobileNo());
				mpModel.setStrDepEmailID(obDM.getStrDepEmailID());
				mpModel.setStrDepAadharCardNo(obDM.getStrDepAadharCardNo());				
				mpModel.setStrAadharCardNo("");
				mpModel.setStrPassportNo("");
				mpModel.setStrVoterIdNo("");
				mpModel.setStrAccNo("");
				mpModel.setStrBranchName("");
				mpModel.setStrIfscCOde("");
				mpModel.setStrLocker("No");
				mpModel.setStrLibrary("No");
				mpModel.setStrSeniorCitizen("No");
				mpModel.setStrStopCredit("No");
				mpModel.setStrInstation("No");
				mpModel.setStrGolfMemberShip("No");
				mpModel.setStrBlocked(obDM.getStrBlocked());
				mpModel.setStrBlockedreasonCode(obDM.getStrDependentReasonCode());
				mpModel.setStrAlternateMemberCode("");
				mpModel.setStrAttachment("");
				mpModel.setDtePermitExpDate("1990-01-01 00:00:00");
				mpModel.setStrLiquorPermitNo("");
				mpModel.setIntFormNo(0);
				mpModel.setStrGuestEntry("Y");
				mpModel.setStrVirtualAccountCode("");
				mpModel.setChkmail(0);
				mpModel.setStrSSuffixCode("0");
				mpModel.setStrNSuffixCode("0");
				mpModel.setChrCircularemail("0");
				mpModel.setStrAuthorisedMember("");
				mpModel.setStrMemberStatusCode("");
				mpModel.setStrLikes("");
				mpModel.setStrDisLikes("");
				mpModel.setStrSendInvThrough("");
				mpModel.setStrSendCircularNoticeThrough("");
				mpModel.setDteInterviewDate("1990-01-01 00:00:00");
				mpModel.setDblCMSBalance(0.00);
				mpModel.setStrPhoto("");
				mpModel.setStrRemark("");
				mpModel.setStrDependentYesNo("N");
				mpModel.setStrSalesStaffCode("");
				mpModel.setDteProfileCreationDate("1990-01-01 00:00:00");
				mpModel.setStrResNonRes("Y");
				mpModel.setDteDependentDateofBirth("1990-01-01 00:00:00");
				mpModel.setDteMemberBlockDate("1990-01-01 00:00:00");
				mpModel.setDteMembershipExpiryDate(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteMembershipEndDate()));
				//mpModel.setDteMembershipExpiryDate(memProfileBean.getDteMembershipEndDate());
				mpModel.setStrDebtorCode("");
				mpModel.setStrDependentFullName("");
				mpModel.setStrDependentMemberCode("");
				mpModel.setStrDependentReasonCode("");
				mpModel.setStrCustomerID("");
				mpModel.setStrBillingFlag("N");
				mpModel.setStrMemberYesNo("");
				mpModel.setStrBankCode("");
				objMemberProfileService.funAddUpdateMemberProfile(mpModel);
			}
			}
		}

	}

	private clsWebClubMemberProfileModel funPrepardSpouseModel(clsWebClubMemberProfileBean memProfileBean, clsWebClubMemberProfileModel objMemberProfile, HttpServletRequest req)  {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String propCode = req.getSession().getAttribute("propertyCode").toString();
		objGlobal = new clsGlobalFunctions();
		long lastNo = 0;
		clsWebClubMemberProfileModel mpModel=null;
		if (memProfileBean.getStrSpouseCustomerCode() == null) {
			lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
			String customerCode = "C" + String.format("%06d", lastNo);
			mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(customerCode, clientCode));
			mpModel.setIntGId(lastNo);
			mpModel.setStrCustomerID("02");
			mpModel.setStrUserCreated(userCode);
			mpModel.setStrUserModified(userCode);
			mpModel.setStrPropertyCode(propCode);
			mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());
		} else {
			clsWebClubMemberProfileModel objMemProfile = objMemberProfileService.funGetCustomer(memProfileBean.getStrSpouseCustomerCode(), clientCode);
			if (null == objMemProfile) {
				lastNo = objGlobalFunctionsService.funGetLastNo("tblmembermaster", "MemberProfile", "intGId", clientCode);
				String customerCode = "C" + String.format("%06d", lastNo);
				mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(customerCode, clientCode));
				mpModel.setIntGId(lastNo);
				mpModel.setStrCustomerID("02");
				mpModel.setStrUserCreated(userCode);
				mpModel.setStrUserModified(userCode);
				mpModel.setStrPropertyCode(propCode);
				mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());
			} else {
				mpModel = new clsWebClubMemberProfileModel(new clsWebClubMemberProfileModel_ID(objMemProfile.getStrCustomerCode(), clientCode));
				mpModel.setStrUserModified(userCode);
				mpModel.setStrPropertyCode(propCode);
				mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				mpModel.setStrCustomerID("02");
				mpModel.setStrPrimaryCode(objMemberProfile.getStrCustomerCode());
			}
		}
		
		mpModel.setStrMemberCode(memProfileBean.getStrSpouseCode());
		mpModel.setStrUserCreated(userCode);
		mpModel.setStrUserModified(userCode);
		mpModel.setDteCreatedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		mpModel.setDteModifiedDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		mpModel.setStrPropertyCode(propCode);
		mpModel.setDteMemberBlockDate("1990-01-01 00:00:00");
		mpModel.setStrClientCode(clientCode);
		mpModel.setStrDepedentRelation("");
		mpModel.setStrPrefixCode("");
		mpModel.setStrFirstName(memProfileBean.getStrSpouseFirstName());
		mpModel.setStrMiddleName(memProfileBean.getStrSpouseMiddleName());
		mpModel.setStrLastName(memProfileBean.getStrSpouseLastName());
		mpModel.setStrFullName(memProfileBean.getStrSpouseFirstName() + " " + memProfileBean.getStrSpouseMiddleName() + " " + memProfileBean.getStrSpouseLastName());
		mpModel.setStrNameOnCard(memProfileBean.getStrSpouseFirstName() + " " + memProfileBean.getStrSpouseMiddleName() + " " + memProfileBean.getStrSpouseLastName());
		// Residence Address
		mpModel.setStrResidentAddressLine1(memProfileBean.getStrResidentAddressLine1());
		mpModel.setStrResidentAddressLine2(memProfileBean.getStrResidentAddressLine2());
		mpModel.setStrResidentAddressLine3(memProfileBean.getStrResidentAddressLine3());
		mpModel.setStrResidentAreaCode(memProfileBean.getStrResidentAreaCode());
		mpModel.setStrResidentAreaName(memProfileBean.getStrResidentAreaName());
		mpModel.setStrResidentCountryCode(memProfileBean.getStrResidentCountryCode());
		mpModel.setStrResidentCountryName(memProfileBean.getStrResidentCountryName());
		mpModel.setStrResidentCtCode(memProfileBean.getStrResidentCtCode());
		mpModel.setStrResidentCtName(memProfileBean.getStrResidentCtName());
		mpModel.setStrResidentEmailID(memProfileBean.getStrSpouseResidentMobileNo());
		mpModel.setStrResidentFax1(memProfileBean.getStrResidentFax1());
		mpModel.setStrResidentFax2(memProfileBean.getStrResidentFax2());
		mpModel.setStrResidentLandMark(memProfileBean.getStrResidentLandMark());
		mpModel.setStrResidentMobileNo(memProfileBean.getStrSpouseResidentMobileNo());
		mpModel.setStrResidentPinCode(memProfileBean.getStrResidentPinCode());
		mpModel.setStrResidentRegionCode(memProfileBean.getStrResidentRegionCode());
		mpModel.setStrResidentRegionName(memProfileBean.getStrResidentRegionName());
		mpModel.setStrResidentStateCode(memProfileBean.getStrResidentStateCode());
		mpModel.setStrResidentStateName(memProfileBean.getStrResidentStateName());
		mpModel.setStrResidentTelephone1(memProfileBean.getStrResidentTelephone1());
		mpModel.setStrResidentTelephone2(memProfileBean.getStrResidentTelephone2());
		mpModel.setStrResident(memProfileBean.getStrResident());
		mpModel.setStrSendCircularNoticeThrough(memProfileBean.getStrSendCircularNoticeThrough());
		mpModel.setStrSendInvThrough(memProfileBean.getStrSendInvThrough());
		
		// Company Address
		mpModel.setStrCompanyAddressLine1("");
		mpModel.setStrCompanyAddressLine2("");
		mpModel.setStrCompanyAddressLine3("");
		mpModel.setStrCompanyAreaCode("");
		mpModel.setStrCompanyAreaName("");
		mpModel.setStrCompanyCode(memProfileBean.getStrSpouseCompanyCode());
		mpModel.setStrCompanyCountryCode("");
		mpModel.setStrCompanyCtCode("");
		mpModel.setStrCompanyCtName("");
		mpModel.setStrCompanyEmailID("");
		mpModel.setStrCompanyFax1("");
		mpModel.setStrCompanyFax2("");
		mpModel.setStrCompanyLandMark("");
		mpModel.setStrCompanyMobileNo("");
		mpModel.setStrCompanyName("");
		mpModel.setStrCompanyPinCode("");
		mpModel.setStrCompanyRegionCode("");
		mpModel.setStrCompanyRegionName("");
		mpModel.setStrCompanyStateCode("");
		mpModel.setStrCompanyCountryCode("");
		mpModel.setStrCompanyCountryName("");
		mpModel.setStrCompanyStateName(memProfileBean.getStrCompanyStateName());
		mpModel.setStrCompanyTelePhone1("");
		mpModel.setStrCompanyTelePhone2("");
		mpModel.setStrHoldingCode("");
		mpModel.setStrJobProfileCode(memProfileBean.getStrSpouseJobProfileCode());
		
		// Bill Address
		mpModel.setStrBillingAddressLine1("");
		mpModel.setStrBillingAddressLine2("");
		mpModel.setStrBillingAddressLine3("");
		mpModel.setStrBillingAreaCode("");
		mpModel.setStrBillingAreaName("");
		mpModel.setStrBillingCountryCode("");
		mpModel.setStrBillingCountryName("");
		mpModel.setStrBillingCtCode("");
		mpModel.setStrBillingCtName("");
		mpModel.setStrBillingEmailID("");
		mpModel.setStrBillingFax1("");
		mpModel.setStrBillingFax2("");
		mpModel.setStrBillingFlag("");
		mpModel.setStrBillingLandMark("");
		mpModel.setStrBillingMobileNo("");
		mpModel.setStrBillingPinCode("");
		mpModel.setStrBillingRegionCode("");
		mpModel.setStrBillingRegionName("");		
		mpModel.setStrBillingStateCode("");
		mpModel.setStrBillingStateName("");
		mpModel.setStrBillingTelePhone1("");
		mpModel.setStrBillingTelePhone2("");		
		
		// Personal Information
		mpModel.setStrGender("F");
		mpModel.setDteDateofBirth(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteSpouseDateofBirth()));
		//mpModel.setDteDateofBirth(memProfileBean.getDteSpouseDateofBirth());
		mpModel.setStrMaritalStatus("Married");
		mpModel.setStrProfessionCode(memProfileBean.getStrSpouseProfessionCode());
		mpModel.setDteAnniversary(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteAnniversary()));
		//mpModel.setDteAnniversary(memProfileBean.getDteAnniversary());		

		// Member Information
		mpModel.setStrCategoryCode("");
		mpModel.setStrProposerCode("");
		mpModel.setStrSeconderCode("");
		mpModel.setStrFatherMemberCode("");
		mpModel.setDteMembershipStartDate(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteMembershipStartDate()));
		//mpModel.setDteMembershipStartDate(memProfileBean.getDteMembershipStartDate());
		// mpModel.setDteMembershipEndDate(memProfileBean.getDteMembershipExpiryDate());
		mpModel.setDteMembershipEndDate(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteMembershipEndDate()));
		//mpModel.setDteMembershipEndDate(memProfileBean.getDteMembershipEndDate());
		mpModel.setStrInstation("");

		// Card Authontication Check Box
		mpModel.setStrQualification("");
		mpModel.setStrDesignationCode("");
		mpModel.setDblEntranceFee(new Double(0));
		mpModel.setDblSubscriptionFee(new Double(0));
		mpModel.setStrPanNumber("");
		mpModel.setStrDepMobileNo("");
		mpModel.setStrDepEmailID("");
		mpModel.setStrDepAadharCardNo("");
		mpModel.setStrAadharCardNo("");
		mpModel.setStrPassportNo("");
		mpModel.setStrVoterIdNo("");
		mpModel.setStrAccNo("");
		mpModel.setStrBranchName("");
		mpModel.setStrIfscCOde("");
		mpModel.setStrStopCredit(memProfileBean.getStrSpouseStopCredit());
		mpModel.setStrLocker("No");
		mpModel.setStrLibrary("No");
		mpModel.setStrSeniorCitizen("No");
		mpModel.setStrInstation("No");
		mpModel.setStrGolfMemberShip("No");
		mpModel.setStrBlocked(memProfileBean.getStrSpouseBlocked());
		mpModel.setStrBlockedreasonCode("");
		mpModel.setDtePermitExpDate("1990-01-01 00:00:00");
		mpModel.setStrLiquorPermitNo("");
		mpModel.setIntFormNo(0);
		mpModel.setStrGuestEntry("Y");
		mpModel.setStrVirtualAccountCode("");
		mpModel.setChkmail(0);
		mpModel.setStrSSuffixCode("0");
		mpModel.setStrNSuffixCode("0");
		mpModel.setStrStopCredit(memProfileBean.getStrStopCredit());
		mpModel.setChrCircularemail("0");
		mpModel.setStrAuthorisedMember("");
		mpModel.setStrMemberStatusCode("");
		mpModel.setStrLikes("");
		mpModel.setStrDisLikes("");
		mpModel.setStrSendInvThrough("");
		mpModel.setStrSendCircularNoticeThrough("");
		mpModel.setDteInterviewDate("1990-01-01 00:00:00");
		mpModel.setDblCMSBalance(0.00);
		mpModel.setStrPhoto("");
		mpModel.setStrRemark("");
		mpModel.setStrDependentYesNo("N");
		mpModel.setStrSalesStaffCode("");
		mpModel.setDteProfileCreationDate("1990-01-01 00:00:00");
		mpModel.setStrResNonRes("Y");
		mpModel.setDteDependentDateofBirth("1990-01-01 00:00:00");
		mpModel.setDteMemberBlockDate("1990-01-01 00:00:00");
		mpModel.setDteMembershipExpiryDate(objGlobal.funGetDate("yyyy-mm-dd", memProfileBean.getDteMembershipEndDate()));
		//mpModel.setDteMembershipExpiryDate(memProfileBean.getDteMembershipEndDate());
		mpModel.setStrDebtorCode("");
		mpModel.setStrDependentFullName("");
		mpModel.setStrDependentMemberCode("");
		mpModel.setStrDependentReasonCode("");
		mpModel.setStrAlternateMemberCode("");
		mpModel.setStrAttachment("");
		mpModel.setStrCustomerID("");
		mpModel.setStrBillingFlag("N");
		mpModel.setStrMemberYesNo("");
		mpModel.setStrBankCode("");
		mpModel.setStrResident("");
		return mpModel;	
	}
	
	private Blob funBlankBlob() {
		Blob blob = new Blob() {
			@Override
			public void truncate(long len) throws SQLException {
				// TODO Auto-generated method stub
			}

			@Override
			public int setBytes(long pos, byte[] bytes, int offset, int len) throws SQLException {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public int setBytes(long pos, byte[] bytes) throws SQLException {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public OutputStream setBinaryStream(long pos) throws SQLException {
				// TODO Auto-generated method stub
				return null;
			}

			@Override
			public long position(Blob pattern, long start) throws SQLException {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public long position(byte[] pattern, long start) throws SQLException {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public long length() throws SQLException {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public byte[] getBytes(long pos, int length) throws SQLException {
				// TODO Auto-generated method stub
				return null;
			}

			@Override
			public InputStream getBinaryStream(long pos, long length) throws SQLException {
				// TODO Auto-generated method stub
				return null;
			}

			@Override
			public InputStream getBinaryStream() throws SQLException {
				// TODO Auto-generated method stub
				return null;
			}

			@Override
			public void free() throws SQLException {
				// TODO Auto-generated method stub

			}
		};
		return blob;
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

	@RequestMapping(value = "/loadWebClubMemberProfileData", method = RequestMethod.GET)
	public @ResponseBody List funAssignFields(@RequestParam("primaryCode") String primaryCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubMemberProfileModel objbean=null;
		objGlobal=new clsGlobalFunctions();
		List<clsWebClubMemberProfileModel> objMemberModelList = objMemberProfileService.funGetAllMember(primaryCode, clientCode);
		List<clsWebClubMemberProfileModel> finalList = new ArrayList<>();
		if (null != objMemberModelList) {
			for(int i=0;i<objMemberModelList.size();i++)
			{
				if(objMemberModelList.get(i).getStrMemberCode()!=null && objMemberModelList.size()>0 && !objMemberModelList.get(i).getStrMemberCode().equals(""))
				{
					objbean=new clsWebClubMemberProfileModel();
					objbean=objMemberModelList.get(i);				
					objbean.setDteAnniversary(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteAnniversary().split(" ")[0]));
					objbean.setDteDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDateofBirth().split(" ")[0]));					
					objbean.setDteDependentDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDependentDateofBirth().split(" ")[0]));
					objbean.setDteInterviewDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteInterviewDate().split(" ")[0]));
					objbean.setDteMemberBlockDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMemberBlockDate().split(" ")[0]));
					objbean.setDteMembershipEndDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipEndDate().split(" ")[0]));
					objbean.setDteMembershipExpiryDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipExpiryDate().split(" ")[0]));
					objbean.setDteMembershipStartDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipStartDate().split(" ")[0]));
					objbean.setDtePermitExpDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDtePermitExpDate().split(" ")[0]));
					objbean.setDteProfileCreationDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteProfileCreationDate().split(" ")[0]));
					finalList.add(objbean);
				}
			}
		}
		return finalList;
	}
	
	
	@RequestMapping(value = "/loadWebClubMemberPre-ProfileData", method = RequestMethod.GET)
	public @ResponseBody List funAssignPre_profileMemberData(@RequestParam("primaryCode") String primaryCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubPreMemberProfileModel objbean=null;
		objGlobal=new clsGlobalFunctions();
		List<clsWebClubPreMemberProfileModel> objMemberModelList = objMemberProfileService.funGetAllMemberPreProfile(primaryCode, clientCode);
		List<clsWebClubPreMemberProfileModel> finalList = new ArrayList<>();
		if (null != objMemberModelList) {
			for(int i=0;i<objMemberModelList.size();i++)
			{
				if(objMemberModelList.get(i).getStrMemberCode()!=null && objMemberModelList.size()>0 && !objMemberModelList.get(i).getStrMemberCode().equals(""))
				{
					objbean=new clsWebClubPreMemberProfileModel();
					objbean=objMemberModelList.get(i);	
					objbean.setDteDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDateofBirth().split(" ")[0]));
					objbean.setDteDependentDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDependentDateofBirth().split(" ")[0]));
					//objbean.setDteDependentMemExpDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDependentDateofBirth().split(" ")[0]));)
					finalList.add(objbean);
				}
			}
		}
		return finalList;
	}
	
	@RequestMapping(value = "/loadWebClubMemberWiseFieldData", method = RequestMethod.GET)
	public @ResponseBody Map funMemberWiseFieldData(@RequestParam("primaryCode") String MemberCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		//List<clsWebClubMemberProfileModel> objMemberModelList = objMemberProfileService.funGetAllMember(primaryCode, clientCode);
		
		List list=objGlobalFunctionsService.funGetListModuleWise("SELECT a.strMemberCode FROM tblmembermaster a WHERE a.strCustomerCode='"+MemberCode+"' AND a.strClientCode='"+clientCode+"'","sql") ;
		Map hm = new LinkedHashMap<String,List>();		
		List listField=objGlobalFunctionsService.funGetListModuleWise("SELECT * FROM tblotherdtl a WHERE a.strMemberCode='"+list.get(0).toString()+"' ","sql") ;
		Map hmap=funDataBaseShrink();
		if(listField!=null && listField.size()>0)
		{
			for(int i=0;i<listField.size();i++)
			{
				int k=1;
				Iterator<Map.Entry<String, String>> itr = hmap.entrySet().iterator(); 
				while(itr.hasNext()) 
			    { 	
					Object obj [] = (Object[]) listField.get(i);
					Map.Entry<String, String> entry = itr.next(); 
					if(!entry.getKey().equalsIgnoreCase("strMemberCode")&&!entry.getKey().equalsIgnoreCase("strClientCode"))
					{	
						List list1 = new ArrayList<>();						
						list1.add(entry.getValue());
						if(obj[k+1]!=null)
						{
							list1.add(obj[k+1].toString());	
						}			
						else
						{
							list1.add("");
						}
						hm.put(entry.getKey(),list1);
						k++;
					}
			    }	
			}
			
		}
		return hm;		
	}
	
	
	@RequestMapping(value = "/loadWebClubMemberProfileCustomerData", method = RequestMethod.GET)
	public @ResponseBody clsWebClubMemberProfileModel funAssignFieldsUsingCustomer(@RequestParam("customerCode") String customerCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubMemberProfileModel objMemberModel = objMemberProfileService.funGetCustomer(customerCode, clientCode);
		if (null == objMemberModel) {
			objMemberModel = new clsWebClubMemberProfileModel();
			objMemberModel.setStrMemberCode("Invalid Code");
		}
		return objMemberModel;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/loadDependentMasterData", method = RequestMethod.GET)
	public @ResponseBody List funLoadDependentMasterData(@RequestParam("docCode") String docCode, HttpServletRequest req) {
		List<clsWebClubDependentMasterModel> listDMData = new LinkedList<clsWebClubDependentMasterModel>();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		listDMData = objDependentMasterService.funGetWebClubDependentMasterList(docCode, clientCode);
		return listDMData;
	}

	@RequestMapping(value = "/loadWebClubMemberFieldListData", method = RequestMethod.GET)
	public @ResponseBody Map funAssignFieldData(HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		List<clsWebClubMemberProfileModel> finalList = new ArrayList<>();
		Map hmap=funDataBaseShrink();		
		return hmap;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/loadFieldsMemberWise", method = RequestMethod.GET)
	public @ResponseBody Map funGetFieldsMemberWise(@RequestParam("memCode") String memCode, HttpServletRequest req) {
 		objGlobal=new clsGlobalFunctions();
		List<clsWebClubDependentMasterModel> listDMData = new LinkedList<clsWebClubDependentMasterModel>();
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		Map hm = new HashMap<String,String>();
		String [] str=memCode.split(" ");
		List list=objGlobalFunctionsService.funGetListModuleWise("select * from tblotherdtl a where a.strMemberCode='"+memCode+"' ","sql") ;
		Map hmap=funDataBaseShrink();
		if(list!=null||list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				int k=0;
				Iterator<Map.Entry<String, String>> itr = hmap.entrySet().iterator(); 
				while(itr.hasNext()) 
			    { 	
					Object obj [] = (Object[]) list.get(i);					
					Map.Entry<String, String> entry = itr.next(); 
					if(!entry.getKey().equalsIgnoreCase("strMemberCode"))
					{
						if(entry.getValue().equalsIgnoreCase("DATE"))
						{
							hm.put(entry.getKey(),obj[k+1].toString());							
							objGlobal.funGetDate("dd-MM-yyyy",obj[k+1].toString());
							k++;
						}
						else{
							hm.put(entry.getKey(),obj[k+1].toString());
							k++;
						}						
					}			        
			    }	
			}			
		}		
		return hm;
	}
	
	//loadMembProfileImage
	@RequestMapping(value = "/loadMembProfileImage", method = RequestMethod.GET)
	public void getImage(@RequestParam("prodCode") String prodCode, HttpServletRequest req, HttpServletResponse response) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubMemberPhotoModel objmemPhotoModel = null;
		if (prodCode.length() > 0) {
			objmemPhotoModel = objWebClubMemberPhotoService.funGetWebClubMemberPhoto(prodCode, clientCode);
		} else {
			objmemPhotoModel = objWebClubMemberPhotoService.funGetWebClubMemberPhoto(prodCode, clientCode);
		}
		try {
			//Blob image = null;
			byte[] imgData = null;
		//	image = objModel.getStrProductImage();
			//if (null != image && image.length() > 0) {
			imgData =objmemPhotoModel.getStrMemberImage();
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
	
	//Print Data On Jasper
	@RequestMapping(value = "/printMeberData", method = RequestMethod.GET)
	public @ResponseBody void funPringMemberData(@RequestParam("memberCode") String memberCode, HttpServletRequest req, HttpServletResponse res) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsWebClubMemberProfileModel objbean=null;
		objGlobal=new clsGlobalFunctions();
		List<clsWebClubMemberProfileModel> objMemberModelList = objMemberProfileService.funGetAllMember(memberCode, clientCode);
		List<clsWebClubMemberProfileModel> finalList = new ArrayList<>();
		if (null != objMemberModelList) {
			for(int i=0;i<objMemberModelList.size();i++)
			{
				if(objMemberModelList.get(i).getStrMemberCode()!=null && objMemberModelList.size()>0 && !objMemberModelList.get(i).getStrMemberCode().equals(""))
				{
					objbean=new clsWebClubMemberProfileModel();
					objbean=objMemberModelList.get(i);				
					objbean.setDteAnniversary(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteAnniversary().split(" ")[0]));
					objbean.setDteDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDateofBirth().split(" ")[0]));					
					objbean.setDteDependentDateofBirth(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteDependentDateofBirth().split(" ")[0]));
					objbean.setDteInterviewDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteInterviewDate().split(" ")[0]));
					objbean.setDteMemberBlockDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMemberBlockDate().split(" ")[0]));
					objbean.setDteMembershipEndDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipEndDate().split(" ")[0]));
					objbean.setDteMembershipExpiryDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipExpiryDate().split(" ")[0]));
					objbean.setDteMembershipStartDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteMembershipStartDate().split(" ")[0]));
					objbean.setDtePermitExpDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDtePermitExpDate().split(" ")[0]));
					objbean.setDteProfileCreationDate(objGlobal.funGetDate("dd-MM-yyyy",objMemberModelList.get(i).getDteProfileCreationDate().split(" ")[0]));
					finalList.add(objbean);
				}
			}
		}	
		funGenarateMemberProfileForm(req,res,finalList);		
	}

	@RequestMapping(value = "/deleteDependenData", method = RequestMethod.GET)
	public @ResponseBody List funDeleteDepedentData(@RequestParam("docCode") String docCode, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		//clsWebClubMemberProfileModel objbean=null;
		//objGlobal=new clsGlobalFunctions();
		String WebClubDB=req.getSession().getAttribute("WebCLUBDB").toString();
		//List<clsWebClubMemberProfileModel> objMemberModelList = objMemberProfileService.funGetAllMember(docCode, clientCode);		
		objMemberProfileService.funExecuteQuery("DELETE FROM "+WebClubDB+".tblmembermaster WHERE strMemberCode='"+docCode+"' AND strClientCode='"+clientCode+"' ");
		return null;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/loadAttachedDocumentsCount", method = RequestMethod.GET)
	public @ResponseBody List funShowAttachDocumentsCount(@RequestParam("docCode") String memCode, HttpServletRequest req) {
		List<clsWebClubDependentMasterModel> listDMData = new LinkedList<clsWebClubDependentMasterModel>();
		String webStockDB = req.getSession().getAttribute("WebStockDB").toString();
		//String sql="SELECT  ifnull(COUNT(a.strActualFileName),0) from "+webStockDB+".tblattachdocument a WHERE a.strCode='"+memCode+" 01' ";
		List list=objGlobalFunctionsService.funGetListModuleWise("SELECT  ifnull(COUNT(a.strActualFileName),0) from "+webStockDB+".tblattachdocument a WHERE a.strCode='"+memCode+" 01' ","sql") ;
		return list;
	}
	
	public Map funDataBaseShrink(String Sql)
    {
    	  Map hmap = new LinkedHashMap();
    	  List<String> list=new ArrayList<String>();
    	  objGlobal=new clsGlobalFunctions();
    	  //System.out.println("Getting Column Names Example!");
    	  Connection con = null;
    	  String url = "jdbc:mysql://localhost:3306/";
    	  String db = "jdbctutorial";
    	  String driver = "com.mysql.jdbc.Driver";
    	  String user = "root";
    	  String pass = "root";
    	  String dbName="";
    	  try{
    	  Class.forName(driver);
    	  con = (Connection) DriverManager.getConnection(objGlobal.urlwebclub, objGlobal.urluser, objGlobal.urlPassword);
    	  try{
    	  Statement st = (Statement) con.createStatement();
    	  ResultSet rs = (ResultSet) st.executeQuery(Sql);
    	  ResultSetMetaData md = (ResultSetMetaData) rs.getMetaData();
    	  int col = md.getColumnCount();
    	 /* System.out.println("Number of Column : "+ col);
    	  System.out.println("Columns Name: ");*/
    	  for (int i = 1; i <= col; i++){
    	  String col_name = md.getColumnName(i);
    	  String col_type = md.getColumnTypeName(i);
    	  hmap.put(col_name, col_type);
    	  //list.add(col_name.toString());
    	  //System.out.println(col_name);
    	  }
    	  }
    	  catch (SQLException s){
    	  //System.out.println("SQL statement is not executed!");
    	  }
    	  }
    	  catch (Exception e){
    	  e.printStackTrace();
    	  }
    	  return hmap;
    }
	
	private clsSundryDebtorMasterModel funPrepareDebtorModel(clsWebClubMemberProfileBean objBean, String userCode, String clientCode, String propertyCode) {
	
	long lastNo = 0;
	clsSundryDebtorMasterModel objModel=null;
	if (objBean.getStrDebtorCode() == null || objBean.getStrDebtorCode().trim().length() == 0) {
		lastNo = objGlobalFunctionsService.funGetLastNoModuleWise("tblsundarydebtormaster", "DebtorMaster", "intGId", clientCode, "5-WebBook");
		String debtorCode = "D" + String.format("%08d", lastNo);
		objModel = new clsSundryDebtorMasterModel(new clsSundryDebtorMasterModel_ID(debtorCode, clientCode));
		objModel.setIntGId(lastNo);
		objModel.setDteStartDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	} else {
		objModel = objSundryDebtorMasterService.funGetSundryDebtorMaster(objBean.getStrDebtorCode().trim(), clientCode);
		if (null == objModel) {
			lastNo = objGlobalFunctionsService.funGetLastNoModuleWise("tblsundarydebtormaster", "DebtorMaster", "intGId", clientCode, "5-WebBook");
			String debtorCode = "D" + String.format("%08d", lastNo);
			objModel = new clsSundryDebtorMasterModel(new clsSundryDebtorMasterModel_ID(debtorCode, clientCode));
			objModel.setIntGId(lastNo);
			objModel.setDteStartDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		} else {
			/*String strStarDate = objModel1.getDteStartDate();
			objModel = new clsSundryDebtorMasterModel(new clsSundryDebtorMasterModel_ID(objBean.getStrDebtorCode(), clientCode));
			objModel.setDteStartDate(strStarDate);*/
		}
	}
	
	String accCode="",accName="";
	try{
		StringBuilder hql=new StringBuilder("select strAccountCode,strAccountName from clsWebBooksAccountMasterModel where strClientCode='" + clientCode + "' and strDebtor='Yes' ");
		List listAcc=objBaseService.funGetListForWebBooks(hql, "hql");		
		//List listAcc=objBaseService.funGetListModuleWise(hql, "hql", "WebBooks");
		if(listAcc!=null && listAcc.size()>0){
			Object[] ob=(Object[]) listAcc.get(0);
			accCode=ob[0].toString();
			accName=ob[1].toString();
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
	/* setting main data */
	objModel.setStrPrefix(objBean.getStrPrefixCode());
	objModel.setStrFirstName(objBean.getStrFirstName());
	objModel.setStrMiddleName(objBean.getStrMiddleName());
	objModel.setStrLastName(objBean.getStrLastName());
	objModel.setStrCategoryCode("");
	
	/* setting main data */
	objModel.setStrAddressLine1(objBean.getStrResidentAddressLine1());
	objModel.setStrAddressLine2(objBean.getStrResidentAddressLine2());
	objModel.setStrAddressLine3("");
	objModel.setStrBlocked("NO");
	objModel.setStrCity(objBean.getStrResidentCtName());
	objModel.setLongZipCode(objBean.getStrResidentPinCode());
	objModel.setStrTelNo1(objGlobal.funIfNull(objBean.getStrResidentMobileNo(), "",objBean.getStrResidentMobileNo()));//objGlobalFunctions.funIfNull(objBean.getStrSubType(), "", "")
	objModel.setStrTelNo2(objGlobal.funIfNull(objBean.getStrResidentTelephone1(),"",objBean.getStrResidentTelephone1()));
	objModel.setStrFax(objGlobal.funIfNull(objBean.getStrResidentFax1(),"",objBean.getStrResidentFax1()));
	objModel.setStrArea(objGlobal.funIfNull(objBean.getStrResidentAreaName(),"",objBean.getStrResidentAreaName()));
	objModel.setStrEmail(objGlobal.funIfNull(objBean.getStrResidentEmailID(),"",objBean.getStrResidentEmailID()));
	objModel.setStrContactPerson1(objGlobal.funIfNull(objBean.getStrResidentTelephone2(),"",objBean.getStrResidentTelephone2()));
	objModel.setStrContactDesignation1("");
	objModel.setStrContactEmail1("");
	objModel.setStrContactTelNo1("");
	objModel.setStrContactPerson2("");
	objModel.setStrContactDesignation2("");
	objModel.setStrContactEmail2("");
	objModel.setStrContactTelNo2("");
	objModel.setStrLandmark("");
	objModel.setStrDebtorFullName(objBean.getStrFullName());
	objModel.setStrExpired("N");
	objModel.setStrExpiryReasonCode("NA");
	objModel.setStrECSYN("N");
	objModel.setStrAccountNo("");
	objModel.setStrHolderName("");
	objModel.setStrMICRNo("");
	objModel.setDblECS("0.00");
	objModel.setStrSaveCurAccount("NA");
	objModel.setStrAlternateCode("");
	objModel.setDblOutstanding("0.00");
	objModel.setStrStatus("NA");
	objModel.setIntDays1("0");
	objModel.setIntDays2("0");
	objModel.setIntDays3("0");
	objModel.setIntDays4("0");
	objModel.setIntDays5("0");
	objModel.setDblCrAmt("0");
	objModel.setDblDrAmt("0");
	objModel.setDteLetterProcess(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	objModel.setStrReminder1("0");
	objModel.setStrReminder2("0");
	objModel.setStrReminder3("0");
	objModel.setStrReminder4("0");
	objModel.setStrReminder5("0");
	objModel.setDblLicenseFee("NA");
	objModel.setDblAnnualFee("NA");
	objModel.setStrRemarks("NA");
	objModel.setStrClientApproval("NA");
	objModel.setStrAMCLink("NA");
	objModel.setStrCurrencyType("");
	objModel.setStrAccountHolderCode("NA");
	objModel.setStrAccountHolderName("NA");
	objModel.setStrAMCCycle("Yearly");
	objModel.setStrAMCRemarks("");
	objModel.setStrClientComment("");
	objModel.setStrBillingToCode("");
	objModel.setDblAnnualFeeInCurrency("");
	objModel.setDblLicenseFeeInCurrency("");
	objModel.setStrState("");
	objModel.setStrRegion("");
	objModel.setStrCountry("");
	objModel.setStrConsolidated("NA");
	objModel.setIntCreditDays("NA");
	objModel.setStrDebtorStatusCode("NA");
	objModel.setLongMobileNo("NA");
	objModel.setStrECSActivate("NA");
	objModel.setStrReminderStatus1("NA");
	objModel.setDteRemainderDate1("NA");
	objModel.setStrReminderStatus2("NA");
	objModel.setDteRemainderDate2("NA");
	objModel.setStrReminderStatus3("NA");
	objModel.setDteRemainderDate3("NA");
	objModel.setStrReminderStatus4("NA");
	objModel.setDteRemainderDate4("NA");
	objModel.setStrReminderStatus5("NA");
	objModel.setDteRemainderDate5("");
	objModel.setStrAllInvoiceHeader("");
	objModel.setStrClientCode(clientCode);
	objModel.setStrPropertyCode(propertyCode);
	objModel.setStrUserCreated(userCode);
	objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	objModel.setStrUserEdited(userCode);
	objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	objModel.setStrAccountCode(accCode);
	objModel.setStrAccountName(accName);
	objModel.setStrOperational("Yes");
	return objModel;
}
	public void funGenarateMemberProfileForm(HttpServletRequest req,HttpServletResponse resp,List<clsWebClubMemberProfileModel> list) 
	{
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		String userCode = req.getSession().getAttribute("usercode").toString();
		String propertyCode = req.getSession().getAttribute("propertyCode").toString();
		String companyName = req.getSession().getAttribute("companyName").toString();
		String webStockDB = req.getSession().getAttribute("WebStockDB").toString();
		String sql="";
		String fromDate="",toDate="";
		String strServiceType="";
		HashMap reportParams = new HashMap();
		clsFunctionProspectusBean objBean=null;
		List<clsWebClubMemberProfileModel> listDep=new ArrayList<clsWebClubMemberProfileModel>();;
		try
		{
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webclub/rptMemberProfileForm.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
			String WebStocksDB=req.getSession().getAttribute("WebStockDB").toString();	
			String WebCLUBDB=req.getSession().getAttribute("WebCLUBDB").toString();	
			reportParams.put("strImagePath", imagePath);
			List<clsWebClubFacilityMasterBean> listFacilityName = new ArrayList<clsWebClubFacilityMasterBean>();
			List listProperInfo =objGlobalFunctionsService.funGetList("SELECT b.strPropertyName,a.strAdd1,a.strAdd2,a.strCity from "+WebStocksDB+".tblpropertysetup a,"+WebStocksDB+".tblpropertymaster b WHERE a.strPropertyCode='"+propertyCode+"' AND a.strPropertyCode=b.strPropertyCode ;");	
			if(listProperInfo!=null)
			{
				Object obj[] = (Object []) listProperInfo.get(0);
				reportParams.put("pCompanyName",objGlobal.funIfNull(obj[0].toString(),"",obj[0].toString()));  
				reportParams.put("pAddress1",objGlobal.funIfNull(obj[1].toString(),"",obj[1].toString()));  
				reportParams.put("pAddress2",objGlobal.funIfNull(obj[2].toString()+","+obj[3].toString(),"",obj[2].toString()+","+obj[3].toString()));  
			}
			if(list.size()>0)
			{
				if(list.get(0) != null)
				{
					reportParams.put("strMemberCode",list.get(0).getStrMemberCode().split(" ")[0]);
					reportParams.put("strPrefixCode",list.get(0).getStrPrefixCode());
					reportParams.put("strFirstName",list.get(0).getStrFirstName());
					reportParams.put("strMiddleName",list.get(0).getStrMiddleName());
					reportParams.put("strLastName",list.get(0).getStrLastName());
					reportParams.put("strGender",list.get(0).getStrGender());
					reportParams.put("dteDateofBirth",list.get(0).getDteDateofBirth());
					reportParams.put("strMaritalStatus",list.get(0).getStrMaritalStatus());
					
					//cate code
					clsWebClubFacilityMasterBean objFacilityBean =null;
					List listCateCode =objGlobalFunctionsService.funGetList("SELECT a.strCatName from "+WebCLUBDB+".tblmembertypemaster a WHERE a.strCatCode='"+list.get(0).getStrCategoryCode()+"' AND a.strClientCode='"+clientCode+"';");	
					if(!listCateCode.isEmpty())
					{						
						//facility information
						List listCateWiseFacilityName =objGlobalFunctionsService.funGetList("SELECT b.strFacilityName FROM "+WebCLUBDB+".tblcategeorywisefacilitydtl a,"+WebCLUBDB+".tblfacilitymaster b WHERE a.strCatCode='"+list.get(0).getStrCategoryCode()+"' AND a.strFacilityCode=b.strFacilityCode and a.strClientCode=b.strClientCode and a.strClientCode='"+clientCode+"' ");	
						if(!listCateWiseFacilityName.isEmpty())
						{
							for(int i=0;i<listCateWiseFacilityName.size();i++)
							{
								objFacilityBean = new clsWebClubFacilityMasterBean();
								objFacilityBean.setStrFacilityName(listCateWiseFacilityName.get(i).toString());
								listFacilityName.add(objFacilityBean);
							}
							reportParams.put("listFacilityName",listFacilityName);	
						}																
						reportParams.put("strCategoryCode",objGlobal.funIfNull(listCateCode.get(0).toString(),"",listCateCode.get(0).toString()));						
					}
					
					List<clsWebClubOtheInfoBean> listOtheInfo = new ArrayList<clsWebClubOtheInfoBean>(); 
					clsWebClubOtheInfoBean objOtheInfo = null;											
							Map hm = new LinkedHashMap<String,List>();		
							List listField=objGlobalFunctionsService.funGetListModuleWise("SELECT * FROM tblotherdtl a WHERE a.strMemberCode='"+list.get(0).getStrMemberCode()+"' ","sql") ;
							Map hmap=funDataBaseShrink();
							if(listField!=null && listField.size()>0)
							{
								for(int i=0;i<listField.size();i++)
								{
									int k=1;
									Iterator<Map.Entry<String, String>> itr = hmap.entrySet().iterator(); 
									while(itr.hasNext()) 
								    {
										Object obj [] = (Object[]) listField.get(i);
										Map.Entry<String, String> entry = itr.next(); 
										if(!entry.getKey().equalsIgnoreCase("strMemberCode")&&!entry.getKey().equalsIgnoreCase("strClientCode"))
										{
											objOtheInfo = new clsWebClubOtheInfoBean();
											objOtheInfo.setStrFieldName(entry.getKey());
											if(obj[k+1]!=null)
											{
												objOtheInfo.setStrFieldValue(obj[k+1].toString());	
											}
											else
											{
												objOtheInfo.setStrFieldValue("");
											}
											listOtheInfo.add(objOtheInfo);											
											k++;
										}
								    }	
								}
								reportParams.put("listOtherInfo",listOtheInfo);  
							}														
					List listBankName =objGlobalFunctionsService.funGetList("SELECT a.strBankName FROM "+WebStocksDB+".tblbankmaster a where a.strBankCode='"+list.get(0).getStrBankCode()+"' AND a.strClientCode='"+clientCode+"' ");	
					if(!listBankName.isEmpty())
					{
						reportParams.put("strBankName",objGlobal.funIfNull(listBankName.get(0).toString(),"",listBankName.get(0).toString()));  
					}					
					reportParams.put("dteMembershipStartDate",list.get(0).getDteMembershipStartDate());
					reportParams.put("dteMembershipEndDate",list.get(0).getDteMembershipStartDate());
					List listEducationName =objGlobalFunctionsService.funGetList("SELECT a.strEducationDesc FROM "+WebCLUBDB+".tbleducationmaster a WHERE a.strEducationCode='"+list.get(0).getStrQualification()+"' AND a.strClientCode='"+clientCode+"'");	
					if(!listEducationName.isEmpty())
					{
						reportParams.put("strQualification",objGlobal.funIfNull(listEducationName.get(0).toString(),"",listEducationName.get(0).toString()));
					}
					List listDesignation =objGlobalFunctionsService.funGetList("SELECT a.strDesignationName FROM "+WebCLUBDB+".tbldesignationmaster a WHERE a.strDesignationCode='"+list.get(0).getStrDesignationCode()+"' AND a.strClientCode='"+clientCode+"'");
					if(!listDesignation.isEmpty())
					{
						reportParams.put("strDesignationCode",objGlobal.funIfNull(listDesignation.get(0).toString(),"",listDesignation.get(0).toString()));
					}
					reportParams.put("strAadharCardNo",list.get(0).getStrAadharCardNo());
					reportParams.put("strPassportNo",list.get(0).getStrPassportNo());
					reportParams.put("strPanNumber",list.get(0).getStrPanNumber());
					reportParams.put("strSeniorCitizen",list.get(0).getStrSeniorCitizen());
					reportParams.put("strBranchName",list.get(0).getStrBranchName());
					reportParams.put("strIfscCOde",list.get(0).getStrIfscCOde());
					reportParams.put("strAccNo",list.get(0).getStrAccNo());	
					List listMemProSetup =objGlobalFunctionsService.funGetList("SELECT a.strBankName FROM "+WebStocksDB+".tblbankmaster a where a.strBankCode='"+list.get(0).getStrBankCode()+"' AND a.strClientCode='"+clientCode+"' ");	
					if(!listMemProSetup.isEmpty())
					{
						reportParams.put("strBankName",objGlobal.funIfNull(listMemProSetup.get(0).toString(),"",listMemProSetup.get(0).toString()));  
					}
					
					
					//address filling
							
					//Resident Address
					reportParams.put("strResAddrLine1",objGlobal.funIfNull(list.get(0).getStrResidentAddressLine1().toString()," ",list.get(0).getStrResidentAddressLine1().toString()));
					reportParams.put("strResAddrLine2",objGlobal.funIfNull(list.get(0).getStrResidentAddressLine2().toString()," ",list.get(0).getStrResidentAddressLine2().toString()));
					reportParams.put("strResAddrLine3",objGlobal.funIfNull(list.get(0).getStrResidentAddressLine3().toString()," ",list.get(0).getStrResidentAddressLine3().toString()));
					reportParams.put("strResAddrLandmark",objGlobal.funIfNull(list.get(0).getStrResidentLandMark().toString()," ",list.get(0).getStrResidentLandMark().toString()));
					reportParams.put("strResArea",objGlobal.funIfNull(list.get(0).getStrResidentAreaName().toString()," ",list.get(0).getStrResidentAreaName().toString()));
					reportParams.put("strResCity",objGlobal.funIfNull(list.get(0).getStrResidentCtName().toString()," ",list.get(0).getStrResidentCtName().toString()));
					reportParams.put("strResState",objGlobal.funIfNull(list.get(0).getStrResidentStateName().toString()," ",list.get(0).getStrResidentStateName().toString()));
					reportParams.put("strResCountry",objGlobal.funIfNull(list.get(0).getStrResidentCountryName().toString()," ",list.get(0).getStrResidentCountryName().toString()));
					reportParams.put("strResReg",objGlobal.funIfNull(list.get(0).getStrResidentRegionName().toString()," ",list.get(0).getStrResidentRegionName().toString()));
					reportParams.put("strResTel1",objGlobal.funIfNull(list.get(0).getStrResidentTelephone1().toString()," ",list.get(0).getStrResidentTelephone1().toString()));
					reportParams.put("strResTel2",objGlobal.funIfNull(list.get(0).getStrResidentTelephone2().toString()," ",list.get(0).getStrResidentTelephone2().toString()));
					reportParams.put("strResFax1",objGlobal.funIfNull(list.get(0).getStrResidentFax1().toString()," ",list.get(0).getStrResidentFax1().toString()));
					reportParams.put("strResFax2",objGlobal.funIfNull(list.get(0).getStrResidentFax2().toString()," ",list.get(0).getStrResidentFax2().toString()));
					reportParams.put("strResPin",objGlobal.funIfNull(list.get(0).getStrResidentPinCode().toString()," ",list.get(0).getStrResidentPinCode().toString()));
					reportParams.put("strResMob",objGlobal.funIfNull(list.get(0).getStrResidentMobileNo().toString()," ",list.get(0).getStrResidentMobileNo().toString()));
					reportParams.put("strResEmail",objGlobal.funIfNull(list.get(0).getStrResidentEmailID().toString()," ",list.get(0).getStrResidentEmailID().toString()));
										
					//comany address
					reportParams.put("strCompAddrLine1",objGlobal.funIfNull(list.get(0).getStrCompanyAddressLine1().toString()," ",list.get(0).getStrCompanyAddressLine1().toString()));
					reportParams.put("strCompAddrLine2",objGlobal.funIfNull(list.get(0).getStrCompanyAddressLine2().toString()," ",list.get(0).getStrCompanyAddressLine2().toString()));
					reportParams.put("strCompAddrLine3",objGlobal.funIfNull(list.get(0).getStrCompanyAddressLine3().toString()," ",list.get(0).getStrCompanyAddressLine3().toString()));
					reportParams.put("strCompAddrLandmark",objGlobal.funIfNull(list.get(0).getStrCompanyLandMark().toString()," ",list.get(0).getStrCompanyLandMark().toString()));
					reportParams.put("strCompArea",objGlobal.funIfNull(list.get(0).getStrCompanyAreaName().toString()," ",list.get(0).getStrCompanyAreaName().toString()));
					reportParams.put("strCompCity",objGlobal.funIfNull(list.get(0).getStrCompanyCtName().toString()," ",list.get(0).getStrCompanyCtName().toString()));
					reportParams.put("strCompState",objGlobal.funIfNull(list.get(0).getStrCompanyStateName().toString()," ",list.get(0).getStrCompanyStateName().toString()));
					reportParams.put("strCompCountry",objGlobal.funIfNull(list.get(0).getStrCompanyCountryName().toString()," ",list.get(0).getStrCompanyCountryName().toString()));
					reportParams.put("strCompReg",objGlobal.funIfNull(list.get(0).getStrCompanyRegionName().toString()," ",list.get(0).getStrCompanyRegionName().toString()));
					reportParams.put("strCompTel1",objGlobal.funIfNull(list.get(0).getStrCompanyTelePhone1().toString()," ",list.get(0).getStrCompanyTelePhone1().toString()));
					reportParams.put("strCompTel2",objGlobal.funIfNull(list.get(0).getStrCompanyTelePhone2().toString()," ",list.get(0).getStrCompanyTelePhone2().toString()));
					reportParams.put("strCompFax1",objGlobal.funIfNull(list.get(0).getStrCompanyFax1().toString()," ",list.get(0).getStrCompanyFax1().toString()));
					reportParams.put("strCompFax2",objGlobal.funIfNull(list.get(0).getStrCompanyFax2().toString()," ",list.get(0).getStrCompanyFax2().toString()));
					reportParams.put("strCompPin",objGlobal.funIfNull(list.get(0).getStrCompanyPinCode().toString()," ",list.get(0).getStrCompanyPinCode().toString()));
					reportParams.put("strCompMob",objGlobal.funIfNull(list.get(0).getStrCompanyMobileNo().toString()," ",list.get(0).getStrCompanyMobileNo().toString()));
					reportParams.put("strCompEmail",objGlobal.funIfNull(list.get(0).getStrCompanyEmailID().toString()," ",list.get(0).getStrCompanyEmailID().toString()));
										
					//billing
					reportParams.put("strBillAddrLine1",objGlobal.funIfNull(list.get(0).getStrBillingAddressLine1().toString()," ",list.get(0).getStrBillingAddressLine1().toString()));
					reportParams.put("strBillAddrLine2",objGlobal.funIfNull(list.get(0).getStrBillingAddressLine2().toString()," ",list.get(0).getStrBillingAddressLine2().toString()));
					reportParams.put("strBillAddrLine3",objGlobal.funIfNull(list.get(0).getStrBillingAddressLine3().toString()," ",list.get(0).getStrBillingAddressLine3().toString()));
					reportParams.put("strBillAddrLandmark",objGlobal.funIfNull(list.get(0).getStrBillingLandMark().toString()," ",list.get(0).getStrBillingLandMark().toString()));
					reportParams.put("strBillArea",objGlobal.funIfNull(list.get(0).getStrBillingAreaName().toString()," ",list.get(0).getStrBillingAreaName().toString()));
					reportParams.put("strBillCity",objGlobal.funIfNull(list.get(0).getStrBillingCtName().toString()," ",list.get(0).getStrBillingCtName().toString()));
					reportParams.put("strBillState",objGlobal.funIfNull(list.get(0).getStrBillingStateName().toString()," ",list.get(0).getStrBillingStateName().toString()));
					reportParams.put("strBillCountry",objGlobal.funIfNull(list.get(0).getStrBillingCountryName().toString()," ",list.get(0).getStrBillingCountryName().toString()));
					reportParams.put("strBillReg",objGlobal.funIfNull(list.get(0).getStrBillingRegionName().toString()," ",list.get(0).getStrBillingRegionName().toString()));
					reportParams.put("strBillTel1",objGlobal.funIfNull(list.get(0).getStrBillingTelePhone1().toString()," ",list.get(0).getStrBillingTelePhone1().toString()));
					reportParams.put("strBillTel2",objGlobal.funIfNull(list.get(0).getStrBillingTelePhone2().toString()," ",list.get(0).getStrBillingTelePhone2().toString()));
					reportParams.put("strBillFax1",objGlobal.funIfNull(list.get(0).getStrBillingFax1().toString()," ",list.get(0).getStrBillingFax1().toString()));
					reportParams.put("strBillFax2",objGlobal.funIfNull(list.get(0).getStrBillingFax2().toString()," ",list.get(0).getStrBillingFax2().toString()));
					reportParams.put("strBillPin",objGlobal.funIfNull(list.get(0).getStrBillingPinCode().toString()," ",list.get(0).getStrBillingPinCode().toString()));
					reportParams.put("strBillMob",objGlobal.funIfNull(list.get(0).getStrBillingMobileNo().toString()," ",list.get(0).getStrBillingMobileNo().toString()));
					reportParams.put("strBillEmail",objGlobal.funIfNull(list.get(0).getStrBillingEmailID().toString()," ",list.get(0).getStrBillingEmailID().toString()));
										
					clsWebClubMemberPhotoModel obj = new clsWebClubMemberPhotoModel();
					clsWebClubMemberPhotoModel objmemPhotoModel = null;
					if (list.get(0).getStrMemberCode().toString().length() > 0) {
						objmemPhotoModel = objWebClubMemberPhotoService.funGetWebClubMemberPhoto(list.get(0).getStrMemberCode().toString(), clientCode);
					} else {
						objmemPhotoModel = objWebClubMemberPhotoService.funGetWebClubMemberPhoto(list.get(0).getStrMemberCode().toString(), clientCode);
					}
					if(objmemPhotoModel!=null)
					{
						Blob image = null;
						byte[] imgData = null;
						String prodImage = "";
						try {
							if (null != objmemPhotoModel.getStrMemberImage() && objmemPhotoModel.getStrMemberImage().length > 0) {
								imgData = objmemPhotoModel.getStrMemberImage();
								try {
									//imgData = Base64.getDecoder().decode(imgData);// decoding
																					// of
																					// byte
								} catch (Exception ex) {
									ex.printStackTrace();
								}
								File imgFolder = new File(System.getProperty("user.dir") + "\\ProductImageIcon");
								if (!imgFolder.exists()) {
									if (imgFolder.mkdir()) {
										System.out.println("Directory is created! " + imgFolder.getAbsolutePath());
									} else {
										System.out.println("Failed to create directory!");
									}
								}
								File fileUserImage = new File(System.getProperty("user.dir") + "\\ProductImageIcon\\" + list.get(0).getStrMemberCode().toString() + "_" + list.get(0).getStrFirstName().toString() + ".jpg");
								prodImage = System.getProperty("user.dir") + "\\ProductImageIcon\\" + list.get(0).getStrMemberCode().toString()  + "_" + list.get(0).getStrFirstName().toString()+ ".jpg";
								if (fileUserImage.exists()) {
									fileUserImage.delete();
								}
								fileUserImage.createNewFile();
								FileOutputStream fos = new FileOutputStream(fileUserImage);
								fos.write(imgData);
								fos.close();
								//objmemPhotoModel.setStrMemberImage(objmemPhotoModel.getStrMemberImage());
							}}
						catch (Exception ex) {
						}						
						reportParams.put("strMemberImage",prodImage); 
					}
				}		
				if(list.get(0).getStrMaritalStatus().equalsIgnoreCase("Married"))
				{
					String strDependent="";
					for(int i=2;i<list.size();i++)
					{
						if(list.get(i)!=null)
						{
							listDep.add(list.get(i));
						}
					}
					reportParams.put("listNominies",listDep);				
				}
			}
			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);
			JasperPrint jp = JasperFillManager.fillReport(jr, reportParams,new JREmptyDataSource());
			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			if (jp != null) 
			{
				jprintlist.add(jp);
				ServletOutputStream servletOutputStream = resp.getOutputStream();
				JRExporter exporter = new JRPdfExporter();
				resp.setContentType("application/pdf");
				exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
				exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
				exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
				resp.setHeader("Content-Disposition", "inline;filename=FunctionProspectus_" + fromDate + "_To_" + toDate + "_" + userCode + ".pdf");
				exporter.exportReport();
				servletOutputStream.flush();
				servletOutputStream.close();
			}		
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}		
	}

	@RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
	public ModelAndView funUpload(HttpServletRequest req, @RequestParam("memberImage") MultipartFile file) throws IOException {
		
		String userCode = req.getSession().getAttribute("usercode").toString();
		String clientCode = req.getSession().getAttribute("clientCode").toString();		
		return new ModelAndView("redirect:/frmMemberProfile.html?saddr=" + 1);
	}

}
