package com.lgcns.nscm.general.file;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.utils.ExcelUtils;
import com.lgcns.nscm.framework.utils.MapUtils;
import com.lgcns.nscm.framework.utils.NullUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes", "unchecked" })
@Service
public class FileServiceImpl extends BaseService implements FileService {

	private static final ObjectMapper objectMapper = new ObjectMapper();


	/**
	 * @MethodName : excelFileUplad
	 * @Description:
	 * @author     : story55
	 * @date       : 2026. 3. 25.
	 * @param      : @param params
	 * @param      : @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> excelFileUplad(Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		String excelJsonData = "";
		String headerContent = "";
		String validProc = "";
		try {
			// 엑셀 헤더정보 및 유효성 체크 프로시저 정보 검색
			List<Map> excelInfoList = (List<Map>) selectList("admin.excel.selectExcelInfo", params).get(BaseConstants.DEFAULT_DATA_RESULT);
			if(excelInfoList.size() == 0) throw new BusinessException("[WARN] excelFileUplad: Not exist ExcelUpload Data.");

			for(Map excelInfo:excelInfoList) {
				// 엑셀 헤더정보
				headerContent = (String) excelInfo.get("HEADER_CONTENT");
				// 유효성 체크 프로시저정보
				validProc = (String) excelInfo.get("STORAGE_SQL_ID");

				// 엑셀 파일 데이터 파싱
				List<Map<String, Object>> excelList = ExcelUtils.convertExcelToJson((MultipartFile) params.get("excelfile"));
				// 엑셀 데이터 > 업로드용 행 리스트 (@TITLE + UPLOAD). 동적 기간 컬럼은 엑셀 날짜 행 기준.
				List<Map<String, Object>> uploadRows = cvtListUploadRows(excelList, headerContent);
				excelJsonData = objectMapper.writeValueAsString(uploadRows);
				// 엑셀 업로드 temp 테이블에 insert
				params.put("excelData", excelJsonData);
				// colCnt = 실제 _COL 개수 (동적 기간 컬럼 반영). 행 없으면 HEADER_CONTENT 토큰 수 fallback.
				int colCnt = uploadRows.isEmpty() ? getPipeCount(headerContent)
						: (int) uploadRows.get(0).keySet().stream().filter(k -> k.startsWith("_COL")).count();
				params.put("colCnt", colCnt);
				params.put("@O_RESULT_CURSOR", null);
				selectList("admin.excel.excelUploadTmp", params);
				// 유효성 체크 프로시저 실행
				params.put("validProc", validProc);
				params.put("mode", 0);
				selectList("admin.excel.excelUploadValid", params);
				// 조회용 프로시저 실행
				params.put("@O_CUR_CNT", null);
				params.put("@O_CUR_LIST", null);
				result = selectList("admin.excel.excelUploadResult", params);
			}
		} catch (Exception e) {
			throw new BusinessException("Error excelFileUplad: "+e.getMessage());
		}
		return result;
	}

	/**
	 * 엑셀 헤더 문자열이 버킷 시작일(YYYYMMDD)이면 8자리 문자열로 정규화해 돌려준다. 아니면 null.
	 *
	 * <p>1단 헤더 업로드에서 기간 컬럼을 식별하는 유일한 근거다. 사용자가 엑셀에서 편집·저장하면
	 * 날짜 헤더가 숫자 셀이 되어 {@code 20260803.0} / {@code 2.0260803E7} 로 읽히므로, 원형 비교만
	 * 하면 그 열 전량이 조용히 탈락한다(= 기간 컬럼 0개 → 전건 BUCKET 오류).
	 *
	 * <p>범위를 19000101~99991231 로 좁혀, 우연히 8자리인 코드성 헤더를 기간 컬럼으로 오인하지 않는다.
	 */
	private String normalizeYmdHeader(String header) {
	    if (header == null) return null;
	    String s = header.trim();
	    if (s.isEmpty()) return null;
	    if (!s.matches("[0-9]+(\\.[0-9]+)?([eE][+-]?[0-9]+)?")) return null;
	    long v;
	    try {
	        v = new java.math.BigDecimal(s).longValueExact();
	    } catch (ArithmeticException | NumberFormatException e) {
	        return null; // 소수부가 있는 실수 등 — 날짜가 아니다
	    }
	    if (v < 19000101L || v > 99991231L) return null;
	    String ymd = Long.toString(v);
	    int mm = Integer.parseInt(ymd.substring(4, 6));
	    int dd = Integer.parseInt(ymd.substring(6, 8));
	    if (mm < 1 || mm > 12 || dd < 1 || dd > 31) return null;
	    return ymd;
	}

	private int getPipeCount(String input) {
        if (input == null || input.isEmpty()) return 0;
        String[] parts = input.split("\\|", -1);
        return parts.length;
    }

	private List<Map<String, Object>> cvtListUploadRows(List<Map<String, Object>> excelList, String keyTemplate) {
	    List<Map<String, Object>> transformedList = new ArrayList<>();

	    // 기준 키 목록 (HEADER_CONTENT) — 식별 컬럼 매핑용. 기간 컬럼은 여기서 쓰지 않는다(동적 주차).
	    String[] targetKeys = keyTemplate.split("\\|", -1);

	    // 날짜(타이틀) 행 판별 — 2단 헤더(라벨 + 기간 시작일) 업로드에서, 선두 식별 컬럼(targetKeys[0])이
	    //   공란이고 기간 컬럼에만 값이 있는 첫 행이 날짜 행이다.
	    // ※ 날짜 행은 데이터에서 제외하지 않는다 — 검증 프로시저(P_DMF0014_CUST_FCST_EXCEL_UPLOAD, 07-08 fix)가
	    //   스테이징에서 'ATTRIBUTE1 IS NULL 인 날짜행'을 직접 찾아 버킷을 산출한다. 여기선 기간 컬럼 순서 판별용.
	    Map<String, Object> titleDateRow = null;
	    if (!excelList.isEmpty() && targetKeys.length > 0) {
	        Map<String, Object> first = excelList.get(0);
	        Object leadKeyVal = first.get(targetKeys[0].trim());
	        if (leadKeyVal == null || leadKeyVal.toString().trim().isEmpty()) {
	            titleDateRow = first;
	        }
	    }

	    // 컬럼 순서(_COL1..N) 결정
	    List<String> orderedCols = new ArrayList<>();
	    if (titleDateRow != null) {
	        final Map<String, Object> tdr = titleDateRow; // 람다/정렬용 final 별칭
	        // 식별 컬럼 = HEADER_CONTENT 토큰 중 날짜 행에 존재하고 값이 비어있는 것 (Division*..Model 순서 보존).
	        //   HEADER_CONTENT 의 stale 기간 토큰(W27 등)은 실제 파일에 없어(containsKey=false) 자동 제외된다.
	        for (String tk : targetKeys) {
	            String key = tk.trim();
	            if (tdr.containsKey(key)) {
	                Object dv = tdr.get(key);
	                if (dv == null || dv.toString().trim().isEmpty()) orderedCols.add(key);
	            }
	        }
	        // 기간 컬럼 = 날짜 행에 시작일이 채워진 엑셀 컬럼 전체(동적 주차), 시작일 오름차순(시트 기간 순).
	        List<String> periodCols = new ArrayList<>();
	        for (Map.Entry<String, Object> e : tdr.entrySet()) {
	            Object dv = e.getValue();
	            if (dv != null && !dv.toString().trim().isEmpty()) periodCols.add(e.getKey());
	        }
	        periodCols.sort((a, b) -> tdr.get(a).toString().trim()
	                .compareTo(tdr.get(b).toString().trim()));
	        orderedCols.addAll(periodCols);
	    } else {
	        // ⭐ [2026-08-14] 1단 헤더 업로드 — 기간 컬럼의 **헤더가 곧 버킷 시작일**(YYYYMMDD)이다.
	        //   SP 는 V_TITLE(헤더행) 의 ATTRIBUTE14~ 에서 버킷을 읽으므로, 날짜 헤더가 그대로 실리면
	        //   별도 일자행(2단) 없이도 업로드가 성립한다. (2단 지원 블록은 EXISTS 가드로 미동작)
	        //   ⚠ 헤더가 항상 문자열로 오지는 않는다 — 사용자가 엑셀에서 편집·저장하면 날짜 헤더가
	        //     숫자 셀로 바뀌어 '20260803.0' / '2.0260803E7' 로 읽힐 수 있다(같은 계열의 값 셀
	        //     방어가 SP NORMALIZE 07-08 에 이미 있다). 원형 그대로만 보면 그 열 전량이 조용히
	        //     탈락해 기간 컬럼 0개 → 아래 fallback 으로 빠지고 **전건 BUCKET 오류**가 된다.
	        List<String> periodCols = new ArrayList<>();
	        Map<String, Object> firstRow = excelList.isEmpty() ? null : excelList.get(0);
	        if (firstRow != null) {
	            for (String k : firstRow.keySet()) {
	                if (normalizeYmdHeader(k) != null) periodCols.add(k);
	            }
	        }
	        if (periodCols.isEmpty()) {
	            // 날짜 헤더가 없는 업로드 → 기존 동작 보존: HEADER_CONTENT 토큰 순서 그대로.
	            for (String tk : targetKeys) orderedCols.add(tk.trim());
	        } else {
	            // 식별 컬럼 = HEADER_CONTENT 토큰 중 **파일에 실재하는 것만**.
	            //   stale 기간 토큰(W27 등)을 그대로 넣으면 빈 컬럼이 끼어 ATTRIBUTE 위치가 통째로 밀린다.
	            for (String tk : targetKeys) {
	                String key = tk.trim();
	                if (firstRow.containsKey(key)) orderedCols.add(key);
	            }
	            // 시트 기간 순 — 표기(문자/숫자)가 섞여도 정규화한 YYYYMMDD 로 정렬한다.
	            periodCols.sort((a, b) -> normalizeYmdHeader(a).compareTo(normalizeYmdHeader(b)));
	            orderedCols.addAll(periodCols);
	        }
	    }

	    // @TITLE(라벨) 행. 2단 업로드에서는 SP 가 버킷을 날짜행에서 산출하므로 라벨만 싣지만,
	    //   1단 업로드에서는 **이 행의 기간 컬럼이 곧 버킷 일자**다.
	    //   ⭐ 숫자로 읽힌 날짜 헤더는 여기서 'YYYYMMDD' 로 되돌려 싣는다 — SP 가 TO_NUMBER 로 버티긴
	    //     하지만, 원장/로그에 '2.0260803E7' 같은 표기가 남으면 추적이 어려워진다.
	    Map<String, Object> headerMap = new LinkedHashMap<>();
	    headerMap.put("UPLOAD_STAT", "@TITLE"); // 헤더 행 식별자
	    for (int i = 0; i < orderedCols.size(); i++) {
	        String col = orderedCols.get(i);
	        String ymd = normalizeYmdHeader(col);
	        headerMap.put("_COL" + (i + 1), ymd != null ? ymd : col);
	    }
	    transformedList.add(headerMap);

	    // 실제 데이터 행 — 날짜 행 포함(제외 안 함). 날짜 행은 식별 컬럼이 공란("")이라 Oracle 에서
	    //   ATTRIBUTE1=NULL 로 저장되고, 기간 컬럼엔 연속 시작일이 실려 SP 버킷 산출(ATTRIBUTE14~)의 근거가 된다.
	    for (int r = 0; r < excelList.size(); r++) {
	        Map<String, Object> excelRow = excelList.get(r);
	        Map<String, Object> attrMap = new LinkedHashMap<>();
	        attrMap.put("UPLOAD_STAT", "UPLOAD"); // 데이터 행 식별자
	        for (int i = 0; i < orderedCols.size(); i++) {
	            String col = orderedCols.get(i);
	            Object value = excelRow.get(col);
	            attrMap.put("_COL" + (i + 1), value != null ? value.toString().trim() : "");
	        }
	        transformedList.add(attrMap);
	    }

	    return transformedList;
	}
}
