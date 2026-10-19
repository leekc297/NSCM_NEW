package com.lgcns.nscm.general.file;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.framework.utils.ExcelUtils;


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
				//   DMF0074(Metal Link Price) 는 Excel Form 다운로드가 그리드 그대로(2단 헤더:
				//   그룹행+원소행)를 내보내므로 재업로드 시 전용 2단 헤더 파서를 쓴다.
				//   PROGRAM_ID 는 'DMF0074'(대형) / 'DMF0074_40'(소형) 두 가지 모두 대상.
				String mnuId = String.valueOf(params.get("mnuId"));
				boolean isTwoHeaderRowMenu = mnuId.startsWith("DMF0074");
				List<Map<String, Object>> excelList = isTwoHeaderRowMenu
						? ExcelUtils.convertExcelToJsonTwoHeaderRows((MultipartFile) params.get("excelfile"))
						: ExcelUtils.convertExcelToJson((MultipartFile) params.get("excelfile"));
				/* 26.09.07
					헤더 검증 — HEADER_CONTENT 필수 토큰('*' 접미)이 엑셀 1행 헤더에 그대로 없으면
					(컬럼명 변경/오탈자 등) SP 까지 빈 값으로 흘러가 ORA-01403 등 원인불명 에러로 터진다.
					 AS-IS 공용 ExcelUploadForm 의 MSG00450(헤더 미검출) 과 동일 시점의 방어.
				*/
				validateExcelHeader(excelList, headerContent);
				// 엑셀 데이터 > 업로드용 행 리스트 (@TITLE + UPLOAD). 동적 기간 컬럼은 엑셀 날짜 행 기준.
				//   2단 헤더 메뉴(DMF0074)는 컬럼이 헤더 2행에 전부 고정 선언돼 있어 titleDateRow
				//   휴리스틱(3번째 행 값 유무로 컬럼을 골라내는 DMF0014 동적 주차 컬럼 전용 로직)이
				//   불필요 — 오히려 3행 값이 우연히 빈칸인 컬럼을 통째로 누락시키는 회귀를 낸다
				//   (2026-09-22 실사고: PeriodFr/PeriodTo 등 그룹 전체가 Error Detail 에서 사라짐).
				//   isTwoHeaderRowMenu 는 항상 HEADER_CONTENT 순서 그대로 전 컬럼을 고정 노출한다.
				//   DMF0014(Customer FCST Upload) — 1단 헤더 폼은 헤더 1행 자체가 이미 실제 날짜
				//   문자열(예: '20260921')로 채워진 자기서술형 기간 컬럼이라, titleDateRow 휴리스틱
				//   (2행 선두 식별컬럼이 빈칸인지로 날짜행을 추정)이 필요 없다. 오히려 2행이 우연히
				//   정상 데이터(선두 식별컬럼 채움)이면 날짜행이 아니라고 오판해 기간 컬럼 전체가
				//   HEADER_CONTENT 고정 13열로 되돌아가 통째로 유실되고, 스테이징 ATTRIBUTE14~ 가
				//   비어 버킷타입(WEEKLY/MONTHLY) 판정이 어긋난다(2026-09-23 실사고 — Customer FCST
				//   Upload 전건 Invalid Measure Upload Bucket). DMF0014 는 엑셀 헤더에 실제로 존재하는
				//   컬럼 중 HEADER_CONTENT 에 없는 나머지를 전부 기간 컬럼으로 채택(오름차순 정렬)한다.
				boolean useHeaderDefinedPeriodCols = mnuId.startsWith("DMF0014");
				List<Map<String, Object>> uploadRows =
						cvtListUploadRows(excelList, headerContent, isTwoHeaderRowMenu, useHeaderDefinedPeriodCols);
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

	// 'W27', 'W44' 같은 주차 라벨 토큰 — 매주 굴러가는 동적 컬럼이라 HEADER_CONTENT 에 특정 주차가
	//   박혀 있어도 그 주차가 지나면 영원히 없는 컬럼이 된다(2026-09-23 실사고 — DMF0014 W27~31
	//   토큰이 stale 화 되어 현재 주차 파일(W43~) 업로드가 전건 헤더 검증 실패). 고정 식별 컬럼만
	//   필수로 보고, 주차 라벨은 있으면 검사하되 없어도 통과시킨다.
	private static final java.util.regex.Pattern WEEK_LABEL_TOKEN = java.util.regex.Pattern.compile("^W\\d+$");

	/* 26.09.22
	   HEADER_CONTENT 토큰 전체(필수 '*' 여부 무관)가 엑셀 1행 헤더에 1건이라도 없으면 즉시 중단한다
	   — 업로드 파일 헤더가 Excel Form(업로드 양식) 다운로드 헤더와 다르면 무조건 안내해야 한다는
	   사용자 요구(2026-09-22). 종전엔 '*'(필수) 토큰만 체크해 DMF0074/DMF0082 처럼 HEADER_CONTENT 에
	   '*' 토큰이 아예 없는 메뉴는 이 체크가 사실상 no-op 이었다 — 전체 토큰 비교로 그 구멍을 없앴다.
	   (AS-IS ExcelUploadForm MSG00450 과 동일 시점의 방어 — 대상 범위만 필수→전체로 확장.)
	   2026.09.23 — 주차 라벨(W\d+) 토큰은 이 "전체 필수" 대상에서 제외한다(WEEK_LABEL_TOKEN 참고).
	*/
	private void validateExcelHeader(List<Map<String, Object>> excelList, String headerContent) {
		if (excelList.isEmpty() || isAllBlank(excelList)) {
			// 헤더 밑에 데이터 행이 아예 없거나, 행은 있어도 값이 전부 공백인 경우
			//   (AS-IS ExcelUploadForm MSG00451 과 동일 시점의 방어). 엑셀에서 값만 지워도
			//   POI 상 빈 Row 객체가 남아 excelList 자체는 비어있지 않을 수 있어 값까지 확인한다.
			throw new BusinessException("엑셀 파일에 업로드할 데이터가 존재하지 않습니다.");
		}
		Set<String> actualHeaders = excelList.get(0).keySet();
		List<String> missing = Arrays.stream(headerContent.split("\\|", -1))
				.map(String::trim)
				.filter(tk -> !tk.isEmpty())
				.filter(tk -> !WEEK_LABEL_TOKEN.matcher(tk).matches())
				.filter(tk -> !actualHeaders.contains(tk))
				.collect(Collectors.toList());
		if (!missing.isEmpty()) {
			// MSG01151("Invalid Column Header Title") — 업로드 양식과 실제 파일 헤더가 다를 때 안내.
			//   잘못된(누락된) 헤더명을 메시지 본문에 줄바꿈으로 나열한다(2026-09-22 사용자 요청).
			throw new BusinessException("Invalid Column Header Title\n\n" + String.join("\n", missing));
		}
	}

	// 모든 행의 모든 값이 공백인지 확인 — 값만 지운 빈 행은 POI 상 Row 객체가 남아있어
	//   excelList 자체는 비어있지 않게 파싱될 수 있다.
	private boolean isAllBlank(List<Map<String, Object>> excelList) {
		return excelList.stream().allMatch(row ->
				row.values().stream().allMatch(v -> v == null || v.toString().trim().isEmpty()));
	}

	private List<Map<String, Object>> cvtListUploadRows(
			List<Map<String, Object>> excelList, String keyTemplate, boolean skipTitleDateRow,
			boolean useHeaderDefinedPeriodCols) {
	    List<Map<String, Object>> transformedList = new ArrayList<>();

	    // 기준 키 목록 (HEADER_CONTENT) — 식별 컬럼 매핑용. 기간 컬럼은 여기서 쓰지 않는다(동적 주차).
	    String[] targetKeys = keyTemplate.split("\\|", -1);

	    // 날짜(타이틀) 행 판별 — 2단 헤더(라벨 + 기간 시작일) 업로드에서, 선두 식별 컬럼(targetKeys[0])이
	    //   공란이고 기간 컬럼에만 값이 있는 첫 행이 날짜 행이다.
	    // ※ 날짜 행은 데이터에서 제외하지 않는다 — 검증 프로시저(P_DMF0014_CUST_FCST_EXCEL_UPLOAD, 07-08 fix)가
	    //   스테이징에서 'ATTRIBUTE1 IS NULL 인 날짜행'을 직접 찾아 버킷을 산출한다. 여기선 기간 컬럼 순서 판별용.
	    // skipTitleDateRow(2단 헤더 메뉴) 는 이 휴리스틱 자체를 건너뛴다 — 컬럼이 이미 헤더에 전부
	    //   고정 선언돼 있어 날짜행 판별이 불필요하고, 잘못 걸리면 컬럼이 통째로 누락된다.
	    Map<String, Object> titleDateRow = null;
	    if (!useHeaderDefinedPeriodCols && !skipTitleDateRow && !excelList.isEmpty() && targetKeys.length > 0) {
	        Map<String, Object> first = excelList.get(0);
	        Object leadKeyVal = first.get(targetKeys[0].trim());
	        if (leadKeyVal == null || leadKeyVal.toString().trim().isEmpty()) {
	            titleDateRow = first;
	        }
	    }

	    // 컬럼 순서(_COL1..N) 결정
	    List<String> orderedCols = new ArrayList<>();
	    if (useHeaderDefinedPeriodCols) {
	        // DMF0014 전용 — 1단 헤더 자체가 이미 실제 날짜 문자열('20260921' 등)로 채워진 자기서술형
	        //   기간 컬럼이라, "2행이 비어있으면 날짜행" 추정이 필요 없고 오히려 위험하다(2026-09-23
	        //   실사고). 엑셀 헤더에 실제 존재하는 컬럼 중 HEADER_CONTENT 식별 토큰이 아닌 나머지를
	        //   전부 기간 컬럼으로 채택 — 8자리 날짜 문자열 키라 사전식 정렬이 곧 시간순 정렬이다.
	        Set<String> headerKeys = excelList.isEmpty() ? Set.of() : excelList.get(0).keySet();
	        Set<String> targetKeySet = Arrays.stream(targetKeys).map(String::trim).collect(Collectors.toSet());
	        for (String tk : targetKeys) {
	            String key = tk.trim();
	            if (headerKeys.contains(key)) orderedCols.add(key);
	        }
	        headerKeys.stream()
	                .filter(k -> !targetKeySet.contains(k))
	                .sorted()
	                .forEach(orderedCols::add);
	    } else if (titleDateRow != null) {
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