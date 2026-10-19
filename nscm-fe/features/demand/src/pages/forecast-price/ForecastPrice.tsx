import { FileExceluploadIcon } from '@lges/design-system/icon';
import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ItemByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { getInsertAnchor, GridAction, type EditTracker } from '@foundation/utils';
// ⭐ [2026-08-20 정본 단일화] Grid Column Setting 모달 = @shared/components 표준 정본 직행
//   (packages/shared/.../templates/modals/column-layout-modal — hook #132 §Column 모달 정본)
import { ColumnLayoutModal, MainTitle, SubTitle, toColumnLayoutSettings } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import { compareForecastRows, groupKeyBindings, type GroupKeyColumn } from './components/ForecastPriceGridUtils';
import {
  ExchangeRateModal,
  ForecastTemplateModal,
  SavePricePeriodModal,
  VersionSelectModal,
} from './components/modals';
import {
  AUTH_MEASURES,
  MENU_ID,
  MSG,
  SHEETS,
  UPLOAD_HEADERS,
  UPLOAD_SHEET,
} from './forecast-price.constants';
import type {
  ButtonAuthRow,
  CalendarRow,
  ForecastPriceRow,
  MeasureAuthRow,
  MonthInfoRow,
  SpreadTitleRow,
} from './forecast-price.types';
import { useForecastPriceStore } from './useForecastPriceStore';
import { saveExcelUpload, saveTitleSet, TITLESET_SHEET } from './utils/forecast-price.api';
import { q } from './utils/forecast-price.combo';
import { editableDayColumnsOf } from './utils/forecast-price.editLock';
import { buildSavePayload, buildSaveRows } from './utils/forecast-price.save';
import { validateSaveRows } from './utils/forecast-price.validate';
import { buildWsFcstTypeSet, parseWsPlannerYn } from './utils/forecast-price.wsAuth';

// ⭐ DMF0082 (Fcst&Price MGMT) — AS-IS DMF0082_FcstNPrice_Mgmt 1:1. 조회 = PKG_DMF0082.
//   P_DMF0082_GET_MAIN_DATA(12 IN+6 cursor) / 저장 = DMF0082_SAVE_MAIN_DATA(17 IN '^' bulk).
export const ForecastPrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<TFlexGrid<ForecastPriceRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker | null>(null);

  const [versionModalOpen, setVersionModalOpen] = useState(false);
  const [measureModalOpen, setMeasureModalOpen] = useState(false);
  const [columnModalOpen, setColumnModalOpen] = useState(false);
  const [exchangeModalOpen, setExchangeModalOpen] = useState(false);
  const [savePriceModalOpen, setSavePriceModalOpen] = useState(false);
  const [uploadModalOpen, setUploadModalOpen] = useState(false);
  const [templateModalOpen, setTemplateModalOpen] = useState(false);
  // 저장 진행 오버레이 — '^' bulk 저장은 react-query 밖이라 전역 스피너가 뜨지 않는다
  //   (정본 SalesReports.tsx:133·493 동일 패턴). 화면 스피너로 진행 중임을 알린다.
  const [saving, setSaving] = useState(false);
  // GridAction.addRowSet/removeRow 는 itemsSource 배열을 직접 splice/remove 하고 setState 를
  //   호출하지 않는다 — React 리렌더가 안 일어나면 이 컴포넌트가 렌더에서 파생하는 값(SubTitle
  //   의 dataCount 등)이 Insert/Delete 이후에도 그 이전 렌더 시점 값에 멈춰 있는다.
  //   handleInsert/handleDelete 끝에서 이 카운터를 올려 강제로 한 번 리렌더시킨다.
  const [, forceGridRerender] = useState(0);

  /**
   * 저장·업로드·설정변경 후 **자동 재조회** (사용자 요구 — "저장완료 메세지 후에는 자동재조회").
   *
   * ⛔ 구 코드는 무효화 키를 `[MENU_ID]` 로 걸었는데 **메인 그리드에 매칭되지 않았다.**
   *   쿼리 키는 `buildTabQueryKey` 가 만든다 (`useCustomQueryClient.ts:47`):
   *       [tabId, sheetName, procedureAction, {...filters}]
   *   즉 **prefix 가 `tabId`(탭 UUID)** 다. 메인 화면은 `PageProps.tabId` 를 넘기고(:192,:200),
   *   모달들만 `tabId: MENU_ID` 를 쓴다 → 구 키는 **모달 쿼리만** 무효화하고 메인 그리드는 그대로 남아,
   *   저장해도 화면이 갱신되지 않았다(2026-08-22 실측).
   *   ⇒ 둘 다 무효화한다: 메인(`tabId`) + 모달 스코프(`MENU_ID`).
   */
  const invalidateAfterSave = useCallback(() => {
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    // `queryClient` 는 모듈 스코프 싱글턴(@foundation/query-client) — deps 대상이 아니다.
  }, [tabId]);

  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const filters = useForecastPriceStore(state => state.filters);
  const titleFilters = useForecastPriceStore(state => state.titleFilters);
  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const setFilters = useForecastPriceStore(state => state.setFilters);
  const clearFilters = useForecastPriceStore(state => state.clearFilters);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useForecastPriceStore(state => state.setOpenSearchArea);
  const fetchStaticColumns = useForecastPriceStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useForecastPriceStore(state => state.fetchStaticMeasures);
  const restoreSearchConditions = useForecastPriceStore(state => state.restoreSearchConditions);
  const setMeasureAuth = useForecastPriceStore(state => state.setMeasureAuth);
  const setCalendar = useForecastPriceStore(state => state.setCalendar);
  const setM3Cutoff = useForecastPriceStore(state => state.setM3Cutoff);
  // M+4 동결 경계월 — 저장(Insert/Delete 일자 산출)에서도 셀 편집과 같은 기준을 써야 한다.
  const m3CutoffYyyymm = useForecastPriceStore(state => state.m3CutoffYyyymm);
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const buttonAuth = useForecastPriceStore(state => state.buttonAuth);
  const setButtonAuth = useForecastPriceStore(state => state.setButtonAuth);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const originalStaticColumns = useForecastPriceStore(state => state.originalStaticColumns);
  const staticMeasures = useForecastPriceStore(state => state.staticMeasures);
  const fetchUserColumnLayout = useForecastPriceStore(state => state.fetchUserColumnLayout);
  const applyColumnLayout = useForecastPriceStore(state => state.applyColumnLayout);
  const authGroup = useForecastPriceStore(state => state.authGroup);
  const setAuthGroup = useForecastPriceStore(state => state.setAuthGroup);
  const setWsPlannerYn = useForecastPriceStore(state => state.setWsPlannerYn);

  // 마운트 1회 — F6 로 저장한 조회조건 복원. 복원이 divisionId 를 바꾸면 아래 division-키 effect 가
  //   컬럼/메저를 복원된 division 기준으로 다시 받는다(별도 순서 await 불필요).
  useEffect(() => {
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // division-linked 메타(SHEET_COLUMNS/SHEET_MEASURE) — 81 전환 시 재fetch (fetch 는 호출 시점 divisionId 를 body 로 전송)
  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // ⭐ 저장된 컬럼 개인화 복원 — BE PR_GET_SHEET_COLUMN_LIST 가 개인화를 반영하지 않으므로
    //   (SHEET_PRSL_YN 미등록) FE 가 titleSet 'C' 를 직접 조회해 staticColumns 에 덧씌운다.
    void fetchUserColumnLayout();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.divisionId]);

  // ⭐ Division 변경 = Grid 초기화 의무 (mkt-fcst/metal-link-price/sales-future-price 선례 1:1).
  //   division 이 바뀌면 컬럼 셋(위 effect)만 갈리고 이전 division 의 조회 결과·신규행·편집 추적이
  //   그대로 남아, 바뀐 컬럼에 옛 데이터가 얹힌 채로 오편집·오저장될 수 있다(2026-07-27 실측).
  //   ⇒ 조회조건(filters/titleFilters)을 무효화해 그리드를 공백으로 되돌린다. 재조회는 Search(F5) 로만.
  //   ⚠️ 초기 마운트/persist 복원은 제외 — 실제 division '변경' 시에만 동작(prevDivisionRef 가드).
  const prevDivisionRef = useRef(searchParams.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === searchParams.divisionId) return;
    prevDivisionRef.current = searchParams.divisionId;
    editTrackerRef.current?.clearChanges(); // 미저장 편집 추적 reset
    clearFilters(); // filters/titleFilters 무효화 → useTabProcQuery enabled=false → rows/동적컬럼 비움
  }, [searchParams.divisionId, clearFilters]);

  // ⭐ [ENDCUSTDISP 2026-08-18 사용자 확정] 비40 division 의 그리드 END_CUSTOMER 표시값을
  //   조회조건과 **같은 축**(SCM_MST_SITE.END_CUSTOMER — Volvo/BMW/HKMC)으로 파생 표기한다.
  //   원장(DM_PLN_CFM_*)의 END_CUSTOMER 는 PK 구성 컬럼이라 값 자체를 바꾸면 SAVE 의 DELETE/MERGE
  //   키가 어긋나 중복 적재된다 ⇒ 원값은 END_CUSTOMER_KEY 로 보존하고(gridRows 변환) 저장은
  //   keyOf 가 KEY 를 우선 사용한다(forecast-price.save.ts). SP 무변경 — 표시/키 분리는 FE 전담.
  //   맵 원천 = CMBO 'SiteEndCustomerMapDMF0082' (division→ SCM_SITE_ID:END_CUSTOMER, (DIV,SITE)
  //   유일성 실측 0중복 = 1:1). 40 은 AS-IS 부터 PROJECT_CODE 축이 조회조건과 동일하므로 제외.
  const siteEcMapRef = useRef<Map<string, string>>(new Map());
  const [siteEcVersion, setSiteEcVersion] = useState(0);
  useEffect(() => {
    const div = searchParams.divisionId;
    siteEcMapRef.current = new Map();
    setSiteEcVersion(v => v + 1);
    if (!div || div === '40') return;
    // 인용/이스케이프는 quoteComboParams 가 멱등 처리하지만, 화면 관례(q())·게이트 G-G 와
    //   정렬해 명시 인용한다 (멱등이라 이중 인용 무해).
    void apiClient
      .getCombo({ comboId: 'SiteEndCustomerMapDMF0082', divisionId: q(div) })
      .then(rows => {
        siteEcMapRef.current = new Map(
          (rows ?? []).map(r => [String(r.CODE ?? ''), String(r.NAME ?? '')])
        );
        setSiteEcVersion(v => v + 1);
      })
      .catch((err: unknown) => {
        // 실패 시 원값(원장 키) 표시 유지 — 조용한 무증상 금지, 콘솔로 남긴다.
        console.error(
          '[combo] SiteEndCustomerMapDMF0082 조회 실패 — END_CUSTOMER 원값 표시 유지',
          err
        );
      });
  }, [searchParams.divisionId]);

  // Column Setting 팝업 재진입 복원 — 현재 grid 상태(개인화 반영본).
  //   ⚠️ DB 응답이 우선이고 이 값은 BE 가 안 준 필드만 보완한다 (buildInitialRows 규칙).
  const columnLayoutSettings = useMemo(
    () => toColumnLayoutSettings(staticColumns),
    [staticColumns]
  );

  // Default 버튼 원복 기준 — 개인화 적용 전 admin 메타 원본.
  const columnLayoutDefaults = useMemo(
    () => toColumnLayoutSettings(originalStaticColumns),
    [originalStaticColumns]
  );

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.FCST_N_PRICE_40>({
    menuId: MENU_ID,
    sheetName: SHEETS.FCST_N_PRICE_40,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  const { data: titleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: titleFilters,
    enabled: titleFilters !== undefined,
  });

  // ⭐ P_USERINFO 권한 그룹 — 세션 groupId 유령 필드(2026-07-15 실측) 대체. CMBO
  //   'FcstPriceUserAuthGroup'(보유그룹 × GET_ADMIN_GROUP_MEASURE(DMF0082)/GET_ADMIN_GROUP(ALL) 교집합,
  //   ADMIN 우선) 1행을 store.authGroup 에 주입 → setFilters 가 userGroup 으로 사용. 미매칭 = userId
  //   fallback(=lookup 미매칭 = 편집권한 없음, 정상). sales-plan(DMF0021) 선례 1:1.
  // ⭐ 'DM Planner (W/S)' 소속 여부 (CMBO 'MktFcstWsPlannerYn' 단일행 CODE='Y'/'N' — mkt-fcst 선례).
  //   authGroup 으로 대신할 수 없다: authGroup 은 ADMIN 우선 **단일** 그룹이라 겸직자가 ADMIN 으로
  //   해석되면 W/S 판정이 무너진다. AS_In_Req measure 개방 / FCST Type W/S 후보 자격의 단일 원천.
  const [authGroupCombo, wsPlannerCombo] = useTabComboQueries({
    filters: ['FcstPriceUserAuthGroup', 'MktFcstWsPlannerYn'],
  });
  useEffect(() => {
    const first = (authGroupCombo ?? [])[0] as { CODE?: string } | undefined;
    if (first?.CODE) setAuthGroup(String(first.CODE));
  }, [authGroupCombo, setAuthGroup]);
  useEffect(() => {
    setWsPlannerYn(parseWsPlannerYn(wsPlannerCombo as ReadonlyArray<{ CODE?: unknown }>));
  }, [wsPlannerCombo, setWsPlannerYn]);

  // 버튼 활성화 권한 — 조회(Search)와 분리해 화면 오픈·Division 변경 시 받는다.
  //   PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH 가 GET_MAIN_DATA 의 메저 편집권한 산출 블록을 그대로 돌려
  //   Insert/Delete/Save/Price Batch/Excel 버튼 Y/N 1행(buttonAuth)과 메저별 권한(measureAuth)을 준다.
  //   userGroup 은 setFilters 와 같은 규칙(authGroup, 미확정 시 userId) — authGroup 도착 시 filters
  //   참조가 바뀌어 자동 재조회된다. Division 이 비어 있으면 SP 가 전 버튼 'N' 을 주므로 호출하지 않는다.
  const sesUserId = useSessionStore(state => state.session?.userId ?? '');
  const buttonAuthFilters = useMemo<ProcRequest<MENU_ID, SHEETS.BUTTON_AUTH>>(
    () => ({
      divisionId: searchParams.divisionId,
      sesUserId,
      userGroup: authGroup || sesUserId,
    }),
    [searchParams.divisionId, sesUserId, authGroup]
  );
  const { data: buttonAuthData } = useTabProcQuery<MENU_ID, SHEETS.BUTTON_AUTH>({
    menuId: MENU_ID,
    sheetName: SHEETS.BUTTON_AUTH,
    tabId,
    filters: buttonAuthFilters,
    enabled: searchParams.divisionId.trim() !== '',
  });
  useEffect(() => {
    if (!buttonAuthData) return;
    const d = buttonAuthData as unknown as Record<string, unknown[]>;
    setButtonAuth((d.buttonAuth ?? [])[0] as ButtonAuthRow | undefined);
    // 메저 편집권한도 함께 갱신 — 조회 전에도 셀 편집/Insert 기본 MEASURE 판정이 가능해진다.
    //   (조회 응답 drop3 와 같은 산출이라 Search 후 덮어써도 값이 같다.)
    const rows = (d.measureAuth ?? []) as MeasureAuthRow[];
    if (rows.length > 0) setMeasureAuth(rows);
  }, [buttonAuthData, setButtonAuth, setMeasureAuth]);

  // AS FROM SITE 필수 검증(V0) 입력 2종 (현업 요청 2026-07-31 — mkt-fcst MktFcst.tsx L497~525 규칙).
  //   · FcstTypeWs   = W/S·A/S 4종(SALES_TYPE_CODE2) — 이 FcstType 일 때만 필수 대상.
  //   · AS_FROM_SITE = 비축(AS)향 사이트 목록(NAME=사이트) — 여기에 없는 사이트가 '고객향'.
  //   그리드도 같은 콤보를 쓰지만 useTabComboQueries 가 동일 키를 캐시 공유하므로 중복 호출이 아니다.
  const wsPlannerYn = useForecastPriceStore(state => state.wsPlannerYn);
  const [wsFcstTypeWsCombo, asFromSiteCombo] = useTabComboQueries({
    filters: ['FcstTypeWs', { comboId: 'AS_FROM_SITE', divisionId: q(searchParams.divisionId) }],
  });
  // 필수: 집합 생성은 wsAuth.buildWsFcstTypeSet 단일 출처 — 그리드(셀 개방)와 같은 집합이어야 한다.
  //   CODE 만 담았다가 "컬럼은 열리는데 MSG00476 은 안 뜨는" 사고를 냈다 (2026-08-06, 함수 주석 참조).
  const wsFcstTypeSet = useMemo(() => buildWsFcstTypeSet(wsFcstTypeWsCombo), [wsFcstTypeWsCombo]);
  // 주의: 비축향 사이트 판정 키는 CODE 가 아니라 NAME(=사이트 ID) — mkt-fcst L504~506 동일.
  const asSiteNameSet = useMemo(
    () => new Set((asFromSiteCombo ?? []).map(r => (r.NAME ?? '').trim()).filter(Boolean)),
    [asFromSiteCombo]
  );
  // ⭐ race 방어 (sales-plan '40 편집불가' 사고 동일): 콤보 도착 전 조회(또는 persist filters 재사용)로
  //   userGroup=userId 조회가 이미 나갔으면 editAuth 미표시 응답이 남는다 → 그룹 확정 시 filters
  //   재생성(setFilters — 새 queryKey)으로 자동 재조회해 measureAuth 를 갱신.
  useEffect(() => {
    if (authGroup && filters) {
      const isSame = setFilters();
      if (isSame) void refetch();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [authGroup]);

  // GET 부가 커서 반영 — drop1(월정보 M3_CUTOFF=M+4 경계, #4) / drop3(measure 편집권한 EDIT_AUTH_YN =
  //   AS-IS bEDIT_AUTH_* 원천) / drop4(배분 캘린더 MONTH_DAY_CNT·WEEK_DAY_CNT, #1).
  //   기준주차 경계는 editLock util 클라 계산(금주 월요일 — AS-IS L9133 동일 규칙).
  useEffect(() => {
    if (!data) return;
    const d = data as unknown as Record<string, unknown[]>;
    const authRows = (d.drop3 ?? []) as MeasureAuthRow[];
    if (authRows.length > 0) setMeasureAuth(authRows);
    setM3Cutoff((d.drop1 ?? []) as MonthInfoRow[]);
    setCalendar((d.drop4 ?? []) as CalendarRow[]);
    editTrackerRef.current?.clearChanges();
  }, [data, setMeasureAuth, setM3Cutoff, setCalendar]);

  const spreadTitle = useMemo(
    () => ((titleData as unknown as Record<string, unknown[]>)?.data ?? []) as SpreadTitleRow[],
    [titleData]
  );

  // 신규행은 GridAction.addRowSet 이 spRows(=grid.collectionView.sourceCollection)에 직접
  //   splice 하므로 별도 병합이 필요 없다 — rows 는 spRows 참조 그대로다(handleInsert 참고).
  const spRows = useMemo<ForecastPriceRow[]>(() => data?.fcstNPrice ?? [], [data]);
  const gridRows: ForecastPriceRow[] = spRows;

  // [ENDCUSTDISP] 표시값 매핑 + [E20260826-DISPSORT]/[DISPSORT-MEASURE] 표시 정렬 재적용.
  //
  //   이 화면은 나머지 6개 마이그레이션 화면과 달리, 관리자 설정(표시 컬럼 순서·Measure 개인화
  //   순서)이 바뀔 때마다 **조회된(저장) 행 전체**를 표시값 기준으로 다시 정렬해야 한다 —
  //   wijmo 헤더 클릭 정렬(sortDescriptions)과 무관한 별개 요구사항이다. GridAction.addRowSet 은
  //   신규행을 배열에 물리적으로 고정 스플라이스해 두는 모델이라, 이 재정렬이 저장된 행과
  //   신규행을 뒤섞어 버리면 신규행이 자기 앵커에서 떨어져 나간다.
  //   ⇒ 저장된 행만 compareForecastRows 로 재정렬하고, 신규(미저장, CRUD_TYPE='I') 행은 정렬
  //   대상에서 뺀 뒤 GridAction.getInsertAnchor 로 자기 앵커를 다시 찾아 그 바로 위에 끼워
  //   넣는다 — addRowSet 이 Insert 시점에 pinInsertedRow 로 등록해 둔 바로 그 앵커다.
  //   등록된 앵커는 항상 "진짜"(미저장이 아닌) 행이다 — resolveInsertAnchor 의 진입부 pin
  //   체이스가 신규행 위에 또 Insert 하는 경우도 이미 진짜 앵커까지 타고 올라가 등록해 두기
  //   때문에, 여기서 다시 체인을 재귀로 풀 필요가 없다(gridAction.ts resolveInsertAnchor 주석 참고).
  //   앵커가 없거나(맨 위 삽입) 유실된 경우(재조회로 앵커 객체가 사라짐 등)는 맨 위로 폴백한다.
  //
  //   useLayoutEffect 로 페인트 전에 재정렬을 끝내 정렬 전 순서가 잠깐 보이는 것을 막는다.
  //   spRows 배열 참조는 그대로 두고 내용(순서)만 바꾼다 — grid.itemsSource 가 이 배열 자체라
  //   참조를 바꾸면 CollectionView 가 재생성된다.
  useLayoutEffect(() => {
    const g = gridRef.current;
    // [ENDCUSTDISP] 행 객체 제자리 변환(참조 유지 필수: editTracker·insert 앵커가 행 참조를 쥔다).
    //   멱등: END_CUSTOMER_KEY 보유 행은 재변환하지 않는다. 맵 미도착 시 원값 유지.
    if (siteEcMapRef.current.size > 0) {
      for (const row of spRows as unknown as WijmoRowItem[]) {
        if ('END_CUSTOMER_KEY' in row) continue;
        const disp = siteEcMapRef.current.get(String(row.SCM_SITE_ID ?? ''));
        if (disp === undefined) continue;
        row.END_CUSTOMER_KEY = row.END_CUSTOMER ?? '';
        row.END_CUSTOMER = disp;
      }
    }

    const sortCols = staticColumns
      .filter(c => c.visible !== false && !!c.colNm && c.colNm !== 'NO')
      .map(c => c.colNm);
    const measureOrder = new Map<string, number>(staticMeasures.map((m, i) => [m.colNm, i]));

    const pending: ForecastPriceRow[] = [];
    const real: ForecastPriceRow[] = [];
    for (const row of spRows) {
      if ((row as unknown as WijmoRowItem)['CRUD_TYPE'] === 'I') pending.push(row);
      else real.push(row);
    }
    (real as unknown as WijmoRowItem[]).sort((a, b) =>
      compareForecastRows(a, b, sortCols, measureOrder)
    );

    let merged: ForecastPriceRow[];
    if (g && pending.length > 0) {
      const realSet = new Set(real);
      const byAnchor = new Map<ForecastPriceRow, ForecastPriceRow[]>();
      const orphans: ForecastPriceRow[] = [];
      pending.forEach(row => {
        const anchor = getInsertAnchor(
          g as unknown as TFlexGrid<WijmoRowItem>,
          row as unknown as WijmoRowItem
        ) as unknown as ForecastPriceRow | undefined;
        if (!anchor || !realSet.has(anchor)) {
          orphans.push(row);
          return;
        }
        const bucket = byAnchor.get(anchor);
        if (bucket) bucket.push(row);
        else byAnchor.set(anchor, [row]);
      });
      merged = [...orphans];
      real.forEach(row => {
        const bucket = byAnchor.get(row);
        if (bucket) merged.push(...bucket);
        merged.push(row);
      });
    } else {
      merged = real;
    }

    for (let i = 0; i < merged.length; i++) spRows[i] = merged[i];
    g?.collectionView?.refresh();
    // siteEcVersion — [ENDCUSTDISP] 맵 도착 시 표시 변환 재실행 트리거 (맵 자체는 ref).
  }, [spRows, siteEcVersion, staticColumns, staticMeasures]);

  const editableDayColumns = useMemo(
    () =>
      editableDayColumnsOf(
        spreadTitle.map(r => String(r.COLUMN_NAME ?? '')).filter(b => /^D_\d{8}$/.test(b))
      ),
    [spreadTitle]
  );

  const isCurVersion = searchParams.versionType.trim() === 'Current';

  // ⭐ 편집 가능 버전 판정 — 편집권한은 백엔드 PKG 가 행별 EDIT_FLAG 로 종합 산출(요일제한·버전
  //   read-only 포함, types.ts drop3 주석). 과거(조회 전용) 버전은 전 행 EDIT_FLAG='N' 로 내려오므로
  //   편집 가능 행이 하나라도 있으면 편집 버전으로 본다.
  //   ⚠️ 문자열 versionType==='Current' 단독 판정은 불가 — 버전 팝업은 선택 시 VERSION_NO 를 넣어
  //     (VersionSelectModal onApply) 편집 가능한 현재 버전조차 'Current' 가 아니게 된다. 따라서
  //     기본/수동 Current(빈 결과 포함) 이거나, 조회 데이터에 편집가능 행이 있으면 편집 버전.
  const isEditableVersion =
    isCurVersion ||
    ((data?.fcstNPrice ?? []) as WijmoRowItem[]).some(r => String(r.EDIT_FLAG ?? '') !== 'N');

  // 버튼 노출 게이트(division 82 조회 전용 / Excel 81 계열 전용 / 메저 편집권한 유무)는 FE 에서
  //   division 문자열로 판정하지 않는다 — buttonAuth 시트(P_DMF0082_GET_BUTTON_AUTH)가 같은 규칙으로
  //   Y/N 을 내려준다(store.buttonAuth). 서버 권위(EDIT_FLAG/SAVE V82-00/Upload 81 Only)는 그대로.

  // ── Search (AS-IS FindButton — V1~V4 검증 후 조회) ──
  //   [공통 C2 2026-08-14 정정] 수정 중 재조회 가드(MSG 확인 팝업)는 여기서 하지 않는다.
  //   조회 진입점 두 곳(SearchArea 조회 버튼 · SubTitle F5)이 이미 공통 가드
  //   confirmIfDirtyKey(..., 'search') 로 감싸 confirm + 편집분 되돌리기까지 수행한다.
  //   화면이 같은 검사를 한 번 더 하면 팝업이 2연속으로 뜬다 — 공통 가드가 확인 직후
  //   뜬다(2번째 팝업은 MSG00703 = 닫기 문구라 "이 화면을 닫으시겠습니까?" 로 떴다). 신규행은
  //   grid.collectionView.sourceCollection 에 직접 물려 있어 discardDirtyKey 의 그리드 되돌리기로
  //   함께 사라지므로 화면이 별도로 정리할 state 가 없다.
  const handleSubmit = async () => {
    if (!searchParams.divisionId) {
      await setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_Select Division.') });
      return;
    }
    if (!searchParams.versionType.trim()) {
      await setAlert({ type: 'alert', content: t(MSG.VERSION_REQUIRED, '_Select Version.') });
      return;
    }
    const from = searchParams.startYyyymmdd;
    const to = searchParams.endYyyymmdd;
    if (from && to && from > to) {
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_ORDER, '_Invalid period.') });
      return;
    }
    // 3년 초과 (AS-IS MSG00164 — 종료일 보정 후 재입력 안내)
    const fromYear = Number(from.slice(0, 4));
    if (Number(to.slice(0, 4)) - fromYear >= 3) {
      setSearchParams({ endYyyymmdd: `${fromYear + 2}${from.slice(4)}` });
      await setAlert({ type: 'alert', content: t(MSG.PERIOD_3Y, '_Period exceeds 3 years.') });
      return;
    }
    const isSame = setFilters();
    if (isSame) void refetch();
  };

  /**
   * 클릭한 셀 기준 병합 축 컬럼(keyBindings)으로 groupKey 함수를 만든다 — GridAction.addRowSet
   * 의 groupKey 옵션에 그대로 넘긴다. 판정 축은 옛 groupTopRowOf 와 동일 규칙 — Sales Site 셀은
   * 그 안의 여러 Model 블록을, Model 셀은 그 안의 Incoterms 블록을, Incoterms 셀은 measure
   * 블록만 덮는다(사용자 요구 2026-08-17 "선택한 값의 병합한 데이터 위로"). 값이 빈 셀은 wijmo
   * 가 아예 병합하지 않으므로(mergeManager `isEmptyCellValue`) 축에서 빼고 data Group(measure
   * 블록) 기준으로 떨어뜨린다.
   */
  const buildGroupKeyOf = (g: TFlexGrid<ForecastPriceRow>): ((row: ForecastPriceRow) => string) => {
    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      // visible 미지정(undefined)은 표시로 본다 — 잘못 빼면 축이 통째로 폴백된다.
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const selectedIndex = g.selection.row;
    const clickedIndex = g.selection.col;
    const clickedBinding = columns[clickedIndex]?.binding ?? '';
    const clickedValue = clickedBinding
      ? (g.rows[selectedIndex]?.dataItem as WijmoRowItem | undefined)?.[clickedBinding]
      : undefined;
    const isEmptyCell =
      clickedValue === null || clickedValue === undefined || String(clickedValue).trim() === '';

    const keyBindings = groupKeyBindings(columns, isEmptyCell ? -1 : clickedIndex);
    return (row: ForecastPriceRow) => {
      if (keyBindings.length === 0) return '';
      const rec = row as unknown as WijmoRowItem;
      // 값이 전부 빈 문자열이어도 key 가 falsy 로 접히지 않도록 접두사를 붙인다 —
      //   resolveInsertAnchor 는 groupKey 가 falsy 면 walk 자체를 건너뛴다.
      return `K:${keyBindings.map(binding => String(rec[binding] ?? '')).join('')}`;
    };
  };

  // ── Insert (AS-IS InsertButton — Current 버전 조회 시에만) ──
  //   ⭐ #9 시드 복사 (AS-IS L2636~2676): 포커스 행이 있으면 키 컬럼을 새 행에 복제한다.
  //   단 MEASURE 는 복사 대상에서 제외 — 통합테스트 35번 요구 (아래 MEASURE 주석 참조).
  const handleInsert = () => {
    if (!isEditableVersion) return;
    // 신규행 생성 자격 없는 역할(SCP Planner 등)은 진입 차단 — 버튼 은닉과 같은 기준(buttonAuth.insert).
    //   판정은 SP(P_DMF0082_GET_BUTTON_AUTH INSERT_YN)가 한다: MKT_FCST/LOC/VMI_In_Req 중 하나라도 'Y'.
    if (!buttonAuth.insert) return;
    const g = gridRef.current;
    const selectedIndex = g?.selection.row ?? -1;
    const seedRow = g?.rows[selectedIndex]?.dataItem as ForecastPriceRow | undefined;
    const seed = seedRow as unknown as WijmoRowItem | undefined;
    const str = (v: unknown): string => (typeof v === 'string' ? v : '');
    const baseDivision = str((data?.fcstNPrice ?? [])[0]?.DIVISION_ID);
    const newRow = {
      CRUD_TYPE: 'I',
      DIVISION_ID: searchParams.divisionId || str(seed?.['DIVISION_ID']) || baseDivision,
      END_CUSTOMER: str(seed?.['END_CUSTOMER']),
      PROJECT_CODE: str(seed?.['PROJECT_CODE']),
      // [CASCADE 2026-08-07] PLANT_SITE_ID 시드 승계 — 81 신규 행이 ''(공백)이면 V81-01(PLANT 공백) 저장 차단.
      //   시드 행의 실값('WA00-P' 등)을 승계 (2026-08-07 SP 직접 I 실증은 시드 실값 경로였음).
      PLANT_SITE_ID: str(seed?.['PLANT_SITE_ID']),
      // AS FROM SITE 시드 승계 — SAVE 의 p_as_from_site 로 나가는 키 컬럼이라 신규행도 이어받는다.
      AS_FROM_SITE: str(seed?.['AS_FROM_SITE']),
      SCM_SITE_ID: str(seed?.['SCM_SITE_ID']),
      // ⭐ DEPT_ID 시드 승계 — AS-IS 그리드 행은 Team 을 항상 들고 있고, 셀 팝업이 그 값을 조회조건으로
      //   읽어 간다(`.cs:3725` `sTeam = GetValue(e.Row, ...Team)`). TO-BE 신규행에는 이 키가 아예
      //   없어 `undefined→''` 가 팝업으로 나갔고, 조회 SP 가 0행을 돌려줬다
      //   (실측 `PKG_COM0000.P_COM0008_GET_ITEM_BY_DIVISION_POPUP`: 'ALL' 14,458행 / '' 0행 —
      //    술어가 `P_DEPT_ID='ALL' OR ...` 엄격비교라 빈값이 어느 것도 못 만난다).
      DEPT_ID: str(seed?.['DEPT_ID']),
      ITEM_ID: str(seed?.['ITEM_ID']),
      DOM_EXP: str(seed?.['DOM_EXP']),
      FCST_TYPE: str(seed?.['FCST_TYPE']),
      INCOTERMS: str(seed?.['INCOTERMS']),
      // ⭐ [2026-08-22 사용자 결정 — AS-IS 파리티] measure 는 **시드에서 복사하지 않고 기본값을 넣는다.**
      //   AS-IS `InsertRow()` 는 두 갈래다(`DMF0082_FcstNPrice_Mgmt.cs:2636-2676`):
      //     if (bFocusYN)  → 포커스 행에서 Measure 를 **복사**
      //     else           → `SetValue(..., Measure, "MKT_FCST")` **기본값만** 설정
      //   `[통합테스트 35번]` "라인추가시 measure 는 copy 하지 않음" 은 **if 분기(복사)** 를 막은 요구이고,
      //   **else 분기의 기본값은 별개 조항**이다. 종전 구현은 둘을 묶어 기본값까지 없애 `''` 로 두었고,
      //   그 결과 AS-IS(`MKT_FCST`) 와 초기값이 달라졌다(사용자 신고 2026-08-22).
      //   ⇒ 복사는 계속 하지 않고(35번 충족), 기본값만 AS-IS else 분기와 동일하게 복원한다.
      //   부수효과: 공백 measure 일 때 잠기던 수량/가격 셀이 처음부터 열린다(AS-IS 와 동일).
      //   [E20260826-AUTHVIEW] + MKT_FCST 편집권한이 없는 그룹(예: SCP Planner — 시간창 메저 = SCM_FCST)은
      //     AS-IS 하드코딩 기본값이 곧바로 "편집 불가 메저" 가 되는 모순(사용자 신고 2026-08-26).
      //     drop3 'Y' 인 첫 메저로 폴백 — ADMIN/DM 계열은 MKT_FCST='Y' 라 기존값 그대로(8/22 결정 보존).
      MEASURE: measureAuth['MKT_FCST']
        ? 'MKT_FCST'
        : (['SCM_FCST', 'LOC', 'VMI_In_Req'].find(m => measureAuth[m]) ?? 'MKT_FCST'),
      // ⭐ [2026-08-22 사용자 결정 — AS-IS 로직 이식] CURRENCY 는 **시드에서 복사하지 않는다.**
      //   AS-IS `InsertRow()` 의 두 분기는 **원자적**이다:
      //     if (bFocusYN) → Measure **와** CURRENCY 를 둘 다 포커스 행에서 복사 (`.cs:2664·2668`)
      //     else          → Measure="MKT_FCST" 만 설정, **CURRENCY 는 손대지 않음(=공백)** (`.cs:2674`)
      //   TO-BE 는 통합테스트 35번으로 Measure 복사가 막혀 있으므로 **else 분기에 해당**한다.
      //   그런데 CURRENCY 만 if 분기처럼 복사하면 AS-IS 가 만들지 않는 조합이 된다
      //   (MEASURE='MKT_FCST' + CURRENCY='USD'). 두 분기를 섞으면 안 된다.
      //   ⇒ 근거 보강: AS-IS 는 measure 가 'LOC' 가 아니면 CURRENCY 셀 콤보를 `NO_DATA`(빈 목록)로
      //     바꿔(`.cs:5626-5645`) **입력도 선택도 불가**하게 만든다. 그 상태에서 값만 남으면
      //     사용자가 지울 수도 없다(사용자 신고 2026-08-22). 저장 검증·중복키도 CURRENCY 를
      //     'LOC' 일 때만 요구/대조한다(`.cs:7710` / `.cs:2286-2298`).
      CURRENCY: '',
      CELL_PROD_SITE_ID: str(seed?.['CELL_PROD_SITE_ID']),
      // 시드 행 BUCKET(요일비트) 승계 — 배분 요일 유지 (없으면 #2 캐스케이드/기본요일).
      BUCKET: str(seed?.['BUCKET']),
      EDIT_FLAG: 'Y',
    } as unknown as ForecastPriceRow;
    if (!g) return;
    // 앵커·정렬 고정·필터 예외 등록은 GridAction.addRowSet(groupKey=buildGroupKeyOf) 이 전부
    //   처리한다 — [통합테스트 35번] 앵커가 포커스 행 자체면 그룹 중간(measure 2~3번째)을 찍었을
    //   때 신규행이 measure 사이에 끼는 문제를, 클릭 컬럼 기준 병합 축(groupKeyBindings)으로
    //   그룹 최상단까지 밀어 올려 해결한다. 배열 끝에 붙여 누른 순서를 유지한다 — 같은 앵커에
    //   연속 Insert 시 누른 순서대로 쌓인다(resolveInsertAnchor 의 pin 체이스).
    const added = GridAction.addRowSet(
      g as unknown as TFlexGrid<WijmoRowItem>,
      [newRow] as unknown as Partial<WijmoRowItem>[],
      'above',
      {
        groupKey: buildGroupKeyOf(g) as unknown as (row: WijmoRowItem) => string,
        preserveMergeManager: true,
      }
    ) as unknown as ForecastPriceRow[] | undefined;
    const target = added?.[0];
    if (!target) return;
    for (let i = 0; i < g.rows.length; i++) {
      if (g.rows[i]?.dataItem !== target) continue;
      g.select(i, Math.max(0, g.selection.col));
      g.scrollIntoView(i, -1);
      break;
    }
    // addRowSet 이 setState 를 호출하지 않으므로 강제 리렌더 — SubTitle dataCount 등을 최신
    //   rows 로 다시 계산시킨다.
    forceGridRerender(v => v + 1);
    // [공통 C1 2026-08-11 → 2026-08-12 정정] 필터링 상태 Insert 시 신규행이 안 보이던 문제는
    //   addRowSet 이 신규(CRUD_TYPE='I') 행을 필터 예외로 등록해 해결한다.
    //   구 구현의 `gridFilterRef.current?.clear()` 는 사용자가 걸어둔 필터까지 날려서 제거했다.
  };

  // ⭐ [No.65 2026-08-14] Project 셀 검색 모달 상태 — 더블클릭한 신규행에 선택값을 되꽂는다.
  const [openProject, setOpenProject] = useState(false);
  // ⭐ [2026-08-22] Model(ITEM_ID) 셀 검색 모달 — AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3772`
  //   `spdMain_CellDoubleClick` 의 `DM0002_ItembyDivisionPopupEx` 배선. TO-BE 에 누락돼 있었다.
  const [openItem, setOpenItem] = useState(false);
  const [popupRow, setPopupRow] = useState<ForecastPriceRow | null>(null);
  /** 팝업 조회조건 초기값 — 더블클릭 행의 셀 값(없으면 fallback). DMF0003 `rowValue` 1:1. */
  /**
   * 모달 선택 후 **파생 컬럼**을 채운다 — AS-IS `if (GetColumnIndex(col) > 0) SetText(...)` 1:1.
   *
   * ⚠ 종전 구현은 `'KEY' in target` 으로 걸렀는데, 신규 Insert 행 객체(`handleInsert` 의 newRow)는
   *   파생 컬럼 키를 아예 만들지 않으므로 **항상 false** 였다 → Model/Project 를 골라도 Nick Name·
   *   Project Name 등이 빈 채로 남았다. 판정 축은 "행 객체에 키가 있나"가 아니라
   *   **"그리드(=메타)에 그 컬럼이 있나"** 다.
   * ⚠ 행에 키가 늘어도 SAVE 는 오염되지 않는다 — `forecast-price.save.ts keyOf` 가 명시 키 목록만
   *   골라 보낸다(파생 컬럼은 표시용이라 목록에 없다).
   */
  const setDerivedCell = (target: WijmoRowItem, binding: string, value: string) => {
    if (gridRef.current?.columns.getColumn(binding)) target[binding] = value;
  };

  const popupCellValue = (key: string, fallback = 'ALL'): string => {
    const value = (popupRow as Record<string, unknown> | null)?.[key];
    if (value == null) return fallback;
    if (typeof value === 'string') return value.trim() || fallback;
    return typeof value === 'number' ? String(value) : fallback;
  };

  // ── Bucket 전환 가드 (AS-IS cboBucketType_Click :3361 — Insert 행 존재 시 MSG00227 차단) ── #13
  const handleBucketChange = (bucket: string) => {
    // 매 호출 시 gridRows(=spRows, 살아있는 grid.collectionView.sourceCollection)를 직접
    //   걸러 판정한다 — outer scope 에 캐시해 두면 addRowSet/removeRow 가 setState 를 안 불러
    //   이 핸들러의 클로저가 재정의(리렌더)되지 않는 한 값이 갱신되지 않는다(2026-09-17 리뷰 발견).
    if (gridRows.some(r => (r as unknown as WijmoRowItem)['CRUD_TYPE'] === 'I')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.BUCKET_CHANGE_BLOCK, '_Cannot change bucket while rows are inserted.'),
      });
      return;
    }
    setSearchParams({ bucketType: bucket });
  };

  // ── Delete (AS-IS DeleteButton — measure 4종 + 권한 검증 후 D 마킹 / I 행 즉시 제거) ──
  const handleDelete = async () => {
    const g = gridRef.current;
    if (!g) return;
    const item = g.rows[g.selection.row]?.dataItem as WijmoRowItem | undefined;
    if (!item) return;
    const crud = item['CRUD_TYPE'];
    if (crud === 'I') {
      // 행 객체 자체를 grid.collectionView 에서 없앤다(GridAction.removeRow 와 동일 방식).
      //   앵커 승계는 별도로 필요 없다 — pin 이 grid 인스턴스의 WeakMap 에 걸려 있어(React
      //   state 가 아니다) 삭제된 행 객체가 참조로 남아 있는 한, 그 행을 앵커로 삼았던 다른
      //   신규행의 pin.anchor 도 그대로 살아 있고, 다음 Insert/표시-정렬 재적용 때
      //   resolveInsertAnchor/getInsertAnchor 가 그 pin 을 타고 올라가 실제 앵커까지 자동으로
      //   재해석한다.
      g.editableCollectionView.remove(item as unknown as ForecastPriceRow);
      g.editableCollectionView.commitEdit();
      forceGridRerender(v => v + 1);
      return;
    }
    if (crud === 'D') {
      item['CRUD_TYPE'] = undefined; // 삭제 취소 (AS-IS 토글)
      g.invalidate();
      return;
    }
    const measure = String(item['MEASURE'] ?? '');
    if (!(AUTH_MEASURES as readonly string[]).includes(measure) || measureAuth[measure] === false) {
      await setAlert({
        type: 'alert',
        content: t(MSG.MEASURE_NOT_EDITABLE, '_Not editable measure.'),
      });
      return;
    }
    item['CRUD_TYPE'] = 'D';
    g.invalidate();
  };

  // ── Save (AS-IS SaveButton — 검증 → MSG00001 확인 → 17 IN '^' bulk → 재조회) ──
  const handleSave = async () => {
    const tracker = editTrackerRef.current;
    if (!tracker) return;
    const allRows = gridRows as unknown as WijmoRowItem[];

    // 필수: bucketType 은 셀 편집 판정과 같은 값을 넘긴다 — M+4 동결은 Monthly 한정이라
    //   (현업 검수 40번) 빠뜨리면 Weekly/Daily 는 입력은 되는데 저장에서 잘린다 (isM4Locked 주석 참조).
    const validationError = validateSaveRows(
      allRows,
      editableDayColumns,
      m3CutoffYyyymm,
      {
        wsPlannerYn,
        divisionId: searchParams.divisionId,
        wsFcstTypes: wsFcstTypeSet,
        asSiteNames: asSiteNameSet,
      },
      searchParams.bucketType
    );
    if (validationError === 'AS_FROM_SITE_REQUIRED') {
      // 고객향 사이트로 FcstType 을 AS/WS 로 등록할 때 AS FROM SITE 필수 (현업 요청 2026-07-31).
      await setAlert({
        type: 'alert',
        content: t(
          MSG.AS_FROM_SITE_REQUIRED,
          '_고객향 사이트로 Fcst Type을 AS 또는 WS로 등록하시는 경우 AS FROM SITE는 필수로 입력이 필요합니다.'
        ),
      });
      return;
    }
    if (validationError === 'PLANT_SITE_REQUIRED') {
      // 81 계열은 Plant Site 가 신규행 필수 키 컬럼 (현업 요청 2026-08-03 — 40·82 해당없음).
      await setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED, '_{0} is required.').replace('{0}', 'Plant Site'),
      });
      return;
    }
    if (validationError === 'CURRENCY_REQUIRED') {
      await setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED, '_{0} is required.').replace('{0}', 'Currency'),
      });
      return;
    }
    if (validationError === 'QTY_PRICE_REQUIRED') {
      await setAlert({ type: 'alert', content: t(MSG.QTY_PRICE_REQUIRED, '_Qty/Price required.') });
      return;
    }
    if (validationError === 'DUP_NEW_ROW') {
      await setAlert({ type: 'alert', content: t(MSG.DUP_NEW_ROW, '_Duplicated new row.') });
      return;
    }

    const saveRows = buildSaveRows(
      allRows,
      tracker,
      editableDayColumns,
      m3CutoffYyyymm,
      searchParams.bucketType
    );
    if (saveRows.length === 0) return;

    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '_Save?') });
    if (!confirmed) return;

    const userId = useSessionStore.getState().session.userId ?? '';
    setSaving(true);
    try {
      // '^' bulk payload — useProcMutation 의 array unfold 를 피해 call-proc 직접 (표준 패턴).
      const res = await apiClient.post<{
        o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string; ERR_EVENT?: string }[];
      }>(`/${MENU_ID}/FcstNPrice/SAVE/call-proc`, buildSavePayload(saveRows, userId));

      // HTTP/BE 레벨 실패 판정 — 필수: 아래 RESULT_CODE 가드보다 먼저 와야 한다.
      //   여기서 걸러내지 않으면 PKG 예외(ORA-01400 등)로 저장이 실패해도 '저장되었습니다' 가 뜬다
      //   (2026-07-30 실측). 원인 2단: ① responseErrorInterceptor 가 403/500 을 reject 하지 않고
      //   error.response 를 그대로 resolve 한다(axios-interceptors.ts L53~55) → await 가 throw 안 함.
      //   ② 그 에러 응답에는 result.o_rc1 자체가 없어 `result &&` 단축평가로 가드가 통과된다.
      //   Number(code) 진위 판정은 responseInterceptor 와 동일 관용구 (비수치 code=NaN 은 성공 취급).
      if (res.status >= 400 || Number(res.data?.code)) {
        await setAlert({
          type: 'alert',
          content: String(res.data?.message ?? '').trim() || t(MSG.DUP_SAVE_ERROR, '_Save error.'),
        });
        return;
      }

      const result = (res.data?.result?.o_rc1 ?? [])[0];
      if (result && String(result.RESULT_CODE ?? '') !== '0') {
        await setAlert({
          type: 'alert',
          content: String(result.RESULT_MSG ?? t(MSG.DUP_SAVE_ERROR, '_Save error.')),
        });
        return;
      }
      // [공통 C4 2026-08-11] 저장 완료 = 팝업 아닌 **토스트**(하단 중앙, 자동 소멸) — 통합테스트 1st
      //   Common "별도 팝업으로 Alert 하지 않고 하단 중앙 메시지 표기 후 사라지도록"(LGES WDG 표준).
      //   실패·검증 메시지는 종전대로 팝업 유지(사용자 확인 필요) — 완료 계열만 토스트.
      setToast({ type: 'success', message: t(MSG.SAVED, '_Saved.') });
      tracker.clearChanges();
      invalidateAfterSave();
    } finally {
      setSaving(false);
    }
  };

  const hotkeyConfig = {
    search: () => void handleSubmit(),
    manual: false as const, // Manual(F1) 버튼 미표시 (전체 삭제 방침 — 강민재)
    // 추가/삭제/저장 = 메뉴 버튼권한(hasButton SAVE — admin 에서 끄면 숨김) AND buttonAuth 시트 Y/N
    //   AND 편집 가능 버전. buttonAuth 는 화면 오픈·Division 변경 시 SP 가 내려주므로 조회 전에도 정해진다.
    //   SP 판정(P_DMF0082_GET_BUTTON_AUTH): SAVE/DELETE = 편집 가능 메저 존재 AND division<>82
    //   (DM Viewer 전 메저 N → 숨김, 82 조회 전용) / INSERT = SAVE AND MKT_FCST·LOC·VMI_In_Req 중 'Y'
    //   (SCP Planner 단독 = SCM_FCST 수정만 가능, 신규행 불가 — [E20260917-INSERTGATE] 규칙 그대로).
    //   과거(조회 전용) 버전은 전 행 EDIT_FLAG='N' → isEditableVersion=false → 세 버튼 숨김(미렌더).
    //   형제 화면처럼 hasButton('INSERT'/'DELETE') 로 가르지 않는 이유: 메인 시트에 그 버튼이 미등록이고
    //   버튼권한 API 가 서브시트(Price Batch 팝업 INSERT)를 합쳐 내려줘 항상 true 다(실측 2026-09-04).
    ...(hasButton('SAVE') && isEditableVersion && buttonAuth.save
      ? {
          insert: buttonAuth.insert ? handleInsert : (false as const),
          delete: buttonAuth.delete ? () => void handleDelete() : (false as const),
          save: () => void handleSave(),
        }
      : { insert: false as const, delete: false as const, save: false as const }),
    // Excel 업로드 — 표준 슬롯은 customButtons **뒤**에 렌더되므로 사용 안 함.
    //   [2026-08-12 사용자 지시] 버튼 순서 = Excel Form → Excel Upload → Price Batch Input →
    //   환율 → Grid → 메저. Excel Upload 는 customButtons 2번째로 이동(아래).
    upload: false as const,
  };

  // AS-IS 커스텀 4버튼 — icon-only (mkt-fcst/DMF0020 표준: buttonLabel='' + iconComponent,
  //   label/title=Tooltip). ⚠️ LBL 실측 대사 완료 — LBL00661/00712/00605 (직전 LBL00741/752/753 은
  //   View PR/MKT FCST 미등록 제외/Include Internal Txn 오매핑 사고 → 교정 2026-07-12).
  const customButtons = [
    // ⭐ Excel Form(템플릿 다운로드 모달) — division 81 계열 전용 노출 [E20260819-XLS81LOC] (metal-link 'Excel Form' 이식).
    //   81 계열 판정은 buttonAuth 시트 EXCEL_FORM_YN (SP 가 division LIKE '81%' 로 산출).
    ...(buttonAuth.excelForm && hasButton('FORM_DATA')
      ? [
          {
            // SubTitle 이 buttonLabel={label} 기본 적용 → 아이콘 + 'Excel Form' 텍스트 (metal-link 동일 shape)
            label: t('LBL00762', 'Excel Form'),
            action: () => setTemplateModalOpen(true),
            iconComponent: <FileExceldownloadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
    // ⭐ Excel Upload — [2026-08-12 사용자 지시] Excel Form 다음(2번째). division 81 계열 전용 [E20260819-XLS81LOC].
    ...(buttonAuth.excelUpload && hasButton('UPLOAD')
      ? [
          {
            label: t('LBL00346', 'Excel Upload'),
            action: () => setUploadModalOpen(true),
            iconComponent: <FileExceluploadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
    // [UICATEGORY 2026-08-07] div 82 = 조회 전용 — Price Batch Input(기간 일괄 저장 진입점)도 숨김 (사용자 지정)
    // [E20260826-AUTHVIEW] + 판가 편집권한(LOC='Y') 보유 시에만 — SCP Planner(판가 불가)·DM Viewer(전면 불가)
    //   숨김 (사용자 지시 2026-08-26). 두 조건 모두 buttonAuth 시트 PRICE_BATCH_YN (= LOC 'Y' AND division<>82).
    ...(buttonAuth.priceBatch
      ? [
          {
            // 명칭 = DMF0020 과 동일 'Price Batch Input' (LBL00662, 2026-07-12 요청)
            label: t('LBL00662', 'Price Batch Input'),
            title: t('LBL00662', 'Price Batch Input'),
            action: () => {
              // AS-IS V15: 수정모드(변경 존재) 시 차단 (MSG00680 pending 차단) 후 SavePricePeriodModal open
              const changed = editTrackerRef.current?.getOriginalValues();
              if (changed && changed.size > 0) {
                void setAlert({
                  type: 'alert',
                  content: t(
                    MSG.EDIT_MODE_NO_INPUT,
                    '_변경 중인 데이터가 있어 수행할 수 없습니다. 저장 또는 취소 후 다시 시도해 주세요.'
                  ),
                });
                return;
              }
              setSavePriceModalOpen(true);
            },
            buttonLabel: t('LBL00662', 'Price Batch Input'),
          },
        ]
      : []),
    // ⭐ 아이콘 버튼 표준 순서 = **환율 → 컬럼설정 → 메저** (hook #120, 2026-08-10 사용자 재확정).
    //   전 화면 동일 순서 — DMF0082/0044/0042/0049/0020 일괄 정렬.
    {
      label: t('LBL00661', 'Exchange Rate'),
      title: t('LBL00661', 'Exchange Rate'),
      // 편집모드(미저장 변경분 존재) 시 진입 차단 — AS-IS "Edit Mode 에서는 수행할 수 없습니다".
      //   Price Batch Input 과 동일 가드 패턴(editTracker 변경분 검사).
      action: () => {
        const changed = editTrackerRef.current?.getOriginalValues();
        if (changed && changed.size > 0) {
          void setAlert({
            type: 'alert',
            content: t(
              MSG.EDIT_MODE_NO_ACTION,
              '_변경 중인 데이터가 있어 수행할 수 없습니다. 저장 또는 취소 후 다시 시도해 주세요.'
            ),
          });
          return;
        }
        setExchangeModalOpen(true);
      },
      iconComponent: <IcExchangeRate />,
      buttonLabel: '',
    },
    {
      label: t('LBL00605', 'Column Setting'),
      title: t('LBL00605', 'Column Setting'),
      action: () => setColumnModalOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
    {
      label: t('LBL00310', '_Measure'),
      title: t('LBL00310', '_Measure'),
      action: () => setMeasureModalOpen(true),
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
      <ForecastPriceForm
        onSubmit={() => {
          void handleSubmit();
        }}
        onOpenVersionLookup={() => setVersionModalOpen(true)}
        onBucketChange={handleBucketChange}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={gridRows.length}
        excelFileName='FcstPrice'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />
      <ForecastPriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={gridRows}
        spreadTitle={spreadTitle}
        editTrackerRef={editTrackerRef}
        onPopupCellDblClick={(modalKey, row) => {
          if (modalKey !== 'PROJECT' && modalKey !== 'ITEM') return;
          setPopupRow(row as unknown as ForecastPriceRow);
          if (modalKey === 'ITEM') setOpenItem(true);
          else setOpenProject(true);
        }}
      />

      {/* ⭐ [2026-08-22] Model(ITEM_ID) 셀 검색 모달 — AS-IS 파리티 복원.
          AS-IS `DMF0082_FcstNPrice_Mgmt.cs`
            · L404-407 : `TextCellType` + `BackgroundImage(ImagePopUp)` = 타이핑 O · 돋보기 O
            · L2541    : `InsertRow()` 가 division 40 신규행 셀에 그 셀타입을 부착
            · L3772    : `spdMain_CellDoubleClick` 에서 `DM0002_ItembyDivisionPopupEx` 호출 후
                         ITEM_ID / ITEM_NAME / NICK_NAME 동반 세팅
          TO-BE 는 모달 배선이 통째로 빠져 있어 Model 을 **모달로 고를 수 없었다**.
          정본 = DMF0003 `MktFcst.tsx` ItemByDivisionModal 배선 1:1. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(
          itemId: string,
          itemName?: string,
          _itemType?: string,
          nickName?: string
        ) => {
          const target = popupRow as unknown as WijmoRowItem | null;
          if (target) {
            target['ITEM_ID'] = itemId;
            // AS-IS 는 Model 선택 시 ITEM_NAME / ITEM_TYPE / NICK_NAME 을 함께 채운다
            //   (`.cs:3817-3823` — 각각 그리드에 컬럼이 있을 때만).
            setDerivedCell(target, 'ITEM_NAME', itemName ?? '');
            setDerivedCell(target, 'NICK_NAME', nickName ?? '');
            // ⛔ ITEM_TYPE 은 채우지 않는다 — DMF0082 의 ITEM_TYPE 은 `FPComboBox`(콤보 `ItemType`)
            //   즉 **코드** 컬럼인데, 이 모달이 넘겨 주는 3번째 인자는 `ITEM_CLASS_NAME`(명칭)이다
            //   (`ItemByDivisionModal.tsx:285-291`). 명칭을 코드 컬럼에 넣으면 콤보가 값을 못 찾아
            //   빈 칸으로 보인다. 모달이 ITEM_TYPE 코드를 노출하도록 넓힌 뒤 채울 것.
            gridRef.current?.invalidate();
          }
          setOpenItem(false);
          setPopupRow(null);
        }}
        preSearchParams={
          {
            // ⚠ 값이 없을 때 **'ALL' 로 넘겨야 한다** — 빈 문자('')를 넘기면 조회 SP 가 0행을 준다.
            //   실측: `P_DMF0002_GET_ITEM_BY_DIVISION_POPUPEX` div40 → ALL 23,360행 / '' 0행
            //   (deptId·endCustomer·salesSite 각각 단독으로 ''만 돼도 전멸).
            //   모달의 `preSearchParams.deptId ?? 'ALL'` 는 `??` 라 null/undefined 만 걸러 ''는 통과시킨다.
            //   신규 Insert 행은 `handleInsert` 가 DEPT_ID 를 만들지 않아 항상 undefined→'' 였다.
            //   ⇒ 아래 `popupCellValue`(기본값 'ALL')로 통일 — 바로 밑 Project 모달과 같은 규약.
            divisionId: popupCellValue('DIVISION_ID', searchParams.divisionId),
            deptId: popupCellValue('DEPT_ID'),
            endCustomer: popupCellValue('END_CUSTOMER'),
            salesSite: popupCellValue('SCM_SITE_ID'),
            // project 는 AS-IS 가 Item 팝업에 빈값을 넘긴다(`.cs:3785` `sProject = "";`) — 'ALL' 금지.
            projectCode: popupCellValue('PROJECT_CODE', ''),
            // ⭐ 현재 셀의 Model 을 팝업에 넘긴다 — Project 모달과 동일 거동.
            //   AS-IS 는 더블클릭한 행의 ITEM_ID 를 읽어 팝업 인자로 넘긴다
            //   (`DMF0082_FcstNPrice_Mgmt.cs:3786` → `Form_Load(…, sProject, sItemId, …)`).
            //   모달은 이 값을 Model 입력칸 + 목록 필터에 실소비한다
            //   (`ItemByDivisionModal.tsx:309-310`). 빈값이면 조건 없이 전량이 열린다.
            itemId: popupCellValue('ITEM_ID', ''),
          } as never
        }
        callFromCell={true}
      />

      {/* ⭐ [No.65 2026-08-14] Project 셀 검색 모달 — 81 계열 신규행의 PROJECT_CODE 입력 경로.
          메타가 FPModal 이라 공용 DataGrid 가 직접 편집을 취소하므로, 이 모달이 없으면 Project 를
          넣을 방법이 아예 없었다(통합테스트 1st No.65 "Project 컬럼 자체가 없음").
          정본 = DMF0003 `MktFcst.tsx` 셀 팝업 배선 1:1. */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName, projectStatus, _bizTypeName, projectOwner) => {
          const target = popupRow as unknown as WijmoRowItem | null;
          if (target) {
            target['PROJECT_CODE'] = projectCode;
            // AS-IS 는 Project 선택 시 PROJECT_NAME / PROJECT_STATUS / BIZ_TYPE / PROJECT_OWNER 를
            //   함께 채운다(`.cs:3751-3769` — 각각 그리드에 컬럼이 있을 때만).
            setDerivedCell(target, 'PROJECT_NAME', projectName ?? '');
            setDerivedCell(target, 'PROJECT_STATUS', projectStatus ?? '');
            setDerivedCell(target, 'PROJECT_OWNER', projectOwner ?? '');
            // ⛔ BIZ_TYPE 은 채우지 않는다 — DMF0082 의 BIZ_TYPE 은 `FPComboBox`(콤보 `BizType`)
            //   즉 **코드** 컬럼이고, AS-IS 도 `popProject.BizType`(=BIZ_TYPE **코드**)을 넣는다
            //   (`SCM0002_ProjectbyDivisionPopupEx.cs:68`). 그런데 이 모달은 4번째 인자로
            //   `BIZ_TYPE_NAME`(명칭)을 넘긴다(`ProjectByDivisionModal.tsx:161`).
            //   명칭을 코드 컬럼에 넣으면 콤보가 값을 못 찾아 빈 칸이 된다 — 모달이 코드를 함께
            //   노출하도록 넓힌 뒤 채울 것.
            gridRef.current?.invalidate();
          }
          setOpenProject(false);
          setPopupRow(null);
        }}
        // 셀 호출 — 더블클릭한 행의 값으로 팝업 조회조건을 미리 채운다 (DMF0003 `rowValue` 규약 1:1).
        preSearchParams={
          {
            divisionId: popupCellValue('DIVISION_ID', searchParams.divisionId),
            deptId: popupCellValue('DEPT_ID'),
            endCustomer: popupCellValue('END_CUSTOMER'),
            salesSite: popupCellValue('SCM_SITE_ID'),
            projectCode: popupCellValue('PROJECT_CODE', ''),
            etc: 'N',
          } as never
        }
        callFromCell={true}
      />

      {/* Version 선택 (AS-IS SCM0002_VersionByWaterfallPopup — DMF0073 공유 계약) */}
      <VersionSelectModal
        open={versionModalOpen}
        modalClose={() => setVersionModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        onApply={versionIds => setSearchParams({ versionType: versionIds })}
      />

      {/* Measure 설정 (AS-IS btnMeasure — titleSet 'M' 영구 저장 → 재조회).
          공용 팝업 사용 (2026-08-12 전환 — 로컬 복사본 제거, sales-monitoring/DMF0048 과 동일 컴포넌트).
          visibleMeasures={null} 유지: 표시 상태는 저장 후 재fetch 한 display 로만 복원한다.
          [2026-08-26 사용자 확정] DMF0003(MktFcst) 사용형이 정본 — showMeasureCode(Measure Code
          컬럼 노출, 구 통합테스트 1st No.40 요구) 제거 = No.40 역전. 화면별 옵션 변형 ⛔ (hook #132). */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            fetchStaticMeasures();
            invalidateAfterSave();
          });
        }}
      />

      {/* Column 설정 (AS-IS btnColumn — 공용 ColumnLayoutModal + titleSet 'C') */}
      <ColumnLayoutModal
        open={columnModalOpen}
        modalClose={() => setColumnModalOpen(false)}
        menuId={MENU_ID}
        sheetName={TITLESET_SHEET}
        // ⭐ 'C' = 컬럼 개인화 (saveTitleSet 이 저장 시 쓰는 값과 반드시 동일해야 한다).
        //   TITLESET_SHEET 를 넘기면 저장('C')과 조회('FcstNPrice')가 다른 키를 봐서 저장 결과가
        //   재진입 시 사라진다(2026-07-27 실측). MktFcst/SalesMonitoring/ContributeView 도 'C'.
        columnType='C'
        divisionId={searchParams.divisionId}
        leftTitle={t('LBL00764', 'Invisible')}
        rightTitle={t('LBL00765', 'Visible')}
        // 재진입 복원 — staticColumns 는 fetchUserColumnKeys/applyColumnLayout 로 개인화가 반영된 상태다.
        initialSettings={columnLayoutSettings}
        defaultSettings={columnLayoutDefaults}
        onSave={settings => {
          // ⭐ 로컬 즉시 반영 — BE 재조회로는 개인화가 돌아오지 않으므로 grid 반영은 store 가 담당한다
          //   (mkt-fcst/sales-monitoring 선례 동일). 서버 저장은 다음 진입 때의 복원용.
          applyColumnLayout(
            settings.map(s => ({
              colNm: s.COLUMN_NAME,
              visible: s.USER_FLAG === 'Y',
              width: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
              order: s.SORT_ORDER_NO,
            }))
          );
          // titleSet 'C' 영구 저장 — 표시 column + 순서 + 폭/색 (BE 3컬럼 확장분 2026-07-27).
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet(
            'C',
            visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            }))
          ).then(ok => {
            // 실패를 조용히 삼키면 '저장했는데 재진입 시 원복' 과 구분이 안 된다 — 반드시 알린다.
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_Save error.') });
              return;
            }
            invalidateAfterSave();
          });
          // [공통 C3 2026-08-11] 컬럼 추가/제외 적용 시 기존 조회 데이터가 있으면 Reset — 통합테스트
          //   1st Common "기존에 조회된 데이터가 있을 경우 Reset 후 재조회 할 수 있도록 수정".
          //   Division 변경 가드와 동일 3종 reset — 그리드 공백 후 Search 로 재조회.
          if (filters !== undefined) {
            editTrackerRef.current?.clearChanges();
            clearFilters();
          }
        }}
      />

      {/* Exchange Rate (AS-IS btnExchangeRate — DMF0082_POPUP_GET_FUTUREPRICE_INFO) */}
      <ExchangeRateModal
        open={exchangeModalOpen}
        modalClose={() => setExchangeModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
      />

      {/* Save Price Period (AS-IS btnSavePricePeriod — DMF0082_SaveSalesFuturePrice_Popup 1:1) */}
      <SavePricePeriodModal
        open={savePriceModalOpen}
        modalClose={() => setSavePriceModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        defaultEndCustomers={searchParams.endCustomers}
        defaultSalesSites={searchParams.salesSites}
        onSaveResult={() => invalidateAfterSave()}
      />

      {/* Excel Form (템플릿 다운로드 모달) — division 81 계열 전용 [E20260819-XLS81LOC].
          SP 가 LOC measure 만 산출 + 81 외 division 은 CODE '1' MSG01014 가드. */}
      <ForecastTemplateModal
        open={templateModalOpen}
        modalClose={() => setTemplateModalOpen(false)}
        divisionId={searchParams.divisionId}
        filters={filters as Record<string, unknown> | undefined}
      />

      {/* Excel Upload (AS-IS DMF0082_EXCEL_UPLOAD — 2-Step: Upload=검증분류 / OK=저장 mode=1.
          공용 FcstUploadModal(demand) + EXCEL_COLUMNS SHEET_NAME='FcstNPrice' 기이관 실측) */}
      {/* 저장 진행 오버레이 (사용자 요구 2026-08-22) — 저장 중 화면 스피너. */}
      <ProgressIndicator shape='circular' placement='parent' open={saving} />

      <FcstUploadModal
        open={uploadModalOpen}
        modalClose={() => setUploadModalOpen(false)}
        menuId={MENU_ID}
        sheetName={UPLOAD_SHEET}
        attributeHeaders={[...UPLOAD_HEADERS]}
        onSave={saveExcelUpload}
        onUploaded={() => invalidateAfterSave()}
      />
    </>
  );
};
