package com.lgcns.nscm.framework.base;

import static com.lgcns.nscm.framework.base.BaseConstants.DB_SESIONFACTORY_KEY;
import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.dao.NCommonDAO;
import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.utils.MapUtils;

import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

/**
 * 시스템 기본 서비스
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.base
 * @FileName : BaseService.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : BaseService
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Slf4j
public class BaseService {

	private final String nameSpace = BaseConstants.MYBATIS_NAME_SPACE;

    @Autowired
    protected NCommonDAO ncommondao;

    /**
     * 기본DB 연결을 이용하여 조회를 수행하는 함수
     * 설정파일: nscm/src/main/resources/config/config-{}.yaml
     * 기본DB: 첫번째 등록된 DB(datasources[0])
     * @MethodName : selectList
     * @Description:
     * * <pre>
     * {@code
     * Map<String, Object> resultList = selectList("com.QueryTest", param);
     *
     * Map의 Object 유형이 List 인경우 List를 Json String 형식으로 변환하여 전달한다.
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 5.
     * @param      : @param sqlId
     * @param      : @param param
     * @param      : @return
     * @param      : @throws Exception
     * @return     : Map<String,Object>
     */
	public Map<String, Object> selectList(String sqlId, Map<String, Object> param) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, Object> paramMap = getRetrieveParam(param);

			List<Map<String, Object>> dataList = ncommondao.selectList(nameSpace+sqlId, paramMap);

			if (paramMap.get(DEFAULT_DATA_RESULT) != null) result.put(DEFAULT_DATA_RESULT, paramMap.get(DEFAULT_DATA_RESULT));
			else result.put(DEFAULT_DATA_RESULT, dataList);


			List<String> rtnList = MapUtils.findKeysContaining(paramMap, "@");
			for(String rtnDs:rtnList) {
				result.put(rtnDs.replace("@", ""),  paramMap.get(rtnDs));
				paramMap.remove(rtnDs);
			}
		} catch (Exception e) {
			throw new SqlException(e);
		}

		return result;
	}

	/**
	 * dbId에 매핑되는 DB 연결을 이용하여 조회를 수행하는 함수
	 * 설정파일: nscm/src/main/resources/config/config-{}.yaml
	 * Yaml에 설정된 databaseName값과 연결된 DB를 이용하여 조회를 한다.
	 * @MethodName : selectList
	 * @Description:
	 * * <pre>
	 * {@code
	 * Map<String, Object> resultList = selectList("nscm_ora", "com.QueryTest", param);
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param dbId
	 * @param      : @param sqlId
	 * @param      : @param param
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : Map<String,Object>
	 */
	public Map<String, Object> selectList(String dbId, String sqlId, Map<String, Object> param) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> paramMap = getRetrieveParam(param);

		List<Map<String, Object>> dataList = ncommondao.selectList(dbId, nameSpace+sqlId, paramMap);

		if (paramMap.get(DEFAULT_DATA_RESULT) != null) result.put(DEFAULT_DATA_RESULT, paramMap.get(DEFAULT_DATA_RESULT));
		else result.put(DEFAULT_DATA_RESULT, dataList);


		List<String> rtnList = MapUtils.findKeysContaining(paramMap, "@");
		for(String rtnDs:rtnList) {
			result.put(rtnDs.replace("@", ""),  paramMap.get(rtnDs));
			paramMap.remove(rtnDs);
		}

		return result;
	}

/*
	public Map<String, Object> selectList(String dbId, String sqlId, Map<String, Object> param) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.putAll(param);

		// 배열을 json String 형식으로 변경
		for(String mapKey:paramMap.keySet()) {
			if(paramMap.get(mapKey) instanceof List<?> list &&
					list.stream().allMatch(item -> item instanceof Map<?, ?>)) {
				paramMap.put(mapKey, MapUtils.cvtListToJson((List<Map<String, Object>>) paramMap.get(mapKey)));
			}
		}
		// CURSOR용 파라미터 세팅에 대한 처리
		List<String> rtnList = MapUtils.findKeysContaining(paramMap, "@");
		for(String rtnDs:rtnList) {
			paramMap.remove(rtnDs);
			paramMap.put(rtnDs.replace("@", ""), null);
		}
		if(rtnList.size() == 0) {
			paramMap.put(DEFAULT_DATA_RESULT, null);
			ncommondao.selectList(dbId, nameSpace+sqlId, paramMap);
			if (paramMap.get(DEFAULT_DATA_RESULT) != null) result.put(DEFAULT_DATA_RESULT, paramMap.get(DEFAULT_DATA_RESULT));
			else result.put(DEFAULT_DATA_RESULT, ncommondao.selectList(dbId, nameSpace+sqlId, paramMap));
		} else {
			ncommondao.selectList(dbId, nameSpace+sqlId, paramMap);
			// CURSOR 담기
			for(String rtnDs:rtnList) result.put(rtnDs.replace("@", ""),  paramMap.get(rtnDs.replace("@", "")));
		}

		return result;
	}
*/

	/**
	 * @MethodName : insert
	 * @Description: 데이터를 추가한다.
	 * <pre>
	 * {@code
	 * int insertCnt = insert("test.TestQuery", paramMap);
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param sqlId
	 * @param      : @param param
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : int
	 */
	public int insert(String sqlId, Map<String, Object> param) throws Exception {
		if(getDb(param).equals("")) return ncommondao.insert(nameSpace+sqlId, param);
		else return ncommondao.insert(getDb(param), nameSpace+sqlId, param);
    }

	/**
	 *
	 * @MethodName : update
	 * @Description: 데이터를 변경한다.
	 * <pre>
	 * {@code
	 * int updateCnt = update("test.TestQuery", paramMap);
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param sqlId
	 * @param      : @param param
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : int
	 */
	public int update(String sqlId, Map<String, Object> param) throws Exception {
		if(getDb(param).equals("")) return ncommondao.update(nameSpace+sqlId, param);
		else return ncommondao.update(getDb(param), nameSpace+sqlId, param);
	}

	/**
	 *
	 * @MethodName : delete
	 * @Description: 데이터를 삭제한다.
	 * <pre>
	 * {@code
	 * int deleteCnt = delete("test.TestQuery", paramMap);
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param sqlId
	 * @param      : @param param
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : int
	 */
    public int delete(String sqlId, Map<String, Object> param) throws Exception {
    	if(getDb(param).equals("")) return ncommondao.delete(nameSpace+sqlId, param);
		else return ncommondao.delete(getDb(param), nameSpace+sqlId, param);
    }


    /**
     * 다건의 데이터를 조회함
     *
     * @param sqlId    String SQL ID
     * @param response HttpServletResponse
     * @throws Exception
     */
    public <T> void selectListToStream(String sqlId, HttpServletResponse response) throws Exception {


        SqlSession sqlSession = ncommondao.getSqlSession();
        ObjectMapper mapper = new ObjectMapper();
        PrintWriter writer = response.getWriter();
        response.setContentType("application/json; charset=UTF-8");
        writer.write("[");
        try {
            sqlSession.select(nameSpace+sqlId
                    , (ResultHandler<Map<String, Object>>) result -> {
                        if (result.getResultCount() == 1) {
                            try {

                                writer.write(mapper.writeValueAsString(result.getResultObject()));
                            } catch (JsonProcessingException e) {
                                log.debug(e.getMessage());
                            }
                        } else {
                            try {
                                writer.write("," + mapper.writeValueAsString(result.getResultObject()));
                            } catch (JsonProcessingException e) {
                                log.debug(e.getMessage());
                            }
                        }
                    });
        } catch (Exception ex) {
            log.debug(ex.getMessage());
            throw ex;
        } finally {

            sqlSession.close();
            writer.write("]");
        }
    }


    /**
     * @MethodName : selectListToStream
     * @Description:
     * <pre>
     * {@code
     *
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 6.
     * @param      : @param <T>
     * @param      : @param sqlId
     * @param      : @param param
     * @param      : @param response
     * @param      : @throws Exception
     * @return     : void
     */
    public <T> void selectListToStream(String sqlId, Map<String, Object> param, HttpServletResponse response) throws Exception {

    	SqlSession sqlSession = null;
        ObjectMapper mapper = new ObjectMapper();
        PrintWriter writer = response.getWriter();
        response.setContentType("application/json; charset=UTF-8");
        writer.write("[");
        try {
        	if(getDb(param).equals("")) sqlSession = ncommondao.getSqlSession();
        	else sqlSession = ncommondao.getSqlSession(getDb(param));

            sqlSession.select(nameSpace+sqlId, getRetrieveParam(param)
                    , (ResultHandler<Map<String, Object>>) result -> {
                        if (result.getResultCount() == 1) {
                            try {
                                writer.write(mapper.writeValueAsString(result.getResultObject()));
                            } catch (JsonProcessingException e) {
                                log.debug(e.getMessage());
                            }
                        } else {
                            try {
                                writer.write("," + mapper.writeValueAsString(result.getResultObject()));
                            } catch (JsonProcessingException e) {
                                log.debug(e.getMessage());
                            }
                        }
                    });
        } catch (Exception ex) {
            log.debug(ex.getMessage());
            throw ex;
        } finally {

            sqlSession.close();
            writer.write("]");
        }
    }

    /**
     * 동적 프로시저 생성 함수
     * @MethodName : makeProcedure
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
     * @param      : @param params
     * @param      : @param procParam
     * @param      : @return
     * @return     : Map<String,Object>
     */
    public Map<String, Object> makeProcedure(Map<String, Object> params, List<Map<String, Object>> procParam) {

    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	String sProcExec = "";
    	int paramNum = 0;
    	int rtnNum = 1;
    	rtnMap.put("mnuId", params.get("mnuId"));
    	rtnMap.put("mnuBtnCd", params.get("mnuBtnCd"));

    	// 프로시저 정보를 가져와서 프로시저 호출하 동적 쿼리를 생성
    	for(int i=0; i<procParam.size(); i++) {
    		Map<String, Object> o = procParam.get(i);
    		if(i==0) sProcExec += "{call "+o.get("PROC_NM").toString();
    		else sProcExec += ", ";
    		if(o.get("COL_TP_CD").equals("IN")) {
    			if(i==0) sProcExec += "( ";
    			paramNum++;
    			if(o.get("DATA_TP_CD").equals("VARCHAR")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=VARCHAR}";
    			else if(o.get("DATA_TP_CD").equals("JVARCHAR")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=VARCHAR}";
    			else if(o.get("DATA_TP_CD").equals("NUMBER")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=NUMERIC}";
    			else if(o.get("DATA_TP_CD").equals("CLOB")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=CLOB}";
    			else if(o.get("DATA_TP_CD").equals("NUMERIC")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=NUMERIC}";
    			else if(o.get("DATA_TP_CD").equals("DATE")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=IN, jdbcType=DATE}";

    			rtnMap.put(o.get("COL_NM").toString(), params.get(o.get("COL_NM").toString()));
    		}
    		if(o.get("COL_TP_CD").equals("OUT")){
    			if(i==0) sProcExec += "( ";
    			paramNum++;
    			if(o.get("DATA_TP_CD").equals("VARCHAR")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=VARCHAR, javaType=java.lang.String}";
    			else if(o.get("DATA_TP_CD").equals("JVARCHAR")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=VARCHAR, javaType=java.lang.String}";
    			else if(o.get("DATA_TP_CD").equals("NUMBER")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=NUMERIC, javaType=int}";
    			else if(o.get("DATA_TP_CD").equals("CLOB")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=CLOB, javaType=java.lang.String}";
    			else if(o.get("DATA_TP_CD").equals("NUMERIC")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=NUMERIC, javaType=java.math.BigDecimal}";
    			else if(o.get("DATA_TP_CD").equals("DATE")) sProcExec += "#{"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=DATE, javaType=java.time.LocalDateTime}";
    			else if(o.get("DATA_TP_CD").equals("CURSOR") || o.get("DATA_TP_CD").equals("PROC_RESULT")) {
    				sProcExec += "#{@"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=data"+String.valueOf(rtnNum)+"}";
    				rtnNum++;
    				rtnMap.put("@"+o.get("COL_NM").toString(), null);}
    		}

    	}
    	if(paramNum>0) sProcExec += ")";
    	sProcExec += "}";
    	log.debug(sProcExec);
    	rtnMap.put("procExec", sProcExec);

    	return rtnMap;
    }
/*
    public Map<String, Object> makeProcedure(Map<String, Object> params, List<Map<String, Object>> procParam) {

    	Map<String, Object> rtnMap = new HashMap<String, Object>();
    	String sProcExec = "";
    	int paramNum = 0;
    	int rtnNum = 1;

    	// 프로시저 정보를 가져와서 프로시저 호출하 동적 쿼리를 생성
    	for(int i=0; i<procParam.size(); i++) {
    		Map<String, Object> o = procParam.get(i);
    		if(i==0) sProcExec += "{call SCM_MGR."+o.get("PROC_NM").toString();
    		else sProcExec += ", ";
    		if(o.get("COL_TP_CD").equals("IN")) {
    			paramNum++;
    			if(i==0) sProcExec += " ( ";
    			if(o.get("DATA_TP_CD").equals("VARCHAR")) sProcExec += "'"+params.get(o.get("COL_NM").toString())+"'";
    		}
    		if(o.get("COL_TP_CD").equals("OUT")){
    			if(i==0) sProcExec += " ( ";
    			sProcExec += "#{@"+o.get("COL_NM").toString()+", mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=data"+String.valueOf(rtnNum)+"}";
    			paramNum++;
    			rtnNum++;
    			rtnMap.put("@"+o.get("COL_NM").toString(), null);
    		}

    	}
    	if(paramNum>0) sProcExec += ")";
    	sProcExec += "}";
    	log.debug(sProcExec);
    	rtnMap.put("procExec", sProcExec);

    	return rtnMap;
    }
*/

    /**
     * 콤보용 동적 쿼리를 생성하여 실행 시켜준다.
     *
     * @MethodName : makeComboQuery
     * @Description:
     <p><b>Usage Example:</b></p>
     * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
     * {@code
     *
     * SCM_ADM_SQL_M 테이블에 SQL의 @부분을 치환처리
     *
     * }
     * </pre>
     * @author     : story55
     * @date       : 2026. 2. 12.
     * @param      : @param query
     * @param      : @param params
     * @param      : @return
     * @return     : String
     */
    public String makeComboQuery(String query, Map<String, Object> params) {

		// 정규표현식 패턴: @로 시작하고 뒤에 영문/숫자가 오는 패턴 추출
        Pattern pattern = Pattern.compile("@(\\w+)");
        Matcher matcher = pattern.matcher(query);

        StringBuilder sb = new StringBuilder();
        while (matcher.find()) {
            String key = matcher.group(1); // 괄호 안의 변수명(name, status 등)만 추출
            String value = (String) params.getOrDefault(key, "''"); // 맵에 없으면 ''로 치환
//            String value = (String) params.getOrDefault(key, matcher.group(0)); // 맵에 없으면 원본 유지
            matcher.appendReplacement(sb, value);
        }
        matcher.appendTail(sb);
		return sb.toString();
	}

/* ===================================================================================================================== */



    private String getDb(Map<String, Object> paramMap) {
    	String rtnDB = "";

    	if (paramMap != null && paramMap.containsKey(DB_SESIONFACTORY_KEY)) {
    		String sKey = paramMap.get(DB_SESIONFACTORY_KEY).toString();
    		for(String dbKey:ncommondao.getSessionFactoryMap().keySet()) {
    			if(dbKey.equals(sKey)) rtnDB = sKey;
    		}
    	}
    	return rtnDB;
    }

    private Map<String, Object> getRetrieveParam(Map<String, Object> paramMap){
    		Map<String, Object> rtnMap = new HashMap<String, Object>();

    		for(String mapKey:paramMap.keySet()) {
    			// 배열을 json String 형식으로 변경
    			if(paramMap.get(mapKey) instanceof List<?> list &&
    					list.stream().allMatch(item -> item instanceof Map<?, ?>)) {
    				rtnMap.put(mapKey, MapUtils.cvtListToJson((List<Map<String, Object>>) paramMap.get(mapKey)));
    			}
    			else rtnMap.put(mapKey, paramMap.get(mapKey));

    		}
    		rtnMap.put(DEFAULT_DATA_RESULT, null);

    	return rtnMap;
    }

    private List<Map<String, Object>> getExcuteParam(Map<String, Object> paramMap){
	    	List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
			if (paramMap != null && paramMap.containsKey("data")) {
				if(paramMap.get("data") instanceof List)
					rtnList = (List<Map<String, Object>>) paramMap.get("data");
			}
		return rtnList;
	}


}
