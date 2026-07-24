import { type FlexGrid, AllowMerging, CellType, DataMap, SelectionMode } from '@mescius/wijmo.grid';
import { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { ComboResponse, FlexGridColumnConfig } from '@foundation/models';
import { EditTracker, isNonEditableDateColumn } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { AUTH_MEASURES } from '../forecast-price.constants';
import type { ForecastPriceRow, SpreadTitleRow } from '../forecast-price.types';
import { useForecastPriceStore } from '../useForecastPriceStore';
import { thisWeekMondayYmd } from '../utils/forecast-price.editLock';

dayjs.extend(isoWeek);

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
  const bucketPrefix = (searchParams.bucketType || 'W').trim().charAt(0).toUpperCase() as 'M' | 'W' | 'D';
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
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
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

  const staticBindingSet = useMemo(
    () => new Set(staticColumns.map(c => c.colNm)),
    [staticColumns]
  );

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
            if (!measureOrigDataMapRef.current) measureOrigDataMapRef.current = col.dataMap as DataMap;
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
            if (ri && ri['CRUD_TYPE'] !== undefined && ri['CRUD_TYPE'] !== null && keyOf(ri) === myKey)
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
      if ((oldVal === undefined || oldVal === null) && (val === undefined || val === null || val === ''))
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
    const formatHandler = (sender: FlexGrid, e: {
      panel: { cellType: CellType; rows: unknown };
      row: number;
      col: number;
      cell: HTMLElement;
    }) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.cell.textContent !== 'No.') e.cell.textContent = 'No.';
        e.cell.style.textAlign = 'center';
        e.cell.style.verticalAlign = 'middle';
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
        // #12 당주 녹색 보더 (AS-IS Green BevelBorder :1970~2017) — 활성 버킷 당월/당주/금주월요일 컬럼.
        e.cell.style.boxShadow = currentPeriodRef.current.has(binding)
          ? 'inset 2px 0 0 0 #2e7d32'
          : '';
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

    g.beginningEdit.addHandler(cellEditableHandler);
    g.pastingCell.addHandler(cellEditableHandler);
    g.cellEditEnded.addHandler(cellEditHandler);
    g.pastedCell.addHandler(cellEditHandler);
    g.formatItem.addHandler(formatHandler);
    g.hostElement.addEventListener('keydown', keydownHandler);
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      g.beginningEdit.removeHandler(cellEditableHandler);
      g.pastingCell.removeHandler(cellEditableHandler);
      g.cellEditEnded.removeHandler(cellEditHandler);
      g.pastedCell.removeHandler(cellEditHandler);
      g.formatItem.removeHandler(formatHandler);
      g.hostElement.removeEventListener('keydown', keydownHandler);
      g.hostElement.removeEventListener('dblclick', dblclickHandler);
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
