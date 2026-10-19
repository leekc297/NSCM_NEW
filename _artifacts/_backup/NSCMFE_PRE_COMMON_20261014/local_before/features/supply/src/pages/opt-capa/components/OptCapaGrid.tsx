import { CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ADMIN_SHEET_NAME,
  COLUMN,
  DAY_OF_WEEK_LABELS,
  EXCEL_FILE_NAME,
  FIX_CANDIDATES,
  MENU_ID,
  SHEETS,
  SOP_EOP_TYPE_CANDIDATES,
  type GridSheet,
} from '../opt-capa.constants';
import type { GridRow, LineRow, LineTypeRow, OperationRow, PlantRow } from '../opt-capa.types';
import {
  buildLineCellCandidates,
  buildLineTypeCellCandidates,
  buildOperationCellCandidates,
  buildPlantCellCandidates,
  deriveLineName,
  deriveOperationByLine,
  rowPlantIdOf,
  shouldClearLineOnPlantChange,
  str,
} from '../utils/optCapa.candidates';
import {
  canInjectLineTypeCombo,
  isLockedByOptCapaRule,
  isRowConditionalLock,
} from '../utils/optCapa.editLock';

export interface CellComboSources {
  plantAll: PlantRow[];
  lineAll: LineRow[];
  operationAll: OperationRow[];
  lineTypeAll: LineTypeRow[];
  /** 조회조건에서 확정된 Plant CODE 전개값 — `PLANT_ID` 셀 콤보의 2차 제한축이다(R-19). */
  selectedPlantCodes: string[];
  /** 조회조건 Plant/Line 후보 — `LINE_ID`→`OPERATION_ID` 2단 조회의 원천이다(R-09). */
  plantCandidates: PlantRow[];
  lineCandidates: LineRow[];
}

interface Props {
  sheet: GridSheet;
  data: GridRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns: RawFlexGridColumnConfig[];
  /**
   * 편집 가능 여부 = `canEdit = hasButton('EDIT')`(mount 1회 권한, `useOptCapaActions`).
   * AS-IS Edit 잠금 토글(R-02·R-03)은 TO-BE 공통 결정으로 미채용 — 권한이 있으면 조회 직후 바로
   * 편집 가능하고, 없으면 이 값이 false 라 `editableAt` 첫 가드가 전 셀을 잠근다.
   */
  editMode: boolean;
  /** 확정 조회조건 division — 행/열 잠금·셀콤보 주입 가드의 입력값이다. */
  divisionId: string;
  comboSources: CellComboSources;
  /**
   * `ITEM_ID` 더블클릭 → 공용 Item 팝업(R-11). Daily Capa 는 호출되지 않는다.
   * 8탭이 동시 렌더되므로(persist) 어느 시트의 행인지 함께 넘긴다 — 부모가 그 시트의
   * EditTracker/grid 에 결과를 반영한다.
   */
  onItemCellDblClick: (row: GridRow, sheet: GridSheet) => void;
}

// Wijmo 는 셀 DOM 을 재사용하므로 조건 미해당 시에도 클래스를 반드시 해제한다(hook #95 §1-4).
const toggleClass = (element: HTMLElement, className: string, on: boolean): void => {
  if (on) element.classList.add(className);
  else element.classList.remove(className);
};

/** `YYYY-MM-DD` 표시값 → 요일 3글자 대문자. locale 의존 금지(AS-IS `InvariantCulture`, cs:3630). */
const dayOfWeekOf = (displayDate: string): string | undefined => {
  const stored = displayDate.replace(/-/g, '');
  if (!/^\d{8}$/.test(stored)) return undefined;
  const probe = new Date(
    Number(stored.slice(0, 4)),
    Number(stored.slice(4, 6)) - 1,
    Number(stored.slice(6, 8))
  );
  if (Number.isNaN(probe.getTime())) return undefined;
  return DAY_OF_WEEK_LABELS[probe.getDay()];
};

/**
 * 8탭 공통 그리드 1벌 — 컬럼셋은 `staticColumns[activeSheet]` 로 갈린다.
 * 시트별 그리드 컴포넌트 8개를 만들지 않는다(design 01 §7 hook #9 — 진입 Page ≤400라인 강제).
 *
 * 화면이 직접 담당하는 것:
 *   (a) 편집 잠금 — `beginningEdit`/`pastingCell` 최종 override (R-02·R-03·R-05·R-06)
 *   (b) 편집가능 셀 배경 — `formatItem` (hook #95)
 *   (c) 셀 콤보 6종 후보 주입 — AS-IS `SetComboDataRow` 이식 (R-07·R-19·R-20·R-21)
 *   (d) 파생 3종 + Plant 변경 cascade — `cellEditEnded` (R-08·R-09·R-10·R-13)
 *   (e) 붙여넣기 시 `LINE_NAME` 재파생 (R-12)
 *   (f) `ITEM_ID` 더블클릭 팝업 3중 가드 (R-11)
 *
 * 컬럼은 **전부 admin 메타 구동**이다 — `FlexGridColumn binding=` 직접 명세 금지,
 * `frozenColumns` 지정 금지(`FIXED_FLAG` 전건 `'-'`), 2단 헤더 `height` 지정 금지
 * (`Yield(Elec.)` 의 `SMALL_CLASS_LABEL_NAME` 메타가 완결한다 — design 03 §1.8 / hook #93).
 */
export const OptCapaGrid = ({
  sheet,
  data,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  editMode,
  divisionId,
  comboSources,
  onItemCellDblClick,
}: Props) => {
  // 셀 콤보 @토큰(@mnuId) 해소 — `VALID_YN`/`WIDE_YN` 의 `YesOrNo` 는 메타 구동이라 이 경로를 쓴다.
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  // 핸들러는 컬럼셋 변경 시 1회만 재등록하고, 최신 상태는 ref 로 읽는다(stale closure 방지).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;
  const divisionIdRef = useRef(divisionId);
  divisionIdRef.current = divisionId;
  const sourcesRef = useRef(comboSources);
  sourcesRef.current = comboSources;
  const itemDblClickRef = useRef(onItemCellDblClick);
  itemDblClickRef.current = onItemCellDblClick;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const rowOf = (index: number): GridRow | undefined =>
      grid.rows[index]?.dataItem as GridRow | undefined;

    /**
     * 셀 편집 가능 판정 = **공용 메타 게이트 AND 화면 추가 잠금**.
     *
     *   ① `editMode`(=`canEdit` 권한) — 없으면 전 셀 잠금. AS-IS Edit 토글(R-02·R-03) 미채용이라
     *      권한이 있으면 조회 직후 바로 편집 가능(모드 해제 단계 없음).
     *   ② `GridUtils.isEditableCell` — `INPUT_TP_CD`(M/O/S) + `EDIT_FLAG` 메타 판정. **정본**이다.
     *      컬럼 단위 Lock 집합을 화면 상수배열로 다시 들지 않는다(hook #130).
     *   ③ `isLockedByOptCapaRule` — 메타로 못 쓰는 division·행 값 종속 잠금(R-05·R-06)만 추가.
     */
    const editableAt = (col: number, row: number): boolean => {
      if (!editModeRef.current) return false;
      if (!GridUtils.isEditableCell(grid, row, col)) return false;
      return !isLockedByOptCapaRule({
        sheet,
        binding: grid.columns[col]?.binding ?? '',
        row: rowOf(row),
        divisionId: divisionIdRef.current,
      });
    };

    /**
     * (c) 셀 콤보 후보 — AS-IS `SpdMain_CellClick`(cs:3780-3828)의 `SetComboDataRow` 이식.
     *
     * 후보가 조회조건 division·선택 Plant·활성 시트·**그 행의 상위 셀** 에 동시에 종속되므로
     * `SCM_ADM_CMBO_SQL_M` + `comboParams` 로는 등가가 되지 않는다(design 03 §6 Q6). 그래서
     * 자매 `capa-line-assign` 선례대로 FE 주입으로 재현한다 → CMBO_SQL 신규 등록 0건.
     * 셀 드롭다운은 **CODE 를 표시**한다(AS-IS 가 `NAME:=CODE` 로 덮어쓴다, design 03 §1.9 규약).
     *
     * `Daily Capa` 는 셀 콤보 자체가 제외 대상이다(cs:3780 `!= shtDailyCapa`).
     */
    const candidatesFor = (binding: string, row: GridRow | undefined): string[] | undefined => {
      if (sheet === SHEETS.DAILY_CAPA) return undefined;
      const sources = sourcesRef.current;
      const division = divisionIdRef.current;
      switch (binding) {
        case COLUMN.PLANT_ID:
          return buildPlantCellCandidates(
            sources.plantAll,
            division,
            sources.selectedPlantCodes,
            sheet
          );
        case COLUMN.LINE_ID:
          // 그 행의 `PLANT_ID` 로 좁힌다 — 조회조건 Plant 선택이 아니다(R-20).
          return buildLineCellCandidates(sources.lineAll, division, rowPlantIdOf(row));
        case COLUMN.OPERATION_ID:
          return buildOperationCellCandidates(sources.operationAll, division, sheet);
        case COLUMN.LINE_TYPE:
          // 주입 자체가 `EE_UC` 한정이다(R-07, cs:3809-3817) — 그 외에는 드롭다운이 없다.
          if (!canInjectLineTypeCombo(division)) return undefined;
          return buildLineTypeCellCandidates(
            sources.lineTypeAll,
            str(row?.[COLUMN.OPERATION_ID])
          );
        case COLUMN.FIX:
          // AS-IS 클라 리터럴 2행(공백/`Y`, cs:253-265). No Work 에만 있는 컬럼이다.
          return [...FIX_CANDIDATES];
        case COLUMN.TYPE:
          // `SOP/EOP` 시트 한정(cs:3822-3828). 다른 시트의 `TYPE` 은 없다.
          if (sheet !== SHEETS.SOP_EOP) return undefined;
          return [...SOP_EOP_TYPE_CANDIDATES];
        default:
          return undefined;
      }
    };

    /**
     * (b) 셀 배경 3색 — hook #95 §0/§3.3.
     *   · Yellow(`wj-cell-editable`)          = 지금 편집 가능
     *   · Gray  (`wj-cell-non-editable`)      = **메타상 편집 가능한데 행 조건으로 잠긴** 셀
     *   · 클래스 없음                          = 기본(White + zebra)
     *
     * Gray 대상은 `isRowConditionalLock` 이 참인 셀뿐이다(= R-06 Daily Capa × `EE_UC` × 행
     * `OPERATION_ID`). 컬럼 전체가 잠기는 R-05(`LINE_TYPE`)나 비편집 컬럼을 회색칠하면
     * hook #95 §2 안티패턴 #1·#2(조회 grid 통째 회색)가 된다 — 그 판정은
     * `optCapa.editLock.isRowConditionalLock` 주석에 근거를 뒀다.
     *
     * Wijmo 는 셀 DOM 을 재사용하므로 두 클래스를 **양쪽 모두 명시**해 해제한다(hook #95 §1-4).
     * iter-1~4 는 Gray 를 항상 `false` 로 둬 3색이 2색이었다(design `00_checklist.md:606` 이
     * "편집가능 Yellow / 편집-잠금 Gray 3색 구분 필요" 로 요구한 축).
     */
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const metaEditable =
        editModeRef.current && GridUtils.isEditableCell(grid, e.row, e.col);
      const grayed =
        metaEditable &&
        isRowConditionalLock({
          sheet,
          binding: grid.columns[e.col]?.binding ?? '',
          row: rowOf(e.row),
          divisionId: divisionIdRef.current,
        });
      toggleClass(e.cell, 'wj-cell-editable', editableAt(e.col, e.row));
      toggleClass(e.cell, 'wj-cell-non-editable', grayed);
    };
    grid.formatItem.addHandler(formatItemHandler);

    /**
     * (a)+(c) 편집 진입 — 잠금 판정이 먼저, 통과하면 그 행 컨텍스트로 후보를 계산해 주입한다.
     *
     * **단방향(잠그기만)** 이다: 공용 `defaultEditHandler`(`dataGridUtils.ts:370`)가 먼저 등록돼
     * 메타 `INPUT_TP_CD` 로 `cancel` 을 세워 두는데, 여기서 `false` 로 되돌리면 admin 메타를
     * 화면이 덮어쓰는 셈이 된다(CLAUDE.md §2 "속성 단위 덮어쓰기 금지"). 메타 정정이 적용된
     * 뒤(2026-09-26 iter-2)로는 되돌릴 이유도 없다 — 화면은 추가로 잠그는 역할만 한다.
     */
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const column = sender.columns[e.col];
      const binding = column?.binding ?? '';
      if (!editableAt(e.col, e.row)) {
        e.cancel = true;
        return;
      }
      if (e.cancel) return; // 공용 게이트가 이미 막은 셀(예: MODAL 컨트롤)은 그대로 둔다
      if (!column) return;
      const candidates = candidatesFor(binding, rowOf(e.row));
      if (!candidates) return;
      // 후보 0건도 의미가 있다 — `LINE_TYPE` 은 Operation 이 매칭되지 않으면 0건이 정답이다.
      column.dataMap = new DataMap(
        candidates.map(value => ({ value })),
        'value',
        'value'
      );
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    /**
     * 파생 2종 — **편집 종료와 붙여넣기가 같은 함수를 쓴다**(iter-3 감사 G3-7).
     *
     * AS-IS 는 요일·Line 명 파생을 `DefaultSheetDataModel.Changed`(cs:3619-3636, 등록 cs:719-720)에
     * 걸어 셀 편집·붙여넣기·프로그램 SetValue 를 **모두** 포착한다. TO-BE 는 Wijmo 이벤트가
     * `cellEditEnded`/`pastedCell` 로 갈리므로 두 핸들러가 이 함수들을 공유해야 어긋나지 않는다
     * (경로마다 다른 코드를 두면 다시 갈라진다).
     * 반환값은 "값을 바꿨는가" = 호출부의 `invalidate()` 필요 여부다.
     */
    const applyLineNameDerivation = (row: GridRow): boolean => {
      const lineId = str(row[COLUMN.LINE_ID]);
      if (!lineId) return false;
      const lineName = deriveLineName(sourcesRef.current.lineAll, lineId);
      if (lineName === undefined) return false;
      row[COLUMN.LINE_NAME] = lineName;
      return true;
    };
    /** `NO_WORK_DATE` → `DAY_OF_WEEK`(R-13, 영문 3글자 대문자 고정 — locale 의존 금지). */
    const applyDayOfWeekDerivation = (row: GridRow): boolean => {
      const dayOfWeek = dayOfWeekOf(str(row[COLUMN.NO_WORK_DATE]));
      if (!dayOfWeek) return false;
      row[COLUMN.DAY_OF_WEEK] = dayOfWeek;
      return true;
    };

    /**
     * (d) 편집 종료 — 파생 3종 + Plant 변경 cascade.
     *   · `PLANT_ID` 변경 → 새 Line 후보에 현재 `LINE_ID` 가 **없을 때만** 클리어(R-10)
     *   · `LINE_ID` 변경 → `LINE_NAME`(R-08) + `OPERATION_ID`(R-09, 못 찾으면 공백이 정답)
     *   · `NO_WORK_DATE` 변경 → `DAY_OF_WEEK`(R-13, 영문 3글자 대문자)
     */
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const column = sender.columns[e.col];
      const binding = column?.binding ?? '';
      const row = rowOf(e.row);
      // 다음 행 진입 시 후보가 섞이지 않게 주입한 dataMap 을 되돌린다(메타 콤보는 여기 오지 않는다).
      if (column?.dataMap && candidatesFor(binding, row)) column.dataMap = null;
      if (!row) return;
      const sources = sourcesRef.current;
      const division = divisionIdRef.current;

      if (binding === COLUMN.PLANT_ID) {
        const lineId = str(row[COLUMN.LINE_ID]);
        if (shouldClearLineOnPlantChange(sources.lineAll, division, rowPlantIdOf(row), lineId)) {
          row[COLUMN.LINE_ID] = '';
          row[COLUMN.LINE_NAME] = '';
        }
      } else if (binding === COLUMN.LINE_ID) {
        applyLineNameDerivation(row);
        // `OPERATION_ID` 는 값이 비어도 파생을 돌린다 — 못 찾으면 **공백이 정답**이다(R-09).
        row[COLUMN.OPERATION_ID] = deriveOperationByLine(
          sources.plantCandidates,
          sources.lineCandidates,
          str(row[COLUMN.DIVISION_ID]),
          str(row[COLUMN.PLANT_ID]),
          str(row[COLUMN.LINE_ID])
        );
      } else if (binding === COLUMN.NO_WORK_DATE && sheet === SHEETS.NO_WORK) {
        applyDayOfWeekDerivation(row);
      }
      sender.invalidate();
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    // (a) 붙여넣기도 같은 게이트 — AS-IS 가 이미 잠근 셀에 값이 들어가면 안 된다.
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editableAt(e.col, e.row)) e.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    /**
     * (e) 붙여넣기 완료 — `LINE_ID` 열이면 `LINE_NAME`(R-12, cs:3638-3661), `NO_WORK_DATE` 열이면
     * `DAY_OF_WEEK`(R-13) 재파생.
     *
     * 붙여넣기는 편집 세션을 거치지 않아 `cellEditEnded` 가 뜨지 않으므로 `pastedCell` 을 따로
     * 태운다(자매 선례 `business-plan`). AS-IS 는 범위를 순회하며 **텍스트가 빈 셀은 건너뛴다**.
     * `Daily Capa` 는 제외 대상이다(cs:3642).
     *
     * 요일 축을 빠뜨리면 날짜를 붙여넣어도 `DAY_OF_WEEK` 가 이전 값으로 남고, 그 컬럼은
     * `INPUT_TP_CD='S'` 라 사용자가 손으로 고칠 수도 없다(iter-3 감사 G3-7).
     */
    const pastedCellHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      if (sheet === SHEETS.DAILY_CAPA) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = rowOf(e.row);
      if (!row) return;
      let changed = false;
      if (binding === COLUMN.LINE_ID) changed = applyLineNameDerivation(row);
      else if (binding === COLUMN.NO_WORK_DATE && sheet === SHEETS.NO_WORK) {
        changed = applyDayOfWeekDerivation(row);
      }
      if (!changed) return;
      sender.invalidate();
    };
    grid.pastedCell.addHandler(pastedCellHandler);

    /**
     * (f) `ITEM_ID` 더블클릭 → 공용 Item 팝업. 가드 3중(cs:3732-3765):
     *   ① 헤더가 아니다 ② 편집권한 있음(`editMode`=`canEdit`) ③ 활성시트가 `Daily Capa` 가 아니다.
     * 팝업 셀은 더블클릭이 인라인 편집으로 먼저 빠지지 않게 진입을 취소한다(nscm-patterns §5-16).
     */
    const dblClickHandler = (event: MouseEvent) => {
      if (sheet === SHEETS.DAILY_CAPA) return;
      if (!editModeRef.current) return;
      const hit = grid.hitTest(event);
      if (hit.cellType !== CellType.Cell) return;
      if (grid.columns[hit.col]?.binding !== COLUMN.ITEM_ID) return;
      const row = GridUtils.getRow(grid, hit.row) as GridRow | undefined;
      if (!row) return;
      grid.finishEditing(true);
      itemDblClickRef.current(row, sheet);
    };
    grid.hostElement.addEventListener('dblclick', dblClickHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.cellEditEnded?.removeHandler(cellEditEndedHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.pastedCell?.removeHandler(pastedCellHandler);
        grid.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, sheet]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data as unknown as WijmoRowItem[]}
      staticColumns={adminColumns}
      comboParams={comboParams}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      excelFileName={EXCEL_FILE_NAME}
    />
  );
};
