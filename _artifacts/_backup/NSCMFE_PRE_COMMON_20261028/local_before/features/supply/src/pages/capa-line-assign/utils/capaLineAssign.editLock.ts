import {
  ASSIGN_ALWAYS_EDITABLE_COLUMNS,
  ELTR_INSERT_LOCKED_COLUMN,
  MONTH_COLUMN_PREFIX,
  SOP_EDITABLE_COLUMNS,
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
 * AS-IS 는 `LockRange2(...)` 를 **컬럼 인덱스 구간**으로 걸지만, TO-BE 는 컬럼명(binding)으로 판정한다.
 * 컬럼명 상수 배열을 그대로 이식하는 것이 아니라(hook #130 BLOCK) AS-IS 잠금 규칙의 **의미**를 옮긴 것이다:
 *   · 조회모드            → 전 셀 잠금 (`SetLockAllRows(true)`)
 *   · 동적 기간컬럼        → 행 상태 무관 상시 편집 (G21 — `beginningEdit` 마지막 override)
 *   · `VALID_YN`/`LANE_QTY` → 행 상태 무관 상시 편집 (G19·G20)
 *   · 신규행('I')의 고정블록 → 편집 허용 (G18 `isInsertMode=false`)
 *   · 기존행의 고정블록    → 잠금
 *   · ELTR 신규행 `NICK_NAME` → 잠금 (G43, 2025-03-31 개정)
 */
export const isAssignCellEditable = (params: {
  binding: string;
  row: GridRow | undefined;
  editMode: boolean;
  isEltr: boolean;
}): boolean => {
  const { binding, row, editMode, isEltr } = params;
  if (!editMode) return false;
  if (!binding) return false;
  if (isDateColumn(binding)) return true;
  if (ASSIGN_ALWAYS_EDITABLE_COLUMNS.includes(binding)) return true;
  if (!isInsertedRow(row)) return false;
  if (isEltr && binding === ELTR_INSERT_LOCKED_COLUMN) return false;
  return true;
};

/**
 * SOP 그리드 편집 가능 판정 (design 03 §3.3 G22~G24 / §5.3 E-7).
 *
 * 편집모드에서도 `VALID_YN`·`SOP_DT` 둘뿐이다. 고정컬럼(`ELTR_LN_TP_CD`)은 AS-IS 가 Assign 시트
 * 인덱스로 잘못 계산해 엉뚱한 컬럼을 잠갔지만(R-33 잠재 결함), TO-BE 는 컬럼명 판정이라
 * 그 결함이 구조적으로 재발하지 않는다 — U-4 확정에 따른 교정이며 `__asis-mapping__.md` 에 명시한다.
 */
export const isSopCellEditable = (params: {
  binding: string;
  editMode: boolean;
}): boolean => params.editMode && SOP_EDITABLE_COLUMNS.includes(params.binding);
