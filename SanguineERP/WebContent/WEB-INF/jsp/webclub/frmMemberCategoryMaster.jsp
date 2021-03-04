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
<style>
	 
.center {
	text-align: right;
    padding-top: 25px;
}	
.btn{
margin:0px;}

</style>

<script type="text/javascript">
		var fieldName,gurl,listRow=0,mastercode;
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
	
	 
	 function btnAdd_onclick() 
		{	
		 	var flag=false;
			if(($("#txtFacilityCode").val().trim().length == 0) )
	        {
				 alert("Please Enter Product Code Or Search");
	             $("#txtFacilityCode").focus() ; 
	             return false;
	        }						 		     	 
			else
		    {
				var strFacilityCode=$("#txtFacilityCode").val();
				if(funDuplicateProduct(strFacilityCode))
	            	{
						var facilityCode = $("#txtFacilityCode").val();
					    var facilityName = $("#txtFacilityName").val();
					    var OperationalNY;
					   
					    if($("#txtOperationalNY")[0].checked)
				    		{
				    			OperationalNY='Y';
				    		} 
					    else
					    	{
					    		OperationalNY='N';
					    	}
					    
					    
					    //var OperationalNY2=  !($('#txtOperationalNY').is(':checked'));   //false
					    
					  
						funAddRow(facilityCode,facilityName,OperationalNY);
	            	}
			}	
			return flag;
		}	 
	 
		 /*
		 * Check duplicate record in grid
		 */
		function funDuplicateProduct(strFacilityCode)
		{
		    var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblProduct tr').each(function()
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
		function funAddRow(facilityCode,facilityName,OperationalNY) 
		{   	    	    
		    var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);   
		    
		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"8%\" name=\"listFacilityDtl["+(rowCount)+"].strFacilityCode\" id=\"txtFacilityCode."+(rowCount)+"\" value="+facilityCode+">";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"55%\" name=\"listFacilityDtl["+(rowCount)+"].strFacilityName\" value='"+facilityName+"' id=\"txtFacilityName."+(rowCount)+"\" >";
		    row.insertCell(2).innerHTML= "<input class=\"Box\" type=\"text\" name=\"listFacilityDtl["+(rowCount)+"].strOperationalNY\" size=\"9%\" style=\"text-align: right;\" id=\"txtOperationalNY."+(rowCount)+"\" value='"+OperationalNY+"'/>";	
		    row.insertCell(3).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"5%\" value = \"Delete\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
			   
		    listRow++;		    
		    funResetProductFields();		   		    
		}
		
		
		/**
		 * Delete a particular record from a grid
		 */
		function funDeleteRow(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblProduct");
		    index--;
		    table.deleteRow(index);
		}
		
		/**
		 * Remove all product from grid
		 */
		function funRemProdRows()
	    {
			var table = document.getElementById("tblProduct");
			var rowCount = table.rows.length;
			for(var i=rowCount;i>=0;i--)
			{
				table.deleteRow(i);
			}
	    }
		

		/**
		 * Clear textfiled after adding data in textfield
		 */
		function funResetProductFields()
		{
			$("#txtFacilityCode").val('');
			$("#txtFacilityName").val('');
			//$("#txtOperationalNY").val('');
		}
		
		function funRemoveProductRows()
		{
			var table = document.getElementById("tblProduct");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		
		
	
		
	 function funHelp(transactionName)
		{	       
			fieldName=transactionName;
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       
	    }
	 
	 function funResetFields()
		{
			location.reload(true); 
		}	 
	 
	 function funSetData(code)
		{
		 switch(fieldName)
		 	{

			case 'WCFacilityMaster' :
				funSetFacilityData(code);				
				break;
				
			case 'WCCatMaster' :				
				funSetMemberCategoryData(code);
				funSetFacilityMasterListData();
				//funSetFacilityMasterListData(code);
				break;
			}
		}
	 function funSetMemberCategoryData(code){		 
			$("#txtCatCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubMemberCategoryMaster.html?catCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strGCode=='Invalid Code')
				        	{
				        		alert("Invalid Category Code");
				        		$("#txtCatCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtCatCode").val(code);
					        	mastercode=$("#txtCatCode").val(code);
					        	$("#txtMCName").val(response.strCatName);
					        	$("#txtGroupCategoryCode").val(response.strGroupCategoryCode);
					        	$("#txtTenure").val(response.strTenure);
					        	$("#cmbVotingRight").val(response.strVotingRights);
					        	$("#txtRCode").val(response.strRuleCode);  	
					        	$("#txtCreditLimit").val(response.intCreditLimit);
					        	$("#txtRemarks").val(response.strRemarks);
					        	$("#txtCreditAmt").val(response.dblCreditAmt);
					        	$("#txtDiscountAmt").val(response.dblDisAmt);
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
	 
	 
	 function funSetFacilityData(code){
		 
			$("#txtFacilityCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubFacilityMaster.html?catCode="+code;
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
				        		$("#txtFacilityCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtFacilityCode").val(code);
					        	mastercode=$("#txtFacilityCode").val(code);
					        	$("#txtFacilityName").val(response.strFacilityName);
					        	if(response.strOperationalNY=='Y')
					        	{
					        		$('#txtOperationalNY').prop('checked', true);
					        	}
					        	else
					        	{
					        		$('#txtOperationalNY').prop('checked', false);
					        		
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
	 
	 
	 function funSetFacilityMasterListData(){
		 	funRemoveProductRows();
			var catCode=$("#txtCatCode").val();
			var searchurl=getContextPath()+"/loadWebClubFacilityMasterListDtl.html?catCode="+catCode;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	
				        	$.each(response, function(cnt,item)
		 					{
					        	funAddRow(item[1],item[2],item[3])
					        	//alert(response);
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
</script>



</head>
<body>
	<div class="container">
		<label id="formHeading">Member Category Master</label>
		<s:form name="frmMemberCategoryMaster" action="saveWebClubMemberCategoryMaster.html?saddr=${urlHits}" method="POST">
			<div id="tab_container">
				<ul class="tabs">
					<li class="active" data-state="tab1">Member Category</li>
					<li data-state="tab2" >Facility Master</li>
				</ul> 
				<div id="tab1" class="tab_content">
						<div class="row transTable">
							<div class="col-md-6">
								<label>Member Category Code:</label>
									<div class="row">
										<div class="col-md-6"><s:input id="txtCatCode" ondblclick="funHelp('WCCatMaster')" cssClass="searchTextBox"
											readonly="true" placeholder="Member Category Code" type="text" path="strCatCode"></s:input>
										</div>
					
										<div class="col-md-6"><s:input id="txtMCName" name="txtMCName" path="strCatName" required="true"
									 		placeholder="Enter Member Category Name" type="text"></s:input><s:errors path=""></s:errors>
										</div>
									</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Member Group Category Code:</label>
											<s:input id="txtGroupCategoryCode" path="strGroupCategoryCode" 
							 					placeholder="Enter Member Group Category Code" type="text" ondblclick="" readonly="true"></s:input>
									</div>
									<div class="col-md-6">
										<label>Tenure:</label>
											<s:input id="txtTenure" name="txtTenure" path="strTenure" required="true"
							 				placeholder="Tenure" type="text"></s:input>&nbsp;&nbsp;&nbsp;
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Rule Code:</label>
											<s:input id="txtRCode" path="strRuleCode" 
							 					placeholder="Rule Code" type="text" cssClass="searchTextBox" ondblclick="" readonly="true"></s:input>
									</div>
									<div class="col-md-6">
										<label>Credit Limit:</label>
											<s:input id="txtCreditLimit" name="txtTenure" path="intCreditLimit" required="required"
							 				placeholder="Tenure" class="decimal-places numberField" type="text"></s:input>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Voting Rights:</label>
											<s:select id="cmbVotingRight" name="cmbVotingRight" path="strVotingRights" cssClass="BoxW124px">
												<option value="N">No</option>
												<option value="Y">Yes</option>
											</s:select>
									</div>
									<div class="col-md-6">
										<label>Remark:</label><br>
											<s:textarea path="strRemarks" id="txtRemarks"/>
									</div>
								</div>
							</div>
							<div class="col-md-6">
								<div class="row">
									<div class="col-md-6">
										<label>Credit Amount:</label>
											<s:input id="txtCreditAmt" path="dblCreditAmt" required="required"
							 				placeholder="Credit Amount" class="decimal-places numberField" type="text"></s:input>
									</div>
									<div class="col-md-6">
										<label>Discount Amount:</label>
											<s:input id="txtDiscountAmt" path="dblDisAmt" required="required"
							 				placeholder="Credit Amount" class="decimal-places numberField" type="text"></s:input>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div id="tab2" class="tab_content">
						<div class="row transTable">
							<div class="col-md-6">
									<div class="row">
										<div class="col-md-6">
											<label>Facility Code</label><br>
										<s:input id="txtFacilityCode" required="" ondblclick="funHelp('WCFacilityMaster')" cssClass="searchTextBox"
											readonly="true" placeholder="Facility Code" type="text" path="strFacilityCode"></s:input>
										</div>
					
										<div class="col-md-6">
										<label>Facility Name</label><br><s:input id="txtFacilityName" path="strFacilityName" required="" readonly="true"
									 		placeholder="Enter Facility Name" type="text"></s:input><s:errors path=""></s:errors>
										</div>
									</div>
							</div>
							<div class="col-md-6">
									<div class="row">
									
									<div class="col-md-4">
										<label>Operational:</label><br>
										<s:checkbox id="txtOperationalNY" path="strOperationalNY" value="Y" checked="true" />
									</div>
									
										<%-- <div class="col-md-6">
											<label>Operational</label>
										<s:input id="txtOperationalNY" 
											placeholder="Operational" type="text" path="strOperationalNY" readonly="true"></s:input>
										</div> --%>
					
										<div class="col-md-6">
										<div class="center">
										<a href="#"><button class="btn btn-primary center-block" id="btnAdd" value="Add" onclick="return btnAdd_onclick()" class="form_button">Add</button></a>
										</div>
										</div>
									</div>
							</div>
						</div>
						  <table class="table table-striped dynamicTableContainer"> <!-- style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;"> -->
								<thead>
									<tr>
									   <th>Facility Code</th>
									   <th>Facility Name</th>
									    <th>Operational</th>
									    <th>Delete</th>
									  </tr>
								 </thead>
								<tbody id="tblProduct"> <!-- class="transTablex path="strTblProduct" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" -->
									  
								</tbody>
						 </table> 
					</div>
					</div>
					<div class="center"style="text-align:center;">
						<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
							class="form_button">Submit</button></a>
						<a href="#"><button class="btn btn-primary center-block" type="reset"
						 	value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
					</div>
			
		</s:form>
</div>
</body>
</html>