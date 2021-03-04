<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<title>Creditor Trail Balance flash</title>
</head>
<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
<script type="text/javascript">
var StkFlashData;
	$(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		/*$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', 'today');
		*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		var glCode = $("#txtGLCode").val();
		if(glCode!='')
		{
			funSetGLCode(glCode);
		}
		
		//debtorCode
		$("#btnExecute").click(function( event )
				{					
					if($("#txtGLCode").val()=='')
					{
						alert("Enter GL Code!");
						return false;
					}
					else
					{
						funCalculateDebtorFlash();
						return false;
					}
				});

		$('#txtGLCode').blur(function() {
			var code = $('#txtGLCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetGLCode(code);
			}
		});

	});
	
	function funSetData(code){
	
		funSetGLCode(code);
		
	}
		

	function funHelp(transactionName)
	{
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	function funSetGLCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAccontCodeAndName.html?accountCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strAccountCode!="Invalid Code")
		    	{
					$("#txtGLCode").val(response.strAccountCode);
					$("#lblGLCode").text(response.strAccountName);
						
		    	}
		    	else
			    {
			    	alert("Invalid Account Code");
			    	$("#txtGLCode").val("");
			    	$("#lblGLCode").text("");
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
		
		
		function funCalculateDebtorFlash()
		{
			
			
			var fromDat=$("#txtFromDate").val();
			var toDat=$("#txtToDate").val();
			var GLCode=$("#txtGLCode").val();
			var currency=$("#cmbCurrency").val();
			var searchUrl=getContextPath()+"/rptCreditorTrialBalanceFlash.html?fromDat="+fromDat+"&toDat="+toDat+"&GLCode="+GLCode+"&currency="+currency;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {				    	
				    	StkFlashData=response;
				    	showTable();
				    	
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
		
	 	function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(StkFlashData.length, optInit);	
		    $("#divValueTotal").show();
		    
		}
	
		var items_per_page = 10;
		function getOptionsFromForm()
		{
		    var opt = {callback: pageselectCallback};
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 10;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		}
		function pageselectCallback(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, StkFlashData.length);
		    var newcontent="";
			
			    	
			   	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#b5b1b1"><td id="labld1" size="10%">Creditor Code</td><td id="labld2">Creditor Name</td><td id="labld3"> Opening</td>	<td id="labld4">Debit</td>	<td id="labld5"> Credit</td><td id="labld6" align="right">Balance</td></tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			    	var balAmt=0.0;
			    	var opnAmt= parseFloat(StkFlashData[i].dblOpnAmt).toFixed(maxQuantityDecimalPlaceLimit);
			    	if(opnAmt<0){
			    		opnAmt="("+(opnAmt*-1)+")";
			    	}
			    	var drAmt=parseFloat(StkFlashData[i].dblDrAmt).toFixed(maxQuantityDecimalPlaceLimit);
			    	if(drAmt<0){
			    		drAmt="("+(drAmt*-1)+")";
			    	}
			    	var crAmt=parseFloat(StkFlashData[i].dblCrAmt).toFixed(maxQuantityDecimalPlaceLimit);
			    	if(crAmt<0){
			    		crAmt="("+(crAmt*-1)+")";
			    	}
			        newcontent += '<tr><td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+StkFlashData[i].strDebtorCode+'</a></td>';
			        newcontent += '<td>'+StkFlashData[i].strDebtorName+'</td>';
			        newcontent += '<td align=right>'+opnAmt+'</td>';
			        newcontent += '<td align=right>'+drAmt+'</td>';
			        newcontent += '<td align=right>'+crAmt+'</td>';
			        
			        balAmt=parseFloat(StkFlashData[i].dblOpnAmt)+parseFloat(StkFlashData[i].dblDrAmt)-parseFloat(StkFlashData[i].dblCrAmt);
			        balAmt=parseFloat(balAmt).toFixed(maxQuantityDecimalPlaceLimit);
			        if(balAmt<0){
			        	balAmt="("+(balAmt*-1)+")";
			    	}
			        newcontent += '<td align=right>'+balAmt+'</td>';
			'</tr>';
			    }			   
		    
		
	
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
		

		
	
		function funClick(obj)			
		 {
			var transactionformName="frmCreditorLedger";
			var fromDat=$("#txtFromDate").val();
			var toDat=$("#txtToDate").val();
			var glCode=$("#txtGLCode").val();	
			var currency=$("#cmbCurrency").val();
			var creditorCode=document.getElementById(""+obj.id+"").innerHTML;

		    response=window.open("frmCreditorLedgerFlash.html?formname="+transactionformName+"&glCode="+glCode+"&creditorCode="+creditorCode+"&fromDat="+fromDat+"&toDat="+toDat+"&currency="+currency,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
	       
			var timer = setInterval(function ()
				    {
					if(response.closed)
						{
							if (response.returnValue != null)
							{
								if(null!=response)
						        {
									response=response.returnValue;
						        	var count=0; 
						        }
			
							}
							clearInterval(timer);
						}
				    }, 500);
			
			}
		  
	function funResetFields(){
		location.reload();
	}	
</script>
<body>
	<div class="container">
		<label id="formHeading">Creditor Trial Balance Flash</label>
			<s:form name="FLR3AReport" method="GET" action="" >				
				<div class="row transTable">
					<div class="col-md-5">
					<label>GL Code:</label><br>
					   <div class="row">
							<div class="col-md-5">
								<s:input  type="text" id="txtGLCode" readonly="true" cssClass="searchTextBox" 
									 path="strAccountCode" ondblclick="funHelp('creditorAccountCode');"/>
							</div>
							<div class="col-md-7">
								<label id="lblGLCode" style="background-color:#dcdada94; width: 100%; height: 24px;"></label>
							</div>
						</div> 
					</div>
					<div class="col-md-7"></div>
					
					<div class="col-md-3">
					   <div class="row">
							<div class="col-md-6">
							<label>From Date:</label><br>
								<s:input  type="text" id="txtFromDate" required="true" readonly="readonly" cssClass="calenderTextBox"
									 path="dteFromDate" />
							</div>
							<div class="col-md-6">
								<label>To Date </label>
								<s:input  type="text" id="txtToDate" cssClass="calenderTextBox" required="true" readonly="readonly"
									 path="dteToDate" />
							</div>
						</div> 
					</div>
					<div class="col-md-3">
					   <div class="row">
							<div class="col-md-6">
							<label>Currency:</label><br>
								<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px">
								</s:select>
							</div>
							<div class="col-md-6"></div>
						</div> 
					</div>
				</div>
				<div id="paraSubmit" class="center" style="margin-right:63%;">
					<a href="#"><button class="btn btn-primary center-block" id="btnExecute" value="Execute" 
						class="form_button">Execute</button></a>&nbsp
					<a href="#"><button class="btn btn-primary center-block" onclick="funResetFields()"
						class="form_button">Reset</button></a>
				</div>
		
			
				<dl id="Searchresult" style="width: 95%; margin-left: 26px; overflow:auto;"></dl>
				<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
					<s:input type="hidden" id="hidSubCodes" path=""></s:input>	<%-- strCatCode --%>
				</div>
			
				<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
					<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
				</div>
	</s:form>
	</div>
</body>
</html>
	
