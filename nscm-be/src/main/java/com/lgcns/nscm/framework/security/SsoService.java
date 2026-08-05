package com.lgcns.nscm.framework.security;

import java.io.IOException;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.initech.eam.api.NXContext;
import com.initech.eam.jakarta.nls.CookieManager;
import com.initech.eam.smartenforcer.SECode;
import com.initech.provider.crypto.InitechProvider;
import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.property.CommonProperties.Sso;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

/**
 * LG에너지솔루션 SSO(INISAFE Nexess) Agent 연동 서비스.
 * SSO 가이드(nexess_Agent config.jsp)의 표준 구현을 Spring Bean으로 옮긴 것.
 */
@Slf4j
@Service
public class SsoService {

    /** verifyNexessCookie 검증 옵션 (가이드 표준값) */
    private static final int VERIFY_OPTION = 10;
    /** 쿠키 검증 성공 코드 */
    public static final String RET_CODE_SUCCESS = "0";

    private final Sso sso;
    private NXContext context;

    public SsoService(CommonProperties commonProperties) {
        this.sso = commonProperties.getSso();
    }

    @PostConstruct
    public void init() {
        List<String> serverUrlList = new ArrayList<>();
        serverUrlList.add(sso.getNdUrl());
        context = new NXContext(serverUrlList, sso.getTimeout());

        // Initech 암호화 Provider 등록 (가이드 표준 초기화)
        if (InitechProvider.isProvenMode()) {
            InitechProvider.changeMode();
        }
        if (Security.getProvider("Initech") != null) {
            Security.removeProvider("Initech");
        }
        InitechProvider.addAsProvider(false, false);

        CookieManager.setEncStatus(true);
        // NLS3 web.xml의 CookiePadding 설정과 일치해야 함
        SECode.setCookiePadding("");

        log.info("SsoService initialized. ndUrl={}, nlsUrl={}", sso.getNdUrl(), sso.getNlsUrl());
    }

    /** Nexess 쿠키에서 SSO 사용자 ID 조회. 미로그인 시 null */
    public String getSsoId(HttpServletRequest request) {
        return CookieManager.getCookieValue(SECode.USER_ID, request);
    }

    /** SSO 포탈 로그인 페이지로 이동 (복귀 URL/인증타입 쿠키 설정 후 redirect) */
    public void goLoginPage(HttpServletResponse response) throws IOException {
        String ascpUrl = ascpUrl();
        String nlsLoginUrl = sso.getNlsUrl() + ":" + sso.getNlsPort() + sso.getNlsLoginUrlSuffix();

        log.debug("SSO goLoginPage. ascpUrl={}, nlsLoginUrl={}", ascpUrl, nlsLoginUrl);

        CookieManager.addCookie(SECode.USER_URL, ascpUrl, sso.getSsoDomain(), response);
        CookieManager.addCookie(SECode.R_TOA, sso.getToa(), sso.getSsoDomain(), response);

        response.sendRedirect(nlsLoginUrl);
    }

    /** Nexess 쿠키 유효성 검증. 성공 시 "0", 실패 시 에러코드, 예외 시 "-1" */
    public String verifySession(HttpServletRequest request, HttpServletResponse response) {
        try {
            return CookieManager.verifyNexessCookie(
                    request, response, VERIFY_OPTION, sso.getCookieSessionTimeout(), sso.getProviderList());
        } catch (Exception e) {
            log.error("SSO 쿠키 검증 중 예외 발생", e);
            return "-1";
        }
    }

    /** SSO 포탈 에러 페이지로 이동 (Nexess 쿠키 제거 후 redirect) */
    public void goErrorPage(HttpServletResponse response, int errorCode) throws IOException {
        String nlsErrorUrl = sso.getNlsUrl() + ":" + sso.getNlsPort() + sso.getNlsErrorUrlSuffix();

        log.warn("SSO goErrorPage. errorCode={}", errorCode);

        CookieManager.removeNexessCookie(sso.getSsoDomain(), response);
        CookieManager.addCookie(SECode.USER_URL, ascpUrl(), sso.getSsoDomain(), response);

        response.sendRedirect(nlsErrorUrl + "?errorCode=" + errorCode);
    }

    private String ascpUrl() {
        return sso.getServerUrl() + ":" + sso.getServerPort() + sso.getAscpUrlSuffix();
    }
}
