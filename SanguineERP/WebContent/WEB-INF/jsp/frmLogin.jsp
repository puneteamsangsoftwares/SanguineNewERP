<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page session="True" %>
<!DOCTYPE html>
<html>
  <head>
	  <script type="text/javascript" src="<spring:url value="/resources/js/jquery-3.0.0.min.js"/>"></script>
	  <script type="text/javascript" src="<spring:url value="/resources/js/jQKeyboard.js"/>"> </script>
	  <script type="text/javascript" src="<spring:url value="/resources/js/slideKeyboard/jquery.ml-keyboard.js"/>"></script>
	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jQKeyboard.css "/>" />
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/slideKeyboard/jquery.ml-keyboard.css"/>" />
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/slideKeyboard/jquery.ml-keyboard.css"/>" />	
		 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
  <script type="text/javascript">
  	/**
	 *  Set Focus
	**/
  $(document).ready(function(){
       $('#username').focus();
      
       var strTouchScreenMode=localStorage.getItem("lsTouchScreenMode");
       if (strTouchScreenMode == null) 
		{
		   localStorage.setItem("lsTouchScreenMode", "N");
		}   
		/*if(strTouchScreenMode=='Y')
		{
		   $('input#username').mlKeyboard({layout: 'en_US'});
		   $('input#password').mlKeyboard({layout: 'en_US'});
		   $('#username').focus();
		}*/
		var companyName='';
		<%if(null!=session.getAttribute("companyName")){%>
		companyName="<%=session.getAttribute("companyName")%>";
		<%}%>
		
		
		$('#lblCompanyName').text(companyName);
	
  });
  	
  	
  	function funKeyBoard()
  	{
  			var lsKeyBoardYN= localStorage.getItem("lsTouchScreenMode");
  			if(lsKeyBoardYN=='Y')
  			{
  				localStorage.setItem("lsTouchScreenMode", "N");
  			}
  			if(lsKeyBoardYN=='N')
  			{
  				localStorage.setItem("lsTouchScreenMode", "Y");
  			}
  	
  	}
  	
</script>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
  </head>

<body>
	<div class="container-fluid">
		<div class="row" >	
		
			<div class="col-md-4">
				<a href="#">
					<img alt=""src="../${pageContext.request.contextPath}/resources/images/Sanguine_ERP.jpg" height="165px" width="340px" onclick="funKeyBoard()" style ="margin:135px 100px;">
				</a>
			</div>
			<div class="col-md-4"></div>
			<div class="col-md-4">
				<s:form name="login" method="POST" action="validateUser.html">
				<div class="box">
							<h2 id="lblCompanyName">sanguine software solutions</h2>
							<h3  style="border: 2px solid #2e6eb1;border-bottom-right-radius:50%;width:50%s; background-color:#2e6eb1; color:#fff;"> Login</h3>
					<form style="padding-left:30px;">
						<div class="inputbox">
							<s:input name="usercode" type="text" path="strUserCode" autocomplete="off" id="username" required="true" cssStyle=" text-transform: uppercase; margin-bottom:20px" /> <s:errors path="strUserCode"></s:errors>
							<s:label path="strUserCode">Username</s:label>
							
						</div>
						<div class="inputbox">
							<s:input type="password" required="true" name="pass" path="strPassword" id="password" /> <s:errors path="strPassword"></s:errors>
							<s:label path="strPassword">Password</s:label>
							
						</div>
						<h2><input type="submit" name="" value="Submit" style="margin-left:200px; font-weight:700px"></h2>
					</form>
				</div>
			</s:form>
			</div>	
		</div>
				
	</div>
	
	
<c:if test="${!empty invalid}">
<script type="text/javascript">
	alert("Invalid Login");
</script>
</c:if> 
<c:if test="${!empty LicenceExpired}">
<script type="text/javascript">
	alert("Licence is Expired \n Please Contact Technical Support");
</script>
</c:if> 

</body>
</html>