<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Move Table</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
    
}
.dynamicTableContainer{
 overflow:hidden;
 border:none;

}
.transTable td {
border-left:none;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
</style>
<script type="text/javascript">

var selectedOccupiedMap = new Map();
var selectedFreeMap = new Map();
var mapOccupiedToolTipData = new Map();
var mapFreeToolTipData = new Map();
var selectedOccupiedRoom="",selectedFreeRoom="";


	/**
		* Success Message After Saving Record
		**/
		$(document).ready(function()
		{
			var message='';
			<%if (session.getAttribute("success") != null) 
			{
				if(session.getAttribute("successMessage") != null)
				{%>
					message='<%=session.getAttribute("successMessage").toString()%>';
				    <%
				    session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) 
				{
					%>alert("Room Changed... \n\n"+message);<%
				}
			}%>
			
			//funLoadData();
			funShowHouseKeepingStatus();	
			
			$("#dteFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteFromDate").datepicker('setDate', 'today');	
			
			$("#dteToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteToDate").datepicker('setDate', 'today');	
			
		});


	
	
//Delete a All record from a grid
	function funRemoveHeaderTableRows(tableName)
	{
		var table = document.getElementById(tableName);
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
		window.open("searchform.html?formname=" + transactionName + "&searchText=", "","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}	
	
	function funValidateData(actionName,object)
	{
		var submitFlag=false;
		var roomsFlag=false;
		var houseKeepingFlag=false;
		
		var table=document.getElementById("tblOccupiedTable");
		var rowCount=table.rows.length;
		for(var i=0;i<rowCount;i++)
		{			
			if(document.getElementById("strRoomFlag."+i).checked)
				{
					roomsFlag=true;
				}			
		}		
			
		var table=document.getElementById("tblAllTable");
		var rowCount=table.rows.length;
		for(var i=0;i<rowCount;i++)
		{		
			if(document.getElementById("strHouseKeepingFlag."+i).checked)
			{
				houseKeepingFlag=true;
			}			
		}
		
		if(roomsFlag==false && houseKeepingFlag==false)
		{
			alert("Please Select At Least One Room and House Keeping Details");
		}
		else if(roomsFlag==false)
		{
			alert("Please Select At Least One Room");
		}
		else if(houseKeepingFlag==false)
		{
			alert("Please Select At Least One House Keeping Details");
		}
		if(roomsFlag==true && houseKeepingFlag==true)
		{
			submitFlag=true;
		}
		
		return submitFlag;	
	}
	
	/**
	* Success Message After Saving Record
**/
function funSetData(code)
{
	switch(fieldName)
	{
		case 'reasonPMS' : 
			funSetReasonData(code);
		break;
		
		
	}
}

/**
* Get and Set data from help file and load data Based on Selection Passing Value(Reason Code)
**/

function funSetReasonData(code)
{
	$("#txtReasonCode").val(code);
	var searchurl=getContextPath()+"/loadPMSReasonMasterData.html?reasonCode="+code;
	 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strReasonCode=='Invalid Code')
		        	{
		        		alert("Invalid Reason Code");
		        		$("#txtReasonCode").val('');
		        	}
		        	else
		        	{	
		        		$("#txtReasonCode").val(response.strReasonCode);
		        		$("#lblReasonDesc").text(response.strReasonDesc);
			        	
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

function funResetFields()
{
	$("#txtReasonCode").val('');
	$("#lblReasonDesc").text('');
	$("#txtRemarks").val('');
	$("#txtFreeRoomCode").val('');
	$("#txtOccupiedRoomCode").val('');
	$("#txtReasonCode").focus();
	selectedOccupiedMap.clear();
	selectedFreeMap.clear();
	mapOccupiedToolTipData.clear();
	mapFreeToolTipData.clear();
	selectedOccupiedRoom="",selectedFreeRoom="";
}



	function funShowHouseKeepingStatus()
	{
		var fromDate=$("#dteFromDate").val();
		var toDate=$("#dteToDate").val();		
		var searchUrl=getContextPath()+"/loadHouseKeepingStatusOfRooms.html?fDate="+fromDate+"&tDate="+toDate;	
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	funFillRoomsTable(response.Rooms);
			    	funFillHouseKeepingDtl(response.HouseKeepingName);
					//StkFlashDataHeader=response[0];
			    	//StkFlashData=response[1];
			    	//showTable();	    	
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
			return false;
	}


function funFillRoomsTable(obj)
{
	 for(var i=0;i<obj.length;i++)
	   {
			var table=document.getElementById("tblOccupiedTable");
			var rowCount=table.rows.length;
			var row=table.insertRow();
		   	row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strRoomDesc\"  id=\"strRoomDesc."+i+"\" value='"+obj[i][1]+"' >";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strRoomNo\" id=\"strRoomNo."+i+"\"value='"+obj[i][0]+"' >";
			row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strRoomFlag\" id=\"strRoomFlag."+i+"\" value='Y' >";
		     
		}
	
}


function funFillHouseKeepingDtl(obj)
{
	for(var i=0;i<obj.length;i++)
	   {
			var table=document.getElementById("tblAllTable");
			var rowCount=table.rows.length;
	   		var row=table.insertRow();
		   	row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strHouseKeepingName\"  id=\"strHouseKeepingName."+i+"\" value='"+obj[i][1]+"' >";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strHouseKeepingCode\" id=\"strHouseKeepingCode."+i+"\" value='"+obj[i][0]+"'>";
			row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listUpdateHouseKeepingStatusBean["+(rowCount)+"].strHouseKeepingFlag\" id=\"strHouseKeepingFlag."+i+"\" value='Y' >";
		   
	   }
	
}



function funCheckboxDirtyRooms()
	{
		var table = document.getElementById("tblOccupiedTable");
		var rowCount = table.rows.length;	
		if ($('#chkDirtyRooms').is(":checked"))
		{
		 	//check all			
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strRoomFlag."+i).checked=1;
	    	}
		}
		else
		{				
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strRoomFlag."+i).checked=0;
	    	}
			
		}	   
	}




function funCheckboxHouseKeeping()
	{
		var table = document.getElementById("tblOccupiedTable");
		var rowCount = table.rows.length;	
		if ($('#chkHouseKeeping').is(":checked"))
		{
		 	//check all			
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strHouseKeepingFlag."+i).checked=1;
	    	}
		}
		else
		{				
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strHouseKeepingFlag."+i).checked=0;
	    	}			
		}	   
	}



</script>


</head>

<body onload="funLoadData()">
	 <div class="transTable" style="margin-left: 10px;width:94%">
		<label id="formHeading">Update House Keeping Status</label>
	     <s:form name="Change Room" method="POST" action="saveHouseKeepingStatus.html" >	
		<div style="display:flex;">
		<div class="dynamicTableContainer" style="height: 400px;width:47%;margin-right:20px;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="20%">Dirty Rooms</td>
					<td width="20%"></td>
					<td style="text-align:center;width:24%; padding:5px;;">Select All<br>
						<input type="checkbox" id="chkDirtyRooms" name="chkBoxAll1" value="Bike"  onclick="funCheckboxDirtyRooms()">
					</td>
				</tr>
			</table>
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblOccupiedTable"  style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
					<tbody>
						<col style="width: 20%">
						<col style="width: 20%">
						<col style="text-align:center;width:20%;">
					</tbody>
				</table>
			</div>
		</div>
		
		<div class="dynamicTableContainer" style="height: 400px;width:47%;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="20%">House Keeping Details</td>
					<td width="20%"></td>
					<td style="text-align:center;width:26%; padding:5px;">Select All<br>
	    				<input type="checkbox" id="chkHouseKeeping" name="chkBoxAll1" value="Bike" style="margin-left: 10px;" onclick="funCheckboxHouseKeeping()">
					</td>
				</tr>
			</table>
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblAllTable"  style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
					<tbody>
						<col style="width: 20%">
						<col style="width: 20%">
						<col style="text-align:center;width:20%;">
					</tbody>
				</table>
			</div>
		</div>
	</div>	
		
	<p align="center" >
            		<input type="submit" value="Save"  class="btn btn-primary center-block" class="form_button" onclick="return funValidateData('submit',this);"/>
            		&nbsp;<input type="reset" value="Reset"  class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
       </p>     		
   		
</s:form>
</div>
</body>
</html>