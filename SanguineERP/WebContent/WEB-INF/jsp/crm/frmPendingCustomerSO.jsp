 <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
		
    <title>Cost Of Issue</title>
<style>
  #tblGroup tr:hover , #tblSubGroup tr:hover, #tblloc tr:hover{
	background-color: #72BEFC;
}
.transTable td{
  padding-left:0px;

}
</style>
    <script type="text/javascript">
    
 		 //Serching on Table when user type in text field
          $(document).ready(function()
    		{
    			var tablename='';
    			
    			$('#txtCustCode').keyup(function()
    	    			{
    						tablename='#tblCust';
    	    				searchTable($(this).val(),tablename);
    	    			});
    			$('#txtProdCode').keyup(function()
    	    			{
    						tablename='#tblProd';
    	    				searchTable($(this).val(),tablename);
    	    			});	
    			
    		});

           //Searching on table on the basis of input value and table name
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
    		
	    var fieldName="";
	    //Ajax Wait Image display
	    $(document).ready(function() 
    		{
    			$(document).ajaxStart(function()
    		 	{
    			    $("#wait").css("display","block");
    		  	});
    			$(document).ajaxComplete(function(){
    			    $("#wait").css("display","none");
    			  });
    		});
	    
	    
		$(document).ready(function() {
			$(".tab_content").hide();
			$(".tab_content:first").show();
			$("ul.tabs li").click(function() 
			{
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();

				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
		});
    
	    //Set Start Date in date picker
        $(function() 
    		{
	    	      	  
    			$( "#txtSODate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
    			$("#txtSODate" ).datepicker('setDate', 'today'); 
    			
    			$( "#txtFulmtDate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
    			$("#txtFulmtDate" ).datepicker('setDate', 'today'); 
    			
    			 var strPropCode='<%=session.getAttribute("propertyCode").toString()%>';
    			 
    			 var prodCode ='<%=session.getAttribute("locationCode").toString()%>';

     			
    			 funSetAllCust();
    			 
    			 
    		});	
      

    
	  //Open Help
      function funHelp(transactionName)
		{
    	  	fieldName=transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
		}
	  
	  //Set data After Seletion of Help
      function funSetData(code)
		{
			switch (fieldName) 
			{

			    case 'custcode':
			    	funSetCustomer(code);
			        break;  
			}
		}
      
   
    
      //Fill  Product Data
	    function funfillProdGrid(strProdCode,strProdName,dblQty,strCustCode,strCustName)
		{
			
			 	var table = document.getElementById("tblProd");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    
			    row.insertCell(0).innerHTML= "<input id=\"cbProdSel."+(rowCount)+"\" name=\"Prodthemes\" type=\"checkbox\" class=\"ProdCheckBoxClass\"  checked=\"checked\" value='"+strProdCode+"' />";
			    row.insertCell(1).innerHTML= "<input name=\"listPendingCustomerSOProductDtlBean["+(rowCount)+"].strCustCode\" readonly=\"readonly\" class=\"Box\" style=\"width:98%;\"  id=\"strCustCode."+(rowCount)+"\" value='"+strCustCode+"' >";
			    row.insertCell(2).innerHTML= "<input name=\"listPendingCustomerSOProductDtlBean["+(rowCount)+"].strCustName\" readonly=\"readonly\" class=\"Box\" size=\"24%\" id=\"strCustName."+(rowCount)+"\" value='"+strCustName+"' >";
			    row.insertCell(3).innerHTML= "<input name=\"listPendingCustomerSOProductDtlBean["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"11%\" id=\"strProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";
			    //row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\"strToLocCode."+(rowCount)+"\" value='"+strProdCode+"' >";
			    row.insertCell(4).innerHTML= "<input name=\"listPendingCustomerSOProductDtlBean["+(rowCount)+"].strProductName\" readonly=\"readonly\" class=\"Box \" size=\"45%\" id=\"strProductName."+(rowCount)+"\" value='"+strProdName+"' >";
			    row.insertCell(5).innerHTML= "<input name=\"listPendingCustomerSOProductDtlBean["+(rowCount)+"].dblQty\" class=\"text \" size=\"4%\" id=\"dblQty."+(rowCount)+"\" value='"+dblQty+"' >";
			    
		}
	  
	  
		     
	      //Get and set Customer  Data 
	      function funSetAllCust() {
				var searchUrl = "";
				searchUrl = getContextPath()+ "/loadAllCustomer.html";
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
						if (response.strPCode == 'Invalid Code') {
							alert("Invalid Customer Code");
							
						} else
						{
							$.each(response, function(i,item)
							 		{
								funfillCustGrid(response[i].strPCode,response[i].strPName);
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
		

				
		    //Fill Supplier Data
		    function funfillCustGrid(strCustCode,strCustName)
			{
				
				 	var table = document.getElementById("tblCust");
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    // onClick=Javacsript:funLoadAllProduct('"+strCustCode+"')
				    row.insertCell(0).innerHTML= "<input id=\"cbSuppSel."+(rowCount)+"\" name=\"Custthemes\" type=\"checkbox\"  class=\"CustCheckBoxClass\"   value='"+strCustCode+"'  />";
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" id=\"strCustCode."+(rowCount)+"\" value='"+strCustCode+"' >";
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \" size=\"50%\" id=\"strCName."+(rowCount)+"\" value='"+strCustName+"' >";
			}
		    //Remove All Row from Grid Passing Table Id as a parameter
		    function funRemRows(tablename) 
			{
				var table = document.getElementById(tablename);
				var rowCount = table.rows.length;
				while(rowCount>0)
				{
					table.deleteRow(0);
					rowCount--;
				}
			}
		    
		    
		    function  funLoadAllProduct(strCustCode)
			{
			
					var searchUrl="";
					searchUrl=getContextPath()+"/loadPartyProdData.html?partyCode="+strCustCode;
					//alert(searchUrl);
					$.ajax({
					        type: "GET",
					        url: searchUrl,
						    dataType: "json",
						    success: function(response)
						    {
// 						    	funRemoveProdRows();
						    	$.each(response, function(i,item)
								    	{
						    		
						    		funfillProdGrid(response[i].strProdCode,response[i].strProdName,response[i].dblStandingOrder,strCustCode,response[i].strSuppName);
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
				
		 function funAddProd()
		 {
			 funRemoveAllRowsProdtable(); 
			 var strCustCode="";
			 
			 $('input[name="Custthemes"]:checked').each(function() {
				 if(strCustCode.length>0)
					 {
					 strCustCode=strCustCode+","+this.value;
					 funLoadAllProduct(this.value);
					 }
					 else
					 {
						 strCustCode=this.value;
						 funLoadAllProduct(this.value);
						 
					 }
				 
				});

			 $("#hidCustCodes").val(strCustCode);
			 
			 
			 
			 
		 }
	    
		    
		 
// 			//Select All Group,SubGroup,From Location, To Location When Clicking Select All Check Box
// 			 $(document).ready(function () 
// 						{
							
// 							$("#chkCustALL").click(function () {
// 							    $(".CustCheckBoxClass").prop('checked', $(this).prop('checked'));
// 							});
							
							
// 							$("#chkProdALL").click(function () {
// 							    $(".ProdCheckBoxClass").prop('checked', $(this).prop('checked'));
// 							});
							
						
							
// 						});
					 
			 
	   //Submit Data after clicking Submit Button with validation 
	   function btnSubmit_Onclick()
	    {
			 
					 var strProdCode="";
					 
					 $('input[name="Prodthemes"]:checked').each(function() {
						 if(strProdCode.length>0)
							 {
							 strProdCode=strProdCode+","+this.value;
							 }
							 else
							 {
								 strProdCode=this.value;
							 }
						 
						});
					 if(strProdCode=="")
					 {
					 	alert("Please Select Prod");
					 	return false;
					 }
					 $("#hidProdCodes").val(strProdCode);
					
					 
  		    	document.forms["frmPendingCustomerSO"].submit();
		    }
	  
	    
	   //Reset All Filed After Clicking Reset Button
	    function funResetFields()
		{
			location.reload(true); 
		}
	   
	    $(document).ready(function() {
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
	   
	    function funRemoveAllRowsProdtable() 
	    {
			 var table = document.getElementById("tblProd");
			 var rowCount = table.rows.length;			   
			//alert("rowCount\t"+rowCount);
			for(var i=rowCount-1;i>=0;i--)
			{
				table.deleteRow(i);						
			} 
	    }
	   
	</script>    
  </head>
 	
<body id="frmPendingCustomerSO" onload="funOnload();">
	<div class="container"> 
		<label id="formHeading">Pending Customer Sales Order</label>
		<s:form name="frmPendingCustomerSO" method="POST" action="savePendingCustomerSO.html" >
	   	<div id="tab_container">
			<ul class="tabs">
				<li class="active" id="t1" data-state="tab1">Customers</li>
				<li data-state="tab2" id="t2">Products</li>
			</ul>
			<div id="tab1" class="tab_content">
				<div class="row transTable">
					<div class="col-md-4">
						<div class="row">
							<div class="col-md-6">
								<label>SO Date:</label>
								<s:input id="txtSODate" path="dteSODate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:80%;"/>
							</div>	
							<div class="col-md-6">
								<label>Fullfillment Date:</label>
								<s:input id="txtFulmtDate" path="dteFulmtDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:80%;"/>
							</div>
						</div>
					</div>
					<div class="col-md-2">
						<label>Customer</label>
						<input type="text" id="txtCustCode"  Class="searchTextBox" placeholder="Type to search"></input>
					</div>
					<div class="col-md-2">
						<label id="lblCustName"></label>
					</div>
				</div>
				<br>
				<div class="transTable" style="margin:0px;'">
					<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 350px; width:60%; 
							overflow-x: hidden; overflow-y: scroll;margin-top:10px;">
						<table id="" class="masterTable" style="width: 100%; border-collapse: separate;">
							<tbody>
								<tr bgcolor="#c0c0c0">
									<td width="5%"><input type="checkbox" id="chkCustALL"/>Select</td>
									<td width="26%">To Customer Code</td>
									<td width="65%">To Customer Name</td>
								</tr>
							</tbody>
						</table>
						<table id="tblCust" class="masterTable"	style="width: 100%; border-collapse: separate;">
							<!-- <tr bgcolor="#72BEFC">
							</tr> -->
							<tbody>    
								<col style="width:1.5%"><!--  COl1   -->
								<col style="width:1%"><!--  COl2   -->
								<col style="width:3%"><!--  COl3   -->
							</tbody>
						</table>
					</div>
					<div class="col-md-12">
						<a href="#"><button class="btn btn-primary center-block" id="btnAddProd" value="Add Prod" onclick="return funAddProd()"
							class="form_button">Add Prod</button></a>
					</div>
				</div>
			</div>
			
			<div id="tab2" class="tab_content" style="height: 650px" >
				<div class="row transTable">
					<div class="col-md-2">
						<label>Location</label>
							<input type="text" id="txtLocCode" Class="searchTextBox" placeholder="Type to search"></input>
					</div>
					<div class="col-md-3">
						<label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 43%; margin-top:25px; padding:2px;"></label>
					</div>
					<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 550px;width: 100%; overflow-x: hidden; overflow-y: scroll;  margin-top:10px;">
						<table id="" class="masterTable" style="width: 100%;">
							 <tbody>
								 <tr bgcolor="#c0c0c0">
									<td width="4%"><input type="checkbox" checked="checked" id="chkLocALL"/>Select</td>
									<td width="11%"> Cust Code </td>
									<td width="22%"> Cust Name </td>
									<td width="11%"> Product Code</td>
									<td width="45%"> Product Name</td>
									<td width="11%"> Qty </td>
								</tr>
							</tbody>
						</table>
						<table id="tblProd" class="masterTable"	style="width: 100%; border-collapse: separate;">
						     <tr bgcolor="#72BEFC">
							</tr>
						</table>
					</div>
				</div>
			</div>	
		</div>
		<div class="center" style="margin-right: 43%;">
				<a href="#"><button class="btn btn-primary center-block" id="btnAddProd" value="Submit" onclick="return btnSubmit_Onclick();"
					class="form_button">Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
					class="form_button">Reset</button></a>
		</div>			
			
			<s:input type="hidden" id="hidCustCodes" path="strSuppCode"></s:input>
			<s:input type="hidden" id="hidProdCodes" path="strProdCode"></s:input>
			<div id="wait" style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
				<img
					src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
					width="60px" height="60px" />
			</div>
	</s:form>
</div>
	</body>
</html>