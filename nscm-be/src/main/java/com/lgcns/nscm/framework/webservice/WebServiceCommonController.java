package com.lgcns.nscm.framework.webservice;

import java.util.Collections;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 외부 웹서비스(SOAP) 공통 호출 컨트롤러.
 *
 * FE 가 serviceKey + 파라미터만 보내면, BE 가 환경별 config 의 URL 로 외부 웹서비스를 호출해 응답을 돌려준다.
 * (예: ERP(SAP PI) 출하확정 I/F — serviceKey=erpIf, params={CHANGE_REQ_NO, CHANGE_TYPE, SHIPMENT_STATUS})
 */
@Slf4j
@Tag(name = "공통 - 외부 웹서비스 호출")
@RestController
@RequiredArgsConstructor
public class WebServiceCommonController extends BaseController {

    private final WebServiceCommonService webServiceCommonService;

    @Operation(summary = "외부 웹서비스(SOAP) 공통 호출",
            description = "serviceKey 로 config(web-service.endpoints)의 엔드포인트를 선택해 파라미터를 전송하고 응답 XML 을 반환합니다.")
    @PostMapping(value = "/common/web-service/{serviceKey}/call", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Map<String, String>>> call(
            @PathVariable String serviceKey,
            @RequestBody(required = false) Map<String, Object> params) throws Exception {
        return successResponseEntity(
                webServiceCommonService.call(serviceKey, params == null ? Collections.emptyMap() : params));
    }
}
