package com.lgcns.nscm.general.file;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
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
				// 엑셀 데이터 > 엑셀 업로드용 데이터롷 변경
				excelJsonData = cvtListUploadJson(excelList, headerContent);
				// 엑셀 업로드 temp 테이블에 insert
				params.put("excelData", excelJsonData);
				params.put("colCnt", getPipeCount(headerContent));
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

	private String cvtListUploadJson(List<Map<String, Object>> excelList, String keyTemplate) {
	    List<Map<String, Object>> transformedList = new ArrayList<>();

	    // 1. 기준이 되는 키 목록을 배열로 분리 (limit -1로 마지막 공백 포함)
	    String[] targetKeys = keyTemplate.split("\\|", -1);

	    // 2. 첫 번째 행에 헤더 정보 및 @TITLE 상태값 추가
	    Map<String, Object> headerMap = new LinkedHashMap<>();
	    headerMap.put("UPLOAD_STAT", "@TITLE"); // 헤더 행 식별자

	    for (int i = 0; i < targetKeys.length; i++) {
	        String attrKey = "_COL" + (i + 1);
	        headerMap.put(attrKey, targetKeys[i].trim());
	    }
	    transformedList.add(headerMap);

	    // 3. 실제 데이터 행 변환 및 UPLOAD 상태값 추가
	    for (Map<String, Object> excelRow : excelList) {
	        Map<String, Object> attrMap = new LinkedHashMap<>();
	        attrMap.put("UPLOAD_STAT", "UPLOAD"); // 데이터 행 식별자

	        for (int i = 0; i < targetKeys.length; i++) {
	            String targetKey = targetKeys[i].trim();
	            String attrKey = "_COL" + (i + 1);
	            Object value = excelRow.get(targetKey);
	            if (value != null) attrMap.put(attrKey, value.toString().trim());
	            else attrMap.put(attrKey, "");
	        }
	        transformedList.add(attrMap);
	    }

	    // 4. 최종 리스트를 JSON 문자열로 변환
	    try {
	    	return objectMapper.writeValueAsString(transformedList);
	    } catch (JsonProcessingException e) {
	        log.error("JSON conversion error: {}", e.getMessage());
	        return "[]";
	    }
	}


/*========================================================================================================================== */




}
