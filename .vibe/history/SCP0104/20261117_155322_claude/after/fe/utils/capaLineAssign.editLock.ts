import { CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';

import {
  ELTR_INSERT_LOCKED_COLUMN,
  MONTH_COLUMN_PREFIX,
  ROW_SOURCE_LINE_POPUP,
  YEAR_COLUMN_PREFIX,
} from '../capa-line-assign.constants';
import type { GridRow } from '../capa-line-assign.types';

/**
 * 동적 기간컬럼 판정 — 월 `M_01YYYYMM`(10자) / 연 `Y_YYYY`(6자) (design 03 §2.2).
 * `*_ASSIGN_PRIORITY` 는 SCP0105/SCP0106 전용이라 SCP0104 에는 애초에 생성되지 않는다(D-6).
 */
export const isDateColumn = (binding: string): boolean =>
  (binding.startsWith(MONTH_COLUMN_PREFIX) && binding.length === 10) ||
  (binding.startsWith(YEAR_COLUMN_PREFIX) && binding.length === 6);

const isInsertedRow = (row: GridRow | undefined): boolean => row?.CRUD_TYPE === 'I';

/**
 * Assign 그리드 편집 가능 판정 (design 03 §3.3 G18~G21·G43 / §5.3 E-1~E-6).
 *
 * **메타가 정본이다**(사용자 결정 2026-10-28). 컬럼별 편집정책은 admin `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD`
 * (→ `_inputEditType`)가 쥐고, 이 함수는 공용 게이트(`GridUtils.isEditableCell`/`dataGridUtils` cellEditHandler)
 * 와 **같은 의미**로 그 값을 읽는다:
 *   · `S`(SEARCH_ONLY)        → 항상 잠금
 *   · `M`/`O`                 → 상시 편집
 *   · `IM`/`IO`(insert-only)  → 신규행('I')에서만 편집
 * 실 DB 실측(ora.py 2026-10-28)으로 SCP0104 Assign 메타가 ID축=IM·명칭축=IO·VALID_YN/LANE_QTY=O·
 * 숨김키=S 로 등록돼 있고, 이 구성이 AS-IS 신규행 개방범위(`LockRange2(row,0,row,DUMMY_YN,false)`,
 * cs:3982 = 고정블록 전체 개방)와 정합함을 확인했다. 과거 "메타 전건 'S'" 전제로 전 컬럼을 일괄 개방하던
 * override 는 그 전제가 거짓이라 폐기한다.
 *
 * 메타로 표현 못 하는 화면 고유 예외 둘만 코드가 override 한다:
 *   · 조회모드            → 전 셀 잠금 (`SetLockAllRows(true)`) — 메타와 무관한 모드 게이트
 *   · 동적 기간컬럼        → 상시 편집 (G21). admin 메타가 없는 런타임 컬럼이라 메타 판정 대상이 아니다.
 *   · ELTR 신규행 `NICK_NAME` 팝업경로 개방 → 메타는 ELTR `NICK_NAME`=`S`(잠금)인데, AS-IS 는
 *     `Insert_Row_Assign_Line`(P03 CAPA Line 팝업) 행만 NICK_NAME 을 열어둔다(G43, 2025-03-31 개정,
 *     cs:5419-5422 는 Insert 버튼 경로만 `LockRange`). 팝업 행의 `ROW_SOURCE_LINE_POPUP` 마커로
 *     그 행에 한해 메타 `S` 를 덮어 편집을 허용한다.
 */
export const isAssignCellEditable = (params: {
  binding: string;
  row: GridRow | undefined;
  editMode: boolean;
  isEltr: boolean;
  inputEditType: CELL_INPUT_EDIT_TYPE | undefined;
}): boolean => {
  const { binding, row, editMode, isEltr, inputEditType } = params;
  if (!editMode) return false;
  if (!binding) return false;
  // 동적 기간컬럼: admin 메타 없음 → 상시 편집(G21).
  if (isDateColumn(binding)) return true;
  // G43 — ELTR 신규행 NICK_NAME 은 메타상 `S`(잠금)이나, 팝업(P03) 경로 행만 AS-IS 가 열어둔다.
  if (
    isEltr &&
    binding === ELTR_INSERT_LOCKED_COLUMN &&
    isInsertedRow(row) &&
    row?.[ROW_SOURCE_LINE_POPUP]
  ) {
    return true;
  }
  // 그 외 전부 메타 정본. 공용 게이트와 동일한 의미(GridUtils.isEditableCell).
  switch (inputEditType) {
    case CELL_INPUT_EDIT_TYPE.MANDATORY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL:
      return true;
    case CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY:
      return row?.CRUD_TYPE === CRUD_TYPE.INSERT;
    case CELL_INPUT_EDIT_TYPE.SEARCH_ONLY:
    default:
      return false;
  }
};

/**
 * SOP 그리드 편집 가능 판정 (design 03 §3.3 G22~G24 / §5.3 E-7).
 *
 * **메타가 정본이다**(사용자 결정 2026-10-28, Assign 과 통일). `isAssignCellEditable` 과 같은 의미로
 * admin `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD`(→ `_inputEditType`)를 읽는다:
 *   · `S`(SEARCH_ONLY)        → 항상 잠금
 *   · `M`/`O`                 → 상시 편집(`VALID_YN`·`SOP_DT`)
 *   · `IM`/`IO`(insert-only)  → 신규행('I')에서만 편집(팝업 P02 추가행의 DIVISION_ID·PLANT_NAME·
 *                               FACTORY_NAME·LINE_NAME·OPERATION_NAME·ELTR_LN_TP_CD 등)
 * 과거 `SOP_EDITABLE_COLUMNS`(VALID_YN·SOP_DT) 하드코딩은 AS-IS `LockRange2`(cs:4028-4072, 신규행도
 * 두 컬럼만 개방)를 그대로 옮긴 것이었으나, 사용자 결정으로 메타를 정본 삼아 신규행 개방을 메타의
 * IM/IO 로 넓힌다 — AS-IS/E-7 과 달라지는 의도적 변경이며 `__asis-mapping__.md` 에 명시한다.
 *
 * 화면 고유 예외는 모드 게이트 하나뿐이다:
 *   · 조회모드 → 전 셀 잠금(`SetLockAllRows(true)`). SOP 는 동적 기간컬럼이 없어 날짜 예외가 없다.
 */
export const isSopCellEditable = (params: {
  binding: string;
  row: GridRow | undefined;
  editMode: boolean;
  inputEditType: CELL_INPUT_EDIT_TYPE | undefined;
}): boolean => {
  const { binding, row, editMode, inputEditType } = params;
  if (!editMode) return false;
  if (!binding) return false;
  switch (inputEditType) {
    case CELL_INPUT_EDIT_TYPE.MANDATORY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL:
      return true;
    case CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY:
    case CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY:
      return row?.CRUD_TYPE === CRUD_TYPE.INSERT;
    case CELL_INPUT_EDIT_TYPE.SEARCH_ONLY:
    default:
      return false;
  }
};
