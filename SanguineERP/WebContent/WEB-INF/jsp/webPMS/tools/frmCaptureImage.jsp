<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

	<style>
		#my_camera{
		 width: 320px;
		 height: 240px;
		 border: 1px solid #000;
		 margin: auto;
		 }
		 
		
		
	</style>
	<script type="text/javascript" src="<spring:url value="/resources/js/webcam.js"/>"></script>
	
</head>
<body style="background-color:#d8d8d894;">
<div class="container" style="text-align:center;margin-top: 10%;">
	<div id="my_camera"></div>
		<!--  <input type=button value="Configure" onClick="configure()"> -->
	<div style="margin-top:20px;">
	 	<input type=button value="Take Snapshot" class="btn btn-primary center-block" onClick="take_snapshot()"> &nbsp;
	 	<input type=button value="Save Snapshot" class="btn btn-primary center-block"  onClick="saveSnap()">

	 	<div id="results" ></div>
	 </div>
</div> 
	 <script language="JavaScript">
 
	 // Configure a few settings and attach camera

	  Webcam.set({
	   width: 320,
	   height: 240,
	   image_format: 'jpeg',
	   jpeg_quality: 90
	  });
	  Webcam.attach( '#my_camera' );

	 // A button for taking snaps
	
	
	 // preload shutter audio clip
	 var shutter = new Audio();
	 shutter.autoplay = false;
	 shutter.src = navigator.userAgent.match(/Firefox/) ? 'shutter.ogg' : 'shutter.mp3';
	
	 function take_snapshot() {
	  Webcam.snap( function(data_uri) {
	  // display results in page
	  document.getElementById('results').innerHTML = 
	   '<img id="imageprev" src="'+data_uri+'"/>';
	 
	/*  Webcam.upload( data_uri, 'upload.php', function(code, text) {
	  console.log('Save successfully');
	  //console.log(text);
	 });  */
	  
	  } );
	
	
	 }
	
	function saveSnap(){
	 // Get base64 value from <img id='imageprev'> source
	 
	 if(document.getElementById("imageprev")!=null){
	 var base64image = document.getElementById("imageprev").src;
	 var url = "/loadImageForGuestMaster";
	 
		 var image = $('#imageprev').attr('src');
		 var base64ImageContent = image.replace(/^data:image\/(png|jpg|jpeg);base64,/, "");
		 var blob = base64ToBlob(base64ImageContent, 'image/png/jpeg');                
		 var formData = new FormData();
		 formData.append('file', blob);
			
			$.ajax({
				type : "POST",
				url : getContextPath()+ "/loadImageForGuestMaster.html",
				data: formData,
				mimeType: "multipart/form-data",
	            contentType: false,
	            cache: false,
	            processData: false,
				    
				success : function(response)
				{
					window.close();
							
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
	 else
		 {
		 
		 var jForm = new FormData();    
		    jForm.append("file", $('#File').get(0).files[0]);
		 //  searchUrl=getContextPath()+"/ChangeGuestImage.html?formname="+transactionformName+"&prodStock="+prodStock;
			searchUrl=getContextPath()+"/ChangeGuestImage.html?";				
	        $.ajax({
	           // url : $("#uploadExcel").attr('action'),
	            url : searchUrl,
	            type: "POST",
             data: jForm,
             mimeType: "multipart/form-data",
             contentType: false,
             cache: false,
             processData: false,
             dataType: "json",
	            success : function(response) 
	            {
	            	if(response[0]=="Invalid Excel File")
	            		{
	            			alert(response[1]);
	            		}
	            	else
	            		{
							window.returnValue = response;
							window.close();
							
	            		}
	            },
	            error: function(jqXHR, exception)
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
	
	
	
	}
	
	function base64ToBlob(base64, mime) 
	{
	    mime = mime || '';
	    var sliceSize = 1024;
	    var byteChars = window.atob(base64);
	    var byteArrays = [];

	    for (var offset = 0, len = byteChars.length; offset < len; offset += sliceSize) {
	        var slice = byteChars.slice(offset, offset + sliceSize);

	        var byteNumbers = new Array(slice.length);
	        for (var i = 0; i < slice.length; i++) {
	            byteNumbers[i] = slice.charCodeAt(i);
	        }

	        var byteArray = new Uint8Array(byteNumbers);

	        byteArrays.push(byteArray);
	    }

	    return new Blob(byteArrays, {type: mime});
	}
	
	</script>

<input type="file" id="File"  Width="50%"  accept="image/gif,image/png,image/jpeg"  onchange="funShowImagePreview(this);"></input>   
		    		<br>
<img id='imgData' hidden="hidden" style="height:100px; width:100px;">
</body>
</html>
 
 
