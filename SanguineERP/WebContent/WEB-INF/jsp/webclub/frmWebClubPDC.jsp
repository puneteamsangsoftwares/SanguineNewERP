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
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
		
<title></title>


<script type="text/javascript">
		var fieldName,gurl,listRow=0,mastercode;
	 $(document).ready(function()
					{
		 
			
			$("#lblReceived").text(0);		 							
			$("#lblIssued").text(0);
			 
			$("#txtChkDte").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtChkDte" ).datepicker('setDate', 'today');
			$("#txtChkDte").datepicker();
			
		 	$("#txtMemCode").val('');
			$("#txtChequeNo").val('');
			$("#txtAmt").val('');
			$("#txtDrawnOn").val('');
			
			$("#txtMemCodee").val('');
			$("#txtChequeNoo").val('');
			$("#txtChkDtee").val('');
			$("#txtAmtt").val('');
			$("#txtDrawnOnn").val('');
			$("#txtChkDte").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtChkDte").datepicker('setDate', 'today');
			$("#txtChkDtee").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtChkDtee").datepicker('setDate', 'today');
		    $(".tab_content").hide();
			$(".tab_content:first").show();
			
			$("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
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
				alert("Data Save successfully\n");
			<%
			}}%>
		});
	
	 
	 $(function()
     		{		
     				
     				$('#baseUrl').click(function() 
     		     			{  
     		     				/*  if($("#txtBankCode").val().trim()=="")
     		     				{
     		     					alert("Please Enter Bank Code");
     		     					return false;
     		     				} 
     		     				window.open('attachDoc.html?transName=frmWebClubBankMaster.jsp&formName=Bank Information&code='+$('#txtBankCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
     		     			 */
     				
     				
     				 if($("#t1")[0].className=='active')
     					{
     						if($("#txtMemCode").val().trim()=="")
	     					{
	         					alert("Please Enter Recieved Member Code");
	         					return false;
	         				} 
	         				window.open('attachDoc.html?transName=frmWebClubPDC.jsp&formName=Post Dated Cheque(PDC)&code='+$('#txtMemCode').val()+' 01R',"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");	         			
     					}
     				else
     					{
     						if($("#txtMemCodee").val().trim()=="")
	     					{
	         					alert("Please Enter Issued Member Code");
	         					return false;
	         				} 
	         				window.open('attachDoc.html?transName=frmWebClubPDC.jsp&formName=Post Dated Cheque(PDC)&code='+$('#txtMemCodee').val()+' 01I',"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");	         			
	 					} 

     			
     		     			});
     			
     			});
     		
	 
	 
	 function btnAdd_onclickRecieved() 
		{	
			 var flag =false;
			if(($("#txtMemCode").val().trim().length == 0))
			{
					 alert("Please Enter Member Code Or Search");
		             $("#txtMemCode").focus() ; 
		             return false;
			}
			else if(($("#txtDrawnOn").val().trim().length == 0))
			{
				 alert("Please Enter Drawn On");
	             $("#txtDrawnOn").focus() ; 
	             return false;
			}
			else if(($("#txtChequeNo").val().trim().length == 0))
			{
				 alert("Please Enter Cheque No");
	             $("#txtChequeNo").focus() ; 
	             return false;
			}
			else if(($("#txtAmt").val().trim().length == 0))
			{
				 alert("Please Enter Amount");
	             $("#txtAmt").focus() ; 
	             return false;
			}
			
			/* else if(($("#txtChkDte").val().trim().length == 0))
			{
				 alert("Please Cheque Date");
	             $("#txtChkDte").focus() ; 
	             return false;
			} */
			else
		    {
				 /* if(funDuplicateProduct(txtMemCode,txtBankCode,txtChequeNo,txtChkDte,txtAmt,txtDrawnOn))
	            	{ */ 
					 	
						var totRec=0;
						var strMemCode = $("#txtMemCode").val();
						var memName = $("#lblMemName").text();
					    var chequeNo = $("#txtChequeNo").val();
					    var chequeDate = $("#txtChkDte").val();
					    var chequeAmt = $("#txtAmt").val();					    
					    var drawnOn = $("#lbldrawnOn").text();
					    totRec= parseInt($("#lblReceived").text())+parseInt(chequeAmt);
					    $("#lblReceived").text(totRec);
					    funAddRowReceived(memName,drawnOn,chequeNo,chequeDate,chequeAmt,strMemCode);
	            	//}
			}		 
			return flag;
		}	 
	  function btnAdd_onclickIssued() 
		{			
		  var flag =false;
			if(($("#txtMemCodee").val().trim().length == 0))
			{
					 alert("Please Enter Member Code Or Search");
		             $("#txtMemCodee").focus() ; 
		             return false;
			}
			else if(($("#txtDrawnOnn").val().trim().length == 0))
			{
				 alert("Please Enter Drawn On");
	             $("#txtDrawnOnn").focus() ; 
	             return false;
			}
			else if(($("#txtChequeNoo").val().trim().length == 0))
			{
				 alert("Please Enter Cheque No");
	             $("#txtChequeNoo").focus() ; 
	             return false;
			}
			else if(($("#txtAmtt").val().trim().length == 0))
			{
				 alert("Please Enter Amount");
	             $("#txtAmtt").focus() ; 
	             return false;
			}
			
			/* else if(($("#txtChkDtee").val().trim().length == 0))
			{
				 alert("Please Cheque Date");
	             $("#txtChkDtee").focus() ; 
	             return false;
			} */
			else
		    {
				var strMemCode = $("#txtMemCodee").val();
				var memName = $("#lblMemName").val();
				
				
				var strFacilityCode=$("#txtFacilityCodee").val();
				var memName = $("#lblMemNamee").text();
				var chequeNo = $("#txtChequeNoo").val();
				var chequeDate = $("#txtChkDtee").val();
				var chequeAmt = $("#txtAmtt").val();
				var drawnOn = $("#lbldrawnOnn").text();
				totRec= parseInt($("#lblIssued").text())+parseInt(chequeAmt);
			    $("#lblIssued").text(totRec);
				funAddRowIssued(memName,drawnOn,chequeNo,chequeDate,chequeAmt,strMemCode);
	            	
			}		 
			return flag;
		} 
	 
		 /*
		 * Check duplicate record in grid
		 */
		function funDuplicateProduct(strFacilityCode)
		{
		    var table = document.getElementById("tblDetails");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblDetails tr').each(function()
				    {
					    if(strFacilityCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added "+ strFacilityCode);
					    	 funResetProductFields();
		    				flag=false;
	    				}
					});
				    
		    	}
		    return flag;
		  
		}
		
		/**
		 * Adding Product Data in grid 
		 */
		function funAddRowReceived(memCode,drawnOn,chequeNo,chequeDate,chequeAmt,strMemCode) 
		{   	    	    
		    var table = document.getElementById("tblDetails");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);   
		    
		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strMemName\" value='"+memCode+"' id=\"txtMemName."+(rowCount)+"\" >";
			row.insertCell(1).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strDrawnOn\" value='"+drawnOn+"' id=\"txtBankCode."+(rowCount)+"\" >";
		    row.insertCell(2).innerHTML= "<input class=\"Box\" readonly=\"true\" type=\"text\" name=\"listPDCDtlRecieved["+(rowCount)+"].strChequeNo\" size=\"15%\" style=\"text-align: right;\" id=\"txtChequeNo."+(rowCount)+"\" value='"+chequeNo+"'/>";	
		    row.insertCell(3).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlRecieved["+(rowCount)+"].dteChequeDate\" id=\"txtChkDte."+(rowCount)+"\" value="+chequeDate+">";
		    row.insertCell(4).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlRecieved["+(rowCount)+"].dblChequeAmt\" value='"+chequeAmt+"' id=\"txtAmt."+(rowCount)+"\" >";	
		    row.insertCell(5).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strType\" value='Received' id=\"txtRecieved."+(rowCount)+"\" >";	
		    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" type=\"hidden\" class=\"Box\" name=\"listPDCDtlRecieved["+(rowCount)+"].strMemCode\" id=\"txtMemCode."+(rowCount)+"\" value='"+strMemCode+"' />";   
		    row.insertCell(7).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"1%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRowRecieved(this)\"/>";
			listRow++;		    
		    funResetProductFieldsRecieved();		   		    
		}
		
		function funAddRowIssued(memCode,drawnOn,chequeNo,chequeDate,chequeAmt,strMemCode) 
		{   	    	    
		    var table = document.getElementById("tblDetailss");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);   
		    
		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlIssued["+(rowCount)+"].strMemName\" value='"+memCode+"' id=\"txtMemName."+(rowCount)+"\" >";
			row.insertCell(1).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlIssued["+(rowCount)+"].strDrawnOn\" value='"+drawnOn+"' id=\"txtBankCode."+(rowCount)+"\" >";
		    row.insertCell(2).innerHTML= "<input class=\"Box\" readonly=\"true\" type=\"text\" name=\"listPDCDtlIssued["+(rowCount)+"].strChequeNo\" size=\"15%\" style=\"text-align: right;\" id=\"txtChequeNo."+(rowCount)+"\" value='"+chequeNo+"'/>";	
		    row.insertCell(3).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlIssued["+(rowCount)+"].dteChequeDate\" id=\"txtChkDte."+(rowCount)+"\" value="+chequeDate+">";
		    row.insertCell(4).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlIssued["+(rowCount)+"].dblChequeAmt\" value='"+chequeAmt+"' id=\"txtAmt."+(rowCount)+"\" >";	
		    row.insertCell(5).innerHTML= "<input class=\"Box\" readonly=\"true\" size=\"15%\" name=\"listPDCDtlIssued["+(rowCount)+"].strType\" value='Issued' id=\"txtRecieved."+(rowCount)+"\" >";	
		    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" type=\"hidden\" class=\"Box\" name=\"listPDCDtlIssued["+(rowCount)+"].strMemCode\" id=\"txtMemCode."+(rowCount)+"\" value='"+strMemCode+"' />";   
		    row.insertCell(7).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"1%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRowIssued(this)\"/>";
			      
		    listRow++;		    
		    funResetProductFieldsIssued();		   		    
		} 
		
		/**
		 * Delete a particular record from a grid
		 */
		function funDeleteRowRecieved(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var value = obj.parentNode.parentNode.cells[4].childNodes[0].defaultValue;		    
		    var table = document.getElementById("tblDetails");
		    index--;
		    table.deleteRow(index);
		    var temp= parseInt($("#lblReceived").text())-(parseInt(value));
		   	$("#lblReceived").text(temp);
		}
		function funDeleteRowIssued(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var value = obj.parentNode.parentNode.cells[4].childNodes[0].defaultValue;
		    var table = document.getElementById("tblDetailss");
		    index--;
		    table.deleteRow(index);
		   	var temp= parseInt($("#lblIssued").text())-(parseInt(value));
		   	$("#lblIssued").text(temp);
		  
		}
		
		/**
		 * Remove all product from grid
		 */
		/* function funRemProdRows()
	    {
			var table = document.getElementById("tblDetails");
			var rowCount = table.rows.length;
			for(var i=rowCount;i>=0;i--)
			{
				table.deleteRow(i);
			}
	    } */
		
		/**
		 * Clear textfiled after adding data in textfield
		 */
		function funResetProductFieldsRecieved()
		{
			$("#txtChequeNo").val('');
			$("#txtAmt").val('');
			$("#txtDrawnOn").val('');
			$("#lbldrawnOn").text('');
			
			//$("#txtChkDte").val('');
			
		}
		function funResetProductFieldsIssued()
		{
			$("#txtChequeNoo").val('');
			$("#txtAmtt").val('');
			$("#txtDrawnOnn").val('');
			$("#lbldrawnOnn").text('');
			//$("#txtChkDtee").val('');
		}
		
		/* function funRemoveProductRows()
		{
			var table = document.getElementById("tblDetails");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		 */
		
		
	
		
	 
	 function funHelp(transactionName)
		{	       
			fieldName=transactionName;
	    //    window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        
	    }
	 
	 function funResetField()
		{
			location.reload(true); 
		}	 
	 function funValidate()
		{
		 	flag=true;
		 	var table = document.getElementById("tblDetails");
		    var rowRecieved = table.rows.length;
		    var table = document.getElementById("tblDetailss");
		    var rowIssued = table.rows.length;				    	
		    	if($('#txtMemCode').val()==''&&$('#txtMemCodee').val()=='')
		    		{
		    			flag=false;
		    			alert("Please Enter Data");
		    		}
		 	return flag;
			
		}	
	 
	 
	 function funSetData(code)
		{
		 switch(fieldName)
		 	{
			case 'WCmemProfileCustomer' :
				funSetMemberDataReceived(code);				
				break;
				
			case 'WCmemProfileCustomerIssued' :
				funSetMemberDataIssued(code);				
				break;
				
			case 'WCBankCode' :
				funSetBankCodeRecieved(code);				
				break;
							
			case 'WCBankCodee' :
				funSetBankCodeIssued(code);				
				break;
			}
		}
	 
	function funSetBankCodeRecieved(code){		 
			var searchurl=getContextPath()+"/loadWebBookBankCode.html?bankCode="+code;
			$.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFacilityCode=='Invalid Code')
				        	{
				        		alert("Invalid Bank Code");
				        		$("#txtDrawnOn").val('');
				        	}
				        	else
				        	{		
				        		
				        		$.each(response, function(cnt,item)
					 			{ 
					        				$("#txtDrawnOn").val(code);
				        					$("#lbldrawnOn").text(response[0]);				        					        					
					 			});	
				        	}
						},
						error: function(jqXHR, exception) {
				            if (jqXHR.status === 0) {
				                alert('Not connect.n Verify Network.');
				            } else if (jqXHR.status == 404) {
				                alert('Requested page not found. [404]');
				            } else if (jqXHR.status == 500) {
				               // alert('Internal Server Error [500].');
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
	function funSetBankCodeIssued(code){		 
		var searchurl=getContextPath()+"/loadWebBookBankCode.html?bankCode="+code;
		$.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strFacilityCode=='Invalid Code')
			        	{
			        		alert("Invalid Bank Code");
			        		$("#txtDrawnOn").val('');
			        	}
			        	else
			        	{				        		
			        		$.each(response, function(cnt,item)
				 			{ 
				        				$("#txtDrawnOnn").val(code);
			        					$("#lbldrawnOnn").text(response[0]);			        					        					
				 			});	
			        	}
					},
					error: function(jqXHR, exception) {
			            if (jqXHR.status === 0) {
			                alert('Not connect.n Verify Network.');
			            } else if (jqXHR.status == 404) {
			                alert('Requested page not found. [404]');
			            } else if (jqXHR.status == 500) {
			               // alert('Internal Server Error [500].');
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
	 
	 function funSetMemberDataReceived(code){
		 
		 $("#txtFacilityCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubMemberProfileData.html?primaryCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFacilityCode=='Invalid Code')
				        	{
				        		alert("Invalid Category Code");
				        		$("#txtMemCode").val('');
				        	}
				        	else
				        	{
				        		$("#txtMemCode").val(response[0].strMemberCode.split(' ')[0]);	 
					        	$("#lblMemName").text(response[0].strFirstName);
				        	}
					        	funSetMemberTableReceived(response[0].strMemberCode);
						},
						error: function(jqXHR, exception) {
				            if (jqXHR.status === 0) {
				                alert('Not connect.n Verify Network.');
				            } else if (jqXHR.status == 404) {
				                alert('Requested page not found. [404]');
				            } else if (jqXHR.status == 500) {
				               // alert('Internal Server Error [500].');
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
	 
	 function funSetMemberTableReceived(code)
	 { 
		 var searchurl=getContextPath()+"/loadPDCMemberWiseData.html?memCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFacilityCode=='Invalid Code')
				        	{
				        		alert("Invalid Member Code");
				        		$("#txtMemCode").val('');
				        	}
				        	else
				        	{				        		
				        		var table=document.getElementById("tblDetails");
				    			var rowCount=table.rows.length;
				    			while(rowCount>0)
				    			{table.deleteRow(0);
				    			   rowCount--;
				    			}
				    			
				    			var totRecieved=0;				    			
				        		$.each(response, function(cnt,item)
					 					{
				        					//$("#txtMemCode").val(item[0]);
				        					if(item.strType=="Received")
				        						{
					        						funAddRowReceived(item.strMemName,item.strDrawnOn,item.strChequeNo,item.dteChequeDate,item.dblChequeAmt,item.strMemCode)
					        						totRecieved=totRecieved+item.dblChequeAmt; 
				        							$("#lblReceived").text(totRecieved);
				        						}		
							      		});		
				        		//$("#txtMemCode").val(code);	 					        						        	
				        	}
						},
						error: function(jqXHR, exception) {
				            if (jqXHR.status === 0) {
				                alert('Not connect.n Verify Network.');
				            } else if (jqXHR.status == 404) {
				                alert('Requested page not found. [404]');
				            } else if (jqXHR.status == 500) {
				                //alert('Internal Server Error [500].');
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
	 
	 
	 function funSetMemberDataIssued(code){
		 
		 $("#txtFacilityCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubMemberProfileData.html?primaryCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFacilityCode=='Invalid Code')
				        	{
				        		alert("Invalid Category Code");
				        		$("#txtMemCodee").val('');
				        	}
				        	else
				        	{
				        		$("#txtMemCodee").val(response[0].strMemberCode.split(' ')[0]);	 
					        	$("#lblMemNamee").text(response[0].strFirstName);
					        	funSetMemberTableIssued(response[0].strMemberCode);
				        	}
						},
						error: function(jqXHR, exception) {
				            if (jqXHR.status === 0) {
				                alert('Not connect.n Verify Network.');
				            } else if (jqXHR.status == 404) {
				                alert('Requested page not found. [404]');
				            } else if (jqXHR.status == 500) {
				               // alert('Internal Server Error [500].');
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
	 
	 function funSetMemberTableIssued(code){
		 var searchurl=getContextPath()+"/loadPDCMemberWiseData.html?memCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strFacilityCode=='Invalid Code')
			        	{
			        		alert("Invalid Member Code");
			        		$("#txtMemCodee").val('');
			        	}
			        	else
			        	{
			        		//$("#txtMemCodee").val(code);				        						        			
					    	var table=document.getElementById("tblDetailss");
					    	var rowCount=table.rows.length;
					    	while(rowCount>0)
					    	{table.deleteRow(0);
					    	   rowCount--;
					    	}			   
							 var totIssued=0;		    	
			        		$.each(response, function(cnt,item)
				 					{
			        					if(item.strType=="Issued")
			        						{
				        						funAddRowIssued(item.strMemName,item.strDrawnOn,item.strChequeNo,item.dteChequeDate,item.dblChequeAmt,item.strMemCode)
				        						totIssued=totIssued+item.dblChequeAmt; 
										    	$("#lblIssued").text(totIssued);
				        					}
							        	
						      		});		
			        		 
				        						        	
			        	}
					},
					error: function(jqXHR, exception) {
			            if (jqXHR.status === 0) {
			                alert('Not connect.n Verify Network.');
			            } else if (jqXHR.status == 404) {
			                alert('Requested page not found. [404]');
			            } else if (jqXHR.status == 500) {
			                //alert('Internal Server Error [500].');
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
	<div class="container">
		<label id="formHeading">Post Dated Cheque (PDC)</label>
			<s:form name="WebClubPDC" method="POST" action="saveWebClubPDC.html">
				<div id="tab_container">
					<ul class="tabs">
						<li class="active" data-state="tab1" id="t1">Received</li>
						<li data-state="tab2" id="t2">Issued</li>
					</ul> 
					<div id="tab1" class="tab_content">
						<div class="row transTable" style="overflow-x: hidden; overflow-y: hidden; ">
							<div class="col-md-6">
								<div class="row" style="padding-left:18px;">
									<div class="col-md-6">
										<label>&nbsp;Member Code:</label>
								          <s:input id="txtMemCode" ondblclick="funHelp('WCmemProfileCustomer');" cssClass="searchTextBox"
											readonly="true" placeholder="Member Code" type="text" path="strMemCodeRecieved"></s:input><label id="lblMemName"></label>
									</div>
					
									<div class="col-md-6">
										<label>&nbsp;Cheque No:</label>
										 <s:input id="txtChequeNo" path="strChequeNo" 
									 		placeholder="Cheque No" type="text" ></s:input><s:errors path=""></s:errors>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>&nbsp;Drawn On:</label>
								          <s:input id="txtDrawnOn" ondblclick="funHelp('WCBankCode');" cssClass="searchTextBox"
											readonly="true" placeholder="Drawn On" type="text" path="strDrawnOn"></s:input><label id="lbldrawnOn"></label>
									</div>
					
									<div class="col-md-6">
										<label>&nbsp;Cheque Date</label>
										 <s:input id="txtChkDte" path="dteChequeDate" 
									 		placeholder="Cheque Date" type="text" class="calenderTextBox"></s:input><s:errors path=""></s:errors>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row" style="padding-left:18px;">
									<div class="col-md-6">
										<label>&nbsp;Amount:</label>
								          <s:input id="txtAmt" class="decimal-places numberField" 
											placeholder="Amount" type="text" path="dblChequeAmt"></s:input><label id="lblBankCode"></label>
									</div>
									<div class="col-md-6">
									<div class="center">
										<a href="#"><button class="btn btn-primary center-block" id="btnExcecute" value="Add" onclick="return btnAdd_onclickRecieved()" class="form_button">Add</button></a>
										</div></div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
									</div>
									<div class="col-md-6"></div>
								</div>
							</div>
						</div>
						<table class="table table-striped dynamicTableContainer" style="width:93.7%;"><!--  style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;"> -->
								<thead>
									<tr>
									   	<th>Member Name</th>
									   	<th>Drawn On</th>
									    <th>Cheque No</th>
									   	<th>Cheque Date</th>
										<th>Amount</th>
										<th>Type</th>
										<th></th>	<th></th>
									  </tr>
								 </thead>
								<tbody id="tblDetails"> <!-- class="transTablex path="strTblProduct" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"> -->
									  
								</tbody>
						 </table> 
					</div>
					<div id="tab2" class="tab_content">
						<div class="row transTable">
							<div class="col-md-6">
								<div class="row" style="padding-left:18px;">
									<div class="col-md-6">
										<label>&nbsp;Member Code:</label>
								          <s:input id="txtMemCodee" ondblclick="funHelp('WCmemProfileCustomerIssued');" cssClass="searchTextBox"
											readonly="true" placeholder="Member Code" type="text" path="strMemCodeIssued"></s:input><label id="lblMemNamee"></label>
									</div>
					
									<div class="col-md-6">
										<label>&nbsp;Cheque No:</label>
										 <s:input id="txtChequeNoo" path="strChequeNo" 
									 		placeholder="Cheque No" type="text"></s:input><s:errors path=""></s:errors>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>&nbsp;Drawn On:</label>
								          <s:input id="txtDrawnOnn" ondblclick="funHelp('WCBankCodee');" cssClass="searchTextBox"
											readonly="true" placeholder="Drawn On" type="text" path="strDrawnOn"></s:input><label id="lbldrawnOnn"></label>
									</div>
					
					
									<%-- <div class="col-md-6">
										<label>Cheque Date</label>
										 <s:input id="txtChkDte" path="dteChequeDate" 
									 		placeholder="Cheque Date" type="text" class="calenderTextBox"></s:input><s:errors path=""></s:errors>
									</div> --%>
					
					
									<div class="col-md-6">
										<label>&nbsp;Cheque Date</label>
										 <s:input id="txtChkDtee" path="dteChequeDate" 
									 		placeholder="Cheque Date" type="text" class="calenderTextBox"></s:input>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row" style="padding-left:18px;">
									<div class="col-md-6">
										<label>&nbsp;Amount:</label>
								          <s:input id="txtAmtt" class="decimal-places numberField" 
											placeholder="Amount" type="text" path="dblChequeAmt"></s:input><label id="lblBankCode"></label>
									</div>
									<div class="col-md-6">
									<div class="center">
										<a href="#"><button class="btn btn-primary center-block" id="btnExcecute" value="Add" onclick="return btnAdd_onclickIssued()" class="form_button">Add</button></a>
										</div></div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
									</div>
									<div class="col-md-6"></div>
								</div>
							</div>
						</div>
						<table class="table table-striped dynamicTableContainer" style="width:93.7%;"><!--  style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;"> -->
								<thead>
									<tr>
									   	<th>Member Name</th>
									   	<th>Drawn On</th>
									    <th>Cheque No</th>
									   	<th>Cheque Date</th>
										<th>Amount</th>
										<th>Type</th>
										<th></th>	<th></th>
									  </tr>
								 </thead>
								<tbody id="tblDetailss"> <!-- class="transTablex path="strTblProduct" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"> -->
									  
								</tbody>
						 </table> 
					</div>
				</div>
				<div class="center"style="text-align:center;">
						<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidate();"
							class="form_button">Submit</button></a>
						<a href="#"><button class="btn btn-primary center-block" type="reset"
						 	value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
					</div>
									
			</s:form>
	</div>
		
</body>
</html>