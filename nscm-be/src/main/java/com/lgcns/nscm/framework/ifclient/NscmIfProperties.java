package com.lgcns.nscm.framework.ifclient;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.Setter;

/**
 * nscm-if(인터페이스 서버) 실시간 송신 클라이언트 설정.
 *
 * config-{local,dev,qa,prd}.yml 의 `config.nscm-if` 를 바인딩한다.
 * AS-IS 는 화면(WinForms)이 UIC0001.asmx 를 직접 SOAP 호출했으나, TO-BE 는 ASMX 가 없고
 * nscm-if 가 그 자리를 REST 로 대신한다(nscm-if README "BE/FE 연동" 절).
 *
 * <pre>
 * config:
 *   nscm-if:
 *     enabled:  true
 *     base-url: http://localhost:8180/nscmif
 *     token:    &lt;X-IF-Token&gt;
 *     routes:
 *       erpIf: NSD0100      # web-service serviceKey -&gt; nscm-if IF_ID
 * </pre>
 *
 * routes 에 없는 serviceKey 는 종전대로 SOAP({@code WsdlCommonService})로 나간다.
 * enabled=false 면 라우팅 자체를 하지 않으므로 설정 한 줄로 SOAP 경로 복귀가 된다.
 */
@Getter
@Setter
@ConfigurationProperties(prefix = "config.nscm-if")
public class NscmIfProperties {

    /** false 면 routes 를 무시하고 전부 SOAP 으로 보낸다(복귀 스위치). */
    private boolean enabled = false;

    /** nscm-if 컨텍스트까지의 주소. 예: http://localhost:8180/nscmif */
    private String baseUrl = "";

    /** nscm-if 가 요구하는 고정 토큰(X-IF-Token). 비어 있으면 호출하지 않는다. */
    private String token = "";

    /** 연결 타임아웃(ms). */
    private int connectTimeoutMs = 5000;

    /**
     * 응답 대기 타임아웃(ms). nscm-if 의 PO 읽기 타임아웃(기본 60초)보다 길어야 한다
     * (IfSendController 주석 — "nscm-be 쪽 타임아웃은 이보다 길게").
     */
    private int readTimeoutMs = 70000;

    /** web-service serviceKey -> nscm-if IF_ID. 예: {erpIf: NSD0100} */
    private Map<String, String> routes = new HashMap<>();

    /** 이 serviceKey 를 nscm-if 로 보내야 하는지. */
    public boolean routes(String serviceKey) {
        return enabled && routes.containsKey(serviceKey);
    }

    /** serviceKey 에 대응하는 IF_ID. */
    public String ifIdOf(String serviceKey) {
        return routes.get(serviceKey);
    }
}
