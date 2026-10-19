// SCP0041 Pack Hold Stock 편집잠금 규칙 (design 03 §3 R2). 순수 함수.
//   AS-IS EditButton 모드 토글(R1)은 미이식(convert-core §2.1(11) edit-mode default ON) —
//   행 단위 편집 허용은 DIR='HOLD' 행만, 그 외(RELEASE/공백/NULL)는 행 전체 잠금.
//   편집 컬럼 자체는 EDITABLE_COLUMNS(QTY/DATE_FORECAST_START/DATE_FORECAST_FINISH)로 한정(design 03 §1-B).

import { ROW_EDIT_COLUMN, ROW_EDIT_VALUE } from '../stock-osp.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 편집가능 판정 (design 03 §3 R2, AS-IS cs:HOLD 분기):
//   DIR 셀 값이 'HOLD'(대문자 비교) 인 행만 편집 대상. RELEASE/공백은 조회 전용.
export const isHoldRow = (row: Row | undefined): boolean => {
  if (!row) return false;
  return s(row[ROW_EDIT_COLUMN]).trim().toUpperCase() === ROW_EDIT_VALUE;
};
