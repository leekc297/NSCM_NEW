package com.lgcns.nscm.framework.webservice;

import java.util.Map;

import javax.xml.transform.Source;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.xml.transform.StringResult;
import org.springframework.xml.transform.StringSource;

@Service
public class WsdlCommonService {

    @Autowired
    private WebServiceTemplate webServiceTemplate;

    /**
     * 공통 WSDL 호출 메서드
     * @param endpoint 서버 주소
     * @param namespace XML 네임스페이스
     * @param methodName 호출할 메서드명
     * @param params 입력 데이터 MapWsdlCommonService
     */
    public String callWsdl(String endpoint, String namespace, String methodName, Map<String, Object> params) {

    	StringResult responseResult = new StringResult();
    	StringBuilder xmlReq = new StringBuilder();

    	try {
	        // 1. 동적 SOAP Request XML 생성 (String 기반 빌드)
	        xmlReq.append("<")
	              .append(methodName)
	              .append(" xmlns=\"")
	              .append(namespace)
	              .append("\">");

	        params.forEach((key, value) -> {
	            xmlReq.append("<").append(key).append(">")
	                  .append(value)
	                  .append("</").append(key).append(">");
	        });

	        xmlReq.append("</").append(methodName).append(">");

	        // 2. 전송 준비
	        Source requestPayload = new StringSource(xmlReq.toString());


	        // 3. WebServiceTemplate을 통한 호출
	        webServiceTemplate.sendSourceAndReceiveToResult(endpoint, requestPayload, responseResult);

	        // 4. 결과 XML 반환 (이후 XML 파서를 통해 Map으로 변환 가능)
    	} catch (Exception e) {
    		//
		}
//    	System.out.println("wsdlREQ>>>:  "+xmlReq.toString());
//    	System.out.println("wsdlTest>>>:  "+responseResult.toString());

    	return responseResult.toString();
    }
}
