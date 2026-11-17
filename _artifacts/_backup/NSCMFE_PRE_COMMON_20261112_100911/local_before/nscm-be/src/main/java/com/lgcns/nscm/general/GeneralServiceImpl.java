package com.lgcns.nscm.general;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.model.CustomMap;
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

    /* ======================================================================================================
     * [E20261015-STREAMPROC] 대량 조회 스트리밍
     *  - 기존 call-proc 는 OUT 커서 전량을 List<CustomMap> 으로 모은 뒤 한 번에 JSON 직렬화한다
     *    (SCP0030 289,551행 x 37컬럼 = 234MB → 화면 표시까지 50~85초, 그동안 화면은 빈 상태).
     *  - 스트리밍은 같은 메타로 같은 SP 를 1회 실행하고, 커서를 읽는 즉시 묶음 단위 NDJSON 한 줄씩 흘려보낸다.
     *    FE 는 첫 묶음부터 그리드에 표시한다. 값 변환은 기존과 동일(CustomMap + 동일 날짜 포맷)해서 행 내용이 같다.
     *  - 응답 줄 형식(줄마다 JSON 1개):
     *      {"t":"cursor","c":"<COL_NM>","cols":[...]}       커서 시작
     *      {"t":"rows","c":"<COL_NM>","rows":[{...},...]}   행 묶음
     *      {"t":"cursorEnd","c":"<COL_NM>","count":N}       커서 끝
     *      {"t":"out","c":"<COL_NM>","v":값}                 커서 아닌 OUT 파라미터
     *      {"t":"error","message":"..."}                     실행 중 오류
     *      {"t":"end","rows":총행수,"ms":소요}                전송 완료
     *    상태 커서(PROC_RESULT, 예: O_RESULT_CURSOR)는 데이터 커서보다 먼저 보낸다 → FE 가 CODE 오류를 먼저 판정.
     * ====================================================================================================== */
    private static final int STREAM_FIRST_BATCH = 1000;   // 첫 화면용 — 작게 보내 빨리 그린다
    private static final int STREAM_BATCH = 30000;          // 사용자 지정(2026-10-15) — 5,000 → 30,000 (브라우저 묶음 처리 횟수 축소)
    private static final int STREAM_FETCH_SIZE = 1000;
    private static final ObjectMapper STREAM_MAPPER = createStreamMapper();

    /** 응답 JSON 과 같은 설정 — CustomWebConfig.configureMessageConverters 와 동일하게 맞춘다 */
    private static ObjectMapper createStreamMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        mapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
        mapper.getFactory().disable(JsonGenerator.Feature.AUTO_CLOSE_TARGET);
        // 기본값(true)이면 gen.writeObject(행) 마다 flush → 행마다 gzip 동기 flush + 소켓 쓰기 (28.9만 행 365초 실측).
        //   flush 는 묶음 끝(endLine)에서만 한다.
        mapper.disable(SerializationFeature.FLUSH_AFTER_WRITE_VALUE);
        return mapper;
    }

    @Override
    public StreamingResponseBody execBtnStream(Map<String, Object> params) throws Exception {
    	// 1) 메타 해석 — 호출 스레드에서 끝낸다(오류는 일반 응답으로 돌아감)
    	List<Map<String, Object>> procParam = (List<Map<String, Object>>) selectList("retrieveBtnInfoList", params).get("procInfo");
    	Set<String> jCols = new HashSet<>();
    	for(Map<String, Object> paramMap:procParam) {
    		if("JVARCHAR".equals(paramMap.get("DATA_TP_CD"))) jCols.add((String)paramMap.get("COL_NM"));
    	}
    	if(!jCols.isEmpty()) MapUtils.cvtJsonToJVarchar(params, jCols);
    	final Map<String, Object> callParams = new HashMap<>(params);
    	final String procNm = String.valueOf(procParam.get(0).get("PROC_NM"));

    	// 2) 실행·전송 — StreamingResponseBody 안에서
    	return out -> {
    		long st = System.currentTimeMillis();
    		long total = 0;
    		JsonGenerator gen = STREAM_MAPPER.getFactory().createGenerator(out, JsonEncoding.UTF8);
    		SqlSession ses = null;
    		try {
    			ses = ncommondao.getSqlSession();
    			Connection con = ses.getConnection();
    			StringBuilder sql = new StringBuilder("{call ").append(procNm);
    			List<Map<String, Object>> args = new ArrayList<>();
    			for(Map<String, Object> p:procParam) {
    				String tp = String.valueOf(p.get("COL_TP_CD"));
    				if("IN".equals(tp) || "OUT".equals(tp)) args.add(p);
    			}
    			if(!args.isEmpty()) {
    				sql.append("(");
    				for(int i=0; i<args.size(); i++) sql.append(i==0 ? "?" : ", ?");
    				sql.append(")");
    			}
    			sql.append("}");

    			try (CallableStatement cs = con.prepareCall(sql.toString())) {
    				for(int i=0; i<args.size(); i++) bindStreamArg(con, cs, i+1, args.get(i), callParams);
    				cs.execute();

    				// 상태 커서(PROC_RESULT) 먼저, 그 다음 데이터 커서, 마지막에 일반 OUT
    				for(String pass : new String[]{"PROC_RESULT", "CURSOR", "OTHER"}) {
    					for(int i=0; i<args.size(); i++) {
    						Map<String, Object> a = args.get(i);
    						if(!"OUT".equals(a.get("COL_TP_CD"))) continue;
    						String dt = String.valueOf(a.get("DATA_TP_CD"));
    						String nm = String.valueOf(a.get("COL_NM"));
    						boolean isCursor = "CURSOR".equals(dt) || "PROC_RESULT".equals(dt);
    						if("OTHER".equals(pass) ? isCursor : !pass.equals(dt)) continue;
    						// getObject(int, Class) 는 log4jdbc(CallableStatementSpy)가 구현하지 않음 → getObject(int) (MyBatis 와 동일 경로)
    						if(isCursor) total += writeCursor(gen, out, nm, (ResultSet) cs.getObject(i+1));
    						else {
    							gen.writeStartObject();
    							gen.writeStringField("t", "out");
    							gen.writeStringField("c", nm);
    							gen.writeFieldName("v");
    							gen.writeObject(cs.getObject(i+1));
    							gen.writeEndObject();
    							endLine(gen, out);
    						}
    					}
    				}
    			}
    		} catch (Throwable e) {
    			// 응답 헤더(x-ndjson)가 이미 정해져 일반 오류 응답으로 바꿀 수 없다 → 오류 줄로 알린다. JVM 치명 오류만 다시 던짐
    			log.error("[execBtnStream] {} error: {}", procNm, e.getMessage(), e);
    			gen.writeStartObject();
    			gen.writeStringField("t", "error");
    			gen.writeStringField("message", String.valueOf(e.getMessage()));
    			gen.writeEndObject();
    			endLine(gen, out);
    			if(e instanceof VirtualMachineError vme) throw vme;
    		} finally {
    			if(ses != null) { ses.clearCache(); ses.close(); }
    		}
    		gen.writeStartObject();
    		gen.writeStringField("t", "end");
    		gen.writeNumberField("rows", total);
    		gen.writeNumberField("ms", System.currentTimeMillis() - st);
    		gen.writeEndObject();
    		endLine(gen, out);
    		gen.close();
    		log.info("[execBtnStream] {} {}/{}/{} rows={} ms={}", procNm, callParams.get("mnuId"), callParams.get("shtNm"),
    				callParams.get("mnuBtnCd"), total, System.currentTimeMillis() - st);
    	};
    }

    /** IN/OUT 바인딩 — makeProcedure 의 DATA_TP_CD 매핑과 같은 규칙 */
    private void bindStreamArg(Connection con, CallableStatement cs, int idx, Map<String, Object> a, Map<String, Object> params) throws SQLException {
    	String dt = String.valueOf(a.get("DATA_TP_CD"));
    	String nm = String.valueOf(a.get("COL_NM"));
    	if("OUT".equals(a.get("COL_TP_CD"))) {
    		switch (dt) {
    			case "CURSOR", "PROC_RESULT" -> cs.registerOutParameter(idx, Types.REF_CURSOR);
    			case "NUMBER", "NUMERIC" -> cs.registerOutParameter(idx, Types.NUMERIC);
    			case "CLOB" -> cs.registerOutParameter(idx, Types.CLOB);
    			case "DATE" -> cs.registerOutParameter(idx, Types.TIMESTAMP);
    			default -> cs.registerOutParameter(idx, Types.VARCHAR);
    		}
    		return;
    	}
    	Object v = params.get(nm);
    	switch (dt) {
    		case "NUMBER", "NUMERIC" -> {
    			if(v == null || String.valueOf(v).isBlank()) cs.setNull(idx, Types.NUMERIC);
    			else cs.setBigDecimal(idx, new BigDecimal(String.valueOf(v)));
    		}
    		case "CLOB" -> {
    			if(v == null) cs.setNull(idx, Types.CLOB);
    			else { Clob c = con.createClob(); c.setString(1, String.valueOf(v)); cs.setClob(idx, c); }
    		}
    		default -> {
    			if(v == null) cs.setNull(idx, Types.VARCHAR);
    			else cs.setString(idx, String.valueOf(v));
    		}
    	}
    }

    /** 커서 1개를 묶음 단위로 전송. 행 변환은 CustomMap(기존 call-proc 와 동일) */
    private long writeCursor(JsonGenerator gen, java.io.OutputStream out, String nm, ResultSet rs) throws Exception {
    	long count = 0;
    	if(rs == null) return 0;
    	try (rs) {
    		rs.setFetchSize(STREAM_FETCH_SIZE);
    		ResultSetMetaData md = rs.getMetaData();
    		int cc = md.getColumnCount();
    		String[] cols = new String[cc];
    		for(int c=0; c<cc; c++) cols[c] = md.getColumnLabel(c+1);

    		gen.writeStartObject();
    		gen.writeStringField("t", "cursor");
    		gen.writeStringField("c", nm);
    		gen.writeArrayFieldStart("cols");
    		for(String col:cols) gen.writeString(col);
    		gen.writeEndArray();
    		gen.writeEndObject();
    		endLine(gen, out);

    		int inBatch = 0;
    		int limit = STREAM_FIRST_BATCH;
    		boolean open = false;
    		while(rs.next()) {
    			if(!open) {
    				gen.writeStartObject();
    				gen.writeStringField("t", "rows");
    				gen.writeStringField("c", nm);
    				gen.writeArrayFieldStart("rows");
    				open = true;
    			}
    			CustomMap row = new CustomMap();
    			for(int c=0; c<cc; c++) row.put(cols[c], rs.getObject(c+1));
    			gen.writeObject(row);
    			count++;
    			if(++inBatch >= limit) {
    				gen.writeEndArray();
    				gen.writeEndObject();
    				endLine(gen, out);
    				open = false;
    				inBatch = 0;
    				limit = STREAM_BATCH;
    			}
    		}
    		if(open) {
    			gen.writeEndArray();
    			gen.writeEndObject();
    			endLine(gen, out);
    		}
    		gen.writeStartObject();
    		gen.writeStringField("t", "cursorEnd");
    		gen.writeStringField("c", nm);
    		gen.writeNumberField("count", count);
    		gen.writeEndObject();
    		endLine(gen, out);
    	}
    	return count;
    }

    private void endLine(JsonGenerator gen, java.io.OutputStream out) throws java.io.IOException {
    	gen.writeRaw('\n');
    	gen.flush();
    	out.flush();
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
