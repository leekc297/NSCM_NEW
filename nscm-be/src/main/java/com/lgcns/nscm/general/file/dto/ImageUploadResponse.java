package com.lgcns.nscm.general.file.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 이미지 업로드 결과 응답 DTO
 * url은 상대경로이며, 프론트엔드에서 API baseURL을 앞에 붙여 &lt;img src&gt;를 조립한다.
 */
@Getter
@NoArgsConstructor
public class ImageUploadResponse {

	/** 첨부파일 ID (UUID) */
	private String fileId;

	/** 이미지 조회 상대경로 (예: /file/image/{fileId}) */
	private String url;

	/** 원본 파일명 */
	private String fileName;

	/** 파일 크기 (byte) */
	private long size;

	@Builder
	public ImageUploadResponse(String fileId, String url, String fileName, long size) {
		this.fileId = fileId;
		this.url = url;
		this.fileName = fileName;
		this.size = size;
	}
}
