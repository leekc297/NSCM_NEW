package com.lgcns.nscm.admin.user;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.security.CustomUserDetailsService;
import com.lgcns.nscm.framework.security.SsoService;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * SSO 진입점. SSO 포탈 인증 사용자를 Spring Security 세션으로 로그인 처리 후 FE로 redirect.
 * 플로우: SSO ID 조회 → 쿠키 검증 → 사용자 조회 → SecurityContext 세션 저장 → FE redirect
 */
@Slf4j
@Controller
@Tag(name = "0. SSO")
@RequiredArgsConstructor
public class SsoController {

    /** 사용자 조회 실패(쿠키검증 통과 후 DB 오류 등) 에러코드. 미등록 사용자는 게스트로 로그인되므로 여기 해당하지 않는다. */
    static final int ERROR_CODE_USER_NOT_FOUND = 999;

    private final SsoService ssoService;
    private final CustomUserDetailsService userDetailsService;
    private final SecurityContextRepository securityContextRepository;
    private final CommonProperties properties;

    /** SSO Agent 표준 진입 URL (config.sso.ascp-url-suffix와 일치해야 함) */
    @GetMapping("/sso/login_exec")
    public void loginExec(HttpServletRequest request, HttpServletResponse response) throws IOException {

        // 1. Nexess 쿠키에서 SSO ID 조회 — 없으면 SSO 로그인 페이지로
        String ssoId = ssoService.getSsoId(request);
        if (ssoId == null || ssoId.isEmpty()) {
            ssoService.goLoginPage(response);
            return;
        }

        // 2. 쿠키 유효성 검증 — 실패 시 SSO 에러 페이지로
        String retCode = ssoService.verifySession(request, response);
        if (!SsoService.RET_CODE_SUCCESS.equals(retCode)) {
            log.warn("SSO 쿠키 검증 실패. ssoId={}, retCode={}", ssoId, retCode);
            ssoService.goErrorPage(response, parseRetCode(retCode));
            return;
        }

        // 3. NSCM 사용자 조회 — 미등록자는 loadUserByUsername이 게스트로 폴백 로그인시킴.
        //    여기 예외는 조회 실패(DB 오류 등)만 해당한다.
        UserDetails userDetails;
        try {
            userDetails = userDetailsService.loadUserByUsername(ssoId);
        } catch (UsernameNotFoundException e) {
            log.warn("SSO 사용자 조회 실패. ssoId={}", ssoId);
            ssoService.goErrorPage(response, ERROR_CODE_USER_NOT_FOUND);
            return;
        }

        // 4. Spring Security 인증 컨텍스트를 세션에 저장 (/user/login과 동일한 세션 상태)
        Authentication authentication =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
        securityContextRepository.saveContext(context, request, response);

        log.info("SSO 로그인 성공. userId={}", ssoId);

        // 5. FE로 이동
        response.sendRedirect(properties.getDomain().getFe());
    }

    private int parseRetCode(String retCode) {
        try {
            return Integer.parseInt(retCode);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
