<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
<meta content="utf-8" http-equiv="encoding">
<title>Tax Report Day Wise</title>

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<style>
.masterTable td {
     padding-left: 33px;
     }
</style>
<script type="text/javascript">

$(document).ready(function() 
		{		
		
			
			/*$("#txtFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#txtFromDate" ).datepicker('setDate', 'today');*/
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', Dat);
			$("#txtFromDate").datepicker();	
			
			 $("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
				$("#txtToDate").datepicker();	
				
    	    			
  	    			$('#txtTaxCode').keyup(function()
  	    	    			{
  	    						tablename='#tblTax';
  	    	    				searchTable($(this).val(),tablename);
  	    	    			});
  	    			
				
				 funSetAllTax();;
				 
				
			
		});
		
					
			//Searching on table on the basis of input value and table name
			function searchTable(inputVal,tablename)
			{
				var table = $(tablename);
				table.find('tr').each(function(index, row)
				{
					var allCells = $(row).find('td');
					if(allCells.length > 0)
					{
						var found = false;
						allCells.each(function(index, td)
						{
							var regExp = new RegExp(inputVal, 'i');
							if(regExp.test($(td).find('input').val()))
							{
								found = true;
								return false;
							}
						});
						if(found == true)$(row).show();else $(row).hide();
					}
				});
			}
			
			var fieldName="";
			
		
			//Get and Set All Tax
		      function funSetAllTax() {
					var searchUrl = "";
					searchUrl = getContextPath()+ "/loadAllTax.html";
					$.ajax({
						type : "GET",
						url : searchUrl,
						dataType : "json",
						success : function(response) {
							if (response.strLocCode == 'Invalid Code') {
								alert("No Tax Found");
							} else
							{
								$.each(response, function(i,item)
							 		{
										funfillTaxGrid(response[i].strTaxCode,response[i].strTaxDesc);
									});
							
							}
						},
						error : function(jqXHR, exception) {
							if (jqXHR.status === 0) {
								alert('Not connect.n Verify Network.');
							} else if (jqXHR.status == 404) {
								alert('Requested page not found. [404]');
							} else if (jqXHR.status == 500) {
								alert('Internal Server Error [500].');
							} else if (exception === 'parsererror') {
								alert('Requested JSON parse failed.');
							} else if (exception === 'timeout') {
								alert('Time out error.');
							} else if (exception === 'abort') {
								alert('Ajax request aborted.');
							} else {
								alert('Uncaught Error.n' + jqXHR.responseText);
							}
						}
					});
				}
			
			  
			    //Fill To Location Data
			    function funfillTaxGrid(strTaxCode,strTaxName)
				{
					
					 	var table = document.getElementById("tblTax");
					    var rowCount = table.rows.length;
					    var row = table.insertRow(rowCount);
					    
					    row.insertCell(0).innerHTML= "<input id=\"cbTaxSel."+(rowCount)+"\" name=\"Taxthemes\" type=\"checkbox\" class=\"TaxCheckBoxClass\"  checked=\"checked\" value='"+strTaxCode+"' />";
					    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"17%\" id=\"strTaxCode."+(rowCount)+"\" value='"+strTaxCode+"' >";
					    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"35%\" style=\"margin-left: -20px;\" id=\"strTaxName."+(rowCount)+"\" value='"+strTaxName+"' >";
				}
			    //Remove All Row from Grid Passing Table Id as a parameter
			    function funRemRows(tablename) 
				{
					var table = document.getElementById(tablename);
					var rowCount = table.rows.length;
					while(rowCount>0)
					{
						table.deleteRow(0);
						rowCount--;
					}
				}
			
	//Select Location When Clicking Select All Check Box
	 $(document).ready(function () 
				{
										
					$("#chkTaxALL").click(function () {
					    $(".TaxCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
				});
	
	//Submit Data after clicking Submit Button with validation 
	    function btnSubmit_Onclick()
	    {
	
	            var strTaxCode1="";
				 
				 $('input[name="Taxthemes"]:checked').each(function() {
					 if(strTaxCode1.length>0)
						 {
						 strTaxCode1=strTaxCode1+","+this.value;
						 }
						 else
						 {
							 strTaxCode1=this.value;
						 }
					 
					});
				 if(strTaxCode1=="")
				 {
				 	alert("Please Select Tax");
				 	return false;
				 }
				 $("#hidTaxCodes").val(strTaxCode1);
		
		return true;
// 	   	document.forms["frmTaxReportDayWise"].submit();
   	}
    
    
/*     function funSubmit()
    {
    	fDate=$("#txtFromDate").val();
    	tDate=$("#txtToDate").val();
    	cur=$("#cmbCurrency").val();
    	hidTaxCodes =btnSubmit_Onclick();
    	
    	//funSetAllTax();
    	//window.open("rptTaxReportDayWise.html?fDate="+fDate+"&tDate="+tDate+"&cur="+cur+"&hidTaxCodes="+hidTaxCodes+" ","")
    	
    	
    	 var searchUrl = "";
		searchUrl = getContextPath()+ "/rptTaxReportDayWise.html?fDate="+fDate+"&tDate="+tDate+"&cur="+cur+"&hidTaxCodes="+hidTaxCodes+" ";
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				
			},
			error : function(jqXHR, exception) {
				if (jqXHR.status === 0) {
					alert('Not connect.n Verify Network.');
				} else if (jqXHR.status == 404) {
					alert('Requested page not found. [404]');
				} else if (jqXHR.status == 500) {
					alert('Internal Server Error [500].');
				} else if (exception === 'parsererror') {
					alert('Requested JSON parse failed.');
				} else if (exception === 'timeout') {
					alert('Time out error.');
				} else if (exception === 'abort') {
					alert('Ajax request aborted.');
				} else {
					alert('Uncaught Error.n' + jqXHR.responseText);
				}
			}
		}); 
    } */
    
</script>

</head>
<body>
	<div class=" container masterTable">
	<label id="formHeading">Tax Report Day Wise</label>
	
	<s:form name="frmTaxReportDayWise" method="POST"
		action="rptTaxReportDayWise1.html" target="_blank">
	
<%-- 		<input type="hidden" value="${urlHits}" name="saddr"> --%>
		<br>
		<div class= "row">
		      <div class="col-md-3">
		           <div class= "row">
					<div class="col-md-6"><label>From Date</label>
				          <s:input path="dtFromDate" id="txtFromDate" required="required" cssClass="calenderTextBox" />
				    </div>
				   <div class="col-md-6"><label>To Date</label>
			              <s:input path="dtToDate" id="txtToDate" required="required" cssClass="calenderTextBox" />
			       </div>
			 </div></div> 
			 <div class="col-md-9"></div>
			  
<!-- 			<tr> -->
<!-- 			<td><label>Currency</label> -->
<%-- 			<td><s:select id="cmbCurrency" path="strCurrency" --%>
<%-- 							items="${currencyList}" cssClass="BoxW124px"></s:select></td> --%>
<!-- 			<td colspan="2"></td>				 -->
<!-- 			</tr> -->
			
				<div class="col-md-2">Tax  &nbsp;&nbsp;&nbsp;
				<input type="text" id="txtTaxCode" Class="searchTextBox" placeholder="Type to search"  ></input>
				</div>
	
				<div class="col-md-2">
				   <label id="lblTaxName" style="background-color:#dcdada94; width: 100%; height: 40%; margin: 27px 0px;"></label>
				</div>
				<div class="col-md-8"></div>
				<br>
		         <div class="row" style="background-color: #fafbfb; border: 1px solid #ccc;margin:12px 15px; display: block;width:50%; height: 215px; overflow-x: hidden; overflow-y: scroll;">
							<table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="2%"><input type="checkbox" checked="checked" 
										id="chkTaxALL"/>Select</td>
										<td width="20%">Tax Code</td>
										<td width="40%">Tax Name</td>
									</tr>
								</tbody>
							</table>
							
							<table id="tblTax" class="masterTable"
								style="width: 50%; border-collapse: separate;">
                              <!-- 
								<tr bgcolor="#fafbfb">
									

								</tr> -->
							</table>
						</div>
			</div>
			<br>
		<p align="center"  style="margin-right: 9%;">
			<input type="submit" value="Submit" onclick="return btnSubmit_Onclick();" class="btn btn-primary center-block" class="form_button"/> &nbsp
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>
		<br>
		<%-- <div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
			
			
			
			
		</div> --%>
		 <s:input type="hidden" id="hidTaxCodes" path="strTaxCode"></s:input> 
	</s:form>
	</div>
	<script type="text/javascript">
	
	</script>
</body>
</html>