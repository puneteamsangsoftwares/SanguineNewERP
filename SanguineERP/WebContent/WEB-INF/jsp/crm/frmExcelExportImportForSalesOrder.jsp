<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
        <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

 <script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Excel Import Export</title>

<style>
.masterTable td {
       padding-left: 28px;
      }
</style>
<script type="text/javascript">
//Press ESC button to Close Form
	window.onkeyup = function (event) {
		if (event.keyCode == 27) {
			window.close ();
		}
	}
</script>
<script type="text/javascript">
 var transactionformName="";
 var LocCode="";
 
    //Get Project Path
	function getContextPath() 
	{
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
    
	$(document).ready(function(){
		  $(document).ajaxStart(function(){
		    $("#wait").css("display","block");
		  });
		  $(document).ajaxComplete(function(){
		    $("#wait").css("display","none");
		  });
		  
		  funGetAllSubGroupData();
		  
		  $("#chkSGALL").click(function ()
					{
					    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
					});
		  
		  
		});

    //Check From to where Link Click to Open
	function funExport()
	{
    	var strSubGroupCode='';
    	
		$('input[name="SubGroupthemes"]:checked').each(function() {
			 if(strSubGroupCode.length>0)
				 {
				 	strSubGroupCode=strSubGroupCode+","+this.value;
				 }
				 else
				 {
					 strSubGroupCode=this.value;
				 }
			 
			});
    	
		
		window.location.href=getContextPath()+"/funSalesOrderProductExport.html?strSubGroupCode="+strSubGroupCode;
			
	}

    //Check File is Excel or another format
	function funValidateFile() 
	{	
		var value=$("#File").val();
		var Extension=value.split(".");
		var ext=Extension[1];
		if(ext=="xls" || ext =="xlsx" )
			{
			 return true;
			}
		else
		{
			alert("Invalid File");
			return false;
			
		}
	}

    //After Submit Button
	function funSubmit()
	{
		if(funValidateFile())
			{
				var jForm = new FormData();    
			    jForm.append("file", $('#File').get(0).files[0]);
			    searchUrl=getContextPath()+"/ExcelExportImportSales.html?formname=frmSalesOrder";	
		        $.ajax({
		           // url : $("#uploadExcel").attr('action'),
		            url : searchUrl,
		            type: "POST",
	                data: jForm,
	                mimeType: "multipart/form-data",
	                contentType: false,
	                cache: false,
	                processData: false,
	                dataType: "json",
		            success : function(response) 
		            {
		            	if(response[0]=="Invalid Excel File")
		            		{
		            			alert(response[1]);
		            		}
		            	else
		            		{
								window.returnValue = response;
								window.close();
		            		}
		            },
		            error: function(jqXHR, exception)
					{
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
    
	function funfillSubGroup(strSGCode,strSGName) 
	{
		var table = document.getElementById("tblSubGroup");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
	}
	
	function funGetAllSubGroupData()
	{
		var searchUrl = getContextPath() + "/AllloadSubGroup.html";
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				beforeSend : function(){
					 $("#wait").css("display","block");
			    },
			    complete: function(){
			    	 $("#wait").css("display","none");
			    },
				success : function(response)
				{
					$.each(response, function(i, value) {
						
						funfillSubGroup(value.strSGCode,value.strSGName);
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
	
</script>
</head>
<body onload="funOnLoad();" >
<div class="container">
<s:form name="uploadExcel" id="uploadExcel" method="POST" action="ExcelExportImportSales.html" enctype="multipart/form-data" >
<br>
<br>
	 <div class="row">
	
		    <div class="col-md-2"  id="formHeading" class="content" bgcolor="#a6d1f6">Export Excel File
			      <input type="button" id="btnExport" value="Export" class="btn btn-primary center-block" class="form_button1" onclick="funExport();"/>
		    </div>
		    
		    <div class="col-md-2">
		    	  <input type="file" id="File"  Width="50%" accept="application/vnd.ms-excel"></input>   
		    </div>
	
	  </div>  
	  <br>
	    <div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 200px; width:80%;overflow-x: hidden; overflow-y: scroll;">

							<table id="" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<tr bgcolor="#c0c0c0">
										<td width="5%"><input type="checkbox" id="chkSGALL"
											checked="checked" onclick="funCheckUncheckSubGroup()" />Select</td>
										<td width="20%">Sub Group Code</td>
										<td width="80%">Sub Group Name</td>

									</tr>
								</tbody>
							</table>
							<table id="tblSubGroup" class="masterTable"
								style="width: 50%; border-collapse: separate;">
								<tbody>
								<!-- 	<tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr> -->
								</tbody>
							</table>
			</div>
	    
	   
	<br>
    <p align="center" style="margin-right: 12%;">
			<input id="btnSubmit" type="button" class="btn btn-primary center-block" class="form_button" value="Submit" onclick="return funSubmit();"/>
			&nbsp; 
			 <input id="btnReset" type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetField()" />
	</p>
</s:form>
</div>
</body>
</html>