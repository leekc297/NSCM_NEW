package com.lgcns.nscm.admin.lookup;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.annotation.SystemLog.LogType;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * lookup 기능을 제공하는 Controller
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.lookup
 * @FileName : LookupController.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : LookupController
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Tag(name = "4. lookup 기능")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
public class LookupController extends BaseController {

	private final LookupService lookupService;

	@SystemLog(LogType.LOOKUP)
	@Operation(summary = "lookup 테이블 조회", description = "lookup 데이터를 조회합니다."
			+ "\r\n데이터 샘플 {\r\n"
			+ "  \"lookupType\": \"INPUT_TP_CD\"\r\n"
			+ "}")
	@PostMapping(value="lookup", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Map<String, Object>>>> retrieveLookkup(
    		@LoginUser UserSession userSession
    	  , @RequestBody(required = false) Map<String, Object>  params) throws Exception {

		if(params == null || !params.containsKey("lookupType")) throw new BusinessException(BaseConstants.BUSINESS_ERROR, "The required input value [lookupType] is missing.");
		List<Map<String, Object>> result = (List<Map<String, Object>>) lookupService.retrieveLookup(params).get(params.get("lookupType").toString());
        return successResponseEntity(result);
    }

	@SystemLog(LogType.LOOKUP)
	@Operation(summary = "lookup 테이블 조회", description = "다건의 lookup 데이터를 조회합니다."
			+ "\r\n데이터 샘플 {\r\n"
			+ "  \"lookupType\": \"INPUT_TP_CD,MNU_TP_CD\"\r\n"
			+ "}")
	@PostMapping(value="lookup-muti", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Map<String, Object>>> retrieveLookkupMuti(
    		@LoginUser UserSession userSession
    	  , @RequestBody(required = false) Map<String, Object>  params) throws Exception {
		if(params == null || !params.containsKey("lookupType")) throw new BusinessException(BaseConstants.BUSINESS_ERROR, "The required input value [lookupType] is missing.");
        return successResponseEntity(lookupService.retrieveLookup(params));
    }

	@SystemLog(LogType.COMBO)
	@Operation(summary = "combo용 다이나믹 쿼리 데이터 조회", description = "combo 데이터를 조회합니다."
			+ "\r\n데이터 샘플 {\r\n"
			+ "  \"comboId\": \"MyDivision\"\r\n"
			+ "}")
	@PostMapping(value="combo", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Map<String, Object>>>> retrieveCombo(
    			@RequestBody(required = false) Map<String, Object>  params) throws Exception {
		if (params == null || !params.containsKey("comboId")) throw new BusinessException(BaseConstants.BUSINESS_ERROR, "The required input value [comboId] is missing.");
		List<Map<String, Object>> result = (List<Map<String, Object>>) lookupService.retrieveCombo(params).get(params.get("comboId").toString());
        return successResponseEntity(result);
    }

	@SystemLog(LogType.COMBO)
	@Operation(summary = "combo용 다이나믹 쿼리 데이터 조회", description = "다건의 combo 데이터를 조회합니다."
			+ "\r\n데이터 샘플  { \"comboList\": [{\"comboId\": \"MyDivision\"}, {\"comboId\": \"Company\"},  { \"comboId\": \"SystemLookup\", \"lookupType\":\"'MNU_TP_CD'\" }] }")
	@PostMapping(value="combo-muti", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Map<String, Object>>> retrieveComboMuti(
    			@RequestBody(required = false) Map<String, Object>  params) throws Exception {
        return successResponseEntity(lookupService.retrieveComboMuti(params));
    }

}
