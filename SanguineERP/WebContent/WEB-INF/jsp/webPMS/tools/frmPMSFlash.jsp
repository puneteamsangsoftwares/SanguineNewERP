<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />


	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
	<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
        <!-- Load data to paginate -->
	<link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />

	
	<script type="text/javascript">
	
	var pmsFlashData;
	
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
		
			return flag;
	}


//set date
		$(document).ready(function(){
					
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
			$("#dteFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#dteFromDate").datepicker('setDate',Dat);
			
			var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
			
			$("#dteToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#dteToDate").datepicker('setDate', pmsDate);
			
			$("#btnExecute").click(function( event )
			{
				var fromDate=$("#txtFromDate").val();
				var toDate=$("#txtToDate").val();
				
					funShowPMSFlash();
					
					return false;
				
			});
				
			$(document).ajaxStart(function()
			{
			    $("#wait").css("display","block");
			});
			$(document).ajaxComplete(function()
			{
				$("#wait").css("display","none");
			});
			
			
			
		});
		
		
		function funShowPMSFlash()
		{
			var report=$("#cmbReport").val();
			var fromDate=$("#dteFromDate").val();
			var fdate = fromDate.split('-');
			var fromDate=fdate[2]+'-'+fdate[1]+'-'+fdate[0];
			
			var toDate=$("#dteToDate").val();
			var tdate = toDate.split('-');
			var toDate=tdate[2]+'-'+tdate[1]+'-'+tdate[0];
			var searchUrl=getContextPath()+"/frmPMSFlashDetail.html?report="+report+"&fDate="+fromDate+"&tDate="+toDate;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {				    	
				    	pmsFlashData=response;
				    	showTable();
				    	//funGetTotalValue(response[1]);
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
		    $("#Pagination").pagination(pmsFlashData.length, optInit);	
		    //$("#divValueTotal").show();
		    
		}
		
		
		var items_per_page = 10;
		function getOptionsFromForm()
		{
			var report=$("#cmbReport").val();
			var opt = '';
			if(report=='Corporate')
			{
				opt = {callback: pageselectCallbackCorporate};
			}
			if(report=='Booker')
			{
				opt = {callback: pageselectCallbackBooker};
			}
			if(report=='Agent')
			{
				opt = {callback: pageselectCallbackAgent};
			}
		   
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 10;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		}
		
		
		function pageselectCallbackCorporate(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, pmsFlashData.length);
		    var newcontent="";
		    		    	
			   	newcontent = '<table id="tblPMSFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labld1" size="10%">Reservation No</td><td id="labld2"> Guest Name</td><td id="labld3"> Corporate Desc</td>	<td id="labld4"> Arrival Date </td>	<td id="labld5"> Arrival Time</td><td id="labld6"> Departure Date</td><td id="labld7"> Departure Time</td></tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<td>'+pmsFlashData[i].strReservationNo+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].guestName+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].strCorporateDesc+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteArrivalDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeArrivalTime+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteDepartureDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeDepartureTime+'</td>';
			       
			    }			   
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
		
		
		function pageselectCallbackBooker(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, pmsFlashData.length);
		    var newcontent="";
		    		    	
			   	newcontent = '<table id="tblPMSFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labld1" size="10%">Reservation No</td><td id="labld2"> Guest Name</td><td id="labld3"> Booker Name</td>	<td id="labld4"> Arrival Date </td>	<td id="labld5"> Arrival Time</td><td id="labld6"> Departure Date</td><td id="labld7"> Departure Time</td></tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<td>'+pmsFlashData[i].strReservationNo+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].guestName+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].strBookerName+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteArrivalDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeArrivalTime+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteDepartureDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeDepartureTime+'</td>';
			       
			    }			   
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
		
		function pageselectCallbackAgent(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, pmsFlashData.length);
		    var newcontent="";
		    		    	
			   	newcontent = '<table id="tblPMSFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labld1" size="10%">Reservation No</td><td id="labld2"> Guest Name</td><td id="labld3"> Agent Name</td><td id="labld4"> Commision Paid</td> <td id="labld5"> Arrival Date </td>	<td id="labld6"> Arrival Time</td><td id="labld7"> Departure Date</td><td id="labld8"> Departure Time</td></tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<td>'+pmsFlashData[i].strReservationNo+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].guestName+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].strAgentName+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].strCommisionPaid+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteArrivalDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeArrivalTime+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].dteDepartureDate+'</td>';
			        newcontent += '<td>'+pmsFlashData[i].tmeDepartureTime+'</td>';
			       
			    }			   
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
		
		
		
		
		
		
		
</script>
<body onload="funOnLoad();">
	<div class="container">
		<label id="formHeading">PMS Flash </label>
		<s:form name="frmPMSFlash" method="GET" action="" >
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
				<div class="col-md-2">
					<label>Report</label>
						<s:select id="cmbReport" name="cmbReport" path="strReport" cssClass="BoxW124px" >
						 	<option value="Corporate">Corporate</option>
		 				 	<option value="Booker">Booker</option>
		 				 	<option value="Agent">Agent</option>
<!-- 		 				 	<option value="Booker">Booker</option> -->
<!-- 		 				 	<option value="Booker">Booker</option> -->
						 </s:select>
				</div>
			</div>
		
			<div class="center" style="margin-right:60%;">
				<button class="btn btn-primary center-block" id="btnExecute"  value="Execute" onclick=""
					class="form_button">Execute</button>&nbsp
				<button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
					class="form_button">Reset</button>
			</div>
			<br>
		<dl id="Searchresult" style="width: 95%; margin-left: 26px; overflow:auto;"></dl>
		<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
		</div>
	</s:form>
</div>
</body>
</html>