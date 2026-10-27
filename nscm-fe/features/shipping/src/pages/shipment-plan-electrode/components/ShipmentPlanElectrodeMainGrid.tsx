import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

dayjs.extend(isoWeek);

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type {
  BUCKET_TYPE} from '../shipment-plan-electrode.constants';
import {
  BOH_COLUMNS,
  BOH_RADIO,
  MAIN_CONFIRM_MEASURE,
  MAIN_EDITABLE_MEASURE,
  MENU_ID,
} from '../shipment-plan-electrode.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-electrode.types';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';
import { createSameCellDblClickGuard } from '../utils/shipment-plan-electrode.dblClickGuard';
import {
  activeSpanOf,
  isDynVisible,
  isMainCellEditable,
  parseDynTag,
  type DynSpan,
} from '../utils/shipment-plan-electrode.editLock';
import { ShipmentPlanElectrodeMergeManager } from '../utils/shipment-plan-electrode.merge';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  bohRadio: BOH_RADIO;
  chkSum: boolean;
  chkPastPeriod: boolean;
  // Main 편집 가능 여부 = canEdit(편집계 권한 INSERT||SAVE)·최신Plan(realFlag). 셀 단위 범위는 isMainCellEditable.
  //   AS-IS EditButton SwitchLock 미이식(convert-core §2.4) — 편집 기본 ON, 권한은 마운트 1회 판정.
  editable: boolean;
  curPlanDate: string;
  // 편집 가능 상한 = 조회 기간 종료(drpPeriod.Text2). AS-IS cs:2142 가 편집 개방 상한으로 쓰는 열.
  periodTo: string;
  onCellEdited?: () => void;
  // 확정 측정치(P_SHIP_CONFIRM_ETD) 일자 셀 더블클릭 → 하단 Plan Detail 드릴다운(AS-IS SpdMain_CellDoubleClick
  //   cs:1790~1828). ymd = 클릭 컬럼 일자(yyyyMMdd).
  onConfirmDrilldown?: (row: MainRow, ymd: string) => void;
}

// 다단(월>주/SUM>일) 동적 헤더 각 단의 행높이 — columnGroup 에 명시(형제 ShipmentPlanMainGrid 선례).
const DYN_HEADER_ROW_HEIGHT = 16;
// 헤더 총높이(px) — 정적 컬럼의 큰 기본높이가 각 tier 를 지배해 48×tier 로 벌어지는 것을 방지.
//   실제 tier 수로 나눠 각 헤더 행·defaultSize 에 균등 배분한다(형제 ShipmentPlanMainGrid applyHeaderHeight 선례).
const MAIN_HEADER_HEIGHT = 48;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

// Main(PSI) 그리드 — base 26컬럼(admin 메타) + 동적 기간(X_/Y_/Z_ × D_/W_/M_, GET_SHEET_CALENDAR_3SPAN).
//   활성 span(rdButton1→X_ / rdButton2→Y_ / rdButton3→Z_)만 노출, bucket 표시규칙(§2.2)·주말색·과거일 회색·
//   Plan-Confirm 불일치 LightPink 재현. 편집표면 = 활성 span D_ 셀(P_SHIP_PLAN_SIMU_ETD 행 + plan_start~confirm_day).
export const ShipmentPlanElectrodeMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  bohRadio,
  chkSum,
  chkPastPeriod,
  editable,
  curPlanDate,
  periodTo,
  onCellEdited,
  onConfirmDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];
  const activeSpan = activeSpanOf(bohRadio);

  // 동적 컬럼 메타 — calendar(o_rc1) 우선, 0건이면 데이터 행 키 union fallback (forecast-price 패턴)
  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!parseDynTag(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => {
          const tag = parseDynTag(str(r.COLUMN_NAME));
          return {
            binding: str(r.COLUMN_NAME),
            span: tag?.span as DynSpan,
            bucket: tag?.bucket ?? 'D',
            ymd: tag?.ymd ?? '',
            large: str(r.LARGE_CLASS_LABEL_NAME),
            small: str(r.SMALL_CLASS_LABEL_NAME),
            leaf: str(r.COLUMN_LABEL_NAME),
            dayCode: str(r.DAY_CODE),
            sort: str(r.SORT_ORDER_NO),
          };
        })
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (parseDynTag(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => {
      const tag = parseDynTag(b);
      return {
        binding: b,
        span: tag?.span as DynSpan,
        bucket: tag?.bucket ?? 'D',
        ymd: tag?.ymd ?? '',
        large: tag?.ymd.slice(0, 6) ?? '',
        small: '',
        leaf: tag?.ymd.slice(6) ?? '',
        dayCode: '',
        sort: b,
      };
    });
  }, [calendar, rows]);

  // 토(Blue)/일(Red) 헤더색 대상 — DAY_CODE 실측값 기준 (03 §3.3, 활성 span D_ 한정)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      if (meta.bucket !== 'D' || meta.span !== activeSpan) return;
      const code = meta.dayCode.toUpperCase();
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas, activeSpan]);

  // 표시 여부 판정 — 활성 span + bucket 표시규칙 + chkPastPeriod(체크 안 됨이면 과거 기간 숨김).
  //   dynamicColumns 초기 빌드와 applyDynVisibility(imperative flip)가 공유하는 순수 판정(상태 인자로 받음).
  //   주의: AS-IS SetSpreadColumn(cs L4580-4596)은 chkPastPeriod 가 "체크 안 됨"일 때 과거 컬럼을 숨기되
  //   2단 헤더가 "SUM"인 컬럼은 continue 로 과거 필터를 건너뛴다(cs:4582) — 즉 SUM 롤업(M_ 월합계·W_ 주합계)은
  //   과거여도 유지하고, 일자(D_)만 날짜 비교로 숨긴다. 과거 필터를 M_/W_ 에도 걸면 첫 월(과거월) 전체 SUM 이
  //   사라진다(2026-10-15 소스 실측 교정 — 이전 "M_ 도 과거면 숨김" 주석은 cs:4582 SUM continue 를 놓친 오독).
  const isDynColVisible = (
    binding: string,
    spanArg: DynSpan,
    bucketArg: BUCKET_TYPE,
    chkSumArg: boolean,
    chkPastArg: boolean,
    planDateArg: string
  ): boolean => {
    const tag = parseDynTag(binding);
    if (!tag) return false;
    if (!isDynVisible(tag, spanArg, bucketArg, chkSumArg)) return false;
    // 과거 필터는 일자(D_)에만 — SUM 롤업(M_/W_)은 과거여도 유지(AS-IS cs:4582 "SUM" continue).
    if (!chkPastArg && planDateArg && tag.bucket === 'D' && tag.ymd < planDateArg) return false;
    return true;
  };

  // UOM Type(activeSpan)·Sum·Past Period 토글은 컬럼 재생성 없이 imperative 로 반영(헤더 SUM 병합·높이·폭·
  //   스크롤 보존) — 빌드 시점 초기 visible 계산만 아래 ref 로 최신값을 참조하고, 토글 자체는 applyDynVisibility 가 flip.
  //   (SSP0015 ShipmentPsiMainGrid chkSumRef 동일 패턴 — 이 값들을 dynamicColumns dep 에 두면 매 토글마다
  //    columnGroups 가 재대입돼 Wijmo 가 다단 헤더를 통째로 재생성, 헤더높이가 리셋되고 깜빡인다.)
  //   컬럼 집합 자체를 바꾸는 것은 bucketType 뿐이라 그것만 재생성 dep. span(X/Y/Z)은 3개를 다 생성해 둔다.
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;
  const chkPastPeriodRef = useRef(chkPastPeriod);
  chkPastPeriodRef.current = chkPastPeriod;

  // 동적 컬럼 binding 순서(헤더 드릴다운 보행 기준 — SP 수신/정렬 순서 그대로, span·M/W/D interleave).
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // 헤더 더블클릭 드릴 오버라이드(binding → visible). bucket/span 변경 시 리셋(AS-IS SetSpreadColumn 재실행).
  //   base(isDynColVisible) 위에 이 오버라이드가 우선 — applyMerge·토글 effect·헤더 핸들러가 공유한다.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);
  // 동적 헤더 SUM 세로병합 매니저 설치 표식 — grid 인스턴스당 1회만 래핑(체인 무한 증식 방지).
  const mergeWrappedRef = useRef<FlexGridType | null>(null);

  // 3단 nested 동적 컬럼 (월 > 주/SUM > 일) — X/Y/Z 3 span 전부 생성(AS-IS SetSpreadColumn parity).
  //   AS-IS 는 spread 한 장에 X_/Y_/Z_ 컬럼을 물리적으로 다 두고 Visible 만 토글한다(cs:4417~). TO-BE 도
  //   동일하게 3 span 을 모두 생성하고 UOM Type 전환은 applyDynVisibility 의 visible flip 으로 처리한다
  //   (activeSpan 을 dep 에서 빼 재생성·헤더 깜빡임 제거). 헤더 그룹키는 span+월(span 블록이 섞이지 않게).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<
      string,
      { span: DynSpan; label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
    const kindRank: Record<string, number> = { M: 0, W: 1, D: 2 };
    const spanRank: Record<string, number> = { X: 0, Y: 1, Z: 2 };
    dynColMetas.forEach((m, idx) => {
      // 주의: 그룹키는 span+월. 같은 월이라도 X/Y/Z 를 다른 블록으로 분리해야 헤더가 섞이지 않는다.
      const ymKey = `${m.span}_${m.ymd.slice(0, 6)}`;
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { span: m.span, label: m.large || m.ymd.slice(0, 6), subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.bucket === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.bucket === 'D' ? m.leaf || 'SUM' : 'SUM',
        align: 'right',
        width: 80,
        height: DYN_HEADER_ROW_HEIGHT,
        allowMerging: false,
        allowSorting: false,
        visible: isDynColVisible(
          m.binding,
          m.span,
          bucketType,
          chkSumRef.current,
          chkPastPeriodRef.current,
          curPlanDate
        ),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => {
      if (k === 'SUM') return Number.NEGATIVE_INFINITY;
      const n = Number(k.replace(/\D/g, '') || 0);
      return k.trim().startsWith('+') ? n - 1000 : n;
    };
    return [...largeMap.values()]
      // span 블록(X→Y→Z) 먼저, 그 안에서 SP 수신 순서(order) 유지 — 비활성 span 은 전부 숨김이라 안 보인다.
      .sort((a, b) => (spanRank[a.span] ?? 3) - (spanRank[b.span] ?? 3) || a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: DYN_HEADER_ROW_HEIGHT,
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            height: DYN_HEADER_ROW_HEIGHT,
            allowSorting: false,
            allowMerging: false,
            columns: leafCols.sort(
              (a, b) =>
                (kindRank[parseDynTag(a.binding)?.bucket ?? 'D'] ?? 2) -
                  (kindRank[parseDynTag(b.binding)?.bucket ?? 'D'] ?? 2) ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
    // chkSum/chkPastPeriod/curPlanDate/activeSpan 의도적 제외 — 전부 applyDynVisibility 가 재생성 없이 flip.
    //   bucketType 만 컬럼 집합(일/주/월 leaf 구성)을 바꾸므로 재생성 dep 로 유지.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, bucketType]);

  // BOH 3칸 표시 토글 — 활성 radio 3칸만 노출(03 §2.1). base 컬럼(admin 메타)에 대한 visible override.
  const bohVisibleSet = useMemo(() => new Set<string>(BOH_COLUMNS[bohRadio]), [bohRadio]);
  const bohAllSet = useMemo(
    () =>
      new Set<string>([
        ...BOH_COLUMNS[BOH_RADIO.GENERAL],
        ...BOH_COLUMNS[BOH_RADIO.CELL],
        ...BOH_COLUMNS[BOH_RADIO.PCM],
      ]),
    []
  );

  const setActiveGrid = useShipmentPlanElectrodeStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;

  const editableRef = useRef(editable);
  editableRef.current = editable;
  const activeSpanRef = useRef(activeSpan);
  activeSpanRef.current = activeSpan;
  const curPlanDateRef = useRef(curPlanDate);
  curPlanDateRef.current = curPlanDate;
  const periodToRef = useRef(periodTo);
  periodToRef.current = periodTo;
  // 과거일 회색 경계 = 오늘(AS-IS cs:2110 DateTime.Today, 설계 03 §3.3 "오늘 이전"). planStart 아님.
  const todayRef = useRef(dayjs().format('YYYYMMDD'));
  todayRef.current = dayjs().format('YYYYMMDD');
  const onCellEditedRef = useRef(onCellEdited);
  onCellEditedRef.current = onCellEdited;
  const onConfirmDrilldownRef = useRef(onConfirmDrilldown);
  onConfirmDrilldownRef.current = onConfirmDrilldown;
  const bohVisibleRef = useRef(bohVisibleSet);
  bohVisibleRef.current = bohVisibleSet;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 동적 M_/W_/D_ 헤더 병합(년월 가로 · M_ SUM 세로) 전담 매니저로 공용 매니저를 감싼다 —
    //   정적 헤더·데이터셀은 delegate 로 위임. 없으면 월(M_) 아래 SUM 이 그룹행+leaf행 2줄로 보인다.
    //   grid 인스턴스당 1회만 래핑(체인 무한 증식 방지, 형제 ShipmentPsiMainGrid 선례).
    if (mergeWrappedRef.current !== g) {
      g.mergeManager = new ShipmentPlanElectrodeMergeManager(g.mergeManager);
      mergeWrappedRef.current = g;
    }

    // 병합 — base 전 컬럼 허용 / 동적(X_/Y_/Z_) 만 제외(FPMerge.None 재현)
    //   동적 컬럼 visible 은 여기서 imperative flip(Sum/Past Period 토글이 컬럼 재생성 없이 반영되게) —
    //   ref 로 최신 chkSum/chkPastPeriod 를 읽으므로 이 effect 의 dep 와 무관하게 항상 현재값 기준.
    const applyMerge = () => {
      g.columns.forEach(col => {
        const binding = col.binding ?? '';
        col.allowMerging = !parseDynTag(binding);
        // BOH 3칸 visible override — 활성 radio 3칸만(비활성 6칸 숨김)
        if (bohAllSet.has(binding)) col.visible = bohVisibleRef.current.has(binding);
        // 동적 기간 컬럼 — Sum/Past Period 토글 + 헤더 드릴 오버라이드 반영(flip only, 재생성 없음)
        if (parseDynTag(binding)) {
          const base = isDynColVisible(
            binding,
            activeSpanRef.current,
            bucketType,
            chkSumRef.current,
            chkPastPeriodRef.current,
            curPlanDateRef.current
          );
          const want = drillVisRef.current.get(binding) ?? base;
          if (col.visible !== want) col.visible = want;
        }
      });
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();
    // 헤더 드릴다운이 flip 후 재적용할 때 부르는 핸들 — applyMerge 가 drillVisRef 오버라이드까지 반영하고
    //   값이 바뀐 컬럼이 있으면 invalidate 로 헤더 SUM 병합을 다시 그린다.
    const applyDynVisibility = () => {
      applyMerge();
      g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;

    // 헤더 총높이 고정 — 정적 컬럼 기본높이가 동적 16·defaultSize 를 이겨 48×tier 로 벌어지는 것을
    //   실제 tier 수로 나눠 되돌린다(형제 ShipmentPlanMainGrid). 목표값과 같으면 skip → updatedLayout 무한루프 방지.
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = MAIN_HEADER_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();

    // 편집 잠금 — beginningEdit(e.cancel) (활성 span D_ + SIMU 측정치 행 + plan_start~confirm_day)
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (
        !isMainCellEditable(
          row,
          binding,
          editableRef.current,
          activeSpanRef.current,
          curPlanDateRef.current,
          periodToRef.current
        )
      ) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 색상 — 헤더 주말색 / 확정구간 연한 회색(BACK_COLOR) / 과거일 진한 회색 / Plan-Confirm 불일치 LightPink (03 §3.3)
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (e.panel === sender.columnHeaders) {
        // 주말색(토 Blue/일 Red)은 leaf 행(최하단 일자 헤더)에만. 다단 헤더에서 1·2단 셀은 병합돼
        //   그 아래 첫 leaf 컬럼의 binding 을 받으므로(e.col=leaf), 월 블록 첫 컬럼이 토/일이면 1·2단까지
        //   색이 번졌다. leaf 행(마지막 헤더 행)으로 한정해 막는다.
        const leafHeaderRow = sender.columnHeaders.rows.length - 1;
        if (e.row !== leafHeaderRow) return;
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      // 음수 = 빨간 글자 (AS-IS NegativeRed 전역 파리티 — 프레임워크 NumberCellType 기본값이라 .cs 에 개별
      //   코드가 없다. 정본 paintNegativeText). 필수: 색 분기 return 앞에서 전 셀에 1회 적용해야 재활용 잔상이
      //   안 남는다. 값 원천은 실제 그리는 원값(getCellData false). 문자/코드 셀은 toGridNumber 가 0 을 돌려 빠진다.
      paintNegativeText(e.cell, toGridNumber(sender.cells.getCellData(e.row, e.col, false)));
      // 주의: 노란 편집배경은 전역 CSS `.wj-cells .wj-cell.wj-cell-editable { background:#fff8cd }` 가 칠한다.
      //   wijmo 가 이 클래스를 컬럼 단위(editable 컬럼)로 모든 행 셀에 붙여 다른 measure 행까지 노랗게 됐다.
      //   → 매 렌더 셀별로 isMainCellEditable 판정에 따라 클래스를 toggle 해 실제 편집가능 셀만 노랗게 한다
      //   (형제 Detail 그리드 formatItem 과 동일 패턴). 셀 재활용 잔류를 막으려 비편집 경로에선 클래스를 제거한다.
      //   배경 인라인색(회색·LightPink·BACK_COLOR)도 분기 전에 초기화한다.
      e.cell.style.backgroundColor = '';
      const tag = parseDynTag(binding);
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable =
        !!tag &&
        tag.span === activeSpanRef.current &&
        isMainCellEditable(
          row,
          binding,
          editableRef.current,
          activeSpanRef.current,
          curPlanDateRef.current,
          periodToRef.current
        );
      e.cell.classList.toggle('wj-cell-editable', cellEditable);

      if (!tag || tag.span !== activeSpanRef.current || !row) return;

      // 배경색 — AS-IS Re_Design(cs:5119-5172) 색 모델 그대로, 칠하는 순서가 곧 우선순위(나중이 덮는다):
      //   1) 연한 회색(확정구간): CONFIRM_DAY 가 있으면 첫 동적일자 ~ CONFIRM_DAY 구간을 BACK_COLOR 필드 RGB 로
      //      칠한다(cs:5130-5135). 종료 경계 = "X_D_"+CONFIRM_DAY 의 컬럼 인덱스.
      //   2) 진한 회색(과거일): 오늘 이전 컬럼은 rgb(230,230,230) 로 1)을 덮는다(cs:5138-5143, 경계=DateTime.Today).
      //      주의: 경계는 planStart(curPlanDate)가 아니라 오늘이다 — planStart 를 쓰면 과거 Plan Date 조회 시
      //      과거 컬럼이 전부 planStart 이후가 돼 회색이 사라진다(2026-10-15 신고).
      //   3) LightPink: SIMU 행에서 동일 기간열 CONFIRM 값과 다르면 2)를 덮는다(cs:5158-5170).
      //   필수 — 버킷별로 회색 체계가 갈린다(AS-IS 인덱스 범위 메커니즘의 셀단위 재현, 사용자 실측 2026-10-16):
      //     · Daily(D_)       : 연회색 = today ~ CONFIRM_DAY(BACK_COLOR) / 진한회색 = today 이전.
      //     · Weekly/Monthly  : 연회색 없음. CONFIRM_DAY 이하 전부 진한회색(오늘 이후 주/월이라도 포함).
      //   AS-IS 는 버킷 전환 시 컬럼을 재생성하지 않고 Visible 토글만 하므로(cs:4429-4499)
      //   GetColumnIndex("X_D_"+경계) 는 숨은 D_ 인덱스를 반환하고, 그 인덱스 범위로 칠한 결과가 보이는
      //   W_/M_ 셀에서는 연회색이 진한회색에 덮여 드러나지 않는다 → Weekly/Monthly 는 확정구간이 통째로
      //   진한 회색으로 보인다. 그래서 연회색(1)은 Daily 전용, 진한회색(2)은 버킷별 상한(Daily=today 이전 /
      //   W·M=CONFIRM_DAY 이하)으로 분기한다. LightPink(3)는 전 버킷 공통.
      //   비교 키는 버킷별 자리수에 맞춘다: D_ 는 8자리 yyyymmdd 직접, W_ 는 yyyyMM+ISO주차, M_ 는 6자리 yyyyMM.
      //   노란 편집셀(.wj-cell-editable)이 최우선 — 편집가능 셀이면 아래 인라인 배경을 칠하지 않아
      //   전역 CSS 노란색이 그대로 보이게 한다. 인라인 style 은 CSS 클래스를 이기므로, 회색/LightPink 를
      //   인라인으로 칠하면 편집가능 셀의 노란색이 가려진다(2026-10-15 신고). W_/M_ 은 편집 불가라 cellEditable
      //   은 항상 false 이므로 D_ 편집셀만 자연히 제외된다.
      if (!cellEditable) {
        const confirmDay = str(row.CONFIRM_DAY).trim();
        // 버킷별 경계 변환 — tag.ymd 는 버킷마다 표기체계가 다르다(D_=yyyyMMdd 8 · M_=yyyyMM 6 ·
        //   W_=yyyyMM+ISO주차 8, CALENDAR SP 실측). 8자리 경계일(confirmDay·today)을 각 버킷의 표기로
        //   맞춰 변환해야 같은 축에서 비교된다. W_ 를 날짜로 직접 비교하면(20261042 vs 20261016) 주차값이
        //   일(day)처럼 취급돼 10월 주차가 미래로 오판된다 → 9월만 회색이 되는 증상(2026-10-16 신고).
        //   W_ 변환은 형제 waterfall.headerColors `W_${yyyymm}${isoWeek}` 선례와 동일.
        const cutOf = (boundary: string): string => {
          if (tag.bucket === 'M') return boundary.slice(0, 6);
          if (tag.bucket === 'W') {
            // 8자리 yyyymmdd → ISO 날짜문자열로 파싱(customParseFormat 플러그인 불요).
            const d = dayjs(`${boundary.slice(0, 4)}-${boundary.slice(4, 6)}-${boundary.slice(6, 8)}`);
            return d.isValid()
              ? `${boundary.slice(0, 6)}${String(d.isoWeek()).padStart(2, '0')}`
              : boundary;
          }
          return boundary; // D_ : yyyyMMdd 그대로
        };
        // 1) 확정구간 연한 회색(BACK_COLOR) — Daily(D_) 전용. AS-IS 실측(2026-10-16 신고):
        //   Weekly/Monthly 에선 연회색이 안 보이고 CONFIRM_DAY 이하가 통째로 진한 회색으로 보인다.
        //   cutOf 는 D_ 에서 항등이므로 8자리 직접 비교로 충분하다.
        if (tag.bucket === 'D' && confirmDay && tag.ymd <= confirmDay) {
          const rgb = str(row.BACK_COLOR).trim();
          if (rgb) e.cell.style.backgroundColor = `rgb(${rgb})`;
        }
        // 2) 진한 회색(rgb230) — 상한이 버킷별로 다르다(AS-IS 인덱스 범위 메커니즘의 셀단위 재현):
        //   · Daily        : today 이전(과거일)만. today ~ CONFIRM_DAY 는 위 연회색이 남는다.
        //   · Weekly/Monthly : CONFIRM_DAY 이하 전부. 연회색이 없으므로 확정구간이 전부 진한 회색이 된다
        //     (오늘 이후 주/월이라도 CONFIRM_DAY 이하면 진한 회색 — 2026-10-16 신고).
        //   AS-IS 는 숨은 D_ 인덱스 범위로 칠해 버킷 전환 시 결과가 이렇게 갈린다. cutOf 로 경계를 버킷
        //   표기(W_=yyyyMM+ISO주차, M_=yyyyMM)로 변환해 같은 축에서 비교한다.
        const darkUpper = tag.bucket === 'D' ? cutOf(todayRef.current) : cutOf(confirmDay);
        const darkHit =
          tag.bucket === 'D' ? tag.ymd < darkUpper : tag.ymd <= darkUpper;
        if (confirmDay && !!todayRef.current && darkHit) {
          e.cell.style.backgroundColor = 'rgb(230,230,230)';
        }
        // 3) Plan-Confirm 불일치 LightPink (과거일 회색을 덮음)
        // if (confirmDay && str(row.MEASURE) === MAIN_EDITABLE_MEASURE) {
        //   const confirmRow = (sender.collectionView?.sourceCollection ?? []).find(
        //     (r: Record<string, unknown>) =>
        //       str(r.MEASURE) === MAIN_CONFIRM_MEASURE &&
        //       str(r.FROM_SITE) === str(row.FROM_SITE) &&
        //       str(r.ITEM_ID) === str(row.ITEM_ID) &&
        //       str(r.TO_SITE) === str(row.TO_SITE)
        //   ) as Record<string, unknown> | undefined;
        //   if (confirmRow && num(row[binding]) !== num(confirmRow[binding])) {
        //     e.cell.style.backgroundColor = '#FFB6C1'; // LightPink
        //   }
        // }
      }

      // 3) Plan-Confirm 불일치 LightPink — AS-IS cs:2139 처럼 편집 셀·CONFIRM_DAY 무관하게 칠한다(노란색도 덮음)
      if (str(row.MEASURE) === MAIN_EDITABLE_MEASURE) {
        const confirmRow = (sender.collectionView?.sourceCollection ?? []).find(
          (r: Record<string, unknown>) =>
            str(r.MEASURE) === MAIN_CONFIRM_MEASURE &&
            str(r.FROM_SITE) === str(row.FROM_SITE) &&
            str(r.ITEM_ID) === str(row.ITEM_ID) &&
            str(r.TO_SITE) === str(row.TO_SITE)
        ) as Record<string, unknown> | undefined;
        // if (confirmRow && num(row[binding]) !== num(confirmRow[binding])) {
        // AS-IS 는 조회 시점(Re_Design)에만 칠하므로 미저장 수정분 대신 원래 값으로 비교한다(Simulation 후 재조회 시 반영)
        const originals = editTrackerRef.current?.getOriginalValues().get(row as WijmoRowItem);
        const simuValue = originals && binding in originals ? originals[binding] : row[binding];
        if (confirmRow && num(simuValue) !== num(confirmRow[binding])) {
          e.cell.style.backgroundColor = '#FFB6C1'; // LightPink
        }
      }

      // 숫자 포맷 — AS-IS 화면은 동적 수량셀을 소수 3자리 고정(.000)으로 렌더한다(라이브 실측, 2026-10-16).
      //   SpreadInfo.cs:4138 가 AddNumColumn 시 DecimalPlaces=0 을 세팅하지만 FixedPoint=true 가
      //   소수 자리를 항상 표시로 돌려 셀타입 기본(3자리)이 화면에 적용된다 — 소스의 DecimalPlaces=0 은
      //   렌더에 반영되지 않는다. 디테일 푸터 포맷 {0:#,##0.###}(SSP0023.cs:5668)도 소수 3자리 관례를 뒷받침.
      //   재현: 소수 3자리 고정 + 천단위 콤마. 동적 수량셀(X/Y/Z × D/W/M)만 대상 — 정적 컬럼은 admin
      //   메타 포맷을 따르므로 건드리지 않는다. 빈값은 공란 유지.
      const rawNum = str(row[binding]).trim();
      // 편집 중인 셀은 덮어쓰지 않는다 - textContent 대입이 편집기(input)를 지워 편집이 안 됐다(2026-10-19).
      const isEditingCell = !!sender.activeEditor && !!sender.editRange?.contains(e.row, e.col);
      // if (rawNum !== '') { 기존 조건 주석 보존 (2026-10-19)
      if (rawNum !== '' && !isEditingCell) {
        const n = num(row[binding]);
        if (Number.isFinite(n)) {
          e.cell.textContent = n.toLocaleString('en-US', {
            minimumFractionDigits: 3,
            maximumFractionDigits: 3,
          });
        }
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // 붙여넣기 게이트 — 동적 셀은 편집창 판정으로 wrapper 판정을 덮어씀(등록 순서 호출)
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!parseDynTag(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isMainCellEditable(
        row,
        binding,
        editableRef.current,
        activeSpanRef.current,
        curPlanDateRef.current,
        periodToRef.current
      );
    };
    g.pastingCell.addHandler(pastingCellHandler);

    const onEdited = () => {
      onCellEditedRef.current?.();
    };
    g.cellEditEnded.addHandler(onEdited);
    g.pastedCell.addHandler(onEdited);

    // 데이터 셀 더블클릭 판정기 — 수명이 아래 click/dblclick 리스너와 같아야 해서 effect 안에서 만든다.
    //   다른 셀을 빠르게 두 번 클릭하면 dblclick 이 hostElement 에서 잡혀 드릴다운이 오발화한다(Detail 그리드와 같은 가드).
    const dblClickGuard = createSameCellDblClickGuard();

    // 데이터 셀 더블클릭 → 하단 Plan Detail 드릴다운 (AS-IS SpdMain_CellDoubleClick cs:1790~1828).
    //   AS-IS 조건: MEASURE 컬럼 오른쪽 셀 && 그 행 MEASURE == 'P_SHIP_CONFIRM_ETD'(확정 측정치)일 때만
    //   FindData_Detail(true, 행, 열) 을 부른다. 편집 측정치 P_SHIP_PLAN_SIMU_ETD 행은 위치만 기억하고
    //   (cs:1829~1833 iTopRow/iTopCol) 조회하지 않는다 — 그 행의 더블클릭은 셀 편집 진입이라 여기서 건드리지 않는다.
    //   확정 측정치 행은 isMainCellEditable 이 잠그므로(편집은 SIMU 행만) 편집과 겹치지 않는다.
    //   일자: AS-IS 는 GetColumnTag().Replace("X_D_","") 라 UOM(X_) 일자 열만 날짜가 된다(Y_/Z_·W_/M_·정적
    //   열은 태그가 그대로 넘어가 0건). TO-BE 는 일자(D_) 열만 받고 span(X/Y/Z) 은 같은 날짜로 본다 —
    //   Cell/Pancake 보기에서도 같은 날짜 Plan Detail 이 뜬다. 주/월 SUM 열과 정적 열은 반응하지 않는다.
    const cellDrilldown = (ht: { row: number; col: number }) => {
      if (!dblClickGuard.accepts({ row: ht.row, col: ht.col })) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const tag = parseDynTag(binding);
      if (!tag || tag.bucket !== 'D') return;
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row || str(row.MEASURE) !== MAIN_CONFIRM_MEASURE) return;
      onConfirmDrilldownRef.current?.(row, tag.ymd);
    };

    // 헤더 더블클릭 → 기간 드릴다운 (AS-IS SetDblClickColumnShowHide, Mobility&IT ShipmentPsiMainGrid 선례):
    //   M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기 / W_ 헤더 = 그 주 구간 D_ 토글.
    //   Electrode 는 활성 span(X_/Y_/Z_) 안에서만 보행 — 다른 span 경계를 만나면 멈춘다.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType === CellType.Cell) {
        cellDrilldown(ht);
        return;
      }
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const htag = parseDynTag(hb);
      if (!htag || htag.span !== activeSpanRef.current) return;
      if (htag.bucket !== 'M' && htag.bucket !== 'W') return;
      const idx = dynBindings.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dynBindings.length; i += 1) {
        const ttag = parseDynTag(dynBindings[i]);
        if (!ttag || ttag.span !== activeSpanRef.current) break; // span 경계
        if (htag.bucket === 'M') {
          if (ttag.bucket === 'M') break;
          if (ttag.bucket === 'W') flip(dynBindings[i], false);
          else if (ttag.bucket === 'D') flip(dynBindings[i], true);
        } else {
          if (ttag.bucket === 'W' || ttag.bucket === 'M') break;
          if (ttag.bucket === 'D') flip(dynBindings[i], false);
        }
      }
      applyDynVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 활성 그리드 전환 — 프레임워크 parity(BaseForm.FpSpread_CellClick 무조건 전환)
    //   더블클릭 가드 기록은 early return 보다 먼저 한다(헤더·빈 영역 클릭도 null 로 남겨야 오인이 없다).
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      dblClickGuard.track(ht.cellType === CellType.Cell ? { row: ht.row, col: ht.col } : null);
      if (ht.cellType !== CellType.Cell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.updatedLayout?.removeHandler(applyHeaderHeight);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(onEdited);
        g.pastedCell?.removeHandler(onEdited);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
        applyDynVisibilityRef.current = null;
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns, dynBindings]);

  // 헤더 드릴 리셋 — bucket/span 변경(= AS-IS SetSpreadColumn 재실행)에만. Sum/Past Period 토글은 드릴 보존.
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucketType, activeSpan, dynBindings]);

  // UOM Type(activeSpan)·Sum·Past Period 토글 반영 — 컬럼 재생성 없이 visible 만 flip 후 재그리기
  //   (헤더높이·병합·폭·스크롤 보존). applyDynVisibility(=applyMerge+invalidate)가 동적 기간컬럼과 BOH 3칸을
  //   함께 현재값 기준으로 반영하므로(ref 로 최신 chkSum/activeSpan/bohVisible 읽음) 여기서 그걸 호출한다.
  //   AS-IS SetSpreadColumn 과 동일 — UOM Type 전환은 Sum 토글과 같은 flip 경로(재생성 없음).
  useEffect(() => {
    applyDynVisibilityRef.current?.();
  }, [activeSpan, bohRadio, chkSum, chkPastPeriod, curPlanDate, bucketType]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져(CustomMergeManager 는 grid.allowMerging 정확일치 판정)
      //   정적 컬럼(allowMerging=true, applyMerge L234)의 단일 라벨이 그룹 헤더행+leaf행에 각각 찍혀 "같은 라벨 2줄".
      //   .All 이어야 헤더 병합(정적 컬럼 세로 span)과 셀 병합이 둘 다 동작(Mobility&IT 선례).
      allowMerging={AllowMerging.All}
    />
  );
};
