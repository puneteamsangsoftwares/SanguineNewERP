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
  #tblGroup tr:hover , #tblSubGroup tr:hover{
	background-color: #c0c0c0;
   }
 .transTable td {
   padding-left:26px;
	}

</style>
<script type="text/javascript">
/**
 * Ready Function for Ajax Waiting and reset form
 */
$(document).ready(function() 
		{
			$(document).ajaxStart(function()
		 	{
			    $("#wait").css("display","block");
		  	});
		 	
			/* $(document).ajaxComplete(function()
			{
			    $("#wait").css("display","none");
			});	 */
		});
		
	/**
	 * Ready Function for Searching in Table
	 */
	$(document).ready(function()
		{
			var tablename='';
			$('#searchGrp').keyup(function()
			{
				tablename='#tblGroup';
				searchTable($(this).val(),tablename);
			});
			$('#searchSGrp').keyup(function()
	    	 {
				 tablename='#tblSubGroup';
	    		 searchTable($(this).val(),tablename);
	    	 });
		});

	/**
	 * Function for Searching in Table Passing value(inputvalue and Table Id) 
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
	
		/**
		 * Open help form
		 */
		function funHelp(transactionName)
		{
			fieldName=transactionName;
		//    window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:800px;dialogLeft:300px;")
		    window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:800px;dialogLeft:300px;")
		}
		
		/**
		 * Set All Group data
		 */
		function funGetGroupData()
		{
			var searchUrl = getContextPath() + "/loadAllGroupData.html";
			
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				beforeSend : function(){
					 $("#wait").css("display","block");
			    },
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
		/**
		 * Filling Group Grid 
		 */
		function funfillGroupGrid(strGroupCode,strGroupName)
		{
			
			 	var table = document.getElementById("tblGroup");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    
			    row.insertCell(0).innerHTML= "<input id=\"cbGSel."+(rowCount)+"\" type=\"checkbox\" class=\"GCheckBoxClass\" checked=\"checked\" name=\"Groupthemes\" value='"+strGroupCode+"' onclick=\"funGroupChkOnClick()\"/>";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strGCode."+(rowCount)+"\" value='"+strGroupCode+"' >";
			    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"strGName."+(rowCount)+"\" value='"+strGroupName+"' >";
		}
		/**
		 * After Selected Group Data get the SubGroup Data
		**/	
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

		/**
		 * Getting  SubGroup Based on Group Code Passing Value(Group Codes)
		**/
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
		
		/**
		 * Filling SubGroup Data in Grid
		**/
		function funfillSubGroup(strSGCode,strSGName) 
		{
			var table = document.getElementById("tblSubGroup");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
		}
		/**
		* Remove All rows form grid
		**/
		function funRemRows(tableName) 
		{
			var table = document.getElementById(tableName);
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		/**
		* Ready function for Select All Group, SubGroup 
		**/
			 $(document).ready(function () 
				{
					$("#chkSGALL").click(function () {
					    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
					
					$("#chkGALL").click(function () 
					{
					    $(".GCheckBoxClass").prop('checked', $(this).prop('checked'));
					    funGroupChkOnClick();
					});
					
				});
			 
		/**
		 *  Get Data from help Selection 
		**/
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'locationmaster':
			    	funSetLocation(code);
			        break;
			}
		}
		
		/**
		* Get and set Location Data Passing value(Location Code)
	    **/
		function funSetLocation(code)
		{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    beforeSend : function(){
						 $("#wait").css("display","block");
				    },
				    complete: function(){
				    	 $("#wait").css("display","none");
				    },
				    success: function(response)
				    {
				    	if(response.strLocCode=='Invalid Code')
				       	{
				       		alert("Invalid Location Code");
				       		$("#txtLocCode").val('');
				       		$("#lblLocName").text("");
				       		$("#txtLocCode").focus();
				       	}
				       	else
				       	{
				    	$("#txtLocCode").val(response.strLocCode);
		        		$("#lblLocName").text(response.strLocName);	
		        		$("#txtProdCode").focus();
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
		/**
		* Checking Validation when user Click On Submit Button
		**/
		function funCallFormAction(actionName,object) 
		{	
			var flag=true;
		    if($("#txtLocCode").val()=='')
		    {
		    	alert("Please enter Location Code");
		    	return false;
		    }
		    var strSubGroupCode="";
			 
			$('input[name="SubGroupthemes"]:checked').each(function() {
				 if(strSubGroupCode.length>0)
					 {
					 	strSubGroupCode=strSubGroupCode+","+this.value;
					 }
					 else
					 {
						 strSubGroupCode=this.value;
					 }
			});
			 
			 /**
			  * Set selected subgroup in hidden textfield
			 **/
			 $("#hidSubCodes").val(strSubGroupCode);
			 
			 var strGroupCode="";
			 
				$('input[name="Groupthemes"]:checked').each(function() {
					 if(strGroupCode.length>0)
						 {
						 	strGroupCode=strGroupCode+","+this.value;
						 }
						 else
						 {
							 strGroupCode=this.value;
						 }
				});
				$("#hidGCodes").val(strGroupCode);
			 
			 
			 /**
			  * Export to excel
			 **/
		     if($("#cmbDocType").val()=="XLS")
		    	{
		    		flag=false;
			    	var reportType=$("#cmbDocType").val();
					var locCode=$("#txtLocCode").val();
					var strGCode= $('#strGCode').val();
					var strSGCode=strSubGroupCode;
					var param1=reportType+","+locCode+","+strSGCode;
					var param2=strGCode;
					window.location.href=getContextPath()+"/ExportReOrderLevelRpt.html?param1="+param1 +"&param2="+param2;
		    	}
		    	return flag;
		}
		
		/**
	     * Reset from
	    **/
		function funResetFields()
		{
			location.reload(true); 
		}
		
		/**
	     * Ready function for on blur event in textfield
	    **/
		 $(function() 
		  {
			funGetGroupData();
			$('#txtLocCode').blur(function() {
				var code = $('#txtLocCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetLocation(code);
				}
			});
		  });
</script>
</head>
<body>
<div class="container transTable">
	 <label id="formHeading">Reorder Level Report</label>
	   <s:form name="frmReorderLevelReport" method="POST" action="rptReorderLevelReport.html" target="_blank">
	   
	   <div class="row">
			 <div class="col-md-2"><label>Location Code</label>
			        <s:input id="txtLocCode" path="strDocCode" readonly="true" ondblclick="funHelp('locationmaster')" cssClass="searchTextBox" cssStyle="width:160px;background-position: 138px 4px;"/>
			  </div>
			  
			 <div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height:51%;margin-top: 27px;padding:4px;"></label></div>
		     <div class="col-md-8"></div>
		    
			<%-- <tr>
				<td><label>Group</label></td>
				<td><s:select path="strGCode" items="${command.group}"
						id="strGCode" onchange="funFillCombo(this.value);" cssClass="BoxW124px"></s:select></td>
				<td><label>SubGroup</label></td>
				<td><s:select path="strSGCode" items="${command.subGroup}"
						id="strSGCode" cssClass="BoxW124px">
					</s:select></td>
			</tr> --%>
			
		 <div class="col-md-6"><label>Group</label>
			  <input type="text"  style="width: 35%;" 
			      id="searchGrp" placeholder="Type to search" Class="searchTextBox">
		 </div>
		 
		 <div class="col-md-6"><label>Sub Group</label>
		  	  <input type="text" id="searchSGrp" style="width: 35%;" 
		  		 Class="searchTextBox" placeholder="Type to search">
		 </div>
		 
		 <div class="col-md-6">
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;">
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
									<tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr>
								</tbody>
							</table>
						</div>
				</div>
			
		       <div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType"  style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    </s:select>
				</div>
		    </div>
			
			<br>
			<p align="center">
				<input type="submit" value="Submit"  class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
				&nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
		<s:input type="hidden" id="hidSubCodes" path="strSGCode"></s:input>
		<s:input type="hidden" id="hidGCodes" path="strGCode"></s:input>
		</s:form>
		</div>
</body>
</html>