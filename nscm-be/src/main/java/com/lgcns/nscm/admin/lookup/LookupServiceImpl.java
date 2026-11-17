package com.lgcns.nscm.admin.lookup;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * lookup 기능을 제공하는 Service
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.admin.lookup
 * @FileName : LookupServiceImpl.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : LookupServiceImpl
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LookupServiceImpl extends BaseService implements LookupService {


	/**
	 * 공통 lookup 조회 함수
	 * @MethodName : retrieveLookup
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param params
	 * @param      : @return
	 * @param      : @throws Exception
	 */
	@Override
	public Map<String, Object> retrieveLookup(Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		if (params != null && params.containsKey("lookupType")) {
			for(String type:params.get("lookupType").toString().split(",")) {
				params.put("type", type);
				result.put(type, selectList("admin.lookup.retrieveLookup", params).get(DEFAULT_DATA_RESULT));
			}
		}
		return result;
	}

	/**
	 * 공통 combo 데이터 조회 함수
	 * @MethodName : retrieveLookkupCombo
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 2. 12.
	 * @param      : @param params
	 * @param      : @return
	 * @param      : @throws Exception
	 */
	@Override
	public Map<String, Object> retrieveCombo(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		if(params == null || NullUtils.isNone(params.get("comboId")) == true) throw new BusinessException("The required input value [comboId] is missing.");
		Map<String, Object> queryMap = selectList("admin.lookup.getQuery", params);
		if(NullUtils.isNone(queryMap.get(DEFAULT_DATA_RESULT))) throw new BusinessException("Query is not exist.");

		params.put("sesUserId", "'"+SecurityUtil.getUserSession().getUserId()+"'");
		params.put("sesLangCd", "'"+SecurityUtil.getUserSession().getLangCd()+"'");
		// mnuId 는 FE 가 raw 로 보내므로 @sesUserId 처럼 여기서 홑따옴표를 붙인다. 미전달/빈 값은 건드리지
		//   않아 makeComboQuery 가 '' 로 치환하게 두고, 이미 인용된 값(구 화면 quoteParam)은 그대로 둔다.
		if (!NullUtils.isNone(params.get("mnuId"))) params.put("mnuId", quoteLiteral(params.get("mnuId")));
		String query = makeComboQuery(((List<Map<String, Object> >) queryMap.get(DEFAULT_DATA_RESULT)).get(0).get("SQL_DTL_CTN").toString(), params);
		queryMap.put("sQuery", query);
		// 길이가 4,000자(리터럴)·999개(함수 인자)를 넘길 수 있는 파라미터는 @ 치환 대신 #{} 바인드로
		//   받는다. 콤보 본문이 #{endCustomer} 를 쓰면 execStmt 의 ${sQuery} 가 펼친 뒤 MyBatis 가
		//   그 #{} 를 바인드로 잡는다. FE 가 홑따옴표로 감싸 보낸 값은 벗겨 raw 로 바인드한다.
		if (!NullUtils.isNone(params.get("endCustomer"))) queryMap.put("endCustomer", unquote(params.get("endCustomer")));
		result.put((String) params.get("comboId"), selectList("execStmt", queryMap).get(DEFAULT_DATA_RESULT));

		return result;
	}


	@Override
	public Map<String, Object> retrieveComboMuti(Map<String, Object> listParams) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		if(listParams == null || NullUtils.isNone(listParams.get("comboList")) == true) throw new BusinessException("Parametor [comboList] is not exist.");
		List<Map<String, Object>> comboList = (List<Map<String, Object>>) listParams.get("comboList");


		for(Map<String, Object> params:comboList) {
			if(params == null || NullUtils.isNone(params.get("comboId")) == true) throw new BusinessException("Parametor [comboId] is not exist.");
			Map<String, Object> queryMap = selectList("admin.lookup.getQuery", params);
			if(NullUtils.isNone(queryMap)) throw new BusinessException("Query is not exist.");

			params.put("userId", "'"+SecurityUtil.getUserSession().getUserId()+"'");
			params.put("sesUserId", "'"+SecurityUtil.getUserSession().getUserId()+"'");
			params.put("langCd", "'"+SecurityUtil.getUserSession().getLangCd()+"'");
			params.put("sesLangCd", "'"+SecurityUtil.getUserSession().getLangCd()+"'");
			if (!NullUtils.isNone(params.get("mnuId"))) params.put("mnuId", quoteLiteral(params.get("mnuId")));
			String query = makeComboQuery(((List<Map<String, Object> >) queryMap.get(DEFAULT_DATA_RESULT))
										.get(0).get("SQL_DTL_CTN").toString()
										, params);
			queryMap.put("sQuery", query);
			if (!NullUtils.isNone(params.get("endCustomer"))) queryMap.put("endCustomer", unquote(params.get("endCustomer")));
			result.put((String) params.get("comboId"), selectList("execStmt", queryMap).get(DEFAULT_DATA_RESULT));
		}
		return result;
	}

	/**
	 * makeComboQuery 의 @키 는 bind 가 아니라 raw 문자열 치환이라, 문자열 값은 홑따옴표로 감싸야 SQL
	 * 리터럴이 된다(@sesUserId 와 동일 규약). 이미 홑따옴표로 감싼 값은 그대로 둔다 — 이중 인용 방지.
	 * @MethodName : quoteLiteral
	 * @param      : value 감쌀 값(호출부에서 null/공백 여부는 미리 거른다)
	 * @return     : String 홑따옴표로 감싼 리터럴
	 */
	private String quoteLiteral(Object value) {
		String v = value.toString().trim();
		return (v.length() >= 2 && v.startsWith("'") && v.endsWith("'")) ? v : "'" + v + "'";
	}

	/**
	 * quoteComboValue(FE)/quoteLiteral 의 역 - #{} 바인드로 넘길 raw 값을 만든다. 겉 홑따옴표 한 겹을
	 * 벗기고, 내부에서 '' 로 이스케이프된 홑따옴표는 ' 로 되돌린다. 안 벗기면 바인드 값에 따옴표가
	 * 섞여 조건이 어긋난다(오류 없이 결과만 달라짐).
	 * @MethodName : unquote
	 * @param      : value 벗길 값(호출부에서 null/공백 여부는 미리 거른다)
	 * @return     : String 홑따옴표를 벗긴 raw 값
	 */
	private String unquote(Object value) {
		String v = value.toString().trim();
		return (v.length() >= 2 && v.startsWith("'") && v.endsWith("'"))
				? v.substring(1, v.length() - 1).replace("''", "'")
				: v;
	}

}
