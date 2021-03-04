package com.sanguine.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.view.document.AbstractXlsView;


@Controller
public class clsExcelBuilderForAccountReports extends AbstractXlsView  {

	@SuppressWarnings({ "rawtypes" })
	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// get data model which is passed by the Spring container

		List listExcelData = (List) model.get("excelDataList");
		
		String reportName = (String) listExcelData.get(0);
		
		List listHeaderLevelInfo=(List)listExcelData.get(3);
		List listdate = new ArrayList();
		List listReportName= new ArrayList();
		try {
			listdate = (List) listExcelData.get(2);
			listReportName=(List)listExcelData.get(1);
		} catch (Exception e) {
			listdate = new ArrayList();
		}

		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-disposition", "attachment; filename=" + reportName.trim() + ".xls");

		List listData = new ArrayList();
		listData=(List)listExcelData.get(4);
		
	// create a new Excel sheet
		Sheet sheet =  workbook.createSheet("Sheet");
		sheet.setDefaultColumnWidth(80);
		sheet.setColumnWidth(1, 5000);
		sheet.setColumnWidth(3, 5000);
	// create style for header cells
		
		CellStyle style = workbook.createCellStyle();
		Font font = workbook.createFont();
		font.setFontName("Arial");
		style.setFillForegroundColor(HSSFColor.BLUE.index);
		style.setFillPattern(CellStyle.SOLID_FOREGROUND);
		style.setAlignment(CellStyle.ALIGN_CENTER);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setColor(HSSFColor.WHITE.index);
		font.setFontHeight((short)(15*20));
		style.setFont(font);

		
		CellStyle style2 = workbook.createCellStyle();
		Font font2 = workbook.createFont();
		font2.setFontName("Arial");
		font2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		style2.setFont(font2);
		
		CellStyle style5 = workbook.createCellStyle();
		Font font5 = workbook.createFont();
		font5.setFontName("Arial");
		style5.setAlignment(CellStyle.ALIGN_RIGHT);
		style5.setFont(font5);
		
		/*CellStyle style3 = workbook.createCellStyle();
		Font font3 = workbook.createFont();
		font3.setFontName("Arial");
		style3.setFillForegroundColor(HSSFColor.YELLOW.index);
		style3.setFillPattern(CellStyle.ALIGN_FILL);
		//style3.setBorderBottom(arg0);
		font3.setColor(HSSFColor.BLACK.index);
		style3.setFont(font3);
		
		CellStyle style4 = workbook.createCellStyle();
		Font font4 = workbook.createFont();
		font4.setFontName("Arial");
		style4.setFillForegroundColor(HSSFColor.YELLOW.index);
		style4.setFillPattern(CellStyle.SOLID_FOREGROUND);
		font4.setColor(HSSFColor.BLACK.index);
		style4.setFont(font4);*/
		// create header row
		
		
		int excelRowCount=4;
		Row header = sheet.createRow(excelRowCount);
		for (int rowCount = 0; rowCount < listHeaderLevelInfo.size(); rowCount++) {
			header.createCell(rowCount).setCellValue(listHeaderLevelInfo.get(rowCount).toString());
			header.getCell(rowCount).setCellStyle(style);
		}
		Row rptName = sheet.createRow(excelRowCount);
		excelRowCount++;
		if (listReportName!=null && listReportName.size()>0) {
			rptName.createCell(0).setCellValue(listReportName.get(0).toString());
			rptName.getCell(0).setCellStyle(style2);
			
			rptName = sheet.createRow(excelRowCount);
			excelRowCount++;
			rptName.createCell(0).setCellValue(listReportName.get(1).toString());
			rptName.getCell(0).setCellStyle(style2);
		}
		
		
		Row date = sheet.createRow(excelRowCount);
		excelRowCount++;
		for (int rowfitter = 0; rowfitter < listdate.size(); rowfitter++) {
			date.createCell(rowfitter).setCellValue(listdate.get(rowfitter).toString());
			date.getCell(rowfitter).setCellStyle(style2);
		}
				
		for (int rowtitile = 0; rowtitile < 1; rowtitile++) {
			Row blank = sheet.createRow(excelRowCount);
			excelRowCount++;
			blank.createCell(rowtitile).setCellValue("");
			// titile.getCell(rowtitile).setCellStyle(style);
		}
 
	// create data rows
	// aRow is add Row
		
		//Map<String,Object> hmGrpSubGrpAcc=(Map) listData.get(0);
		
		List<List<String>> list1=new ArrayList<>(); 
		List<String> listLiabilities=(List)listData.get(0); 
		List<String> listAssets=(List)listData.get(1); 
		
		excelRowCount++;
		int maxListSize=(listAssets.size()>=listLiabilities.size())?listAssets.size():listLiabilities.size(); 
		Row aRowHeader = sheet.createRow(excelRowCount);
		aRowHeader.createCell(0).setCellValue("ASSET");
		aRowHeader.createCell(1).setCellValue("Balance");
		aRowHeader.createCell(2).setCellValue("LIABILITY");
		aRowHeader.createCell(3).setCellValue("Balance");
		
		aRowHeader.getCell(0).setCellStyle(style);
		aRowHeader.getCell(1).setCellStyle(style2);
		aRowHeader.getCell(2).setCellStyle(style);
		aRowHeader.getCell(3).setCellStyle(style2);
		
		excelRowCount++;
		for(int rowCount = 0; rowCount <maxListSize; rowCount++ ){
			
			Row aRow = sheet.createRow(excelRowCount);
			if(rowCount<listAssets.size()){				
				 List list= new ArrayList<>();
				 list.add(listAssets.get(rowCount));
				 String str=list.get(rowCount).toString();
				 char c[]=str.toCharArray();
				 StringBuilder sbSql = new StringBuilder();				 
				 for(int i=1;i<c.length-1;i++) {sbSql.append(c[i]);}						  
				 String rowData=sbSql.toString();
				 if(!rowData.equals("ASSET")){ //Sub Group
					if(rowData.contains("_")){
						aRow.createCell(0).setCellValue(rowData.replace("_","  "));
						aRow.getCell(0).setCellStyle(style2);
					}else{
						if(rowData.contains("!")){
							aRow.createCell(1).setCellValue(rowData.split("!")[1]);
							aRow.createCell(0).setCellValue("      "+rowData.split("!")[0]);
							aRow.getCell(1).setCellStyle(style5);
						}else{
							aRow.createCell(0).setCellValue("      "+rowData);	
							
						}
						
					//	aRow.getCell(0).setCellStyle(style3);
					}
				}
			}
			if(rowCount<listLiabilities.size()){
				List list= new ArrayList<>();
				 list.add(listLiabilities.get(rowCount));
				 String str=list.get(list.size()-1).toString();
				 char c[]=str.toCharArray();
				 StringBuilder sbSql = new StringBuilder();				 
				 for(int i=1;i<c.length-1;i++) {sbSql.append(c[i]);}	
				String rowData=sbSql.toString();
				if(!rowData.equals("LIABILITY")){
					
					if(rowData.contains("_")){ //sub Group 
						aRow.createCell(2).setCellValue(rowData.replace("_","  "));
						aRow.getCell(2).setCellStyle(style2);
							
					}else{
						if(rowData.contains("!")){
							aRow.createCell(3).setCellValue(rowData.split("!")[1]);
							aRow.createCell(2).setCellValue("      "+rowData.split("!")[0]);
							aRow.getCell(3).setCellStyle(style5);
						}else{
							aRow.createCell(2).setCellValue("      "+rowData);	
							
						}
						
					//	aRow.getCell(1).setCellStyle(style3);
					}
					
				}
			}
			excelRowCount++;
			
		}
		
		
		
	}

	public static boolean isNumeric(String str) {
		return str.matches("-?\\d+(\\.\\d+)?"); // match a number with optional
												// '-' and decimal.
	}

}
