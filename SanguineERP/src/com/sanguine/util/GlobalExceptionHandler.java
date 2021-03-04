package com.sanguine.util;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

@ControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(SQLException.class)
	public String handleSQLException(HttpServletRequest request, Exception ex){
		//logger.info("SQLException Occured:: URL="+request.getRequestURL());
		ex.printStackTrace();
		return "error";
	}
	
	@ResponseStatus(value=HttpStatus.NOT_FOUND, reason="IOException occured")
	@ExceptionHandler(IOException.class)
	public void handleIOException(){
		System.out.println("page not found");

		//logger.error("IOException handler executed");
		//returning 404 error code
	}
	
	@ExceptionHandler(Exception.class)
	public String handleSQLException1(HttpServletRequest request, Exception ex){
		//logger.info("Exception Occured vv:: URL="+request.getRequestURL());
		ex.printStackTrace();
		return "error";
	}
}
