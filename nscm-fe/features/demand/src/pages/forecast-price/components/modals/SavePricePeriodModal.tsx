import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellRangeEventArgs,
  CellRange,
  CellType,
  DataMap,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
  type GridPanel,
  MergeManager,
} from '@mescius/wijmo.grid';
import {
  ItemByDivisionModal,
  PeriodField,
  ProjectByDivisionModal,
  SalesSiteField,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { safeString } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon, FileExceldownloadIcon, FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../forecast-price.constants';
import { useForecastPriceStore } from '../../useForecastPriceStore';
import { buildSavePayload, type SaveRow } from '../../utils/forecast-price.save';

import styles from './SavePricePeriodModal.module.scss';
import { useSavePricePeriodModalStore } from './savePricePeriodModalStore';

// yyyymmdd → 해당 주 "월요일" yyyymmdd (AS-IS drpDateTime 월요일 정렬 L196~202 + MSG00330 정합).
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
// price 문자열 정규화 — ',' 제거 (AS-IS L1746 param_qty.Replace(",","")). 빈값은 '' 유지.
const normPrice = (v: string | number | null | undefined): string =>
  v === undefined || v === null ? '' : String(v).replace(/,/g, '').trim();

/**
 * 숫자 셀 정규화 — 표시 서식(n3)이 먹도록 **문자열 숫자를 number 로** 바꾼다.
 *
 * Wijmo 의 `Column.format` 은 `Globalize.format(value, format)` 을 타는데 값이 string 이면
 * 그대로 돌려준다. 즉 같은 컬럼이라도 SP 가 행마다 number/string 을 섞어 내리면 **string 행만**
 * 서식이 빠져 정수처럼 보인다(사용자 신고 2026-08-22). 편집한 셀은 `dataType=Number` 로 커밋되어
 * 3자리가 되므로 "수정한 것만 3자리" 라는 비대칭이 생긴다.
 *
 * 빈값은 숫자로 만들지 않는다 — 0 으로 바꾸면 "값 없음" 과 "0" 이 구분되지 않고,
 * 저장 payload 가 0 을 실어 보내 원장에 없던 행이 생긴다.
 */
const toNumericCell = (v: unknown): string | number | undefined => {
  if (v === null || v === undefined) return undefined;
  if (typeof v === 'number') return v;
  const s = safeString(v).replace(/,/g, '').trim();
  if (s === '') return undefined;
  const n = Number(s);
  return Number.isFinite(n) ? n : (v as string);
};

// ⭐ UI Category Setup 미로드(BE 메타 실패) 시 fallback — SCM_MST_SHEET_COLUMNS 'Sales Price Save All'
//   실측 25 컬럼 중 표시 컬럼 (2026-07-12 ora.py). 메타 로드 시엔 fixedColumns useMemo 가 대체.
const FALLBACK_FIXED: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Division*', colWth: 50, horzAlgnCd: 'L' },
  { colNm: 'DEPT_ID', colLblNm: 'Team', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'END_CUSTOMER40', colLblNm: 'End Customer*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site*', colWth: 120, horzAlgnCd: 'L' },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'ITEM_ID', colLblNm: 'Model*', colWth: 100, horzAlgnCd: 'L' },
  { colNm: 'ITEM_NAME', colLblNm: 'Model Name', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'DOM_EXP', colLblNm: 'Customs Handbook*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'CURRENCY', colLblNm: 'Currency*', colWth: 60, horzAlgnCd: 'L' },
  { colNm: 'PLANT_SITE_ID', colLblNm: 'Plant Site*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'CELL_PROD_SITE_ID', colLblNm: 'Cell Prod Site*', colWth: 80, horzAlgnCd: 'L' },
  { colNm: 'MEASURE', colLblNm: 'Measure*', colWth: 80, horzAlgnCd: 'L' },
].map(c => ({ ...c, fixed: false, visible: true, display: true })) as RawFlexGridColumnConfig[];

// 앞에서부터 계층 머지 대상 (AS-IS SmartColMerge 등가 — DMF0020 PriceBatchInputModal 동일 4열).
const MERGE_BINDINGS = ['DIVISION_ID', 'DEPT_ID', 'SCM_SITE_ID', 'PROJECT_CODE'];
// 셀 코드→명칭 DataMap 부착/해제 대상 (UI Category 콤보 여부로 gating — 형제 modal 동일).
const DISPLAY_MAP_BINDINGS = new Set([
  'DIVISION_ID',
  'SCM_SITE_ID',
  'DEPT_ID',
  'INCOTERMS',
  'CURRENCY',
  'FCST_TYPE',
  'DOM_EXP',
]);
// 일괄입력 Price — 메타 PRICE_ALL(VISIBLE_FLAG='N') 미반환 시 append 하는 편집 컬럼 상수.
//   AS-IS DefColumns.PriceAll — "Price 일괄입력" 의 유일한 편집 셀.
const PRICE_ALL_COL: RawFlexGridColumnConfig = {
  colNm: 'PRICE_ALL',
  colLblNm: '일괄입력 Price',
  colWth: 130,
  horzAlgnCd: 'R',
  fixed: false, // freeze 미사용 — 다단 헤더 48px 정규화 정상 동작 (형제 modal 검증)
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  cellCtrlObjTpCd: CELL_CONTROL_TYPE.NUMBER,
  scale: 3,
};

interface Props {
  open: boolean;
  modalClose: () => void;
  /** AS-IS LoadData(sDivision, …) — 부모 조회조건 승계 */
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
  defaultEndCustomers: string[];
  defaultSalesSites: string[];
  /** 저장 성공 시 부모 재조회 (AS-IS isSaveOK → 부모 refresh) */
  onSaveResult?: () => void;
}

interface PriceRow {
  DIVISION_ID?: string;
  DEPT_ID?: string;
  END_CUSTOMER?: string;
  END_CUSTOMER40?: string;
  SCM_SITE_ID?: string;
  PLANT_SITE_ID?: string;
  PROJECT_CODE?: string;
  ITEM_ID?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  DOM_EXP?: string;
  CURRENCY?: string;
  MEASURE?: string;
  CELL_PROD_SITE_ID?: string;
  AUTHORITY_YN?: string;
  COL_LIST?: string;
  PRICE_ALL?: string | number;
  /** 조회 직후 PRICE_ALL 초기값 스냅샷 — 변경(AS-IS 빨간색 셀) 판정 기준 */
  __INIT_PRICE_ALL?: string;
  [key: string]: string | number | undefined;
}

// ⭐ 참조 안정 빈 배열 (DataGrid memo 보존 — 형제 modal 동일 사유).
const EMPTY_ROWS: PriceRow[] = [];

// 멀티선택 → SP 파라미터 (콤마 delim / 빈 배열 'ALL' — AS-IS clb ControlValues 'ALL' sentinel).
const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

// title COLUMN_NAME → 3단 헤더 키 (LARGE=년월 / SMALL=주차명 — AS-IS SetSpreadHeaderSpan 그룹 기준).
interface DynHdr {
  lg: string;
  sm: string;
}

/**
 * ⭐ DMF0082 전용 POPUP — SavePricePeriodModal (Price 기간 일괄저장)
 *
 * AS-IS `DMF0082_SaveSalesFuturePrice_Popup.cs` (2,827줄) + `.Designer.cs` (897줄) 1:1.
 *  - 조회조건 6종: clbDivisions(단일·비활성) / clbCustomer(End Customer) / clbSalesSite /
 *    drpDateTime(월요일 스냅) / umltProject+usrButton1(팝업) / umltItem+usrButton2(팝업)
 *  - 버튼 5종: Find / Edit / Save / Excel / Close
 *    (Edit 는 TO-BE 미배선 — PRICE_ALL 만 항상 편집 가능 구조라 잠금 토글 자체가 없음.
 *     AS-IS EditButton 의 W_ 전체 잠금(L935 상시 true)과 동일 결과. MSG00113 도 함께 소멸)
 *  - Grid: 고정 25 컬럼(admin 메타 'Sales Price Save All') + 일괄입력 Price + W_yyyymmdd 3단 헤더
 *    · PRICE_ALL 초기값 = 첫 주차 값 (AS-IS L1316~1324)
 *    · COL_LIST 주차 셀 Pink (AS-IS PJ20200138 L1392~1405)
 *    · AUTHORITY_YN='N' 행 = PRICE_ALL 편집 차단 (AS-IS L1029~1033)
 *    · CELL_PROD_SITE_ID 콤보(AS-IS L1329)는 미배선 — 이 팝업은 행 추가가 없어(I 행 0) 항상 잠김 표시 전용
 *  - SP: 조회 = DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (17 IN — LOC 행만)
 *        시간축/저장주차 = DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE (W_ 표시 / 'W_2%' 저장 — L2740)
 *        저장 = DMF0082_SAVE_MAIN_DATA 17 IN '^' bulk (기배선 fcstNPrice SAVE 라우트 재사용.
 *        KRW/USD 확장·qty 0 → 'D' 재판정은 SP 내부 처리 — SP L1394·L1556 실측)
 *  - AS-IS GET_WEEKDATA / GET_MEASURE_COUNTINFO(_SAVE_PRICE) 는 TO-BE 미배선:
 *    · dtWeek 잠금 분기(L1096)는 "시작일 < 이번주-7일" 전제인데 MSG00409 가 과거구간을 원천 차단 → 불달(dead)
 *    · dtMeasureCount 는 행 배수(measure 3쌍) 계산용인데 이 팝업 GET 은 LOC 단일행 — 배수 상수 1
 *  - MSG (실문구 대사 2026-07-12): 00108/00137/00043 동일 · 00097→00667 · 00133→00004 ·
 *    00002→00429 · 00004→00672(신규) · 00330/00409 ID 승계 등록 · 00079/00113 dead → 미배선
 *  - AS-IS 에 저장 confirm 없음 — TO-BE 표준(형제 PriceBatchInputModal MSG00001) 채택.
 */
export const SavePricePeriodModal = ({
  open,
  modalClose,
  defaultDivision,
  defaultPeriod,
  defaultEndCustomers,
  defaultSalesSites,
  onSaveResult,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<FlexGridType<PriceRow> | null>(null);
  const headerNormalizeRef = useRef<() => void>(() => undefined);
  const gridWrapRef = useRef<HTMLDivElement>(null);

  // ── 조회조건 상태 (AS-IS LoadData 승계 + Form_Load 초기화) ──
  const { divisionId, endCustomers, salesSites, projectCode, itemId, periodFrom, periodTo } =
    useSavePricePeriodModalStore(state => state.searchParams);
  const setSearchParams = useSavePricePeriodModalStore(state => state.setSearchParams);
  const resetSearchParams = useSavePricePeriodModalStore(state => state.resetSearchParams);
  const searched = useSavePricePeriodModalStore(state => state.searched);
  const setSearched = useSavePricePeriodModalStore(state => state.setSearched);
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [saving, setSaving] = useState(false); // AS-IS blnWork (연속작업 방지 — MSG00137)

  // Project 활성 = Division 81*/82 (AS-IS lblProject.Enabled L281/L313 — 40 은 비활성+클리어)
  const projectEnabled = divisionId.startsWith('81') || divisionId === '82';

  // ⭐ 고정 컬럼 메타 — admin UI Category Setup 'Sales Price Save All' (store 동적 fetch).
  const metaColumns = useForecastPriceStore(s => s.savePriceColumns);
  const fetchSavePriceColumns = useForecastPriceStore(s => s.fetchSavePriceColumns);

  useEffect(() => {
    if (open) {
      // 재진입 초기화 — AS-IS LoadData + Form_Load 1:1 (조회조건 승계 + 미조회 상태).
      // ⭐ 기간 기본값 — 부모 기간의 월요일 스냅 + 시작일은 이번 주 월요일 이상
      //   (AS-IS Form_Load L189~202: MinDate1 = 이번주 월요일 + From/To 월요일 정렬).
      const thisMon = snapMonday(todayYmd());
      const fromMon = snapMonday(defaultPeriod.start);
      const from = fromMon > thisMon ? fromMon : thisMon;
      const to = snapMonday(defaultPeriod.end);
      resetSearchParams({
        divisionId: defaultDivision,
        endCustomers: defaultEndCustomers,
        salesSites: defaultSalesSites,
        projectCode: '',
        itemId: '',
        periodFrom: from,
        periodTo: to < from ? from : to,
      });
      setSearched(false);
    }
    // ⭐ 초기화는 **모달 open 전환 시에만** — deps 에 default* 를 넣으면 부모 리렌더(예: Save confirm
    //   alert 표시)마다 새 참조(defaultPeriod={{...}})가 들어와 effect 가 재실행되고 searched=false 로
    //   리셋 → 저장 확인 중에 그리드가 비워지는 문제(사용자 확인 2026-07-23). open 시점 값만 사용.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // ⭐ 고정 컬럼 = admin UI Category Setup 'Sales Price Save All' 메타를 **현재 Division 기준**으로 fetch.
  //   (구: defaultDivision 으로 1회만 fetch → Division 변경 시 컬럼 미갱신 + 실패 시 하드코딩 FALLBACK 잔존.
  //    division 변경마다 재조회 = 메타 division-linked 컬럼 반영. PR_GET_SHEET_COLUMN_LIST 가 division 필터.)
  useEffect(() => {
    if (open && divisionId) fetchSavePriceColumns(divisionId);
  }, [open, divisionId, fetchSavePriceColumns]);

  // ===== Combo — Div 표시 + 셀 코드→명칭 DataMap 7종 (형제 PriceBatchInputModal 동일 등록명) =====
  const [divQ, ssQ, teamQ, incoQ, currQ, fcstQ, customsQ, endCustQ] = useTabComboQueries({
    filters: [
      'MyDivision',
      'SalesSite',
      { comboId: 'TeambyDivision', divisionId },
      'Incoterms',
      'CurrencyList',
      { comboId: 'FcstType', divisionId },
      { comboId: 'CustomsHandbook', divisionId },
      // ⭐ [CASCADE 2026-08-22] End Customer 조회조건 콤보 = AS-IS 팝업과 동일 등록본.
      //   AS-IS `DMF0082_SaveSalesFuturePrice_Popup.cs:260`
      //     Filter["DIVISION_ID"] = sDivision;
      //     dtEndCustomer = DataService.GetDMInnerTable("EndCustomerByDivision", Filter);
      //   (같은 블록의 `Filter["DEPT_ID"]` 는 **주석**이라 팀 축은 이 팝업에 없다 — 조회조건에도 Team 없음.)
      //   구 배선은 공용 'EndCustomer' 콤보 + 클라 division 필터라 AS-IS 산식과 달랐다.
      'EndCustomerByDivision',
    ],
  });
  // 'ALL' 센티널 제거 — CustomDropdown 이 선택 해제 시 'ALL' 을 내보낸다(CustomDropdown.tsx:182-184).
  //   그대로 서버 바인드에 넘기면 코드값 'ALL' 로 조회돼 0행이 된다(메인 화면과 동일 처리).
  const endCustomerSel = endCustomers.filter(v => v !== 'ALL');
  type ComboItem = { CODE?: string; NAME?: string };
  const divItems = (divQ ?? []) as ComboItem[];
  // UI Category 존중 — cellCtrlObjTpCd=COMBO 컬럼만 DataMap 적용 (메타 미로드 시 전부 적용).
  const comboBindings = useMemo<Set<string> | null>(() => {
    if (!metaColumns || metaColumns.length === 0) return null;
    const s = new Set<string>();
    for (const c of metaColumns) if (c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.COMBO) s.add(c.colNm);
    return s;
  }, [metaColumns]);
  const dataMaps = useMemo<Record<string, DataMap | null>>(() => {
    const make = (binding: string, q: ComboItem[] | undefined): DataMap | null => {
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
  const dataMapsRef = useRef(dataMaps);
  dataMapsRef.current = dataMaps;

  // ⭐ 고정 컬럼 — 메타 순수 구동 (visible 필터 + 표시전용 강제. PRICE_ALL 만 편집 컬럼으로 별도 구성).
  const fixedColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const base: RawFlexGridColumnConfig[] =
      metaColumns && metaColumns.length > 0
        ? metaColumns
            // ⭐ 2026-08-22 — 시트 메타가 AS-IS `DEFAULT_FLAG` 기준으로 재확정되면서(패키지
            //   SHEETCOL_SAVEPRICE_VISIBLE_FROM_DEFAULTFLAG_20260822) AS-IS 가 **데이터로만** 싣던
            //   폭 0 컬럼(AUTHORITY_YN·DISPLAY_SEQ·NEW_FLAG·COL_LIST)도 VISIBLE_FLAG='Y' 가 됐다.
            //   AS-IS 는 폭 0 으로 숨겼으므로 여기서도 폭 0 은 컬럼으로 만들지 않는다(#144 폭0=숨김 규약).
            //   `PRICE_ALL` 은 메타도 'Y' 지만 아래에서 편집 상수로 append 하므로 이름으로 제외(중복 방지).
            .filter(c => c.visible !== false && c.colNm !== 'PRICE_ALL' && (c.colWth ?? 80) > 0)
            .map(c => ({
              colNm: c.colNm,
              colLblNm: c.colLblNm || c.colNm,
              colWth: c.colWth ?? 80,
              horzAlgnCd: c.horzAlgnCd ?? 'L',
              fixed: false,
              visible: true,
              display: true,
              inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // 표시전용 (편집 = PRICE_ALL 만)
            }))
        : FALLBACK_FIXED.map(c => ({ ...c, inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY }));
    return [...base, PRICE_ALL_COL];
  }, [metaColumns]);
  const fixedBindings = useMemo(() => fixedColumns.map(c => c.colNm), [fixedColumns]);

  // ===== 조회 SP 2종 (enabled:false — Find 버튼 수동. AS-IS FindData 는 자동조회 주석처리 L214) =====
  const sesUserId = useSessionStore(s => s.session.userId ?? '');
  const userGroup = useSessionStore(s => s.session.groupId || (s.session.userId ?? ''));

  const filters = useMemo(
    () =>
      open
        ? ({
            divisionId,
            deptId: 'ALL',
            // 빈 multi-select = 'ALL' 전송 (SP 토큰필터 UF_FX_String_SplitForIN('')=0행 → 전량배제 회피).
            endCustomer: endCustomers.length ? joinComma(endCustomers) : 'ALL',
            scmSiteId: salesSites.length ? joinComma(salesSites) : 'ALL',
            plantSiteId: 'ALL',
            projectCode,
            itemId,
            customerProjectCode: '',
            customerModel: '',
            fromYyyymmdd: snapMonday(periodFrom),
            toYyyymmdd: snapMonday(periodTo),
            biztype: 'ALL',
            sesUserId,
            userGroup,
            owner: '',
            overRange: 'N',
            invalidExec: 'N',
          } satisfies ProcRequest<MENU_ID, SHEETS.SAVE_PRICE_DATA>)
        : undefined,
    [
      open,
      divisionId,
      endCustomers,
      salesSites,
      projectCode,
      itemId,
      periodFrom,
      periodTo,
      sesUserId,
      userGroup,
    ]
  );
  const { data, refetch, isFetching } = useTabProcQuery<MENU_ID, SHEETS.SAVE_PRICE_DATA>({
    menuId: MENU_ID,
    sheetName: SHEETS.SAVE_PRICE_DATA,
    tabId: MENU_ID,
    filters,
    enabled: false,
  });

  const titleFilters = useMemo(
    () =>
      open
        ? ({
            startYyyymmdd: snapMonday(periodFrom),
            endYyyymmdd: snapMonday(periodTo),
            sesUserId,
            divisionId,
          } satisfies ProcRequest<MENU_ID, SHEETS.SAVE_PRICE_TITLE>)
        : undefined,
    [open, periodFrom, periodTo, sesUserId, divisionId]
  );
  const {
    data: titleData,
    refetch: refetchTitle,
    isFetching: isTitleFetching,
  } = useTabProcQuery<MENU_ID, SHEETS.SAVE_PRICE_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SAVE_PRICE_TITLE,
    tabId: MENU_ID,
    filters: titleFilters,
    enabled: false,
  });

  const loading = isFetching || isTitleFetching;

  // ── 시간축 (title W_ 행 — AS-IS CreateSheetHeaderColumn + SetSpreadColumn: W_ 만 표시, M_/B_ 숨김) ──
  const titleRows = useMemo(
    () =>
      ((titleData as unknown as Record<string, unknown[]>)?.data ?? []) as Array<
        Record<string, string>
      >,
    [titleData]
  );
  const weekTitleRows = useMemo(
    () => titleRows.filter(r => /^W_\d{8}$/.test(String(r.COLUMN_NAME ?? ''))),
    [titleRows]
  );
  const weekBindings = useMemo(
    () => weekTitleRows.map(r => String(r.COLUMN_NAME)).sort(),
    [weekTitleRows]
  );
  // 헤더 정규화가 "예상 tier 수" 를 선제 인지하도록 ref (형제 modal 검증 패턴).
  const weekBindingsRef = useRef(weekBindings);
  weekBindingsRef.current = weekBindings;
  // binding → 3단 헤더 그룹 키 (LARGE=년월 / SMALL=주차명) — 수동 수평 머지 판정용.
  const dynHdrMap = useMemo(() => {
    const m = new Map<string, DynHdr>();
    for (const r of weekTitleRows) {
      m.set(String(r.COLUMN_NAME), {
        lg: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
        sm: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
      });
    }
    return m;
  }, [weekTitleRows]);
  const dynHdrMapRef = useRef(dynHdrMap);
  dynHdrMapRef.current = dynHdrMap;

  // ⭐ 3단 nested 동적 컬럼 — 년월(LARGE) → 주차(SMALL) → 시작일 MMDD(leaf. 표시전용 — AS-IS L935
  //   가 Edit 모드에서도 W_ 전체 잠금 = 오직 PRICE_ALL 로만 일괄 입력).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (weekTitleRows.length === 0) return [];
    type LgBucket = { sm: Map<string, FlexGridColumnConfig[]> };
    const lgMap = new Map<string, LgBucket>();
    for (const r of weekTitleRows) {
      const binding = String(r.COLUMN_NAME);
      const lg = String(r.LARGE_CLASS_LABEL_NAME ?? '');
      const sm = String(r.SMALL_CLASS_LABEL_NAME ?? '');
      const leafLabel = String(r.COLUMN_LABEL_NAME ?? binding.slice(6)); // MMDD
      let bucket = lgMap.get(lg);
      if (!bucket) {
        bucket = { sm: new Map() };
        lgMap.set(lg, bucket);
      }
      let smCols = bucket.sm.get(sm);
      if (!smCols) {
        smCols = [];
        bucket.sm.set(sm, smCols);
      }
      smCols.push({
        binding,
        header: leafLabel,
        align: 'right',
        format: 'n3',
        width: 90,
        allowDragging: false,
        allowMerging: false,
        allowResizing: true,
        allowSorting: false,
        visible: true,
        _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        _display: true,
      });
    }
    return [...lgMap.entries()].map(([lg, bucket]) => ({
      header: lg,
      align: 'center',
      columns: [...bucket.sm.entries()].map(([sm, leafCols]) => ({
        header: sm,
        align: 'center',
        columns: leafCols,
      })),
    }));
  }, [weekTitleRows]);

  // ── 데이터 rows — 커서 키 정규화 + PRICE_ALL 초기값 세팅 (AS-IS L1316~1324) ──
  //   키 정규화: 동적 PIVOT alias 가 W_yyyymmdd_PVT / "W_yyyymmdd" 등으로 반환될 수 있어
  //   /W_(\d{8})/ 매칭 키를 canonical W_yyyymmdd 로 재매핑 (title binding 과 정합).
  const rows = useMemo<PriceRow[]>(() => {
    if (!searched) return EMPTY_ROWS;
    const raw = ((data as unknown as Record<string, unknown[]>)?.data ?? []) as Array<
      Record<string, unknown>
    >;
    if (raw.length === 0) return EMPTY_ROWS;
    const firstWeek = weekBindings[0];
    return raw.map(r => {
      const out: PriceRow = {};
      for (const [k, v] of Object.entries(r)) {
        const m = /W_(\d{8})/.exec(k);
        // ⭐ 2026-08-22 — 주차(W_) 값을 **숫자로 정규화**한다 (사용자 신고: "수정한 컬럼은 3자리로
        //   나오는데 수정하지 않은 컬럼은 정수로 나오는 행이 있다").
        //   원인: Wijmo 의 `format`(n3) 은 **숫자에만** 적용된다(Globalize.format). SP/JDBC 가
        //   같은 컬럼을 행에 따라 string 으로 내려주면 그 셀만 서식이 안 붙어 raw 로 보인다.
        //   편집하면 `dataType=Number`(normalizeDynamicColumns)로 커밋되어 그때부터 3자리가 되는데,
        //   그 비대칭이 바로 신고 증상이다. 표시 이전에 타입을 맞춰 원천 제거한다.
        //   ⚠ 숫자 컬럼만 변환한다 — 코드성 문자열(예: DIVISION_ID '0082')을 숫자로 바꾸면
        //     앞자리 0 이 날아가므로 W_ 이외 키는 절대 건드리지 않는다.
        out[m ? `W_${m[1]}` : k] = m ? toNumericCell(v) : (v as string | number);
      }
      // PRICE_ALL 초기값 = 첫 주차 값 (AS-IS: GetText(i, PriceAll+1) → SetText(i, PriceAll))
      const init = firstWeek !== undefined ? out[firstWeek] : undefined;
      out.PRICE_ALL = init;
      out.__INIT_PRICE_ALL = normPrice(init);
      return out;
    });
  }, [data, searched, weekBindings]);

  // ===== Find (AS-IS FindData L1153~1230 — 검증 순서 1:1) =====
  const handleFind = () => {
    // 연속 작업 방지 (AS-IS blnWork → MSG00137)
    if (loading || saving) {
      void setAlert({ type: 'alert', content: t(MSG.WORK_IN_PROGRESS, '_Task in progress.') });
      return;
    }
    // ⭐ 검증·조회·저장은 월요일 스냅값 기준 (선택 중엔 raw 보관 → 여기서 정렬).
    const fromMon = snapMonday(periodFrom);
    const toMon = snapMonday(periodTo);
    // 기간 역전 (AS-IS L1177 → MSG00108)
    if (fromMon > toMon) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '_Invalid period.') });
      return;
    }
    // 과거구간 차단 — 이번 주 월요일 이전 시작 불가 (AS-IS L1195 → MSG00409)
    if (fromMon < snapMonday(todayYmd())) {
      void setAlert({ type: 'alert', content: t(MSG.PAST_PERIOD, '_Past period not allowed.') });
      return;
    }
    // (AS-IS L1203 MSG00330 "월요일 선택" 검증은 불필요 — 이제 snapMonday 로 항상 월요일 정렬됨)
    // Division 필수 (AS-IS L1224 MSG00097 → TO-BE MSG00667)
    if (!divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_Select Division.') });
      return;
    }
    // 조회 확정 시 표시값도 월요일 스냅으로 정렬 (선택 중엔 raw → Find 시점에 커밋).
    if (periodFrom !== fromMon || periodTo !== toMon) {
      setSearchParams({ periodFrom: fromMon, periodTo: toMon });
    }
    setSearched(true);
    void refetchTitle?.();
    void refetch?.();
  };

  // ===== Save (AS-IS SaveData L1454~2097 — 변경분 × 저장주차 확장, 17 IN '^' bulk) =====
  const handleSave = async () => {
    if (loading || saving) {
      void setAlert({ type: 'alert', content: t(MSG.WORK_IN_PROGRESS, '_Task in progress.') });
      return;
    }
    // 변경(AS-IS 빨간색 셀) 판정 — PRICE_ALL ≠ 조회 초기값 (없으면 MSG00133 → TO-BE MSG00004)
    const changedRows = rows.filter(r => normPrice(r.PRICE_ALL) !== (r.__INIT_PRICE_ALL ?? ''));
    if (changedRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // 저장 주차 = title COLUMN_NAME LIKE 'W_2%' (AS-IS GetSaveDateFromTo L2740)
    const saveWeeks = weekBindings.filter(b => /^W_2\d{7}$/.test(b)).map(b => b.slice(2));
    if (saveWeeks.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '_No weeks in period.') });
      return;
    }

    // AS-IS 에 저장 confirm 없음 — TO-BE 표준(형제 modal) MSG00001 채택.
    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '_Save?') });
    if (!confirmed) return;

    // 저장 rows — 행별 일괄 price 를 기간 내 모든 주차로 확장 (AS-IS L1695~1783).
    //   projectCode/endCustomer 는 둘 다 END_CUSTOMER40 (AS-IS L1703~1706 — 81·82 는 PROJECT_CODE
    //   alias 라 동일값). measure 는 행 그대로 'LOC' — KRW/USD 확장·qty 0 'D' 재판정은 SP 내부.
    const saveRows: SaveRow[] = [];
    for (const r of changedRows) {
      const qtyRaw = normPrice(r.PRICE_ALL);
      const qty = qtyRaw === '' ? '0' : qtyRaw; // AS-IS L1749 — 빈값 '0'
      const activeFlag = qty === '0' ? 'D' : 'M'; // AS-IS stempAction L1753~1759 의도 + SP L1394 정합
      const projectKey = String(r.END_CUSTOMER40 ?? r.PROJECT_CODE ?? '');
      for (const yyyymmdd of saveWeeks) {
        saveRows.push({
          activeFlag,
          divisionId: String(r.DIVISION_ID ?? ''),
          projectCode: projectKey,
          endCustomer: projectKey,
          scmSiteId: String(r.SCM_SITE_ID ?? ''),
          itemId: String(r.ITEM_ID ?? ''),
          domExp: String(r.DOM_EXP ?? ''),
          fcstType: String(r.FCST_TYPE ?? ''),
          incoterms: String(r.INCOTERMS ?? ''),
          measure: String(r.MEASURE ?? ''),
          plantSite: String(r.PLANT_SITE_ID ?? ''),
          // 이 팝업 조회 커서에는 AS FROM SITE 개념이 없다 (기간 일괄 price 저장 전용).
          //   NULL 이 아닌 공란을 보내 메인 화면 저장과 같은 MERGE 비교값을 유지한다.
          asFromSite: '',
          cellProdSiteId: String(r.CELL_PROD_SITE_ID ?? ''),
          yyyymmdd,
          currency: String(r.CURRENCY ?? ''),
          qty,
        });
      }
    }

    setSaving(true);
    try {
      // 기배선 fcstNPrice SAVE 라우트 재사용 — DMF0082_SAVE_MAIN_DATA (PROC_M 17 row 실측 일치).
      const res = await apiClient.post<
        { RESULT_CODE?: string; RESULT_MSG?: string; EVENT?: string }[]
      >(`/${MENU_ID}/FcstNPrice/SAVE/call-proc`, buildSavePayload(saveRows, sesUserId));
      const result = (res.data.result ?? [])[0];
      if (result && result.RESULT_CODE !== undefined && String(result.RESULT_CODE) !== '0') {
        // 실패 — SP RESULT_MSG 그대로 표기 (AS-IS L2018/L2025 MessageBox.Show 1:1)
        void setAlert({
          type: 'alert',
          content: String(result.RESULT_MSG ?? t(MSG.DUP_SAVE_ERROR, '_Save error.')),
        });
        return;
      }
      // 성공 — {0}개 저장 (AS-IS MSG00004 + RESULT_CNT → TO-BE MSG00672 + EVENT=N_LOG_COUNT)
      const cnt = String(result?.EVENT ?? saveRows.length);
      void setAlert({
        type: 'alert',
        content: t(MSG.SAVED_COUNT, '_{0} data saved.').replace('{0}', cnt),
      });
      onSaveResult?.(); // 부모 재조회 (AS-IS isSaveOK)
      void refetch?.(); // AS-IS L2082 FindData(false) — 저장 후 재조회
    } catch (e) {
      const msg = e instanceof Error ? e.message : t(MSG.DUP_SAVE_ERROR, '_Save error.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setSaving(false);
    }
  };

  // ===== Excel (AS-IS ExcelButton — 화면 표시 그대로 export) =====
  const handleExcel = () => {
    const g = gridRef.current;
    if (!g || rows.length === 0) return;
    void GridAction.excelDownload(g as never, t('LBL00662', 'Price Batch Input'));
  };

  // ⭐ #70 — formatItem(PRICE_ALL 편집색/COL_LIST Pink) + AUTHORITY_YN 편집가드 + 계층 머지 +
  //   scroll invalidate + DataMap 재부착. deps 에 컬럼 구성 포함(closure 정합 — 형제 modal 동일).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    for (let i = 0; i < g.columns.length; i++) g.columns[i].allowMerging = true;
    g.allowMerging = AllowMerging.All;

    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const item = (e.panel.rows[e.row] as unknown as { dataItem?: PriceRow })?.dataItem;
      // PRICE_ALL — 권한 행만 editable Yellow, 무권한 행 Gray (AS-IS AUTHORITY_YN 잠금 L1029)
      if (binding === 'PRICE_ALL') {
        const editable = (item?.AUTHORITY_YN ?? '') === 'Y';
        toggleClass(e.cell, 'wj-cell-editable', editable);
        toggleClass(e.cell, 'wj-cell-non-editable', !editable);
        return;
      }
      // 주차 셀 — 표시전용 White + COL_LIST(범위초과) Pink (AS-IS L1392~1405)
      if (/^W_\d{8}$/.test(binding)) {
        const colList = String(item?.COL_LIST ?? '');
        const isOver = colList !== '' && colList.split(',').includes(binding);
        toggleClass(e.cell, 'wj-cell-editable', false);
        toggleClass(e.cell, 'wj-cell-non-editable', false);
        toggleClass(e.cell, 'overRangeCell', isOver);
        return;
      }
      // 고정 표시전용 컬럼 = White 기본 (hook #95 — 전체 회색 금지)
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-non-editable', false);
    };
    g.formatItem.addHandler(formatHandler);

    // AUTHORITY_YN='N' 행 PRICE_ALL 편집 차단 (AS-IS 권한행 잠금 1:1)
    const editGuard = (_s: unknown, e: CellRangeEventArgs) => {
      const binding = e.panel.columns[e.col]?.binding ?? '';
      if (binding !== 'PRICE_ALL') return;
      const item = (e.panel.rows[e.row] as unknown as { dataItem?: PriceRow })?.dataItem;
      if ((item?.AUTHORITY_YN ?? '') !== 'Y') e.cancel = true;
    };
    g.beginningEdit.addHandler(editGuard);

    // scroll 시 머지 재계산 (hook #38 viewport sticky)
    const handleScrollInvalidate = () => g.invalidate();
    g.scrollPositionChanged.addHandler(handleScrollInvalidate);

    // MergeManager — ① 데이터셀 계층 머지(Div→Team→Site→Project — AS-IS SmartColMerge 등가)
    //               ② 헤더 머지(고정 3단 세로 span + 동적 W_ 1·2단 수평 — 커스텀 매니저 설치 시
    //                  nested 그룹 네이티브 span 무효 → 수동 머지 의무, hook #108)
    class SavePriceMergeManager extends MergeManager {
      getMergedRange(panel: GridPanel, r: number, c: number, _clip = true): CellRange | null {
        const col = panel.columns[c];
        if (!col) return null;
        const binding = col.binding ?? '';

        if (panel.cellType === CellType.Cell && MERGE_BINDINGS.includes(binding)) {
          const view = panel.rows;
          const ri = (i: number): PriceRow | undefined =>
            (view[i] as unknown as { dataItem?: PriceRow })?.dataItem;
          if (!ri(r)) return null;
          const minRow = panel.viewRange.row;
          const maxRow = panel.viewRange.row2;
          const idx = MERGE_BINDINGS.indexOf(binding);
          const leftBindings = MERGE_BINDINGS.slice(0, idx + 1);
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

        if (panel.cellType === CellType.ColumnHeader) {
          if (fixedBindings.includes(binding)) {
            return new CellRange(0, c, panel.rows.length - 1, c);
          }
          const dyn = dynHdrMapRef.current.get(binding);
          if (dyn && (r === 0 || r === 1)) {
            const keyOf = (b: string): string => {
              const d = dynHdrMapRef.current.get(b);
              if (!d) return '';
              return r === 0 ? d.lg : `${d.lg}|${d.sm}`;
            };
            const key = keyOf(binding);
            let c1 = c,
              c2 = c;
            while (c1 > 0 && keyOf(panel.columns[c1 - 1]?.binding ?? '') === key) c1--;
            while (
              c2 < panel.columns.length - 1 &&
              keyOf(panel.columns[c2 + 1]?.binding ?? '') === key
            )
              c2++;
            if (c1 === c2) return null;
            return new CellRange(r, c1, r, c2);
          }
        }
        return null;
      }
    }
    g.mergeManager = new SavePriceMergeManager();

    // updatedLayout — combo DataMap 재부착 (wrapper columnGroups 재적용이 dataMap wipe — 룰 정합)
    const reattachDataMaps = () => {
      const maps = dataMapsRef.current;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        const dm = maps[binding];
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
        g.beginningEdit?.removeHandler(editGuard);
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
  }, [weekBindings, fixedBindings]);

  // ⭐⭐ 헤더 총높이 48px 상시 정규화 (hook #93 — 1단48/3단16. 형제 modal 검증 raf 루프 패턴:
  //   grid 인스턴스 교체 감지 재부착 + 실제/예상 tier 이원 계산으로 어떤 build 시점에도 총합 48 불변).
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let attached: FlexGridType<PriceRow> | null = null;
    const normalizeHeader = () => {
      const g = gridRef.current;
      if (!g) return;
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const expectedTiers = weekBindingsRef.current.length > 0 ? 3 : 1;
      const actualTiers = headerRows.length;
      const perDefault = Math.round(48 / expectedTiers);
      const perActual = Math.round(48 / actualTiers);
      const ok =
        Math.round(headerRows.defaultSize) === perDefault &&
        Array.from({ length: actualTiers }).every(
          (_, i) => Math.round(headerRows[i]?.height ?? 0) === perActual
        );
      if (ok) return;
      headerRows.defaultSize = perDefault;
      for (let i = 0; i < actualTiers; i++) headerRows[i].height = perActual;
    };
    headerNormalizeRef.current = normalizeHeader;
    const loop = () => {
      const g = gridRef.current;
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

  // ⭐ 콤보 도착 시 DataMap 재부착 (핸들러 재등록 없이 — flicker 방지, 형제 modal 동일)
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
        col.dataMap = null;
        changed = true;
      }
    }
    if (changed) g.invalidate();
  }, [dataMaps]);

  // ⭐ 컨테이너 리사이즈 재측정 (hook wijmo-resize-invalidate — CustomDialog open 애니메이션 후
  //   지연 build 되는 3단 헤더 높이 정규화 보장. 형제 modal ResizeObserver 패턴 1:1)
  useEffect(() => {
    if (!open) return;
    let raf = 0;
    let ro: ResizeObserver | null = null;
    const attach = () => {
      const el = gridWrapRef.current;
      if (!el || typeof ResizeObserver === 'undefined') {
        if (!el) raf = requestAnimationFrame(attach);
        return;
      }
      ro = new ResizeObserver(() => {
        const g = gridRef.current;
        if (!g) return;
        try {
          g.invalidate(true);
          headerNormalizeRef.current();
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
        size={1160}
        height='60vh'
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
            {/* 조회조건 (AS-IS Designer 1:1 — Division/End Customer/Sales Site/Period/Project/Model.
                #94: 36px·1행 4개. Division 비활성 = AS-IS clbDivisions.Enabled=false L369) */}
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
                          onChange={(_, option) => setSearchParams({ divisionId: String(option) })}
                        />
                      )}
                    />
                  </Grid>
                  {/* End Customer — [PJ2025-50188] 추가 조회조건.
                      ⭐ [CASCADE 2026-08-22] 메인 화면 ForecastPriceForm L120~150 과 동일 산식으로 교체.
                        · 콤보 = `EndCustomerByDivision` (AS-IS 팝업 L260 등록본 1:1)
                        · division 필터를 **명시 비교**로 건다 — 공용 `toOptions` 의 `|| !r.DIVISION_ID`
                          우회는 division 이 빈 행을 전부 통과시킨다(메인 화면에서 같은 이유로 제거).
                        · 선택 변경 시 하위(Sales Site) clear — cascade 의 필수 짝. */}
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00503', 'End Customer')}
                      labelAlign='right'
                      render={() => (
                        <CustomDropdown
                          multiple
                          allOption
                          useClearIcon
                          limitTags={1}
                          value={endCustomers.join(',')}
                          options={
                            ((endCustQ ?? []) as Array<Record<string, string>>)
                              .filter(item => item.DIVISION_ID === divisionId)
                              .map(item => ({
                                label: String(item.NAME ?? item.CODE),
                                value: String(item.CODE),
                              })) ?? []
                          }
                          onChange={(_, selected) => {
                            setSearchParams({
                              endCustomers: String(selected ?? '')
                                .split(',')
                                .filter(Boolean),
                              salesSites: [], // 상위 변경 → 하위 초기화
                            });
                          }}
                        />
                      )}
                    />
                  </Grid>
                  {/* Sales Site — ⭐ [CASCADE 2026-08-22] Division + End Customer 서버 바인드.
                      AS-IS 는 `UserSiteByEndCustomer(..., division, sEndCustomer)` 를 호출하지만
                      `sEndCustomer` 는 **필드(L45=null)** 이고 값을 넣는 L224 가 주석이라 실제로는
                      필터가 걸리지 않는다(= AS-IS 미완성). 메인 화면에서 이미 확정한 산식으로 맞춘다.
                      div40 + End Customer 미선택 = BigFilter 'ScmSitebyEndCustomer40'(전체 40),
                      그 외 = 'UserSiteByEndCustomer'(권한 D + 'W' 제외 + 고객 종속). */}
                  <SalesSiteField
                    gridSize={3}
                    division={divisionId}
                    comboId={
                      divisionId === '40' && endCustomerSel.length === 0
                        ? 'ScmSitebyEndCustomer40'
                        : 'UserSiteByEndCustomer'
                    }
                    endCustomer={endCustomerSel.join(',')}
                    value={salesSites}
                    onChange={v => setSearchParams({ salesSites: v })}
                  />
                  {/* Period — 월요일 스냅 (AS-IS drpDateTime 월요일 정렬).
                      ⚠️ 첫 클릭(단일 날짜) 때 스냅하면 제어값이 픽커의 range 앵커와 어긋나 두번째 날짜
                         클릭 시 첫 날짜가 지워진다(사용자 확인 2026-07-23). → 두 날짜가 모두 찍힌
                         **완전한 range(start≠end)** 일 때만 월요일 스냅, 첫 클릭(단일)은 raw 로 보관.
                         (조회/저장/검증은 별도로 snapMonday 적용 — 어떤 경우에도 월요일 정렬 보장.) */}
                  <PeriodField
                    gridSize={3}
                    start={periodFrom}
                    end={periodTo}
                    onChange={(start, end) => {
                      if (start && end && start !== end) {
                        setSearchParams({ periodFrom: snapMonday(start), periodTo: snapMonday(end) });
                      } else {
                        setSearchParams({ periodFrom: start, periodTo: end });
                      }
                    }}
                  />
                  {/* Project — 81계열/82 만 활성 (AS-IS lblProject.Enabled). 팝업 = usrButton1 1:1 */}
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00617', 'Project')}
                      labelAlign='right'
                      render={() => (
                        <div className={styles.popupRow}>
                          <InputField
                            fullWidth
                            disabled={!projectEnabled}
                            value={projectCode}
                            InputProps={{ readOnly: true }}
                            onDoubleClick={() => projectEnabled && setOpenProject(true)}
                          />
                          <Button
                            appearance='outlined'
                            priority='normal'
                            disabled={!projectEnabled}
                            iconComponent={<FunctionSearchIcon appearance='lined' />}
                            onClick={() => setOpenProject(true)}
                          />
                        </div>
                      )}
                    />
                  </Grid>
                  {/* Model — 팝업 = usrButton2 (DM0002_ItembyDivisionPopupEx → ItemByDivisionModal) */}
                  <Grid size={3}>
                    <FormItem
                      label={t('LBL00669', 'Model')}
                      labelAlign='right'
                      render={() => (
                        <div className={styles.popupRow}>
                          <InputField
                            fullWidth
                            value={itemId}
                            InputProps={{ readOnly: true }}
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
                </>
              }
            />

            {/* Grid — 고정 25 컬럼(admin 메타) + 일괄입력 Price + 주차 3단 헤더 (계층 머지) */}
            <div className={styles.gridWrapper} ref={gridWrapRef}>
              {/* ⭐ 2026-08-22 — 저장 중에도 스피너를 띄운다(사용자 요청).
                  구 `open={loading}` 은 조회축(`isFetching || isTitleFetching`)만 봐서 저장 동안
                  아무 표시가 없었다. 저장은 '^' bulk 로 수백~수천 행을 한 번에 보내 체감이 길다.
                  버튼 disabled 는 이미 `loading || saving` 로 묶여 있어(Save L1097) 판정축을 맞춘다. */}
              <ProgressIndicator
                shape='circular'
                apprearance='infinite'
                open={loading || saving}
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

            {/* Action — AS-IS btnButtonList: Find(SearchArea)/Edit(불요)/Save/Excel/Close */}
            <div className={styles.buttonWrapper}>
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                iconComponent={<FileExceldownloadIcon />}
                onClick={handleExcel}
              />
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                iconComponent={<ControlConfirmIcon size='small' />}
                iconPosition='leading'
                disabled={loading || saving || rows.length === 0}
                onClick={() => void handleSave()}
              />
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00627', 'Close')}
                onClick={modalClose}
              />
            </div>
          </div>
        }
      />

      {/* Project popup (AS-IS SCM0002_ProjectbyDivisionPopupEx L2251~2268) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={code => {
          setSearchParams({ projectCode: code ?? '' });
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: joinComma(endCustomers),
            salesSite: joinComma(salesSites),
            projectCode: '',
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* Item popup (AS-IS DM0002_ItembyDivisionPopupEx L2271~2297) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={id => {
          setSearchParams({ itemId: id ?? '' });
        }}
        preSearchParams={
          {
            divisionId,
            deptId: 'ALL',
            endCustomer: joinComma(endCustomers),
            salesSite: joinComma(salesSites),
            projectCode: projectCode || '',
            // [hook #143 §2] 폼에 입력돼 있는 Model 을 팝업 조회조건으로 이어 준다.
            itemId,
          } as never
        }
        callFromCell={true}
      />
    </>
  );
};
