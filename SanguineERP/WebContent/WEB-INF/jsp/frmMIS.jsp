<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>


<title>MIS</title>

<script type="text/javascript">

 /**On form Load It Reset form :Ritesh 22 Nov 2014
  * Ready Function for Ajax Waiting
 **/
 var miseditable;
 var clickCount=0;
 $(document).ready(function () {
	 
    resetForms('MIS');
    $("#txtLocTo").focus();
    $(document).ajaxStart(function(){
	    $("#wait").css("display","block");
	  });
	  $(document).ajaxComplete(function(){
	    $("#wait").css("display","none");
	  });
	  
	  miseditable="${miseditable}" ;
	  if(miseditable=="false"){
		  $("#txtMISCode").prop('disabled', true);
	  }
}); 

</script>
<script type="text/javascript">
/**
 * Global variable
 */
	var fieldName="",strLocationType,listRow=0;
	
	/**
	 * Ready Function for Initialize textField with default value
	 * And Getting session Value
	 * Success Message after Submit the Form
	 */
	$(function() 
	{		
		
		$("#txtMISDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtMISDate" ).datepicker('setDate', 'today');
		
		strChangeUOM='<%=session.getAttribute("changeUOM").toString()%>';
		if(strChangeUOM!="N")
			{
				$("#strUOM").prop("disabled", false);
			}
		else
			{
				$("#strUOM").prop("disabled", true);
			}
		
		
		var message='';
		 var retval="";
		 var warnMessage='';
		 
		<%if(session.getAttribute("success") != null) 
		{
			if(session.getAttribute("successMessage") != null)
			{%>
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
			}
		}
		else if(session.getAttribute("warning") != null) // Warning Message 
		{			
			if(session.getAttribute("warningMessage") != null)
			{%>
				warnMessage='<%=session.getAttribute("warningMessage").toString()%>';
			 	<%
			    session.removeAttribute("warningMessage");
			}
			boolean test = ((Boolean) session.getAttribute("warning")).booleanValue();
			session.removeAttribute("warning");
			if (test) {
			%>	
				alert(warnMessage);
			
			<%
			}
		}
		
		%>
		
		var code='';
		<%if(null!=session.getAttribute("rptMISCode")){%>
		code='<%=session.getAttribute("rptMISCode").toString()%>';
		 '<%session.removeAttribute("rptMISCode");%>'
		
		var isOk=confirm("Do You Want to Generate Slip?");
		if(isOk)
		    {
			//alert("/openRptMISSlip.html?rptMISCode="+code);
		        window.open(getContextPath()+"/openRptMISSlip.html?rptMISCode="+code,'_blank');
		    }
		
		 var isOk = confirm("Do You Want to Send Slip On Mail?");
		    if (isOk) 
		    {
				window.open(getContextPath() + "/sendMISEmail.html?strMISCode=" + code);
		    }
		<%}%>
		if(null!='<%=session.getAttribute("BatchList")%>')
			{
				if("null"!='<%=session.getAttribute("BatchList")%>')
					{
					//	window.showModalDialog("frmManualBatch.html?rptMISCode="+code,"","dialogHeight:500px;dialogWidth:800px;dialogLeft:300px;dialogTop:50px");
					window.open("frmManualBatch.html?rptMISCode="+code,"","dialogHeight:500px;dialogWidth:800px;dialogLeft:300px;dialogTop:50px");
					}
			}
		
		$("#txtLocFrom").val("${locationCode}");
    	$("#lblLocFrom").text("${locationName}");  
    	strLocationType="${locationType}";
		var flagOpenFromAuthorization="${flagOpenFromAuthorization}";
		if(flagOpenFromAuthorization == 'true'){
			funGetMISData("${authorizationMISCode}");
		}
		
		if($("#txtReqCode").val()!='')
		{
			var misCode=$("#txtMISCode").val();
			
			funSetAgainstReqData(misCode);
		}
	});
		
	/**
	 * Open against help form
	 */
	function funOpenAgainst()
	{
		if($("#cmbAgainst").val()=="WorkOrder1")
			{
				//funHelp("WorkOrderST");
			}
		else if ($("#cmbAgainst").val()=="Production Order")
			{
				funHelp("Production");
			}
		
		else
			{
				if($("#txtLocFrom").val()=="")
		        {
		            alert("Please Enter From Location Or Search")
		            return false
		        }
		        if($("#txtLocTo").val()=="")
		        {
		            alert("Please Enter To Location Or Search")
		            return false
		        }
		        else
		        {
					strLocFrom=$("#txtLocFrom").val();
		            strLocTo=$("#txtLocTo").val();
		          //  var retval=window.showModalDialog("frmMISforMR.html?strLocFrom="+strLocFrom+"&strLocTo="+strLocTo,"","dialogHeight:700px;dialogWidth:800px;dialogLeft:300px;")
				  	  var retval=window.open("frmMISforMR.html?strLocFrom="+strLocFrom+"&strLocTo="+strLocTo,"","dialogHeight:700px;dialogWidth:800px;dialogLeft:300px;")     
// 		          if(retval != null)
// 			            {
// 			                strVal=retval.split("#")
// 			                $("#txtReqCode").val(strVal[0]);
// 			            }
		          
		          
		          
				  	var timer = setInterval(function ()
						    {
							if(retval.closed)
								{
									if (retval.returnValue != null)
									{
										strVal=retval.returnValue.split("#")
						                $("#txtReqCode").val(strVal[0]);
					
									}
									clearInterval(timer);
								}
						    }, 500);
		          
		          
		        }
			}
	}
		
	/**
	 * Open help form
	 */
	function funHelp(transactionName)
	{
		var fromLoc=$("#txtLocFrom").val();
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
		window.open("searchform.html?formname="+transactionName+"&locationCode="+fromLoc+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    }
	/**
	 * Open Location help form
	 */
	function funLocationOnOpen(transactionName)
	   {   
		
		fieldName=transactionName;		
	        /* if(strLocationType=="Stores")
	        {
	        	window.showModalDialog("searchform.html?formname=LocationToAllPropertyStore&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	        	 
	        }
	        else if(strLocationType=="Cost Center" || strLocationType=="Profit Center")
	        {
	        	window.showModalDialog("searchform.html?formname=StoreLocationTo&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	        }
	        else
	        { */
	        	 //  window.showModalDialog("searchform.html?formname=locon&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	        	   window.open("searchform.html?formname=locon&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	        //}
	   }
	
	/**
	 * Set Data after selecting form Help windows
	 */
	function funSetData(code)
	{
		var searchUrl="";
		switch (fieldName)
		{
			case 'StoreLocationTo':
				funSetLocationFrom(code);						
			break;	
			
			case 'loconMIS':
				funSetLocationTo(code);					
			break;
			
			case 'productInUse':
				funSetProduct(code);		
			break;
			 			
			case 'MIS':
				funGetMISData(code);
 			break;	
 			
			case 'Production':
				funSetProductionData(code);
 			break;	
 			
 			
		}
		
	}
	
	/**
	 * Get and set Location From Data Based on passing Location Code
	 */
	function funSetLocationFrom(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	if(response.strLocCode=='Invalid Code')
			       	{
			       	   alert("Invalid Location Code");
			       		$("#txtLocFrom").val('');
			       		$("#lblLocFrom").text("");
			       		$("#txtLocFrom").focus();
			       	}
			       	else
			       	{
			    	$("#txtLocFrom").val(response.strLocCode);						
			    	$("#lblLocFrom").text(response.strLocName);
			    	$("#txtLocTo").focus();
	        		strLocationType=response.strType;
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
	
	/**
	 * Get and set Location To Data Based on passing Location Code
	 */
	function funSetLocationTo(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	if(response.strLocCode=='Invalid Code')
			       	{
			       		alert("Invalid Location Code");
			       		$("#txtLocTo").val('');
			       		$("#lblLocTo").text("");
			       		$("#txtLocTo").focus();
			       	}
			       	else
			       	{
			    	$("#txtLocTo").val(response.strLocCode);			    	
			    	$("#lblLocTo").text(response.strLocName);		    	
        			$("#txtProdCode").focus();
        			
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
	
	/**
	 * Get and set prodcut data based on product code
	 */
	function funSetProduct(code)
	{
		var searchUrl="";		
		searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
		//alert(searchUrl);
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",			   
			    success: function(response)
			    {
			    	if('Invalid Code' == response.strProdCode){
			    		alert('Invalid Product Code');
				    	$("#txtProdCode").val('');
				    	$("#spProdName").text('');
				    	$("#txtProdCode").focus();
			    	}else
			    	{
			    		var dblStock=funGetProductStock(response.strProdCode);
			    		//alert(dblStock);
			    		$("#spStock").text(dblStock);
			    		//$("#spStockUOM").text(response.strIssueUOM); changes done by sumeet for space
			    		$("#spStockUOM").text(" "+response.strIssueUOM);
				    	$("#txtProdCode").val(response.strProdCode);
				    	$("#spProdName").text(response.strProdName);
						$("#strUOM").val((response.strIssueUOM).toUpperCase());
						var costRm=response.dblCostRM;
						var issueConv =response.dblIssueConversion;
						var recipeCov = response.dblRecipeConversion;
						var unitPrice=parseFloat(costRm)/parseFloat(issueConv);
						
						$("#txtUnitPrice").val(unitPrice);
						$("#hidExpDate").val(response.strExpDate);
						$("#txtProdQty").focus();
						//objModel.getStrProdType().equals("Produced")  ||objModel.getStrProdType().equals("Procured") || objModel.getStrProdType().equals("Semi Finished") 
						if(unitPrice==0){
							if(response.strProdType=='Produced' ||response.strProdType=='Semi Finished')
							{
							    var dblActualPrice= funGetProductActualPrice(response.strProdCode,response.strProdType,"1");
							    $("#txtUnitPrice").val(dblActualPrice);
							}	
						}
						
			    	}
			    },
				error: function(e)
			    {
			       	alert('Invalid Product Code');
			       	$("#txtProdCode").val('');
			    	$("#spProdName").text('');
			    	$("#txtProdCode").focus();
			    }
		      });
	}
	
	function funGetProductActualPrice(strProdCode,strProdType,finalWeight)
	{
		var searchUrl=getContextPath()+"/getProductActualCosting.html?prodCode="+strProdCode+"&strProdType="+strProdType+"&finalWeight="+finalWeight;	
		var dblProductActualPrice=0;
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    async: false,
			    success: function(response)
			    {
			    	dblProductActualPrice= response;
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
		return dblProductActualPrice;
	}
	
	
	/**
	 * Get product stock passing value product code
	 */
	function funGetProductStock(strProdCode)
	{
		var searchUrl="";	
		var locCode=$("#txtLocFrom").val();
		var dblStock="0";
		var strMISDate=$("#txtMISDate").val();
		searchUrl=getContextPath()+"/getProductStock.html?prodCode="+strProdCode+"&locCode="+locCode+"&strMISDate="+strMISDate;	
		//alert(searchUrl);		
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    async: false,
			    success: function(response)
			    {
			    	dblStock= response;
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
		return Math.round(dblStock * 100) / 100;
	}
	
	
	
	
	/**
	 * Get and set MIS Data
	 */
	function funGetMISData(code)
	{
		$("#txtMISCode").val(code);
		searchUrl=getContextPath()+"/loadMISHdData.html?MISCode="+code;
		//alert(searchUrl);
		$.ajax({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
		    	if(response.strMISCode!="Invalid MIS Code")
		    	{
		    		funFillData(response);
		    	}
		    	else
			    {
			    		alert("Invalid MIS Code");
			    		$("#txtMISCode").val("");
			    		$("#txtMISCode").focus();
			    		return false;
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
	
	/**
	 * Fill Data in text field
	 */
	function funFillData(response)
	{
						        				
    	$("#txtMISCode").val(response.strMISCode);
    	$("#txtMISDate").val(response.dtMISDate); 
    	$("#txtLocFrom").val(response.strLocFrom);
    	$("#lblLocFrom").text(response.strLocFromName); 
    	$("#lblLocTo").text(response.strLocToName);
    	$("#txtLocTo").val(response.strLocTo);
    	$("#cmbAgainst").val(response.strAgainst);
    	$("#txtReqCode").val(response.strReqCode);							        				
    	$("#txtNarration").val(response.strNarration);
    	$("#hidAuthorise").val(response.strAuthorise);
    	funOnChange();
    	$("#txtProdCode").focus(); 	
    	document.getElementById("btnFill").disabled = true ; 
    
    	funGetProdData1(response.clsMISDtlModel);

	}
	
	/**
	 * Get and set Requisition aginst Data
	 */
	function funSetAgainstReqData(code)
	{
		funGetReqDtlData(code);			
	}
	/**
	 * Get and set Requisition detail Data
	 */
	function funGetReqDtlData(strReqcode)
	{
		var locCode=$("#txtLocFrom").val();		
		strReqcode=$("#txtReqCode").val();
		var searchUrl=getContextPath()+"/MISReqDtlData.html?ReqCode="+strReqcode+"&locCode="+locCode;			
		$.ajax({			
        	type: "GET",
	        url: searchUrl,
	        dataType: "json",
	        async: false,
	        success: function(response)
	        {	
	        	var count=0;
	        	$.each(response, function(i,item)
	       	    	 {
	        			count=i;
	       	    	    funfillProdRow(response[i].strProdCode,response[i].strProdName,
	       	    	    		response[i].strUOM,response[i].dblQty,response[i].dblUnitPrice,
	       	    	    		response[i].strRemarks,strReqcode,response[i].dblStock);
	       	    	                                           
	       	    	 });
	        	listRow=count+1;
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
	
	/**
	 * Get Requisition Data form Response Data
	 */
	function funGetProdData1(response)
	{	
		var count=0;
		funRemoveProductRows();
		$.each(response, function(i,item)
        {
			count=i;
			//alert(response.strExpiry);
			funfillProdRow(response[i].strProdCode,response[i].strProdName,response[i].strUOM,response[i].dblQty,response[i].dblUnitPrice,response[i].strRemarks,response[i].strReqCode,response[i].dblStock,response[i].strExpiry);
                                       
        });
		listRow=count+1;
	}
	
	/**
	 * Geting MIS Details Records passing value MIS Code
	 */
	function funGetProdData(code)
	{		
		var searchURL=getContextPath()+"/loadMISDtlData.html?MISCode="+code;
	   
		$.ajax({				
        	type: "GET",
	        url:searchURL,
	        dataType: "json",
	        success: function(response)
	        {	      
	        	var count=0;
	        	funRemoveProductRows();
				$.each(response, function(i,item)
                {
					count=i;
					funfillProdRow(response[i].strProdCode,response[i].strProdName,response[i].strUOM,response[i].dblQty,response[i].dblUnitPrice,response[i].strRemarks,response[i].strReqCode);
                                               
                });
				listRow=count+1;				
				funOnChange();
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
	/**
	 * Filling Records in Grid
	 */
	function funfillProdRow(strProdCode,strProdName,strUOM,dblQty,dblUnitPrice,strRemarks,strReqcode,dblStock,strExpiry)
	{	   
		dblQty=parseFloat(dblQty).toFixed(maxQuantityDecimalPlaceLimit);
		dblUnitPrice=parseFloat(dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);
	    var table = document.getElementById("tblProdDet");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var dblTotalPrice=dblQty*dblUnitPrice;
	    dblTotalPrice=dblTotalPrice.toFixed(maxAmountDecimalPlaceLimit);
	    var dblIssueQty="";
	    if($("#txtMISCode").val()!="")
	    	{
	    		dblIssueQty="";
	    		dblStock=parseFloat(dblStock)+parseFloat(dblQty);
	    	}
	    dblStock=parseFloat(dblStock).toFixed(maxQuantityDecimalPlaceLimit);
	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" name=\"listMISDtl["+(rowCount)+"].strProdCode\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";	    
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" name=\"listMISDtl["+(rowCount)+"].strProdName\" id=\"strProdName."+(rowCount)+"\" value='"+strProdName+"' />";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"6%\" style=\"margin-left: -38px;\" name=\"listMISDtl["+(rowCount)+"].strUOM\" id=\"strUOM."+(rowCount)+"\" value='"+strUOM+"' />";
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"6%\" style=\"margin-left: -36px;\" name=\"listMISDtl["+(rowCount)+"].dblStock\" id=\"dblStock."+(rowCount)+"\" value='"+dblStock+"'/>";
	    row.insertCell(4).innerHTML= "<input type=\"text\" required = \"required\" size=\"4%\" style=\"border: 1px solid #a29c9c;padding: 1px;text-align: right;margin-left: -13px;\" class=\"decimal-places inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblQty\" id=\"dblQty."+(rowCount)+"\" value="+dblQty+" onblur=\"Javacsript:funUpdatePrice(this)\" >";
	    row.insertCell(5).innerHTML= "<input class=\"inputText-Auto Box\" size=\"7%\" style=\"margin-left: -15px;\"  disabled=\"disabled\" id=\"dblPendingQty."+(rowCount)+"\" value="+dblIssueQty+" >";
	    row.insertCell(6).innerHTML= "<input readonly=\"true\"  required = \"required\" size=\"7%\" style=\"text-align: right;\" class=\"inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblUnitPrice\" id=\"dblUnitPrice."+(rowCount)+"\" value="+dblUnitPrice+" >";
	    row.insertCell(7).innerHTML= "<input class=\"Box\" size=\"7%\" style=\"text-align: right;margin-left:18px;\" readonly=\"readonly\" size=\"7%\" name=\"listMISDtl["+(rowCount)+"].dblTotalPrice\" id=\"dblTotalPrice."+(rowCount)+"\" value="+dblTotalPrice+" >";
	    row.insertCell(8).innerHTML= "<input readonly=\"true\" size=\"13%\" style=\"margin-left:35px;\" class=\"Box\" name=\"listMISDtl["+(rowCount)+"].strReqCode\" id=\"strReqCode."+(rowCount)+"\" value="+strReqcode+" >";
	    row.insertCell(9).innerHTML= "<input size=\"20%\" style=\"margin-left:45px;\" name=\"listMISDtl["+(rowCount)+"].strRemarks\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"' />";		    
	    row.insertCell(10).innerHTML='<input type="button"  style=\"margin-left:75px;\"  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
	    row.insertCell(11).innerHTML= "<input name=\"listMISDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
	    funApplyNumberValidation();
	    funCalculateTotalAmt();
	}

	/**
	 * Checking validation and Update total price when user change the qty 
	 */
	function funUpdatePrice(object)
	{	 
		var index=object.parentNode.parentNode.rowIndex;
		var dblProdQty=parseFloat(object.value);
		//var dblPendingQty=document.getElementById("dblPendingQty."+index).value;
		var dblPendingQty="";
		if("${strNegStock}"=="N")
		 {
		 	var prodStock=parseFloat(document.getElementById("dblStock."+index).value);
		 	if(parseFloat(prodStock) < parseFloat(dblProdQty))
	          {
	              alert("Issue Quantity > Available Stock");	              
	              document.all(object.id).value="";	   
	              document.all(object.id).focus();
	          }
		 }
		if(dblPendingQty!="")
			{
		 		if(dblProdQty > dblPendingQty)
		 			{
						alert("Issue Quantity > Requisition Qty");
						document.all(object.id).value="";	   
						document.all(object.id).focus();
						return false;
		 			}
			}
		var price=parseFloat(document.getElementById("dblUnitPrice."+index).value)*parseFloat(object.value);
		price=price.toFixed(maxAmountDecimalPlaceLimit);
		document.getElementById("dblTotalPrice."+index).value=price;
		funCalculateTotalAmt();
		
	}
	
	
	/**
	 * Checking validation before Adding Product Data in grid 
	 */
	 	function btnAdd_onclick() 
	    {	    
	 	   
			if($("#txtProdCode").val().length<=0)
			{
				$("#txtProdCode").focus();
				alert("Please Enter Product Code Or Search");
				return false;
			}			
		    if($("#txtProdQty").val().trim().length==0 || $("#txtProdQty").val()== 0)
		        {		
		          alert("Please Enter Quantity");
		          $("#txtProdQty").focus();
		          return false;
		       } 
	        else
	        	{
	        	 var strProdCode=$("#txtProdCode").val();
	        	 //if(funDuplicateProduct(strProdCode))
		        	
		          if(true)
		          {
		         	 funAddProductRow();
		          }
	        	}
	        	
	    }
	
	 	/**
		 * Check duplicate record in grid
		 */
	 	function funDuplicateProduct(strProdCode)
		{
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblProdDet tr').each(function()
				    {
					    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added "+ strProdCode);
					    	  funClearProduct();
		    				flag=false;
	    				}
					});
				    
		    	}
		    return flag;
		}
	 	
	 	/**
		 * Adding Product Data in grid 
		 */
		function funAddProductRow() 
		{			
			var strProdCode =$("#txtProdCode").val().trim();
			var strUOM=$("#strUOM").val();
			if(strUOM==null)
				{
					strUOM="";
				}
			var strProdName=$("#spProdName").text();
		    var dblProdQty = $("#txtProdQty").val();
		    var strRemarks = $("#txtRemarks").val();
		    var dblUnitPrice=$("#txtUnitPrice").val();
		    var stock=$("#spStock").text();
		    var strExpiry=$("#hidExpDate").val();
		    dblProdQty=parseFloat(dblProdQty).toFixed(maxQuantityDecimalPlaceLimit);
		    dblUnitPrice=parseFloat(dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);
		    var dblTotalPrice=parseFloat(dblProdQty*dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);		    
		    if("${strNegStock}"=="N")
	         {
	                if(parseFloat(stock) < parseFloat(dblProdQty))
	                {
	                    alert("Issue Quantity > Available Stock");
	                    $("#txtProdQty").focus();
	                    return false;
	                }
	        }
		    
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
// 		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" name=\"listMISDtl["+(rowCount)+"].strProdCode\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" name=\"listMISDtl["+(rowCount)+"].strProdName\" id=\"strProdName."+(rowCount)+"\" value='"+strProdName+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"6%\" style=\"margin-left: -38px;\" name=\"listMISDtl["+(rowCount)+"].strUOM\" id=\"strUOM."+(rowCount)+"\" value='"+strUOM+"' />";		    
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"6%\" style=\"margin-left: -18px;\" name=\"listMISDtl["+(rowCount)+"].dblStock\" id=\"dblStock."+(rowCount)+"\" value='"+stock+"'/>";
		    row.insertCell(4).innerHTML= "<input type=\"text\"  required = \"required\" style=\"border: 1px solid #a29c9c;padding: 1px;text-align: right;\" class=\"decimal-places inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblQty\" id=\"dblQty."+(rowCount)+"\" value="+dblProdQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";		    
		    row.insertCell(5).innerHTML= "<input disabled=\"disabled\" class=\"inputText-Auto Box\"></input>";
		    row.insertCell(6).innerHTML= "<input readonly=\"true\" type=\"text\"  required = \"required\" style=\"text-align: right;\" class=\"inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblUnitPrice\" id=\"dblUnitPrice."+(rowCount)+"\" value='"+dblUnitPrice+"'/>";
		    row.insertCell(7).innerHTML= "<input class=\"Box\" style=\"text-align: right;\" readonly=\"readonly\" size=\"7%\" name=\"listMISDtl["+(rowCount)+"].dblTotalPrice\" id=\"dblTotalPrice."+(rowCount)+"\" value='"+dblTotalPrice+"' />";
		    row.insertCell(8).innerHTML= "<input disabled=\"disabled\" class=\"inputText-Auto Box\"></input>";
		    row.insertCell(9).innerHTML= "<input size=\"25%\" name=\"listMISDtl["+(rowCount)+"].strRemarks\" id=\"strRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";		    
		    row.insertCell(10).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
		    row.insertCell(11).innerHTML= "<input name=\"listMISDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
		    listRow++;
		    funUpdateIssueUOM();
		    funCalculateTotalAmt();
		    funApplyNumberValidation();
		    funClearProduct();
		}
		
		
		/**
		 * Calculate Total Amount
		 */
		function funCalculateTotalAmt()
		{
			var totalAmt=0;
			var table = document.getElementById("tblProdDet");
			var rowCount = table.rows.length;
			
		
			for(var i=0;i<rowCount;i++)
			{
				totalAmt=parseFloat(document.getElementById("dblTotalPrice."+i).value)+totalAmt;
			}
			$("#txtTotalAmt").val(Math.round(totalAmt));
		}
		
		/**
		 * Delete a particular record from a grid
		 */
		function funDeleteRow(obj) 
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblProdDet");
		    table.deleteRow(index);
		   
		    funCalculateTotalAmt();
		    
		    
		}
		
		/**
		 * Clear product text filed after adding records in grid
		 */
		function funClearProduct()
		{
			$("#txtProdCode").val("");
			$("#strUOM").val("");
			$("#spProdName").text("");
			$("#txtProdQty").val("");
			$("#txtUnitPrice").val("");
			$("#txtRemarks").val("");
			$("#spStockUOM").text("");
			$("#spStock").text("");
			$("#txtProdCode").focus();
		}
		
		/**
		 * Update Issue UOM in product master
		 */
		function funUpdateIssueUOM()
		{
			var strProdCode = $("#txtProdCode").val();				
			var strUOM=$("#strUOM").val();
			if(strUOM!="")
			{
			var transaction="MIS";
			var searchUrl=getContextPath()+"/updateUOMData.html?strProdCode="+strProdCode+"&strUOM="+strUOM+"&transaction="+transaction;
			//alert(searchUrl);
			$.ajax({			
	        	type: "GET",
		        url: searchUrl,
		        dataType: "text",
		        success: function(response)
		        {	
		        	//alert(response);
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
		}
		
		/**
		 * Combo box on Change event
		 */
		function funOnChange()
		{
					 if($("#cmbAgainst").val()=="Direct")
						 {
							document.all[ 'txtWoQty' ].style.display = 'none';
							document.all[ 'txtReqCode' ].style.display = 'none';
							document.all[ 'spQty' ].style.display = 'none';
							document.all[ 'btnFill' ].style.display = 'none';
							document.all[ 'chkCloseReq' ].style.display = 'none';
							document.all[ 'lblCloseReq' ].style.display = 'none';
							
// 						 	$('#txtWoQty').css('visibility','hidden');
// 						 	$("#txtReqCode").css('visibility','hidden');
// 						 	$("#spQty").css('visibility','hidden');
// 						 	$("#btnFill").css('visibility','hidden');
						 	$("#txtProdCode").attr("disabled", false);
						 }
					 else if($("#cmbAgainst").val()=="Work Order")
						 {
						 
						 	document.all[ 'txtWoQty' ].style.display = 'block';
							document.all[ 'txtReqCode' ].style.display = 'block';
							document.all[ 'spQty' ].style.display = 'block';
							document.all[ 'btnFill' ].style.display = 'block';
							document.all[ 'chkCloseReq' ].style.display = 'none';
							document.all[ 'lblCloseReq' ].style.display = 'none';
// 						    $('#txtWoQty').css('visibility','visible');
// 						 	$("#txtReqCode").css('visibility','visible');
// 						 	$("#spQty").css('visibility','visible');
// 						 	$("#btnFill").css('visibility','visible');
						 }
					 else if($("#cmbAgainst").val()=="Requisition")
						 {
						 	document.all[ 'txtReqCode' ].style.display = 'block';
// 						    $("#txtReqCode").css('visibility','visible');
// 						 	$('#txtWoQty').css('visibility','hidden');
							document.all[ 'txtWoQty' ].style.display = 'none';
							document.all[ 'spQty' ].style.display = 'none';
							document.all[ 'btnFill' ].style.display = 'block';
// 						 	$("#btnFill").css('visibility','visible');
							document.all[ 'chkCloseReq' ].style.display = 'block';
							document.all[ 'lblCloseReq' ].style.display = 'block';
// 						 	$("#chkCloseReq").css('visibility','visible');
						 	$("#txtProdCode").attr("disabled", true);
						 } 
		}
		
		/**
		 * Delete a All record from a grid
		 */
		function funRemoveProductRows()
		{
			var table = document.getElementById("tblProdDet");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		/**
		 * Reset All data when user Click on reset button
		 */
		function funResetField()
		{
			funRemoveProductRows();			  
			$("#txtLocTo").val(""); 	
			$("#lblLocTo").text(""); 
			$("#txtProdCode").val("");
			$("#spProdName").text(""); 
			$("#txtWoQty").val(""); 
			$("#strUOM").val("");
			$("#spStock").text(""); 
			$("#txtProdQty").val(""); 
			$("#txtUnitPrice").val(""); 
			$("#txtRemarks").val(""); 			 
			$("#txtLocTo").focus();
			      $(document).ajaxStart(function()
			         {
				   $("#wait").css("display","block");
				    });
				  $(document).ajaxComplete(function()
				    {
				    $("#wait").css("display","none");
				    });
		 	}
	  
		
		/**
		 * Checking Validation before submiting the data
		 */
		function funCallFormAction(actionName,object) 
		{
			  
			if(clickCount==0){
				clickCount=clickCount+1;
				
				var flg=true;
				var AllowDateChangeInMIS='<%=session.getAttribute("AllowDateChangeInMIS").toString()%>';
				var table = document.getElementById("tblProdDet");
				var rowCount = table.rows.length;	
				
				var spMISDate=$("#txtMISDate").val().split('-');
			    var misDate = new Date(spMISDate[2],spMISDate[1]-1,spMISDate[0]);
			    var td=new Date();
			    var d2 = new Date(td.getYear()+1900,td.getMonth(),td.getDate());
			    var dateDiff=misDate-d2;
			    if(dateDiff>0)
			    {
			    	alert("Future date is not allowed for MIS");
			    	$("#txtMISDate").focus();
			    	
			    	//document.getElementById(object.id).disabled = false;
					return false;		    	
			    }
				if (!fun_isDate($("#txtMISDate").val())) 
				    {
					 alert('Invalid Date');
					 $("#txtMISDate").focus();
					 
					 //document.getElementById(object.id).disabled = false;
					 return false;  
				   }
				if($("#txtMISCode").val().trim()=="")
				{
				 	if(AllowDateChangeInMIS=="N")
					{
				 		var spMISDate=$("#txtMISDate").val().split('-');
					    var misDate = new Date(spMISDate[2],spMISDate[1]-1,spMISDate[0]);
					    var td=new Date();
					    var d2 = new Date(td.getYear()+1900,td.getMonth(),td.getDate());
					    var dateDiff=misDate-d2;
					  //  alert(dateDiff);
					  /*  var newDate= $(this).datepicker('getDate');
				       var curDateTime = new Date();
				       var curDate = new Date(curDateTime.getFullYear(), curDateTime.getMonth(), curDateTime.getDate()); */
				       //alert("misDate"+misDate+"\d2"+d2);
				       
				       
				       
				      		 if (dateDiff < 0 ) 
				      		 {
				             	alert('Please Select Todate');
				             	$("#txtMISDate").focus();
				             	
				             	//document.getElementById(object.id).disabled = false;
				             	return false;
					         }
					 
					} 
				}
				if($("#txtLocFrom").val().trim().length == 0)
					{
						alert("Please Enter Location From or Search");
						$("#txtLocFrom").focus();
						
						//document.getElementById(object.id).disabled = false;
						return false;
					}
				 if($("#txtLocTo").val()=='')
					{
						alert("Please Enter Location To or Search");
						$("#txtLocTo").focus();
						
						//document.getElementById(object.id).disabled = false;
						return false;
					}
				 if($("#txtLocFrom").val()==$("#txtLocTo").val())
					{
						alert("Location From and Location To cannot be same");
						
						//document.getElementById(object.id).disabled = false;
						return false;
					}
				 if(rowCount<1)
					{
						alert("Please Add Product in Grid");
						
						//document.getElementById(object.id).disabled = false;
						return false;
					}
				 if(  $("#cmbAgainst").val() == null || $("#cmbAgainst").val().trim().length == 0 )
					 {
					 		alert("Please Select Against");
					 		
					 		//document.getElementById(object.id).disabled = false;
							return false;
					 }
				 
				 
				 if("${strNegStock}"=="N")
					{
						var strurl=getContextPath()+"/checkStockForAllProduct.html";					
						 $.ajax({				
						 	type: "POST",
						    url:strurl,
						    data:$("#MIS").serialize(),					  
						    context: document.body,
						    dataType: "json",
						    async:false,
						    success: function(response)
						    {	
						    	if(null!=response && response!="")
						    		{
						    			alert("No Stock is Available for Product "+ response);
										flg= false;
						    		}
						    	else
						    		{
						    			document.forms[0].action = "saveMIS.html";
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
					            flg= false;
					            
					            //document.getElementById(object.id).disabled = false;
					            return flg;
					        }
						});
					}
					else
						{
						flg= true;
						//document.getElementById(object.id).disabled = true;
						return flg;
						}
				 
				 
				 var misDate=$("#txtMISDate").val();
				 
					if(funGetMonthEnd(document.all("txtLocFrom").value,misDate)!=true)
					{
		            	alert("Month End Done For Selected Month");
		            	//document.getElementById(object.id).disabled = false;
			            return false;
		            }
					else
					{
						//document.getElementById(object.id).disabled = true;
						return true;
					}
				 

				
				
			}else{
				return false;
			}
			////document.getElementById(object.id).disabled = true;
			
							
					
		}
		
		//Check Month End done or not
		function funGetMonthEnd(strLocCode,transDate) {
			var strMonthEnd="";
			var searchUrl = "";
			searchUrl = getContextPath()+ "/checkMonthEnd.html?locCode=" + strLocCode+"&GRNDate="+transDate;;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				async: false,
				success : function(response) {
					strMonthEnd=response;
					//alert(strMonthEnd);
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
			if(strMonthEnd=="1" || strMonthEnd=="-1")
				return false;
			if(strMonthEnd=="0")
				return true;
		}
		
		
		
		
		/**
		 * Set Requisition data when user click on fill button 
		 */
		function btnFill_onclick()
		{
			if($('#txtReqCode').val()!="")
            {
                strCodes=$('#txtReqCode').val();
                strDNCodes=strCodes.split(",")
                funRemoveProductRows();
                for(ci=0;ci<strDNCodes.length;ci++)
                {
                	//funSetAgainstReqData($('#txtReqCode').val());.
                	//alert(strDNCodes[ci]);
                	funSetAgainstReqData(strDNCodes[ci]);
                
                }
            }
			
			
		}
		
		
		/**
		 * On blur event in textfield
		 */
		$(function()
				{
					$("#txtMISCode").blur(function()
					{
						if(!$("#txtMISCode").val()=='')
						{
							fieldName ="MIS";
							//funSetData($('#txtMISCode').val());						
						}					
					});
				    
					$('a#baseUrl').click(function() {
						if($("#txtMISCode").val().trim()=="")
						{
							alert("Please Select MIS Code");
							return false;
						}

						//Open Document Attach Link
						 window.open('attachDoc.html?transName=frmMIS.jsp&formName=Material Issue Slip&code='+$('#txtMISCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					});
				});

				$(function()
						{
					
					$('#txtLocFrom').blur(function () {
						var code=$('#txtLocFrom').val();
						if (code.trim().length > 0 && code !="?" && code !="/"){							   
							   funSetLocationFrom(code);
							 
						   }
						});
					
					$('#txtLocTo').blur(function () {
						 var code=$('#txtLocTo').val();
						 if (code.trim().length > 0 && code !="?" && code !="/"){	
						     funSetLocationTo(code)
							  
						   }
						});
					
					
// 					$('#txtProdCode').blur(function () {
// 						 var code=$('#txtProdCode').val();
// 						 if (code.trim().length > 0 && code !="?" && code !="/"){							   
// 							   funSetProduct(code);
// 						   }
// 						});

					$('#txtProdCode').keydown(function(e){
					var code=$('#txtProdCode').val();
						 if (e.which == 9 ){
							 if (code.trim().length > 0 && code !="?" && code !="/") {
							  		
						  		funSetProduct(code);
						  	}
						  }
					if(e.which == 13)
							{
								if (code.trim().length > 8) {
							  		funCallBarCodeProduct(code)
							  	}
							  	else if(code.trim().length > 0 )
									{
									funSetProduct(code);
									}
							}
					});
					
					$('#txtMISCode').blur(function () {
						var code=$('#txtMISCode').val();
						if (code.trim().length > 0 && code !="?" && code !="/"){						   
							   funGetMISData(code);
						   }
						});
						
					});
		
		
				
		/**
		 * Apply Number Validation
		**/
		function funApplyNumberValidation(){
			$(".numeric").numeric();
			$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
			$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
			$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
		    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
		}
		//Reset field
		function funResetFields()
		{
			location.reload(true); 
		}	
		
		
		function funDuplicateProductFroRow(strProdCode)
		{
		 var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;		   
		    var flag=false;
		    if(rowCount > 0)
		    	{
				    $('#tblProdDet tr').each(function()
				    {
					    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	flag=true; 
					    	
		    			
	    				}
					});
				    
		    	}
		    return flag;
		}
		
		
		
		function funCallBarCodeProduct(code)
		{
			var searchUrl="";		
			searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
			//alert(searchUrl);
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",			   
				    success: function(response)
				    {
				    	if('Invalid Code' == response.strProdCode){
				    		alert('Invalid Product Code');
					    	$("#txtProdCode").val('');
					    	$("#spProdName").text('');
					    	$("#txtProdCode").focus();
				    	}else
				    	{
				    		var dblStock=funGetProductStock(response.strProdCode);
				    		
				    					    		
				    		 var strProdCode = response.strProdCode;
								if(funDuplicateProductFroRow(strProdCode))
									{
									
									 var table = document.getElementById("tblProdDet");
									  var rowCount = table.rows.length;
									  
									    if(rowCount > 0)
									    	{
											    $('#tblProdDet tr').each(function()
											    {
												    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
								    				{
												    	
												    	var index=$(this).index(); //this.parentNode.parentNode.rowIndex;
														var qty=document.getElementById("dblQty."+index).value;

												    	qty=parseFloat(qty);
												    	qty+=1;
												    	var totalPrice = parseFloat(response.dblCostRM)*qty;
												    	document.getElementById("dblTotalPrice."+index).value=totalPrice;
												    	document.getElementById("dblQty."+index).value=qty;
	 											    	
	 											    	
								    				}
												    
												});
											    
									    	}
									   															  
									}
										else
								    	{
// 											strProdCode,strProdName,strUOM,stock,dblProdQty,dblUnitPrice,strRemarks
								    			funAddRowBarCodeWise(response.strProdCode,response.strProdName,response.strIssueUOM,dblStock,1,response.dblCostRM,'');
									    }
								$("#txtProdCode").val('');
								$("#txtProdCode").focus();
				    		
				    		
				    		
				    		
// 				    		//alert(dblStock);
// 				    		$("#spStock").text(dblStock);
// 				    		$("#spStockUOM").text(response.strIssueUOM);
// 					    	$("#txtProdCode").val(response.strProdCode);
// 					    	$("#spProdName").text(response.strProdName);
// 							$("#strUOM").val(response.strIssueUOM);
// 							var costRm=response.dblCostRM;
// 							var issueConv =response.dblIssueConversion;
// 							var recipeCov = response.dblRecipeConversion;
// 							var unitPrice=parseFloat(costRm)/parseFloat(issueConv);
							
// 							$("#txtUnitPrice").val(unitPrice);
// 							$("#hidExpDate").val(response.strExpDate);
// 							$("#txtProdQty").focus();
				    	}
				    },
					error: function(e)
				    {
				       	alert('Invalid Product Code');
				       	$("#txtProdCode").val('');
				    	$("#spProdName").text('');
				    	$("#txtProdCode").focus();
				    }
			      });
		}
		
		function funAddRowBarCodeWise(strProdCode,strProdName,strUOM,stock,dblProdQty,dblUnitPrice,strRemarks) 
		{			
			
			if(strUOM==null)
				{
					strUOM="";
				}
			
		    var strExpiry=$("#hidExpDate").val();
		    dblProdQty=parseFloat(dblProdQty).toFixed(maxQuantityDecimalPlaceLimit);
		    dblUnitPrice=parseFloat(dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);
		    var dblTotalPrice=parseFloat(dblProdQty*dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);		    
		    if("${strNegStock}"=="N")
	         {
	                if(parseFloat(stock) < parseFloat(dblProdQty))
	                {
	                    alert("Issue Quantity > Available Stock");
	                    $("#txtProdQty").focus();
	                    return false;
	                }
	        }
		    
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
// 		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listMISDtl["+(rowCount)+"].strProdCode\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";   
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"42%\" name=\"listMISDtl["+(rowCount)+"].strProdName\" id=\"strProdName."+(rowCount)+"\" value='"+strProdName+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listMISDtl["+(rowCount)+"].strUOM\" id=\"strUOM."+(rowCount)+"\" value='"+strUOM+"' />";		    
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listMISDtl["+(rowCount)+"].dblStock\" id=\"dblStock."+(rowCount)+"\" value='"+stock+"'/>";
		    row.insertCell(4).innerHTML= "<input type=\"text\"  required = \"required\" style=\"text-align: right;\" class=\"decimal-places inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblQty\" id=\"dblQty."+(rowCount)+"\" value="+dblProdQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";		    
		    row.insertCell(5).innerHTML= "<input disabled=\"disabled\" class=\"inputText-Auto Box\"></input>";
		    row.insertCell(6).innerHTML= "<input readonly=\"true\" type=\"text\"  required = \"required\" style=\"text-align: right;\" class=\"inputText-Auto\" name=\"listMISDtl["+(rowCount)+"].dblUnitPrice\" id=\"dblUnitPrice."+(rowCount)+"\" value='"+dblUnitPrice+"'/>";
		    row.insertCell(7).innerHTML= "<input class=\"Box\" style=\"text-align: right;\" readonly=\"readonly\" size=\"7%\" name=\"listMISDtl["+(rowCount)+"].dblTotalPrice\" id=\"dblTotalPrice."+(rowCount)+"\" value='"+dblTotalPrice+"' />";
		    row.insertCell(8).innerHTML= "<input disabled=\"disabled\" class=\"inputText-Auto Box\"></input>";
		    row.insertCell(9).innerHTML= "<input size=\"25%\" name=\"listMISDtl["+(rowCount)+"].strRemarks\" id=\"strRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";		    
		    row.insertCell(10).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
		    row.insertCell(11).innerHTML= "<input name=\"listMISDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
		    listRow++;
		    funUpdateIssueUOM();
		    funCalculateTotalAmt();
		    funApplyNumberValidation();
		    funClearProduct();
		}
		
		
		
		
		
		
		
		
		function  funCloseReq_onclick()
		{
			
		}
		
		
		function funGetKeyCode(event,controller) {
		    var key = event.keyCode;
		    
		    if(controller=='IssueQty' && key==13)
		    {
		    	btnAdd_onclick();
		    }
		}
		
		function funOpenExportImport()			
		{
			var transactionformName="frmMIS";
			var locCode=$('#txtLocFrom').val();
			var dtPhydate=$("#txtMISDate").val();
			var strReqcode=$("#txtReqCode").val();
			
			response=window.open("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode+"&dtPIDate="+dtPhydate,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
			
			var timer = setInterval(function ()
				    {
					if(response.closed)
						{
							if (response.returnValue != null)
							{
								funRemoveProductRows();
								var count=0;
								var retValue =response.returnValue;
								$.each(retValue, function(i,item)
					               { 
									count=i;
									funfillProdRow(retValue[i].strProdCode,retValue[i].strProdName,
											retValue[i].strUOM,retValue[i].dblQty,retValue[i].dblUnitPrice,
											retValue[i].strRemarks,strReqcode,retValue[i].dblStock);                 
										$('#hidDocCode').val(retValue[i].strDocCode);
										$('#hidDocType').val(retValue[i].strDocType);
					               
					               });
								listRow=count+1;
			
							}
							clearInterval(timer);
						}
				    }, 500);
						        	
		}
		
		function funSetProductionData(code)
		{
			var searchUrl="";		
			searchUrl=getContextPath()+"/loadProductionData.html?PDCode="+code;
			//alert(searchUrl);
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	$.each(response, function(i,item)
				    	{
				    		if(response[i].strPDCode!="Invalid Code")
				    			{
				    				funFillDataForBatching(response);	
				    			}
				    		else
				    			{
				    				
				    			}
				    	
					     });
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
		
		function funFillDataForBatching(response)
		{
			var count=0;
			$.each(response, function(i,item)
	    			{		
						count=i;
						$("#txtReqCode").val(response[i].strPDCode);									    
			    		$("#txtLocFrom").val(response[i].strLocCode)
			    		funGetProdDataForBatching($("#txtReqCode").val());
	    			});
			listRow=count+1;
		}
		
		function funGetProdDataForBatching(strPDcode)
		{	
			searchUrl=getContextPath()+"/loadProductionDtlData.html?PDCode="+strPDcode;				
			$.ajax({				
	        	type: "GET",
		        url: searchUrl,
		        dataType: "json",
		        success: function(response)
		        {				        	
		        	/* funRemRows(); */
					$.each(response, function(i,item)
	                {
						funfillProdRowForBatching(response[i].strProdCode,response[i].strPartNo,response[i].strProdName,response[i].strProcessCode,response[i].strProcessName,response[i].strUOM,response[i].dblQtyProd,response[i].dblQtyRej,response[i].dblWeight,response[i].dblPrice,response[i].dblActTime);
	                                               
	                });
					
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
		
		function funfillProdRowForBatching(strProdCode,strPartNo,strProdName,strProcessCode,strProcessName,strUOM,dblQtyProd,dblQtyRej,dblWeight,dblPrice,dblActTime)
		{	  
		    var dblAcceptedQty=dblQtyProd-dblQtyRej;
	        var dblTotWt=dblQtyProd*dblWeight;
	        var dblTotalPrice=dblAcceptedQty*dblPrice;
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		  
		    row.insertCell(0).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"8%\"   id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";	
		    row.insertCell(1).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"48%\"  id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"' />";	
		    row.insertCell(2).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].strUOM\" readonly=\"readonly\" class=\"Box\" size=\"3%\"  id=\"txtUOM."+(rowCount)+"\" value='"+strUOM+"' />";
		    row.insertCell(3).innerHTML=" <input name=\"listonMISDtl["+(rowCount)+"].strProcessCode\" readonly=\"readonly\" class=\"Box\" size=\"8%\"  id=\"strProcessCode."+(rowCount)+"\" value="+strProcessCode+">";
		    row.insertCell(4).innerHTML=" <input name=\"listonMISDtl["+(rowCount)+"].strProcessName\" readonly=\"readonly\" class=\"Box\" size=\"8%\"  id=\"strProcessName."+(rowCount)+"\" value="+strProcessName+">";	
		    row.insertCell(5).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblQty\" type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\" size=\"5%\" id=\"txtQtyProd."+(rowCount)+"\" value="+dblQtyProd+">";
		    row.insertCell(6).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblWeight\" type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\"  size=\"5%\" id=\"txtWt."+(rowCount)+"\" value="+dblWeight+">";
		    row.insertCell(7).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dtlTotWt\"  class=\"Box\" style=\"text-align: right;width:100%\" size=\"5%\" id=\"dtlTotWt."+(rowCount)+"\" value="+dblTotWt+">";
		    row.insertCell(8).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblUnitPrice\"  type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\" size=\"5%\" id=\"dblPrice."+(rowCount)+"\" value="+dblPrice+">";
		    row.insertCell(9).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblTotalPrice\"  class=\"Box\" style=\"text-align: right;width:100%\" size=\"5%\" id=\"dblTotalPrice."+(rowCount)+"\" value="+dblTotalPrice+">";
		    row.insertCell(10).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblQtyRej\" type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\" size=\"5%\" id=\"txtQtyRej."+(rowCount)+"\" value="+dblQtyRej+">";
		    row.insertCell(11).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblAcceptedQty\"  type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\"  size=\"5%\" id=\"dblAcceptedQty."+(rowCount)+"\" value="+dblAcceptedQty+">";	    
		    row.insertCell(12).innerHTML= "<input name=\"listonMISDtl["+(rowCount)+"].dblActTime\"  type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:100%\"  size=\"5%\" id=\"txtActTime."+(rowCount)+"\" value="+dblActTime+">";		    
		    row.insertCell(13).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		    
		}
		
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Material Issue Slip</label>
		<s:form name="MIS" id="MIS" action="saveMIS.html?saddr=${urlHits}" method="POST" >
		
		<s:input path="strAuthorise" type="hidden" id="hidAuthorise"  name="strAuthorise" value=""></s:input>
		<div class="row transTable">
			<div class="col-md-12">
			 	<!-- <a id="baseUrl" href="#">Attach Documents</a> -->
				<a onclick="funOpenExportImport()"href="javascript:void(0);">Export/Import</a>
			</div>
			<div class="col-md-2">
				<label>MIS Code</label>
				<s:input id="txtMISCode" name="txtMISCode" path="strMISCode" value="${command.strMISCode}"
						ondblclick="funHelp('MIS')" cssClass="searchTextBox" />
			</div>
			<div class="col-md-2">
				<!-- <td><label>MIS Date:</label></td> -->
				<label>MIS Date</label>
				<s:input id="txtMISDate" name="txtMISDate" type="text" required="required" path="dtMISDate" pattern="\d{1,2}-\d{1,2}-\d{4}" 
						value="${command.dtMISDate}" cssClass="calenderTextBox" style="width:80%;"/>
			</div>
			<div class="col-md-2">
				<s:label path="strLocFrom">Location By</s:label>
				<s:input id="txtLocFrom" name="txtLocFrom" path="strLocFrom" value="${command.strLocFrom}"
						ondblclick="funHelp('StoreLocationTo')" cssClass="searchTextBox" />
			</div>
			<div class="col-md-2">			
				<s:label path="strLocFrom" id="lblLocFrom" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align: center;"></s:label>
			</div>
			<div class="col-md-4"></div>
			<div class="col-md-2">
				<s:label path="strLocTo">Location To</s:label>
				<s:input id="txtLocTo" name="txtLocTo" path="strLocTo"						
						ondblclick="funLocationOnOpen('loconMIS');" cssClass="searchTextBox" />
			</div>
			<div class="col-md-2">
				<s:label id="lblLocTo" path="strLocTo"  style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align: center;"></s:label>
			</div>
			<div class="col-md-2">
				<label>Against</label>
				<s:select id="cmbAgainst" items="${strProcessList}"  onchange="funOnChange();"	name="cmbAgainst" cssClass="BoxW124px" path="strAgainst">
					</s:select>
			</div>
			<div class="col-md-2">
				<s:input id="txtReqCode" name="txtReqCode" path="strReqCode" ondblclick="return funOpenAgainst();" cssClass="searchTextBox" style="margin-top:27px;"/>
			</div>
			<div class="col-md-2">
				<span id="spQty" style="display:none">Qt</span>
				<s:input id="txtWoQty" name="txtWoQty" path="" value=""	type="number" style="display:none"/>
			</div>
			<div class="col-md-2"></div>
			<div class="col-md-2">
				<label id="lblCloseReq" style="display:block"> Close Req.</label>
<!--            <td><input id="chkCloseReq" value="Y" style="width: 36px;" 	type="checkbox" onclick="return cbCloseReq_onclick()" /> -->
				<s:checkbox id="chkCloseReq" path="strCloseReq" value="Y" />	
			</div>
			<div class="col-md-2">
				<input type="Button" id="btnFill" value="Fill" 	onclick="return btnFill_onclick()" class="btn btn-primary center-block" style="margin-top: 20px; display:none"/>
			</div>
		</div>
		<div class="row transTable">
			<div class="col-md-2">
				<label>Product Code</label>
				<!-- <td width="20%"><input id="txtProdCode" name="txtProdCode" ondblclick="funHelp('productmasterStkable')" class="searchTextBox" /></td> -->
				<input id="txtProdCode" name="txtProdCode" ondblclick="funHelp('productInUse')" class="searchTextBox" />
			</div>
			<div class="col-md-2">
				<!-- productInUse -->
				<label>Product Name</label>
				<label id="spProdName" style="background-color:#dcdada94; width: 100%; height: 52%;text-align: center;"></label>
			</div>	
			<div class="col-md-2">	
				<label>UOM</label> 
				<s:select id="strUOM" name="strUOM" path="" items="${uomList}"  cssClass="BoxW124px"/>
				<%-- <td><span id="strUOM"></span></td> --%>
			</div>
			<div class="col-md-2">
				<label>Stock</label>
				<label id="spStock" class="namelabel"></label>
				<span id="spStockUOM"></span>
			</div>	
			<div class="col-md-4"></div>
			<div class="col-md-2">
				<label>Issue Qty</label>
				<input id="txtProdQty" name="txtProdQty" type="text" step="any" class="decimal-places numberField" onkeypress="funGetKeyCode(event,'IssueQty')"/>
			</div>
			<div class="col-md-2">				
				<label>Unit Price</label>
				<input id="txtUnitPrice" name="txtUnitPrice" type="text" step="any" class="decimal-places numberField"  readonly />	
			</div>
			<div class="col-md-2">	
				<label>Remarks</label>
				<input id="txtRemarks" name="txtRemarks" type="text" />
				<input type="hidden" id="hidExpDate">
			</div>
			<div class="col-md-2">
				<input type="Button" value="Add" onclick="return btnAdd_onclick()" class="btn btn-primary center-block" style="margin-top: 20px;"/>
			</div>
		</div><br>
		<div class="dynamicTableContainer" style="height: 300px;">
			<table style="height: 20px; border: #0F0;width: 100%;font-size:11px;
				font-weight: bold;">
				<tr bgcolor="#c0c0c0">
					<td width="7%" style="padding-left: 10px;">Prod Code</td>					
					<td width="25%" style="padding-left: 10px;">Product Name</td>	
					<td width="6%">UOM</td>	
					<td width="5%">Stock</td>				
					<td width="6%">Issue Qty</td>
                    <td width="6%">Pending Qty</td> 
                    <td width="6%">Unit Price</td>
                    <td width="7%">Total Price</td> 
                    <td width="10%">MR Code</td>        
					<td width="0%">Remarks</td>
					<td width="5%">Delete</td>
				</tr>
			</table>
			<div  style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
					<table id="tblProdDet"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col11-center">
					<tbody>
					<col style="width:8%">					
					<col style="width:28%">
					<col style="width:4%">
					<col style="width:3%">
					<col style="width:7%">
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:5%">
					<col style="width:8%">
					<col style="width:14%">
					<col style="width:3%">
					<col style="width:0%">
					</tbody>
				</table>
			</div>
		</div>
		<div class="row transTable">
			<div class="col-md-2">
				<label>Total Amt:</label><br>
				<s:input type="text" cssClass="decimal-places numberField" id="txtTotalAmt" style="text-align:right;" readonly="true" path="dblTotalAmt"/>
			</div>
			<div class="col-md-2">	
				<label>Narration</label><br>
				<s:textarea id="txtNarration" path="strNarration" value="${command.strNarration}" style="width:100%; height:27px;"></s:textarea>
			</div>
		</div>
		
		<div class="center" style="text-align:center">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick="return funCallFormAction('submit',this)">Submit</button></a>&nbsp
		<input type="button" class="btn btn-primary center-block"  value="Reset" onclick="funResetFields();" />
		</div>
<%-- 		<s:input type="hidden" id="hidReqClose" path="strCloseReq"></s:input> --%>
			<br><br>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
			<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
		</div>
	</s:form>
</div>
	<script type="text/javascript">
	funApplyNumberValidation();
	funOnChange();
	</script>
</body>
</html>