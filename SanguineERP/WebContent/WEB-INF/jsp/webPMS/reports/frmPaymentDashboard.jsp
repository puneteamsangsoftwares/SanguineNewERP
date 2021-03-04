<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
        <title>JSP Page</title>
        
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />    
        
        <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
       	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
        <script type="text/javascript" src="<spring:url value="/resources/js/jquery-1.6.3.min.js"/>"></script>
        <script type="text/javascript" src="<spring:url value="/resources/js/highcharts.js"/>"></script>
        <script type="text/javascript" src="<spring:url value="/resources/js/exporting.js"/>"></script>
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
		<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>  
		
<style>
.contents{
	min-height: calc(100vh - -457px);	
	}
</style>
        <script type="text/javascript">
        
        $(function() 
        {		
        	
        	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
        	
        	$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', pmsDate);
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate" ).datepicker('setDate', pmsDate);
			
        }); 
        
        
         $(document).ready(function () 
         {   
        	 var date = new Date();
        	 $("#txtFromDate").datepicker({
      		   dateFormat : 'dd-mm-yy'
      		});
      	//	$("#txtFromDate").datepicker('setDate', new Date("04-01-"+date.getFullYear()));
      	
      		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
      	
      		$("#txtFromDate").datepicker('setDate', pmsDate);
      		
      		$("#txtToDate").datepicker({
      			dateFormat : 'dd-mm-yy'
      		});
      		$("#txtToDate").datepicker('setDate', pmsDate);
			
      		funShowRecord();
        	
        });
         
         
         function funShowRecord()
         {
       	    $('#container1').empty();
       	    funDrawSettlementWiseChart();
	       
     	}
         
         
        
         
         function funDrawSettlementWiseChart() 
         {
        	var dataSet = [],checkDataSet=[];
         	var strReportTypedata="Settlement Wise Report";
        	var fDate = $("#txtFromDate").val();
        	var tDate = $("#txtToDate").val();
        	var gurl = getContextPath()+"/loadDataForPMSPaymentDashboard.html";
 			$.ajax({
 				type : "GET",
 				data:{ fromDate:fDate,
 					   toDate:tDate,
  					   strReportTypedata:strReportTypedata,
 					},
 				url : gurl,
 				dataType : "json",
 				success : function(response) 
 				{
 				 	if (response== 0) 
 					{
 						alert("Data Not Found");
 					} 
 					else 
 					{ 
 						var total=0;
 						$.each(response.arrFootCountList,function(i,item)
 			 			{
 							  	
 			 				dataSet.push([item.type, item.amount]);
 			 				if(item.amount==0)
 			 				{
 			 					checkDataSet.push([item.type, item.amount]);
 			 			    }
 			 				
 			 		    });
 						
 						if(checkDataSet.length==5)
 						{
 							alert("No Data Available");
 						}
 						else
 						{
 							funDrawPieChartSettlementwise('container1', dataSet,strReportTypedata);
 						}	
 						
 		        	}
 					
 				}
 			});	 
 		 }
         
        
  
         
         
         
         function funDrawPieChartSettlementwise(elementId, dataList,reportType) 
         {
        	 if(dataList.length === 0)
             {
        		 
             }	
        	 else
             {
        		 
        		 var fDate = $("#txtFromDate").val();
            	 var tDate = $("#txtToDate").val();
             	 var textToDisplay='';
             	 textToDisplay="Payment In (Rs) From ";
                 new Highcharts.Chart({
                   chart:
                	 {
                		 options3d:
                           {
                             enabled: true,
                             alpha: 45,
                             beta: 0
                           },
                         renderTo: elementId,
                         plotBackgroundColor: null,
                         plotBorderWidth: null,
                         plotShadow: false
                      },
                   credits: 
                      {
                           enabled: false
                      },
                   exporting: 
                      { 
                          enabled: false 
                      },	
                      title: {
                          text: textToDisplay+fDate+" To "+tDate,
                          style: {
                              fontSize: '14px',
                              color: 'black',
                              fontWeight: 'bold',
                              fontFamily: 'Verdana'
                          }
                      },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + Math.round(this.percentage) + ' %';
                        }
                    
                    },
                   
                    colors: ['#4965F9', '#F87272','#66CDAA','#CD853F','#4682B4','#DDA0DD','#F4A460'],
                    plotOptions: 
         			{
                         pie: {
                             allowPointSelect: true,
                             cursor: 'pointer',
                             showInLegend: true,
                             colorByPoint: true,
                             borderWidth: 0, // This removes the border
                         }
                     },
                     legend: {
                         enabled: true,
                         layout: 'vertical',
                         align: 'right',
                         width: 200,
                         verticalAlign: 'middle',
                         useHTML: true,
                         labelFormatter: function() 
                         {
                        	 return '<div style="text-align: left; width:130px;float:left;">' + this.name + ' : ' + this.y + '</div>';
                         }
                     },
         			series: [{
         				type: 'pie',
                         dataLabels: 
                         {
                        	 name:this.name,
                        	 verticalAlign: 'top',
                             enabled: true,
                             color: '#ffffff',
                             connectorWidth: 1,
                             distance: -50,
                             connectorColor: '#000000',
                             formatter: function () 
                             {
                            	 if(Math.round(this.percentage)==0)
                            	 {
                            		 
                            	 }
                            	 else
                            	 {
                            		 return Math.round(this.percentage) + ' %';
                            	 }	 
                                
                             }
                         },
         				data: dataList
         			}]
                 });
             }		 
        	 
         };
         
         
         
         
         
        
         
</script>
</head>
<body>
    <div class="container">
     <label  id="formHeading">PAYMENT DASHBOARD</label>
     <s:form name="dashboard" method="POST" action="rptPOSWiseSalesReport.html?saddr=${urlHits}" target="_blank" >
	  <div class="masterTable">
	  		<div class="row" style="padding:10px;">
		  		<div class="col-md-2">
			       <label> Date</label>
			       <s:input type="text" id="txtFromDate" required="true" path="strFromDate" class="calenderTextBox" style="width:80%"/>
			    </div>
			    <div class="col-md-2">
					 <label>To Date</label>
			         <s:input type="text" id="txtToDate" required="true" path="strToDate" class="calenderTextBox" style="width:80%" />
			     </div>
			     <div class="col-md-2">
					 <s:input type="button" id="btnShow" value="Show" path="strShow"  class="btn btn-primary center-block form_button" onclick="funShowRecord()"
					 style="margin-top: 23px; padding-bottom: 23px; color: #000;"/>
				</div>
			</div>
	  </div>
    
         <div id="container1" style=" width: 50%; height: 350px; margin: auto;float:left;  overflow-x: hidden; border-collapse: separate; background-color: #ffffff; ">
		</div>
		
		<div id="container2" style=" width: 50%; height: 350px; margin:auto;float:left;  overflow-x: hidden; border-collapse: separate; background-color: #ffffff; ">
		</div>
		
		<div id="container3" style=" width: 50%; height: 350px; margin: auto;float:left;  overflow-x: hidden; border-collapse: separate; background-color: #ffffff; ">
		</div>
		
		<div id="container4" style=" width: 50%; height: 350px; margin: auto;float:left;  overflow-x: hidden; border-collapse: separate; background-color: #ffffff; ">
		</div>
       
	</s:form>
	</div>	
    </body>
</html> 



