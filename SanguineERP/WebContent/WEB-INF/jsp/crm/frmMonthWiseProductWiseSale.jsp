<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
       
		<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

</head>
<script type="text/javascript">

 		var StkFlashDataHeader;
 		var StkFlashData;
 		var StkFlashData;
 		var loggedInProperty="";
 		var loggedInLocation="";
 		$(document).ready(function() 
 				{
		  	loggedInProperty="${LoggedInProp}";
			loggedInLocation="${LoggedInLoc}";
			$("#cmbProperty").val(loggedInProperty);
			//alert(loggedInProperty);
			var propCode=$("#cmbProperty").val();
			//funFillLocationCombo(propCode);
			
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate").datepicker('setDate',Dat);
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate").datepicker('setDate', 'today');
			$("#divValueTotal").hide();
		});	
 		
 		function funShowMISFlash()
 		{
 			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var propCode=$("#cmbProperty").val();
			var locCode=$("#cmbLocation").val();
			var type=$("#cmbType").val();
 			var searchUrl="";
 			if(type=='Amount'){
 			searchUrl=getContextPath()+"/showMonthWiseProdSaleAmount.html?fDate="+fromDate+"&tDate="+toDate+"&propCode="+propCode+"&locCode="+locCode;
			//alert(searchUrl);
 			}else{
 				searchUrl=getContextPath()+"/showMonthWiseProdSaleQunatityWise.html?fDate="+fromDate+"&tDate="+toDate+"&propCode="+propCode+"&locCode="+locCode;
 			}
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
						StkFlashDataHeader=response[0];
				    	StkFlashData=response[1];
				    	showTable();

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
 		
 		function funExport(){
 			
 			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var propCode=$("#cmbProperty").val();
			var locCode=$("#cmbLocation").val();
			var type=$("#cmbType").val();
			if(type=='Amount'){
			window.location.href=getContextPath()+"/monthWiseProdSaleAmountWiseExport.html?fDate="+fromDate+"&tDate="+toDate+"&propCode="+propCode+"&locCode="+locCode;
			}else{
				window.location.href=getContextPath()+"/monthWiseProdSaleQunatityWiseExport.html?fDate="+fromDate+"&tDate="+toDate+"&propCode="+propCode+"&locCode="+locCode;
			}
 		}
 		
	 	function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(StkFlashData.length, optInit);	
		    $("#divValueTotal").show();
		    
		}
	
		var items_per_page = 10;
		function getOptionsFromForm()
		{
		    var opt = {callback: pageselectCallback};
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 10;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		}
	
	
	
		
		function pageselectCallback(page_index, jq)
		{
			
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, StkFlashData.length);
		    var newcontent="";
			var currValue='<%=session.getAttribute("currValue").toString()%>';
    		if(currValue==null)
    			{
    				currValue=1;
    			}	
		  		    	
			   	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;">';
			   	// Iterate through a selection of the content and build an HTML string
			  
			    	 newcontent += '<tr>';
			 for(var j=0;j<StkFlashDataHeader.length;j++)
			 {
			    
			     if(j==0)
    			 { 
			    	 newcontent += '<td align="left" size=\"9%\" >'+StkFlashDataHeader[j]+'</td>';
			    	 newcontent += '<td align="center"></td>';
    			 }else{
			     newcontent += '<td align="center">'+StkFlashDataHeader[j]+'</td>';
			 }
			 }
			 newcontent += '<td align="center">Total Quantity</td>';
			 newcontent += '<td align="center">Total Amount</td>';
			    newcontent += '</tr>';
			   
			   	
			   	
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			    	 newcontent += '<tr>';
			   
			     var data=StkFlashData[i];
			     for(var cnt=1;cnt<data.length;cnt++)
			     {
			    	 if(cnt==1)
			    	  {
			    		 newcontent += '<td align="left" size=\"9%\" >'+data[cnt]+'</td>'; 
			    		 }else{
			    			 if(cnt==2)
			     		newcontent += '<td align="center">'+data[cnt]+'</td>';
			     		else{
			     			newcontent += '<td align="right">'+data[cnt]+'</td>';
			     			
			     		}
			         }
			    }newcontent += '</tr>';
			     
			    }
			    
			    newcontent += '</table>';
			    $('#Searchresult').html(newcontent);
		}
		

 		</script>
<body onload="funOnLoad();">
<div class="container transTable">
		<label id="formHeading">Month Wise Product Wise Sale</label>
	   <s:form  method="GET" name="frmMonthPordWiseSaleFlash" target="_blank">
		<br>
	<div class="row">
			<div class="col-md-2"><label> Property Code </label> 
					   <s:select id="cmbProperty" name="propCode" path="strPropertyCode" style="width:auto;" onchange="funChangeLocationCombo();">
			    			<s:options items="${listProperty}"/>
			    		</s:select>
			</div>
						
			<div class="col-md-2"><label>Location</label>
					<s:select id="cmbLocation" name="locCode" path="strLocationCode" style="width:auto;">
			    			<s:options items="${listLocation}"/>
			    		</s:select>
			</div>
					
			<div class="col-md-2"><label>Currency </label>
					<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" style="width:auto;">
						</s:select>
			</div>
			<div class="col-md-6"></div>
					
			<div class="col-md-2"><label id="lblFromDate">From Date</label>
			           <s:input id="txtFromDate" name="fromDate" path="dteFromDate" cssClass="calenderTextBox" style="width:70%;"/>
			        	<s:errors path="dteFromDate"></s:errors>
			</div>
				        
			<div class="col-md-2"><label id="lblToDate">To Date</label>
			        <s:input id="txtToDate" name="toDate" path="dteToDate" cssClass="calenderTextBox" style="width:70%;"/>
			        	<s:errors path="dteToDate"></s:errors>
			</div>
			
			 <div class="col-md-2"><label >Type Of Data</label>
			        <s:select id="cmbType" path="" style="width:auto;">
					  <option value="Amount" >Amount Wise </option>
			          <option value="Qunatity">Quantity Wise</option></s:select>
			 </div>
	  </div>
	  <br>
			    <p align="center" style="margin-right: 25%">
					<input id="btnExecute" type="button" class="btn btn-primary center-block" class="form_button1" value="EXECUTE" onclick="funShowMISFlash()" />
					&nbsp;
					<input id="btnExport" type="button" class="btn btn-primary center-block" class="form_button1" value="EXPORT" onclick="funExport()" />
				</p>
				<br/>
			
					<dl id="Searchresult" style="width: 95%; margin-left: 26px; overflow:auto;"></dl>
		<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
		
		</div>
		<div id="divValueTotal">
		<table id="tblTotalFlash" class="transTablex" style="width: 95%;font-size:11px;font-weight: bold;">
		<tr style="margin-left: 28px">
		
			<td width="10%" align="right"></td>
			</tr>
		</table>
		</div>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			</div>
	</s:form>
	</div>
</body>
</html>