<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title></title>
<style>
   .dynamicTableContainer {
      border:none;
      overflow-x:hidden;
   }
</style>
<script>

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
var clickCount =0.0;
function funCallFormAction(actionName,object) 
{
	if(clickCount==0){
		clickCount=clickCount+1;	
	if ($("#txtTransName").val()=="") 
	    {
		 alert('Enter Transport Name');
		 $("#txtTransName").focus();
		 return false;  
	   }
	}
	else
	{
		return false;
	}
	return true; 
}

function funHelp(transactionName)
{	     fieldName=  transactionName
 //   window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}
	function funSetData(code){

		switch(fieldName){

			case 'VehCode' : 
				funSetVehCode(code);
				break;
				
			case 'transCode' : 
				funSetTransCode(code);
				break;
		}
	}
	
	function funSetVehCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/LoadVehicleMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('Invalid Code' == response.strVehCode){
        			alert("Invalid Vehicle Code");
        			$("#txtVehCode").val('');
        			$("#txtVehCode").focus();
        		}else{
        			
        			$("#txtVehCode").val(response.strVehCode);
        			$("#lblVehNo").text(response.strVehNo);
        		
        		
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

	
	
	
	function funSetTransCode(code){
		
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/LoadTransporterMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('Invalid Code' == response.strVehCode){
        			alert("Invalid Vehicle Code");
        			$("#txtTransCode").val('');
        			$("#txtTransCode").focus();
        		}else{
        			
        			$("#txtTransCode").val(response.strTransCode);
        			$("#txtTransName").val(response.strTransName);
        			$("#txtDesc").val(response.strDesc);
        			$.each(response.listclsTransporterModelDtl, function(i,item)
	       	       	    	 {
	       	       	    	    funfillTransporterDataRow(response.listclsTransporterModelDtl[i]);
	       	       	    	 });
        		
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
	
	function funfillTransporterDataRow(data){
		
		var strVehCode=data.strVehCode;
		var vehNo=data.strVehNo;
		var table = document.getElementById("tblVehicleDtl");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);

	    row.insertCell(0).innerHTML= "<input name=\"listclsTransporterModelDtl["+(rowCount)+"].strVehCode\" readonly=\"readonly\" class=\"Box\" size=\"22%\" id=\"txtVehCode."+(rowCount)+"\" value='"+strVehCode+"'/>";
	    row.insertCell(1).innerHTML= "<input name=\"listclsTransporterModelDtl["+(rowCount)+"].strVehNo\" readonly=\"readonly\" class=\"Box\" style=\"margin-left: 40px;\" size=\"40%\" id=\"lblVehNo."+(rowCount)+"\" value='"+vehNo+"'/>";
	    row.insertCell(2).innerHTML= '<input  class="deletebutton" value = "Delete" style=\"margin-left: 145px;\" onClick="Javacsript:funDeleteRow(this)">';
	
	}
	
	
    function funSaveTrasnporter(){
    
    	var transCode=$("#txtTransCode").val();
    	var transName=$("#txtTransName").val();
    	var desc= $("#txtDesc").val();
    	$.ajax({
			type : "GET",
			url : getContextPath()+ "/saveTransporter.html?transName="+transName+"&desc="+desc+"&transCode="+transCode,
			dataType : "json",
			success : function(response){ 
				alert(response.strTransCode);
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
    	
    return false;
    }
    
    function btnAdd_onclick()
    {

    	var table = document.getElementById("tblVehicleDtl");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
    	var strVehCode=$("#txtVehCode").val();
    	var vehNo=$("#lblVehNo").text();

     	//if(funDuplicateVehicle(strVehCode))
   		// {
	    row.insertCell(0).innerHTML= "<input name=\"listclsTransporterModelDtl["+(rowCount)+"].strVehCode\" readonly=\"readonly\" class=\"Box\" size=\"22%\" id=\"txtVehCode."+(rowCount)+"\" value='"+strVehCode+"'/>";
	    row.insertCell(1).innerHTML= "<input name=\"listclsTransporterModelDtl["+(rowCount)+"].strVehNo\" readonly=\"readonly\" class=\"Box\" style=\"margin-left: 40px;\" size=\"40%\" id=\"lblVehNo."+(rowCount)+"\" value='"+vehNo+"'/>";
	    row.insertCell(2).innerHTML= '<input  class="deletebutton" value = "Delete" style=\"margin-left: 145px;\" onClick="Javacsript:funDeleteRow(this)">';
    	//}
     	
	    funResetDetailFields();
	   return false;
    }

    
    function funResetDetailFields()
    {
    	$("#txtVehCode").val('');
    	$("#lblVehNo").text('');
    }
    
    
    function funDeleteRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblVehicleDtl");
	    table.deleteRow(index);
	}
    

	function funDuplicateVehicle(strVehCode)
	{
	    var table = document.getElementById("tblVehicleDtl");
	    var rowCount = table.rows.length;		   
	    var flag=true;
	    if(rowCount > 0)
	    	{
			    $('#tblVehicleDtl tr').each(function()
			    {
				    if(strVehCode==$(this).find('input').val())// `this` is TR DOM element
    				{
				    	alert("Already added "+ strVehCode);
	    				flag=false;
    				}
				});
			    
	    	}
	}
	
	function funResetFields()
	{
		$("#txtTransCode").focus();
    }
</script>
</head>
<body>
  <div class="container">
	<label id="formHeading">TransPorter Master</label>
	<s:form name="TransPorter Master" method="GET" action="saveTransporterVehicle.html?saddr=${urlHits}">

	<input type="hidden" value="${urlHits}" name="saddr">
		<div class="row masterTable">
		 	<div class="col-md-2">
			 	<label>Transporter Code</label>
				<s:input  type="text" id="txtTransCode" path="strTransCode" cssClass="searchTextBox" ondblclick="funHelp('transCode');" readOnly="true"/>	
			</div>	
			<div class="col-md-2">
				<label>Transporter Name</label>
				<s:input  type="text" id="txtTransName" path="strTransName" />
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input type="text" id="txtDesc" path="strDesc"/>
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">	
				<label>Vehicle Code</label>
				<s:input  type="text" id="txtVehCode" path="strVehCode" cssClass="searchTextBox" ondblclick="funHelp('VehCode');" readOnly="true"/>
			</div>
			<div class="col-md-2">	
				<label id ="lblVehNo" style="background-color:#dcdada94; width: 100%; height: 30px; margin-top: 26px; text-align: center;"></label>
			</div>
			
			<div class="col-md-3">
				<a href="#"><button class="btn btn-primary center-block"  value="Create" onclick="return funSaveTrasnporter()"
				>Create</button></a>&nbsp;
				<a href="#"><button class="btn btn-primary center-block"  value="Add" onclick="return btnAdd_onclick()"
				>Add</button></a>
			</div>
		</div>		
		<div class="dynamicTableContainer" style="width: 80%;">
			<table style="height: 28px; border: #0F0; width: 70%;font-size:11px; font-weight: bold;">
					 <tr style="background-color:#c0c0c0;">
                        <td align="left" style="width: 30%; height: 30px;"> Vehicle Code</td>
                        <td align="left" style="width: 40%; height: 30px;"> Vehicle No.</td>    
                        <td align="left" style="width: 16%; height: 30px;"> Delete</td>
                      </tr>
             </table>
                 <div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px;overflow-x: hidden; overflow-y: scroll; width: 70%;">
					<table id="tblVehicleDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					        class="transTablex col8-center">
                        <tbody>
                        	<col align="left" style="width: 10%">   
                            <col align="left" style="width: 18%">                            
                            <col align="left" style="width: 16%">                            
                        </tbody>
                    </table>
                </div>
		 </div>

		<div class="center" style="margin-right: 44%;">
				<a href="#"><button class="btn btn-primary center-block"  value="Submit" onclick="return funCallFormAction('submit',this);"
				>Submit</button></a>&nbsp;
				<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()"
				>reset</button></a>
		</div>
		
	</s:form>
   </div>
</body>
</html>