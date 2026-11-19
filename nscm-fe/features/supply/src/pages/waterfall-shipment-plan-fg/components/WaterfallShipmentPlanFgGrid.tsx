import type { FlexGrid, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { useWaterfallShipmentPlanFgStore } from '../useWaterfallShipmentPlanFgStore';
import {
  buildDynColMetas,
  buildDynamicColumns,
  buildStaticColumns,
  dynKeySig,
  periodScaleOf,
  splitTitleRows,
  type DynColMeta,
  type WaterfallTitleRow,
} from '../utils/waterfall.columns';
import { derivePeriodSums } from '../utils/waterfall.derive';
import { WaterfallMergeManager } from '../utils/waterfall.merge';
import { baseVisibleOf, dynKindOf, isIsoWeek } from '../utils/waterfall.periods';
import {
  BUCKET_TYPE,
  HEADER_COLORS,
  MENU_ID,
  PERIOD_COLUMN_REGEX,
  quoteComboParam,
  SHEETS,
} from '../waterfall-shipment-plan-fg.constants';

// #93 다단 헤더 총 높이 48px 표준(production-plan-waterfall 동일).
const HEADER_TOTAL_HEIGHT = 48;

interface WaterfallShipmentPlanFgGridProps {
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: Record<string, string | number>[];
  tabId: string;
}

export const WaterfallShipmentPlanFgGrid = ({
  gridRef,
  gridFilterRef,
  data,
  tabId,
}: WaterfallShipmentPlanFgGridProps) => {
  const filters = useWaterfallShipmentPlanFgStore(state => state.filters);
  const searchParams = useWaterfallShipmentPlanFgStore(state => state.searchParams);
  const metaColumns = useWaterfallShipmentPlanFgStore(state => state.staticColumns[SHEETS.MAIN]);

  const bucket = searchParams.bucket;
  const chkSum = searchParams.chkSum;

  // 셀 콤보 파라미터 — 메타 CMBO 토큰(@mnuId). 셀 콤보 0건이나 공용 규약대로 전달.
  const comboParams = useMemo(() => ({ mnuId: quoteComboParam(MENU_ID) }), []);

  // Bucket=Only Weekly 는 캘린더 헤더를 ISO 전용 proc(연속 ISO 주차 + 날짜범위 MMDD)으로 받는다
  //   — AS-IS 가 WeeklyISO 일 때만 SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO 를 호출하는 것과 등가(cs:1263-1268).
  //   그 외 버킷은 NotISO spreadTitle 사용. 둘 중 bucket 에 맞는 쿼리만 enable 한다(자매 SCP0018 미러).
  const isWeeklyIso = bucket === BUCKET_TYPE.WEEKLY_ISO;

  // 기간칼럼 헤더(공용 캘린더 3span, NotISO) — filters 세팅 후 + 비(非)WeeklyISO 일 때만 enabled.
  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.TITLE,
    tabId,
    filters: filters[SHEETS.TITLE],
    enabled: !!filters[SHEETS.TITLE] && !isWeeklyIso,
  });
  // ISO 캘린더 헤더(Only Weekly 전용) — WeeklyISO 일 때만 enabled.
  const { data: titleIsoData } = useTabProcQuery<MENU_ID, SHEETS.TITLE_ISO>({
    menuId: MENU_ID,
    sheetName: SHEETS.TITLE_ISO,
    tabId,
    filters: filters[SHEETS.TITLE_ISO],
    enabled: !!filters[SHEETS.TITLE_ISO] && isWeeklyIso,
  });

  const titleRows = useMemo<WaterfallTitleRow[]>(
    () => ((isWeeklyIso ? titleIsoData?.o_rc1 : titleData?.o_rc1) ?? []) as WaterfallTitleRow[],
    [isWeeklyIso, titleData?.o_rc1, titleIsoData?.o_rc1]
  );

  const { staticRows, periodRows } = useMemo(() => splitTitleRows(titleRows), [titleRows]);

  const staticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => buildStaticColumns({ staticRows, metaColumns }),
    [staticRows, metaColumns]
  );

  const dynMetas = useMemo<DynColMeta[]>(() => buildDynColMetas(periodRows), [periodRows]);
  const dynSig = useMemo(() => dynKeySig(dynMetas), [dynMetas]);
  const dynMetasRef = useRef(dynMetas);
  dynMetasRef.current = dynMetas;
  const scale = useMemo(() => periodScaleOf(periodRows), [periodRows]);

  const headerRowHeight = dynMetas.length === 0 ? HEADER_TOTAL_HEIGHT : HEADER_TOTAL_HEIGHT / 3;

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildDynamicColumns({ metas: dynMetasRef.current, bucket, chkSum, scale }),
    // dynSig 가 컬럼 목록 동일성 판정 (metas 배열 참조는 조회마다 바뀐다)
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [dynSig, bucket, chkSum, scale]
  );

  const dynBindings = useMemo(() => dynMetas.map(m => m.binding), [dynMetas]);

  // W_/M_ 파생 합산(R6~R8) — D_ 만 신뢰하고 FE 재합산(measure!=BALANCE=합, BALANCE=기간 마지막 D_).
  //   서버 plain SUM 을 덮어써 BALANCE 행을 교정(design 03 §2.2/§3). 기간 메타 없으면 원본 그대로.
  const gridData = useMemo(() => derivePeriodSums(data, dynMetas), [data, dynMetas]);

  // 헤더 주말색(토/일) 판정용 — binding → DAY_CODE.
  const dayCodeOf = useMemo(() => {
    const map = new Map<string, string>();
    dynMetas.forEach(m => map.set(m.binding, m.dayCode));
    return map;
  }, [dynMetas]);

  // ── 버킷·Sum 토글 + 헤더 더블클릭 드릴(R10, hook #103) ──
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // bucket/sum/조회(동적 메타) 변경 = AS-IS SetSpreadColumn 재실행 등가 — 드릴 상태 리셋
    drillVisRef.current.clear();
    const dynSet = new Set(dynBindings);
    const kindByBinding = new Map(dynBindings.map(b => [b, dynKindOf(b)]));

    const applyDynVisibility = () => {
      // 우클릭 Hide Column 으로 숨긴 컬럼(공용 DataGrid 가 grid 인스턴스에 얹어 준다 — Column 객체의
      //   커스텀 플래그는 wijmo 생성자가 `_` 로 시작하는 키를 무시해 전달되지 않는다).
      const userHiddenColumns = (g as unknown as { _userHiddenColumns?: ReadonlySet<string> })
        ._userHiddenColumns;
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        if (!dynSet.has(binding)) continue;
        // Hide Column 으로 숨긴 컬럼은 sum/드릴 재계산 대상에서 제외 — 숨김 유지.
        if (userHiddenColumns?.has(binding)) {
          if (col.visible !== false) {
            col.visible = false;
            changed = true;
          }
          continue;
        }
        const kind = kindByBinding.get(binding);
        const base = kind ? baseVisibleOf(bucket, chkSum, kind, isIsoWeek(binding)) : true;
        const want = drillVisRef.current.get(binding) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };

    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dynBindings, bucket, chkSum, dynamicColumns]);

  // ── 헤더 높이 자급 (#93 총 48px — 보이는 tier 수로 나눠 전 헤더 row 에 강제) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const rows = g.columnHeaders?.rows;
      if (!rows || rows.length === 0) return;
      const targetHeight = HEADER_TOTAL_HEIGHT / rows.length;
      let changed = false;
      for (let i = 0; i < rows.length; i += 1) {
        if (Math.round(rows[i].height ?? rows.defaultSize) !== targetHeight) {
          rows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(rows.defaultSize) !== targetHeight) {
        rows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticColumns, dynamicColumns, headerRowHeight]);

  // ── 계층 병합 (AS-IS SmartColMerge + 헤더 스팬) — 실제 보이는 정적 컬럼 좌→우 순서로 ──
  //   fixedBindings 는 admin 메타 전체(staticColumns)가 아니라 g.columns 에서 "보이는 비기간" 컬럼만
  //   추린다. 메타에는 숨김 축 컬럼(MEASURE 등 — 행마다 값이 달라 계층키를 매 행 깨뜨림)이 섞여 있어
  //   그대로 쓰면 세로병합이 전혀 안 걸린다. 자매 production-plan-waterfall(SCP0017)과 동일 방식.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fixedBindings = g.columns
      .filter(
        column =>
          column.visible !== false &&
          !!column.binding &&
          !PERIOD_COLUMN_REGEX.test(column.binding)
      )
      .map(column => column.binding as string);
    g.mergeManager = new WaterfallMergeManager(fixedBindings);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // ── 스크롤 시 세로 병합 재계산 (AS-IS spdMain_TopChange → SmartColMerge 재호출) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const onScroll = () => g.invalidate();
    g.scrollPositionChanged.addHandler(onScroll);
    return () => {
      try {
        g.scrollPositionChanged?.removeHandler(onScroll);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, data]);

  // ── 헤더 더블클릭 드릴다운 (R10, AS-IS SpdMain_CellDoubleClick + WeeklyISO 가드 buttonGuard #1) ──
  //   자매 SCP0017 ProductionPlanWaterfallGrid dblClickHandler 1:1. 종전엔 largeKeyOf(=yyyymm, 월)로
  //   하위를 모아 M_(월) 더블클릭 시 그 달의 W_ 뿐 아니라 D_(일)까지 한 번에 펼쳐졌다(사용자 신고:
  //   Monthly 에서 SUM 더블클릭 시 Daily 까지 보임). 월 키 매칭 대신 표시순서(g.columns)를 걸어 클릭한
  //   헤더의 구간(다음 동급/상위 경계 전까지)만 토글한다 — 한 단계씩 드릴다운(AS-IS 주석 cs:1059-1098 등가).
  //     M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기(hideOnly) /
  //     W_ 헤더 = 그 주 구간(다음 W_/M_ 전까지) D_ 토글.
  //   WeeklyISO 면 무동작(주별만 표시 — design 03 §2.4 buttonGuard #1).
  useEffect(() => {
    const g = gridRef.current;
    if (!g?.hostElement) return;
    const host = g.hostElement;
    const onDblClick = (ev: MouseEvent) => {
      if (bucket === BUCKET_TYPE.WEEKLY_ISO) return; // design 03 §2.4 buttonGuard #1
      const hit = g.hitTest(ev);
      if (hit.cellType !== CellType.ColumnHeader) return;
      const clicked = g.columns[hit.col]?.binding ?? '';
      const clickedKind = dynKindOf(clicked);
      if (clickedKind !== 'M' && clickedKind !== 'W') return; // leaf(일)는 접을 하위 없음
      // 표시순서의 동적 바인딩만 추려 클릭 헤더 뒤 구간을 walk.
      const dyn: string[] = [];
      for (let i = 0; i < g.columns.length; i += 1) {
        const b = g.columns[i].binding ?? '';
        if (dynKindOf(b) !== null) dyn.push(b);
      }
      const idx = dyn.indexOf(clicked);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.columns.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dyn.length; i += 1) {
        const t = dyn[i];
        const tk = dynKindOf(t);
        if (clickedKind === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyDynVisibilityRef.current?.();
    };
    host.addEventListener('dblclick', onDblClick);
    return () => host.removeEventListener('dblclick', onDblClick);
  }, [gridRef, dynBindings, bucket]);

  // ── 표시 규칙: 주말 헤더색(토=파랑/일=빨강, design 03 §3 R9) + 데이터 셀 음수=빨강 ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (_sender: FlexGrid, e: FormatItemEventArgs) => {
      const panel = e.panel;
      // 헤더 주말색
      if (panel.cellType === CellType.ColumnHeader) {
        const col = panel.columns[e.col];
        if (!col) return;
        const binding = col.binding ?? '';
        const isLeafRow = e.row === panel.rows.length - 1;
        const dayCode = isLeafRow ? dayCodeOf.get(binding) : undefined;
        const weekend =
          dayCode === 'SAT'
            ? HEADER_COLORS.SATURDAY
            : dayCode === 'SUN'
              ? HEADER_COLORS.SUNDAY
              : '';
        e.cell.style.color = weekend;
        return;
      }
      // 데이터 셀 음수 = 빨강 (AS-IS NumberCellType.NegativeRed=true — 전 수치 셀 공통).
      //   문자/코드 셀은 toGridNumber 가 0 으로 떨어져 자연히 제외. paintNegativeText 는 양수일 때
      //   색을 지운다 — Wijmo 셀 DOM 재사용 시 색 누수 방지(공용 헬퍼 규약).
      if (panel.cellType === CellType.Cell) {
        paintNegativeText(e.cell, toGridNumber(panel.getCellData(e.row, e.col, false)));
      }
    };
    g.formatItem.addHandler(handler);
    g.invalidate(true);
    return () => {
      try {
        g.formatItem.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dayCodeOf]);

  return (
    <DataGrid<Record<string, string | number>>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      // 조회 전용 화면 — 전 컬럼 Lock(design 03 R1). CUD 상태(CRUD_TYPE) rowHeader 미생성.
      isReadOnly={true}
      itemsSource={gridData}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      autoGenerateColumns={false}
      // AS-IS SmartColMerge — 데이터 행 세로 병합 + 헤더 3단 그룹 병합(WaterfallMergeManager 로 교체).
      allowMerging={AllowMerging.All}
      comboParams={comboParams}
      // headerRowHeight 정적 prop 제거(SCP0100 류 무한 header-height 루프 방지) — 공용 DataGrid 가 정적
      //   prop 으로 defaultSize 를 되돌리는 것과 자체 applyHeaderHeight 의 동적 tier 보정이 충돌해 무한
      //   invalidate 가 됐다. headerRowHeight 지역값은 applyHeaderHeight effect deps 로 계속 쓰인다.
      excelFileName='WaterfallShipmentPlanFg'
    />
  );
};
