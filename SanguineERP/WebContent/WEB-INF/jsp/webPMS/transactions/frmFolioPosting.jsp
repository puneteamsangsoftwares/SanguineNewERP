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

<style type="text/css">
.masterTable  td{
	padding-left:1px;
	border-left:none;
}
</style>

<script type="text/javascript">
	
	var fieldName;
    var totalAmt=0.00;
    var clickCount =0.0;
	
//reset fields
	function funResetFields()
	{
		var folioText=document.getElementById("strFolioNo");
		folioText.disabled=false;
	}
	
	
//set folio Data
	function funSetFolioData(folioNo)
	{
		$("#strFolioNo").val(folioNo);
		var folioText=document.getElementById("strFolioNo");
		folioText.disabled=true;
				
		/* var searchUrl=getContextPath()+"/loadFolioData.html?folioNo="+folioNo;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strFolioNo=='Invalid Code')
	        	{
	        		alert("Invalid Folio No.");
	        		$("#strFolioNo").val('');
	        	}
	        	else
	        	{					        	    
	        		$("#strFolioNo").val(response.strFolioNo);	        			        	
	        	}
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
		}); */
	}


//set Reservation Data
	function funSetIncomeHeadData(incomeCode)
	{
		$("#strIncomeHead").val(incomeCode);
		var searchUrl=getContextPath()+"/loadIncomeHeadMasterData.html?incomeCode="+incomeCode;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strIncomeHeadCode=='Invalid Code')
	        	{
	        		alert("Invalid Reservation No.");
	        		$("#strIncomeHead").val('');
	        	}
	        	else
	        	{
	        		$("#strIncomeHead").val(response.strIncomeHeadCode);
	        		$("#lblIncomeHeadName").text(response.strIncomeHeadDesc);
	        		$("#dblRate").val(response.dblRate);
	        	}
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
	
//remove income head
	function funRemoveRow(selectedRow,tableId)
	{
	    var rowIndex = selectedRow.parentNode.parentNode.rowIndex;
	    switch(tableId)
	    {
	    	case 'tblIncomeHeadDtl':
	    		document.getElementById("tblIncomeHeadDtl").deleteRow(rowIndex);
	    		break;
	    }
	}
	
//calculate totals
	function funCalculateTotals()
	{
		var totalAmt=0.00;
		var table=document.getElementById("tblIncomeHeadDtl");
		var rowCount=table.rows.length;
		if(rowCount>0)
		{
		    for(var i=0;i<rowCount;i++)
		    {
		    	var containsAccountCode=table.rows[i].cells[2].innerHTML;
		       	totalAmt=totalAmt+parseFloat($(containsAccountCode).val());
		    }
		   	totalAmt=parseFloat(totalAmt).toFixed(maxAmountDecimalPlaceLimit);
		}
		$("#dblTotalAmt").text(totalAmt);
	}

	
//check duplicate value
	function funChechDuplicate(incomeHeadCode)
	{
		var flag=false;
		var table=document.getElementById("tblIncomeHeadDtl");
		var rowCount=table.rows.length;
		if(rowCount>0)
		{
		    for(var i=0;i<rowCount;i++)
		    {
		       var containsAccountCode=table.rows[i].cells[0].innerHTML;
		       var addedIHCode=$(containsAccountCode).val();
		       if(addedIHCode==incomeHeadCode)
		       {
		    	   flag=true;
		    	   break;
		       }
		    }
		}
		return flag;
	}
	
	
//add income head
	function funAddIncomeHeadRow()
	{
		var incomeHeadCode=$("#strIncomeHead").val();
		var incomeHeadName=$("#lblIncomeHeadName").text();
		var amount=$("#dblIncomeHeadAmt").val();
		var quantity = $("#dblQuantity").val();
		var rate = $("#dblRate").val();
		var Remark = $("#idRemark").val();
		var flag=false;
		flag=funChechDuplicate(incomeHeadCode);
		if(flag)
		{
			alert("Already Added.");
		}
		else
		{
			var table=document.getElementById("tblIncomeHeadDtl");
			var rowCount=table.rows.length;
			var row=table.insertRow();
			amount = quantity * rate
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\" name=\"listIncomeHeadBeans["+(rowCount)+"].strIncomeHeadCode\" id=\"strIncomeHeadCode."+(rowCount)+"\" value='"+incomeHeadCode+"' >";
	 	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:95%;\" name=\"listIncomeHeadBeans["+(rowCount)+"].strIncomeHeadDesc\" id=\"strIncomeHeadDesc."+(rowCount)+"\" value='"+incomeHeadName+"' >";
	        row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-right: 5px;width:95%;text-align: right;\" name=\"listIncomeHeadBeans["+(rowCount)+"].dblAmount\" id=\"dblAmount."+(rowCount)+"\"  value='"+amount+"' >";
	        row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-right: 5px;width:112%;\" name=\"listIncomeHeadBeans["+(rowCount)+"].strRemark\" id=\"idtblRemark."+(rowCount)+"\"  value='"+Remark+"' >";

	        row.insertCell(4).innerHTML= "<input type=\"button\" value=\"Delete\" style=\"float: right;\" class=\"deletebutton\" onclick=\"funRemoveRow(this,'tblIncomeHeadDtl')\" />";
			
		//calculate totals
			funCalculateTotals();
			
			/* $("#strIncomeHead").val('');
			$("#dblIncomeHeadAmt").val('');
			
			$("#dblQuantity").val('');
			$("#dblRate").val(''); */
		}
	}
	
	//
	function funAddRow()
	{
		var flag=false;
		
		if($("#strFolioNo").val().trim().length==0)
		{
			alert("Please Select Folio No.");
		}
		else if($("#strIncomeHead").val().trim().length==0)
		{
			alert("Please Select Income Head.");
		}
		else if($("#dblIncomeHeadAmt").val().trim().length==0)
		{
			alert("Please Enter Income Head Amount.");
		}
		else
		{
			flag=true;
			funAddIncomeHeadRow();
		}		
		return flag;
	}
	
	function funValidateFields()
	{
		
		if(clickCount==0){
			clickCount=clickCount+1;
		var flag=true;
		var table=document.getElementById("tblIncomeHeadDtl");
		var rowCount=table.rows.length;
		if($("#strFolioNo").val().trim().length==0)
		{
			alert("Please Select Folio No.");	
			flag=false;
		}
		else if(rowCount<1)
		{
			alert("Please add income head in grid");	
			flag=false;
		}
		else
		{
			var folioText=document.getElementById("strFolioNo");
			folioText.disabled=false;
		}		
		return flag;
		
		}
		else
		{
			return false;
		}
	}

	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
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
				<%-- var AdvAmount='';
				var isOk=confirm("Do You Want to pay Advance Amount ?");
				if(isOk)
 				{
					var checkAgainst="Folio-No";
					AdvAmount='<%=session.getAttribute("AdvanceAmount").toString()%>';
	    			window.location.href=getContextPath()+"/frmPMSPaymentAdvanceAmount.html?AdvAmount="+AdvAmount ;
	    			//session.removeAttribute("AdvanceAmount"); 
	    			
 				}  --%>
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
	
	
	function funSetData(code)
	{
		switch(fieldName)
		{
			case "incomeHead":
				funSetIncomeHeadData(code);
				break;
			
			case "folioNoForNoPost":
				funSetFolioData(code);
				break;
		}
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funUpdateAmt() {
		
		var quantity = $("#dblQuantity").val();
		var rate = $("#dblRate").val();
		var amt = quantity * rate;
		$("#dblIncomeHeadAmt").val(amt);
	}
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Folio Posting</label>
	 <s:form name="Folio Posting" method="POST" action="saveFolioPosting.html">

	<div class="row">
	    <div class="col-md-3">
	      <div class="row">
              <div class="col-md-6"><label>Transaction id.</label> 
			       <s:input id="" path=""   readonly="true" ondblclick="funHelp('transactionId')" cssClass="searchTextBox" style="height: 45%;"/>
			   </div>
			   <div class="col-md-6"><label>Folio No.</label>
			        <s:input id="strFolioNo" path="strFolioNo" readonly="true"  ondblclick="funHelp('folioNoForNoPost')" cssClass="searchTextBox" style="height: 45%;"/>
			   </div>
		</div></div>
			
			<div class="col-md-3"><label>Income Head</label>
			    <div class="row">
                     <div class="col-md-6"><s:input id="strIncomeHead" path=""  readonly="true"  ondblclick="funHelp('incomeHead')" cssClass="searchTextBox" style="height:90%;"/></div>
			         <div class="col-md-6"><label id="lblIncomeHeadName" style="background-color:#dcdada94; width: 100%; height:95%;"></label></div>
			</div></div>
			<div class="col-md-6"></div>
			   
			 <div class="col-md-3">
			     <div class="row"> 
			         <div class="col-md-6"><label>Rate</label>
				              <s:input id="dblRate" path=""/></div>
				              
			         <div class="col-md-6"><label>Quantity</label>
			                  <s:input id="dblQuantity" path="dblQuantity"  onblur="funUpdateAmt();" class="decimal-places-amt numberField" value="1" placeholder="Quantity"  />
			         </div>
			</div></div>			
			
			<div class="col-md-5"><label>Amount</label>
			   <div class="row">
			       <div class="col-md-3"><s:input id="dblIncomeHeadAmt" path=""   class="decimal-places-amt numberField" value="0" placeholder="amt"  /></div>
			       
			</div>
			<div class="row">
			<div class="col-md-3"><label style="margin-left: -323%;">Remark</label><br>
							<s:textarea id="idRemark" path="" style="width: 374px;margin-left: -323%;"/>
					 </div>
				    <div class="col-md-9"><input type="button" value="Add" class="btn btn-primary center-block" class="smallButton" onclick='return funAddRow()'style="margin-top: 15%;"/></div>
				    
				    </div>
				    
			</div>
			
			
			
		</div>
		
		<br/>
		<!-- Generate Dynamic Table   -->		
		<div class="dynamicTableContainer" style="height: 200px; width: 80%">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tbody><tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td style="width: 21%">Income Head Code</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td style="width: 27%;">Income Head Name</td>
					<!-- col2   -->
					
					<!-- col2   -->
					<td style="width: 18%;">Amount</td>
					<!-- col2   -->
					
					<!-- col3   -->					
					<td style="width: 28%;">Remark</td>
					<!-- col4   -->
					
					<!-- col4   -->
					<td>Delete</td>
					<!-- col4   -->									
				</tr>
			</tbody>								
				</tr>
			</tbody></table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblIncomeHeadDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col3-center">
					<tbody>
						<!-- col1   -->
						</tbody><colgroup><col width="25%">
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="35%">
						<!-- col2   -->
						
						<!-- col3   -->
						<col align="right" width="25%">
						<!-- col4   -->
						<col width="35%">
						<!-- col5  -->
						<col width="10%">
						<!-- col4   -->
					</colgroup>
				</table>
			</div>			
		</div>	
		<div class="dynamicTableContainer" style="height: 25px; width: 30%;overflow-x: hidden;background:#fbfafa">
			<div class="row">
				 <div class="col-md-3"> <label>Total</label>
					  <label id ="dblTotalAmt">0.00</label>									
				</div>				
			</div>
		</div>
		<!-- Generate Dynamic Table   -->
		
		<br />
		<p align="right" style="margin-right:40%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()"/>&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
