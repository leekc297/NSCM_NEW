package com.lgcns.nscm.general.file;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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

	// G5 File Transfer (Phase 7 A1, 2026-06-04) — application.yml 의 file.storage.path 설정
	// 미설정 시 default: ${user.home}/.nscm/files
	@Value("${file.storage.path:${user.home}/.nscm/files}")
	private String fileStoragePath;


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

	// ⭐ G5 File Transfer (Phase 7 A1, 2026-06-04) — 일반 파일 업로드/다운로드/삭제
	// SCM_SYS_FILE 테이블: FILE_ID(ULID 26자) / MNU_ID / SHT_NM / FILE_NM / FILE_PATH / FILE_SIZE / MIME_TYPE / UPLOADED_BY / UPLOADED_AT / DELETED_YN
	// 메타 SQL 의무: `_artifacts/G5_file_transfer_metadata.sql` (별도 작성)

	@Override
	public Map<String, Object> fileUpload(Map<String, Object> params) throws Exception {
		try {
			MultipartFile file = (MultipartFile) params.get("file");
			if (file == null || file.isEmpty()) {
				throw new BusinessException("[WARN] fileUpload: file is empty");
			}

			String fileId = UUID.randomUUID().toString().replace("-", "");
			String originalName = file.getOriginalFilename();
			long fileSize = file.getSize();
			String mimeType = file.getContentType();

			// Storage path: {fileStoragePath}/{mnuId}/{shtNm}/{fileId}_{originalName}
			Path dir = Paths.get(fileStoragePath, (String) params.get("mnuId"), (String) params.get("shtNm"));
			Files.createDirectories(dir);
			Path target = dir.resolve(fileId + "_" + originalName);
			Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

			// SCM_SYS_FILE INSERT (mapper: general.file.insertFile)
			Map<String, Object> dbParams = new HashMap<>();
			dbParams.put("fileId", fileId);
			dbParams.put("mnuId", params.get("mnuId"));
			dbParams.put("shtNm", params.get("shtNm"));
			dbParams.put("fileName", originalName);
			dbParams.put("filePath", target.toString());
			dbParams.put("fileSize", fileSize);
			dbParams.put("mimeType", mimeType);
			dbParams.put("uploadedBy", params.get("uploadedBy"));
			selectList("general.file.insertFile", dbParams);

			Map<String, Object> result = new HashMap<>();
			result.put("fileId", fileId);
			result.put("fileName", originalName);
			result.put("fileSize", fileSize);
			result.put("mimeType", mimeType);
			return result;
		} catch (IOException e) {
			throw new BusinessException("Error fileUpload (IO): " + e.getMessage());
		} catch (Exception e) {
			throw new BusinessException("Error fileUpload: " + e.getMessage());
		}
	}

	@Override
	public ResponseEntity<Resource> fileDownload(Map<String, Object> params) throws Exception {
		try {
			// SCM_SYS_FILE SELECT (mapper: general.file.selectFile)
			Map<String, Object> fileMeta = (Map<String, Object>) ((List<Map>) selectList("general.file.selectFile", params).get(BaseConstants.DEFAULT_DATA_RESULT)).get(0);
			if (fileMeta == null) {
				throw new BusinessException("[WARN] fileDownload: file not found (fileId=" + params.get("fileId") + ")");
			}

			String filePath = (String) fileMeta.get("FILE_PATH");
			String fileName = (String) fileMeta.get("FILE_NAME");
			String mimeType = (String) fileMeta.get("MIME_TYPE");

			Path path = Paths.get(filePath);
			if (!Files.exists(path)) {
				throw new BusinessException("[WARN] fileDownload: file missing on disk: " + filePath);
			}

			Resource resource = new UrlResource(path.toUri());
			HttpHeaders headers = new HttpHeaders();
			headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"");

			return ResponseEntity.ok()
				.contentType(mimeType != null ? MediaType.parseMediaType(mimeType) : MediaType.APPLICATION_OCTET_STREAM)
				.headers(headers)
				.body(resource);
		} catch (Exception e) {
			throw new BusinessException("Error fileDownload: " + e.getMessage());
		}
	}

	@Override
	public Map<String, Object> fileDelete(Map<String, Object> params) throws Exception {
		try {
			// SCM_SYS_FILE soft delete (DELETED_YN='Y') — mapper: general.file.deleteFile
			selectList("general.file.deleteFile", params);

			Map<String, Object> result = new HashMap<>();
			result.put("success", true);
			result.put("fileId", params.get("fileId"));
			return result;
		} catch (Exception e) {
			throw new BusinessException("Error fileDelete: " + e.getMessage());
		}
	}

}
