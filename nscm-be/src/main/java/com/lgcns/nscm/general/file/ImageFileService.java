package com.lgcns.nscm.general.file;

import org.springframework.web.multipart.MultipartFile;

import com.lgcns.nscm.general.file.dto.ImageFileDto;
import com.lgcns.nscm.general.file.dto.ImageUploadResponse;

/**
 * 이미지 업로드/조회 서비스.
 *
 * <p>공지사항 등 에디터 본문에 삽입할 이미지를 DB(SCM_COM_ATCH_FILE_M)의 BLOB으로 저장한다.
 * 엑셀 업로드를 담당하는 {@link FileService}와는 책임이 분리되어 있다.</p>
 */
public interface ImageFileService {

	/**
	 * 이미지를 검증 후 DB에 저장하고 조회 URL을 반환한다.
	 *
	 * @param file      업로드 이미지
	 * @param fileKdnCd 업무 구분 코드 (null이면 BASIC)
	 * @param userId    등록자 ID
	 * @return 파일 ID와 조회용 상대경로를 담은 응답
	 * @throws Exception 검증 실패 또는 저장 실패 시
	 */
	ImageUploadResponse upload(MultipartFile file, String fileKdnCd, String userId) throws Exception;

	/**
	 * 파일 ID로 이미지를 조회한다.
	 *
	 * @param fileId 첨부파일 ID
	 * @return 이미지 정보. 존재하지 않으면 null
	 * @throws Exception 조회 실패 시
	 */
	ImageFileDto get(String fileId) throws Exception;
}
