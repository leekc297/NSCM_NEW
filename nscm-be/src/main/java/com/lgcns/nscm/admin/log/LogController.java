	package com.lgcns.nscm.admin.log;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lgcns.nscm.admin.log.dto.LogDto;
import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
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


}
