package com.sanguine.util;

import java.text.MessageFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class clsErrorController {

	
	@RequestMapping(value="/error", method = RequestMethod.GET) 
	 public ModelAndView customError(HttpServletRequest request, HttpServletResponse response, Model model) {
	  // retrieve some useful information from the request
	  Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
	  Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
	  // String servletName = (String) request.getAttribute("javax.servlet.error.servlet_name");
	  String exceptionMessage = getExceptionMessage(throwable, statusCode);
	  
	  
	  String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
	  if (requestUri == null) {
	   requestUri = "Unknown";
	  }
	  
	  String message = MessageFormat.format("{0} returned for {1} with message {3}", 
	   statusCode, requestUri, exceptionMessage
	  ); 
	  
	  
	  model.addAttribute("errorMessage", message);
	  ModelAndView errorPage = new ModelAndView("error");
	  return errorPage;
	 }

	 private String getExceptionMessage(Throwable throwable, Integer statusCode) {
	  if (throwable != null) {
	   return throwable.getMessage();//RootCause(throwable).getMessage();
	  }
	  HttpStatus httpStatus = HttpStatus.valueOf(statusCode);
	  return httpStatus.getReasonPhrase();
	 }
	
	 
	/*
	 * @RequestMapping(value ="/errors",method = RequestMethod.GET) public
	 * ModelAndView funOpenForm(@ModelAttribute("command") clsPropBean bean,
	 * BindingResult result, HttpServletRequest request) { Map<String, Object> model
	 * = new HashMap<String, Object>();
	 * 
	 * 
	 * return new ModelAndView("/error",model); }
	 */
	/*
	 * @RequestMapping(value = "/errors", method = RequestMethod.GET) public
	 * ModelAndView renderErrorPage(HttpServletRequest httpRequest) {
	 * 
	 * ModelAndView errorPage = new ModelAndView("error"); String errorMsg = ""; int
	 * httpErrorCode = getErrorCode(httpRequest);
	 * 
	 * switch (httpErrorCode) { case 400: { errorMsg =
	 * "Http Error Code: 400. Bad Request"; break; } case 401: { errorMsg =
	 * "Http Error Code: 401. Unauthorized"; break; } case 404: { errorMsg =
	 * "Http Error Code: 404. Resource not found"; break; } case 500: { errorMsg =
	 * "Http Error Code: 500. Internal Server Error"; break; } }
	 * errorPage.addObject("errorMsg", errorMsg); return errorPage; }
	 * 
	 * private int getErrorCode(HttpServletRequest httpRequest) { return (Integer)
	 * httpRequest .getAttribute("javax.servlet.error.status_code"); }
	 */
}
