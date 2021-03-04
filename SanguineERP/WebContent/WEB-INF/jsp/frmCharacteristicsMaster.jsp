<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
$(document).ready(function(){
	funResetFields();	
});
</script>	
<script type="text/javascript">
function funResetFields(){
	resetForms('characteristicsForm');
	   $("#CharacteristicsName").focus();
}


var clickCount =0.0;	
function funCallFormAction(actionName,object) 
	{
		
		if ($("#CharacteristicsName").val()=="") 
		    {
			 alert('Enter characteristic Name');
			 $("#CharacteristicsName").focus();
			 return false;  
		   
		}
	if(clickCount==0){
		clickCount=clickCount+1;
	}
		else
		{
			return false;
		}
		return true; 
	}
function funHelp(transactionName)
{
	fieldName=transactionName;
   
    //window.showModalDialog("searchform.html?formname=charCode&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    window.open("searchform.html?formname=charCode&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}

function funSetData(Code)
{
	document.getElementById("CharacteristicsCode").value=Code;
	
	 $.ajax({
	        type: "GET",
	        url: getContextPath()+"/loadCharData.html?charCode="+Code,
	        dataType: "json",
	        success: function(resp){
	          // we have the response
	         document.getElementById("CharacteristicsCode").value=resp.strCharCode;
	         document.getElementById("CharacteristicsName").value=resp.strCharName;
	         document.getElementById("CharacteristicsDesc").value=resp.strCharDesc;
	        // $("#CharacteristicsDesc").val(resp.strCharDesc); 
	         
	        },
	        error: function(e){
	        	document.getElementById("CharacteristicsCode").value=Code;
	          alert('Error121212: ' + e);
	        }
	      });
}

$(function()
		{
		$('#CharacteristicsCode').blur(function() {			
					var code = $('#CharacteristicsCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){
						funSetData(Code);
					}
				
			});
		
		
		$('a#baseUrl').click(function() 
		{
			if($("#CharacteristicsCode").val()=="")
			{
				alert("Please Select Characteristics Code");
				return false;
			}
			
			//window.open('attachDoc.html?transName=frmAttributeMaster.jsp&formName=Attribute Master&code='+$("#txtAttCode").val(),"","Height:600px;Width:800px;Left:300px;");
			window.open('attachDoc.html?transName=frmCharacteristicsMaster.jsp&formName=Characteristics Master&code='+$("#CharacteristicsCode").val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		    //$(this).attr('target', '_blank');
		});

		});
	
		
$(document).ready(function()
		{
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
</script>

<title>Insert title here</title>
</head>
<body onload="onLoadFun();">
   <div class="container masterTable">
		<label id="formHeading">Characteristics Master</label>
	  <s:form name="characteristicsForm" method="POST" action="saveCharMaster.html?saddr=${urlHits}">
		
		<!-- <a id="baseUrl" href="#">Attach Documents</a>  -->
		<div class="row">
			<div class="col-md-2"><s:label path="">Characteristics Code </s:label> 
				<s:input path="strCharCode" id="CharacteristicsCode"  readonly="true" ondblclick="funHelp('characteristics')" cssClass="searchTextBox"/>
			</div>
		
			<div class="col-md-3"><s:label path="">Name </s:label> 
				 <s:input path="strCharName" id="CharacteristicsName" required="true"/>
			</div>
			<div class="col-md-7"></div>
			
			<div class="col-md-2"><s:label path="">Type</s:label>
				   <s:select path="strCharType" style="width:auto;">
					<s:option value="Text">Text</s:option>
					<s:option value="Integer">Integer</s:option>
					<s:option value="Decimal">Decimal</s:option>
				</s:select>
			</div>

			<div class="col-md-3"><s:label path="">Description</s:label>
				   <s:input id="CharacteristicsDesc" path="strCharDesc"/>
            </div>
		</div>
	
         <br />
		
		<p align="center" style="margin-right: 32%;">
			<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction()" /> 
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
	</s:form>
	</div>
</body>
</html>