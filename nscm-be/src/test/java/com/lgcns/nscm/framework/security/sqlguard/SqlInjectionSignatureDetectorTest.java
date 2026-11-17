package com.lgcns.nscm.framework.security.sqlguard;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class SqlInjectionSignatureDetectorTest {

    private final SqlInjectionSignatureDetector detector = new SqlInjectionSignatureDetector();

    @DisplayName("주입 시그니처가 포함된 값은 탐지된다")
    @ParameterizedTest
    @ValueSource(strings = {
        "Ampere Ele||(case when 1=1 then 'c' else 'xcascd' end)||'tricity_FR_DOI",
        "' OR '1'='1",
        "x' or 1=1 --",
        "1 UNION SELECT username,password FROM users",
        "name /* comment */",
        "(select max(id) from dual)",
        "'||xp_cmdshell('dir')||'",
        "' and utl_http.request('x')='",
        "'; execute immediate 'x",
        "1 or 1=1"
    })
    void detectsInjection(String value) {
        assertThat(detector.matches(value)).isTrue();
    }

    @DisplayName("정상 업무 값은 통과한다(오탐 없음)")
    @ParameterizedTest
    @ValueSource(strings = {
        "Ampere Electricity_FR_DOI",
        "AT&T",
        "O'Brien",
        "LG(주)",
        "20270509",
        "81",
        "DMF0014",
        "Model-A+B",
        "100%",
        "cat or dog pet",
        "Grade A or 2=rejected",
        "weight or 5 = heavy",
        "A;B;C"
    })
    void passesLegitimateValues(String value) {
        assertThat(detector.matches(value)).isFalse();
    }
}
