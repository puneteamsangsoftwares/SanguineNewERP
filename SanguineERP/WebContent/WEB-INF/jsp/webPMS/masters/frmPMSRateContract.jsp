<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;

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
		
		
		var RoomType=value="${RoomType}"
		
		//$("#cmbRoomType").val(RoomType);
		
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#dteFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteFromDate").datepicker('setDate', pmsDate);

		$("#dteToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteToDate").datepicker('setDate', pmsDate);
	});

	function funSetData(code){

		switch(fieldName){

			case 'BookingTypeCode' : 
				funSetBookingTypeCode(code);
				break;
				
			case 'PMSRateManagement' : 
				funSetPMSRateManagementCode(code);
				break;
		}
	}


	function funSetPMSRateManagementCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadPMSRateCode.html?code=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strRateContractID=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookingTypeCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtBookingTypeCode").val(response.strRateContractID);
	        		$("#cmbRoomType").val(response.strRoomTypeCode);
	        		
	        		$("#cmbSeason").val(response.strSeasonCode);
	        		
	        		if(response.strIncludeTax.includes("Y"))
	        		{
	        			document.getElementById("txtIncludeTax").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtIncludeTax").checked = false;	
	        		}
	        		
	        		$("#txtNoOfNights").val(response.intNoOfNights);
	        		$("#dteFromDate").val(response.dteFromDate);
	        		$("#dteToDate").val(response.dteToDate);
	        		
	        		if(response.strSunday.includes("Y"))
	        		{
	        			document.getElementById("txtSunday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtSunday").checked = false;	
	        		}
	        		
	        		if(response.strMonday.includes("Y"))
	        		{
	        			document.getElementById("txtMonday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtMonday").checked = false;	
	        		}
	        		
	        		if(response.strTuesday.includes("Y"))
	        		{
	        			document.getElementById("txtTuesday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtTuesday").checked = false;	
	        		}
	        		
	        		if(response.strWednesday.includes("Y"))
	        		{
	        			document.getElementById("txtWednesday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtWednesday").checked = false;	
	        		}
	        		if(response.strThursday.includes("Y"))
	        		{
	        			document.getElementById("txtThursday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtThursday").checked = false;	
	        		}
	        		
	        		if(response.strFriday.includes("Y"))
	        		{
	        			document.getElementById("txtFriday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtFriday").checked = false;	
	        		}
	        		
	        		if(response.strSaturday.includes("Y"))
	        		{
	        			document.getElementById("txtSaturday").checked = true;	
	        		} 
	        		else
	        		{
	        			document.getElementById("txtSaturday").checked = false;	
	        		}
	        		
	        		
	        		
	        		$("#txtSingleTariffWeekDays").val(response.dblSingleTariWeekDays);
	        		$("#txtDoubleTariffWeekDays").val(response.dblDoubleTariWeekDays);
	        		$("#txtTrippleTariffWeekDays").val(response.dblTrippleTariWeekDays);
	        		$("#txtExtraBedTariffWeekDays").val(response.dblExtraBedTariWeekDays);
	        		$("#txtChildTariffWeekDays").val(response.dblChildTariWeekDays);
	        		$("#txtYouthTariffWeekDays").val(response.dblYouthTariWeekDays);
	        		$("#txtSingleTariffWeekend").val(response.dblSingleTariWeekend);
	        		$("#txtDoubleTariffWeekend").val(response.dblDoubleTariWeekend);
	        		$("#txtTrippleTariffWeekend").val(response.dblTrippleTariWeekend);
	        		$("#txtExtraBedTariffWeekend").val(response.dblExtraBedTariWeekend);
	        		$("#txtChildTariffWeekend").val(response.dblChildTariWeekend);
	        		$("#txtYouthTariffWeekend").val(response.dblYouthTariWeekend);
	        		$("#txtRateContractName").val(response.strRateContractName);
	        
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


	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
			if(session.getAttribute("successMessage") != null)
			{%>
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
			}
		}%>
	});



	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	/**
	 *  Check Validation Before Saving Record
	 **/
	function funCallFormAction(actionName,object) 
	{
		var flg=true;
		
		if($('#txtBookingTypeDesc').val()=='')
		{
			 alert('Enter Booking Type Description');
			 flg=false;
		}			
		return flg;
	}
	$('#baseUrl').click(function() 
			{  
				 if($("#txtBookingTypeCode").val().trim()=="")
				{
					alert("Please Select Booking Type Code..  ");
					return false;
				} 
					window.open('attachDoc.html?transName=frmBookingType.jsp&formName=Member Profile&code='+$('#txtBookingTypeCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
	
	function funTaxOnTaxableStateChange()
	{
		var isSelected=$("#txtIncludeTax").prop('checked');
		if(isSelected==true)
		{
			$("#txtIncludeTax").val("Y");				
		}
		else
		{
			$("#txtIncludeTax").val("N");				
		}
	}
	
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Rate Management</label>
	<s:form name="BookingType" method="POST" action="savePMSRateContract.html">
		<div class="row">
			<div class="col-md-2"><label>Rate Mgmt Code</label>
				    <s:input type="text" id="txtBookingTypeCode" readonly="true" path="strRateContractID" value="" style="height: 48%" cssClass="searchTextBox" ondblclick="funHelp('PMSRateManagement');"/>
			</div>
			
			<div class="col-md-3"><label>Rate Contract Name</label> 
				 <s:input type="text" id="txtRateContractName" style="width:60%;text-align:right" path="strRateContractName"/>
			</div>
			
		</div>
		<!-----------------------  -->
		
		        <div class="row">
		            <div class="col-md-2" style="padding-left:15px"><label>From Date</label>
			                <s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" />
			        </div>
			        
			        <div class="col-md-2"><label>To Date</label>
			                <s:input type="text" id="dteToDate" path="dteToDate" class="calenderTextBox" />		    		  
			        </div>
			        
			        
			         <div class="col-md-2"><label>Room Type</label>
			              
<%-- 							<s:select  id="cmbRoomType" path="strRoomTypeCode" items="${RoomType}"  required="true" style="width:70%;" />
 --%>							<s:select  id="cmbRoomType" path="strRoomTypeCode" items="${RoomDesc}" required="true"  style="width:70%;" />
							
					</div>
					
					<div class="col-md-2"><label>Season</label>
			              
<%-- 							<s:select  id="cmbSeason"  path="strSeasonCode" items="${Season}" required="true" style="width:70%;" />
 --%>							
							<s:select  id="cmbSeason"  path="strSeasonCode" items="${SeasonDesc}" required="true" style="width:70%;" />
							
					</div>
					
					<div class="col-md-2">
							<label>Include Tax</label><br>
							<s:checkbox id="txtIncludeTax" checked="checked" value="Y" path="strIncludeTax" onclick="funTaxOnTaxableStateChange()" />
				</div>
				
				<div class="col-md-2"><label>No.Of Nights</label>
				 <s:input type="text" id="txtNoOfNights" style="width:50%;text-align:right" path="intNoOfNights"/>
			</div>
			        
			       
            </div>
            
            
            
            <!-- ----------------------------------- -->
            
            <div class="row">
		<label style="padding-left:20px;font-weight:bold;text-size:20px;">Week Days</label>
		</div>
		<div class="row">
		<div class="col-md-2"><label>Single</label>
				 <s:input type="text" id="txtSingleTariffWeekDays" style="width:50%;text-align:right" path="dblSingleTariWeekDays"/>
			</div>
			
			<div class="col-md-2"><label>Double</label>
				 <s:input type="text" id="txtDoubleTariffWeekDays" style="width:50%;text-align:right" path="dblDoubleTariWeekDays"/>
			</div>
			
			<div class="col-md-2"><label>Triple</label>
				 <s:input type="text" id="txtTrippleTariffWeekDays" style="width:50%;text-align:right" path="dblTrippleTariWeekDays"/>
			</div> 
			
			<div class="col-md-2"><label>Extra Bed</label>
				 <s:input type="text" id="txtExtraBedTariffWeekDays" style="width:50%;text-align:right" path="dblExtraBedTariWeekDays"/>
			</div> 
			
			<div class="col-md-2"><label>Child</label>
				 <s:input type="text" id="txtChildTariffWeekDays" style="width:50%;text-align:right" path="dblChildTariWeekDays"/>
			</div>
			
			<div class="col-md-2"><label>Youth</label>
				 <s:input type="text" id="txtYouthTariffWeekDays" style="width:50%;text-align:right" path="dblYouthTariWeekDays"/>
			</div>
			
			
		</div>
		
		<div class="row">
		<label style="padding-left:20px;font-weight:bold;text-size:20px;">Weekend</label>
		</div>
		<div class="row">
		<div class="col-md-2"><label>Single</label>
				 <s:input type="text" id="txtSingleTariffWeekend" style="width:50%;text-align:right" path="dblSingleTariWeekend"/>
			</div>
			
			<div class="col-md-2"><label>Double</label>
				 <s:input type="text" id="txtDoubleTariffWeekend" style="width:50%;text-align:right" path="dblDoubleTariWeekend"/>
			</div>
			
			<div class="col-md-2"><label>Triple</label>
				 <s:input type="text" id="txtTrippleTariffWeekend" style="width:50%;text-align:right" path="dblTrippleTariWeekend"/>
			</div> 
			
			<div class="col-md-2"><label>Extra Bed</label>
				 <s:input type="text" id="txtExtraBedTariffWeekend" style="width:50%;text-align:right" path="dblExtraBedTariWeekend"/>
			</div> 
			
			<div class="col-md-2"><label>Child</label>
				 <s:input type="text" id="txtChildTariffWeekend" style="width:50%;text-align:right" path="dblChildTariWeekend"/>
			</div>
			
			<div class="col-md-2"><label>Youth</label>
				 <s:input type="text" id="txtYouthTariffWeekend" style="width:50%;text-align:right" path="dblYouthTariWeekend"/>
			</div>
			
			<%-- <div class="col-md-3"><label>Rate Contract Name</label> 
				 <s:input type="text" id="txtRateContractName" style="width:80%;text-align:right" path="strRateContractName"/>
			</div>
			 --%>
			
			<div class="col-md-1"><label>Monday</label><br />
				 <s:checkbox  id="txtMonday" checked="checked" value="Y" path="strMonday"/>
			</div>
			
			<div class="col-md-1"><label>Tuesday</label><br />
				 <s:checkbox  id="txtTuesday" checked="checked" value="Y" path="strTuesday"/>
			</div>
			
			<div class="col-md-1"><label>Wednesday</label><br />
				 <s:checkbox  id="txtWednesday" checked="checked" value="Y" path="strWednesday"/>
			</div> 
			
			<div class="col-md-1"><label>Thursday</label><br />
				 <s:checkbox  id="txtThursday" checked="checked" value="Y" path="strThursday"/>
			</div> 
			
			<div class="col-md-1"><label>Friday</label><br />
				 <s:checkbox  id="txtFriday" checked="checked" value="Y" path="strFriday"/>
			</div>
			
			<div class="col-md-1"><label>Saturday</label><br />
				 <s:checkbox  id="txtSaturday" checked="checked" value="Y" path="strSaturday"/>
			</div>
			
			<div class="col-md-1"><label>Sunday</label><br />
				 <s:checkbox  id="txtSunday" checked="checked" value="Y" path="strSunday"/>
			</div>
		</div>
            
		</div>
            
            <!-- ---------------------- -->
		
		<!-- -------------------------------------------------------------------------------------->
		
		
		<!--------------------------------------------------------------------  -->
		
		
		
        <br />
	
		<p align="center" >
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);"/>
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
    </s:form>
    </div>
</body>
</html>
