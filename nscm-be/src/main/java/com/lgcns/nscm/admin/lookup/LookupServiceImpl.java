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
		String query = makeComboQuery(((List<Map<String, Object> >) queryMap.get(DEFAULT_DATA_RESULT)).get(0).get("SQL_DTL_CTN").toString(), params);
		queryMap.put("sQuery", query);
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
			String query = makeComboQuery(((List<Map<String, Object> >) queryMap.get(DEFAULT_DATA_RESULT))
										.get(0).get("SQL_DTL_CTN").toString()
										, params);
			queryMap.put("sQuery", query);
			result.put((String) params.get("comboId"), selectList("execStmt", queryMap).get(DEFAULT_DATA_RESULT));
		}
		return result;
	}



}
