<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
    
</head>

<script type="text/javascript">
	var fDate, tDate,ModuleName;
	var inPeg;
	$(document).ready(function() {
		var startDate="${startDate}";
		var startDateOfMonth="${startDateOfMonth}";
		var arr1 = startDateOfMonth.split("-");
		Dat1=arr1[2]+"-"+arr1[1]+"-"+arr1[0];
		var arr = startDate.split("/");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
		$("#txtFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtFromDate").datepicker('setDate', startDateOfMonth);

		$("#txtToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtToDate").datepicker('setDate', 'today');

		
		$("[type='reset']").click(function(){
			location.reload(true);
		});

		$("#btnSubmit").click(function(event) {
			 fromDate = $("#txtFromDate").val();
			toDate = $("#txtToDate").val();
			 ModuleName=$("#cmbModule").val();
			if (fromDate.trim() == '' && fromDate.trim().length == 0) {
				alert("Please Enter From Date");
				return false;
			}
			if (toDate.trim() == '' && toDate.trim().length == 0) {
				alert("Please Enter To Date");
				return false;
			}

			var masterName = $("#txtMasterName").val();

			if (masterName.trim() == '' && masterName.trim().length == 0) {
				alert("Please Select Master");
				return false;
			}

		
			if (CalculateDateDiff(fromDate, toDate)) {
					fDate = fromDate;
					tDate = toDate;
					funAdd();
				}
			
		});

	});

	function CalculateDateDiff(fromDate,toDate) {

		var frmDate= fromDate.split('-');
	    var fDate = new Date(frmDate[2],frmDate[1],frmDate[0]);
	    
	    var tDate= toDate.split('-');
	    var t1Date = new Date(tDate[2],tDate[1],tDate[0]);

		var dateDiff=t1Date-fDate;
			 if (dateDiff >= 0 ) 
			 {
	     	return true;
	     }else{
	    	 alert("Please Check From Date And To Date");
	    	 return false
	     }
	}
	

	
</script>
<body>
	<div class="container masterTable">
	<label id="formHeading">Master List</label>
	<s:form name="frmMasterList" method="GET" action="rptMasterList.html?saddr=${urlHits}">
		
	  <div class="row">	
		        <div class="col-md-2"><label>From Date</label>
					  <s:input type="text" id="txtFromDate"
							class="calenderTextBox" path="dtFromDate" required="required" style="width:70%"/>
				</div>
				
				<div class="col-md-2"><label>To Date</label>
					  <s:input type="text" id="txtToDate" class="calenderTextBox" path="dtToDate" required="required" style="width:70%"/>
				</div>
				<div class="col-md-8"></div>
				
				<div class="col-md-3"><label>Module</label>
				  <s:select id="cmbModule" cssClass="combo1" cssStyle="width:auto;height:25px;overflow:scroll" path="strAgainst">
					<option value="tblattributemaster">Attribute Master</option>
					<option value="tbludcategory">UD Report Category Master</option>
					<option value="tblcharacteristics">Characteristics Master</option>
					<option value="tblgroupmaster">Group Master</option>
					<option value="tbllocationmaster">Location Master</option>
					<option value="tblpropertymaster">Property Master</option>
					<option value="tblreasonmaster">Reason Master</option>
					<option value="tblsubgroupmaster">Sub Group Master</option>
					<option value="tblpartymaster">Supplier Master</option>
					<option value="tbltaxhd">Tax Master</option>
					<option value="tblprocessmaster">Process Master</option>
					<option value="tbluserhd">User Master</option>
					<option value="tbltcmaster">TC Master</option>
					<option value="tbluommaster">UOM Master</option>
					<!-- <option value=""></option> -->
				</s:select>			
			   </div>
		</div>
	   <br />
	
		<p align="center" style="margin-right:57%">
			 <input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" id="btnSubmit" /> 
			  &nbsp;
		  	 <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>
	</s:form>
	</div>
</body>
</html>