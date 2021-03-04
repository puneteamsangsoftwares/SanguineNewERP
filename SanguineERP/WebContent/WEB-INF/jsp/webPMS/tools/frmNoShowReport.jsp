<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
</head>

<script>


	function funValidateFields()
	{
		var flag=false;
			flag=true;
			
			var fromDate=$("#dteFromDate").val();
			var toDate=$("#dteToDate").val();
			
			var fd=fromDate.split("-")[0];
			var fm=fromDate.split("-")[1];
			var fy=fromDate.split("-")[2];
			
			var td=toDate.split("-")[0];
			var tm=toDate.split("-")[1];
			var ty=toDate.split("-")[2];
			
			$("#dteFromDate").val(fy+"-"+fm+"-"+fd);
			$("#dteToDate").val(ty+"-"+tm+"-"+td);
			
		
			
			window.open(getContextPath()+"/frmNoShowReportList.html?fromDate="+fy+"-"+fm+"-"+fd+"&toDate="+ty+"-"+tm+"-"+td+" ");
		
		return flag;
	}


//set date
		$(document).ready(function(){
			
			var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
			 
			$("#dteFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteFromDate").datepicker('setDate', pmsDate);	
			
			
			$("#dteToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteToDate").datepicker('setDate', pmsDate);	
			$("#btnExecute").click(function( event )
			{
			funCalculateStockFlashForSummary();
			return false;
			});
		});
		
		function funCalculateStockFlashForSummary()
		{
			var fromDate=$("#dteFromDate").val();
			var toDate=$("#dteToDate").val();
			
			var fd=fromDate.split("-")[0];
			var fm=fromDate.split("-")[1];
			var fy=fromDate.split("-")[2];
			
			var td=toDate.split("-")[0];
			var tm=toDate.split("-")[1];
			var ty=toDate.split("-")[2];
			
// 			$("#dteFromDate").val(fy+"-"+fm+"-"+fd);
// 			$("#dteToDate").val(ty+"-"+tm+"-"+td);
			var searchUrl=getContextPath()+"/frmNoShowReportList.html?fromDate="+fy+"-"+fm+"-"+fd+"&toDate="+ty+"-"+tm+"-"+td;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {				    	
				    	StkFlashData=response[0];
				    	showTable();
 				    	funGetTotalValue(response[1]/currValue);
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
		
		function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(StkFlashData.length, optInit);	
		    $("#divValueTotal").show();
		    
		}
		
		var items_per_page = 10;
		function getOptionsFromForm()
		{
		    var opt = {callback: pageselectCallback};
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 10;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		}
		
		var totAmt=0;
		function pageselectCallback(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, StkFlashData.length);
		    var newcontent="";
			var currValue='<%=session.getAttribute("currValue").toString()%>';
    		if(currValue==null)
    			{
    				currValue=1;
    			}	
		
		   
			   	newcontent = '<table id="tblNoShow" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labls1">Guest Name</td><td id="labls2">Reservation No</td><td id="labls3">No Of Rooms</td><td id="labls4">Payment</td></tr>';
					   
			    // Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<tr><td>'+StkFlashData[i].strGuestName+'</td>';
			        
			        newcontent += '<td>'+StkFlashData[i].strReservationNo+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strNoOfRooms+'</td>';
			       newcontent += '<td align="right">'+parseFloat((StkFlashData[i].dblPayment/currValue)).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
			       totAmt=totAmt+StkFlashData[i].dblPayment/currValue;
			      
			    }
		    
			    $("#txtTotValue").val(totAmt);
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
		
		$(document).ready(function () 
				{			 
					$("#btnExport").click(function (e)
					{
						
						var fromDate=$("#dteFromDate").val();
						var toDate=$("#dteToDate").val();
						
						var rowCount = document.getElementById('tblNoShow').rows.length;
						if(rowCount>1)
						{
						window.location.href=getContextPath()+"/downloadNoShowFlashExcel.html?fromDate="+fromDate+"&toDate="+toDate;
						}
						else
						{
						alert("No Data Present For Selected Date");
						}	
				});
					
				});			
				
		
		
</script>
<body onload="funOnLoad();">
	<div class="container">
		<label id="formHeading">No Show Report </label>
		<s:form name="frmNoShowReport" method="GET" action="" >
			<div class="row masterTable">
				<div class="col-md-3">
					<div class="row">
						<div class="col-md-6">
							<label>From Date</label>
							<s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" />
						</div>
						<div class="col-md-6">
							<label>To Date</label>
							<s:input type="text" id="dteToDate" path="dteToDate" required="true" class="calenderTextBox" />
						</div>	
					</div>
				</div>
				<div class="col-md-1">
					<s:select path="strExportType" id="cmbExportType" style="margin-top:27px;">
						<option value="Excel">Excel</option>
					</s:select>
				</div>
			</div>
			<div class="center" style="margin-right:68%;">
				<button class="btn btn-primary center-block" id="btnExecute"  value="Execute" onclick=""
					class="form_button">Execute</button>&nbsp
				<button class="btn btn-primary center-block" id="btnExport" value="Export" 
					class="form_button">Export</button>
			</div>
			
		<br>
		<br>
		<dl id="Searchresult" style="width: 95%; margin-left: 26px; overflow:auto;"></dl>
		<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
		
		</div>
			<div id="divNoShow">
		<table id="tblNoShow" class="transTablex" style="width: 95%;font-size:11px;font-weight: bold;">
		<tr style="margin-left: 28px">
			<td id="labld26" width="80%" align="right">Total Value</td>
			<td id="tdTotValue" width="10%" align="right">
			<input id="txtTotValue" style="width: 100%;text-align: right;" class="Box"></input></td>
		</tr>
		</table>
		</div>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			</div>
	
	</s:form>
</div>
</body>
</html>