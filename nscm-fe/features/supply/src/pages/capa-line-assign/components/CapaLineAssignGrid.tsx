import { AllowMerging, CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  ASSIGN_HEADER_ROW_HEIGHT,
  COLUMN,
  MENU_ID,
  SHEETS,
} from '../capa-line-assign.constants';
import type { GridRow } from '../capa-line-assign.types';
import type { ColumnLayoutOverride } from '../useCapaLineAssignStore';
import { dummyCodeTypeOf } from '../utils/capaLineAssign.dummyCode';
import { isAssignCellEditable, isDateColumn } from '../utils/capaLineAssign.editLock';
import {
  buildCellComboCandidates,
  clearSubCodes,
  markDummyYn,
  syncCodeAndName,
  type CellComboSources,
} from '../utils/capaLineAssign.gridCombos';
import { applyEditModeVisibility, applyLayoutToColumns } from '../utils/capaLineAssignColumns';

interface Props {
  sheet: SHEETS.ASSEMBLY | SHEETS.ELTR;
  data: GridRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns: RawFlexGridColumnConfig[];
  userColumnLayout?: ColumnLayoutOverride[];
  dateColumns: FlexGridColumnConfig[];
  editMode: boolean;
  comboSources: CellComboSources;
  dummyCodes: Set<string>;
  /**
   * 셀 더블클릭 라우팅(hook #18 / 00 §4e P03):
   *   · `NICK_NAME`(ASSEMBLY 전용) → P01 Item 팝업
   *   · 그 외 고정블록 셀           → P03 CAPA Line 팝업
   */
  onCellDblClick: (binding: string, row: GridRow) => void;
  /**
   * 마스터에 없는 명칭이 `NICK_NAME`/`ITEM_ID` 에 입력됐을 때(G14·G15).
   * 페이지가 CHECK SP 로 Dummy 코드를 채번하고 클라 목록·`DUMMY_YN` 을 갱신한다.
   */
  onUnknownItemName: (binding: string, row: GridRow, name: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Wijmo 는 셀 DOM 을 재사용하므로 조건 미해당 시에도 항상 클래스를 해제한다(hook #95 §1-4).
const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

/**
 * Assign 탭 그리드 (AS-IS `spdAssign` / 시트 `ASSEMBLY` | `ELTR`).
 *
 * 컬럼셋은 admin `SCM_MST_SHEET_COLUMNS` 에서 오고(하드코딩 금지, C-1), 동적 기간컬럼은
 * `P_SCP0104_GET_SPREAD_TITLE` 이 공급한 3단 헤더를 `dynamicColumns` 로 붙인다(§2.3).
 *
 * 화면이 직접 담당하는 것:
 *   (a) 행상태 기반 편집잠금 — `beginningEdit`/`pastingCell` (G18~G21·G43)
 *   (b) 편집가능 셀 배경 — `formatItem` (hook #95)
 *   (c) 셀 콤보 후보 주입 — 메타 미이관분 16종 복원(§0.4·§5.6 B-2)
 *   (d) 코드↔명칭 동기 · 하위 cascade 클리어 · Dummy 마킹 (§3.2)
 *   (e) 병합 ON/OFF — 조회모드에서만 병합(§3.4)
 */
export const CapaLineAssignGrid = ({
  sheet,
  data,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  userColumnLayout,
  dateColumns,
  editMode,
  comboSources,
  dummyCodes,
  onCellDblClick,
  onUnknownItemName,
}: Props) => {
  const isEltr = sheet === SHEETS.ELTR;

  // 편집모드 표시/숨김(X-F)은 개인화 오버레이 **뒤**에 얹는다 — AS-IS 도 `SetVisibleSheetColumns` 가
  //   컬럼셋 구성 말미에 호출된다(cs:5545-5548 → BeforeFindData* 경유).
  const columns = useMemo(
    () => applyEditModeVisibility(applyLayoutToColumns(adminColumns, userColumnLayout), editMode, true),
    [adminColumns, userColumnLayout, editMode]
  );

  // 셀 콤보 @토큰(@mnuId) 해소 — VALID_YN/DUMMY_YN 의 `YesOrNo` 는 메타 구동이다.
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 핸들러는 columns 변경 시 1회만 재등록한다 — 최신 상태는 ref 로 읽는다(stale closure 방지).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;
  const comboSourcesRef = useRef(comboSources);
  comboSourcesRef.current = comboSources;
  const dummyCodesRef = useRef(dummyCodes);
  dummyCodesRef.current = dummyCodes;
  const cellDblClickRef = useRef(onCellDblClick);
  cellDblClickRef.current = onCellDblClick;
  const unknownItemNameRef = useRef(onUnknownItemName);
  unknownItemNameRef.current = onUnknownItemName;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const rowOf = (index: number): GridRow | undefined =>
      grid.rows[index]?.dataItem as GridRow | undefined;

    const editableAt = (col: number, row: number): boolean =>
      isAssignCellEditable({
        binding: grid.columns[col]?.binding ?? '',
        row: rowOf(row),
        editMode: editModeRef.current,
        isEltr,
      });

    // (b) 편집가능 셀 배경 — 편집 가능일 때만 클래스, 그 외는 반드시 해제(회색 일괄칠 금지).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      toggleClass(e.cell, 'wj-cell-editable', editableAt(e.col, e.row));
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    grid.formatItem.addHandler(formatItemHandler);

    // (a)+(c) 편집 진입 — 잠금 판정이 먼저, 통과하면 그 행 컨텍스트로 콤보 후보를 계산해 주입한다.
    //   공용 DataGrid 의 메타 기반 판정 뒤에 화면이 최종 재지정한다(동적 기간컬럼 override 포함).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const column = sender.columns[e.col];
      const binding = column?.binding ?? '';
      const row = rowOf(e.row);
      // SOP 그리드와 동일하게 **양방향 지정**한다(GAP-10). 공용 `defaultEditHandler` 가 먼저 등록되므로
      //   편집 가능일 때 false 로 되돌리지 않으면 메타 `INPUT_TP_CD='S'` 판정이 그대로 남아 AS-IS 가
      //   신규행에서 열어주는 고정블록(G18 `isInsertMode=false`, cs:3985)이 잠긴 채로 남는다.
      //   두 그리드 모두 **화면 판정(`isAssignCellEditable`/`isSopCellEditable`)이 정본**이다.
      e.cancel = !editableAt(e.col, e.row);
      if (e.cancel) return;
      if (!row) return;
      const candidates = buildCellComboCandidates(binding, row, comboSourcesRef.current, isEltr);
      if (!candidates || candidates.length === 0) return;
      // 후보는 코드/명칭 자기 자신이다 — 표시 변환이 없으므로 `formatItem` 복원이 필요 없다.
      column.dataMap = new DataMap(
        candidates.map(value => ({ value })),
        'value',
        'value'
      );
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    // (d) 편집 종료 — 코드↔명칭 동기 → 하위 cascade 클리어 → Dummy 마킹 순서(AS-IS CheckDummyName).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const column = sender.columns[e.col];
      const binding = column?.binding ?? '';
      const row = rowOf(e.row);
      // 다음 행 진입 시 후보가 섞이지 않게 주입한 dataMap 을 되돌린다(메타 콤보는 여기 오지 않는다).
      if (column?.dataMap && buildCellComboCandidates(binding, row ?? {}, comboSourcesRef.current, isEltr))
        column.dataMap = null;
      if (!row) return;
      syncCodeAndName(binding, row, comboSourcesRef.current.masterRows);
      clearSubCodes(binding, row);
      markDummyYn(row, dummyCodesRef.current);
      sender.invalidate();
      // G14·G15 — 마스터에 없는 명칭이면 Dummy 코드 채번(비동기). `markDummyYn` 뒤에 둬야
      //   채번 성공 시 세우는 `DUMMY_YN='Y'` 가 마스터 기준 재계산에 지워지지 않는다(AS-IS 순서).
      const dummyType = dummyCodeTypeOf(binding, isEltr);
      if (!dummyType) return;
      const name = str(row[binding]).trim();
      if (!name) return;
      const key = isEltr ? COLUMN.ITEM_ID : COLUMN.NICK_NAME;
      const known = comboSourcesRef.current.nicknameRows.some(
        candidate => str(candidate[key]) === name
      );
      if (known) return;
      unknownItemNameRef.current(binding, row, name);
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    // (a) 붙여넣기도 같은 게이트 — AS-IS `LockRange2` 가 이미 막은 셀에 값이 들어가면 안 된다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editableAt(e.col, e.row)) e.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    // 셀 더블클릭 팝업 2종(hook #18): `NICK_NAME` → P01 Item / 그 외 고정블록 → P03 CAPA Line.
    //   **ELTR 은 `NICK_NAME` 으로 Item 팝업이 열리지 않는다**(B34, 2025-03-31 개정, A-7) —
    //   그 시트에서 `NICK_NAME` 은 잠금 컬럼이므로 여기서도 P01 경로를 타지 않는다.
    //   동적 기간컬럼 더블클릭은 팝업 대상이 아니다(값 편집 구간).
    const dblClickHandler = (event: MouseEvent) => {
      if (!editModeRef.current) return;
      const hit = grid.hitTest(event);
      if (hit.cellType !== CellType.Cell) return;
      const binding = grid.columns[hit.col]?.binding ?? '';
      if (!binding || isDateColumn(binding)) return;
      if (isEltr && binding === COLUMN.NICK_NAME) return;
      const row = GridUtils.getRow(grid, hit.row) as GridRow | undefined;
      if (!row) return;
      cellDblClickRef.current(binding, row);
    };
    grid.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.cellEditEnded?.removeHandler(cellEditEndedHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dateColumns, isEltr]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dateColumns}
      comboParams={comboParams}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      excelFileName='CapaLineAssign'
      // 3단 헤더 총높이 48px 고정(hook #93).
      headerRowHeight={ASSIGN_HEADER_ROW_HEIGHT}
      /*
        셀 병합은 조회모드일 때만이다(AS-IS `SetSheetMergeAssign` = `SetToggleMerge(si, !editMode)`) —
        병합된 셀을 편집하면 어느 행을 고쳤는지 알 수 없다. 신규행(`CRUD_TYPE='I'`) 제외는 공용
        `CustomMergeManager` 소관.

        대상 컬럼 = **메타에서 온 정적 컬럼 전부**다(iter-2 GAP-07 정정). AS-IS 원천:
          · `SpreadInfo.SetSheetHeaderColumn`(SpreadInfo.cs:11612)이 메타로 컬럼을 만들 때
            `merge = FPMerge.Restricted` 를 조건 없이 전 컬럼에 건다(:11700).
          · `SmartColMerge`(:10114) → `SmartColMergeOld`(:10405)가 숨은 `COLMERGE` 열을 끼워
            "왼쪽 전 컬럼이 같을 때만" 이라는 Restricted cascade 로 병합한다.
          · TO-BE `CustomMergeManager._getMergeKey`(foundation/utils/mergeManager.ts:123-139)가
            머지키를 좌측 누적해 같은 cascade 를 구현한다 → 전 컬럼을 켜도 과병합이 아니다.
        컬럼별 `allowMerging` 을 따로 세우지 않는 이유(iter-3 GAP-22): 공용 DataGrid 가 정적 컬럼의
        `allowMerging` 을 이 prop 값으로 **일괄 재지정**한다(DataGrid.tsx:922-930) — 컬럼 단위 지정은
        무시되므로 화면은 이 그리드 레벨 스위치 하나만 쓴다. 동적 기간컬럼은 `buildDateColumns` 가
        `allowMerging: false` 로 따로 둔다(동적 컬럼은 일괄 재지정 대상이 아니다).
      */
      allowMerging={editMode ? AllowMerging.ColumnHeaders : AllowMerging.All}
    />
  );
};
