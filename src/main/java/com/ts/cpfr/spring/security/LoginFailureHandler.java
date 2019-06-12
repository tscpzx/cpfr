package com.ts.cpfr.spring.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * 登录验证出错处理
 */
public class LoginFailureHandler implements AuthenticationFailureHandler {
	private static Logger logger = LoggerFactory.getLogger(LoginFailureHandler.class);
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	private String defaultFailureUrl;
	
	public void setDefaultFailureUrl(String defaultFailureUrl) {
		this.defaultFailureUrl = defaultFailureUrl;
	}
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException ae) throws IOException, ServletException {
		ae.printStackTrace();
		System.out.println(ae.getMessage());
		if (defaultFailureUrl == null) {
	         response.sendError(HttpServletResponse.SC_UNAUTHORIZED,"Authentication Failed:"+ae.getMessage());
     	} else {
	         saveException(request, ae);
	         redirectStrategy.sendRedirect(request, response, defaultFailureUrl);
     	}
	}
	
	protected final void saveException(HttpServletRequest request, AuthenticationException exception) {
//	     HttpSession session = request.getSession(false);
//	     if (session != null) {
//	    	 request.getSession().setAttribute(CommConst.AUTHENTICATION_EXCEPTION, exception);
//	     }
	 }
}