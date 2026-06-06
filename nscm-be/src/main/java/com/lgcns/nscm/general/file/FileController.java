	package com.lgcns.nscm.general.file;

import java.util.HashMap;
import java.util.Map;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.AuthCheck;
import com.lgcns.nscm.framework.annotation.AuthCheck.Type;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.annotation.SystemLog;
import com.lgcns.nscm.framework.annotation.SystemLog.LogType;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.utils.MapUtils;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Tag(name = "8. NSCM file 관련 공통기능")
@SuppressWarnings({"rawtypes" })
@RestController
@RequiredArgsConstructor
public class FileController extends BaseController {

    private final FileService fileService;

    @SystemLog(LogType.EXCELUPLOAD)
    @AuthCheck(Type.ALL)
    @PostMapping(value="/{mnuId}/{shtNm}/{mnuBtnCd}/excel-upload", produces = "application/json; charset=UTF-8")
    public ResponseEntity excelFileUplad(
    		@PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String mnuBtnCd
    		, @RequestParam("file") MultipartFile file
    		) throws Exception {
    	Map params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("mnuBtnCd", mnuBtnCd);
    	params.put("excelfile", file);
    	return successResponseEntity(fileService.excelFileUplad(params));
    }

    // ⭐ G5 File Transfer (Phase 7 A1, 2026-06-04) — 일반 파일 업로드/다운로드/삭제
    // AS-IS DataService.FP_DataPull / FP_DataPush / FP_FileDataClient (147~159) 매핑
    // Storage: application.yml 의 file.storage.path (local filesystem)
    // Metadata: SCM_SYS_FILE 테이블 (별도 메타 SQL `_artifacts/G5_file_transfer_metadata.sql`)

    @SystemLog(LogType.SYSTEM)
    @AuthCheck(Type.ALL)
    @PostMapping(value="/{mnuId}/{shtNm}/file-upload", produces = "application/json; charset=UTF-8")
    public ResponseEntity fileUpload(
    		@PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @RequestParam("file") MultipartFile file
    		, @LoginUser UserSession userSession
    		) throws Exception {
    	Map params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("file", file);
    	params.put("uploadedBy", userSession.getUserId());
    	return successResponseEntity(fileService.fileUpload(params));
    }

    @SystemLog(LogType.SYSTEM)
    @AuthCheck(Type.ALL)
    @GetMapping(value="/{mnuId}/{shtNm}/file-download/{fileId}")
    public ResponseEntity<Resource> fileDownload(
    		@PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String fileId
    		) throws Exception {
    	Map params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("fileId", fileId);
    	return fileService.fileDownload(params);
    }

    @SystemLog(LogType.SYSTEM)
    @AuthCheck(Type.ALL)
    @DeleteMapping(value="/{mnuId}/{shtNm}/file-delete/{fileId}", produces = "application/json; charset=UTF-8")
    public ResponseEntity fileDelete(
    		@PathVariable String mnuId
    		, @PathVariable String shtNm
    		, @PathVariable String fileId
    		, @LoginUser UserSession userSession
    		) throws Exception {
    	Map params = new HashMap<String, Object>();
    	params.put("mnuId", mnuId);
    	params.put("shtNm", shtNm);
    	params.put("fileId", fileId);
    	params.put("deletedBy", userSession.getUserId());
    	return successResponseEntity(fileService.fileDelete(params));
    }

}
