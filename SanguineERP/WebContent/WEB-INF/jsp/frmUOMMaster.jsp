<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
		
		<script type="text/javascript" src="<spring:url value="/resources/js/controller/scriptchart.js"/>"></script>
	
	  <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.2/jquery.min.js'></script>
<script src='https://cdn3.devexpress.com/jslib/17.1.6/js/dx.all.js'></script>
	
<script type="text/javascript">
	
		/**
		 * Open Help windows 
		 */
		function funHelp(transactionName)
		{	     
	      //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
			  window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	    }
		/**
		 * Set Data after selecting form Help windows
		 */
		function funSetData(code)
		{
			$("#txtUOM").val(code);
			$("#txtHidUom").val(code);
		}
</script>
</head>
<body>
<div id="somediv" class="container">
	<label id="formHeading">UOM Master</label>
	<s:form id="UOMMaster" name="UOMMaster" action="saveUOMMaster.html" method="POST">
		<div class="row masterTable">
			<div class="col-md-2">
				<label>UOM Name</label>
				<s:input id="txtUOM" name="txtUOM" path="strUOMName" ondblclick="funHelp('UOMmaster')" required = "true" value="" />
			</div>
		</div>
		<div class="center" style="text-align:left;">
			<a href="#"><button class="btn btn-primary center-block" id="btnSubmit" value="Submit" 
				>Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="" >Reset</button></a>
		</div>
		
	<s:input type="hidden" id="txtHidUom" path="strhidUom"></s:input>
</s:form>
</div>

<main class="main">
  <button id="random" class="button">Random value</button>
<h1 class="main__title">Gauge Chart</h1>
  
  <div class="gauge-container">
    <div class="gauge"></div>
      <!-- <div class="gauge"></div>-->
    <!-- <div class="gauge"></div>-->
  </div>
</main>

  <!--<footer class="footer">
  <p>A pen by <a href="http://brunocarvalho.me">Bruno Carvalho</a></p>
</footer>-->

<svg width="0" height="0" version="1.1" class="gradient-mask" xmlns="http://www.w3.org/2000/svg">
  <defs>
      <linearGradient id="gradientGauge" radius="50%">
        <stop class="color-red" offset="20%" radius="50%"/>
        <stop class="color-yellow" offset="17%" width="50%"/>
        <stop class="color-green" offset="40%" width="50%"/>
        <stop class="color-yellow" offset="87%" width="50%"/>
        <stop class="color-red" offset="100%" width="50%"	/>
      </linearGradient>
  </defs>  
</svg>
<!-- partial -->


</body>
</html>