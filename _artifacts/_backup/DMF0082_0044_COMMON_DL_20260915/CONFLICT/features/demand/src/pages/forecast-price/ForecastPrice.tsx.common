import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { Point } from '@mescius/wijmo';
import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ItemByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { pinInsertedRow, type EditTracker } from '@foundation/utils';
// ⭐ [2026-08-20 정본 단일화] Grid Column Setting 모달 = @shared/components 표준 정본 직행
//   (packages/shared/.../templates/modals/column-layout-modal — hook #132 §Column 모달 정본)
import { ColumnLayoutModal, MainTitle, SubTitle, toColumnLayoutSettings } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useDirtyReset, useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import {
  compareForecastRows,
  findGroupTopIndex,
  groupKeyBindings,
  type GroupKeyColumn,
} from './components/ForecastPriceGridUtils';
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

/**
 * 저장 전 신규행 1건 — 그리드 표시 위치를 결정하는 앵커를 함께 보관한다.
 *   anchor = Insert 를 누른 시점의 선택 셀이 속한 **머지 블록의 첫 행** 객체 참조.
 *   null = 선택 없이 Insert (그리드 맨 위에 놓는다).
 * 배열 순서 = 누른 순서. 같은 앵커에 여러 건이 걸리면 누른 순서대로 위에서 아래로 쌓인다.
 */
interface PendingInsert {
  row: ForecastPriceRow;
  anchor: ForecastPriceRow | null;
}

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
  const [insertedRows, setInsertedRows] = useState<PendingInsert[]>([]);
  // Insert 직후 포커스를 옮길 신규행 — gridRows 재계산 후 effect 가 소비하고 비운다.
  // 저장 진행 오버레이 — '^' bulk 저장은 react-query 밖이라 전역 스피너가 뜨지 않는다
  //   (정본 SalesReports.tsx:133·493 동일 패턴). 화면 스피너로 진행 중임을 알린다.
  const [saving, setSaving] = useState(false);
  const focusRowRef = useRef<ForecastPriceRow | null>(null);
  // Insert 직전 선택돼 있던 컬럼 — handleInsert 시점(= itemsSource 교체 전)에 캡처해 둔다.
  //   포커스 복원 effect 에서 그 시점의 grid.selection.col 을 실시간으로 읽으면, itemsSource
  //   가 이미 바뀌어 wijmo 가 selection 을 초기화한 뒤라 항상 0(맨 왼쪽 No 컬럼)이 된다.
  const focusColRef = useRef<number>(0);
  // Insert 직전 스크롤 위치 — 같은 이유로 캡처해 둔다. itemsSource 교체가 스크롤을 맨 위로
  //   되돌리는데, 그 상태에서 바로 scrollIntoView 하면 신규행이 뷰포트 최상단에 붙어 화면이
  //   방금 보던 위치에서 뚝 떨어진 것처럼 튄다. 복원해 두면 이미 보이는 범위면 아예 안 움직이고,
  //   범위 밖이면 거기서부터 최소한만 스크롤한다.
  const focusScrollRef = useRef<Point | null>(null);

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
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const originalStaticColumns = useForecastPriceStore(state => state.originalStaticColumns);
  const staticMeasures = useForecastPriceStore(state => state.staticMeasures);
  const fetchUserColumnLayout = useForecastPriceStore(state => state.fetchUserColumnLayout);
  const applyColumnLayout = useForecastPriceStore(state => state.applyColumnLayout);
  const authGroup = useForecastPriceStore(state => state.authGroup);
  const setAuthGroup = useForecastPriceStore(state => state.setAuthGroup);
  const setWsPlannerYn = useForecastPriceStore(state => state.setWsPlannerYn);

  // 이탈 가드(조회·탭 닫기·팝업 닫기) 확인 시 화면이 들고 있는 신규행 state 도 함께 버린다.
  //   그리드 되돌리기는 DataGrid 가 자동 등록하지만, 그것은 itemsSource 배열에서 'I' 행을 지울 뿐이라
  //   insertedRows 가 살아 있으면 다음 렌더의 gridRows useMemo 가 버린 행을 그대로 되살린다.
  useDirtyReset(() => setInsertedRows([]));

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
    setInsertedRows([]); // 신규(CRUD_TYPE='I') 행 reset
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

  // AS FROM SITE 필수 검증(V0) 입력 2종 (현업 요청 2026-07-31 — mkt-fcst MktFcst.tsx L497~525 규칙).
  //   · FcstTypeWs   = W/S·A/S 4종(SALES_TYPE_CODE2) — 이 FcstType 일 때만 필수 대상.
  //   · AS_FROM_SITE = 비축(AS)향 사이트 목록(NAME=사이트) — 여기에 없는 사이트가 '고객향'.
  //   그리드도 같은 콤보를 쓰지만 useTabComboQueries 가 동일 키를 캐시 공유하므로 중복 호출이 아니다.
  const wsPlannerYn = useForecastPriceStore(state => state.wsPlannerYn);
  const [wsFcstTypeWsCombo, asFromSiteCombo] = useTabComboQueries({
    filters: ['FcstTypeWs', { comboId: 'AS_FROM_SITE', param1: `'${searchParams.divisionId}'` }],
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
    setInsertedRows([]); // 재조회 = pending insert reset (hook #97)
    editTrackerRef.current?.clearChanges();
  }, [data, setMeasureAuth, setM3Cutoff, setCalendar]);

  const spreadTitle = useMemo(
    () => ((titleData as unknown as Record<string, unknown[]>)?.data ?? []) as SpreadTitleRow[],
    [titleData]
  );

  // 조회행 + 신규행 병합 — 신규행은 앵커(=선택 셀이 속한 머지 블록의 첫 행) **바로 위**에 놓는다.
  //   앵커가 사라진 경우(재조회로 객체 참조 교체 등)는 맨 위로 폴백 — 행이 증발하지 않게 한다.
  const gridRows = useMemo(() => {
    const baseRows = data?.fcstNPrice ?? [];
    // [ENDCUSTDISP] 표시/키 분리 — 행 객체 **제자리** 변환(참조 유지 필수: editTracker·insert 앵커가
    //   행 참조를 쥔다. 새 객체로 map 하면 앵커/변경추적이 전부 끊긴다). 멱등: END_CUSTOMER_KEY
    //   보유 행은 재변환하지 않는다. 맵 미도착 시 원값 유지 — 도착하면 siteEcVersion 이 재실행시킨다.
    if (siteEcMapRef.current.size > 0) {
      // 값 타입은 WijmoRowItem(WijmoPrimitive) — Record<string, unknown> 로 두면 String(row.X)
      //   가 no-base-to-string 에 걸린다.
      for (const row of baseRows as unknown as WijmoRowItem[]) {
        if ('END_CUSTOMER_KEY' in row) continue;
        const disp = siteEcMapRef.current.get(String(row.SCM_SITE_ID ?? ''));
        if (disp === undefined) continue;
        row.END_CUSTOMER_KEY = row.END_CUSTOMER ?? '';
        row.END_CUSTOMER = disp;
      }
    }
    // [E20260826-DISPSORT] 행 정렬 = **표시값** 기준 (사용자 신고 2026-08-26: Audi→VW 일부→BMW).
    //   SP 정렬 키는 원장 END_CUSTOMER(비40=프로젝트 코드)인데 표시값은 위에서 사이트 파생 고객명으로
    //   교체(ENDCUSTDISP)되므로 표시 기준으로 어긋나 보인다. 표시 컬럼(staticColumns 개인화 순서)
    //   순으로 재정렬한다 — 얕은 복사 정렬(행 참조 보존: editTracker·insert 앵커 무손상).
    // [DISPSORT-MEASURE 2026-09-04] 같은 키 그룹 안 메저 순서 = Measure 설정 팝업 순서(staticMeasures =
    //   titleSet 'M' 개인화 반영)를 따른다. 조회 SP 의 메저 SORT_KEY 는 팝업 개인화와 무관하고,
    //   sortCols 에 든 MEASURE 를 문자열 비교하면 메저 코드 알파벳순으로 어긋난다 → compareForecastRows
    //   가 MEASURE 를 제네릭 비교에서 빼고 measureOrder 로만 정렬한다(사용자 신고: 그리드 메저 순서가
    //   팝업과 다름). staticMeasures 미도착 시 맵이 비어 SP 원 순서 보존(로딩 중 튐 방지).
    const sortCols = staticColumns
      .filter(c => c.visible !== false && !!c.colNm && c.colNm !== 'NO')
      .map(c => c.colNm);
    const measureOrder = new Map<string, number>(staticMeasures.map((m, i) => [m.colNm, i]));
    const displaySorted = ([...baseRows] as unknown as WijmoRowItem[]).sort((a, b) =>
      compareForecastRows(a, b, sortCols, measureOrder)
    ) as unknown as ForecastPriceRow[];
    if (insertedRows.length === 0) return displaySorted;

    const knownRows = new Set<ForecastPriceRow>(baseRows);
    insertedRows.forEach(pending => knownRows.add(pending.row));

    // 앵커 → 그 위에 놓을 신규행 목록(누른 순서 유지). 앵커 없는/유실된 건은 orphanRows.
    const rowsByAnchor = new Map<ForecastPriceRow, ForecastPriceRow[]>();
    const orphanRows: ForecastPriceRow[] = [];
    insertedRows.forEach(({ row, anchor }) => {
      if (!anchor || !knownRows.has(anchor)) {
        orphanRows.push(row);
        return;
      }
      const bucket = rowsByAnchor.get(anchor);
      if (bucket) bucket.push(row);
      else rowsByAnchor.set(anchor, [row]);
    });

    // 앵커가 신규행인 경우(추가한 행을 다시 찍고 Insert)까지 재귀로 펼친다.
    const merged: ForecastPriceRow[] = [];
    const emit = (target: ForecastPriceRow) => {
      rowsByAnchor.get(target)?.forEach(emit);
      merged.push(target);
    };
    orphanRows.forEach(emit);
    displaySorted.forEach(emit); // [E20260826-DISPSORT] 신규행 병합도 표시 정렬 순서 기준
    return merged;
    // siteEcVersion — [ENDCUSTDISP] 맵 도착 시 표시 변환 재실행 트리거 (맵 자체는 ref).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [insertedRows, data, siteEcVersion, staticColumns, staticMeasures]);

  // Insert 직후 새 행으로 포커스·스크롤 이동.
  //   필수: 실패 시 **다음 프레임에 한 번 더** 시도한다. itemsSource 가 바뀌면 wijmo 는 스크롤을
  //   0 으로 되돌리는데, 이 시점에 grid.rows 가 아직 새 배열을 반영하지 않았으면 findIndex 가 -1 이라
  //   그대로 빠져나가 화면이 맨 위에 머문다 — 사용자는 중간에 생긴 신규행을 찾아 스크롤하게 된다
  //   (2026-08-17 리포트). 재시도 후에도 못 찾으면 조용히 포기(다음 Insert 에 영향 없음).
  useEffect(() => {
    const target = focusRowRef.current;
    if (!target) return;
    const grid = gridRef.current;
    if (!grid) return;
    let settleFrame = 0;
    // 상단 여백 제거 (사용자 신고 2026-09-04: "3번째 행 클릭 후 행추가 시 위에 여백이 생김").
    //   Insert 시 자식 그리드(ForecastPriceGrid)의 collectionView.refresh() 가 디바운스된 wijmo
    //   invalidate(약 10ms 뒤 refresh)를 예약한다. 그 relayout 이 아래 focusTarget 의 scrollIntoView
    //   보다 늦게 돌면, 앞서 맞춘 스크롤 translate 가 새 레이아웃과 어긋나 헤더 아래 빈 띠로 남는다
    //   (병합이 아니라 스크롤 잔상 — 여백이 병합 없는 수량 컬럼까지 전 폭으로 뜬다). 디바운스가 끝난
    //   뒤 relayout(refresh(true), 스크롤 위치는 보존)+재스크롤로 정렬을 다시 맞춘다.
    const settle = () => {
      const g = gridRef.current;
      if (!g || g.columns.length === 0) return;
      const rowIndex = g.rows.findIndex(r => r.dataItem === target);
      if (rowIndex < 0) return;
      g.refresh(true);
      g.scrollIntoView(rowIndex, -1);
    };
    const scheduleSettle = () => {
      // 디바운스 invalidate(10ms) 이후에 돌도록 2 프레임(약 32ms) 뒤 보정.
      settleFrame = requestAnimationFrame(() => {
        settleFrame = requestAnimationFrame(settle);
      });
    };
    const focusTarget = (): boolean => {
      const rowIndex = grid.rows.findIndex(r => r.dataItem === target);
      if (rowIndex < 0) return false;
      // itemsSource 교체로 리셋된 스크롤을 Insert 이전 위치로 먼저 되돌린다 — 이미 보이는
      //   범위면 scrollIntoView 가 아무 것도 안 움직인다(맨 위에 붙어 튀는 현상 방지).
      if (focusScrollRef.current) grid.scrollPosition = focusScrollRef.current;
      grid.select(rowIndex, focusColRef.current);
      grid.scrollIntoView(rowIndex, -1);
      return true;
    };
    if (focusTarget()) {
      focusRowRef.current = null;
      scheduleSettle();
      return () => cancelAnimationFrame(settleFrame);
    }
    // ⭐ [2026-08-22] 재시도를 **여러 프레임**으로 늘린다 (사용자 신고: "INSERT 한 ROW 로 FOCUS 가
    //   이동하지 않아서 INSERT 된 ROW 을 찾아야 합니다").
    //   필터가 걸린 상태의 Insert 는 신규행이 곧바로 `grid.rows` 에 나타나지 않는다 —
    //   ①필터 복원(apply) → ②예외집합 등록(keepRowVisibleUnderFilter) → ③collectionView.refresh()
    //   → ④wijmo 레이아웃 재계산 순서라, 1프레임 재시도로는 ③~④ 사이에서 놓칠 수 있다.
    //   찾으면 즉시 중단하고, 못 찾으면 조용히 포기한다(다음 Insert 에 영향 없음).
    let frame = 0;
    let tries = 0;
    const retry = () => {
      if (focusTarget()) {
        focusRowRef.current = null;
        scheduleSettle();
        return;
      }
      if (++tries >= 10) return; // 약 10프레임(≈160ms) — 그 이상은 행이 없다고 본다
      frame = requestAnimationFrame(retry);
    };
    frame = requestAnimationFrame(retry);
    return () => {
      cancelAnimationFrame(frame);
      cancelAnimationFrame(settleFrame);
    };
  }, [gridRows]);

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

  // Excel Form / Excel Upload 버튼 노출 게이트 — ⭐ division 81 계열 전용 (2026-08-19 사용자 지시 — 구 40 전용 역전).
  //   근거: PKG_DMF0082 [E20260819-XLS81LOC] — Upload 검증절 'Invalid Division(81 Only)' + Form 진입 가드(MSG01014) 실측.
  //   대상 measure 도 LOC(Unit Price) 한정 — SP 가 템플릿 산출·업로드 검증에서 LOC 외 제외/오류 분류(서버 권위).
  //   Sender Code disabled 관례(startsWith('81'))와 동일 판정식.
  const isExcelDiv = searchParams.divisionId.startsWith('81');
  // [UICATEGORY 2026-08-07] Division 82 = 조회 전용 (사용자 확정) — Insert/Delete/Save 버튼 차단.
  //   서버 권위 = PKG EDIT_FLAG='N' 일괄 + SAVE V82-00 가드. FE 는 UX 게이트(진입점 원천 차단).
  const isDiv82 = searchParams.divisionId === '82';

  // ── Search (AS-IS FindButton — V1~V4 검증 후 조회) ──
  //   [공통 C2 2026-08-14 정정] 수정 중 재조회 가드(MSG 확인 팝업)는 여기서 하지 않는다.
  //   조회 진입점 두 곳(SearchArea 조회 버튼 · SubTitle F5)이 이미 공통 가드
  //   confirmIfDirtyKey(..., 'search') 로 감싸 confirm + 편집분 되돌리기까지 수행한다.
  //   화면이 같은 검사를 한 번 더 하면 팝업이 2연속으로 뜬다 — 공통 가드가 확인 직후
  //   discardDirtyKey 로 그리드만 되돌리고 화면 state(insertedRows)는 남기기 때문에
  //   여기 검사가 다시 걸렸다(2번째 팝업은 MSG00703 = 닫기 문구라 "이 화면을 닫으시겠습니까?" 로 떴다).
  //   화면 state 정리는 아래 useDirtyReset 등록이 담당한다.
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
   * 선택한 셀이 속한 머지 블록의 첫 행 — Insert 앵커.
   *
   * 판정 입력은 **그리드가 실제로 그리고 있는 것**에서 뽑는다: 표시 순서(개인화로 바뀐다) ·
   * 표시 여부 · 필터/정렬이 반영된 행 순서(`g.rows`). 조회 응답 배열(gridRows)이 아니다 —
   * 사용자가 본 화면상의 블록과 어긋나면 안 된다.
   *
   * 범위 축 = **선택한 컬럼(`g.selection.col`)** — 사용자 요구 "선택한 값의 병합한 데이터 위로"
   *   (2026-08-17). Sales Site 셀은 그 안의 여러 Model 블록을, Model 셀은 그 안의 Incoterms 블록을,
   *   Incoterms 셀은 measure 블록만 덮는다. 축은 `groupKeyBindings` 에 **인덱스 그대로** 넘긴다
   *   (binding 이름 역탐색 금지 — 그 방식이 2026-08-17 Sales Site 미동작의 원인이었다).
   *
   * 값이 빈 셀은 wijmo 가 아예 병합하지 않으므로(mergeManager `isEmptyCellValue`) 축에서 빼고
   *   data Group(measure 블록) 기준으로 떨어뜨린다.
   *
   * 금지: wijmo 컬렉션(`g.columns`/`g.rows`)에 `.map`/`.filter` 를 쓰지 말 것 — Array 상속이라
   *   species 규약(`new ObservableArray(length)`)으로 새 ObservableArray 를 만들며 결과가 깨진다.
   *   실제로 이 때문에 앵커 계산이 통째로 무력화돼 "포커스 행 바로 위"로 떨어졌다(2026-08-17).
   *   인덱스 루프로 순수 배열에 복사한 뒤 다룬다.
   */
  const groupTopRowOf = (index: number): ForecastPriceRow | undefined => {
    const g = gridRef.current;
    if (!g || index < 0) return undefined;

    const columns: GroupKeyColumn[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const column = g.columns[i];
      // visible 미지정(undefined)은 표시로 본다 — 잘못 빼면 축이 통째로 폴백된다.
      columns.push({ binding: column?.binding ?? '', visible: column?.visible !== false });
    }
    const rows: (WijmoRowItem | undefined)[] = [];
    for (let i = 0; i < g.rows.length; i++) {
      rows.push(g.rows[i]?.dataItem as WijmoRowItem | undefined);
    }

    const clickedIndex = g.selection.col;
    const clickedBinding = columns[clickedIndex]?.binding ?? '';
    const clickedValue = clickedBinding ? rows[index]?.[clickedBinding] : undefined;
    const isEmptyCell =
      clickedValue === null || clickedValue === undefined || String(clickedValue).trim() === '';

    const keyBindings = groupKeyBindings(columns, isEmptyCell ? -1 : clickedIndex);
    return g.rows[findGroupTopIndex(rows, index, keyBindings)]?.dataItem as
      | ForecastPriceRow
      | undefined;
  };

  // ── Insert (AS-IS InsertButton — Current 버전 조회 시에만) ──
  //   ⭐ #9 시드 복사 (AS-IS L2636~2676): 포커스 행이 있으면 키 컬럼을 새 행에 복제한다.
  //   단 MEASURE 는 복사 대상에서 제외 — 통합테스트 35번 요구 (아래 MEASURE 주석 참조).
  const handleInsert = () => {
    if (!isEditableVersion) return;
    // 신규행 생성 자격 없는 역할(SCP Planner 등)은 진입 차단 — 버튼 은닉과 같은 기준(canInsertNewRow).
    if (measureAuth['MKT_FCST'] !== true) return;
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
    // 앵커 = 선택한 셀이 속한 **머지 블록의 첫 행** — 그 바로 위에 놓는다 (앵커 null = 맨 위).
    //   [통합테스트 35번] 앵커가 포커스 행 자체면 그룹 중간(measure 2~3번째)을 찍었을 때 신규행이
    //   measure 사이에 낀다. 요구는 "data Group 제일 위로 / 선택한 값의 병합한 데이터 위로".
    //   시드 값은 그대로 **선택한 행**에서 복사한다 — 위치만 블록 맨 위로 올린다.
    //   배열 끝에 붙여 누른 순서를 유지한다 — 같은 앵커에 연속 Insert 시 누른 순서대로 쌓인다.
    const anchorRow = groupTopRowOf(selectedIndex) ?? null;
    // 정렬이 걸려 있어도 신규행이 앵커 옆에 계속 붙어 보이도록 pin 등록(pinInsertedRow).
    if (g) pinInsertedRow(g as never, newRow as never, (anchorRow as never) ?? undefined);
    setInsertedRows(prev => [...prev, { row: newRow, anchor: anchorRow }]);
    focusRowRef.current = newRow;
    // itemsSource 가 바뀌기 전인 지금 컬럼을 캡처 — 늦게 읽으면 wijmo 가 이미 선택을 초기화한 뒤다.
    focusColRef.current = Math.max(0, g?.selection.col ?? 0);
    focusScrollRef.current = g?.scrollPosition ?? null;
    // [공통 C1 2026-08-11 → 2026-08-12 정정] 필터링 상태 Insert 시 신규행이 안 보이던 문제는
    //   ForecastPriceGrid 가 신규(CRUD_TYPE='I') 행을 필터에서 제외해 해결한다.
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
    if (insertedRows.length > 0) {
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
      // 삭제 대상이 다른 신규행의 앵커였다면 그 앵커를 삭제 행의 앵커로 승계시킨다.
      //   (승계하지 않으면 앵커 유실로 딸린 행들이 그리드 맨 위로 튄다.)
      setInsertedRows(prev => {
        const removed = prev.find(p => (p.row as unknown as WijmoRowItem) === item);
        if (!removed) return prev;
        return prev
          .filter(p => p !== removed)
          .map(p => (p.anchor === removed.row ? { ...p, anchor: removed.anchor } : p));
      });
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
      setToast({ message: t(MSG.SAVED, '_Saved.') });
      tracker.clearChanges();
      setInsertedRows([]);
      invalidateAfterSave();
    } finally {
      setSaving(false);
    }
  };

  // [E20260826-AUTHVIEW] 편집 가능 메저 존재 여부 — drop3(measureAuth) 에 'Y' 가 하나라도 있는가.
  //   DM Viewer(전 메저 N)·시간창 밖 SCP Planner(전 메저 N/T) 는 false → 편집 진입 버튼 숨김.
  const hasEditAuth = Object.values(measureAuth).some(Boolean);

  // 신규행 생성 자격 — SCP Planner 는 기존 SCM_FCST 값 수정만 가능하고 신규 행 Insert·저장은 불가
  //   (사용자 요구 2026-09-04). SCP Planner 는 SAVE 권한이 있어(SCM_FCST 수정 저장) 지금은 Insert 도
  //   같이 열린다. 형제 화면처럼 hasButton('INSERT') 로 가를 수 없는 화면이다 — 메인 시트(FcstNPrice)에
  //   INSERT 버튼이 미등록이고, 버튼권한 API 가 서브시트를 합쳐 내려줘 hasButton('INSERT') 가 Price Batch
  //   팝업의 INSERT 로 항상 true 다(실측 2026-09-04). 대신 measure 편집권한으로 가른다: 신규행은 MKT_FCST
  //   (또는 권한 있는 첫 measure)로 생성되는 DM 측 행위이고, SCP Planner 는 룩업상 SCM_FCST(시간창)만
  //   있고 MKT_FCST 권한이 없다. 그래서 MKT_FCST 편집권한 보유를 "신규행을 만들 수 있는 역할"의 신호로 쓴다.
  //   주의: MKT_FCST 시간창 잠금(별건, 백엔드 drop3)이 반영되면 SCP 시간대엔 DM Planner 의 MKT_FCST 도
  //     'N' 이 되어 그 시간대엔 DM Planner Insert 도 막힌다("SCP 시간대=신규행 금지"면 정합, 아니면
  //     정적 권한 신호로 교체 필요).
  const canInsertNewRow = measureAuth['MKT_FCST'] === true;

  const hotkeyConfig = {
    search: () => void handleSubmit(),
    manual: false as const, // Manual(F1) 버튼 미표시 (전체 삭제 방침 — 강민재)
    // 추가/삭제/저장 = 저장권한(hasButton) AND **편집 가능 버전일 때만** 노출.
    //   과거(조회 전용) 버전은 전 행 EDIT_FLAG='N' → isEditableVersion=false → 세 버튼 숨김(미렌더).
    //   Insert 는 handleInsert 내부에도 동일 가드가 있으나, 버튼 자체를 숨겨 진입점을 원천 차단한다.
    //   [UICATEGORY 2026-08-07] div 82 = 조회 전용 — isCurVersion 이 true 여도 세 버튼 차단(!isDiv82).
    //   [E20260826-AUTHVIEW] + 편집 가능 메저 존재(hasEditAuth) — hasButton('SAVE') 는 메뉴 단위
    //     합집합이라 DM Viewer 의 titleSet:SAVE 가 MAIN 편집 버튼까지 열었다(사용자 지시 2026-08-26:
    //     DM Viewer = INSERT/DELETE/수정 전면 불가). drop3 전 메저 'N'(Viewer·시간창 밖 SCP)이면 숨김.
    ...(hasButton('SAVE') && isEditableVersion && !isDiv82 && hasEditAuth
      ? {
          // Insert 는 신규행 생성 자격(canInsertNewRow)까지 있어야 노출 — SCP Planner 차단.
          //   Delete/Save 는 그대로 둔다: SCP Planner 도 기존 SCM_FCST 값 수정·저장은 정상 기능이다.
          insert: canInsertNewRow ? handleInsert : (false as const),
          delete: () => void handleDelete(),
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
    ...(isExcelDiv && hasButton('FORM_DATA')
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
    ...(isExcelDiv && hasButton('UPLOAD')
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
    //   숨김 (사용자 지시 2026-08-26). 판가 일괄 입력의 권한 축 = drop3 LOC (AS-IS bEDIT_AUTH_LOC 계보).
    ...(!isDiv82 && measureAuth['LOC'] === true
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
      label: t('LBL00712', '_Measure'),
      title: t('LBL00712', '_Measure'),
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
            setInsertedRows([]);
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
