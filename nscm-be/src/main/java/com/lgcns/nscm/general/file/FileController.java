	package com.lgcns.nscm.general.file;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
import com.lgcns.nscm.framework.model.BaseResponse;
import com.lgcns.nscm.framework.utils.MapUtils;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;
import com.lgcns.nscm.general.file.dto.ImageFileDto;
import com.lgcns.nscm.general.file.dto.ImageUploadResponse;

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
    private final ImageFileService imageFileService;

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

    /**
     * @MethodName : imageUpload
     * @Description: 에디터/공지사항 본문에 삽입할 이미지를 업로드한다.
     *               응답의 url은 상대경로이므로, 프론트엔드에서 API baseURL을 앞에 붙여 &lt;img src&gt;를 조립한다.
     * @param      : @param file 업로드 이미지 (jpg, jpeg, png, gif, webp / 최대 15MB)
     * @param      : @param fileKdnCd 업무 구분 코드 (선택, 기본값 BASIC)
     * @return     : ResponseEntity
     *
     * SystemLogAspect가 대상 메서드의 인자 전체를 JSON 직렬화하여
     * 업로드 이미지 바이너리가 통째로 변환되므로 @SystemLog는 적용하지 않는다.
     */
    @AuthCheck(Type.LOGIN)
    @PostMapping(value="/file/image-upload", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<ImageUploadResponse>> imageUpload(
    		@LoginUser UserSession userSession
    		, @RequestParam("file") MultipartFile file
    		, @RequestParam(value = "fileKdnCd", required = false) String fileKdnCd
    		) throws Exception {
    	return successResponseEntity(imageFileService.upload(file, fileKdnCd, userSession.getUserId()));
    }

    /**
     * @MethodName : getImage
     * @Description: 업로드된 이미지를 조회한다. 브라우저의 &lt;img&gt; 태그가 직접 호출한다.
     *               조회 로그가 과도하게 쌓이는 것을 막기 위해 @SystemLog는 적용하지 않는다.
     * @param      : @param fileId 첨부파일 ID
     * @return     : ResponseEntity
     */
    @AuthCheck(Type.LOGIN)
    @GetMapping("/file/image/{fileId}")
    public ResponseEntity<byte[]> getImage(@PathVariable String fileId) throws Exception {
    	ImageFileDto image = imageFileService.get(fileId);
    	if (image == null) return ResponseEntity.notFound().build();

    	HttpHeaders headers = new HttpHeaders();
    	headers.set(HttpHeaders.CONTENT_TYPE, ImageValidator.toContentType(image.getExtension()));
    	headers.set(HttpHeaders.CONTENT_DISPOSITION, "inline");
    	headers.set(HttpHeaders.CACHE_CONTROL, "private, max-age=3600");
    	headers.set("X-Content-Type-Options", "nosniff");

    	return new ResponseEntity<byte[]>(image.getContent(), headers, HttpStatus.OK);
    }

}
