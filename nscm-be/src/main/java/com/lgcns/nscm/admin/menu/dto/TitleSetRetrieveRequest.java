package com.lgcns.nscm.admin.menu.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 컬럼 개인화(titleSet) 조회 요청 — 공용 Column 팝업(ColumnLayoutModal) 전용.
 *
 * <p>{@link TitleSetSaveRequest} 와 대칭. DMF0002_GET_TITLESET_POPUP 은 programId/sheetName 을
 * 인자로 받아 메뉴에 종속되지 않으므로, 화면마다 SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_API_M /
 * SCM_ADM_PROC_M 를 등록해야 하는 call-proc 경로 대신 고정 매핑 엔드포인트를 쓴다.
 *
 * <p>programId / mnuId 는 path variable({mnuId})에서, sesUserId 는 로그인 세션에서 채우므로 body 에 없다.
 */
@Getter
@NoArgsConstructor
public class TitleSetRetrieveRequest {

	/** admin SHEET_NAME (예: 'Biz Plan') — 저장(saveTitleSet)에 넘기는 값과 반드시 동일해야 한다. */
	private String sheetName;

	/** 개인화 구분 ('C' = 컬럼 / 'M' = measure. 화면에 따라 'main' 등 자체 값 사용). */
	private String columnType;

	/** 사업부. SP 가 division 별 컬럼 세트를 서버에서 필터한다. */
	private String divisionId;
}
