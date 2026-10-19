import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  COLUMN,
  COLUMN_WIDTH_EDIT,
  COLUMN_WIDTH_VIEW,
  HEADER_ROW_HEIGHT,
  HIDDEN_COLUMN_WIDTH,
  MEASURE_COLOR,
  MEASURE_COLOR_BY_CODE,
  MENU_ID,
  SCALE_EDIT,
  SCALE_VIEW,
  type DivisionType,
  type GridSheet,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { Scp0106Row } from '../capa-loss-plan.types';
import { isEditablePeriodColumn } from '../utils/capaLossPlan.dateColumns';
import { isCellEditable } from '../utils/capaLossPlan.editLock';

import styles from './CapaLossPlanGrid.module.scss';

interface Props {
  sheetName: GridSheet;
  rows: Scp0106Row[];
  staticColumns: RawFlexGridColumnConfig[];
  periodColumns: FlexGridColumnConfig[];
  isEditMode: boolean;
  progressStatus: string;
  sheetType: SheetType;
  divisionType: DivisionType;
  /** GET measure 결과셋에서 만든 편집가능 measure 집합(`utils/capaLossPlan.editLock`). */
  editableMeasures: Set<string>;
  /** LINE 시트의 생산확정기간 잠금 컬럼 집합. 그 외 시트는 빈 집합. */
  scpPlanFixedColumns: Set<string>;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  onCellEditEnded: (rowIndex: number, binding: string) => void;
}

/**
 * AS-IS `spdMain`(FpSpread, 8시트) -> 공용 DataGrid 1개 + `sheetName` 스위치(03 R-01).
 * 탭이 아니라 스위치라 여러 시트 데이터를 동시에 들고 있지 않는다(`TabStripPolicy=Never`).
 *
 * 화면이 직접 담당하는 것:
 *  (a) 조건부 편집잠금 `beginningEdit` — utils/capaLossPlan.editLock (R-05/R-06)
 *  (b) 병합 토글 — 조회모드 ON / 편집모드 OFF (R-14, L-29)
 *  (c) Measure 행 배경색 — **`MEASURE`(코드) 기준** (R-12, V-57)
 *  (d) 숫자 소수자릿수 2모드 — 메타 `DATA_SCALE_NUMBER` 226행 전건 NULL 이라 화면 상수(R-07, C-05)
 *  (e) 컬럼 폭 2모드 80<->140 (R-04)
 *  (f) 숨김 컬럼 — `COLUMN_WIDTH === 0 -> hidden`(R-03, C-10 메타 무수정 경로)
 *  (g) `Delete` 키 = 선택 범위 `0.0` 일괄 기입 / `Ctrl+Z` 차단 (R-16, V-54)
 *  (h) 붙여넣기 차단 — AS-IS 클립보드 4핸들러가 전부 주석 처리라 **미지원이 파리티**(R-17, BLK-12 확정)
 * 컬럼 목록·머지헤더·컨텍스트메뉴·EditTracker 는 공용 DataGrid 소관이다.
 */
export const CapaLossPlanGrid = ({
  sheetName,
  rows,
  staticColumns,
  periodColumns,
  isEditMode,
  progressStatus,
  sheetType,
  divisionType,
  editableMeasures,
  scpPlanFixedColumns,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onCellEditEnded,
}: Props) => {
  // 셀 콤보 @토큰(@mnuId) 해소 — 인용은 getCombo funnel 이 처리한다(nscm-patterns §3.3).
  //   주의: 이 화면은 셀 콤보를 **배선하지 않는다**. 메타에 `OperationByLine` 이 있지만 대상 컬럼
  //   (`1ST_CUTOFF_LINE_ASSEMBLY.OPERATION_ID`)이 폭0 + 코드 숨김 이중 은닉이라 AS-IS 에서 렌더된
  //   적이 없다 — **미구현이 파리티**다(03 C-07, decisions §A BLK-17). prop 은 공용 규약 유지용.
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  /**
   * (f) 숨김 컬럼 + (e) 폭 2모드를 메타 위에 덧씌운다.
   * AS-IS `SetVisibleSheetColumn` 은 16컬럼을 **코드 배열**로 숨기지만 그 배열을 이식하면
   * hook #130(컬럼명 상수 배열 이식 금지) 위반이자 메타와 이중 관리가 된다. 숨김 신호는
   * 메타에서만 읽는다 — 폭 0 **또는** `VISIBLE_FLAG='N'`(= `column.visible === false`).
   *
   * `VISIBLE_FLAG` 를 함께 보는 이유(gap-resolve iter-1, DB 실측으로 확정):
   *   AS-IS 는 `SCM_SYS_GET_SPREAD_TITLE` 의 개인화 미적용 분기에서 `VISIBLE_FLAG='Y'` 행만
   *   돌려준다 — 즉 `'N'` 컬럼은 그리드에 **생성 자체가 되지 않는다**. 반면 TO-BE
   *   `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` 의 대응 분기는 `VALID_YN='Y'` 만 걸고
   *   전건을 돌려주므로, FE 가 `visible` 을 보지 않으면 AS-IS 에 없는 컬럼이 살아난다.
   *   실측상 이 차이가 드러나는 행은 `IPRV_GOL_DIVS_NM`(4개 시트, `VISIBLE_FLAG='N'` + 폭 100)
   *   뿐이며, AS-IS 화면코드의 `IPRV_GOL_DIVS_*` 참조는 전부 주석 처리돼 있다
   *   ("Improvement Rate 영역 제거하고 Operation Plan에 Goal 직접 입력형태로 수정", 2025-02-07).
   *   `human-doc/asis-screenshot.png` 에 이 컬럼이 보이는 것은 캡처가 **202411** 시점이라
   *   위 제거 변경 이전이기 때문이다(캡처 Plan Month 로 확인).
   */
  const resolvedStaticColumns = useMemo(
    () =>
      staticColumns.map(column => {
        const hidden = (column.colWth ?? 0) === HIDDEN_COLUMN_WIDTH || column.visible === false;
        if (hidden) return { ...column, visible: false, display: false };
        if (column.colNm === COLUMN.PFRSLT_QTY || column.colNm === COLUMN.BASE_QTY) {
          return { ...column, colWth: isEditMode ? COLUMN_WIDTH_EDIT : COLUMN_WIDTH_VIEW };
        }
        return column;
      }),
    [staticColumns, isEditMode]
  );

  // 핸들러는 mount 후 1회 등록이라 최신값을 ref 로 본다(stale closure 방지).
  const editModeRef = useRef(isEditMode);
  editModeRef.current = isEditMode;
  const lockInputRef = useRef({ progressStatus, sheetType, divisionType, editableMeasures, scpPlanFixedColumns });
  lockInputRef.current = { progressStatus, sheetType, divisionType, editableMeasures, scpPlanFixedColumns };
  const editEndedRef = useRef(onCellEditEnded);
  editEndedRef.current = onCellEditEnded;

  /** 공통 잠금 판정 — `beginningEdit`/`formatItem`/`cellEditEnded` 가 같은 함수를 쓴다. */
  const canEdit = (binding: string, row: Scp0106Row | undefined): boolean =>
    isCellEditable({
      binding,
      row,
      isEditMode: editModeRef.current,
      ...lockInputRef.current,
    });

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatItemHandler = (
      sender: FlexGridType,
      event: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (event.panel !== sender.cells) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0106Row | undefined;
      if (!row) return;

      /**
       * (c) Measure 행 배경색 — 적용 범위는 `(행, MEASURE_NAME 열) ~ 행 끝` 이다(R-12).
       * **`MEASURE_NAME`(영문 표시값) 문자열 비교가 아니라 `MEASURE`(코드) 기준**이다 —
       * AS-IS 는 19문자열 하드코딩이라 다국어에서 즉시 깨진다(V-57).
       * AS-IS `SetMeasureColorOneRow`(R-13)는 `else{continue}` 가 없어 미매칭 행을 검정으로
       * 칠하는 dead 코드다 — **이식하지 않는다**.
       * Wijmo 는 셀 DOM 을 재사용하므로 미해당 시에도 반드시 클래스를 해제한다(hook #95 §1-4).
       */
      const measureNameIndex = sender.columns.findIndex(
        column => column.binding === COLUMN.MEASURE_NAME
      );
      const inMeasureRange = measureNameIndex >= 0 && event.col >= measureNameIndex;
      const measure = typeof row[COLUMN.MEASURE] === 'string' ? (row[COLUMN.MEASURE] as string) : '';
      const color = inMeasureRange ? MEASURE_COLOR_BY_CODE[measure] : undefined;
      event.cell.classList.toggle(styles.measureYellow, color === MEASURE_COLOR.YELLOW);
      event.cell.classList.toggle(styles.measureSky, color === MEASURE_COLOR.SKY);
      event.cell.classList.toggle(styles.measureOrange, color === MEASURE_COLOR.ORANGE);
      event.cell.classList.toggle(styles.measurePink, color === MEASURE_COLOR.PINK);

      // 편집 가능 셀 표시 — 미해당 시에도 항상 클래스를 해제한다(DOM 재사용).
      const editable = canEdit(binding, row);
      event.cell.classList.toggle('wj-cell-editable', editable);

      /**
       * (d) 소수 자릿수 2모드 — 조회 1자리 / 편집 10자리(R-07, V-33).
       * 공용 numberFormat 은 컬럼 단위라 행(measure)마다 다른 자릿수를 줄 수 없어 여기서 그린다.
       * 대상은 `PFRSLT_QTY`/`BASE_QTY` + 전 기간 컬럼이다.
       */
      if (
        binding === COLUMN.PFRSLT_QTY ||
        binding === COLUMN.BASE_QTY ||
        isEditablePeriodColumn(binding)
      ) {
        const raw = row[binding];
        if (raw !== null && raw !== undefined && raw !== '') {
          const numeric = Number(raw);
          if (Number.isFinite(numeric)) {
            const scale = editModeRef.current ? SCALE_EDIT : SCALE_VIEW;
            event.cell.textContent = numeric.toLocaleString(undefined, {
              minimumFractionDigits: scale,
              maximumFractionDigits: scale,
            });
          }
        }
      }
    };
    grid.formatItem.addHandler(formatItemHandler);

    /**
     * (a) 편집 게이트 — 공용 DataGrid 기본 핸들러(`INPUT_TP_CD`)가 먼저 판정하고 화면이 최종 재지정한다.
     * 주의: 메타가 `INPUT_TP_CD='S'` **226행 전건**이라 공용 판정만으로는 전 셀이 잠긴다(C-04).
     * 그 상태는 AS-IS 와 다르므로(기간셀·BASE_QTY 는 조건부 편집 가능) 여기서 조건부로 연다.
     * 필수검증이 이 메타 때문에 무발동인 것은 **파리티 유지**로 확정됐다(decisions §A BLK-3) —
     * 메타를 고치거나 코드로 검증을 강제 발동시키지 않는다.
     */
    const beginningEditHandler = (
      sender: FlexGridType,
      event: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0106Row | undefined;
      event.cancel = !canEdit(binding, row);
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    /**
     * (h) 붙여넣기 — AS-IS `ClipboardPasting`/`ClipboardChanged`/`ClipboardChanging`/
     * `SelectionChanged` 4핸들러가 `InitEvent` 에서 **전부 주석 처리**돼 미지원이다(R-17).
     * 사용자 확정(decisions §A BLK-12)으로 **미지원이 파리티** — 공용 wrapper 의 붙여넣기를 막는다.
     * CommonCheckList "편집 가능 컬럼 paste 허용" 항목은 이 화면에서 "미해당 — AS-IS 파리티".
     */
    const pastingCellHandler = (_sender: FlexGridType, event: { cancel: boolean }) => {
      event.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    /**
     * 셀 변경 가드 6종을 **AS-IS 순서 그대로**(03 R-18):
     *   `_si==null` -> `GetMaxRowIndex()==-1` -> `row/col==-1` -> 시트 잠금 -> `!IsEditMode`
     *   -> **`IsLockCell`(잠금 셀은 자동계산 대상이라 재계산 skip — 무한루프 방지)**
     * 순서를 바꾸면 잠금 셀에도 자동계산이 돈다.
     * 공용 EditTracker 가 먼저 변경을 기록하므로 이 핸들러는 그 뒤에 등록된다.
     */
    const cellEditEndedHandler = (sender: FlexGridType, event: { row: number; col: number }) => {
      if (sender.rows.length === 0) return;
      if (event.row === -1 || event.col === -1) return;
      if (!editModeRef.current) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0106Row | undefined;
      if (!canEdit(binding, row)) return;
      editEndedRef.current(event.row, binding);
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    /**
     * (g) `Delete` 키 = 선택 범위에 **`0.0` 일괄 기입**(행 삭제도 DBNull 도 아니다) + `Ctrl+Z` 차단
     * (R-16, V-54). 편집 가능한 셀만 대상이며 변경은 `EditTracker` 에 기록해 `CRUD_TYPE='M'` 을 얻는다.
     * CommonCheckList 의 "Delete 키 행 삭제" 항목은 이 화면에서 **해당 없음**이다.
     */
    const keyDownHandler = (event: KeyboardEvent) => {
      if (event.ctrlKey && (event.key === 'z' || event.key === 'Z')) {
        event.preventDefault();
        return;
      }
      if (event.key !== 'Delete') return;
      if (!editModeRef.current) return;
      const sender = grid;
      const selection = sender.selection;
      if (!selection) return;
      event.preventDefault();
      const tracker = editTrackerRef.current;
      for (let rowIndex = selection.topRow; rowIndex <= selection.bottomRow; rowIndex += 1) {
        const row = sender.rows[rowIndex]?.dataItem as Scp0106Row | undefined;
        if (!row) continue;
        for (let colIndex = selection.leftCol; colIndex <= selection.rightCol; colIndex += 1) {
          const binding = sender.columns[colIndex]?.binding ?? '';
          if (!binding || !canEdit(binding, row)) continue;
          const previousValue = row[binding];
          if (previousValue === 0) continue;
          row[binding] = 0;
          tracker?.storeChange(row as never, binding, previousValue as never, 0 as never);
          editEndedRef.current(rowIndex, binding);
        }
      }
      sender.invalidate();
    };
    grid.hostElement?.addEventListener('keydown', keyDownHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.cellEditEnded?.removeHandler(cellEditEndedHandler);
        grid.hostElement?.removeEventListener('keydown', keyDownHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [resolvedStaticColumns, periodColumns]);

  /**
   * (b) 병합 토글 — AS-IS 는 `!IsEditMode` 일 때만 `ToggleMerge(sheet,true)` + `SmartColMerge()` 를
   * 돌리고 편집 진입 시 해제한다. **조회 직후(`AfterFindData`)에도 병합이 걸린다** — "Edit 토글
   * 시에만" 처리하면 누락되므로 `isEditMode` 파생값으로 항상 계산한다(R-14, L-29, V-31/V-55, hook #69).
   * 기간(동적) 컬럼은 `buildPeriodColumns` 에서 `allowMerging:false` 라 수치가 묶이지 않는다.
   */
  const allowMerging = isEditMode
    ? AllowMerging.ColumnHeaders // 3단 헤더 머지는 유지하고 데이터 셀 병합만 해제
    : AllowMerging.All;

  /**
   * 좌측 고정(frozen) 경계 = **표시 중인 정적 컬럼 전부**.
   *
   * gap-resolve iter-1 에서 AS-IS 프레임워크 원본까지 대사해 **AS-IS 등가임을 확정**했다(V-09 종결).
   * AS-IS `SpreadInfo.SetSheetHeaderColumnSCP` 는 시트 컬럼 목록을 돌며
   * `FIXED_FLAG='Y'` 인 **마지막** 행의 순번을 `freezeColumnIndex` 로 잡고
   * `Freeze(FPFrozen.Col, freezeColumnIndex + 2)` 를 건다(+2 = 0번 Action 컬럼 보정).
   * AS-IS 메타 실측상 `FIXED_FLAG='Y'` 는 시트당 정확히 1행이고 그것이 정적 블록의 마지막
   * 컬럼이다 — CURRENT/CUTOFF_MODEL 은 `SITE_NAME`, LINE 계열은 `IDX`(= `_fixed_column_name`).
   * 즉 AS-IS 의 고정 경계는 "정적 블록 전체(= 기간 컬럼 직전까지)" 이며, 아래 식과 같은 결과다.
   *
   * 메타 `FIXED_FLAG` 에 직접 위임하지 않는 이유: TO-BE 메타는 이관 과정에서 `MEASURE` 행에도
   * `'Y'` 가 붙어 시트당 2건이다(AS-IS 는 1건). AS-IS 규칙이 "마지막 `'Y'`" 라 이 여분은 결과를
   * 바꾸지 않지만, 위임식으로 바꾸면 이관 오류에 동작이 끌려간다. 메타 정정은 별건이다.
   */
  const frozenColumns = useMemo(
    () => resolvedStaticColumns.filter(column => column.display).length,
    [resolvedStaticColumns]
  );

  // 편집모드가 바뀌면 배경색/자릿수/잠금 표시를 다시 그린다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEditMode, editableMeasures, scpPlanFixedColumns]);

  // 주의: DataGrid 를 래퍼 div 로 감싸지 않는다(hook #132). 공용 DataGrid 가 height:100% / flex:1 1 0 /
  //   min-height:0 을 이미 갖고 있어 래퍼는 중복이다.
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={resolvedStaticColumns}
      dynamicColumns={periodColumns}
      comboParams={comboParams}
      sheetName={sheetName}
      // 3단 헤더 총높이 48px — 컬럼 정의의 height 가 아니라 이 prop 이 단일 출처다(hook #93).
      headerRowHeight={HEADER_ROW_HEIGHT}
      allowMerging={allowMerging}
      frozenColumns={frozenColumns}
    />
  );
};
