<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reason Master</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
$(document).ready(function(){
	 resetForms('reasonForm');
	    $("#txtReasonName").focus();	
});
</script>

<script type="text/javascript">
	var clickCount =0.0;	
	function funHelp(transactionName) {
		
	//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}

	function funSetData(code) {
		
			$.ajax({
					type : "GET",
					url : getContextPath()
							+ "/loadReasonMasterData.html?reasonCode=" + code,
					dataType : "json",
					success : function(response) {
						if('Invalid Code' == response.strReasonCode){
							alert("Invalid reason Code");
							$("#txtReasonCode").val('');
							$("#txtReasonName").val('');
							$("#txtReasonCode").focus();
						}else{
							$("#txtReasonCode").val(response.strReasonCode);
							$("#txtReasonName").val(response.strReasonName);
							$("#txtReasonDesc").val(response.strReasonDesc);
							$("#txtExpiryDate").val(response.dtExpiryDate.split(" ")[0]);
							if (response.strStockAdj == 'Y') {
								$("#chkStockAdj").attr('checked', true);
							} else {
								$("#chkStockAdj").attr('checked', false);
							}
							document.getElementById("chkStocktra").checked = response.strStocktra == 'Y' ? true: false;
							document.getElementById("chkNonConf").checked = response.strNonConf == 'Y' ? true: false;
							document.getElementById("chkFollowUps").checked = response.strFollowUps == 'Y' ? true: false;
							document.getElementById("chkCorract").checked = response.strCorract == 'Y' ? true: false;
							document.getElementById("chkPrevAct").checked = response.strPrevAct == 'Y' ? true: false;
							document.getElementById("chkResAlloc").checked = response.strResAlloc == 'Y' ? true: false;
							document.getElementById("tchkDelcha").checked = response.strDelcha == 'Y' ? true: false;
							document.getElementById("chkLeadMaster").checked = response.strLeadMaster == 'Y' ? true: false;
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

	$(function() {
		$('a#baseUrl').click(function() {
			if ($("#txtReasonCode").val().trim() == "") {
				alert("Please Select Reason Code");
				return false;
			}
 
			 window.open('attachDoc.html?transName=frmReasonMaster.jsp&formName=Reason Master&code='+$('#txtReasonCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
 
		});
		
		
		$('#txtReasonCode').blur(function(){
			 var code=$('#txtReasonCode').val();			     
			 if (code.trim().length > 0 && code !="?" && code !="/") {
			  		funSetData(code);
			  	}			 
		});
		
		$("#txtExpiryDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		var dt = new Date();
		var currentDateTime=dt.getDay()+"-"+(dt.getMonth()+1)+"-"+(dt.getYear()+1901);
		$("#txtExpiryDate" ).datepicker('setDate', currentDateTime);
	});
	
	function funResetFields()
	{
		$("#txtReasonName").focus();
		$("#chkStockAdj").attr("checked", false);
    }
	
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
	
	$(document).ready(function()
	{
		var moduleName='<%=session.getAttribute("moduleName").toString()%>';
		if(moduleName=="7-WebBanquet")
		{
			$("#stockAdjust").text("Banquet");
			$('#stockTransfer').hide();
			$('#chkStocktra').hide();
			$('#nonConference').hide();
			$('#chkNonConf ').hide();
			$('#secondRow').hide();
			$('#thirdRow').hide();
		}
	});
	
	
	function funvalidate()
	{
		if($('#txtReasonCode').val()=='')
		{
			var code = $('#txtReasonName').val().trim();
			if(clickCount==0){
				clickCount=clickCount+1;
			 $.ajax({
			        type: "GET",
			        url: getContextPath()+"/checkReasonName.html?reasonName="+code,
			        async: false,
			        dataType: "text",
			        success: function(response)
			        {
			        	if(response=="true")
			        		{
			        			alert("Reason Name Already Exist!");
			        			$('#txtReasonName').focus();
			        			flg= false;
				    		}
				    	else
				    		{
				    			flg=true;
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
		else
		{
			return false;
		}
		}
		//alert("flg"+flg);
		return flg;
	}
	
</script>
</head>

<body>
	<div class="container masterTable">
		<label id="formHeading">Reason Master</label>
	   <s:form method="POST" name="reasonForm" action="savereasonmaster.html?saddr=${urlHits}">
			<!-- <a id="baseUrl"
					href="#"> Attach Documents</a> -->
					
		<div class="row">
				<div class="col-md-2"><label>Reason Code </label>
				    <s:input path="strReasonCode" readonly="true" ondblclick="funHelp('reason')" id="txtReasonCode" cssClass="searchTextBox" />
			    </div>
			
			<div class="col-md-2"><label>Reason Name</label>
				 <s:input path="strReasonName" cssStyle="text-transform: uppercase;" id="txtReasonName" required="true" />
			</div>
			<div class="col-md-8"></div>
			
			<div class="col-md-2"><label>Description</label>
				<s:input path="strReasonDesc" cssStyle="text-transform: uppercase;"	id="txtReasonDesc"/>
			</div>
			
			<div class="col-md-2"><label>Expiry Date</label>
				<s:input id="txtExpiryDate" name="txtExpiryDate" path="dtExpiryDate" style="width: 70%" cssClass="calenderTextBox" />
			</div>
		</div>
		
		<div id="bottomTable" class="masterTable" >
		  <div class="row">
			<div class="col-md-12"><s:label path="">APPLICABLE FOR</s:label></div>
			
			<div class="col-md-2"><label id="stockAdjust">Stock Adjustment</label><br>
				<s:checkbox element="li" id="chkStockAdj" path="strStockAdj" value="true" />
			</div>
			<div class="col-md-2"><label id="stockTransfer">Stock Transfer</label><br>
				<s:checkbox element="li" id="chkStocktra" path="strStocktra" value="true" />
			</div>
			<div class="col-md-2"><label id="nonConference">Non Conference</label><br>
				<s:checkbox element="li" id="chkNonConf" path="strNonConf" value="true" />
			</div>
		  </div>
		
		 <div class="row" id="secondRow">
			<div class="col-md-2"><label>Follow ups</label><br>
				 <s:checkbox element="li" id="chkFollowUps" path="strFollowUps" value="true" />
			</div>
			<div class="col-md-2"><label>Corrective Active</label><br>
				 <s:checkbox element="li" id="chkCorract" path="strCorract" value="true" />
			</div>
			<div class="col-md-2"><label>Preventive Action</label><br>
				 <s:checkbox element="li" id="chkPrevAct" path="strPrevAct" value="true" />
			</div>
		</div>
			
		<div class="row" id="thirdRow">
			<div class="col-md-2"><label>Resource Blocking</label><br>
				<s:checkbox element="li" id="chkResAlloc" path="strResAlloc" value="true" />
			</div>
			<div class="col-md-2"><label>Delivery Challan</label><br>
				<s:checkbox element="li" id="tchkDelcha" path="strDelcha" value="true" />
			</div>
			<div class="col-md-2"><label>Lead Master</label><br>
				<s:checkbox element="li" id="chkLeadMaster" path="strLeadMaster" value="true" />
			</div>
		</div>
		</div>
	
		<p align="center"  style="margin-right: 49%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funvalidate();" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" />
		</p>
	</s:form>
  </div>
</body>
</html>