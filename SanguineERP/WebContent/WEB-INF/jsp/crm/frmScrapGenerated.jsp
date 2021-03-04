<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

</head>
<script type="text/javascript">
$(document).ready(function() 
	{		
		$(".tab_content").hide();
		$(".tab_content:first").show();
	
		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		 var startDate="${startDate}";
		 var arr = startDate.split("/");
		 Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
		 $("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
		 $("#txtFromDate" ).datepicker('setDate', Dat);
		 $("#txtFromDate").datepicker();	
			
		 $("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
		 $("#txtToDate" ).datepicker('setDate', 'today');
		 $("#txtToDate").datepicker();	
				
		 $("#txtSRTillDate").datepicker({ dateFormat: 'dd-mm-yy' });
		 $("#txtSRTillDate" ).datepicker('setDate', 'today');
		 $("#txtSRTillDate").datepicker();
			
				
	});



	function funHelp(transactionName)
	{
		fieldName=transactionName;
	    
	 //   window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	   window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	}
	function funSetData(code)
	{
		switch(fieldName)
		{
		
		case 'subContractor':
		      funSetSubContractor(code)
		      break;
		case 'DNCode':
			  funSetDeliveryNoteCode(code)
			  break;
		}
	 }
 
   $(function()
	 {
		$('#txtSubContractor').blur(function() {
			var code = $('#txtSubContractor').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetSubContractor(code);
			}
		});
		
		$('#txtDNCode').blur(function() {
			var code = $('#txtDNCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetDeliveryNoteCode(code);
			}
		});
	});
	
	function funSetSubContractor(code)
	{
		
		var searchUrl="";
		searchUrl=getContextPath()+"/loadsubContractorScrapGenerated.html?subContractor="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	if(response.strPCode=='Invalid Code')
			       	{
			       		alert("Invalid Sub Contractor Code");
			       		$("#txtSubContractor").val('');
			       		$("#lblSubContractor").text("All Sub Contractor");
			       		$("#txtSubContractor").focus();
			       	}
			       	else
			       	{
			    	$("#txtSubContractor").val(response.strPCode);
	        		$("#lblSubContractor").text(response.strPName);	
	        		$("#txtSubContractor").focus();
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
	
	
	function funSetDeliveryNoteCode(code)
	{
		
		var searchUrl="";
		searchUrl=getContextPath()+"/loadDeliveryNoteCodeScrapGenerated.html?deliveryNote="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	if(response.strDNCode==null)
			       	{
			       		alert("Invalid Delivery Note Code");
			       		$("#txtDNCode").val('');
			       		$("#lblDN").text("All Delivery Notes");
			       		$("#txtDNCode").focus();
			       	}
			       	else
			       	{
// 			    	$("#txtDNCode").val(response.strPCode);
// 	        		$("#lblDN").text(response.strPName);	
// 	        		$("#txtDNCode").focus();
			       		funSetSubContractor(response.strSCCode)
		        		$("#txtDNCode").val(response.strDNCode);
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
<body>
	 <div class="container transTable">
		<label id="formHeading">Scrap Generated</label>
	   <s:form name="frmScrapGenerated" method="GET"
		action="rptScrapGenerated.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
	<div class="row">
			<div class="col-md-3">
				<div class="row">
				<div class="col-md-6"><label>From Date</label>
				    <s:input path="dtFromDate" id="txtFromDate"
						required="required" cssClass="calenderTextBox" />
				</div>
				<div class="col-md-6"><label>To Date</label>
				     <s:input path="dtToDate" id="txtToDate" required="required"
						cssClass="calenderTextBox" />
			    </div>
			  </div></div>
			
			<div class="col-md-3"><label>Sub Contractor Permission Type</label>
				 <s:select id="cmbDocType" path="strDocType" style="width:35%">
						<s:option value="Permitted">Permitted</s:option>
						<s:option value="General">General</s:option>
						<s:option value="UCC">UCC</s:option>
						<s:option value="ALL">ALL</s:option>
					  </s:select>
		    </div>
			 
		     <div class="col-md-6"></div>
		    
		    <div class="col-md-4">
				<div class="row">
					<div class="col-md-5"><label>Sub Contractor</label>
					<s:input path="strSCCode" id="txtSubContractor"
						ondblclick="funHelp('subContractor')" cssClass="searchTextBox"></s:input></div>
					<div class="col-md-7"><label id="lblSubContractor" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top:13%">All Sub Contractor</label></div>
		    </div></div>
		    
		    <div class="col-md-3"><label>Delivery Note Type</label>
			 <s:select id="cmbDNType" path="strProdType" style="width:35%">
					<s:option value="Job Work">Job Work</s:option>
					<s:option value="General">General</s:option>
					<s:option value="ALL">ALL</s:option>
			</s:select>
		    </div>
		    
			<div class="col-md-5"></div>
			
			<div class="col-md-4">
				<div class="row">	
			<div class="col-md-5"><label>Delivery Note Code</label>
				<s:input path="strDocCode" id="txtDNCode"
				ondblclick="funHelp('DNCode')" cssClass="searchTextBox" /></div>
			<div class="col-md-7"><label id="lblDN" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top:13%">All Delivery Notes</label></div>
			</div></div>
			
			<div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strExportType" style="width:55%">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
		     </div>
			
<!-- 			<tr> -->
<!-- 				<td><label>Order By</label></td> -->
<%-- 				<td><s:select id="cmbDNType" path="strProdType" --%>
<%-- 						cssClass="BoxW124px"> --%>
<%-- 						<s:option value="Date">Date</s:option> --%>
<%-- 						<s:option value="G">G</s:option> --%>
<%-- 						<s:option value="A">A</s:option> --%>

<%-- 					</s:select></td> --%>
				


<!-- 				<td><label>Month Wise Job Work</label> -->
				
<!-- 				<td colspan="4"> -->
<!-- 			<label>Hide Age Celling</label>&nbsp&nbsp&nbsp&nbsp<input type="checkbox" name="vehicle" value="Car" path="strProdType" -->
<!-- 					id="txtMonthWise"> -->
<!-- 				</td> -->
<!--             </tr> -->
		</div>
	  <br>
		<p align="right" style="margin-right: 57%;">
			<input type="submit" value="Submit"
				onclick="" class="btn btn-primary center-block"
				class="form_button" /> &nbsp; 
			 <a STYLE="text-decoration: none"
				href="frmJobWorkRegister.html?saddr=${urlHits}"><input
				type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block"
				class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
	</div>
</body>
</html>