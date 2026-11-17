package com.lgcns.nscm.framework.webservice;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

/**
 * 외부 웹서비스(SOAP) 공통 호출 엔드포인트 설정.
 *
 * config-{local,dev,qa,prd}.yml 의 `config.web-service.endpoints.<serviceKey>` 를 바인딩한다.
 * URL 은 환경별 yml 에서만 관리하고 코드에는 serviceKey 만 남긴다(AS-IS 의 DEV/QAS/PRD 분기 대체).
 *
 * <pre>
 * config:
 *   web-service:
 *     endpoints:
 *       erpIf:
 *         endpoint:  http://.../UIC0001.asmx
 *         namespace: http://www.lgchem.com/PI/UIC0001
 *         method:    FN_UIC0001
 * </pre>
 */
@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "config.web-service")
public class WebServiceProperties {

    /** serviceKey -> 엔드포인트. 설정이 없으면 빈 맵(호출 시 미등록 예외). */
    private Map<String, Endpoint> endpoints = new HashMap<>();

    @Getter
    @Setter
    public static class Endpoint {
        /** SOAP 서비스 주소(.asmx 등). 환경별 yml 에서 주입. */
        private String endpoint;
        /** SOAP XML namespace. */
        private String namespace;
        /** 호출 메서드명(SOAP body 루트 엘리먼트). */
        private String method;
        /**
         * 요청 파라미터를 감쌀 복합타입 엘리먼트명(예: UIC0001_CALL_FROM_SSPUI).
         * AS-IS ASMX 는 메서드 인자를 복합타입 1개로 받으므로 그 엘리먼트로 한 번 감싼다. 없으면 평면.
         */
        private String wrapper;
        /** SOAPAction HTTP 헤더(ASMX document/literal 필수). 미지정 시 namespace 로 자동 채움(관례). */
        private String soapAction;
        /**
         * true 면 실제 전송 없이 성공 응답(E_TYPE=S)만 돌려준다 — 그 환경에 연계 대상이 아직 없을 때.
         *
         * 종전에는 화면이 mock 전용 URL(`/call-test`)을 직접 가리켜 환경 구분을 FE 가 졌다. 그러면 환경마다
         * 화면 상수를 바꿔야 하고, dev 에서 실경로로 올리는 순간 미구성 SOAP 으로 나가 오류 알럿이 뜬다.
         * 그래서 "연계가 준비됐나"는 FE 가 아니라 환경 설정이 판단하도록 옮겼다. 화면은 항상 `/call` 하나만 쓴다.
         * 준비가 끝나면 이 값을 내리고 nscm-if.enabled 를 올린다. `/call-test` 는 수동 점검용으로 남아 있다.
         */
        private boolean stub;
    }
}
