import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellEditEndingEventArgs,
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
import { CODE_DISPLAY_COLUMNS, GRID_COMBO_PARAMS, WORKING_TIME_RANGE } from '../working-time.constants';
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
  // admin DATA_SCALE_NUMBER — FPNumber 셀 편집기(InputNumber format n{scale}) 생성·소수 자릿수 제한의 원천.
  //   누락 시 InputNumber 가 안 붙어 문자/소수자리 입력이 안 막힌다(2026-10-16 WORKING_TIME_DEFAULT 사고).
  scale?: number;
}

// 숫자 셀 입력 키 차단 규칙(NumberInputRule). binding 키 조회라 wijmo Column 프로퍼티가 아니다(안전).
type NumberRuleMap = Record<
  string,
  { positiveOnly?: boolean; integerOnly?: boolean; decimalPlaces?: number }
>;

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
          scale: col.scale, // admin DATA_SCALE_NUMBER 위임 — FPNumber 편집기 소수 자릿수 원천
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
        scale: c.scale, // FPNumber InputNumber 편집기(n{scale}) 생성용 — 누락 시 문자/소수 입력 미차단
      })),
    [visibleColumns]
  );

  // 동적 D_ 기간 컬럼 — AS-IS 3단 헤더(1단 = 연-월 span / 2단 = 주차 span / 3단 leaf = 일(DD)).
  //   dynColumns 는 부모가 파생한 {binding,yyyymmdd,dayLabel,weekday,monthLabel,weekLabel}. 이 SP 에
  //   타이틀 커서가 없어 월/주/일 전부 캘린더에서 FE 파생한다(03_grid-columns §2-c). 토=blue/일=red 는
  //   일자 leaf 헤더 색으로 처리(formatItem, weekdayByBinding) — 상단 월/주 그룹엔 색 없음.
  //   주차가 월 경계를 넘으면 월이 먼저 끊기므로 같은 W 라벨이 두 월 아래로 분리된다(AS-IS span 동일).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColumns.length === 0) return [];
    type WeekGroup = { label: string; leafs: FlexGridColumnConfig[] };
    type MonthGroup = { label: string; weeks: WeekGroup[] };
    const months: MonthGroup[] = [];
    dynColumns.forEach(dc => {
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
        // 입력 키 차단(0~1440 정수, 음수·소수 거부)은 numberRules prop 으로 binding 별로 준다(아래 numberRules).
        //   주의: positiveOnly/integerOnly 를 이 config 에 직접 넣으면 wijmo Column 이니셜라이저가
        //   "Unknown property" 로 어설션 크래시한다(2026-10-16 실측) — 반드시 numberRules 경로로 준다.
        // 편집 가부는 beginningEdit 행 단위 판정(OSP_YN='Y') — 컬럼은 편집형 선언.
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _ctrlType: CELL_CONTROL_TYPE.NUMBER,
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
    return months.map(m => ({
      header: m.label,
      align: 'center',
      columns: m.weeks.map(w => ({
        header: w.label,
        align: 'center',
        columns: w.leafs,
      })),
    }));
  }, [dynColumns]);

  // 일자 leaf 헤더 색(SAT=blue/SUN=red) 판정용 — binding→요일 맵. 상단 월/주 그룹은 binding 이 없어 미채색.
  const weekdayByBinding = useMemo(
    () => new Map(dynColumns.map(dc => [dc.binding, dc.weekday])),
    [dynColumns]
  );

  // 동적 D_ 일자 셀 입력 키 차단(AS-IS SetReNumerCellType(min=0, dec=0): 0~1440 정수) — 음수·소수점 거부.
  //   DataGrid numberRules prop 으로 binding 별 전달(wijmo Column 프로퍼티가 아니라 안전 — config 에 직접
  //   넣으면 "Unknown property" 크래시). 동적 셀은 InputNumber 에디터가 없어 beforeinput 규칙이 그대로 먹는다.
  //   문자는 dataType:Number(normalizeDynamicColumns)가 커밋 시 거부. WORKING_TIME_DEFAULT 는 InputNumber
  //   에디터(min/max/n2)가 직접 막으므로 여기 넣지 않는다(InputNumber 가 beforeinput 규칙을 가린다 — 실측).
  const numberRules = useMemo<NumberRuleMap>(() => {
    const rules: NumberRuleMap = {};
    for (const dc of dynColumns) rules[dc.binding] = { positiveOnly: true, integerOnly: true };
    return rules;
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
        // SAT=blue / SUN=red — 일자 leaf 헤더(3단)에만 색상(03_grid-columns §2-c). 상단 월/주 그룹은
        //   binding 이 없어 미채색. 재활용 셀 잔색 방지 위해 평일은 명시적으로 초기화.
        const wd = weekdayByBinding.get(binding);
        if (wd === 'SAT') e.cell.style.color = '#1e56c8';
        else if (wd === 'SUN') e.cell.style.color = '#c0392b';
        else e.cell.style.color = '';
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

    // WORKING_TIME_DEFAULT 범위 검증(0~7) — AS-IS SetReNumerCellType(min=0, dec=2, max=7, cs:283). InputNumber 의
    //   min/max 는 그리드 셀 편집기에서 값을 실제로 강제하지 못하므로(2026-10-16 실측: '22,222.00' 커밋됨) 커밋 직전
    //   cellEditEnding 에서 범위를 검증해 0~7 밖이면 편집 종료를 취소한다(잘못된 값이 셀에 남지 않는다).
    //   주의: 동적 D_ 일자셀은 AS-IS 셀 타입에 max 가 없어(cs:330) 편집 시점 상한을 두지 않는다 — D_ 의 0~1440
    //   은 AS-IS 와 동일하게 저장 시점(Page handleSave)에서만 검증한다(AS-IS MSG00203 = TO-BE MSG01037). 여기서 D_ 를 막으면 과차단.
    const rangeGuardHandler = (_s: FlexGrid<WorkingTimeRow>, e: CellEditEndingEventArgs) => {
      if (e.cancel || _s.columns[e.col]?.binding !== 'WORKING_TIME_DEFAULT') return;
      const raw = String(_s.activeEditor?.value ?? '').replace(/,/g, '').trim();
      if (raw === '') return;
      const v = Number(raw);
      if (Number.isNaN(v) || v < WORKING_TIME_RANGE.DEFAULT_MIN || v > WORKING_TIME_RANGE.DEFAULT_MAX)
        e.cancel = true;
    };
    g.cellEditEnding.addHandler(rangeGuardHandler);

    // WORKING_TIME_DEFAULT 입력 시점 상한 차단 — 위 rangeGuardHandler 는 7 초과 값의 '저장'만 막는다(편집기엔
    //   7.5 가 그대로 타이핑되고 커밋 때 조용히 되돌아감). AS-IS(FarPoint SetReNumerCellType max=7) 재현(2026-10-19
    //   사용자 지시): '7.' 까지만 입력되고 그 뒤 소수부에는 0 을 포함해 어떤 숫자도 못 들어간다(7.0 조차 불가).
    //   beforeinput 을 capture 로 걸어 InputNumber(n2) 자체 핸들러보다 먼저 가로채고(InputNumber 가 bubble 단계
    //   beforeinput 을 가린다 — 2026-10-16 사고), (1) 삽입 결과값이 DEFAULT_MAX(7)를 넘거나 (2) 정수부가 7인데
    //   소수부 숫자가 생기면 그 키입력을 취소한다. 삭제(ev.data==null)·'7.'·'6.99' 등은 통과. 커밋 가드는
    //   붙여넣기·엣지케이스 백스톱으로 유지한다.
    const guardDefaultMaxOnInput = (ev: InputEvent) => {
      if (ev.data == null) return; // 삭제·조합취소 등 값 추가가 아닌 입력은 허용
      const el = ev.target as HTMLInputElement;
      const start = el.selectionStart ?? el.value.length;
      const end = el.selectionEnd ?? el.value.length;
      const next = (el.value.slice(0, start) + ev.data + el.value.slice(end)).replace(/,/g, '').trim();
      if (next === '' || next === '.' || next === '-') return; // 7 이하로 수렴 가능한 미완성 입력
      const v = Number(next);
      if (!Number.isNaN(v) && v > WORKING_TIME_RANGE.DEFAULT_MAX) {
        ev.preventDefault();
        return;
      }
      // 정수부가 상한(7)이면 '7.' 까지만 허용 — 소수부 숫자는 0 이라도 차단(AS-IS 와 동일). 7 미만 소수는 자유.
      const dot = next.indexOf('.');
      if (dot >= 0) {
        const intPart = Number(next.slice(0, dot) || '0');
        const hasFractionDigit = /\d/.test(next.slice(dot + 1));
        if (intPart === WORKING_TIME_RANGE.DEFAULT_MAX && hasFractionDigit) ev.preventDefault();
      }
    };
    const prepareEditHandler = (_s: FlexGrid<WorkingTimeRow>, e: CellRangeEventArgs) => {
      const col = _s.columns[e.col];
      if (col?.binding !== 'WORKING_TIME_DEFAULT') return;
      // 필수: InputNumber(커스텀 에디터) 셀은 grid.activeEditor 가 null 이라 거기에 beforeinput 을 달면 조용히
      //   건너뛴다(2026-10-16 'InputNumber 가 beforeinput 을 가린다'의 실제 원인 — dom_listeners 실측). 컬럼이
      //   들고 있는 InputNumber 편집기의 inputElement 에 직접 단다. 컬럼당 편집기 1개가 재사용되므로 같은 함수
      //   참조 재등록을 브라우저가 중복 제거해 리스너가 쌓이지 않는다.
      const el =
        (col.editor as { inputElement?: HTMLInputElement } | null)?.inputElement ?? _s.activeEditor;
      if (!el) return;
      el.addEventListener('beforeinput', guardDefaultMaxOnInput as EventListener, true);
    };
    g.prepareCellForEdit.addHandler(prepareEditHandler);

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
      try {
        g.cellEditEnding?.removeHandler(rangeGuardHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.prepareCellForEdit?.removeHandler(prepareEditHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visibleColumns, dynBindings, editableStaticBindings, weekdayByBinding]);

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

  // 셀 세로병합 — AS-IS siMain.SmartColMerge()(SCP0019_WorkingTime.cs:284,701 활성) 이식.
  //   공용 CustomMergeManager(DataGrid allowMerging={All} 로 자동설치)가 좌측 누적 키로 선행 식별컬럼
  //   (Division/Plant/Building/Operation/Line …)만 계층 병합하고 신규행(CRUD_TYPE='I')은 제외한다.
  //   동적 D_ 기간 컬럼은 AS-IS FPMerge.None 대로 병합 제외(일자별 값 컬럼). 자매 SCP0020 TactTimeMainGrid 패턴.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    for (let i = 0; i < g.columns.length; i++) {
      const col = g.columns[i];
      col.allowMerging = !dynBindings.has(col.binding ?? '');
    }
    g.invalidate(true);
  }, [gridRef, visibleColumns, dynBindings]);

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
      numberRules={numberRules}
      comboParams={GRID_COMBO_PARAMS}
      itemsSource={data}
      allowMerging={AllowMerging.All}
      autoGenerateColumns={false}
    />
  );
};
