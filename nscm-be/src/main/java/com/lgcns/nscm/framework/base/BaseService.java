package com.lgcns.nscm.framework.base;

import static com.lgcns.nscm.framework.base.BaseConstants.DB_SESIONFACTORY_KEY;
import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.dao.NCommonDAO;
import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.model.CustomMap;
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
     * @MethodName : callProcStream
     * @Description: 동적 프로시저를 raw JDBC 로 실행하고 OUT 커서를 ResultSet -> JSON 으로
     *   직접 스트리밍한다. CustomMap 재료화(행 객체 생성)와 별도 Jackson 패스를 건너뛰는 단일 패스 경로.
     *   응답 형태는 기존 execBtn/callProc(BaseResponse)와 동일:
     *   { "code":..., "message":..., "result": { "<커서COL_NM>":[..행..], "<스칼라OUT>":val } }
     *   주의: 기존 callProc/execBtn 공용 경로와 분리된 실험 경로다(공용 경로 무영향).
     */
    @SuppressWarnings("unchecked")
    public void callProcStream(Map<String, Object> params, HttpServletResponse response) throws Exception {

        // 1. 프로시저 메타 (execBtn 과 동일 소스)
        List<Map<String, Object>> procParam =
                (List<Map<String, Object>>) selectList("retrieveBtnInfoList", params).get("procInfo");

        // 2. JVARCHAR 처리 (execBtn 과 동일)
        Set<String> jCols = new HashSet<>();
        boolean isJvarchar = false;
        for (Map<String, Object> o : procParam) {
            if ("JVARCHAR".equals(o.get("DATA_TP_CD"))) { isJvarchar = true; jCols.add((String) o.get("COL_NM")); }
        }
        if (isJvarchar) MapUtils.cvtJsonToJVarchar(params, jCols);

        // 3. {call PROC(?, ?, ...)} 생성
        StringBuilder sb = new StringBuilder("{call ");
        for (int i = 0; i < procParam.size(); i++) {
            Map<String, Object> o = procParam.get(i);
            if (i == 0) sb.append(o.get("PROC_NM").toString()).append("(");
            else sb.append(", ");
            sb.append("?");
        }
        if (!procParam.isEmpty()) sb.append(")");
        sb.append("}");
        String callSql = sb.toString();
        log.debug("callProcStream: {}", callSql);

        response.setContentType("application/json; charset=UTF-8");

        long t0 = System.currentTimeMillis();
        int totalRows = 0;
        SqlSession sqlSession = "".equals(getDb(params)) ? ncommondao.getSqlSession() : ncommondao.getSqlSession(getDb(params));
        CallableStatement cs = null;
        try {
            Connection conn = sqlSession.getConnection();
            cs = conn.prepareCall(callSql);

            List<Integer> cursorIdx = new ArrayList<>();
            List<String> cursorKey = new ArrayList<>();
            List<Integer> scalarIdx = new ArrayList<>();
            List<String> scalarKey = new ArrayList<>();
            for (int i = 0; i < procParam.size(); i++) {
                Map<String, Object> o = procParam.get(i);
                int idx = i + 1;
                String colTp = String.valueOf(o.get("COL_TP_CD"));
                String dataTp = String.valueOf(o.get("DATA_TP_CD"));
                String colNm = String.valueOf(o.get("COL_NM"));
                if ("IN".equals(colTp)) {
                    cs.setObject(idx, params.get(colNm));
                } else if ("OUT".equals(colTp)) {
                    if ("CURSOR".equals(dataTp) || "PROC_RESULT".equals(dataTp)) {
                        cs.registerOutParameter(idx, Types.REF_CURSOR);
                        cursorIdx.add(idx); cursorKey.add(colNm);
                    } else {
                        cs.registerOutParameter(idx, Types.VARCHAR);
                        scalarIdx.add(idx); scalarKey.add(colNm);
                    }
                }
            }

            cs.execute();

            JsonGenerator gen = new JsonFactory().createGenerator(response.getOutputStream(), JsonEncoding.UTF8);
            try {
                gen.writeStartObject();
                gen.writeStringField("code", BaseConstants.SUCCESS);
                gen.writeStringField("message", BaseConstants.SUCCESS_MSG);
                gen.writeFieldName("result");
                gen.writeStartObject();

                for (int k = 0; k < scalarIdx.size(); k++) {
                    Object v = cs.getObject(scalarIdx.get(k));
                    gen.writeStringField(scalarKey.get(k), v == null ? null : String.valueOf(v));
                }
                for (int k = 0; k < cursorIdx.size(); k++) {
                    gen.writeArrayFieldStart(cursorKey.get(k));
                    ResultSet rs = (ResultSet) cs.getObject(cursorIdx.get(k));
                    try {
                        rs.setFetchSize(1000);
                        ResultSetMetaData md = rs.getMetaData();
                        int cc = md.getColumnCount();
                        String[] label = new String[cc + 1];
                        int[] type = new int[cc + 1];
                        for (int c = 1; c <= cc; c++) { label[c] = md.getColumnLabel(c); type[c] = md.getColumnType(c); }
                        while (rs.next()) {
                            totalRows++;
                            gen.writeStartObject();
                            for (int c = 1; c <= cc; c++) {
                                gen.writeFieldName(label[c]);
                                writeCell(gen, rs, c, type[c]);
                            }
                            gen.writeEndObject();
                        }
                    } finally {
                        if (rs != null) rs.close();
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject(); // result
                gen.writeEndObject(); // root
                gen.flush();
            } finally {
                gen.close();
            }
        } catch (Exception e) {
            log.debug(e.getMessage());
            throw e;
        } finally {
            if (cs != null) try { cs.close(); } catch (Exception ignore) {}
            sqlSession.close();
            log.info("callProcStream done: {} ms, rows={}, mnuId={}, shtNm={}, mnuBtnCd={}",
                    System.currentTimeMillis() - t0, totalRows, params.get("mnuId"), params.get("shtNm"), params.get("mnuBtnCd"));
        }
    }

    /** callProcStream 셀 1개 값을 타입에 맞춰 JSON 으로 쓴다(숫자는 number, 그 외 문자열). */
    private void writeCell(JsonGenerator gen, ResultSet rs, int c, int type) throws Exception {
        switch (type) {
            case Types.NUMERIC: case Types.DECIMAL: case Types.INTEGER:
            case Types.BIGINT: case Types.SMALLINT: case Types.TINYINT:
            case Types.FLOAT: case Types.DOUBLE: case Types.REAL: {
                BigDecimal bd = rs.getBigDecimal(c);
                if (bd == null) gen.writeNull(); else gen.writeNumber(bd);
                break;
            }
            default: {
                String s = rs.getString(c);
                if (s == null) gen.writeNull(); else gen.writeString(s);
            }
        }
    }

    /**
     * call-proc2 — SCM_ADM_PROC_M / procedures.d.ts 를 참조하지 않고, 살아있는 Oracle 카탈로그
     * (ALL_ARGUMENTS)만으로 프로시저 IN/OUT 을 유도해 실행하는 경로. 신규/개선 화면의 점진 전환용.
     *
     * 파라미터 키 규약(카탈로그에서 유도 불가한 것만 여기서 보완):
     * - IN 업무 파라미터: 오라클명에서 선두 'P_' 제거 + snake→camel 로 요청 키를 유도 (P_DIVISION_ID -> divisionId).
     * - 세션 파라미터: 컨트롤러가 넣어준 ses* 값을 "요청에 없는 키의 default" 로만 채운다. 그래서
     *   같은 오라클명 P_USER_ID 가 어떤 화면은 세션(요청에 userId 없음), 어떤 화면은 업무값(요청에 userId 있음)
     *   이어도 충돌하지 않는다.
     * - JVARCHAR: cvtJsonToVarchar 목록(요청 키)에 대해 data 그리드 배열을 '^' delim 으로 접는다(기존 규약 재사용).
     * - OUT 커서/스칼라: 오라클명 소문자를 응답 키로 사용(O_RC1 -> o_rc1). 행 컬럼은 ResultSetMetaData 로 런타임 취득.
     */
    public Map<String, Object> callProc2(String procNm, Map<String, Object> params, Set<String> jvarcharCols) throws Exception {

        // 0. PKG.PROC 분리
        String pkg = null;
        String obj = procNm;
        int dot = procNm.indexOf('.');
        if (dot > 0) { pkg = procNm.substring(0, dot); obj = procNm.substring(dot + 1); }

        // 1. 세션 default (컨트롤러가 주입한 ses* 값 → 유도키에도 매핑). 요청에 키가 있으면 요청값이 이긴다.
        Map<String, Object> sessionDefaults = new HashMap<>();
        if (params.containsKey("sesUserId"))     { Object v = params.get("sesUserId");     sessionDefaults.put("sesUserId", v);     sessionDefaults.put("userId", v); }
        if (params.containsKey("sesLangCd"))      { Object v = params.get("sesLangCd");      sessionDefaults.put("sesLangCd", v);      sessionDefaults.put("langCd", v); }
        if (params.containsKey("sesDivisionId"))  { Object v = params.get("sesDivisionId");  sessionDefaults.put("sesDivisionId", v); }
        if (params.containsKey("sesUserGrId"))    { Object v = params.get("sesUserGrId");    sessionDefaults.put("sesUserGrId", v); }
        if (params.containsKey("sesMenuId"))      { Object v = params.get("sesMenuId");      sessionDefaults.put("sesMenuId", v); }

        // 2. JVARCHAR 접기(그리드 배치) — 기존 규약 재사용
        if (jvarcharCols != null && !jvarcharCols.isEmpty()) {
            MapUtils.cvtJsonToJVarchar(params, jvarcharCols);
        }

        Map<String, Object> result = new HashMap<>();
        SqlSession sqlSession = "".equals(getDb(params)) ? ncommondao.getSqlSession() : ncommondao.getSqlSession(getDb(params));
        try {
            Connection conn = sqlSession.getConnection();

            // 3. 카탈로그에서 파라미터 시그니처 취득 (POSITION 순)
            List<String[]> args = new ArrayList<>(); // {ARGUMENT_NAME, IN_OUT, DATA_TYPE}
            String metaSql = "SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE "
                    + (pkg == null ? "PACKAGE_NAME IS NULL" : "PACKAGE_NAME = ?")
                    + " AND OBJECT_NAME = ? AND DATA_LEVEL = 0 AND (OVERLOAD IS NULL OR OVERLOAD = '1') ORDER BY POSITION";
            try (PreparedStatement ps = conn.prepareStatement(metaSql)) {
                int bi = 1;
                if (pkg != null) ps.setString(bi++, pkg);
                ps.setString(bi, obj);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) args.add(new String[] { rs.getString(1), rs.getString(2), rs.getString(3) });
                }
            }
            if (args.isEmpty()) throw new Exception("call_proc2: no catalog arguments for " + procNm);

            // 4. {call PKG.PROC(?, ?, ...)}
            StringBuilder sb = new StringBuilder("{call ").append(procNm).append("(");
            for (int i = 0; i < args.size(); i++) { if (i > 0) sb.append(", "); sb.append("?"); }
            sb.append(")}");
            String callSql = sb.toString();
            log.debug("call_proc2: {}", callSql);

            List<Integer> cursorIdx = new ArrayList<>();
            List<String> cursorKey = new ArrayList<>();
            List<Integer> scalarIdx = new ArrayList<>();
            List<String> scalarKey = new ArrayList<>();

            try (CallableStatement cs = conn.prepareCall(callSql)) {
                for (int i = 0; i < args.size(); i++) {
                    String[] a = args.get(i);
                    int idx = i + 1;
                    String name = a[0];
                    String inOut = a[1];
                    String dataType = a[2];

                    if ("OUT".equals(inOut) || "IN/OUT".equals(inOut)) {
                        String key = name.toLowerCase();
                        if ("REF CURSOR".equals(dataType)) {
                            cs.registerOutParameter(idx, Types.REF_CURSOR);
                            cursorIdx.add(idx); cursorKey.add(key);
                        } else {
                            cs.registerOutParameter(idx, Types.VARCHAR);
                            scalarIdx.add(idx); scalarKey.add(key);
                        }
                    } else { // IN
                        String key = toCamelKey(name);
                        Object val = params.containsKey(key) ? params.get(key) : sessionDefaults.get(key);
                        cs.setObject(idx, val);
                    }
                }

                cs.execute();

                for (int k = 0; k < scalarIdx.size(); k++) {
                    Object v = cs.getObject(scalarIdx.get(k));
                    result.put(scalarKey.get(k), v == null ? null : String.valueOf(v));
                }
                for (int k = 0; k < cursorIdx.size(); k++) {
                    List<Map<String, Object>> rows = new ArrayList<>();
                    try (ResultSet rs = (ResultSet) cs.getObject(cursorIdx.get(k))) {
                        if (rs != null) {
                            ResultSetMetaData md = rs.getMetaData();
                            int cc = md.getColumnCount();
                            String[] label = new String[cc + 1];
                            for (int c = 1; c <= cc; c++) label[c] = md.getColumnLabel(c);
                            while (rs.next()) {
                                Map<String, Object> row = new CustomMap();
                                for (int c = 1; c <= cc; c++) {
                                    Object v = rs.getObject(c);
                                    if (v != null) row.put(label[c], v); // null 은 담지 않음(기존 MyBatis 동작과 동일)
                                }
                                rows.add(row);
                            }
                        }
                    }
                    result.put(cursorKey.get(k), rows);
                }
            }
        } catch (Exception e) {
            log.error("call_proc2 error (procNm = {})", procNm, e);
            throw e;
        } finally {
            sqlSession.close();
        }
        return result;
    }

    /** 오라클 IN 파라미터명 -> 요청 키. 선두 'P_' 제거 후 snake_case -> camelCase. (P_FROM_YYYYMMDD -> fromYyyymmdd) */
    private String toCamelKey(String oracleName) {
        String s = oracleName;
        if (s.startsWith("P_") || s.startsWith("p_")) s = s.substring(2);
        String[] parts = s.toLowerCase().split("_");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (parts[i].isEmpty()) continue;
            if (sb.length() == 0) sb.append(parts[i]);
            else sb.append(Character.toUpperCase(parts[i].charAt(0))).append(parts[i].substring(1));
        }
        return sb.toString();
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
