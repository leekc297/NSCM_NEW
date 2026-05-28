package com.lgcns.nscm.general;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Service;

import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.utils.MapUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes", "unchecked" })
@Service
public class GeneralServiceImpl extends BaseService implements GeneralService {

    private final String nameSpace = BaseConstants.MYBATIS_NAME_SPACE;

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
    	return selectList("callProc", makeProcedure(params, procParam));
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
    	return selectList("callProc", makeProcedure(params, procParam));
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
