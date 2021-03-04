<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>  
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
        
        
        <script type="text/javascript" src="<spring:url value="/resources/js/jquery-1.6.3.min.js"/>"></script>
        <script type="text/javascript" src="<spring:url value="/resources/js/highcharts.js"/>"></script>
        <script type="text/javascript" src="<spring:url value="/resources/js/exporting.js"/>"></script>
		<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
		<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>  
       <style>
        .btn-primary {
	border-radius: 0px;
	font-size: 13px;
	font-family:'trebuchet ms';
	background-color: #fff;
	color:#000;
	border:none;
}

.btn-primary:hover {
	background-color: #007bff;
	color: #fff;
	font-family:'trebuchet ms';
}
       </style>
       <script type="text/javascript">
        
        $(function() 
                {	
		        	var startDate="${startDate}";
		        	var startDateOfMonth="${startDateOfMonth}";
					var arr = startDate.split("/");
					Date1=arr[0]+"-"+arr[1]+"-"+arr[2];
                	$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
        			$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
        			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
        			$("#txtToDate" ).datepicker('setDate', 'today');
        			
                }); 
                
                 $(document).ready(function () 
                 {    
                	var startDate="${startDate}";
 					var arr = startDate.split("/");
 					Date1=arr[0]+"-"+arr[1]+"-"+arr[2]; 
 					var startDateOfMonth="${startDateOfMonth}";
                	$("#txtFromDate").datepicker({
              		   dateFormat : 'dd-mm-yy'
              		});
              		$("#txtFromDate").datepicker('setDate', startDateOfMonth);
              		
              		$("#txtToDate").datepicker({
              			dateFormat : 'dd-mm-yy'
              		});
              		$("#txtToDate").datepicker('setDate', 'today');

        		
        		   funShowRecord();
                });
         
         
         function funShowRecord()
         {
       	    $('#container1').empty();
       	    funDrawMonthWiseSaleLineGraph();
       	     
     		//funDrawItemWiseSaleChart();
     		
         }
         
         function funDrawMonthWiseSaleLineGraph() 
         {
        	var dataSet = [],xData=[],dataSet1 = [];
          	var fDate = $("#txtFromDate").val();
         	var tDate = $("#txtToDate").val();
        	var gurl = getContextPath()+"/loadSaleVSPurchaseDtl.html";
 			$.ajax({
 				type : "GET",
 				data:{ fromDate:fDate,
 					   toDate:tDate,
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
  						$.each(response.arrGraphList,function(i,item)
  			 			{
  			 			            	
  			 				//alert(item.strPOSName)
  			 				dataSet.push([item.dblSettlementAmt]);
  			 				dataSet1.push([item.dblAmount]);
  							xData.push([item.strItemName]);
  							
  			 		    });
  						//RenderLineChart(dataSet,xData);
  						funDrawBarChart(dataSet,xData,dataSet1); 
  		        	}
  					
  				}
  			});	 
        	 
        }
         
         
         function funDrawBarChart(dataSet,xData,dataSet1) 
         {
        	 if(dataSet.length === 0)
             {
        		 alert('No Record Found');
             }
        	 else
        	 {
        		 var datasety = dataSet;
          	   var datasety1 = dataSet1;
          	    for(i=0;i<datasety.length;i++)
          	    {
          	        datasety[i] = parseFloat(datasety[i]);

          	    }
          	    
          	    for(i=0;i<datasety1.length;i++)
          	    {
          	        datasety1[i] = parseFloat(datasety1[i]);

          	    }

          	    var datasetx = new Array(); 
          	    datasetx = xData;
          	     
          	  
          	    chart = new Highcharts.Chart({
          	        chart: {
          	            renderTo: 'container1',
          	            type: 'column',
          	            margin: [ 50, 50, 100, 80]
          	        },
          	       title: 
          	        {
          	            text: ''
          	        },
          	        style: 
  	   	             {
  	   	                fontWeight: 'bold'
  	   	             },
  	   	             
          	        xAxis: {
          	            categories: datasetx,
          	            labels: {
          	                enabled: true,
          	                rotation: -45,
          	                align: 'right',
          	                style: {
          	                    fontSize: '13px',
          	                    fontFamily: 'Verdana, sans-serif'
          	                }
          	            }
          	        },
          	        yAxis: {
          	           min: 0,
          	           title: 
           	           {
           	                text: 'Sale'
           	           },
           	           labels: 
           	           { 
           	            formatter: function() 
           	            {
           	               return Math.round(this.value/100000) + 'Lac';
           	            }
           	           }  

          	        },
          	        plotOptions:{ // for different color of bar
          	           // series:{ colorByPoint: true}
          	        	column: {
  	    					dataLabels: {
  	    						enabled: true
  	    					}
  	    				}
          	        },
          	        legend: 
          	        {
          	            enabled: true
          	        },
          	        tooltip: {
          	        	formatter: function() {
         	            	 return '<b>'+ this.x +'</b><br/>'+ this.series.name +': '+ Highcharts.numberFormat(this.y/100000, 2); 
         	            }
          	        },
          	        credits: 
                      {
                        enabled: false
                      },
                     exporting: 
                     { 
                     	enabled: false 
                     },
          	        series: [{
          	            name: 'Sale',
          	            data: datasety,

          	            dataLabels: {
          	                formatter:function(){   // for format value 
          	                    return 'USD'+this.y
          	                    },
          	                enabled: false,
          	                rotation: -90,
          	                color: '#FFFFFF',
          	                align: 'right',
          	                x: 4,
          	                y: 10,
          	                style: {
          	                    fontSize: '13px',
          	                    fontFamily: 'Verdana, sans-serif'
          	                }
          	            }
          	        },
          	        
          	        {
          	            name: 'Purchase',
          	            data: datasety1,

          	            dataLabels: {
          	                formatter:function(){   // for format value 
          	                    return 'USD'+this.y
          	                    },
          	                enabled: false,
          	                rotation: -90,
          	                color: '#FFFFFF',
          	                align: 'right',
          	                x: 4,
          	                y: 10,
          	                style: {
          	                    fontSize: '13px',
          	                    fontFamily: 'Verdana, sans-serif'
          	                }
          	            }
          	        },
          	        ]
          	    });
          	     
        	 }	 
        	 
         };
         

         
    </script>
    </head>
    
    <body>
    <div class="container masterTable">
      <label id="formHeading">Sale Vs Purchase</label>
      <s:form name="SaleVSPurchase" method="POST" action="rptPOSWiseSalesReport.html?saddr=${urlHits}" target="_blank">
	
	       <div class="row">	
		       <div class="col-md-2"><label>From Dater</label> 
		             <s:input id="txtFromDate" required="required" path="strFromDate" pattern="\d{1,2}-\d{1,2}-\d{4}"
							cssClass="calenderTextBox" style="width:70%;height:50%"/>
				</div>
				 
			    <div class="col-md-2"><label>To Date</label> 
		             <s:input id="txtToDate" required="required" path="strToDate" pattern="\d{1,2}-\d{1,2}-\d{4}"
							cssClass="calenderTextBox" style="width:70%;height:50%"/>
				</div>			
							
				<div class="col-md-2"><br>
				     <s:input type="button" id="btnShow" value="Show" path="strShow" class="btn btn-primary   form_button" onclick="funShowRecord()" style="height:28px;"/>
				</div> 
	         </div>
		
		 <br>
          <div style="background-color: #ffffff; border: 1px solid #ccc; display: block; ">
	     <br />
	     <div id="container1" style=" width: 100%; height: 800px; margin: auto;float:center;  overflow-x: hidden; border-collapse: separate; background-color: #ffffff; ">
		</div>
		
		</div>	
  
   </s:form>	
	</div>
    </body>
</html> 



