package com.lgcns.nscm.framework.security.handler;

import static com.lgcns.nscm.framework.base.BaseConstants.SUCCESS;
import static com.lgcns.nscm.framework.base.BaseConstants.SUCCESS_MSG;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.admin.menu.MenuService;
import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.annotation.SystemLog.LogType;
import com.lgcns.nscm.framework.security.CustomUserDetails;
import com.lgcns.nscm.framework.utils.SecurityUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    @SystemLog(LogType.LOGIN)
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        response.setStatus(HttpStatus.OK.value());
        response.setContentType("application/json;charset=UTF-8");

        Map<String, Object> body = new HashMap<>();
        body.put("code", SUCCESS);
        body.put("message", SUCCESS_MSG);
        body.put("result", SecurityUtil.getUserSession(authentication));

        objectMapper.writeValue(response.getWriter(), body);
    }
}
