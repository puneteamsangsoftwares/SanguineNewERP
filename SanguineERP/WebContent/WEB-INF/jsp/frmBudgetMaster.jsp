<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<style>
.masterTable td{
padding:0px;
	}
	
</style>
<script type="text/javascript">


$(function() 
		{
	var loggedInProperty="${LoggedInProp}";
	$("#strPropertyCode").val(loggedInProperty);
			funLoadTableMasterHeaderData();
			funGetGroupData();
		});
		


//Geting Group Data 
function funGetGroupData()
{
	
	var count=0;
	var propCode=$("#strPropertyCode").val();
	var year=$("#cmbYear").val();
		var searchUrl = getContextPath() + "/loadAllGroup.html?propCode="+propCode+"&year="+year;
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
					funfillGroup(response);
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


	function funLoadTableMasterHeaderData()
	{
		var searchUrl="";
		var year=$("#cmbYear").val();
		searchUrl=getContextPath()+"/loadBudgetMasterHeader.html?year="+year;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	funFillMasterHeaderData(response);
	        		
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
		
		
	
	
	function funFillMasterHeaderData(data)
	{
		$('#tblFlashMasterHeader tbody').empty()
		  var table = document.getElementById("tblFlashMasterHeader");
		  var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"19%\"  id=\"txtGroupName.1\" value='GroupName' />";
		   var cnt=1;
		    for(var i=0;i<data.length;i++)
		    {
		    	
				row.insertCell(cnt).innerHTML= "<input class=\"Box\" size=\"10%\" style=\"text-align:right;\"   id=\"txtMonthName."+(cnt)+"\" value='"+data[i]+"' />";
				cnt++;
		    }  
	}


	//Fill Group Data listBudgetModel
		function funfillGroup(data) 
		{
			$('#tblGroup tbody').empty()
			var table = document.getElementById("tblGroup");
			
			for(var i=0;i<data.length;i++)
			{	
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var resultData=data[i];
			   
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"19%\" id=\"strGName."+(rowCount)+"\" value='"+resultData[0]+"' >";
		    row.insertCell(1).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth1\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[1]+"' >";
		    row.insertCell(2).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth2\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[2]+"'>";
		    row.insertCell(3).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth3\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[3]+"' >";
		    row.insertCell(4).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth4\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[4]+"' >";
		    row.insertCell(5).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth5\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[5]+"' >";
		    row.insertCell(6).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth6\"  style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[6]+"' >";
		    row.insertCell(7).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth7\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[7]+"' >";
		    row.insertCell(8).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth8\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[8]+"' >";
		    row.insertCell(9).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth9\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[9]+"' >";
		    row.insertCell(10).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth10\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[10]+"' >";
		    row.insertCell(11).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth11\" style=\"text-align:right;\" class=\"text\" size=\"10%\" value='"+resultData[11]+"' >";
		    row.insertCell(12).innerHTML= "<input name=\"listBudgetMonth["+(rowCount)+"].strMonth12\" style=\"text-align:right;\"  class=\"text\" size=\"10%\" value='"+resultData[12]+"' >";
//	 	    row.insertCell(13).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
		    row.insertCell(13).innerHTML= "<input type=\"hidden\" size=\"0%\"  name=\"listBudgetMonth["+(rowCount)+"].strGroupCode\"  value='"+resultData[13]+"'>";
		    $("#hidBudgetCode").val(resultData[14]);
		    
			}
  }
		
	/**
	 * Delete a particular tax row 
	**/
	function funDeleteTaxRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblGroup");
		table.deleteRow(index);
		funCalTaxTotal();
	}
	
	
	/**
	 * Reset function  
	 */
	function funResetFields()
	{
		location.reload(true); 
	} 	
	
	
	</script>
	<title>Insert title here</title>
	</head>

	<body>

	<div class="container">
		<label id="formHeading">Budget Master</label>
		<s:form name="BudgetMaster" method="POST" action="saveBudgetMaster.html?saddr=${urlHits}">
			<div class="row">
				<div class="col-md-2">
					<label>Property</label> 
					<s:select path="strPropertyCode" items="${properties}"
							id="strPropertyCode" cssClass="longTextBox" onchange="funGetGroupData()">
					</s:select>
				</div>
				<div class="col-md-2">
					<label>Year</label>
					<s:select id="cmbYear" path="strFinYear" style="width:80%;">
						<option>2017-2018</option>
						<option>2018-2019</option>
						<option>2017-2018</option>
					</s:select>
				</div>
			</div>
		<br/>
	
		<div class="dynamicTableContainer" style="height:350px; overflow-y: scroll">
			<table id="tblFlashMasterHeader" style="height:28px;border:#0F0; width: 100%; background:#c0c0c0;" >
			</table>
		
			<table id="tblGroup" class="masterTable" style="width: 100%; border-collapse: separate;">
			</table>
		</div>
	
		<div>
			<s:input type="hidden" id="hidBudgetCode" path="strBudgetCode"></s:input>
		</div>
			
		<div class="center">
				<a href="#"><button class="btn btn-primary center-block"  value="Submit">Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()">Reset</button></a>
		</div>
</s:form>
</div>	
</body>
</html>