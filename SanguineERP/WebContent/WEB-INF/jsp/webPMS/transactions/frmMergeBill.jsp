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
    var total=0;
	
	function funValidateFields()
	{
		var flag=false;
		if($("#strBillNo").val().trim().length==0)
		{
			alert("Please Select Bill No.");
		}
		else
		{
			flag=true;
			
		}
		
		return flag;
	}
	
	function funValidateRevertFields()
	{
		var flag=false;
		if($("#strBillNo").val().trim().length==0)
		{
			alert("Please Select Bill No.");
		}
		else
		{
			var billNo = $("#strBillNo").val();
			window.open(getContextPath()+"/saveRevertBill.html?billNo="+billNo+"");
		}
		
		return flag;
	}
	
	function funSetBillNo(billNo)
	{
		$("#strFromBillNo").val(billNo);
		funLoadBillData(billNo);
	}	
	
	function funSetBillNoForCheckIn(billNo)
	{
		$("#strBillNo").val(billNo);
		funLoadBillDataForCheckIn(billNo);
	}
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
				{
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
			alert(message);
		<%
		}}%>
		
		 <%-- var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");
		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
		  
			var billNo='<%=session.getAttribute("BillNo").toString()%>';
			if(billNo!='')
			 {
				 $("#strBillNo").val(billNo);
				
				 funSetBillNo(billNo);
				 <%session.removeAttribute("BillNo");
				 %>
			 }
			 else
			 {
				
				 $("#strBillNo").val("");
				 <%session.removeAttribute("BillNo");
				 %>
				 
			 }
			  --%>
		  

	}); 
	/**
		* Success Message After Saving Record
	**/
	
	/* set date values */
	
	/*
	function funSetDate(id,responseValue)
	{
		var id=id;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);		
	}*/
	
	//set date
	<%-- $(document).ready(function(){
		
		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#dteFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteFromDate").datepicker('setDate', pmsDate);
		
		
		$("#dteToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteToDate").datepicker('setDate', pmsDate);
		
		$("#chkBill").click(function ()
		{
		    $(".suppCheckBoxClass").prop('checked', $(this).prop('checked'));
		});
	
	});
	--%>
	function funSetData(code)
	{
		switch(fieldName)
		{
			case "MergeBill":
				 if(fromToBillNo=='FromBillNo')
				  {
					 funLoadFromBillData(code);
				  }
				  else if(fromToBillNo=='ToBillNo')				
				  {
					  funSetBillNo(code);
				  }
				
				
				break;
			case 'reasonPMS' : 
				funSetReasonData(code);
			break;	
		}
	}
	
	function funSetBillNo(billNo)
	{
		$("#strToBillNo").val(billNo);
	}
    
	var fromToBillNo="";
	function funHelp(transactionName,frmToBillNo)
	{
		fromToBillNo=frmToBillNo;
		fieldName=transactionName;
		var fromDate=$("#dteFromDate").val();
		var toDate=$("#dteToDate").val();
		var type=$("#cmbType").val();
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	}
	
 	function funLoadFromBillData(code)
       {
 		 $('#tblBillDetails tbody').empty()
 		 $("#strFromBillNo").val(code);
	     var searchUrl=getContextPath()+ "/loadBillDataForMergeBill.html?strBillNo=" + code;;
		 $.ajax({
			type :"GET",
			url : searchUrl,
			dataType : "json",
			async: false,
			success: function(response){
				//funRemoveRows();
				$.each(response, function(i,item)
				{
					funFillBillTable(response[i][0],response[i][1],response[i][2],response[i][3],response[i][4],response[i][5],response[i][6]);
				});
				
			},
			error : function(jqXHR, exception)
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

	function funLoadBillDataForCheckIn(code){
		var searchUrl=getContextPath()+ "/loadBillDetailsForCheckin.html?strBillNo=" + code;;
		$.ajax({
			type :"GET",
			url : searchUrl,
			dataType : "json",
			async: false,
			success: function(response){
				funRemoveRows();
				$.each(response, function(i,item)
				{
					funFillBillTable(response[i].strFolioNo,response[i].strDocNo,response[i].strMenuHead,response[i].dblIncomeHeadPrice,response[i].strRevenueCode);
				});
				
			},
			error : function(jqXHR, exception)
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
	
	
	function funFillBillTable(strBillNo,strFolioNo,strDocNo,strCheckInNo,strGuestName,dteCheckOutDate,strTotal){
	 	var table = document.getElementById("tblBillDetails");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);

	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].strFromBillNo\" id=\"strBillNo."+(rowCount)+"\" value='"+strBillNo+"' />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].strFolioNo\" id=\"strFolioNo."+(rowCount)+"\" value='"+strFolioNo+"' />";
	   	row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].strDocNo\" id=\"strDocNo."+(rowCount)+"\" value='"+strDocNo+"' />";
	   	row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].strCheckInNo\" id=\"strCheckInNo."+(rowCount)+"\" value='"+strCheckInNo+"' />";
	   	row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].strGuestName\" id=\"strGuestName."+(rowCount)+"\" value='"+strGuestName+"' />";
	   	row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listMergeBill["+(rowCount)+"].dteCheckoutdate\" id=\"dteCheckOutDate."+(rowCount)+"\" value='"+dteCheckOutDate+"' />";
	    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;width:100%\" name=\"listMergeBill["+(rowCount)+"].dblDblTotal\" id=\"dblDblTotal."+(rowCount)+"\" value='"+strTotal+"' />";
		row.insertCell(7).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listMergeBill["+(rowCount)+"].strIsBillSelected\" onClick=\"funCheckBillTransfer("+rowCount+")\"  id=\"strIsBillSelected."+rowCount+"\" value='N' >"; 
	    total = total+strTotal;
	    funCalculateTotal(total);
	   // row.insertCell(0).innerHTML= "<input id=\"cbSuppSel."+(rowCount)+"\" name=\"Suppthemes\" type=\"checkbox\" class=\"SuppCheckBoxClass\"  checked=\"checked\" value='"+strSuppCode+"' />";
	}
	function funCalculateTotal(total)
	{
		$("#txtTotValue").val(total);
	}
	function funDeleteRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblBillDetails");
	    table.deleteRow(index);
	}
	function funRemoveRows()
	{
		var table = document.getElementById("tblBillDetails");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	} 
	

	function funCheckBillTransfer(count)
	{
		
		var no=0;
		$('#tblBillDetails tr').each(function() {
			
			if(document.getElementById("strIsBillSelected."+no).checked == true)
			{
				document.getElementById("strIsBillSelected."+no).value='Y';
			
			}
			else
			{
			 document.getElementById("strIsBillSelected."+no).value='N';
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
  <div class="container masterTable" style="width:90%;">
	<label  id="formHeading">Merge Bills</label>
	    <s:form name="BillMerge" method="POST" action="saveMergeBill.html">

       <div class="row">
     		 <div class="col-md-3">
			     <div class="row">
			       <div class="col-md-6"><label>From Bill No.</label>
				       <s:input id="strFromBillNo" path="strFromBillNo"  cssClass="searchTextBox" ondblclick="funHelp('MergeBill','FromBillNo')" style="height: 45%;"/><!-- 	From Bill No -->		       				       
			       </div>
			          <div class="col-md-6"><label>To Bill No.</label>
				       <s:input id="strToBillNo" path="strToBillNo"  cssClass="searchTextBox" ondblclick="funHelp('MergeBill','ToBillNo')" style="height: 45%;"/><!-- 	From Bill No -->		       				       
			       </div>
		
			     <!--   <div class="col-md-6">
			     <a href="#"><button class="btn btn-primary center-block" id="btnAdd" value="Add" onclick="return btnAdd_onclick()">Add</button></a>
			</div> -->
		     </div></div>
		</div>
		<div class="row">
                <div class="col-md-4" ><label>Reason Code</label>
				   <div class="row">
				      <div class="col-md-5"><s:input type="text" id="txtReasonCode" path="strReasonCode" cssClass="searchTextBox" ondblclick="funHelp('reasonPMS','reason');" style="height: 25px;"/></div>
				      <div class="col-md-7"><s:input type="text" id="txtReasonDesc" path="strReasonDesc"  style="height: 25px;"/></div>
			       </div>
			    </div> 
			
				<div class="col-md-2"><label>Remarks</label>
				        <s:input type="text" id="strRemarks" path="strRemarks" style="height: 25px;"/>
				</div>
			</div>
		<div class="dynamicTableContainer" style="width:90%;height: 300px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:12%;">Bill No</td>
						<td style="width:12%;">Folio No</td>
						<td style="width:11%;">Doc No</td>
						<td style="width:22%; text-align: center;">Check In No</td>
						<td style="width:12%; text-align: center;">Guest Name</td>
						<td style="width:12%; text-align: center;">Checkout Date</td>
						<td style="width:13%; text-align: center;">Total</td>
						<td style`="width:3%;">Select</td>
					</tr>
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblBillDetails"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8.5%;">
						<col style="width: 8%;">
						<col style="width: 9%;">
						<col style="width: 15%;">
						<col style="width: 9%;">
						<col style="width: 9%;">
						<col style="width: 9%;">
						<col style="width: 3%;">
						
					</tbody>
				</table>
			</div>
		</div>
			
		
		<div id="divValueTotal" style="background-color: #c0c0c0; border: 1px solid #ccc; display: block; height: 25px; overflow-x: hidden; overflow-y: hidden; width: 90%;">
			<table id="tblTotalFlash" class="transTablex" style="width: 100%; font-size: 11px; font-weight: bold;">
				<tr style="margin-left: 28px">
					<td id="labld26" width="50%" align="right">Total Value</td>
					<td id="tdTotValue" width="10%" align="right">
						<input id="txtTotValue" style="width: 80%; text-align: right;font-size: 14px;" class="Box"></input>
					</td>
				</tr>
			</table>
		</div>
		
		<br />
		<p align="center" style="margin-right:-68%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()" />&nbsp;
<!-- 			<input type="button" value="Revert Bill" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateRevertFields()" />&nbsp;
 -->			
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
			
		</p>
		<s:input type="hidden" id="hidData" path="" ></s:input>				
	</s:form>
	</div>
</body>
</html>
