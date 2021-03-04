<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="ie=edge" />
<script src="less.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url  value="/resources/css/styles/styles.css"/> "/>
<title><tiles:insertAttribute name="title" ignore="true"></tiles:insertAttribute>
</title>
</head>
<body>
	<header class="app-header">
      <nav class="app-nav">
        <div class="left-menu">
          <div class="navaction app-header-main">
            <a href="#">Web PMS</a>
          </div>
          <div class="navaction app-header-sub">
            <div>HOTEL SURYA</div>
          </div>
        </div>
        <div class="right-menu">
          <ul>
            <li><a href="#" class="mdi mdi-information-outline menu-link"></a></li>
            <li><a href="#" class="mdi mdi-crosshairs-question menu-link"></a></li>
            <li><a href="#" class="mdi mdi-home-outline menu-link"></a></li>
            <li><a href="#" class="mdi mdi-web menu-link"></a></li>
            <li><a href="#" class="mdi mdi-bank-outline menu-link"></a></li>
            <li><a href="#" class="mdi mdi-power-standby menu-link"></a></li>

          </ul>
        </div>
      </nav>
    </header>
</body>
</html>
