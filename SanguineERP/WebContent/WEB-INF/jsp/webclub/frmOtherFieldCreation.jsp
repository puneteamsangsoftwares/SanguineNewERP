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
<script type="text/javascript">
		var fieldName,gurl,listRow=0,mastercode;
		var map1 = new Map();
	 $(document).ready(function()
		{		 dblLength
		 funLoadOtherInfoData();
		 	$("#dblLength").val(10);
			/*$(".tab_content").hide();
			$(".tab_content:first").show();
			
			 $("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();

				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			}); */
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
				alert(message);
			<%
			}}%>
		});
	
	 
	 function btnAdd_onclickOtherListFill() 
		{		
		 	var flag=false;
		 	if(($("#cmbDataType").val()== 'DATE')||($("#cmbDataType").val()== 'TIME')||($("#cmbDataType").val() == 'DATETIME')||($("#cmbDataType").val() == 'BLOB'))
			{
				if($("#dblLength").val().trim().length>0||$("#dblLength").val().trim().length==0)
					{						
						$("#dblLength").val('');
						
					}
			} 
		 	/* if(($("#cmbDataType").val()== 'DECIMAL'))
			{
				if($("#dblLength").val().trim().length>0||$("#dblLength").val().trim().length==0)
					{						
						$("#dblLength").val('10,2');						
					}
			}  */
			if(($("#txtFieldName").val().trim().length == 0))
			{
					 alert("Please Enter Field Name");
		             $("#txtFieldName").focus() ; 
		             return false;
			}	
			
			else if(!(($("#cmbDataType").val()== 'DATE')||($("#cmbDataType").val()== 'TIME')||($("#cmbDataType").val() == 'DATETIME')||($("#cmbDataType").val() == 'BLOB'))&&$("#dblLength").val()<=9)
			{									
					alert("Please Enter Minimum Length 10");
					return false;				
				
			}
			else if($("#cmbDataType").val()== 'DECIMAL'&&$("#dblLength").val()<=9)
			{										
					alert("Please Enter Minimum Length 10,2");
					//$("#dblLength").val('10,2')
					return false;			
				
			}
			else
		    {
				  if(funDuplicateProduct($("#txtFieldName").val()))
	            	{ 
						var fieldName = $("#txtFieldName").val();
					    var dataType = $("#cmbDataType").val();
					    var length = $("#dblLength").val();
					    var deefault = $("#cmbDefault").val();
					    funAddRowList(fieldName,dataType,length,deefault);
	            	}
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
		function funAddRowList(fieldName,dataType,length,deefault) 
		{   	    	    
		    var table = document.getElementById("tblDetails");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);   
		    
		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"15%\" readonly=\"true\" name=\"listTableCreation["+(rowCount)+"].strFieldName\" value='"+fieldName+"' id=\"txtFieldName."+(rowCount)+"\" >";
			row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"15%\" readonly=\"true\" name=\"listTableCreation["+(rowCount)+"].strDataType\" value='"+dataType+"' id=\"txtBankCode."+(rowCount)+"\" >";
		    row.insertCell(2).innerHTML= "<input class=\"Box\" type=\"text\" readonly=\"true\" name=\"listTableCreation["+(rowCount)+"].dblLength\" size=\"15%\" style=\"text-align: right;\" id=\"txtChequeNo."+(rowCount)+"\" value='"+length+"'/>";	
		    row.insertCell(3).innerHTML= "<input class=\"Box\" size=\"15%\" readonly=\"true\" name=\"listTableCreation["+(rowCount)+"].strDefault\" id=\"txtChkDte."+(rowCount)+"\" value="+deefault+">";
			row.insertCell(4).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"1%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRowRecieved(this)\"/>";
			   
		    listRow++;		    
		    funResetProductFields();		   		    
		}
		
		
		
		/**
		 * Delete a particular record from a grid
		 */
		function funDeleteRowRecieved(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblDetails");
		    index--;
		    value=table.parentNode.children[1].rows[index].cells[0].childNodes[0].value;
		    table.deleteRow(index);
		    

		    funDeleteRow(value)
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
		function funResetProductFields()
		{
			$("#txtFieldName").val('');
			//$("#dblLength").val('');
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
		
		 
		 function funCheckDataType()
			{	       
			 if(($("#cmbDataType").val()== 'DATE')||($("#cmbDataType").val()== 'TIME')||($("#cmbDataType").val() == 'DATETIME')||($("#cmbDataType").val() == 'BLOB'))
				{
					if($("#dblLength").val().trim().length>0||$("#dblLength").val().trim().length==0)
						{						
							$("#dblLength").val('');
							
						}
				} 
			 /* else if($("#cmbDataType").val()== 'DECIMAL')
				 {
					 $("#dblLength").val('10,2');
				 } */
			 else{
				 $("#dblLength").val(10);
			 }
		    }
		
	 
	 function funHelp(transactionName)
		{	       
			fieldName=transactionName;
	    //    window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        
	    }
	 
	 function funResetFields()
		{
			location.reload(true); 
		}	
	 
	 function funValidate()
		{
		 	var flag=true;
			var table = document.getElementById("tblDetails");
			var rowCount = table.rows.length;
			if(rowCount==0)
				{
					flag=false; 
					alert("Please Field Name");
				}
			
			/* for(var i=rowCount;i>=0;i--)
			{
				table.deleteRow(i);
				
			} */
			return flag;
		}
	 
	 
	 
	 function funSetData(code)
		{
		 switch(fieldName)
		 	{

			case 'WCmemProfileCustomer' :
				funSetMemberDataReceived(code);				
				break;				
			
			}
		}
	 
	 
	 
	 function funLoadOtherInfoData(){		 
			var searchurl=getContextPath()+"/loadOtherInfoDetails.html?";
			$.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	map1=response;
				        	for (var i in map1) {	
				        		if(i!='strMemberCode'&&i!='strClientCode')
				        			{
				        				funAddRowList(i,map1[i].split(",")[0],map1[i].split(",")[1],"NOT NULL DEFAULT ''")
				        				//funAddFieldListRow(i,map1[i])
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
	
	 
	 function funDeleteRow(code)
		{
			var searchurl=getContextPath()+"/deleteOtherInfoDetails.html?primaryCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strMemberCode=='Invalid Code')
				        	{
				        		//alert("Invalid Member Code");
				        		$("#txtMemberCode").val('');
				        	}
				        	else
				        	{  				        	
					        	alert(response);
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
				        		$("#txtFieldName").val('');
				        	}
				        	else
				        	{
				        		$("#txtFieldName").val(code);	 
					        	$("#lblMemCode").text(response[0].strFirstName);
				        	}
					        	funSetMemberTableReceived(response[0].strMemberCode);
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
				        		$("#txtFieldName").val('');
				        	}
				        	else
				        	{				        		
				        		var table=document.getElementById("tblDetails");
				    			var rowCount=table.rows.length;
				    			while(rowCount>0)
				    			{table.deleteRow(0);
				    			   rowCount--;
				    			}
				        		$.each(response, function(cnt,item)
					 					{
				        					$("#txtFieldName").val(item[0]);
				        					if(item[3]=="Received")
				        						{
				        						funAddRowList(item[0],item[1],item[2],item[5],item[4])
				        						}		
							      		});		
				        		$("#txtFieldName").val(code);	 					        						        	
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
	 
	 
	 
	 
	 function blockSpecialChar(e){
	         var k;
	        document.all ? k = e.keyCode : k = e.which;
	        return ((k > 64 && k < 91) || (k > 96 && k < 123) || k == 8);	   
	 }
	 
	 
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Other Info Master</label>
			<s:form name="WebClubPDC" method="POST" action="saveOtherFieldCreation.html">
				<div class="row masterTable"> <!--  transTable --><!-- id="tab_container"  -->
					
						<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Field Name:</label><br>
											<s:input  type="text" placeholder="Field Name" id="txtFieldName" 
												 path="strFieldName" onkeypress="return blockSpecialChar(event)"/><s:errors path=""></s:errors>
									</div>
									<div class="col-md-6">
										<label>Data Type:</label><br>
											<s:select id="cmbDataType" name="cmbDataType" path="strDataType" onclick="funCheckDataType()">
														 <option value="VARCHAR">VARCHAR</option>
														 <option value="DATE">DATE</option>
														 <!-- <option value="TIME">TIME</option>
														 <option value="INT">INT</option> -->
														 <option value="BIGINT">BIGINT</option>
														 <option value="DECIMAL">DECIMAL</option>
														 <!-- <option value="BLOB">BLOB</option>	 -->										 												 
												</s:select>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Length:</label><br>
											<s:input  type="text" placeholder="Length" id="dblLength" onclick="return funCheckDataType();"
												 path="dblLength" class="decimal-places numberField"/><s:errors path=""></s:errors>
									</div>
									<div class="col-md-6">
										<label>Default:</label><br>
											<s:select id="cmbDefault" name="cmbDefault" path="strDefault">
													 <option value="NOT&nbsp;NULL&nbsp;DEFAULT&nbsp;''">NOT NULL DEFAULT</option>
													 <!-- <option value="AUTO_INCREMENT">AUTO_INCREMENT</option>	 -->										 												 
											</s:select>
									</div>
								</div>
							</div>
							</div>
							<div class="center">
								<a href="#"><button class="btn btn-primary center-block" id="btnExcecute" value="Add" onclick="return btnAdd_onclickOtherListFill()" class="form_button">Add</button></a>
							</div>
								<table class="table table-striped dynamicTableContainer"> <!-- style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;"> -->
								<thead>
									<tr>
									   <th>Field Name</th>
									   <th>Data Type</th>
									   <th>Length</th>
									   <th>Default</th>
									   <th></th>
									  </tr>
								 </thead>
								<tbody id="tblDetails"> <!-- class="transTablex path="strTblProduct" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" -->
									  
								</tbody>
						 </table>
						<div class="center">
							<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidate()"
								class="form_button">Submit</button></a>
							<a href="#"><button class="btn btn-primary center-block" type="reset"
								value="Reset" class="form_button" onclick="funResetField()">Reset</button></a>
						</div>
			</s:form>
	</div>
</body>
</html>



	<%-- <div id="formHeading">
	<label>Other Info Master</label>
	</div>
<br/>
<br/>

	<s:form name="WebClubPDC" method="POST" action="saveOtherFieldCreation.html">

		<table class="masterTable">
			<table style="border: 0px solid black; width: 100%; height: 70%; margin-left: auto; margin-right: auto; background-color: #C0E4FF;">
				<tr>
					<td>
						<div id="tab_container" style="height: 380px">
							<table class="transTable">
									<tr>					
										<td style="width: 220px;">
											<label>Field Name</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;				
											<s:input type="text" id="txtFieldName" path="strFieldName" style="width: 150px;"  class="longTextBox" />
										</td>									
										<td ><label>Data Type</label>&nbsp;&nbsp;&nbsp;
											<s:select id="cmbDataType" name="cmbDataType" path="strDataType" cssClass="BoxW124px" onclick="funCheckDataType()">
													 <option value="VARCHAR">VARCHAR</option>
													 <option value="DATE">DATE</option>
													 <option value="TIME">TIME</option>
													 <option value="INT">INT</option>
													 <option value="BIGINT">BIGINT</option>
													 <option value="DECIMAL">DECIMAL</option>
													 <!-- <option value="BLOB">BLOB</option>	 -->										 												 
											</s:select></td>
											</td>														
									</tr>
									
									<tr>
									<td style="width: 320px;">
										<label>Length</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;										
										<s:input type="text" id="dblLength" path="dblLength" style="width: 150px;"  class="decimal-places numberField" onclick="return funCheckDataType();"/>
																											
										</td>
									</td>
									<td>
										<label>Default</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<s:select id="cmbDefault" name="cmbDefault" path="strDefault" cssClass="BoxW124px"  style="width: 150px;" >
													 <option value="NOT&nbsp;NULL&nbsp;DEFAULT&nbsp;''">NOT NULL DEFAULT ''</option>
													 <!-- <option value="AUTO_INCREMENT">AUTO_INCREMENT</option>	 -->										 												 
											</s:select></td>
										</td>									
									</tr>
									<td>
										</td>
										<td>
										</td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="button" id="btnExcecute" value="Add"  class="form_button" onclick="btnAdd_onclickOtherListFill()" />
									</td>					
								</tr>		
							</table>
							<div class="dynamicTableContainer" style="height: 300px;width: 99.80%;">
							<table
								style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#72BEFC">				
									<td style="width:6.2%;">Field Name</td>
									<td style="width:6.2%;">Data Type</td>
									<td style="width:6.2%;">Length</td>
									<td style="width:6.2%;">Default</td>
								</tr>
							</table>
							
							<div style="background-color: #C0E2FE; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblDetails"
									style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col8-center">
									<tbody>			
										<col style="width:21.4%;">	
										<col style="width:21.5%;">
										<col style="width:21.5%;">
										<col style="width:17%;">
										<col style="width:2.4%;">
									</tbody>
								</table>
							</div>
						</div>						
					
						</div>
					</td>
				</tr>
			</table>					
							
			</table>

		<p align="center">
				<input type="submit" value="Submit" class="form_button" onclick="return funValidate()"/>
				&nbsp; &nbsp; &nbsp; 
				<input type="reset" value="Reset"
					class="form_button" onclick="funResetField()" />
			</p>
			<br>
			<br>
	</s:form>
</body>
</html>
 --%>