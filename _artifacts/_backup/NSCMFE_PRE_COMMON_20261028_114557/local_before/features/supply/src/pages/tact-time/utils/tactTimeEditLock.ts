// SCP0020 편집잠금 white-list (design 03 §3.2 gridSignals 32건) + Insert 기본값 (design 03 §3.3).
//   순수 함수 — 조회직후 grid 전체 readOnly, Edit 진입 시 이 판정으로 셀별 해제.
//   트리거는 서버 EDIT_FLAG 가 아니라 행 데이터값(division/INPUT_STATUS/OPERATION_GROUP/MODEL_SITE/OSP_YN)
//   으로 클라이언트 판정(design 03 §3.2 마지막 문단). SP 반환에 이 값들이 포함돼야 함(procedures.d.ts).

import { LOCK_DIVISIONS, OPERATION_GROUP_ELECTRODE, TACT_MODE } from '../tact-time.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// 신규행 판정 — GridAction.addRow 가 붙이는 CRUD_TYPE='I' 또는 insertDefaults 의 INPUT_STATUS='I'.
//   LINE_ID 편집 화이트리스트 판정에 쓴다(신규행일 때만 편집 — 사용자 확정 2026-09-14).
const isNewRow = (row: Row): boolean => s(row.CRUD_TYPE) === 'I' || s(row.INPUT_STATUS) === 'I';

// AS-IS spdMain(Plant) 컬럼 순서 — LockColumn/LockRange(from,to) 범위 판정의 기준.
//   주의: React 표시순서(PLANT_COLUMNS)와 다르다. AS-IS 는 GetColumnIndex(DefColumns.X) 로
//   스프레드 순서의 인덱스를 얻어 범위를 잠그므로, 잠금범위는 반드시 이 AS-IS 순서로 계산해야
//   동일 컬럼 집합이 잠긴다(표시순서로 계산하면 LANE_QTY/JUMBO_MIN 이 오잠금됨).
//   실측: SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0020' SHEET_NAME='Plant' ORDER BY SORT_ORDER_NO.
const PLANT_ORDER = [
  'DIVISION_ID',
  'PLANT_SITE_NAME',
  'OPERATION_NAME',
  'MODEL_SITE',
  'ITEM_ID',
  'NICK_NAME',
  'LINE_ID',
  'PRIORITY',
  'VALID_YN',
  'YIELD',
  'LANE_QTY',
  'DAILY_CAPACITY',
  'ITEM_UOM',
  'UOM_CONVERT_VALUE',
  'TACT_TIME',
  'JUMBO_MIN',
  'BOM_MIN_DUE_DATE',
  'BIG_TACT_TIME',
  'ACTUAL_OUTPUT',
  'ACTUAL_CAPACITY',
  'FROM_ACTUAL_CAPACITY',
  'TO_ACTUAL_CAPACITY',
  'EFFECTIVE_DATA_COUNT',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'BIG_LAST_UPDATE_DATE',
  'PLANT_SITE_ID',
  'OPERATION_ID',
  'INPUT_STATUS',
  'EXCEPT_YN',
  'OPERATION_GROUP_ID',
];

// 컬럼 순서 기반 범위(inclusive, 양방향) — AS-IS LockColumn(from, to) 이식.
const rangeKeys = (order: string[], a: string, b: string): string[] => {
  const ia = order.indexOf(a);
  const ib = order.indexOf(b);
  if (ia < 0 || ib < 0) return [];
  const [lo, hi] = ia <= ib ? [ia, ib] : [ib, ia];
  return order.slice(lo, hi + 1);
};

// ===== Plant 시트 편집 판정 (design 03 §1.1 / §3.2 cs:553-601) =====
//   base 편집후보 = admin/census 상 사용자가 값을 넣는 컬럼. 그 외 전부 잠금(키/감사/조회전용).
const PLANT_BASE_EDITABLE = new Set([
  'LINE_ID',
  'PRIORITY',
  'TACT_TIME',
  'YIELD',
  'VALID_YN',
  'ITEM_UOM',
  'UOM_CONVERT_VALUE',
  'LANE_QTY',
  'DAILY_CAPACITY',
]);

export const isPlantCellEditable = (binding: string, row: Row): boolean => {
  if (!PLANT_BASE_EDITABLE.has(binding)) return false;
  const division = s(row.DIVISION_ID);
  const modelSite = s(row.MODEL_SITE).trim();
  const opGroup = s(row.OPERATION_GROUP_ID);

  const locked = new Set<string>();
  // cs:573/577 — division 42/44 vs else 잠금범위
  if ((LOCK_DIVISIONS as readonly string[]).includes(division)) {
    rangeKeys(PLANT_ORDER, 'ITEM_UOM', 'TACT_TIME').forEach(k => locked.add(k));
  } else {
    rangeKeys(PLANT_ORDER, 'DAILY_CAPACITY', 'UOM_CONVERT_VALUE').forEach(k => locked.add(k));
  }
  // LINE_ID 는 신규행일 때만 편집 (사용자 확정 2026-09-14) — 기존행(조회건)은 항상 잠금.
  //   AS-IS(cs:588)는 INPUT_STATUS='M' 만 잠갔으나, 조회건 INPUT_STATUS 가 'M' 이 아닌 값이면
  //   LINE_ID 가 편집 가능해지는 문제 → 신규행 화이트리스트(isNewRow)로 반전.
  if (!isNewRow(row)) locked.add('LINE_ID');
  // cs:593 — MODEL_SITE 공백이면 LINE_ID~LANE_QTY 전체 잠금
  if (modelSite === '') rangeKeys(PLANT_ORDER, 'LINE_ID', 'LANE_QTY').forEach(k => locked.add(k));
  // cs:598 — OPERATION_GROUP != 'E'(비전극) 이면 LANE_QTY 잠금
  if (opGroup !== OPERATION_GROUP_ELECTRODE) locked.add('LANE_QTY');

  return !locked.has(binding);
};

// ===== Packer 시트 편집 판정 (design 03 §1.2 / §3.2 cs:605-647) =====
// AS-IS Packer EditButton(cs:610/611): DIVISION_ID~NICK_NAME + TACT_TIME~OSP_YN 잠금 →
//   그 사이 LINE_ID/PRIORITY/YIELD/DAILY_CAPACITY 편집(YIELD 포함, TACT_TIME 은 파생이라 잠금).
const PACKER_BASE_EDITABLE = new Set(['LINE_ID', 'PRIORITY', 'YIELD', 'DAILY_CAPACITY']);

export const isPackerCellEditable = (binding: string, row: Row): boolean => {
  // cs:694-712 UnLockOnlyOSP — OSP_YN != 'Y' 행은 전체 잠금.
  if (s(row.OSP_YN) !== 'Y') return false;
  if (!PACKER_BASE_EDITABLE.has(binding)) return false;
  // LINE_ID 는 신규행일 때만 편집 (사용자 확정 2026-09-14) — 기존행(조회건)은 잠금.
  //   AS-IS(cs:621)는 INPUT_STATUS='M' 만 잠갔으나, 조회건 INPUT_STATUS 가 'M' 이 아닌 값이면
  //   편집 가능해지는 문제 → 신규행 화이트리스트(isNewRow)로 반전.
  if (binding === 'LINE_ID' && !isNewRow(row)) return false;
  return true;
};

// ===== Except 시트 편집 판정 (design 03 §1.3 / §3.2 cs:648-687) =====
//   부모탭(Plant/Packer)에 따라 DAILY_CAPACITY / TACT_TIME 중 하나 잠금(cs:681/684).
const EXCEPT_BASE_EDITABLE = new Set([
  'NICK_NAME',
  'TACT_TIME',
  'YIELD',
  'DAILY_CAPACITY',
  'TACT_TIME_START_DATE',
  'TACT_TIME_END_DATE',
  'EXCEPT_COMMENT',
  'USE_YN',
]);

export const isExceptCellEditable = (binding: string, parentMode: TACT_MODE): boolean => {
  if (!EXCEPT_BASE_EDITABLE.has(binding)) return false;
  if (parentMode === TACT_MODE.PLANT && binding === 'DAILY_CAPACITY') return false; // cs:681
  if (parentMode === TACT_MODE.PACKER && binding === 'TACT_TIME') return false; // cs:684
  return true;
};

// ===== Insert 기본값 (design 03 §3.3 — 상위/선택행 복사 + 고정 기본값) =====
export const plantInsertDefaults = (src: Row): Row => ({
  DIVISION_ID: s(src.DIVISION_ID),
  PLANT_SITE_ID: s(src.PLANT_SITE_ID),
  PLANT_SITE_NAME: s(src.PLANT_SITE_NAME),
  ITEM_ID: s(src.ITEM_ID),
  OPERATION_ID: s(src.OPERATION_ID),
  OPERATION_NAME: s(src.OPERATION_NAME),
  NICK_NAME: s(src.NICK_NAME),
  OPERATION_GROUP_ID: s(src.OPERATION_GROUP_ID),
  MODEL_SITE: s(src.MODEL_SITE),
  INPUT_STATUS: 'I',
  VALID_YN: 'Y', // cs:789
});

export const packerInsertDefaults = (src: Row): Row => ({
  DIVISION_ID: s(src.DIVISION_ID),
  SITE_DESCRIPTION: s(src.SITE_DESCRIPTION),
  ITEM_ID: s(src.ITEM_ID),
  NICK_NAME: s(src.NICK_NAME),
  PLANT_SITE_ID: s(src.PLANT_SITE_ID),
  OPERATION_ID: s(src.OPERATION_ID),
  INPUT_STATUS: 'I', // cs:843
  EXCEPT_YN: 'N', // cs:844
  OSP_YN: 'Y', // cs:845
});

export const exceptInsertDefaults = (src: Row): Row => ({
  DIVISION_ID: s(src.DIVISION_ID),
  PLANT_SITE_ID: s(src.PLANT_SITE_ID),
  PLANT_SITE_NAME: s(src.PLANT_SITE_NAME ?? src.SITE_DESCRIPTION),
  ITEM_ID: s(src.ITEM_ID),
  OPERATION_ID: s(src.OPERATION_ID),
  OPERATION_NAME: s(src.OPERATION_NAME ?? src.OPERATION_ID),
  LINE_ID: s(src.LINE_ID),
  NICK_NAME: s(src.NICK_NAME),
  INPUT_STATUS: 'I',
  USE_YN: 'Y', // cs:925
  // 수정 전 복합키 스냅샷 (신규는 원본 없음 → 빈값; 수정건은 GET 반환값 그대로 보존)
  ORG_DIVISION_ID: s(src.DIVISION_ID),
  ORG_PLANT_SITE_ID: s(src.PLANT_SITE_ID),
  ORG_ITEM_ID: s(src.ITEM_ID),
  ORG_OPERATION_ID: s(src.OPERATION_ID),
  ORG_LINE_ID: s(src.LINE_ID),
});
