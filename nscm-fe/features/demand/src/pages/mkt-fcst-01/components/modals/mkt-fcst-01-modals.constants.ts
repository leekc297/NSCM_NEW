import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

// ⭐ #3 — Measure 선택 모달은 공용 ColumnSelectDualList(양쪽 구성) 사용 — 컬럼 정의는
//   MeasureSelectModal.tsx 내부 DualListColumn(Class/Measure Code/Measure Name) 참조.
//   (구 MEASURE_SELECT_COLUMNS(DataGrid useCheckbox 단일 grid) 는 dual list 전환으로 제거 — 2026-07-02)

// ⭐ Phase 2e POPUP grid fallback 컬럼 메타 (AS-IS popup .cs InitSpread 1:1).
//   admin SCM_MST_SHEET_COLUMNS 동적 fetch 대상이 아닌 화면 내부 popup → hardcode fallback.
//   모두 read-only(SEARCH_ONLY) — AS-IS LockColumn(0, max, true).

// SspSyncComparePopUp — DMF0003_SspSyncComparePopUp.cs L143~154 (12 컬럼, DOM_EXP 숨김).
export const SSP_COMPARE_COLUMNS: RawFlexGridColumnConfig[] = [
  {
    colNm: 'PROJECT_CODE',
    colLblNm: 'End Customer',
    colWth: 110,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'SCM_SITE_ID',
    colLblNm: 'Sales Site',
    colWth: 150,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'ITEM_ID',
    colLblNm: 'Model',
    colWth: 140,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'INCOTERMS',
    colLblNm: 'Incoterms',
    colWth: 70,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'FCST_TYPE',
    colLblNm: 'Fcst Type',
    colWth: 70,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  // AS-IS L148: Customs Handbook 숨김(visible=false)
  {
    colNm: 'DOM_EXP',
    colLblNm: 'Customs Handbook',
    colWth: 50,
    horzAlgnCd: 'L',
    display: false,
    visible: false,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'CATEGORY',
    colLblNm: 'Measure',
    colWth: 125,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'CONFIRM_ID',
    colLblNm: 'Confirm ID',
    colWth: 110,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'SO_NO',
    colLblNm: 'So No',
    colWth: 80,
    horzAlgnCd: 'R',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'PLAN_QTY',
    colLblNm: 'Qty',
    colWth: 100,
    horzAlgnCd: 'R',
    scale: 3,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'RESULT_QTY',
    colLblNm: 'Shipment Result Qty',
    colWth: 100,
    horzAlgnCd: 'R',
    scale: 3,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
];

// SspSyncPopUp — DMF0003_SspSyncPopUp.cs L136~145 (9 컬럼, MEASURE 숨김). SAVE 응답 O_RC1.
export const SSP_SYNC_COLUMNS: RawFlexGridColumnConfig[] = [
  {
    colNm: 'MEASURE',
    colLblNm: 'MEASURE',
    colWth: 50,
    horzAlgnCd: 'L',
    display: false,
    visible: false,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'PROJECT_CODE',
    colLblNm: 'End Customer',
    colWth: 100,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'SCM_SITE_ID',
    colLblNm: 'Sales Site',
    colWth: 100,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'ITEM_ID',
    colLblNm: 'Model',
    colWth: 140,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'INCOTERMS',
    colLblNm: 'Incoterms',
    colWth: 70,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'FCST_TYPE',
    colLblNm: 'Fcst Type',
    colWth: 70,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'DOM_EXP',
    colLblNm: 'Customs Handbook',
    colWth: 70,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'YYYYMMDD',
    colLblNm: 'YYYYMMDD',
    colWth: 90,
    horzAlgnCd: 'L',
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'SYNC_QTY',
    colLblNm: 'Sync Qty',
    colWth: 70,
    horzAlgnCd: 'R',
    scale: 3,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
  {
    colNm: 'QTY',
    colLblNm: 'DP Qty',
    colWth: 70,
    horzAlgnCd: 'R',
    scale: 3,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
    display: true,
    visible: true,
    inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  },
];

// (PR_DETAIL_COLUMNS · PR_HISTORY_COLUMNS 없음 — DMF0003_01 은 PR 발행 기능을 쓰지 않는다(설계서 v9, 2026-11-06).)

// (MASTER_CHG_COLUMNS 제거 — 2026-07-13 사용자 결정: Master Change 버튼·기능 전체 삭제.
//  AS-IS DMF0003_MatsterChgPopup 미이관 확정. 복원 필요 시 git history 참조.)
