<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Void Bill</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>


<style type="text/css">
.transTable td{
	padding-left:1px;
	border-left:none;
}
</style>

<script type="text/javascript">
    $(function(){
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#txtBillDate").timepicker();
		$("#txtBillDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtBillDate").datepicker('setDate', pmsDate);
	});
	
	function funHelp(transactionName)
	{
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")		
	}
	function funSetData(code)
	{
		$("#txtBillNo").val(code);
		document.all["divReason"].style.display = 'block';
		funLoadVoidBillData(code);
	}
	function funLoadVoidBillData(code){
		var searchUrl=getContextPath()+ "/loadVoidBill.html?strBillNo=" + code;;
		$.ajax({
			type :"GET",
			url : searchUrl,
			dataType : "json",
			async: false,
			success: function(response){
				$("#txtFolioNo").val(response[0].strFolioNo);
				var billDate=response[0].strBilldate.split(" ")[0].split("-");
				
				$("#txtBillDate").val(billDate[2]+"-"+billDate[1]+"-"+billDate[0]);
				$("#txtGuestName").val(response[0].strGuestName);
				$("#txtRoomNo").val(response[0].strRoomNo);
				$("#txtRoomName").val(response[0].strRoomName);
				//$("#txtExtraBed").val(response[0].strExtraBed);
				
				$("#txtTotalAmt").val(response[0].dblTotalAmt);
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
	
	function funFillBillTable(strFolioNo,docNo,incomeHead,incomeHeadPrice,strRevenueCode){
		 	var table = document.getElementById("tblVoidBillDetails");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
	
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strFolioNo\" id=\"strFolioNo."+(rowCount)+"\" value='"+strFolioNo+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strRevenueCode\" id=\"strRevenueCode."+(rowCount)+"\" value='"+strRevenueCode+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strMenuHead\" id=\"strMenuHead."+(rowCount)+"\" value='"+incomeHead+"' />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].dblIncomeHeadPrice\" id=\"dblIncomeHeadPrice."+(rowCount)+"\" value='"+incomeHeadPrice+"' />";
		    row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" style=\"text-align: center;width:100%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
            row.insertCell(5).innerHTML= "<input type=\"hidden\" class=\"Box\" size=\"1%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strDocNo\" id=\"strDocNo."+(rowCount)+"\" value='"+docNo+"' />"; 
		    
	}
	//Delete a All record from a grid
	function funRemoveRows()
	{
		var table = document.getElementById("tblVoidBillDetails");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	//Function to Delete Selected Row From Grid
	function funDeleteRow(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblVoidBillDetails");
	    table.deleteRow(index);
	
	}

	function funBtnFullVoidBill(){
		$("#txtVoidType").val("fullVoid");
		
		if($("#txtBillNo").val()==''){
			alert("Select Bill No");
			return false;
		}
		var table = document.getElementById("tblVoidBillDetails");
		var rowCount = table.rows.length;
		if(rowCount==0){
			alert(" No Folio Present");
			return false;
		}
		if($("#cmbReason").val==''){
			alert("select reason");
			return false;
		}
		if($("#txtRemark").val()==''){
			alert("Enter Valied Remark");
			return false;
		}
		
		
	}
	function funBtnVoidBillItem(){
		$("#txtVoidType").val("itemVoid");
		
		if($("#txtBillNo").val()==''){
			alert("Select Bill No");
			return false;
		}
		var table = document.getElementById("tblVoidBillDetails");
		var rowCount = table.rows.length;
		if(rowCount==0)
		{
			alert("Please Select Full Void Option");
			return false;
		}
		if($("#cmbReason").val()==''){
			alert("Select Reason");
			return false;
		}
		if($("#txtRemark").val()==''){
			alert("Enter Valied Remark");
			return false;
		}
		
	}

	/**
	* Success Message After Saving Record
	**/
	 $(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessage") != null) {%>
			            message='<%=session.getAttribute("successMessage").toString()%>';
						<%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success"))
						.booleanValue();
				session.removeAttribute("success");
				if (test) {%>
	alert("Data Save successfully\n\n" + message);
<%}
			}%>
	});
</script>
</head>

<body>
 <div class="container transTable">
	<label id="formHeading">Void Bill</label>
	 <s:form name="frmVoidBill" method="POST"
		action="voidBill.html?saddr=${urlHits}">
     <div class="row">
           <div class="col-md-3">
			 <div class="row">
			       <div class="col-md-6"><label>Bill No.</label>
				        <s:input id="txtBillNo" path="strBillNo" cssClass="searchTextBox" ondblclick="funHelp('billNo')" />
			       </div>
			       <div class="col-md-6"><label>Folio No</label>
				        <s:input id="txtFolioNo" path="strFolioNo" style="height: 23px;"/>
			       </div>
	        </div></div>
			
			<div class="col-md-3">
			  <div class="row">
			     <div class="col-md-6"><label>Bill Date</label>
				    <s:input id="txtBillDate" required="required" path="strBilldate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox" />
			    </div>
                <div class="col-md-6"><label>Guest Name</label>
				   <s:input id="txtGuestName" path="strGuestName" style="height: 23px;"/>
		        </div>
		    </div></div>
		   
			<div class="col-md-2"><label>Room No</label>
				    <s:input id="txtRoomName" path="strRoomName" style="height: 23px;" />
		     </div>

			<div class="col-md-1"><s:input type="hidden" id="txtRoomNo" path="strRoomNo" /></div>
			<div class="col-md-1"><s:input type="hidden" id="txtVoidType" path="strVoidType" /></div>
				<%-- <td><label>Extra Bed</label></td>	
				<td><s:input id="txtExtraBed" path="strExtraBed"  cssClass="longTextBox"/></td> --%>
             <div class="col-md-2"></div>
		    
            <div class="col-md-1"><label style="width: 125%">Total Amount</label>
				<s:input id="txtTotalAmt" path="dblTotalAmt" style="text-align:right; height: 23px;"/>
		    </div>
			
					<%-- <td><label>Room No</label></td>	
				<td><s:input id="strBillNo" path="strBillNo"  cssClass="longTextBox"/></td>
				<td><label>Extra Bed</label></td>	
				<td><s:input id="strBillNo" path="strBillNo"  cssClass="longTextBox"/></td>
				  --%>
			 
			 <div class="col-md-2" id="divReason"><label>Reason</label>
					<s:select id="cmbReason" path="strReason">
							<s:options items="${listReason}" />
					</s:select>
			  </div>	
			  	
			 <div class="col-md-2"><label>Remark</label>
						<s:input id="txtRemark" path="strRemark" style="height: 24px;"/>
			  </div>
		</div>		
				<p align="right" style="margin-right:34%">
                      <input type="submit" value="Full Void Bill" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funBtnFullVoidBill()" />
                </p>
		
		<div class="dynamicTableContainer" style="height: 300px;">
			<table
				style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0">

					<td style="width: 8%;">Folio</td>
					<td style="width: 8%;">Revenue Code</td>
					<!-- <td style="width:7%;">Doc Code</td> -->
					<td style="width: 14%;">Income Head</td>
					<td style="width: 9%;">Total</td>
					<td style="width: 3%;">Delete</td>

				</tr>
			</table>

			<div
				style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblVoidBillDetails"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
					<col style="width: 8%;">
					<col style="width: 8%;">
					<%-- 	<col style="width: 7%;"> --%>
					<col style="width: 14%;">
					<col style="width: 9%;">
					<col style="width: 3%;">
					<col style="width: 0%;">
					</tbody>
				</table>
			</div>
		</div>

		<br />
		<p align="center">
			<input type="submit" value="Void Bill" tabindex="3" class="btn btn-primary center-block"
				class="form_button" onclick="return funBtnVoidBillItem()" />&nbsp;
		    <input  type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" class="btn btn-primary center-block"
				onclick="funResetFields()" />
		</p>
      </s:form>
     </div>
</body>
</html>