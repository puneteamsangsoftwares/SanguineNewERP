<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="default.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title>RECIPE MASTER</title>
<style>
#lblFormName  {
	font-family: 'trebuchet ms';
	font-size: 20px;
	color: #646777;
	font-weight: bold;
	padding:0px;
}
</style>

<script type="text/javascript">
				
		var fieldName,listRow=0; 
	
		 $(document).ready(function () 
		 {
			 
		    	var strIndustryType='<%=session.getAttribute("strIndustryType").toString()%>';
		   		//alert("Upper");
		   		
		   		switch(strIndustryType) 
		   		{
		   		
		   		case 'Manufacture' :
		   			$("#lblFormName").text("Bom Master");
		   			$("#lblRecipeCode").text("Bom Code");
		   			
		   			break;
		   			
		   		case 'Hospitality' :	
		   			$("#lblFormName").text("Recipe Master");
		   			$("#lblRecipeCode").text("Recipe code");
		   			
		   			break;
		   			
		   		default :
		   			$("#lblFormName").text("Recipe Master");
		   		$("#lblRecipeCode").text("Recipe code");
		   			break;
		   		}
			 if($("#txtFromDate").val()=='')
			 {
			 $( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			 $("#txtFromDate" ).datepicker('setDate', 'today');
			 }if($("#txtToDate").val()=='')
			 {
			 $( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			 $("#txtToDate" ).datepicker('setDate', 'today');
			 }
			 $(document).ajaxStart(function(){
				    $("#wait").css("display","block");
				  });
				  $(document).ajaxComplete(function(){
				    $("#wait").css("display","none");
				  });
			 
		});
		
		function funResetFields()
		{
			location.reload(true); 	
	    }
		
		function funHelp(transactionName)
		{
			fieldName=transactionName;
			if(transactionName=='childcode')
			{
				if($("#txtParentCode").val()=='')
				{
					alert('Please Select parent item Code');
					return false;
				}
				/* if($("#txtParentQty").val()=='0.0')
				{
					alert('Please Enter parent item quantity');
					return false;
				}	 */			
			}
	        //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=", 'window', 'width=600,height=600');
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:300px;")
	    	    window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:300px;")
		}
		
	 	function funSetBom(code)
		{
	 		
	 		$("#txtBomCode").val(code);
	 		searchUrl=getContextPath()+"/loadBOMMaster.html?BOMCode="+code;
			//alert(searchUrl);
			$.ajax({
		        type: "POST",
		        url: searchUrl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strBOMCode!="Invalid Code")
		        		{
				        	$("#txtParentCode").val(response.strParentCode);	        		
			        		$("#txtParentCodeName").val(response.strParentName);
			        		$("#txtSGCode").val(response.strSGCode);
			        		$("#txtSGName").val(response.strSGName);
			        		$("#txtPOSItemCode").val(response.strPOSItemCode);
			        		$("#txtType").val(response.strProdType);
			        		$("#lblUOM").text(response.strUOM);
			        		$("#txtFromDate").val(response.dtValidFrom);
			        		$("#txtToDate").val(response.dtValidTo);
			        		$("#txtMethod").val(response.strMethod);
			        		$("#txtQty").focus();
			        		fillParentImage(response.strParentCode);
			        		
			        		var count=0;
				        	funRemoveProductRows();
				        	var listdata=response.listBomDtlModel
							$.each(listdata, function(i,item)
			                {
								count=i;
								funLoadBomData(listdata[i].strChildCode,listdata[i].strProdName,listdata[i].dblQty,listdata[i].strUOM );
								                          
			                });
							listRow=count+1;
							funShowRecipeCost(code);
			        		
		        		}
		        	else
		        		{
		        			alert("Invalid Child Code");
		        			$("#txtChildCode").val('');
		        			$("#txtChildCode").focus();
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
	 		
// 			document.recipeForm.action="frmBOMMaster1.html?BOMCode="+code;
// 			document.recipeForm.submit();
			
		} 
		
		function funSetChild(code)
		{
			searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
			//alert(searchUrl);
			$.ajax({
		        type: "GET",
		        url: searchUrl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strProdCode!="Invalid Code")
		        		{
				        	$("#txtChildCode").val(response.strProdCode);	        		
			        		$("#lblItemName").text(response.strProdName);
			        		$("#lblUOM").text(response.strRecipeUOM);
			        		$("#txtQty").focus();
		        		}
		        	else
		        		{
		        			alert("Invalid Child Code");
		        			$("#txtChildCode").val('');
		        			$("#txtChildCode").focus();
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
		
		function funSetProduct(code)
		{
			searchUrl=getContextPath()+"/loadProductData.html?prodCode="+code;
			//alert(searchUrl);
			$.ajax({
		        type: "GET",
		        url: searchUrl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strParentCode!="Invalid Product Code")
		        		{
		        		
		        			if(response.strBOMCode.length>0)
		        				{
		        					alert("BOM already created :"+response.strBOMCode);
		        				}else
		        					{
		        					$("#txtParentCode").val(response.strParentCode);
					        		$("#txtParentCodeName").val(response.strParentName);
					        		$("#txtPOSItemCode").val(response.strPartNo);
					        		$("#txtType").val(response.strProdType);
					        		$("#txtSGCode").val(response.strSGCode);
					        		$("#txtSGName").val(response.strSGName);			        		
					        		$("#cmbProcessName").val(response.strProcessName);
					        		$("#txtUOM").val(response.strUOM);
					        		//$("#txtParentQty").focus();
					        		funGetImage(code);
		        					}
		        		
				        	
		        		}
		        	else
		        		{
		        			alert("Invalid Parent Product Code");
		        			$("#txtParentCode").val("");
		        			$("#txtParentCode").focus();
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
		
		
		function funSetData(code)
		{			
			switch (fieldName) 
			{			   
			   case 'bomcode':
			    	funSetBom(code);
			        break;
			   
			   case 'childcode':
			    	funSetChild(code);
			        break;
			        
			   case 'productProduced':
			    	funSetProduct(code);
			        break;
			}
		}
				
		function btnAdd_onclick() 
		{			
			
			if($("#txtChildCode").val().trim().length==0)
		    {
				  	alert("Please Enter Child Product Code Or Search");
			     	$('#txtProdCode').focus();
			     	return false; 
		    }
			
		    if(($("#txtQty").val() == 0) || ($("#txtQty").val().trim().length==0  ))
			 {
					  alert("Please Enter Quantity ");
				       $('#txtQty').focus();
				       return false; 
			}			     	 
			else
		    {
				var strProdCode=$("#txtChildCode").val();
				if(funDuplicateProduct(strProdCode))
	            	{
						funAddRow();
	            	}
			}
		 
		}
		
		
		function funLoadBomData(strChildCode,strProdName,dblQty,strUOM)
		{
			
		    var table = document.getElementById("tblChild");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input type=\"text\" class=\"Box id\" size=\"10%\" style=\"border:1px solid #a2a2a2;padding:1px;\" name=\"listBomDtlModel["+(rowCount)+"].strChildCode\" id=\"txtChildCode."+(rowCount)+"\" value="+strChildCode+" >";		    
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"50%\" name=\"listBomDtlModel["+(rowCount)+"].strProdName\"  id=\"lblItemName."+(rowCount)+"\" value='"+strProdName+"' >";
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" name=\"listBomDtlModel["+(rowCount)+"].dblQty\" id=\"txtQty."+(rowCount)+"\" value="+dblQty+">";
		    row.insertCell(3).innerHTML= "<input class=\"Box\" size=\"7%\" name=\"listBomDtlModel["+(rowCount)+"].strUOM\" id=\"lblUOM."+(rowCount)+"\" value="+strUOM+">";
		    row.insertCell(4).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		    fillChildImage(strChildCode);
		    funResetProductFields();
		    listRow++;
		    return false;
		}
		
		function funDuplicateProduct(strProdCode)
		{
		    var table = document.getElementById("tblChild");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblChild tr').each(function()
				    {
					    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added "+ strProdCode);
		    				flag=false;
	    				}
					});
				    
		    	}
		    return flag;
		  
		}
		
		function funAddRow() 
		{
			var childCode = document.getElementById("txtChildCode").value;
			var parentCode = document.getElementById("txtParentCode").value;
			if(childCode==parentCode)
				{
					alert("Parent Prouct and Child Product is Same");
					$("#txtChildCode").val('');
					$("#lblUOM").text("");
	        		$("#txtQty").val("");
        			$("#txtChildCode").focus();
					return false;
				}
			else
				{
			
			    var qty = document.getElementById("txtQty").value;
			    var uom = document.getElementById("lblUOM").innerHTML;		    
			    var itemName = document.getElementById("lblItemName").innerHTML;
			    //var qtyConversion = document.getElementById("txtQtyConversion").value;
			    //alert("qtyConversion\t"+qtyConversion);
			    var table = document.getElementById("tblChild");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    rowCount=listRow;
			    row.insertCell(0).innerHTML= "<input type=\"text\" class=\"Box id\" size=\"10%\" style=\"border:1px solid #a2a2a2;padding:1px;\" name=\"listBomDtlModel["+(rowCount)+"].strChildCode\" id=\"txtChildCode."+(rowCount)+"\" value="+childCode+" >";		    
			    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"50%\" name=\"listBomDtlModel["+(rowCount)+"].strProdName\"  id=\"lblItemName."+(rowCount)+"\" value='"+itemName+"' >";
			    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;border:1px solid #a2a2a2;padding:1px;\" class=\"inputText-Auto\" name=\"listBomDtlModel["+(rowCount)+"].dblQty\" id=\"txtQty."+(rowCount)+"\" value="+qty+">";
			    row.insertCell(3).innerHTML= "<input class=\"Box\" size=\"7%\" name=\"listBomDtlModel["+(rowCount)+"].strUOM\" id=\"lblUOM."+(rowCount)+"\" value="+uom+">";
			    row.insertCell(4).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
			    fillChildImage(childCode);
			    funResetProductFields();
			    listRow++;
			    return false;
		    
				}
		}
		 
		function funDeleteRow(obj) 
		{
			var index = $(obj).closest('tr').index();
			var icode = $(obj).closest("tr").find("input[type=text]").val();
		    $("#childProdImages #"+icode).remove();
		    var table = document.getElementById("tblChild");
		    table.deleteRow(index);
		}
			
		
		function funResetProductFields()
		{
			$("#txtChildCode").val('');
		    $("#txtQty").val('');
		    document.getElementById("lblUOM").innerHTML='';
		    document.getElementById("lblItemName").innerHTML='';
		    //$("#txtQtyConversion").val('1');
		}
		
		
		$(function()
		{
			$('a#baseUrl').click(function() 
			{
				if($("#txtBomCode").val().trim()=="")
				{
					alert("Please Select Recipe Code");
					return false;
				}
				window.open('attachDoc.html?transName=frmBOMMaster.jsp&formName=Recipe Master&code='+$('#txtBomCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
		});
		
		
		/* function funUpdateConversionQty1(object)
		{			
			var index=object.parentNode.parentNode.rowIndex-2;
			var parentQty=$("#txtParentQty").val();
			var childQty=document.getElementById("txtQty."+index).value;
			document.getElementById("txtQtyConversion."+index).value=childQty/parentQty;
		}
		
		function funUpdateConversionQty()
		{
			var conversionQty=$("#txtQty").val()/$("#txtParentQty").val();
			$("#txtQtyConversion").val(conversionQty);
		} */
		
		function funGetImage(prodCode)
		{
			searchUrl=getContextPath()+"/getProdImage.html?prodCode="+prodCode;
			$("#itemImage").attr('src', searchUrl);
			
		}
		
		function funValidateFields() {
			if (!fun_isDate($("#txtFromDate").val())) {
				alert('Invalid Date');
				$("#txtFromDate").focus();
				return false;
			}
			if (!fun_isDate($("#txtToDate").val())) {
				alert('Invalid Date');
				$("#txtToDate").focus();
				return false;
			}

			var table = document.getElementById("tblChild");
			var rowCount = table.rows.length;
			if (rowCount == 0) {
				alert('Please Add Child Products');
				return false;
			}else {
				return true;
			}

		}
		$(function()
		{
			$('#txtChildCode').blur(function ()
			{
				var code=$("#txtChildCode").val();
				if (code.trim().length > 0 && code !="?" && code !="/")
				{					   
					funSetChild(code);
				}
			});
			$('#txtParentCode').blur(function ()
			{
				var code=$('#txtParentCode').val();			
				if (code.trim().length > 0 && code !="?" && code !="/")
				{
					
					funSetProduct(code);
				}
			});
		});
		
		
		function funApplyNumberValidation(){
			$(".numeric").numeric();
			$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
			$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
			$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
		    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit,negative: false});
		}
		
		function fillChildImage(imageCode){
			searchUrl=getContextPath()+"/getProdImage.html?prodCode="+imageCode;
			$('#childProdImages').append('<div class=\"mainMenuIcon\" id="'+imageCode+'"><img  src="'+searchUrl+'" width=\"100px\" height=\"100px\"/><div>');
		}
		
		function fillParentImage(imageCode){
			searchUrl=getContextPath()+"/getProdImage.html?prodCode="+imageCode;
			$('#itemImage').append('<div class=\"mainMenuIcon\" id="'+imageCode+'"><img  src="'+searchUrl+'" width=\"100%\" height=\"147px\"/><div>');
		}
		
		function setImages_ChildProd(){
			var table = document.getElementById("tblChild");
			var rowCount = table.rows.length;
			if(rowCount > 0)
	    	{
				$('#tblChild tr').each(function() 
					    {
							var imageCode=$(this).find('.id').val();
							fillChildImage(imageCode);
						});	
	    	}
		}
		
		$(function()
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
		
		function funRemoveProductRows()
		{
			var table = document.getElementById("tblChild");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		function funShowRecipeCost(code)
		{
			searchUrl=getContextPath()+"/loadRecipeCost.html?bomCode="+code;				
			$.ajax({				
	        	type: "GET",
		        url: searchUrl,
		        dataType: "json",
		        async:false,
		        success: function(response)
		        {				        	
		        	$("#lblRecipeCost").text(response);
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
</head>

<body id="bodyMain">
	<div class="container">
		<!-- <label>Recipe Master</label> -->
		<label id="lblFormName"></label>
	
		<s:form name="recipeForm" method="POST" action="saveRecipeMaster.html?saddr=${urlHits}">
		<input type="hidden" value="${urlHits}" name="saddr">
		
			<div class="row transTable" style="padding-bottom:20px">
				<div class="col-md-9">
					<div class="row">
						<div class="col-md-2">
					      	 <label id="lblRecipeCode" ></label>
					      	 <s:input id="txtBomCode" path="strBOMCode" readonly="true" ondblclick="funHelp('bomcode')" cssClass="searchTextBox"/>			        
					     </div>
					     <div class="col-md-2">
					      	 <label>Parent Product</label>
					         <s:input id="txtParentCode" required="true" path="strParentCode"  ondblclick="funHelp('productProduced')" cssClass="searchTextBox"/>
					     </div>
					     <div class="col-md-3">   
					          <s:input type="text" id="txtParentCodeName"  path="strParentName" readonly="true" style="margin-top: 28px;"/>
					      </div>
					       <div class="col-md-3"> 
						      <label>Type</label>
						 	  <s:input path="strType" id="txtType" readonly="true" class="Box"></s:input>
						   </div>
						     <div class="col-md-2"></div> 
					      <div class="col-md-2"> 
					   		  <label>POS Item Code</label>
						      <s:input id="txtPOSItemCode" path="strPOSItemCode" readonly="true"/>
						  </div>
						 
				    	   <div class="col-md-2"> 
						    	<label>Sub Group Code</label>	
						    	<s:input id="txtSGCode" path="strSGCode" readonly="true"  class="Box"/>	
						    </div>
						    <div class="col-md-3"> 
						    	<label>Name</label>	
						   		<s:input id="txtSGName" path="strSGName" readonly="true"  class="Box"/>	
							</div>
						  	<div class="col-md-3">
						  		<label>UOM</label>
						    	<s:input id="txtUOM" path="strUOM" readonly="true"  cssClass="Box"/>
							    <%-- <td><label>Quantity</label></td>
							    <td><s:input type="text"  class="decimal-places numberField" id="txtParentQty" path="dblQty" /></td> --%>
							</div>
							<div class="col-md-2"></div>
							<div class="col-md-2">
								<label>Date Valid From</label>	
						    	<s:input id="txtFromDate" required="true" name="txtDtFromDate" path="dtValidFrom" cssClass="calenderTextBox"/>
						    </div>	
						    <div class="col-md-2">
								<s:label path="dtValidTo">Date Valid To</s:label>	
						    	<s:input id="txtToDate" required="true" name="txtToDate" path="dtValidTo" cssClass="calenderTextBox" />					    
							</div>
							<div class="col-md-2">
								<label>Process</label>	
						    	<s:select id="cmbProcessName" path="strProcessName" items="${processList}" cssClass="BoxW124px"/>	
						   		<s:input type="hidden" id="txtProcessCode" path="strProcessCode"/>
						  	</div>	
							<div class="col-md-3">
								<label>Method</label>	
								<s:textarea cssStyle="width:100%; height: 27px;" id="txtMethod" path="strMethod" />
							</div>
							<div class="col-md-3">	
								<label>Recipe Cost</label>	
								<label id="lblRecipeCost"  style="background-color:#dcdada94; width: 100%; height: 51%;text-align: center;"></label>
							</div>
					</div>
				</div>
				<div class="col-md-3">
					<!-- <div style="background-color: #fbfafa; width:90%;margin-top: 10px; border: 1px solid black; height:auto;"><img id="itemImage" src="" width="134px" height="127px" alt="Item Image"  >
					</div> -->
					
					<div id="itemImage" style="width: 134px; height:157px;">
	
			</div>
				</div>
			</div>
			<div style="margin-bottom: 30px;min-height: 300px">
				<div style="width: 60%;height:300px; float: left;">
					<div id="tblChild1" class="transTableMiddle2">
						<div class="row">
							<div class="col-md-3">
								<label>Child Code</label>
								<input id="txtChildCode" ondblclick="funHelp('childcode')" class="searchTextBox" style="height: 25px;"></input>
							</div>
							<div class="col-md-3">
								<label id="lblItemName" style="background-color:#dcdada94; width: 100%; height: 51%;margin-top: 26px;text-align: center;"></label>
							</div>
							<div class="col-md-3">
								<label>Qty</label>
								<input id="txtQty" type="text" class="decimal-places numberField" ></input>
							</div>
							<div class="col-md-2">
								<label>UOM</label>
								<span id="lblUOM"></span>
							</div>
							<div class="col-md-2">
								<input id="btnAdd" type="button" value="Add" class="btn btn-primary center-block" onclick="return btnAdd_onclick();" style="margin-top:10px;"></input></td>
							</div>
						</div>
					</div>
			
					<div class="dynamicTableContainer"  style="width:100%;height: 235px">
						<table style="height:28px;border:#0F0;width:100%;font-size:11px;">
							<tr bgcolor="#c0c0c0" >
								<td width="9%">Child Code</td><!--  COl1   -->				
								<td width="35%">Name</td><!--  COl2   -->
								<td width="6%">Qty</td><!--  COl3   -->
								<td width="6%">UOM</td><!--  COl5   -->
								<td width="3%">Delete</td><!--  COl6   -->
							</tr>
						</table>
					<div style="background-color: #fbfafa;border: 1px solid #ccc; display: block; height: 190px;
					   	 margin: auto; overflow-x: hidden;  overflow-y: scroll; width: 100%;">
						<table id="tblChild" style="width:100%;border: #0F0;table-layout:fixed;overflow:scroll" class="transTablex col7-center">
						<tbody>    
							<col style="width:6%"><!--  COl1   -->		
							<col style="width:30%"><!--  COl2   -->
							<col style="width:6%"><!--  COl3   -->
							<col style="width:6%"><!--  COl4   -->
							<col style="width:4%"><!--  COl7   -->
						<c:forEach items="${command.listBomDtlModel}" var="recipe" varStatus="status">
							<tr>
								<td><input type="text" class="Box id" size="10%" name="listBomDtlModel[${status.index}].strChildCode" value="${recipe.strChildCode}" readonly="readonly"/></td>					
								<td><input class="Box" size="30%" name="listBomDtlModel[${status.index}].strProdName" value="${recipe.strProdName}" readonly="readonly"/></td>
								<td><input type="number" step="any" required="required" style="text-align: right;" class="inputText-Auto" name="listBomDtlModel[${status.index}].dblQty" value="${recipe.dblQty}"/></td>
								<td><input class="Box" size="6%" name="listBomDtlModel[${status.index}].strUOM" value="${recipe.strUOM}" readonly="readonly"/></td>
								<td><input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)"></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>				
			</div>	
		</div>
			<div id="childProdImages" style="width: 35%; height:300px; background-color: inherit; float: left;margin-left: 0px;overflow-x: hidden;     overflow-y: scroll; border-width: 1px; border-style: solid; border-color: #c3c5c7;">
	
			</div>
		</div>
		<div class="center" style="margin-right: 5%;">
		   <a href="#"><button class="btn btn-primary center-block" id="formsubmit"  value="Submit" onclick="return funValidateFields()">Submit</button></a>
		   <a href="#"><button class="btn btn-primary center-block" type="button"  value="Reset" onclick="funResetFields();">Reset</button></a>
		</div>
		<br><br>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
			<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
		</div>
</s:form>
</div>
<script type="text/javascript">
	setParrentImage();
	function setParrentImage(){
		if($("#txtParentCode").val().length >0){
			funGetImage($("#txtParentCode").val());	
		}
	}
	
	setImages_ChildProd();
</script>
	<script type="text/javascript">funApplyNumberValidation();</script>
</body>
</html>