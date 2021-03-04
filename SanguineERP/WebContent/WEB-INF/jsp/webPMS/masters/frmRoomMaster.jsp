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
	
	//Initialize tab Index or which tab is Active
	$(document).ready(function() 
	{		
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
			
		$(document).ajaxStart(function(){
		    $("#wait").css("display","block");
		});
		$(document).ajaxComplete(function(){
		   	$("#wait").css("display","none");
		});
	});
	
	function funSetRoomMasterData(roomCode)
	{
		var searchUrl=getContextPath()+"/loadRoomMasterData.html?roomCode="+roomCode;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strRoomCode=='Invalid Code')
	        	{
	        		alert("Invalid Room Code");
	        		$("#txtRoomCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomCode").val(response.strRoomCode);
	        		$("#txtRoomDesc").val(response.strRoomDesc);
	        		$("#cmbRoomType").val(response.strRoomTypeCode);
	        		funSetRoomType(response.strRoomTypeCode);
	        		$("#txtFloorCode").val(response.strFloorCode);
	        		$("#txtBedType").val(response.strBedType);
	        		$("#txtFurniture").val(response.strFurniture);
	        		$("#txtExtraBed").val(response.strExtraBed);
	        		$("#txtUpholstery").val(response.strUpholstery);
	        		$("#txtLocation").val(response.strLocation);
	        		$("#txtColourScheme").val(response.strColourScheme);
	        		$("#txtPolishType").val(response.strPolishType);
	        		$("#txtGuestAmenities").val(response.strGuestAmenities);
	        		$("#txtInterConnectRooms").val(response.strInterConnectRooms);
	        		$("#txtBathTypeCode").val(response.strBathTypeCode);
	        		
	        		if(response.strAccountCode!="" && response.strAccountCode!="NA" )
	        			{
	        				funSetAccountCode(response.strAccountCode);
	        			}
	        		
	        		
	        		if(response.strProvisionForSmokingYN=="Y")
	        		{
	        			$("#rdbProvisionForSmokingYN").prop('checked',true);
	        		}
	        		else
	        		{
	        			$("#rdbProvisionForSmokingYN").prop('checked',false);
	        		}
	        		if(response.strDeactiveYN=="Y")
	        		{
	        			$("#rdbDeactiveYN").prop('checked',true);
	        		}
	        		else
	        		{
	        			$("#rdbDeactiveYN").prop('checked',false);
	        		}
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
	
	
	
	function funSetRoomType(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strRoomTypeCode=='Invalid Code')
	        	{
	        		alert("Invalid Room Type");
	        		$("#txtRoomType").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomType").val(response.strRoomTypeCode);
	        		$("#lblRoomType").val(response.strRoomTypeDesc);
	        	}
			},
			error : function(e){
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
	linked account code
	**/
	function funSetAccountCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getAccountMasterDtl.html?accountCode=" + code,
			dataType : "json",			
			success : function(response)
			{
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtAccountCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtAccountCode").val(response.strAccountCode);
	        		$("#txtAccountName").val(response.strAccountName);
	        	}
			},
			error : function(jqXHR, exception)
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
	* Get and Set data from help file and load data Based on Selection Passing Value(Extra Bed Code)
	**/
	
	function funSetExtraBed(code)
	{
		$("#txtExtraBed").val(code);
		var searchurl=getContextPath()+"/loadExtraBedMasterData.html?extraBedCode="+code;
		$.ajax({
			type: "GET",
			url: searchurl,
			dataType: "json",
			success: function(response)
			{
				if(response.strExtraBedTypeCode=='Invalid Code')
			    {
			    	alert("Invalid ExtraBed Code");
			    	$("#txtExtraBed").val('');
			    }
			    else
			    {
			    	$("#lblExtraBed").text(response.strExtraBedTypeDesc);					
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

	function funSetData(code) 
	{

		switch (fieldName) 
		{
			case "roomForMaster":
				 funSetRoomMasterData(code);
				 break;
			
			case "roomType":
				funSetRoomType(code);
				break;
				
			case "extraBed":
				funSetExtraBed(code);
				break;	
				
			case "accountCode":
				funSetAccountCode(code);
				break;
				
			case "floormaster":
				funSetFloorMaster(code);
				break;
				
			case "bathType":
				funSetBathType(code);
				break;
		}
	}

	function funHelp(transactionName)
	{
		fieldName = transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname=" + transactionName + "&searchText=", "","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funSetFloorMaster(code)
	{
		$("#txtFloorCode").val(code);
		var searchurl=getContextPath()+"/loadFloorMasterData.html?floorCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strFloorCode=='Invalid Code')
			        	{
			        		alert("Invalid Business Code");
			        		$("#txtFloorCode").val('');
			        	}
			        	else
			        	{	
			        		$("#txtFloorCode").val(response.strFloorCode);
				        	$("#lblFloorName").text(response.strFloorName);
				        	
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
	
	function funSetBathType(code)
	{
		$("#txtBathTypeCode").val(code);
		var searchurl=getContextPath()+"/loadBathTypeMasterData.html?bathTypeCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strBathTypeCode=='Invalid Code')
			        	{
			        		alert("Invalid Bath Code");
			        		$("#txtBathTypeCode").val('');
			        	}
			        	else
			        	{
			        		$("#txtBathTypeCode").val(response.strBathTypeCode);
				        	$("#lblBathTypeDesc").text(response.strBathTypeDesc);
				     
				        	
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
	
	function funOpenExportImport()			
	{
		var transactionformName="frmRoomMaster";
		//var guestCode=$('#txtGuestCode').val();
		
		
	//	response=window.showModalDialog("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
		response=window.open("frmExcelExportImport.html?formname="+transactionformName,"dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
        
		
	}
	
			
 			$('#baseUrl').click(function() 
 			{  
 				 if($("#txtRoomCode").val().trim()=="")
 				{
 					alert("Please select Room Code.. ");
 					return false;
 				} 
 					window.open('attachDoc.html?transName=frmRoomMaster.jsp&formName=Member Profile&code='+$('#txtRoomCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
 			});

</script>

</head>
<body>
   <div class="container masterTable">
		<label id="formHeading">Room Master</label>
	<s:form name="RoomMaster" method="POST" action="saveRoomMaster.html">
     <div id="tab_container" style="height:360px; overflow: hidden;">
				<ul class="tabs">
					<li data-state="tab1" style="width:7%" class="active" >General</li>
					<li data-state="tab2" style="width:7%">LinkUp</li>
				</ul>
							
				<!-- General Tab Start -->
				<div id="tab1" class="tab_content" style="height: 360px">
					<br> 
					<br>					
					
					
				
				<!-- <th align="right" colspan="6"><a id="baseUrl"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;</th> -->
			<div class="row">
			      <div class="col-md-12"  align="center" style="margin-left: 12%"><a onclick="funOpenExportImport()"
					href="javascript:void(0);">Export/Import</a>&nbsp; &nbsp; &nbsp;
					&nbsp;
					</div>
				
				     <div class="col-md-4"><label>Room Code</label>
					    <div class="row">
						   <div class="col-md-5"> <s:input id="txtRoomCode" path="strRoomCode"  ondblclick="funHelp('roomForMaster')" style="height:95%" cssClass="searchTextBox"/></div>			        			        
						   <div class="col-md-7"> <s:input id="txtRoomDesc" path="strRoomDesc" required="true"/></div>			    		        			   
				    </div></div>
						
						<div class="col-md-4"><label>Room Type</label>
						 <div class="row">
						    <div class="col-md-5"><s:input id="txtRoomType" path="strRoomType"  ondblclick="funHelp('roomType')" style="height:95%" cssClass="searchTextBox"/></div>
						    <div class="col-md-7"><s:input id="lblRoomType" path="strRoomTypeDesc" readonly="readonly" style="background-color:#dcdada94; width: 100%; height:90%"/></div>
						 </div></div>
					
					<div class="col-md-4"></div>
					
						<div class="col-md-4"><label>Floor Code</label>
						 <div class="row">
							<div class="col-md-5"><s:input id="txtFloorCode" type="text" path="strFloorCode" style="height:95%" cssClass="searchTextBox" ondblclick="funHelp('floormaster')" /></div>
						     <div class="col-md-7"><label id="lblFloorName" style="background-color:#dcdada94; width: 100%; height:90%"></label></div>
						</div></div>
						
						<div class="col-md-4"><label>Extra Bed</label>
						 <div class="row">
						      <div class="col-md-5"><s:input id="txtExtraBed" path="strExtraBed"  ondblclick="funHelp('extraBed')" style="height:95%" cssClass="searchTextBox"/></div>
						     <div class="col-md-7"><label id="lblExtraBed" style="background-color:#dcdada94; width: 100%; height:90%"></label></div>
						 </div></div>
						 <div class="col-md-4"></div>
						 
						 <div class="col-md-2"><label>Bed Type</label>		    
							<s:input id="txtBedType" path="strBedType"/>
						 </div>
						
						<div class="col-md-2"><label>Furniture</label>
							  <s:input id="txtFurniture" path="strFurniture"/>
					     </div>
						
						<div class="col-md-2"><label>Upholstery</label>
							  <s:input id="txtUpholstery" path="strUpholstery" style="width: 130px"/>
						</div>
						
						 <div class="col-md-2"><label>Location</label>
							   <s:input id="txtLocation" path="strLocation" style="width: 160px"/>
					     </div>
						<div class="col-md-4"></div>
						
						<div class="col-md-4"><label>Bath Type</label>
						 <div class="row">
							  <div class="col-md-5"><s:input id="txtBathTypeCode" type="text" path="strBathTypeCode" style="height:95%" cssClass="searchTextBox" ondblclick="funHelp('bathType')" /></div>
						      <div class="col-md-7"><label id="lblBathTypeDesc" style="background-color:#dcdada94; width: 100%; height:90%"></label></div>
						</div></div>
						
						<div class="col-md-2"><label>Colour Scheme</label>
							<s:input id="txtColourScheme" path="strColourScheme" style="width: 130px"/>
						</div>
						
						<div class="col-md-2"><label>Polish Type</label>
							<s:input id="txtPolishType" path="strPolishType" style="width: 160px"/>
						</div>
						<div class="col-md-4"></div>
						
						<div class="col-md-2"><label>Guest Amenities</label>
							<s:input id="txtGuestAmenities" path="strGuestAmenities" style="width: 160px"/>
						</div>
						
						<div class="col-md-2"><label>Interconnect Rooms</label>
							<s:input id="txtInterConnectRooms" path="strInterConnectRooms" style="width: 160px"/>
						</div>
						
						<div class="col-md-2"><label>Provision For Smoking</label><br>
							    <s:radiobutton id="rdbProvisionForSmokingYN" path="strProvisionForSmokingYN" value="Y"  />Yes 
								<s:radiobutton id="rdbProvisionForSmokingYN" path="strProvisionForSmokingYN" value="N" checked="checked" style="margin-left: 20px;" />No
						</div>
						
						<div class="col-md-2"><label>Deactive</label><br>
							     <s:radiobutton id="rdbDeactiveYN" path="strDeactiveYN" value="Y" />Yes 
								<s:radiobutton id="rdbDeactiveYN" path="strDeactiveYN" value="N" checked="checked" style="margin-left: 20px;" />No
					    </div>
						
					<%-- 	<tr>
						
						 <td><label>Room Status</label></td>
						<td><s:input id="txtRoomStatus" path="strStatus"  cssClass="longTextBox" style="width: 190px"/></td>
						<td><s:select id="txtRoomStatus" path="strStatus" cssClass="BoxW124px" >
					    <option selected="selected" value="Free">Free</option>
				        <option value="Blocked">Blocked</option>
				        <option value="Occupied">Occupied</option>
				        </td>
			         </s:select>
						</tr> --%>
					</div>		
		         </div>
						<!--General Tab End  -->
			
						
			<!-- Linkedup Details Tab Start -->
			<div id="tab2" class="tab_content" style="height: 360px">
			<br> 
			<br>			
				<div class="row">
				    <div class="col-md-4">
				        <div class="row">
							<div class="col-md-5"><label>Account Code</label>
						    	<s:input id="txtAccountCode" path="strAccountCode" readonly="true" ondblclick="funHelp('accountCode')" style="height:50%" cssClass="searchTextBox"/></div>
						   <div class="col-md-7"><s:input id="txtAccountName" path="" style="margin-top: 14%" readonly="true"/></div>			        			        						    			    		        			  
					</div></div>
				</div>
			</div>
			
		</div>
		
		<p align="center" style="margin-right: -20%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" />
		</p>
      </s:form>
     </div>
</body>
</html>
