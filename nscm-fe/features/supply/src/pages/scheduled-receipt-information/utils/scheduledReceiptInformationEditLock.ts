// WijmoRowItem 은 configs/types/global.d.ts 전역 타입 (import 불필요 — 다른 화면 util 과 동일).

/**
 * 그리드 편집잠금 — design/03_grid-columns.md §1/§3 gridSignals white-list 재현.
 * 두 시트(Virtual Bom/Scheduled Reciept Information) 공통 규칙(gridSignals#9,10,12,15,16,18,19가
 * `siMain` 대상으로 시트 무관 공용 적용, design 03 §1.2 각주).
 *
 * TO-BE 는 EditButton "편집모드" 토글을 실제로 배선한다(design/01_layout.md §2 #4 — 라인 경계
 * 계산으로 SwitchLock 이 EditButton 본문 소속임을 구조적으로 확정, asis_to_tobe.md §11 미이식 결정과
 * 달리 이 화면은 원본 근거가 명확해 재현). isEditMode 가 false 면 조회 직후 전체잠금(#12)이 유지되고,
 * true(EditButton 클릭)면 DIVISION_ID·감사4컬럼·PRE_KEY_VALUES 를 제외한 나머지가 해제된다.
 * 신규행(CRUD_TYPE='I')은 isEditMode 와 무관하게 위 잠금 컬럼 외 즉시 편집 가능(LockRange #15/16/18/19).
 */
const LOCKED_ALWAYS: ReadonlySet<string> = new Set([
  'DIVISION_ID',
  'CREATED_BY',
  'CREATION_DATE',
  'LAST_UPDATED_BY',
  'LAST_UPDATE_DATE',
  'PRE_KEY_VALUES',
]);

const crudType = (row: WijmoRowItem | undefined): string => row?.CRUD_TYPE ?? '';

export const isSheetCellEditable = (
  binding: string,
  row: WijmoRowItem | undefined,
  isEditMode: boolean
): boolean => {
  if (LOCKED_ALWAYS.has(binding)) return false;
  if (crudType(row) === 'I') return true; // 신규행 = 항상 편집 가능(잠금 컬럼 제외)
  return isEditMode; // 기존행 = EditButton 편집모드일 때만
};

// 신규행 기본값 — design/01_layout.md §2 #6(gridSignals#14/17 defaultData), 확인 필요(원식 미확인,
//   SCP0122/SCP0127/SCP0128 선례대로 조회조건 Division 기준으로 채운다).
export const virtualBomInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  OPMZ_PLAN_GR_ID: '',
  PLANT_SITE_ID: '',
  ITEM_ID: '',
  ITEM_ID_CHILD: '',
  TO_EXPC_QTY: '',
  TO_YYYYMMDD: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});

export const scheduledReceiptInsertDefaults = (divisionId: string): Record<string, string> => ({
  DIVISION_ID: divisionId,
  OPMZ_PLAN_GR_ID: '',
  PLANT_SITE_ID: '',
  ITEM_ID_CHILD: '',
  TO_YYYYMMDD: '',
  TO_EXPC_QTY: '',
  VALUE_DESCRIPTION: '',
  VALID_YN: 'Y',
});
