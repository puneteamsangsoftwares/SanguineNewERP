<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 

  <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

 	
	<%-- End Default Script For Page  --%>
	
	<%-- Started Default CSS For Page  --%>

	 	
	 	<link rel="stylesheet"  href="<spring:url value="/resources/css/pagination.css"/>" />
	 	<link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 
	 
 	
 	<%-- End Default CSS For Page  --%>
 	
 	<%--  Started Script and CSS For Select Time in textBox  --%>
	
	
	<%-- End Script and CSS For Select Time in textBox  --%>
	

<title>REQUISITION</title>	
<script type="text/javascript">

/**
 * Close window after pressing ESC button 
 */
	window.onkeyup = function (event) {
		if (event.keyCode == 27) {
			window.close ();
		}
	}
</script>
<script type="text/javascript">



/**
 * Ready Function for Ajax Waiting
**/
	$(document).ready(function() 
		{
		var startDate="${startDate}";
		var arr = startDate.split("/");
		 
		var date = new Date(); 
		var month=date.getMonth()+1;
        Dat= 1 +"-"+month+"-"+date.getFullYear();
        
		$("#txtReqFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtReqFromDate" ).datepicker('setDate', Dat);
		
		$("#txtReqToDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtReqToDate" ).datepicker('setDate', 'today');
			$(document).ajaxStart(function()
		 	{
			    $("#wait").css("display","block");
		  	});
		 	
			$(document).ajaxComplete(function()
			{
			    $("#wait").css("display","none");
			});	
		});
		
	 /**
	  * Get project path
	 **/
	function getContextPath() 
	{
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}

	/**
	 * Ready Function for Initialize textField with default value
	 * And Getting session Value
	 */
	$(function() 
	{		
	    strLocFrom='<%=request.getParameter("strLocFrom") %>'
	    strLocTo='<%=request.getParameter("strLocTo") %>'  
	  //  funFillDetails(strLocFrom,strLocTo);
	
	});
	
	/**
	 * Loding pending Requisition records passing value Location from code and Location to code
	 **/
	function funFillDetails(strLocFrom,strLocTo,fromDate,toDate)
	{
		var searchUrl=getContextPath()+"/loadMISforMR.html?strLocFrom="+strLocFrom+"&strLocTo="+strLocTo+"&fromDate="+fromDate+"&toDate="+toDate;	
		//alert(searchUrl);
		$.ajax({
	 	        type: "GET",
	 	        url: searchUrl,
	 		    dataType: "json",
	 		    success: function(response)
	 		    {
	 		    	funRemRows();
			    	$.each(response, function(i,item)
	 		         {
			    		funfillGrid(response[i][0],response[i][1],response[i][2],response[i][3],response[i][4],response[i][5],response[i][6],response[i][7]);
	 		         });
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
	 * Filling Grid
	 */
	function funfillGrid(strReqCode,dtReqDate,strLocBy,strLocOn,strNarration,strAuthorise,dtReqiredDate,strSessionCode)
	{	   
	    var table = document.getElementById("tblDNDet");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
	    row.insertCell(0).innerHTML= "<input id=\"cbSel."+(rowCount)+"\" type=\"checkbox\"  />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strReqCode."+(rowCount)+"\" value='"+strReqCode+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"dtReqDate."+(rowCount)+"\" value='"+dtReqDate+"' >";
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strLocBy."+(rowCount)+"\" value='"+strLocBy+"'>";		    
	    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strLocOn."+(rowCount)+"\" value='"+strLocOn+"'>";		    
	    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strNarration."+(rowCount)+"\" value='"+strNarration+"'>";
	    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" id=\"strAuthorise."+(rowCount)+"\" value='"+strAuthorise+"'>";
	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"dtReqiredDate."+(rowCount)+"\" value='"+dtReqiredDate+"'>";
	    row.insertCell(8).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" id=\"strSessionCode."+(rowCount)+"\" value='"+strSessionCode+"'>";
	    
	}
	/**
	 * Remove all rows form grid
	 */
	function funRemRows() 
	{
		var table = document.getElementById("tblDNDet");
		var rowCount = table.rows.length-1;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	/**
	 * Get Selected Requisition Code form Grid
	 */
	function funCheckUncheck()
	{
		
		var table = document.getElementById("tblDNDet");
		var rowCount = table.rows.length;	
		
	    for (var i=1;i<rowCount;i++)
	    {
	        if(document.all("chkALL").checked==true)
	        {
	        	
	        	document.all("cbSel."+i).checked=true; 
	        }
	        else
	        {
	        	document.all("cbSel."+i).checked=false;  
	        }
	    }
		
	}
	/**
	 * Close windows and return selected requisition code in MIS form 
	 */
function btnClose_onclick()
{
    var table = document.getElementById("tblDNDet");
    var rowCount = table.rows.length;  
   var strMRCode="";
    for(no=1;no<rowCount;no++)
    {
        if(document.all("cbSel."+no).checked==true)
        	{
        		//alert(document.all("strReqCode."+no).innerHTML);
            	strMRCode=strMRCode+document.all("strReqCode."+no).value+",";
        	}
    }
    strMRCode=strMRCode.substring(strMRCode,strMRCode.length-1)
    //window.returnValue=strMRCode+"#"+document.all("cmbGroup").value+","+document.all("cmbSGroup").value
    //alert(strMRCode);
    window.returnValue=strMRCode+"#";
    window.close()
}
       function funExecute()
		{
    	   strLocFrom='<%=request.getParameter("strLocFrom") %>'
           strLocTo='<%=request.getParameter("strLocTo") %>'  
           var fromDate= $("#txtReqFromDate").val();
           var toDate= $("#txtReqToDate").val();

           funFillDetails(strLocFrom,strLocTo,fromDate,toDate);
		}
</script>
</head>
<body>
<div style="width: 100%; height: 40px; background-color: #c0c0c0;">
		<p align="center" style="padding-top: 10px;color:white;">Material Requisition Details</p>
	</div>
    <form id="form1">
        
                        <table  class="masterTable" style="width: 100%">
                           <%--  <tr>
                                <td>Group</td>
                                <td >
                                    <select id="cmbGroup" onchange="funFillSubGroup()" >
                                        <option selected="selected" value="ALL">ALL</option>
                                    </select>
                                </td>
                                <td >
                                    Sub Group</td>
                                <td >
                                    <label id="lblWODate"></label>
                                    <select id="cmbSGroup">
                                        <option selected="selected" value="ALL">ALL</option>
                                    </select></td>
                            </tr> --%>
                            <tr>
                            <td>
							<div class="">
								<label>from Date</label>.
								<input id="txtReqFromDate" name="txtReqFromDate" type="text" required="required"  pattern="\d{1,2}-\d{1,2}-\d{4}" 
										 cssClass="calenderTextBox" style="width:80%;"/>
								
							</div>
                            </td>
                            <td>
                            
								<div class="">
									<!-- <td><label>MIS Date:</label></td> -->
									<label>To Date</label>
							<input id="txtReqToDate" name="txtReqToDate" type="text" required="required"  pattern="\d{1,2}-\d{1,2}-\d{4}" 
											 cssClass="calenderTextBox" style="width:80%;"/>
								</div>
                            </td> 
                            
                             <td>
                              		 	<button type="button" class="btn btn-primary center-block" id="btnExecute" onclick="funExecute()" value="EXECUTE">Execute</button>
                              
                             </td>
                            </tr>
                           
                        </table>
                   
                   
                       <div
				style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 450px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
						 <table id="tblDNDet"  class="masterTable" style="width: 100%;border-collapse: separate; ">
                            <tbody>
                             <tr bgcolor="#c0c0c0">
                                <td width="20px">Select<input type="checkbox" id="chkALL" onclick="funCheckUncheck()" />
								<td width="8%">MR Code</td>				
								<td width="10%">Date</td>
			                    <td width="20%">Loc By</td> 
			                    <td width="20%">Loc On</td>
			                    <td width="20%">Narration</td> 
			                    <td width="5%">Authorise</td>  
			                    <td width="10%">Required Date</td>      
					            <td width="10%">Session</td>         
                              </tr>
                            </tbody>
                        </table>
                        </div>
                   <br>
                   <div style="text-align:center;">
                      <input id="btnClose" type="Button" class="btn btn-primary center-block" class="form_button" value="Close" onclick="return btnClose_onclick()" style="padding:7px;"/>                                      
                   </div>
       <div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
    </form>
</body>
</html>