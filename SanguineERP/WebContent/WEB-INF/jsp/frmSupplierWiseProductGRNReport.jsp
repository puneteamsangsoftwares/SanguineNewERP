<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<style> 
 .transTable td {
    padding-left: 25px;
 }
 </style>
 
</head>
<script type="text/javascript">

$(function() 
		{
			var startDate="${startDate}";
			var startDateOfMonth="${startDateOfMonth}";
			var arr = startDate.split("/");
			Date1=arr[0]+"-"+arr[1]+"-"+arr[2];
			$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			
			$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
			$("#txtToDate" ).datepicker('setDate', 'today');
			
			
			$("#btnSubmit").click(function( event )
			{
				var fromDate=$("#txtFromDate").val();
				var toDate=$("#txtToDate").val();
				var suppCode=$("#txtPartyCode").val();
				
				if(suppCode=='')
				{
					$("#txtPartyCode").val("All");
					return;
				}
				
				if(fromDate=='')
				{
					alert("Please Enter From Date");
					return;
				}
				if(toDate=='')
				{
					alert("Please Enter To Date");
					return;
				}
				
			});
			 funSetAllSupplier();
			 funGetSubGroupData();
					
		});
		
//Select Location When Clicking Select All Check Box
$(document).ready(function () 
			{
									
				$("#chkSuppALL").click(function () {
				    $(".SuppCheckBoxClass").prop('checked', $(this).prop('checked'));
				});
				
				$("#chkSGALL").click(function () {
				    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
				});
				
			});

function funHelp(transactionName)
{
	fieldName=transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
}

function funSetData(code)
{
	switch (fieldName) 
	{
	case 'suppcode':
    	funSetSupplier(code);
        break;
	}
	
}

function funSetSupplier(code)
{
	
	gurl=getContextPath()+"/loadSupplierMasterData.html?partyCode=";
	$.ajax({
        type: "GET",
        url: gurl+code,
        dataType: "json",
        success: function(response)
        {
        	
        		if('Invalid Code' == response.strPCode){
        			alert("Invalid Supplier Code");
        			$("#txtPartyCode").val('');
        			$("#lblSuppName").focus();
        			
        		}else{
        			$("#txtPartyCode").val(response.strPCode);
					$("#lblSuppName").text(response.strPName);
	
        		}
        		
			
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


//Get and set Supplier  Data 
function funSetAllSupplier() {
		var searchUrl = "";
		searchUrl = getContextPath()+ "/loadAllSupplier.html";
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
				if (response.strSuppCode == 'Invalid Code') {
					alert("Invalid Supplier Code");
					
				} else
				{
					$.each(response, function(i,item)
					 		{
						funfillSuppGrid(response[i].strPCode,response[i].strPName);
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
	
	
//Fill Supplier Data
function funfillSuppGrid(strSuppCode,strSuppName)
{
	
	 	var table = document.getElementById("tblSupp");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    row.insertCell(0).innerHTML= "<input id=\"cbSuppSel."+(rowCount)+"\" name=\"Suppthemes\" type=\"checkbox\" class=\"SuppCheckBoxClass\"  checked=\"checked\" value='"+strSuppCode+"' />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strSuppCode."+(rowCount)+"\" value='"+strSuppCode+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strSName."+(rowCount)+"\" value='"+strSuppName+"' >";
}


//Geting SubGroup Data On the basis of Selection Group
function funGetSubGroupData()
{
	
	var count=0;
	
	
		var searchUrl = getContextPath() + "/loadAllSubGroup.html";
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



//Submit Data after clicking Submit Button with validation 
function btnSubmit_Onclick()
 {
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




	
	 var strSuppCode="";
	 
	 $('input[name="Suppthemes"]:checked').each(function() {
		 if(strSuppCode.length>0)
			 {
			 strSuppCode=strSuppCode+","+this.value;
			 }
			 else
			 {
				 strSuppCode=this.value;
			 }
		 
		});
	 if(strSuppCode=="")
	 {
	 	alert("Please Select To Supplier");
	 	return false;
	 }
	 $("#hidSuppCodes").val(strSuppCode);

	    	document.forms["SupplierwiseGRNReport"].submit();
	
 }
</script>
<body>
	<div  class="container transTable">
		<label id="formHeading"> Supplier wise Category wise GRN Report</label>
	    <s:form name="SupplierwiseGRNReport" method="GET" action="rptSupplierWiseProducttGRNReport.html" target="_blank">
          
          <div class="row">
			 <div class="col-md-2"><label>From Date :</label>
					<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width: 70%;"/>
			 </div>
			 
			 <div class="col-md-2"><label>To Date :</label>
					<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width: 70%;"/>
			 </div>	
			
<!-- 				<td width="140px"> -->
<!-- 				        		<label>Supplier Code </label> -->
<!-- 				        	</td> -->
<!-- 				        	<td  width="15%"> -->
<%-- 				        		<s:input id="txtPartyCode" name="txtPartyCode"  path="strPCode" ondblclick="funHelp('suppcode')"   cssClass="searchTextBox"/> --%>
<!-- 				       	</td><td><label id=lblSuppName>ALL Supplier</label> </td> -->
			<div class="col-md-8"></div>
		
			   <div class="col-md-2"><label>Report Type :</label>
					    <s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    	</s:select>
				</div>
				<div class="col-md-10"></div>
				
			   <div class="col-md-6"><label>Supplier</label>
			          <input style="width: 35%;" type="text" id="txtSuppCode" 
			            Class="searchTextBox" placeholder="Type to search" style="width: 35%;"></input>
			              <label id="lblSuppName"></label>
			   </div>
			
			  <div class="col-md-6"><label>Category</label>
			          <input style="width: 35%;" type="text" id="txtSuppCode" 
			            Class="searchTextBox" placeholder="Type to search" style="width: 35%;"></input>
			           <label id="lblCategory"></label>
			  </div>
			
			    <div class="col-md-6">
					<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
                         <table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="10%"><input type="checkbox" checked="checked" 
										id="chkSuppALL"/>Select</td>
										<td width="25%">Supplier Code</td>
										<td width="65%"> Supplier Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblSupp" class="masterTable"
								style="width: 100%; border-collapse: separate;">

							<!-- 	<tr bgcolor="#fafbfb">
									

								</tr> -->
							</table>
						</div>
				   </div>
				
				<div class="col-md-6">
					<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
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
									<!-- <tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr> -->
								</tbody>
							</table>
					</div>
				</div>
			</div>
			
			<br>
			<p align="center">
				 <!-- <input type="submit" value="Submit"  class="btn btn-primary center-block"  class="form_button"  onclick="btnSubmit_Onclick()"  id="btnSubmit" /> -->
				 <button type="button" class="btn btn-primary center-block" id="btnSubmit" value="Submit" onclick="btnSubmit_Onclick()">Submit</button>
				 &nbsp;
				 <!-- <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/> -->			     
			     <button type="button" class="btn btn-primary center-block" id="btnReset" value="Reset" onclick="funResetFields()">Reset</button>
			</p>
		
			<div id="wait" style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
				
			<s:input type="hidden" id="hidSuppCodes" path="strPCode"></s:input>		
			<s:input type="hidden" id="hidSubCodes" path="strCatCode"></s:input>	
		</div>
		</s:form>
		</div>
	</body>
</html>