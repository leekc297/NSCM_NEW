import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { ACTION_COLUMN, ACTIVITY, ADMIN_SHEET_NAME, SHEETS } from '../plan-control.constants';
import type { MasterValidationResult, PlanControlRow } from '../plan-control.types';
import { formatValidationDetail, str } from '../utils/planControl.activity';

import styles from './PlanControlGrid.module.scss';

interface Props {
  gridRef: MutableRefObject<FlexGrid<PlanControlRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: PlanControlRow[];
  // admin SCM_MST_SHEET_COLUMNS 'Plan Control' 22행. 하드코딩·리터럴 덮어쓰기 금지.
  staticColumns: RawFlexGridColumnConfig[];
  masterValidation: MasterValidationResult;
  click: (mouseEvent: MouseEvent) => void;
  dblClick: (mouseEvent: MouseEvent) => void;
  cellEditEnded: (grid: FlexGrid<PlanControlRow>, e: CellRangeEventArgs) => void;
  gotFocus?: () => void;
}

// spdMain "Plan Control" — 컬럼 22개(가시 9)는 전부 admin 메타 구동. 화면이 직접 명세하는 것은
//   셀 표현(LINK 링크체 / CONFIRM 버튼체 / DETAIL 파생문구 / Plan ID 편집가능 색)과 행 조건부 편집잠금뿐이다.
export const PlanControlGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  masterValidation,
  click,
  dblClick,
  cellEditEnded,
  gotFocus,
}: Props) => {
  // G07 의 색 조건은 "메타가 편집을 허용한 컬럼일 때만" 이다. 메타가 조회전용('S')인데 노란색을 칠하면
  //   "노랗지만 안 열리는 셀"이 되어 편집가능 표준색 계약(hook #95)을 깨뜨린다. 리터럴로 덮어쓰지 않고
  //   메타를 읽어 곱한다 — admin 이 INPUT_TP_CD 를 되돌리면 색도 함께 꺼진다.
  const isPlanIdEditableByMeta = useMemo(
    () =>
      staticColumns.some(
        column =>
          column.colNm === ACTION_COLUMN.PLAN_ID &&
          column.inputTpCd !== undefined &&
          column.inputTpCd !== CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
      ),
    [staticColumns]
  );

  // G06·G07·G09~G11·X03 — 셀 표현. 컬럼 메타에 없는 시각 규칙만 여기서 그린다.
  //   DETAIL·CONFIRM 은 SP 가 값을 주지 않는 코드 전용 컬럼이라 반드시 textContent 를 채워야 보인다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (
      _sender: unknown,
      e: { cell: HTMLElement; row: number; col: number; panel: { cellType: CellType } }
    ) => {
      if (e.panel.cellType !== CellType.Cell || e.row < 0) return;
      const binding = grid.columns[e.col]?.binding;
      const row = grid.rows[e.row]?.dataItem as PlanControlRow | undefined;
      if (!row) return;

      if (binding === ACTION_COLUMN.LINK) {
        // LINK 값이 빈 Activity(A004·A005·A006·A009 — lookup ATTRIBUTE9 공란)는 링크 표현을 주지 않는다.
        const linkable = str(row.LINK).trim() !== '';
        e.cell.classList.toggle(styles.linkCell, linkable);
        return;
      }

      if (binding === ACTION_COLUMN.CONFIRM) {
        // 캡션은 그 행의 ACTION_NAME(A001 Confirm / A003 Engine Run Request / A006 Release …).
        const caption = str(row.ACTION_NAME).trim();
        e.cell.textContent = '';
        e.cell.classList.toggle(styles.actionButtonCell, caption !== '');
        if (caption) {
          const label = document.createElement('span');
          label.textContent = caption;
          e.cell.appendChild(label);
        }
        return;
      }

      if (binding === ACTION_COLUMN.DETAIL) {
        // A001 행 + Master Validation 조회 완료 상태일 때만 "Critical : n, Warning : m"(G06·G17).
        const showDetail =
          str(row.OPMZ_ACTV_CD) === ACTIVITY.MASTER_VALIDATION && masterValidation.isValidSearch;
        e.cell.textContent = showDetail
          ? formatValidationDetail(masterValidation.criticalCnt, masterValidation.warningCnt)
          : '';
        return;
      }

      if (binding === ACTION_COLUMN.PLAN_ID) {
        // G07 — 메타가 편집을 허용하고(위 isPlanIdEditableByMeta) 행 조건도 통과한(indp_yn != 'Y')
        //   셀만 편집가능 표준색(Yellow). 임의 hex 금지(hook #95).
        e.cell.classList.toggle(
          'wj-cell-editable',
          isPlanIdEditableByMeta && str(row.OPMZ_PLAN_ID_INDP_YN) !== 'Y'
        );
      }
    };
    grid.formatItem.addHandler(handler);
    return () => grid.formatItem.removeHandler(handler);
  }, [gridRef, isPlanIdEditableByMeta, masterValidation]);

  // G08 — 행 조건부 편집잠금. 컬럼 축 잠금은 메타(INPUT_TP_CD)가 하고, 행 조건은 메타로 표현할 수
  //   없으므로 여기서 마지막에 override 한다(hook #70). Plan ID 외 컬럼은 메타가 이미 잠근다.
  const handleBeginningEdit = (grid: FlexGrid<PlanControlRow>, e: CellRangeEventArgs) => {
    if (grid.columns[e.col]?.binding !== ACTION_COLUMN.PLAN_ID) return;
    const row = grid.rows[e.row]?.dataItem as PlanControlRow | undefined;
    if (!row || str(row.OPMZ_PLAN_ID_INDP_YN) === 'Y') e.cancel = true;
  };

  // E08 — 콤보 셀 키입력 차단. AS-IS SpdMain_KeyPress(cs:1313-1322)는 "잠기지 않은 셀이면서 그 컬럼의
  //   CellType 이 ComboBoxCellType 이면 e.Handled = true" 로 문자 키 입력을 통째로 막는다. 즉 Plan ID 는
  //   드롭다운 선택으로만 바꿀 수 있고 타이핑으로는 못 바꾼다. Wijmo 는 dataMap 콤보 셀에서 문자 키를
  //   누르면 에디터를 열고 증분검색으로 후보를 옮기므로 그대로 두면 AS-IS 와 조작이 달라진다.
  //   capture 로 잡는 이유: Wijmo 에디터가 keydown 을 먼저 소비하면 이미 값이 옮겨간 뒤다
  //   (선례 forecast-price/ForecastPriceGrid.tsx:1803 enforceDecimalKey).
  //   차단 범위는 AS-IS 조건 그대로 "편집 가능한 Plan ID 셀 + 문자 키" 뿐이다 — 방향키·Tab·Enter·
  //   Esc·Backspace·F 키와 Ctrl/Alt/Meta 조합은 통과시켜 드롭다운 열기·이동·취소를 막지 않는다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const blockComboCellKey = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.ctrlKey || keyboardEvent.altKey || keyboardEvent.metaKey) return;
      if (keyboardEvent.key.length !== 1) return; // 문자 키만(AS-IS KeyPress 와 동일 범위)
      if (grid.columns[grid.selection.col]?.binding !== ACTION_COLUMN.PLAN_ID) return;
      // AS-IS 는 `!Locked` 일 때만 막는다 — 메타가 조회전용이거나 행 조건으로 잠긴 셀은 대상이 아니다.
      if (!isPlanIdEditableByMeta) return;
      const row = grid.rows[grid.selection.row]?.dataItem as PlanControlRow | undefined;
      if (!row || str(row.OPMZ_PLAN_ID_INDP_YN) === 'Y') return;
      keyboardEvent.preventDefault();
    };
    grid.hostElement.addEventListener('keydown', blockComboCellKey, true);
    return () => grid.hostElement?.removeEventListener('keydown', blockComboCellKey, true);
  }, [gridRef, isPlanIdEditableByMeta]);

  return (
    <DataGrid<PlanControlRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      sheetName={ADMIN_SHEET_NAME[SHEETS.PLAN_CONTROL]}
      // 병합: 컬럼을 만드는 프레임워크 메타 빌더가 merge=FPMerge.Restricted 를 무조건 대입한다
      //   (SpreadInfo.cs:1797 -> Add*Column -> col.MergePolicy, L2605-2617). 이 그리드가 부르는 SCP
      //   변형(cs:305 SetSheetHeaderColumnSCP)의 본문은 이 워킹트리에 없지만 형제 오버로드 2개가 모두
      //   Restricted 를 하드코딩하고, SCP 변형의 3·4번째 인자는 refreshAllColumn·fixedColumnName 이라
      //   (SCP0108 호출부 변수명 실측) merge 정책을 바꾸는 자리가 아니다 — 04_react-gap.md CN-2.
      allowMerging={AllowMerging.Cells}
      click={click}
      dblClick={dblClick}
      beginningEdit={handleBeginningEdit}
      cellEditEnded={cellEditEnded}
      gotFocus={gotFocus}
    />
  );
};
