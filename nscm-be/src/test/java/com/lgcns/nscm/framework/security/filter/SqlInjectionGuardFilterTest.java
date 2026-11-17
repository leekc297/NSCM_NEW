package com.lgcns.nscm.framework.security.filter;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

class SqlInjectionGuardFilterTest {

    private final SqlInjectionGuardFilter filter = new SqlInjectionGuardFilter();

    private MockHttpServletRequest post(String uri, String json) {
        MockHttpServletRequest req = new MockHttpServletRequest("POST", uri);
        req.setContentType("application/json");
        req.setContent(json.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        return req;
    }

    @Test
    @DisplayName("call-proc 경로의 주입 페이로드는 400으로 차단된다")
    void blocksInjectionOnGuardedPath() throws Exception {
        MockHttpServletRequest req = post("/DMF0014/FCST Upload/SEARCH/call-proc",
            "{\"scmSiteId\":\"Ampere Ele||(case when 1=1 then 'c' else 'x' end)||'DOI\"}");
        MockHttpServletResponse res = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, res, chain);

        assertThat(res.getStatus()).isEqualTo(400);
        assertThat(chain.getRequest()).isNull();
        assertThat(res.getContentAsString()).contains("-9993");
    }

    @Test
    @DisplayName("정상 값은 통과하고 컨트롤러가 바디를 다시 읽을 수 있다")
    void passesCleanAndBodyReReadable() throws Exception {
        String json = "{\"divisionId\":\"81\",\"endCustomer\":\"AT&T\"}";
        MockHttpServletRequest req = post("/DMF0014/FCST Upload/SEARCH/call-proc", json);
        MockHttpServletResponse res = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, res, chain);

        assertThat(res.getStatus()).isEqualTo(200);
        assertThat(chain.getRequest()).isNotNull();
        String downstream = new String(
            ((jakarta.servlet.http.HttpServletRequest) chain.getRequest()).getInputStream().readAllBytes(),
            java.nio.charset.StandardCharsets.UTF_8);
        assertThat(downstream).isEqualTo(json);
    }

    @Test
    @DisplayName("SYS0013(dynamic-query) 경로는 검사하지 않고 통과한다")
    void skipsExemptDynamicQuery() throws Exception {
        MockHttpServletRequest req = post("/admin/dynamic-query/execute",
            "{\"sqlText\":\"SELECT * FROM users WHERE 1=1 UNION SELECT * FROM secret\"}");
        MockHttpServletResponse res = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, res, chain);

        assertThat(res.getStatus()).isEqualTo(200);
        assertThat(chain.getRequest()).isNotNull();
    }

    @Test
    @DisplayName("비대상 경로(image-upload 등)는 검사하지 않는다")
    void skipsNonGuardedPath() throws Exception {
        MockHttpServletRequest req = post("/file/image-upload", "{\"x\":\"' OR '1'='1\"}");
        MockHttpServletResponse res = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilter(req, res, chain);

        assertThat(res.getStatus()).isEqualTo(200);
        assertThat(chain.getRequest()).isNotNull();
    }
}
