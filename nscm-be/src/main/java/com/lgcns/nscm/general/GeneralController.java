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
import com.lgcns.nscm.framework.utils.NullUtils;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Tag(name = "1. SCM Business 공통 기능")
@SuppressWarnings({"rawtypes" })
@RestController
@RequiredArgsConstructor
public class GeneralController extends BaseController {

    private final GeneralService generalService;

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
    	return successResponseEntity(generalService.execBtn(params));
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
