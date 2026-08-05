package com.lgcns.nscm.admin.dynamicquery;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.auth.AuthService;
import com.lgcns.nscm.admin.dynamicquery.dto.DynamicQueryExecuteRequest;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Tag(name = "Dynamic Query(SYS0013)")
@RestController
@RequiredArgsConstructor
public class DynamicQueryController extends BaseController {

	private static final String MENU_ID = "SYS0013";
	private static final String SHEET_NM = "result";
	private static final String BTN_CD = "EXECUTE";

	private final DynamicQueryService dynamicQueryService;
	private final AuthService authService;

	@Operation(summary = "Dynamic Query 실행(컬럼 순서 보존)",
			description = "사용자 SQL 을 실행하되 SELECT projection 순서를 보존하여 결과를 반환합니다. FE SQL 검증 팝업 전용.")
	@AuthCheck(Type.LOGIN)
	@PostMapping(value = "/admin/dynamic-query/execute", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Map<String, Object>>> executeQuery(
			@LoginUser UserSession userSession,
			@RequestBody DynamicQueryExecuteRequest dto) throws Exception {

		// 공용 call-proc 경로와 동일한 버튼 단위 권한 확인 (SYS0013 / result / EXECUTE)
		boolean hasBtnAuth = authService.checkMenuBtnAuth(userSession.getUserId(), MENU_ID, SHEET_NM, BTN_CD);
		if (!hasBtnAuth) {
			throw new AccessDeniedException("Dynamic Query 실행 권한 없음");
		}

		return successResponseEntity(dynamicQueryService.executeQuery(dto.getSqlText()));
	}

	@Operation(summary = "Dynamic Query 검증(구문 + 컬럼 스키마)",
			description = "사용자 SQL 을 실행하지 않고 DBMS_SQL.PARSE 로 구문을 검증한 뒤, 결과 컬럼 스키마(이름/타입)를 반환합니다. "
					+ "데이터를 스캔하지 않아 파라미터 토큰을 값으로 채우지 않아도 되고 0행이어도 컬럼이 나옵니다. FE SQL 검증 팝업(Confirm) 전용.")
	@AuthCheck(Type.LOGIN)
	@PostMapping(value = "/admin/dynamic-query/validate", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Map<String, Object>>> validateQuery(
			@LoginUser UserSession userSession,
			@RequestBody DynamicQueryExecuteRequest dto) throws Exception {

		// 검증도 실행과 동일한 버튼 단위 권한(EXECUTE) 시맨틱을 유지한다.
		boolean hasBtnAuth = authService.checkMenuBtnAuth(userSession.getUserId(), MENU_ID, SHEET_NM, BTN_CD);
		if (!hasBtnAuth) {
			throw new AccessDeniedException("Dynamic Query 검증 권한 없음");
		}

		return successResponseEntity(dynamicQueryService.validateQuery(dto.getSqlText()));
	}
}
