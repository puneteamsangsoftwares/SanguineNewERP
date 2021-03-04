<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<title>Void Bill</title>
<script type="text/javascript">

	$(function(){
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		//$("#txtBillDate").timepicker();
		//$("#txtBillDate").datepicker({ dateFormat: 'dd-mm-yy' });
		//$("#txtBillDate").datepicker('setDate', pmsDate);
		$("#txtBillDate").val(pmsDate);
		
		document.getElementById("txtBillDate").readOnly = true;
		document.getElementById("txtFolioNo").readOnly = true;
		document.getElementById("txtGuestName").readOnly = true;
		document.getElementById("txtRoomName").readOnly = true;
		document.getElementById("txtTotalAmt").readOnly = true;
		//document.getElementById("cmbReason").readOnly = true;
		$("#cmbReason").attr('disabled',true);
		document.getElementById("txtRemark").readOnly = true;
		document.getElementById("tblChangeBillDetails").readOnly = true;
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
				$("#txtGRNNo").val(response[0].strGSTNo);
				$("#txtCompanyName").val(response[0].strCompanyName);
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
		 	var table = document.getElementById("tblChangeBillDetails");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
	
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strFolioNo\" id=\"strFolioNo."+(rowCount)+"\" value='"+strFolioNo+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strRevenueCode\" id=\"strRevenueCode."+(rowCount)+"\" value='"+strRevenueCode+"' />";
		   /*  row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strDocNo\" id=\"strDocNo."+(rowCount)+"\" value='"+docNo+"' />"; */
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].strMenuHead\" id=\"strMenuHead."+(rowCount)+"\" value='"+incomeHead+"' />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;width:100%\" name=\"listVoidBilldtl["+(rowCount)+"].dblIncomeHeadPrice\" id=\"dblIncomeHeadPrice."+(rowCount)+"\" value='"+incomeHeadPrice+"' />";
		    //row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" style=\"text-align: center;width:100%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
		    row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" style=\"text-align: center;width:100%\" value = \"Delete\" />";
	}
	//Delete a All record from a grid
	function funRemoveRows()
	{
		var table = document.getElementById("tblChangeBillDetails");
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
	    var table = document.getElementById("tblChangeBillDetails");
	    table.deleteRow(index);
	}

	function funSaveBill(){
		if($("#txtBillNo").val()==""){
			alert("Select Bill No");
			return false;
		}
		var table = document.getElementById("tblChangeBillDetails");
		var rowCount = table.rows.length;
		if(rowCount<0){
			alert(" No Folio Present");
			return false;
		}
		if($("#cmbReason").val==""){
			alert("select reason");
			return false;
		}
		if($("#txtRemark").val==""){
			alert("Enter Valid Remark");
			return false;
		}
		
		if($("#txtGRNNo").val()==""){
			alert("GRN No should not be blank");
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

	});
	
	function funResetField()
	{
		location.reload(true);
		return false;
	}
</script>
</head>
<body>
	<div class="container">
		<label id="formHeading">Change GST No</label>
		<s:form name="frmChangeGSTNoOnBill" method="POST" action="updateGSTNoOnBill.html?saddr=${urlHits}">
			<div class="transTable" style="overflow: hidden;width: 100%;">
				<div class="row">
					<div class="col-md-2">
						<label>Bill No.</label><br>	
						<s:input id="txtBillNo" path="strBillNo"  cssClass="searchTextBox" ondblclick="funHelp('billNo')"/>
					</div>
					<div class="col-md-2">
						<label>Folio No</label><br>	
						<s:input type="text" id="txtFolioNo" path="strFolioNo" readonly="true"/>
					</div>
					<div class="col-md-2">
						<label>Bill Date</label><br>	
				       	<s:input type="readonly" id="txtBillDate" required="required" path="strBilldate" pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"
				       		style="border: none; width: 70%; padding: 4px;"/>
					</div>
					<div class="col-md-2">
						<label>Guest Name</label><br>		
						<s:input type="readonly" id="txtGuestName" path="strGuestName" style="border: none; padding: 4px;"/>
					</div>
					<div class="col-md-4"></div>
					<div class="col-md-2">	
						<label>Room No</label><br>		
						<s:input type="readonly" id="txtRoomName" path="strRoomName" style="border: none; padding: 4px;width: 100%;"/>
					</div>
					<div class="col-md-2">
						<label>Total Amount</label><br>		
						<s:input type="readonly" id="txtTotalAmt" path="dblTotalAmt" style="text-align:right;border: none; padding: 4px;width: 100%;"/>
					</div>
					<div class="col-md-2">
						<label>GST No</label><br>		
						<s:input id="txtGRNNo" path="strGSTNo" style="text-align:right;"/>
					</div>
					<div class="col-md-2">
						<label>Company Name</label><br>	
						<s:input id="txtCompanyName" path="strCompanyName"/>
					</div>
					<div class="col-md-3">	
						<s:input type="hidden" id="txtRoomNo" path="strRoomNo"/>
						<s:input type="hidden" id="txtVoidType" path="strVoidType"/>
					</div>
				</div>
				<div id="divReason" style="display:none;">
					<div class="row">
						<div class="col-md-2">
							<label>Reason</label><br>	
							 <s:select type="readonly" id="cmbReason" path="strReason" cssClass="BoxW124px" style="color:#000;">
	    			 			<s:options items="${listReason}"/>
	    					</s:select>
    					</div>
    					<div class="col-md-2">
			    			<label>Remark</label><br>	
			    			<s:input type="readonly" id="txtRemark" path="strRemark"/>
			    		</div>
			    	</div>
				</div>
			</div>
			<div class="dynamicTableContainer" style="height: 300px;width:70%;">
					<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0">
							<td style="width:8%;">Folio</td>
							<td style="width:7.5%;">Revenue Code</td>
							<!-- <td style="width:7%;">Doc Code</td> -->
							<td style="width:14%;">Income Head</td>
							<td style="width:9%; text-align: center;">Total</td>
							<td style="width:3%;">Delete</td>
						</tr>
					</table>
				<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
					<table id="tblChangeBillDetails" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col8-center">
						<tbody>
							<col style="width: 8.5%;">
							<col style="width: 8%;">
						<%-- <col style="width: 7%;"> --%>
							<col style="width: 15%;">
							<col style="width: 9%;">
							<col style="width: 3%;">
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="center" style="margin-right: 30%;">
				<a href="#"><button class="btn btn-primary center-block" value="Update" onclick="return funSaveBill()" type="submit" tabindex="3"
					class="form_button">Update</button></a>
				<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="return funResetField()"
					class="form_button">Reset</button></a>
			</div>
	</s:form>
</div>
</body>
</html>