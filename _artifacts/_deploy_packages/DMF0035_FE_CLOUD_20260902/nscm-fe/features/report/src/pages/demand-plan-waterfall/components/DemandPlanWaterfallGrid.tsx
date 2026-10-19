import type { FlexGrid, GridPanel } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { toGridNumber } from '@foundation/utils';
import {
  DataGrid,
  OlapPivotGrid,
  unpivotWideRows,
  type OlapFieldDef,
  type OlapPivotGridRef,
} from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import {
  AMOUNT_MEASURES,
  BUCKET_TYPE,
  BUCKET2_TYPE,
  formatByNotation,
  GUBUN,
  MENU_ID,
  PERIOD_COLUMN_REGEX,
  QTY_MEASURES_BIZ,
  QTY_MEASURES_SALES,
  scaleOf,
  SHEETS,
  type Gubun,
} from '../demand-plan-waterfall.constants';
import { useDemandPlanWaterfallStore } from '../useDemandPlanWaterfallStore';

// DMF0035 통합 Waterfall 그리드 — Wijmo OLAP 표준 컴포넌트 (사용자 지시).
//   wide(PIVOT 커서: 고정컬럼 + 기간컬럼) → long 변환 후 PivotEngine 바인딩.
//   rows = TITLE SP 고정컬럼(titleset 'C' 순서) / columns = PERIOD / values = QTY(sum, 소수3).
//   버킷·Sum 토글 = 표시 기간 접두 필터 (AS-IS SetSpreadColumn .cs:1965-2035 / 0051 cs:932-954 대응).
//   환산 콤보 = MEASURE별 나눗셈 Round 2 (AS-IS SetAmountCalculating 실측 — constants 참조).
//   1차 범위(조회 전용) 제한: 3단 헤더 병합·chkColor 회색구간·NOTATION 행 포맷·헤더 더블클릭 드릴은
//   OLAP 계층/포맷으로 대체 — 미대체분은 __asis-mapping__.md §Grid 에 전수 기록.

interface DemandPlanWaterfallGridProps {
  olapRef: MutableRefObject<OlapPivotGridRef | null>;
  /** UM-07 — SubTitle Filter(F4) 가 보는 ref. PivotGrid(FlexGrid 파생) 마운트 시 FlexGridFilter 를 붙여 채운다 */
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  gubun: Gubun;
  data: Record<string, string | number>[];
  tabId: string;
  /** 레일에서 버킷 필드를 Columns 로 옮겼을 때 — 페이지가 UM-08 경계 판정(resetForBucket) 을 담당 */
  onBucketChange?: (prev: string, next: string) => void;
  /**
   * ⭐ [E20260902-PIVOTCOUNT] 피벗 후 행수 통지 — 페이지의 건수 표기(SubTitle dataCount / OlapGridMeta rowCount)가
   *   원천 행수가 아니라 **그리드에 실제로 그려지는 행수**를 쓰도록 한다 (사용자 지시 2026-09-02).
   */
  onPivotRowCountChange?: (rowCount: number) => void;
}

/**
 * 버킷 필드 3종 (사용자 지시 2026-08-28) — 모두 long 행의 PERIOD 에 바인딩되며 **헤더가 키**다. 조회 시 3종을 전부
 * 필드 목록에 등록하고, 선택한 버킷의 필드만 Columns 축에 둔다. 레일에서 다른 버킷 필드를 Columns 로 끌면
 * onLayoutChange → 조회조건 bucket 이 바뀌고 long 행이 그 버킷의 기간 컬럼으로 다시 펼쳐진다.
 */
const BUCKET_FIELD_HEADERS: Record<string, string> = {
  [BUCKET_TYPE.DAILY]: 'DAILY',
  [BUCKET_TYPE.WEEKLY]: 'WEEKLY',
  [BUCKET_TYPE.MONTHLY]: 'MONTHLY',
  [BUCKET2_TYPE.QUARTERLY]: 'QUARTERLY',
  [BUCKET2_TYPE.YEARLY]: 'YEARLY',
};
const bucketFieldsFor = (gubun: Gubun): { code: string; header: string }[] =>
  (gubun === GUBUN.BIZ_PLAN
    ? [BUCKET2_TYPE.MONTHLY, BUCKET2_TYPE.QUARTERLY, BUCKET2_TYPE.YEARLY]
    : [BUCKET_TYPE.DAILY, BUCKET_TYPE.WEEKLY, BUCKET_TYPE.MONTHLY]
  ).map(code => ({ code, header: BUCKET_FIELD_HEADERS[code] }));
/** ONLY_WEEKLY 는 WEEKLY 필드가 대표 (헤더는 2단 Period>Week) */
const bucketHeaderOf = (bucket: string): string =>
  BUCKET_FIELD_HEADERS[bucket === BUCKET_TYPE.ONLY_WEEKLY ? BUCKET_TYPE.WEEKLY : bucket] ?? 'PERIOD';

/** #93 — 헤더 총높이 48px 고정: 1단 48 / 2단 24 / 3단 16 (UM-06) */
const HEADER_TOTAL_PX = 48;

/** ONLY_WEEKLY 2단 열 축 — 상단 = 타이틀 LARGE(MM.DD ~ MM.DD, 주마다 유일 → 병합 없음 1:1) / 하단 = SMALL(Wnn) */
const PERIOD_LARGE = 'PERIOD_LARGE';
const PERIOD_SMALL = 'PERIOD_SMALL';

/** GUBUN×버킷×Sum → 표시할 기간 컬럼 접두 (AS-IS 버킷 토글 규칙 실측 1:1) */
const visiblePrefixes = (gubun: Gubun, bucket: string, sum: boolean): string[] => {
  if (gubun === GUBUN.BIZ_PLAN) {
    if (bucket === BUCKET2_TYPE.YEARLY) return ['Y_'];
    if (bucket === BUCKET2_TYPE.QUARTERLY) return sum ? ['Q_', 'Y_'] : ['Q_'];
    return sum ? ['M_', 'Q_', 'Y_'] : ['M_'];
  }
  if (bucket === BUCKET_TYPE.DAILY) return sum ? ['D_', 'W_', 'M_'] : ['D_'];
  if (bucket === BUCKET_TYPE.WEEKLY || bucket === BUCKET_TYPE.ONLY_WEEKLY)
    return bucket === BUCKET_TYPE.WEEKLY && sum ? ['W_', 'M_'] : ['W_'];
  return ['M_'];
};

/** MEASURE → 나눗셈 배수 (AS-IS SetAmountCalculating 실측 — MKT 는 전 행 QTY 배수 무조건) */
const divisorFor = (
  gubun: Gubun,
  measure: string,
  d: { krw: number; usd: number; loc: number; qty: number }
): number => {
  if (gubun === GUBUN.MKT_FCST) return d.qty;
  if ((AMOUNT_MEASURES.KRW as readonly string[]).includes(measure)) return d.krw;
  if ((AMOUNT_MEASURES.USD as readonly string[]).includes(measure)) return d.usd;
  if ((AMOUNT_MEASURES.LOC as readonly string[]).includes(measure)) return d.loc;
  const qtyMeasures: readonly string[] =
    gubun === GUBUN.BIZ_PLAN ? QTY_MEASURES_BIZ : QTY_MEASURES_SALES;
  if (qtyMeasures.includes(measure)) return d.qty;
  return 1;
};

export const DemandPlanWaterfallGrid = ({
  olapRef,
  gridFilterRef,
  gubun,
  data,
  tabId,
  onBucketChange,
  onPivotRowCountChange,
}: DemandPlanWaterfallGridProps) => {
  const filters = useDemandPlanWaterfallStore(state => state.filters);
  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useDemandPlanWaterfallStore(state => state.setSearchParams);
  const staticColumns = useDemandPlanWaterfallStore(state => state.staticColumns);
  // [E20260831-MEASURE] 표시 메저 선택 (GUBUN 별 — null = 전체)
  const isOnlyWeekly = searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY;

  // GUBUN별 TITLE 시트 3본 — 활성 GUBUN 만 enabled (disabled 쿼리는 유휴)
  const { data: mktTitle } = useTabProcQuery<MENU_ID, SHEETS.MKT_FCST_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MKT_FCST_TITLE,
    tabId,
    filters: filters[SHEETS.MKT_FCST_TITLE],
    enabled: gubun === GUBUN.MKT_FCST && !!filters[SHEETS.MKT_FCST_TITLE],
  });
  const { data: salesTitle } = useTabProcQuery<MENU_ID, SHEETS.SALES_PLAN_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_PLAN_TITLE,
    tabId,
    filters: filters[SHEETS.SALES_PLAN_TITLE],
    enabled: gubun === GUBUN.SALES_PLAN && !!filters[SHEETS.SALES_PLAN_TITLE],
  });
  const { data: bizTitle } = useTabProcQuery<MENU_ID, SHEETS.BIZ_PLAN_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.BIZ_PLAN_TITLE,
    tabId,
    filters: filters[SHEETS.BIZ_PLAN_TITLE],
    enabled: gubun === GUBUN.BIZ_PLAN && !!filters[SHEETS.BIZ_PLAN_TITLE],
  });

  const titleRows = useMemo(
    () =>
      (gubun === GUBUN.MKT_FCST
        ? mktTitle?.o_rc1
        : gubun === GUBUN.SALES_PLAN
          ? salesTitle?.o_rc1
          : bizTitle?.o_rc1) ?? [],
    [gubun, mktTitle?.o_rc1, salesTitle?.o_rc1, bizTitle?.o_rc1]
  );

  // 고정(행 축) 컬럼 — TITLE SP 의 기간 외 컬럼(B_ 숨김/VISIBLE 'N' 제외), SORT_ORDER_NO 순
  const rowFields = useMemo<OlapFieldDef[]>(() => {
    const first = data[0];
    const fields = titleRows
      .slice()
      .sort((a, b) => Number(a.SORT_ORDER_NO ?? 0) - Number(b.SORT_ORDER_NO ?? 0))
      .filter(row => {
        const name = String(row.COLUMN_NAME);
        // VERSION_NO/MEASURE 는 메타상 숨김(VISIBLE 'N')이지만 waterfall 의 핵심 행 축 —
        // AS-IS 강제치환 규약([VERSION_NO]/[MEASURE] 무조건 SELECT) 1:1 로 축에 항상 포함
        const forcedAxis = name === 'VERSION_NO' || name === 'MEASURE';
        return (
          !PERIOD_COLUMN_REGEX.test(name) &&
          !name.startsWith('B_') &&
          (row.VISIBLE_FLAG !== 'N' || forcedAxis) &&
          (!first || name in first)
        );
      })
      .map(row => ({
        binding: String(row.COLUMN_NAME),
        header: String(row.COLUMN_LABEL_NAME || row.COLUMN_NAME),
      }));
    // [E20260831-MEASROW→W45] MEASURE 위치 강제(말미 고정) 해제 (사용자 지시 "메저 COLUMN FIX 해제") —
    //   축 자체는 필수: TITLE SP 에 MEASURE 행이 없어도 데이터에 키가 실재하면 합성해 말미에 추가만 한다
    //   (기존 위치의 MEASURE 는 재배치하지 않음 — 레일 D&D 자유 이동).
    // [E20260831-W39] VERSION_NO 는 말미 고정 유지 (정적 → VERSION → 동적).
    const TAIL_PINNED = ['VERSION_NO'] as const;
    const TAIL_HEADERS: Record<string, string> = { VERSION_NO: 'Version', MEASURE: 'Measure' };
    let ordered = fields;
    for (const pin of TAIL_PINNED) {
      if (!first || !(pin in first)) continue;
      const found = ordered.find(f => f.binding === pin);
      ordered = ordered.filter(f => f.binding !== pin);
      ordered.push(found ?? { binding: pin, header: TAIL_HEADERS[pin] });
    }
    if (first && 'MEASURE' in first && !ordered.some(f => f.binding === 'MEASURE')) {
      ordered = [...ordered, { binding: 'MEASURE', header: TAIL_HEADERS.MEASURE }];
    }
    return ordered;
  }, [titleRows, data]);

  // ⭐ 사용자 지시 2026-08-28 — UI CATEGORY(SHEET_COLUMNS, 사업부 매칭) 전체 컬럼을 필드 후보로 등록하고
  //   Rows 축은 위 rowFields(DEFAULT/titleset = TITLE SP) 만. 데이터에 실재하는 컬럼만(SP [E20260828-ALLCOLS] 가
  //   사업부 VALID 전 컬럼을 반환) — 없는 컬럼을 등록하면 빈 그룹만 생긴다. MEASURE 는 VISIBLE 'N' 이어도 rowFields 강제.
  const extraColumnFields = useMemo<OlapFieldDef[]>(() => {
    const first = data[0];
    const onRows = new Set(rowFields.map(f => f.binding));
    return staticColumns
      .filter(c => {
        const name = c.colNm;
        return (
          !PERIOD_COLUMN_REGEX.test(name) &&
          !name.startsWith('B_') &&
          !onRows.has(name) &&
          (!first || name in first)
        );
      })
      .map(c => ({ binding: c.colNm, header: c.colLblNm || c.colNm }));
  }, [staticColumns, rowFields, data]);

  // 기간 컬럼 라벨 메타 (TITLE SP LARGE/SMALL) — ONLY_WEEKLY 2단 열 축용 (UM-09)
  const periodLabelMap = useMemo(() => {
    const m = new Map<string, { large: string; small: string }>();
    titleRows.forEach(row => {
      const name = String(row.COLUMN_NAME ?? '');
      if (!PERIOD_COLUMN_REGEX.test(name)) return;
      m.set(name, {
        large: String(row.LARGE_CLASS_LABEL_NAME ?? '').trim() || name,
        small: String(row.SMALL_CLASS_LABEL_NAME ?? row.COLUMN_LABEL_NAME ?? '').trim() || name,
      });
    });
    return m;
  }, [titleRows]);

  // wide → long (표시 접두 필터 + 환산 나눗셈 Round 2)
  const longRows = useMemo(() => {
    if (data.length === 0 || rowFields.length === 0) return [];
    // [E20260831-MEASURE→MEASCOUNT] 메저 선택 행 필터는 페이지(visibleData)로 승격 — data 는 이미 필터된 축.
    //   (건수 표시 dataCount/rowCount 와 그리드 행이 같은 원천을 쓰기 위함. MEASURE 행 축은 rowFields 강제 유지.)
    const srcRows = data;
    const prefixes = visiblePrefixes(gubun, searchParams.bucket, searchParams.isSumChecked);
    const periodTest = new RegExp(`^(${prefixes.join('|')})\\d`);
    const keyBindings = rowFields.map(f => f.binding);
    const divisors = {
      krw: Number(searchParams.krw) || 1,
      usd: Number(searchParams.usd) || 1,
      loc: Number(searchParams.loc) || 1,
      qty: Number(searchParams.qty) || 1,
    };
    const rows = unpivotWideRows(srcRows, keyBindings, periodTest, 'PERIOD', 'QTY').map(row => {
      // UM-09 — ONLY_WEEKLY 열 축 2단(LARGE > SMALL) 라벨 동반. 다른 버킷은 PERIOD 단일 축(기존).
      if (!isOnlyWeekly) return row;
      const lbl = periodLabelMap.get(String(row.PERIOD));
      return { ...row, [PERIOD_LARGE]: lbl?.large ?? row.PERIOD, [PERIOD_SMALL]: lbl?.small ?? row.PERIOD };
    });
    if (divisors.krw === 1 && divisors.usd === 1 && divisors.loc === 1 && divisors.qty === 1) {
      return rows;
    }
    return rows.map(row => {
      const measure = row.MEASURE;
      const divisor = divisorFor(
        gubun,
        typeof measure === 'string' ? measure : typeof measure === 'number' ? String(measure) : '',
        divisors
      );
      if (divisor === 1) return row;
      return { ...row, QTY: Math.round((Number(row.QTY) / divisor) * 100) / 100 };
    });
  }, [
    data,
    rowFields,
    gubun,
    isOnlyWeekly,
    periodLabelMap,
    searchParams.bucket,
    searchParams.isSumChecked,
    searchParams.krw,
    searchParams.usd,
    searchParams.loc,
    searchParams.qty,
  ]);

  // UM-09 — ONLY_WEEKLY = AS-IS SetSpreadHeader(.cs:489~521) 3행(월/주차/SUM): 열 축 2단(LARGE 날짜구간 > SMALL 주차,
  //   LARGE 가 주마다 유일해 병합 없이 1:1) + 값 필드 헤더 'SUM' 행(showValueFieldHeaders). 다른 버킷 = 기존 PERIOD 단일 축.
  //   버킷 3종(사용자 지시 2026-08-28): 선택 버킷 필드만 Columns, 나머지는 extraFields 로 등록(레일 드래그 후보).
  const bucketFields = useMemo(() => bucketFieldsFor(gubun), [gubun]);
  const activeBucketHeader = bucketHeaderOf(searchParams.bucket);
  const columnFields = useMemo<OlapFieldDef[]>(
    () =>
      isOnlyWeekly
        ? [
            { binding: PERIOD_LARGE, header: 'Period' },
            { binding: PERIOD_SMALL, header: activeBucketHeader },
          ]
        : [{ binding: 'PERIOD', header: activeBucketHeader }],
    [isOnlyWeekly, activeBucketHeader]
  );
  const extraFields = useMemo<OlapFieldDef[]>(
    () => [
      ...extraColumnFields,
      ...bucketFields
        .filter(b => b.header !== activeBucketHeader)
        .map(b => ({ binding: 'PERIOD', header: b.header })),
    ],
    [extraColumnFields, bucketFields, activeBucketHeader]
  );
  // 레일에서 버킷 필드를 Columns 로 옮김 → 조회조건 bucket 갱신 (UM-08 경계는 페이지 onBucketChange 가 판정)
  const handleLayoutChange = (layout: { columns: string[] }) => {
    const picked = bucketFields.find(b => layout.columns.includes(b.header));
    if (!picked || picked.header === activeBucketHeader) return;
    const prev = searchParams.bucket;
    setSearchParams({ bucket: picked.code });
    onBucketChange?.(prev, picked.code);
  };
  // UM-04 — 값 포맷 = TITLE SP 기간 컬럼 DATA_SCALE_NUMBER (MKT 는 NULL → 0자리, AS-IS decimalPlaces=0).
  //   행별 NOTATION(INTEGER/POINT/POINT3) 은 아래 formatItem 이 우선 적용한다.
  const valueScale = useMemo(() => {
    const first = titleRows.find(r => PERIOD_COLUMN_REGEX.test(String(r.COLUMN_NAME ?? '')));
    return scaleOf(first?.DATA_SCALE_NUMBER as string | number | null | undefined, 0);
  }, [titleRows]);
  const valueFields = useMemo<OlapFieldDef[]>(
    () => [
      {
        binding: 'QTY',
        header: isOnlyWeekly ? 'SUM' : 'Qty',
        format: `n${valueScale}`,
        aggregate: 'Sum',
      },
    ],
    [isOnlyWeekly, valueScale]
  );

  // 행 키 → NOTATION (AS-IS .cs:1199 rNotation — 행 단위 포맷). 피벗 행 아이템은 행 축 필드 **헤더명**으로 키가 잡힌다.
  const notationByKey = useMemo(() => {
    const m = new Map<string, string>();
    if (!data.some(r => 'NOTATION' in r)) return m;
    const keys = rowFields.map(f => f.binding);
    data.forEach(r => {
      const k = keys.map(b => String(r[b] ?? '')).join('');
      const n = String(r.NOTATION ?? '');
      if (n && !m.has(k)) m.set(k, n);
    });
    return m;
  }, [data, rowFields]);
  const notationRef = useRef(notationByKey);
  notationRef.current = notationByKey;
  const rowFieldsRef = useRef(rowFields);
  rowFieldsRef.current = rowFields;

  // ── 피벗 그리드 인스턴스 후처리: UM-06 헤더 높이 / UM-07 FlexGridFilter / UM-04 NOTATION 행 포맷 / UM-09 SUM 헤더 행 ──
  //   PivotGrid 는 데이터가 있어야 마운트되므로 longRows 를 deps 로 다시 시도한다.
  //   PivotGrid 인스턴스는 조회 후 마운트되므로 onGridInit 로 받아 state 에 두고 deps 로 쓴다(ref 만 보면 마운트 전 빈손).
  const [pivotGrid, setPivotGrid] = useState<unknown>(null);
  useEffect(() => {
    const g = (pivotGrid ?? olapRef.current?.grid) as
      | (FlexGrid & { showValueFieldHeaders?: boolean })
      | null
      | undefined;
    // 조회 결과가 비면(bucket 경계 전환 등) PivotGrid 가 언마운트되고 인스턴스는 dispose 된다 — columnHeaders 가 null
    if (!g || !g.hostElement || !g.columnHeaders) return;
    // UM-09 — ONLY_WEEKLY 는 3행째 'SUM' 값 헤더를 보인다 (AS-IS row2 "SUM")
    g.showValueFieldHeaders = isOnlyWeekly;
    // UM-06 (#93) — 헤더 총 48px: 열 축 단수(+값 헤더 행) 로 나눠 1단 48 / 2단 24 / 3단 16
    const tiers = columnFields.length + (isOnlyWeekly ? 1 : 0);
    const rowH = Math.floor(HEADER_TOTAL_PX / Math.max(1, tiers));
    const applyHeaderHeight = () => {
      if (!g.columnHeaders) return; // dispose 후 늦게 오는 layout 이벤트 방어
      const rows = g.columnHeaders.rows;
      if (Math.round(rows.defaultSize) !== rowH) rows.defaultSize = rowH;
      // wijmo 는 뷰 갱신 때 헤더 row 에 명시 height 를 넣기도 하므로(#93 DataGrid 계보) row 단위로도 강제
      for (let i = 0; i < rows.length; i += 1) {
        if (Math.round(rows[i].height ?? rows.defaultSize) !== rowH) rows[i].height = rowH;
      }
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    // UM-07 — FlexGridFilter 1회 부착 (PivotGrid 는 FlexGrid 파생. 필터는 피벗 뷰(CollectionView) 에 걸린다)
    if (gridFilterRef && (!gridFilterRef.current || gridFilterRef.current.grid !== g)) {
      gridFilterRef.current = new FlexGridFilter(g);
      // [E20260831-NOFILTERICON] 동적(기간) 컬럼 헤더의 깔때기 아이콘 숨김 (사용자 지시 2026-08-31).
      //   피벗 필터 축은 레일 Filters 영역(F4=레일 열기, C4 FilterEditorPopover)이 담당 —
      //   FlexGridFilter 객체는 남겨 F4/컨텍스트 경로는 유지하되 헤더 아이콘만 끈다.
      gridFilterRef.current.showFilterIcons = false;
    }
    // UM-04 — 행별 NOTATION 포맷 (INTEGER/POINT/POINT3) — 총계 행·NOTATION 없는 행은 컬럼 기본 포맷 유지
    const handler = (
      sender: FlexGrid,
      e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const item = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!item) return;
      const cellStr = (v: unknown): string =>
        typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
      const key = rowFieldsRef.current
        .map(f => cellStr(item[f.header ?? f.binding] ?? item[f.binding]))
        .join('');
      const notation = notationRef.current.get(key);
      if (!notation) return;
      const n = toGridNumber(e.panel.getCellData(e.row, e.col, false));
      if (n === null) return;
      const text = formatByNotation(n, notation);
      if (text !== null) e.cell.textContent = text;
    };
    g.formatItem.addHandler(handler);
    return () => {
      g.formatItem.removeHandler(handler);
      g.updatedLayout.removeHandler(applyHeaderHeight);
    };
  }, [olapRef, pivotGrid, gridFilterRef, longRows, columnFields, isOnlyWeekly]);

  // 데이터 0행 fallback — OLAP 은 데이터 없으면 헤더도 그리지 않으므로(빈 화면),
  // TITLE SP 기반 컬럼 헤더만이라도 표준 DataGrid 로 표시 (AS-IS InitSpread 후 빈 그리드와 동일 UX)
  const placeholderColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    if (titleRows.length === 0) return [];
    const prefixes = visiblePrefixes(gubun, searchParams.bucket, searchParams.isSumChecked);
    return titleRows
      .slice()
      .sort((a, b) => Number(a.SORT_ORDER_NO ?? 0) - Number(b.SORT_ORDER_NO ?? 0))
      .filter(row => {
        const name = String(row.COLUMN_NAME);
        if (name.startsWith('B_') || row.VISIBLE_FLAG === 'N') return false;
        if (PERIOD_COLUMN_REGEX.test(name)) return prefixes.some(p => name.startsWith(p));
        return true;
      })
      .map(row => ({
        colNm: String(row.COLUMN_NAME),
        colLblNm: String(row.COLUMN_LABEL_NAME || row.COLUMN_NAME),
        colWth: row.COLUMN_WIDTH ? Number(row.COLUMN_WIDTH) : undefined,
        visible: true,
        display: true,
      })) as RawFlexGridColumnConfig[];
  }, [titleRows, gubun, searchParams.bucket, searchParams.isSumChecked]);

  if (longRows.length === 0) {
    return (
      <DataGrid<Record<string, string | number>>
        itemsSource={[]}
        staticColumns={placeholderColumns}
        autoGenerateColumns={false}
      />
    );
  }

  return (
    <OlapPivotGrid
      ref={olapRef}
      itemsSource={longRows}
      rowFields={rowFields}
      columnFields={columnFields}
      valueFields={valueFields}
      extraFields={extraFields}
      onLayoutChange={handleLayoutChange}
      onGridInit={setPivotGrid}
      // ⭐ [E20260902-PIVOTCOUNT] 건수 표기를 **피벗 후 행수**로 (사용자 지시 2026-09-02)
      onPivotRowCountChange={onPivotRowCountChange}
      // Subtotal 표기 = Layout 모달 드롭다운 (기본 GrandTotals — AS-IS footer SUM 대응)
      showRowTotals={searchParams.rowTotals}
      showColumnTotals='None'
      // 컬럼 폭 자동 최적화 (사용자 지정 2026-08-20 — 행 축=내용 autosize·값 컬럼=64~160 캡)
      autoFitColumns
    />
  );
};
