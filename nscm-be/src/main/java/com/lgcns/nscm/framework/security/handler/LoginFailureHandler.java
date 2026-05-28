package com.lgcns.nscm.framework.security.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.AUTHENTICATION_ERROR;
import static com.lgcns.nscm.framework.base.BaseConstants.AUTHENTICATION_ERROR_MSG;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class LoginFailureHandler implements AuthenticationFailureHandler {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException {

        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> body = new HashMap<>();
        body.put("code", AUTHENTICATION_ERROR);
        body.put("message", AUTHENTICATION_ERROR_MSG);
        body.put("data", null);

        objectMapper.writeValue(response.getWriter(), body);
    }
}
