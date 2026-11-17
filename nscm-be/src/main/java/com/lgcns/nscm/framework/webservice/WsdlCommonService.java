package com.lgcns.nscm.framework.webservice;

import java.util.Map;

import javax.xml.transform.Source;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.SoapMessage;
import org.springframework.xml.transform.StringResult;
import org.springframework.xml.transform.StringSource;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class WsdlCommonService {

    @Autowired
    private WebServiceTemplate webServiceTemplate;

    /**
     * 공통 WSDL 호출 메서드(래퍼/SOAPAction 없는 평면 호출) — 하위호환 유지.
     */
    public String callWsdl(String endpoint, String namespace, String methodName, Map<String, Object> params) {
        return callWsdl(endpoint, namespace, methodName, null, null, params);
    }

    /**
     * 공통 WSDL(SOAP) 호출 — AS-IS ASMX 규약 일치용(래퍼 복합타입 + SOAPAction).
     *
     * @param endpoint   서버 주소
     * @param namespace  XML 네임스페이스
     * @param methodName 호출할 메서드명(SOAP body 루트)
     * @param wrapper    파라미터를 감쌀 복합타입 엘리먼트명(예: UIC0001_CALL_FROM_SSPUI). null/빈값이면 평면.
     * @param soapAction SOAPAction HTTP 헤더. null/빈값이면 설정 안 함.
     * @param params     입력 데이터 Map(엘리먼트명:값)
     * @return 응답 XML 문자열
     */
    public String callWsdl(String endpoint, String namespace, String methodName,
            String wrapper, String soapAction, Map<String, Object> params) {

        StringResult responseResult = new StringResult();
        StringBuilder xmlReq = new StringBuilder();
        boolean useWrapper = wrapper != null && !wrapper.isEmpty();

        try {
            // 1. 동적 SOAP Request XML 생성
            xmlReq.append("<").append(methodName).append(" xmlns=\"").append(namespace).append("\">");
            if (useWrapper) {
                xmlReq.append("<").append(wrapper).append(">");
            }
            if (params != null) {
                params.forEach((key, value) ->
                    xmlReq.append("<").append(key).append(">")
                          .append(value)
                          .append("</").append(key).append(">"));
            }
            if (useWrapper) {
                xmlReq.append("</").append(wrapper).append(">");
            }
            xmlReq.append("</").append(methodName).append(">");

            Source requestPayload = new StringSource(xmlReq.toString());

            // 2. SOAPAction 헤더를 세팅하며 호출(없으면 payload 만 전송)
            webServiceTemplate.sendSourceAndReceiveToResult(endpoint, requestPayload,
                message -> {
                    if (soapAction != null && !soapAction.isEmpty() && message instanceof SoapMessage) {
                        ((SoapMessage) message).setSoapAction(soapAction);
                    }
                },
                responseResult);

        } catch (Exception e) {
            // 호출 실패 — 빈 결과 반환(호출부 판단). 기존 동작 유지하되 원인은 로그로 남긴다.
            log.warn("callWsdl 실패 endpoint={} method={} : {}", endpoint, methodName, e.getMessage());
        }

        return responseResult.toString();
    }
}
