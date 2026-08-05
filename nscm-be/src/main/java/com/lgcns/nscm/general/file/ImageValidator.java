package com.lgcns.nscm.general.file;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import com.lgcns.nscm.framework.exception.BusinessException;

/**
 * 이미지 업로드 검증 유틸.
 *
 * <p>DB에 의존하지 않는 순수 검증 로직만 담는다.
 * 확장자 화이트리스트만으로는 png로 이름만 바꾼 HTML/스크립트가 통과하여
 * 저장형 XSS 통로가 되므로, 실제 파일 헤더(매직바이트)까지 함께 검사한다.</p>
 */
public final class ImageValidator {

	/** 허용 확장자 */
	private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp");

	/** 이미지 용량 상한 (15MB) */
	public static final long MAX_IMAGE_SIZE = 15L * 1024 * 1024;

	private ImageValidator() {
	}

	/**
	 * 업로드된 이미지의 파일명과 내용을 검증한다.
	 *
	 * @param originalFilename 원본 파일명
	 * @param content          파일 바이너리
	 * @return 소문자로 정규화된 확장자
	 * @throws BusinessException 검증 실패 시
	 */
	public static String validate(String originalFilename, byte[] content) {
		if (content == null || content.length == 0) {
			throw new BusinessException("업로드할 이미지 파일이 없습니다.");
		}
		if (content.length > MAX_IMAGE_SIZE) {
			throw new BusinessException("이미지 파일 크기는 최대 15MB까지 허용됩니다.");
		}

		String extension = extractExtension(originalFilename);
		if (!ALLOWED_EXTENSIONS.contains(extension)) {
			throw new BusinessException("허용되지 않는 이미지 형식입니다. (허용: jpg, jpeg, png, gif, webp)");
		}
		if (!matchesSignature(extension, content)) {
			throw new BusinessException("파일 내용이 이미지 형식과 일치하지 않습니다.");
		}
		return extension;
	}

	/**
	 * 확장자에 매핑되는 Content-Type을 반환한다.
	 *
	 * @param extension 소문자 확장자
	 * @return Content-Type 문자열
	 * @throws BusinessException 허용 목록에 없는 확장자인 경우
	 */
	public static String toContentType(String extension) {
		String ext = extension == null ? "" : extension.toLowerCase(Locale.ROOT);
		switch (ext) {
			case "jpg":
			case "jpeg":
				return "image/jpeg";
			case "png":
				return "image/png";
			case "gif":
				return "image/gif";
			case "webp":
				return "image/webp";
			default:
				throw new BusinessException("허용되지 않는 이미지 형식입니다.");
		}
	}

	/** 파일명에서 소문자 확장자를 추출한다. 확장자가 없으면 빈 문자열. */
	private static String extractExtension(String originalFilename) {
		if (originalFilename == null) return "";
		int dotIndex = originalFilename.lastIndexOf('.');
		if (dotIndex < 0 || dotIndex == originalFilename.length() - 1) return "";
		return originalFilename.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
	}

	/** 파일 헤더가 확장자에 해당하는 시그니처와 일치하는지 검사한다. */
	private static boolean matchesSignature(String extension, byte[] content) {
		switch (extension) {
			case "jpg":
			case "jpeg":
				// FF D8 FF
				return startsWith(content, 0, 0xFF, 0xD8, 0xFF);
			case "png":
				// 89 50 4E 47 0D 0A 1A 0A
				return startsWith(content, 0, 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A);
			case "gif":
				// "GIF8"
				return startsWith(content, 0, 0x47, 0x49, 0x46, 0x38);
			case "webp":
				// "RIFF" ....(파일크기 4byte).... "WEBP"
				return startsWith(content, 0, 0x52, 0x49, 0x46, 0x46)
						&& startsWith(content, 8, 0x57, 0x45, 0x42, 0x50);
			default:
				return false;
		}
	}

	/** content의 offset 위치부터 주어진 바이트열과 일치하는지 확인한다. */
	private static boolean startsWith(byte[] content, int offset, int... signature) {
		if (content.length < offset + signature.length) return false;
		for (int i = 0; i < signature.length; i++) {
			if ((content[offset + i] & 0xFF) != signature[i]) return false;
		}
		return true;
	}
}
