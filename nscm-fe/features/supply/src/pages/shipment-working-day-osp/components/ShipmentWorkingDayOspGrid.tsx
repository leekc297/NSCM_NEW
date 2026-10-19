import { toggleClass } from '@mescius/wijmo';
import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  CODE_DISPLAY_COLUMNS,
  DAY_CELL_DATA_MAP,
  GRID_COMBO_PARAMS,
} from '../shipment-working-day-osp.constants';
import { buildDynSumColumns } from '../shipment-working-day-osp.dynamic-columns';
import type {
  DynColumnMeta,
  DynDayColumn,
  ShipmentWorkingDayOspRow,
} from '../shipment-working-day-osp.types';
import { useShipmentWorkingDayOspStore } from '../useShipmentWorkingDayOspStore';

interface ShipmentWorkingDayOspGridProps {
  gridRef: MutableRefObject<FlexGrid<ShipmentWorkingDayOspRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  // 그리드 공용 EditTracker 노출 — 저장 시 변경 셀의 단일 진실원(부모 handleSave 가 payload 도출).
  editTrackerRef: MutableRefObject<EditTracker<ShipmentWorkingDayOspRow> | undefined>;
  data: ShipmentWorkingDayOspRow[];
  // 동적 D_ 기간 컬럼 — GET SP o_rc1_columns 의 D_yyyymmdd 에서 FE 파생(3단 머지헤더 group/일 leaf).
  dynColumns: DynDayColumn[];
  // GET SP o_rc1_columns 원본(W_/M_ SUM 열 도출용) — chkSum 토글 대상.
  dynColumnMeta: DynColumnMeta[];
  // 편집모드(EditButton SwitchLock) — off 면 전열 잠금, on 이면 WORKING_TIME_DEFAULT+D_ 만 개방(03 §3-a).
  //   SCP0019(OSP_YN 행 게이트)와 다른 델타: SCP0096 은 명시 편집모드 상태다.
  editMode: boolean;
  // chkSum — W_/M_ SUM 컬럼 show/hide 토글(03 §3-c). off 면 SUM 열 숨김.
  showSum: boolean;
}

// 편집 대상 정적 컬럼 — WORKING_TIME_DEFAULT(FPNumber scale2). 편집성 근거는 SHEET_COLUMNS.INPUT_TP_CD
//   (='S' 읽기전용)가 아니라 AS-IS 코드다(03 §3-a EditButton SwitchLock 후 개방). 즉 메타에 근거 없는
//   코드-편집 규약의 재현이며, admin 관리 속성을 리터럴로 덮어쓰는 것이 아니다. INPUT_TP_CD 메타 정합은
//   deploy SQL 정비 대상(runtime-parity [A] — sheet-columns-editable-metadata-all-s-highrisk).
const EDITABLE_STATIC_BINDING = 'WORKING_TIME_DEFAULT';

// FlexGridColumn 렌더링용 통합 column meta (WorkingTimeGrid MergedColumnMeta 1:1).
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

export const ShipmentWorkingDayOspGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  dynColumns,
  dynColumnMeta,
  editMode,
  showSum,
}: ShipmentWorkingDayOspGridProps) => {
  const staticColumn = useShipmentWorkingDayOspStore(state => state.staticColumn);

  // editMode 를 이벤트 핸들러(beginningEdit)에서 최신값으로 읽기 위한 ref — 핸들러는 등록 시점 클로저라
  //   prop 을 직접 참조하면 stale 된다. 렌더마다 ref 동기화(retrackDyn 계열 stale-closure 사고 예방).
  const editModeRef = useRef(editMode);
  editModeRef.current = editMode;

  // 컬럼 메타 정본 = admin `/column` 응답(SCM_MST_SHEET_COLUMNS 6행) 단일 원천.
  //   admin UI Category Setup 변경이 코드 수정 없이 반영된다(WorkingTimeGrid 1:1).
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
          fixed: col.fixed === true, // admin FIXED_FLAG 위임 (MEASURE 좌측고정 등 — 리터럴 덮어쓰기 금지)
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

  // 정적 6컬럼 — WORKING_TIME_DEFAULT 만 편집형(OPTIONAL), 나머지 식별/메타는 읽기전용('S').
  //   편집 가부는 beginningEdit editMode 판정과 AND — 컬럼 선언이 편집형이어도 편집모드 off 면 막힌다.
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
        inputTpCd:
          c.binding === EDITABLE_STATIC_BINDING
            ? CELL_INPUT_EDIT_TYPE.OPTIONAL
            : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // W_/M_ SUM 열 — chkSum 토글로 visible 제어(03 §3-c). SUM 잠금이라 편집형 선언 안 함(SEARCH_ONLY).
  const sumColumns = useMemo(() => buildDynSumColumns(dynColumnMeta), [dynColumnMeta]);

  // 동적 컬럼 — 3단 머지헤더(대 월 / 소 주차 / 일). D_ 은 Y/N 셀콤보(dataMap 고정), W_/M_ 은 SUM 잠금.
  //   dynColumns 는 부모가 o_rc1_columns 에서 파생한 {binding,yyyymmdd,dayLabel,weekday,monthKey,weekKey}.
  //   요일/주차/월 그룹은 SP 커서에 없어 캘린더에서 FE 파생(03 §1-b). SAT=blue/SUN=red 는 formatItem 처리.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColumns.length === 0) return [];

    // D_ 일 leaf 를 월→주차 2단으로 group. 같은 monthKey/weekKey 연속 run 을 하나의 스팬으로 묶는다.
    type WeekGroup = { key: string; label: string; leafs: FlexGridColumnConfig[] };
    type MonthGroup = { key: string; label: string; weeks: WeekGroup[] };
    const months: MonthGroup[] = [];

    dynColumns.forEach(dc => {
      const leaf: FlexGridColumnConfig = {
        binding: dc.binding,
        header: dc.dayLabel || dc.binding.slice(2),
        align: 'center',
        width: 56,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        // 편집 가부는 beginningEdit editMode 판정 — 컬럼은 편집형 셀콤보 선언.
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _ctrlType: CELL_CONTROL_TYPE.COMBO,
        // dtValidYN 고정 2값(Y/N) — 동적 alias 라 서버콤보 없이 리터럴 dataMap(CustomerFcstMasterDateColumns 선례).
        dataMap: [...DAY_CELL_DATA_MAP],
        _display: true,
      };
      let month = months[months.length - 1];
      if (!month || month.key !== dc.monthKey) {
        month = { key: dc.monthKey, label: `${dc.monthKey.slice(0, 4)}-${dc.monthKey.slice(4, 6)}`, weeks: [] };
        months.push(month);
      }
      let week = month.weeks[month.weeks.length - 1];
      if (!week || week.key !== dc.weekKey) {
        week = { key: dc.weekKey, label: dc.weekKey.split('-W')[1] ?? '', leafs: [] };
        month.weeks.push(week);
      }
      week.leafs.push(leaf);
    });

    const dayGroups: FlexGridColumnConfig[] = months.map(m => ({
      header: m.label,
      align: 'center',
      columns: m.weeks.map(w => ({
        header: w.label ? `W${w.label}` : ' ',
        align: 'center',
        columns: w.leafs,
      })),
    }));

    // W_/M_ SUM 열 — 잠금(SEARCH_ONLY). chkSum off 면 숨김. 3단 헤더와 나란히 우측에 붙인다.
    const sumGroups: FlexGridColumnConfig[] = sumColumns.map(s => ({
      binding: s.binding,
      header: s.header,
      align: 'right',
      format: 'n0',
      width: 80,
      allowDragging: false,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: showSum,
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _ctrlType: CELL_CONTROL_TYPE.NUMBER,
      _display: true,
    }));

    return [...dayGroups, ...sumGroups];
  }, [dynColumns, sumColumns, showSum]);

  const dynBindings = useMemo(() => new Set(dynColumns.map(dc => dc.binding)), [dynColumns]);

  // 편집 가능 셀 binding 판정 — 동적 D_ 셀 또는 WORKING_TIME_DEFAULT. (W_/M_ SUM 은 잠금 — 제외.)
  const isEditableBinding = (binding: string): boolean =>
    dynBindings.has(binding) || binding === EDITABLE_STATIC_BINDING;

  // 요일색 판정 — D_ leaf 헤더(일)의 요일. dynColumns 에서 binding→weekday 조회(0=일 ~ 6=토, 03 §3-c).
  const weekdayByBinding = useMemo(() => {
    const m = new Map<string, number>();
    dynColumns.forEach(dc => m.set(dc.binding, dc.weekday));
    return m;
  }, [dynColumns]);

  // grid 핸들러 등록 — 편집 가드(editMode) + 셀 색(편집가능/잠금) + 요일색.
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders || !g.columnHeaders.rows) return;

    if (g.alternatingRowStep !== 1) g.alternatingRowStep = 1;

    const formatHandler = (_s: FlexGrid<ShipmentWorkingDayOspRow>, e: FormatItemEventArgs) => {
      const col = e.panel.columns[e.col];
      if (!col) return;
      const binding = col.binding ?? '';

      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
        // 일 leaf 헤더 요일색 — 토=Blue/일=Red(DAY_CODE, 03 §3-c). binding 으로 요일 조회(라벨 파싱 불필요).
        const wd = weekdayByBinding.get(binding);
        if (wd === 6) e.cell.style.color = '#1e56c8'; // SAT
        else if (wd === 0) e.cell.style.color = '#c0392b'; // SUN
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      if (!binding) return;

      // 편집 가능 셀만 강조(편집형 binding × editMode). 편집모드 off 면 전셀 잠금표기.
      if (isEditableBinding(binding)) {
        const editable = editModeRef.current;
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !editable);
        return;
      }
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // 편집 가드 — 편집형 셀(D_ 또는 WORKING_TIME_DEFAULT) × 편집모드 on 만 허용.
    const beginningEditHandler = (
      _s: FlexGrid<ShipmentWorkingDayOspRow>,
      e: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = _s.columns[e.col]?.binding ?? '';
      if (!editModeRef.current || !isEditableBinding(binding)) e.cancel = true;
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
  }, [visibleColumns, dynBindings, weekdayByBinding]);

  // editMode 토글 시 셀 잠금표기 갱신 — 핸들러는 ref 로 최신값을 읽으나 재도색 트리거가 필요하다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
  }, [editMode, gridRef]);

  // 다단 헤더 총높이 불변식(3단 = 60px) — WorkingTimeGrid #93 rAF 상시 감시 1:1(인스턴스 교체 시 이관).
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<ShipmentWorkingDayOspRow> | null = null;
    const TOTAL = 60;
    const normalize = (g: FlexGrid<ShipmentWorkingDayOspRow>) => {
      const hdr = g.columnHeaders?.rows;
      if (!hdr || hdr.length === 0) return;
      const per = Math.max(1, Math.round(TOTAL / hdr.length));
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

  // F4 Filter — 피처 소유 FlexGridFilter (WorkingTimeGrid 1:1).
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
    <DataGrid<ShipmentWorkingDayOspRow>
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
