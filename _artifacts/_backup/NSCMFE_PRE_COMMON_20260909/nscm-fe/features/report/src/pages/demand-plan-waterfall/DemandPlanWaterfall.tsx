import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import {
  ColumnLayoutModal,
  MainTitle,
  ResultArea,
  saveTitleSet,
  SubTitle,
  toColumnLayoutSettings,
  type ColumnLayoutRow,
} from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DemandPlanWaterfallForm } from './components/DemandPlanWaterfallForm';
import { DemandPlanWaterfallGrid } from './components/DemandPlanWaterfallGrid';
import {
  divisorFor,
  GUBUN,
  GUBUN_META,
  MENU_ID,
  PERIOD_COLUMN_REGEX,
  PERIOD_LIMIT_YEARS,
  SHEETS,
} from './demand-plan-waterfall.constants';
import { useDemandPlanWaterfallStore } from './useDemandPlanWaterfallStore';

// DMF0035 Demand Plan Waterfall — AS-IS 3 UI(0035/0022/0051) 통합 조회 전용 리포트 (2026-08-06).
//   정본: Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md (+ Cascade_Filter 전수 md).
//   MSG 는 AS-IS 실문구 대사(#114) — MSG00137/00108/00164/00097 (통합분석 §2.F 실측).

export const DemandPlanWaterfall = ({ tabId, title }: PageProps<MENU_ID>) => {
  // SubTitle(Excel/Filter/Sort) 연동용 — 공용 DataGrid 가 채운다
  const gridRef = useRef<TFlexGrid | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const filters = useDemandPlanWaterfallStore(state => state.filters);
  const searchParams = useDemandPlanWaterfallStore(state => state.searchParams);
  const setSearchParams = useDemandPlanWaterfallStore(state => state.setSearchParams);
  const setFilters = useDemandPlanWaterfallStore(state => state.setFilters);
  const isOpenSearchArea = useDemandPlanWaterfallStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useDemandPlanWaterfallStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useDemandPlanWaterfallStore(state => state.fetchStaticColumns);
  // [E20260831-MEASURE] 공통 메저 선택 상태 (개별 selector — 객체 destructuring 금지 규약)
  const fetchStaticMeasures = useDemandPlanWaterfallStore(state => state.fetchStaticMeasures);
  const staticMeasures = useDemandPlanWaterfallStore(state => state.staticMeasures);
  const visibleMeasures = useDemandPlanWaterfallStore(state => state.visibleMeasures);
  const applyVisibleMeasures = useDemandPlanWaterfallStore(state => state.applyVisibleMeasures);
  const staticColumns = useDemandPlanWaterfallStore(state => state.staticColumns);
  const columnSettings = useDemandPlanWaterfallStore(state => state.columnSettings);
  const applyColumnSettings = useDemandPlanWaterfallStore(state => state.applyColumnSettings);
  const restoreSearchConditions = useDemandPlanWaterfallStore(
    state => state.restoreSearchConditions
  );
  const clearData = useDemandPlanWaterfallStore(state => state.clearData);
  const resetForBucket = useDemandPlanWaterfallStore(state => state.resetForBucket);

  const gubun = searchParams.gubun;

  // ⭐ UM-01 Division 기본 선택 (사용자 결정 2026-08-28): 세션 division 이 MyDivision 목록에 있으면 그것,
  //   없으면 목록 첫 행 (AS-IS .cs:420~423 `cboDivision.SelectedIndex = 1` = 첫 실 division 자동선택).
  //   빈 값일 때만 1회 채운다 — F6 복원값·사용자 선택은 덮지 않는다(2026-08-23 "자동 보정 없음"은 선택 후 재보정 금지).
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (myDivisions ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchParams({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [myDivisions, searchParams.divisionId, session.div, setSearchParams]);

  // UM-01 — Division 변경 = Grid 초기화 (#59 §1.4 / memory feedback_division_change_grid_reset).
  //   filters 를 비우면 3 GUBUN 쿼리가 전부 disabled 되어 데이터·타이틀이 비고, 다시 보려면 Search 를 눌러야 한다.
  //   조회 전용 화면 = CRUD reset 해당없음. 정적 컬럼은 divisionId deps effect 가 뒤따라 재fetch.
  //   ⭐ GRID COLUMN SET 도 함께 초기화 — SHEET_COLUMNS 는 DIVISION_ID 토큰으로 컬럼 집합이 갈리므로
  //   이전 division 의 선택을 그대로 쓰면 없는 컬럼을 켠 상태가 된다.
  const handleDivisionChange = () => {
    clearData();
    // division 이 바뀌면 표시 대상 컬럼·메저 집합 자체가 달라진다(SHEET_COLUMNS/MEASURE 의 DIVISION_ID 축).
    //   null 로 비워 두면 뒤따르는 메타 재조회가 새 division 의 개인화로 다시 시드한다([E20260904-METASEED]).
    applyColumnSettings(gubun, null);
    applyVisibleMeasures(gubun, null);
  };

  // Waterfall Type(GUBUN) 변경 = GRID 초기화 (사용자 지시 2026-09-04).
  //   TYPE 이 바뀌면 시트·종속 PROGRAM_ID·컬럼/메저 메타 축이 통째로 바뀌므로 이전 결과는 무효다.
  //   컬럼·메저 설정은 뒤따르는 메타 effect 가 새 TYPE 의 서버 저장분으로 재시드한다([E20260904-METASEED]).
  const handleGubunChange = () => {
    clearData();
    queryClient.removeQueries({ queryKey: [tabId] });
  };

  // [E20260831-BUCKETRESET] BUCKET 변경 = 항상 GRID 초기화 (사용자 지시 2026-08-31 — 구 UM-08 경계 판정 폐기).
  //   AS-IS InitSpread 등가: 활성 GUBUN 메인 비움 + 타이틀 즉시 재조회(새 헤더). 재조회는 Search 버튼.
  const handleBucketChange = (_prev: string, next: string) => {
    resetForBucket(next);
  };

  // [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건 복원 (탭당 1회 — store initialized 가드).
  //   복원된 divisionId/gubun 은 아래 정적 컬럼 effect 의 deps 라 컬럼도 뒤따라 재fetch 된다.
  useEffect(() => {
    if (!session.userId) return;
    void restoreSearchConditions();
  }, [tabId, session.userId, restoreSearchConditions]);

  // GUBUN별 메인 시트 3본 — 활성 GUBUN 만 enabled
  const mktQuery = useTabProcQuery<MENU_ID, SHEETS.MKT_FCST>({
    menuId: MENU_ID,
    sheetName: SHEETS.MKT_FCST,
    tabId,
    filters: filters[SHEETS.MKT_FCST],
    enabled: gubun === GUBUN.MKT_FCST && !!filters[SHEETS.MKT_FCST],
  });
  const salesQuery = useTabProcQuery<MENU_ID, SHEETS.SALES_PLAN>({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_PLAN,
    tabId,
    filters: filters[SHEETS.SALES_PLAN],
    enabled: gubun === GUBUN.SALES_PLAN && !!filters[SHEETS.SALES_PLAN],
  });
  const bizQuery = useTabProcQuery<MENU_ID, SHEETS.BIZ_PLAN>({
    menuId: MENU_ID,
    sheetName: SHEETS.BIZ_PLAN,
    tabId,
    filters: filters[SHEETS.BIZ_PLAN],
    enabled: gubun === GUBUN.BIZ_PLAN && !!filters[SHEETS.BIZ_PLAN],
  });

  const active =
    gubun === GUBUN.MKT_FCST ? mktQuery : gubun === GUBUN.SALES_PLAN ? salesQuery : bizQuery;
  const activeRows = active.data?.o_rc1;
  const data = useMemo(
    () => (activeRows ?? []) as Record<string, string | number>[],
    [activeRows]
  );
  // ⭐ [E20260902-MEASDEPS] 메저 선택은 **서버 축(TITLESET_USER 'M')** 단일 출처 — 클라이언트 행 필터 ⛔.
  //   메인 SP 는 사용자 저장 메저를 base 로 **종속(파생) 메저를 서버에서 덧붙여** 반환한다:
  //     `PKG_DMF0035` L433~481 CUST_FCST → Immidiate/Planning_Forecast/Commercial_Agreement/Firm_Temp/
  //       Manumacturing_Material_Temp/Material_Temp/Backorder/CUST_FCST_EDI
  //     `PKG_DMF0035` L489~556 CUST_FCST(_ORG) → DM_MST_CUSTOMER_FCST.MEASURE / 'Customer Fcst[Org.]'
  //   이 종속 메저 코드들은 모달 목록의 원천(`SCM_MST_SHEET_MEASURE` VALID_YN='Y')에 **없거나 VALID_YN='N'**
  //   이라, 구 구현의 `vis.includes(MEASURE)` 필터가 종속 메저를 통째로 잘라냈다
  //   (사용자 신고 2026-09-02 "div 81 최초 조회는 나오는데 Measure 모달 저장 후 종속메저 사라짐" —
  //    선택을 바꾸지 않고 OK 만 눌러도 재현. AS-IS `DMF0035_MktFcstWaterfall.cs:1809` 은 팝업 OK 시
  //    `InitSpread()` 뿐이고 행 필터가 없다 = 서버가 선택+종속을 함께 내려주는 계약).
  //   → FE 는 SP 반환 measure 집합을 그대로 렌더한다. 정본 = DMF0003 `MktFcst.tsx:867~873` 동일 문구.
  //   `visibleMeasures` 는 모달 재진입 시 좌/우 복원 + 아래 **면제형 행 필터**의 입력으로 쓰인다.
  //
  // ⭐ [E20260902-MEASFILTEREXEMPT] 사용자 확정 2026-09-02 — "종속메저는 메저필터 적용 대상에서 제외(항상 표시)".
  //   필터를 **전면 제거**하면 건수 표시가 선택에 반응하지 않고(REQ:CHAT-20260831-W44 후퇴),
  //   **전면 적용**하면 종속메저가 잘린다(REQ:CHAT-20260902-W46 원인). 둘 다 아닌 **면제 규칙**을 쓴다:
  //     · 모달 목록(= SHEET_MEASURE VALID_YN='Y' 후보)에 있는 메저 → 선택 여부대로 필터
  //     · 모달 목록에 **없는** 메저(= SP 가 붙인 종속/파생) → 필터 면제, 항상 표시
  //   판정 원천은 `staticMeasures`(모달에 넘기는 바로 그 목록)라 모달과 축이 어긋날 수 없다.
  //   ⚠ staticMeasures 가 비면(fetch 실패) 전 메저가 '면제' 로 떨어져 필터가 no-op 이 된다 —
  //     메타 실패로 행이 사라지는 쪽보다 안전한 degrade (의도된 동작).
  const selectableMeasures = useMemo(
    () => new Set(staticMeasures.map(measure => measure.colNm)),
    [staticMeasures]
  );
  const visibleData = useMemo(() => {
    const vis = visibleMeasures[gubun];
    if (vis == null) return data;
    return data.filter(row => {
      const measure = String(row.MEASURE ?? '');
      if (!selectableMeasures.has(measure)) return true; // 종속메저 = 면제
      return vis.includes(measure);
    });
  }, [data, visibleMeasures, gubun, selectableMeasures]);

  // ⭐ 환산(KRW/USD/LOC/QTY 배수)은 **값 단계**에서 나눈다 — footer 집계(useAggregationRow)·Excel
  //   (FlexGridXlsxConverter)·F4 필터가 모두 셀 값을 보므로 formatItem 텍스트 치환으로는 셋 다 어긋난다.
  //   AS-IS `SetAmountCalculating`(0035 .cs:2246~2262 / 0022 .cs:2467~2571)도 스프레드 **값**을 갱신하고
  //   그 위에서 `SumIgnoreHidden` 이 돈다 = 값 단계가 1:1.
  //   배수가 전부 1이면 원배열 참조를 그대로 돌려준다(itemsSource 재대입 회피 — 스크롤·컬럼폭 보존).
  const scaledData = useMemo(() => {
    const d = {
      krw: Number(searchParams.krw) || 1,
      usd: Number(searchParams.usd) || 1,
      loc: Number(searchParams.loc) || 1,
      qty: Number(searchParams.qty) || 1,
    };
    if (d.krw === 1 && d.usd === 1 && d.loc === 1 && d.qty === 1) return visibleData;
    return visibleData.map(row => {
      const divisor = divisorFor(gubun, String(row.MEASURE ?? ''), d);
      if (divisor === 1) return row;
      // react-query 캐시 객체이므로 원본 mutate 금지 — shallow copy 후 기간 컬럼만 환산
      const next: Record<string, string | number> = { ...row };
      Object.keys(next).forEach(key => {
        if (!PERIOD_COLUMN_REGEX.test(key)) return;
        const value = Number(next[key]);
        if (!Number.isFinite(value)) return;
        next[key] = Math.round((value / divisor) * 100) / 100; // AS-IS Round 2
      });
      return next;
    });
  }, [visibleData, gubun, searchParams.krw, searchParams.usd, searchParams.loc, searchParams.qty]);

  // 당기(당월·당주) 헤더 강조 기준 — 메인 SP o_rc2 (AS-IS ds.Tables[1]["ISO_WEEK"], .cs:1140)
  //   ⚠ `procedures.d.ts` 의 DMF0035 블록(o_rc2 선언)이 아직 병합되지 않은 저장소에서도 **빌드가 깨지지 않게**
  //   구조적 접근으로 읽는다 (2026-09-04 클라우드 TS2551 — 이관 시 FE_MERGE 블록이 뒤늦게 적용되는 순서 문제).
  //   PROC_M 에는 o_rc2 가 등록돼 있어 런타임 값은 선언 유무와 무관하게 내려온다.
  const isoWeekRaw = (
    active.data as unknown as { o_rc2?: Array<{ ISO_WEEK?: string | number }> } | undefined
  )?.o_rc2?.[0]?.ISO_WEEK;
  const isoWeek = typeof isoWeekRaw === 'number' ? String(isoWeekRaw) : (isoWeekRaw ?? '');

  const isFetching = active.isFetching;

  useEffect(() => {
    if (!session.userId || !searchParams.divisionId) return;
    // [E20260831-METASHEET] 메타 조회 = AS-IS 시트명 + 종속 PROGRAM_ID (구 camel 시트명은 MKT/BIZ 0행 — Fields 에 DEFAULT 만 노출 실사고)
    void fetchStaticColumns({
      divisionId: searchParams.divisionId,
      sheetNm: GUBUN_META[gubun].sheetNm,
      programId: GUBUN_META[gubun].programId,
      gubun,
      // 진입·division·GUBUN 변경 = 서버 저장분이 정본 (이전 세션 잔재 무시)
      reseed: true,
    });
    // [E20260831-MEASURE] 공통 메저 선택(AS-IS 0035/0022/0051 공통 기능) — SHEET_MEASURE 메타 동반 fetch
    void fetchStaticMeasures({
      divisionId: searchParams.divisionId,
      measureSheetNm: GUBUN_META[gubun].measureSheetNm,
      programId: GUBUN_META[gubun].programId,
      gubun,
      reseed: true,
    });
  }, [
    tabId,
    session.userId,
    searchParams.divisionId,
    gubun,
    fetchStaticColumns,
    fetchStaticMeasures,
  ]);

  const handleSubmit = () => {
    if (!session.userId) return;

    // MSG00137 — "전 작업이 아직 실행 중입니다." (AS-IS blnWork 가드)
    if (isFetching) {
      void setAlert({
        type: 'alert',
        content: t('MSG00137', '_The previous task is still running.'),
      });
      return;
    }

    // MSG00097 — "권한을 가진 Division이 없습니다." (AS-IS .cs:1100)
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t('MSG00097', '_There is no Division with permission.'),
      });
      return;
    }

    const fromDt = dayjs(searchParams.startYyyymmdd, 'YYYYMMDD');
    const toDt = dayjs(searchParams.endYyyymmdd, 'YYYYMMDD');
    if (!fromDt.isValid() || !toDt.isValid()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00013', '_Please enter the required fields.'),
      });
      return;
    }

    // Version — [E20260831-VERREQ] 전 waterfall type 필수 (사용자 지시 2026-08-31 — 구 'MKT ''=CURRENT 비필수' 폐기.
    //   초기값·type 변경 시 기본값 = 'CURRENT'([E20260831-VERCUR]) 라 통상 통과, 사용자가 비운 경우만 차단).
    // 무엇이 빠졌는지 명시 — MSG00283 '버전을 선택하세요' (범용 MSG00013 은 원인 불명 혼선)
    if (!searchParams.version) {
      void setAlert({
        type: 'alert',
        content: t('MSG00283', '_Please select Version.'),
      });
      return;
    }

    // MSG00108 — "시작일자가 종료일자보다 늦을 수 없습니다."
    if (fromDt.isAfter(toDt)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_The start date cannot be later than the end date.'),
      });
      return;
    }

    // MSG00164 — 기간 상한 (MKT/SALES 3년, BIZ 10년 — AS-IS 실측). 초과 시 To 보정 후 중단
    const limitYears = PERIOD_LIMIT_YEARS[gubun];
    if (fromDt.add(limitYears, 'year').isBefore(toDt)) {
      void setAlert({
        type: 'alert',
        content: t('MSG00164', `_The search period cannot exceed ${limitYears} years.`),
      });
      setSearchParams({ endYyyymmdd: fromDt.add(limitYears, 'year').format('YYYYMMDD') });
      return;
    }

    const changed = setFilters({ userId: session.userId });
    // 조건 불변 재조회 = 메인+TITLE 전 쿼리 재조회 — [tabId] prefix invalidate
    // (active.refetch 만 하면 TITLE 이 캐시 재사용 → SP 정정 후에도 옛 컬럼셋 표시. hook 계보:
    //  invalidateQueries([MENU_ID]) 는 메인 그리드 미매칭 — 키 prefix 는 tabId)
    if (!changed) void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  // 조회 전용 — CUD/업로드 숨김 (AS-IS F7/F8/F9 no-op, F2=MSG00109).
  //   Excel/Filter/Sort 는 공용 경로 복귀 — 실 FlexGrid 이므로 `GridAction.excelDownload`(다단 헤더 재구성)와
  //   F3/F4 가 그대로 동작한다 (구 OLAP 오버라이드·`filter:false`/`sort:false` 폐기, 2026-09-04).
  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  // [E20260831-MEASURE] 공통 메저 선택 모달 (AS-IS 0035/0022/0051 공통 기능 — 정본 사용형 DMF0003, hook #132)
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ⭐ [E20260902-MEASDEPS] Measure 모달 OK — 정본 DMF0003 `MktFcst.tsx:1204~1226` 1:1.
  //   ① 그리드 비움: 이전 조회 rows 는 이전 메저 집합 기준이라 무효. `clearData()` 로 filters 를 비워
  //      3 GUBUN 쿼리를 disable 하고, `removeQueries([tabId])` 로 캐시까지 지운다.
  //      ⚠ removeQueries 필수 — queryKey 는 `buildTabQueryKey(tabId, sheet, action, filters)` 라
  //        동일 조건으로 다시 Search 하면 전역 staleTime=Infinity 캐시가 옛 rows 를 그대로 돌려준다.
  //      ⚠ 키 prefix 는 **tabId(UUID)** 다 — `invalidateQueries([MENU_ID])` 는 메인 그리드에 매칭되지 않는다.
  //   ② 서버 저장: 표시 메저만 sortOrderNo 1..n (titleSetApi 저장 계약 = 행 존재가 곧 표시).
  //      codes === null(전체 선택)이면 전 메저 코드를 그대로 저장한다 — 빈 배열 저장은 SP no-op(false).
  //   ③ 저장 성공 후 메저 메타 재fetch — 모달 재진입 목록/기본값을 서버 기준으로 다시 맞춘다.
  //   재조회는 Search 버튼 (division/bucket 변경 초기화와 동일 정책 — 자동 재조회 없음).
  const handleApplyMeasures = (codes: string[] | null) => {
    clearData();
    queryClient.removeQueries({ queryKey: [tabId] });
    // 모달 재진입 시 좌/우 복원 상태 (행 필터 아님 — 위 [E20260902-MEASDEPS] 주석 참조)
    applyVisibleMeasures(gubun, codes);

    const meta = GUBUN_META[gubun];
    const selected = codes ?? staticMeasures.map(measure => measure.colNm);
    void saveTitleSet({
      menuId: meta.programId,
      sheetName: meta.titleSetSheetNm,
      // Measure 개인화 — 폭/색은 대상이 아니라 미전달(빈 값으로 저장됨).
      columnType: 'M',
      rows: selected.map((name, index) => ({ name, sortOrderNo: index + 1 })),
    }).then(ok => {
      if (!ok) {
        void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
        return;
      }
      if (!session.userId || !searchParams.divisionId) return;
      void fetchStaticMeasures({
        divisionId: searchParams.divisionId,
        measureSheetNm: meta.measureSheetNm,
        programId: meta.programId,
      });
    });
  };
  // ⭐ GRID COLUMN SET — 공용 정본 모달(@shared ColumnLayoutModal, hook #132 §2-1. 구 ColumnSettingModal ⛔).
  //   ⚠ 축은 GUBUN 별 **종속 PROGRAM_ID + SHEET_COLUMNS 실등록 시트명**이다(GUBUN_META).
  //     저장 SP(`SCM0002_SET_TITLESET_POPUP`)의 'C' 분기가 `SCM_MST_SHEET_COLUMNS` 에서 SELECT 해
  //     INSERT 하므로(사내 라이브 L138~156), 메타에 없는 시트명으로 저장하면 DELETE 만 되고 0행이 들어간다.
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const columnLayoutSettings = useMemo(
    () => columnSettings[gubun] ?? toColumnLayoutSettings(staticColumns),
    [columnSettings, gubun, staticColumns]
  );

  const handleSaveColumnLayout = (settings: ColumnLayoutRow[]) => {
    // ① 그리드 비움 (#132 §2-2) — 이전 조회 rows 는 이전 컬럼 구성 기준이라 무효.
    //    키 prefix 는 tabId(UUID) — invalidateQueries([MENU_ID]) 는 메인 그리드에 매칭되지 않는다.
    clearData();
    queryClient.removeQueries({ queryKey: [tabId] });
    // ② FE 적용 (MKT 는 SP 개인화 축과 달라 FE 가 정본 — B-2 축 정정 전까지의 안전망 겸용)
    applyColumnSettings(gubun, settings);

    // ③ 서버 저장 (titleset 'C')
    const meta = GUBUN_META[gubun];
    const visible = settings.filter(row => row.USER_FLAG === 'Y');
    void saveTitleSet({
      menuId: meta.programId,
      sheetName: meta.sheetNm,
      columnType: 'C',
      rows: visible.map((row, index) => ({
        name: row.COLUMN_NAME,
        sortOrderNo: index + 1,
        colWidth: row.COL_WIDTH,
        cellColor: row.CELL_COLOR,
        textColor: row.TEXT_COLOR,
      })),
    }).then(ok => {
      if (!ok) {
        void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
        return;
      }
      void setToast({ message: t('MSG00606', '_Saved.'), type: 'success' });
      // ⚠ 모달 titleset 쿼리 키의 첫 요소는 menuId(= 종속 PROGRAM_ID) — MENU_ID 로 무효화하면
      //   SALES/BIZ 가 "저장했는데 재진입 시 원복" 으로 보인다.
      void queryClient.invalidateQueries({ queryKey: [meta.programId] });
      if (!session.userId || !searchParams.divisionId) return;
      void fetchStaticColumns({
        divisionId: searchParams.divisionId,
        sheetNm: meta.sheetNm,
        programId: meta.programId,
      });
    });
  };

  // #120 아이콘 버튼 순서 = 환율 → ColumnSet → Measure (본 화면은 환율 없음).
  //   BTN 권한 배선(COLUMN_SETUP/MEASURE_SELECT)은 메타 미등재 상태라 무게이트 노출 —
  //   등재 후 `hasButton` 게이트로 전환한다(정본 DMF0003 `MktFcst.tsx:836~857`).
  const customButtons = [
    {
      label: t('LBL00605', '_Column Setting'),
      title: t('LBL00605', '_Column Setting'),
      action: () => setOpenColumnSetting(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
    {
      label: t('LBL00712', '_Measure'),
      title: t('LBL00712', '_Measure'),
      action: () => setOpenMeasureSelect(true),
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <DemandPlanWaterfallForm
        onSubmit={handleSubmit}
        onDivisionChange={handleDivisionChange}
        onBucketChange={handleBucketChange}
        onGubunChange={handleGubunChange}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        // wide 바인딩이라 UI 건수 = 그리드 행수 = Excel 행수가 자동 일치 (구 피벗 병합 보정 불요).
        //   F4 필터로 행이 줄면 SubTitle 이 collectionView.items.length 로 보정한다.
        dataCount={scaledData.length}
        excelFileName='DemandPlanWaterfall'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      {/* 결과 영역 — 공용 셸(ResultArea)이 남은 높이를 준다. 그리드 래퍼 div 금지(#132 §1-3). */}
      <ResultArea>
        <DemandPlanWaterfallGrid
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          gubun={gubun}
          data={scaledData}
          isoWeek={isoWeek}
          tabId={tabId}
        />
      </ResultArea>

      {/* ⭐ GRID COLUMN SET — 공용 정본(@shared). 축 = GUBUN 별 종속 PROGRAM_ID + SHEET_COLUMNS 실등록 시트명.
          fallbackColumns/initialSettings 는 현재 화면 컬럼(개인화 반영본) — 미전달 시 재진입에 선택이 원복된다. */}
      <ColumnLayoutModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={GUBUN_META[gubun].programId}
        sheetName={GUBUN_META[gubun].sheetNm}
        columnType='C'
        divisionId={searchParams.divisionId}
        fallbackColumns={staticColumns.map(column => ({
          key: column.colNm,
          header: column.colLblNm,
          width: column.colWth,
        }))}
        initialSettings={columnLayoutSettings}
        title={t('LBL00711', '_Column')}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        onSave={handleSaveColumnLayout}
      />

      {/* [E20260831-MEASURE] 공통 메저 선택 — master 공용 정본 모달(hook #132, 사본 ⛔).
          ⭐ [E20260902-MEASDEPS] OK = **서버 영구 저장(titleset 'M') + 그리드 비움** (정본 DMF0003
             `MktFcst.tsx:1204~1226` 1:1). AS-IS `DM0002_TitleSetForm_Popup.cs:425` SaveTitleSet →
             `SCM0002_SET_TITLESET_POPUP` 과 동일 계약이며, 종속 메저는 다음 조회 때 SP 가 붙여 내려준다.
          ⚠ 저장 엔드포인트는 공용 `POST /admin/menu/{mnuId}/titleset` (BE 고정 매핑) —
             `MenuServiceImpl.saveTitleSet` javadoc 대로 `SCM_ADM_MNU_BTN_MPG_M` 등록을 요구하지 않는다
             (화면별 `{menuId}/titleSet/SAVE/call-proc` 경로였다면 403). 따라서 메타 배선 작업 불요.
          ⚠ menuId 는 **GUBUN 별 종속 PROGRAM_ID**(DMF0035/DMF0022/DMF0051) — BE 가 path mnuId 를 그대로
             P_PROGRAM_ID 로 넘기므로 MENU_ID 고정 전달 시 SALES/BIZ 가 저장은 되고 조회에 안 잡힌다. */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures[gubun]}
        onApply={handleApplyMeasures}
      />
    </>
  );
};
