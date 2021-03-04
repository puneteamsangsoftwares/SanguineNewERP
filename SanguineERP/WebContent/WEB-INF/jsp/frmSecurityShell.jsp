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
	
<script type="text/javascript">
	$(document).ready(function() {

		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
	});
</script>

<script type="text/javascript">
var fieldName;
	function funHelp(transactionName) {
		//window.open("searchform.html?formname=" + transactionName+"&searchText=", 'window','width=600,height=600');
		//Likeusermaster
		fieldName=transactionName;		
		if(transactionName=="Likeusermaster")
			{
				transactionName="usermaster";
			}
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}

	function funSetData(code)
	{
		//alert(fieldName);
		switch (fieldName)
		{
			case 'usermaster':
				
				funSetNewUser(code);
				
			break;	
			
			case 'Likeusermaster':
				
				funSetLikeUser(code);	
				
				break;
		}
		

	}
	function funSetNewUser(code)
	{
		document.getElementById("strUserCode").value = code;
		$
				.ajax({
					type : "GET",
					url : getContextPath()
							+ "/loadUserMasterData.html?userCode=" + code,
					dataType : "json",
					success : function(response) 
					{
						document.getElementById("UserName").value = response.strUserName1;
						document.securityShell.action = "security.html?userCode="+ code;
						document.securityShell.submit();
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
	
	function funSetLikeUser(code)
	{
		//alert(code);
		document.getElementById("strLikeUserCode").value = code;
		$
				.ajax({
					type : "GET",
					url : getContextPath()
							+ "/loadUserMasterData.html?userCode=" + code,
					dataType : "json",
					success : function(response) 
					{
						document.getElementById("LikeUserName").value = response.strUserName1;
						document.securityShell.action = "LikeUsersecurity.html?userCode="+ code;
						document.securityShell.submit();
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
	function funResetForm(){
		
	}
</script>
<style type="text/css">

</style>

<title>Insert title here</title>
<%-- <tab:tabConfig /> --%>
</head>
<body>

	<div class="container">
		<label id="formHeading">Security Shell</label>
	<div>
		<s:form action="saveSecurityShell.html?saddr=${urlHits}" method="POST"
			name="securityShell">
			<input type="hidden" value="${urlHits}" name="saddr">
			<br />
			
			<div class="row">
				<div class="col-md-5">
					<label>User Code</label>
					<div class="row">
						<div class="col-md-5">
							<s:input path="strUserCode" cssClass="searchTextBox" id="strUserCode" readonly="true"
								ondblclick="funHelp('usermaster')" />
						</div>
						<div class="col-md-7">
							<s:input id="UserName" readonly="true" path="strUserName"/>
						</div>
					</div>
				</div>
				<div class="col-md-7"></div>
				<div class="col-md-5">
					<label>Like User </label>
						<div class="row">
							<div class="col-md-5">
								<s:input path="strLikeUserCode" cssClass="searchTextBox" id="strLikeUserCode" readonly="true"
									ondblclick="funHelp('Likeusermaster')" />
				 			</div>
				 			<div class="col-md-7">
				 				<s:input id="LikeUserName"  readonly="true" path="strLikeUserName"/></td>
							</div>
						</div>
				</div>
			</div>
		<br>
			<!-- Start of tab container -->
			<table style="width: 100%;">
				<tr>
					<td>
						<div id="tab_container">
							<ul class="tabs">
								<li class="active" data-state="tab1">Masters</li>
								<li data-state="tab2">Transactions</li>
								<li data-state="tab3">Process</li>
								<li data-state="tab4">Reports</li>
								<li data-state="tab5">Tools</li>
<!-- 								<li data-state="tab6">Mobile Applications</li> -->
							</ul>
							<br /> <br />

							<!--  Start of Masters tab-->

							<div id="tab1" class="tab_content">
								<table border="1" class="myTable">
									<thead>
										<tr>
											<th>Form Name</th>
											<th></th>
											<th>Add</th>
											<th>Edit</th>
											<th>View</th>
											<th>Print</th>
										</tr>
									</thead>									
									<c:forEach items="${treeList.listMasterForms}" var="tree"
										varStatus="status">
										<tr>
											<td><label
												id="listMasterForms[${status.index}].strFormDesc">${tree.strFormDesc}</label></td>
											<td><input type="hidden"
												name="listMasterForms[${status.index}].strFormName"
												value="${tree.strFormName}" /></td>
											<td align="center"><input type="checkbox"
												name="listMasterForms[${status.index}].strAdd"
												<c:if test="${tree.strAdd == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listMasterForms[${status.index}].strEdit"
												<c:if test="${tree.strEdit == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listMasterForms[${status.index}].strView"
												<c:if test="${tree.strView == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listMasterForms[${status.index}].strPrint"
												<c:if test="${tree.strPrint == 'true'}">checked="checked"</c:if>
												value="true" /></td>
										</tr>
									</c:forEach>


								</table>
							</div>
							<!--  End of  Masters tab-->


							<!-- Start of Transaction tab -->

							<div id="tab2" class="tab_content">
								<table border="1" class="myTable">
									<thead>
										<tr>
											<th width="40%">Form Name</th>
											<th></th>
											<th>Add</th>
											<th>Edit</th>
											<th>Delete</th>
											<th>View</th>
											<th>Print</th>
											<th>Authorise</th>
										</tr>
									</thead>
									<c:forEach items="${treeList.listTransactionForms}" var="tree"
										varStatus="status">
										<tr>
											<%-- <td><input name="listTransactionForms[${status.index}].strFormDesc" value="${tree.strFormDesc}"/></td> --%>
											<td><label
												id="listTransactionForms[${status.index}].strFormDesc">${tree.strFormDesc}</label></td>
											<td><input type="hidden"
												name="listTransactionForms[${status.index}].strFormName"
												value="${tree.strFormName}" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strAdd"
												<c:if test="${tree.strAdd == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strEdit"
												<c:if test="${tree.strEdit == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strDelete"
												<c:if test="${tree.strDelete == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strView"
												<c:if test="${tree.strView == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strPrint"
												<c:if test="${tree.strPrint == 'true'}">checked="checked"</c:if>
												value="true" /></td>
											<td align="center"><input type="checkbox"
												name="listTransactionForms[${status.index}].strAuthorise"
												<c:if test="${tree.strAuthorise == 'true'}">checked="checked"</c:if>
												value="true" /></td>
										</tr>
									</c:forEach>
								</table>
							</div>
							<!-- End of Transaction tab -->


							<!-- Start of Process Tab -->

							<div id="tab3" class="tab_content"></div>

							<!-- End  of Process Tab -->


							<!-- Start of Reports Tab -->
							<div id="tab4" class="tab_content">
								<table border="1" class="myTable">
									<thead>
										<tr>
											<th width="70%">Form Name</th>
											<th></th>
											<th>Grant</th>
										</tr>
									</thead>
									<c:forEach items="${treeList.listReportForms}" var="tree"
										varStatus="status">
										<tr>
											<td><label
												id="listReportForms[${status.index}].strFormDesc">${tree.strFormDesc}</label></td>
											<%-- <td><label id="listReportForms[${status.index}].strFormDesc" >${tree.strFormDesc}</label></td> --%>
											<td><input type="hidden"
												name="listReportForms[${status.index}].strFormName"
												value="${tree.strFormName}" /></td>
											<td align="center"><input type="checkbox"
												name="listReportForms[${status.index}].strGrant"
												<c:if test="${tree.strGrant == 'true'}">checked="checked"</c:if>
												value="true" /></td>
										</tr>
									</c:forEach>
								</table>
							</div>
							<!-- End  of Reports Tab -->


							<!-- Start of tools tab -->

							<div id="tab5" class="tab_content">
								<table border="1" class="myTable">
									<thead>
										<tr>
											<th width="70%">Form Name</th>
											<th></th>
											<th>Grant</th>
										</tr>
									</thead>
									<c:forEach items="${treeList.listUtilityForms}" var="tree"
										varStatus="status">
										<tr>
											<td><label
												id="listUtilityForms[${status.index}].strFormDesc">${tree.strFormDesc}</label></td>
											<td><input type="hidden"
												name="listUtilityForms[${status.index}].strFormName"
												value="${tree.strFormName}" /></td>
											<td align="center"><input type="checkbox"
												name="listUtilityForms[${status.index}].strGrant"
												<c:if test="${tree.strGrant == 'true'}">checked="checked"</c:if>
												value="true" /></td>
										</tr>
									</c:forEach>
								</table>
							</div>

							<!-- End  of tools tab -->


							<!-- Start of Mobile Applications Tab -->
						<!-- 	<div id="tab4" class="tab_content">This id my Mobile
								Applications Tab</div> -->
							<!-- End of Mobile Applications Tab -->

						</div>
					</td>
				</tr>
			</table>
			<!-- End Of tab container -->
			<div class="center" >
				<a href="#"><button class="btn btn-primary center-block"  value="Submit" 
				>Submit</button></a>
				<a href="frmSecurityShell.html"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()"
				>Reset</button></a>
		</div>
		</s:form>
	</div>
</div>
</body>
</html>