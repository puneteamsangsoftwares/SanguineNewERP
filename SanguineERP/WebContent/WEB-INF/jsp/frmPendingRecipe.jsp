<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
 <style> 
 .transTable td {
    padding-left: 33px;
 }
 </style>
</head>
<script type="text/javascript">

$(function() 
		{
			
			
			funGetSubGroupData();
		});
function funHelp(transactionName)
{
	fieldName=transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
}

function funSetData(code)
{
	switch (fieldName) 
	{
	    case 'locationmaster':
	    	funSetLocation(code);
	        break;
	}
}

/**
 * Ready Function for Searching in Table
 */
$(document).ready(function()
		{
	var tablename='';
			
			$('#searchSGrp').keyup(function()
	    			{
						tablename='#tblSubGroup';
	    				searchTable($(this).val(),tablename);
	    			});
		});
		
/**
 * Function for Searching in Table Passing value(inputvalue and Table Id) 
 */
function searchTable(inputVal,tablename)
{
	var table = $(tablename);
	table.find('tr').each(function(index, row)
	{
		var allCells = $(row).find('td');
		if(allCells.length > 0)
		{
			var found = false;
			allCells.each(function(index, td)
			{
				var regExp = new RegExp(inputVal, 'i');
				if(regExp.test($(td).find('input').val()))
				{
					found = true;
					return false;
				}
			});
			if(found == true)$(row).show();else $(row).hide();
		}
	});
}




	


//Geting SubGroup Data On the basis of Selection Group
function funGetSubGroupData()
{
	
	var count=0;
	
	
		var searchUrl = getContextPath() + "/loadAllSubGroup.html";
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			success : function(response)
			{
				$.each(response, function(key, value) {
					funfillSubGroup(key,value);
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

//Fill SubGroup Data
function funfillSubGroup(strSGCode,strSGName) 
{
	var table = document.getElementById("tblSubGroup");
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);
    
    row.insertCell(0).innerHTML= "<input id=\"cbSGSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"SubGroupthemes\" value='"+strSGCode+"' class=\"SGCheckBoxClass\" />";
    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSGCode."+(rowCount)+"\" value='"+strSGCode+"' >";
    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"48%\" id=\"strSGName."+(rowCount)+"\" value='"+strSGName+"' >";
}

//Submit Data after clicking Submit Button with validation 
function btnSubmit_Onclick()
 {
	 var strSGCode="";
	 
	 $('input[name="SubGroupthemes"]:checked').each(function() {
		 if(strSGCode.length>0)
			 {
			 strSGCode=strSGCode+","+this.value;
			 }
			 else
			 {
				 strSGCode=this.value;
			 }
		 
		});
	 if(strSGCode=="")
	 {
	 	alert("Please Select SubGroup");
	 	return false;
	 }
	 $("#hidSubCodes").val(strSGCode);



	    	document.forms["PendingRecipeReport"].submit();
	
 } 


/**
 * Select All Group, SubGroup
**/
 $(document).ready(function () 
	{
		$("#chkSGALL").click(function () {
		    $(".SGCheckBoxClass").prop('checked', $(this).prop('checked'));
		});
		
		
	});
 


</script>
<body>
	<div class="container transTable">
		<label id="formHeading">Pending Recipe Report</label>
	    <s:form name="PendingRecipeReport" method="POST" action="rptPendingRecipeList.html" target="_blank">
            <br />
	   		
		 <div class="row">	
		    <div class="col-md-2"><label>Sub Group</label>
		  		 <input type="text" id="searchSGrp" readonly="true" Class="searchTextBox" placeholder="Type to search">
		    </div>
		 </div>
		<br>
			<div  style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px;width: 55%; overflow-x: hidden; overflow-y: scroll;">
                	<table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
						<tbody>
							<tr bgcolor="#c0c0c0">
								<td width="10%"><input type="checkbox" id="chkSGALL"
											checked="checked" onclick="funCheckUncheckSubGroup()" />Select</td>
								<td width="25%">Sub Group Code</td>
								<td width="65%">Sub Group Name</td>

							</tr>
						</tbody>
					  </table>
					  <table id="tblSubGroup" class="masterTable"
								style="width: 100%; border-collapse: separate;">
								<tbody>
									<!-- <tr bgcolor="#fafbfb">
										<td width="15%"></td>
										<td width="25%"></td>
										<td width="65%"></td>

									</tr> -->
								</tbody>
					  </table>
			</div>
	
			<br><br>
			<p align="center" >
				 <input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"  onclick="btnSubmit_Onclick()" id="btnSubmit" />
				 &nbsp;
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>			     
			</p>
		
			<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
					
			<s:input type="hidden" id="hidSubCodes" path="strSGCode"></s:input>	
		</div>
		</s:form>
		</div>
	</body>
</html>