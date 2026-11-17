package com.lgcns.nscm.framework.security.sqlguard;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class SqlInjectionScannerTest {

    private final SqlInjectionScanner scanner = new SqlInjectionScanner(new SqlInjectionSignatureDetector());

    @Test
    @DisplayName("최상위 문자열 값의 주입을 잡는다")
    void detectsTopLevel() {
        Map<String, Object> body = Map.of(
            "divisionId", "81",
            "scmSiteId", "Ampere Ele||(case when 1=1 then 'c' else 'x' end)||'DOI");
        Optional<SqlInjectionViolation> v = scanner.scan(body);
        assertThat(v).isPresent();
        assertThat(v.get().field()).isEqualTo("scmSiteId");
    }

    @Test
    @DisplayName("중첩 배열/객체(save payload) 내부 주입도 잡는다")
    void detectsNested() {
        Map<String, Object> body = Map.of(
            "data", List.of(
                Map.of("itemId", "A001"),
                Map.of("itemId", "x' OR '1'='1")));
        Optional<SqlInjectionViolation> v = scanner.scan(body);
        assertThat(v).isPresent();
        assertThat(v.get().field()).isEqualTo("data[1].itemId");
    }

    @Test
    @DisplayName("정상 값만 있으면 위반 없음")
    void passesClean() {
        Map<String, Object> body = Map.of(
            "divisionId", "81",
            "endCustomer", "AT&T",
            "toYyyymmdd", "20270509",
            "qty", 100);
        assertThat(scanner.scan(body)).isEmpty();
    }
}
