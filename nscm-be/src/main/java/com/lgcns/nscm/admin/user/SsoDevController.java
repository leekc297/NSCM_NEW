package com.lgcns.nscm.admin.user;

import java.io.IOException;

import org.springframework.context.annotation.Profile;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.security.CustomUserDetailsService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * [DEV ONLY] SSO 쿠키 검증을 건너뛰고 id 만으로 로그인 세션을 만들어 FE로 redirect 하는 테스트용 진입점.
 * SsoController.loginExec 의 4~5단계(SecurityContext 세션 저장 → FE redirect)와 동일하며,
 * Nexess 쿠키 조회/검증(1~2단계)만 생략한다. loadUserByUsername 을 그대로 태우므로
 * Case 1/2(자동등록) / Case 3(게스트 폴백)도 실제와 동일하게 동작한다.
 *
 * <p><b>보안</b>: {@code @Profile({"local","dev"})} 로 제한되어 qa/prd 프로파일에서는 Bean 이 등록되지 않는다.
 * 인증 우회 엔드포인트이므로 운영 프로파일에 절대 노출되면 안 된다.
 */
@Slf4j
@Profile({"local", "dev"})
@Controller
@Tag(name = "0. SSO")
@RequiredArgsConstructor
public class SsoDevController {

    private final CustomUserDetailsService userDetailsService;
    private final SecurityContextRepository securityContextRepository;
    private final CommonProperties properties;

    @Operation(summary = "[DEV] SSO 우회 로그인", description = "id 만으로 세션을 만들어 FE로 이동. local/dev 프로파일 전용.")
    @GetMapping("/sso/dev-login")
    public void devLogin(@RequestParam("id") String userId,
                         HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetails userDetails;
        try {
            userDetails = userDetailsService.loadUserByUsername(userId);
        } catch (UsernameNotFoundException e) {
            log.warn("[DEV] 사용자 조회 실패. userId={}", userId);
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("dev-login failed: user load error for '" + userId + "'");
            return;
        }

        // SsoController.loginExec 4~5단계와 동일 — SecurityContext 를 세션에 저장 후 FE redirect
        Authentication authentication =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
        securityContextRepository.saveContext(context, request, response);

        log.warn("[DEV] SSO 우회 로그인 성공. userId={}", userId);
        response.sendRedirect(properties.getDomain().getFe());
    }
}
