package com.lgcns.nscm.admin.menu.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 컬럼 개인화(titleSet) 저장 요청 — 공용 Column 팝업(ColumnLayoutModal) 전용.
 *
 * <p>SCM0002_SET_TITLESET_POPUP 은 다건을 '^' 로 이어붙인 문자열 인자로 받는다(DELETE 후 INSERT).
 * 따라서 컬럼별 값들은 모두 같은 길이의 '^' delim 문자열이어야 하며, 순서가 곧 컬럼 대응이다.
 *
 * <p>programId 는 path variable({mnuId})에서, sesUserId 는 로그인 세션에서 채우므로 body 에 없다.
 */
@Getter
@NoArgsConstructor
public class TitleSetSaveRequest {

	/** admin SHEET_NAME (예: 'Sales Price') — 조회 팝업에 넘기는 값과 반드시 동일해야 한다. */
	private String sheetName;

	/** 개인화 구분 ('C' = 컬럼 / 'M' = measure. 화면에 따라 'main' 등 자체 값 사용). */
	private String columnType;

	/** '^' delim — 사용 여부(전부 'Y'). */
	private String activeFlag;

	/** '^' delim — 컬럼명. */
	private String columnName;

	/** '^' delim — 표시 순서. */
	private String sortOrderNo;

	/** '^' delim — 소계 사용 여부. */
	private String subTotalFlag;

	/** '^' delim — 정렬 방식. */
	private String sortMethodCode;

	/** '^' delim — 컬럼 폭 (2026-07-27 확장). */
	private String columnWidth;

	/** '^' delim — 셀 배경색 hex (2026-07-27 확장). */
	private String cellColor;

	/** '^' delim — 글자색 hex (2026-07-27 확장). */
	private String textColor;
}
