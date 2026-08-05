package com.lgcns.nscm.general.file.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 이미지 조회 결과 DTO
 */
@Getter
@NoArgsConstructor
public class ImageFileDto {

	/** 원본 파일명 */
	private String fileName;

	/** 확장자 (소문자) */
	private String extension;

	/** 파일 크기 (byte) */
	private long size;

	/** 이미지 바이너리 */
	private byte[] content;

	@Builder
	public ImageFileDto(String fileName, String extension, long size, byte[] content) {
		this.fileName = fileName;
		this.extension = extension;
		this.size = size;
		this.content = content;
	}
}
