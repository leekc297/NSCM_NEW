	package com.lgcns.nscm.general;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.annotation.SystemLog.LogType;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.utils.NullUtils;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Tag(name = "1. SCM Business 공통 기능")
@SuppressWarnings({"rawtypes" })
@RestController
@RequiredArgsConstructor
public class GeneralController extends BaseController {

    private final GeneralService generalService;
    private final CommonProperties commonProperties;

    /**
     * @MethodName : callProc
     * @Description: 메뉴의 버튼별 연결 프로시저 호출 함수
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param params 전달파라미터
     * @param      : @param mnuId 메뉴아이디
     * @param      : @param mnuBtnCd 메뉴의버튼코드
     * @param      : @return
     * @param      : @throws Exception
     * @return     : ResponseEntity
     */
    @SystemLog(LogType.BUTTON)
    @AuthCheck(Type.ALL)
    @PostMapping(value="/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc", produces = "application/json; charset=UTF-8")
    public ResponseEntity callProc(@LoginUser UserSession userSession
    		, @RequestBody(required = false) Map<String, Object>  params
    		, @PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String mnuBtnCd
    		) throws Exception {
    	if(NullUtils.isNone(params)) params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("mnuBtnCd", mnuBtnCd);
    	// 배포 시스템 구분(config.system-cd) 고정 주입 — PROC_M 에 sesSystemCd IN 을 등록한 proc(SYS0003 GET 등)만 사용.
    	params.put("sesSystemCd", commonProperties.getSystemCd());
    	// 세션 언어 주입 — 저장 실패 시 원시 DB 에러 마스킹 문구(MSG00003)를 세션 언어로 내리는 데 사용(execBtn).
    	params.put("sesLangCd", userSession.getLangCd());
    	return successResponseEntity(generalService.execBtn(params));
    }

    /**
     * @MethodName : callProc2
     * @Description: 카탈로그 기반 프로시저 호출(SCM_ADM_PROC_M / procedures.d.ts 미참조) — 신규/개선 화면 점진 전환용.
     *   세션값은 여기서 고정 주입하여 FE 미전송 파라미터의 default 로 쓴다(오라클명 충돌 회피).
     */
    @SystemLog(LogType.BUTTON)
    @AuthCheck(Type.ALL)
    @PostMapping(value="/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc2", produces = "application/json; charset=UTF-8")
    public ResponseEntity callProc2(@LoginUser UserSession userSession
    		, @RequestBody(required = false) Map<String, Object>  params
    		, @PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String mnuBtnCd
    		) throws Exception {
    	if(NullUtils.isNone(params)) params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("mnuBtnCd", mnuBtnCd);
    	// 세션값 컨트롤러 고정 주입 (요청에 없는 파라미터의 default 로만 적용됨)
    	params.put("sesUserId", userSession.getUserId());
    	params.put("sesLangCd", userSession.getLangCd());
    	return successResponseEntity(generalService.callProc2(params));
    }

    /**
     * @MethodName : callProcStream
     * @Description: callProc 의 스트리밍 변형 — OUT 커서를 ResultSet -> JSON 으로 직접 스트리밍(단일 패스).
     *   응답 형태는 call-proc 와 동일({code,message,result}). 대용량 wide 결과(예: DMF0020) 검증용 실험 엔드포인트.
     *   주의: @SystemLog 미부착(응답 스트림 직접 쓰기와 로깅 aspect 충돌 방지).
     */
    @AuthCheck(Type.ALL)
    @PostMapping(value="/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc-stream", produces = "application/json; charset=UTF-8")
    public void callProcStream(@LoginUser UserSession userSession
    		, @RequestBody(required = false) Map<String, Object>  params
    		, @PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String mnuBtnCd
    		, HttpServletResponse response
    		) throws Exception {
    	if(NullUtils.isNone(params)) params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("mnuBtnCd", mnuBtnCd);
    	generalService.execBtnStream(params, response);
    }

    /**
     * @MethodName : retrieveGeneral
     * @Description: 일반적인 조회쿼리 실행 Controller
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param params
     * @param      : @param business
     * @param      : @param subBusiness
     * @param      : @return
     * @param      : @throws Exception
     * @return     : ResponseEntity
     */
    @PostMapping(value="/{business}/{subBusiness}/retrieve-general", produces = "application/json; charset=UTF-8")
    public ResponseEntity retrieveGeneral(@RequestBody(required = false) Map<String, Object>  params
    		, @PathVariable String business
    		, @PathVariable String subBusiness
    		) throws Exception {
    	if(NullUtils.isNone(params)) params = new HashMap<String, Object>();
    	params.put("business", business);
    	params.put("subBusiness", subBusiness);
    	return successResponseEntity(generalService.retrieveSql(params));
    }

    /**
     * @MethodName : excuteGeneral
     * @Description: 일반적인 저장쿼리 실행 Controller
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param params
     * @param      : @param business
     * @param      : @param subBusiness
     * @param      : @return
     * @param      : @throws Exception
     * @return     : ResponseEntity
     */
    @PostMapping(value="/{business}/{subBusiness}/excute-general", produces = "application/json; charset=UTF-8")
    public ResponseEntity excuteGeneral(@RequestBody(required = false) Map<String, Object>  params
    		, @PathVariable String business
    		, @PathVariable String subBusiness
    		) throws Exception {
    	if(NullUtils.isNone(params)) params = new HashMap<String, Object>();
    	params.put("business", business);
    	params.put("subBusiness", subBusiness);
    	return successResponseEntity(generalService.excuteSql(params));
    }

}
