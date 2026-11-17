	package com.lgcns.nscm.admin.log;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.f4b6a3.ulid.UlidCreator;
import com.lgcns.nscm.admin.log.dto.LogDto;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.interceptor.LogInterceptor;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Tag(name = "5. log 관련 Controller")
@SuppressWarnings({"rawtypes" })
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/log")
public class LogController extends BaseController {

    private final LogService logService;
    private final LogInterceptor logInterceptor;

    @Operation(summary = "System Log 조회", description = "System Log 데이터를 조회합니다.")
	@PostMapping(value="common", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<LogDto>>> retrieveLog(
    		@LoginUser UserSession userSession
    	  , @RequestBody(required = false) Map<String, Object>  params) throws Exception {
		params.put("userId", userSession.getUserId());
		params.put("langCd", userSession.getLangCd());
        return successResponseEntity(logService.retrieveLog(params));
    }

    /**
     * front 최종 로그 시간 업데이트
     * @MethodName : logBack
     * @Description:
     <p><b>Usage Example:</b></p>
     * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 19.
     * @param      : @param ULID
     * @param      : @throws Exception
     * @return     : void
     */
    @GetMapping(value="/{ULID}/log-back" , produces = "application/json; charset=UTF-8")
    public void logBack(@PathVariable String ULID) throws Exception {
    	logService.logBack(ULID);
    }

    /**
     * 메뉴 접속 로그. 사용자가 메뉴(화면)를 최초로 열 때 FE(useMDIStore.openTab)가 1회 호출한다.
     * SSO LOGIN 적재와 동일하게 명시적 insert 로 처리한다 — @SystemLog 를 붙이면 LogInterceptor.afterCompletion
     * 이 MENU 타입을 한 번 더 적재해 중복되므로 애너테이션은 쓰지 않는다. 적재 실패가 응답을 막지 않는다.
     */
    @Operation(summary = "메뉴 접속 로그", description = "메뉴(화면) 최초 오픈 시 접속 로그를 기록합니다.")
    @PostMapping(value="menu-access", produces = "application/json; charset=UTF-8")
    public void menuAccess(
    		@LoginUser UserSession userSession
    	  , @RequestBody(required = false) Map<String, Object> params
    	  , HttpServletRequest request) {
    	String mnuId = (params == null || params.get("mnuId") == null) ? null : params.get("mnuId").toString();
    	if (mnuId == null || mnuId.isEmpty()) return;
    	recordMenuAccessLog(userSession, request, mnuId);
    }

    /** SystemLogAspect 의 LOGIN 분기와 동일한 logParam 구성으로 MENU 로그를 적재한다. */
    private void recordMenuAccessLog(UserSession userSession, HttpServletRequest request, String mnuId) {
    	try {
    		Timestamp ts = new Timestamp(System.currentTimeMillis());
    		Map<String, Object> logParam = new HashMap<>();
    		logParam.put("traceId", UlidCreator.getUlid().toString());
    		logParam.put("userId", userSession != null ? userSession.getUserId() : null);
    		logParam.put("typeCd", "MENU");
    		logParam.put("requestUrl", "MENU");
    		logParam.put("clientIp", logInterceptor.getClientIp(request));
    		logParam.put("menuId", mnuId);
    		logParam.put("clientStTm", ts);
    		logParam.put("serverStTm", ts);
    		logParam.put("sqlStTm", ts);
    		logParam.put("sqlEdTm", ts);
    		logParam.put("serverEdTm", ts);
    		logParam.put("clientEdTm", ts);
    		logInterceptor.insertSystemLog(logParam);
    	} catch (Exception e) {
    		log.warn("메뉴 접속 로그 적재 실패. {}", e.getMessage());
    	}
    }

}
