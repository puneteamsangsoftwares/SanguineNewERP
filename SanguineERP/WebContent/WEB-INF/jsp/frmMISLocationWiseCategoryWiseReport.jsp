<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MIS Location wise Report</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

 <style>
.transTable td {
	   padding-left:26px;
		}
</style> 
<script type="text/javascript">

$(document).ready(function() 
		{		
		
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Date1=arr[2]+"-"+arr[1]+"-"+arr[0];
			var startDateOfMonth="${startDateOfMonth}";
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
			$("#txtFromDate").datepicker();	
			
			 $("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
				$("#txtToDate").datepicker();	
				
    	    			
  	    			$('#txtLocCode').keyup(function()
  	    	    			{
  	    						tablename='#tblToloc';
  	    	    				searchTable($(this).val(),tablename);
  	    	    			});
  	    			/* $('#txtFrmLocCode').keyup(function()
  	    	    			{
  	    						tablename='#tblFromloc';
  	    	    				searchTable($(this).val(),tablename);
  	    	    			}); */
				
				 funSetAllLocationAllPrpoerty();;
				 
				 funGetGroupData();
			
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
			//Ajax Wait Image display
			$(document).ready(function() 
			{
				$(document).ajaxStart(function()
			 	{
				    $("#wait").css("display","block");
			  	});
				$(document).ajaxComplete(function(){
				    $("#wait").css("display","none");
				  });
			});
		
			//Get and Set All Location on the basis of all Property
		      function funSetAllLocationAllPrpoerty() {
					var searchUrl = "";
					searchUrl = getContextPath()+ "/loadAllLocationForAllProperty.html";
					$.ajax({
						type : "GET",
						url : searchUrl,
						dataType : "json",
						beforeSend : function(){
							 $("#wait").css("display","block");
					    },
					    complete: function(){
					    	 $("#wait").css("display","none");
					    },
						success : function(response) {
							if (response.strLocCode == 'Invalid Code') {
								alert("Invalid Location Code");
								$("#txtFromLocCode").val('');
								$("#lblFromLocName").text("");
								$("#txtFromLocCode").focus();
							} else
							{
								$.each(response, function(i,item)
								 		{
									funfillToLocationGrid(response[i].strLocCode,response[i].strLocName);
								//	funfillFromLocationGrid(response[i].strLocCode,response[i].strLocName);
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
			    function funfillToLocationGrid(strLocCode,strLocationName)
				{
					
					 	var table = document.getElementById("tblToloc");
					    var rowCount = table.rows.length;
					    var row = table.insertRow(rowCount);
					    
					    row.insertCell(0).innerHTML= "<input id=\"cbToLocSel."+(rowCount)+"\" name=\"ToLocthemes\" type=\"checkbox\" class=\"ToLocCheckBoxClass\"  checked=\"checked\" value='"+strLocCode+"' />";
					    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strToLocCode."+(rowCount)+"\" value='"+strLocCode+"' >";
					    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strToLocName."+(rowCount)+"\" value='"+strLocationName+"' >";
				}
			    
			  
			    
			/*     //Fill From Location Data
			    function funfillFromLocationGrid(strLocCode,strLocationName)
				{
					
					 	var table = document.getElementById("tblFromloc");
					    var rowCount = table.rows.length;
					    var row = table.insertRow(rowCount);
					    
					    row.insertCell(0).innerHTML= "<input id=\"cbFromLocSel."+(rowCount)+"\" name=\"FromLocthemes\" type=\"checkbox\" class=\"FromLocCheckBoxClass\"  checked=\"checked\" value='"+strLocCode+"' />";
					    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strFromLocCode."+(rowCount)+"\" value='"+strLocCode+"' >";
					    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strFromLocName."+(rowCount)+"\" value='"+strLocationName+"' >";
				} */
			    
					
					
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
			
			
			

function funHelp(transactionName)
{
	fieldName = transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	
}

		 	function funSetData(code)
			{
		 		switch (fieldName) 
 				{
 					
 				    case 'locationmaster':
 				    	funSetToLocation(code);
 				        break;
 				        
 				        
 				}
			}
	
	//Select Location When Clicking Select All Check Box
	 $(document).ready(function () 
				{
										
					$("#chkToLocALL").click(function () {
					    $(".ToLocCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
					$("#chkFromLocALL").click(function () {
					    $(".FromLocCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
					
					
				});
	
	
	//Submit Data after clicking Submit Button with validation 
	   function btnSubmit_Onclick()
	    {
	
	            var strToLocCode="";
				 
				 $('input[name="ToLocthemes"]:checked').each(function() {
					 if(strToLocCode.length>0)
						 {
						 strToLocCode=strToLocCode+","+this.value;
						 }
						 else
						 {
							 strToLocCode=this.value;
						 }
					 
					});
				 if(strToLocCode=="")
				 {
				 	alert("Please Select To Location");
				 	return false;
				 }
				 $("#hidToLocCodes").val(strToLocCode);
				
		 
				 var strSGCode="";
				 $('input[name="SubGroupthemes"]:checked').each(function() {
					 if(strSGCode.length>0)
						 {
						 strSGCode=strSGCode+","+this.value;
						 }
						 else
						 {
							 strSGCode=this.value;
						 }
					 
					});
				 if(strSGCode=="")
				 {
				 	alert("Please Select SubGroup");
				 	return false;
				 }
				 $("#hidSubCodes").val(strSGCode);
		 
	    
	    var strFromLocCode="";
		 
		/*  $('input[name="FromLocthemes"]:checked').each(function() {
			 if(strFromLocCode.length>0)
				 {
				 strFromLocCode=strFromLocCode+","+this.value;
				 }
				 else
				 {
					 strFromLocCode=this.value;
				 }
			 
			}); */
			strFromLocCode=$("#txtFrmLocCode").val();
			
		 if(strFromLocCode=="")
		 {
		 	alert("Please Select From Location");
		 	return false;
		 }
		 $("#hidFrmLocCodes").val(strFromLocCode);
		 
		
	   	
		 if($("#cmbReportType").val()=="Summary")
			{
			
			document.forms[0].action = "rptMISLocationWiseCategoryWiseSummaryReport.html";
			
			}
		else
			{
			document.forms[0].action ="rptMISLocationWiseCategoryWiseReport.html";
			}
		
   
   	}
   	
   	
   	function funHelp(transactionName)
	{
		fieldName=transactionName;
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600,dialogWidth:1000,top=500,left=500")
		
		 
    }
   	
   	function funSetData(code)
	{					
		var searchUrl="";			
		switch (fieldName)
		{
			case 'StoreLocationTo':
				funSetLocationBy(code);					
			break;
   	
		}
	}
   	
   	function funSetLocationBy(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	$("#txtFrmLocCode").val(response.strLocCode);
			    	$("#lblFrmLocName").text(response.strLocName);
			    },
			    error: function(jqXHR, exception) {
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
   	
    //Get All Group data 
    function funGetGroupData()
	{
		var searchUrl = getContextPath() + "/loadAllGroupData.html";
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				funRemRows("tblGroup");
				$.each(response, function(i,item)
		 		{
					funfillGroupGrid(response[i].strGCode,response[i].strGName);
				});
				funGroupChkOnClick();
			},
			error: function(jqXHR, exception) {
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
    
    //Fill Group Data
	function funfillGroupGrid(strGroupCode,strGroupName)
	{
		
		 	var table = document.getElementById("tblGroup");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input id=\"cbGSel."+(rowCount)+"\" type=\"checkbox\"  name=\"GCodethemes\" class=\"GCheckBoxClass selected \" checked=\"checked\" value='"+strGroupCode+"' onclick=\"funGroupChkOnClick()\"/>";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box selected\" size=\"15%\" id=\"strGCode."+(rowCount)+"\" value='"+strGroupCode+"' >";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box selected\" size=\"40%\" id=\"strGName."+(rowCount)+"\" value='"+strGroupName+"' >";
	}
		
	//Select All Group
	function funGroupChkOnClick()
	{
		var table = document.getElementById("tblGroup");
	    var rowCount = table.rows.length;  
	    var strGCodes="";
	    for(no=0;no<rowCount;no++)
	    {
	        if(document.all("cbGSel."+no).checked==true)
	        	{
	        		if(strGCodes.length>0)
	        			{
	        				strGCodes=strGCodes+","+document.all("strGCode."+no).value;
	        			}
	        		else
	        			{
	        				strGCodes=document.all("strGCode."+no).value;
	        			}
	        	}
	    }
	    funGetSubGroupData(strGCodes);
	}
	
	//Geting SubGroup Data On the basis of Selection Group
	function funGetSubGroupData(strGCodes)
	{
		strCodes = strGCodes.split(",");
		var count=0;
		funRemRows("tblSubGroup");
		for (ci = 0; ci < strCodes.length; ci++) 
		 {
			var searchUrl = getContextPath() + "/loadSubGroupCombo.html?code="+ strCodes[ci];
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				beforeSend : function(){
					 $("#wait").css("display","block");
			    },
			    complete: function(){
			    	 $("#wait").css("display","none");
			    },
				success : function(response)
				{
					$.each(response, function(key, value) {
						funfillSubGroup(key,value);
					});
							
				},
				error: function(jqXHR, exception) {
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
		
	}
	
	//Fill SubGroup Data
	function funfillSubGroup(strSGCode,strSGName) 
	{
		var table = document.getElementById("tblSubGroup");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
	}
	
	//Select All Group,SubGroup,From Location, To Location When Clicking Select All Check Box
	 $(document).ready(function () 
				{
					$("#chkSGALL").click(function ()
					{
					    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
					$("#chkGALL").click(function () 
					{
					    $(".GCheckBoxClass").prop('checked', $(this).prop('checked'));
					    funGroupChkOnClick();
					  
					});
					$("#chkSuppALL").click(function () {
					    $(".SuppCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
					
					$("#chkLocALL").click(function () {
					    $(".LocCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
				
					
				});
			 
   	
   	
	
   	
</script>

</head>
<body onload="funOnLoad();">
  <div class="container transTable">
	<label id="formHeading">Material Issue Location - Group - Sub Group Wise Report</label>
	<s:form name="frmMISLocReport" method="POST"
	           action="rptMISLocationWiseCategoryWiseReport.html" target="_blank">
	
	<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		<div class="row">
			 <div class="col-md-2"><label>From Date</label>
				  <s:input path="dtFromDate" id="txtFromDate" required="required" cssClass="calenderTextBox" style="width:70%"/>
		     </div>
				
			 <div class="col-md-2"><label>To Date</label>
				<s:input path="dtToDate" id="txtToDate" required="required" cssClass="calenderTextBox" style="width:70%"/>
			  </div>
		      <div class="col-md-8"></div>
		      
			  <div class="col-md-2"><label>Report Type</label>
				  <s:select id="cmbDocType" path="strDocType" style="width:auto">
                        <s:option value="XLS">EXCEL</s:option>
						<s:option value="PDF">PDF</s:option>
                  </s:select>
			   </div>
			 
			 <div class="col-md-2"><label>From Location</label>
			       <input type="text" id="txtFrmLocCode" Class="searchTextBox"  ondblclick="funHelp('StoreLocationTo')"  ></input>
		      </div>
		      
			 <div class="col-md-2"><label id="lblFrmLocName" style="background-color:#dcdada94; width:100%; height:51%;margin-top: 27px;padding:4px;"></label>
			 </div>
			<div class="col-md-6"></div>
			
			<div class="col-md-2"><label>Type</label>
				  <s:select id="cmbReportType" path="strReportType" style="width:auto">
                        <s:option value="Detail">Detail</s:option>
						<s:option value="Summary">Summary</s:option>
                  </s:select>
			   </div>
			
			<div class="col-md-2"><label>To Location</label>
			     <input type="text" id="txtLocCode" Class="searchTextBox" placeholder="Type to search"  ></input>
			</div>
			
			<div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width:100%; height:51%;margin-top: 27px;padding:4px;"></label></div>
			<div class="col-md-8"></div>
			<div class="col-md-12"></div>
		<br>
		<!-- 	<td colspan="2">
						<div
							style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">

							<table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#72BEFC">
										<td width="15%"><input type="checkbox" checked="checked" 
										id="chkFromLocALL"/>Select</td>
										<td width="25%">From Location Code</td>
										<td width="65%">From Location Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblFromloc" class="masterTable"
								style="width: 100%; border-collapse: separate;">

								<tr bgcolor="#72BEFC">
									

								</tr>
							</table>
						</div>
				</td> -->
			 <div class="col-md-6">
						<div
							style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">

							<table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="10%"><input type="checkbox" checked="checked" 
										id="chkToLocALL"/>Select</td>
										<td width="25%">To Location Code</td>
										<td width="65%">To Location Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblToloc" class="masterTable"
								style="width: 100%; border-collapse: separate;">

								<!-- <tr bgcolor="#fafbfb">
									

								</tr> -->
							</table>
						</div>
				</div>
				<div class="col-md-6"></div>
				<div class="col-md-12"></div><br>
				<div class="col-md-6">
						<div
							style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
							<table id="" class="display"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="10%"><input type="checkbox" id="chkGALL"
											checked="checked" onclick="funCheckUncheck()" />Select</td>
										<td width="20%">Group Code</td>
										<td width="65%">Group Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="20%"></td>
										<td width="65%"></td>

									</tr>
								</tbody>
							</table>
						</div>
						</div>
						
				<div class="col-md-6">
						<div
							style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">

							<table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="10%"><input type="checkbox" id="chkSGALL"
											checked="checked" onclick="funCheckUncheckSubGroup()" />Select</td>
										<td width="25%">Sub Group Code</td>
										<td width="65%">Sub Group Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblSubGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr>
								</tbody>
							</table>
							
						</div>
				</div>
	         </div>
		<br>
		<p align="center">
			<input type="submit" value="Submit" onclick="return btnSubmit_Onclick()" class="btn btn-primary center-block"
				class="form_button" /> &nbsp;
			<%-- <a STYLE="text-decoration: none" href="frmMaterialIssueRegisterReport.html?saddr=${urlHits}">
			&nbsp; --%>
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
			
			<s:input type="hidden" id="hidToLocCodes" path="strToLoc"></s:input>	
			<s:input type="hidden" id="hidFrmLocCodes" path="strFromLoc"></s:input>	
			<s:input type="hidden" id="hidSubCodes" path="strSGCode"></s:input>
		</div>
	</s:form>
	</div>
	<script type="text/javascript">
	
	</script>
</body>
</html>