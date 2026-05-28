package com.lgcns.nscm.admin.webservice;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.webservice.WsdlCommonService;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;

/**
 * Webservice 를 위한 controller
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.webservice
 * @FileName : WebServiceController.java
 * @author   : story55
 * @date     : 2026. 3. 5.
 * @description : WebServiceController
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 3. 5.        story55       최초 생성
 */
@Tag(name = "6. webservice 기능")
@Slf4j
@RestController
public class WebServiceController extends BaseController {

	@Autowired
	WsdlCommonService wsdlCommonService;

	@PostMapping("/api/wsdl/send")
	public ResponseEntity<BaseResponse> sendWsdlData(@RequestBody Map<String, Object> requestData) {
	    String resultXml = wsdlCommonService.callWsdl(
	        "http://xxx.com/service",
	        "http://namespace.uri",
	        "MM0501_SSPX_SOService",
	        requestData
	    );

	    // 성공 응답 반환 (GlobalExceptionHandler가 에러를 관리함)
	    return ResponseEntity.ok(new BaseResponse("200", "SUCCESS", resultXml));
	}




}
