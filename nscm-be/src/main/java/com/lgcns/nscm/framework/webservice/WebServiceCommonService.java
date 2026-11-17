package com.lgcns.nscm.framework.webservice;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.ifclient.IfSendClient;
import com.lgcns.nscm.framework.ifclient.NscmIfProperties;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 외부 웹서비스(SOAP) 공통 호출 서비스.
 *
 * serviceKey 로 {@link WebServiceProperties} 에서 환경별 엔드포인트를 찾아 {@link WsdlCommonService#callWsdl}
 * 로 전송하고, 응답 XML 의 말단 엘리먼트(E_TYPE/E_MESSAGE 등)를 Map 으로 파싱해 돌려준다.
 * (원문 XML 을 그대로 주면 FE 가 XML 을 파싱해야 하고, String 반환은 BaseController 의 String 오버로드와
 *  충돌해 result 가 아닌 code 로 들어가므로 Map 으로 반환한다.)
 *
 * 단, {@code config.nscm-if.routes} 에 등록된 serviceKey 는 SOAP 대신 nscm-if 로 보낸다
 * ({@link IfSendClient}). AS-IS 의 UIC0001.asmx 가 TO-BE 에 없고 nscm-if 가 그 역할을 REST 로
 * 대신하기 때문이다. 응답 형태({E_TYPE, E_MESSAGE})는 같아서 FE 계약은 바뀌지 않는다.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WebServiceCommonService {

    /** 말단 엘리먼트 추출용: <TAG>text</TAG> (중첩 없는 leaf 만). 네임스페이스 접두는 아래에서 제거. */
    private static final Pattern LEAF = Pattern.compile("<([A-Za-z_][\\w.:-]*)>([^<]*)</\\1>");

    private final WebServiceProperties webServiceProperties;
    private final WsdlCommonService wsdlCommonService;
    private final NscmIfProperties nscmIfProperties;
    private final IfSendClient ifSendClient;

    /**
     * @param serviceKey config.web-service.endpoints.&lt;serviceKey&gt;
     * @param params     SOAP body 파라미터(엘리먼트명:값)
     * @return 응답 말단 엘리먼트 Map (예: {E_TYPE=S, E_MESSAGE=})
     */
    public Map<String, String> call(String serviceKey, Map<String, Object> params) {
        // nscm-if 로 라우팅된 serviceKey 는 SOAP 을 타지 않는다(설정 한 줄로 SOAP 복귀 가능).
        if (nscmIfProperties.routes(serviceKey)) {
            return ifSendClient.send(nscmIfProperties.ifIdOf(serviceKey), params);
        }

        WebServiceProperties.Endpoint ep = webServiceProperties.getEndpoints().get(serviceKey);
        if (ep == null) {
            throw new IllegalArgumentException("등록되지 않은 web-service serviceKey: " + serviceKey);
        }

        // 그 환경에 연계 대상이 아직 없으면 전송하지 않고 성공만 돌려준다(화면 흐름을 막지 않기 위함).
        //   dev 는 ERP 인터페이스 구성 전까지 stub=true 다 — 실패를 내보내면 결재 다음 단계로 못 넘어간다.
        if (ep.isStub()) {
            log.info("web-service STUB serviceKey={} — 전송 생략, E_TYPE=S 반환. params={}", serviceKey, params);
            return erpIfCallTest(serviceKey, params);
        }

        Map<String, Object> safeParams = (params == null) ? Collections.emptyMap() : params;
        String soapAction = (ep.getSoapAction() == null || ep.getSoapAction().isEmpty())
                ? ep.getNamespace() : ep.getSoapAction();
        log.info("web-service call serviceKey={} endpoint={} method={} wrapper={}",
                serviceKey, ep.getEndpoint(), ep.getMethod(), ep.getWrapper());

        String xml = wsdlCommonService.callWsdl(
                ep.getEndpoint(), ep.getNamespace(), ep.getMethod(),
                ep.getWrapper(), soapAction, safeParams);
        return parseLeafElements(xml);
    }

    /**
     * 테스트용 Mock 호출 — 외부로 실제 전송하지 않고 실서비스와 동일한 형태의 응답을 파싱해 돌려준다.
     * 서비스(UIC0001.asmx) 완성 전 FE 배선 테스트용. 분기 테스트는 body 에 아래 키로 제어:
     *   _mockEType    : 응답 E_TYPE (기본 "S") — "E"/"F"/"C_E"/"S_E"
     *   _mockEMessage : 응답 E_MESSAGE (기본 "")
     */
    public Map<String, String> erpIfCallTest(String serviceKey, Map<String, Object> params) {
        WebServiceProperties.Endpoint ep = webServiceProperties.getEndpoints().get(serviceKey);
        if (ep == null) {
            throw new IllegalArgumentException("등록되지 않은 web-service serviceKey: " + serviceKey);
        }

        Map<String, Object> p = (params == null) ? Collections.emptyMap() : params;
        String eType = (p.get("_mockEType") != null) ? String.valueOf(p.get("_mockEType")) : "S";
        String eMessage = (p.get("_mockEMessage") != null) ? String.valueOf(p.get("_mockEMessage")) : "";
        String method = ep.getMethod();

        log.info("web-service CALL-TEST(mock) serviceKey={} method={} mockEType={} params={}",
                serviceKey, method, eType, p);

        // 실서비스(ASMX document/literal) 응답 payload 와 동일 형태로 구성 후 동일 파서로 파싱.
        String xml = "<" + method + "Response xmlns=\"" + ep.getNamespace() + "\">"
                + "<" + method + "Result>"
                + "<E_TYPE>" + eType + "</E_TYPE>"
                + "<E_MESSAGE>" + eMessage + "</E_MESSAGE>"
                + "</" + method + "Result>"
                + "</" + method + "Response>";
        return parseLeafElements(xml);
    }

    /** 응답 XML 의 말단 엘리먼트(<TAG>text</TAG>)를 {TAG:text} 로 추출. 네임스페이스 접두(prefix:)는 제거. */
    private static Map<String, String> parseLeafElements(String xml) {
        Map<String, String> map = new LinkedHashMap<>();
        if (xml == null || xml.isEmpty()) {
            return map;
        }
        Matcher m = LEAF.matcher(xml);
        while (m.find()) {
            String tag = m.group(1);
            int colon = tag.indexOf(':');
            if (colon >= 0) {
                tag = tag.substring(colon + 1);
            }
            map.put(tag, m.group(2).trim());
        }
        return map;
    }
}
