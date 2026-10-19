import { COLUMN, SHEETS, type GridSheet } from '../capa-speed-plan.constants';
import type { Scp0105Row } from '../capa-speed-plan.types';

import { assignPriorityKeyOf, isEditablePeriodColumn } from './capaSpeedPlan.dateColumns';

/**
 * 조건부 셀 편집잠금 — AS-IS `SetLockColumnsASSEMBLY`(cs:1479~1572) / `SetLockColumnsELTR`(cs:1574~1693).
 *
 * AS-IS 는 `LockRange2(...)` 로 좌표 범위를 잠그지만 TO-BE 는 **좌표가 아니라 의미**로 재현한다
 * (hook #130 — `LockRange`/컬럼명 상수 배열 이식 금지). 판정 입력은 (시트, 컬럼 binding, 행 데이터)뿐이라
 * 순수 함수로 두고 `beginningEdit` / `pastingCell` / `formatItem` 이 같은 함수를 쓴다.
 *
 * 규칙(design 03 R-05~R-09 / V-20~V-25):
 *   (a) 고정영역(`0` ~ `IDX`) 는 전 행 잠금 — 기간열 앞의 정적 컬럼은 편집 대상이 아니다.
 *   (b) ASSEMBLY 기간열 : 짝 `_ASSIGN_PRIORITY` 가 0/공백이거나 `EDITABLE_YN !== 'Y'` -> 잠금
 *   (c) ELTR 기간열     : 짝 `_ASSIGN_PRIORITY` **만** 본다.
 *                         `EDITABLE_YN` 조건을 추가하면 안 된다 — ELTR SP 가 그 컬럼을 반환하지
 *                         않으므로(undefined !== 'Y') 전 셀이 잠겨 편집 기능이 통째로 사라진다.
 *   (d) `ELTR_LN_TP_CD`(ELTR 시트) : 설비유형 공백 OR `EQUIPMENT_ID` 공백 OR `UI_UPD_YN === 'Y'`
 *   (e) `BASE_QTY` 개별 잠금은 **걸지 않는다** — AS-IS 의 `BASE_EDITABLE_YN` 분기는 주석처리
 *       상태다(cs:1495·1523·1528·1530, R-07). 현행 동작 재현.
 */

// 행 값은 인덱스 시그니처라 `unknown` 이다. 객체가 섞여 들어와도 `'[object Object]'` 로 새지 않게
//   원시값만 문자열로 바꾼다(그 외는 빈 문자열 = "값 없음" 취급, AS-IS GetText 의 공백 동작과 같다).
const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/** `_ASSIGN_PRIORITY` 값이 0/공백이면 "우선순위 없음" = 그 기간 셀은 잠긴다(SheetUtils.cs:1417~1459). */
export const isPriorityNone = (row: Scp0105Row | undefined, periodColumn: string): boolean => {
  if (!row) return true;
  const raw = toText(row[assignPriorityKeyOf(periodColumn)]);
  if (raw === '') return true;
  const parsed = Number(raw);
  // 숫자로 못 읽으면 AS-IS 도 decimal.Parse 실패로 0 을 유지한다(= 잠금).
  return !Number.isFinite(parsed) || parsed === 0;
};

/** ELTR `ELTR_LN_TP_CD` 편집 허용 조건(R-08, cs:1588·1618~1638). */
export const isElectrodeTypeEditable = (row: Scp0105Row | undefined): boolean => {
  if (!row) return false;
  return (
    toText(row[COLUMN.ELTR_LN_TP_CD]) === '' ||
    toText(row[COLUMN.EQUIPMENT_ID]) === '' ||
    toText(row[COLUMN.UI_UPD_YN]) === 'Y'
  );
};

interface EditableInput {
  sheetName: GridSheet;
  binding: string;
  row: Scp0105Row | undefined;
  isEditMode: boolean;
}

/**
 * 이 셀이 지금 편집 가능한가. `beginningEdit`/`pastingCell`/`formatItem` 공통 판정.
 * 조회 직후에는 전 셀이 읽기전용이다(R-24 — `AfterFindData` 가 전 컬럼을 잠근다).
 */
export const isCellEditable = ({
  sheetName,
  binding,
  row,
  isEditMode,
}: EditableInput): boolean => {
  if (!isEditMode || !row || !binding) return false;

  if (binding === COLUMN.ELTR_LN_TP_CD) {
    // ASSEMBLY 의 Line Type 은 표시 전용이다(03 §1.1 #7). ELTR 시트에서만 조건부 편집.
    return sheetName === SHEETS.ELTR && isElectrodeTypeEditable(row);
  }

  // (a) 기간열이 아니면 전부 고정영역 — AS-IS `LockRange2(0,0,rowCnt-1,IDX,true)` 와 등가.
  if (!isEditablePeriodColumn(binding)) return false;

  if (isPriorityNone(row, binding)) return false;
  if (sheetName === SHEETS.ASSEMBLY && toText(row[COLUMN.EDITABLE_YN]) !== 'Y') return false;
  return true;
};

/**
 * 설비유형 일괄 동기화(ELTR) — AS-IS `CheckEltrEquipmentType`(cs:2946~3083).
 * 편집한 행의 6키(DIV/COMPANY/SITE/PLANT/FACTORY/LINE)가 **전부 채워져 있을 때만** 발동하고,
 * 같은 6키를 갖는 다른 행의 `ELTR_LN_TP_CD` 를 방금 넣은 값으로 덮어쓴다. 자기 행은 건너뛴다.
 * 반환값 = 실제로 값이 바뀐 행들(호출부가 'M' 마킹과 EditTracker 기록을 담당).
 *
 * AS-IS 와의 의도적 미세 편차 1건: AS-IS 는 **값이 이미 같은 행에도** SetText 후 'M' 을 찍는다
 * (cs:3075~3080). TO-BE 는 값이 같으면 건너뛴다 — 같은 값을 쓰는 행까지 'M' 으로 만들면
 * `EditTracker` 가 원복으로 지울 수 없는 마킹이 남아(자체 CRUD 세팅 = convert-core §2.4 위반)
 * 사용자가 되돌릴 길이 없어진다. 저장되는 **값**은 동일하므로 데이터 결과는 같고, 저장 건수만
 * AS-IS 보다 작거나 같다. 근거는 __asis-mapping__.md 에 기록.
 */
const SYNC_KEYS: readonly string[] = [
  COLUMN.DIVISION_ID,
  COLUMN.COMPANY_ID,
  COLUMN.SITE_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
];

export interface SyncedCell {
  row: Scp0105Row;
  previousValue: string;
  nextValue: string;
}

export const syncElectrodeTypeAcrossLine = (
  rows: readonly Scp0105Row[],
  editedRow: Scp0105Row
): SyncedCell[] => {
  const keys = SYNC_KEYS.map(key => toText(editedRow[key]));
  if (keys.some(value => value === '')) return [];

  const nextValue = toText(editedRow[COLUMN.ELTR_LN_TP_CD]);
  const synced: SyncedCell[] = [];
  for (const row of rows) {
    if (row === editedRow) continue;
    if (SYNC_KEYS.some((key, index) => toText(row[key]) !== keys[index])) continue;
    const previousValue = toText(row[COLUMN.ELTR_LN_TP_CD]);
    if (previousValue === nextValue) continue;
    synced.push({ row, previousValue, nextValue });
  }
  return synced;
};
