import { toggleClass } from '@mescius/wijmo';
import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { useWorkingTimeStore } from '../useWorkingTimeStore';
import { CODE_DISPLAY_COLUMNS, GRID_COMBO_PARAMS } from '../working-time.constants';
import type { DynDayColumn, WorkingTimeRow } from '../working-time.types';

interface WorkingTimeGridProps {
  gridRef: MutableRefObject<FlexGrid<WorkingTimeRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  // 그리드 공용 EditTracker 노출 — 저장 시 변경 셀의 단일 진실원(메인 handleSave 가 payload 도출).
  editTrackerRef: MutableRefObject<EditTracker<WorkingTimeRow> | undefined>;
  data: WorkingTimeRow[];
  // 동적 D_ 기간 컬럼 — GET SP o_rc1_columns 의 D_yyyymmdd 에서 FE 파생(요일 그룹/일 leaf).
  //   04_impl-gap-audit #1: 이 SP 에 타이틀 커서가 없어 데이터 커서 컬럼 메타에서 만든다.
  dynColumns: DynDayColumn[];
}

// 정적 컬럼 편집성의 단일 원천 = admin 메타 SHEET_COLUMNS.INPUT_TP_CD (O/M=편집, S/미지정=읽기전용).
//   과거엔 WORKING_TIME_DEFAULT 를 코드 리터럴로 편집 지정했으나(EDITABLE_STATIC_BINDING), 이는
//   DMF0044/SCM0008 안티패턴 — 운영자가 admin 에서 정한 INPUT_TP_CD 가 화면에 무효화된다
//   (sales-reports.editLock.ts §staticEditableByMeta 주석 참조). AS-IS 파리티는 메타 값으로 보존한다:
//   SCP0019 WORKING_TIME_DEFAULT 는 deploy SQL(05_register_apply.sql)로 INPUT_TP_CD 'S'→'O' 정합.
const staticEditableByMeta = (inputTpCd: CELL_INPUT_EDIT_TYPE | undefined): boolean =>
  inputTpCd === CELL_INPUT_EDIT_TYPE.OPTIONAL || inputTpCd === CELL_INPUT_EDIT_TYPE.MANDATORY;

// FlexGridColumn 렌더링용 통합 column meta (CustomerFcstUploadGrid MergedColumnMeta 1:1).
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  inputTpCd?: CELL_INPUT_EDIT_TYPE;
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

// 편집 가능 행 판정 — 행 OSP_YN='Y'(대문자). 편집형 셀(메타 O/M or 동적 D_)과 AND. 01_layout §2-b #5.
const isRowEditable = (item: WorkingTimeRow | undefined): boolean =>
  String(item?.OSP_YN ?? '').toUpperCase() === 'Y';

export const WorkingTimeGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  dynColumns,
}: WorkingTimeGridProps) => {
  const staticColumn = useWorkingTimeStore(state => state.staticColumn);

  // 컬럼 메타 정본 = admin `/column` 응답(SCM_MST_SHEET_COLUMNS 14행) 단일 원천.
  //   admin UI Category Setup 변경이 코드 수정 없이 그대로 반영된다(CustomerFcstUploadGrid 1:1).
  const mergedColumns = useMemo<MergedColumnMeta[]>(
    () =>
      (staticColumn ?? []).map(col => {
        const comboKey = CODE_DISPLAY_COLUMNS.includes(col.colNm)
          ? undefined
          : col.cellCboDataTp?.trim();
        return {
          binding: col.colNm,
          header: col.colLblNm || col.colNm,
          width: col.colWth ?? 100,
          align: col.horzAlgnCd ?? 'L',
          visible: col.visible !== false,
          display: col.display === true,
          fixed: col.fixed === true, // admin FIXED_FLAG 위임 (MEASURE/OSP_YN 좌측고정 — AS-IS Freeze)
          inputTpCd: col.inputTpCd, // admin INPUT_TP_CD 위임 — 편집성 단일 원천
          cellCboDataTp: comboKey,
          cellCtrlObjTpCd: comboKey ? CELL_CONTROL_TYPE.COMBO : col.cellCtrlObjTpCd,
        } as MergedColumnMeta;
      }),
    [staticColumn]
  );

  const visibleColumns = useMemo(
    () => mergedColumns.filter(c => c.display && c.visible),
    [mergedColumns]
  );

  // 정적 14컬럼 — 편집성은 admin 메타(inputTpCd)를 그대로 위임. 메타 O/M 컬럼만 편집형,
  //   나머지(S/미지정)는 읽기전용. WORKING_TIME_DEFAULT 편집은 코드 리터럴이 아니라 메타 'O' 로 결정된다.
  //   편집 가부는 beginningEdit 행 단위 판정(OSP_YN='Y')과 AND — 컬럼이 편집형이어도 행이 잠기면 막힌다.
  const mainStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      visibleColumns.map(c => ({
        colNm: c.binding,
        colLblNm: c.header,
        colWth: c.width,
        horzAlgnCd: c.align,
        fixed: c.fixed,
        visible: true,
        display: true,
        inputTpCd: c.inputTpCd ?? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // 동적 D_ 기간 컬럼 — 2단 헤더(상단 = 요일 연속 run 그룹 스팬 / 하단 leaf = 일(DD)).
  //   dynColumns 는 부모가 o_rc1_columns 에서 파생한 {binding,yyyymmdd,dayLabel,weekday}. 이 SP 에
  //   타이틀 커서가 없어 요일/일은 캘린더에서 FE 파생한다(04_impl-gap-audit #1). SAT=blue/SUN=red 는
  //   formatItem 헤더 색으로 처리(03_grid-columns §5) — 그룹 라벨(요일 3글자)을 그대로 읽어 색을 준다.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColumns.length === 0) return [];
    type Group = { label: string; leafs: FlexGridColumnConfig[] };
    const groups: Group[] = [];
    dynColumns.forEach(dc => {
      const label = dc.weekday || ' ';
      const last = groups[groups.length - 1];
      const leaf: FlexGridColumnConfig = {
        binding: dc.binding,
        header: dc.dayLabel || dc.binding.slice(2),
        align: 'right',
        format: 'n0', // 근무시간(분/요일단위) 정수 표기
        width: 100,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // 편집 가부는 beginningEdit 행 단위 판정(OSP_YN='Y') — 컬럼은 편집형 선언.
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _ctrlType: CELL_CONTROL_TYPE.NUMBER,
        _display: true,
      };
      // 요일 연속 run 을 하나의 상단 스팬으로 묶는다(같은 요일이 인접하면 병합).
      if (last && last.label === label) last.leafs.push(leaf);
      else groups.push({ label, leafs: [leaf] });
    });
    return groups.map(g => ({
      header: g.label,
      align: 'center',
      columns: g.leafs,
    }));
  }, [dynColumns]);

  const dynBindings = useMemo(
    () => new Set(dynColumns.map(dc => dc.binding)),
    [dynColumns]
  );

  // 메타 O/M 로 편집 지정된 정적 컬럼 binding 집합 — admin INPUT_TP_CD 단일 원천.
  const editableStaticBindings = useMemo(
    () =>
      new Set(
        mergedColumns.filter(c => staticEditableByMeta(c.inputTpCd)).map(c => c.binding)
      ),
    [mergedColumns]
  );

  // 편집 가능 셀 binding 판정 — 동적 D_ 셀 또는 메타 편집형(O/M) 정적 컬럼.
  const isEditableBinding = (binding: string): boolean =>
    dynBindings.has(binding) || editableStaticBindings.has(binding);

  // grid 핸들러 등록 — 편집 가드 + 셀 색(편집가능 노랑/잠금 회색)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGrid<WorkingTimeRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // SAT=blue / SUN=red — 동적 그룹 라벨(요일)에 색상. 03_grid-columns §5.
        const text = (e.cell.textContent ?? '').trim();
        if (text === 'SAT') e.cell.style.color = '#1e56c8';
        else if (text === 'SUN') e.cell.style.color = '#c0392b';
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!binding) return;

      // 편집 가능 셀만 강조(편집형 binding × OSP_YN='Y' 행). UnLockOnlyOSP 재현 —
      //   OSP_YN!=='Y' 행의 편집형 셀은 잠금 회색으로 표기(01_layout §2-b).
      if (isEditableBinding(binding)) {
        const item = (e.panel.rows[e.row] as { dataItem?: WorkingTimeRow }).dataItem;
        const editable = isRowEditable(item);
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !editable);
        return;
      }
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 가드 — 편집형 셀(D_ 또는 WORKING_TIME_DEFAULT) × OSP_YN='Y' 행만 허용.
    const beginningEditHandler = (
      _s: FlexGrid<WorkingTimeRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      if (!isEditableBinding(binding)) {
        e.cancel = true;
        return;
      }
      const item = (_s.rows[e.row] as { dataItem?: WorkingTimeRow }).dataItem;
      if (!isRowEditable(item)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, editableStaticBindings]);

  // 다단 헤더 총높이 48px 불변식 (CustomerFcstUploadGrid #93 1:1 — rAF 상시 감시, 인스턴스 교체 시
  //   핸들러 이관 + 존재 행 높이 = 48/실제 행수 강제).
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<WorkingTimeRow> | null = null;
    const normalize = (g: FlexGrid<WorkingTimeRow>) => {
      const hdr = g.columnHeaders?.rows;
      if (!hdr || hdr.length === 0) return;
      const per = Math.max(1, Math.round(48 / hdr.length));
      let changed = false;
      if (Math.round(hdr.defaultSize) !== per) {
        hdr.defaultSize = per;
        changed = true;
      }
      for (let i = 0; i < hdr.length; i++) {
        if (Math.round(hdr[i].height ?? 0) !== per) {
          hdr[i].height = per;
          changed = true;
        }
      }
      if (changed) g.invalidate(false);
    };
    const onLayout = () => {
      if (attached) normalize(attached);
    };
    const tick = () => {
      const g = gridRef.current ?? null;
      if (g && g !== attached) {
        try {
          attached?.updatedLayout?.removeHandler(onLayout);
        } catch {
          /* dead instance */
        }
        g.updatedLayout.addHandler(onLayout);
        attached = g;
      }
      if (g) normalize(g);
      raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout?.removeHandler(onLayout);
      } catch {
        /* dead instance */
      }
    };
  }, [gridRef]);

  // F4 Filter — 피처 소유 FlexGridFilter (CustomerFcstUploadGrid 1:1).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const onFilterApplied = () => g.invalidate(true);

    let f = gridFilterRef.current;
    if (!f || f.grid !== g) {
      f = new FlexGridFilter(g);
      f.filterColumns = [''];
      gridFilterRef.current = f;
    }
    f.filterApplied.addHandler(onFilterApplied);

    return () => {
      try {
        f?.filterApplied.removeHandler(onFilterApplied);
      } catch {
        /* unmount race */
      }
    };
  }, [visibleColumns, dynBindings, gridRef, gridFilterRef]);

  return (
    <DataGrid<WorkingTimeRow>
      key={mainStaticColumns.map(c => c.colNm).join(',')}
      gridRef={gridRef}
      editTrackerRef={editTrackerRef}
      staticColumns={mainStaticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={GRID_COMBO_PARAMS}
      itemsSource={data}
      autoGenerateColumns={false}
    />
  );
};
