<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
<style type="text/css">
.transTable th	{
		 background:#c0c0c0;
	}
.transTable{
 margin:0px;
}	
 #percent-sign {
    top: 27px;
    left: 165px;
    color: #555;
    position: absolute;
    z-index: 1;
    font-size: 18px;
    }

</style>
	
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
		funOnChangeCriteria();
		$("#strUser1_SB").css('visibility','hidden');
		$("#strUser2_SB").css('visibility','hidden');
		$("#strUser3_SB").css('visibility','hidden');
		$("#strUser4_SB").css('visibility','hidden');
		$("#strUser5_SB").css('visibility','hidden');
		$('#itemImage').attr('src', getContextPath()+"/resources/images/company_Logo.png");
		 var property='<%=session.getAttribute("userProperty").toString()%>';
		 funGetImage();
//  		 funGetProperty(property);
	});
</script>
<script type="text/javascript">
	var fieldName;
	var selectedFieldId;
	
	
	
	
	
	
	function funCheckBoxClicked(obj)
	{
		/* var isChecked=$(obj).prop("checked");
		alert(isChecked); */
		
		/* if(isChecked)
		{
			$(obj).val("Y");
		}
		else
		{
			$(obj).val("N");
		} */
		
		/* var value=$(obj).val();
		alert(value);
		
		var value=$(obj).attr("id");
		alert(value);
		
		 */
		
		
	}
	
	
	
	
	
	
	
	$(function() {
		/* $("#dtStart").datepicker();
		$("#dtEnd").datepicker();
		$("#dtLastTransDate").datepicker();
		$("#dtFromTime").datepicker();
		$("#dtToTime").datepicker(); */
		
		$("#btnAddTC").click(function( event )
		{
			funAddTCRows();
		});
		
		$('#txtReasonCode').blur(function(){
			 var code=$('#txtReasonCode').val();			     
			 if (code.trim().length > 0 && code !="?" && code !="/") {
				 funGetReason(code);
			  	}			 
		});
	});
	
	
	function funClearAutorizatioTabFields() {
		$("#strFormName").val("");
		$("#strUser1").val("");
		$("#strUser2").val("");
		$("#strUser3").val("");
		$("#strUser4").val("");
		$("#strUser5").val("");
		$("#intLevel").val("");
	}
	
	function funValidateFields()
	{
		funGetCheckedAuditForm();
		if($("#strProperty").val()=='--select--')
		{
			alert("Please select Property");
			$("#strProperty").focus();
			return false;
		}
	}
	function funClearAutorizatioTabFields_SB() {
		$("#strFormName_SB").val("");
		$("#strUser1_SB").val("");
		$("#strUser2_SB").val("");
		$("#strUser3_SB").val("");
		$("#strUser4_SB").val("");
		$("#strUser5_SB").val("");
		$("#intLevel_SB").val("");
		$("#strCriteria").val(">");
		$("#intVal1").val("");
		$("#intVal2").val("");
	}

	function btnAdd_onclick() {
		if (document.all("strFormName").value != "") {
			if (document.all("strFormName").value != ""
					&& document.all("intLevel").value != 0) {
				funAddProductRow_Authorization();
				funClearAutorizatioTabFields();
			} else {
				alert("Please Select Level");
				document.all("intLevel").focus();
				return false;
			}
		} else {
			alert("Please Select Form");
			document.all("strFormName").focus();
			return false;
		}
	}

	function btnAdd_onclick_SB() {

		if (document.all("strFormName_SB").value != "") {
		
			if ($("strFormName_SB").val() != "" && $("intLevel_SB").val() != 0) {
				if ($("#strCriteria").val() == 'between') {
					if ($("#intVal1").val() == '') {
						alert("Please Enter Value");
						$("#intVal1").focus();
						return false;
					}
					if ($("#intVal2").val() == '') {
						alert("Please Enter Value");
						$("#intVal2").focus();
						return false;
					}

				}
				if($("#strCriteria").val() == '<' && $("#intVal1").val() == ''){
					
						alert("Please Enter Value");
						document.all("intVal1").focus();
						return false;
					
				}
				if ($("#strCriteria").val() == '>' && $("#intVal1").val() == '') {
				
						alert("Please Enter Value");
						document.all("intVal1").focus();
						return false;
					
				}
				if($("#intLevel_SB").val().trim().length==0 && $("#intLevel_SB").val()=="")
					{
						alert("Please Select Level");
						document.all("intLevel_SB").focus();
						return false;
					}
				else {
					
					funAddProductRow_Authorization_SB();
					funClearAutorizatioTabFields_SB();
				}

			} else {
				alert("Please Select Level");
				$("intLevel_SB").focus();
				return false;
			}
		} else {
			alert("Please Select Form");
			document.all("strFormName_SB").focus();
			return false;
		}
	}
	function funRemoveProductRows_Authorization()
    {
		 var table = document.getElementById("tblAuthorization");
		 var rowCount = table.rows.length;
		 //alert(rowCount);
		for(var i=rowCount;i>=0;i--)
		{
			table.deleteRow(i);						
		} 
    }
	function funAddProductRow_Authorization() {
		debugFlag = false;
		var strUser1 = 'NA';
		var strUser2 = 'NA';
		var strUser3 = 'NA';
		var strUser4 = 'NA';
		var strUser5 = 'NA';

		var strFormName = $("#strFormName").val();
		var intLevel = $("#intLevel").val();
		if (intLevel == '1') {
			strUser1 = $("#strUser1").val();
			strUser2 = 'NA';
			strUser3 = 'NA';
			strUser4 = 'NA';
			strUser5 = 'NA';
		} else if (intLevel == '2') {
			strUser1 = $("#strUser1").val();
			strUser2 = $("#strUser2").val();
			strUser3 = 'NA';
			strUser4 = 'NA';
			strUser5 = 'NA';
		} else if (intLevel == '3') {
			strUser1 = $("#strUser1").val();
			strUser2 = $("#strUser2").val();
			strUser3 = $("#strUser3").val();
			strUser4 = 'NA';
			strUser5 = 'NA';
		} else if (intLevel == '4') {
			strUser1 = $("#strUser1").val();
			strUser2 = $("#strUser2").val();
			strUser3 = $("#strUser3").val();
			strUser4 = $("#strUser4").val();
			strUser5 = 'NA';
		} else if (intLevel == '5') {
			strUser1 = $("#strUser1").val();
			strUser2 = $("#strUser2").val();
			strUser3 = $("#strUser3").val();
			strUser4 = $("#strUser4").val();
			strUser5 = $("#strUser5").val();
		}

		var table = document.getElementById("tblAuthorization");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		/* debug( funGetLabel(rowCount, 'strFormName', strFormName));
		debugFlag = false; */
		row.insertCell(0).innerHTML = funGetLabel(rowCount, 'strFormName',
				strFormName);
		row.insertCell(1).innerHTML = funGetLabel(rowCount, 'intLevel',
				intLevel);
		row.insertCell(2).innerHTML = funGetLabel(rowCount, 'strUser1',
				strUser1);
		row.insertCell(3).innerHTML = funGetLabel(rowCount, 'strUser2',
				strUser2);
		row.insertCell(4).innerHTML = funGetLabel(rowCount, 'strUser3',
				strUser3);
		row.insertCell(5).innerHTML = funGetLabel(rowCount, 'strUser4',
				strUser4);
		row.insertCell(6).innerHTML = funGetLabel(rowCount, 'strUser5',
				strUser5);
		row.insertCell(7).innerHTML = '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		//row.insertCell(0).innerHTML= "<label name=\"listclsWorkFlowModel["+(rowCount-1)+"].strFormName\" id=\"strFormName."+(rowCount-1)+"\" value='"+strFormName+"' >"+strFormName+"</label>";			  		   	  
		//  row.insertCell(1).innerHTML= "<label name=\"listclsWorkFlowModel["+(rowCount-1)+"].intLevel\" id=\"intLevel."+(rowCount-1)+"\" value="+intLevel+" ></label>";
		/* 	    row.insertCell(2).innerHTML= "<label name=\"listclsWorkFlowModel["+(rowCount-1)+"].strUser1\" id=\"strUser1."+(rowCount-1)+"\" value="+strUser1+" >";		    	    
		 row.insertCell(3).innerHTML="<input name=\"listclsWorkFlowModel["+(rowCount-1)+"].strUser2\" id=\"strUser2."+(rowCount-1)+"\" value="+strUser2+" >";
		 row.insertCell(4).innerHTML= "<input name=\"listclsWorkFlowModel["+(rowCount-1)+"].strUser3\" id=\"strUser3."+(rowCount-1)+"\" value="+strUser3+" >";	   
		 row.insertCell(5).innerHTML= "<input name=\"listclsWorkFlowModel["+(rowCount-1)+"].strUser4\" id=\"strUser4."+(rowCount-1)+"\" value="+strUser4+" >";	
		 row.insertCell(6).innerHTML= "<input name=\"listclsWorkFlowModel["+(rowCount-1)+"].strUser5\" id=\"strUser5."+(rowCount-1)+"\" value="+strUser5+" >";
		 row.insertCell(7).innerHTML= '<input type="button" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
		 debugFlag = false; */
		return false;
	}

	function funGetLabel(rowCount, id, value) {

		return "<label name=\"listclsWorkFlowModel[" + (rowCount - 1) + "]."
				+ id + "\" id=\"" + id + "." + (rowCount - 1) + "\" value='"
				+ value + "' >" + value + "</label>";
	}

	function funAddProductRow_Authorization_SB() {
		var strUser1 = 'NA';
		var strUser2 = 'NA';
		var strUser3 = 'NA';
		var strUser4 = 'NA';
		var strUser5 = 'NA';
		var intVal1 = 0.00;
		var intVal2 = 0.00;
		var strCriteria = $("#strCriteria").val();
	//alert(strCriteria);
		var strFormName = $("#strFormName_SB").val();
		var intLevel = $("#intLevel_SB").val();
		if (intLevel == '1') {
			strUser1 = $("#strUser1_SB").val();

		} else if (intLevel == '2') {
			strUser1 = $("#strUser1_SB").val();
			strUser2 = $("#strUser2_SB").val();

		} else if (intLevel == '3') {
			strUser1 = $("#strUser1_SB").val();
			strUser2 = $("#strUser2_SB").val();
			strUser3 = $("#strUser3_SB").val();

		} else if (intLevel == '4') {
			strUser1 = $("#strUser1_SB").val();
			strUser2 = $("#strUser2_SB").val();
			strUser3 = $("#strUser3_SB").val();
			strUser4 = $("#strUser4_SB").val();

		} else if (intLevel == '5') {
			strUser1 = $("#strUser1_SB").val();
			strUser2 = $("#strUser2_SB").val();
			strUser3 = $("#strUser3_SB").val();
			strUser4 = $("#strUser4_SB").val();
			strUser5 = $("#strUser5_SB").val();
		}
		if (strCriteria == ">" || strCriteria == '<') {
			intVal1 = $("#intVal1").val();
		} else if (strCriteria == 'between') {
			intVal1 = $("#intVal1").val();
			intVal2 = $("#intVal2").val();
		}
		
		var table = document.getElementById("tblAuthorizationSlabBased");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strFormName\" size=\"27%\" class=\"Box\"  readonly=\"readonly\" id=\"strFormName_SB."
				+ (rowCount - 1) + "\" value=\"" + strFormName + "\">";
		row.insertCell(1).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strCriteria\" size=\"11%\" class=\"Box\"  readonly=\"readonly\"  id=\"strCriteria."
				+ (rowCount - 1) + "\" value='" + strCriteria + "'>";
		row.insertCell(2).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].intVal1\" size=\"6%\" class=\"Box\"  readonly=\"readonly\"  id=\"intVal1."
				+ (rowCount - 1)
				+ "\" value=" + intVal1 + " >";
		row.insertCell(3).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].intVal2\" size=\"6%\" class=\"Box\"  readonly=\"readonly\"  id=\"intVal2."
				+ (rowCount - 1)
				+ "\" value=" + intVal2 + " >";
		row.insertCell(4).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].intLevel\" size=\"13%\" class=\"Box\"  readonly=\"readonly\"  id=\"intLevel_SB."
				+ (rowCount - 1) + "\" value=" + intLevel + " >";
		row.insertCell(5).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strUser1\" size=\"12%\" class=\"Box\"  readonly=\"readonly\"  id=\"strUser1_SB."
				+ (rowCount - 1) + "\" value=" + strUser1 + " >";
		row.insertCell(6).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strUser2\" size=\"12%\" class=\"Box\"  readonly=\"readonly\"  id=\"strUser2_SB."
				+ (rowCount - 1) + "\" value=" + strUser2 + " >";
		row.insertCell(7).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strUser3\" size=\"12%\" class=\"Box\"  readonly=\"readonly\"  id=\"strUser3_SB."
				+ (rowCount - 1) + "\" value=" + strUser3 + " >";
		row.insertCell(8).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strUser4\" size=\"12%\" class=\"Box\"  readonly=\"readonly\"  id=\"strUser4_SB."
				+ (rowCount - 1) + "\" value=" + strUser4 + " >";
		row.insertCell(9).innerHTML = "<input name=\"listclsWorkFlowForSlabBasedAuth["
				+ (rowCount - 1)
				+ "].strUser5\" size=\"12%\" class=\"Box\"  readonly=\"readonly\"  id=\"strUser5_SB."
				+ (rowCount - 1) + "\" value=" + strUser5 + " >";
		row.insertCell(10).innerHTML = '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow_SB(this)">';
		return false;
	}

	function funDeleteRow(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblAuthorization");
		table.deleteRow(index);
	}
	function funDeleteRow_SB(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblAuthorizationSlabBased");
		table.deleteRow(index);
	}

	function funHelp(transactionName, id) 
	{
		fieldName = transactionName;
		selectedFieldId = id;		
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
	
	function funSetData(code) 
	{
		switch(fieldName)
		{
			case "treeMasterForm":
				if (selectedFieldId == 'strFormName')
				{
					document.getElementById("strFormName").value = code;
				} 
				else if (selectedFieldId == 'strFormName_SB')
				{
					document.getElementById("strFormName_SB").value = code;
				}	
				
				break;
				
			case "tcForSetup":
					funSetTCFields(code);
				break;
				
			case "reason":
				funGetReason(code);
			break;	
		}
		
	}

	
	function funSetTCFields(code)
	{
		$.ajax({
	        type: "GET",
	        url: getContextPath()+"/loadTCForSetup.html?tcCode="+code,
	        dataType: "json",
	        success: function(response)
	        {
	        	$("#txtTCCode").val(response.strTCCode);
		        $("#lblTCName").text(response.strTCName);
		        $("#txtTCDesc").focus();
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
	function funGetReason(code) {
		
		$.ajax({
				type : "GET",
				url : getContextPath()
						+ "/loadReasonMasterData.html?reasonCode=" + code,
				dataType : "json",
				success : function(response) {
					if('Invalid Code' == response.strReasonCode){
						alert("Invalid reason Code");
						$("#txtReasonCode").val('');
						$("#txtReasonName").val('');
						$("#txtReasonCode").focus();
					}else{
						$("#txtReasonCode").val(response.strReasonCode);
						$("#txtReasonName").text(response.strReasonName);
						 
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
	
	function funAddTCRows()
	{
		var table = document.getElementById("tblTermsAndCond");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var tcCode=$("#txtTCCode").val();
	    var tcName=$("#lblTCName").text();
	    var tcDesc=$("#txtTCDesc").val();
	    
	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listTCForSetup["+(rowCount)+"].strTCCode\" id=\"txtTCCode."+(rowCount)+"\" value='"+tcCode+"' />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listTCForSetup["+(rowCount)+"].strTCName\" id=\"txtTCName."+(rowCount)+"\" value='"+tcName+"' />";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"80%\" name=\"listTCForSetup["+(rowCount)+"].strTCDesc\" id=\"txtTCDesc."+(rowCount)+"\" value='"+tcDesc+"' />";	    
	    row.insertCell(3).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTCRow(this)">';
	    funResetTCFields();
	}
	
	
	function funDeleteTCRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblTermsAndCond");
	    table.deleteRow(index);
	}
	
	function funResetTCFields() 
	{
	    $("#txtTCCode").val("");
	    $("#lblTCName").text("");
	    $("#txtTCDesc").val("");
	}	
	
	
	function funGetProperty(propertyCode) {
		if (propertyCode=='--select--') {	
			window.location.href ="frmSetup.html";		
		} else {
			
			document.setupForm.action = "loadPropertySetupForm.html";
			document.setupForm.submit();
			
		}
	}

	function funOnChangeCriteria() {
		if ($("#strCriteria").val() == ">" || $("#strCriteria").val() == "<") {
			$('#intVal2').css('visibility', 'hidden');

		} else {
			$('#intVal1').css('visibility', 'visible');
			$("#intVal2").css('visibility', 'visible');
		}
	}
	function funOnChange(id) {
		
		if (id == 'intLevel') {
			if ($("#intLevel").val() == "") {
				$('#strUser1').css('visibility', 'hidden');
				$("#strUser2").css('visibility', 'hidden');
				$("#strUser3").css('visibility', 'hidden');
				$("#strUser4").css('visibility', 'hidden');
				$("#strUser5").css('visibility', 'hidden');
			} else if ($("#intLevel").val() == "1") {
				$('#strUser1').css('visibility', 'visible');
				$("#strUser2").css('visibility', 'hidden');
				$("#strUser3").css('visibility', 'hidden');
				$("#strUser4").css('visibility', 'hidden');
				$("#strUser5").css('visibility', 'hidden');
			} else if ($("#intLevel").val() == "2") {
				$('#strUser1').css('visibility', 'visible');
				$("#strUser2").css('visibility', 'visible');
				$("#strUser3").css('visibility', 'hidden');
				$("#strUser4").css('visibility', 'hidden');
				$("#strUser5").css('visibility', 'hidden');
			} else if ($("#intLevel").val() == "3") {
				$('#strUser1').css('visibility', 'visible');
				$("#strUser2").css('visibility', 'visible');
				$("#strUser3").css('visibility', 'visible');
				$("#strUser4").css('visibility', 'hidden');
				$("#strUser5").css('visibility', 'hidden');
			} else if ($("#intLevel").val() == "4") {
				$('#strUser1').css('visibility', 'visible');
				$("#strUser2").css('visibility', 'visible');
				$("#strUser3").css('visibility', 'visible');
				$("#strUser4").css('visibility', 'visible');
				$("#strUser5").css('visibility', 'hidden');
			} else if ($("#intLevel").val() == "5") {
				$('#strUser1').css('visibility', 'visible');
				$("#strUser2").css('visibility', 'visible');
				$("#strUser3").css('visibility', 'visible');
				$("#strUser4").css('visibility', 'visible');
				$("#strUser5").css('visibility', 'visible');
			}
		} else {
			if ($("#intLevel_SB").val() == "") {
				$('#strUser1_SB').css('visibility', 'hidden');
				$("#strUser2_SB").css('visibility', 'hidden');
				$("#strUser3_SB").css('visibility', 'hidden');
				$("#strUser4_SB").css('visibility', 'hidden');
				$("#strUser5_SB").css('visibility', 'hidden');
			} else if ($("#intLevel_SB").val() == "1") {
				$('#strUser1_SB').css('visibility', 'visible');
				$("#strUser2_SB").css('visibility', 'hidden');
				$("#strUser3_SB").css('visibility', 'hidden');
				$("#strUser4_SB").css('visibility', 'hidden');
				$("#strUser5_SB").css('visibility', 'hidden');
			} else if ($("#intLevel_SB").val() == "2") {
				$('#strUser1_SB').css('visibility', 'visible');
				$("#strUser2_SB").css('visibility', 'visible');
				$("#strUser3_SB").css('visibility', 'hidden');
				$("#strUser4_SB").css('visibility', 'hidden');
				$("#strUser5_SB").css('visibility', 'hidden');
			} else if ($("#intLevel_SB").val() == "3") {
				$('#strUser1_SB').css('visibility', 'visible');
				$("#strUser2_SB").css('visibility', 'visible');
				$("#strUser3_SB").css('visibility', 'visible');
				$("#strUser4_SB").css('visibility', 'hidden');
				$("#strUser5_SB").css('visibility', 'hidden');
			} else if ($("#intLevel_SB").val() == "4") {
				$('#strUser1_SB').css('visibility', 'visible');
				$("#strUser2_SB").css('visibility', 'visible');
				$("#strUser3_SB").css('visibility', 'visible');
				$("#strUser4_SB").css('visibility', 'visible');
				$("#strUser5_SB").css('visibility', 'hidden');
			} else if ($("#intLevel_SB").val() == "5") {
				$('#strUser1_SB').css('visibility', 'visible');
				$("#strUser2_SB").css('visibility', 'visible');
				$("#strUser3_SB").css('visibility', 'visible');
				$("#strUser4_SB").css('visibility', 'visible');
				$("#strUser5_SB").css('visibility', 'visible');
			}
		}

	}
	function getContextPath() 
	{
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
	}
	
		function funGetImage()
		{
	
				searchUrl=getContextPath()+"/getCompanyLogo.html";
				$("#item").attr('src', searchUrl);
				funChk();
			
		}
		function funShowImagePreview(input)
		 {
			 
			 if (input.files && input.files[0])
			 {
				 var filerdr = new FileReader();
				 filerdr.onload = function(e) 
				 {
				 $('#item').attr('src', e.target.result);
				 }
				 filerdr.readAsDataURL(input.files[0]);
				
			 }
		 }
		function funChk()
		{
			var strAuditCheckList="${AuditCheckList}";
			if(strAuditCheckList!="")
			{
				var temStr=strAuditCheckList.split(",");
				var table = document.getElementById("tblAudit");
		    	var rowCount = table.rows.length;
		    	var row = table.insertRow(rowCount);
		    	var FromNames="";
		    	for(var i=0;i<rowCount;i++)
		    	{
		    		var fromName=document.all("strAuditFormName."+i).value;
		    		if(fromName==temStr[i]);
		    		{
		    			document.all("strcbAudit."+i).checked="true";
		    		}
		    		
		    	}
			}
		}
		function funGetCheckedAuditForm()
		{
			var table = document.getElementById("tblAudit");
	    	var rowCount = table.rows.length;
	    	var row = table.insertRow(rowCount);
	    	var FromNames="";
	    	for(var i=0;i<rowCount;i++)
	    		{
	    			if(document.all("strcbAudit."+i).checked=="true")
	    				{
	    					var fromName=document.all("strAuditFormName."+i).value;
	    					FromNames=FromNames+","+fromName;
	    				}
	    		}
			$("#strCheckedAuditFormName").val(FromNames);
		}
		
		
	function funCreateSMS()
	{
		
		var field =$("#cmbSMSField").val();
		var content='';
		var mainSMS =$("#txtSMSContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='PONo')
		{
			content='%%PONo';
		}
		if(field=='PODate')
		{
			content='%%PODate';
		}
		if(field=='DeleveryDate')
		{
			content='%%DeleveryDate';
		}
		if(field=='Amount')
		{
			content='%%Amount';
		}
		if(field=='ContactPerson')
		{
			content='%%ContactPerson';
		}
		
		
		mainSMS+=content;
		$("#txtSMSContent").val(mainSMS);
	}
	
	function funGetLoadPropertyLocation()
	{			
		var isOk=confirm("Do You Want to Select All Location?");
		if(isOk)
		{
			var property= $("#strProperty").val();;
			var searchUrl=getContextPath()+"/loadLocationPropertyWise.html?strProperty="+property;
			//alert(searchUrl);
			$.ajax({
			        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	funRemoveTransactionTimeTable();
			    	$.each(response, function(i,item)
			    	{
			    		funAddTransactionTime(response[i].strLocCode,response[i].strLocName,'12:00pm','12:00pm');
			    	});
			    },
				error: function(e)
			    {
			       	alert('Error:=' + e);
			    }
		      });
		}
	}

	function funAddTransactionTime(locCode, locName, tmeFrom, tmeTo)	{
	    var table = document.getElementById("tblTransactionTable");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    // onClick=\"funCallTime('txttmeFrom."+rowCount+"')\"
	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  size=\"10%\" name=\"listclsTransactionTimeModel["+(rowCount)+"].strLocCode\" id=\"txtLocCode."+(rowCount)+"\" value='"+locCode+"'>";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  size=\"30%\" name=\"listclsTransactionTimeModel["+(rowCount)+"].strLocName\" id=\"txtLocName."+(rowCount)+"\" value='"+locName+"'  >";
	    row.insertCell(2).innerHTML= "<input type=\"text\" class =\"datepicker_recurring_start\"  size=\"10%\" name=\"listclsTransactionTimeModel["+(rowCount)+"].tmeFrom\" id=\"txttmeFrom."+(rowCount)+"\" value='"+tmeFrom+"' onClick=\"funCallTime(this)\" >";
	    row.insertCell(3).innerHTML= "<input type=\"text\"  size=\"10%\" name=\"listclsTransactionTimeModel["+(rowCount)+"].tmeTo\" id=\"txttmeTo."+(rowCount)+"\" value='"+tmeTo+"' onClick=\"funCallTime(this)\">";
	    row.insertCell(4).innerHTML= '<input type="button" class="deletebutton"  value = "Delete" onClick="funDeleteRowTransactionTable(this)">';
	    
	    return false;
}	


	function funRemoveTransactionTimeTable()
    {
		 var table = document.getElementById("tblTransactionTable");
		 var rowCount = table.rows.length;
		 //alert(rowCount);
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		} 
    }
	
	
	function funDeleteRowTransactionTable(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblTransactionTable");
		table.deleteRow(index);
	}
	
	function funCallTime(obj)
	{
		$(obj).timepicker();

	}
		
	
</script>
<title>Insert title here</title>
<%-- <tab:tabConfig /> --%>
</head>
<body onload="funGetImage()">
	<div class="container">
		<label id="formHeading">Setup</label>
		
	<div>
		<s:form action="saveSetupData.html?saddr=${urlHits}" method="POST" name="setupForm" modelAttribute="setUpAttribute" enctype="multipart/form-data">
			<input type="hidden" value="${urlHits}" name="saddr">
			<div class="row">
				<div class="col-md-2">
					<label>Property</label>
					<s:select path="strProperty" items="${properties}" id="strProperty" onchange="funGetProperty(this.value)">
					</s:select>
				</div>
			</div>
			<br/>
			<!--  Start of tabContainer-->
			<div style="border: 0px solid black; width: 100%;height:100%; margin-left: auto; margin-right: auto;">
				<div id="tab_container">
					<ul class="tabs" >
						<li class="active" data-state="tab1">Company</li>
						<li data-state="tab2">General</li>
						<li data-state="tab3">Purchase Order</li>
						<!-- <li data-state="tab4">Authorise</li> -->
						<li data-state="tab5">Process</li>
						<li data-state="tab6">Bank</li>
						<li data-state="tab7">Supplier Performance</li>
						<li data-state="tab8">Authorization(Slab Based)</li>
						<li data-state="tab9">Audit</li>
						<li data-state="tab10">SMS Setup</li>
						<li data-state="tab11">Transaction Time</li>
					</ul>
					<div id="tab1" class="tab_content">
						<br><br>
							<div class="row transTable">
								<div class="col-md-9">
								<div class="row">
									<div class="col-md-3"><!--  style="width:80%;"-->
										<label>Industry Type</label>
										<s:select path="strIndustryType">
											<s:option value="Hospitality">Hospitality</s:option>
											<s:option value="Manufacturing">Manufacturing</s:option> 
											<s:option value="Retailing">Retailing</s:option> 
											<%-- <s:option value="Pharmaceutical">Pharmaceutical</s:option>
											<s:option value="Trading">Trading</s:option>
											<s:option value="Corporate">Corporate</s:option>  --%>										
										</s:select>
									</div>
											

									<div class="col-md-3">
										<s:label path="strCompanyCode">Company Code </s:label>
										<s:input path="strCompanyCode" value="${command.strCompanyCode}" readonly="true"/>
									</div>
									<div class="col-md-3">
										<s:label path="strCompanyName">Name </s:label>
										<s:input path="strCompanyName"  readonly="true"/>
									</div>	
									<div class="col-md-3">
										<label>Financial Year</label>
										<s:input path="strFinYear" readonly="true"/>
									</div>
									<div class="col-md-3">	
										<label>Start Date</label>
										<s:input path="dtStart" id="dtStart" readonly="true"/>
									</div>
									<div class="col-md-3">
										<label>End Date</label>
										<s:input path="dtEnd" id="dtEnd" readonly="true"/>
									</div>
									<div class="col-md-3">
										<label>Last Transaction Date</label>
										<s:input path="dtLastTransDate" id="dtLastTransDate" readonly="true" />
									</div>
									<div class="col-md-3">
									 	<label>Company Logo</label>
										<input  id="companyLogo" name="companyLogo"  type="file" accept="image/png" onchange="funShowImagePreview(this);" />
									</div>
									<div class="col-md-12">
										<label><b>Main Address</b></label>
									</div>
									<div class="col-md-3">
										<label>Address Line 1</label>
										<s:input path="strAdd1" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>Address Line 2</label>
										<s:input path="strAdd2"/>
									</div>
									<div class="col-md-3">
										<label>City</label>
										<s:input path="strCity" cssStyle="text-transform: uppercase;" />
									</div>	
									<div class="col-md-3">
										<label>State</label>
										<s:input path="strState" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>Country</label>
										<s:input path="strCountry" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>Pin</label>
										<s:input path="strPin"/>
									</div>
									<div class="col-md-12">
										<label><b>Billing Address</b></label>
									</div>
									<div class="col-md-3">
										<label>Address Line 1</label>
										<s:input path="strBAdd1" cssStyle="text-transform: uppercase;" />
									</div>

									<div class="col-md-3">
										<label>Address Line 2</label>
										<s:input path="strBAdd2" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>City</label>
										<s:input path="strBCity" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">	
										<label>State</label>
										<s:input path="strBState" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">	
										<label>Country</label>
										<s:input path="strBCountry" cssStyle="text-transform: uppercase;" />
									</div>
									<div class="col-md-3">	
										<label>Pin</label>
										<s:input path="strBPin"/>
									</div>
									<div class="col-md-12">	
										<label><b>Shipping Address</b></label>
									</div>
									<div class="col-md-3">	
										<label>Address Line 1</label>
										<s:input path="strSAdd1" cssStyle="text-transform: uppercase;"/>
									</div>

									<div class="col-md-3">
										<label>Address Line 2</label>
										<s:input path="strSAdd2" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>City</label>
										<s:input path="strSCity" cssStyle="text-transform: uppercase;"/>
									</div>
									<div class="col-md-3">
										<label>State</label>
										<s:input path="strSState" />
									</div>
									<div class="col-md-3">
										<label>Country</label>
										<s:input path="strSCountry" cssStyle="text-transform: uppercase;" />
									</div>
									<div class="col-md-3">	
										<label>Pin</label>
										<s:input path="strSPin"/>
									</div>
									<div class="col-md-12">
										<label><b>Others</b></label>
									</div>
									<div class="col-md-3">
										<label>Phone No</label>
										<s:input path="strPhone"/>
									</div>
									<div class="col-md-3">
										<label>Fax</label>
										<s:input path="strFax"/>
									</div>
									<div class="col-md-3">
										<label>Email id</label>
										<s:input path="strEmail" type="text" placeholder="Enter a valid email address"/>
									</div>
									<div class="col-md-3">
										<label>Website</label>
										<s:input type="text" placeholder="Enter a valid Website"  path="strWebsite"/>Starting with http or https
									</div>
									<div class="col-md-3">
										<label>Due Days</label>
										<s:input path="intDueDays"/>
									</div>
									<div class="col-md-3">
										<label>P.L.A. No.</label>
										<s:input path="strMask"/>
									</div>
									<div class="col-md-3">
										<label>CST No/GST No</label>
										<s:input path="strCST"/>
									</div>
									<div class="col-md-3">
										<label>VAT No</label>
										<s:input path="strVAT"/>
									</div>
									<div class="col-md-3">
										<label>Service Tax No</label>
										<s:input path="strSerTax"/>
									</div>
									<div class="col-md-3">
										<label>Pan No </label>
										<s:input path="strPanNo"/>
									</div>
									<div class="col-md-3">
										<label>Location Code No </label>
										<s:input path="strLocCode"/>
									</div>
									<div class="col-md-3">
										<label>Asseese Code No </label>
										<s:input path="strAsseeCode"/>
									</div>
									<div class="col-md-3">
										<label>Purchase Email </label>
										<s:input path="strPurEmail" type="text" placeholder="Enter a valid email address"/>
									</div>
									<div class="col-md-3">
										<label>Sales Email</label>
										<s:input type="text" placeholder="Enter a valid email address" path="strSaleEmail"/>
									</div>
									<div class="col-md-3">
										<label>Range Address</label>
										<s:input path="strRangeAdd" />
									</div>
									<div class="col-md-3">
										<label>Range</label>
										<s:input path="strRangeDiv"/>
									</div>
									<div class="col-md-3">
										<label>Commisionerate </label>
										<s:input path="strCommi" />
									</div>
									<div class="col-md-3">
										<label>C.Ex Reg No</label>
										<s:input path="strRegNo" />
									</div>
									<div class="col-md-3">
										<label>Division </label>
										<s:input path="strDivision"/>
									</div>
									<div class="col-md-3">
										<label>Division Address</label>
										<s:input path="strDivisionAdd" />
									</div>
									<div class="col-md-3">
										<label>Bond Amount</label>
										<s:input path="dblBondAmt" />
									</div>
									<div class="col-md-3">
										<label>Acceptance No.</label>
										<s:input path="strAcceptanceNo" />
									</div>
									<div class="col-md-3">
										<label>E.C.C.No.</label>
										<s:input path="strECCNo" />
									</div>	
								</div>
							</div>	
							<div class="col-md-2">
								 <div  style="background-color: #fbfafa;">
					       			<img id="item" src=""  style="width:150px;height:150px;" alt="img" />
					       		</div>
								
							</div>					
						</div>
					</div>
						<div id="tab2" class="tab_content">
							<br>
							<br>
								<div class="row transTable">
									<div class="col-md-2">
										<label>Allow Negative Stock</label>
										<s:select path="strNegStock" style="width:60%;">
											<s:option value="Y">YES</s:option>
											<s:option value="N">NO</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Rate PickUp From</label>
										<s:select path="strRatePickUpFrom" cssStyle="width:auto">
											<s:option value="SupplierRate">Last Supplier Rate</s:option>
											<s:option value="PurchaseRate">Purchase Rate</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Production Order BOM</label>
										<s:select path="strPOBOM">
												<s:option value="FIRST">FIRST LEVEL</s:option>
												<s:option value="LAST">LAST LEVEL</s:option>
											</s:select>
									</div>
									<div class="col-md-2">
										<label>Sales Order BOM</label>
										<s:select path="strSOBOM">
											<s:option value="FIRST">FIRST LEVEL</s:option>
											<s:option value="LAST">LAST LEVEL</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Total Working Time(min)</label>
										<s:input path="strTotalWorkhour"/>
									</div>
									<div class="col-md-2"></div>
									
									<div class="col-md-2">	
										<label>From Time </label>
										<s:input path="dtFromTime" id="dtFromTime"/>
									</div>
									<div class="col-md-2">	
										<label>To Time</label>
										<s:input path="dtToTime" id="dtToTime"/>
									</div>
									<div class="col-md-2">	
										<label>Show All Product To All Location</label><br>
										<s:checkbox path="strShowAllProdToAllLoc" value="Y" />	
									</div>
									<div class="col-md-2">	
										<label>Workflowbased Authorisation </label>
										<s:select path="strWorkFlowbasedAuth" style="width:60%;">
											<s:option value="Y">YES</s:option>
											<s:option value="N">NO</s:option>
											<%-- <s:option value="S">SLAB BASED</s:option> --%>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Location Wise Production Order </label>
										<s:checkbox path="strLocWiseProductionOrder" value="Y" />		
									</div>	
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Amount Decimal Places</label>
										<s:select path="intdec" id="intdec" style="width:60%;">
												<s:option value="-1">-1</s:option>
												<s:option value="0">0</s:option>
												<s:option value="1">1</s:option>
												<s:option value="2">2</s:option>
												<s:option value="3">3</s:option>
												<s:option value="4">4</s:option>
												<s:option value="5">5</s:option>
												<s:option value="6">6</s:option>
												<s:option value="7">7</s:option>
												<s:option value="8">8</s:option>
												<s:option value="9">9</s:option>
												<s:option value="10">10</s:option>
												
											</s:select>
									</div>
									<div class="col-md-2">
										<label>Quantity Decimal Places</label>
										<s:select path="intqtydec" id="intqtydec" style="width:60%;">
												<s:option value="0">0</s:option>
												<s:option value="1">1</s:option>
												<s:option value="2">2</s:option>
												<s:option value="3">3</s:option>
												<s:option value="4">4</s:option>
												<s:option value="5">5</s:option>
											</s:select>
									</div>
									<div class="col-md-2">
										<label>List Price in PO</label>
										<s:select path="strListPriceInPO" id="strListPriceInPO">
											<s:option value="L">List Price</s:option>
											<s:option value="S">Supplier Price</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Finance Module</label><br>
										<s:checkbox path="strCMSModule" value="Y" />
									</div>

									<div class="col-md-2">
										<label>Batch Method</label>
										<s:select path="strBatchMethod" id="strBatchMethod" style="width:70%;">
											<s:option value="Manual">Manual</s:option>
											<s:option value="FIFO">FIFO</s:option>
										</s:select>
									</div>
									<div class="col-md-2"></div><br><br><br>
									<div class="col-md-2">	
										<label>Tally Posting Type</label>
										<s:select path="strTPostingType" id="strTPostingType">
											<s:option value="Basic">Linkup Based</s:option>
											<s:option value="ST">Consider SubTotal As Taxable</s:option>
											<s:option value="STandTaxes">Consider SubTotal + Taxes as Taxable</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Auto DC for TaxInvoice</label>
										<s:checkbox path="strAutoDC" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Audit</label><br>
										<s:checkbox path="strAudit" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Value In Requisition</label>
										<s:checkbox path="strShowReqVal" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Stock In Requisition</label>
										<s:checkbox path="strShowStkReq" value="Y" />
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Show Value In MIS Slip</label><br>
										<s:checkbox path="strShowValMISSlip" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Change UOM In Transaction</label>
										<s:checkbox path="strChangeUOMTrans" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Location Wise Product In Product Master</label>
										<s:checkbox path="strShowProdMaster" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Property Wise Document</label>
										<s:checkbox path="strShowProdDoc" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Transaction Help Asc/Desc</label>
										<s:select path="strShowTransAsc_Desc" id="strShowTransAsc_Desc" style="width:80%;" >
											<s:option value="Asc">Ascending</s:option>
											<s:option value="Desc">Descending</s:option>
										</s:select>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Allow Date Change In MIS</label>
										<s:checkbox path="strAllowDateChangeInMIS" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Allow Name Change In Product Master </label>
										<s:checkbox path="strNameChangeProdMast" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Stock Adjustement Reason Code</label>
										<s:select id="cmbReason" name="txtReasonCode" path="strStkAdjReason" >
											<s:options items="${listReason}" />
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Notification Time Interval</label>
										<s:input type="number" path="intNotificationTimeinterval" step="any" min="1" cssStyle="width:50%;" />
			
									</div>
									<div class="col-md-2">
										<label>Month End</label><br>
										<s:checkbox path="strMonthEnd" value="Y" />
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Show Avg Qty In Production Order</label>
										<s:checkbox path="strShowAvgQtyInOP" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Stock In Production Order</label>
										<s:checkbox path="strShowStockInOP" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Avg Qty In Sales Order</label>
										<s:checkbox path="strShowAvgQtyInSO" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show Stock In Sales Order</label>
										<s:checkbox path="strShowStockInSO" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Effect Of Disc On PO</label><br>
										<s:checkbox path="strEffectOfDiscOnPO" value="Y" />
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Invoice Print Formate</label>
										<s:select path="strInvFormat" id="strInvFormat">
												<s:option value="Format 1">Invoice Format 1</s:option>
												<s:option value="Format 2">Invoice Format 2</s:option>
												<s:option value="RetailNonGSTA4">Format 3 Retail A4</s:option>
												<%-- <s:option value="RetailNonGSTA4">Format 4 Retail Non GST A4</s:option> --%>
												<s:option value="Format 4 Inv Ret">Format 4 Retail 40Col</s:option>
												<s:option value="Format 5">Format 5</s:option>
												<s:option value="Format 6">Format 6</s:option>
												<s:option value="Format 7">Format 7</s:option>
												<s:option value="Format 8">Format 8</s:option>
											</s:select>
									</div>
									<div class="col-md-2">
										<label>Invoice Print Note</label>
										<s:textarea cssStyle="height:25px;" id="txtSMSContent" path="strInvNote"  />
									</div>
									<div class="col-md-2">
										<label>Currency</label>
										<s:select path="strCurrencyCode" id="txtCurrencyCode" >
											<s:options items="${listCurrency}" />
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Show All Properties Customer</label>
										<s:checkbox path="strShowAllPropCustomer" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Effect of Invoice In Stock After</label>
										<s:select path="strEffectOfInvoice" id="txtEffectOfInvoice"  >
											<s:option value="DC" >Delivery Challan</s:option>
											<s:option value="Invoice">Invoice</s:option>
										</s:select>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Effect of GRN in WebBooks</label>
										<s:select path="strEffectOfGRNWebBook" id="txtEffectOfGRNWebBook" >
											<s:option value="SCBill" >Sundry Creditor Bill</s:option>
											<s:option value="Payment">Payment</s:option>
											</s:select>
									</div>
									<div class="col-md-2">
										<label>Multiple Currency</label>
										<s:select path="strMultiCurrency" id="strMultiCurrency" style="width:70%;">
											<s:option value="N">NO</s:option>
											<s:option value="Y">YES</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Show All Supp/ Cust/SubCont to All Property</label>
										<s:checkbox path="strShowAllPartyToAllLoc" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Show All Taxes on Transaction</label>
										<s:checkbox path="strShowAllTaxesOnTransaction" value="Y" />
									</div>
									<div class="col-md-2">
										<label>Sales Order KOT Print</label><br>
										<s:checkbox id="chkSOKOTPrint" path="strSOKOTPrint"  onclick="funCheckBoxClicked(this)"/>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Rate History Format</label>
										<s:select path="strRateHistoryFormat" id="strRateHistoryFormat">
												<s:option value="Format 1">Format 1</s:option>
												<s:option value="Format 2">Format 2</s:option>
										</s:select>
									</div>	
									<div class="col-md-2">
										<label>PO Slip Format</label>
										<s:select path="strPOSlipFormat" id="strPOSlipFormat">
												<s:option value="Format 1">Format 1</s:option>
												<s:option value="Format 2">Format 2</s:option>
												<s:option value="Format 3">Format 3 (Global)</s:option>
												<s:option value="Format 4">Format 4</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Sales Return Slip Format</label>
										<s:select path="strSRSlipFormat" id="strSRSlipFormat">
											<s:option value="Format 1">Format 1</s:option>
											<s:option value="Format 2">Format 2</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Calculation for Weighted Avg Price</label>
										<s:select path="strWeightedAvgCal" id="strWeightedAvgCal">
											<s:option selected="selected" value="Company Wise">Company Wise</s:option>
											<s:option value="Property Wise">Property Wise</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>GRN Rate Editable</label>
										<s:select path="strGRNRateEditable" id="strGRNRateEditable" cssStyle="width:50%">
											<s:option selected="selected" value="Yes">Yes</s:option>
											<s:option value="No">No</s:option>
										</s:select>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">
										<label>Sales Order Rate Editable</label>
										<s:select path="strSORateEditable" id="strSORateEditable" cssStyle="width:50%">
											<s:option selected="selected" value="Yes">Yes</s:option>
											<s:option value="No">No</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Invoice Rate Editable</label>
										<s:select path="strInvoiceRateEditable" id="strInvoiceRateEditable" cssStyle="width:50%">
											<s:option selected="selected" value="Yes">Yes</s:option>
											<s:option value="No">No</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Settlement Wise Invoice Series</label>
										<s:select path="strSettlementWiseInvSer" id="strSettlementWiseInvSer" cssStyle="width:50%">
											<s:option selected="selected" value="No">No</s:option>
											<s:option  value="Yes">Yes</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Show GRN Product PO Wise</label>
										<s:select path="strGRNProdPOWise" id="GRNProdPOWise" cssStyle="width:50%">
											<s:option selected="selected" value="No">No</s:option>
											<s:option  value="Yes">Yes</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>PO Rate Editable</label>
										<s:select path="strPORateEditable" id="strPORavteEdit" cssStyle="width:50%">
											<s:option selected="selected" value="Yes">Yes</s:option>
											<s:option  value="No">No</s:option>
										</s:select>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">	
										<label>Use Current Date For Transaction</label>
										<s:select path="strCurrentDateForTransaction" id="cmbAllowBackDateTransaction" cssStyle="width:50%">
											<s:option selected="selected" value="No">No</s:option>
											<s:option  value="Yes">Yes</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Round Off Final Amt On Transaction</label>
										<s:checkbox path="strRoundOffFinalAmtOnTransaction" value="Y"/> 
									</div>
									<div class="col-md-2">
										<label>Post Round Off Amount to WebBooks</label>
										<s:checkbox path="strPOSTRoundOffAmtToWebBooks" value="Y"/> 
									</div>
									<div class="col-md-2">
										<label>Recipe List Price By</label>
										<s:select path="strRecipeListPrice" id="strReceipeListPrice">
											<s:option value="Received">Received</s:option>
											<s:option value="Recipe">Recipe</s:option>
										</s:select>
									</div>
									<div class="col-md-2">
										<label>Include Tax In Weight Average price</label>
										<s:checkbox path="strIncludeTaxInWeightAvgPrice" value="Y"/> 
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">	
										<label>Batching First in first out(FIFO) </label>
										<%--  <s:checkbox  path="strFifo" value="Y"/> --%>
										<%-- <tr>
										<td>Last Supplier Rate Show In StockFlash and Ledger </td>
										<td>	
										<s:checkbox path="strLastSuppRateShowInStockFlash" value="Y"/></td>
										</tr> --%>
									</div>
									<div class="col-md-2"></div>
									<div class="col-md-2">	
										<label>Check POS Sales In Physical Post </label>
										<s:checkbox path="strCheckPOSSales" value="Y"/>
									</div>
									
									<div class="col-md-2"></div>
									<div class="col-md-2">	
										<label>Show All Products </label>
										<s:checkbox path="strShowAllProducts" value="Y"/>
									</div>
									
									
								</div>
							</div>
				
					<div id="tab3" class="tab_content">
							<div class="masterTable" style="width:95%; padding-top:10px;" >								
								<h6> Purchase Order Terms Conditions</h6>								
							</div>
							
							<div class="row transTableMiddle1">
								<div class="col-md-2">
									<label class="namelabel">TC Code</label>
									<input id="txtTCCode" ondblclick="funHelp('tcForSetup')" class="searchTextBox" />
								</div>
								<div class="col-md-2">								
									<label id="lblTCName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 41%; margin-top: 26px; text-align: center;"></label>
								</div>
								<div class="col-md-2">
									 <label class="namelabel">TC Description</label> 
									 <input id="txtTCDesc" type="text"/>
								</div>
								<div class="col-md-2">
									<input type="Button" value="Add" id="btnAddTC" class="btn btn-primary center-block"  style="margin:23px;"/>
								</div>
							</div>
							
							<div class="dynamicTableContainer" style="height: 250px; background:#fbfafa;">
								<table style="height: 20px; border: #0F0;width: 100%;font-size:11px; font-weight: bold;">
									<tr bgcolor="#c0c0c0">
										<td width="20%">TC Code</td>
										<td width="20%">TC Name</td>
										<td width="48%">TC Description</td>
										<td width="20%">Delete</td>
									</tr>
								</table>
								<div>
									<table id="tblTermsAndCond" style="width:100%; border:
											#0F0;table-layout:fixed;overflow:scroll;" class="transTablex col4-center">
										<c:forEach items="${listTCForSetup}" var="SB" varStatus="status">
											<tr>
												<td style="width: 34%; height: 12px;"><input size="27%" class="Box"  readonly="readonly"
													name="listTCForSetup[${status.index}].strTCCode"
													value="${SB.strTCCode}" /></td>
		
												<td style="width:35%; height: 12px;"><input size="11%" class="Box" readonly="readonly"
													name="listTCForSetup[${status.index}].strTCName"
													value="${SB.strTCName}" /></td>
		
												<td style="width: 84%; height: 12px;"><input size="11%" class="Box" readonly="readonly"
													name="listTCForSetup[${status.index}].strTCDesc"
													value="${SB.strTCDesc}" /></td>
		
												<td style="width: 20%; height: 12px;"><input type="Button" value="Delete" size="5%" 
													onClick="Javacsript:funDeleteTCRow(this)" class="deletebutton"/></td>
											</tr>
										</c:forEach>
									</table>
								</div>
							</div>
						</div>
						<div id="tab5" class="tab_content">
							<br><br>
							<table id="tblprocess" class="transTable" style="background:#fbfafa;">
								<tr>
									<th>Module Flow</th>
								</tr>
								
								<c:forEach items="${processSetupFormList}"
									var="processsetupform" varStatus="status">
									<tr>
										<td>
										<input type="hidden" name="listProcessSetupForm[${status.index}].strFormName"
											value="${processsetupform.strFormName}"/>
										<input
											name="listProcessSetupForm[${status.index}].strFormDesc"
											value="${processsetupform.strFormDesc}" readonly="readonly"  class="Box"/></td>
										<c:choose>

											<c:when
												test="${processsetupform.strFormName == 'frmPurchaseIndent'}">
												<%-- <td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesOrder"
													<c:if test="${processsetupform.strSalesOrder == 'Sales Order'}">checked="checked"</c:if>
													value="Sales Order">Sales Order<br></td> --%>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order">Production Order<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strMinimumLevel"
													<c:if test="${processsetupform.strMinimumLevel == 'Minimum Level'}">checked="checked"</c:if>
													value="Minimum Level">Minimum Level <br></td>
												<td colspan="3"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strRequisition"
													<c:if test="${processsetupform.strRequisition == 'Requisition'}">checked="checked"</c:if>
													value="Requisition">Requisition<br></td>
											</c:when>

											<c:when
												test="${processsetupform.strFormName == 'frmPurchaseOrder'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<td ><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order">Production Order<br></td>
													
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strPurchaseIndent"
													<c:if test="${processsetupform.strPurchaseIndent == 'Purchase Indent'}">checked="checked"</c:if>
													value="Purchase Indent">Purchase Indent<br></td>	
											</c:when>

											<c:when test="${processsetupform.strFormName == 'Job Order'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesOrder"
													<c:if test="${processsetupform.strSalesOrder == 'Sales Order'}">checked="checked"</c:if>
													value="Sales Order">Sales Order<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order">Production Order<br></td>
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>

											<c:when
												test="${processsetupform.strFormName == 'Sales Direct Billing'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesOrder"
													<c:if test="${processsetupform.strSalesOrder == 'Sales Order'}">checked="checked"</c:if>
													value="Sales Order">Sales Order<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strServiceOrder"
													<c:if test="${processsetupform.strServiceOrder == 'Service Order'}">checked="checked"</c:if>
													value="Service Order"> Service Order <br></td>
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>

											<c:when
												test="${processsetupform.strFormName == 'frmMaterialReq'}">
													<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strWorkOrder"
													<c:if test="${processsetupform.strWorkOrder == 'Work Order'}">checked="checked"</c:if>
													value="Work Order"> Work Order <br></td>
												
											    <td colspan="2"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order"> Production Order <br></td>		
													
													
											</c:when>


											<c:when
												test="${processsetupform.strFormName == 'frmMIS'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strRequisition"
													<c:if test="${processsetupform.strRequisition == 'Requisition'}">checked="checked"</c:if>
													value="Requisition">Requisition<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strWorkOrder"
													<c:if test="${processsetupform.strWorkOrder == 'Work Order'}">checked="checked"</c:if>
													value="Work Order"> Work Order <br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProject"
													<c:if test="${processsetupform.strProject == 'Project'}">checked="checked"</c:if>
													value="Project"> Project <br></td>
													
													<td colspan="2"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order"> Production Order <br></td>
											</c:when>


											<c:when test="${processsetupform.strFormName == 'frmGRN'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strPurchaseOrder"
													<c:if test="${processsetupform.strPurchaseOrder == 'Purchase Order'}">checked="checked"</c:if>
													value="Purchase Order">Purchase Order<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strPurchaseReturn"
													<c:if test="${processsetupform.strPurchaseReturn == 'Purchase Return'}">checked="checked"</c:if>
													value="Purchase Return">Purchase Return<br></td>
												<%-- <td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strServiceOrder"
													<c:if test="${processsetupform.strServiceOrder == 'Service Order'}">checked="checked"</c:if>
													value="Service Order">Service Order<br></td> --%>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<%-- <td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesReturn"
													<c:if test="${processsetupform.strSalesReturn == 'Sales Return'}">checked="checked"</c:if>
													value="Sales Return"> Sales Return <br></td> --%>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strRateContractor"
													<c:if test="${processsetupform.strRateContractor == 'Rate Contractor'}">checked="checked"</c:if>
													value="Rate Contractor"> Rate Contractor <br></td>
												
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strInvoice"
													<c:if test="${processsetupform.strInvoice == 'Invoice'}">checked="checked"</c:if>
													value="Invoice"> Invoice <br></td>	
													
													<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDeliverySchedule"
													<c:if test="${processsetupform.strDeliverySchedule == 'Delivery Schedule'}">checked="checked"</c:if>
													value="Delivery Schedule"> Delivery Schedule <br></td>
													
													
											</c:when>


											<c:when
												test="${processsetupform.strFormName == 'frmPurchaseReturn'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strGRN"
													<c:if test="${processsetupform.strGRN == 'GRN'}">checked="checked"</c:if>
													value="GRN"> GRN <br></td>
												<td colspan="5"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>


											<c:when
												test="${processsetupform.strFormName == 'Sub Contractor GRN'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDeliveryNote"
													<c:if test="${processsetupform.strDeliveryNote == 'Delivery Note'}">checked="checked"</c:if>
													value="Delivery Note">Delivery Note<br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strOpeningStock"
													<c:if test="${processsetupform.strOpeningStock == 'Opening Stock'}">checked="checked"</c:if>
													value="Opening Stock">Opening Stock<br></td>
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>


											<c:when
												test="${processsetupform.strFormName == 'Delivery Note'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strGRN"
													<c:if test="${processsetupform.strGRN == 'GRN'}">checked="checked"</c:if>
													value="GRN"> GRN <br></td>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSubContractorGRN"
													<c:if test="${processsetupform.strSubContractorGRN == 'Sub Contractor GRN'}">checked="checked"</c:if>
													value="Sub Contractor GRN"> Sub Contractor GRN <br></td>
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>
											
											
											
											<c:when
												test="${processsetupform.strFormName == 'frmMaterialReturn'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<td colspan="6"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strMIS"
													<c:if test="${processsetupform.strMIS == 'MIS'}">checked="checked"</c:if>
													value="MIS"> MIS <br></td>
											</c:when>
											
											
											

											<c:when
												test="${processsetupform.strFormName == 'Excise Challan'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strPurchaseReturn"
													<c:if test="${processsetupform.strPurchaseReturn == 'Purchase  Return'}">checked="checked"</c:if>
													value="Purchase  Return">Purchase Return<br></td>
												<td colspan="4"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDeliveryNote"
													<c:if test="${processsetupform.strDeliveryNote == 'Delivery Note'}">checked="checked"</c:if>
													value="Delivery Note"> Delivery Note <br></td>
											</c:when>


											<c:when
												test="${processsetupform.strFormName == 'frmProductionOrder'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>												
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesOrder"
													<c:if test="${processsetupform.strSalesOrder == 'Sales Order'}">checked="checked"</c:if>
													value="Sales Order">Sales Order<br></td>
												<td colspan="5"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDeliveryNote"
													<c:if test="${processsetupform.strDeliveryNote == 'Delivery Note'}">checked="checked"</c:if>
													value="Delivery Note"> Delivery Note <br></td>
											</c:when>

											
											<c:when
												test="${processsetupform.strFormName == 'frmBillPassing'}">
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strGRN"
													<c:if test="${processsetupform.strGRN == 'GRN'}">checked="checked"</c:if>
													value="GRN"> GRN <br></td>
											</c:when>
											
											<c:when
												test="${processsetupform.strFormName == 'frmWorkOrder'}">
												<%-- <td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strSalesOrder"
													<c:if test="${processsetupform.strSalesOrder == 'Sales Order'}">checked="checked"</c:if>
													value="Sales Order">Sales Order<br></td> --%>
												<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strProductionOrder"
													<c:if test="${processsetupform.strProductionOrder == 'Production Order'}">checked="checked"</c:if>
													value="Production Order">Production Order<br></td>
												<%-- <td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strServiceOrder"
													<c:if test="${processsetupform.strServiceOrder == 'Service Order'}">checked="checked"</c:if>
													value="Service Order"> Service Order <br></td> --%>
												<td colspan="3"><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
											</c:when>
											
											<c:when
												test="${processsetupform.strFormName == 'frmStockReq'}">
													<td><input type="checkbox"
													name="listProcessSetupForm[${status.index}].strDirect"
													<c:if test="${processsetupform.strDirect == 'Direct'}">checked="checked"</c:if>
													value="Direct"> Direct <br></td>
												<p>aaa</p>
											</c:when>
										</c:choose>
									</tr>
								</c:forEach>
							</table>
							</div>
						
						<div id="tab6" class="tab_content">
							<br><br>
							<div class="row transTable">
								<div class="col-md-3">	
									<label>Bank Name</label>
									<s:input path="strBankName" cssStyle="text-transform: uppercase;" />
								</div>
								<div class="col-md-3">
									<label>Branch Name</label>
									<s:input path="strBranchName" cssStyle="text-transform: uppercase;" />
								</div>
								<div class="col-md-3">
									<label>AddressLine1</label>
									<s:input path="strBankAdd1" cssStyle="text-transform: uppercase;"/>
								</div>
								<div class="col-md-3"></div>
								<div class="col-md-3">
									<label>AddressLine2</label>
									<s:input path="strBankAdd2" cssStyle="text-transform: uppercase;" />
								</div>
								<div class="col-md-3">
									<label>City</label>
									<s:input path="strBankCity" cssStyle="text-transform: uppercase;"/>
								</div>
								<div class="col-md-3">
									<label>Account Number </label>
									<s:input path="strBankAccountNo" />
								</div>
								<div class="col-md-3"></div>
								<div class="col-md-3">
									<label>SwiftCode </label>
									<s:input path="strSwiftCode"/>
								</div>
							</div>
						</div>
						<div id="tab7" class="tab_content">
							<br><br>
							<div class="row transTable">
								<div class="col-md-12">
									<h6>Supplier Performance</h6>
								</div>
								<div class="col-md-2">
									<label>Late (Delay)</label>
									<s:input path="strLate"/>
									 <span id="percent-sign">%</span>
								</div>	
								<div class="col-md-2">
									<label>Rejection</label>
									<s:input path="strRej"/>
 									<span id="percent-sign">%</span>
								</div>
								<div class="col-md-2">
									<label>Price Change</label>
									<s:input path="strPChange" />
									 <span id="percent-sign">%</span>
								</div>	
								<div class="col-md-2">
									<label>Excess Delay</label>
									<s:input path="strExDelay"/>
									<span id="percent-sign">%</span>
								</div>	
							</div>
						</div>
						<div id="tab8" class="tab_content">
						<br><br>
							<div class="row transTable">
								<div class="col-md-12">
									<h6>Authorization(Slab Based) </h6>
								</div>
								
									<!-- 	<td><label>Form Name</label></td> -->
								<div class="col-md-2">
									<label>Form Name</label>
									<input type="text" ondblclick="funHelp('treeMasterForm',this.id)"
										id="strFormName_SB" class="searchTextBox">
								</div>
								<div class="col-md-2">
									<label >Criteria</label>
									<select  id="strCriteria"  onchange="funOnChangeCriteria()" style="width:70%">
										<option value="<">&lt;</option>
										<option value=">">&gt;</option>
										<option value="between">between</option>
									</select>
								</div>
								<div class="col-md-2">
									<input type="text" id="intVal1" style="margin-top:24px;">
								</div>
								<div class="col-md-2">
									<input type="text" id="intVal2" style="margin-top:24px;" >
								</div>
								<div class="col-md-4"></div>
								<div class="col-md-2">
									<label>Levels</label>
									<select id="intLevel_SB" onchange="funOnChange(this.id)" >
											<!-- <option value=""></option> -->
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
									</select>
								</div>
								<div class="col-md-2">
									<s:select path="strUserCode1" items="${users}"
											id="strUser1_SB" style="margin-top:24px;">
									</s:select>
								</div>
								<div class="col-md-2">	
									<s:select path="strUserCode2" items="${users}"
										id="strUser2_SB" style="margin-top:24px;">
									</s:select>
								</div>
								<div class="col-md-2">
									<s:select path="strUserCode3" items="${users}"
											id="strUser3_SB" style="margin-top:24px;">
									</s:select>
								</div>
								<div class="col-md-2">
									<s:select path="strUserCode4" items="${users}"
											id="strUser4_SB" style="margin-top:24px;">
										</s:select>
								</div>
								<div class="col-md-2">
									<s:select path="strUserCode5" items="${users}"
											id="strUser5_SB" style="margin-top:24px;">
									</s:select>
								</div>
								<div class="col-md-2">
									<input type="button" value="Add"
										onclick="return btnAdd_onclick_SB()" class="btn btn-primary center-block" style="margin-top:24px;"/>
								</div>
							</div>
								<br>
							<table style="width: 100%;font-size:11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">
									<td style="width: 18%; height: 12px;" align="center">Form Name</td>
									<td style="width: 9%; height: 12px;" align="center">Criteria</td>
									<td style="width: 6%; height: 12px;" align="center">Value1</td>
									<td style="width: 6%; height: 12px;" align="center">Value2</td>
									<td style="width: 10%; height: 12px;" align="center">Level</td>
									<td style="width: 10%; height: 12px;" align="center">Level
										1</td>
									<td style="width: 10%; height: 12px;" align="center">Level
										2</td>
									<td style="width: 10%; height: 12px;" align="center">Level
										3</td>
									<td style="width: 10%; height: 12px;" align="center">Level
										4</td>
									<td style="width: 10%; height: 12px;" align="center">Level
										5</td>
									<td style="width: 5%; height: 12px;" align="center">Delete</td>
								</tr>
							</table>



							<div id="divSlabBase"style="width: 100%; bgcolor: #d8edff; overflow: scroll;height: 150PX; background:#fbfafa;">
								<table id="tblAuthorizationSlabBased" style="overflow: scroll;margin-left: auto;
									margin-right: auto;width: 100%;" class="transTablex col11-center">
									<tr>
										<td style="width: 18%; height: 12px;" align="center"></td>
										<td style="width: 8%; height: 12px;" align="center"></td>
										<td style="width: 6%; height: 12px;" align="center"></td>
										<td style="width: 6%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 10%; height: 12px;" align="center"></td>
										<td style="width: 5%; height: 12px;" align="center"></td>

									</tr>
									<c:forEach items="${listclsWorkFlowForSlabBasedAuth}"
										var="SB" varStatus="status">
										<tr>
											<td style="width: 16%; height: 12px;"><input size="27%" class="Box"  readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strFormName"
												value="${SB.strFormName}" /></td>

											<td style="width: 8%; height: 12px;"><input size="11%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strCriteria"
												value="${SB.strCriteria}" /></td>

											<td style="width: 6%; height: 12px;"><input size="6%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].intVal1"
												value="${SB.intVal1}" /></td>


											<td style="width: 6%; height: 12px;"><input size="6%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].intVal2"
												value="${SB.intVal2}" /></td>

											<td style="width: 10%; height: 12px;"><input size="13%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].intLevel"
												value="${SB.intLevel}" /></td>
 
											<td style="width: 10%; height: 12px;"><input size="12%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strUser1"
												value="${SB.strUser1}" /></td>


											<%-- <td><input
												name="llistclsWorkFlowForSlabBasedAuth[${status.index}].strUser2"
												value="${SB.strUser2}" /></td> --%>

										<td style="width: 10%; height: 12px;"><input size="12%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strUser2"
												value="${SB.strUser2}" /></td>

											<td style="width: 10%; height: 12px;"><input size="12%"  class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strUser3"
												value="${SB.strUser3}" /></td>

											<td style="width: 10%; height: 12px;"><input size="12%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strUser4"
												value="${SB.strUser4}" /></td>

											<td style="width: 10%; height: 12px;"><input size="12%" class="Box" readonly="readonly"
												name="listclsWorkFlowForSlabBasedAuth[${status.index}].strUser5"
												value="${SB.strUser5}" /></td>

											<td style="width: 5%; height: 12px;"><input type="Button" value="Delete" size="5%" 
												onClick="Javacsript:funDeleteRow_SB(this)" class="deletebutton"/></td>
										</tr>
									</c:forEach>
								</table>
						
						</div>
						</div>
						
						
						<div id="tab9" class="tab_content">
							<br><br>
							<table id="tblAudit" class="transTable" style="background:#fbfafa;width:60%;">

								<tr>
									<th colspan="7" align="left">Audit</th>
								</tr>
								
								<c:forEach items="${auditFormList}"
									var="auditsetupform" varStatus="status">
									
									<tr>
									
										<td>
										
											<input type="hidden" id="strAuditFormName.${status.index}"  name="listAuditForm[${status.index}].strFormName"
												value="${auditsetupform.strFormName}"/>
											<input name="listAuditForm[${status.index}].strFormDesc"
											value="${auditsetupform.strFormDesc}" readonly="readonly"  class="Box"/></td>
										
										<td><input type="checkbox" id="strcbAudit.${status.index}" 
													name="listAuditForm[${status.index}].strAuditForm" 
													<c:if test="${auditsetupform.strAuditForm == 'on'}"> checked="checked"</c:if>> 
												 <br></td>
									</tr>

								</c:forEach>
							

							</table>
							</div>
							
							
						<div id="tab10" class="tab_content">
							<br><br>
							<div id="tblAudit" class="row transTable">
								<div class="col-md-2">
									<label >SMS Provider</label>
									<s:select  id="cmbSMSProvider" path="strSMSProvider">
										<option value="SANGUINE">SANGUINE</option>
									</s:select>
								</div>	
								<div class="col-md-2">
									<label >SMS API</label>
									<s:textarea  id="txtSMSAPI" path="strSMSAPI" style="height: 26px;" />
								</div>
								<div class="col-md-8"></div>
								<div class="col-md-3">
									<label >SMS Content For Purchase Order</label>
									<select  id="cmbSMSField" class="BoxW48px" style="width:80%;" >
										<option value="CompanyName">Company Name</option>
										<option value="PropertyName">Property Name</option>
										<option value="ContactPerson">Contact Person</option>
										<option value="PONo">Purchase No</option>
										<option value="PODate">PO Date</option>
										<option value="DeleveryDate">Delivery Date</option>
										<option value="Amount">Amount</option>
									</select>
								</div>
								<div class="col-md-1">
							 		<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateSMS();" id="btnAddSMS" style="margin-top:22px;"/>
							 	</div>
							 	<div class="col-md-2">
									<s:textarea cssStyle="height: 28px; margin-top:22px;" id="txtSMSContent" path="strSMSContent"  />
								</div>
							</div>							
						</div>
							<div id="tab11" class="tab_content" style="margin-top: 47px;">
								<div class="row masterTable">
									<div class="col-md-2">
										<input type="button" value="Select All Location" class="btn btn-primary center-block" id="btnShowAllLocation" onclick="return funGetLoadPropertyLocation();"></input>
									</div>
								</div>
							<br>
							
							<table class="masterTable" style="width:100%;">
								<tr style="background:#c0c0c0;">
									<th><label>Location</label></th>
									<th><label>Location Name</label></th>
									<th><label>From Time</label></th>
									<th><label>To Time</label></th>
									<th><label>Delete</label></th>									
								</tr>	
							</table>
							
							<div class="dynamicTableContainer" style="height: 246px;overflow-y:scroll;background: #fbfafa;">
							<table id="tblTransactionTable" class="masterTable" style="width: 100%">
																			
								<c:forEach items="${listTransactionTime}" var="transactionTime"
									varStatus="status">

 									<tr>
										<td style="width:15%;"><input readonly="readonly" class="Box"  size="10%"
											name="listclsTransactionTimeModel[${status.index}].strLocCode"
											value="${transactionTime.strLocCode}" /></td>
										<td style="width:20%;"><input readonly="readonly" class="Box" size="20%"
											name="listclsTransactionTimeModel[${status.index}].sstrLocName"
											value="${transactionTime.strLocName}"  /></td>
										<td width="10%"><input type="text" step="any" required = "required" style="text-align: right;width:60%" size="10%"
											name="listclsTransactionTimeModel[${status.index}].tmeFrom"
											value="${transactionTime.tmeFrom}" id="txttmeFrom" onClick="funCallTime(this)"/></td>
										<td width="10%"><input type="text" step="any" required ="required" style="text-align: right;width:60%" size="10%"
											name="listclsTransactionTimeModel[${status.index}].tmeTo"
											value="${transactionTime.tmeTo}" id="txttmeTo" onClick="funCallTime(this)"/></td>
										<td width="5%"><input type="button" value="Delete" class="deletebutton"
											onClick="funDeleteRowTransactionTable(this)"  class="deletebutton"></td>
									</tr>
									
								</c:forEach>	
								</table>	
								</div>
								</div>	
						</div>
			</div>
		<div class="center" style="text-align:center;">
			<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidateFields()">Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Reset">Reset</button></a>
		</div> 
		</s:form>
		</div>
	</div>
</body>
</html>