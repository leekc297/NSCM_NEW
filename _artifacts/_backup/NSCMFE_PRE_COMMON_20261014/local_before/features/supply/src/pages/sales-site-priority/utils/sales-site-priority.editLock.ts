// SCP0131 편집잠금 white-list(design 03 §3.1) + 신규행 기본값(§3.2) + 파생 Auto-Sync(§3.2).
//   순수 함수. AS-IS LockColumn/LockRange(gridSignals 5건)를 화면 편집정책으로 이식 —
//   INPUT_TP_CD 전 컬럼 'S'(메타 미세팅)라 메타 파리티만으론 재현 불가, 코드가 아닌 정책 함수로 명시(hook #130).
//
// 2026-09-26 iter-3 AS-IS 원본 확보(GSCM/06.UIL/.../SCP0131_SalesSitePriority.cs) 후 확정:
//   InsertButton override 는 실동작(Insert_Row, l503~521) — SwitchLock 토글(EditButton, l369~380)도
//   실동작이나 이 화면의 TO-BE 등록 버튼(SCM_ADM_MNU_BTN_MPG_M, SEARCH/INSERT/SAVE/DELETE 4종)에
//   EDIT 버튼 자체가 없어 자매(SCP0037 operation-lt) 표준(그리드 상시편집 + 셀 white-list)을 그대로
//   따른다 — 조회 직후 전잠금(LockColumn l462)/EditButton 토글은 재현 대상이 아니다.

import { CRUD_TYPE } from '@foundation/constants';

import { EDITABLE_COLUMNS } from '../sales-site-priority.constants';

type Row = Record<string, unknown>;

export const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 신규행 판정 — GridAction.addRow 가 붙이는 CRUD_TYPE='I'.
export const isNewRow = (row: Row): boolean => s(row.CRUD_TYPE) === CRUD_TYPE.INSERT;

// 편집 가능 판정(design 03 §3.1) — 신규행/기존행 공통 8칸(EDITABLE_COLUMNS). DIVISION_ID·감사4칸·
//   PRE_KEY_VALUES 는 행 상태 불문 항상 잠금(ALWAYS_LOCKED_COLUMNS, 별도 화이트리스트 불필요 —
//   EDITABLE_COLUMNS 에 없으므로 자동 차단).
//   ITEM_ID 는 팝업 전용(더블클릭) — 인라인 텍스트 편집 금지.
export const isCellEditable = (binding: string): boolean => {
  if (!(EDITABLE_COLUMNS as readonly string[]).includes(binding)) return false;
  if (binding === 'ITEM_ID') return false;
  return true;
};

// ITEM_ID 팝업 오픈 대상 셀 — 신규행/기존행(Edit 모드) 공통.
export const isItemPopupCell = (binding: string): boolean => binding === 'ITEM_ID';

// 신규행 기본값(design 01 §2#6 / 03 §3.2, AS-IS Insert_Row l508~514 확정) — DIVISION_ID=확정
//   조회조건 division(항상잠금), VALID_YN='Y'(AS-IS defaultData.Add(VALID_YN,"Y") 그대로).
//   나머지 편집가능 6칸은 공란(사용자 입력), 감사4칸/PRE_KEY_VALUES 는 서버/시스템 처리 영역이라
//   화면에서 비워둔다.
export const insertDefaults = (division: string): Row => ({
  DIVISION_ID: division,
  OPMZ_PLAN_GR_ID: '',
  SCM_SITE_ID: '',
  ITEM_ID: '',
  PRIO_RANK: '',
  FROM_YYYYMMDD: '',
  TO_YYYYMMDD: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});

// 파생: ITEM 팝업 선택 -> ITEM_ID 동기(design 03 §3.2, gridSignals#13 SetText).
export const applyItemSelect = (row: Row, itemId: string): void => {
  row.ITEM_ID = itemId;
};
