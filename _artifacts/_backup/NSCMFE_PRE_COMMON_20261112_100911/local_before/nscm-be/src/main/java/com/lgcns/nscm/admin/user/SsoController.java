// 2026.02.23 Minyong Lee : SSO 개발 임시 중단, QA 서버 구비 시 재개 예정

// package com.lgcns.nscm.admin.user;

// import java.io.IOException;

// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Controller;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RestController;

// import com.initech.eam.jakarta.nls.CookieManager;
// import com.initech.eam.smartenforcer.SECode;
// import com.lgcns.nscm.admin.auth.AuthService;
// import com.lgcns.nscm.admin.menu.MenuController;
// import com.lgcns.nscm.admin.menu.MenuService;
// import com.lgcns.nscm.framework.annotation.AuthCheck;
// import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
// import com.lgcns.nscm.framework.property.CommonProperties;
// import com.lgcns.nscm.framework.security.SsoService;
// import com.lgcns.nscm.general.GeneralService;

// import io.swagger.v3.oas.annotations.tags.Tag;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession;
// import lombok.RequiredArgsConstructor;
// import lombok.extern.slf4j.Slf4j;

// @Slf4j
// @Controller
// @RequestMapping
// @Tag(name = "0. SSO")
// @RequiredArgsConstructor
// public class SsoController {

//     private final SsoService ssoService;
//     private final CommonProperties properties;
// //    private final SessionService sessionService;

// //    @Value("${domain.be}")
// //    private String DOMAIN_BE;
// //    @Value("${domain.fe}")
// //    private String DOMAIN_FE;
// //    private String REDIRECT_SUFFIX = "api/v1/sso/login_exec";

// //    @GetMapping(value = "/v1/sso/redirect-url", produces = MediaType.APPLICATION_JSON_VALUE)
// //    public ResponseEntity<CommonResponseVO> ssoRedirectUrl(HttpServletRequest request, HttpServletResponse response)
// //            throws Exception {
// //        String redirectUrl = DOMAIN_BE + REDIRECT_SUFFIX;
// //        return new ResponseEntity<>(
// //                CommonResponseVO.builder()
// //                        .successOrNot(CommonConstants.YES_FLAG)
// //                        .statusCode(StatusCodeConstants.SUCCESS)
// //                        .data(redirectUrl)
// //                        .build(),
// //                HttpStatus.OK);
// //    }

//     @AuthCheck(Type.NONE)
//     @GetMapping("/sso/login")
//     public void loginExec(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {

//         System.out.println("=== Request ===");
//         System.out.println(request.toString());
//         System.out.println("=== Response ===");
//         System.out.println(response.toString());
//         System.out.println("=== Session ===");
//         System.out.println(session.toString());

//         String ssoId = ssoService.getSsoId(request);
//         System.out.println("[login_exec] sso_id = " + ssoId);

//         if (ssoId == null || ssoId.isEmpty()) {
//             ssoService.goLoginPage(request, response);
//             return;
//         }

// //        String retCode = ssoService.getEamSessionCheck(request, response);
// //        System.out.println("[login_exec] retCode = " + retCode);
// //
// //        if (!"0".equals(retCode)) {
// //            ssoService.goErrorPage(response, Integer.parseInt(retCode));
// //            return;
// //        }
// //
// //        String eamId = (String) session.getAttribute("SSO_ID");
// //        if (eamId == null || eamId.isEmpty()) {
// //            session.setAttribute("SSO_ID", ssoId);
// //        }
// //
// //        System.out.println("SSO Success");

//         return;

// //        String ip1 = NetworkUtil.getClientIP(request);
// //        String ip2 = CookieManager.getCookieValue(SECode.USER_IP, request);
// //        System.out.println("NetworkUtil.getClientIP(request): " + ip1);
// //        System.out.println("CookieManager.getCookieValue(SECode.USER_IP, request): " + ip2);
// //        UserSessionVO userSession = sessionService.createUserSession(ssoId, "en", ip1);
// //        session.setAttribute(CommonConstants.HTTP_SESSION_KEY, userSession);
// //        response.sendRedirect(DOMAIN_FE);
//     }
// }
