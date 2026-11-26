// SCP0053 편집잠금 규칙 (design 03 §3 W6/W7 · §5#2). 순수 함수.
//   AS-IS EditButton 잠금 상태머신은 미이식(asis_to_tobe §11, convert-core §2.4 editMode 금지) —
//   편집 범위는 INPUT_TP_CD 메타(S15/M3)로 공용 DataGrid 가 상시 재현하고, 행 단위 잠금만 여기서 판정한다.

import { ROW_LOCK_COLUMN } from '../scp-bom.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 편집잠금 판정 (design 03 §3 W6, cs:351~361 소스 확정):
//   SCP_PLAN_YN 셀 값이 'Y'/'N'(대문자 비교) 둘 다 아니면(NULL/공백/기타) 그 행 전체 편집 차단.
//   = 'ALL' 조회의 ALTER_BOM 미등록 outer-join 행(편집컬럼 NULL) — UPDATE 대상이 없어 편집 무의미.
export const isRowLocked = (row: Row | undefined): boolean => {
  if (!row) return true;
  const v = s(row[ROW_LOCK_COLUMN]).trim().toUpperCase();
  return v !== 'Y' && v !== 'N';
};
