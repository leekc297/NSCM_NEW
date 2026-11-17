package com.lgcns.nscm.framework.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.soap.SoapVersion;
import org.springframework.ws.soap.saaj.SaajSoapMessageFactory;

@Configuration
public class WebServiceConfig {

    @Bean
    public WebServiceTemplate webServiceTemplate() {
        WebServiceTemplate webServiceTemplate = new WebServiceTemplate();

        // SOAP 메시지 팩토리 설정 (기본적으로 SAAJ 사용)
        webServiceTemplate.setMessageFactory(messageFactory());

        // 타임아웃 설정을 추가하고 싶다면 아래 주석을 참고하세요
        // HttpComponentsMessageSender 등을 사용하여 연결/응답 타임아웃 지정 가능

        return webServiceTemplate;
    }

    @Bean
    public SaajSoapMessageFactory messageFactory() {
        SaajSoapMessageFactory messageFactory = new SaajSoapMessageFactory();

        // SOAP 1.1 — AS-IS ERP ASMX(UIC0001/UIC0003, WsiProfiles.BasicProfile1_1)와 규약 일치.
        //   (종전 SOAP_12 는 ASMX document/literal 서비스와 버전 불일치로 호출 실패 위험이었음.)
        messageFactory.setSoapVersion(SoapVersion.SOAP_11);
        return messageFactory;
    }
}
