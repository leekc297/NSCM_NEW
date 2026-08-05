package com.lgcns.nscm.admin.test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.menu.dto.MenuDto;
import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.handler.FileUploadTest;
import com.lgcns.nscm.framework.handler.MailHandler;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.general.GeneralService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Tag(name = "99. API 기능 테스트")
@Slf4j
@RestController
@RequestMapping
@RequiredArgsConstructor
public class TestController extends BaseController {

    private final SuccessTestService sucessTestService;
    private final ErrorTestService errorTestService;
    private final GeneralService generalService;
    private final MailHandler mailHandler;
    private final FileUploadTest fileUploadTest;

    @Operation(summary = "API exception test", description = "Exception test")
	@AuthCheck(Type.NONE)
    @GetMapping("/exception-test")
    public void exceptonTest() throws Exception {
//		throw new BusinessException("BusinessException message.");
		throw new SqlException();
    }

	@Operation(summary = "API Health Check", description = "API Health Check")
	@AuthCheck(Type.NONE)
    @GetMapping("/health-check")
    public ResponseEntity healthCheck(@RequestHeader(value = "X-Request-ID", required = false) String requestId) throws Exception {
		log.info("X-Request-ID : {}", requestId);
		return successResponseEntity((Object) "API is Listening!!");
    }

	@Operation(summary = "단건 조회", description = "단건 조회")
	@AuthCheck(Type.NONE)
    @GetMapping("/test/success/retrieveOne")
    public ResponseEntity<BaseResponse<MenuDto>> retrieveOne() throws Exception {
		return successResponseEntity(sucessTestService.retrieveOne());
    }

	@Operation(summary = "리스트 조회", description = "리스트 조회")
	@AuthCheck(Type.NONE)
	@GetMapping("/test/success/retrieveList")
    public ResponseEntity<BaseResponse<List<MenuDto>>> retrieveList() throws Exception {
        return successResponseEntity(sucessTestService.retrieveList());
    }

	@Operation(summary = "BadRequest", description = "(400) 유효성 검사 오류 - 형식 미준수, 필수값 누락, 타입 불일치 등")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/error/bad-request", produces = "application/json; charset=UTF-8")
    public ResponseEntity badRequest() throws Exception {
		return successResponseEntity(errorTestService.badRequest());
    }

	@Operation(summary = "Forbidden", description = "(403) 인가 실패 - 요청한 리소스에 접근할 권한이 없음")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/error/forbidden", produces = "application/json; charset=UTF-8")
    public ResponseEntity forbidden() throws Exception {
		return successResponseEntity(errorTestService.forbidden());
    }

	@Operation(summary = "Not Found", description = "(404) 요청한 리소스를 찾을 수 없음")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/error/not-found", produces = "application/json; charset=UTF-8")
    public ResponseEntity notFound() throws Exception {
		return successResponseEntity(errorTestService.notFound());
    }

	@Operation(summary = "Internal Server Error", description = "(500) API 서버 내부 오류")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/error/internal-server-error", produces = "application/json; charset=UTF-8")
    public ResponseEntity internalServerError() throws Exception {
		return successResponseEntity(errorTestService.internalServerError());
    }


	@Operation(summary = "DB 배열 입력값 테스트", description = "DB 배열 입력값 테스트")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/ora", produces = "application/json; charset=UTF-8")
    public ResponseEntity testOraTable() throws Exception {
		return successResponseEntity(sucessTestService.testOraTable());
    }

	@Operation(summary = "API 직접호출 ", description = "API 직접호출 테스트")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/api", produces = "application/json; charset=UTF-8")
    public ResponseEntity testAPi() throws Exception {
		Map<String, Object> testMap = new HashMap<String, Object>();
		testMap.put("apiId", "DMF0082_HEADER1");
		testMap.put("startDate", "20260219");
		testMap.put("endDate", "20260730");
		testMap.put("createdBy", "minyonglee1");
		testMap.put("divisionId", "40");
		return successResponseEntity(generalService.callProc(testMap));
    }

	@Operation(summary = "메일테스트 ", description = "메일테스트")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/email", produces = "application/json; charset=UTF-8")
    public void testEmail() throws Exception {
		mailHandler.sendEmail("story55@lgespartner.com", "story55@lgespartner.com", "yangsh2@lgespartner.com", "story55@lgespartner.com", "제목테스트", "내용테스트", "4B780E2F0364C778E06351DC220A67AB");
    }

	@Operation(summary = "파일업로드테스트 ", description = "파일업로드테스트")
	@AuthCheck(Type.NONE)
	@GetMapping(value = "/test/uploadFile", produces = "application/json; charset=UTF-8")
    public void testUploadFile() throws Exception {
		fileUploadTest.testFileUpload();
    }

//	@Operation(summary = "메뉴 버튼 권한 test1", description = "메뉴 버튼 권한 test1")
//	@AuthCheck(Type.ALL)
//	@PostMapping(value = "/DMF0082/SAVE/call-proc", produces = "application/json; charset=UTF-8")
//    public ResponseEntity checkMenuBtnAuthTest1() throws Exception {
//		return successResponseEntity();
//    }
//
//	@Operation(summary = "메뉴 버튼 권한 test2", description = "메뉴 버튼 권한 test2")
//	@AuthCheck(Type.ALL)
//	@PostMapping(value = "/DMF0082/SEARCH/call-proc", produces = "application/json; charset=UTF-8")
//    public ResponseEntity checkMenuBtnAuthTest2() throws Exception {
//		return successResponseEntity();
//    }
//
//	@Operation(summary = "메뉴 버튼 권한 test3", description = "메뉴 버튼 권한 test3")
//	@AuthCheck(Type.ALL)
//	@PostMapping(value = "/DMF0082/UNDEFINED/call-proc", produces = "application/json; charset=UTF-8")
//    public ResponseEntity checkMenuBtnAuthTest3() throws Exception {
//		return successResponseEntity();
//    }

}
