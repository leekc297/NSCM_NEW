import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ColumnSettingModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../components';

import { ExchangeRateModal } from './components/modals/ExchangeRateModal';
import { PriceBatchInputModal } from './components/modals/PriceBatchInputModal';
import {
  SalesPriceRangeModal,
  type SalesPriceRangeRow,
} from './components/modals/SalesPriceRangeModal';
import { SalesPriceVersionModal } from './components/modals/SalesPriceVersionModal';
import { SalesFuturePriceForm } from './components/SalesFuturePriceForm';
import { SalesFuturePriceGrid } from './components/SalesFuturePriceGrid';
import { useSalesFuturePriceValidation } from './hooks/useSalesFuturePriceValidation';
import {
  ADMIN_SHEET_NAME,
  type BUCKET_TYPE,
  DIVISION,
  MAIN_COLUMNS,
  MEASURE_4,
  MENU_ID,
  MSG,
  SHEETS,
} from './sales-future-price.constants';
import type { FuturePriceRow } from './sales-future-price.types';
import styles from './SalesFuturePrice.module.scss';
import {
  buildExchangeRateMap,
  currencyCodesFromRateMap,
  type ExchangeRateRow,
  getExchangeRate,
  isExchangeTargetMeasure,
} from './salesPriceExchange';
import { useSalesFuturePriceStore } from './useSalesFuturePriceStore';
import { isEditableDivision } from './utils/editableDivision';
import { groupKeyOf, toStr } from './utils/futurePriceGroup';

// AS-IS DMF0020_SalesFuturePrice.cs (3,969줄 Forms.UIL/Master 정본) — 메인 화면
//   - 24 Event (Form_Load / clbDivisions_Change / btnExchangeRate_Click / btnSavePricePeriod_Click / ...)
//   - 18 PKG SP + 12 Common Lookup
//   - 71 메인 Validation + 12 POPUP Validation
//   - 9 Expression (SUM headers / 동적 컬럼 / 3단 머지 / Visible 분기 / EditFlag)
//   - 7 POPUP (Exchange/Price Batch/Version/Owner/ColumnTitleSet/Range/Template)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/ (9 MD)
//   - 메타: To-be_v2_converted/08_Screen_Registration/registrations/03_DMF0020_Registration.sql (7-BLOCK)
//   - __asis-mapping__.md: 본 폴더 + Doc/_analysis 폴더 cross-ref
//
// 룰 25 §1.5.1 (Button 10대) — CRUD 6 + Aux 4:
//   F2 Edit / F5 Search / F7 Save / F8 Insert / F9 Delete / F12 Excel  (CRUD)
//   F3 Sort (자동) / F4 Filter (자동) / F6 Condition (false — 패널 없음) / F10 Reset (false)
// 룰 12 §11.7 — column meta 기반 cell coloring + popup cell
// 룰 12 §11.6 — HierarchicalMergeManager (SmartColMerge 동등, SalesFuturePriceGrid 안 정의)

// 셀 값 → 문자열 (unknown 안전 변환 — no-base-to-string 회피, cascade 팝업 필터용)
const cellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// measure 그룹 식별 키 · toStr · groupKeyOf 는 그리드 실시간 형제 환율 재계산과 공용 → utils/futurePriceGroup.

export const SalesFuturePrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<FuturePriceRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  // F7 Save 편집행('U') 변경 셀 추적 — 공용 DataGrid 가 new EditTracker(grid) 초기화.
  //   FuturePriceRow 는 WijmoRowItem 제약 위반(index sig) → default generic.
  const editTrackerRef = useRef<EditTracker>(undefined);
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useSalesFuturePriceStore(s => s.searchCondition);
  const filters = useSalesFuturePriceStore(s => s.filters);
  const setFilter = useSalesFuturePriceStore(s => s.setFilter);
  const clearFilters = useSalesFuturePriceStore(s => s.clearFilters);
  const openSearchArea = useSalesFuturePriceStore(s => s.openSearchArea);
  const setOpenSearchArea = useSalesFuturePriceStore(s => s.setOpenSearchArea);
  const setSearchCondition = useSalesFuturePriceStore(s => s.setSearchCondition);
  // ⭐ master hook §2.3 — Column/Measure 동적 fetch (admin SYS0004 UI Category Setup 변경 즉시 반영)
  const staticColumns = useSalesFuturePriceStore(s => s.staticColumns);
  const staticMeasures = useSalesFuturePriceStore(s => s.staticMeasures);
  const fetchStaticColumns = useSalesFuturePriceStore(s => s.fetchStaticColumns);
  // ⭐ Batch 팝업 컬럼('Sales Price Save All')을 부모에서 division 단위로 선-fetch → 모달 open 시 metaBatch 준비완료
  //   (open 마다 재fetch = 참조 churn → 그리드 깜박임 방지, 2026-07-07).
  const fetchBatchColumns = useSalesFuturePriceStore(s => s.fetchBatchColumns);
  const fetchStaticMeasures = useSalesFuturePriceStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useSalesFuturePriceStore(s => s.restoreSearchConditions);
  const applyColumnVisibility = useSalesFuturePriceStore(s => s.applyColumnVisibility);

  const validate = useSalesFuturePriceValidation();
  const { t } = useTranslation();
  const sessionUserId = useSessionStore(s => s.session.userId);

  // ui-dynamic-property-management §3 / screen-meta-and-permissions #50 — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 편집 가능 division (메타 구동 — 하드코딩 제거) — CMBO 'SalesFuturePriceEditableDivision'
  //   (lookup DM_EDITABLE_DIVISION_ALLOW, SEGMENT1='DMF0020' → 편집가능 division CODE).
  //   현행 업무규칙: 82(Power)만 편집 가능. 40/81/81_* = 편집제약(셀 편집불가 + Insert/Delete/Save 미표시).
  //   메타 미적용/빈 응답 시 fallback = {'82'} (하드코딩 금지 원칙상 메타 우선, fallback 은 규칙 기본값 1건).
  const [editableDivRows] = useTabComboQueries({ filters: ['SalesFuturePriceEditableDivision'] });
  const editableSet = useMemo(() => {
    const codes = (editableDivRows ?? [])
      .map(r => {
        const code = (r as { CODE?: unknown }).CODE;
        return typeof code === 'string' ? code.trim() : '';
      })
      .filter(Boolean);
    return codes.length > 0 ? new Set(codes) : new Set(['82']);
  }, [editableDivRows]);
  // 현재 조회 division 이 편집 가능한지 — 셀 편집(그리드) + Insert/Delete/Save 버튼 표시의 division 게이트.
  const editable = isEditableDivision(sc.divisionId, editableSet);

  // 메인 그리드 SP (P_DMF0020_GET_FUTUREPRICE_INFO — 4 IN + 2 OUT)
  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const loading = isLoading || isFetching;

  // ⭐ 환율 데이터 (SP PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO — ExchangeRateModal 동일 소스).
  //   LOC 편집 시 KRW/USD/RTF 형제 measure 를 환율 재계산(AS-IS GetExchangeRate)해 3쌍 전송하기 위함.
  //   조회 기간(sc)으로 fetch — react-query 캐시. 저장 시 buildExchangeRateMap 으로 룩업.
  const exchangeFilters = useMemo(
    () => ({ startYyyymmdd: sc.startYyyymmdd, endYyyymmdd: sc.endYyyymmdd }) as never,
    [sc.startYyyymmdd, sc.endYyyymmdd]
  );
  const { data: exchangeData } = useTabProcQuery<MENU_ID, SHEETS.EXCHANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCHANGE,
    tabId,
    filters: exchangeFilters,
    enabled: !!sc.startYyyymmdd && !!sc.endYyyymmdd,
  });
  // Insert LOC 행 동적셀 편집 시 형제 measure 환율 재계산용 맵 (grid 로 전달, save 와 동일 소스).
  const exchangeRateMap = useMemo(
    () => buildExchangeRateMap((exchangeData as { o_rc1?: ExchangeRateRow[] })?.o_rc1 ?? []),
    [exchangeData]
  );

  // ⚠️ 화면 진입 시 자동 조회 제거 (2026-06-21 사용자 보고: 조회 시간 큼).
  //    SP `DMF0020_GET_SCM_MST_FUTURE_PRICE` 가 대용량 데이터 + 18 IN params + PIVOT 처리로 무거움.
  //    AS-IS .cs Form_Load 의 자동 조회는 적용 안 함 — 사용자가 조회조건 입력 후 Search 버튼 (F5) 으로 직접 trigger.

  // ⭐ master hook §2.3 + §5 — mount 시 1회 fetch (admin 메타 즉시 반영 baseline)
  //   + sessionStorage 의 이전 filters cache 무효화 — incomplete payload (sesUserId 누락 등) 재사용 회피.
  //     사용자 검색 버튼 → setFilter() 새 payload 만 사용.
  useEffect(() => {
    void restoreSearchConditions(); // F6 저장 조회조건 진입 시 1회 복원 (initialized 가드)
    void fetchStaticColumns(sc.divisionId); // ⭐ divisionId → SP 서버측 DIVISION_ID 필터
    void fetchBatchColumns(sc.divisionId); // ⭐ Batch 팝업 컬럼 선-fetch (open 깜박임 방지)
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 신규/수정 행 추적 (CRUD_TYPE) — SP 결과와 합쳐 grid itemsSource
  const [insertedRows, setInsertedRows] = useState<FuturePriceRow[]>([]);

  // #23 blnWork — 저장 in-flight 가드 (연속작업 방지, AS-IS L1549 MSG00137).
  const savingRef = useRef(false);
  // ⭐ 저장 직후 재조회 데이터에서 "방금 저장한 행" 위치로 스크롤/선택 (신규 행이 맨 위 → 정렬 위치로
  //   이동해 "안 보임"으로 인지되는 문제 해소). 값 = 저장한 첫 LOC 행의 그룹 키.
  const scrollTargetRef = useRef<string | null>(null);

  // Division 조건 변경 시 Grid 초기화 — 이전 division 의 조회결과/신규행/편집추적 제거(재조회 전 빈 상태).
  //   초기 마운트(또는 persist 복원)는 제외 — 실제 division '변경' 시에만 동작.
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    clearFilters(); // filters[MAIN] 제거 → query disabled → spRows 비움
    void fetchStaticColumns(sc.divisionId); // ⭐ division 변경 시 컬럼 재조회 (SP DIVISION_ID 서버측 필터)
    void fetchBatchColumns(sc.divisionId); // ⭐ Batch 팝업 컬럼도 division 동기화 (모달 open 깜박임 방지)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, clearFilters]);

  // Modal open state
  const [openExchange, setOpenExchange] = useState(false);
  const [openBatch, setOpenBatch] = useState(false);
  const [openVersion, setOpenVersion] = useState(false);
  const [openTitleSet, setOpenTitleSet] = useState(false);
  // 저장 후 Range Rate 초과 리스트 (AS-IS ds.Tables[2] → SalesPriceRangePopUp) — SAVE 응답 o_rc1.
  const [rangeRows, setRangeRows] = useState<SalesPriceRangeRow[]>([]);
  const [openRange, setOpenRange] = useState(false);

  // Insert row popup state — PROJECT / ITEM 공용 modal (AS-IS .cs L2040/2044 cellTypeImage 동등)
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupGroupId, setPopupGroupId] = useState<string | null>(null);
  // ⭐ modal cascade (hook #59 §5 / AS-IS CellDoubleClick L3229~3294) — 팝업 필터는 조회조건이 아니라
  //   "클릭한 행의 상위 셀 값" (Form_Load(false, div, team, endCustomer, site, project[, item]) 1:1).
  const [popupRow, setPopupRow] = useState<FuturePriceRow | null>(null);
  // ⭐ 성능(2026-07-08) — 참조 안정 콜백(useCallback). inline arrow 로 넘기면 매 렌더 새 함수 →
  //   Grid 의 대형 useEffect(deps 에 onPopupCellDblClick 포함)가 렌더마다 재실행(핸들러 5종 재등록 +
  //   new MergeManager + invalidate(true) 전체 리프레시). setState 함수들은 참조 고정이라 deps [].
  const handlePopupCellDblClick = useCallback((modalKey: string, row: FuturePriceRow) => {
    setPopupGroupId(row.INSERT_GROUP_ID ?? null);
    setPopupRow(row); // cascade — 클릭 행의 상위 셀 값을 팝업 필터로 (AS-IS L3229~3247)
    if (modalKey === 'PROJECT') setOpenProject(true);
    else if (modalKey === 'ITEM') setOpenItem(true);
  }, []);

  // ----- Button 10대 매핑 -----
  const handleSearch = () => {
    const v = validate.validateFind(sc);
    if (!v.ok) return;
    void setToast({ message: t('LBL00665', 'Loading...'), type: 'default', duration: 2000 });
    setFilter();
    // ⭐ 2026-07-03 — refetch?.() 제거: refetch 는 "이 렌더" 관찰자(=이전 filters, division 변경 직후엔
    //   undefined)로 즉시 발사되어 실제 조회와 병렬로 전-파라미터 NULL SP 호출이 매번 1회 나감
    //   (BE SQL_LOG 실측 88ms~13s — 풀 커넥션 점유 + GTT DELETE 낭비, enabled:false 도 우회).
    //   재조회 트리거는 useTabProcQuery 내부가 담당: filters 참조 변경 → 이전 키 invalidate
    //   (동일 조건 재검색 = 같은 해시 = active refetch) / 값 변경 = 새 키 자동 fetch.
    setInsertedRows([]);
    // ⭐ master hook §2.4 — Search 시 admin 메타 refetch (admin 변경 즉시 반영)
    void fetchStaticColumns(sc.divisionId); // ⭐ divisionId → SP 서버측 DIVISION_ID 필터
    void fetchStaticMeasures();
  };

  // F8 Insert — AS-IS L2049 dtMeasureCount.Rows.Count 만큼 row 추가
  //   ⭐ master hook §5 — Measure 동적 fetch (SCM_MST_SHEET_MEASURE 의 VALID_YN='Y' COLUMN_NAME 만)
  //   admin 변경 즉시 반영. staticMeasures 비어있으면 MEASURE_4 hardcode fallback.
  const handleInsert = () => {
    if (!editable) return; // 편집제약 division 방어 (버튼도 미표시되나 이중 가드)
    // ⭐ isCurVersion 게이트 (MSG00448) — 과거버전 조회 상태에서는 Insert 불가.
    //   AS-IS EditButton(.cs L868~): txtVersion=='Current' 조회일 때만 편집/신규 허용.
    if (sc.versionId !== 'CURRENT') {
      void setAlert({ type: 'alert', content: t(MSG.EDIT_NOT_CURRENT_VER, '_현재 버전이 아닙니다.') });
      return;
    }
    // AS-IS InsertRow L1815: siMain.Insert2(dtMeasureCount.Rows.Count) — measure 개수만큼 행 추가.
    //   admin SCM_MST_SHEET_MEASURE(VALID_YN='Y') COLUMN_NAME 우선. ⭐ COLUMN_NAME 유효값만 사용
    //   (admin 이 빈값/다른 필드 반환 시 undefined 누적 방지) → 유효 measure 0개면 AS-IS 4종(MEASURE_4) fallback.
    //   ⚠️ BE GridMeasure DTO = camelCase(colNm/display). 정렬은 SP 반환 순서(배열 순서), 노출 measure(display!==false)만.
    const validMeasures = (staticMeasures[SHEETS.MAIN] ?? [])
      .filter(m => m.display !== false)
      .filter(m => !!(m.colNm ?? '').trim())
      .map(m => m.colNm.trim());
    const measures: readonly string[] = validMeasures.length > 0 ? validMeasures : MEASURE_4;
    const groupId = `I_${Date.now()}`;
    const newRows: FuturePriceRow[] = measures.map(
      (m): FuturePriceRow => ({
        CRUD_TYPE: 'I',
        INSERT_GROUP_ID: groupId,
        DIVISION_ID: sc.divisionId,
        DEPT_ID: '',
        END_CUSTOMER: '',
        SCM_SITE_ID: '',
        PROJECT_CODE: '',
        PROJECT_STATUS: '',
        BIZ_TYPE_NAME: '',
        ITEM_ID: '',
        INCOTERMS: '',
        FCST_TYPE: '',
        DOM_EXP: '',
        PLANT_SITE_ID: '',
        CURRENCY: '',
        PRICE_EXIST: 'Y',
        MEASURE: m,
      })
    );
    setInsertedRows(prev => [...newRows, ...prev]);
  };

  // F9 Delete — AS-IS L275~ DeleteButton (신규 'I' 행만 제거, 같은 INSERT_GROUP_ID 4 row 묶음 삭제)
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as FuturePriceRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') {
      void setAlert({ type: 'alert', content: t('LBL00666', 'Only new rows can be deleted.') });
      return;
    }
    const gid = sel.INSERT_GROUP_ID;
    if (gid) {
      setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    } else {
      setInsertedRows(prev => prev.filter(r => r !== sel));
    }
  };

  // F7 Save — AS-IS DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (1,279 lines) → To-Be 17 ^-delim CLOB
  //   각 row 는 (Insert 'I' / Update 'U' / Delete 'D') 별 4 measure × M dynamic col 펼침 (YYYYMMDD, PRICE)
  //   Inserted row 만 'I', SP 결과 row 의 dynamic cell 수정값 'U' (사용자 LOC row 만 editable)
  const handleSave = async () => {
    // #23 blnWork — 연속작업(저장 in-flight 중 재클릭) 방지 (AS-IS L1549, MSG00137).
    if (savingRef.current) {
      void setAlert({
        type: 'alert',
        content: t('MSG00137', '_이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.'),
      });
      return;
    }
    // ⭐ isCurVersion 게이트 (MSG00448) — 과거버전 조회 상태에서는 저장 불가 (AS-IS L868 편집 대전제).
    if (sc.versionId !== 'CURRENT') {
      void setAlert({ type: 'alert', content: t(MSG.EDIT_NOT_CURRENT_VER, '_현재 버전이 아닙니다.') });
      return;
    }
    const spRowsAll = (data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? [];
    // AS-IS SaveData = I/M/D 통합. 편집된 기존 행은 EditTracker 가 자동 CRUD_TYPE='M' 마킹.
    const editedRows = spRowsAll.filter(r => r.CRUD_TYPE === 'M');
    const targetRows = [...insertedRows, ...editedRows];

    // ⭐ fnValidation 정합 — 신규 행 중복은 "화면 전체 행(기존 조회분 포함)" 대비 검사 (AS-IS L2267).
    const v = validate.validateSaveRows(targetRows, [...insertedRows, ...spRowsAll], sc);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_저장하시겠습니까?') });
    if (!ok) return;

    void setToast({ message: t('LBL00665', 'Loading...'), type: 'default', duration: 3000 });

    // 17 IN params 의 ^-delim 누적 array (AS-IS SaveData nvc 동등)
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
      // ⭐ createdBy/lastUpdatedBy 키명 회피 (createdByList/lastUpdatedByList):
      //    BE NDaoInterface._selectList 가 정확히 'createdBy'/'lastUpdatedBy' 키를 세션 userId
      //    단일값으로 덮어써 ^×N 배열이 1토큰으로 붕괴 → SP CREATED_BY NULL(ORA-01400).
      //    BE 가 가로채지 않는 키명으로 보내고 PROC_M COL_NM(14/16)도 동일 매핑(21_…sql).
      createdByList: [],
      creationDate: [],
      lastUpdatedByList: [],
      rownumKey: [],
    };
    const today = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const userId = sessionUserId ?? ''; // 세션 사용자 (하드코딩 제거 — screen-additional-skills #45)
    let rownum = 0;

    // EditTracker 변경 셀 맵 — 'M' 행은 변경된 binding 만 전송 (AS-IS red cell 동등).
    const changedMap = editTrackerRef.current?.getOriginalValues();

    // 환율 룩업 (AS-IS dtFuturePrice = GetFuturePriceInfo) — LOC → KRW/USD 재계산용.
    const erRows = (exchangeData as { o_rc1?: ExchangeRateRow[] })?.o_rc1 ?? [];
    const erMap = buildExchangeRateMap(erRows);
    // RTF 등 비통화 measure 저장 제외 판정용 통화코드 집합 (환율 데이터 구동 — 하드코딩 금지).
    const saveCurrencyCodes = currencyCodesFromRateMap(erMap);

    // 형제 measure 행 (LOC 제외) — insert: 같은 INSERT_GROUP_ID / edit: 같은 그룹 키 (spRowsAll).
    const siblingsOf = (locRow: FuturePriceRow): FuturePriceRow[] => {
      if (locRow.CRUD_TYPE === 'I') {
        const gid = locRow.INSERT_GROUP_ID;
        return insertedRows.filter(r => r.INSERT_GROUP_ID === gid && (r.MEASURE ?? '') !== 'LOC');
      }
      const key = groupKeyOf(locRow as Record<string, unknown>);
      return spRowsAll.filter(
        r => (r.MEASURE ?? '') !== 'LOC' && groupKeyOf(r as Record<string, unknown>) === key
      );
    };

    // 저장 대상 동적 셀 키 추출 — AS-IS L1640: M_(월 SUM) 제외, W_(주차) 만.
    //   'I' 행 = 입력된 모든 W_ 셀 / 'M' 행 = EditTracker 가 변경 표시한 W_ 셀만.
    const collectDynKeys = (row: FuturePriceRow, isInsert: boolean): string[] => {
      const allW = Object.keys(row).filter(k => /^W_\d+$/.test(k));
      if (isInsert) return allW;
      const changed = changedMap?.get(row as never);
      if (!changed) return [];
      return allW.filter(k => k in changed);
    };

    // 키 컬럼은 모두 LOC 행(그룹 대표 = AS-IS CurrentDataRow) 값 사용, measure/price 만 가변.
    const pushEntry = (
      kr: Record<string, unknown>,
      measure: string,
      yyyymmdd: string,
      price: string,
      flag: string
    ): void => {
      rownum++;
      acc.activeFlag.push(flag);
      acc.divisionId.push(toStr(kr.DIVISION_ID));
      // ⭐ Division 저장 키 분기 — 40 은 프로젝트 역할을 END_CUSTOMER40 컬럼이 담당(AS-IS PIVOT 키),
      //   81·82 = PROJECT_CODE. validateSaveRows projectFieldOf 와 정합. (현행 82-only 편집이라 무발현,
      //   향후 40/81 편집 확대 시 정합 확보.)
      acc.projectCode.push(
        toStr(kr.DIVISION_ID) === DIVISION.MOBILITY
          ? toStr(kr.END_CUSTOMER40)
          : toStr(kr.PROJECT_CODE)
      );
      acc.scmSiteId.push(toStr(kr.SCM_SITE_ID));
      // ⭐ PLANT_SITE_ID NOT NULL — 신규 insert(특히 div 82/40)는 plant 미입력이라 빈값 → ORA-01400.
      //   기존 데이터·AS-IS 동일 placeholder '-' 로 기본 처리(div 81 실제값은 비어있지 않아 무영향).
      acc.plantSiteId.push(toStr(kr.PLANT_SITE_ID) || '-');
      acc.itemId.push(toStr(kr.ITEM_ID));
      acc.yyyymmdd.push(yyyymmdd);
      acc.currency.push(toStr(kr.CURRENCY));
      acc.measure.push(measure);
      acc.domExp.push(toStr(kr.DOM_EXP));
      acc.fcstType.push(toStr(kr.FCST_TYPE));
      acc.incoterms.push(toStr(kr.INCOTERMS));
      acc.price.push(price);
      acc.createdByList.push(userId);
      acc.creationDate.push(today);
      acc.lastUpdatedByList.push(userId);
      acc.rownumKey.push(String(rownum));
    };

    // ⭐ LOC 주도 3쌍 전송 (AS-IS CellsUpdated: LOC 편집 시 형제 measure 를 환율 재계산해 함께 변경/전송).
    //   화면은 LOC measure 행만 편집 가능 → LOC 행을 그룹 대표로 삼아 LOC + KRW/USD/RTF 동시 emit.
    //   SP GROUP BY(key+CURRENCY) HAVING COUNT(*)<3 검증 통과 ("LOC값 확인 후 재저장" 거부 방지).
    const locRows = targetRows.filter(r => (r.MEASURE ?? '') === 'LOC');
    for (const locRow of locRows) {
      const isInsert = locRow.CRUD_TYPE === 'I';
      const kr = locRow as Record<string, unknown>;
      const div = toStr(kr.DIVISION_ID);
      const baseCur = toStr(kr.CURRENCY);
      const sibs = siblingsOf(locRow);
      for (const dk of collectDynKeys(locRow, isInsert)) {
        const rawLoc = kr[dk];
        // Insert 는 빈 셀 skip / Modify 는 변경 셀이므로 빈값=0 (AS-IS sPRICE="" → "0").
        if (isInsert && (rawLoc === undefined || rawLoc === '' || rawLoc === null)) continue;
        const locPrice =
          rawLoc === undefined || rawLoc === '' || rawLoc === null ? '0' : toStr(rawLoc);
        const yyyymmdd = dk.slice(2); // W_yyyymmdd → yyyymmdd
        const yyyymm = yyyymmdd.slice(0, 6);

        // LOC entry — price==0 → 'D' (AS-IS [E20240206-000758]: LOC 메져만 0 시 상태 D).
        const locFlag = locPrice === '0' ? 'D' : isInsert ? 'I' : 'M';
        pushEntry(kr, 'LOC', yyyymmdd, locPrice, locFlag);

        // 형제 measure (KRW/USD) — LOC 값 환율 재계산 (AS-IS GetExchangeRate).
        //   ⭐ RTF(RTF_SYS_RP) 제외 (AS-IS 실측 정합 2026-07-08): RTF 는 시스템 생성 measure(이동계획 판가)
        //   — 저장 대상 아님. GET SP 적재도 COLUMN_NAME <> 'RTF_SYS_RP' 필터로 제외해 저장해도 쓰레기 행.
        //   SAVE SP 3쌍 검증(HAVING COUNT(*) < 3)은 LOC/KRW/USD 3건으로 정확 충족.
        //   판정 = 환율 통화코드 집합(하드코딩 금지, 미로드 시 기존 동작 보존).
        for (const sib of sibs) {
          const sm = toStr((sib as Record<string, unknown>).MEASURE);
          if (!sm) continue;
          if (!isExchangeTargetMeasure(saveCurrencyCodes, sm, baseCur)) continue; // RTF 등 비통화 제외
          const sibRaw = (sib as Record<string, unknown>)[dk];
          const sibCur = sibRaw === undefined || sibRaw === null ? null : toStr(sibRaw);
          const sibPrice = getExchangeRate(erMap, div, baseCur, sm, yyyymm, locPrice, sibCur);
          // ^-delim 빈 토큰 방지 (AS-IS sPRICE "" → "0"). 형제는 LOC 가 아니므로 D 변환 없음.
          pushEntry(kr, sm, yyyymmdd, sibPrice === '' ? '0' : sibPrice, isInsert ? 'I' : 'M');
        }
      }
    }

    if (acc.activeFlag.length === 0) {
      void setAlert({ type: 'alert', content: t('LBL00667', 'No data to save.') });
      return;
    }

    const payload: Record<string, string> = {};
    for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

    savingRef.current = true;
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/main/SAVE/call-proc`,
        payload
      );
      // ⭐ false-success 차단 — 전역 responseErrorInterceptor 가 500(ORA 오류 등)을 reject 하지 않고
      //   error.response 를 그대로 resolve → 여기로 정상 도달함. status/code 로 실패를 직접 판별.
      //   (CODE≠0 검증거부는 전역 responseInterceptor 가 O_RESULT_CURSOR.MSG 로 throw → catch 처리.
      //    SP 검증 SELECT 의 MSG=V_DESCRIPTION 으로 실제 사유 표출 — 21/SP fix 참조.)
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return; // insertedRows/편집 유지 — 사용자가 수정 후 재저장
      }

      void setToast({ message: t('MSG00606', '_저장되었습니다.'), type: 'success' });
      // ⭐ 저장 후 재조회 시 신규 행이 SP 정렬 위치(Site/Project 순)로 이동 → "안 보임" 방지:
      //   저장한 첫 LOC 행 키를 기억해 재조회 데이터 로드 후 해당 행으로 scroll + select.
      const firstLoc = locRows[0];
      if (firstLoc) scrollTargetRef.current = groupKeyOf(firstLoc as Record<string, unknown>);
      // ⭐ AS-IS L1939 [PJ20200138] — SAVE SP O_RC1 = Range Rate 초과 리스트 → 팝업 표시 (저장은 완료 상태).
      const overRows: SalesPriceRangeRow[] =
        (res.data?.result as { o_rc1?: SalesPriceRangeRow[] })?.o_rc1 ??
        (res.data as { o_rc1?: SalesPriceRangeRow[] })?.o_rc1 ??
        [];
      if (overRows.length > 0) {
        setRangeRows(overRows);
        setOpenRange(true);
      }
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges(); // 편집 추적 reset (재조회 전)
      refetch?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      savingRef.current = false;
    }
  };

  // Button 10대 = CRUD 6 + Search Aux 4 (룰 25 §1.5.1, §1.5.3)
  //   F5 Search / F7 Save / F8 Insert / F9 Delete / Excel (SubTitle 자동)
  //   F3 Sort / F4 Filter (자동 — `allowSorting=true` + `gridFilter` ref 생략)
  //   F6 Condition / F10 Reset Condition (SubTitle DefaultButtonActions 자동 활성 — DMF0020 은 SalesFuturePriceForm 조회조건 form 있음)
  //   F2 Edit: HotkeyConfig 미지원 (`_F2_Unused`) → actionBar 의 Edit 버튼으로 별도 노출
  // ui-dynamic-property-management §3.2 — hasButton 조건부 callback (admin USE_YN / USER_GR 권한 미부여 시 자동 숨김)
  // ⭐ Insert/Delete/Save 는 편집가능 division(메타 LOOKUP 구동, 82만) 일 때만 활성 — 그 외 미표시 (하드코딩 제거).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') && editable ? handleInsert : false,
    save: hasButton('SAVE') && editable ? handleSave : false,
    delete: hasButton('DELETE') && editable ? handleDelete : false,
    manual: false,
    upload: false,
  };

  // SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M 결과 — wide format (28 fixed cols + 동적 W_/M_)
  // PIVOT 이 DB 단에서 처리되어 클라이언트 측 변환 불필요
  // ⭐ 성능(2026-07-08 사용자 보고: SP 1~3초 vs 화면 표시 지연) — spRows/rows 참조 안정화(useMemo).
  //   구현: 매 렌더 새 배열 생성 → memo(DataGrid) 무력화 → 페이지가 리렌더될 때마다(토스트/isFetching/
  //   콤보·메타 도착 등 조회 1회에 10회+) wrapper 가 itemsSource(CollectionView 재생성) +
  //   columnGroups(전체 컬럼 트리 재구축) 를 반복 재적용 → 수 초 소모. 데이터 실제 변경 시에만 재바인딩되도록 고정.
  const spRows = useMemo<FuturePriceRow[]>(
    () => (data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? [],
    [data]
  );
  const rows = useMemo<FuturePriceRow[]>(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

  // ⭐ 저장 후 재조회 데이터 로드 시 방금 저장한 행으로 scroll + select
  //   (신규 행이 그리드 맨 위 → 저장/재조회 후 SP 정렬 위치로 이동해 "안 보임"으로 인지되는 문제 해소.
  //    feedback_recently_added_loadedrows_pattern — 데이터 로드 후 1 frame 뒤 스크롤.)
  useEffect(() => {
    const target = scrollTargetRef.current;
    if (!target) return;
    const spRowsNow = (data as { o_rc1?: FuturePriceRow[] })?.o_rc1 ?? [];
    if (spRowsNow.length === 0) return;
    const idx = spRowsNow.findIndex(r => groupKeyOf(r as Record<string, unknown>) === target);
    scrollTargetRef.current = null;
    if (idx < 0) return;
    requestAnimationFrame(() => {
      const g = gridRef.current;
      if (!g) return;
      try {
        // itemsSource = [...insertedRows(저장 후 빈 배열), ...spRows] → grid row index == idx.
        g.select(idx, 0);
        g.scrollIntoView(idx, 0);
      } catch {
        /* grid rebuild race */
      }
    });
  }, [data]);

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <SalesFuturePriceForm
          onSearch={handleSearch}
          onVersionOpen={() => setOpenVersion(true)}
          hasInsertRows={insertedRows.length > 0}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesFuturePrice'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // 기능 버튼 순서 = Exchange Rate → Column Setting → Price Batch Input (사용자 요구 2026-07-01).
          {
            // Exchange Rate — 공용 IcExchangeRate 아이콘(@foundation/assets). 차주 환율 버튼도 동일 아이콘 사용 가능.
            label: t('LBL00661', 'Exchange Rate'),
            title: t('LBL00661', 'Exchange Rate'),
            action: () => setOpenExchange(true),
            iconComponent: <IcExchangeRate />,
            buttonLabel: '',
          },
          {
            // Column Setting — 공용 Grid Column Setup 아이콘(↔ + 상/하 분할 2컬럼). @foundation/assets IcGridColumnSetup.
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenTitleSet(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
          {
            label: t('LBL00662', 'Price Batch Input'),
            title: t('LBL00662', 'Price Batch Input'),
            action: () => setOpenBatch(true),
          },
        ]}
      />

      {/* SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M (wide format, 28 fixed + 동적 W_/M_)
          ⚠️ 로딩 시에도 grid 를 언마운트하지 않음 — 재마운트 시 헤더높이(#93)/LOC backcolor/머지 효과가
             타이밍 문제로 깨짐(조회·저장 후 144 회귀 사고, 2026-06-27). 로딩 표시는 SubTitle Loading toast 로 대체. */}
      <SalesFuturePriceGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        editable={editable}
        bucketType={sc.bucketType as BUCKET_TYPE}
        staticColumns={staticColumns[SHEETS.MAIN]}
        staticMeasures={staticMeasures[SHEETS.MAIN]}
        exchangeRateMap={exchangeRateMap}
        onPopupCellDblClick={handlePopupCellDblClick}
      />

      {/* POPUP 6종 */}
      <ExchangeRateModal
        open={openExchange}
        modalClose={() => setOpenExchange(false)}
        defaultDivision={sc.divisionId}
        defaultPeriod={{ start: sc.startYyyymmdd.slice(0, 6), end: sc.endYyyymmdd.slice(0, 6) }}
      />
      <PriceBatchInputModal
        open={openBatch}
        modalClose={() => setOpenBatch(false)}
        defaultDivision={sc.divisionId}
        defaultPeriod={{ start: sc.startYyyymmdd, end: sc.endYyyymmdd }}
        onSaveResult={() => refetch?.()}
      />
      <SalesPriceVersionModal
        open={openVersion}
        modalClose={() => setOpenVersion(false)}
        defaultDivision={sc.divisionId}
        onApply={vIds => setSearchCondition({ versionId: vIds })}
      />
      {/* 저장 후 Range Rate 초과 리스트 (AS-IS DMF0020_SalesPriceRangePopUp — SAVE O_RC1) */}
      <SalesPriceRangeModal
        open={openRange}
        modalClose={() => setOpenRange(false)}
        rows={rangeRows}
      />
      <ColumnSettingModal
        open={openTitleSet}
        modalClose={() => setOpenTitleSet(false)}
        menuId={MENU_ID}
        // admin SHEET_NAME(AS-IS 'Sales Price')로 컬럼 메타 조회 — 메인 그리드와 동일 소스 (SHEET_NAME 불변).
        sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN}
        columnType='main'
        divisionId={sc.divisionId}
        fallbackColumns={MAIN_COLUMNS.map(c => ({ key: c.key, header: c.header, width: c.width }))}
        // ⭐ modal 재진입 시 이전 OK 상태 복원 — store.staticColumns 의 visible flag 기반.
        //   ColumnSettingModal 의 initialRows useMemo 가 USER_FLAG='Y'/'N' 결정에 사용.
        initialVisibleKeys={(staticColumns[SHEETS.MAIN] ?? [])
          .filter(c => c.visible !== false)
          .map(c => c.colNm)}
        onSave={settings => {
          // 사용자 선택 column 만 visible — store.staticColumns 의 visible flag 적용 → grid 즉시 반영.
          // ⚠️ 사내 SCM_USR_TITLE_SET 영구 저장은 별도 SP 호출 (Phase 후속).
          const visibleKeys = settings.map(s => s.COLUMN_NAME);
          applyColumnVisibility(SHEETS.MAIN, visibleKeys);
        }}
      />
      {/* Insert row popup — PROJECT (AS-IS .cs L2040 cellTypeImage + L2092/L2094 자동 채움) */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName, projectStatus, bizTypeName) => {
          if (!popupGroupId) return;
          // AS-IS L2049 LoopByDtMeasureCount — 같은 INSERT_GROUP_ID 의 4 measure row 동기화
          // AS-IS L2092 ProjectStatus LockRange2(true) — popup 선택 시 자동 채움
          // AS-IS L2094 BizTypeName LockRange2(true) — popup 선택 시 자동 채움
          setInsertedRows(prev =>
            prev.map(r =>
              r.INSERT_GROUP_ID === popupGroupId
                ? {
                    ...r,
                    PROJECT_CODE: projectCode,
                    PROJECT_NAME: projectName ?? '',
                    PROJECT_STATUS: projectStatus ?? '',
                    BIZ_TYPE_NAME: bizTypeName ?? '',
                  }
                : r
            )
          );
        }}
        preSearchParams={
          {
            // ⭐ cascade — 클릭 행의 상위 셀 값 (AS-IS Form_Load(false, div, team, endCust, site, project) L3259)
            divisionId: cellStr(popupRow?.DIVISION_ID) || sc.divisionId,
            deptId: cellStr(popupRow?.DEPT_ID) || 'ALL',
            endCustomer: cellStr(popupRow?.END_CUSTOMER) || 'ALL',
            salesSite: cellStr(popupRow?.SCM_SITE_ID) || 'ALL',
            projectCode: cellStr(popupRow?.PROJECT_CODE),
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* Insert row popup — ITEM (AS-IS .cs L2044 cellTypeImage) */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId, itemName, itemClass, nickName) => {
          if (!popupGroupId) return;
          setInsertedRows(prev =>
            prev.map(r =>
              r.INSERT_GROUP_ID === popupGroupId
                ? {
                    ...r,
                    ITEM_ID: itemId,
                    ITEM_NAME: itemName ?? '', // Model Name
                    ITEM_CLASS_NAME: itemClass ?? '', // Model Type
                    NICK_NAME: nickName ?? '', // ⭐ Nick Name (AS-IS DefColumns.NICK_NAME)
                  }
                : r
            )
          );
        }}
        preSearchParams={
          {
            // ⭐ cascade — 클릭 행의 상위 셀 값 (AS-IS Form_Load(false, ..., project, itemId) L3293)
            divisionId: cellStr(popupRow?.DIVISION_ID) || sc.divisionId,
            deptId: cellStr(popupRow?.DEPT_ID) || 'ALL',
            endCustomer: cellStr(popupRow?.END_CUSTOMER) || 'ALL',
            salesSite: cellStr(popupRow?.SCM_SITE_ID) || 'ALL',
            projectCode: cellStr(popupRow?.PROJECT_CODE),
            itemId: cellStr(popupRow?.ITEM_ID),
          } as never
        }
        callFromCell={true}
      />
    </div>
  );
};
