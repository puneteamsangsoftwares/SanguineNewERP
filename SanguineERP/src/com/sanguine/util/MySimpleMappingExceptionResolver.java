package com.sanguine.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

public class MySimpleMappingExceptionResolver extends
SimpleMappingExceptionResolver {

@Override
public String buildLogMessage(Exception ex, HttpServletRequest request) {
	  int abc=10;
	  
      return "Spring MVC exception: " + ex.getLocalizedMessage();
	}	
}