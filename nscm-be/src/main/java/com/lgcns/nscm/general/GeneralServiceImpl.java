package com.lgcns.nscm.general;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.utils.MapUtils;

import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes", "unchecked" })
@Service
public class GeneralServiceImpl extends BaseService implements GeneralService {

    private final String nameSpace = BaseConstants.MYBATIS_NAME_SPACE;

    /** 프로시저 결과커서(O_RESULT_CURSOR 등)의 에러 메시지 필드명 — 원시 DB 에러 마스킹 대상. */
    private static final Set<String> ERROR_MSG_KEYS =
            Set.of("MSG", "ERR_MESSAGE", "ERR_MSG", "ERROR_MESSAGE", "SQLERRM");
    /** 시스템 Oracle 에러코드 추출 패턴(ORA-NNNNN). 20000~20999 는 RAISE_APPLICATION_ERROR(업무 메시지)라 보존. */
    private static final Pattern ORA_CODE = Pattern.compile("ORA-(\\d{5})");

    /**
     * 버튼별 api 호출
     * @MethodName : retrieveProc
     * @Description: 메뉴별 버튼에 연결되 프로시저를 호출하는 함수
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param params
     * @param      : @return
     * @param      : @throws Exception
     */
    public Map<String, Object> execBtn(Map<String, Object> params) throws Exception {
    	// 메뉴ID와 버튼코드로 호출 api를 검색
    	List<Map<String, Object>> procParam = (List<Map<String, Object>>) selectList("retrieveBtnInfoList", params).get("procInfo");
    	// json형식의 데이터 타입을 DB입력값에 맞도록 변경하기 위한 구조
    	boolean isJvarchar = false;
    	Set<String> jCols = new HashSet<>();
    	for(Map<String, Object> paramMap:procParam) {
    		if(paramMap.get("DATA_TP_CD").equals("JVARCHAR")) {
    			isJvarchar = true;
    			jCols.add((String)paramMap.get("COL_NM"));
    		}
    	}
    	// 세션 정보 파라미터에 추가
    	if(isJvarchar) MapUtils.cvtJsonToJVarchar(params, jCols);
    	Map<String, Object> result = selectList("callProc", makeProcedure(params, procParam));
    	return maskRawDbErrors(result, (String) params.get("sesLangCd"));
    }

    /**
     * execBtn 의 스트리밍 변형 — BaseService.callProcStream(raw JDBC, ResultSet->JSON 단일패스)에 위임.
     */
    @Override
    public void execBtnStream(Map<String, Object> params, HttpServletResponse response) throws Exception {
    	callProcStream(params, response);
    }

    /**
     * api 호출
     * @MethodName : callProc
     * @Description:
     * @author     : story55
     * @date       : 2026. 2. 19.
     * @param      : @param params
     * @param      : @return
     * @param      : @throws Exception
     */
    public Map<String, Object> callProc(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> procParam = (List<Map<String, Object>>) selectList("retrieveProcInfoList", params).get("procInfo");
    	Map<String, Object> result = selectList("callProc", makeProcedure(params, procParam));
    	return maskRawDbErrors(result, (String) params.get("sesLangCd"));
    }

    /**
     * call-proc2 — 카탈로그 기반 프로시저 실행(SCM_ADM_PROC_M 파라미터 메타 미사용).
     * 프로시저명(PROC_NM=API_URL)만 기존 버튼->API_M 해석(retrieveBtnInfoList)에서 취하고,
     * IN/OUT 유도·바인딩은 BaseService.callProc2(살아있는 카탈로그)에 위임한다. 버튼권한(@AuthCheck)은 그대로.
     */
    @Override
    public Map<String, Object> callProc2(Map<String, Object> params) throws Exception {
    	List<Map<String, Object>> procInfo = (List<Map<String, Object>>) selectList("retrieveBtnInfoList", params).get("procInfo");
    	if (procInfo == null || procInfo.isEmpty() || procInfo.get(0).get("PROC_NM") == null) {
    		throw new Exception("call_proc2: cannot resolve PROC_NM for " + params.get("mnuId") + "/" + params.get("shtNm") + "/" + params.get("mnuBtnCd"));
    	}
    	String procNm = String.valueOf(procInfo.get(0).get("PROC_NM"));

    	Set<String> jCols = new HashSet<>();
    	Object cvt = params.get("cvtJsonToVarchar");
    	if (cvt != null && !String.valueOf(cvt).isBlank()) {
    		for (String c : String.valueOf(cvt).split(",")) {
    			if (!c.trim().isEmpty()) jCols.add(c.trim());
    		}
    	}
    	Map<String, Object> result = callProc2(procNm, params, jCols);
    	return maskRawDbErrors(result, (String) params.get("sesLangCd"));
    }

    /**
     * 프로시저 결과커서의 원시 DB 에러(SQLERRM/ORA-NNNNN)를 generic 문구로 치환한다(보안 — 스키마/제약조건/
     * 테이블/컬럼명·입력값이 클라이언트로 유출되는 것을 막는다). 원문은 서버 로그(log.error)에만 남긴다.
     *
     * 판별: 결과 Map 의 List 값(각 커서) 각 행에서 에러메시지 필드({@link #ERROR_MSG_KEYS})가 시스템 Oracle
     * 에러(ORA-NNNNN, 단 20000~20999 제외)를 포함하면 원시 DB 에러로 간주한다. 통제된 업무 에러(앱 코드
     * 99010/99020 친화 메시지, RAISE_APPLICATION_ERROR ORA-20xxx)는 메시지에 시스템 ORA 코드가 없으므로
     * 보존된다. CODE/ERR_CODE·행 식별자 필드는 그대로 둔다(FE 실패 판정·셀 색칠 로직 유지).
     */
    private Map<String, Object> maskRawDbErrors(Map<String, Object> result, String langCd) {
    	if (result == null) return result;
    	// MSG00003 (SCM_ADM_MSG_M 기준): KO="저장에 실패하였습니다." / EN·CN="Failed to save."
    	//   AS-IS SCP0005 는 raw 저장오류에 generic MSG00006 만 띄웠으나(원문 표시 라인 주석처리), MSG00006 은
    	//   TO-BE 미등록이라 등가 generic 코드 MSG00003 으로 대체한다. 메시지원문 drift 방지는 전역 공통 관리.
    	boolean english = "EN".equalsIgnoreCase(langCd) || "CN".equalsIgnoreCase(langCd);
    	String generic = english ? "Failed to save." : "저장에 실패하였습니다.";
    	for (Object cursor : result.values()) {
    		if (!(cursor instanceof List)) continue;
    		for (Object rowObj : (List<Object>) cursor) {
    			if (!(rowObj instanceof Map)) continue;
    			Map<String, Object> row = (Map<String, Object>) rowObj;
    			boolean raw = false;
    			for (String key : ERROR_MSG_KEYS) {
    				Object val = row.get(key);
    				if (val != null && isSystemOraError(String.valueOf(val))) { raw = true; break; }
    			}
    			if (!raw) continue;
    			log.error("[call-proc] 원시 DB 에러 마스킹: {}", row); // 원문은 서버에만 기록
    			for (String key : ERROR_MSG_KEYS) {
    				if (row.containsKey(key)) row.put(key, generic);
    			}
    		}
    	}
    	return result;
    }

    /** 메시지에 시스템 Oracle 에러코드(ORA-NNNNN, 20000~20999 제외)가 있으면 true. */
    private boolean isSystemOraError(String msg) {
    	Matcher m = ORA_CODE.matcher(msg);
    	while (m.find()) {
    		int code = Integer.parseInt(m.group(1));
    		if (code < 20000 || code > 20999) return true;
    	}
    	return false;
    }


    /**
     * 조회용 함수
	 * @MethodName : retrieveSql
	 * @Description: sql 조회용
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param params
	 * @param      : @return
     * @throws Exception
	 */
	@Override
	public Map<String, Object> retrieveSql(Map<String, Object> params) throws Exception {
		String queryId = params.get("business")+"."+params.get("subBusiness")+"."+params.get("api");
		return selectList(queryId, params);
	}

	/**
	 * 저장용 함수
	 * @MethodName : excuteSql
	 * @Description: sql 저장용
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param params
	 * @param      : @return
	 * @throws Exception
	 */
	@Override
	public int excuteSql(Map<String, Object> params) throws Exception {
		String queryId = params.get("business")+"."+params.get("subBusiness")+"."+params.get("api");
		return update(queryId, params);
	}

/*========================================================================================================================== */




}
