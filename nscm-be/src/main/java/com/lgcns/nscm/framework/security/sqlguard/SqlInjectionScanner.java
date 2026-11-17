package com.lgcns.nscm.framework.security.sqlguard;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/** 파싱된 요청 바디(Map/List/String 중첩)를 재귀 순회해 첫 주입 위반을 찾는다. */
public class SqlInjectionScanner {

    private final SqlInjectionSignatureDetector detector;

    public SqlInjectionScanner(SqlInjectionSignatureDetector detector) {
        this.detector = detector;
    }

    public Optional<SqlInjectionViolation> scan(Object body) {
        return walk(body, "");
    }

    private Optional<SqlInjectionViolation> walk(Object node, String path) {
        if (node instanceof String s) {
            String sig = detector.firstMatch(s);
            return sig == null ? Optional.empty()
                    : Optional.of(new SqlInjectionViolation(path.isEmpty() ? "(root)" : path, sig));
        }
        if (node instanceof Map<?, ?> map) {
            for (Map.Entry<?, ?> e : map.entrySet()) {
                String child = path.isEmpty() ? String.valueOf(e.getKey()) : path + "." + e.getKey();
                Optional<SqlInjectionViolation> v = walk(e.getValue(), child);
                if (v.isPresent()) return v;
            }
            return Optional.empty();
        }
        if (node instanceof List<?> list) {
            for (int i = 0; i < list.size(); i++) {
                Optional<SqlInjectionViolation> v = walk(list.get(i), path + "[" + i + "]");
                if (v.isPresent()) return v;
            }
            return Optional.empty();
        }
        return Optional.empty();
    }
}
