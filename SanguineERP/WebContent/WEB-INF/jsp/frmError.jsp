<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

  <head>
  <style type="text/css">
  
  .img {
  max-width: 100%;
  /* Make sure images are scaled correctly. */
  height: auto;
  /* Adhere to container width. */
  vertical-align: top;
}
  .error404 .content-wrapper {
  height: 100%;
  display: table;
  width: 100%;
  text-align: center;
}

.error404 .branding__logo a {
  float: none;
}

.error404--header {
  position: absolute;
  right: 0;
  left: 0;
  top: 0;
  padding: 30px 0;
}

.admin-bar .error404--header {
  top: 32px;
}

.error404--content-wrap {
  padding: 50px 0;
  display: table-cell;
  vertical-align: middle;
}

.error404--title {
  font-size: 56px;
  line-height: 1.28;
  margin: 20px 0 38px;
}
  </style>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks fgfg</title>
     <script type="text/javascript">
     
    
     function goBack() {
       window.history.back();
     }
    
 /*    $(document).ready(function(){
    	var s=getContextPath()+"/resources/images/";
    	
    	
    	$("#Desktop").attr('src', s+'Desktop.png');
    	$("#Desktop").attr('title','Desktop');
	}); */
    
    </script> 

   
  </head>
  
	<body>
	
	

   	
		
		
	<div class="content-wrapper" style="min-height: 419px;">
	<div class="error404--header">
		<%-- <div class="branding__logo">
						<!-- <a href="http://www.maximojo.com/" rel="home"> -->
				<img src="../${pageContext.request.contextPath}/resources/images/Sanguine_ERP.jpg" alt="">
			</a> 
		</div> --%>
	</div>
	<div  style="padding-left: 18%;padding-top:12%"  class="error404--content-wrap">
		<div class="error404--content">
			<img src="../${pageContext.request.contextPath}/resources/images/oops.png" alt="img" > <!-- alt="404 Image" -->
			
			
			<%-- <span class="navaction app-header-main" onclick="goBack()"></span> --%>
			
				<%-- <a href="" class="tm-button style-outline tm-button-grey  has-icon icon-left">
					<span class="button-icon ion-home"></span>
					<span class="button-text">Go back to homepage</span>
				</a> --%>
		
		</div>
	</div>
</div><!-- /.content-wrapper -->
</div>
	</body>
</html>