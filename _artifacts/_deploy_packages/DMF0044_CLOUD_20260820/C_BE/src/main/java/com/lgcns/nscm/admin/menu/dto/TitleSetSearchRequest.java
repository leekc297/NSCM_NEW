package com.lgcns.nscm.admin.menu.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 컬럼 개인화(titleSet) 조회 요청 — 공용 Column 팝업(ColumnLayoutModal) 전용.
 *
 * <p>DMF0002_GET_TITLESET_POPUP 호출 인자. programId 는 path variable({mnuId})에서,
 * sesUserId 는 로그인 세션에서 채우므로 body 에 없다 (TitleSetSaveRequest 와 동일 규약).
 *
 * <p>sheetName / columnType 은 저장(TitleSetSaveRequest)과 반드시 동일한 값이어야 한다 —
 * 하나라도 다르면 저장은 되는데 재진입 조회가 그 행을 못 찾는다.
 */
@Getter
@NoArgsConstructor
public class TitleSetSearchRequest {

	/** admin SHEET_NAME (예: 'FcstNPrice') — 저장 팝업에 넘기는 값과 반드시 동일해야 한다. */
	private String sheetName;

	/** 개인화 구분 ('C' = 컬럼 / 'M' = measure. 화면에 따라 'main' 등 자체 값 사용). */
	private String columnType;

	/** 화면 조회조건의 division (SHEET_COLUMNS division 스코프). */
	private String divisionId;
}
