<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Room Master</title>
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<script type="text/javascript">

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
				if($("#txtRoomTypeCode").val().trim()=="")
				{
					alert("Please Select RoomType Code");
					return false;
				}
			   window.open('attachDoc.html?transName=frmRoomTypeMaster.jsp&formName=RoomType Master&code='+$('#txtRoomTypeCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			
			/**
			* On Blur Event on RoomType Code Textfield
			**/
			$('#txtRoomTypeCode').blur(function() 
			{
					var code = $('#txtRoomTypeCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/")
					{				
						funSetData(code);						
					}
			});
			
			$('#txtRoomTypeDesc').blur(function () {
				 var strRoomTypeDesc=$('#txtRoomTypeDesc').val();
				 var st = strRoomTypeDesc.replace(/\s{2,}/g, ' ');
			      $('#txtRoomTypeDesc').val(st);
				});
			
		});
		
	
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Room Master Code)
		**/
		
		function funSetData(code)
		{
			$("#txtRoomTypeCode").val(code);
			var searchurl=getContextPath()+"/loadRoomTypeMasterData.html?roomCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strRoomTypeCode=='Invalid Code')
				        	{
				        		alert("Invalid RoomType Code");
				        		$("#txtRoomTypeCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtRoomTypeDesc").val(response.strRoomTypeDesc);
					        	$("#txtRoomTerrif").val(response.dblRoomTerrif);
					        	$("#txtDoubleTarrif").val(response.dblDoubleTariff);
					        	$("#txtTrippleTarrif").val(response.dblTrippleTariff);
					        	$("#txtHsnSac").val(response.strHsnSac);
					        	$("#txtGuestCapcity").val(response.strGuestCapcity);
					        	
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
						if($('#txtRoomTypeDesc').val()=='')
						{
							 alert('Enter RoomType Name ');
							 flg=false;
							  
						}
					
						return flg;
					}	
		 
					 function isNumber(evt) {
					        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
					        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
					            return false;
					        return true;
					    } 
					 
					 
					 $('#baseUrl').click(function() 
				    			{  
				    				 if($("#txtRoomTypeCode").val().trim()=="")
				    				{
				    					alert("Please Select Room Type..  ");
				    					return false;
				    				} 
				    					window.open('attachDoc.html?transName=frmRoomTypeMaster.jsp&formName=Member Profile&code='+$('#txtRoomTypeCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				    			});
					 

	
</script>


</head>
<body>
	<div class="container masterTable">
		<label id="formHeading">Room Type Master</label>
		<s:form name="RoomType" method="GET" action="saveRoomTypeMaster.html?" >
	    <div class="row">
				<!--  <div class="col-md-12" align="center"><a id="baseUrl" style="margin-left: -30%; display:none"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;
			     </div>    -->
             
            <div class="col-md-2"><label>Room Type</label>
				 <s:input id="txtRoomTypeCode" readonly="true" path="strRoomTypeCode" style="height: 45%;" cssClass="searchTextBox" ondblclick="funHelp('roomType')" />			
			</div>
			
			<div class="col-md-2"><label>Room Type Desc</label>
				<s:input id="txtRoomTypeDesc" path="strRoomTypeDesc"/>				
			</div>
			
			<div class="col-md-2"><label>Single Occupancy</label>
				<s:input id="txtRoomTerrif" path="dblRoomTerrif" style="text-align:right; width: 40%;" onkeypress="javascript:return isNumber(event)"/>				
			</div>
			<div class="col-md-6"></div>
			
			<div class="col-md-2"><label>Double Occupancy</label>
				<s:input id="txtDoubleTarrif" path="dblDoubleTariff" style="text-align:right; width: 40%;" onkeypress="javascript:return isNumber(event)"/>				
			</div>
			
			<div class="col-md-2"><label>Tripple Occupancy</label>
				<s:input id="txtTrippleTarrif" path="dblTrippleTariff" style="text-align:right; width: 40%;" onkeypress="javascript:return isNumber(event)"/>				
			</div>
			<div class="col-md-2"><label>HSN/SAC</label>
				<s:input id="txtHsnSac" path="strHsnSac"/>				
			</div>
		
			<div class="col-md-2"><label>Guest Capcity</label>
				<s:input id="txtGuestCapcity" path="strGuestCapcity" type="number" onkeypress="return isNumber(event)" max="100"/>				
			</div>
			
		</div>
		<br />
		<p align="center" style="margin-right:32%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"  onclick="return funCallFormAction('submit',this);"/>
            &nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
       </p>
	</s:form>
	</div>
</body>
</html>
