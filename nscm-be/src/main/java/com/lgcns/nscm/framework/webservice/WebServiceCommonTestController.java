package com.lgcns.nscm.framework.webservice;

import java.util.Collections;
import java.util.Map;

import org.springframework.http.ResponseEntity;
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
 * 외부 웹서비스 호출 - 테스트(Mock) 전용 컨트롤러.
 *
 * 운영용 {@link WebServiceCommonController}(실제 전송)와 분리해, 실서비스(UIC0001.asmx) 완성 전
 * FE 배선/동작 테스트에만 쓴다. serviceKey 는 ERP I/F(erpIf) 로 고정 — 테스터는 URL/serviceKey 신경쓸 필요 없이
 * 이 엔드포인트만 호출하면 실서비스와 동일한 형태의 모의 응답(E_TYPE/E_MESSAGE)을 받는다.
 * 실제 전송은 하지 않으므로 config endpoint(URL) 미정이어도 동작한다.
 */
@Slf4j
@Tag(name = "공통 - 외부 웹서비스 호출(테스트)")
@RestController
@RequiredArgsConstructor
public class WebServiceCommonTestController extends BaseController {

    private final WebServiceCommonService webServiceCommonService;

    @Operation(summary = "ERP I/F 테스트(Mock) 호출",
            description = "실제 전송 없이 실서비스와 동일한 형태의 모의 응답(E_TYPE/E_MESSAGE)을 반환합니다. "
                    + "serviceKey 는 erpIf 고정. body._mockEType('E'/'F'/'C_E'/'S_E') 로 분기 테스트.")
    @PostMapping(value = "/common/web-service/erpIf/call-test", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Map<String, String>>> erpIfCallTest(
            @RequestBody(required = false) Map<String, Object> params) throws Exception {
        return successResponseEntity(
                webServiceCommonService.erpIfCallTest("erpIf", params == null ? Collections.emptyMap() : params));
    }
}
