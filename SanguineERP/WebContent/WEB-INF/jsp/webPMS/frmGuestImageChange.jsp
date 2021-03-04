<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Excel Import Export</title>
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
 var dtPhydate='';
 var supplierCode='';
 var strGCode="";  
 var strSGCode="";
 var glboalcode;
 
 $(document).ready(function() 
 		{
		 var tablename='';
			$('#searchGrp').keyup(function()
			{
				tablename='#tblGroup';
				searchTable($(this).val(),tablename);
			});
			$('#searchSGrp').keyup(function()
	 			{
						tablename='#tblSubGroup';
	 				searchTable($(this).val(),tablename);
	 			});
 			$(document).ajaxStart(function()
 		 	{
 			    $("#wait").css("display","block");
 		  	});
 			$(document).ajaxComplete(function(){
 			    $("#wait").css("display","none");
 			  });
 			funGetGroupData();
 			
 			
 			
 			
 			
 			
			
 			
 		});
 
 <%-- 
 
 $(document).ready(function(){	 
	 var message='a';
	
		<%if (session.getAttribute("code") != null) {
			            if(session.getAttribute("code") != null){%>
			            message='<%=session.getAttribute("code").toString()%>';
			            <%
			            session.removeAttribute("code");
			            }
						boolean test = ((Boolean) session.getAttribute("code")).booleanValue();
						session.removeAttribute("code");
						if (test) {
						%>	
			alert("Data Save successfully\n\n"+message);
		<%
		}}%>

	}); --%>
 
	 
	 
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
			var jForm = new FormData();    
		    jForm.append("file", $('#File').get(0).files[0]);
		 //  searchUrl=getContextPath()+"/ChangeGuestImage.html?formname="+transactionformName+"&prodStock="+prodStock;
			searchUrl=getContextPath()+"/ChangeGuestImage.html?";				
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
	
    //Get Transaction from to which Link is Click and Location Code
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    }
	
	
	 function funShowImagePreview(input)
	 {
		 if (input.files && input.files[0])
		 {
			 var filerdr = new FileReader();
			 filerdr.onload = function(e) 
			 {
			 	$('#memImage').attr('src', e.target.result);
			 }
			 filerdr.readAsDataURL(input.files[0]);
			// uploadNeWImage();
		 }
	 } 
	 
	 function showPopup(code) {
		 glboalcode=code;
		 $.ajax({
				type : "GET",
				  url: getContextPath()+ "/getInformation.html?code=" +glboalcode,
				  dataType : "json",
				  async:false,
				  success: function(response) {
				    /* 
					  $("#txtGuestName").text(response[0]);
					  $("#txtCheckInDate").text(response[1]);
					  $("#txtNumber").text(response[2]);
					  $("#txtFolioNo").text(response[3]);
					  $("#txtRoomNo").text(response[4]);
					  $("#txtOneDayTariff").text(response[5]);
					  $("#txtTaxAmt").text(response[6]);
					  $("#txtNoOfNights").text(response[7]);
					  $("#txtHighSeasonFee").text(0);
					  $("#txtCleaningFee").text(0); 
					  var total = (response[5]*response[7])+response[6]
					  $("#txtTotal").text(total); */
					  funloadMemberPhoto(response[9])
				    
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
		 
		// document.getElementById('popover').style.cssText = 'display: block';
	      
	      }
	 
	 
	 
	 
	 
	 
	 
					 
</script>
</head>
<!-- <body onload="funOnLoad();"> -->

<s:form name="uploadExcel" id="uploadExcel" method="POST" action="ExcelExportImport.html" enctype="multipart/form-data" >
<br>
<br>
	<table>
	   <tbody>
		    <tr>
			    <td class="content" bgcolor="#a6d1f6">Attach Image</td>
			    <!-- <td><input type="button" id="btnExport" value="Export" class="form_button1" onclick="funExport();"/></td> -->
		    </tr>
		    <tr>
		    	<td><input type="file" id="File"  Width="50%" accept="image/gif,image/png,image/jpeg"  onchange="funShowImagePreview(this);"></input></td>    
		    		<img id="memImage" src="" width="170px" height="150px" alt="Member Image" onclick="funChangeImage()">
            
		    </tr>
		</tbody>
	</table>
	<br>
    <p align="center">
			<input id="btnSubmit" type="button" class="form_button" value="Submit" onclick="return funSubmit();"/>
			&nbsp; &nbsp; &nbsp;
			 <input id="btnReset" type="reset" value="Reset" class="form_button" onclick="funResetField()" />
	</p>
	
</s:form>
</body>
</html>