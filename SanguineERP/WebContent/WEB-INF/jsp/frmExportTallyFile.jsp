<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  
   <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	   
    <title>Web Stocks</title>
    <script type="text/javascript">
    $(document).ready(function() 
    		{
    	var startDateOfMonth="${startDateOfMonth}";
    	var arr = startDateOfMonth.split("-");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
        $("#txtFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
		$("#txtFromDate" ).datepicker('setDate',Dat);
		$("#txtFromDate").datepicker();
		
		 $("#txtToDate").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#txtToDate" ).datepicker('setDate', 'today');
			$("#txtToDate").datepicker();	
		
			 $(document).ajaxStart(function(){
				    $("#wait").css("display","block");
				  });
				  $(document).ajaxComplete(function(){
				    $("#wait").css("display","none");
				  });
				  
				  $('#txtSuppCode').keyup(function()
	    	    			{
	    						tablename='#tblSupp';
	    	    				searchTable($(this).val(),tablename);
	    	    			});	
				  funSetAllSupplier();  
			
			
    		});
    
    
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
    
    
    function update_FromFulFillmentDate(selecteDate){
		var date = $('#txtFromDate').val();
		$('#txtToDate').val(selecteDate);
	}
    
    
//     function funGetProperty(propertyCode) {
		
		function funValidate()
		{
			
			var spFromDate=$("#txtFromDate").val().split('-');
			var spToDate=$("#txtToDate").val().split('-');
			var FromDate= new Date(spFromDate[0],spFromDate[1]-1,spFromDate[2]);
			var ToDate = new Date(spToDate[0],spToDate[1]-1,spToDate[2]);

			if(ToDate<FromDate)
			{
			    	alert("To Date is not < Form Date");
			    	$("#txtToDate").focus();
					return false;		    	
			}
			
			if($('#strProperty').val()=="-select-")
				{
					 alert("Please Select Property !");
					 return false;
				}
			if($('#txtUserCode').val()=="")
				{
					 alert("Please Write Tally User Name !");
					 return false;
				}
			
			var strSuppCode="";
			 
			 $('input[name="Suppthemes"]:checked').each(function() {
				 if(strSuppCode.length>0)
					 {
					 strSuppCode=strSuppCode+","+this.value;
					 }
					 else
					 {
						 strSuppCode=this.value;
					 }
				 
				});
// 			 if(strSuppCode=="")
// 			 {
// 			 	alert("Please Select To Supplier");
// 			 	return false;
// 			 }
			 $("#hidSuppCodes").val(strSuppCode);


			
		}
		
		
		//Get and Set All Location on the basis of all Property
	      function funSetAllSupplier() {
				var searchUrl = "";
				searchUrl = getContextPath()+ "/loadAllSupplier.html";
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
					success : function(response) {
						if (response.strSuppCode == 'Invalid Code') {
							alert("Invalid Supplier Code");
							
						} else
						{
							$.each(response, function(i,item)
							 		{
								funfillSuppGrid(response[i].strPCode,response[i].strPName);
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
		
	      //Fill To Location Data
		    function funfillSuppGrid(strSuppCode,strSuppName)
			{
				
				 	var table = document.getElementById("tblSupp");
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    
				    row.insertCell(0).innerHTML= "<input id=\"cbSuppSel."+(rowCount)+"\" name=\"Suppthemes\" type=\"checkbox\" class=\"SuppCheckBoxClass\"   value='"+strSuppCode+"' />";
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strSuppCode."+(rowCount)+"\" value='"+strSuppCode+"' >";
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"50%\" id=\"strSName."+(rowCount)+"\" value='"+strSuppName+"' >";
			}
		
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
		    
		    
		    $(document).ready(function () 
					{
												
						$("#chkSuppALL").click(function () {
						    $(".SuppCheckBoxClass").prop('checked', $(this).prop('checked'));
						});
						
					});
		
		
// 	}
    
    </script>
  </head>
  <body >
	<div class="container">
	<label id="formHeading">Export Tally File</label>
	
	<s:form name="frmExportTallyFile" method="GET"  action="exportTallyFile.html?saddr=${urlHits}" >
		<div id="tab_container">
			
			<ul class="tabs">
				<li class="active" data-state="tab1">General</li>
				<li data-state="tab2">Supplier</li>
			</ul>
		
			<div id="tab1" class="tab_content" style="margin-top: 50px;">
				<div class="row masterTable">
					<div class="col-md-2">
						<label>From Date</label>
						<s:input path="dteFromDate" id="txtFromDate" cssClass="calenderTextBox" style="width:80%;"/>
					</div>
					<div class="col-md-2">				
						<label>To Date</label>
						<s:input path="dteToDate" id="txtToDate" cssClass="calenderTextBox" style="width:80%;"/>
					</div>
					<div class="col-md-2">			
						<label>Type</label>
						<s:select id="cmbDocType" path="strDocType" style="width:80%;" >
							<s:option value="Purchase">Purchase</s:option>
							<s:option value="Sales">Sales</s:option>
						</s:select>
					</div>	
					<div class="col-md-6"></div>		
					<div class="col-md-2">		
						<label>Tally User Name</label>
						<s:input path="strUserCode" id="txtUserCode" />
					</div>
					<div class="col-md-2">	
						<label>Property</label>
							<s:select path="strPropertyCode" items="${properties}" id="strProperty">
							</s:select>
					</div>			
					<div class="col-md-2">				
						<label>Tally Company Name</label>
						<s:input path="strDocCode" id="txtDocCode" />
					</div>
				</div>
			</div>
			<div id="tab2" class="tab_content" >
				<div class="transTable">
					<div class="row">
						<div class="col-md-2">	
							<label>Supplier</label>
							<input type="text" id="txtSuppCode" Class="searchTextBox" placeholder="Type to search"></input>
						</div>
						<div class="col-md-2">	
						 	<label id="lblSuppName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label>
						</div>
					</div>
					<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll;">
 						<table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
							<tbody>
								<tr bgcolor="#c0c0c0">
									<td width="5%"><input type="checkbox" id="chkSuppALL"/>Select</td>
									<td width="21%">To Supplier Code</td>
									<td width="65%">To Supplier Name</td>
								</tr>
							</tbody>
						</table>
						<table id="tblSupp" class="masterTable" style="width: 100%; border-collapse: separate;">
							<tr bgcolor="#fbfafa">
							</tr>
						</table>
					</div>
				</div>
			</div>
			
			<p align="center" style="margin-top:20px;">
				<input type="submit" value="Submit"  class="btn btn-primary center-block form_button" onclick="return  funValidate()" style="color:#000; height: 31px;"/>
				 <input type="button" value="Reset" class="btn btn-primary center-block form_button"  onclick="funResetFields()" style="color:#000; height: 31px;" />
			</p>
			
			<s:input type="hidden" id="hidSuppCodes" path="strSuppCode"></s:input>	
	</div>	
</s:form>
</div>
</body>
</html>