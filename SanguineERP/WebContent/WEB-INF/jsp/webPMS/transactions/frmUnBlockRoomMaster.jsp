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
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;
	var listOfBlockRoom=${command.jsonArrBlockRooms};
	
	//Initialize tab Index or which tab is Active
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
			
		$(document).ajaxStart(function(){
		    $("#wait").css("display","block");
		});
		$(document).ajaxComplete(function(){
		   	$("#wait").css("display","none");
		});
		
	
	});
	
	

		
	
	
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		//alert(listOfBlockRoom);
		$.each(listOfBlockRoom, function(i, obj) 
		{
			//alert(obj.strRoomCode+""+obj.strRoomDesc+""+obj.strRoomTypeCode+""+obj.strRoomTypeCode+""+obj.strRoomTypeDesc);
			
			funUnblockRoom(obj.strRoomCode,obj.strRoomDesc,obj.strRoomTypeCode,obj.strRoomTypeDesc);
			
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

	
	function funCheckUnblockRoom(count)
	{
		
		var no=0;
		$('#tblRoom tr').each(function() {
			
			if(document.getElementById("strUnBlockRoomFlag."+no).checked == true)
			{
				document.getElementById("strUnBlockRoomFlag."+no).value='Y';
			
			}
			else
			{
			 document.getElementById("strUnBlockRoomFlag."+no).value='N';
			}
			no++;
		});
	
		
		
	}
			
	function funResetFields()
	{
		location.reload(true); 
	}
	
	function funCheckUnBlockRooms()
	{
		var table = document.getElementById("tblRoom");
		var rowCount = table.rows.length;	
		if ($('#chkUnBlockRoomStatus').is(":checked"))
		{
		 	//check all			
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strUnBlockRoomFlag."+i).checked=1;
				document.getElementById("strUnBlockRoomFlag."+i).value='Y';
	    	}
		}
		else
		{				
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strUnBlockRoomFlag."+i).checked=0;
				document.getElementById("strUnBlockRoomFlag."+i).value='N';
	    	}
			
		}	   
	}

	
	
	function funUnblockRoom(strRoomCode,strRoomDesc,strRoomTypeCode,strRoomTypeDesc){
		
		var table=document.getElementById("tblRoom");
		var rowCount=table.rows.length;
		var row=table.insertRow();
	   	row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listOfUnblockRoom["+(rowCount)+"].strRoomDesc\"  id=\"strRoomDesc."+rowCount+"\" value='"+strRoomDesc+"' >";
	   	row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 295%;margin-left: 14%;\" name=\"listOfUnblockRoom["+(rowCount)+"].strRoomDesc\"  id=\"strRoomDesc."+rowCount+"\" value='"+strRoomTypeDesc+"' >";
	   	row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listOfUnblockRoom["+(rowCount)+"].strRoomCode\" id=\"strRoomNo."+rowCount+"\"value='"+strRoomCode+"' >";
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listOfUnblockRoom["+(rowCount)+"].strRoomType\" id=\"strRoomType."+rowCount+"\"value='"+strRoomTypeCode+"' >";
		row.insertCell(4).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listOfUnblockRoom["+(rowCount)+"].strUnBlockRoomFlag\" onClick=\"Javacsript:funCheckUnblockRoom("+rowCount+")\"  id=\"strUnBlockRoomFlag."+rowCount+"\" value='N' >"; 
	    
	}
			
</script>

</head>
<body>
    <div class="container masterTable">
	 <label id="formHeading">UnBlock Room</label>
	   <s:form name="UnBlockRoomMaster" method="POST"
		action="saveUnBlockRoom.html">
	<div class="dynamicTableContainer" style="height: 400px;width:57%;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;height: 10%;" class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="20%">Room Type</td>
					<td width="20%" style="text-align:center">Room Number</td>
					<td style="width:26%;padding:5px;float: right;">Select All<br>
	    				<input type="checkbox" id="chkUnBlockRoomStatus" name="chkBoxAll1" value="Bike" style="margin-left: 10px;" onclick="funCheckUnBlockRooms()">
					</td>
				</tr>
			</table>
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRoom"  style="width: 100%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
					<tbody>
						<col style="width: 20%">
						<col style="width: 20%">
						<col style="text-align:center;width:20%;">
					</tbody>
				</table>
			</div>
		</div>   

       </div>
		<br />
	
		<p align="center" style="margin-right:27%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" />
		</p>
		
     </s:form>
	</div>
</body>
</html>
