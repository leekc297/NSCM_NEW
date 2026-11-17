package com.lgcns.nscm.framework.security.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.security.sqlguard.SqlInjectionScanner;
import com.lgcns.nscm.framework.security.sqlguard.SqlInjectionSignatureDetector;
import com.lgcns.nscm.framework.security.sqlguard.SqlInjectionViolation;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

/**
 * WS 3-1 SQL Injection 완화 공통 필터. SP/SQL 범용 실행 JSON 경로만 대상으로 요청 바디를 스캔해
 * 주입 시그니처가 있으면 400 차단. SQL 실행이 기능 자체인 화면(SYS0013 등)은 비대상.
 * 근본치료(SP 동적SQL 바인드화)는 별도 과제. 스펙: docs/superpowers/specs/2026-11-09-ws3-1-sql-injection-guard-design.md
 */
@Slf4j
public class SqlInjectionGuardFilter extends OncePerRequestFilter {

    private static final AntPathMatcher MATCHER = new AntPathMatcher();

    private static final List<String> GUARDED = List.of(
        "/**/call-proc", "/**/call-proc2", "/**/call-proc-stream",
        "/**/retrieve-general", "/**/excute-general");

    private static final List<String> EXEMPT = List.of(
        "/admin/dynamic-query/**");

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final SqlInjectionScanner scanner = new SqlInjectionScanner(new SqlInjectionSignatureDetector());

    @Override
    protected boolean shouldNotFilter(HttpServletRequest req) {
        String uri = req.getRequestURI();
        if (EXEMPT.stream().anyMatch(p -> MATCHER.match(p, uri))) return true;
        boolean guarded = GUARDED.stream().anyMatch(p -> MATCHER.match(p, uri));
        return !guarded;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        CachedBodyHttpServletRequest cached = new CachedBodyHttpServletRequest(request);
        byte[] body = cached.getCachedBody();

        if (body.length > 0) {
            Object parsed = null;
            try {
                parsed = objectMapper.readValue(body, Object.class);
            } catch (Exception e) {
                parsed = null;
            }
            if (parsed != null) {
                Optional<SqlInjectionViolation> v = scanner.scan(parsed);
                if (v.isPresent()) {
                    writeBlocked(request, response, v.get());
                    return;
                }
            }
        }
        chain.doFilter(cached, response);
    }

    private void writeBlocked(HttpServletRequest request, HttpServletResponse response, SqlInjectionViolation v)
            throws IOException {
        String userId = currentUserId();
        log.warn("[SQLi-BLOCK] user={} uri={} field={} signature={}",
            userId, request.getRequestURI(), v.field(), v.signature());

        response.setStatus(HttpStatus.BAD_REQUEST.value());
        response.setContentType("application/json;charset=utf-8");

        Map<String, Object> errorBody = new HashMap<>();
        errorBody.put("code", BaseConstants.INVALID_INPUT);
        errorBody.put("message", BaseConstants.INVALID_INPUT_MSG);
        errorBody.put("result", null);
        objectMapper.writeValue(response.getWriter(), errorBody);
    }

    private String currentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth == null ? "anonymous" : auth.getName();
    }
}
