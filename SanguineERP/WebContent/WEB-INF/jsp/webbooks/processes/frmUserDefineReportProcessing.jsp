<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
	<script>
	
	
			$(function(){
					var startDate="${startDate}";
					var arr = startDate.split("/");
					Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
					$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtFromDate" ).datepicker('setDate', Dat);
					$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtToDate").datepicker('setDate', 'today');
					var glCode = $("#txtGLCode").val();
					
					$('#txtReportCode').blur(function() {
						var code = $('#txtReportCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetReportName(code);
						}
					});
					
					});
			
	
	function funSetData(code)
	{
		switch (fieldName) 
		{
		   case 'userDefinedReportCode':
			   funSetReportName(code);
		        break;
		        
		}
	}
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
	
	
	function funSetReportName(code)
	{
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadUserDefinedReportMasterData.html?userDefinedCode=" + code,
			dataType : "json",
			success : function(response)
			{
				if(response.strReportId=="Invalid Code")
				{
				alert("Invlid Report Id");
				$("#txtReportCode").val("");
				$("#lblUserName").text("");
				}
				else
				{	
				$("#txtReportCode").val(response.strReportId);
				$("#lblUserName").text(response.strReportName);
				}
			},
			error : function(e){
			}
		});
	}
	
	
	
	function funValidate()
	{		
		if($("#txtReportCode").val().trim().length<1)
		{
			alert("Please Select Report ID.");
			$("#txtReportCode").focus();
			return false;
		}				
	}
	
	
	
	</script>
</head>
	<body>
	<div class="container masterTable">
		<label id="formHeading">User Defined Report Master</label>
		<s:form id="frmUserDefinedReportProcess" method="POST" action="getUserDefinedReportProcess.html?saddr=${urlHits}">
			
		    <div class="row">
			    <div class="col-md-2"><label>Report ID</label>
			            <s:input id="txtReportCode" path="strReportId" style="height:42%" readonly="true" ondblclick="funHelp('userDefinedReportCode');" class="searchTextBox"/>
			            <label id="lblUserName"></label>			    			    			    		    
			    </div>
			    <div class="col-md-10"></div>
			    
			    <div class="col-md-3">
					   <div class="row">
			   				<div class="col-md-6"><label>From Date</label>
				        		<s:input colspan="3" type="text" id="txtFromDate" style="height:50%" path="dteFDate" cssClass="calenderTextBox" />
							</div>
						<div class="col-md-6"><label>To Date</label>
				         	<s:input type="text" id="txtToDate" path="dteTDate" style="height:50%" cssClass="calenderTextBox" />
						</div>
		    </div></div>
		    </div>
		    <br>
			<p align="right" style="margin-right:77%;">
			   <input id="btnSubmit" type="submit" value="Execute" class="btn btn-primary center-block" class="form_button" onclick="return funValidate()"/>
			</p>
			</s:form>
		</div>
</body>
</html>