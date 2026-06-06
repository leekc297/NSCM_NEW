package com.lgcns.nscm.master.bod;

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
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.master.bod.dto.BodRequest;
import com.lgcns.nscm.master.bod.service.BodService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * DMF0015 BOD (Bill of Delivery) Controller — Phase 6 PoC (보완 6)
 *
 * AS-IS: GSCM.DM.Master.UIL.DM0015_BOD + DM.DM0015_GET_BOD_DATA / SAVE_BOD_DATA SP
 * 룰: Doc/_rules_v2/_tobe/11_be_controller_service.md
 *
 * 표준 적용:
 * - @RestController + @RequiredArgsConstructor (필드 주입 X)
 * - @LoginUser UserSession (BE 자동 user_id 주입)
 * - @SystemLog (자동 로깅)
 * - successResponseEntity(data) — ResponseEntity 직접 작성 X
 *
 * 엔드포인트:
 * - POST /master/bod/main/retrieve   (Main 조회)
 * - POST /master/bod/main/save       (Main 저장)
 * - POST /master/bod/bod-item/retrieve (Sub 조회)
 * - POST /master/bod/bod-item/save     (Sub 저장)
 *
 * → 동적 SP 호출 표준에 따라 SCM_ADM_API_M 의 매핑 (DMF0015/main/RETRIEVE 등) 으로 라우팅됨.
 *   본 Controller 는 명시 endpoint 가 별도 필요한 경우 — 동적 라우팅으로 충분 시 생략 가능.
 *
 * ⚠️ NSCM 의 동적 SP 호출 아키텍처 (룰 11 §4): 본 Controller 는 SCM_ADM_API_M 메타가 충분히
 *    구성되어 있으면 별도 명시 endpoint 불필요. 본 파일은 명시 endpoint 가 필요한 경우의 reference.
 */
@Slf4j
@Tag(name = "DMF0015 BOD Master")
@RestController
@RequiredArgsConstructor
@RequestMapping("/master/bod")
public class BodController extends BaseController {

    private final BodService bodService;

    @SystemLog(LogType.RETRIEVE)
    @Operation(summary = "BOD Main 조회", description = "DMF0015 BOD Master 데이터 조회")
    @PostMapping(value = "/main/retrieve", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Map<String, Object>>>> retrieveMain(
        @LoginUser UserSession userSession,
        @RequestBody BodRequest request
    ) throws Exception {
        return successResponseEntity(bodService.retrieveMain(userSession, request));
    }

    @SystemLog(LogType.SAVE)
    @Operation(summary = "BOD Main 저장", description = "DMF0015 BOD Master 데이터 저장")
    @PostMapping(value = "/main/save", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Void>> saveMain(
        @LoginUser UserSession userSession,
        @RequestBody BodRequest request
    ) throws Exception {
        bodService.saveMain(userSession, request);
        return successResponseEntity();
    }

    @SystemLog(LogType.RETRIEVE)
    @Operation(summary = "BOD Item 조회", description = "DMF0015 BOD Item (Sub) 데이터 조회")
    @PostMapping(value = "/bod-item/retrieve", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Map<String, Object>>>> retrieveBodItem(
        @LoginUser UserSession userSession,
        @RequestBody BodRequest request
    ) throws Exception {
        return successResponseEntity(bodService.retrieveBodItem(userSession, request));
    }

    @SystemLog(LogType.SAVE)
    @Operation(summary = "BOD Item 저장", description = "DMF0015 BOD Item (Sub) 데이터 저장")
    @PostMapping(value = "/bod-item/save", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<Void>> saveBodItem(
        @LoginUser UserSession userSession,
        @RequestBody BodRequest request
    ) throws Exception {
        bodService.saveBodItem(userSession, request);
        return successResponseEntity();
    }
}
