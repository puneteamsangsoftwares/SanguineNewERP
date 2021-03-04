<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

<script type="text/javascript">
	$(document).ready(function() {
		
		
		  var message = '';
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
	    				alert("Data Save successfully");
	    			<%
	    			}}%>

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
		<label id="formHeading">Member Profile Setup</label>
			<s:form action="saveWebClubMemberProfileSetup.html?saddr=${urlHits}" method="POST" name="securityShell">				
			<!-- Start of tab container -->
			<table  class="table table-striped"
				style="border: 0px solid black; width:50%;">
				<tr>
					<td style="background-color: #f5f3f394; border-style:none;">						
							<!--  Start of Masters tab-->

							<div id="tab1" class="tab_content">
								 <table border="1" class="myTable">
									<thead>
										<tr>
											<th>Form Mandatory Fields</th>											
											<th>Flag</th>
										</tr>
									</thead>									
									<c:forEach items="${treeList.listWebClubMemberProfileModel}" var="tree"
										varStatus="status">
										<tr>
											<%-- <td><input name="listTransactionForms[${status.index}].strFormDesc" value="${tree.strFormDesc}"/></td> --%>
											<td><label
												id="listWebClubMemberProfileModel[${status.index}].strFieldName">${tree.strFieldName}</label></td> 
											
											<td align="center"><input type="checkbox"
												name="listWebClubMemberProfileModel[${status.index}].strFlag"
												<c:if test="${tree.strFlag == 'true'}">checked="checked"</c:if>
												value="true" /></td>		
											<td><input type="hidden" readonly="true" 
												name="listWebClubMemberProfileModel[${status.index}].strFieldName"
												value="${tree.strFieldName}" /></td> 									
										</tr>
									</c:forEach>
									
									<!-- <label id="formHeading">Other Detail Form</label> -->
									
									<c:forEach items="${treeList.listOtherDtl}" var="tree"
										varStatus="status">
										
										<tr>
											<%-- <td><input name="listTransactionForms[${status.index}].strFormDesc" value="${tree.strFormDesc}"/></td> --%>
											<td><label
												id="listOtherDtl[${status.index}].strFieldName">${tree.strFieldName}</label></td> 											
											<td align="center"><input type="checkbox"
												name="listOtherDtl[${status.index}].strFlag"
												<c:if test="${tree.strFlag == 'true'}">checked="checked"</c:if>
												value="true" /></td>														
											 <td><input type="hidden" readonly="true" 
												name="listOtherDtl[${status.index}].strFieldName"
												value="${tree.strFieldName}" /></td> 									
										</tr>
																				
										
									</c:forEach>
								</table>
							</div>
							<!--  End of  Masters tab-->
					</td>
				</tr>
			</table>
			<!-- End Of tab container -->
			<div class="center" style="text-align:center;margin-right:18%;">
				<a href="#"><button class="btn btn-primary center-block"  tabindex="3" value="Submit" onclick="" 
					class="form_button">Submit</button></a>&nbsp;
				<a href="frmWebClubSecurityShell.html"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
					class="form_button">Reset</button></a>
			</div>
			
			
			</s:form>
	</div> 
</body>
</html>
