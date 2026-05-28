package com.lgcns.nscm.framework.security.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.SUCCESS;
import static com.lgcns.nscm.framework.base.BaseConstants.SUCCESS_MSG;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.annotation.SystemLog.LogType;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class LogoutResponseHandler implements LogoutSuccessHandler {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @SystemLog(LogType.LOGOUT)
    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,
                                Authentication authentication) throws IOException {

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> body = new HashMap<>();
        body.put("code", SUCCESS);
        body.put("message", SUCCESS_MSG);
        body.put("result", null);

        objectMapper.writeValue(response.getWriter(), body);
    }
}
