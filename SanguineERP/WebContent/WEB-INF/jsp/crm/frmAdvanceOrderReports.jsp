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

<style>
  #tblGroup tr:hover , #tblSubGroup tr:hover{
	background-color: #c0c0c0;
	
}
.transTable {
	margin:0px;
	}
.transTable td {
	padding-left: 0px;
	border-left:none;
	}
</style>
<script type="text/javascript">




		//set date
		$(document).ready(function(){
			/*$("#dteFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteFromDate").datepicker('setDate', 'today');	*/
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
			$( "#dteFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$("#dteFromDate" ).datepicker('setDate', Dat);
			
			$("#dteToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteToDate").datepicker('setDate', 'today');	
		});
		











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
		   // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:800px;dialogLeft:300px;")
		   
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
			    
			    row.insertCell(0).innerHTML= "<input id=\"cbGSel."+(rowCount)+"\" type=\"checkbox\" style=\"margin-left: 37%;\" class=\"GCheckBoxClass\" checked=\"checked\" name=\"Groupthemes\" value='"+strGroupCode+"' onclick=\"funGroupChkOnClick()\"/>";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strGCode."+(rowCount)+"\" value='"+strGroupCode+"' >";
			    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strGName."+(rowCount)+"\" value='"+strGroupName+"' >";
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
		    
		    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" style=\"margin-left: 37%;\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
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
					
					$('a#baseUrl').click(function() {
						
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
						 
					
						frmAndToDate=$("#dteToDate").val()+"dte"+$("#dteFromDate").val()+"dte"+$("#cmbType").val();
						
						var strGrpCode=$("#hidGCodes").val();
						var strSubGrpCode=$("#hidSubCodes").val();
						
						
						//Open Document Attach Link
						 window.open('attachImageAdvOrd.html?transName=frmAdvanceOrderReport.jsp&formName=Advance Orer Product Image&code='+frmAndToDate+"&strGrpCode="+strGrpCode+"&strSubGrpCode="+strSubGrpCode,"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
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
		
		 function update_date(selecteDate){
			var date = $('#dteFromDate').val();
			$('#dteToDate').val(selecteDate);
		}
		 
		 
		 
		 function funGetImage()
			{
				var searchUrl = getContextPath() + "/loadImage.html";
				
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

</script>
</head>
<body>
     <div class="container transTable">
		<label id="formHeading">Advance Order Report</label>
	    <s:form name="AdvanceOrderReport" method="POST" action="rptAdvOrderReport.html" target="_blank" enctype="multipart/form-data">
	   		
	   		<div class="row">
	   			<div class="col-md-12" style="text-align:right;padding-right: 83px;"><a id="baseUrl" href="#">
						Export Image</a>&nbsp; &nbsp; &nbsp; &nbsp;
				</div>
			</div>
		
		     <div class="row">
	   		    <div class="col-md-3"><label>From Fullfillment Date</label>
					 <s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" onchange="update_date(this.value);" style="width:50%"/>
			     </div>
				<div class="col-md-3"><label>To Fullfillment Date</label>
				     <s:input type="text" id="dteToDate" path="dteToDate" required="true" class="calenderTextBox" style="width:50%"/>
				</div>				
			</div>
		  
			   <br>
			   
			  <table class="transTable">
		<tr>
		<td width="49%">Group&nbsp;&nbsp;&nbsp;
			<input type="text"  style="width: 30%" 
			id="searchGrp" placeholder="Type to search" Class="searchTextBox">
		 </td>
		 <td width="49%">Sub Group&nbsp;&nbsp;&nbsp;&nbsp;
		  		 <input type="text" id="searchSGrp" 
		  		 style="width: 30%" 
		  		 Class="searchTextBox" placeholder="Type to search">
		 </td>
		  </tr>
			
			<td style="padding: 5 !important; margin-right: 16px;">
						<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block;  width:97%; margin-top:7px;">
						<table id="" class="display"style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center"
								style="width: 100%;">
							<tbody>
								<tr bgcolor="#c0c0c0">
									<td style="text-align:center;width:14%;">Select<br>
										<input type="checkbox" id="chkGALL" checked="checked" onclick="funCheckUncheck()" /></td>
									<td width="35%">To Customer Code</td>
									<td width="65%">To Customer Name</td>
								</tr>
							</tbody>
						</table>
						<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
							<table id="tblGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<colgroup>
										<col style="text-align:center;width:5%;">
										<col style="width:13%">
										<col style="text-align:center;width:20%;">
								</colgroup>
							</table>
						</div>
					</div>
						</td>
						<td>
						<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; width:97%;margin-top:7px;">
							<table id="" class="masterTable"
								style="width: 100%;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td style="text-align:center;width:14%;">Select<br>
										<input type="checkbox" id="chkSGALL"checked="checked" onclick="funCheckUncheckSubGroup()" /></td>
										<td width="30%">Sub Group Code</td>
										<td width="65%">Sub Group Name</td>
									</tr>
								</tbody>
							</table>
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
							<table id="tblSubGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<colgroup>
										<col style="text-align:center;width:5%;">
										<col style="width:13%">
										<col style="text-align:center;width:20%;">
								</colgroup>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>
			  
			   <div class="row">
			  
			      <div class="col-md-2" ><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" style="width:70%;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
<%-- 				    		<s:option value="CSV">CSV</s:option> --%>
				    </s:select>
					</div>
					
				 <div class="col-md-2" ><label>Order Type</label>
					<s:select id="cmbType" path="strReportType" style="width:70%;">
							
							<option value="Advance Order">Advance Order</option>
							<option value="Urgent Order">Urgent Order</option>
				    </s:select>
					</div>
					
			   	<div class="col-md-2" ><label>Show Image</label>
					<s:select id="cmbExportType" path="strExportType" style="width:70%;">
				    		<s:option value="No">No</s:option>
				    		<s:option value="Yes">Yes</s:option>
				    </s:select>
				</div>
			</div>
			<br>
			<p align="center">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
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