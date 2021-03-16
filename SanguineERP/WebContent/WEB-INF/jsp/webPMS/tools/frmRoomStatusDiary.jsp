<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/materialdesignicons.min.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/jquery-ui.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/rsd-design.css"/>" />
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
		<script type="text/javascript" src="<spring:url value="/resources/js/canvas.js"/>"></script>
		
	<title></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
.container {
  display: inline-block;
  cursor: pointer;
}

.bar1, .bar2, .bar3 {
  width: 25px;
  height: 1px;
  background-color: #333;
  margin: 6px 0;
  transition: 0.4s;
}
c:hover{
background-color: gray
}

.change .bar1 {
  -webkit-transform: rotate(-45deg) translate(-9px, 6px);
  transform: rotate(-45deg) translate(-9px, 6px);
}

.change .bar2 {opacity: 0;}

.change .bar3 {
  -webkit-transform: rotate(45deg) translate(-8px, -8px);
  transform: rotate(45deg) translate(-8px, -8px);
}
<style type="text/css">
#tblDays td{
       width:176px;
}
.table-bordered td{
		border-style:none;
}
.Box { background: inherit; border: 0px solid #060006; outline:0; padding-left: 00px;  font-size:11px;
	font-weight: bold; font-family: trebuchet ms,Helvetica,sans-serif; 
}
.table>thead>tr.active {
	background-color: #a3d0f7;
}
.table>thead{
	background-color: #a3d0f7;
}
.table-bordered > tbody > tr > td,
.table-bordered > tbody > tr > th,
.table-bordered > tfoot > tr > td,
.table-bordered > tfoot > tr > th,
.table-bordered > thead > tr > td,
.table-bordered > thead > tr > td{
  border-color: #e4e5e7;
  border-bottom: 1px solid #dbd9d9;
}
table tbody tr:nth-child(odd) {
	background:#fff;
}
table tbody tr:nth-child(even) {
	background:#fafafa;
}
.mdi-broom::before{
	height:26px;
}
.table tr.header {
  font-weight: bold;
  /* height:20px;
  width:100px; */
  cursor: pointer;
  -webkit-user-select: none;
  /* Chrome all / Safari all */
  -moz-user-select: none;
  /* Firefox all */
  -ms-user-select: none;
  /* IE 10+ */
  user-select: none;
  /* Likely future */
	background:#fff;
}

.table tr:not(.header) {
  display: none; 
    
}

.table .header td:first-child:after {
  content:  "\02C7"; /* "\02C7"; */ /* "\002b"; */
  position: relative;
  top: 14px;
  display: inline-block;
  font-family: 'Glyphicons Halflings';
  font-style: normal;
  font-weight: 400;
  line-height: 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  float: right;
  color: #000;
  text-align: center;
  padding: 3px;
  transition: transform .25s linear;
  -webkit-transition: -webkit-transform .25s linear;
 right:25px;
 font-size: 23px;
}

.table .header.active td:first-child {
  content:"\02C6";   /* "\02C6"; *//* "\2212"; */
  
}
#tblDays td{
       width:176px;
}
</style>
<script type="text/javascript">
	
	var fieldName;
	var occupiedCnt=0;
	var emptyCnt=0;
	var blockCnt=0;
	var dirtyCnt=0;
	var reservedCnt=0;
	var mapRoomType={};
	var lightRed = '#ff4f53';
	var gcode,gSelection='',gViewSelection='';
	
	$(document).ready(function() {
		  //Fixing jQuery Click Events for the iPad
		  var ua = navigator.userAgent,
		    event = (ua.match(/iPad/i)) ? "touchstart" : "click";
		  if ($('.table').length > 0) {
		    $('.table .header').on(event, function() {
		      $(this).toggleClass("active", "").nextUntil('.header').css('display', function(i, v) {
		        return this.style.display === 'table-row' ? 'none' : 'table-row';
		      });
		    });
		  }
		});
	
	$(function() 
	{
		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#txtViewDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtViewDate").datepicker('setDate', pmsDate);
		//$("#lblPMSDate").text(pmsDate);
		funShowRoomStatusFlash();
		//funFillHeaderRows();


		var chart = new CanvasJS.Chart("chartContainer", {
			animationEnabled: true,
			theme: "light2",
			title:{
				
			},
			axisY:{
				includeZero: false
			},
			data: [{        
				type: "line",
		      	indexLabelFontSize: 16,
				dataPoints: [
					{ y: 450 },
					{ y: 414},
					{ y: 520, indexLabel: "\u2191 highest",markerColor: "red", markerType: "triangle" },
					{ y: 460 },
					{ y: 450 },
					{ y: 500 },
					{ y: 480 },
					{ y: 480 },
					{ y: 410 , indexLabel: "\u2193 lowest",markerColor: "DarkSlateGrey", markerType: "cross" },
					{ y: 500 },
					{ y: 480 },
					{ y: 505 },
					{ y: 486 },
					{ y: 510 }
				]
			}]
		});
		chart.render();
		
		
		
		 $(".tab_content").hide();
		$(".tab_content:first").show();

		$(".tab_content1").hide();
		$(".tab_content1:first").show();
		
		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide(); 
			$(".tab_content1").hide();
			
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
			
			var activeTab1 = $(this).attr("data-state1");
			$("#" + activeTab1).fadeIn();
			
		});
	});
	
	
//Delete a All record from a grid
	function funRemoveHeaderTableRows()
	{
		var table = document.getElementById("tblDays");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
		var table1 = document.getElementById("tblRoomType");
		var rowCount = table1.rows.length;
		while(rowCount>0)
		{
			table1.deleteRow(0);
			rowCount--;
		}
		occupiedCnt=0;
		emptyCnt=0;
		blockCnt=0;
		dirtyCnt=0;
		reservedCnt=0;
	}
	
	function funRemoveDetailTableRows()
	{
		var table = document.getElementById("tblRoomInfo");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}	
	
	//weekend view
	function funShowRoomStatusFlash()
	{	
		
		gSelection='';					
		gViewSelection='Seven Day View';
		$("#lblView").text("-  Seven Day View");
		var viewDate=$("#txtViewDate").val();
				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusList.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRows(response);
			},
			error : function(e){
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
	
	//One Day View	
	function funShowRoomStatusFlashForOneDay()
	{
		gSelection='';
		gViewSelection='One Day View';
		$("#lblView").text("-  One Day View");
		var viewDate=$("#txtViewDate").val();
				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusListForOneDay.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRowsForOneDay(response);
			},
			error : function(e){
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
	
	//House Keeping View	
	function funShowRoomStatusFlashHouseKeeping()
	{
		gSelection='';
		gViewSelection='House Keeping View';
		$("#lblView").text("-  House Keeping View");
		var viewDate=$("#txtViewDate").val();				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusListForHouseKeeping.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRowsForHouseKeeping(response);
			},
			error : function(e){
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
	

	//weekend view Selection Wise
	function funShowRoomStatusFlashSelectionWise()
	{					
		gViewSelection='Seven Day View';
		var viewDate=$("#txtViewDate").val();
				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusList.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRows(response);
			},
			error : function(e){
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
	
	//One Day View Selection Wise
	function funShowRoomStatusFlashForOneDaySelectionWise()
	{
		gViewSelection='One Day View';
		var viewDate=$("#txtViewDate").val();
				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusListForOneDay.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRowsForOneDay(response);
			},
			error : function(e){
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
	
	//House Keeping View Selection Wise
	function funShowRoomStatusFlashHouseKeepingSelectionWise()
	{
		gViewSelection='House Keeping View';
		var viewDate=$("#txtViewDate").val();				
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusListForHouseKeeping.html?viewDate=" + viewDate,
			dataType : "json",
			 beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){ 
				funRemoveHeaderTableRows();
				funFillHeaderRowsForHouseKeeping(response);
			},
			error : function(e){
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
		
	function funShowRoomStatusDtl1(row)
	{		  
		  var ua = navigator.userAgent,
		    event = (ua.match(/iPad/i)) ? "touchstart" : "click";
		  if ($('.table').length > 0) {
		    $('.table .header').on(event, function() {
		      $(this).toggleClass("active", "").nextUntil('.header').css('display', function(i, v) {
		        return this.style.display === 'table-row' ? 'none' : 'table-row';
		      });
		    });
		  }	
	}
	
	function funShowRoomStatusDtl()
	{		
		var viewDate=$("#txtViewDate").val();
		var strPreviousNumber = "";	
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusDtlList.html?viewDate=" + viewDate+"&Selection="+gSelection,
			dataType : "json",
			async:false,
			beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){
				funRemoveDetailTableRows();
				var itemroomType='';
				$.each(response, function(i,item)
				{							
					if(itemroomType!=item.strRoomType){
						
						var key=item.strRoomType;
						var value=mapRoomType[key];
						var roomCnt = item.dblRoomCnt;
						funFillROomTypeHeaderRowsHeaderRows(key,value,roomCnt);
					}
					itemroomType=item.strRoomType;					
					if(strPreviousNumber=="")
					{
						strPreviousNumber = "temp";
					}
					if(item.strReservationNo==strPreviousNumber)
					{
						strPreviousNumber = item.strReservationNo;
					}
					else
					{
						strPreviousNumber = item.strReservationNo;
						funFillRoomStatusRows(item.strRoomNo,item.strDay1,item.strDay2,item.strDay3,item.strDay4,item.strDay5,item.strDay6,item.strDay7,item.strRoomStatus,item);	
					}				
				});
			},
			error : function(e){
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
	
		//For one Day view
	function funShowRoomStatusDtlForOneDay()
	{		
		var viewDate=$("#txtViewDate").val();
		var strPreviousNumber = '';
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusDtlListForOneDay.html?viewDate="+ viewDate+"&Selection="+gSelection,
			dataType : "json",
			async:false,
			beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");
		    },
			
			success : function(response){
				funRemoveDetailTableRows();
				var itemroomType='';
				$.each(response, function(i,item)
				{
				if(itemroomType!=item.strRoomType){
						
						var key=item.strRoomType;
						var roomCnt = item.dblRoomCnt;
						funFillROomTypeHeaderRowsHeaderRowsForOneDay(key,roomCnt);
					}
					
					itemroomType=item.strRoomType;
					if(strPreviousNumber=="")
					{
						strPreviousNumber = "temp";
					}
					if(item.strReservationNo==strPreviousNumber)
					{
						strPreviousNumber = item.strReservationNo;
					}
					else
					{
						strPreviousNumber = item.strReservationNo;
						funFillRoomStatusRowsForOneDay(item.strRoomNo,item.strDay1,item.strDay2,item.strDay3,item.strDay4,item.strDay5,item.strDay6,item.strDay7,item.strRoomStatus,item);	
					}					
				});
			},
			error : function(e){
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
	
	
	//For House Keeping view
	function funShowRoomStatusDtlForHouseKeeping()
	{
		var viewDate=$("#txtViewDate").val();
		var strPreviousNumber = '';
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomStatusDtlListForHouseKeeping.html?viewDate=" +viewDate+"&Selection="+gSelection,
			dataType : "json",
			async:false,
			beforeSend : function(){
				 $("#wait").css("display","block");
		    },
		    complete: function(){
		    	 $("#wait").css("display","none");s
		    },
			
			success : function(response){
				funRemoveDetailTableRows();
				var itemroomType='';
				$.each(response, function(i,item)
				{
				if(itemroomType!=item.strRoomType){
						
						var key=item.strRoomType;
						var roomCnt = item.dblRoomCnt;
						funFillROomTypeHeaderRowsHeaderRowsForHouseKepping(key,roomCnt);
					}
					
					itemroomType=item.strRoomType;
					if(strPreviousNumber=="")
					{
						strPreviousNumber = "temp";
					}
					if(item.strReservationNo==strPreviousNumber)
					{
						strPreviousNumber = "temp";
					}
					else
					{
						strPreviousNumber = item.strReservationNo;
						funFillRoomStatusRowsForHouseKeeping(item.strRoomNo,item.strDay1,item.strDay2,item.strDay3,item.strDay4,item.strDay5,item.strDay6,item.strDay7,item.strRoomStatus,item);	
					}
				
				});
			},
			error : function(e){
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
				
	function funGetRoomTypeAndStatus()
	{
		var viewDate=$("#txtViewDate").val();
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/getRoomTypeWiseList.html?viewDate=" + viewDate,
			dataType : "json",
			async:false,
			success : function(response){ 
				mapRoomType=response.RoomTypeCount;
			},
			error : function(e){
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
		
	function funFillHeaderRows(obj)
	{
		var table=document.getElementById("tblDays");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		
		
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"color:#4a4a4a; font-weight:550; font-size: 13px; \" value='Room No' >";
		row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[0]+"' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[1]+"' >";
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[2]+"' >";
		row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[3]+"' >";
		row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[4]+"' >";
		row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[5]+"' >";
		row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[6]+"' >";		
		
		funGetRoomTypeAndStatus();			
		funShowRoomStatusDtl();
	}
	
	function funFillHeaderRowsForOneDay(obj)
	{
		var table=document.getElementById("tblDays");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		
		
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"color:#4a4a4a; font-weight:550; font-size: 13px; \" value='Room No' >";
		row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='Alert' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='"+obj[0]+"' >";
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='' >";
		row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='Source' >";
		row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='Pax' >";
		row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='Rate Type' >";
		row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='Special Instruction' >";
		
		funShowRoomStatusDtlForOneDay();
	}

	function funFillHeaderRowsForHouseKeeping(obj)
	{
		var table=document.getElementById("tblDays");
		var rowCount=table.rows.length;
		var row=table.insertRow();	
		
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"color:#4a4a4a; font-weight:550; font-size: 13px; \" value='Room No' >";
		row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='STATUS' >";
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='AVAILABILITY' >";
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='PAX' >";
		row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='STAFF ALLOCATION' >";
		row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='REMARKS' >";
		row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='DISCREPANCY' >";
		row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" value='' >";
	
		funShowRoomStatusDtlForHouseKeeping();
	}
	
	
	
	function funFillRoomStatusRows(roomNo,day1,day2,day3,day4,day5,day6,day7,roomStatus,response)
	{
		var table=document.getElementById("tblRoomType");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		row.style.display='none';
		response.dblRemainingAmt='Balance: '+response.dblRemainingAmt;
		var color='';
		
		var toolTipText1="",toolTipText2="",toolTipText3="",toolTipText4="",toolTipText5="",toolTipText6="",toolTipText7="";
		if(roomStatus=='Waiting')
		{
			color= 'linear-gradient(250.46deg, #ff94ed 0.67%, #9242fc 100%)'; // linear-gradient(250.46deg, #ff94ed 0.67%, #9242fc 100%);
		}
		else if(roomStatus=='RESERVATION')
		{
			color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%)';//linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%)
		}
		else if(roomStatus=='Occupied')
		{
			color='linear-gradient(250.46deg, #3ade5e 0%, #2ba56e 100%);';
		}
		else if(roomStatus=='Checked Out')
		{
			color='linear-gradient(250.46deg, #d5d5d5 0%, #9d9d9d 100%);';
		}
		else if(roomStatus=='Blocked')
		{
			color='linear-gradient(250.46deg, #94b9ff 0.67%, #4283fc 100%);';
		}
		else if(roomStatus=='Dirty')
		{
			color='linear-gradient(70.46deg, #e4a846 0%, #ffd58e 100%);';
		}  
		else if(roomStatus=='VIRTUAL RESERVATION')
		{
			//color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%);';
			color='linear-gradient(to top, #e6b980 0%, #eacda3 100%);';			
		}   
	
		if(day1==null)
		{
			day1='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day1+='                  ,'+response.strReservationNo;
					  
					      toolTipText1+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;      
			}
		}
		
		if(day2==null)
		{
			day2='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day2+='                    ,'+response.strReservationNo;
					      toolTipText2+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;		
	        }
		}
		
		if(day3==null)
		{
			day3='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day3+='                     ,'+response.strReservationNo;
					      toolTipText3+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
			}
		}
		
		if(day4==null)
		{
			day4='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day4+='                    ,'+response.strReservationNo;
					      toolTipText4+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;		
			}
		}
		
		if(day5==null)
		{
			day5='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day5+='                    ,'+response.strReservationNo;
					      toolTipText5+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;	
			}
		}
		
		if(day6==null)
		{
			day6='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day6+='                    ,'+response.strReservationNo;
					      toolTipText6+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;	
			}
		}
		
		if(day7==null)
		{
			day7='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day7+='                     ,'+response.strReservationNo;
					      toolTipText7+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;	
			}
		}
				
		if(roomNo.includes(""))
		{
			row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
		}
		else
		{
			row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
		}
				
		var x1=row.insertCell(1);		
		if(roomStatus.includes('Dirty'))
		{
			day1='DIRTY                                      ,'+roomNo;
			x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+"; \"><input readonly=\"readonly\" class=\"Box \"  style=\"width: 100%;height: 20px; color: white; \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
		}
		else
		{
			if(day1==''){
				x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\" ><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
			}
			else{
				x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
			}
		}		
		
		if(day1!='')
		{ 
			x1.style.transform='skew(-17deg)';
			x1.title=toolTipText1;
		}
		
		var x2=row.insertCell(2);
		x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(9deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
		if(day1!='')
		{
			if(!day1.includes(day2))
			{
				x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
				x2.style.transform='skew(-17deg)';
				x2.title=toolTipText2;
			}
		}
		else
		{
			if(day2!='')
			{
				x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
				x2.style.transform='skew(-17deg)';
				x2.title=toolTipText2;
			}
		}
		
		var x3=row.insertCell(3);
		x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg); \" value='"+day3+"' onClick='funOnClick(this)'></div>";
		if(day1!='')
		{
			if(!day1.includes(day3))
			{
				x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
				x3.style.transform='skew(-17deg)';
				x3.title=toolTipText3;
			}
		}
		else
		{
			if(day3!='')
			{
				x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
				x3.style.transform='skew(-17deg)';
				x3.title=toolTipText3;
			}
		}		
		
		var x4=row.insertCell(4);
		x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day4+"' onClick='funOnClick(this)' ></div>";
		if(day1!='')
		{
			if(!day1.includes(day4))
			{
				x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
				x4.style.transform='skew(-17deg)';
				x4.title=toolTipText4;
			}
		}
		else
		{
			if(day4!='')
			{
				x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
				x4.style.transform='skew(-17deg)';
				x4.title=toolTipText4;
			}
		}		
		
		var x5=row.insertCell(5);
		x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day5+"' onClick='funOnClick(this)' ></div>";
		if(day1!='')
		{
			if(!day1.includes(day5))
			{
				x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width:font:size:0px; 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
				x5.style.transform='skew(-17deg)';
				x5.title=toolTipText5;
			}
		}
		else
		{
			if(day5!='')
			{
				x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
				x5.style.transform='skew(-17deg)';
				x5.title=toolTipText5;
			}
		}		
		
		var x6=row.insertCell(6);
		x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
		if(day1!='')
		{
			if(!day1.includes(day6))
			{
				x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
				x6.style.transform='skew(-17deg)';
				x6.title=toolTipText6;
			}
		}
		else
		{
			if(day6!='')
			{
				x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
				x6.style.transform='skew(-17deg)';
				x6.title=toolTipText6;
			}
				
		}	
		
		
		var x7=row.insertCell(7);
		x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day7+"' onClick='funOnClick(this)'></div>";
		if(day1!='')
		{
			if(!day1.includes(day7))
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)'></div>";
				x7.style.transform='skew(-17deg)';
				x7.title=toolTipText7;
			}
		}
		else
		{
			if(day7!='')
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)'></div>";
				x7.style.transform='skew(-17deg)';
				x7.title=toolTipText7;
			}
				
		}	
		
		
		/* 
		 var x7=row.insertCell(7);
		x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%; color:#fff;height: 20px; transform:skew(9deg); \" value='"+day7+"' onClick='funOnClick(this)' ></div>";
		if(day1!='')
		{
			if(!day1.includes(day7))
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-style:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";
	
				//x7.bgColor=color;
				x7.style.transform='skew(-17deg)';
				x7.title=toolTipText7;
			}
		}
		else
		{
			if(day7!='')
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";

				//x7.bgColor=color;
				x7.style.transform='skew(-17deg)';
				x7.title=toolTipText7;
			}	
		} */
	}
	
			
	
	//For One Day View	
	function funFillRoomStatusRowsForOneDay(roomNo,day1,day2,day3,day4,day5,day6,day7,roomStatus,response)
	{
		var table=document.getElementById("tblRoomType");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		row.style.display='none';
		response.dblRemainingAmt='Balance: '+response.dblRemainingAmt;
		var color='';
		
		var toolTipText1="",toolTipText2="",toolTipText3="",toolTipText4="",toolTipText5="",toolTipText6="",toolTipText7="";
		if(roomStatus=='Waiting')
		{
			color='linear-gradient(250.46deg, #ff94ed 0.67%, #9242fc 100%);';
		}
		else if(roomStatus=='RESERVATION')
		{
			color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%);';
		}
		else if(roomStatus=='Occupied')
		{
			color='linear-gradient(250.46deg, #3ade5e 0%, #2ba56e 100%);';
		}
		else if(roomStatus=='Checked Out')
		{
			color='linear-gradient(250.46deg, #d5d5d5 0%, #9d9d9d 100%);';
		}
		else if(roomStatus=='Blocked')
		{
			color='linear-gradient(250.46deg, #94b9ff 0.67%, #4283fc 100%);';
		}
		else if(roomStatus=='Dirty')
		{
			color='linear-gradient(70.46deg, #e4a846 0%, #ffd58e 100%);';
		}  
	
		if(day1==null)
		{
			day1='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{				
					      day1+='                  ,'+response.strReservationNo;					  
					      toolTipText1+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
			}
		}
		
		row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
		var x1=row.insertCell(1);		
			
			if(day1==''){
				x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\" ><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;  \" value='' onClick='funOnClick(this)' ></div>";
			}
			else{
				x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;  \" value='' onClick='funOnClick(this)' ></div>";
			}		
		
		if(day1!='')
		{ 		
			x1.title=toolTipText1;
		}
		
		var x2=row.insertCell(2);
		if(day1!='')
		{		
			x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px ;\" value='"+day1+"' onClick='funOnClick(this)' ></div>";
			x2.title=toolTipText1;		
		}
		else
		{
			if(day1!='')
			{
				//x2.bgColor=color;
				x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px; \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
				x2.title=toolTipText1;
			}
		}
		
		var x3=row.insertCell(3);
		if(day1!='')
		{		
			x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px; \" value='"+day1+"' onClick='funOnClick(this)'></div>";
			x3.title=toolTipText1;
		}		
		else
		{
			if(day1!='')
			{
				x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px; \" value='"+day1+"' onClick='funOnClick(this)'></div>";
				x3.title=toolTipText1;
			}
		}		
		
		var x4=row.insertCell(4);
		if(day1!='')
		{
			x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+response.strSource+"' ></div>";
			x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+response.strSource+"'></div>";
		}
		
		var x5=row.insertCell(5);
		if(day1!='')
		{
			if(!day1.includes(day5))
			{
				x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width:font:size:0px; 90%;height: 20px;text-align:center; \" value='"+response.dblPax+"' ></div>";
				
			}
		}
		else
		{
			if(day1!='')
			{
				x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px; text-align:center;\" value='"+response.dblPax+"' ></div>";
				
			}
		}
		
		var x6=row.insertCell(6);
		if(day1!='')
		{
			if(!day1.includes(day6))
			{
				x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+response.dblRoomRate+"'></div>";
				
			}
		}
		else
		{
			if(day1!='')
			{
				x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+response.dblRoomRate+"' ></div>";
				
			}				
		}		
		
		var x7=row.insertCell(7);
		if(day1!='')
		{
			if(!day1.includes(day7))
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-style:0px; width: 90%;height: 20px;text-align:center;\" value='"+response.strSpclInstruction+"' ></div>";
			}
		}
		else
		{
			if(day1!='')
			{
				x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+response.strSpclInstruction+"' ></div>";
			}	
		}
	}	
	
	//For House Keeping View	
	function funFillRoomStatusRowsForHouseKeeping(roomNo,day1,day2,day3,day4,day5,day6,day7,roomStatus,response)
	{
		var table=document.getElementById("tblRoomType");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		row.style.display='none';
		response.dblRemainingAmt='Balance: '+response.dblRemainingAmt;
		var color='';
		
		day1,day2,day3,day4,day5,day6,day7
		if(day1==null)
		{
			day1="";
		}
		if(day2==null)
		{
			day2="";
		}
		if(day3==null)
		{
			day3="";
		}
		if(day4==null)
		{
			day4="";
		}
		if(day5==null)
		{
			day5="";
		}
		if(day6==null)
		{
			day6="";
		}
		if(day7==null)
		{
			day7="";
		}
		var toolTipText1="",toolTipText2="",toolTipText3="",toolTipText4="",toolTipText5="",toolTipText6="",toolTipText7="";
		if(roomStatus=='Waiting')
		{
			color='linear-gradient(250.46deg, #ff94ed 0.67%, #9242fc 100%);';
		}
		else if(roomStatus=='RESERVATION')
		{
			color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%);';
		}
		else if(roomStatus=='Occupied')
		{
			color='linear-gradient(250.46deg, #3ade5e 0%, #2ba56e 100%);';
		}
		else if(roomStatus=='Checked Out')
		{
			color='linear-gradient(250.46deg, #d5d5d5 0%, #9d9d9d 100%);';
		}
		else if(roomStatus=='Blocked')
		{
			color='linear-gradient(250.46deg, #94b9ff 0.67%, #4283fc 100%);';
		}
		else if(roomStatus=='Dirty')
		{
			color='linear-gradient(70.46deg, #e4a846 0%, #ffd58e 100%);';
		}  	
		if(day1==null)
		{
			day1='';
		}
		else
		{
			if(response.strReservationNo!=null)
			{
					      day1+='                  ,'+response.strReservationNo;					  
					      toolTipText1+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
			}
		}
		roomStatus=roomStatus+'                                      ,'+roomNo;
		row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
		
		var x1=row.insertCell(1);
			x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;  \" value='"+roomStatus+"' onClick='funOnClick(this)' ></div>";
	
		var x2=row.insertCell(2);
			x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px ;\" value='"+roomStatus+"' onClick='funOnClick(this)' ></div>";
			x2.title=toolTipText1;		
				
		var x3=row.insertCell(3);
			x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px; text-align:center; \" value='"+response.dblPax+"' onClick='funOnClick(this)'></div>";
			x3.title=toolTipText1;
				
		var x4=row.insertCell(4);
			x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+day4+"'></div>";
				
		var x5=row.insertCell(5);
			x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width:font:size:0px; 90%;height: 20px;text-align:center; \" value='"+day5+"' ></div>";
			
		var x6=row.insertCell(6);
			x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;text-align:center; \" value='"+day6+"'></div>";
		
		var x7=row.insertCell(7);		
			x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; \"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-style:0px; width: 90%;height: 20px;text-align:center;\" value='"+day7+"' ></div>";
	}
	
	var message = "";
	function funOnClick(obj)
	{
		var color=$(obj).parent()[0].style.background;
		var url='';
		switch(color)
		{
			case 'linear-gradient(250.46deg, rgb(58, 222, 94) 0%, rgb(43, 165, 110) 100%)'://RED-->CHECKED-IN-->OCCUPIED
									  //code=obj.value;
				                      if(gViewSelection=='House Keeping View')
			                    	  {
				                    	  var isCheckOk=confirm("Do You Want to schedule this room for cleaning ?"); 
				  						  if(isCheckOk){
				  							code=obj.defaultValue.split(","); 
				  						    var subStr = code[1];
											
				  						     funCallRoomDirty(obj,subStr);
				  						  }
			                    	  }
				                      else
			                    	  {
				                    	  code=obj.defaultValue.split(",");//rgb(255, 79, 83)
										  var subStr = code[1];
										  gcode=code;
										  showPopup(code);
			                    	  } 
									 									
		   						  	  break;
			case 'linear-gradient(250.46deg, rgb(213, 213, 213) 0%, rgb(157, 157, 157) 100%)'://GREY-->CHECKED-OUT
									  
			      code=obj.defaultValue.split(",");
				  var subStr = code[1];
				  
				  var isCheckOk=confirm("Do You Want to go on Reopen ?"); 
					if(isCheckOk){
						url=getContextPath()+"/frmReOpenFolio.html?folioNo="+obj.defaultValue.split(',')[1];
						 window.open(url);	
					}
					else
					{
						var isCheckOk=confirm("Do You Want to go on Print Bill ?"); 
						if(isCheckOk){
							url=getContextPath()+"/frmBillPrinting.html?docCode="+obj.defaultValue.split(',')[1];
							 window.open(url);	
						}
					} 
				  break;									  
									  
			case 'linear-gradient(250.46deg, rgb(255, 148, 237) 0.67%, rgb(146, 66, 252) 100%)':          //'linear-gradient(250.46deg, rgb(255, 162, 162) 0%, rgb(255, 91, 91) 100%)'://purple-->WAITING
			//
	            var isCheckOk=confirm("Do You Want to Check In  ?"); 
				if(isCheckOk){
					
					code=obj.defaultValue.split(",");
					  var subStr = code[1];
					  url=getContextPath()+"/frmCheckIn1.html?docCode="+subStr
					  window.open(url);
				}
				  
				  break;
		
			case 'linear-gradient(250.46deg, rgb(255, 162, 162) 0%, rgb(255, 91, 91) 100%)':          //'linear-gradient(250.46deg, rgb(255, 162, 162) 0%, rgb(255, 91, 91) 100%)'://purple-->WAITING
				//
		            var isCheckOk=confirm("Do You Want to Check In  ?"); 
					if(isCheckOk){
						
						code=obj.defaultValue.split(",");
						  var subStr = code[1];
						  url=getContextPath()+"/frmCheckIn1.html?docCode="+subStr
						  window.open(url);
					}
					  
					  break;
					  
				  
			case 'linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%)'://GREEN-->CONFIRM
				 code=obj.defaultValue.split(",");
				  var subStr = code[1];
				  url=getContextPath()+"/frmCheckIn1.html?docCode="+subStr
				  window.open(url);
				  break;
			
			case ''://GREEN-->CONFIRM
				  code=obj.value;
				  var index=obj.parentNode.parentNode.parentNode.rowIndex;
				  var table1=document.getElementById("tblRoomType");
				  var indexData=table1.rows[index];
				  var roomNo=indexData.cells[0].childNodes[0].childNodes[0].defaultValue;
				  var count=indexData.cells[1].cellIndex;
				  
				  var table2=document.getElementById("tblDays");
				  var indexDate=table2.rows[0];				  
				  if(gViewSelection=='House Keeping View')
            	  {
                	  var isCheckOk=confirm("Do You Want to schedule this room for cleaning ?"); 
						  if(isCheckOk){
							code=obj.defaultValue.split(","); 
						    var subStr = code[1];						
						    funCallRoomDirty(obj,subStr);
						  }
            	  }
				  else
				  {
					  if(obj.parentNode.parentNode.cellIndex>1)
					  {
					  var isCheckOk=confirm("Do You Want to go on Reservation ?"); 
						if(isCheckOk)
						{
						  url=getContextPath()+"/frmReservation1.html?docCode="+code+"&roomNo="+roomNo+"&rootIndex="+obj.parentNode.parentNode.cellIndex;
						  window.open(url);
						}
					  }
					  else
					  {
					  var isCheckOk=confirm("Do You Want to go on Walkin ?"); 
						if(isCheckOk)
						{
						  url=getContextPath()+"/frmWalkin1.html?docCode="+code+"&roomNo="+roomNo;
						  window.open(url);
						}
					  }
				  }	  
				  
				  

				  break;
				  
			case 'linear-gradient(70.46deg, rgb(228, 168, 70) 0%, rgb(255, 213, 142) 100%)'://Orange-->Dirty
				  code=obj.defaultValue.split(","); 
				  var subStr = code[1];
				
				  var isDirtyOk=confirm("Do You want to mark this room as Clean ?");
				  
				  if(isDirtyOk)
					{		
					  /* funCallRoomClean(subStr,obj); */
					  funOpenCleanPage(subStr,obj);
					  
						//window.open(getContextPath() + "/cleanRoomStatus.html?checkInNo=" +nextFinalTemp);
					}
			
				  break;
				  
			/* case 'rgba(0, 0, 0, 0)'://GREEN-->CONFIRM
				  code=obj.value;
				  //code=code.split(',')[1].trim();
				  // For Room Number
				  var index=obj.parentNode.parentNode.rowIndex;
				  var table1=document.getElementById("tblRoomInfo");
				  var indexData=table1.rows[index];
				  var roomNo=indexData.cells[0].childNodes[0].defaultValue;
				  // For Particular Date
				  var table2=document.getElementById("tblDays");
				  var indexDate=table2.rows[0];
				  var roomDate=table2.rows[0].cells[index-1].childNodes[0].defaultValue
				  alert("Proceed to \n\n"+message);
				  url=getContextPath()+"/frmWalkin1.html?docCode="+code+"&roomNo="+roomNo+"&roomDate="+roomDate;
				  window.open(url);

				  break; */
									  
		}					
	}
		
	function funSetData(code)
	{
		switch (fieldName)
		{
			
		}
	}
	
	
	
	function funHelp(transactionName)
	{
		fieldName = transactionName;
		window.showModalDialog("searchform.html?formname=" + transactionName + "&searchText=", "","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funCallRoomClean(subStr,obj)
	{  
		$.ajax({
			type : "GET",
			  url: getContextPath()+ "/cleanRoomStatus.html?checkInNo=" +subStr,
			  dataType : "text",
			  success: function(response) {
			    
				  var index=obj.parentNode.parentNode.rowIndex;
				  var table1=document.getElementById("tblRoomType");
				  var indexData=table1.rows[index];
				  indexData.cells[1].bgColor='';
				  obj.defaultValue='';
				  alert('Room cleaned Successfully');
			    
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
		
	function funCallRoomDirty(obj,subStr)
	{  
		$.ajax({
			type : "GET",
			  url: getContextPath()+ "/UpdateDirtyStatus.html?RoomDesc=" +subStr,
			  dataType : "json",
			  async:false,
			  success: function(response) {
				  location.reload(true); 
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
		function funFillROomTypeHeaderRowsHeaderRows(key,value,roomCnt)
		{
		
			var table=document.getElementById("tblRoomType");
			table.setAttribute("class", "table table-bordered");
			var rowCount=table.rows.length;
			var row=table.insertRow();
			row.setAttribute("class", "header");
			key=key+" ("+roomCnt+")";
			
			var valueArr = value.split('/');
			var inpKey = key;
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%; color:#4a4a4a; font-weight:550; font-size: 13px; width: 72%; \" value='"+key+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[1].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[2].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info\"  style=\"width: 88%;\" value='"+valueArr[3].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[4].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[5].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[6].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='"+valueArr[7].replace("-", "/")+"' onClick=\"funShowRoomStatusDtl1(this)\">";
		}
		
		//One Day		
		function funFillROomTypeHeaderRowsHeaderRowsForOneDay(key,roomCnt)
		{		
			var table=document.getElementById("tblRoomType");
			table.setAttribute("class", "table table-bordered");
			var rowCount=table.rows.length;
			var row=table.insertRow();
			row.setAttribute("class", "header");
			key=key+" ("+roomCnt+")";
			
			var inpKey = key;
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%; color:#4a4a4a; font-weight:550; font-size: 13px; width: 72%; \" value='"+key+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info\"  style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
		}
		
		
		//House Keeping		
		function funFillROomTypeHeaderRowsHeaderRowsForHouseKepping(key,roomCnt)
		{		
			var table=document.getElementById("tblRoomType");
			table.setAttribute("class", "table table-bordered");
			var rowCount=table.rows.length;
			var row=table.insertRow();
			row.setAttribute("class", "header");
			key=key+" ("+roomCnt+")";
			
			var inpKey = key;
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%; color:#4a4a4a; font-weight:550; font-size: 13px; width: 72%; \" value='"+key+"' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"column-info\"  style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
			row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"column-info \" style=\"width: 88%;\" value='' onClick=\"funShowRoomStatusDtl1(this)\">";
		}
		
		function funOpenCleanPage(roomNo,obj)
		{
			var transactionName ;
		  	transactionName  = roomNo;
		    var name = obj.defaultValue.split(",")[0];
			window.open("frmCheckDirtyRoom.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
			window.close;				
		}		
		
		function funCheckAllDirty(code)
		{
			switch (fieldName)
			{
			case 'userDefinedReportCode':
				if(response.name.includes("mywindow")){
					  funCallRoomClean(roomNo,obj);
					  var index=obj.parentNode.parentNode.rowIndex;
					  var table1=document.getElementById("tblRoomType");
					  var indexData=table1.rows[index];
					  indexData.cells[1].bgColor='';
					  obj.defaultValue='';
					  alert('Room cleaned Successfully');
					}
			        break;				
			}
		}
		 function showPopup(code) {
		        
			 $.ajax({
					type : "GET",
					  url: getContextPath()+ "/getInformation.html?code=" +code,
					  dataType : "json",
					  async:false,
					  success: function(response) {
					    
						  var total = 0;
						  $("#txtGuestName").text(response[0]);
						  $("#txtCheckInDate").text(response[1]);
						  $("#txtNumber").text(response[2]);
						  $("#txtFolioNo").text(response[3]);
						  $("#txtRoomNo").text(response[4]);
						  $("#txtOneDayTariff").text(response[5]);
						  $("#txtTaxAmt").text(response[6]);
						  $("#txtNoOfNights").text(response[7]);
						  $("#txtExtraBedCharges").text(response[8]);
						  $("#txtHighSeasonFee").text(0);
						  $("#txtCleaningFee").text(0); 
						  $("#txtCheckOutDate").text(response[10]); 
						  if(response[7]>0){
							  total = (response[5]*response[7])+response[6]+response[8];
						  }
						  else
							  {
							 total = parseFloat(response[5])+parseFloat(response[6])+parseFloat(response[8]);
							  }
						 
						  $("#txtTotal").text(total);
						  funloadMemberPhoto(response[9]);					    
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
			 
			 document.getElementById('popover').style.cssText = 'display: block';
		      
		      }
		 function hidePopup() {
		        document.getElementById('popover').style.cssText = 'display: none';
		      }
		 function hidePopupCheckIn() {
		        document.getElementById('checkInListPopUp').style.cssText = 'display: none';
		      }
		 function hidePopupreport() {
		        document.getElementById('reportsPopup').style.cssText = 'display: none';
		      }
		 
		 function funOpenRoomMaster()
	      {
				window.open("frmRoomMaster.html?","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=1000");
				window.close;
	      }
		 function funUpdateTotal()
		 {
			 var rate = parseFloat($("#txtOneDayTariff").text());
			 var taxes = parseFloat($("#txtTaxAmt").text());
			 var noOfNights = parseFloat($("#txtNoOfNights").text());
			 var highSeasonCharges = parseFloat($("#txtHighSeasonFee").val());
			 var cleaningFee =  parseFloat($("#txtCleaningFee").val());
			 var total = (rate*noOfNights)+taxes+ highSeasonCharges+cleaningFee;
			 $("#txtTotal").text(total);		 
		 }
		 
		 function funConfirmClicked()
		 {
			 var isCheckOk=confirm("Do You Want to Checkout ?"); 
				if(isCheckOk)
				{			 	 
					var subStr =  $("#txtFolioNo").text();
					url=getContextPath()+"/frmCheckOut1.html?docCode="+subStr
			 	 	window.open(url); 
				}
				else
					{
					isCheckOk =	confirm("Do you want to clean this room");
					if(isCheckOk)
						{
							funOpenCleanPage(subStr,obj);						
						}
					}
		 }		 
		 
		 function funloadMemberPhoto(code)
			{
			 	ggcode=code;
			 	var searchUrl1=getContextPath()+"/loadGuestImage.html?guestCode="+code;
				$("#memImage").attr('src', searchUrl1);				
			}  

		  
		 function funShowImagePreview(input)
		 {
			 if (input.files && input.files[0])
			 {
				 var filerdr = new FileReader();
				 filerdr.onload = function(e) 
				 {
				 	$('#memImage').attr('src', e.target.result);
				 }
				 filerdr.readAsDataURL(input.files[0]);
				 uploadNeWImage();
			 }
		 } 
		 
		
		 
		 
		  function funChangeImage() {		  
			  window.open("frmGuestImageChange.html?guestCode="+ggcode+"&code="+gcode,"","dialogHeight:600px;dialogWidth:800px;top=500,left=500")
			  hidePopup();			  
			}		  

		  function funWaiting() 
		  {		
			  //seven day view
			  gSelection='Waiting';		
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
			 
			 // gViewSelection='House Keeping View';  
			 
		  }
		  function funReservation() 
		  {		
			  gSelection='RESERVATION';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funOccupied() 
		  {		
			  gSelection='Occupied';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funCheckedOut() 
		  {		
			  gSelection='Checked Out';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funBlocked() 
		  {		
			  gSelection='Blocked';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funDirty() 
		  {		
			  gSelection='Dirty';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funGroupReservation() 
		  {		
			  gSelection='GROUP RESERVATION';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  function funVirtualReservation() 
		  {		
			  gSelection='VIRTUAL RESERVATION';			  
			  if(gViewSelection=='Seven Day View')
			  {
				  funShowRoomStatusFlashSelectionWise();
			  }
			  else if(gViewSelection=='One Day View')
			  {
				  funShowRoomStatusFlashForOneDaySelectionWise();
			  }
			  else if(gViewSelection=='House Keeping View')
			  {
				  funShowRoomStatusFlashHouseKeepingSelectionWise();
			  }
			  else
			  {
			  	alert("Select View First");
			  }
		  }
		  
		  function funGetRoomTypeAndStatusSelectionWise()
			{
				var viewDate=$("#txtViewDate").val();
				$.ajax({
					type : "GET",
					url : getContextPath()+ "/getRoomTypeWiseList.html?viewDate=" + viewDate,
					dataType : "json",
					async:false,
					success : function(response){ 
						mapRoomType=response.RoomTypeCount;
					},
					error : function(e){
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
		  
		  /* 
		  function funShowRoomStatusDtl()
			{
				var viewDate=$("#txtViewDate").val();
				var strPreviousNumber = "";	
				$.ajax({
					type : "GET",
					url : getContextPath()+ "/getRoomStatusDtlList.html?viewDate=" + viewDate,
					dataType : "json",
					async:false,
					beforeSend : function(){
						 $("#wait").css("display","block");
				    },
				    complete: function(){
				    	 $("#wait").css("display","none");
				    },					
					success : function(response){
						funRemoveDetailTableRows();
						var itemroomType='';
						$.each(response, function(i,item)
						{
							if(itemroomType!=item.strRoomType){
								
								var key=item.strRoomType;
								var value=mapRoomType[key];
								var roomCnt = item.dblRoomCnt;
								funFillROomTypeHeaderRowsHeaderRows(key,value,roomCnt);
							}
							itemroomType=item.strRoomType;							
							if(strPreviousNumber=="")
							{
								strPreviousNumber = "temp";
							}
							if(item.strReservationNo==strPreviousNumber)
							{
								strPreviousNumber = item.strReservationNo;
							}
							else
							{
								strPreviousNumber = item.strReservationNo;
								funFillRoomStatusRows(item.strRoomNo,item.strDay1,item.strDay2,item.strDay3,item.strDay4,item.strDay5,item.strDay6,item.strDay7,item.strRoomStatus,item);	
							}						
						});
					},
					error : function(e){
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
		   */
		  function funFillRoomStatusRows(roomNo,day1,day2,day3,day4,day5,day6,day7,roomStatus,response)
			{
			   if((response.strRoomStatus==gSelection && response.strReservationNo!=null)||gSelection=='')
				{
					var table=document.getElementById("tblRoomType");
					var rowCount=table.rows.length;
					var row=table.insertRow();
					row.style.display='none';
					response.dblRemainingAmt='Balance: '+response.dblRemainingAmt;
					var color='';
					
					var toolTipText1="",toolTipText2="",toolTipText3="",toolTipText4="",toolTipText5="",toolTipText6="",toolTipText7="";
					if(roomStatus=='Waiting')
					{
						color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%);';  //Purple color //color='linear-gradient(250.46deg, #ff94ed 0.67%, #9242fc 100%);';//This sould be purple
					}
					else if(roomStatus=='RESERVATION')
					{
						color='linear-gradient(250.46deg, #ffa2a2 0%, #ff5b5b 100%);';//This shold be red
					}
					else if(roomStatus=='Occupied')
					{
						color='linear-gradient(250.46deg, #3ade5e 0%, #2ba56e 100%);';
					}
					else if(roomStatus=='Checked Out')
					{
						color='linear-gradient(250.46deg, #d5d5d5 0%, #9d9d9d 100%);';
					}
					else if(roomStatus=='Blocked')
					{
						color='linear-gradient(250.46deg, #94b9ff 0.67%, #4283fc 100%);';
					}
					else if(roomStatus=='Dirty')
					{
						color='linear-gradient(70.46deg, #e4a846 0%, #ffd58e 100%);';
					}  
					else if(roomStatus=='VIRTUAL RESERVATION')
					{
						color='linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(230,17,68,1) 1%);';		
					} 
					else if(response.strSource=='GROUP RESERVATION')
					{						
						color='rgb(105, 89, 205)';
					} 
				
					if(day1==null)
					{
						day1='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{						
								      day1+='                  ,'+response.strReservationNo;							  
								      toolTipText1+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day2==null)
					{
						day2='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day2+='                    ,'+response.strReservationNo;
								      toolTipText2+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day3==null)
					{
						day3='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day3+='                     ,'+response.strReservationNo;
								      toolTipText3+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;	
						}
					}
					
					if(day4==null)
					{
						day4='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day4+='                    ,'+response.strReservationNo;
								      toolTipText4+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day5==null)
					{
						day5='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day5+='                    ,'+response.strReservationNo;
								      toolTipText5+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day6==null)
					{
						day6='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day6+='                    ,'+response.strReservationNo;
								      toolTipText6+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day7==null)
					{
						day7='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day7+='                     ,'+response.strReservationNo;
								      toolTipText7+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
							
					if(roomNo.includes(""))
					{
						row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
					}
					else
					{
						row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
					}
					
					if(((response.strRoomStatus=="GROUP RESERVATION" ||response.strRoomStatus=="VIRTUAL RESERVATION") && response.strReservationNo!=null)||gSelection=='')
					{	   
					   
					}
					else
					{
					
					}
									
					var x1=row.insertCell(1);				
					if(roomStatus.includes('Dirty'))
						{
							day1='DIRTY                                      ,'+roomNo;
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+"; \"><input readonly=\"readonly\" class=\"Box \"  style=\"width: 100%;height: 20px; color: white; \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
					else
						{
						if(day1==''){
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\" ><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
						else{
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
					}
					
					if(day1!='')
					{ 
						x1.style.transform='skew(-17deg)';
						x1.title=toolTipText1;
					}
					
					var x2=row.insertCell(2);
					x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(9deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
					if(!day1.includes(day2))
					{
						x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
						x2.style.transform='skew(-17deg)';
						x2.title=toolTipText2;
					}
					}
					else
					{
						if(day2!='')
						{
							//x2.bgColor=color;
							x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
							x2.style.transform='skew(-17deg)';
							x2.title=toolTipText2;
						}
					}
									
					var x3=row.insertCell(3);
					x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg); \" value='"+day3+"' onClick='funOnClick(this)'></div>";
					if(day1!='')
					{
						if(!day1.includes(day3))
						{
							x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
							x3.style.transform='skew(-17deg)';
							x3.title=toolTipText3;
						}
					}
					else
					{
						if(day3!='')
						{
							x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
							x3.style.transform='skew(-17deg)';
							x3.title=toolTipText3;
						}
					}				
					
					var x4=row.insertCell(4);
					x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day4+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day4))
						{
							x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
							x4.style.transform='skew(-17deg)';
							x4.title=toolTipText4;
						}
					}
					else
					{
						if(day4!='')
						{
							x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
							x4.style.transform='skew(-17deg)';
							x4.title=toolTipText4;
						}
					}				
					
					var x5=row.insertCell(5);
					x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day5+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day5))
						{
							x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width:font:size:0px; 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
							x5.style.transform='skew(-17deg)';
							x5.title=toolTipText5;
						}
					}
					else
					{
						if(day5!='')
						{
							x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
							x5.style.transform='skew(-17deg)';
							x5.title=toolTipText5;
						}
					}				
					
					
					var x6=row.insertCell(6);
					x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
					if(day1!='')
					{
						if(!day1.includes(day6))
						{
							x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
							x6.style.transform='skew(-17deg)';
							x6.title=toolTipText6;
						}
					}
					else
					{
						if(day6!='')
						{
							x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
							x6.style.transform='skew(-17deg)';
							x6.title=toolTipText6;
						}						
					}				
					
					var x7=row.insertCell(7);
					x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;margin-right: 3px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%; color:#fff;height: 20px; transform:skew(9deg); \" value='"+day7+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day7))
						{
							x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; margin-right: 3px;background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-style:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";
		
							//x7.bgColor='#ffffff';
							x7.style.transform='skew(-17deg)';
							x7.title=toolTipText7;
						}
					}
					else
					{
						if(day7!='')
						{
							x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";
	
							//x7.bgColor=color;
							x7.style.transform='skew(-17deg)';
							x7.title=toolTipText7;
						}			
					}
				}
			   else if(response.strSource=='GROUP RESERVATION'||response.strSource=='VIRTUAL RESERVATION')
			   {
					var table=document.getElementById("tblRoomType"); 
					var rowCount=table.rows.length;
					var row=table.insertRow();
					row.style.display='none';
					response.dblRemainingAmt='Balance: '+response.dblRemainingAmt;
					var color='';
					
					var toolTipText1="",toolTipText2="",toolTipText3="",toolTipText4="",toolTipText5="",toolTipText6="",toolTipText7="";
					if(roomStatus=='VIRTUAL RESERVATION')
					{
						color='linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(230,17,68,1) 1%);';		
					} 
					else if(response.strSource=='GROUP RESERVATION')
					{						
						color='rgb(105, 89, 205)';
					} 
				
					if(day1==null)
					{
						day1='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{						
								      day1+='                  ,'+response.strReservationNo;							  
								      toolTipText1+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day2==null)
					{
						day2='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day2+='                    ,'+response.strReservationNo;
								      toolTipText2+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day3==null)
					{
						day3='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day3+='                     ,'+response.strReservationNo;
								      toolTipText3+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;	
						}
					}
					
					if(day4==null)
					{
						day4='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day4+='                    ,'+response.strReservationNo;
								      toolTipText4+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day5==null)
					{
						day5='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day5+='                    ,'+response.strReservationNo;
								      toolTipText5+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day6==null)
					{
						day6='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day6+='                    ,'+response.strReservationNo;
								      toolTipText6+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
					
					if(day7==null)
					{
						day7='';
					}
					else
					{
						if(response.strReservationNo!=null)
						{
								      day7+='                     ,'+response.strReservationNo;
								      toolTipText7+="\n"+response.strGuestName+"\n"+response.strReservationNo+"\n"+response.strRoomNo+"\n"+response.dteArrivalDate+"\n"+response.dteDepartureDate+"\n"+roomStatus+"\n"+response.dblRemainingAmt;
						}
					}
							
					if(roomNo.includes(""))
					{
						row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
					}
					else
					{
						row.insertCell(0).innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \" style=\"text-align: center;width: 100%;\" value='"+roomNo+"' ></div>";
					}
					
					if(((response.strRoomStatus=="GROUP RESERVATION" ||response.strRoomStatus=="VIRTUAL RESERVATION") && response.strReservationNo!=null)||gSelection=='')
					{	   
					   
					}
					else
					{
					
					}
									
					var x1=row.insertCell(1);				
					if(roomStatus.includes('Dirty'))
						{
							day1='DIRTY                                      ,'+roomNo;
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+"; \"><input readonly=\"readonly\" class=\"Box \"  style=\"width: 100%;height: 20px; color: white; \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
					else
						{
						if(day1==''){
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\" ><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
						else{
							x1.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input  readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;height: 20px;color: white;transform:skew(14deg); \" value='"+day1+"' onClick='funOnClick(this)' ></div>";
						}
					}
					
					if(day1!='')
					{ 
						x1.style.transform='skew(-17deg)';
						x1.title=toolTipText1;
					}
					
					var x2=row.insertCell(2);
					x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(9deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
					if(!day1.includes(day2))
					{
						x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
						x2.style.transform='skew(-17deg)';
						x2.title=toolTipText2;
					}
					}
					else
					{
						if(day2!='')
						{
							//x2.bgColor=color;
							x2.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day2+"' onClick='funOnClick(this)' ></div>";
							x2.style.transform='skew(-17deg)';
							x2.title=toolTipText2;
						}
					}
									
					var x3=row.insertCell(3);
					x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg); \" value='"+day3+"' onClick='funOnClick(this)'></div>";
					if(day1!='')
					{
						if(!day1.includes(day3))
						{
							x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
							x3.style.transform='skew(-17deg)';
							x3.title=toolTipText3;
						}
					}
					else
					{
						if(day3!='')
						{
							x3.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day3+"' onClick='funOnClick(this)'></div>";
							x3.style.transform='skew(-17deg)';
							x3.title=toolTipText3;
						}
					}				
					
					var x4=row.insertCell(4);
					x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day4+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day4))
						{
							x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
							x4.style.transform='skew(-17deg)';
							x4.title=toolTipText4;
						}
					}
					else
					{
						if(day4!='')
						{
							x4.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day4+"' onClick='funOnClick(this)'></div>";
							x4.style.transform='skew(-17deg)';
							x4.title=toolTipText4;
						}
					}				
					
					var x5=row.insertCell(5);
					x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day5+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day5))
						{
							x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width:font:size:0px; 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
							x5.style.transform='skew(-17deg)';
							x5.title=toolTipText5;
						}
					}
					else
					{
						if(day5!='')
						{
							x5.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day5+"' onClick='funOnClick(this)'></div>";
							x5.style.transform='skew(-17deg)';
							x5.title=toolTipText5;
						}
					}				
					
					
					var x6=row.insertCell(6);
					x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px; transform:skew(9deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
					if(day1!='')
					{
						if(!day1.includes(day6))
						{
							x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-size:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
							x6.style.transform='skew(-17deg)';
							x6.title=toolTipText6;
						}
					}
					else
					{
						if(day6!='')
						{
							x6.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day6+"' onClick='funOnClick(this)'></div>";
							x6.style.transform='skew(-17deg)';
							x6.title=toolTipText6;
						}						
					}				
					
					var x7=row.insertCell(7);
					x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px;margin-right: 3px;\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%; color:#fff;height: 20px; transform:skew(9deg); \" value='"+day7+"' onClick='funOnClick(this)' ></div>";
					if(day1!='')
					{
						if(!day1.includes(day7))
						{
							x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; margin-right: 3px;background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px;font-style:0px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";
		
							//x7.bgColor='#ffffff';
							x7.style.transform='skew(-17deg)';
							x7.title=toolTipText7;
						}
					}
					else
					{
						if(day7!='')
						{
							x7.innerHTML= "<div class=\"one\" style=\"margin:3px 0px; background:"+color+";\"><input readonly=\"readonly\" class=\"Box \"  style=\"margin-left:2px; width: 90%;color: white;height: 20px;transform:skew(14deg);\" value='"+day7+"' onClick='funOnClick(this)' ></div>";
	
							//x7.bgColor=color;
							x7.style.transform='skew(-17deg)';
							x7.title=toolTipText7;
						}			
					}
				   
				   }
				   
			   
			   
			   
			   
			   
		   }
		   function myFunction(x) {
			   //x.classList.toggle("change");
			   document.getElementById('reportsPopup').style.cssText = 'display: block';
			  
			 }
		   
		   function funOpenCheckInList()
		   {
			   /* transactionName="frmCheckInList";
				window.open("frmCheckInList.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
				window.close; */
			   document.getElementById('checkInListPopUp').style.cssText = 'display: block';
			   funOpenReservationData();
		   }
		   

		   function funOpenCheckOutList()
		   {
			   transactionName="frmCheckOutList";
				window.open("frmCheckOutList.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
				window.close;
		   } 
		   function funOpenExpArrivalList()
		   {
			   transactionName="frmExpectedArrivalList";
				window.open("frmExpectedArrivalList.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
				window.close;
		   }
		   function funOpenExpDepartureList()
		   {
			   transactionName="frmExpectedDepartureList";
				window.open("frmExpectedDepartureList.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
				window.close;
		   }function funOpenGuestList()
		   {
			   transactionName="frmGuestListReport";
				window.open("frmGuestListReport.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=200,height=200,left=400");
				
				
		   }
		   function funOpenRevenueHead()
		   {
			   transactionName="frmRevenueHeadReport";
				window.open("frmRevenueHeadReport.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=400,height=400,left=40");
				
				
		   }
		   function funOpenRoomInventory()
		   {
			   transactionName="frmRoomTypeInventoryReport";
				window.open("frmRoomTypeInventoryReport.html?formname="+transactionName+"&objData="+name,"","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=400,height=400,left=40");
				
				
		   }
		  
		   function funOpenReservationData()
		   {

			   var viewDate = $("#txtViewDate").val();
				var searchUrl=getContextPath()+ "/loadDataReservation.html?viewDate=" + viewDate;
				$.ajax({
					type :"GET",
					url : searchUrl,
					dataType : "json",
					async: false,
					success: function(response){
						
						$("#lblArrival").text(response[0]);
						$("#lblDeparture").text(response[1]);
						$("#lblRoomsOccupied").text(response[2]);
						//funFillBillTable(response[i].strFolioNo,response[i].strDocNo,response[i].strMenuHead,response[i].dblIncomeHeadPrice,response[i].strRevenueCode);
						funFillReservationTable();
						funFillActivityTable();
						
					},
					error : function(jqXHR, exception)
					{
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
		   
		   function funFillReservationTable()
		   {
			   var table = document.getElementById("tblReservationFlash");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);

			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" id=\"strName."+(rowCount)+"\" value='SUMEET B' />";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" id=\"strResNo."+(rowCount)+"\" value='RS000001' />";
			   	row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;width:100%\" id=\"strRoomNo."+(rowCount)+"\" value='A 101' />";
			    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;width:100%\ id=\"strStatus."+(rowCount)+"\" value='Confirmed' />";
			    row.insertCell(4).innerHTML= "<input id=\"cbToLocSel."+(rowCount)+"\" type=\"button\" name=\"billData\"  size=\"2%\" style=\"text-align: center;background: #b5b3b3;width:100%\" class=\"btn btn-primary center-block\"  value='Check-In' onClick='funOnClickCheckIn(this)' />";

		   }
		   function funFillActivityTable()
		   {
		
			   var table = document.getElementById("tblActivityFlash");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);

			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" id=\"strName."+(rowCount)+"\" value='SUMEET B' />";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" id=\"dblRevenue."+(rowCount)+"\" value='400' />";
			   	row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: left;width:100%\" id=\"strDate."+(rowCount)+"\" value='20-11-2020' />";
			    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align: right;;width:100%\ id=\"intNights."+(rowCount)+"\" value='3' />";

		   }
		   function funOnClickCheckIn(data)
		   {
			   	var code=data.defaultValue.split(",");
				  var subStr = code[1];
				  url=getContextPath()+"/frmCheckIn1.html?docCode="+subStr
				  window.open(url);

		   }
</script>


</head>
<body>
	<div class="container-fluid">
		<div class="title-row">
         	<div class="title"><label id="formHeading">Room Status Diary</label>&nbsp;&nbsp;
         	<label id="lblView"></label>
         	</div>
          		<div class="status-list ">
           			 <ul>
           			  	<li>
			              <div class="thumb waiting"></div>
			             <!--  <div class="thumb-title">Waiting</div> -->
			              <a href="#" onclick="funWaiting();">&nbsp;&nbsp;&nbsp;Waiting</a> 
			            </li>
			            <li>
			              <div class="thumb reservation"></div>
			           <!--    <div class="thumb-title">Reservation</div> -->
			           <a href="#" onclick="funReservation();">&nbsp;&nbsp;&nbsp;Reservation</a> 
			            </li>
			            <li>
			              <div class="thumb occupied"></div>
			          <!--     <div class="thumb-title">Occupied</div> -->
			             <a href="#" onclick="funOccupied();">&nbsp;&nbsp;&nbsp;Occupied</a> 
			            </li>
			            <li>
			              <div class="thumb checked"></div>
			             <!--  <div class="thumb-title">Checked Out</div> -->
			                <a href="#" onclick="funCheckedOut();">&nbsp;&nbsp;&nbsp;Checked Out</a> 
			            </li>
			            <li>
			              <div class="thumb blocked"></div>
			             <!--  <div class="thumb-title">Blocked</div> -->
			                <a href="#" onclick="funBlocked();">&nbsp;&nbsp;&nbsp;Blocked</a> 
			           	</li>
			            <li>
			              <div class="thumb dirty"></div>
			            <!--   <div class="thumb-title">Dirty</div> -->
			               <a href="#" onclick="funDirty();">&nbsp;&nbsp;&nbsp;Dirty</a> 
			            </li>
			            <li>
			              <div class="thumb groupReservation"></div>
			             <!--  <div class="thumb-title">Waiting</div> -->
			              <a href="#" onclick="funGroupReservation();">&nbsp;&nbsp;&nbsp;Group Reservation</a> 
			            </li>
			            
			            <li>
			              <div class="thumb virtualReservation"></div>
			              <a href="#" onclick="funVirtualReservation();">&nbsp;&nbsp;&nbsp;Virtual Reservation</a> 
			            </li>
			            
			          </ul>
			       </div>
			 </div>
		<s:form name="RoomStatusDiary" method="GET" action="frmRoomStatusDiary.html">
			<div class="app-calender"><!--  transTable -->
				<div class="day-wrap transTable"> 
		           <div class="date">
		             <span class="date-switch">
		             	 <s:input id="txtViewDate"  path="dteViewDate"  type="text" cssClass="calenderTextBox"/>
		              </span>		              
		              <div class="icon-action">
		                 	<span class="mdi mdi-file-word-box" id="btnView" title="Seven Day View" onclick="funShowRoomStatusFlash();" style="padding: 0px 18px; font-size: 23px; color: #9a9d9f;" ></span>
		              </div>
		              		              
		               <div class="icon-action">
		                 	<span class="mdi mdi-disqus-outline" id="btnView" title="One Day View" onclick="funShowRoomStatusFlashForOneDay();" style="padding: 0px 18px; font-size: 23px; color: #9a9d9f;" ></span>
		              </div> 		              
		               
		               <div class="icon-action">
		                 	<span class="mdi mdi-broom" id="btnView" title="House Keeping View" onclick="funShowRoomStatusFlashHouseKeeping();" style="padding: 0px 18px; font-size: 23px; color: #9a9d9f;" ></span>
		              </div>
		                              
		               
		            </div>
		            <div class="date-actions">
		              <div class="add-room">
		                <i class="mdi mdi-plus " onclick="funOpenRoomMaster()"></i><span>Add Room</span>
		              </div>
		             <%--  <div class="icon-action">
		                <span class="mdi mdi-magnify" onclick="hidePopup()"></span>
		              </div> --%>
		              
		             <%-- <c > <div class="col-md-2"  onclick="funOpenCheckInList(this)">
					  <div  class="bar1"></div>
					  <div class="bar2"></div>
					  <div class="bar3"></div>
					</div>
					</c> --%>
		            </div>
		        </div>
			</div>
			<table id="tblDays" class="transTable" >
				
			</table>
			<table id="tblRoomType" style="width:100%;" class="transTable"  >
		
			</table>
			<br>
			<table id="tblRoomInfo" class="transTable"> <!-- class="collapse show" --> 
			
			</table>
		
		<br />
		
		 <div class="popup-details" id="popover">
        <div class="popup-backdrop">
          <div class="popup-data">
            <div class="cust-info-wrap">
              <div class="cust-name-img">
                <div class="profile-image">
            <%-- <img src="../${pageContext.request.contextPath}/resources/images/user.jpg" alt="user"> 
             --%>    
                
      	
            <img id="memImage" src="" width="170px" height="150px" alt="Member Image" onclick="funChangeImage()">
               
		
		

                
                  <i class="mdi mdi-close close-icon" onclick="hidePopup()"></i>
                </div>
                <div class="display-name">
                  <div class="name" id="txtGuestName"></div>
                  <div class="room" id = "txtRoomNo"></div>
                </div>
                <div style="clear: both"></div>
              </div>
              <div class="info-tabs">
                <ul>
                  <li class="<!-- active -->"><a href="#">Checkout Details</a></li>
                  <li><a href="#">Customer Details</a></li>
                  <li><a href="#">Requests</a></li>
                </ul>
                <div class="checkout-tab-data">
                  <div class="checkout-grid">
                    <div class="grid-row">
                        <div class="grid-data">
                            <span class="mdi mdi-calendar picon"></span>
                            <div class="data-info">
                              <div class="attr">Check in Date </div>
                              <div class="value" id="txtCheckInDate"></div>
                            </div>
                        </div>
                        <div class="grid-data">
                          <span class="mdi mdi-calendar-outline picon"></span>
                          <div class="data-info">
                            <div class="attr">Check out Date </div>
                            <div class="value" id = "txtCheckOutDate"></div>
                          </div>
                      </div>
                    </div>
                    <div class="grid-row">
                      <div class="grid-data">
                        <span class="mdi mdi-file-document-edit-outline picon"></span>
                        <div class="data-info">
                          <div class="attr">Registration Number </div>
                          <div class="value" id="txtNumber"></div>
                        </div>
                      </div>
                      <div class="grid-data">
                        <span class="mdi mdi-file-document-box-outline picon"></span>
                        <div class="data-info">
                          <div class="attr">Folio Number </div>
                          <div class="value" id = "txtFolioNo"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="billing-wrap">
                    <div class="heading">
                      <div class="title">Receipt</div>
                      <div class="action"><i class="mdi mdi-printer"></i> Receipt</div>
                    </div>
                    <div class="billing-details">
                      <div class="distribution">
                        <div class="bill-row">
                          <div class="label">Basic Cost per night</div>
                          <div class="cost" id="txtOneDayTariff"></div>
                        </div>
                        <div class="bill-row">
                          <div class="label">No.Of Nights</div>
                          <div class="cost" id="txtNoOfNights"></div>
                        </div>
                        <div class="bill-row">
                          <div class="label">Tax Amt</div>
                          <div class="cost" id="txtTaxAmt"></div>
                        </div>
                        <div class="bill-row">
                          <div class="label" >Cleaning Fee</div>
                          <!-- <div class="cost"id="txtCleaningFee"></div> -->
                           &nbsp;&nbsp;<div class="cost" style="width:20%;"><input type="text" id= "txtCleaningFee" value="0" style="color:#4A4A4A;text-align:right; font-size:16px;" onchange="funUpdateTotal()"/></div>
                        </div>
                        <div class="bill-row">
                          <div class="label">Extra Bed Charges</div>
                          <!-- <div class="cost">
                          <input type="text" id="txtHighSeasonFee" value="0" style="color:#4A4A4A;width:20%;text-align:right; font-size:16px;"/>
                          </div> -->
                          <!-- <div class="cost" style="width:20%;"><input type="text" id= "txtExtraBedCharges" readonly="readonly" value="0" style="color:#4A4A4A;text-align:right; font-size:16px;"onchange="funUpdateTotal()"/></div> -->
                          <div class="label" id="txtExtraBedCharges"></div>
                        </div>
     <!--                    <div class="cost" style="width:20%;"><input type="text" value="Rs.870" style="color:#4A4A4A; font-size:16px;"/></div> -->
                        
                      </div>
                      <div class="bill-total">
                        <div class="label">Total</div>
                        <div class="cost" id = "txtTotal"></div>
                      </div>
                      <div class="cnfm-action">
                        <button id="btnConfirm" onclick="return funConfirmClicked()">Confirm Checkout</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="popup-details" id="reportsPopup" style="position: relative">
          <div class="popup-data" style="width: 5%;background:#f2f2f2;min-width: fit-content;top: 90px;position:relative;left:1050px;">
           <div>
           
           <div>
			<label style="font-size:20px;padding-left: 10px;">Quick View</label>
			<i class="mdi mdi-close close-icon" onclick="hidePopupreport()" style="font-size:15px;"></i>
           </div>
           <br />
                <div>
                <a href="#"  onclick="funOpenCheckInList();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Check In List</a> 
                
                </div>
                <div>
                <a href="#" onclick="funOpenCheckOutList();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Check Out List</a> 
                
                </div>
                
                 <div>
                <a href="#" onclick="funOpenExpArrivalList();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Expected Arival List</a> 
                
                </div>
                
                 <div>
                <a href="#" onclick="funOpenExpDepartureList();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Expected Departure List</a> 
                
                </div>
                
                <div>
                <a href="#" onclick="funOpenGuestList();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Guest List</a> 
                
                </div>
                 <div>
                <a href="#" onclick="funOpenRevenueHead();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Revenue Head Report</a> 
                
                </div>
                 <div>
                <a href="#" onclick="funOpenRoomInventory();" style="font-size:13px;">&nbsp;&nbsp;&nbsp;Room Type Inventory</a> 
                
                </div>
           </div>
                
                    </div>
      </div>
      <!--Check in list popup  -->
       <div class="popup-details" id="checkInListPopUp" style="position: relative">
          <div class="popup-data" style="width: 75%;background:white;top: 45px;position:relative;left:150px;">
           <div>
           
           <div>
			<label id="lblPMSDate" style="font-size:20px;padding-left: 20px;"></label>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" style = "background: #b5b3b3;width: fit-content;" value="New Reservation" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()">
			</input>
			
			<div class="row" style="margin-left: 16px">
			
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
			<label id="lblArrival" style="padding-left: 10px;color: red;">
				</label><br />
				<label style="padding-left: 10px;">Arrival</label>
			
			</div>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
				<label id="lblDeparture" style="padding-left: 10px;color: green;">
				</label><br />
				<label style="padding-left: 10px;">Departure</label>
			
			</div>
			
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
				<label id="lblRoomsOccupied" style="padding-left: 10px;color: blue;">
				</label><br />
				<label style="padding-left: 10px;">Rooms Occupied</label>
			
			</div>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
				<label id="lblBookedToday" style="padding-left: 10px;color: orange;">3
				</label><br />
				<label style="padding-left: 10px;">Booked Today</label>
			
			</div>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
				<label id="lblRoomNights" style="padding-left: 10px;color: cyan;">1
				</label><br />
				<label style="padding-left: 10px;">Room Nights</label>
			
			</div>
			
			&nbsp;&nbsp;&nbsp;&nbsp;
			<div class="col-md-1.5" style="border: ridge;width: 120px;">
				<label id="lblRevenue" style="padding-left: 10px;color: gray;">2
				</label><br />
				<label style="padding-left: 10px;">Revenue</label>
			
			</div>
			
			<div>
<!-- 			<i class="mdi mdi-close close-icon"  onclick="hidePopupCheckIn()" style="font-size:15px;padding-left:800px;"></i>
 -->			
			</div>
						</div>
			
			
			           </div><br />
          <div class=" row transTable" style="width:100%;">
           <div class="col-md-6">
           <label style="width: 100%;background: #646777;color: white;padding-top: 0px;">Reservation</label>
           
           
           <div id="tab_container">
					<ul class="tabs">
						<li data-state="tab1">Arrival</li>
						<li data-state="tab2">Departure</li>
						<li data-state="tab3">Stay Over</li>
						<li data-state="tab4">In House Guest</li>
					</ul>
					<div id="tab1" class="tab_content">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:13%;">Name</td>
						<td style="width:5%;">Reservation No.</td>
						<td style="width:3%;">Room</td>
						<td style="width:4%;">Status</td>
						<td style="width:5%;">Check-In</td> 
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblReservationFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
						<col style="width: 5%;"> 
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			
			<div id="tab2" class="tab_content">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:13%;">Name</td>
						<td style="width:5%;">Reservation No.</td>
						<td style="width:3%;">Room</td>
						<td style="width:4%;">Status</td>
						<td style="width:5%;">Check-In</td> 
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblDepartureFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
						<col style="width: 5%;"> 
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			<div id="tab3" class="tab_content">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:13%;">Name</td>
						<td style="width:5%;">Reservation No.</td>
						<td style="width:3%;">Room</td>
						<td style="width:4%;">Status</td>
						<td style="width:5%;">Check-In</td> 
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblStayOverFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
						<col style="width: 5%;"> 
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			<div id="tab4" class="tab_content">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:13%;">Name</td>
						<td style="width:5%;">Reservation No.</td>
						<td style="width:3%;">Room</td>
						<td style="width:4%;">Status</td>
						<td style="width:5%;">Check-In</td> 
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblSInHouseFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
						<col style="width: 5%;"> 
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			
			</div>
			
				
				
		
		</div>
		
		<!-- Activity -->
		
		<div class="col-md-6">
           <label style="width: 100%;background: #646777;color: white;padding-top: 0px;">Todays Activity</label>
          <div id="tab_container">
					<ul class="tabs">
						<li data-state1="tab11">Sales</li>
						<li data-state1="tab22">Cancellation</li>
						<li data-state1="tab33">Overbooking</li>
					</ul>
					<div id="tab11" class="tab_content1">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:11%;">Name</td>
						<td style="width:5%;">Revenue</td>
						<td style="width:3%;">Check-In</td>
						<td style="width:4%;">Nights</td>
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblActivityFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			<div id="tab22" class="tab_content1">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:11%;">Name</td>
						<td style="width:5%;">Revenue</td>
						<td style="width:3%;">Check-In</td>
						<td style="width:4%;">Nights</td>
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblCancellationFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			<div id="tab33" class="tab_content1">
           <div class="dynamicTableContainer" style="width:100%;height: 240px;margin-top:10px;">
				<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
					<tr bgcolor="#c0c0c0">
					
						<td style="width:11%;">Name</td>
						<td style="width:5%;">Revenue</td>
						<td style="width:3%;">Check-In</td>
						<td style="width:4%;">Nights</td>
				</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
				<table id="tblOverbookingFlash"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 8%;">
						<col style="width: 5%;">
						<col style="width: 3%;">
						<col style="width: 4%;">
					</tbody>
				</table>
			</div>
			</div>
			</div>
			
			
			</div>
				
				
		
		</div>
		<div style="width: 100%;">
           <label style="width: 97%;background: #646777;color: white;padding-top: 0px;padding-left: 10px;margin-left: 15px;">14 Days Outlook</label>
                 <div id="chartContainer" style="height: 150px; width: 100%; margin: 0px;"></div>
		
		
		</div>
				 
		</div>
           
                
                
           </div>
                
                    </div>
      </div>
      
      
<!-- ////////////////////////////////////////////////////////////////////////////////////////////////// -->
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
	</div>
</body>
</html>
