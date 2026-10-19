export const MENU_ID = 'SDM5010' as const;
export type MENU_ID = typeof MENU_ID;

// SDM5010 Project Master (SDM > SDM_Admin > Project Master — ROUTE_PATH 'sdm/project-master' 후속).
//   ⭐ 정본 원천 = 화면설계서 xlsx (AS-IS GSCM 대응 화면 부재 — 순수 신규, hook #134) +
//     메타 등재 계약 `_artifacts/_apply_corporate/SDM5010_META_20260819/_CONTRACT.md` (배선 단일 원천).
//   TAB1 '프로젝트 등록 요청' = 조회(Session 본인 필터 — 조회조건 미소비 F-3) + 셀 편집(수정 항목
//     11종 P-07) + 행 내 승인(CONFIRM)/반려(CANCEL) 버튼(REG_COL — FE 파생 렌더 F-15) + 권한관리 링크.
//   TAB2 '프로젝트 Master 관리' = 조회 + 개발현황/비활성 2컬럼 편집(P-12) + SAVE('M' 행별 단건).
//   권한관리 모달 = SDM1010 `AuthManagementPopup` 공용 컴포넌트 재사용 (F-22 — 모달 내부 MENU_ID
//   는 SDM1010 유지: POP1_* 메타·권한 소유. 신규 작성 금지).
export enum SHEETS {
  TAB1 = 'TAB1',
  TAB2 = 'TAB2',
}

// 커서명 'data' (PROC_M 실등재 — SDM1010/SDM1020 RESPONSE_SET 용법 동일)
export enum RESPONSE_SET {
  DATA = 'data',
}

// 탭 인덱스 (TabWrapper activeTabIndex)
export enum TAB_INDEX {
  TAB1,
  TAB2,
}

// 커스텀/행 버튼 BTN_CD (계약 ② — hasButton 게이트 축. SEARCH/EXCEL/FILTER/SORT/SAVE 는 공통 버튼)
export const BTN = {
  CONFIRM: 'CONFIRM', // TAB1 행 내 승인 — PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM (행별 단건)
  CANCEL: 'CANCEL', // TAB1 행 내 반려 — PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL (행별 단건)
  SAVE: 'SAVE', // TAB2 저장 — PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER ('M' 행별 단건)
} as const;

// ⭐ '수정' 구분 코드 (2026-08-19 사용자 확정 — DPJT_REG_CAT='MOD' 행 = 행 단위 색상 P-05 +
//   D-PJT Code 편집 불가 P-06/F-9)
export const REG_CAT_MOD = 'MOD' as const;

// ⭐ DISABLE_YN 서버 문자열 (계약 ⑥ — GET 은 CHECKED/UNCHECKED 2값. SAVE `disabled` 는
//   'CHECKED' 정확 일치만 DISABLED, 그 외 NORMAL. FE 재파생 금지 — 값 그대로 왕복)
export { CHECK_STATE as DISABLE_CHECK } from '../../lib/grid';

// 조회조건 lookup 타입 (SCM0001_GET_LOOKUP_VALUES 도메인 — useTabLookupQueries 소비, CF-03/CF-05)
export const LOOKUP = {
  CELL_TYPE: 'SPMS_CELL_TYPE',
  DEVELOP_STATUS: 'SPMS_DPJT_DEVELOP_STATUS', // 임시 시드 DEV/PROD/DROP (F-21/T-4)
} as const;

// ⭐ MSG 매핑 — 계약 ③ 확정 (재사용 8 + 신규 MSG01008~MSG01013. 팝업 내부 MSG 는 모달(SDM1010) 소유)
export const MSG = {
  DIVISION_REQUIRED: 'MSG00097', // Division 필수 (P-01)
  DATE_INVERTED: 'MSG00108', // 기간 필수·역전 (P-02)
  RANGE_OVER_3Y: 'MSG00164', // 기간 3년 초과 (P-03 — 계약 ③: MSG00715 중복 잔재 소비 금지)
  PENDING_SEARCH_CONFIRM: 'MSG00703', // 수정 pending 중 재조회/탭 전환 confirm (UC-02/E03)
  SAVED: 'MSG00002', // TAB2 저장 성공 (⭐ toast — hook #132)
  SAVE_ERROR: 'MSG00003', // TAB2 저장 실패
  NO_CHANGES: 'MSG00004', // 수정된 내용 없음 (EVENT 0 허위성공 방지 계보 겸용)
  CONFIRM_CONFIRM: 'MSG01008', // 승인 confirm (E06)
  CONFIRM_DONE: 'MSG01009', // 승인 성공 (toast)
  CONFIRM_FAIL: 'MSG01010', // 승인 실패 (설계서 '실해' 오타 정정 F-7)
  CANCEL_CONFIRM: 'MSG01011', // 반려 confirm (E07)
  CANCEL_DONE: 'MSG01012', // 반려 성공 (toast)
  CANCEL_FAIL: 'MSG01013', // 반려 실패
} as const;

// LBL 매핑 — 계약 ③ (재사용 8 + 신규 LBL00863)
export const LBL = {
  DIV: 'LBL00001',
  CUSTOMER: 'LBL01003',
  CELL_TYPE: 'LBL01005',
  BIZ_TYPE: 'LBL00607',
  DEVELOP_STATUS: 'LBL01007', // 신규 (Development Status)
  REG_COMP_DATE: 'LBL01006',
  APPROVE: 'LBL01004', // TAB1 승인 버튼
  REJECT: 'LBL00863', // TAB1 반려 버튼
  SEARCH: 'LBL00112', // Search 라벨 고정 (hook #120 §5)
} as const;

// TAG 렌더 메타 ATTRIBUTE1 값 (계약 ④ — CT 'S'+ATTRIBUTE1 'TAG')
export const TAG_ATTR = 'TAG' as const;

// FPModal 셀 메타 ATTRIBUTE1 → 모달 배선 (계약 ④ DPJT_ATUH_REG_STR — 하드코딩 바인딩 금지)
export const MODAL_ATTR = {
  AUTH_REG: 'ProjectAuthRegModal',
} as const;

// TAB1 승인/반려 행 버튼 컬럼 ATTRIBUTE1 (계약 ④ REG_COL — 커서 '' 반환·FE 파생 렌더 F-15)
export const REG_ACTION_ATTR = 'REG_ACTION' as const;

// ⭐ TAG pill 색·표시 컬럼 (SDM1020 TAG_SOURCE 승계 — 바인딩 = 값 컬럼(DPJT_ATUH_REG_STATUS),
//   표시 = NAME 컬럼 / 색 = COLOR_TYPE 컬럼(H — 커서 실명, 계약 ⑤). 미등재 바인딩은 관례 폴백)
export const TAG_SOURCE: Record<string, { name: string; color: string }> = {
  DPJT_ATUH_REG_STATUS: {
    name: 'DPJT_ATUH_REG_STATUS_NAME',
    color: 'DPJT_ATUH_REG_STATUS_COLOR_TYPE',
  },
};

// ⭐ 행 CELL_TYPE 종속 셀 콤보 (CF-15 — Cell Type 변경 시 Stack Method clear + dataMap 스왑.
//   행 단위 종속은 이 1건뿐 — 조회 Division 축 콤보는 Division 변경 시 그리드가 비워지므로
//   dataMap 재구성으로 충분, Cascade 문서 §4)
export const CELLTYPE_SCOPED_COMBO = 'StackMethodByCellType' as const;
export const CELL_TYPE_BINDING = 'CELL_TYPE' as const;
export const STACK_METHOD_BINDING = 'STACK_METHOD' as const;

// TAB1 D-PJT Code 바인딩 (P-06/P-08 — DPJT_CODE_MOD_YN 편집 게이트 + 승인 시 9자리 FE 선검증 D12)
export const DPJT_CODE_BINDING = 'DPJT_CODE' as const;
export const DPJT_CODE_LENGTH = 9 as const;

// TAB2 비활성 체크 바인딩 (계약 ⑥ — FPCheckBox 클릭 토글 + CRUD_TYPE 'M' 마킹)
export const DISABLE_YN_BINDING = 'DISABLE_YN' as const;
