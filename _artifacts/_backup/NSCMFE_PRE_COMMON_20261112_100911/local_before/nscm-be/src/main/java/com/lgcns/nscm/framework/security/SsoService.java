// 2026.02.23 Minyong Lee : SSO 개발 임시 중단, QA 서버 구비 시 재개 예정

// package com.lgcns.nscm.framework.security;

// import java.io.IOException;
// import java.util.ArrayList;
// import java.util.List;
// import java.util.Vector;

// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Service;

// import com.initech.eam.api.NXContext;
// import com.initech.eam.jakarta.api.NXNLSAPI;
// import com.initech.eam.jakarta.nls.CookieManager;
// import com.initech.eam.smartenforcer.SECode;

// import jakarta.servlet.http.Cookie;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import lombok.extern.slf4j.Slf4j;

// @Slf4j
// @Service
// public class SsoService {

//     @Value("${config.sso.service-name}")
//     private String SERVICE_NAME;
//     @Value("${config.sso.server-url}")
//     private String SERVER_URL;
//     @Value("${config.sso.server-port}")
//     private String SERVER_PORT;
//     private String ASCP_URL_SUFFIX = "/api/v1/sso/login_exec";

//     @Value("${config.sso.nls-url}")
//     private String NLS_URL;
//     @Value("${config.sso.nls-port}")
//     private String NLS_PORT;
//     private String NLS_LOGIN_URL_SUFFIX = "/nls3/clientLogin.jsp";
//     private String NLS_LOGOUT_URL_SUFFIX = "/nls3/NCLogout.jsp";
//     private String NLS_ERROR_URL_SUFFIX = "/nls3/error.jsp";

//     @Value("${config.sso.nd-url}")
//     private static String ND_URL;
//     private String SSO_DOMAIN = ".lgensol.com";
//     private String TOA = "1";

//     private static int COOKIE_SESSION_TIMEOUT = 3000000;
//     private static int TIMEOUT = 15000;

//     private static Vector<String> PROVIDER_LIST = new Vector<String>();

//     private static NXContext context;

//     static {
//         List<String> serverurlList = new ArrayList<>();
//         serverurlList.add(ND_URL);

//         context = new NXContext(serverurlList, TIMEOUT);

//         com.initech.provider.crypto.InitechProvider.isPrint = true;

//         if (com.initech.provider.crypto.InitechProvider.isProvenMode())
//             com.initech.provider.crypto.InitechProvider.changeMode();

//         if (java.security.Security.getProvider("Initech") != null) {
//             java.security.Security.removeProvider("Initech");
//         }

//         com.initech.provider.crypto.InitechProvider.addAsProvider(false, false);

//         CookieManager.setEncStatus(true);

//         PROVIDER_LIST.add("ssodev.lgensol.com");
//         PROVIDER_LIST.add("ssolesdev.lgchem.com");
//         PROVIDER_LIST.add("gssodev.ultiumcell.com");
//         PROVIDER_LIST.add("gssodev.lgensol.com");
//         PROVIDER_LIST.add("sso.lgensol.com");
//         PROVIDER_LIST.add("ssoles.lgchem.com");
//         PROVIDER_LIST.add("gsso.lgensol.com");
//         PROVIDER_LIST.add("gssoles.lgchem.com");
//         PROVIDER_LIST.add("gsso.ultiumcell.com");

//         SECode.setCookiePadding("");
//     }

//     public String getSsoId(HttpServletRequest request) {
//         System.out.println("SsoService.getSsoId()");
//         System.out.println(request.toString());
//         String sso_id = null;
//         // sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
//         sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
//         System.out.println("sso_id: " + sso_id);
//         return sso_id;
//     }

//     public void goLoginPage(HttpServletRequest request, HttpServletResponse response) throws IOException {
//         System.out.println("SsoService.goLoginPage()");
//         System.out.println(response.toString());
//         System.out.println(NLS_URL);
//         System.out.println(NLS_PORT);

//         String ascpUrl = SERVER_URL + ":" + SERVER_PORT + ASCP_URL_SUFFIX;
//         String nlsLoginUrl = NLS_URL + ":" + NLS_PORT + NLS_LOGIN_URL_SUFFIX;

//         System.out.println("SECode.USER_URL: " + SECode.USER_URL);
//         System.out.println("ascpUrl: " + ascpUrl);
//         System.out.println("SSO_DOMAIN: " + SSO_DOMAIN);
//         System.out.println("nlsLoginUrl: " + nlsLoginUrl);

//         // 문제가 되는 부분
//         Cookie[] cookies = request.getCookies();
//         log.info("Cookie InitechEamUURL : {}", CookieManager.getCookieValue("initechEamUURL", request));
//         CookieManager.addCookie("InitechEamUURL", ascpUrl, SSO_DOMAIN,
//         response);
//         log.info("Cookie InitechEamUURL : {}", CookieManager.getCookieValue("initechEamUURL", request));

//         CookieManager.addCookie(SECode.R_TOA, "2", SSO_DOMAIN, response);
//         response.sendRedirect(nlsLoginUrl);
//     }

//     public String getEamSessionCheckAndAgentVaild(HttpServletRequest request, HttpServletResponse response) {
//         System.out.println("SsoService.getEamSessionCheckAndAgentVaild()");
//         System.out.println(request.toString());
//         System.out.println(response.toString());

//         try {
//             String retCode = CookieManager.verifyNexessCookieAndAgentVaild(request,
//                     response, 10, COOKIE_SESSION_TIMEOUT, PROVIDER_LIST, SERVER_URL, context);
//             System.out.println("retCode: " + retCode);
//             return retCode;
//         } catch (Exception npe) {
//             System.out.println("SsoService.getEamSessionCheckAndAgentVaild() - Error Catched");
//             npe.printStackTrace();
//             return "-1";
//         }
//     }

//     public String getEamSessionCheck(HttpServletRequest request, HttpServletResponse response) {
//         String retCode = "";
//         try {
//             retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSION_TIMEOUT, PROVIDER_LIST);
//         } catch (Exception npe) {
//             npe.printStackTrace();
//         }
//         return retCode;
//     }

//     public String getEamSessionCheck2(HttpServletRequest request, HttpServletResponse response) {
//         String retCode = "";
//         try {
//             NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
//             retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
//         } catch (Exception npe) {
//             npe.printStackTrace();
//         }
//         return retCode;
//     }

//     public void goErrorPage(HttpServletResponse response, int errorCode) throws IOException {
//         System.out.println("SsoService.goErrorPage()");
//         System.out.println(response.toString());

//         String ascpUrl = SERVER_URL + ":" + SERVER_PORT + ASCP_URL_SUFFIX;
//         System.out.println(ascpUrl);
//         String nlsErrorUrl = NLS_URL + ":" + NLS_PORT + NLS_ERROR_URL_SUFFIX;
//         System.out.println(nlsErrorUrl);

//         CookieManager.removeNexessCookie(SSO_DOMAIN, response);
//         CookieManager.addCookie(SECode.USER_URL, ascpUrl, SSO_DOMAIN,
//                 response);
//         response.sendRedirect(nlsErrorUrl + "?errorCode=" + errorCode);
//     }
// }
