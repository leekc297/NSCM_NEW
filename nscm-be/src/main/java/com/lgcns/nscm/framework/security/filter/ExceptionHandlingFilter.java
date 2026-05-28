package com.lgcns.nscm.framework.security.filter;

import static com.lgcns.nscm.framework.base.BaseConstants.SERVER_ERROR;
import static com.lgcns.nscm.framework.base.BaseConstants.SERVER_ERROR_MSG;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ExceptionHandlingFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        try {
            filterChain.doFilter(request, response);

        } catch (Exception e) {
	        if (e instanceof AccessDeniedException ||
	            e instanceof AuthenticationException) {
	            throw e;
	        }

			response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
			response.setContentType("application/json;charset=utf-8");

			Map<String, Object> errorBody = new HashMap<>();
			errorBody.put("code", SERVER_ERROR);
			errorBody.put("message", SERVER_ERROR_MSG);
			errorBody.put("result", null);

			new ObjectMapper().writeValue(response.getWriter(), errorBody);
        }
    }
}
