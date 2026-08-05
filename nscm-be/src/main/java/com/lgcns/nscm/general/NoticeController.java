package com.lgcns.nscm.general;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.general.GeneralService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 홈 화면 공지사항.
 *
 * <p>관리자 공지관리(SYS0016)의 조회 프로시저를 그대로 재사용해 활성(ACTIVE) 공지를 반환한다.
 * 공용 {@code /call-proc} 경로는 메뉴-버튼 권한(SYS0016)을 요구하므로 일반 사용자·게스트 홈에서는 403 이 된다.
 * 홈 공지는 로그인한 모든 사용자에게 보여야 하므로, 메뉴 권한이 아닌 {@link Type#LOGIN} 만 요구하는 전용 경로로 노출한다.
 */
@Slf4j
@Tag(name = "Notice(Home)")
@RestController
@RequiredArgsConstructor
public class NoticeController extends BaseController {

	/** 재사용하는 관리자 공지관리 프로시저 좌표 (SYS0016 / main / SEARCH). */
	private static final String NOTICE_MENU_ID = "SYS0016";
	private static final String NOTICE_SHEET_NM = "main";
	private static final String NOTICE_SEARCH_BTN = "SEARCH";

	private final GeneralService generalService;

	@Operation(summary = "홈 화면 공지 조회",
			description = "로그인 사용자 홈 화면에 노출할 활성(ACTIVE) 공지를 조회한다. "
					+ "관리자 공지관리(SYS0016) 조회 프로시저를 재사용하되, 메뉴 권한이 아닌 로그인만 요구한다. "
					+ "노출 개수 제한/정렬은 FE 에서 처리한다.")
	@AuthCheck(Type.LOGIN)
	@GetMapping(value = "/notice/home", produces = "application/json; charset=UTF-8")
	public ResponseEntity<BaseResponse<Map<String, Object>>> retrieveHomeNotices() throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("mnuId", NOTICE_MENU_ID);
		params.put("shtNm", NOTICE_SHEET_NM);
		params.put("mnuBtnCd", NOTICE_SEARCH_BTN);
		// 관리자 조회 화면과 동일한 검색 파라미터 (전체 모듈 + 활성만)
		params.put("module", "ALL");
		params.put("subModule", "ALL");
		params.put("activeYn", "Y");
		return successResponseEntity(generalService.execBtn(params));
	}
}
