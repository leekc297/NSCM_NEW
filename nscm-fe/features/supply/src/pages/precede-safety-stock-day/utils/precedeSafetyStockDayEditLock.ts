// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

import { NEW_ROW_LOCKED_COLUMNS } from '../precede-safety-stock-day.constants';

// design/03_grid-columns.md §1 집계(편집가능 10칼럼) — 신규행/기존행 공통 white-list.
//   VALUE_TYPE/OPMZ_PLAN_GR_ID/SCM_SITE_ID/ITEM_ID/STAGE/FROM_YYYYMMDD/TO_YYYYMMDD/
//   TYPE_APPLY_DAY/VALUE_DESCRIPTION/VALID_YN.
const EDITABLE_COLUMNS: ReadonlySet<string> = new Set([
  'VALUE_TYPE',
  'OPMZ_PLAN_GR_ID',
  'SCM_SITE_ID',
  'ITEM_ID',
  'STAGE',
  'FROM_YYYYMMDD',
  'TO_YYYYMMDD',
  'TYPE_APPLY_DAY',
  'VALUE_DESCRIPTION',
  'VALID_YN',
]);

const NEW_ROW_LOCKED: ReadonlySet<string> = new Set(NEW_ROW_LOCKED_COLUMNS);

/**
 * 셀 편집 가부 판정 — design/03_grid-columns.md §4.2·§4.3(G-01, iter-2 갱신).
 *
 * TO-BE 는 AS-IS EditButton "편집모드" 토글(SwitchLock 잠금 토글 절차)을 이식하지 않는다
 * (asis_to_tobe.md §11 전 화면 공통 결정). 이는 Edit 버튼만 제거한다는 뜻이고 편집가능 여부
 * 자체는 신규/기존행 구분 없이 컬럼 white-list(EDITABLE_COLUMNS)로 판정한다 — DIVISION_ID·
 * 감사4칼럼은 목록에 없어 신규/기존행 모두 항상 잠기고, 나머지 10칼럼은 조회 직후 즉시 편집
 * 가능하다. 자매 SCP0128 SafetyStockGrid 와 동형(이전 `hasButton('EDIT')` 편집권한 게이트는
 * 그 버튼이 SCM_ADM_MNU_BTN_MPG_M 에 미등록이라 항상 false → 기존행 전건 read-only 로 역전돼
 * "노란 셀이 편집 안 됨"을 유발, memory scp0048-edit-gate-uses-nonexistent-edit-permission).
 *
 * 신규행 추가 가부(권한) 자체는 상위에서 hasButton 으로 판정하므로 여기서는 보지 않는다.
 */
export const isMainCellEditable = (binding: string, row: WijmoRowItem | undefined): boolean => {
  if (!row) return false;
  return !NEW_ROW_LOCKED.has(binding) && EDITABLE_COLUMNS.has(binding);
};

/**
 * 신규행 기본값 — DIVISION_ID 는 조회조건 선택값을 승계(gridSignals#9 defaultData 상세 미확인,
 * 03_grid-columns.md §4.3 "가정 — SetValue defaultData 상세 미확인으로 확정 아님"). VALID_YN
 * 기본 'Y' 는 화면 업무 관례(그리드 신규행 공통 패턴, AS-IS 원문 미확인 — 확인 필요).
 */
export const precedeSafetyStockDayInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  VALUE_TYPE: '',
  OPMZ_PLAN_GR_ID: '',
  OPMZ_PLAN_GR_NAME: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  STAGE: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  TYPE_APPLY_DAY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});
