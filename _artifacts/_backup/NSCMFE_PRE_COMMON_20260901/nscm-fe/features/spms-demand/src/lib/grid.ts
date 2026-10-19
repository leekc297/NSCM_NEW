// SDM 공통 — useCheckbox 그리드에서 체크된 row 를 모은다 (row.isSelected).
//   GridUtils.getSelectedRows(포커스 선택 기준)와 다르다 — 체크 대상 버튼 로직은 이것을 사용한다.
import { SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';

import { toText } from './call-proc';

// ⭐ useCheckbox 그리드 드래그 선택 복원 — wijmo Selector 는 unbound 생성 시 grid.selectionMode 를
//   Cell(단일 셀)로 강제해(wijmo.grid.selector column setter) 드래그 범위 선택·범위 복사/붙여넣기가
//   막힌다. DataGrid 는 initialized 를 내부 설정(setCheckbox 포함)이 모두 끝난 뒤 마지막에 호출하므로
//   여기서 MultiRange 로 되돌린다. SDM useCheckbox 그리드의 initialized 에 연결해 쓴다.
export const restoreMultiRangeSelection = (grid: FlexGrid): void => {
  grid.selectionMode = SelectionMode.MultiRange;
};

export const collectCheckedRows = <T>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (const element of grid.rows) {
    if (element?.isSelected) rows.push(element.dataItem as T);
  }
  return rows;
};

// ⭐ 3상태 체크박스 서버 문자열 (REQ_CHECK/DISABLE_CHECK 사본 통합 — FE 재파생 금지, 값 그대로 왕복.
//   DISABLED = 편집 잠금 / CHECKED = 진행 중 / UNCHECKED = 선택 가능)
export const CHECK_STATE = {
  DISABLED: 'DISABLED',
  CHECKED: 'CHECKED',
  UNCHECKED: 'UNCHECKED',
} as const;

// 체크 토글 게이트 — 서버 2값(CHECKED/UNCHECKED)만 토글, 그 외(DISABLED 등) 잠금
export const isCheckToggleable = (value: unknown): boolean => {
  const s = toText(value);
  return s === CHECK_STATE.CHECKED || s === CHECK_STATE.UNCHECKED;
};

// INPUT_TP_CD 편집형 판정 (IM/IO/M/O — 'S'/미지정 = 불가. admin UI Category Setup 메타 단일 원천.
//   행 게이트(MOD_ROW_YN 등)는 화면별 editLock 몫 — 여기는 컬럼 축만)
export const isEditableInputTp = (inputTpCd: string | undefined): boolean =>
  inputTpCd === 'IM' || inputTpCd === 'IO' || inputTpCd === 'M' || inputTpCd === 'O';
