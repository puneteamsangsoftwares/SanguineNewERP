<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;
    
	
	function funValidateFields()
	{
		var flag=false;
		if($("#taxToFolioNo").val().trim().length==0)
		{
			alert("Please Select To Folio No.");
		}
		else
		{
			flag=true;
		}	
		var isCheckOk=confirm("Do you want to Transfer Folio???????"); 
		if(isCheckOk)
		{
			flag=true;
			
		}
		else
		{
			flag=false;
		}	
		return flag;
	}
	
	function funSetFolioNo(folioNo)
	{
		$("#taxToFolioNo").val(folioNo);
	}	
	
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		 	
		var FromFolioNo='';
		var ToFolioNO='';
		<%if (session.getAttribute("success") != null) 
		{
			if(session.getAttribute("FromFolioNo") != null && session.getAttribute("ToFolioNO") != null ){%>
				FromFolioNo='<%=session.getAttribute("FromFolioNo").toString()%>';
				ToFolioNO='<%=session.getAttribute("ToFolioNO").toString()%>';
					<%
				session.removeAttribute("FromFolioNo");
			    session.removeAttribute("ToFolioNO");
			}			
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();			
			session.removeAttribute("success");
			if (test) {
				%>
				alert("Folio is Transfer successfully from "+FromFolioNo+" To "+ToFolioNO);
			<%
			}
		}%>
		
		
		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");
		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
	});
	/**
		* Success Message After Saving Record
	**/
	
	/* set date values */
	function funSetDate(id,responseValue)
	{
		var id=id;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);
		
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
	});
	
	function funSetData(code)
	{
		switch(fieldName)
		{
		  case "folioNo":
		  if(fromToFolioNo=='FromFolioNo')
		  {
			  funloadFromFolioData(code);
		  }
		  else if(fromToFolioNo=='ToFolioNo')				
		  {
			  funSetFolioNo(code);
		  }
			break;
			case 'reasonPMS' : 
				funSetReasonData(code);
			break;
			  
			
		}
	}
	var fromToFolioNo="";

	function funHelp(transactionName,frmToFolioNo)
	{
		fromToFolioNo=frmToFolioNo;
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funloadFromFolioData(Code)
	{
		$('#tblFolioTranfer tbody').empty()
		$("#taxFromFolioNo").val(Code);
		var searchUrl=getContextPath()+"/loadFromFolioData.html?FromFolioCode="+Code;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	
        		$.each(response, function(i,item)
                 {	
        			 funAddTranferFolio(response[i][0],response[i][1],response[i][2],response[i][3],response[i][4],response[i][5]);
        			
                 });
        		
        	
			},
			error: function(jqXHR, exception) 
			{
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
	
	
	function  funAddTranferFolio(strFolioNo,strDocDate,strDocNo,strRoom,StrParticular,Amount) {
		
		
		var table=document.getElementById("tblFolioTranfer");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\" name=\"listFolioDtlBean["+(rowCount)+"].strFolioNo\" id=\"strFolioNo."+(rowCount)+"\" value='"+strFolioNo+"' >";
		row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\" name=\"listFolioDtlBean["+(rowCount)+"].dteDocDate\" id=\"dteDocDate."+(rowCount)+"\" value='"+strDocDate+"' >";
		row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\" name=\"listFolioDtlBean["+(rowCount)+"].strDocNo\" id=\"strDocNo."+(rowCount)+"\" value='"+strDocNo+"' >";
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\"  id=\"strRoom."+(rowCount)+"\" value='"+strRoom+"' >";
        row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-right: 5px;width:95%;\"  id=\"StrParticular."+(rowCount)+"\"  value='"+StrParticular+"' >";
        row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-right: 5px;width:112%;text-align: right;\"  id=\"Amount."+(rowCount)+"\"  value='"+Amount+"' >";
		row.insertCell(6).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listFolioDtlBean["+(rowCount)+"].strIsFolioSelected\" onClick=\"Javacsript:funCheckFolioTransfer("+rowCount+")\"  id=\"strIsFolioSelected."+rowCount+"\" value='N' >"; 


	}
	
	
	function funCheckFolioTransfer(count)
	{
		
		var no=0;
		$('#tblFolioTranfer tr').each(function() {
			
			if(document.getElementById("strIsFolioSelected."+no).checked == true)
			{
				document.getElementById("strIsFolioSelected."+no).value='Y';
			
			}
			else
			{
			 document.getElementById("strIsFolioSelected."+no).value='N';
			}
			no++;
		});
	
		
		
	}
	

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
		        		$("#txtReasonDesc").val(response.strReasonDesc);
			        	
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

</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Tranfer Folio</label>
	   <s:form name="TransferFolio" method="POST" action="saveTranferFolio.html">
   
    <div class="row">
            <div class="col-md-2"><label>From Folio No.</label>
				<s:input id="taxFromFolioNo" path="strFromFolioNo" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('folioNo','FromFolioNo')" style="height: 50%;"/>													
			</div>
	            
             <div class="col-md-2"><label>To Folio No</label> 
			 <s:input id="taxToFolioNo" path="strToFolioNo" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('folioNo','ToFolioNo')" style="height: 50%;"/>													
		   </div>
			
		
		</div>
		  <div class="row">
                <div class="col-md-4"><label>Reason Code</label>
				   <div class="row">
				      <div class="col-md-5"><s:input type="text" id="txtReasonCode" path="strReasonCode" cssClass="searchTextBox" ondblclick="funHelp('reasonPMS','reason');" style="height: 25px;"/></div>
				      <div class="col-md-7"><s:input type="text" id="txtReasonDesc" path="strReasonDesc"  style="height: 25px;"/></div>
			       </div>
			    </div> 
			
				<div class="col-md-2"><label>Remarks</label>
				        <s:input type="text" id="txtRemarks" path="strRemarks" style="height: 25px;"/>
				</div>
			</div>
		<br>
		
		<div class="dynamicTableContainer" style="height: 400px; width: 93%;">
		
		<h6>Selected Transfer Folio Details</h6>
		<table style="height: 28px;border: #0F0;width: 100%;font-size: 14px;font-weight: bold;">
				<tbody><tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td style="width: 17%;padding-left: 1.4%;">Folio No</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td style="width: 16%;">Date</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td style="width: 14%;">Doc Code</td>
					<!-- col3   -->
					
					<!-- col4   -->
					<td style="width: 20%;">Room No</td>
					<!-- col4   -->
					
					<!-- col5   -->					
					<td style="width: 20%;">Particulars</td>
					<!-- col5   -->
					
					<!-- col6   -->					
					<td style="width: 24%;">Amount</td>
					<!-- col6   -->
					
					<!-- col7   -->
					<td style="overflow-y: scroll;">Select</td>
					<!-- col7   -->									
				</tr>
			</tbody>								
				
			</table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 323px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblFolioTranfer" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col3-center">
				<tbody>
				<colgroup>
				        <col width="25%">
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="25%">
						<!-- col2   -->
						
						<!-- col3   -->						
						<col width="25%">
						<!-- col3   -->
						
						<!-- col4   -->
						<col width="35%">
						<!-- col4   -->
						
						<!-- col5   -->
						<col align="right" width="25%">
						<!-- col5   -->
						
						<!-- col6  -->
						<col width="30%">
						<!-- col6  -->
						
						<!-- col7   -->
						<col width="12%">
						<!-- col7   -->
					</colgroup>
				</table>
			</div>			
		</div>	
		
		<br />
		<br />
		
		
		<p align="center" style="margin-right:61%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>						
	</s:form>
	</div>
</body>
</html>
