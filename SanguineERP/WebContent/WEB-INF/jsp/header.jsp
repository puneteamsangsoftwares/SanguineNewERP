
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    
   	<%-- Started Default Script For Page  --%><%-- 
    	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script> --%>
		
		<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
		<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/TreeMenu.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/main.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.fancytree.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.numeric.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.ui-jalert.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.excelexport.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/hindiTyping.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/checkNetworkConnection.js"/>"></script>
	
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 	
	<%-- End Default Script For Page  --%>
	
	<%-- Started Default CSS For Page  --%>

	    <link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" sizes="16x16">
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/materialdesignicons.min.css"/>" />
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/tree.css"/>" /> 
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery-ui.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/main.css"/>" />
	 	
	 	
	 	<link rel="stylesheet"  href="<spring:url value="/resources/css/pagination.css"/>" />
	 	<link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 
	 
 	
 	<%-- End Default CSS For Page  --%>
 	
 	<%--  Started Script and CSS For Select Time in textBox  --%>
	
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery.timepicker.min.js"/>"></script>
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery.timepicker.css"/>" />
	
	<%-- End Script and CSS For Select Time in textBox  --%>
	
 	  
  	<title>Web Stocks</title>
	
	<script type="text/javascript">
		var maxQuantityDecimalPlaceLimit=parseInt('<%=session.getAttribute("qtyDecPlace").toString()%>');
		var maxAmountDecimalPlaceLimit=parseInt('<%=session.getAttribute("amtDecPlace").toString()%>');
   		function getContextPath() 
   	{
	  	return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
   
   	
   		var debugFlag = false;
   		function debug(value)
   	{
   		if(debugFlag)
   		{
   			alert(value);
   		}   		
   	} 
   	
    $(document).ready(function(){
    
    	var strIndustryType='<%=session.getAttribute("strIndustryType").toString()%>';
   		//alert("Upper");
   		switch(strIndustryType) 
   		{
   		
   		case 'Manufacture' :
   						document.getElementById("pageTop").className = "pagetopMenufactureing";
   			break;
   			
   		case 'Hospitality' :	
   						document.getElementById("pageTop").className = "pagetop";
   			break;

   		case 'Retailing' :
   						document.getElementById("pageTop").className = "pagetopMenufactureing";
   				break;
   			
   		case 'MilkFederation' :
   						document.getElementById("pageTop").className = "pagetopMenufactureing";
				break;//headerimageMilkFederation
   			
   		default :
   			document.getElementById("pageTop").className = "pagetop";
   			break;
   		}
   		
   		
   			var strModule='<%=session.getAttribute("selectedModuleName").toString()%>';
   			if(strModule!=null){
   			
   				switch(strModule)
   				{
   	   			case '1-WebStocks' :
   	   				document.getElementById("one").innerHTML = "WebStocks";
   						break;
   	   			case '2-WebExcise' :
   	   				document.getElementById("one").innerHTML = "WebExcise";
   				break;
   	   			case '3-WebPMS' :
   	   				document.getElementById("one").innerHTML = "WebPMS";
   	   				
   				break;
   	   			case '6-WebCRM' :
   	   				document.getElementById("one").innerHTML = "WebCRM";
   				break;
   	   			case '4-WebClub' :
   	   			document.getElementById("one").innerHTML = "WebClub";
   				break;
   	   			case '5-WebBook' :
   	   				document.getElementById("one").innerHTML = "WebBook";
   				break;
   				
   	   			case '5-WebBookAR' :
	   				document.getElementById("one").innerHTML = "WebBooks";
				break;
   				
   	   			case '7-WebBanquet' :
   	   				document.getElementById("one").innerHTML = "Web Banquet";
   				break;
   						
   				default :
   					document.getElementById("pageTop").className = "pagetopMenufactureing";
   	   			}

   			}
       
   });
   	
   	
	</script>
<script  type="text/JavaScript">
document.onkeypress = stopRKey;
function stopRKey(evt) {
              var evt = (evt) ? evt : ((event) ? event : null);
              var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
              if (evt.keyCode == 13)  {
                           //disable form submission
                           return false;
              }
}
</script>
<!-- code for banner -->
<script type="text/javascript">

//var resFormName="";

var NotificationTimeinterval=parseInt('<%=session.getAttribute("NotificationTimeinterval").toString()%>');
var chkNetwork=1;
var NotificationCount="";
$(document).ready(function(){
	//window.location.href=getContextPath()+"/loadPendingRequisition.html";
   		$("#MainDiv").hide();
   		
   		<%if(session.getAttribute("selectedModuleName").toString().equalsIgnoreCase("1-WebStocks")){%>
   			funGetNotification();
   		<%}%>
   		
   		<%if(session.getAttribute("selectedModuleName").toString().equalsIgnoreCase("3-WebPMS")){%>
   		funGetPMSNotification();
		<%}%>
   		
   	    $("#notification").click(function(){
   	        $("#MainDiv").fadeToggle();
   	    });
   	    
   	});
   	
<%if(session.getAttribute("selectedModuleName").toString().equalsIgnoreCase("1-WebStocks")){%>
 	NotificationTimeinterval=parseInt(NotificationTimeinterval)*60000;
 	setInterval(function(){funGetNotification()},NotificationTimeinterval);
 	
 	
<%}%>

<%if(session.getAttribute("selectedModuleName").toString().equalsIgnoreCase("3-WebPMS")){%>
	NotificationTimeinterval=parseInt(NotificationTimeinterval)*60000;
	setInterval(function(){funGetPMSNotification()},NotificationTimeinterval);
	
	
<%}%>
//     NetworkcheckTimeinterval=parseInt(30)*100;
// 	setInterval(function(){funCheckNetworkConnection()},NetworkcheckTimeinterval);
   	
	
function funGetNotification()
{
	var searchUrl=getContextPath()+"/getNotification.html";
	$.ajax({
        type: "GET",
        url: searchUrl,
        dataType: "json",
        success: function(response)
        {
        	funRemoveNotification();
        	var count=0;
        	$.each(response, function(i,item)
        	        {
        				count=i;
        				funfillNotificationRow(response[i].strReqCode,response[i].Locationby,response[i].strNarration,
        						response[i].strUserCreated,response[i].FormName,response[i].strLocOn);
        	        });
        	if(response.length>0)
        		{
        			NotificationCount=count+1;	
        		}
        	
        	$("#lblNotifyCount").text(NotificationCount);
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

function funGetPMSNotification()
{
	var searchUrl=getContextPath()+"/getPMSNotification.html";
	$.ajax({
        type: "GET",
        url: searchUrl,
        dataType: "json",
        success: function(response)
        {
        	funRemoveNotification();
        	var count=0;
        	$.each(response, function(i,item)
        	        {
        				count=i;
        				funfillPMSNotificationRow(response[i][0],response[i][1],response[i][2],response[i][3]);
        	        });
        	if(response.length>0)
        		{
        			NotificationCount=count+1;	
        		}
        	
        	$("#lblNotifyCount").text(NotificationCount);
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

function funfillNotificationRow(docCode,locationby,narration,userCreated,formName,strLocOn) 
{
    var table = document.getElementById("tblNotify");
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
    
    //row.insertCell(0).innerHTML= "<label>"+strReqCode+"</label>";
    row.insertCell(0).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\" onClick=\"funClick('"+formName+"','"+docCode+"','"+strLocOn+"');\" value='"+docCode+"'>";
 	row.insertCell(1).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\"  value='"+locationby+"'>";
 	row.insertCell(2).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\"  value='"+narration+"'>";
    row.insertCell(3).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\"  value='"+userCreated+"'>";
}

function funfillPMSNotificationRow(reservationNO,name,arivalDate,formName) 
{
    var table = document.getElementById("tblNotify");
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
    
    //row.insertCell(0).innerHTML= "<label>"+strReqCode+"</label>";
    row.insertCell(0).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\" onClick=\"funClick('"+formName+"','"+reservationNO+"','');\" value='"+reservationNO+"'>";
 	row.insertCell(1).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"54%\"  value='"+name+"'>";
 	row.insertCell(2).innerHTML= "<input class=\"Box\" readonly = \"readonly\" size=\"24%\"  value='"+arivalDate+"'>";
}


function funRemoveNotification()
{
	 $("#tblNotify").find("tr:gt(0)").remove();
}


	function funClick(formName,docCode,strLocOn,locationby)
	{
		switch (formName)
		{
			case "PurchaseOrder":
				window.open("loadPIDataFromNotification.html?PICode="+docCode, "myhelp", "scrollbars=1,width=500,height=350");
				break;
				
				
				
			case "MIS":
				window.open("loadMISDataFromNotification.html?strMRCode="+docCode+"&strLocOn="+strLocOn, "myhelp", "scrollbars=1,width=500,height=350");
				break;
				
			case "Reorder Level" :
				window.open("rptReorderLevelFromNotification.html?locCode="+locationby, '_blank').focus();
				break;
			
			case "Authorization" :
				window.open("frmAuthorisationTool.html");
				break;
				
			case "frmReservation" :
				window.open("frmCheckIn.html");
				break;
		}
		
	}
	

	

function funHelpWindow(formName)
{
	var returnVal ="";
	
	
	//window.showModalDialog(getContextPath()+"/resources/jsp/WEB-INF/frmHelpModulWindow.jsp","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	//window.open(getContextPath()+"/WebRoot/WEB-INF/jsp/frmHelpModuleWindow","_blank");
	switch (formName)
	{
		case  "frmMIS" :
		
		//window.open('frmWebStockHelpMaterialIssueSlip.html',"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=900,height=400,left=400px");
		//returnVal=window.showModalDialog("frmWebStockHelpMaterialIssueSlip.html","","dialogHeight:600px;dialogWidth:500px;dialogLeft:350px;dialogTop:100px");
		window.open("frmWebStockHelpMaterialIssueSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
		
		break;	
	
	
		case  "frmMaterialReq" :
			window.open("frmWebStockHelpMaterialRequisition.html", "myhelp", "scrollbars=1,width=500,height=350");
		
		//window.open('frmWebStockHelpMaterialIssueSlip.html',"mywindow","directories=yes,titlebar=yes,toolbar=yes,location=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=900,height=400,left=400px");
		//returnVal=window.showModalDialog("frmWebStockHelpMaterialIssueSlip.html","","dialogHeight:600px;dialogWidth:500px;dialogLeft:350px;dialogTop:100px");
		break;
		
		case "frmMaterialReturn":
			window.open("frmWebStockHelpMaterialReturn.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
				
		case "frmOpeningStock":
			window.open("frmWebStockHelpOpeningStock.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
		
		case "frmPhysicalStkPosting":
			window.open("frmWebStockHelpPhysicalStockPosting.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
		case "frmPurchaseIndent":
			window.open("frmWebStockHelpPurchaseIndent.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
				
		case "frmPurchaseOrder":
			window.open("frmWebStockHelpPurchaseOrder.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
		case "frmStockAdjustment":
			window.open("frmWebStockHelpStockAdjustment.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
					
		case "frmStockTransfer":
			window.open("frmWebStockHelpStockTransfer.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
		case "frmBillPassing":
			window.open("frmWebStockHelpBillPassing.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;

	 	case "frmWebStockHelpGRN":
			window.open("frmWebStockHelpGRN.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
	 	case "frmWebStockHelpGRNSlip":
			window.open("frmWebStockHelpGRNSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
	 	case "frmWebStockHelpMaterialReturnSlip":
			window.open("frmWebStockHelpMaterialReturnSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
	 	case "frmWebStockHelpMealPlanning":
			window.open("frmWebStockHelpMealPlanning.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
			
	 	case "frmWebStockHelpProductList":
			window.open("frmWebStockHelpProductList.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;	
			
	 	case "frmWebStockHelpProductWiseSupplierWise":
			window.open("frmWebStockHelpProductWiseSupplierWise.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;	
			
	 	case "frmWebStockHelpPurchaseOrderSlip":
			window.open("frmWebStockHelpPurchaseOrderSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;		
		
	 	case "frmWebStockHelpPurchaseReturn":
			window.open("frmWebStockHelpPurchaseReturn.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;	

	 	case "frmWebStockHelpPurchaseReturnSlip":
	 		window.open("frmWebStockHelpPurchaseReturnSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
		case "frmWebStockHelpRateContract":
			window.open("frmWebStockHelpRateContract.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
		case "frmWebStockHelpRequisitionSlip":
			window.open("frmWebStockHelpRequisitionSlip.html", "myhelp", "scrollbars=1,width=500,height=350");
			break;
	
			
			
// 		case "":
// 			window.open(".html", "myhelp", "scrollbars=1,width=500,height=350");
// 			break;
 	
	}
	
	
	
	
	
}


// function funcheck()
// {
// 	//getContextPath();
// 	//var formname = document.getElementById("lblFormHeadingName").innerHTML;
// 	funHelpWindow(formname);
// 	//alert("Help coming soon"+formname);
	
// }

function getContextPath() 
{
	return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
}


function funGetFormName(){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/getFormName.html",
		success : function(response){ 

			if(response=='Invalid Code')
        	{
        		alert("Invalid FormName");
        		
        	}
        	else
        	{      
        		//resFormName=response;
        		funHelpWindow(response)
        		
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
/* $(function()
{			
	$('#baseUrl').click(function() 
	{  
		 if($("#txtMemberCode").val().trim()=="")
		{
			alert("Please Enter Member Code");
			return false;
		} 
		window.open('attachDoc.html?transName=frmMemberProfile.jsp&formName=Member Profile&code='+$('#txtMemberCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	});
}); */

	$(document).ready(function()
	{
		var strModule='<%=session.getAttribute("selectedModuleName").toString()%>';
		if(strModule=='3-WebPMS')
		{
			 var pmsDate='<%=session.getAttribute("PMSDate")%>';
			  
			  if(null!=pmsDate)
		 	  {
			 	  var dte=pmsDate.split("-");
				  $("#txtPMSHeaderDate").val(dte[0]+"-"+dte[1]+"-"+dte[2]); 	
			  } 
		}
		else
		{
			document.getElementById('lblPMSDate').style.display = 'none'
		}	
		 
	});   
	  

</script>

<style>
  #tblNotify tr:hover{
	background-color: #c0c0c0;;
	
}
</style>
	
  	</head>
		<body>
			<div id="pageTop"> 	
	 			<header class="app-header">
      				<nav class="app-nav">
        				<div class="left-menu">
         			 		 <div class="navaction app-header-main">
            					<a href="#" id="one">Web Stocks</a>
         			 		</div>
          					<div class="navaction app-header-sub">
           			 			<p class="para"><img src="../${pageContext.request.contextPath}/resources/images/DSS_logo.png" alt="img" style="max-width:180px; height: 50px; padding-left:5px"><span style=" padding-left:16px; font-size:16px; font-weight: 600; color: #4a4a4a;">
           			 			${companyName}</span> &nbsp; &nbsp;- &nbsp; ${propertyName} &nbsp;- ${financialYear}
           			 			<label style="margin-left: 113px;color: black;font-weight: bold;" id="lblPMSDate">PMS Date</label>&nbsp; &nbsp;<input id="txtPMSHeaderDate" style="width: 90px;font-weight: bold;" readonly="readonly" class="longTextBox"/> 
           			 		    <th style="width: 34%;"></th> 
           			 			</p>
           			 		
         		 			</div> 
        				</div>
        				<div class="right-menu" id="page_top_banner">
          					<ul>
          					 	<li><a href="frmHome.html" class="mdi mdi-home-outline menu-link"  title="HOME"></a></li>
          						<li><a href="#" class="mdi  mdi-paperclip menu-link" id="baseUrl" title="Attched document"></a></li>
					            <li><a href="#" class="mdi mdi-information-outline menu-link" id="notification" title="Notification"></a></li>
					          	<label id="lblNotifyCount" style="color:red;padding-top:2px"></label>
					            <!-- <div style=" background-color: #f13c0d;text-align: center;height:25px;;width: 15px;margin-top: 12px;">
								<label id="lblNotifyCount" style="color:#fff;padding-top:2px"></label>
								</div> -->
					            <li><a href="#" class="mdi mdi-crosshairs-question menu-link"onclick="funGetFormName()" title="HELP"></a></li>
					            <li><a href="frmPropertySelection.html" class="mdi mdi-tumblr-reblog menu-link" title="Change Property"></a></li>
					            <li><a href="frmChangeModuleSelection.html" class="mdi mdi-rotate-left-variant menu-link" title="Change Module"></a></li>
					            <li><a href="logout.html" class="mdi mdi-power-standby menu-link" title="LOGOUT"></a></li>

					         </ul>
					      </div>
					      <div id="MainDiv" style="background-color: #FFFFFF; border: 1px solid #ccc; height: 238px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 30%;
							 		position: absolute; z-index: 1; right: 3.5%; top: 10.5%;">
				
							<table id="tblNotify"
								style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll;"
								class="transTablex">
								<tbody id="tbodyNotifyid">
								<tr><td colspan="4">Notifications</td></tr>
								
								<%-- <c:forEach items="${Notifcation}" var="draw1" varStatus="status1">
								<tr>
								<td>${draw1.strReqCode}</td>
								<td>${draw1.dtReqDate}</td>
								<td>${draw1.Locationby}</td>
								<td>${draw1.LocationOn}</td>
							</tr>
								</c:forEach> --%>
						</tbody>
						</table>
					</div>
			</nav>  
	</header>
	</div>
	<%-- <script>
		window.onscroll = function() {myFunction()};
		
		var header = document.getElementById("pageTop");
		var sticky = header.offsetTop;
		
		function myFunction() {
		  if (window.pageYOffset > sticky) {
		    header.classList.add("sticky");
		  } else {
		    header.classList.remove("sticky");
		  }
		}
		</script> --%>
		</body>
</html>