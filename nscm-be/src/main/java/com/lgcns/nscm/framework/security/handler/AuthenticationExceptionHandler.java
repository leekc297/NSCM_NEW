package com.lgcns.nscm.framework.security.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.AUTHENTICATION_ERROR;
import static com.lgcns.nscm.framework.base.BaseConstants.AUTHENTICATION_ERROR_MSG;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AuthenticationExceptionHandler implements AuthenticationEntryPoint {

	// Spring Security 인증(Authentication) 오류 처리 로직
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException {

    	response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.setContentType("application/json;charset=utf-8");

        Map<String, Object> errorBody = new HashMap<>();
        errorBody.put("code", AUTHENTICATION_ERROR);
        errorBody.put("message", AUTHENTICATION_ERROR_MSG);
        errorBody.put("result", null);

        new ObjectMapper().writeValue(response.getWriter(), errorBody);
    }
}
