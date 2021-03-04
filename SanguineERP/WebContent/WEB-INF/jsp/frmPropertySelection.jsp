<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
  <head>
  
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" sizes="16x16">
<title>Property Selection</title>

<%--   <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesign/bootstrap.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesign/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesign/bootstrap-grid.css"/>" /> 
 <script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	 --%>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
<script type="text/javascript">
  $(document).ready(function(){
	  $('#submit').focus();
       
       $(document).ajaxStart(function(){
   	    $("#wait").css("display","block");
   	  });
   	  $(document).ajaxComplete(function(){
   	    $("#wait").css("display","none");
   	  });
   	  
<%--    	var PropertyError='<%=session.getAttribute("PropertyError").toString()%>'; --%>
//    	if(PropertyError!='')
//    		{
//    			alert(PropertyError);
//    		}
   	  

  });

  $(document).ready(function()
			{
		var message='';
		<%if (session.getAttribute("posLicStatus") != null) {
			            if(session.getAttribute("posLicMsg") != null){%>
			            message='<%=session.getAttribute("posLicMsg").toString()%>';
			            <%
			            session.removeAttribute("posLicMsg");
			            }
						session.removeAttribute("posLicStatus");
						%>	
			alert("\n"+message);
		<%
		}%>
		var diffDays='<%=session.getAttribute("diffDays").toString()%>';
		if(diffDays != "0"){
			
			alert("Licence Will Expire In "+diffDays+" Days\n Please Contact Technical Support");
<%-- 			<% session.removeAttribute("diffDays");%> --%>
		}
	});
  
  
</script>


<script type="text/javascript">

	function funSetSessionData()
	{
		var companyName=$( "#cmbCompany option:selected" ).text();
	    var  propertyName=$( "#cmbProperty option:selected" ).text();
	    var locationName=$( "#cmbLocation option:selected" ).text();
	    var financialYear=$( "#cmbFinancialYear option:selected" ).text();  
	    var pmsModule='<%=session.getAttribute("selectedPMSModule").toString()%>';
	   
	 	if(locationName.trim().length == 0){
	 	$.jAlert("Please Select Location");	
		return false;
	 	}else{
	    $("#strCompanyName").val(companyName);
	    $("#strPropertyName").val(propertyName);
	    $("#strLocationName").val(locationName);
	    $("#strFinancialYear").val(financialYear);
	   if(pmsModule.equals("Yes"))
	   {
		   var searchurl=getContextPath()+"/checkMasterEmptyForPMS.html?";
			 $.ajax({
				  type: "GET",
				  url: searchurl,
				  dataType:"text",
				  async:false,
				  success: function(response){
					  if(response.includes(false))
						  {
						  var isCheckOk=confirm("Do You Want to Open fill Masters ?"); 
							if(isCheckOk)
							{			 	 
								url=getContextPath()+"/frmPMSFillMasters.html?"
						 	 	window.open(url); 
							}
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
	    
	 	}
	}
	
	function getContextPath() 
	{
	  	return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
	
	function funLoadLocation(code)
	{	
		var searchUrl=getContextPath()+"/loadLoactionComboPropertyNUserWise.html?code="+code;
		//alert(searchUrl);
		$.ajax({
	        type: "GET",
	        url: searchUrl,	        		
	        dataType: "json",
	        success: function(response)	        
	        {	      
	        	
	        
		           var html = '';   
		           var check=0;
				   $.each(response, function(key, value)
				   {
						if(key=='Invalid')
		        		{
							window.location.href=getContextPath()+"/frmStructureUpdateException_2.html"; 
		        			check=1;
		        		}else{
					 html += '<option value="' + key + '">'+ value + '</option>';
		        		}
				   });
				   if(check==0)
					   {
				   html += '</option>';
				   $('#cmbLocation').html(html);
				  // document.all['#divBtn'].style.display = 'block';
        		}
	        
			},
			error: function(jqXHR, exception) {
	            if (jqXHR.status === 0) {
	                $.jAlert('Not connect.n Verify Network.');
	            } else if (jqXHR.status == 404) {
	                $.jAlert('Requested page not found. [404]');
	            } else if (jqXHR.status == 500) {
	                $.jAlert('Internal Server Error [500].');
	            } else if (exception === 'parsererror') {
	                $.jAlert('Requested JSON parse failed.');
	            } else if (exception === 'timeout') {
	                $.jAlert('Time out error.');
	            } else if (exception === 'abort') {
	                $.jAlert('Ajax request aborted.');
	            } else {
	                $.jAlert('Uncaught Error.n' + jqXHR.responseText);
	            }		            
	        }
	  });	
	}
	
	
	function funLoadLocation1(code,loc)
	{	
		var searchUrl=getContextPath()+"/loadLoactionComboPropertyNUserWise.html?code="+code;
		
		$.ajax({
	        type: "GET",
	        url: searchUrl,
	        dataType: "json",
	        success: function(response)	        
	        {	    
	        
		           var html = '';   
		           var check=0;
				   $.each(response, function(key, value)
				   {
						if(key=='Invalid')
		        		{
							window.location.href=getContextPath()+"/frmStructureUpdateException_2.html"; 
		        			check=1;
		        		}else{
					 html += '<option value="' + key + '">'+ value + '</option>';
		        		}
				   });
				   if(check==0)
				   {
				   html += '</option>';
				   $('#cmbLocation').html(html);
				   $("#cmbLocation").val(loc);
				   }
				  // document.all["#divBtn"].style.display = 'block';
				   // $('#txtWOCode').css('visibility','visible');
	        
			},
			error: function(jqXHR, exception) {
	            if (jqXHR.status === 0) {
	                $.jAlert('Not connect.n Verify Network.');
	            } else if (jqXHR.status == 404) {
	                $.jAlert('Requested page not found. [404]');
	            } else if (jqXHR.status == 500) {
	                $.jAlert('Internal Server Error [500].');
	            } else if (exception === 'parsererror') {
	                $.jAlert('Requested JSON parse failed.');
	            } else if (exception === 'timeout') {
	                $.jAlert('Time out error.');
	            } else if (exception === 'abort') {
	                $.jAlert('Ajax request aborted.');
	            } else {
	                $.jAlert('Uncaught Error.n' + jqXHR.responseText);
	            }		            
	        }
	  });	
	}
	

	function funOnLoad()
	{	
		var prop='<%=session.getAttribute("LastProperty").toString()%>';
		var loc='<%=session.getAttribute("LastLocation").toString()%>';
		
		if(prop!='')
		{
			<%
				session.removeAttribute("LastProperty");
				session.removeAttribute("LastLocation");
			%>
			 $("#cmbProperty").val(prop);
			funLoadLocation1(prop,loc); 
		}
	}


</script>

  </head>
  
	<body>
	<!-- <div class="wrapper" style="margin:0px; padding:0px"> -->
	
<div class="container-fluid">
		<div class="row">

			<div class="col-md-4">
			
			
			<div class="col-md-4"></div>
			<div class="col-md-4" style="margin-right:-40px;"> 
			
			<div style="width: 100%;height: 200px;"><img alt="" src="../${pageContext.request.contextPath}/resources/images/${headerImage}" width="100%" height="200px" style="background-repeat: no-repeat"></div>
	<div style="background-color: inherit; top: 200px; bottom: 0;float: left;padding-left: 10px; margin: 145px 100px;"><img alt="" src="../${pageContext.request.contextPath}/resources/images/${moduleTitleImage}" height="150px" width="350px">
	
<!-- 	<div style="float: left;padding-left: 40px;"> -->
<!-- 		<img alt="" -->
<%-- 				src="../${pageContext.request.contextPath}/resources/images/company_Logo.png" --%>
<!-- 				style="display: block; padding-left: 1px;width : 339px;high : 250px;"> -->
				
<!-- 	</div> -->
	</div>
	
	     </div>
				<s:form name="frmPropSel"  method="GET" action="frmMainMenu.html" style=" margin-top: 90px;">

				<div class="box1" style="margin-top: 50px">
							<h2 style="width: 17%; float: right; margin-right: 190px; padding-left: 0px;">Property Selection</h2>
				</div>
				<div class="inputbox1">
								 <label style="margin-left: 527px; margin-top:263px;">Company</label>
								 <s:select id="cmbCompany" style="margin-bottom:5px;margin-left: 68%;
  								  width: 18%;" path="strCompanyCode">
				    			<s:options items="${listComapny}"/>
				    		</s:select><s:input type="hidden" path="strCompanyName" id="strCompanyName"/>
						
							
				</div>
				<div class="inputbox1">
							<label style="margin-left: 527px;  margin-top:263px;">Property</label>
							  <s:select id="cmbProperty" path="strPropertyCode" required="true"  style="margin-bottom:5px; margin-left: 68%;
   							 width: 18%;" onchange="funLoadLocation(this.value)">
				    			<s:options items="${listProperty}"/>
				    		</s:select><s:input type="hidden" path="strPropertyName" id="strPropertyName"/>
							
							
				</div>	
				<div class="inputbox1">
							  <label style="margin-left: 527px;  margin-top:263px;">Location</label>
							  <s:select id="cmbLocation" path="strLocationCode"  style="margin-bottom:5px;margin-left: 68%;
   								 width: 18%;"> 
				    			<!-- <s:options  items="${listLocation}"/> -->
				    		</s:select><s:input type="hidden" path="strLocationName" id="strLocationName"/>
							
							
				</div>
				<div class="inputbox1">
							  <label style="margin-left: 527px;  margin-top:263px;">Fin. Year</label>
							  <select id="cmbFinancialYear"  style="margin-bottom:-10px;margin-left: 68%;
   								 width: 18%;">	
				    		<c:forEach items="${listFinancialYear}" var="draw">	
				    		<option value="${draw.key}">${draw.value}</option>
				    		</c:forEach>	
				    		</select><s:input type="hidden" path="strFinancialYear" id="strFinancialYear"/>
							
							
				</div>
				<div class="submit" id="divBtn">
					<h2><input type="submit" onclick="return funSetSessionData()" placeholder="Submit style='color:#fff;'" id="submit" value="Submit" class="loginButton" style="margin-right:170px; float:right; font-size:17px; font-family:trebuchet ms; font-weight:1100px;
    width: 8%; color:#fff;"></h2>
				</div>
				
				<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:50%;left:45%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			</div>
			<script type="text/javascript">
			funLoadLocation($("#cmbProperty").val());
			</script>
			
			</s:form>
			
				<div id="loginfooter">Copyright &copy; 2014 Sanguine Software Solutions</div>
		</div> 
    </div>	
   <!--  </div>			 -->
	</body>
</html>