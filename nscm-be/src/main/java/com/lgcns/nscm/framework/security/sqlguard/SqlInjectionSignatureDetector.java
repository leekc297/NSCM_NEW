package com.lgcns.nscm.framework.security.sqlguard;

import java.util.List;
import java.util.regex.Pattern;

/**
 * SQL 주입 시그니처 탐지기. 단독 특수문자가 아니라 "따옴표 탈출 + SQL 구조"가 섞인 입력만 탐지한다.
 * WS 3-1(SQL Injection) 보안점검 대응. 근거: docs/superpowers/specs/2026-11-09-ws3-1-sql-injection-guard-design.md
 */
public class SqlInjectionSignatureDetector {

    private static final List<Pattern> SIGNATURES = List.of(
        Pattern.compile("--"),
        Pattern.compile("/\\*|\\*/"),
        Pattern.compile("\\|\\|"),
        Pattern.compile("\\(\\s*case\\s+when", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\(\\s*select\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\bunion\\b\\s+(all\\s+)?\\bselect\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("['\"]\\s*(or|and)\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\b(or|and)\\s+(\\d+)\\s*=\\s*\\2\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\bxp_cmdshell\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\bdbms_\\w+", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\butl_\\w+", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\bexecute\\s+immediate\\b", Pattern.CASE_INSENSITIVE),
        Pattern.compile("\\bwaitfor\\s+delay\\b", Pattern.CASE_INSENSITIVE)
    );

    /** 값에 주입 시그니처가 있으면 true. null/빈값은 false. */
    public boolean matches(String value) {
        if (value == null || value.isEmpty()) return false;
        for (Pattern p : SIGNATURES) {
            if (p.matcher(value).find()) return true;
        }
        return false;
    }

    /** 처음 매칭된 시그니처의 정규식 문자열을 반환(감사로그용). 없으면 null. */
    public String firstMatch(String value) {
        if (value == null || value.isEmpty()) return null;
        for (Pattern p : SIGNATURES) {
            if (p.matcher(value).find()) return p.pattern();
        }
        return null;
    }
}
