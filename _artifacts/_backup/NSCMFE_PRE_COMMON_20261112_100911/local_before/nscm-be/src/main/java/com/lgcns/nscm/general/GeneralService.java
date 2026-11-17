package com.lgcns.nscm.general;

import java.util.Map;

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
	 * 버튼별 api 호출 — 스트리밍(대량 조회용)
	 * @MethodName : execBtnStream
	 * @Description: execBtn 과 같은 메타(SCM_ADM_MNU_BTN_MPG_M → API_M → PROC_M)로 프로시저를 찾아 실행하고,
	 *               OUT 커서를 읽는 즉시 묶음 단위 NDJSON 으로 내보낸다. 메타 해석은 호출 스레드에서 끝내고
	 *               실행·전송은 반환한 StreamingResponseBody 안에서 한다. [E20261015-STREAMPROC]
	 * @param      : @param params (mnuId/shtNm/mnuBtnCd/sesUserId/sesLangCd 포함)
	 * @return     : StreamingResponseBody
	 */
	org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody execBtnStream(Map<String, Object> params) throws Exception;

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
