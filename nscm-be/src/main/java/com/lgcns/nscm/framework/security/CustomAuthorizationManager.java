package com.lgcns.nscm.framework.security;

import static org.springframework.web.servlet.HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE;

import java.util.function.Supplier;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.authorization.AuthorizationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.access.intercept.RequestAuthorizationContext;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerExecutionChain;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import com.lgcns.nscm.admin.auth.AuthService;
import com.lgcns.nscm.framework.annotation.AuthCheck;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomAuthorizationManager implements AuthorizationManager<RequestAuthorizationContext> {

	private final RequestMappingHandlerMapping handlerMapping;
	private final AntPathMatcher pathMatcher = new AntPathMatcher();
    private final AuthService authService;

    @Override
    public AuthorizationDecision check(Supplier<Authentication> authenticationSupplier, RequestAuthorizationContext context) {
        try {
            HttpServletRequest request = context.getRequest();
            AuthCheck.Type authCheckType = getAuthCheckType(request);
            log.info("AuthCheck type: {}", authCheckType);

            // 1. NONE
            if (authCheckType == AuthCheck.Type.NONE) return new AuthorizationDecision(true);

            // 2. LOGIN
            Authentication auth = authenticationSupplier.get();
            if (authCheckType == AuthCheck.Type.LOGIN) return _authenticate(auth);

            // 3. ALL
            if (authCheckType == AuthCheck.Type.ALL) return _authorize(request, auth);

            return new AuthorizationDecision(false);

        } catch (Exception e) {
            log.error("Authorization error occurred", e);
            return new AuthorizationDecision(false);
        }
    }

    private AuthCheck.Type getAuthCheckType(HttpServletRequest request) throws Exception {
        HandlerExecutionChain chain = handlerMapping.getHandler(request);
        if (chain == null || !(chain.getHandler() instanceof HandlerMethod handlerMethod)) {
            return AuthCheck.Type.LOGIN; // 기본값
        }

        AuthCheck authCheck = handlerMethod.getMethodAnnotation(AuthCheck.class);

        return (authCheck != null) ? authCheck.value() : AuthCheck.Type.LOGIN;
    }

    private boolean _isValidAuthentication(Authentication auth) {
        return auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken);
    }

    private AuthorizationDecision _authenticate(Authentication auth) throws Exception {
    	return _isValidAuthentication(auth) ? new AuthorizationDecision(true) : new AuthorizationDecision(false);
    }

    private AuthorizationDecision _authorize(HttpServletRequest request, Authentication auth) throws Exception {
        String lookupPath = (String) request.getAttribute(BEST_MATCHING_PATTERN_ATTRIBUTE);

        if (lookupPath == null
        		|| (!pathMatcher.match("/*/*/*/call-proc", lookupPath)
        		&& !pathMatcher.match("/*/*/*/excel-upload", lookupPath))) {
            return new AuthorizationDecision(false);
        }

        String uri = request.getRequestURI();
        String[] segments = uri.split("/");

        if (segments.length < 4) return new AuthorizationDecision(false);

        String userId = ((CustomUserDetails) auth.getPrincipal()).getUserId();
        String mnuId = segments[1];
        String shtNm = segments[2];
        String mnuBtnCd = segments[3];

        boolean isAuthorized = authService.checkMenuBtnAuth(userId, mnuId, shtNm, mnuBtnCd);
        return new AuthorizationDecision(isAuthorized);
    }
}
