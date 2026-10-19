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
import com.lgcns.nscm.framework.utils.MapUtils;
import com.lgcns.nscm.framework.utils.NullUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SuppressWarnings({"rawtypes", "unchecked" })
@Service
public class FileServiceImpl extends BaseService implements FileService {

	private static final ObjectMapper objectMapper = new ObjectMapper();

	/* 26.09.22
	   헤더 불일치 메시지 = SCM_ADM_MSG_M MSG01151 ("Invalid Column Header Title" — 메시지 관리 화면에서 변경 가능).
	   대상 화면만 적용하고 그 외 화면은 기존 문구·기존 검사 규칙 그대로 둔다.
	   DMF0074 는 DIV=40 전용 formId 'DMF0074_40' 도 같은 화면이라 함께 포함한다.
	*/
	private static final String INVALID_HEADER_MSG_ID = "MSG01151";
	private static final String INVALID_HEADER_MSG_DEFAULT = "Invalid Column Header Title"; // MSG01151 미등록 환경 대비
	private static final Set<String> INVALID_HEADER_MSG_PROGRAMS = Set.of("DMF0014", "DMF0074", "DMF0074_40", "DMF0082");

	// 헤더 불일치 전용 — 아래 catch 에서 접두어 없이 그대로 전달하기 위한 구분용
	private static final class InvalidExcelHeaderException extends BusinessException {
		private static final long serialVersionUID = 1L;
		InvalidExcelHeaderException(String message) { super(message); }
	}


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
				//   ⭐ [2026-09-14] AS-IS 2단 병합 헤더 양식(DMF0074 Metal Link Price) 우선 판정 — 2단이 아니면 null → 기존 1단 파싱.
				//   2단 판정 시 컬럼 키 = "그룹명_하위명" (HEADER_CONTENT 토큰도 같은 형식).
				MultipartFile excelFile = (MultipartFile) params.get("excelfile");
				List<Map<String, Object>> excelList = ExcelUtils.convertGroupedHeaderExcelToJson(excelFile, headerContent.split("\\|", -1));
				boolean groupedHeader = excelList != null;
				if (!groupedHeader) excelList = ExcelUtils.convertExcelToJson(excelFile);
				/* 26.09.07
					헤더 검증 — HEADER_CONTENT 필수 토큰('*' 접미)이 엑셀 1행 헤더에 그대로 없으면
					(컬럼명 변경/오탈자 등) SP 까지 빈 값으로 흘러가 ORA-01403 등 원인불명 에러로 터진다.
					 AS-IS 공용 ExcelUploadForm 의 MSG00450(헤더 미검출) 과 동일 시점의 방어.
				*/
				validateExcelHeader(excelList, headerContent, (String) params.get("mnuId"));
				// 엑셀 데이터 > 업로드용 행 리스트 (@TITLE + UPLOAD). 동적 기간 컬럼은 엑셀 날짜 행 기준.
				List<Map<String, Object>> uploadRows = cvtListUploadRows(excelList, headerContent, groupedHeader);
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
			// 26.09.22 헤더 불일치 문구는 화면에 그대로 보여야 하므로 접두어("Error excelFileUplad: ") 없이 전달한다.
			if (e instanceof InvalidExcelHeaderException) throw (InvalidExcelHeaderException) e;
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

	/* 26.09.07
	   HEADER_CONTENT 의 필수 토큰('*' 접미 = SHEET_COLUMNS 필수컬럼 표기)이 엑셀 1행 헤더에
	   1건이라도 없으면 즉시 중단한다(AS-IS ExcelUploadForm MSG00450 과 동일 시점의 방어).
	*/
	/* 26.09.22
	   INVALID_HEADER_MSG_PROGRAMS 화면은 헤더 불일치 시 INVALID_HEADER_MSG 로 중단한다.
	   검사 대상 토큰 = HEADER_CONTENT 에 필수표시('*')가 있으면 그 토큰(DMF0014 — 뒤쪽 기간 컬럼은 동적이라 전체 대조 불가),
	   필수표시가 하나도 없으면 전 토큰(DMF0074/DMF0074_40/DMF0082 — 필수표시가 없어 종전엔 검사 없이 통과했다).
	*/
	private void validateExcelHeader(List<Map<String, Object>> excelList, String headerContent, String programId) {
		if (excelList.isEmpty() || isAllBlank(excelList)) {
			// 헤더 밑에 데이터 행이 아예 없거나, 행은 있어도 값이 전부 공백인 경우
			//   (AS-IS ExcelUploadForm MSG00451 과 동일 시점의 방어). 엑셀에서 값만 지워도
			//   POI 상 빈 Row 객체가 남아 excelList 자체는 비어있지 않을 수 있어 값까지 확인한다.
			throw new BusinessException("엑셀 파일에 업로드할 데이터가 존재하지 않습니다.");
		}
		boolean useInvalidHeaderMsg = INVALID_HEADER_MSG_PROGRAMS.contains(programId);
		List<String> tokens = Arrays.stream(headerContent.split("\\|", -1))
				.map(String::trim)
				.filter(tk -> !tk.isEmpty())
				.collect(Collectors.toList());
		boolean hasRequiredMark = tokens.stream().anyMatch(tk -> tk.endsWith("*"));
		Set<String> actualHeaders = excelList.get(0).keySet();
		List<String> missing = tokens.stream()
				.filter(tk -> tk.endsWith("*") || (useInvalidHeaderMsg && !hasRequiredMark))
				.filter(tk -> !actualHeaders.contains(tk))
				.collect(Collectors.toList());
		if (!missing.isEmpty() && useInvalidHeaderMsg) {
			// 26.09.22 메시지 아래 줄 = 엑셀에 적힌 잘못된 헤더명(파일 컬럼 순서). 양식에 있는 토큰·기간(날짜) 컬럼·빈 헤더는 제외.
			//   2단 양식은 "그룹명_하위명" 으로 표기된다. 잘못 적힌 헤더 없이 컬럼이 빠지기만 한 경우엔 빠진 헤더명을 대신 적는다.
			Set<String> tokenSet = new java.util.HashSet<>(tokens);
			List<String> wrong = actualHeaders.stream()
					.filter(h -> h != null && !h.trim().isEmpty())
					.filter(h -> !tokenSet.contains(h.trim()))
					.filter(h -> normalizeYmdHeader(h) == null)
					.collect(Collectors.toList());
			log.warn("[excelUpload] header mismatch program={} missing={} wrong={}", programId, missing, wrong);
			throw new InvalidExcelHeaderException(getMessageNm(INVALID_HEADER_MSG_ID, INVALID_HEADER_MSG_DEFAULT)
					+ "\n" + String.join(", ", wrong.isEmpty() ? missing : wrong));
		}
		if (!missing.isEmpty()) {
			throw new BusinessException("엑셀 파일의 Header 정보 확인 후 재 Upload 하세요! (누락된 필드: "
					+ String.join(", ", missing) + ")");
		}
	}

	// 26.09.22 SCM_ADM_MSG_M 문구 1건 (세션 언어 우선). 조회 실패·미등록이면 기본 문구 — 오류 안내가 조회 오류로 가려지지 않게 한다.
	private String getMessageNm(String msgId, String defaultMsg) {
		try {
			Map<String, Object> param = new HashMap<>();
			param.put("msgId", msgId);
			List<Map> rows = (List<Map>) selectList("admin.excel.selectMessageNm", param).get(BaseConstants.DEFAULT_DATA_RESULT);
			Object msgNm = (rows == null || rows.isEmpty() || rows.get(0) == null) ? null : rows.get(0).get("MSG_NM");
			return NullUtils.isNone(msgNm) ? defaultMsg : msgNm.toString();
		} catch (Exception e) {
			log.warn("[excelUpload] message lookup failed msgId={} : {}", msgId, e.getMessage());
			return defaultMsg;
		}
	}

	// 모든 행의 모든 값이 공백인지 확인 — 값만 지운 빈 행은 POI 상 Row 객체가 남아있어
	//   excelList 자체는 비어있지 않게 파싱될 수 있다.
	private boolean isAllBlank(List<Map<String, Object>> excelList) {
		return excelList.stream().allMatch(row ->
				row.values().stream().allMatch(v -> v == null || v.toString().trim().isEmpty()));
	}

	private List<Map<String, Object>> cvtListUploadRows(List<Map<String, Object>> excelList, String keyTemplate, boolean groupedHeader) {
	    List<Map<String, Object>> transformedList = new ArrayList<>();

	    // 기준 키 목록 (HEADER_CONTENT) — 식별 컬럼 매핑용. 기간 컬럼은 여기서 쓰지 않는다(동적 주차).
	    String[] targetKeys = keyTemplate.split("\\|", -1);

	    // 날짜(타이틀) 행 판별 — 2단 헤더(라벨 + 기간 시작일) 업로드에서, 선두 식별 컬럼(targetKeys[0])이
	    //   공란이고 기간 컬럼에만 값이 있는 첫 행이 날짜 행이다.
	    // ※ 날짜 행은 데이터에서 제외하지 않는다 — 검증 프로시저(P_DMF0014_CUST_FCST_EXCEL_UPLOAD, 07-08 fix)가
	    //   스테이징에서 'ATTRIBUTE1 IS NULL 인 날짜행'을 직접 찾아 버킷을 산출한다. 여기선 기간 컬럼 순서 판별용.
	    // ⭐ 2단 병합 헤더 양식(groupedHeader)은 날짜 행이 없다 — 첫 데이터 행의 Div 가 비어 있어도 날짜 행으로
	    //   오인하지 않도록 판별을 건너뛰고, 아래 1단 분기의 "HEADER_CONTENT 토큰 순서 그대로" 로 간다.
	    Map<String, Object> titleDateRow = null;
	    if (!groupedHeader && !excelList.isEmpty() && targetKeys.length > 0) {
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
