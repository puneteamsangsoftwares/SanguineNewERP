<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	    
	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />	
	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
		
	<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
	<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
	        <!-- Load data to paginate -->
	<link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 	
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery-ui.css"/>" />
	
	
	<title>Batch Report</title>
<script type="text/javascript">


/*On form Load It Reset form :Ritesh 22 Nov 2014*/
 $(document).ready(function () {
    $(document).ajaxStart(function(){
	    $("#wait").css("display","block");
	  });
	  $(document).ajaxComplete(function(){
	    $("#wait").css("display","none");
	  });
}); 

</script>

<script type="text/javascript">
	var ExpiryFlashData;
	/**
	 * Get project path
	 */
	 
	function getContextPath() 
	{
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
	
 	/**
	 * Ready Function for Initialize textField with default value
	 * And Set date in date picker 
	 * And Getting session Value
	 */
	$(document).ready(function() 
		{
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
			var startDateOfMonth="${startDateOfMonth}";
			
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate").datepicker('setDate',startDateOfMonth);
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate").datepicker('setDate', 'today');
			$("#txtEXPFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtEXPFromDate").datepicker('setDate',Dat);
			$("#txtEXPToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtEXPToDate").datepicker('setDate', 'today');
			var strPropCode='<%=session.getAttribute("propertyCode").toString()%>';
			var locationCode ='<%=session.getAttribute("locationCode").toString()%>';
			 $("#cmbLocation").val(locationCode);
			 $("#cmbProperty").val(strPropCode);
		});
		
	/**
	 * Ready Function for Geting Expiry Data
	 */
	$(document).ready(function() 
		{
		$("#btnExecute").click(function(){
			var reportType=$("#cmbReportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var EXPFromDate=$("#txtEXPFromDate").val();
			var EXPToDate=$("#txtEXPToDate").val();
			var prodcode=$("#txtProdCode").val();
			if(prodcode.trim().length==0)
				{
					prodcode="ALL";
				}
	var suppcode=$("#txtSuppCode").val();
			if(suppcode.trim().length==0)
			{
				suppcode="ALL";
			}
	
				
			
	var param1=reportType+","+locCode+","+propCode+","+fromDate+","+toDate+","+EXPFromDate+","+EXPToDate+","+prodcode+","+suppcode;
	        
			var searchUrl=getContextPath()+"/frmExpiryFlashReport.html?param1="+param1;
			//alert(searchUrl);
			$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	ExpiryFlashData=response;
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
		
		});			
	/**
	 * Excel export
	 **/
	$("#btnExport").click(function(){
		var reportType=$("#cmbReportType").val();
		var fromDate=$("#txtFromDate").val();
		var toDate=$("#txtToDate").val();
		var locCode=$("#cmbLocation").val();
		var propCode=$("#cmbProperty").val();
		var EXPFromDate=$("#txtEXPFromDate").val();
		var EXPToDate=$("#txtEXPToDate").val();var prodcode=$("#txtProdCode").val();
		var suppcode=$("#txtSuppCode").val();
		var param1=reportType+","+locCode+","+propCode+","+fromDate+","+toDate+","+EXPFromDate+","+EXPToDate+","+prodcode+","+suppcode;
		window.location.href=getContextPath()+"/ExportExpiryFlashReport.html?param1="+param1;
		
	    });
});


function showTable()
{
	var optInit = getOptionsFromForm();
    $("#Pagination").pagination(ExpiryFlashData.length, optInit);	
    
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
    var max_elem = Math.min((page_index+1) * items_per_page, ExpiryFlashData.length);
    var newcontent="";
	   	newcontent = '<table id="tblExpiryFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labls1">Product Name</td><td id="labls2">Batch Code</td><td id="labls3">Supplier Name</td><td id="labls4">GRN Date</td><td id="labls5">GRN Code</td><td id="labls6">GRN Qty</td><td id="labls7">Balance Qty</td><td id="labls8">Expiry Date</td><td id="labls9">ManuBatch Code</td></tr>';
			   
	    // Iterate through a selection of the content and build an HTML string
	    for(var i=page_index*items_per_page;i<max_elem;i++)
	    {
	    	newcontent += '<tr><td style="padding-left: 5px;">'+ExpiryFlashData[i].strProdName+'</td>';
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].strBatchCode+'</td>';
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].strPartyName+'</td>';
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].dtGRNDate+'</td>';
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].strTransCode+'</td>';
	        newcontent += '<td style="padding-right: 5px;text-align:right">'+parseFloat(ExpiryFlashData[i].dblQty).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
	        newcontent += '<td style="padding-right: 5px;text-align:right">'+parseFloat(ExpiryFlashData[i].dblPendingQty).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].dtExpiryDate+'</td>';
	       
	        newcontent += '<td style="padding-left: 5px;">'+ExpiryFlashData[i].strManuBatchCode+'</td></tr>';
	         }
    newcontent += '</table>';
    // Replace old content with new content
    $('#Searchresult').html(newcontent);
    // Prevent click eventpropagation
    return false;

}
function funHelp(transactionName)
{
	fieldName=transactionName;
	//window.open("searchform.html?formname="+transactionName+"&searchText=", 'window', 'width=600,height=600');
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}


function funSetData(code)
{
	switch (fieldName) 
	{			        
	    case 'productmaster':
	    	funSetProduct(code);
	        break;
	    case 'suppcode':
	    	funSetSupplier(code);
	        break;
	}
}
		

function funSetProduct(code)
{
	var searchUrl="";
	
	searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
	$.ajax
	({
        type: "GET",
        url: searchUrl,
	    dataType: "json",
	    success: function(response)
	    {
	    	$("#txtProdCode").val(response.strProdCode);
        	$("#lblProdName").text(response.strProdName);
	    },
		error: function(e)
	    {
	       	alert('Error:=' + e);
	    }
    });
}
function funSetSupplier(code) {
	var searchUrl = "";
	searchUrl = getContextPath()
			+ "/loadSupplierMasterData.html?partyCode=" + code;

	$.ajax({
		type : "GET",
		url : searchUrl,
		dataType : "json",
		success : function(response) {
			if ('Invalid Code' == response.strPCode) {
				alert('Invalid Code');
				$("#txtSuppCode").val('');
				$("#txtSuppName").text('');
				$("#txtSuppCode").focus();
			} else {
				$("#txtSuppCode").val(response.strPCode);
				$("#txtSuppName").text(response.strPName);
				
			}
		},
		error : function(jqXHR, exception) {
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
function funChangeLocationCombo()
{
	var propCode=$("#cmbProperty").val();
	funFillLocationCombo(propCode);
}
function funFillLocationCombo(propCode) 
{
	var searchUrl = getContextPath() + "/loadLocationForProperty.html?propCode="+ propCode;
	$.ajax({
		type : "GET",
		url : searchUrl,
		dataType : "json",
		success : function(response) {
			var html = '';
			$.each(response, function(key, value) {
				html += '<option value="' + value[1] + '">'+value[0]
						+ '</option>';
			});
			html += '</option>';
			$('#cmbLocation').html(html);
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

function funOnExecute()
{

	$("#btnExecute").click(function(){
		var reportType=$("#cmbReportType").val();
		var fromDate=$("#txtFromDate").val();
		var toDate=$("#txtToDate").val();
		var locCode=$("#cmbLocation").val();
		var propCode=$("#cmbProperty").val();
		var EXPFromDate=$("#txtEXPFromDate").val();
		var EXPToDate=$("#txtEXPToDate").val();
		var prodcode=$("#txtProdCode").val();
		if(prodcode.trim().length==0)
			{
				prodcode="ALL";
			}
		var suppcode=$("#txtSuppCode").val();
		if(suppcode.trim().length==0)
		{
			suppcode="ALL";
		}
	
		var param1=reportType+","+locCode+","+propCode+","+fromDate+","+toDate+","+EXPFromDate+","+EXPToDate+","+prodcode+","+suppcode;
        
		var searchUrl=getContextPath()+"/frmExpiryFlashReport.html?param1="+param1;
		//alert(searchUrl);
		$.ajax({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
		    	ExpiryFlashData=response;
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
	
	});
	return false;
}

function funOnExport()
{
	$("#btnExport").click(function(){
		var reportType=$("#cmbReportType").val();
		var fromDate=$("#txtFromDate").val();
		var toDate=$("#txtToDate").val();
		var locCode=$("#cmbLocation").val();
		var propCode=$("#cmbProperty").val();
		var EXPFromDate=$("#txtEXPFromDate").val();
		var EXPToDate=$("#txtEXPToDate").val();var prodcode=$("#txtProdCode").val();
		var suppcode=$("#txtSuppCode").val();
		var param1=reportType+","+locCode+","+propCode+","+fromDate+","+toDate+","+EXPFromDate+","+EXPToDate+","+prodcode+","+suppcode;
		window.location.href=getContextPath()+"/ExportExpiryFlashReport.html?param1="+param1;
		
	    });	
	return false;
}

</script>

</head>
<body>
<div class="container">
	<label id="formHeading">Expiry Flash</label>
	<s:form action="frmExpiryFlash.html" method="GET" name="frmExpiryFlash">
		<div class="row transTable">
			<div class="col-md-2">
				<label>Property Code</label>
				<s:select id="cmbProperty" name="propCode" path="strPropertyCode"  onchange="funChangeLocationCombo();">
				    <s:options items="${listProperty}"/>
				 </s:select>
			</div>	
			<div class="col-md-2">		
				<label>Location</label>
				<s:select id="cmbLocation" name="locCode" path="strLocationCode"  >
			    	<s:options items="${listLocation}"/>
			    </s:select>
			</div>
			<div class="col-md-2">			
				<label id="lblFromDate">GRN From Date</label>
			    <s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" style="width:80%;"/>
			 </div>       	
			 <div class="col-md-2">	  
				  <label id="lblToDate">GRN To Date</label>
			       <s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" style="width:80%;"/>
			  </div>
			   <div class="col-md-4"></div>
			  <div class="col-md-2">	       	
			      <label>Product Code</label>
				   <input id="txtProdCode" placeholder="ALL" ondblclick="funHelp('productmaster');" class="searchTextBox"/>
			  </div> 
			  <div class="col-md-2">   
			       <label  id="lblProdName" style="background-color:#dcdada94; width: 100%; height: 40%; margin: 27px 0px;text-align:center"></label>
			  </div> 
			  <div class="col-md-2">     
				  <label id="lblEXPFromDate">Exp. From Date</label>
			   	  <s:input id="txtEXPFromDate" name="fromEXPDate" path="dtExpFromDate" cssClass="calenderTextBox" style="width:80%;"/>
			   </div>
			   <div class="col-md-2">    
			      <label id="lblEXPToDate">Exp. To Date</label>
			       <s:input id="txtEXPToDate" name="toEXPDate" path="dtExpToDate" cssClass="calenderTextBox" style="width:80%;"/>
			    </div>
			    <div class="col-md-4"></div>
			    <div class="col-md-2">    	
			        <label>Supplier Code</label>
					<input id="txtSuppCode" placeholder="ALL" ondblclick="funHelp('suppcode');" class="searchTextBox"/>
			     </div>
			     <div class="col-md-2">   
			         <label  id="txtSuppName" style="background-color:#dcdada94; width: 100%; height: 40%; margin: 27px 0px;text-align:center"></label>
			     </div>
			     <div class="col-md-2"> 
						<s:select path="strExportType" id="cmbExportType" cssClass="BoxW124px" style="width:80%; margin-top:26px;">
							<option value="Excel">Excel</option>
						</s:select>
				</div>
			</div>		
					<%-- <tr>
							<td><label>Report Type</label></td>
							<td colspan="5">
							<s:select id="cmbDocType" path="strDocType" cssClass="BoxW124px">
								   <s:option value="PDF">PDF</s:option>
								    	<s:option value="XLS">EXCEL</s:option>
								    	<s:option value="HTML">HTML</s:option>
								    	<s:option value="CSV">CSV</s:option>
								   </s:select>
							</td>
					</tr> --%>
				<div class="center" style="margin-right:40%;">
					 <a href="#"><button class="btn btn-primary center-block" id="btnExecute" value="Execute" onclick="return funOnExecute()">Execute</button></a>&nbsp
					 <a href="#"><button class="btn btn-primary center-block" id="btnExport"  value="Export" onclick="return funOnExport()">Export</button></a>
				</div>
		<br><br>
			<dl id="Searchresult" style="padding-left: 26px;overflow:auto;"></dl>
				<div id="Pagination" class="pagination">
				
				</div>
				<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
					<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
				</div>
	</s:form>
</div>
</body>
</html>