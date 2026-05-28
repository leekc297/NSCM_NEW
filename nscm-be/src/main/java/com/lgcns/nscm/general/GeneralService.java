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
