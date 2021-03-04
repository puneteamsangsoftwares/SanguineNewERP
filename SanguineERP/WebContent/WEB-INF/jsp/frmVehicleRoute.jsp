<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title></title>
<script type="text/javascript">
	var fieldName;

	$(function() 
	{
		
		$("#txtFromdate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromdate" ).datepicker('setDate', 'today');
		$("#txtTodate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtTodate" ).datepicker('setDate', 'today');
		
		var message='';
		<%if (session.getAttribute("success") != null) {
			            if(session.getAttribute("successMessage") != null){%>
			            message='<%=session.getAttribute("successMessage").toString()%>';
			            <%
			            session.removeAttribute("successMessage");
			            }
						boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
						session.removeAttribute("success");
						if (test) {
						%>	
			alert("Data Save successfully\n\n"+message);
		<%
		}}%>
		
		funRemoveProdRows();
		funReset()
		
	});
	
	function funSetData(code){

		switch(fieldName){

			case 'VehCode' : 
				funSetVehCode(code);
				break;
				
			case 'RouteCode' : 
				funSetRouteCode(code);
				break;	
		}
	}
	
	function funReset()
	{
		$("#txtVehCode").val('');
		$("#lblVehNo").text('');
		$("#txtRouteCode").val('');
		$("#lblRouteName").text('');
	}


	function funSetVehCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/LoadVehicleMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('Invalid Code' == response.strVehCode){
        			alert("Invalid Vehicle Code");
        			$("#txtVehCode").val('');
        			$("#txtVehCode").focus();
        		}else{
        			
        			$("#txtVehCode").val(response.strVehCode);
        			$("#lblVehNo").text(response.strVehNo);
        			
        			funLoadGrid(code);
        		
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


	function funSetRouteCode(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/LoadRouteMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('Invalid Code' == response.strVehCode){
        			alert("Invalid Route Code");
        			$("#txtRouteCode").val('');
        			$("#txtRouteCode").focus();
        		}else{
        			
        			$("#txtRouteCode").val(response.strRouteCode);
        			$("#lblRouteName").text(response.strRouteName);
        		
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






	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funGetDate(ChangedDate)
	{
		var fullDate = ChangedDate.split(" ");
		var fSplitedDate = fullDate[0].split("-");
		var retDate = fSplitedDate[2]+"-"+fSplitedDate[1]+"-"+fSplitedDate[0];
		
		return retDate ;
	}
	
	function btnAdd_onclick()
	{
		
		funAddRow();
		return false;
	}
	
	function funAddRow()
	{
		var vehNo = $("#lblVehNo").text();
		var routeName=$("#lblRouteName").text();
		
		var fromDate = $("#txtFromdate").val();
		fromDate=funGetDate(fromDate);
		
		var toDate=$("#txtTodate").val();
		toDate = funGetDate(toDate);;
		
		var editedUser ='<%=session.getAttribute("usercode").toString()%>';  
		
		
		var table = document.getElementById("tblRouteDtl");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    row.insertCell(0).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strVehNo\" readonly=\"readonly\" class=\"Box\" size=\"21%\" id=\"txtVehNo."+(rowCount)+"\" value='"+vehNo+"'>";		    
	    row.insertCell(1).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].dtFromDate\" readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"txtFromDate."+(rowCount)+"\" value='"+fromDate+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].dtToDate\" id=\"txtToDate."+(rowCount)+"\" class=\"Box\" required = \"required\" size=\"14%\"  value='"+toDate+"'>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strRouteName\" id=\"txtRouteName."+(rowCount)+"\" required = \"required\" size=\"33%\" class=\"Box\" value='"+routeName+"'>";
	    row.insertCell(4).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strUserModified\" id=\"txtUserModified."+(rowCount)+"\" required = \"required\"  size=\"20%\" class=\"Box\" value='"+editedUser+"'>";
	    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForVeh(this)">';
	   // funApplyNumberValidation();
	    return false;
		
		
	}
	
	function funRemoveProdRows()
	{
		var table = document.getElementById("tblRouteDtl");
		var rowCount = table.rows.length;
		while(rowCount>1)
		{
			table.deleteRow(rowCount);
			rowCount--;
		}
	}
	
	
	function funDeleteRowForVeh(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblRouteDtl");
	    table.deleteRow(index);
	}
	
	
	function funLoadGrid(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/VehRouteDtl.html?vehCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('' == response.strVehCode){
        			alert("Invalid Route Code");
        			$("#txtVehCode").val('');
        			$("#txtVehCode").focus();
        		}else{
        			
        			funRemoveProdRows();
			    	$.each(response, function(i,item)
					    	{
			    		funSetGridData(item.strVehNo,item.dtFromDate,item.dtToDate,item.strRouteName,item.strUserModified);
					    	});
        			
        		
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

	function funSetGridData(vehNo, fromDate, toDate,routeName,editedUser)
	{
		var table = document.getElementById("tblRouteDtl");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    row.insertCell(0).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strVehNo\" readonly=\"readonly\" class=\"Box\" size=\"21%\" id=\"txtVehNo."+(rowCount)+"\" value='"+vehNo+"'>";		    
	    row.insertCell(1).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].dtFromDate\" readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"txtFromDate."+(rowCount)+"\" value='"+fromDate+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].dtToDate\" id=\"txtToDate."+(rowCount)+"\" class=\"Box\" required = \"required\" size=\"14%\"  value='"+toDate+"'>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strRouteName\" id=\"txtRouteName."+(rowCount)+"\" required = \"required\" size=\"33%\" class=\"Box\" value='"+routeName+"'>";
	    row.insertCell(4).innerHTML= "<input name=\"listclsVehicleRouteModel["+(rowCount)+"].strUserModified\" id=\"txtUserModified."+(rowCount)+"\" required = \"required\"  size=\"20%\" class=\"Box\" value='"+editedUser+"'>";
	    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForVeh(this)">';
// 	    funApplyNumberValidation();
	    return false;
	}
	
	
	
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Vehicle Route Master</label>
		<s:form name="VehicleRoute" method="POST" action="saveVehicleRoute.html?saddr=${urlHits}">

		<div class="row masterTable">
			 <div class="col-md-2">
				 <label>Vehicle Code</label>
				 <s:input  type="text" id="txtVehCode" path="strVehCode" cssClass="searchTextBox" ondblclick="funHelp('VehCode');" readOnly="true;"/>	
			</div>
			<div class="col-md-2">
				<label id="lblVehNo" style="background-color:#dcdada94; width: 100%; height: 49%; margin-top: 27px; text-align: center;"></label>	
			</div>
			 <div class="col-md-8"></div>
			<div class="col-md-2">
				<label>Route Code</label>
				<s:input  type="text" id="txtRouteCode" path="strRouteCode" cssClass="searchTextBox" ondblclick="funHelp('RouteCode');" readOnly="true;"/>	
			</div>
			<div class="col-md-2">
				<label id="lblRouteName" style="background-color:#dcdada94; width:100%; height:49%; margin-top:23px; text-align:center;"></label>
			</div>
			
			 <div class="col-md-8"></div>	
			<div class="col-md-2">
				<label>From Date</label>
				<input  type="text" id="txtFromdate"  Class="calenderTextBox" style="width:80%;"/>
			</div>
			<div class="col-md-2">
				<label>To Date</label>
				<input  type="text" id="txtTodate"  Class="calenderTextBox" style="width:80%;"/>
			</div>
			<div class="col-md-2">
			     <a href="#"><button class="btn btn-primary center-block" id="btnAdd" value="Add" onclick="return btnAdd_onclick()">Add</button></a>
			</div>
		</div>				
		
	  <div class="dynamicTableContainer"  style="width: 80%;">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr style="background-color:#c0c0c0">
                    <td  align="left" style="width: 11%; height: 30px;">Vehicle No.</td>
                    <td align="left" style="width: 9%; height: 30px;">From Date</td>
                    <td align="left" style="width: 7%; height: 30px;">To Date</td>
                    <td align="left" style="width: 16%; height: 30px;">Route Name</td>    
                     <td align="left" style="width: 10%; height: 30px;">User Create</td>
                    <td align="left" style="width: 5%; height: 30px;">Delete</td>
                  </tr>
            </table>
                        
            <div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
			<table id="tblRouteDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
                     <tbody>
                      	<col align="left" style="width: 9.8%">   
                        <col align="left" style="width: 7%">                            
                        <col align="left" style="width: 7%">                            
                        <col align="left" style="width: 15%">
                        <col align="left" style="width: 10%">  
                        <col align="left" style="width: 3%">                           
                    	</tbody>
             </table>
            </div>
		</div>
		
		<div class="center" style="margin-right: 20%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit">Submit</button></a>
			&nbsp;
			<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="funResetFields()">Reset</button></a>
		</div>
		
	</s:form>
</div>
</body>
</html>
