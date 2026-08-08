import type { MutableRefObject } from 'react';
import { useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
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
  GUBUN,
  MENU_ID,
  PERIOD_COLUMN_REGEX,
  QTY_MEASURES_BIZ,
  QTY_MEASURES_SALES,
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
  gubun: Gubun;
  data: Record<string, string | number>[];
  tabId: string;
}

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
  gubun,
  data,
  tabId,
}: DemandPlanWaterfallGridProps) => {
  const filters = useDemandPlanWaterfallStore(state => state.filters);
  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);

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
    return titleRows
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
  }, [titleRows, data]);

  // wide → long (표시 접두 필터 + 환산 나눗셈 Round 2)
  const longRows = useMemo(() => {
    if (data.length === 0 || rowFields.length === 0) return [];
    const prefixes = visiblePrefixes(gubun, searchParams.bucket, searchParams.isSumChecked);
    const periodTest = new RegExp(`^(${prefixes.join('|')})\\d`);
    const keyBindings = rowFields.map(f => f.binding);
    const divisors = {
      krw: Number(searchParams.krw) || 1,
      usd: Number(searchParams.usd) || 1,
      loc: Number(searchParams.loc) || 1,
      qty: Number(searchParams.qty) || 1,
    };
    const rows = unpivotWideRows(data, keyBindings, periodTest, 'PERIOD', 'QTY');
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
    searchParams.bucket,
    searchParams.isSumChecked,
    searchParams.krw,
    searchParams.usd,
    searchParams.loc,
    searchParams.qty,
  ]);

  const columnFields = useMemo<OlapFieldDef[]>(() => [{ binding: 'PERIOD', header: 'Period' }], []);
  const valueFields = useMemo<OlapFieldDef[]>(
    () => [{ binding: 'QTY', header: 'Qty', format: 'n3', aggregate: 'Sum' }],
    []
  );

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
      // Subtotal 표기 = Layout 모달 드롭다운 (기본 GrandTotals — AS-IS footer SUM 대응)
      showRowTotals={searchParams.rowTotals}
      showColumnTotals='None'
    />
  );
};
