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
	        // 날짜 행 없는 업로드(단일 헤더) → 기존 동작: HEADER_CONTENT 토큰 순서 그대로
	        for (String tk : targetKeys) orderedCols.add(tk.trim());
	    }

	    // @TITLE(라벨) 행 — SP 는 버킷을 V_TITLE 이 아니라 날짜행에서 산출하므로 라벨만 싣는다.
	    Map<String, Object> headerMap = new LinkedHashMap<>();
	    headerMap.put("UPLOAD_STAT", "@TITLE"); // 헤더 행 식별자
	    for (int i = 0; i < orderedCols.size(); i++) {
	        headerMap.put("_COL" + (i + 1), orderedCols.get(i));
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
