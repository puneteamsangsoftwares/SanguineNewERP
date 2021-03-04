<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Material Requisition Slip</title>
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
 
    <script type="text/javascript">
    
    /**
	 * Ready Function for Searching in Table
	 */
    $(document).ready(function()
    		{
    			var tablename='';
    			$('#txtToLocCode').keyup(function()
    	    			{
    						tablename='#tblToloc';
    	    				searchTable($(this).val(),tablename);
    	    			});
    			
    		});

	    /**
		 * Function for Searching in Table passing value(input value and table name)
		 */
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
    	var fieldName;
    
    	/**
    	 * Reset Textfield
    	 */
    	function funResetFields()
    	{
    		$("#txtFromReqCode").val('');
    		$("#txtToReqCode").val('');
    	}
    	
    	
    	/**
    	 * Ready Function for Initialize textField with default value
    	 * And Set date in date picker 
    	 * And Getting session Value
    	 */
    	$(function() 
    			{	
		    		var startDate="${startDate}";
		    		var startDateOfMonth="${startDateOfMonth}";
					var arr = startDate.split("/");
					Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
    				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFromDate" ).datepicker('setDate',startDateOfMonth);
    				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtToDate" ).datepicker('setDate', 'today');
    				var strPropCode='<%=session.getAttribute("propertyCode").toString()%>';
        			funRemRows("tblFromloc");
        			funRemRows("tblToloc");
        			var locationCode ='<%=session.getAttribute("locationCode").toString()%>';
        			 //funSetFromLocation(locationCode);
        			funSetAllLocationAllPrpoerty();
    			});
    	
    	/**
    	 * Open help form
    	 */
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
			//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=", 'window', 'width=600,height=600');
			if(transactionName=="ToMaterialReq")
				{
// 					transactionName="MaterialReq";
					transactionName="MaterialReqSlip";
				} 

		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
			
	    }
		
    	/**
		 * Set Data after selecting form Help windows
		 */
		function funSetData(code)
		{
			switch (fieldName) 
			{
				 case 'MaterialReq':
					 $("#txtFromReqCode").val(code);
			        break;
			    case 'ToMaterialReq':
			    	$("#txtToReqCode").val(code);
			        break;
			    case 'locby':
			    	funSetFromLocation(code);
			        break;
			        
			    case 'MaterialReqSlip':
					 $("#txtFromReqCode").val(code);
			        break;

			}
			
			
		}
		
		
		/**
		* Get and Set All Location All Property
		**/
		function funSetAllLocationAllPrpoerty() {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadAllLocationForAllProperty.html";
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
		
		/**
		*  Get and Set From Location Data Passing Value(Location Code)  
		**/
		function funSetFromLocation(code) {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadLocationMasterData.html?locCode=" + code;

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
						funfillFromLocationGrid(response.strLocCode,response.strLocName);
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
	     
			/**
			*  Filling Location From Grid 
			**/
		    function funfillFromLocationGrid(strLocCode,strLocationName)
			{
				 	var table = document.getElementById("tblFromloc"); 
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    
				    row.insertCell(0).innerHTML= "<input id=\"cbFromLocSel."+(rowCount)+"\" name=\"FromLocthemes\" type=\"checkbox\" class=\"FromLocCheckBoxClass\"  checked=\"checked\" value='"+strLocCode+"' />";
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strFromLocCode."+(rowCount)+"\" value='"+strLocCode+"' >";
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strFromLocName."+(rowCount)+"\" value='"+strLocationName+"' >";
			}
			
		    /**
			*  Filling Location To Grid 
			**/
		    function funfillToLocationGrid(strLocCode,strLocationName)
			{
				
				 	var table = document.getElementById("tblToloc");
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    
				    row.insertCell(0).innerHTML= "<input id=\"cbToLocSel."+(rowCount)+"\" name=\"ToLocthemes\" type=\"checkbox\" class=\"ToLocCheckBoxClass\"  checked=\"checked\" value='"+strLocCode+"' />";
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strToLocCode."+(rowCount)+"\" value='"+strLocCode+"' >";
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strToLocName."+(rowCount)+"\" value='"+strLocationName+"' >";
			}
		    /**
			*  Remove All Row From Grid 
			**/	
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
		    
		    /**
			*  Ready function for Select All From Location and To Location When User Click On Select All Check Box
			**/
		    $(document).ready(function () 
					{
						$("#chkFromLocALL").click(function () {
						    $(".FromLocCheckBoxClass").prop('checked', $(this).prop('checked'));
						});
						
						$("#chkToLocALL").click(function () {
						    $(".ToLocCheckBoxClass").prop('checked', $(this).prop('checked'));
						});
						
					});
		    
		    /**
			*  Check Validation Before Submit The Form
			**/
		    function funCallFormAction(actionName,object) 
			{	
			
		    	var spFromDate=$("#txtFromDate").val().split('-');
				var spToDate=$("#txtToDate").val().split('-');
				var FromDate= new Date(spFromDate[2],spFromDate[1]-1,spFromDate[0]);
				var ToDate = new Date(spToDate[2],spToDate[1]-1,spToDate[0]);
				if(!fun_isDate($("#txtFromDate").val())) 
			    {
					 alert('Invalid From Date');
					 $("#txtFromDate").focus();
					 return false;  
			    }
			    if(!fun_isDate($("#txtToDate").val())) 
			    {
					 alert('Invalid To Date');
					 $("#txtToDate").focus();
					 return false;  
			    }
				if(ToDate<FromDate)
				{
						alert("To Date Should Not Be Less Than Form Date");
				    	$("#txtToDate").focus();
						return false;		    	
				}
			    var strFromLocCode="";
				$('input[name="FromLocthemes"]:checked').each(function()
					{
						 if(strFromLocCode.length>0)
							 {
							 	strFromLocCode=strFromLocCode+","+this.value;
							 }
							 else
							 {
								 strFromLocCode=this.value;
							 }
						 
					 });
						
					 /**
					  *  Set All Selected From Location In hidden TextField 
					 **/
					 $("#hidFromLocCodes").val(strFromLocCode);
					 
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
					 
					 /**
					  *  Set All Selected To Location In hidden TextField 
					 **/
					 $("#hidToLocCodes").val(strToLocCode);
					 document.forms[0].action = "rptReqSlip.html";
			    }
			
    </script>
  </head>
<body>
   <div class="container transTable">
		<label id="formHeading">Material Requisition Slip</label>
	<s:form name="ReqSlip" method="GET" action="rptReqSlip.html" target="_blank">
     
        <div class="row">	
		         <div class="col-md-2"><label id="lblFromDate">From Date</label>
				       <s:input id="txtFromDate" name="fromDate"
						path="dtFromDate" cssClass="calenderTextBox" required="true" style="width:70%"/> 
						<s:errors path="dtFromDate"></s:errors>
				</div>
					
				<div class="col-md-2"><label id="lblToDate">To Date</label>
				       <s:input id="txtToDate" name="toDate"
						path="dtToDate" cssClass="calenderTextBox" required="true" style="width:70%"/> 
						<s:errors path="dtToDate"></s:errors>
				</div>
	             <div class="col-md-8"></div>
	             
		        <div class="col-md-2"><label>From Location</label>
		                <input type="text" id="txtFromLocCode" ondblclick="funHelp('locby')" Class="searchTextBox" readOnly="true"></input>
			     </div>
			     
			     <div class="col-md-3"><label id="lblFromLocName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label></div>
			     <div class="col-md-1"></div>
			     
			     <div class="col-md-2"><label>To Location</label>
			           <input type="text" id="txtToLocCode" style="width:100%;" class="searchTextBox" placeholder="Type to search"></input>
			     </div>
			
			     <div class="col-md-3"><label id="lblToLocName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label></div>
			
				 <div class="col-md-6">
					<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
                        <table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="10%"><input type="checkbox" id="chkFromLocALL"
											checked="checked" />Select</td>
										<td width="25%">From Location Code</td>
										<td width="65%">From Location Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblFromloc" class="masterTable"
								style="width: 100%; border-collapse: separate;">

								<tr bgcolor="#fafbfb">
									<td width="15%"></td>
									<td width="25%"></td>
									<td width="65%"></td>

								</tr>
							</table>
						</div>
					</div>
					 <div class="col-md-6">
						<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
                            <table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
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

								<tr bgcolor="#fafbfb">
									<td width="15%"></td>
									<td width="25%"></td>
									<td width="65%"></td>

								</tr>
							</table>
						</div>
				       </div>
		   	
		      <div class="col-md-2"><label>Requisition Code</label>
		
		<%-- <td width="150px" colspan="2"><s:input type ="text" path="strDocCode" id="txtReqCode" name="strMISCode" readonly="readonly"  class="searchTextBox" style="width: 150px;background-position: 136px 4px;" ondblclick="funHelp('MaterialReq')"/> </td> --%>
		
		           <s:input type ="text" path="strFromDocCode" id="txtFromReqCode" name="strFromReqCode" readonly="true" placeholder="From Requisition Code"  class="searchTextBox" style="width: 155px;background-position: 137px 5px;" ondblclick="funHelp('MaterialReqSlip')"/> 
		      </div>
		        
		 <div class="col-md-2">
		        <s:input type ="text" path="strToDocCode" id="txtToReqCode" name="strToReqCode" readonly="true" placeholder="To Requisition Code"  class="searchTextBox" style="width: 150px;background-position: 136px 2px;margin-top:27px" ondblclick="funHelp('ToMaterialReq')"/> 
		</div>
		
	 <div class="col-md-8"></div>
	 <div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" style="width:50%">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    </s:select>
	  </div>
	</div>

		<p align="center">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" class="form_button"/>
			 &nbsp;
			 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields();"/>
		</p>
			<s:input type="hidden" id="hidFromLocCodes" path="strFromLocCode"></s:input>
			<s:input type="hidden" id="hidToLocCodes" path="strToLocCode"></s:input>
 </s:form>
 </div>
</body>
</html>