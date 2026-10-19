// SCP0097 편집잠금 규칙 (design 03 §3 W7/W8 · §5#3). 순수 함수.
//   AS-IS EditButton 잠금 상태머신은 미이식(asis_to_tobe §11, convert-core §2.4 editMode 금지) —
//   편집 범위는 INPUT_TP_CD 메타(S11/M2)로 공용 DataGrid 가 상시 재현하고, 행 단위 잠금만 여기서 판정한다.

import { ROW_LOCK_COLUMN } from '../scp-bom-elec.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 편집잠금 판정 (design 03 §3 W7, cs:255~265 소스 확정):
//   SCP_YN 셀 값이 'Y'/'N'(대문자 비교) 둘 다 아니면(NULL/공백/기타) 그 행 전체 편집 차단.
//   실데이터상 Y/N 외 값 0건이나 데이터 방어 규칙(AS-IS EditButton 루프 등가).
export const isRowLocked = (row: Row | undefined): boolean => {
  if (!row) return true;
  const v = s(row[ROW_LOCK_COLUMN]).trim().toUpperCase();
  return v !== 'Y' && v !== 'N';
};
