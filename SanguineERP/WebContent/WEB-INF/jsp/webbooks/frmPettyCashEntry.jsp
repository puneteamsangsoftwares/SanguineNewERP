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
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>
<script type="text/javascript">
    
    
var fieldName;

			function funHelp(transactionName)
			{	       
			   fieldName = transactionName;
			   window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			}
			    
			$(function() 
					{
						$("#txtVouchDate").datepicker({ dateFormat: 'dd-mm-yy' });
						$("#txtVouchDate").datepicker('setDate', 'today');
			
						var message='';
						var retval="";
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
								%> alert("Data Save successfully\n\n"+message);<%
							}
						}%>
					
					});
			
			
			function funSetData(code)
			{

				switch(fieldName){
				case 'expense' : 
					funSetExpCode(code);
					break;
				case 'pettyCash' : 
					funSetPettyCash(code);
					break;
					
					

			   }
			}
			
			function funSetExpCode(code){

				$.ajax({
					type : "GET",
					url : getContextPath()+ "/loadExpenseCode.html?expCode=" + code,
					dataType : "json",
					async:false,
					success : function(response){ 
						if(response.strExpCode!="Invalid Code")
				    	{
							$("#txtExpCode").val(response.strExpCode);
							$("#txtExpenseName").text(response.stnExpName);
							
				    	}
				    	else
					    {
					    	alert("Invalid Account No");
					    	$("#txtExpCode").val("");
					    
					    	return false;
					    }
					},
					error : function(e){
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
			
			
			
			function funSetPettyCash(code){

				$.ajax({
					type : "GET",
					url : getContextPath()+ "/loadPettyCash.html?vouchNo=" + code,
					
					dataType : "json",
					success : function(response){ 
						if(response.strVouchNo!="Invalid Code")
				    	{
							
							$("#txtVouchNo").val(response.strVouchNo);
							$("#txtVouchDate").val(response.dteVouchDate);
							$("#txtNarration").val(response.strNarration);
							$("#txtGrandTotal").val(response.dblGrandTotal);
							$('#tblpettyDetails tbody').empty()
							$.each(response.listDtlModel, function(i,item)
									
							{
								var listDtlModel=response.listDtlModel[i];
								funSetExpCode(listDtlModel.strExpCode);
								funLoadDtlData(listDtlModel.strExpCode,listDtlModel.strNarration,listDtlModel.dblAmount);
							});
							
				    	}
				    	else
					    {
					    	alert("Invalid Account No");
					    	$("#txtGLCode").val("");
					    
					    	return false;
					    }
					},
					error : function(e){
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
			
			
			function funDeleteRow(obj)
			{
			    var index = obj.parentNode.parentNode.rowIndex;
			    var table = document.getElementById("tblpettyDetails");
			    table.deleteRow(index);
			   
			    
			}
			
			
			// Function to add detail grid rows	
			function funLoadDtlData(strExpCode,strNarration,dblAmount)
			{
			    var table = document.getElementById("tblpettyDetails");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    var expName=$("#txtExpenseName").text();
			    
			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listPettyCashDtl["+(rowCount)+"].strExpCode\" id=\"strExpCode."+(rowCount)+"\" value='"+strExpCode+"' />";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"12%\"  id=\"strExpName."+(rowCount)+"\" value='"+expName+"' />";
			    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listPettyCashDtl["+(rowCount)+"].strNarration\" id=\"strNarration."+(rowCount)+"\" value='"+strNarration+"' />";
			    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listPettyCashDtl["+(rowCount)+"].dblAmount\" id=\"dblAmount."+(rowCount)+"\"style=\"text-align: right;\" value='"+dblAmount+"' />";
			    row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
			    $("#txtExpenseName").text('');
			    $("#txtExpCode").val('');
			  		    
			}
			
			
			// Function to add detail grid rows	
			function funGetDetailsRow() 
			{
				
				
				if($("#txtExpCode").val().trim().length == 0 ){
					alert("Please Enter Expense code Or Search");
					$("#txtExpCode").focus()
					 return false;
				}
				var expcode=$("#txtExpCode").val();
				if(funDuplicateProduct(expcode))
			    {
				    var table = document.getElementById("tblpettyDetails");
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    
				    var expName=$("#txtExpenseName").text();
				    var expNarration=$("#txtExpNarration").val();
				    var amount=$("#txtAmount").val();
				    
				    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listPettyCashDtl["+(rowCount)+"].strExpCode\" id=\"strExpCode."+(rowCount)+"\" value='"+expcode+"' />";
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"12%\"  id=\"strExpName."+(rowCount)+"\" value='"+expName+"' />";
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listPettyCashDtl["+(rowCount)+"].strNarration\" id=\"strNarration."+(rowCount)+"\" value='"+expNarration+"' />";
				    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box dblAmount\" size=\"8%\" name=\"listPettyCashDtl["+(rowCount)+"].dblAmount\" id=\"dblAmount."+(rowCount)+"\"style=\"text-align: right;\" value='"+amount+"' />";
				    row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
				    funResetDetailFields();
				    funGetTotal();
			    }
			}
	
			function funDuplicateProduct(expCode)
			{
			    var table = document.getElementById("tblpettyDetails");
			    var rowCount = table.rows.length;
			    var flag=true;
			    if(rowCount > 0)
		    	{
				    $('#tblpettyDetails tr').each(function()
				    {
					    if(expCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added "+ expCode);
					    	funResetDetailFields();
		    				flag=false;
	    				}
					});
			    }
			    return flag;
			}
			
			
			// Reset Detail Fields
			function funResetDetailFields()
			{
				$("#txtExpCode").val('');
			    $("#txtExpenseName").text('');
			    $("#txtAmount").val(0);
			    $("#txtExpNarration").val('');
			}
			
			//Calculating subtotal amount
			function funGetTotal()
			{
				var totalGrand=0.00;
			
				
				$('#tblpettyDetails tr').each(function() {
				    var total = $(this).find(".dblAmount").val();
				    totalGrand=totalGrand+parseFloat(total);
				    
						  
				 });
			
				$("#txtGrandTotal").val(totalGrand);
			
			}
			
			
</script>

<body>
	<div class="container transTable">
		<label id="formHeading">Petty Cash Entry</label>
     	<s:form name="PettyCash" method="POST" action="savePettyCash.html">
		
		<div class="row">
				<div class="col-md-2"><label>Vouch No</label>
					<s:input  type="text" id="txtVouchNo" readonly="true" path="strVouchNo" cssClass="searchTextBox" ondblclick="funHelp('pettyCash');"/>
				</div>
		
				<div class="col-md-2"><label>Vouch Date</label>
				    <s:input  type="text" id="txtVouchDate" path="dteVouchDate" cssClass="calenderTextBox" style="width:70%;" />
				</div>
				   
				<div class="col-md-2"><label id="lblNarration">Narration</label><br>
					<s:textarea  id="txtNarration" path="strNarration" style="height: 25px;" />
				</div>
				       
				<div class="col-md-2"><label>Expense Code</label>
		            <s:input id="txtExpCode" readonly="true" path="" cssClass="searchTextBox" ondblclick="funHelp('expense')" />
				</div>			
					
				<div class="col-md-3"><label  id="txtExpenseName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label>
	    		</div>
	    	
	    		<div class="col-md-2"><label id="lblExpNarration">Expense Narration</label><br>
				 	<s:textarea  id="txtExpNarration" path=""  style="height: 25px; width:100%;"  />
				</div>
						
				<div class="col-md-2"><label>Amount</label>
					<input type="text" id="txtAmount" value="0"   class="decimal-places numberField"/>
				</div>	
			
				<div class="col-md-3">		
					<input type="Button" value="Add" onclick="return funGetDetailsRow()" class="btn btn-primary center-block" class="smallButton" style="margin-top: 21px;"/>
				</div>

		</div>
				
				<div class="dynamicTableContainer" style="height: 300px;width: 99.80%;">
		<table
			style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
			<tr bgcolor="#c0c0c0">
				<td style="width:8%;">Expense Code</td>
				<td style="width:12%;">Expense Name</td>
				<td style="width:22%;">Narration</td>
				<td style="width:5%;">Amount</td>
				<td style="width:2%;">Delete</td>
				
			</tr>
		</table>
		
		<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
			<table id="tblpettyDetails"
				style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
				class="transTablex col8-center">
				<tbody>
					<col style="width:8%">
					<col style="width:12%">
					<col style="width:22%">
					<col style="width:5%">
					<col style="width:2%">
				</tbody>
			</table>
		</div>
	</div>
	
								
		<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
			<table 
				style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
				class="transTablex col8-center">
		 <tr>
			<td style="width:8%;"></td>
				<td style="width:12%;"></td>
				<td style="width:22%;"><label id="lblTotal">Total</label></td>
				<td style="width:9%;"><s:input id="txtGrandTotal" type="text"  path="dblGrandTotal" readonly="true"   cssClass="decimal-places-amt numberField"/></td>
				
			 
<!-- 				<td ><label id="lblTotal">Total</label></td> -->
<%-- 			    <td ><s:input id="txtGrandTotal" type="text"  path="dblGrandTotal" readonly="true"   cssClass="decimal-places-amt numberField"/></td> --%>
		    </tr>
		    </table>
		    </div>
	
				<br />
		<br />
		<p align="right">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp
			 <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
		</s:form>
	</div>
</body>
</html>