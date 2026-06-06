package com.lgcns.nscm.general.file;

import java.util.Map;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;

public interface FileService {

	/**
	 *
	 * @MethodName : excelFileUplad
	 * @Description:
	 <p><b>Usage Example:</b></p>
	 * <pre style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px; border-radius: 5px;">
	 * {@code
	 *
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 3. 25.
	 * @param      : @param params
	 * @param      : @return
	 * @return     : String
	 */
	Map<String, Object> excelFileUplad(Map<String, Object> params) throws Exception;

	/**
	 * G5 File Transfer (Phase 7 A1, 2026-06-04) — 일반 파일 업로드.
	 * params: mnuId, shtNm, file(MultipartFile), uploadedBy
	 * return: { fileId, fileName, fileSize, uploadedAt }
	 */
	Map<String, Object> fileUpload(Map<String, Object> params) throws Exception;

	/**
	 * G5 — 파일 다운로드 (binary stream).
	 * params: mnuId, shtNm, fileId
	 * return: ResponseEntity<Resource> with Content-Disposition: attachment
	 */
	ResponseEntity<Resource> fileDownload(Map<String, Object> params) throws Exception;

	/**
	 * G5 — 파일 삭제 (soft delete = DELETED_YN='Y').
	 * params: mnuId, shtNm, fileId, deletedBy
	 * return: { success: true, fileId }
	 */
	Map<String, Object> fileDelete(Map<String, Object> params) throws Exception;

}
