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
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url  value="/resources/css/styles/styles.css"/> "/>
<title><tiles:insertAttribute name="title" ignore="true"></tiles:insertAttribute>
</title>
</head>
<body>
	<main class="app-page">
		<div class="app-sidebar">
        <ul class="side-menu">
          <li class="active-tab">
            <a href="#" class="link">
              <i class="mdi mdi-source-fork rotate"></i>
              <div class="link-text">MASTERS</div>
            </a>
            <div class="submenu">
              <a href="#">Checkout Discount Master</a>
              <a href="#">Room Master</a>
              <a href="#">Income Head Master</a>
              <a href="#">Attribute Value Master</a>
            </div>
          </li>
          <li>
            <a href="#" class="link">
              <i class="mdi mdi-wrench-outline"></i>
              <div class="link-text">TOOLS</div>
            </a>
          </li>
          <li>
            <a href="#" class="link">
              <i class="mdi mdi-file-chart-outline"></i>
              <div class="link-text">REPORTS</div>
            </a>
          </li>
          <li>
            <a href="#" class="link">
              <i class="mdi mdi-credit-card-outline"></i>
              <div class="link-text">TRANSACTION</div>
            </a>
          </li>
        </ul>
      </div>
	 </main>
</body>
</html>
 