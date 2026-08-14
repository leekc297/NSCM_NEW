import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon, FileExceldownloadIcon, FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ItemByDivisionModal,
  PeriodField,
  ProjectByDivisionModal,
  SalesSiteField,
} from '../../../../components';
import { MENU_ID, SHEETS } from '../../sales-future-price.constants';
import {
  buildExchangeRateMap,
  type ExchangeRateRow,
  getExchangeRate,
} from '../../salesPriceExchange';
import { useSalesFuturePriceStore } from '../../useSalesFuturePriceStore';
import { fromYyyymmdd, isPeriodInverted, yyyymmddOf } from '../../utils/futurePriceDate';

import styles from './PriceBatchInputModal.module.scss';

// yyyymmdd → 해당 주 "월요일" yyyymmdd (AS-IS drpDateTime 월요일 정렬 + MSG00330 정합).
const snapMonday = (yyyymmdd: string): string => {
  if (!/^\d{8}$/.test(yyyymmdd)) return yyyymmdd;
  const d = new Date(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8));
  const day = d.getDay(); // 0=일 … 6=토
  d.setDate(d.getDate() + (day === 0 ? -6 : 1 - day)); // 그 주 월요일
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
};
// 오늘 yyyymmdd (local).
const todayYmd = (): string => {
  const n = new Date();
  return `${n.getFullYear()}${String(n.getMonth() + 1).padStart(2, '0')}${String(n.getDate()).padStart(2, '0')}`;
};

// ⭐ No.30 — 일괄입력 저장 대상 주차를 "조회된 데이터(allRows)의 동적 컬럼"이 아니라 선택 Period 로
//   직접 산출한다. 기존엔 GET SP 가 실제로 반환한 W_yyyymmdd 컬럼 집합에만 의존했는데, 그 컬럼 수가
//   Period 전체를 못 채우면(예: 2026.08.03~2027.08.02 요청했는데 2027.06월까지만 반환) 저장도 그만큼만
//   되어 "Period 기준으로 생성 안 됨" 증상이 재현된다. 주 시작일 판정 규칙은 SalesFuturePriceGrid
//   dynBindings 와 동일(월요일 OR 월경계 분할로 생긴 월 1일) — 이 규칙은 날짜 계산만으로 결정되므로
//   GET 응답에 기대지 않고 Period 양끝만으로 전 구간을 재현할 수 있다.
const enumerateWeekStarts = (fromYmd: string, toYmd: string): string[] => {
  const from = fromYyyymmdd(fromYmd);
  const to = fromYyyymmdd(toYmd);
  if (!from || !to) return [];
  const result: string[] = [];
  const cur = new Date(from);
  while (cur <= to) {
    if (cur.getDay() === 1 || cur.getDate() === 1) result.push(yyyymmddOf(cur));
    cur.setDate(cur.getDate() + 1);
  }
  return result;
};

// ISO 주차 번호 (SalesFuturePriceGrid getDynKey 와 동일 로직) — 동적 주별 헤더 2단 라벨(Wxx)용.
const isoWeekNum = (yyyymmdd: string): number => {
  const d = new Date(
    Date.UTC(+yyyymmdd.slice(0, 4), +yyyymmdd.slice(4, 6) - 1, +yyyymmdd.slice(6, 8))
  );
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yStart.getTime()) / 86400000 + 1) / 7);
};
// 동적 W_yyyymmdd → { ym:'YYYY-MM', wk:'Wxx' } (ColumnHeader 수평 머지 그룹 판정용).
const dynHdrKey = (binding: string): { isW: boolean; ym: string; wk: string } => {
  if (!/^W_\d{8}$/.test(binding)) return { isW: false, ym: '', wk: '' };
  const d = binding.slice(2);
  return {
    isW: true,
    ym: `${d.slice(0, 4)}-${d.slice(4, 6)}`,
    wk: `W${String(isoWeekNum(d)).padStart(2, '0')}`,
  };
};

// ⭐ UI Category Setup 미로드(BE 메타 실패) 시 fallback — AS-IS 캡쳐 12 cols (PRICE_ALL 은 항상 별도 append).
//   메타 로드 시엔 아래 fixedColumns useMemo 가 UI Category(division 필터 포함)로 대체.
const FALLBACK_FIXED: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div*', colWth: 50, horzAlgnCd: 'C' },
  { colNm: 'DEPT_ID', colLblNm: 'Team', colWth: 100, horzAlgnCd: 'L' },
  { colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site*', colWth: 140, horzAlgnCd: 'L' },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code*', colWth: 120, horzAlgnCd: 'L' },
  { colNm: 'ITEM_ID', colLblNm: 'Model*', colWth: 150, horzAlgnCd: 'L' },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms*', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type*', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'DOM_EXP', colLblNm: 'Customs Handbook', colWth: 110, horzAlgnCd: 'C' },
  { colNm: 'CURRENCY', colLblNm: 'Currency*', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'PLANT_SITE_ID', colLblNm: 'Plant Site*', colWth: 90, horzAlgnCd: 'L' },
  { colNm: 'MEASURE', colLblNm: 'Measure*', colWth: 80, horzAlgnCd: 'C' },
].map(c => ({ ...c, fixed: false, visible: true, display: true })) as RawFlexGridColumnConfig[];

// 앞에서부터 계층 머지 대상 4 컬럼 (사용자 요구 2026-07-01): Div → Team → Sales Site → Project Code.
const MERGE_BINDINGS = ['DIVISION_ID', 'DEPT_ID', 'SCM_SITE_ID', 'PROJECT_CODE'];
// 셀 코드→명칭 DataMap 을 부착/해제할 수 있는 대상 컬럼(UI Category 콤보 여부로 gating).
const DISPLAY_MAP_BINDINGS = new Set([
  'DIVISION_ID',
  'SCM_SITE_ID',
  'DEPT_ID',
  'INCOTERMS',
  'CURRENCY',
  'FCST_TYPE',
  'DOM_EXP',
]);
// 일괄입력 Price — modal 전용 (Sales Price 메타에 없음). 항상 고정컬럼 마지막에 append.
const PRICE_ALL_COL: RawFlexGridColumnConfig = {
  colNm: 'PRICE_ALL',
  colLblNm: 'Batch Price',
  colWth: 130,
  horzAlgnCd: 'R',
  fixed: false, // ⭐ 메인 그리드와 동일 — freeze 미사용(frozenColumns=0). 다단 헤더 48px 정규화 정상 동작 보장.
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  // ⭐ 주별(뒷쪽) 컬럼과 동일 포맷 — 래퍼 columnMapping 이 NUMBER + scale 시 format 'n3'(###,###,###.000) 생성.
  //   하드코딩 format 문자열 대신 표준 컬럼메타(cellCtrlObjTpCd=NUMBER, scale=3)로 동일 결과.
  cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
  scale: 3,
};

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
  onSaveResult?: () => void;
}

interface PriceBatchRow {
  DIVISION_ID?: string;
  DEPT_ID?: string;
  TEAM_INCHARGE?: string;
  END_CUSTOMER?: string;
  SCM_SITE_ID?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  DOM_EXP?: string;
  CURRENCY?: string;
  PLANT_SITE_ID?: string;
  MEASURE?: string;
  PRICE_ALL?: string | number;
  [key: string]: string | number | undefined;
}

// ⭐ 성능(2026-07-08, 메인 그리드 동일 사유) — 미조회/빈 결과의 rows 를 항상 "같은" 빈 배열 참조로 반환.
//   매 렌더 새 [] 를 만들면 DataGrid(memo) 가 깨져 부모 리렌더(콤보 7종 도착 등)마다
//   itemsSource(CollectionView 재생성)+columnGroups(전 컬럼 트리 재구축) 재적용이 반복됨.
const EMPTY_ROWS: PriceBatchRow[] = [];

// AS-IS DMF0020_SaveSalesFuturePrice_Popup.cs (2,614줄) + 캡쳐 Doc/ui_cap/DMF0020_Price_batch.png 정밀 매핑
//   SP: P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (bucketType='W' — 기간 주차 W_yyyymmdd 반환)
//   Header: Div + Sales Site + Project popup + Model popup + Period
//   고정 12 cols(UI Category Setup division별 동적) + Batch Price + ⭐ 조회기간 주별 컬럼(W_yyyymmdd, 3단 헤더)
//   Cell merge: Div/Team/Sales Site/Project Code 앞에서부터 계층 머지(viewport sticky).
//   과거 주차(이번 주 월요일 이전) = gray lock. 헤더 높이 48px 정규화(메인 그리드 동일, freeze 미사용).
export const PriceBatchInputModal = ({
  open,
  modalClose,
  defaultDivision,
  defaultPeriod,
  onSaveResult,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<PriceBatchRow> | null>(null);
  // ⭐ 헤더높이 정규화 함수 참조(permanent 효과가 주입 — ResizeObserver 등에서 직접 호출) + 그리드 컨테이너 ref.
  const headerNormalizeRef = useRef<() => void>(() => {});
  const gridWrapRef = useRef<HTMLDivElement>(null);

  const [divisionId, setDivisionId] = useState(defaultDivision);
  // ⭐ No.27 — 다중선택 지원 (2026-08-04). 빈 배열 = ALL. 공용 SalesSiteField(string[]) 계약과 정합.
  const [salesSite, setSalesSite] = useState<string[]>([]);
  const [projectCode, setProjectCode] = useState('');
  const [itemId, setItemId] = useState('');
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);

  // popup state
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  // ⭐ 재진입 초기화 — 이 모달 세션에서 조회했는지 여부. 미조회면 그리드 비움(이전 데이터/입력 잔존 방지).
  const [searched, setSearched] = useState(false);

  // ⭐ UI Category Setup 동적 컬럼 메타 — Batch 전용 시트 'Sales Price Save All'(AS-IS shtMain, 2026-07-07).
  //   division 필터는 SP(PR_GET_SHEET_COLUMN_LIST)가 DIVISION_ID 컬럼으로 서버측 처리(attribute3 미사용) →
  //   fetchBatchColumns(divisionId). 하드코딩 화이트리스트(BATCH_FIXED_ORDER) 제거 = 순수 메타구동.
  const metaBatch = useSalesFuturePriceStore(s => s.staticColumns[SHEETS.PRICE_BATCH]);
  const fetchBatchColumns = useSalesFuturePriceStore(s => s.fetchBatchColumns);

  useEffect(() => {
    if (open) {
      // ⭐ 재진입 시 초기화 — 조회조건/조회여부 리셋(이전 입력·데이터 잔존 방지).
      setDivisionId(defaultDivision);
      setSalesSite([]);
      setProjectCode('');
      setItemId('');
      setSearched(false);
      // ⭐ AS-IS drpDateTime 정합 — 기간 기본값 월요일 정렬 + 시작일은 이번 주 월요일 이상(과거구간 금지 MSG00409).
      const thisMon = snapMonday(todayYmd());
      const fromMon = snapMonday(defaultPeriod.start);
      const from = fromMon > thisMon ? fromMon : thisMon;
      const to = snapMonday(defaultPeriod.end);
      setPeriodFrom(from);
      setPeriodTo(to < from ? from : to);
      // ⭐ Batch 시트 컬럼은 부모(SalesFuturePrice)가 division 단위로 선-fetch → 여기선 미로드일 때만 보강.
      //   (open 마다 재fetch 하면 metaBatch 참조가 매번 바뀌어 그리드 컬럼 재구성 = 깜박임. 2026-07-07)
      if (!metaBatch || metaBatch.length === 0) void fetchBatchColumns(defaultDivision);
    }
  }, [open, defaultDivision, defaultPeriod, metaBatch, fetchBatchColumns]);

  // ===== Combo dropdown — Div / Sales Site / Team / Incoterms / FCST / Customs Handbook / Currency =====
  const [divQ, ssQ, teamQ, incoQ, currQ, fcstQ, customsQ] = useTabComboQueries({
    filters: [
      'MyDivision',
      // ⭐ Sales Site = 메인 화면 SalesSiteField 와 동일 콤보 'SalesSite'(전체 반환 → division 클라이언트 필터).
      //   기존 'SiteByEndCustomer' 는 endCustomer 파라미터 필요 → 빈 결과 사고. (2026-07-01 보완)
      'SalesSite',
      { comboId: 'TeambyDivision', divisionId },
      'Incoterms',
      'CurrencyList',
      { comboId: 'FcstType', divisionId },
      { comboId: 'CustomsHandbook', divisionId },
    ],
  });
  type ComboItem = { CODE?: string; NAME?: string };
  // ⭐ UI Category Setup 존중 — 셀 콤보(코드→명칭 DataMap)는 admin 이 cell type 을 'FPComboBox' 로 둔 컬럼만 적용.
  //   admin 이 DIVISION_ID 의 cell type 을 삭제/비콤보로 바꾸면 DataMap 미적용 → raw 코드('82')만 표시(메인 그리드 동일).
  //   metaMain 미로드(fallback) 시엔 null → 기존 기본 DataMap 전부 적용(화면 작동 보장).
  const comboBindings = useMemo<Set<string> | null>(() => {
    if (!metaBatch || metaBatch.length === 0) return null;
    const s = new Set<string>();
    for (const c of metaBatch) if (c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO) s.add(c.colNm);
    return s;
  }, [metaBatch]);
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (binding: string, q: ComboItem[] | undefined): DataMap | null => {
      // UI Category 가 콤보가 아니라고 하면(로드됨 && 미포함) DataMap 미적용 → raw 코드 표시.
      if (comboBindings && !comboBindings.has(binding)) return null;
      const arr = q ?? [];
      if (arr.length === 0) return null;
      return new DataMap(arr, 'CODE', 'NAME');
    };
    return {
      DIVISION_ID: make('DIVISION_ID', divQ as never),
      SCM_SITE_ID: make('SCM_SITE_ID', ssQ as never),
      DEPT_ID: make('DEPT_ID', teamQ as never),
      INCOTERMS: make('INCOTERMS', incoQ as never),
      CURRENCY: make('CURRENCY', currQ as never),
      FCST_TYPE: make('FCST_TYPE', fcstQ as never),
      DOM_EXP: make('DOM_EXP', customsQ as never),
    };
  }, [divQ, ssQ, teamQ, incoQ, currQ, fcstQ, customsQ, comboBindings]);
  // ⭐ 헤더높이 깜빡임 방지 — updatedLayout 핸들러를 dataMaps 변경마다 재등록하지 않도록 ref 로 최신값 참조.
  //   (콤보 로딩 시 핸들러 제거·재등록 사이 wijmo 기본 높이 노출 = flicker 원인 제거.)
  const dataMapsRef = useRef(dataMaps);
  dataMapsRef.current = dataMaps;

  const divItems = (divQ ?? []) as ComboItem[];

  // ⭐ 고정 컬럼 = 'Sales Price Save All' 시트 메타 순수 구동 (2026-07-07 하드코딩 화이트리스트 제거).
  //   division 필터 = SP 서버측(DIVISION_ID 컬럼) → FE 는 visible 만 필터. 정렬 = SP 반환 순서(SORT_ORDER_NO).
  //   PRICE_ALL 은 시트에 VISIBLE_FLAG='N' 이므로 visible 셋에 없음 → 항상 편집용 상수 append(중복 없음).
  //   inputTpCd = 표시전용(SEARCH_ONLY) 강제(오직 PRICE_ALL 편집). 메타 미로드 시 FALLBACK_FIXED.
  const fixedColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const base: RawFlexGridColumnConfig[] =
      metaBatch && metaBatch.length > 0
        ? metaBatch
            .filter(c => c.visible !== false)
            .map(c => ({
              colNm: c.colNm,
              colLblNm: c.colLblNm || c.colNm,
              colWth: c.colWth ?? 90,
              horzAlgnCd: c.horzAlgnCd ?? 'C',
              fixed: false, // ⭐ 메인 그리드와 동일 — freeze 미사용(다단 헤더 높이 정규화 정상화)
              visible: true,
              display: true,
              inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // 표시전용 (편집=PRICE_ALL 만)
            }))
        : FALLBACK_FIXED.map(c => ({ ...c, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY }));
    return [...base, PRICE_ALL_COL];
  }, [metaBatch]);

  const fixedBindings = useMemo(() => fixedColumns.map(c => c.colNm), [fixedColumns]);

  // ===== SP — sheet 'priceBatch' (메인 SP DMF0020_GET_SCM_MST_FUTURE_PRICE 와 동일) =====
  //   BE makeProcedure (BaseService.java) 가 SCM_ADM_PROC_M.COL_NM 매핑 — IN 18 param 모두 명시 의무.
  const sesUserId = useSessionStore(s => s.session.userId ?? '');
  // ⭐ open 일 때만 filters 정의 (형제 SalesPriceVersionModal 표준) — modal 닫힘 시 stale query 방지.
  const filters = useMemo(
    () =>
      open
        ? ({
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            scmSiteId: salesSite.length > 0 ? salesSite.join('^') : 'ALL',
            plantSiteId: 'ALL',
            projectCode: projectCode || 'ALL',
            itemId: itemId || 'ALL',
            customerProjectCode: 'ALL',
            customerModel: 'ALL',
            fromYyyymmdd: periodFrom,
            toYyyymmdd: periodTo,
            biztype: 'ALL',
            sesUserId,
            userInfo: sesUserId,
            owner: 'ALL',
            overRange: 'N',
            invalidExec: 'N',
            versionType: 'CURRENT',
            // ⭐ 'W' — 기간 내 주차(W_yyyymmdd) 단위로 주별 컬럼 표시 + 저장 시 일괄 price 확장.
            bucketType: 'W',
          } as never)
        : undefined,
    [open, divisionId, periodFrom, periodTo, salesSite, projectCode, itemId, sesUserId]
  );
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.PRICE_BATCH,
    tabId: MENU_ID,
    filters,
    enabled: false,
  });

  // ⭐ 환율 데이터 (메인 grid 저장과 동일 소스) — 저장 시 LOC → KRW/USD 재계산용.
  //   ⭐ No.24 — periodFrom 이 월 중간(월요일 스냅)이면 그 달 환율행이 빠지는 문제(메인화면과 동일 원인) →
  //   월초로 스냅해 조회 (SalesFuturePrice.tsx exchangeFilters 와 동일 처리).
  const exchangeFilters = useMemo(
    () =>
      open
        ? ({ startYyyymmdd: `${periodFrom.slice(0, 6)}01`, endYyyymmdd: periodTo } as never)
        : undefined,
    [open, periodFrom, periodTo]
  );
  const { data: exchangeData } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    tabId: MENU_ID,
    filters: exchangeFilters,
    enabled: !!open && !!periodFrom && !!periodTo,
  });

  // ⭐ 성능(2026-07-08) — allRows 참조 안정화(useMemo). `data?.o_rc1 ?? []` 를 렌더 본문에서 만들면
  //   data 미도착 동안 매 렌더 새 배열 → rows useMemo 재계산 연쇄 → 그리드 재바인딩 반복.
  const allRows = useMemo<PriceBatchRow[]>(
    () => (data?.o_rc1 ?? EMPTY_ROWS) as unknown as PriceBatchRow[],
    [data]
  );
  // 추가 client-side filter (사용자 명시 검색조건)
  //   ⭐ 이 Modal 은 LOC Measure 만 등록 사용 (AS-IS GET_MEASURE_COUNTINFO_SAVE_PRICE = LOC only) → LOC 행만 표시.
  const rows = useMemo(
    () =>
      // ⭐ 미조회(재진입 초기) 상태면 빈 그리드 → 헤더 단단(1단)로 리셋 + 이전 데이터/입력 비표시.
      //   EMPTY_ROWS 상수 반환 = 참조 안정(매번 새 [] 생성 금지 — DataGrid memo 보존).
      !searched
        ? EMPTY_ROWS
        : allRows.filter(r => {
            if (String(r.MEASURE ?? '').toUpperCase() !== 'LOC') return false;
            if (salesSite.length > 0 && !salesSite.includes(String(r.SCM_SITE_ID ?? '')))
              return false;
            if (projectCode && !String(r.PROJECT_CODE ?? '').includes(projectCode)) return false;
            if (itemId && !String(r.ITEM_ID ?? '').includes(itemId)) return false;
            return true;
          }),
    [allRows, salesSite, projectCode, itemId, searched]
  );

  // ⭐ 동적 주별 bindings (W_yyyymmdd) — 주 시작일(월요일 OR 월 1일, 월경계 분할 주차) 만.
  //   SalesFuturePriceGrid dynBindings 와 동일 규칙 → 메인 그리드와 동일한 주별 컬럼 집합.
  const dynBindings = useMemo<string[]>(() => {
    if (rows.length === 0) return [];
    const set = new Set<string>();
    for (const r of rows) {
      for (const k of Object.keys(r)) {
        if (!/^W_\d{8}$/.test(k)) continue;
        const d = k.slice(2);
        const dt = new Date(Date.UTC(+d.slice(0, 4), +d.slice(4, 6) - 1, +d.slice(6, 8)));
        if (dt.getUTCDay() !== 1 && dt.getUTCDate() !== 1) continue;
        set.add(k);
      }
    }
    return [...set].sort();
  }, [rows]);
  // ⭐ 헤더높이 정규화가 "데이터 기반 예상 tier 수"로 defaultSize 를 선제 설정하도록 ref 로 최신 dynBindings 참조.
  //   (런타임 headerRows.length 는 3단 build 전 1로 오인 → 48 굳어 3단이 상속 시 144px 잔존 → 이 ref 로 회피.)
  const dynBindingsRef = useRef(dynBindings);
  dynBindingsRef.current = dynBindings;

  // ⭐ 과거 주차 편집불가 cutoff = "이번 주 월요일" (SalesFuturePriceGrid todayCutoff 동일).
  const todayCutoff = useMemo(() => {
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    now.setDate(now.getDate() + (1 - now.getDay()));
    return `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(
      now.getDate()
    ).padStart(2, '0')}`;
  }, []);

  // ⭐ 3단 nested 동적 컬럼 (SalesFuturePriceGrid mainDynamicColumns 동일) — year-month → week → day.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynBindings.length === 0) return [];
    type YmBucket = { ymLabel: string; weeks: Map<string, FlexGridColumnConfig[]> };
    const ymMap = new Map<string, YmBucket>();
    for (const b of dynBindings) {
      const ymd = b.slice(2);
      const ym = ymd.slice(0, 6);
      const ymLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
      const mmdd = ymd.slice(4, 8);
      const wLabel = `W${String(isoWeekNum(ymd)).padStart(2, '0')}`;
      let bucket = ymMap.get(ym);
      if (!bucket) {
        bucket = { ymLabel, weeks: new Map() };
        ymMap.set(ym, bucket);
      }
      if (!bucket.weeks.has(wLabel)) bucket.weeks.set(wLabel, []);
      bucket.weeks.get(wLabel)!.push({
        binding: b,
        header: mmdd,
        align: 'right',
        format: 'n3',
        width: 80,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // 주별 컬럼 = 표시전용
        _display: true,
      });
    }
    return [...ymMap.values()].map(bucket => ({
      header: bucket.ymLabel,
      align: 'center',
      columns: [...bucket.weeks.entries()].map(([wLabel, dayCols]) => ({
        header: wLabel,
        align: 'center',
        columns: dayCols,
      })),
    }));
  }, [dynBindings]);

  const loading = isLoading || isFetching;

  // ===== Button handlers =====
  const handleFind = () => {
    // AS-IS FindData L1160-1211 정합 (순서: 역전 → 과거구간 → 월요일 → division).
    if (isPeriodInverted(periodFrom, periodTo)) {
      void setAlert({ type: 'alert', content: t('MSG00108', '_Period 가 역전되었습니다.') });
      return;
    }
    // MSG00409 — 이번 주 월요일보다 시작일이 이전이면 과거구간 일괄입력 불가 (AS-IS L1178-1182).
    if (periodFrom < snapMonday(todayYmd())) {
      void setAlert({
        type: 'alert',
        content: t('MSG00409', '_과거구간은 일괄입력이 불가합니다.'),
      });
      return;
    }
    // MSG00330 — From/To 둘 다 월요일이어야 함 (AS-IS L1186-1191).
    if (periodFrom !== snapMonday(periodFrom) || periodTo !== snapMonday(periodTo)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00330', '_기간은 월요일 단위로 선택해야 합니다.'),
      });
      return;
    }
    if (!divisionId) {
      void setAlert({ type: 'alert', content: t('MSG00097', '_Division 을 선택하세요.') });
      return;
    }
    setSearched(true);
    refetch?.();
  };

  // AS-IS DMF0020_SaveSalesFuturePrice_Popup.cs SaveData() L1751~1839 정합:
  //   LOC 행마다 입력한 일괄 price 를 기간 내 모든 주차(W_yyyymmdd)로 확장 × measure 3쌍(LOC/KRW/USD, RTF 제외).
  //   LOC=입력값 / KRW·USD=GetExchangeRate 재계산. 저장 SP = DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL(메인 라우트 재사용).
  const handleSave = async () => {
    // 일괄 price 입력된 LOC 행만 대상 (PRICE_ALL 비어있으면 skip)
    const targets = rows.filter(r => {
      const v = r.PRICE_ALL;
      return v !== undefined && v !== null && String(v).trim() !== '';
    });
    if (targets.length === 0) {
      void setAlert({
        type: 'alert',
        content: t('MSG00113', '_일괄입력 Price 를 입력 후 저장하세요.'),
      });
      return;
    }

    // ⭐ AS-IS fnValidation() + SP [C20200814-000093] 검증 등가 (저장 전 클라이언트 사전 차단).
    //   SP 는 (통화 제외 전체키 + 주차 + measure) 그룹에 2건 이상이면 "동일 기간 두 개 이상 Currency" 오류.
    //   업무키(통화 제외) = Division/Project/Site/Plant/Item/DomExp/FcstType/Incoterms.
    const bizKey = (r: PriceBatchRow) =>
      [
        r.DIVISION_ID,
        r.PROJECT_CODE,
        r.SCM_SITE_ID,
        r.PLANT_SITE_ID,
        r.ITEM_ID,
        r.DOM_EXP,
        r.FCST_TYPE,
        r.INCOTERMS,
      ]
        .map(x => String(x ?? ''))
        .join('|');
    // (A) 같은 업무키에 서로 다른 Currency 2건 이상 → SP 가드 유발 → 사전 차단(원인 item 표시).
    const curByKey = new Map<string, Set<string>>();
    for (const r of targets) {
      const set = curByKey.get(bizKey(r)) ?? new Set<string>();
      set.add(String(r.CURRENCY ?? ''));
      curByKey.set(bizKey(r), set);
    }
    // 충돌 item 전수 수집 — 어떤 Model 이 어떤 통화로 충돌하는지 한 번에 표시(옵션 A: 차단 + 정리 안내).
    const conflicts = new Map<string, { itemId: string; curs: string }>();
    for (const r of targets) {
      const k = bizKey(r);
      const set = curByKey.get(k);
      if (set && set.size > 1 && !conflicts.has(k)) {
        conflicts.set(k, {
          itemId: String(r.ITEM_ID ?? ''),
          curs: [...set].map(c => (c === '' ? '(빈값)' : c)).join(', '),
        });
      }
    }
    if (conflicts.size > 0) {
      const list = [...conflicts.values()]
        .slice(0, 10)
        .map(c => `• ${c.itemId}: ${c.curs}`)
        .join('\n');
      const more = conflicts.size > 10 ? `\n… 외 ${conflicts.size - 10}건` : '';
      void setAlert({
        type: 'alert',
        content: `동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.\n아래 Model 의 통화를 하나로 정리 후 저장하세요.\n${list}${more}`,
      });
      return;
    }
    // (B) 완전 동일 업무키+통화 중복 행(GET fan-out 등) 제거 — payload 에 같은 (키+주차+measure) 중복 미전송.
    const seenFull = new Set<string>();
    const uniqueTargets = targets.filter(r => {
      const k = `${bizKey(r)}|${String(r.CURRENCY ?? '')}`;
      if (seenFull.has(k)) return false;
      seenFull.add(k);
      return true;
    });

    // ⭐ No.30 — 기간 내 주차(W_yyyymmdd) 는 GET 응답의 동적 키가 아니라 선택 Period(periodFrom~periodTo)
    //   로 직접 산출한다 (표시 주차(dynBindings)와 동일 규칙: 주 시작 = 월요일 OR 월 1일). GET 응답 컬럼에
    //   기대면 그 응답이 Period 전체를 못 채웠을 때 저장도 같이 잘린다 — 위 enumerateWeekStarts 참조.
    const weeks = enumerateWeekStarts(periodFrom, periodTo);
    if (weeks.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00108', '_조회된 주차가 없습니다.') });
      return;
    }

    const ok = await setAlert({ type: 'confirm', content: t('MSG00001', '_저장하시겠습니까?') });
    if (!ok) return;
    void setToast({ message: t('LBL00665', 'Loading...'), type: 'default', duration: 3000 });

    const erRows = (exchangeData as { o_rc1?: ExchangeRateRow[] })?.o_rc1 ?? [];
    const erMap = buildExchangeRateMap(erRows);

    // 메인 SAVE 와 동일 17 key (createdBy/lastUpdatedBy 는 BE 가 단일값 덮어쓰므로 List 키명 사용).
    const acc: Record<string, string[]> = {
      activeFlag: [],
      divisionId: [],
      projectCode: [],
      scmSiteId: [],
      plantSiteId: [],
      itemId: [],
      yyyymmdd: [],
      currency: [],
      measure: [],
      domExp: [],
      fcstType: [],
      incoterms: [],
      price: [],
      createdByList: [],
      creationDate: [],
      lastUpdatedByList: [],
      rownumKey: [],
    };
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const userId = sesUserId;
    const MEAS = ['LOC', 'KRW', 'USD'] as const; // RTF/RTF_SYS_RP 제외 (AS-IS L1762)
    let rownum = 0;
    const seenRow = new Set<string>(); // (업무키+주차+measure) 최종 중복 안전망 (SP count>1 원천 차단)

    for (const r of uniqueTargets) {
      const batch =
        String(r.PRICE_ALL ?? '')
          .replace(/,/g, '')
          .trim() || '0';
      const div = String(r.DIVISION_ID ?? '');
      const cur = String(r.CURRENCY ?? '');
      for (const m of MEAS) {
        for (const ymd of weeks) {
          // 최종 안전망 — 같은 (업무키+주차+measure) 는 1건만 (동일 통화 완전중복 제거 후에도 방어).
          const rowKey = `${bizKey(r)}|${ymd}|${m}`;
          if (seenRow.has(rowKey)) continue;
          seenRow.add(rowKey);
          const ym = ymd.slice(0, 6);
          const raw = m === 'LOC' ? batch : getExchangeRate(erMap, div, cur, m, ym, batch, '0');
          const price = raw === '' ? '0' : raw;
          // ⭐ AS-IS SaveData 정합 — active_flag 는 "배치 입력값(batch)" 기준 전 measure 동일.
          //   batch=='0' → 'D'(삭제). batch!='0' → 'M'(수정).
          //   ⚠️ 'I' 가 아니라 'M' 인 이유: 배치 팝업은 항상 기존 Sales Price 를 편집(AS-IS Dsdm_Changed →
          //   SetActionFlagEx 'M'). SP 검증 [E20241125-000026](line 607~640)은 active_flag='I' + 기존 테이블
          //   매칭 시 오류를 내는데, 통화 비교가 주석(line 625 --S.CURRENCY=..)이라 통화가 같아도 발동.
          //   → 기존 데이터 편집을 'M' 으로 보내면 그 검증을 통과(AS-IS 동작 동일). SP delete-then-insert 는 non-'D' 모두 insert.
          const flag = batch === '0' ? 'D' : 'M';
          rownum++;
          acc.activeFlag.push(flag);
          acc.divisionId.push(div);
          acc.projectCode.push(String(r.PROJECT_CODE ?? ''));
          acc.scmSiteId.push(String(r.SCM_SITE_ID ?? ''));
          acc.plantSiteId.push(String(r.PLANT_SITE_ID ?? ''));
          acc.itemId.push(String(r.ITEM_ID ?? ''));
          acc.yyyymmdd.push(ymd);
          acc.currency.push(cur);
          acc.measure.push(m);
          acc.domExp.push(String(r.DOM_EXP ?? ''));
          acc.fcstType.push(String(r.FCST_TYPE ?? ''));
          acc.incoterms.push(String(r.INCOTERMS ?? ''));
          acc.price.push(price);
          acc.createdByList.push(userId);
          acc.creationDate.push(today);
          acc.lastUpdatedByList.push(userId);
          acc.rownumKey.push(String(rownum));
        }
      }
    }

    if (acc.activeFlag.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00667', 'No data to save.') });
      return;
    }
    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    try {
      // ⭐ 메인 SAVE 라우트 재사용 (DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL — PROC_M/시퀀스/createdBy 수리됨).
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/main/SAVE/call-proc`,
        payload
      );
      // false-success 차단 — 전역 responseErrorInterceptor 가 500 을 resolve. (CODE≠0 검증거부는 interceptor throw→catch)
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t('MSG00606', '_저장되었습니다.'), type: 'success' });
      onSaveResult?.(); // 메인 grid refetch
      modalClose();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // ⭐ Excel Download — 공용 GridAction.excelDownload (backcolor 제외 + 숨김 컬럼 제외 표준).
  //   주별 동적 컬럼(W_yyyymmdd) 포함 화면 표시 그대로 export.
  const handleExcel = async () => {
    const g = gridRef.current;
    if (!g) return;
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00667', 'No data to save.') });
      return;
    }
    // ⭐ No.29 — 공용 GridAction.excelDownload 는 export 용 Column 을 새로 만들며 화면의 combo
    //   dataMap(코드→명칭)을 옮기지 않는다 → Team(DEPT_ID)이 원시 코드로 내려받아짐. 근본 수정은
    //   공용 유틸(gridAction.ts) 쪽이지만 이번 작업 범위는 이 화면 안이므로, 내보내는 동안만 Team
    //   값을 코드→명칭으로 치환한 사본을 바인딩했다가 끝나면 원본으로 되돌리는 방식으로 우회한다.
    const teamNameOf = new Map(
      ((teamQ ?? []) as unknown as Array<Record<string, string>>).map(
        r => [String(r.CODE ?? ''), String(r.NAME ?? r.CODE ?? '')] as const
      )
    );
    const exportRows = rows.map(r => ({
      ...r,
      DEPT_ID: teamNameOf.get(String(r.DEPT_ID ?? '')) ?? r.DEPT_ID,
    }));
    g.itemsSource = exportRows as unknown as typeof g.itemsSource;
    try {
      await GridAction.excelDownload(g as never, t('LBL00662', 'Price Batch Input'));
    } finally {
      // 화면 표시는 항상 원본(코드 그대로 유지 + dataMap 이 명칭 렌더) 바인딩으로 복원.
      g.itemsSource = rows as unknown as typeof g.itemsSource;
    }
  };

  // ⭐ #70 — DataGrid `initialized` prop deprecated → useEffect + gridRef.
  //   formatItem(과거주차 gray / PRICE_ALL editable) + 계층 머지(viewport sticky) + scroll invalidate.
  //   deps 에 dynBindings/fixedBindings 포함 → 컬럼 변경 시 handler/mergeManager 재등록(closure 정합).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.allowMerging = AllowMerging.All;

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      // PRICE_ALL(일괄입력) = editable Yellow.
      if (binding === 'PRICE_ALL') {
        toggleClass(e.cell, 'wj-cell-editable', true);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        return;
      }
      // 동적 주별 셀 — 과거 주차(이번 주 월요일 이전)만 gray lock (hook #95: 잠금 Gray 는 특수셀만).
      if (/^W_\d{8}$/.test(binding)) {
        const isPast = binding.slice(2) < todayCutoff;
        toggleClass(e.cell, 'wj-cell-editable', false);
        toggleClass(e.cell, 'wj-cell-non-editable', isPast);
        return;
      }
      // 고정 표시전용 컬럼 = White 기본 (gray 칠하지 않음 — hook #95).
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // ⭐ scroll 시 머지 재계산 (hook #38 viewport sticky) → 새 viewport 첫 row 가 머지 top → 값 항상 표시.
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // MergeManager — ① 데이터셀 계층 머지(Div→Team→Site→Project, 앞에서부터) ② 헤더 머지(고정 verticalSpan + 동적 W 수평).
    class BatchMergeManager extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';

        // ① 데이터셀 — MERGE_BINDINGS(4) 만 계층 머지. viewport row 제한(sticky 값 표시).
        if (panel.cellType === CellType.Cell && MERGE_BINDINGS.includes(binding)) {
          const view = panel.rows;
          const ri = (i: number): PriceBatchRow | undefined =>
            (view[i] as unknown as { dataItem?: PriceBatchRow })?.dataItem;
          if (!ri(r)) return null;
          const minRow = panel.viewRange.row;
          const maxRow = panel.viewRange.row2;
          const idx = MERGE_BINDINGS.indexOf(binding);
          const leftBindings = MERGE_BINDINGS.slice(0, idx + 1); // 앞에서부터 계층
          const sameRow = (a: number, b: number): boolean => {
            const ra = ri(a);
            const rb = ri(b);
            if (!ra || !rb) return false;
            return leftBindings.every(
              k =>
                ((ra as Record<string, unknown>)[k] ?? '') ===
                ((rb as Record<string, unknown>)[k] ?? '')
            );
          };
          let r1 = r,
            r2 = r;
          while (r1 > minRow && sameRow(r1 - 1, r)) r1--;
          while (r2 < maxRow && sameRow(r2 + 1, r)) r2++;
          if (r1 === r2) return null;
          return new CellRange(r1, c, r2, c);
        }

        // ② ColumnHeader — 고정 컬럼 세로 verticalSpan(3단 전체) + 동적 W 컬럼 수평 머지(년월/주차).
        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) {
            return new CellRange(0, c, panel.rows.length - 1, c);
          }
          const dyn = dynHdrKey(binding);
          if (dyn.isW) {
            if (r === 0) {
              let c1 = c,
                c2 = c;
              while (c1 > 0) {
                const p = dynHdrKey(panel.columns[c1 - 1].binding ?? '');
                if (p.isW && p.ym === dyn.ym) c1--;
                else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = dynHdrKey(panel.columns[c2 + 1].binding ?? '');
                if (n.isW && n.ym === dyn.ym) c2++;
                else break;
              }
              return new CellRange(0, c1, 0, c2);
            }
            if (r === 1) {
              let c1 = c,
                c2 = c;
              while (c1 > 0) {
                const p = dynHdrKey(panel.columns[c1 - 1].binding ?? '');
                if (p.isW && p.wk === dyn.wk && p.ym === dyn.ym) c1--;
                else break;
              }
              while (c2 < panel.columns.length - 1) {
                const n = dynHdrKey(panel.columns[c2 + 1].binding ?? '');
                if (n.isW && n.wk === dyn.wk && n.ym === dyn.ym) c2++;
                else break;
              }
              return new CellRange(1, c1, 1, c2);
            }
          }
        }
        return null;
      }
    }
    g.mergeManager = new BatchMergeManager();

    // ⭐ updatedLayout — combo dataMap 재부착(ref 최신값 + UI Category gating). 헤더높이는 별도 permanent 효과 전담.
    //   (wrapper 가 columnGroups 재적용 시 col.dataMap 을 undefined 로 덮으므로 매 layout 재부착.)
    const reattachDataMaps = () => {
      const maps = dataMapsRef.current;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        const dm = maps[binding];
        // UI Category 콤보 gating — dm 있으면 부착, 대상인데 gated-off(null)면 명시적 해제(raw 코드).
        if (dm) {
          if (col.dataMap !== dm) col.dataMap = dm;
        } else if (DISPLAY_MAP_BINDINGS.has(binding) && col.dataMap) {
          col.dataMap = null;
        }
        col.allowMerging = true;
      }
    };
    g.updatedLayout.addHandler(reattachDataMaps);
    reattachDataMaps();
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        g.scrollPositionChanged?.removeHandler(handleScrollInvalidate);
      } catch {
        /* unmount race */
      }
      try {
        g.updatedLayout?.removeHandler(reattachDataMaps);
      } catch {
        /* unmount race */
      }
    };
  }, [dynBindings, fixedBindings, todayCutoff]);

  // ⭐⭐ 헤더높이 상시 정규화 (재진입 포함 어떤 상황도 48px 초과 잔존 금지 — 사용자 요구 2026-07-02).
  //   과거 방식(open 시 1회 등록)의 재발 경로 2개를 함께 차단:
  //   ① 모달 close→reopen 시 그리드 인스턴스가 교체되면 핸들러가 죽은 인스턴스에 남음
  //      → open 동안 raf 루프가 gridRef.current 교체를 감지해 항상 "살아있는" 인스턴스에 재부착.
  //   ② "예상 tier 수(dynBindings)"로만 per 를 계산하면 실제 헤더 행 수와 어긋나는 시점에 총높이 > 48 가능
  //      → 존재하는 행은 실제 행 수(48/actual)로, defaultSize 는 예상 tier(48/expected)로 각각 강제
  //        ⇒ 어떤 조합에서도 "현재 보이는 헤더 총합 = 48px" 불변식 유지(늦게 build 되는 행은 defaultSize 상속).
  //   루프는 정규화 완료 시 early-exit 라 프레임당 비용은 속성 몇 개 비교 수준.
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<PriceBatchRow> | null = null;
    const normalizeHeader = () => {
      const g = gridRef.current;
      if (!g) return;
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const expectedTiers = dynBindingsRef.current.length > 0 ? 3 : 1;
      const actualTiers = headerRows.length;
      const perDefault = Math.round(48 / expectedTiers); // 미래 build 행 상속용 (3단=16 / 1단=48)
      const perActual = Math.round(48 / actualTiers); // 현재 존재 행 — 총합 48 불변식
      const ok =
        Math.round(headerRows.defaultSize) === perDefault &&
        Array.from({ length: actualTiers }).every(
          (_, i) => Math.round(headerRows[i]?.height ?? 0) === perActual
        );
      if (ok) return; // 이미 목표 = skip (무한루프/불필요 invalidate 차단)
      headerRows.defaultSize = perDefault;
      for (let i = 0; i < actualTiers; i++) headerRows[i].height = perActual;
    };
    headerNormalizeRef.current = normalizeHeader;
    const loop = () => {
      const g = gridRef.current;
      // 인스턴스 교체 감지 → 살아있는 grid 에 updatedLayout 핸들러 이관 (죽은 인스턴스 잔존 등록 차단).
      if (g && g !== attached) {
        try {
          attached?.updatedLayout.removeHandler(normalizeHeader);
        } catch {
          /* destroyed instance */
        }
        g.updatedLayout.addHandler(normalizeHeader);
        attached = g;
      }
      try {
        normalizeHeader();
      } catch {
        /* unmount race */
      }
      raf = requestAnimationFrame(loop);
    };
    loop();
    return () => {
      cancelAnimationFrame(raf);
      try {
        attached?.updatedLayout.removeHandler(normalizeHeader);
      } catch {
        /* unmount race */
      }
    };
  }, [open]);

  // ⭐ 콤보 로딩(dataMaps) 시 — 핸들러 재등록 없이 dataMap 만 재부착 + invalidate(높이 핸들러가 48 유지).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    let changed = false;
    for (let i = 0; i < g.columns.length; i++) {
      const col = g.columns[i];
      const binding = col.binding ?? '';
      const dm = dataMaps[binding];
      if (dm) {
        if (col.dataMap !== dm) {
          col.dataMap = dm;
          changed = true;
        }
      } else if (DISPLAY_MAP_BINDINGS.has(binding) && col.dataMap) {
        // UI Category 가 콤보 아님(FPText 등) → DataMap 해제 → raw 코드 표시.
        col.dataMap = null;
        changed = true;
      }
    }
    if (changed) g.invalidate();
  }, [dataMaps]);

  // ⭐ 헤더높이 커진 채 잔존 방지 핵심 — CustomDialog open 애니메이션으로 grid 컨테이너가 0→full 로 리사이즈될 때
  //   wijmo 는 그 시점(수 프레임 후)에야 3단 헤더를 확정 build 하는데, 이후 정적이라 updatedLayout 이 안 뜬다.
  //   ResizeObserver 로 컨테이너 크기 변화를 감지 → invalidate(true)(레이아웃 재계산 + updatedLayout 유발)
  //   + applyLayout 직접 호출 → 48→(1단48/2단24/3단16) 정규화. (메인 그리드 gridBoxRef ResizeObserver 동일 취지.)
  //   ⚠️ deps=[open] — 모달이 닫힌 채 mount 되면 gridWrapRef 가 null 이라 관찰 미부착됨. open 마다 재부착(재진입 정규화 보장).
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let ro: ResizeObserver | null = null;
    const attach = () => {
      const el = gridWrapRef.current;
      if (!el || typeof ResizeObserver === 'undefined') {
        if (!el) raf = requestAnimationFrame(attach); // 컨테이너 렌더 대기
        return;
      }
      ro = new ResizeObserver(() => {
        const g = gridRef.current;
        if (!g) return;
        try {
          g.invalidate(true); // 레이아웃 재계산 → updatedLayout → permanent normalizeHeader
          headerNormalizeRef.current(); // 직접 호출로 즉시 정규화까지 보장
        } catch {
          /* unmount race */
        }
      });
      ro.observe(el);
    };
    attach();
    return () => {
      cancelAnimationFrame(raf);
      ro?.disconnect();
    };
  }, [open]);

  return (
    <>
      <CustomDialog
        open={open}
        type='modal'
        position='basic'
        size={1100}
        handleClose={modalClose}
        disableButtonCancel
        customHeaderTitle={
          <div className='headerContainer'>
            <div className='headerDot' />
            <h2 className='headerTitle'>{t('LBL00662', 'Price Batch Input')}</h2>
          </div>
        }
        customContentArea={
          <div className={styles.dialogContent}>
            {/* 조회 조건 — 표준 SearchArea (Div/Sales Site CustomDropdown + Project/Model popup + Period) */}
            <SearchArea
              searchButtonLabel={t('LBL00664', 'Search')}
              onSearch={handleFind}
              conditions={
                <>
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00663', 'Div')}
                      labelAlign='right'
                      render={() => (
                        <CustomDropdown
                          disabled
                          value={divisionId}
                          options={divItems.map(i => ({
                            label: String(i.NAME ?? i.CODE),
                            value: String(i.CODE),
                          }))}
                          onChange={(_, option) => setDivisionId(String(option))}
                        />
                      )}
                    />
                  </Grid>
                  {/* No.27 — 단일선택→다중선택 (2026-08-04). 공용 SalesSiteField 재사용(메인 조회조건과 동일 계약). */}
                  <SalesSiteField
                    gridSize={3}
                    value={salesSite}
                    onChange={setSalesSite}
                    division={divisionId}
                  />
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00617', 'Project')}
                      labelAlign='right'
                      render={() => (
                        <div className={styles.popupRow}>
                          <InputField
                            fullWidth
                            value={projectCode}
                            onChange={e => setProjectCode(e.target.value)}
                            onDoubleClick={() => setOpenProject(true)}
                          />
                          <Button
                            appearance='outlined'
                            priority='normal'
                            iconComponent={<FunctionSearchIcon appearance='lined' />}
                            onClick={() => setOpenProject(true)}
                          />
                        </div>
                      )}
                    />
                  </Grid>
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00669', 'Model')}
                      labelAlign='right'
                      render={() => (
                        <div className={styles.popupRow}>
                          <InputField
                            fullWidth
                            value={itemId}
                            onChange={e => setItemId(e.target.value)}
                            onDoubleClick={() => setOpenItem(true)}
                          />
                          <Button
                            appearance='outlined'
                            priority='normal'
                            iconComponent={<FunctionSearchIcon appearance='lined' />}
                            onClick={() => setOpenItem(true)}
                          />
                        </div>
                      )}
                    />
                  </Grid>
                  {/* ⭐ 표준 카탈로그 PeriodField (DatePickerCalendar date-range-multi, 36px datePickerFix).
                      AS-IS 월요일 정렬 — 선택 날짜를 그 주 월요일로 스냅(기존 동작 유지). */}
                  <PeriodField
                    gridSize={4}
                    start={periodFrom}
                    end={periodTo}
                    onChange={(start, end) => {
                      setPeriodFrom(snapMonday(start));
                      setPeriodTo(snapMonday(end));
                    }}
                  />
                </>
              }
            />

            {/* Grid — 고정 컬럼(UI Category division별) + Batch Price + 주별 3단 헤더 (Div~Project 계층 머지) */}
            {/* ⭐ 조회 스피너 (2026-07-07 사용자 요구) — 조회 중 grid 영역에 circular ProgressIndicator overlay.
                gridWrapper=position:relative → placement='parent' 로 grid 위 중앙 표시. Batch 는 자동조회 제외(수동 Search). */}
            <div className={styles.gridWrapper} ref={gridWrapRef}>
              <ProgressIndicator
                shape='circular'
                apprearance='infinite'
                open={loading}
                placement='parent'
              />
              <DataGrid
                gridRef={gridRef as never}
                className={styles.grid}
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={fixedColumns}
                dynamicColumns={dynamicColumns}
                autoGenerateColumns={false}
                allowSorting={true}
                allowMerging={AllowMerging.All}
              />
            </div>

            {/* Action — 표준 buttonWrapper (하단 우측 정렬, @shared/lges Button) */}
            <div className={styles.buttonWrapper}>
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                iconComponent={<FileExceldownloadIcon />}
                onClick={handleExcel}
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00627', 'Close')}
                onClick={modalClose}
              />
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                iconComponent={<ControlConfirmIcon size='small' />}
                iconPosition='leading'
                disabled={loading || rows.length === 0}
                onClick={handleSave}
              />
            </div>
          </div>
        }
      />

      {/* Project popup */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={code => {
          setProjectCode(code ?? '');
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            // ⭐ No.27 — salesSite 가 string[] 로 바뀜(다중선택). 이 팝업 내부 필터는 콤마 split
            //   기준(ItemByDivisionModal searchParam.salesSite?.split(',') 과 동일 계약).
            salesSite: salesSite.length > 0 ? salesSite.join(',') : 'ALL',
            projectCode: '',
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* Item popup */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={id => {
          setItemId(id ?? '');
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            // ⭐ No.27 — salesSite 가 string[] 로 바뀜(다중선택). 이 팝업 내부 필터는 콤마 split
            //   기준(ItemByDivisionModal searchParam.salesSite?.split(',') 과 동일 계약).
            salesSite: salesSite.length > 0 ? salesSite.join(',') : 'ALL',
            projectCode: projectCode || '',
            itemId: '',
          } as never
        }
        callFromCell={true}
      />
    </>
  );
};
