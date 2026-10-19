import type { MENU_ID, SHEETS } from './safety-stock.constants';

// SCP0128 SafetyStock — 단일 그리드(spdMain). PKG_SCP0128 미배포로 procedures.d.ts SSOT 에
//   아직 등록 없음 — Base index-signature 로 loose(WijmoRowItem) 해석된다(SCP0002 LineMaster 동일
//   선례, memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 결함 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

/**
 * 조회조건 (design/02_search-combo.md §1 인벤토리 8개 논리조건 전건: Division/Plan Group/Site/
 * Type/Stage/Period/Item Id+팝업/Valid).
 *
 * scmSiteId/valueType/stage 는 전용 SP `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO`(init 시트)의
 * 다중커서에서 옵션을 받아 실배선한다(SafetyStockForm). Site 는 다중선택(콤마결합), Type/Stage 는 단일.
 */
export interface SearchParamProps {
  divisionId: string;
  planGroupId: string; // 다중선택 — 콤마결합 문자열
  scmSiteId: string; // 다중선택 — 콤마결합(init o_rc2, Division cascade + IN('81','40','82') base 필터)
  itemId: string;
  stage: string; // 단일선택(init o_rc3 OPMZ_STAGE_CD, Division cascade)
  validYn: string;
  valueType: string; // 단일선택 Type(init o_rc4 COVER_DAY_TYPE MAX/MIN)
  periodFrom: string;
  periodTo: string;
}
