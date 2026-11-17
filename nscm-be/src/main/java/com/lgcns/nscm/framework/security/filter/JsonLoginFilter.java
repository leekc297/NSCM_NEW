package com.lgcns.nscm.framework.security.filter;

import java.io.IOException;
import java.util.Map;

import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JsonLoginFilter extends UsernamePasswordAuthenticationFilter {

    private final ObjectMapper objectMapper = new ObjectMapper();

    // true 면 ID 로그인을 받지 않는다(운영은 SSO 로만 로그인, config.security.id-login-disabled).
    private final boolean idLoginDisabled;

    public JsonLoginFilter(boolean idLoginDisabled) {
        this.idLoginDisabled = idLoginDisabled;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException {

        if (idLoginDisabled) {
            log.warn("ID 로그인 차단(SSO 전용). remoteAddr={}", request.getRemoteAddr());
            throw new AuthenticationServiceException("ID login is disabled");
        }

        if (!request.getContentType().equals("application/json")) {
            throw new AuthenticationServiceException("Authentication content-type not supported: " + request.getContentType());
        }

        try {
            Map<String, String> loginData = objectMapper.readValue(request.getInputStream(), Map.class);
            String userId = loginData.get("userId");

            UsernamePasswordAuthenticationToken authRequest =
                new UsernamePasswordAuthenticationToken(userId, "");

            return this.getAuthenticationManager().authenticate(authRequest);

        } catch (IOException e) {
            throw new AuthenticationServiceException("Failed to parse login request body", e);
        }
    }
}
