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

<style type="text/css">
.transTable td {
	border-style: none;
	padding-left: 0px;
}
</style>
<script type="text/javascript">

	   $(document).ready(function() 
		{
		   
		   
// 		   resetForms('stkAdjustment');
// 		   $("#txtProdCode").focus();	
// 		   $(document).ajaxStart(function(){
// 			    $("#wait").css("display","block");
// 			  });
// 			  $(document).ajaxComplete(function(){
// 			    $("#wait").css("display","none");
// 			  });
			  
			$("#txtFulmtDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFulmtDate" ).datepicker('setDate', 'today');
			$("#txtFulmtDate").datepicker();
			
			
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


/**
 * Open help windows
 */
function funHelp(transactionName)
{
	fieldName=transactionName;
	
		
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
}
	
	/**
	 * Set Data after selecting form Help windows
	 */
	function funSetData(code)
	{
		switch (fieldName) 
		{
		    case 'productProduced':
		    	funSetProduct(code);
		        break;
		        
		    
		}
	}
	
	
	$(function()
	{
		$('#txtProdCode').blur(function() {
			var code = $('#txtProdCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetProduct(code);
			}
		});
	});
	
	/**
	 * Set Product Data after selecting form Help windows
	 */
	function funSetProduct(code)
	{
		//var qty=funGetProductStock(code);
		//alert("Stock="+qty);
		var searchUrl="";
		
		searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
		//alert(searchUrl);
		$.ajax
		({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
		    	if('Invalid Code' == response.strProdCode){
		    		alert('Invalid Product Code');
		    		$("#txtProdCode").val('');
			    	$("#lblProdName").text('');
			    	$("#txtProdCode").focus();
		    	}else{
		    		var dblStock=funGetProductStock(response.strProdCode);
		    	$("#txtProdCode").val(response.strProdCode);
	        	document.getElementById("lblProdName").innerHTML=response.strProdName;
	        	$("#txtStock").val(dblStock);
	            
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
	 * Get product stock 
	 */
	function funGetProductStock(strProdCode)
	{
		var searchUrl="";	
		var locCode=$("#hidLocCode").val();
		
		var dblStock="0";
		searchUrl=getContextPath()+"/getProductStock.html?prodCode="+strProdCode+"&locCode="+locCode;	
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
 		//alert("dblStock\t"+dblStock);
		return dblStock;
	}


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
	    				flag=false;
    				}
				});
			    
	    	}
	    return flag;
	}
	
	function btnAdd_onclick()
	{
		
		if($("#txtProdCode").val().length<=0)
			{
				$("#txtProdCode").focus();
				alert("Please Enter Product Code Or Search");
				return false;
			}		
		
	    else
	    	{
	    	var strProdCode=$("#txtProdCode").val();
	    	 if(funDuplicateProduct(strProdCode))
	    		 {
	    		 
	    		 funAddRow(strProdCode);
	    		 }
	    	}
	}
	
	
	
	function funAddRow(code){
		var date=$("#txtFulmtDate").val();
		
		var searchUrl = "";
		searchUrl = getContextPath()
				+ "/loadProductVarianceData.html?strProdCode=" + code+"&date="+date;

		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				if('Invalid Code' == response.strSOCode){
        			alert("Invalid Customer Code");
        			$("#txtSOCode").val('');
        			$("#txtSOCode").focus();
        			
        		}else{	
					funInsertProdQtyInGrid(response);
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

	
	
	
	
	function funInsertProdQtyInGrid(data)
	{
		var table = document.getElementById("tblProdDet");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	  
	    var strSOCode=data.strSOCode;
	    var strProdCode=data.strProdCode;
	    var strCustCode=data.strCustCode;
	    var strCustNmae=data.strCustNmae;
	    var dblQty=data.dblQty;
	    var dblAcceptQty=data.dblAcceptQty;
		
	   
	    row.insertCell(0).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].strSOCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"strSOCode."+(rowCount)+"\" value='"+strSOCode+"' />";		  		   	  
	    row.insertCell(1).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strProdCode."+(rowCount)+"\" value='"+strProdCode+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].strCustCode\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strCustCode."+(rowCount)+"\" value='"+strCustCode+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].strCustNmae\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\" class=\"decimal-places inputText-Auto\" id=\"strCustNmae."+(rowCount)+"\" value="+strCustNmae+" >";
	    row.insertCell(4).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].dblQty\" type=\"text\" class=\"Box\" required = \"required\" style=\"text-align: right;width:99%; border:1px solid #c0c0c0;\" class=\"decimal-places inputText-Auto\" id=\"dblQty."+(rowCount)+"\" value="+dblQty+" >";
	    row.insertCell(5).innerHTML= "<input name=\"listSODtl["+(rowCount)+"].dblAcceptQty\"  class=\"Box\" style=\"text-align:right;width:99%;\"  class=\"decimal-places inputText-Auto\"  id=\"dblAcceptQty."+(rowCount)+"\"   value='"+dblAcceptQty+"'/>";
	    row.insertCell(6).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
	    		    
	    
	}
	
	function funDeleteRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblProdDet");
	    table.deleteRow(index);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

// function funInsertProdQtyInGrid(data)
// {	
	
//     if (data != null) {
// 		var table = document.getElementById("tblProdDet");
// 		var rowCount = table.rows.length;
// 		var row, rowData;
		
// 		for (var j = 0; j < data.length; j++) {
// 			row = table.insertRow(rowCount);
// 			rowData = data[j]
			
// 			for (var i = 0; i < rowData.length; i++) {
    
// 		    if (i == 0) {
// 				row.insertCell(i).innerHTML= "<input class=\"Box\"  name=\"listSODtl\" value="+rowData[i]+">";
				
// 			} else if (i == 1) {
// 				row.insertCell(i).innerHTML= "<input class=\"Box\"  name=\"listSODtl\" value="+rowData[i]+">";
				
// 			} else if (i == 2) {
// 				row.insertCell(i).innerHTML =  "<input class=\"Box\"  name=\"listSODtl\" value="+rowData[i]+">";
				
// 			} else if(i == 3) {
// 				row.insertCell(i).innerHTML ="<input class=\"Box\"  name=\"listSODtl\" value="+rowData[i]+">";
// 			}else{
// 				row.insertCell(i).innerHTML = "<input class=\"Box\"  name=\"listSODtl\" value="+rowData[i]+">";
// 			}

// 			}
// 			rowCount++;
// 	  }
// 	}
// }
</script>

<body>

<div class="container transTable" >
	<label id="formHeading">Invoice Product Variance</label>
	   <s:form name="frmInvoiceVariance" method="GET" action="saveInvoiceVariance.html?saddr=${urlHits}">
<div class="row">
		
				<div class="col-md-2"><label> Product Code </label>
					   <input id="txtProdCode" ondblclick="funHelp('productProduced')" class="searchTextBox" ></input>
			    </div>
				
				
				<div class="col-md-2"><label> Product Name </label>
					   <label id="lblProdName" class="namelabel" style="background-color:#dcdada94; width: 110%; height: 50%;"></label>
			    </div>
				
				<div class="col-md-2"><label> Stock </label>
					   <input id="txtStock" readonly="readonly" class="right-Align" style="width: 80%;" type="text" ></input>
				</div>
			    <div class="col-md-6"></div>
			    
				<div class="col-md-2"><label>FulmtDate</label>
				       <s:input path="dteFulmtDate" id="txtFulmtDate" required="required" cssClass="calenderTextBox" style="width:80%;"/>
				</div>
				
				<div class="col-md-2"><br><input type="button" value="Show" class="btn btn-primary center-block" class="smallButton" onclick="return btnAdd_onclick()"/>
				</div>
	           
	            <br>
				<div class="dynamicTableContainer" style="height: 290px; width: 80%;">
						<table style="height: 20px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
									<tr bgcolor="#c0c0c0">
										<td width="6%">Sales Order Code</td>
										<!--  COl1   -->
										<td width="6%">Product Code</td>
										<!--  COl2   -->
										<td width="8.5%">Customer Code</td>
										<!--  COl3   -->
										<td width="9%">Customer Name</td>
										<!--  COl4   -->
										<td width="3%">Order Qty</td>
										<!--  COl5   -->
										<td width="3%">Accept Qty</td>
										<!--  COl6   -->
										<td width="2%">Delete</td>
										<!--  COl7   -->
										
									</tr>
								</table>
								<div
									style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
									<table id="tblProdDet"
										style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col15-center">
										<tbody>
										<col style="width: 5%">
										<!--  COl1   -->
										<col style="width: 5%">
										<!--  COl2   -->
										<col style="width: 7%">
										<!--  COl3   -->
										<col style="width: 8%">
										<!--  COl4   -->
										<col style="width: 3%">
										<!--  COl5   -->
										<col style="width: 3%">
										<!--  COl6   -->
										<col style="width:2%">
										<!--  COl7   -->
									</tbody>
                                   </table>
								</div>

							</div>
				</div>
		<br>
        <p align="center">
			<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" /> 
			&nbsp;  
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>	
			
		   <input type="hidden" id="hidLocCode" name="strLocCode" value="${locationCode}"></input>
			
		</s:form>
	   </div>
</body>
</html>