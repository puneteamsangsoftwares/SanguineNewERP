<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:insertAttribute name="title" ignore="true"></tiles:insertAttribute>
</title>
		<%-- <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value=resources/css/newdesigncss/materialdesignicons.min.css/>" />
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value=resources/css/newdesigncss/bootstrap.css/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value=resources/css/newdesigncss/bootstrap.min.css/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value=resources/css/newdesigncss/bootstrap-grid.css/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value=resources/css/design.css/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script> --%>
</head>

<body >

		 <div class="row12" >
			    <tiles:insertAttribute name="header"></tiles:insertAttribute>
			 
			</div>
			<div class="row">
			<%-- <tiles:insertAttribute name="banner"></tiles:insertAttribute> --%> 
			</div>
			 
			<div class="row-container">
			    <!-- <div class="content"> -->
			        <div class="sidebar">
			          <tiles:insertAttribute name="menu"></tiles:insertAttribute>
			        </div>
			        <div class="contents" style="overflow: scroll;">
			           <tiles:insertAttribute name="body"></tiles:insertAttribute>
			        </div>
			        <!-- <div class="clearfix"></div> -->
			    <!-- </div> -->
			    <div id="loginfooter">
						<!-- id="loginfooter"> -->
						<tiles:insertAttribute name="footer"></tiles:insertAttribute>
						<!-- end .footer -->
				</div>
			</div>
  
	   <%-- <main class="app-page">
		 <div class="row12" >
			 <tiles:insertAttribute name="header"></tiles:insertAttribute>
		 </div>
	 </main> --%>
         
</body>
</html>




