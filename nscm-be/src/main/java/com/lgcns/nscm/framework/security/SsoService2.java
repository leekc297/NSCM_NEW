// 2026.02.23 Minyong Lee : SSO 개발 임시 중단, QA 서버 구비 시 재개 예정

// package com.lgcns.nscm.framework.security;

// import java.io.IOException;
// import java.util.ArrayList;
// import java.util.List;

// import org.springframework.stereotype.Service;

// import com.initech.eam.api.NXContext;
// import com.initech.eam.jakarta.nls.CookieManager;
// import com.initech.eam.smartenforcer.SECode;
// import com.lgcns.nscm.framework.property.CommonProperties;
// import com.lgcns.nscm.framework.property.CommonProperties.Sso;

// import jakarta.annotation.PostConstruct;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import lombok.extern.slf4j.Slf4j;


// @Slf4j
// //@Service
// public class SsoService2 {

// 	private final Sso sso;
//     private NXContext context;

// //    @Value("${sso.service-name}")
// //    private String SERVICE_NAME;
// //    @Value("${sso.server-url}")
// //    private String SERVER_URL;
// //    @Value("${sso.server-port}")
// //    private String SERVER_PORT;
// //    private String ASCP_URL_SUFFIX = "/api/v1/sso/login_exec";
// //
// //    @Value("${sso.nls-url}")
// //    private String NLS_URL;
// //    @Value("${sso.nls-port}")
// //    private String NLS_PORT;
// //    private String NLS_LOGIN_URL_SUFFIX = "/nls3/clientLogin.jsp";
// //    private String NLS_LOGOUT_URL_SUFFIX = "/nls3/NCLogout.jsp";
// //    private String NLS_ERROR_URL_SUFFIX = "/nls3/error.jsp";
// //
// //    @Value("${sso.nd-url}")
// //    private static String ND_URL;
// //    private String SSO_DOMAIN = ".lgensol.com";
// //    private String TOA = "1";

// //    private static int COOKIE_SESSION_TIMEOUT = 3000000;
// //    private static int TIMEOUT = 15000;

// //    private static Vector<String> PROVIDER_LIST = new Vector<String>();


// 	public SsoService2(CommonProperties commonProperties) {
// 		this.sso = commonProperties.getSso();
// 	}

//     @PostConstruct
//     public void init() {
//         List<String> serverUrlList = new ArrayList<>();
//         serverUrlList.add(sso.getNdUrl());

//         context = new NXContext(serverUrlList, sso.getTimeout());

//         // static import로 변경 예정
//         com.initech.provider.crypto.InitechProvider.isPrint = true;

//         if (com.initech.provider.crypto.InitechProvider.isProvenMode())
//             com.initech.provider.crypto.InitechProvider.changeMode();

//         if (java.security.Security.getProvider("Initech") != null) {
//             java.security.Security.removeProvider("Initech");
//         }

//         com.initech.provider.crypto.InitechProvider.addAsProvider(false, false);

//         CookieManager.setEncStatus(true);
//         SECode.setCookiePadding("");
//     }

//     public String getSsoId(HttpServletRequest request) {
//         String sso_id = null;
//         sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
//         return sso_id;
//     }

//     public void goLoginPage(HttpServletResponse response) throws IOException {
//         String ascpUrl = sso.getServerUrl() + ":" + sso.getServerPort() + sso.getAscpUrlSuffix();
//         String nlsLoginUrl = sso.getNlsUrl() + ":" + sso.getNlsPort() + sso.getNlsLoginUrlSuffix();

//         log.info("ASCP_URL : {}", ascpUrl);
//         log.info("NSL_LOGIN_URL : {}", nlsLoginUrl);

//         CookieManager.addCookie("InitechEamUURL", ascpUrl, sso.getSsoDomain(), response);
//         CookieManager.addCookie(SECode.R_TOA, sso.getToa(), sso.getSsoDomain(), response);

//         response.sendRedirect(nlsLoginUrl);
//     }

//     public void goErrorPage(HttpServletResponse response, int errorCode) throws IOException {
//         String ascpUrl = sso.getServerUrl() + ":" + sso.getServerPort() + sso.getAscpUrlSuffix();
//         String nlsErrorUrl = sso.getNlsUrl() + ":" + sso.getNlsPort() + sso.getNlsErrorUrlSuffix();

//         CookieManager.removeNexessCookie(sso.getSsoDomain(), response);
//         CookieManager.addCookie(SECode.USER_URL, ascpUrl, sso.getSsoDomain(), response);

//         response.sendRedirect(nlsErrorUrl + "?errorCode=" + errorCode);
//     }

//     public String getEamSessionCheck(HttpServletRequest request, HttpServletResponse response) {
//         try {
//             String retCode = CookieManager.verifyNexessCookie(
//             	request, response, 10, sso.getCookieSessionTimeout(), sso.getProviderList()
//             );
//             return retCode;
//         } catch (Exception e) {
//         	return "-1";
//         }
//     }
// }
