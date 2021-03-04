package com.sanguine.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class clsRequestInterceptor extends HandlerInterceptorAdapter {
	
	

	private static final Logger logger = LoggerFactory
			.getLogger(clsRequestInterceptor.class);

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		//long startTime = System.currentTimeMillis();
		logger.info("Request URL::" + request.getRequestURL().toString()
				+ ":: Start Time=" + System.currentTimeMillis());
		//request.setAttribute("startTime", startTime);
		//if returned false, we need to make sure 'response' is sent
		
		String prjName = request.getContextPath().toString();
		prjName = prjName.concat("/");
		if (!request.getRequestURI().equals(prjName) && !request.getRequestURI().equals(prjName + "index.html") && !request.getRequestURI().equals(prjName + "validateUser.html") && !request.getRequestURI().equals(prjName + "validateClient.html") && !request.getRequestURI().equals(prjName + "logout.html") && !request.getRequestURI().equals(prjName + "updateStructure.html")) {

			if (null == request.getSession().getAttribute("usercode")) {
				response.sendRedirect(prjName);
				return false;
			}

		}
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		/*
		 * System.out.println("Request URL::" + request.getRequestURL().toString() +
		 * " Sent to Handler :: Current Time=" + System.currentTimeMillis());
		 */
		//we can add attributes in the modelAndView and use that in the view page
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		if(ex!=null) {
			 ex.printStackTrace();
			System.out.println("error handler :");
		}
		/*
		 * long startTime = (Long) request.getAttribute("startTime");
		 * logger.info("Request URL::" + request.getRequestURL().toString() +
		 * ":: End Time=" + System.currentTimeMillis()); logger.info("Request URL::" +
		 * request.getRequestURL().toString() + ":: Time Taken=" +
		 * (System.currentTimeMillis() - startTime));
		 */
	}

	
}



/*implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		 * System.out.println("request.getRequestURL()="+request.getRequestURL())
		 * ;
		 * System.out.println("request.getContextPath()="+request.getContextPath
		 * ());
		 * System.out.println("request.getRequestURI()="+request.getRequestURI
		 * ());
		 
		String prjName = request.getContextPath().toString();
		prjName = prjName.concat("/");
		if (!request.getRequestURI().equals(prjName) && !request.getRequestURI().equals(prjName + "index.html") && !request.getRequestURI().equals(prjName + "validateUser.html") && !request.getRequestURI().equals(prjName + "validateClient.html") && !request.getRequestURI().equals(prjName + "logout.html") && !request.getRequestURI().equals(prjName + "updateStructure.html")) {

			if (null == request.getSession().getAttribute("usercode")) {
				response.sendRedirect(prjName);
				return false;
			}

		}
		return true;

	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		// TODO Auto-generated method stub

	}*/

//}
