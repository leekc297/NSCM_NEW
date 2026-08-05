package com.lgcns.nscm.admin.user;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Collections;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.context.SecurityContextRepository;

import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.security.CustomUserDetails;
import com.lgcns.nscm.framework.security.CustomUserDetailsService;
import com.lgcns.nscm.framework.security.SsoService;

@ExtendWith(MockitoExtension.class)
class SsoControllerTest {

    @Mock
    private SsoService ssoService;
    @Mock
    private CustomUserDetailsService userDetailsService;
    @Mock
    private SecurityContextRepository securityContextRepository;
    @Mock
    private CommonProperties properties;

    @InjectMocks
    private SsoController ssoController;

    private MockHttpServletRequest request;
    private MockHttpServletResponse response;

    @BeforeEach
    void setUp() {
        request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
    }

    @Test
    @DisplayName("SSO ID가 없으면 SSO 로그인 페이지로 이동한다")
    void goLoginPageWhenNoSsoId() throws Exception {
        when(ssoService.getSsoId(request)).thenReturn(null);

        ssoController.loginExec(request, response);

        verify(ssoService).goLoginPage(response);
        verify(ssoService, never()).verifySession(any(), any());
    }

    @Test
    @DisplayName("쿠키 검증 실패 시 retCode를 에러코드로 에러 페이지로 이동한다")
    void goErrorPageWhenVerifyFails() throws Exception {
        when(ssoService.getSsoId(request)).thenReturn("testuser");
        when(ssoService.verifySession(request, response)).thenReturn("3");

        ssoController.loginExec(request, response);

        verify(ssoService).goErrorPage(response, 3);
        verify(securityContextRepository, never()).saveContext(any(), any(), any());
    }

    @Test
    @DisplayName("사용자 조회 중 오류가 발생하면 에러 페이지로 이동한다")
    void goErrorPageWhenLoadFails() throws Exception {
        when(ssoService.getSsoId(request)).thenReturn("unknown");
        when(ssoService.verifySession(request, response)).thenReturn("0");
        when(userDetailsService.loadUserByUsername("unknown"))
                .thenThrow(new UsernameNotFoundException("User not found: unknown"));

        ssoController.loginExec(request, response);

        verify(ssoService).goErrorPage(response, SsoController.ERROR_CODE_USER_NOT_FOUND);
        verify(securityContextRepository, never()).saveContext(any(), any(), any());
    }

    @Test
    @DisplayName("게스트 사용자도 999로 막지 않고 세션 저장 후 FE로 redirect 한다")
    void loginSuccessForGuestUser() throws Exception {
        when(ssoService.getSsoId(request)).thenReturn("kim");
        when(ssoService.verifySession(request, response)).thenReturn("0");
        when(userDetailsService.loadUserByUsername("kim")).thenReturn(
                CustomUserDetails.builder()
                        .username("kim")
                        .password("")
                        .userNm("Guest")
                        .isGuest(true)
                        .authorities(Collections.emptyList())
                        .build());
        when(properties.getDomain()).thenReturn(
                new CommonProperties.Domain("http://localhost:3000/", "http://localhost:8080/"));

        ssoController.loginExec(request, response);

        verify(securityContextRepository).saveContext(any(SecurityContext.class), eq(request), eq(response));
        assertEquals("http://localhost:3000/", response.getRedirectedUrl());
        verify(ssoService, never()).goErrorPage(any(), eq(SsoController.ERROR_CODE_USER_NOT_FOUND));
    }

    @Test
    @DisplayName("인증 성공 시 SecurityContext를 세션에 저장하고 FE로 redirect 한다")
    void loginSuccess() throws Exception {
        when(ssoService.getSsoId(request)).thenReturn("testuser");
        when(ssoService.verifySession(request, response)).thenReturn("0");
        when(userDetailsService.loadUserByUsername("testuser")).thenReturn(
                CustomUserDetails.builder()
                        .username("testuser")
                        .password("")
                        .authorities(Collections.emptyList())
                        .build());
        when(properties.getDomain()).thenReturn(
                new CommonProperties.Domain("http://localhost:3000/", "http://localhost:8080/"));

        ssoController.loginExec(request, response);

        verify(securityContextRepository).saveContext(any(SecurityContext.class), eq(request), eq(response));
        assertEquals("http://localhost:3000/", response.getRedirectedUrl());
    }
}
