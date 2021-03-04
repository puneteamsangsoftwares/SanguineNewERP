 <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
	<script type="text/javascript"
		src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript"
		src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>
	<link rel="stylesheet" type="text/css" media="screen"
		href="<spring:url value="/resources/css/design.css"/>" />

<title>Email</title>
<style type="text/css">
	.container{
	margin:auto;
	}
	

	
</style>

<script type="text/javascript">
//From Close after Pressing ESC Button
	window.onkeyup = function (event) {
		if (event.keyCode == 27) {
			window.close ();
		}
	}
</script>
<script type="text/javascript">
	var fieldName="";
	$(document).ready(function(){
		  $(document).ajaxStart(function(){
		    $("#wait").css("display","block");
		  });
		  $(document).ajaxComplete(function(){
		    $("#wait").css("display","none");
		  });
		 
		});
	 
	function funOnLoad()
	{
		 var strPOCode='<%=request.getParameter("POCode") %>' 
			  $("#txtPOCode").val(strPOCode);
	}
	/**
	 * Open help windows
	 */
	function funHelp(transactionName)
	{
		fieldName = transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
		
	}
	function funSetData(code)
	{
		switch (fieldName)
		{
		    case 'purchaseorder':
		    	$("#txtPOCode").val(code);
		        break;
		}
	}


	//Sending Email With Validation After Clicking Submit Button
	function btnSubmit_onClick() 
	{
		if($("#txtPOCode").val().trim().length==0)
			{
				alert("Please Enter PO Code or Search");
				$("#txtPOCode").focus();
				return false;
			}
		else
			{
				funSendEmail();
			}
	}
	function funSendEmail()
	{
		var form = $('#frmEmail');
	    var code=$("#txtPOCode").val();
		var subject=$("#txtsubject").val();
		var message=$("#txtmessage").val();
		var form = $('#frmEmail');
		var searchUrl = "";
		searchUrl = getContextPath()+ "/sendPOEmail.html?strPOCode=" + code+"&strSubject=" + subject+"&strMessage="+message;
		$.ajax({
			type : "GET",
			url : searchUrl,
	            async: false,
			    context: document.body,
			    dataType: "text", 
			    success: function(response)
		        {
		        	alert(response);
		        	window.close();
				},
			   
		/* var form = $('#frmEmail');
		$.ajax({
				type: "GET",
			    url: $("#frmEmailSending").attr("action"),
			    data:$("#frmEmailSending").serialize(),
			    async: false,
			    context: document.body,
			    dataType: "text",
		        success: function(response)
		        {
		        	alert(response);
		        	window.close();
				}, */
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
	function btnClose_onClick()
	{
		window.close();
	}
	
	function getContextPath() 
	{
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
	
</script>
</head>
<body onload="funOnLoad();">
	<div class="container">
		<label id="formHeading">Send E-mail</label>
		<form method="GET" name="frmEmailSending" id="frmEmailSending" action="sendPOEmail.html" >
		 <div class="row transTable">
                <div class="col-md-2">
                    <label>PO Code</label>
					<input name="strPOCode" id="txtPOCode" ondblclick="funHelp('purchaseorder')"
						Class="searchTextBox"></input>
				</div>
				<div class="col-md-2">	
               		<label>Subject:</label>
                   <input type="text" name="subject" id="txtsubject" size="65"/>
               </div>
               <div class="col-md-8"></div>
               <div class="col-md-2">
              		<label>Message:</label>
                   <textarea cols="50" rows="10" name="message"></textarea>
               </div>
             </div>
               <!--  <tr>
                    <td>Attach file:</td>
                    <td><input type="file" name="attachFile" size="60" /></td>
                </tr>   -->          
               	
         <div class="center" style="margin-right:68%;">
			<a href="#"><button class="btn btn-primary center-block" value="Send" onclick="return btnSubmit_onClick() ">Send</button></a>
			&nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Close" onclick="btnClose_onClick() ">Close</button></a>
		</div>       
          
        </form>
     </div>
</body>
</html>