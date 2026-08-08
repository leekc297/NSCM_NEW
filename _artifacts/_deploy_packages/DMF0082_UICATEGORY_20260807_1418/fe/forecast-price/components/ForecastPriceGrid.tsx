import type { GridPanel } from '@mescius/wijmo.grid';
import {
  type FlexGrid,
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  SelectionMode,
} from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { ComboResponse, FlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager, EditTracker, isNonEditableDateColumn } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { AUTH_MEASURES } from '../forecast-price.constants';
import type { ForecastPriceRow, SpreadTitleRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';
import { thisWeekMondayYmd } from '../utils/forecast-price.editLock';

dayjs.extend(isoWeek);

/** 동적 컬럼 헤더 머지 키 — dynamicColumns 의 그룹 구성(ym / sub)과 **동일 규칙**. */
interface HeaderKey {
  ym: string; // 1단 = 년월 (binding[2..8])
  sub: string; // 2단 = 주차 그룹 (SPREAD_TITLE small, M_ 는 'SUM')
}

// ⭐ 동적 헤더 머지 — mkt-fcst `HierarchicalMergeManager` 규약 이식 (정본).
//   [문제] 공용 `CustomMergeManager._getColumnHeaderMergedRange` 는 **셀 라벨이 같으면** 붙인다.
//     동적 leaf 헤더는 W_·M_ 모두 리터럴 'SUM' 이라(dynamicColumns header 참조, mkt-fcst L492 동일)
//     leaf 행의 SUM 들이 **가로로 한 덩어리**가 되고, M_ 는 세로 가드(_isSameHorizontalRange) 실패로
//     'SUM' 이 두 줄로 쌓인다.
//   [해결] 라벨이 아니라 **binding 파생 키**로 머지 (mkt-fcst 와 동일한 접근).
//   ⚠️ 회귀 방지 — 2026-07-22 사고: TopLeft 를 전 범위 머지했다가 헤더 더블클릭 드릴다운이 죽었다.
//     ⇒ **ColumnHeader 만** 재정의하고 TopLeft·Cell 은 super(기존 CustomMergeManager) 그대로 위임한다.
//     드릴다운은 `hitTest` 의 ColumnHeader 좌표에 의존하는데, 2단 머지 원점이 W_ 컬럼으로 유지되므로
//     (dynamicColumns 가 그룹 내 kindRank M<W<D 순 정렬 → W_ 가 D_ 보다 앞) 기존 동작과 동일하다.
class FcstHeaderMergeManager extends CustomMergeManager<ForecastPriceRow> {
  constructor(
    grid: FlexGrid<ForecastPriceRow>,
    private readonly getKeys: () => Map<string, HeaderKey>
  ) {
    super(grid);
  }

  getMergedRange(panel: GridPanel, r: number, c: number): CellRange | null {
    // TopLeft / Cell = 기존 동작 유지 (회귀 0)
    if (panel.cellType !== CellType.ColumnHeader) return super.getMergedRange(panel, r, c);

    const keys = this.getKeys();
    const bindingAt = (i: number): string => panel.columns[i]?.binding ?? '';
    const b = bindingAt(c);
    // 정적 컬럼 등 동적 대상이 아니면 기존 값기반 머지 유지 (헤더 세로 span 보존)
    if (!keys.has(b)) return super.getMergedRange(panel, r, c);

    const leafRow = panel.rows.length - 1;

    // M_(월 SUM) — 1단 아래 전 행 세로 병합. 2·3단 라벨이 모두 'SUM' 이라 한 칸으로 보여야 한다.
    if (b.startsWith('M_') && r >= 1) {
      return leafRow <= 1 ? null : new CellRange(1, c, leafRow, c);
    }
    // leaf 행('SUM' / 일자) — 가로 병합 금지 (라벨 동일로 인한 오병합 차단)
    if (r === leafRow) return null;

    const keyOf = (i: number): string => {
      const k = keys.get(bindingAt(i));
      if (!k) return '\0';
      return r === 0 ? k.ym : `${k.ym}|${k.sub}`;
    };
    const key = keyOf(c);
    let c1 = c;
    let c2 = c;
    while (c1 > 0 && keyOf(c1 - 1) === key) c1--;
    while (c2 < panel.columns.length - 1 && keyOf(c2 + 1) === key) c2++;
    return c1 === c2 ? null : new CellRange(r, c1, r, c2);
  }
}
// #10 중복체크 대상 키 8종 (AS-IS spdMain_Changed :5897~5946 — Insert 행 간 완전일치 판정).
const DUP_KEY_COLS = [
  'END_CUSTOMER',
  'SCM_SITE_ID',
  'ITEM_ID',
  'DOM_EXP',
  'FCST_TYPE',
  'INCOTERMS',
  'MEASURE',
  'CELL_PROD_SITE_ID',
] as const;

import {
  allocateLoc,
  divideByDate,
  divideByMonth,
  divideByWeek,
  isNonEditableCell,
  toNumber,
  type CalendarInfo,
} from './ForecastPriceGridUtils';

interface ForecastPriceGridProps {
  gridRef: MutableRefObject<FlexGrid<ForecastPriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ForecastPriceRow[];
  spreadTitle: SpreadTitleRow[];
  editTrackerRef: MutableRefObject<EditTracker | null>;
  // #10 — Insert 행 키 중복(MSG00260) 발생 시 페이지 alert 호출.
  onDuplicateKey?: () => void;
}

interface DynColMeta {
  binding: string;
  kind: 'M' | 'W' | 'D';
  large: string; // 1단 = 년월 (LARGE_CLASS_LABEL_NAME)
  small: string; // 2단 = 주차 (SMALL_CLASS_LABEL_NAME)
  leaf: string; // 3단 = 일자 (COLUMN_LABEL_NAME)
  sort: number;
}

const kindOf = (b: string): 'M' | 'W' | 'D' | null =>
  /^M_\d{6}$/.test(b) ? 'M' : /^W_\d{7,10}$/.test(b) ? 'W' : /^D_\d{8}$/.test(b) ? 'D' : null;

// 표시 rank (M=0 상위 합계 … D=2 하위 상세). 활성 bucket = 데이터에 존재하는 최정밀 kind(max rank).
//   상위(rank<활성) = SUM 합계 컬럼 → chkSum(sumYn) 으로 표시 토글 (AS-IS chkSum / mkt-fcst 패턴 #92).
const DYN_RANK = { M: 0, W: 1, D: 2 } as const;

// ⭐ DMF0082 메인 그리드 — AS-IS spdMain(FCST 행 + PRICE 행 병렬 단일 시트) 1:1.
//   동적 시간축 = DMF0082_GET_SPREAD_TITLE (월>주>일 3단, mkt-fcst 패턴 이식) /
//   편집 = 권한 4분기(measureAuth, GET drop3) × 행 EDIT_FLAG × bucket × 기준주차 이전 잠금 /
//   배분 = 월간→주간→일별 자동 (ForecastPriceGridUtils — AS-IS EditChange 분배 로직).
export const ForecastPriceGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
  editTrackerRef,
  onDuplicateKey,
}: ForecastPriceGridProps) => {
  const monthMap = useRef<Map<string, Set<string>>>(new Map());
  const weekMap = useRef<Map<string, Set<string>>>(new Map());
  const bucketRef = useRef<string>('W');

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const measureAuthRef = useRef(measureAuth);
  measureAuthRef.current = measureAuth;

  // ⭐ 배분 캘린더(drop4, #1) / M+3 기준월(drop1, #4) — 핸들러가 재구독 없이 최신 참조 (measureAuth 패턴).
  const calendar = useForecastPriceStore(state => state.calendar);
  const m3CutoffYyyymm = useForecastPriceStore(state => state.m3CutoffYyyymm);
  const calendarMapRef = useRef<Map<string, CalendarInfo>>(new Map());
  calendarMapRef.current = useMemo(() => new Map(Object.entries(calendar)), [calendar]);
  const m3CutoffRef = useRef(m3CutoffYyyymm);
  m3CutoffRef.current = m3CutoffYyyymm;
  const onDuplicateKeyRef = useRef(onDuplicateKey);
  onDuplicateKeyRef.current = onDuplicateKey;
  const bucketTypeParam = searchParams.bucketType;
  const bucketTypeParamRef = useRef(bucketTypeParam);
  bucketTypeParamRef.current = bucketTypeParam;

  // ⭐ #7 Insert 행 편집가능 Measure 콤보 캐스케이드 (hook #59 §5-G / AS-IS L5839) —
  //   Site 변경 시 FcstPriceEditMeasure(div/site/bucket) 조회해 행별 후보 캐시 → MEASURE 편집 진입 시
  //   컬럼 dataMap 스왑(편집 후보=편집가능 measure), 편집 종료 시 원 dataMap(전체 표시용) 원복.
  const editMeasuresRef = useRef<WeakMap<object, ComboResponse[]>>(new WeakMap());
  const measureOrigDataMapRef = useRef<DataMap | null>(null);

  // #12 당주(현재 기간) binding 집합 — 활성 버킷의 당월(M_)/당주(W_)/금주월요일(D_) 녹색 보더.
  const currentPeriodRef = useRef<Set<string>>(new Set());
  currentPeriodRef.current = useMemo(() => {
    const ym = dayjs().format('YYYYMM');
    const wk = String(dayjs().isoWeek()).padStart(2, '0');
    return new Set([`M_${ym}`, `W_${ym}${wk}`, `D_${thisWeekMondayYmd()}`]);
  }, []);

  // ── 동적 컬럼 메타 (SPREAD_TITLE 우선 / 0건 시 data row 키 union fallback — mkt-fcst 패턴) ──
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    const titleRows = (spreadTitle ?? []).filter(r => !!kindOf(String(r.COLUMN_NAME ?? '')));
    if (titleRows.length > 0) {
      return titleRows
        .map<DynColMeta>(r => ({
          binding: String(r.COLUMN_NAME),
          kind: kindOf(String(r.COLUMN_NAME)) as DynColMeta['kind'],
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          sort: Number(r.SORT_ORDER_NO ?? 0),
        }))
        .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));
    }
    if (!data || data.length === 0) return [];
    const set = new Set<string>();
    for (const r of data) {
      for (const k of Object.keys(r)) {
        if (kindOf(k)) set.add(k);
      }
    }
    return [...set].sort().map<DynColMeta>(b => ({
      binding: b,
      kind: kindOf(b) as DynColMeta['kind'],
      large: `${b.slice(2, 6)}-${b.slice(6, 8)}`,
      small: '',
      leaf: b.slice(8),
      sort: 0,
    }));
  }, [spreadTitle, data]);

  // ── 활성 bucket / 요약(상위 합계) / 드릴(하위 상세) 분류 (#93 height / #92 sum + 드릴다운, mkt-fcst 패턴) ──
  //   활성 = 조회 bucketType (데이터 최정밀 아님 — Weekly 조회 시 D_ 존재해도 활성=W).
  //   상위(rank<활성) = SUM 합계 → chkSum(sumYn) 토글 / 하위(rank>활성) = 기본 숨김 → 헤더 더블클릭 드릴.
  //   tierH = 3단(D 존재)16 / 2단 24 (총 48px 고정, #93).
  const bucketPrefix = (searchParams.bucketType || 'W').trim().charAt(0).toUpperCase() as
    | 'M'
    | 'W'
    | 'D';
  const { hasDaily, tierH, summaryBindings, drillBindings, dynBindings } = useMemo(() => {
    const daily = dynColMetas.some(m => m.kind === 'D');
    const active = DYN_RANK[bucketPrefix] ?? DYN_RANK.W;
    return {
      hasDaily: daily,
      tierH: daily ? 16 : 24,
      summaryBindings: dynColMetas.filter(m => DYN_RANK[m.kind] < active).map(m => m.binding),
      drillBindings: dynColMetas.filter(m => DYN_RANK[m.kind] > active).map(m => m.binding),
      dynBindings: dynColMetas.map(m => m.binding),
    };
  }, [dynColMetas, bucketPrefix]);
  // 드릴 오버라이드(binding→visible) — bucket/sum/조회 변경 시 리셋 (AS-IS SetSpreadColumn 재실행).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  // ── monthMap(M_→W_ set) / weekMap(W_→D_ set) — 배분 로직 입력 (SPREAD_TITLE 관계 기반) ──
  useEffect(() => {
    const mm = new Map<string, Set<string>>();
    const wm = new Map<string, Set<string>>();
    // 주차 키: 같은 (large, small) 조합의 W_ binding. D_ 는 자신의 (large, small) 주차에 소속.
    const weekBySub = new Map<string, string>(); // `${large}|${small}` → W_ binding
    dynColMetas.forEach(m => {
      if (m.kind === 'W') weekBySub.set(`${m.large}|${m.small}`, m.binding);
    });
    dynColMetas.forEach(m => {
      if (m.kind === 'D') {
        const wk = weekBySub.get(`${m.large}|${m.small}`);
        if (wk) {
          if (!wm.has(wk)) wm.set(wk, new Set());
          wm.get(wk)?.add(m.binding);
        }
      } else if (m.kind === 'W') {
        const month = `M_${m.binding.slice(2, 8)}`;
        if (!mm.has(month)) mm.set(month, new Set());
        mm.get(month)?.add(m.binding);
      }
    });
    monthMap.current = mm;
    weekMap.current = wm;
  }, [dynColMetas]);

  // ── 동적 컬럼 3단 nested (mkt-fcst 패턴 — 년월 → 주차/SUM → 일자. #93 height 명시) ──
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    // ⭐ 헤더 단수 동적 (#93 캐노니컬 + Figma DMF0082 Table 실측 정합):
    //   D_ 존재(Daily 조회) = 3단(년월>주차>일, 각 16px) / D_ 부재(W/M 조회) = 2단(년월>주차, 각 24px
    //   — Figma Table 프레임 실측 24+24=48 과 일치). hasDaily/tierH = 컴포넌트 스코프 파생.
    const largeMap = new Map<
      string,
      { label: string; subs: Map<string, LeafCol[]>; order: number }
    >();
    const kindRank = { M: 0, W: 1, D: 2 } as const;
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        // 3단 leaf = 일자('06') / 2단 leaf = 주차 라벨('W28') 또는 월 'SUM'
        header: hasDaily ? (m.kind === 'D' ? m.leaf || 'SUM' : 'SUM') : subKey,
        align: 'right',
        width: 90,
        allowDragging: true,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        height: tierH,
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? -1 : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): 'M' | 'W' | 'D' => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        height: tierH,
        allowSorting: false,
        allowMerging: false,
        columns: hasDaily
          ? [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .map(([subLabel, leafCols]) => ({
                header: subLabel,
                align: 'center',
                height: tierH,
                allowSorting: false,
                allowMerging: false,
                columns: leafCols.sort(
                  (a, b) =>
                    kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                    a.binding.localeCompare(b.binding)
                ),
              }))
          : // 2단 — 주차/SUM 컬럼을 직접 leaf 로 (Figma Table 실측 구조)
            [...bucket.subs.entries()]
              .sort(([a], [b]) => subOrder(a) - subOrder(b))
              .flatMap(([, leafCols]) =>
                leafCols.sort((a, b) => a.binding.localeCompare(b.binding))
              ),
      }));
  }, [dynColMetas, hasDaily, tierH]);

  const staticBindingSet = useMemo(() => new Set(staticColumns.map(c => c.colNm)), [staticColumns]);

  // ⭐ 컬럼 개인화 색 (ColumnLayoutModal 저장값) — binding → {cell, text}.
  //   공용 columnMapping 은 colWth/visible 만 넘기고 색은 안 넘기므로 formatItem 이 직접 적용한다
  //   (DMF0020 SalesFuturePriceGrid 선례 동일). ref 로 최신 맵 전달 — 핸들러 재등록 불필요.
  const colorMetaRef = useRef<Map<string, { cell: string; text: string }>>(new Map());
  colorMetaRef.current = useMemo(() => {
    const m = new Map<string, { cell: string; text: string }>();
    staticColumns.forEach(c => {
      if (c.cellColor || c.textColor) {
        m.set(c.colNm, { cell: c.cellColor ?? '', text: c.textColor ?? '' });
      }
    });
    return m;
  }, [staticColumns]);

  // ⭐ 헤더 머지 키 — dynamicColumns 의 그룹 구성(ymKey / subKey)과 **동일 규칙**으로 산출.
  //   (같은 규칙을 써야 머지 범위 = 실제 헤더 그룹 구조. 별도 파생 시 그룹 경계를 넘어 붙는다.)
  const headerKeyMap = useMemo<Map<string, HeaderKey>>(() => {
    const m = new Map<string, HeaderKey>();
    dynColMetas.forEach((d: DynColMeta) => {
      m.set(d.binding, {
        ym: d.binding.slice(2, 8),
        sub: d.kind === 'M' ? 'SUM' : (d.small || 'SUM').trim() || 'SUM',
      });
    });
    return m;
  }, [dynColMetas]);
  // 매니저는 1회만 생성(super 가 grid 이벤트를 바인딩하므로 재생성 시 핸들러 누적) → ref 로 최신 맵 전달.
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;

  // ⭐ 동적 헤더 머지 매니저 설치 (ColumnHeader 만 재정의 — TopLeft·Cell 은 super 위임).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.mergeManager instanceof FcstHeaderMergeManager) return;
    g.mergeManager = new FcstHeaderMergeManager(g, () => headerKeyRef.current);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  useEffect(() => {
    bucketRef.current = searchParams.bucketType;
  }, [searchParams.bucketType]);

  // ── grid 핸들러 등록 (useEffect + gridRef, deps=[staticColumns, dynamicColumns], cleanup 의무) ──
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    editTrackerRef.current = new EditTracker(g as FlexGrid);
    if (!gridFilterRef.current) {
      // 동적(M_/W_/D_) 컬럼은 필터 제외 — 정적 컬럼만 필터 대상.
      gridFilterRef.current = new FlexGridFilter(g as FlexGrid, {
        filterColumns: staticColumns.map(c => c.colNm ?? '').filter(Boolean),
      });
    }

    // 편집 가능 판정 — AS-IS 권한 4분기(bEDIT_AUTH_*, GET drop3) + GridUtils 공통 판정.
    const canEditCell = (binding: string, dataItem: WijmoRowItem): boolean => {
      const measure = dataItem['MEASURE'];
      if (typeof measure !== 'string') return false;
      // 권한 대상 measure(4종) 외 = 항상 read-only / 대상인데 그룹권한 N = 차단.
      if (!(AUTH_MEASURES as readonly string[]).includes(measure)) return false;
      if (measureAuthRef.current[measure] === false) return false;
      const bucketName =
        bucketRef.current === 'M' ? 'Monthly' : bucketRef.current === 'D' ? 'Daily' : 'Weekly';
      return !isNonEditableCell(
        g as FlexGrid,
        binding,
        dataItem,
        weekMap.current,
        bucketName,
        m3CutoffRef.current
      );
    };

    const cellEditableHandler = (
      sender: FlexGrid,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) {
        e.cancel = true;
        return;
      }
      if (staticBindingSet.has(binding)) {
        // 정적 컬럼: Insert 행(CRUD_TYPE 존재)만 편집 (AS-IS: 기존 행 키 컬럼 잠금)
        const isInsert = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
        if (!isInsert) {
          e.cancel = true;
          return;
        }
        // #7 — MEASURE 편집 진입: 행별 편집가능 후보로 컬럼 dataMap 스왑 (원본은 1회만 백업 → 편집 종료 시 원복).
        if (binding === 'MEASURE') {
          const candidates = editMeasuresRef.current.get(dataItem);
          const col = sender.columns[e.col];
          if (candidates && candidates.length > 0 && col) {
            if (!measureOrigDataMapRef.current)
              measureOrigDataMapRef.current = col.dataMap as DataMap;
            col.dataMap = new DataMap(candidates as unknown[], 'CODE', 'NAME');
          }
        }
        return;
      }
      if (kindOf(binding) && !canEditCell(binding, dataItem)) e.cancel = true;
    };

    // ⭐ #2 SALES_BUCKET 캐스케이드 (AS-IS L5862~5874) — Insert 행에서 Sales Site / Incoterms 변경 시
    //   배분 요일비트(SUN-first 7자리)를 조회해 행 BUCKET 에 세팅. 결과 없으면 '' → 배분은 기본요일 적용.
    //   (BUCKET 은 divideBy*/allocateLoc 가 다음 수량 편집 때 읽음 — AS-IS 도 세팅만.)
    const applySalesBucket = (dataItem: WijmoRowItem) => {
      const div = String(dataItem['DIVISION_ID'] ?? '');
      const site = String(dataItem['SCM_SITE_ID'] ?? '');
      const inco = String(dataItem['INCOTERMS'] ?? '');
      if (!div || !site || !inco) return; // 세 값 모두 있어야 조회 (AS-IS: div·site 채워졌을 때)
      void apiClient
        .getCombo({ comboId: 'SalesBucket', divisionId: div, scmSiteId: site, incoterms: inco })
        .then(rows => {
          const bucket = rows?.[0]?.CODE ?? '';
          // '0000000'(매칭 0건 PIVOT) = 미설정 취급 → 기본요일 배분 (AS-IS '' 동작).
          dataItem['BUCKET'] = bucket && bucket !== '0000000' ? bucket : '';
        })
        .catch(() => {
          /* 룩업 미배선/오류 시 무시 → 기본요일 배분 유지 */
        });
    };

    // #7 — Insert 행 Site 변경 시 편집가능 Measure 후보 재조회 → 행별 캐시 (MEASURE 편집 진입 시 사용).
    const applyEditMeasures = (dataItem: WijmoRowItem) => {
      const div = String(dataItem['DIVISION_ID'] ?? '');
      const site = String(dataItem['SCM_SITE_ID'] ?? '');
      if (!div || !site) return;
      void apiClient
        .getCombo({
          comboId: 'FcstPriceEditMeasure',
          divisionId: div,
          scmSiteId: site,
          bucketType: bucketTypeParamRef.current,
        })
        .then(rows => editMeasuresRef.current.set(dataItem, rows ?? []))
        .catch(() => {
          /* 룩업 오류 시 캐시 미설정 → 편집 진입 시 전체 Measure 콤보 유지 */
        });
    };

    // 편집 종료 — 월/주/일 배분 (AS-IS spdMain_EditChange 분배 로직 1:1, GridUtils 재사용).
    const cellEditHandler = (sender: FlexGrid, e: { row: number; col: number; data?: unknown }) => {
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;
      // #7 — MEASURE 편집 종료: 스왑했던 dataMap 을 원본(전체 표시용)으로 원복 (취소 포함 커버).
      if (binding === 'MEASURE' && measureOrigDataMapRef.current) {
        const col = sender.columns[e.col];
        if (col) col.dataMap = measureOrigDataMapRef.current;
      }
      const isInsertRow = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
      // #2 — Insert 행 Site/Incoterms 변경 → SALES_BUCKET 조회·세팅 (배분 요일 원천).
      //   #7 — Site 변경 시 편집가능 Measure 후보도 재조회(행별 캐시).
      if ((binding === 'SCM_SITE_ID' || binding === 'INCOTERMS') && isInsertRow) {
        applySalesBucket(dataItem);
        if (binding === 'SCM_SITE_ID') applyEditMeasures(dataItem);
      }
      // #10 — Insert 행 키 8종 변경 시 실시간 중복 검사 (AS-IS MSG00260 :5878). 중복이면 값 롤백 + alert.
      if (isInsertRow && (DUP_KEY_COLS as readonly string[]).includes(binding)) {
        const keyOf = (r: WijmoRowItem) => DUP_KEY_COLS.map(c => String(r[c] ?? '')).join('');
        const full = DUP_KEY_COLS.every(c => String(dataItem[c] ?? '') !== '');
        if (full) {
          const myKey = keyOf(dataItem);
          let dup = 0;
          for (let r = 0; r < sender.rows.length; r++) {
            const ri = sender.rows[r]?.dataItem as WijmoRowItem | undefined;
            if (
              ri &&
              ri['CRUD_TYPE'] !== undefined &&
              ri['CRUD_TYPE'] !== null &&
              keyOf(ri) === myKey
            )
              dup += 1;
          }
          if (dup >= 2) {
            sender.setCellData(e.row, e.col, (e.data ?? '') as WijmoPrimitive); // 롤백
            onDuplicateKeyRef.current?.();
          }
        }
      }
      if (!kindOf(binding)) return;
      let val = sender.getCellData(e.row, e.col, false) as WijmoPrimitive;
      const oldVal = (e.data ?? null) as WijmoPrimitive;
      if (
        (oldVal === undefined || oldVal === null) &&
        (val === undefined || val === null || val === '')
      )
        return;
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      const measure = dataItem['MEASURE'];
      // #14 — Daily 버킷 D_ 직접 입력 시 FCST 3종은 정수 절삭 (AS-IS :6094~6103).
      if (
        binding.startsWith('D_') &&
        (measure === 'MKT_FCST' || measure === 'SCM_FCST' || measure === 'VMI_In_Req')
      ) {
        const truncated = Math.trunc(toNumber(val));
        if (truncated !== toNumber(val)) {
          val = truncated;
          sender.setCellData(e.row, e.col, truncated);
        }
      }
      // 배분 대상 = MKT_FCST/SCM_FCST 만 (AS-IS L498 실측). LOC=일괄할당. VMI_In_Req=단일 셀(배분 없음).
      if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
        if (binding.startsWith('M_'))
          divideByMonth(
            binding,
            dataItem,
            val,
            monthMap.current,
            weekMap.current,
            calendarMapRef.current,
            tracker
          );
        else if (binding.startsWith('W_'))
          divideByWeek(binding, dataItem, val, oldVal, weekMap.current, tracker);
        else if (binding.startsWith('D_')) divideByDate(binding, dataItem, val, oldVal, tracker);
      } else if (measure === 'LOC') {
        allocateLoc(binding, dataItem, val, monthMap.current, weekMap.current, tracker);
      } else {
        tracker.storeChange(dataItem, binding, oldVal, val);
      }
      sender.invalidate();
    };

    // 셀 표시 (#95 3색 표준 — 편집가능 Yellow / 기준주차 이전 잠금 Gray / 기본 White+zebra)
    //   + #108 No. 코너 헤더 (TopLeft 전체 단일 머지 + 'No.' 라벨, 재귀 가드).
    const formatHandler = (
      sender: FlexGrid,
      e: {
        panel: { cellType: CellType; rows: unknown };
        row: number;
        col: number;
        cell: HTMLElement;
      }
    ) => {
      if (e.panel.cellType === CellType.TopLeft) {
        // 코너 헤더 — row-header 첫 컬럼(번호)에만 'No.' 표시, 나머지(편집 그리드의 CRUD 상태 컬럼)는 공백.
        //   편집 그리드는 rowHeaders 2컬럼이라 전 셀에 'No.' 를 찍으면 'No. No.' 로 보였다(#108).
        //   Exchange Rate(읽기전용=1컬럼) 팝업처럼 코너에 'No.' 하나만 보이도록 한다.
        const label = e.col === 0 ? 'No.' : '';
        if (e.cell.textContent !== label) e.cell.textContent = label;
        e.cell.style.textAlign = 'center';
        e.cell.style.verticalAlign = 'middle';
        return;
      }
      // ⭐ 당월·당주 헤더 초록 볼드 — **AS-IS 화면 캡처 기준** (사용자 확정 2026-07-22).
      //   AS-IS 는 초록을 **헤더에만** 쓴다: 1단(년월)=당월 / 하위단=당주 **W_ 컬럼만**
      //   (그 아래 leaf 'SUM' 은 같은 W_ binding 이라 함께 초록). 본문 셀에는 초록을 칠하지 않는다.
      //   ⚠️ M_(당월 SUM)·D_ 는 제외 — 포함 시 초록이 4곳으로 번져 AS-IS 와 달라진다.
      if (e.panel.cellType === CellType.ColumnHeader) {
        const hb = sender.columns[e.col]?.binding ?? '';
        if (!kindOf(hb)) return;
        // 주말 일자 헤더 색 — 토요일 파랑 / 일요일 빨강 (D_ leaf 헤더 한정, 사용자 요구 2026-07-22).
        //   D_ 는 3단 leaf(일자)에서만 자기 라벨이 보인다(상위 row 는 월/주 머지에 덮임) → leaf row 한정.
        const leafRow = sender.columnHeaders.rows.length - 1;
        if (hb.startsWith('D_') && e.row === leafRow) {
          const ymd = hb.slice(2); // YYYYMMDD
          const dow = dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`).day();
          if (dow === 6)
            e.cell.style.color = '#1565c0'; // 토
          else if (dow === 0) e.cell.style.color = '#d32f2f'; // 일
        }
        const isGreen =
          e.row === 0
            ? hb.slice(2, 8) === dayjs().format('YYYYMM')
            : hb.startsWith('W_') && currentPeriodRef.current.has(hb);
        if (isGreen) {
          e.cell.style.color = '#2e7d32';
          e.cell.style.fontWeight = 'bold';
        }
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sender.columns[e.col]?.binding;
      const dataItem = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!binding || !dataItem) return;

      if (kindOf(binding)) {
        const editable = canEditCell(binding, dataItem);
        e.cell.classList.toggle('wj-cell-editable', editable);
        // 기준주차 이전 = 잠금 Gray (특수셀 한정 — 전체 회색 금지)
        e.cell.classList.toggle(
          'wj-cell-non-editable',
          isNonEditableDateColumn(binding, weekMap.current)
        );
        // #12 본문 셀 초록 보더 제거 — AS-IS 화면 캡처에는 본문에 초록 선이 없다(사용자 확정 2026-07-22).
        //   당주 강조는 헤더 초록 볼드가 전담(위 ColumnHeader 분기). 잔여 inline 스타일 정리 위해 '' 유지.
        e.cell.style.boxShadow = '';
        // #11 숫자 표시 — NOTATION(POINT3/LOC)=소수3자리 / INTEGER=정수. 0/null 은 빈칸 (AS-IS :1853~1924).
        if (!sender.editRange?.contains(e.row, e.col)) {
          const v = dataItem[binding];
          if (v === undefined || v === null || v === 0 || v === '') {
            e.cell.innerText = '';
          } else {
            const isPoint3 = dataItem['NOTATION'] === 'POINT3' || dataItem['MEASURE'] === 'LOC';
            e.cell.innerText = toNumber(v as WijmoPrimitive).toLocaleString(undefined, {
              minimumFractionDigits: isPoint3 ? 3 : 0,
              maximumFractionDigits: isPoint3 ? 3 : 0,
            });
          }
        }
        return;
      }
      // 정적 컬럼: Insert 행만 Yellow
      const isInsert = dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null;
      e.cell.classList.toggle('wj-cell-editable', isInsert);
      // ⭐ 개인화 색 — 우선순위: Insert 편집셀 Yellow(클래스) > 저장된 Cell Color > 기본(제거).
      //   inline !important 라 클래스보다 세므로 insert 행에는 배경을 칠하지 않는다.
      //   미지정 시 removeProperty 필수 — Wijmo 셀 재활용으로 이전 행 색이 남는다.
      const personalColor = colorMetaRef.current.get(binding);
      if (!isInsert && personalColor?.cell) {
        e.cell.style.setProperty('background-color', personalColor.cell, 'important');
      } else {
        e.cell.style.removeProperty('background-color');
      }
      if (personalColor?.text) {
        e.cell.style.setProperty('color', personalColor.text, 'important');
      } else {
        e.cell.style.removeProperty('color');
      }
    };

    // Delete 키 — 선택 범위 일괄 clear + 배분 재계산 (AS-IS KeyUp Delete 1:1)
    const keydownHandler = (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.key !== 'Delete') return;
      keyboardEvent.preventDefault();
      keyboardEvent.stopPropagation();
      const tracker = editTrackerRef.current;
      if (!tracker) return;
      g.selectedRanges.forEach(range => {
        for (let row = range.topRow; row <= range.bottomRow; row++) {
          for (let col = range.leftCol; col <= range.rightCol; col++) {
            const dataItem = g.rows[row]?.dataItem as WijmoRowItem | undefined;
            const binding = g.columns[col]?.binding;
            if (!binding || !dataItem || g.columns[col]?.isReadOnly) continue;
            if (staticBindingSet.has(binding)) {
              if (dataItem['CRUD_TYPE'] !== undefined && dataItem['CRUD_TYPE'] !== null)
                dataItem[binding] = null;
              continue;
            }
            if (!kindOf(binding) || !canEditCell(binding, dataItem) || !dataItem[binding]) continue;
            const oldValue = dataItem[binding];
            tracker.storeChange(dataItem, binding, oldValue, 0);
            dataItem[binding] = 0;
            const measure = dataItem['MEASURE'];
            if (measure === 'MKT_FCST' || measure === 'SCM_FCST') {
              if (binding.startsWith('M_'))
                divideByMonth(
                  binding,
                  dataItem,
                  0,
                  monthMap.current,
                  weekMap.current,
                  calendarMapRef.current,
                  tracker
                );
              else if (binding.startsWith('W_'))
                divideByWeek(binding, dataItem, 0, oldValue, weekMap.current, tracker);
              else if (binding.startsWith('D_'))
                divideByDate(binding, dataItem, 0, oldValue, tracker);
            } else if (measure === 'LOC') {
              allocateLoc(binding, dataItem, 0, monthMap.current, weekMap.current, tracker);
            }
          }
        }
      });
      g.invalidate();
    };

    // 헤더 더블클릭 드릴다운 (AS-IS spdMain_CellDoubleClick 헤더 분기 / mkt-fcst 1:1) —
    //   W_ 헤더('SUM' leaf) 더블클릭 = 해당 주(다음 W_/M_ 전까지) D_ 토글 → 일자별 컬럼 표시/접기.
    //   M_ 헤더 더블클릭 = 해당 월(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기.
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = kindOf(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const idx = dynBindings.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M_ 드릴: 보이는 D_ 만 접기
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dynBindings.length; i++) {
        const t = dynBindings[i];
        const tk = kindOf(t);
        if (hk === 'M') {
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

    // ⭐ 동적(M_/W_/D_) 헤더 정렬 차단 (사용자 요구 2026-07-22) — 주차/SUM 단일클릭 시 공용
    //   DataGrid `setSortableColumnHeaderClick` 가 정렬을 걸고 `select(-1,-1)+scrollIntoView(0,0)` 로
    //   그리드를 맨 앞으로 스크롤한다. 그 스크롤 탓에 뒤이은 dblclick 의 hitTest 가 앞쪽 컬럼을 집어
    //   드릴다운(특히 October M_)이 죽는다. allowSorting=false 재설정은 columnGroups 재적용과 경쟁해
    //   클릭 순간을 못 막으므로, **capture 단계**에서 동적 헤더 click 을 선점 차단한다.
    //   (click 대상은 셀=하위 요소 → hostElement 의 capture 가 공용 bubble 핸들러보다 먼저 실행.
    //    dblclick 은 건드리지 않아 드릴다운은 그대로 동작. 정적 컬럼 정렬은 유지 — kindOf 대상만 차단.)
    const dynHeaderSortGuard = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      if (!kindOf(hb)) return;
      ev.stopImmediatePropagation();
    };

    g.beginningEdit.addHandler(cellEditableHandler);
    g.pastingCell.addHandler(cellEditableHandler);
    g.cellEditEnded.addHandler(cellEditHandler);
    g.pastedCell.addHandler(cellEditHandler);
    g.formatItem.addHandler(formatHandler);
    g.hostElement.addEventListener('keydown', keydownHandler);
    g.hostElement.addEventListener('dblclick', dblclickHandler);
    // capture 단계 등록 — 공용 setSortableColumnHeaderClick(bubble)보다 먼저 실행돼 정렬 선점 차단.
    g.hostElement.addEventListener('click', dynHeaderSortGuard, true);

    return () => {
      g.beginningEdit.removeHandler(cellEditableHandler);
      g.pastingCell.removeHandler(cellEditableHandler);
      g.cellEditEnded.removeHandler(cellEditHandler);
      g.pastedCell.removeHandler(cellEditHandler);
      g.formatItem.removeHandler(formatHandler);
      g.hostElement.removeEventListener('keydown', keydownHandler);
      g.hostElement.removeEventListener('dblclick', dblclickHandler);
      g.hostElement.removeEventListener('click', dynHeaderSortGuard, true);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns]);

  // ⭐ 다단 헤더 높이 48px 고정 (#93) — 실헤더 행 수로 나눠 각 행 height 명시 설정 (mkt-fcst 방식).
  //   wrapper 의 defaultSize 만으로는 동적 config height 가 만든 explicit row height 에 덮여 무효 →
  //   각 헤더행 height 를 직접 세팅. updatedLayout 마다 재적용(columnGroups rebuild 후 리셋 대응).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [dynamicColumns, gridRef]);

  // ⭐ 동적 컬럼 표시 통합 (chkSum + 헤더 드릴다운, mkt-fcst 패턴 1:1) —
  //   활성 bucket=표시 / 상위 합계=sumYn / 하위=숨김 → 셋 다 드릴 오버라이드(drillVisRef) 우선.
  //   wrapper 의 columnGroups 재적용이 visible 을 덮으므로 updatedLayout 마다 재적용. 조회 없이 즉시 반영.
  const sumYn = searchParams.sumYn;
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    drillVisRef.current.clear(); // bucket/sum/조회 변경 = AS-IS SetSpreadColumn 재실행 → 드릴 리셋
    const summarySet = new Set(summaryBindings);
    const drillSet = new Set(drillBindings);
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        // ⭐ 동적 컬럼 정렬 금지 (사용자 요구 2026-07-22) — 헤더 클릭 시 정렬이 걸려 드릴다운이
        //   오작동한다. 공용 DataGrid 는 **컬럼 객체의 allowSorting** 으로 정렬 아이콘과 클릭을
        //   판정하므로(dataGridUtils `formatSortableColumns` / `setSortableColumnHeaderClick`),
        //   dynamicColumns config 의 allowSorting:false 가 columnGroups 재적용으로 되살아나도
        //   여기서 매 updatedLayout 마다 다시 눌러 확정한다. 정적 컬럼은 정렬 유지(dynSet 만 대상).
        if (col.allowSorting) col.allowSorting = false;
        const base = summarySet.has(b) ? sumYn : drillSet.has(b) ? false : true;
        const want = drillVisRef.current.get(b) ?? base;
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
        g.updatedLayout.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [sumYn, summaryBindings, drillBindings, dynBindings, dynamicColumns, gridRef]);

  return (
    <DataGrid<ForecastPriceRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      selectionMode={SelectionMode.MultiRange}
      allowMerging={AllowMerging.All}
      alternatingRowStep={1}
      useSummaryTooltip
      useResultColumns
      useHotkey
    />
  );
};
