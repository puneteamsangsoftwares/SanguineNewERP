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
	    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
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
		
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#dteValidFrom").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteValidFrom").datepicker('setDate', pmsDate);

		$("#dteValidTo").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#dteValidTo").datepicker('setDate', pmsDate);
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
	        		$("#lblRoomType").text(response.strRoomTypeDesc);
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
			case "roomByRoomType":
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
				
			case 'reasonPMS' : 
				funSetReasonData(code);
			break;
			
			case 'blockRoom' : 
				funSetBlockRoomData(code);
			break;
			
		}
	}

	function funHelp(transactionName)
	{
		fieldName = transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname=" + transactionName + "&searchText=", "","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funHelp1(transactionName,row)
	{
		gridHelpRow=row;
		var condition = $("#txtRoomType").val();
		fieldName = transactionName;
		if(transactionName=="roomByRoomType" && condition!="")
			{
				window.open("searchform.html?formname="+fieldName+"&strRoomTypeCode="+condition+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		
			}
		else
		{
			if(condition=="")
			{
				alert("Please Select Room Type !!!");
			}
			//window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		}
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
	
		function funBtnSubmit(){
		
			if($("#txtReason").val()==''){
				alert("Please Select Reason");
				return false;
			}
			
			if($("#txtRemarks").val()==''){
				alert("Please Select Remark");
				return false;
			}
		}
		
		function funSetReasonData(code)
		{
			$("#txtReason").val(code);
			var searchurl=getContextPath()+"/loadPMSReasonMasterData.html?reasonCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strTransId=='Invalid Code')
				        	{
				        		alert("Invalid Reason Code");
				        		$("#txtReasonCode").val('');
				        	}
				        	else
				        	{	
				        		$("#txtReason").val(response.strReasonCode);
				        		$("#lblReasonDesc").text(response.strReasonDesc);
					        	
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
		
		
		function funSetBlockRoomData(transId)
		{
			var searchUrl=getContextPath()+"/loadBlockRoomData.html?transId="+transId;
			$.ajax({
				
				url:searchUrl,
				type :"GET",
				dataType: "json",
		        success: function(response)
		        {
		        	if(response[0]=='Invalid Code')
		        	{
		        		alert("Invalid Block Code");
		        		$("#txtTransId").val('');
		        	}
		        	else
		        	{
		        		
		        		$("#txtTransId").val(response[0]);
		        		$("#txtRoomType").val(response[1]);
		        		$("#lblRoomType").text(response[2]);
		        		$("#txtRoomCode").val(response[3]);
		        		$("#txtRoomDesc").val(response[4]);
		        		$("#txtReason").val(response[5]);
		        		$("#lblReasonDesc").text(response[6]);
		        		$("#txtRemarks").text(response[7]);
		        		$("#dteValidFrom" ).datepicker('setDate', response[8]);
		        		$("#dteValidTo" ).datepicker('setDate', response[9]);
		        		//$("#dteValidFrom").text(response[8]);
		        		//$("#dteValidTo").text(response[9]);
		        		
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
</script>

</head>
<body>
    <div class="container masterTable">
	 <label id="formHeading">Block Room </label>
	   <s:form name="BlockRoomMaster" method="POST"
		action="saveBlockRoom.html">

      <!--  <div id="tab_container" style="height:405px"> -->
			
           <!-- General Tab Start -->
			<!-- <div id="tab1" class="tab_content" style="height:400px"> -->
				
	    <div class="row">
	       
	       <div class="col-md-5"><label>Block Room Code</label>
		        <div class="row">
				    <div class="col-md-5">
						<s:input id="txtTransId" path="strTransId" ondblclick="funHelp('blockRoom')" cssClass="searchTextBox" style="height: 95%;"/>
					</div>
				</div></div>
			<div class="col-md-7"></div>	 
	    
		   <div class="col-md-5"><label>Room Type</label>
		        <div class="row">
				    <div class="col-md-5">
						<s:input id="txtRoomType" path="strRoomType" ondblclick="funHelp('roomType')" cssClass="searchTextBox" style="height: 95%;"/>
					</div>
					<div class="col-md-7"><label id="lblRoomType" style="background-color:#dcdada94; width:80%; height:95%;"></label>
					</div>
				</div></div>
		    <div class="col-md-7"></div>
		    
			<div class="col-md-5">
		        <div class="row">	
				<div class="col-md-5"><label>Room Code</label>
					 <s:input id="txtRoomCode" path="strRoomCode" ondblclick="funHelp1('roomByRoomType')" cssClass="searchTextBox" style="height:45%;"/>
				</div>
				<div class="col-md-7"><s:input id="txtRoomDesc" path=""
								required="true" style="width:197px; margin-top:25px" />
				</div>
		     </div></div>
             <div class="col-md-7"></div>
             
              <div class="col-md-5">
			      <div class="row">
					<div class="col-md-5"><label>Reason</label>
					      <s:input type="text" id="txtReason" path="strReason" cssClass="searchTextBox" style="height: 45%;" ondblclick="funHelp('reasonPMS');"/>
			        </div>
						<%-- <td><s:input id="txtReason" path="strReason"
								cssClass="longTextBox" style="width: 190px" /></td> --%>
				    <div class="col-md-7"><label id="lblReasonDesc" style="background-color:#dcdada94; width:80%;margin-top: 27px; height:45%;"></label>
				    </div>
			       </div></div>				
				<div class="col-md-7"></div>
				
			 <div class="col-md-3">
		        <div class="row">
		            <div class="col-md-6"><label>Valid From</label>
			                <s:input type="text" id="dteValidFrom" path="dteValidFrom" required="true" class="calenderTextBox" />
			        </div>
			        <div class="col-md-6"><label>Valid To</label>
			                <s:input type="text" id="dteValidTo" path="dteValidTo" class="calenderTextBox" />		    		  
			        </div>
            </div></div>
            
            <div class="col-md-2"><label>Remarks</label>
						<s:textarea id="txtRemarks" path="strRemarks" style="height: 30px;"/>
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
				<!-- </div>
			</div> -->
			<!--General Tab End  -->

       </div>
		<br />
	
		<p align="center" style="margin-right:27%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funBtnSubmit()"/>&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" />
		</p>
		
     </s:form>
	</div>
</body>
</html>
