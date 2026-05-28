package com.lgcns.nscm.framework.security.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.AUTHORIZATION_ERROR;
import static com.lgcns.nscm.framework.base.BaseConstants.AUTHORIZATION_ERROR_MSG;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AccessDeniedExceptionHandler implements AccessDeniedHandler {

	// Spring Security 인가(Authorization) 오류 처리 로직
	@Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException {

    	response.setStatus(HttpStatus.FORBIDDEN.value());
        response.setContentType("application/json;charset=utf-8");

        Map<String, Object> errorBody = new HashMap<>();
        errorBody.put("code", AUTHORIZATION_ERROR);
        errorBody.put("message", AUTHORIZATION_ERROR_MSG);
        errorBody.put("result", null);

        new ObjectMapper().writeValue(response.getWriter(), errorBody);
    }
}
