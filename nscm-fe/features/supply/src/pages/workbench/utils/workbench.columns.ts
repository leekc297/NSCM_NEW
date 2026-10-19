// SCP0125 컬럼 구성 — admin 메타(`SCM_MST_SHEET_COLUMNS` 102행)에 (a) division 조건부 표시(V1~V5)
//   (b) 셀 콤보 후보(dataMap) 만 얹는다. 컬럼 목록·라벨·폭·정렬·소수자리는 전부 메타 소비다
//   (하드코딩 0건 — hook #65/#96/#108, CLAUDE.md §2 체크 3·4항).
//
// "숨김" = **폭 0**이다(Visible=false 아님). SVN BASE `SheetUtils.SetVisibleSheetColumn` 실측:
//   `if (visible) setColumnWidth(idx, w); else setColumnWidth(idx, 0);` — `visible` 인자는 미사용.
//   폭 0 이면 화면에서 도달 불가하되 **행 데이터·저장 payload 에는 그대로 남는다**(03 §2.2/§4.3).
//   `visible:false` 로 바꾸면 `useSaveWithValidation` 이 숨김 컬럼을 필수검증에서 빼는 등 의미가
//   달라지므로 폭 0 을 유지한다.
//
// 재평가 트리거 4곳(03 §2.2): mount · 조회마다 · Division 변경 · 탭 전환 → 이 함수는 순수하므로
//   호출부(useMemo deps)가 division·staticColumns 를 물면 4곳 전부 자동 재평가된다.

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { DYNAMIC_COLUMNS, type TABS } from '../workbench.constants';

import type { CellComboRows } from './workbench.gridCombos';

const HIDDEN_WIDTH = 0;

/** division 조건부 표시 규칙(V1~V5) 적용 후 폭을 돌려준다. 규칙이 없는 컬럼은 메타 폭 그대로. */
const resolveWidth = (
  tab: TABS,
  column: RawFlexGridColumnConfig,
  divisionId: string
): number | undefined => {
  const rule = DYNAMIC_COLUMNS[tab][column.colNm];
  if (!rule) return column.colWth;
  if (rule.visibleWhenDivision === undefined) return rule.shownWidth ?? column.colWth;

  const matched = divisionId === rule.visibleWhenDivision;
  const shown = rule.negate ? !matched : matched;
  if (!shown) return HIDDEN_WIDTH;
  return rule.shownWidth ?? column.colWth;
};

/**
 * 화면 컬럼 구성 — `staticColumns`(admin fetch) + division + 셀 콤보 후보.
 *
 * `cellCboDataTp` 가 남아 있는 컬럼(`YesOrNo` 1종)은 건드리지 않는다 — 공용 DataGrid 의
 * 자동 콤보 경로가 담당한다. 그 밖의 콤보 컬럼은 `05_register.sql` 이 `cellCboDataTp` 를 비우고
 * `cellCtrlObjTpCd='FPComboBox'` 만 세웠으므로 여기서 `dataMap` 을 주입한다.
 */
export const buildColumns = (
  tab: TABS,
  staticColumns: RawFlexGridColumnConfig[],
  divisionId: string,
  comboRows: CellComboRows
): RawFlexGridColumnConfig[] =>
  staticColumns.map(column => {
    const width = resolveWidth(tab, column, divisionId);
    const rows = comboRows[column.colNm];
    // 메타에 자동 콤보(cellCboDataTp)가 살아 있으면 공용 경로를 존중하고 주입하지 않는다.
    const injectDataMap =
      !!rows && !column.cellCboDataTp && column.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO;

    if (width === column.colWth && !injectDataMap) return column;
    return {
      ...column,
      colWth: width,
      ...(injectDataMap ? { dataMap: rows } : {}),
    };
  });

// 참고: AS-IS `SetColumHide`(cs:477 — BASE SheetUtils:1353~1359)는 폭 0 컬럼의 `Resizable` 을 끈다.
//   TO-BE 는 폭 0 컬럼이 렌더 자체에서 잡히지 않아 리사이즈 핸들이 생기지 않으므로 별도 처리가 없다.
