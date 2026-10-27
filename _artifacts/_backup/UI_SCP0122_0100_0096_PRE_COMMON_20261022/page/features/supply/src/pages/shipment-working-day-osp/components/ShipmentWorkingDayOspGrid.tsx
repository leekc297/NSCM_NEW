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
  DAY_CODE,
  DAY_COLUMN_WIDTH,
  GRID_COMBO_PARAMS,
  HEADER_TOTAL_HEIGHT,
  WEEKEND_HEADER_COLOR,
} from '../shipment-working-day-osp.constants';
import { buildDynSumColumns } from '../shipment-working-day-osp.dynamic-columns';
import type {
  CalendarColumnRow,
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
  // 동적 D_ 기간 컬럼 — 3SPAN(SHEETS.CALENDAR) o_rc1 의 D_ 행에서 파생(3단 머지헤더 group/일 leaf, 서버 라벨 그대로).
  dynColumns: DynDayColumn[];
  // 3SPAN o_rc1 원본 행(W_/M_ SUM 열 도출용) — chkSum 토글 대상(AS-IS SetSpreadColumn .cs:353).
  calendarRows: CalendarColumnRow[];
  // 편집모드(EditButton SwitchLock) — off 면 전열 잠금, on 이면 WORKING_TIME_DEFAULT+D_ 만 개방(03 §3-a).
  //   SCP0019(OSP_YN 행 게이트)와 다른 델타: SCP0096 은 명시 편집모드 상태다.
  editMode: boolean;
  // chkSum — W_/M_ SUM 컬럼 show/hide(03 §3-c). AS-IS chkSum 은 Designer Visible=false(:346)·Checked=false(.cs:121)라 3SPAN 이 만든
  //   W_/M_ 열은 항상 숨김 → 부모가 항상 false 전달(AS-IS SetSpreadColumn .cs:339-358 대응). GET SP 데이터에는 W_/M_ 값이 없다.
  showSum: boolean;
}

// 정적 컬럼 편집 가부 = admin SHEET_COLUMNS.INPUT_TP_CD 단일 원천(feedback_input_tp_cd_meta_over_hardcoded_editlock).
//   사내 실측(ZIOUI1 2026-10-20, Doc/tobefacts/db/sheet_columns.csv): WORKING_TIME_DEFAULT 'O'(ZIONEX 2026-09-25) · 나머지 5컬럼 'S'
//   = AS-IS EditButton 이 코드로 개방하던 범위(.cs:288-289 LockColumn 제외분)와 일치. 이전 리터럴 EDITABLE_STATIC_BINDING 하드코딩은
//   admin 변경을 무효화하므로 제거(2026-10-20, 원장 S96-14). 메타가 비면 읽기전용('S'). 클라우드 기존행 'S' 잔존은 registration.sql BLOCK 3-b 가 맞춘다.
const EDITABLE_INPUT_TYPES: ReadonlySet<CELL_INPUT_EDIT_TYPE> = new Set([
  CELL_INPUT_EDIT_TYPE.OPTIONAL,
  CELL_INPUT_EDIT_TYPE.MANDATORY,
  CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY,
  CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY,
]);

// FlexGridColumn 렌더링용 통합 column meta (WorkingTimeGrid MergedColumnMeta 1:1).
interface MergedColumnMeta {
  binding: string;
  header: string;
  width: number;
  align: 'L' | 'R' | 'C';
  visible: boolean;
  display: boolean;
  fixed: boolean;
  // admin INPUT_TP_CD 그대로(S/O/M/IO/IM). 미등재는 'S'.
  inputTpCd: CELL_INPUT_EDIT_TYPE;
  cellCtrlObjTpCd?: CELL_CONTROL_TYPE;
  cellCboDataTp?: string;
}

export const ShipmentWorkingDayOspGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  dynColumns,
  calendarRows,
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
          inputTpCd: col.inputTpCd ?? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // admin INPUT_TP_CD 위임
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

  // 정적 6컬럼 — 편집형 여부는 admin INPUT_TP_CD 그대로(사내 현행: WORKING_TIME_DEFAULT 'O', 나머지 'S').
  //   편집 가부는 beginningEdit editMode 판정과 AND — 컬럼 선언이 편집형이어도 EDIT 권한이 없으면 막힌다.
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
        inputTpCd: c.inputTpCd,
        cellCtrlObjTpCd: c.cellCtrlObjTpCd,
        cellCboDataTp: c.cellCboDataTp,
      })),
    [visibleColumns]
  );

  // 편집 가능 정적 binding 집합 — INPUT_TP_CD ∈ {O, M, IO, IM}. admin 변경 시 즉시 반영.
  const editableStaticBindings = useMemo(
    () => new Set(visibleColumns.filter(c => EDITABLE_INPUT_TYPES.has(c.inputTpCd)).map(c => c.binding)),
    [visibleColumns]
  );

  // W_/M_ SUM 열 — chkSum 토글로 visible 제어(03 §3-c). SUM 잠금이라 편집형 선언 안 함(SEARCH_ONLY).
  const sumColumns = useMemo(() => buildDynSumColumns(calendarRows), [calendarRows]);

  // 동적 컬럼 — 3단 머지헤더(대 월 / 소 주차 / 일). D_ 은 Y/N 셀콤보(dataMap 고정), W_/M_ 은 SUM 잠금.
  //   dynColumns 는 부모가 3SPAN o_rc1 에서 파생한 {binding,yyyymmdd,dayLabel,weekLabel,monthLabel,dayCode} — 라벨은 서버 달력 값 그대로
  //   (AS-IS InitSpreadDateColumn .cs:183-244 ColumnHeaderSpan 0단=LARGE / 1단=SMALL / 2단=COLUMN_LABEL). SAT=blue/SUN=red 는 formatItem 처리.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColumns.length === 0) return [];

    // D_ 일 leaf 를 월→주차 2단으로 group. AS-IS 는 라벨이 바뀌는 순간 span 을 마감(:213,228)하므로 연속 run 기준으로 묶고,
    //   월이 바뀌면 주차 span 도 함께 마감한다(:221) — 월 그룹 안에서만 주차를 매칭하므로 구조적으로 보장된다.
    type WeekGroup = { label: string; leafs: FlexGridColumnConfig[] };
    type MonthGroup = { label: string; weeks: WeekGroup[] };
    const months: MonthGroup[] = [];

    dynColumns.forEach(dc => {
      const leaf: FlexGridColumnConfig = {
        binding: dc.binding,
        header: dc.dayLabel || dc.binding.slice(2),
        align: 'center',
        width: DAY_COLUMN_WIDTH, // AS-IS AddComboColumn(…, 50, …) .cs:203
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
      if (!month || month.label !== dc.monthLabel) {
        month = { label: dc.monthLabel, weeks: [] };
        months.push(month);
      }
      let week = month.weeks[month.weeks.length - 1];
      if (!week || week.label !== dc.weekLabel) {
        week = { label: dc.weekLabel, leafs: [] };
        month.weeks.push(week);
      }
      week.leafs.push(leaf);
    });

    const dayGroups: FlexGridColumnConfig[] = months.map(m => ({
      header: m.label || ' ',
      align: 'center',
      columns: m.weeks.map(w => ({
        // 라벨이 비어도 헤더 행 자체는 살려 3단 구조를 유지한다(빈 문자열이면 span 이 접힌다 — 자매 SCP0095 동일).
        header: w.label || ' ',
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

  // 편집 가능 셀 binding 판정 — 동적 D_ 셀 또는 INPUT_TP_CD 편집형 정적 컬럼(사내 현행 = WORKING_TIME_DEFAULT). (W_/M_ SUM 은 잠금 — 제외.)
  const isEditableBinding = (binding: string): boolean =>
    dynBindings.has(binding) || editableStaticBindings.has(binding);

  // 요일색 판정 — D_ leaf 헤더(일)의 3SPAN DAY_CODE(AS-IS sDayCode .cs:192,206). binding→dayCode 조회(라벨 파싱·dayjs 재계산 금지).
  const dayCodeByBinding = useMemo(() => new Map(dynColumns.map(dc => [dc.binding, dc.dayCode])), [dynColumns]);

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
        // 일 leaf 헤더 요일색 — AS-IS ColumnHeader.Cells[2, col].ForeColor = SAT ? Blue : Red(.cs:206-208). 헤더 3단 중 leaf 행만.
        const dayCode = dayCodeByBinding.get(binding);
        e.cell.style.color = ''; // wijmo 셀 DOM 재사용 — 이전 프레임의 주말색 잔존 방지
        if (e.row === e.panel.rows.length - 1) {
          if (dayCode === DAY_CODE.SAT) e.cell.style.color = WEEKEND_HEADER_COLOR.SAT;
          else if (dayCode === DAY_CODE.SUN) e.cell.style.color = WEEKEND_HEADER_COLOR.SUN;
        }
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
  }, [visibleColumns, dynBindings, editableStaticBindings, dayCodeByBinding]);

  // editMode 토글 시 셀 잠금표기 갱신 — 핸들러는 ref 로 최신값을 읽으나 재도색 트리거가 필요하다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
  }, [editMode, gridRef]);

  // 다단 헤더 총높이 불변식(48px — hook #93 · 10_RULES_KEEP D3) — WorkingTimeGrid #93 rAF 상시 감시 1:1(인스턴스 교체 시 이관).
  //   (2026-10-20 정정: 이전 TOTAL=60 은 AS-IS ColumnHeaderSpan 20×3 을 옮긴 것으로 D3 위반 — 자매 SCP0095 HEADER_TOTAL_HEIGHT 48 과 통일.)
  useEffect(() => {
    let raf = 0;
    let attached: FlexGrid<ShipmentWorkingDayOspRow> | null = null;
    const normalize = (g: FlexGrid<ShipmentWorkingDayOspRow>) => {
      const hdr = g.columnHeaders?.rows;
      if (!hdr || hdr.length === 0) return;
      const per = Math.max(1, Math.round(HEADER_TOTAL_HEIGHT / hdr.length));
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
