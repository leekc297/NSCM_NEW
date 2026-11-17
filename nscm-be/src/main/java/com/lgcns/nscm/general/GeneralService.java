package com.lgcns.nscm.general;

import java.util.Map;

import jakarta.servlet.http.HttpServletResponse;

public interface GeneralService {

	/**
	 * api 호출
	 * @MethodName : retrieveProc
	 * @Description: 프로시저 호출처리
	 * @author     : story55
	 * @date       : 2026. 1. 21.
	 * @param      : @param params
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : Map<String,Object>
	 */
	Map<String, Object> callProc(Map<String, Object> params) throws Exception;

	/**
	 * call-proc2 — SCM_ADM_PROC_M / procedures.d.ts 미참조, 살아있는 Oracle 카탈로그(ALL_ARGUMENTS)로
	 * IN/OUT 을 유도해 실행하는 신규 경로(점진 전환용). 프로시저명은 기존 버튼->API_M 해석을 재사용한다.
	 * @param      : @param params (mnuId/shtNm/mnuBtnCd + 업무값 + 선택 cvtJsonToVarchar)
	 * @return     : Map<String,Object> 커서키(o_rc1..)/스칼라OUT 을 담은 result
	 */
	Map<String, Object> callProc2(Map<String, Object> params) throws Exception;

	/**
	 * 버튼별 api 호출
	 * @MethodName : execBtn
	 * @Description: 프로시저 호출처리
	 * @author     : story55
	 * @date       : 2026. 2. 19.
	 * @param      : @param params
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : Map<String,Object>
	 */
	Map<String, Object> execBtn(Map<String, Object> params) throws Exception;

	/**
	 * 버튼별 api 호출 (스트리밍) — OUT 커서를 ResultSet -> JSON 으로 직접 스트리밍(단일 패스, CustomMap 미생성).
	 * 응답은 execBtn 과 동일한 { code, message, result:{ 커서키:[..], 스칼라OUT:val } } 형태를 응답 스트림에 직접 쓴다.
	 */
	void execBtnStream(Map<String, Object> params, HttpServletResponse response) throws Exception;

	/**
	 *  select 처리
	 * @MethodName : retrieveSql
	 * @Description: 쿼리ID(param.api)를 이용한 select 처리
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param params 에 api 값 필수
	 * @param      : @return
	 * @return     : Map<String,Object>
	 */
	Map<String, Object> retrieveSql(Map<String, Object> params) throws Exception;

	/**
	 * insert/update/delete 처리
	 * @MethodName : excuteSql
	 * @Description: 쿼리ID(param.api)를 이용한 insert/update/delete 처리
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param params 에 api 값 필수
	 * @param      : @return
	 * @return     : int
	 */
	int excuteSql(Map<String, Object> params) throws Exception;

}
