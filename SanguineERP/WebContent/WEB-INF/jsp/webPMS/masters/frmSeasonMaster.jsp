<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Season Master</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
   
<script type="text/javascript">


$(document).ready(function(){
	
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
	
	$("#txtFromDate").datepicker({
		dateFormat : 'dd-mm-yy'
	});
	$("#txtFromDate").datepicker('setDate', pmsDate);

	$("#txtToDate").datepicker({
		dateFormat : 'dd-mm-yy'
	});
	$("#txtToDate").datepicker('setDate', pmsDate);
	
	
	
});

		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	  
			window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		    //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		
		

		/**
		*   Attached document Link
		**/
		$(function()
		{
		
			$('a#baseUrl').click(function() 
			{
				if($("#txtBathTypeCode").val().trim()=="")
				{
					alert("Please Select BathType Code");
					return false;
				}
			   window.open('attachDoc.html?transName=frmBathTypeMaster.jsp&formName=BathType Master&code='+$('#txtBathTypeCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			/**
			* On Blur Event on BathType Code Textfield
			**/
			$('#txtBathTypeCode').blur(function() 
			{
					var code = $('#txtBathTypeCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/")
					{				
						funSetData(code);						
					}
			});
			
			$('#txtBathTypeDesc').blur(function () {
				 var strBathTypeDesc=$('#txtBathTypeDesc').val();
			      var st = strBathTypeDesc.replace(/\s{2,}/g, ' ');
			      $('#txtBathTypeDesc').val(st);
				});
			
		});
		
	
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(BathType Code)
		**/
		
		function funSetData(code)
		{
			$("#txtBathTypeCode").val(code);
			var searchurl=getContextPath()+"/loadSeasonMasterData.html?SeasonCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strBathTypeCode=='Invalid Code')
				        	{
				        		alert("Invalid Bath Code");
				        		$("#txtSeasonCode").val('');
				        	}
				        	else
				        	{
				        		 var FromDate1=response.dteFromDate;
					        		var FromDate= FromDate1.split(' ');
					        	    var FDate = FromDate[0];
					        	    var toDate2=response.dteToDate;
					        		var toDate= toDate2.split(' ');
					        	    var tDate = toDate[0];
					        	$("#txtSeasonDesc").val(response.strSeasonDesc);
					        	$("#txtSeasonCode").val(response.strSeasonCode);
					        	$("#txtFromDate").val(FDate);
					        	$("#txtToDate").val(tDate);
					     
					        	
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
		* Success Message After Saving Record
		**/
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
		
			/**
			 *  Check Validation Before Saving Record
			 **/
					function funCallFormAction(actionName,object) 
					{
						var flg=true;
						if($('#txtSeasonDesc').val()=='')
						{
							 alert('Enter Season Name ');
							 flg=false;
							  
						}
						return flg;
					}
			
			//set Date value
			
		function funSetDate(id,responseValue)
		{
		var id=id;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);
		
	}
			
		
</script>
</head>
<body>
    <div class="container masterTable">
           
		<label id="formHeading">Season Master</label>
	<s:form name="Season" method="POST" action="saveSeasonMaster.html?" >
	
		  <div class="row">
				<!-- <th align="right" colspan="2"><a id="baseUrl"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;</th> -->
			<div class="col-md-5">
		   		<div class="row">
					<div class="col-md-5"><label>Season Code </label>
						<s:input id="txtSeasonCode" readonly="true" path="strSeasonCode" cssClass="searchTextBox" ondblclick="funHelp('Season')" style="height:45%"/>			
					</div>
					<div class="col-md-7"><label>Season Desc</label>
						<s:input id="txtSeasonDesc" path="strSeasonDesc"/>			
					</div>
					<div class="col-md-5"><label>From Date</label>
					 <s:input type="text" id="txtFromDate" path="dteFromDate" style="width: 70%;" cssClass="calenderTextBox" />
					</div>
			
					<div class="col-md-4"><label>To Date</label>
					<s:input type="text" id="txtToDate" path="dteToDate" style="width: 70%;" cssClass="calenderTextBox" />
					</div>
					 
				</div>
				
			</div>
		</div>
		<br />
		<p align="center" style="margin-right: 31%;">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);"  />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
        </p>
	</s:form>
	</div>
</body>
</html>
