import { FileExceluploadIcon } from '@lges/design-system/icon';
import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
// ⭐ [2026-08-20 정본 단일화] Grid Column Setting 모달 = @shared/components 표준 정본 직행
//   (packages/shared/.../templates/modals/column-layout-modal — hook #132 §Column 모달 정본)
import { ColumnLayoutModal, MainTitle, SubTitle, toColumnLayoutSettings } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useDirtyReset, useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import {
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
  const focusRowRef = useRef<ForecastPriceRow | null>(null);

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
    void apiClient
      .getCombo({ comboId: 'SiteEndCustomerMapDMF0082', divisionId: `'${div.replace(/'/g, "''")}'` })
      .then(rows => {
        siteEcMapRef.current = new Map(
          (rows ?? []).map(r => [String(r.CODE ?? ''), String(r.NAME ?? '')])
        );
        setSiteEcVersion(v => v + 1);
      })
      .catch((err: unknown) => {
        // 실패 시 원값(원장 키) 표시 유지 — 조용한 무증상 금지, 콘솔로 남긴다.
        console.error('[combo] SiteEndCustomerMapDMF0082 조회 실패 — END_CUSTOMER 원값 표시 유지', err);
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
      for (const row of baseRows as unknown as Record<string, unknown>[]) {
        if ('END_CUSTOMER_KEY' in row) continue;
        const disp = siteEcMapRef.current.get(String(row.SCM_SITE_ID ?? ''));
        if (disp === undefined) continue;
        row.END_CUSTOMER_KEY = row.END_CUSTOMER ?? '';
        row.END_CUSTOMER = disp;
      }
    }
    if (insertedRows.length === 0) return baseRows;

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
    baseRows.forEach(emit);
    return merged;
    // siteEcVersion — [ENDCUSTDISP] 맵 도착 시 표시 변환 재실행 트리거 (맵 자체는 ref).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [insertedRows, data, siteEcVersion]);

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
    const focusTarget = (): boolean => {
      const rowIndex = grid.rows.findIndex(r => r.dataItem === target);
      if (rowIndex < 0) return false;
      grid.select(rowIndex, Math.max(0, grid.selection.col));
      grid.scrollIntoView(rowIndex, -1);
      return true;
    };
    if (focusTarget()) {
      focusRowRef.current = null;
      return;
    }
    const frame = requestAnimationFrame(() => {
      if (focusTarget()) focusRowRef.current = null;
    });
    return () => cancelAnimationFrame(frame);
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
      ITEM_ID: str(seed?.['ITEM_ID']),
      DOM_EXP: str(seed?.['DOM_EXP']),
      FCST_TYPE: str(seed?.['FCST_TYPE']),
      INCOTERMS: str(seed?.['INCOTERMS']),
      // [통합테스트 35번] "라인추가시 measure 는 copy 하지 않음" — 시드 행의 measure 를 승계하지도,
      //   기본값('MKT_FCST')을 넣지도 않는다. 사용자가 MEASURE 셀 콤보에서 직접 고른다.
      //   주의: 공백 measure 는 수량/가격 셀이 잠긴 상태다(isNonEditableCell 의 editableMeasures 게이트).
      //   즉 measure 를 먼저 고르지 않으면 값을 못 넣고, 그대로 저장하면 V2(QTY_PRICE_REQUIRED)에서 막힌다.
      MEASURE: '',
      CURRENCY: str(seed?.['CURRENCY']),
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
    setInsertedRows(prev => [...prev, { row: newRow, anchor: anchorRow }]);
    focusRowRef.current = newRow;
    // [공통 C1 2026-08-11 → 2026-08-12 정정] 필터링 상태 Insert 시 신규행이 안 보이던 문제는
    //   ForecastPriceGrid 가 신규(CRUD_TYPE='I') 행을 필터에서 제외해 해결한다.
    //   구 구현의 `gridFilterRef.current?.clear()` 는 사용자가 걸어둔 필터까지 날려서 제거했다.
  };

  // ⭐ [No.65 2026-08-14] Project 셀 검색 모달 상태 — 더블클릭한 신규행에 선택값을 되꽂는다.
  const [openProject, setOpenProject] = useState(false);
  const [popupRow, setPopupRow] = useState<ForecastPriceRow | null>(null);
  /** 팝업 조회조건 초기값 — 더블클릭 행의 셀 값(없으면 fallback). DMF0003 `rowValue` 1:1. */
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
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
  };

  const hotkeyConfig = {
    search: () => void handleSubmit(),
    manual: false as const, // Manual(F1) 버튼 미표시 (전체 삭제 방침 — 강민재)
    // 추가/삭제/저장 = 저장권한(hasButton) AND **편집 가능 버전일 때만** 노출.
    //   과거(조회 전용) 버전은 전 행 EDIT_FLAG='N' → isEditableVersion=false → 세 버튼 숨김(미렌더).
    //   Insert 는 handleInsert 내부에도 동일 가드가 있으나, 버튼 자체를 숨겨 진입점을 원천 차단한다.
    //   [UICATEGORY 2026-08-07] div 82 = 조회 전용 — isCurVersion 이 true 여도 세 버튼 차단(!isDiv82).
    ...(hasButton('SAVE') && isEditableVersion && !isDiv82
      ? {
          insert: handleInsert,
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
    ...(!isDiv82
      ? [
          {
            // 명칭 = DMF0020 과 동일 'Price Batch Input' (LBL00662, 2026-07-12 요청)
            label: t('LBL00662', 'Price Batch Input'),
            title: t('LBL00662', 'Price Batch Input'),
            action: () => {
              // AS-IS V15: 수정모드(변경 존재) 시 차단 (MSG00669) 후 SavePricePeriodModal open
              const changed = editTrackerRef.current?.getOriginalValues();
              if (changed && changed.size > 0) {
                void setAlert({
                  type: 'alert',
                  content: t(MSG.EDIT_MODE_NO_INPUT, '_Not in edit mode.'),
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
            content: t(MSG.EDIT_MODE_NO_ACTION, '_Edit Mode 에서는 수행할 수 없습니다.'),
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
        customButtons={customButtons}
      />
      <ForecastPriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={gridRows}
        spreadTitle={spreadTitle}
        editTrackerRef={editTrackerRef}
        onPopupCellDblClick={(modalKey, row) => {
          if (modalKey !== 'PROJECT') return;
          setPopupRow(row as unknown as ForecastPriceRow);
          setOpenProject(true);
        }}
      />

      {/* ⭐ [No.65 2026-08-14] Project 셀 검색 모달 — 81 계열 신규행의 PROJECT_CODE 입력 경로.
          메타가 FPModal 이라 공용 DataGrid 가 직접 편집을 취소하므로, 이 모달이 없으면 Project 를
          넣을 방법이 아예 없었다(통합테스트 1st No.65 "Project 컬럼 자체가 없음").
          정본 = DMF0003 `MktFcst.tsx` 셀 팝업 배선 1:1. */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(
          projectCode,
          projectName,
          _projectStatus,
          _bizTypeName,
          projectOwner
        ) => {
          const target = popupRow as unknown as WijmoRowItem | null;
          if (target) {
            target['PROJECT_CODE'] = projectCode;
            // PROJECT_NAME / OWNER 컬럼은 division·컬럼셋에 따라 없을 수 있다 —
            //   **있을 때만** 채운다(hook #130 메타 실소비: 없는 키를 만들면 SAVE payload 가 오염된다).
            if ('PROJECT_NAME' in target) target['PROJECT_NAME'] = projectName ?? '';
            if ('PROJECT_OWNER' in target) target['PROJECT_OWNER'] = projectOwner ?? '';
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
          visibleMeasures={null} 유지: 표시 상태는 저장 후 재fetch 한 display 로만 복원한다. */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        // 통합테스트 1st No.40 요구 — 이 화면만 Measure Code 컬럼을 함께 노출한다.
        showMeasureCode
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          ).then(ok => {
            if (!ok) return;
            fetchStaticMeasures();
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
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
        title={t('LBL00753', '_Column')}
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
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
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
        onSaveResult={() => void queryClient.invalidateQueries({ queryKey: [MENU_ID] })}
      />

      {/* Excel Form (템플릿 다운로드 모달) — division 81 계열 전용 [E20260819-XLS81LOC].
          SP 가 LOC measure 만 산출 + 81 외 division 은 CODE '1' MSG01014 가드. */}
      <ForecastTemplateModal
        open={templateModalOpen}
        modalClose={() => setTemplateModalOpen(false)}
        divisionId={searchParams.divisionId}
        filters={filters as Record<string, unknown> | undefined}
        staticColumns={staticColumns}
      />

      {/* Excel Upload (AS-IS DMF0082_EXCEL_UPLOAD — 2-Step: Upload=검증분류 / OK=저장 mode=1.
          공용 FcstUploadModal(demand) + EXCEL_COLUMNS SHEET_NAME='FcstNPrice' 기이관 실측) */}
      <FcstUploadModal
        open={uploadModalOpen}
        modalClose={() => setUploadModalOpen(false)}
        menuId={MENU_ID}
        sheetName={UPLOAD_SHEET}
        attributeHeaders={[...UPLOAD_HEADERS]}
        onSave={saveExcelUpload}
        onUploaded={() => void queryClient.invalidateQueries({ queryKey: [MENU_ID] })}
      />
    </>
  );
};
