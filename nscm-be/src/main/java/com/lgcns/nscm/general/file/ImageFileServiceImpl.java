package com.lgcns.nscm.general.file;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.lgcns.nscm.framework.base.BaseConstants;
import com.lgcns.nscm.framework.base.BaseService;
import com.lgcns.nscm.framework.exception.BusinessException;
import com.lgcns.nscm.general.file.dto.ImageFileDto;
import com.lgcns.nscm.general.file.dto.ImageUploadResponse;

@SuppressWarnings({ "rawtypes", "unchecked" })
@Service
public class ImageFileServiceImpl extends BaseService implements ImageFileService {

	/** 이미지 조회 상대경로 prefix. 절대 URL은 프론트엔드에서 API baseURL을 붙여 조립한다. */
	private static final String IMAGE_URL_PREFIX = "/file/image/";

	/** 첨부파일 유형 코드 */
	private static final String FILE_TYPE_IMAGE = "IMAGE";

	/** 업무 구분 코드 기본값 */
	private static final String DEFAULT_FILE_KDN_CD = "BASIC";

	@Override
	public ImageUploadResponse upload(MultipartFile file, String fileKdnCd, String userId) throws Exception {
		if (file == null || file.isEmpty()) {
			throw new BusinessException("업로드할 이미지 파일이 없습니다.");
		}

		byte[] content = file.getBytes();
		String originalFilename = file.getOriginalFilename();
		String extension = ImageValidator.validate(originalFilename, content);

		// SYS_GUID()는 insert 후 값을 돌려받을 수 없어 조회 URL을 만들 수 없으므로 ID를 애플리케이션에서 생성한다.
		String fileId = UUID.randomUUID().toString();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fileId", fileId);
		params.put("fileName", originalFilename);
		params.put("fileTpCd", FILE_TYPE_IMAGE);
		params.put("fileKdnCd", (fileKdnCd == null || fileKdnCd.isBlank()) ? DEFAULT_FILE_KDN_CD : fileKdnCd);
		params.put("ext", extension);
		params.put("size", content.length);
		params.put("ctn", content);
		params.put("userId", userId);

		try {
			if (insert("admin.file.insertImageFile", params) < 1) {
				throw new BusinessException("이미지 저장에 실패했습니다.");
			}
		} catch (BusinessException e) {
			throw e;
		} catch (Exception e) {
			throw new BusinessException("Error imageUpload: " + e.getMessage());
		}

		return ImageUploadResponse.builder()
				.fileId(fileId)
				.url(IMAGE_URL_PREFIX + fileId)
				.fileName(originalFilename)
				.size(content.length)
				.build();
	}

	@Override
	public ImageFileDto get(String fileId) throws Exception {
		if (fileId == null || fileId.isBlank()) return null;

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fileId", fileId);

		List<Map> fileList = (List<Map>) selectList("admin.file.selectImageFile", params)
				.get(BaseConstants.DEFAULT_DATA_RESULT);
		if (fileList == null || fileList.isEmpty()) return null;

		Map fileInfo = fileList.get(0);
		Object ctn = fileInfo.get("ATCH_FILE_CTN");
		if (ctn == null) return null;

		// 매퍼의 resultMap이 byte[]로 실체화해준다.
		// 그렇지 않으면 세션이 닫힌 뒤 읽을 수 없는 BLOB 로케이터가 넘어오므로 원인을 명확히 알린다.
		if (!(ctn instanceof byte[])) {
			throw new BusinessException(
					"이미지 데이터를 byte[]로 읽지 못했습니다. type=" + ctn.getClass().getName());
		}
		byte[] content = (byte[]) ctn;

		Object size = fileInfo.get("ATCH_FILE_SIZE");

		return ImageFileDto.builder()
				.fileName((String) fileInfo.get("ATCH_FILE_SAVE_NM"))
				.extension((String) fileInfo.get("ATCH_FILE_EFNM_NM"))
				.size(size instanceof Number ? ((Number) size).longValue() : content.length)
				.content(content)
				.build();
	}
}
