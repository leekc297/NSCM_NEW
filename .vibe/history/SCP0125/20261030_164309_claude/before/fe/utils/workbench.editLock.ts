// SCP0125 편집잠금 — 권한 × 행상태 × division 매트릭스 순수함수(design 01_layout.md §2.4 A/B/C).
//
// 규범 convert-core §2.4 (편집모드 기본 ON) — AS-IS 의 "조회 직후 전열 잠금 → Edit 버튼으로 해제"
//   모드토글은 이식하지 않는다. 첫 인자였던 `isEditMode` 는 `canEdit`(= `hasButton('EDIT')`)로
//   바뀌었고, 값이 false 인 경우의 의미도 "Edit 미클릭"이 아니라 "EDIT 권한 없음"이다.
//   컬럼 단위 잠금(아래 white-list · 조건부 2건)은 모드가 아니라 컬럼 속성이므로 그대로 유지한다.
//
// hook #130: AS-IS `LockColumn`/`LockRange` 24건의 **컬럼 인덱스 배열을 그대로 옮기지 않는다**.
//   AS-IS 가 그 인덱스로 표현하던 의미(기존행 = CHG_QTY·CHG_RSN 만 / 신규행 = 시트별 white-list)를
//   컬럼명 축으로 인코딩하고, 실제 게이트는 beginningEdit·pastingCell·formatItem 이 이 함수를 본다.
//
// 필수: `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` 는 102행 전건 `'S'`(SEARCH_ONLY)다. 사용자 결정
//   (goal.md §7 B1)으로 메타를 바꾸지 않고 화면 4계층(인라인편집 / 붙여넣기 / 편집셀 시각 /
//   저장 필수검증)을 세트로 배선한다 — 공용 `GridUtils.isEditableCell` 은 'S' 를 전부 false 로
//   판정하므로 이 함수가 그 위에 덮어쓴다.
//
// AS-IS 근거 (SCP0125_Workbench.cs):
//   - 조회 직후 전열 읽기전용 : cs:700 `LockColumn(0, GetMaxColumnIndex(), true)` (G14 — 규범상 미이식)
//   - Edit 버튼 후 기존행     : cs:517~519 `SwitchLock()` + LockColumn ×2 (G10~G12)
//   - 신규행 전열 해제        : SpreadInfo(BASE):8460~8504 `Insert()` (G15)
//   - 신규행 재잠금           : cs:748~752 / 780~784 / 797~800 / 828~832 (G18~G39)
//   - MKT FCST 조건부 잠금    : cs:734~739 `CELL_PROD_SITE_ID` division ≠ '40' (G16)
//   - STOCK 조건부            : cs:461~468 `LINE_ID`/`BEFORE_DEGAS` division == '81_UC' (V3/V4)

import {
  COL,
  DIVISION_CODE,
  EDITABLE_ON_EXISTING_ROW,
  EDITABLE_ON_INSERT_ROW,
  TABS,
} from '../workbench.constants';

/** 신규행 판정 — 공용 `CRUD_TYPE='I'` 전용(자체 행상태 필드 신설 금지, convert-core §2.4). */
export const isInsertRow = (row: Record<string, unknown> | undefined): boolean =>
  !!row && row.CRUD_TYPE === 'I';

/**
 * 셀 편집 가능 판정 — 이 화면 편집 게이트의 단일 원천.
 * `beginningEdit`(e.cancel) · `pastingCell`(e.cancel) · `formatItem`(배경색) 이 같은 함수를 봐야
 * "노란칸인데 못 고치는" 또는 "흰칸인데 붙여넣기가 되는" 상태가 생기지 않는다(hook #95 §1).
 *
 * @param canEdit `hasButton('EDIT')` — 화면 오픈 시 1회 확정되는 권한축(규범 §2.4). 모드 토글이 아니다.
 * @param divisionId 조회조건에서 확정된 division(신규행 DIVISION_ID 와 동일). 조건부 잠금 2건의 입력.
 */
export const isCellEditable = (
  tab: TABS,
  binding: string,
  row: Record<string, unknown> | undefined,
  canEdit: boolean,
  divisionId: string
): boolean => {
  if (!row || !binding) return false;
  // (①) EDIT 권한이 없으면 전열 읽기전용으로 열린다(규범 §2.4 — AS-IS R07 모드 잠금 대체).
  if (!canEdit) return false;

  if (isInsertRow(row)) {
    // (④⑤) 신규행: Insert() 가 전 셀을 열고 LockRange 가 white-list 밖을 다시 잠근다.
    if (!EDITABLE_ON_INSERT_ROW[tab].includes(binding)) return false;

    // 조건부 잠금 1 — MKT FCST `CELL_PROD_SITE_ID` 는 division == '40' 에서만 편집(G16).
    //   그 외 division 은 값 '-' 고정 + 셀 잠금.
    if (tab === TABS.MKT_FCST && binding === COL.CELL_PROD_SITE_ID)
      return divisionId === DIVISION_CODE.SMALL;

    // 조건부 잠금 2 — STOCK `LINE_ID`/`BEFORE_DEGAS` 는 division == '81_UC' 에서만 편집(V3/V4).
    //   그 외 division 은 폭 0 으로 숨겨져 도달 불가하며 저장값도 '-' 강제다(cs:1247~1248).
    if (
      tab === TABS.STOCK &&
      (binding === COL.LINE_ID || binding === COL.BEFORE_DEGAS) &&
      divisionId !== DIVISION_CODE.UC
    )
      return false;

    return true;
  }

  // (②③) 기존행: SwitchLock 으로 전열 해제 후 두 구간을 재잠금한 결과 = CHG_QTY·CHG_RSN 2개.
  //   5시트 전부 동일하다(01_layout.md §2.4 A).
  return EDITABLE_ON_EXISTING_ROW.includes(binding);
};

/**
 * 삭제 가능 판정(R14 / D11) — `CHG_TYPE` 값이 있는 행만 삭제된다.
 * 신규행('New')·수정행('Change') 만 대상이고 **원본행(CHG_TYPE 공백)은 삭제 금지**다.
 */
export const isRowDeletable = (row: Record<string, unknown> | undefined): boolean => {
  if (!row) return false;
  const chgType = row[COL.CHG_TYPE];
  return typeof chgType === 'string' && chgType.trim() !== '';
};
