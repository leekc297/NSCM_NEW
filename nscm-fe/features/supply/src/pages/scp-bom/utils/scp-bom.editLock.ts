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
//   판정 시점 = 조회 직후 값(AS-IS EditButton cs:288-296 이 편집 진입 때 1회 잠금). 편집 중 SCP YN 을
//   지워도 그 행은 잠기지 않고 계속 편집·저장된다(AS-IS 는 빈 값을 그대로 저장). markRowLocks 가 조회
//   시점 판정을 ROW_LOCKED_KEY 에 고정해 두고, 플래그가 없을 때만 현재 값으로 판정한다.
const ROW_LOCKED_KEY = '_ROW_LOCKED';

const isLockValue = (row: Row): boolean => {
  const v = s(row[ROW_LOCK_COLUMN]).trim().toUpperCase();
  return v !== 'Y' && v !== 'N';
};

export const isRowLocked = (row: Row | undefined): boolean => {
  if (!row) return true;
  const fixed = row[ROW_LOCKED_KEY];
  return typeof fixed === 'boolean' ? fixed : isLockValue(row);
};

// 조회 결과 행에 조회 시점 잠금 여부를 고정한다.
export const markRowLocks = <T extends Row>(rows: T[]): T[] =>
  rows.map(r => ({ ...r, [ROW_LOCKED_KEY]: isLockValue(r) }));
