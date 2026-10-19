// SCP0037 편집잠금 white-list (design 03 §3-1) + 신규행 기본값(§3-3, R4) + 파생 Auto-Sync(§3-3).
//   순수 함수. AS-IS LockColumn/LockRange(gridSignals 8건)를 화면 편집정책으로 이식 —
//   INPUT_TP_CD 전 컬럼 'S'(메타 미세팅)라 메타 파리티만으론 재현 불가, 코드가 아닌 정책 함수로 명시(hook #130).

import { CRUD_TYPE } from '@foundation/constants';

import { EXISTING_ROW_EDITABLE, LT_OP, NEW_ROW_EDITABLE } from '../operation-lt.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 판정 — GridAction.addRow 가 붙이는 CRUD_TYPE='I'.
export const isNewRow = (row: Row): boolean => s(row.CRUD_TYPE) === CRUD_TYPE.INSERT;

// 편집 가능 판정 (design 03 §3-1 / §5-3):
//   신규행 = SCM_SITE_ID(콤보)/ITEM_ID(팝업)/LT_DAY/INV_FLAG(PRE_INSP) / 기존행 = LT_DAY/INV_FLAG(PRE_INSP).
//   ITEM_ID 는 인라인 편집 금지(팝업 선택만, KeyPress 차단) → beginningEdit 에서 취소한다.
export const isCellEditable = (binding: string, row: Row): boolean => {
  const editable = isNewRow(row)
    ? (NEW_ROW_EDITABLE as readonly string[])
    : (EXISTING_ROW_EDITABLE as readonly string[]);
  if (!editable.includes(binding)) return false;
  // ITEM_ID 는 팝업 전용 — 인라인 텍스트 편집 불가(design 03 §3-4 KeyPress 차단, guard#10/#11).
  if (binding === 'ITEM_ID') return false;
  // INV_FLAG 는 그 행 LT_OPERATION=PRE_INSP 일 때만 편집 가능 (design 01 R6 / 03 §2).
  if (binding === 'INV_FLAG') return s(row.LT_OPERATION) === LT_OP.PRE_INSP;
  return true;
};

// 신규행 셀 클릭 팝업/콤보 진입 대상 여부 — 신규행 SCM_SITE_ID/ITEM_ID 만(design 03 §3-4 guard#5).
export const isItemPopupCell = (binding: string, row: Row): boolean =>
  isNewRow(row) && binding === 'ITEM_ID';

// 신규행 기본값 (design 01 R4 / 03 §3-3 #11,#21):
//   DIVISION_ID=조회div · SITE_ITEM_VALID_YN='Y' · LT_OPERATION=조회LTop. 나머지 셀은 공란(사용자 입력).
export const insertDefaults = (division: string, ltOperation: string): Row => ({
  DIVISION_ID: division,
  PLANT_SITE_ID: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  NICK_NAME: '',
  LT_OPERATION: ltOperation,
  LT_DAY: '',
  INV_FLAG: 'N',
  SITE_ITEM_VALID_YN: 'Y', // cs:402 defaultData
});

// 파생: SCM_SITE_ID 선택 -> PLANT_SITE_ID 미러 + ITEM_ID/NICK_NAME clear (design 03 §3-3 #28,#29,#30).
export const applyScmSiteChange = (row: Row, scmSiteId: string): void => {
  row.SCM_SITE_ID = scmSiteId;
  row.PLANT_SITE_ID = scmSiteId; // 항상 SCM_SITE_ID 미러(별도 입력 없음)
  row.ITEM_ID = '';
  row.NICK_NAME = '';
};

// 파생: ITEM 팝업 선택 -> ITEM_ID + NICK_NAME 동기 (design 03 §3-3 #22,#23).
export const applyItemSelect = (row: Row, itemId: string, nickName: string): void => {
  row.ITEM_ID = itemId;
  row.NICK_NAME = nickName;
};
