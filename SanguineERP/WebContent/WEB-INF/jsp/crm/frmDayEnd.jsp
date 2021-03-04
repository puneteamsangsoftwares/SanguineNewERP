<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">


<title>Day End</title>
<style type="text/css">

.masterTable td{
	padding-left: 36px;
</style>

<script type="text/javascript">

	/**
	 * Ready Function for Searching in Table
	 */
	$(document).ready(function() {
		var tablename = '';
		$('#txtLocCode').keyup(function() {
			tablename = '#tblloc';
			searchTable($(this).val(), tablename);
		});
	});

	/**
	 * Function for Searching in Table Passing value(inputvalue and Table Id) 
	 */
	function searchTable(inputVal, tablename) {
		var table = $(tablename);
		table.find('tr').each(function(index, row) {
			var allCells = $(row).find('td');
			if (allCells.length > 0) {
				var found = false;
				allCells.each(function(index, td) {
					var regExp = new RegExp(inputVal, 'i');
					if (regExp.test($(td).find('input').val())) {
						found = true;
						return false;
					}
				});
				if (found == true)
					$(row).show();
				else
					$(row).hide();
			}
		});
	}
	
	/**
	 * Ready Function for Ajax Waiting
	 */
	$(document).ready(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		funRemRows("tblloc");
		var propCode='<%=session.getAttribute("propertyCode").toString()%>';
		funSetAllLocationOfPrpoerty(propCode);
	});

	/**
	* Get and Set All Location All Property
	**/
	function funSetAllLocationOfPrpoerty(propCode) {
		var searchUrl = "";
		searchUrl = getContextPath() + "/loadLocationForProperty.html?propCode="+propCode;
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				if (response.strLocCode == 'Invalid Code') {
					alert("Invalid Location Code");
					$("#txtFromLocCode").val('');
					$("#lblFromLocName").text("");
					$("#txtFromLocCode").focus();
				} else {
					$.each(response, function(i, item) {
						funfillLocationGrid(item[1],item[0]);
					});

				}
			},
			error : function(jqXHR, exception) {
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
	*  Filling Location Grid 
	**/
	function funfillLocationGrid(strLocCode, strLocationName) {
		var table = document.getElementById("tblloc");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input id=\"cbLocSel."
				+ (rowCount)
				+ "\" name=\"Locthemes\" type=\"checkbox\" class=\"LocCheckBoxClass\" size=\"10%\" checked=\"checked\" value='"
				+ strLocCode + "' />";
		row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strLocCode."
				+ (rowCount) + "\" value='" + strLocCode + "' >";
		row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box \" size=\"50%\" id=\"strLocName."
				+ (rowCount) + "\" value='" + strLocationName + "' >";
	}

	/**
	*  Remove All Row From Grid 
	**/
	function funRemRows(tableName) {
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		while (rowCount > 0) {
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	/**
	*  Select All Location When User Click On Select All Check Box
	**/
	$(document).ready(function() {
		$("#chkLocALL").click(function() {
			$(".LocCheckBoxClass").prop('checked', $(this).prop('checked'));
		});
	});
	
	/**
	*  Check Validation Before Submit The Form
	**/
	function formSubmit() {
		
		 var status = confirm("DO YOU WANT TO Day END?");
		   if(status == true){
			   var strLocCode = "";
				$('input[name="Locthemes"]:checked').each(function() {
					if (strLocCode.length > 0) {
						strLocCode = strLocCode + "," + this.value;
					} else {
						strLocCode = this.value;
					}
				});
				$("#hidLocCodes").val(strLocCode);

				document.forms["frmDayEnd"].submit();
		   	
		   }
		   else{
			  	return false;
		   }
		
		
		
		 /**
		  *  Set All Selected Location In hidden TextField 
		 **/
		

	}
	
	/**
	 *Reset the form
	 */
	function funResetFields() {
		location.reload(true);
	}
	
	/**
	 * Ready Function 
	 * Success Message after Submit the Form
	 */
	$(function() {
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
			 if(session.getAttribute("successMessage") != null)
			 {%>
			  	message='<%=session.getAttribute("successMessage").toString()%>';
			    <% session.removeAttribute("successMessage");
			 }
			 boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				if (test)
				{%>	
					alert(message);
				<%}
				 session.removeAttribute("success");	
		}%>
		
	});
</script>
</head>
<body onload="funOnload();">
	<div class="container">
		<label id="formHeading">Day End </label>
		<s:form name="frmDayEnd" method="POST" action="saveCRMDayEnd.html?saddr=${urlHits}" >
		<div class="masterTable">
			<div class="col-md-2">
				<label>Location</label>
				<input type="text"id="txtLocCode"
					class="searchTextBox" placeholder="Type to search">
			</div><br>
				<div style="background-color: #fbfafa;width: 60%;  border: 1px solid #ccc; display: block; height: 150px;font-size:13px; overflow-x: hidden; overflow-y: scroll;">
					<table id="" class="masterTable"style="width: 100%; border-collapse: separate;">
						<tbody>
							<tr bgcolor="#c0c0c0">
								<td width="10%"><input type="checkbox" id="chkLocALL"
									checked="checked" />Select</td>
								<td width="25%">Location Code</td>
								<td width="65%">Location Name</td>
							</tr>
						</tbody>
					</table>
					<table id="tblloc" class="masterTable" style="width: 100%;">
						<tr bgcolor="#72BEFC">
							<td style="width:9%;"></td>
							<td style="width:25%;"></td>
							<td style="width:65%;"></td>
						</tr>
					</table>
			</div>
		</div>
		<br>
			<br>
			<div class="center" style="margin-right: 40%;">
				<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return formSubmit();"
					class="form_button">Submit</button></a> &nbsp;
				<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
					class="form_button">Reset</button></a>
			</div>
			<s:input type="hidden" id="hidLocCodes" path="strFromLocCode"></s:input>
			<div id="wait"
				style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
				<img
					src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
					width="60px" height="60px" />
			</div>
		</s:form>
	</div>
	</body>
</html>