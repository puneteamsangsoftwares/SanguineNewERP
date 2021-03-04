<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />	
	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
<title>Insert title here</title>

	<script>
	
		var transactionName,fieldName;
	
		$(function ()
		{			
			$( "#txtFromDate" ).datepicker();
			$( "#txtToDate" ).datepicker();
			
			funSetTransCodeHelp($("#cmbFormName").val());
			
			
			
			$("#btnReset").click(function( event )
			{
				$('#divDocReco').html("");
			});
			
			$("#cmbFormName").change(function() 
			{
				var value=$("#cmbFormName").val();
				funSetTransCodeHelp(value);
			});
			
		});
		
		
		function funOpenDocument(obj)
		{			
			var idd=obj.id;
			var spTrans=idd.split(' ');
			
			var transName=idd.substring(idd.lastIndexOf('#')+1,idd.length);
			//alert(transName+'    '+spTrans[0]);
			window.open(getContextPath()+"/setReportFormName.html?docCode="+spTrans[0]+","+transName+"");
		}		
		
		var count = 0;
		
		function funGenerateDocRecoTree(frmName,docCode,type)
		{
			var tree1='';
			var fromDate='';
			var toDate='';
			var param1=frmName+","+docCode+","+type;
			
			var searchUrl=getContextPath()+"/showDocReconc.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate;
			$.ajax({
			        type: "GET",
			        url: searchUrl,
			        async: false,
				    dataType: "json",
				    success: function(respBillPass)
				    {
				    	tree='<ul>';
				    	$.each(respBillPass, function(i,respGRN)
						{
				    		if(i!='Empty')
				    		{
				    			var spTrans=i.split('#');
				    			tree+='<li>'+spTrans[0] + '&nbsp;&nbsp;<input type="button" id="'+i+'" value="View" onClick="funOpenDocument(this);">';
				    			tree+='<ul>';
				    		}
				    		$.each(respGRN, function(g,respPO)
							{
				    			if(g!='Empty')
					    		{
				    				var spTrans=g.split('#');
					    			tree+='<li>'+spTrans[0] + '&nbsp;&nbsp;<input type="button" id="'+g+'" value="View" onClick="funOpenDocument(this);">';
					    			tree+='<ul>';
					    		}
				    			$.each(respPO, function(po,respPI)
								{
				    				if(po!='Empty')
				    				{
				    					var spTrans=po.split('#');
				    					//tree+='<li>'+po;
				    					tree+='<li>'+spTrans[0] + '&nbsp;&nbsp;<input type="button" id="'+po+'" value="View" onClick="funOpenDocument(this);">';
					    				tree+='<ul>';
				    				}
				    				$.each(respPI, function(pi,item)
									{
				    					var spTrans=pi.split('#');
				    					tree+='<li>'+spTrans[0] + '&nbsp;&nbsp;<input type="button" id="'+pi+'" value="View" onClick="funOpenDocument(this);">';
				    					tree+='</li>';
									});
				    				tree+='</ul>';
				    				tree+='</li>';
								});
				    			if(g!='Empty')
					    		{
					    			tree+='</ul>';
				    				tree+='</li>';
					    		}
							});
				    		if(i!='Empty')
				    		{
				    			tree+='</ul>';
			    				tree+='</li>';
				    		}
				    	});
				    	
				    	tree+='</ul>';
				    	//$('#divDocReco').html(tree);
				    	var div = jQuery('<div id="a'+(count++)+'"></div>').html(tree);
				    	$('#divDocReco').html("");
				    	$('#divDocReco').append(div);
				    	div.fancytree();
				    	//alert(tree);
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
		
		
		function funSetTransCodeHelp(value)
		{
			switch (value) 
			{
			   case 'frmGRN':
				   transactionName='grncode';
			       break;
			       
			   case 'frmMaterialReturn':
				   transactionName='MaterialReturn';
			       break;
			       
			   case 'frmOpeningStock':
				   transactionName='opstock';
			       break;
			   
			   case 'frmPurchaseIndent':
				   transactionName='PICode';
			       break;
			       
			   case 'frmPurchaseOrder':
				   transactionName='purchaseorder';
			       break;
			      
			   case 'frmWorkOrder':
				   transactionName='WorkOrder';
			       break;
			   
			   case 'frmStockTransfer':
				   transactionName='stktransfercode';
			       break;
			       
			   case 'frmBillPassing':
				   transactionName='BillPassing';
			       break;
			   
			   case 'frmMIS':
				   transactionName='MIS';
			       break;
			       
			   case 'frmMaterialReq':
				   transactionName='MaterialReq';
			       break;
			       
			       
			}
		}
		
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'reason':
			    	funSetReason(code);
			        break;
			    
			    case 'transaction':
			    	funSetTrasactionCode(code);
			        break;
			}
		}
		
		
		function funHelp1(field)
		{
			fieldName=field;
	        window.open("searchform.html?formname="+field+"&searchText=", 'window', 'width=600,height=600');
	    }
		
		function funHelp()
		{
			fieldName='transaction';
	        window.open("searchform.html?formname="+transactionName+"&searchText=", 'window', 'width=600,height=600');
	    }
		
		function funSetTrasactionCode(code)
		{
			$("#txtTransactionCode").val(code);
		}
		
		function funOnClick()
		{
			if($("#txtTransactionCode").val()=='')
			{
				alert("Please Select Transaction Code");
				return false;
			}
			
			funGenerateDocRecoTree($("#cmbFormName").val(),$("#txtTransactionCode").val(),$("#cmbType").val());
			return false;
		}
		
	</script>

</head>
	<body>
	<div class="container">
		<label id="formHeading">Document Reconciliation Flash</label>
		<s:form id="frmDocReconciliation" method="GET" action="">
		    <div class="row masterTable">
		   		<div class="col-md-2">
		   			<label>Form Name</label>
						<s:select id="cmbFormName" path="strFormName" style="width:auto;">
							<s:options items="${listFormName}"/>
						</s:select>
				</div>&nbsp;&nbsp;&nbsp;
				<div class="col-md-2">	
					<label>Code</label>
					<s:input type="text" name="code" id="txtTransactionCode"  cssClass="searchTextBox"  path="strTransCode" ondblclick="funHelp();"/>						
				</div>
					<!-- <td>
						<input type="button" id="btnShow" />
					</td> -->
				<!-- 		    			    
			    <tr>
			        <td><label id="lblFromDate">From Date</label></td>
			        <td>
			            <s:input id="txtFromDate" name="fromDate" path="dteFromDate" cssClass="BoxW116px"/>
			        	<s:errors path="dteFromDate"></s:errors>
			        </td>
				        
			        <td><label id="lblToDate">To Date</label></td>
			        <td colspan="4">
			            <s:input id="txtToDate" name="toDate" path="dteToDate" cssClass="BoxW116px"/>
			        	<s:errors path="dteToDate"></s:errors>
			        </td>
			    </tr>
			     -->
			    <div class="col-md-2">	
			    	<label>Type</label>
			       	<s:select id="cmbType" path="strType">
						<s:option value="Forward"/>
						<s:option value="Backward"/>
					</s:select>
				</div>
			</div>
		<div class="center" style="margin-right: 50%;">
		   <a href="#"><button class="btn btn-primary center-block"  value="Execute" id="btnSubmit" onclick="return funOnClick()" >Execute</button></a>
		   &nbsp;
		   <a href="#"><button class="btn btn-primary center-block"  value="Reset" id="btnReset">Reset</button></a>
		</div>
			
			<!-- 
			<p align="center">
				<input type="button" value="Execute" id="btnSubmit" class="form_button" />
				<input type="reset" value="Reset" id="btnReset" class="form_button" />
			</p>-->
		<div id="divDocReco">				
		</div>
</s:form>
</div>
</body>
</html>