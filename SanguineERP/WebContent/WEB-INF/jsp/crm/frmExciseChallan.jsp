<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<script type="text/javascript">
	var fieldName;

	$(document).ready(function() 
	{
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		
		$('#txtDispatchTime').timepicker({ 'step': 15 });
		
		$( "#txtDispatchDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$( "#txtDispatchDate" ).datepicker('setDate','today');
		
		$( "#txtECDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$( "#txtECDate" ).datepicker('setDate','today');
		
		$( "#txtGRChallanDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$( "#txtGRChallanDate" ).datepicker('setDate','today');
		
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
			alert("Data Save successfully For \n\n"+message);
		<%
		}}%>
		
	});

	function funSetData(code){

		switch(fieldName){

			case 'ECCode' : 
				funSetECCode(code);
				break;
			case 'ProdCode' : 
				funSetProdCode(code);
				break;
			case 'ProcessCode' : 
				funSetProcessCode(code);
				break;
		}
	}


	function funSetECCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadExciseChallanData.html?ecCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}

	function funSetId(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadId.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}



	function funSetProdCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadProdCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}

	function funSetProcessCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadProcessCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}



	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	
	function funApplyNumberValidation(){
		$(".numeric").numeric();
		$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
		$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
		$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
	    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
	}
	
</script>

</head>
<body>

	<div class="container">
	<label id="formHeading">Excise Challan</label>
	  <s:form name="ExciseChallan" method="POST" action="saveExciseChallan.html?saddr=${urlHits}">

		<div class="row masterTable">
			  <div class="col-md-2"><label>EC Code</label>
				   <s:input type="text" id="txtECCode" path="strECCode" cssClass="searchTextBox" ondblclick="funHelp('ecCode');"/>
			  </div>
			  
			  <div class="col-md-2"><label>EC Date</label>
				   <s:input type="text" id="txtECDate" path="dteECDate" cssClass="calenderTextBox" style="width:70%;"/>
			  </div>
				
			  <div class="col-md-2"><label>Against</label>
				    <s:select id="txtAgainst" path="strAgainst" style="width:auto;">
					    <s:option value="deliveryNote">Delivery Note</s:option>
					    <s:option value="purchaseReturn">Purchase Return</s:option>
					</s:select>
			  </div>
				 <div class="col-md-6"></div>
				 
			    <div class="col-md-2"><label>GR Challan Code</label>
				
		<%-- 		<td>
					<s:input type="text" id="txtGRChallanCode" path="strGRChallanCode" cssClass="searchTextBox" ondblclick="funHelp('GRChallanCode');"/>
				</td> --%>
				
				<s:input type="text" id="txtGRChallanCode" path="strGRChallanCode" />
				</div>
				
			   <div class="col-md-2"><label>GRN Date</label>
				    <s:input type="text" id="txtGRChallanDate" path="dteGRChallanDate" cssClass="calenderTextBox" style="width:70%;"/>
			   </div>
			
			   <div class="col-md-2"><label>S Code</label>
				     <s:input type="text" id="txtScode" path="strScode" />
			    </div>
			  <div class="col-md-6"></div>
			  
			   <div class="col-md-2"><label>Product Code</label>
			 
				<%-- <td>
					<s:input type="text" id="txtProdCode" path="strProdCode" cssClass="searchTextBox" ondblclick="funHelp('ProdCode');"/>
				</td> --%>
				
				    <s:input type="text" id="txtProdCode" path="strProdCode" />
				</div>
				
		        <div class="col-md-2"><label>Process Code</label>
				
<!-- 				<td> -->
<%-- 					<s:input type="text" id="txtProcessCode" path="strProcessCode" cssClass="searchTextBox" ondblclick="funHelp('ProcessCode');"/> --%>
<!-- 				</td> -->
				
				       <s:input type="text" id="txtProcessCode" path="strProcessCode"/>
				</div>
			
		        <div class="col-md-2"><label>Challan Type</label>
				      <s:select id="txtChallanType" path="strChallanType" style="width:auto;">
						<s:option value="jobOrder">Job Order</s:option>
						<s:option value="thirdParty">Third party</s:option>
						<s:option value="return">Return</s:option>
					  </s:select>
				</div>
				<div class="col-md-6"></div>
				
				<div class="col-md-2"><label>Tariff</label>
				       <s:input type="text" id="txtTariff" path="strTariff" />
				</div>
				
			    <div class="col-md-2"><label>Dispatch Date</label>
				        <s:input type="text" id="txtDispatchDate" path="dteDispatchDate" cssClass="calenderTextBox" style="width:70%;"/>
				</div>
				
				 <div class="col-md-2"><label>Dispatch Time</label>
				         <s:input type="datetime-local " id="txtDispatchTime" path="dteDispatchTime" style="border:none;"/>
				</div>					
				<div class="col-md-6"></div>
				
			    <div class="col-md-2"><label>Quantity</label>
				      <s:input type="text"  id="txtQty" path="dblQty" class="decimal-places-amt numeric" />
				</div>
				
				<div class="col-md-2"><label>Unit Price</label>
			           <s:input type="text" id="txtUnitPrice" path="dblUnitPrice" class="BoxW124px decimal-places-amt numeric" />
				</div>
				
			    <div class="col-md-2"><label>Identity Marks</label>
				      <s:input type="text" id="txtIdentityMarks" path="strIdentityMarks"/>
				</div>
				<div class="col-md-6"></div>
				
				<div class="col-md-2"><label>Duration</label>
				       <s:input type="text" id="txtDuration" path="strDuration"/>
				</div>
				
			   <div class="col-md-2"><label>Currency</label>
				      <s:input type="text" id="txtCurrency" path="strCurrency"/>
				</div>
		   </div>
		<br />
		<br />
		<p align="center" style="margin-right: 12%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	
	<script type="text/javascript">
		funApplyNumberValidation();
	</script>
</body>
</html>
