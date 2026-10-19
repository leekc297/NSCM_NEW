import { isEssDivision } from '../group-code-management.constants';

// division layout 키 — resolveSheetNm 이 4 레이아웃(base/40/81계열/82)으로 수렴하는 것과 동일 축.
//   81 계열 6종(81/81_HD/81_HG/81_HM/81_ST/81_UC)은 편집가능셋 byte-동일 → '81' 하나로 대표.
type LayoutKey = 'base' | '40' | '81' | '82';

// division 값 → layout 판정 (03_grid-columns.md §1 규칙 / resolveSheetNm 산식과 동일 축).
const layoutOf = (divisionId: string): LayoutKey => {
  if (divisionId === '40') return '40';
  if (divisionId === '82') return '82';
  if (isEssDivision(divisionId)) return '81';
  return 'base';
};

/**
 * 편집가능 컬럼 white-list (03_grid-columns.md §1 각 레이아웃 "편집가능" 행 정본).
 *
 * AS-IS 는 `_notEditableColumn{81,82,40}s` (락 대상) 배열을 SwitchLock 뒤에 재잠금하지만,
 *   TO-BE 는 그 여집합(편집가능 컬럼)을 직접 명세한다 — 판정 의미는 동일하고 셋이 더 작다(§3-2).
 *   여기 없는 컬럼은 편집모드에서도 전부 락(조회키/파생/hidden 포함).
 *   PIC_ID 는 인라인 편집이 아니라 UserInfoPopup 더블클릭으로만 값이 들어오므로 락 취급(아래 §비고).
 */
const EDITABLE_COLUMNS: Record<LayoutKey, ReadonlySet<string>> = {
  // base(spdEtc): GROUP_CODE1~5 / REMARK 편집. PIC_ID 는 팝업 전용.
  base: new Set(['GROUP_CODE1', 'GROUP_CODE2', 'GROUP_CODE3', 'GROUP_CODE4', 'GROUP_CODE5', 'REMARK']),
  // 40: GROUP_CODE9/1/2/3 + 정적콤보(ATTRIBUTE7/STATUS_PROTOTYPE/BASIC_FINISHED_PRODUCT) + END_CUSTOMER + REMARK.
  '40': new Set([
    'GROUP_CODE9',
    'ATTRIBUTE7',
    'STATUS_PROTOTYPE',
    'BASIC_FINISHED_PRODUCT',
    'BASIC_END_CUSTOMER',
    'GROUP_CODE1',
    'GROUP_CODE2',
    'GROUP_CODE3',
    'REMARK',
  ]),
  // 81 계열: GROUP_CODE1/2/3/4/5/6/7 + LEVEL2_CODE + REPLACEMENT + 정적콤보 3 + END_CUSTOMER + MKT_DEPT + REMARK.
  '81': new Set([
    'GROUP_CODE1',
    'LEVEL2_CODE',
    'GROUP_CODE6',
    'GROUP_CODE7',
    'GROUP_CODE5',
    'REPLACEMENT',
    'ATTRIBUTE7',
    'STATUS_PROTOTYPE',
    'BASIC_FINISHED_PRODUCT',
    'BASIC_END_CUSTOMER',
    'MKT_DEPT',
    'GROUP_CODE2',
    'GROUP_CODE3',
    'GROUP_CODE4',
    'REMARK',
  ]),
  // 82: GROUP_CODE8(ESS_CATEGORY 콤보)/2/4/6/7 + LEVEL2_CODE + 정적콤보(ATTRIBUTE7/STATUS_PROTOTYPE/BASIC_FINISHED_PRODUCT) + REMARK.
  //   GROUP_CODE5(82)는 AS-IS IsESSEdit 로 인라인 키인을 막고 RTFGubun 팝업(CommonDataSCPPopup)으로만 값이
  //   들어온다(cs:1493/1725). 그래서 편집가능셋에서 제외(PIC_ID 와 동일한 팝업 전용 취급) — R-KEYBLOCK 은
  //   그리드에서, 팝업 라우팅은 isRtfGubunCell 로 처리한다(03_grid-columns.md §3-3/§3-4).
  '82': new Set([
    'GROUP_CODE8',
    'LEVEL2_CODE',
    'GROUP_CODE6',
    'GROUP_CODE7',
    'GROUP_CODE4',
    'ATTRIBUTE7',
    'STATUS_PROTOTYPE',
    'BASIC_FINISHED_PRODUCT',
    'GROUP_CODE2',
    'REMARK',
  ]),
};

// PIC_ID 는 인라인 키인 + UserInfoPopup 더블클릭 둘 다 허용(AS-IS 복원, SpdMain_Change→CheckUser cs:1400/1409).
//   키인/팝업 어느 경로든 SCP0050(CAPA PIC = SSP planner 등록) 검증 — 미등록이면 셀 클리어+MSG00251.
//   검증은 그리드 cellEditEnded(키인)·handleUserSelected(팝업)에서 수행(§3-3/§3-4 R-PIC-CHECK).
export const PIC_ID_COLUMN = 'PIC_ID';
export const PIC_NAME_COLUMN = 'PIC_NAME';
// GROUP_CODE5(82)는 RTFGubun 팝업이 NAME 을 쓴다 — 인라인 키인 락(§3-3 R-POPUP-RTFGUBUN).
export const GROUP_CODE5_COLUMN = 'GROUP_CODE5';

/**
 * 그리드 셀 인라인 편집 가능 판정 (03_grid-columns.md §3-2 R-EDIT-TOGGLE + R-LOCK-{81,82,40}).
 *
 * - 조회모드(editMode=false): 전 셀 락(AS-IS SetLockAllRows(true)).
 * - 편집모드: layout 별 EDITABLE_COLUMNS 에 속한 컬럼만 편집.
 * - PIC_ID: 전 레이아웃 공통으로 키인 허용(AS-IS 복원, 사용자 지시 2026-10-07). 키인 종료 시 SCP0050
 *   검증(그리드 cellEditEnded → onPicCellEdited). 더블클릭 UserInfoPopup 도 병행.
 */
export const isCellEditable = (params: {
  binding: string;
  divisionId: string;
  editMode: boolean;
}): boolean => {
  const { binding, divisionId, editMode } = params;
  if (!editMode || !binding) return false;
  if (binding === PIC_ID_COLUMN) return true;
  return EDITABLE_COLUMNS[layoutOf(divisionId)].has(binding);
};

// 셀 더블클릭 팝업 라우팅용 — 편집모드에서만.
//   PIC_ID(공통, UserInfoPopup) / GROUP_CODE5+division82(RTFGubun, GroupCodeRtfGubunModal).
export const isPicPopupCell = (binding: string): boolean => binding === PIC_ID_COLUMN;
export const isRtfGubunCell = (binding: string, divisionId: string): boolean =>
  binding === 'GROUP_CODE5' && divisionId === '82';
