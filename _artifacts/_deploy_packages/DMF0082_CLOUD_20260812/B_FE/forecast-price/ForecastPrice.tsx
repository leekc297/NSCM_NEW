import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnLayoutModal, toColumnLayoutSettings } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FileExceluploadIcon } from '@lges/design-system/icon';

import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { ForecastPriceForm } from './components/ForecastPriceForm';
import { ForecastPriceGrid } from './components/ForecastPriceGrid';
import {
  ExchangeRateModal,
  ForecastTemplateModal,
  MeasureSelectModal,
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

// ⭐ DMF0082 (Fcst&Price MGMT) — AS-IS DMF0082_FcstNPrice_Mgmt 1:1. 조회 = PKG_DMF0082.
//   P_DMF0082_GET_MAIN_DATA(12 IN+6 cursor) / 저장 = DMF0082_SAVE_MAIN_DATA(16 IN '^' bulk).
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
  const [insertedRows, setInsertedRows] = useState<ForecastPriceRow[]>([]);

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
  const measureAuth = useForecastPriceStore(state => state.measureAuth);
  const staticColumns = useForecastPriceStore(state => state.staticColumns);
  const originalStaticColumns = useForecastPriceStore(state => state.originalStaticColumns);
  const staticMeasures = useForecastPriceStore(state => state.staticMeasures);
  const fetchUserColumnLayout = useForecastPriceStore(state => state.fetchUserColumnLayout);
  const applyColumnLayout = useForecastPriceStore(state => state.applyColumnLayout);
  const authGroup = useForecastPriceStore(state => state.authGroup);
  const setAuthGroup = useForecastPriceStore(state => state.setAuthGroup);

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
  const [authGroupCombo] = useTabComboQueries({ filters: ['FcstPriceUserAuthGroup'] });
  useEffect(() => {
    const first = (authGroupCombo ?? [])[0] as { CODE?: string } | undefined;
    if (first?.CODE) setAuthGroup(String(first.CODE));
  }, [authGroupCombo, setAuthGroup]);
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

  const gridRows = useMemo(
    () => [...insertedRows, ...(data?.fcstNPrice ?? [])],
    [insertedRows, data]
  );

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

  // Excel Form / Excel Upload 버튼 노출 게이트 — ⭐ division 40 전용 (2026-08-12 정정).
  //   근거: PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD 검증절 L4342 'Invalid Division(40 Only)' 실측 —
  //   구 81 게이트는 SP 계약과 정면 충돌(81 업로드는 전행 ERROR 분류). AS-IS(KJY 2025.05) 40 전용 설계.
  const isExcelDiv = searchParams.divisionId === '40';
  // [UICATEGORY 2026-08-07] Division 82 = 조회 전용 (사용자 확정) — Insert/Delete/Save 버튼 차단.
  //   서버 권위 = PKG EDIT_FLAG='N' 일괄 + SAVE V82-00 가드. FE 는 UX 게이트(진입점 원천 차단).
  const isDiv82 = searchParams.divisionId === '82';

  // ── Search (AS-IS FindButton — V1~V4 검증 후 조회) ──
  const handleSubmit = async () => {
    // [공통 C2 2026-08-11] 수정 중 재조회 가드 — 통합테스트 1st Common "수정 중인 데이터가 있습니다.
    //   새로 조회하시겠습니까? 팝업 호출 필요"(현재는 경고 없이 전환). MSG00703 신규 채번(3점 반영).
    //   pending = editTracker 변경분(Price Batch Input 가드 동일 패턴) + 신규(I) 행.
    const pendingChanges = editTrackerRef.current?.getOriginalValues();
    if ((pendingChanges && Object.keys(pendingChanges).length > 0) || insertedRows.length > 0) {
      const proceed = await setAlert({
        type: 'confirm',
        content: t('MSG00703', '_There are unsaved changes. Search again?'),
      });
      if (!proceed) return;
    }
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

  // ── Insert (AS-IS InsertButton — Current 버전 조회 시에만) ──
  //   ⭐ #9 시드 복사 (AS-IS L2636~2676): 포커스 행이 있으면 키 10종을 새 행에 복제, 없으면 Measure='MKT_FCST'.
  const handleInsert = () => {
    if (!isEditableVersion) return;
    const g = gridRef.current;
    const seed = g?.rows[g.selection.row]?.dataItem as WijmoRowItem | undefined;
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
      SCM_SITE_ID: str(seed?.['SCM_SITE_ID']),
      ITEM_ID: str(seed?.['ITEM_ID']),
      DOM_EXP: str(seed?.['DOM_EXP']),
      FCST_TYPE: str(seed?.['FCST_TYPE']),
      INCOTERMS: str(seed?.['INCOTERMS']),
      MEASURE: seed ? str(seed['MEASURE']) : 'MKT_FCST',
      CURRENCY: str(seed?.['CURRENCY']),
      CELL_PROD_SITE_ID: str(seed?.['CELL_PROD_SITE_ID']),
      // 시드 행 BUCKET(요일비트) 승계 — 배분 요일 유지 (없으면 #2 캐스케이드/기본요일).
      BUCKET: str(seed?.['BUCKET']),
      EDIT_FLAG: 'Y',
    } as unknown as ForecastPriceRow;
    setInsertedRows(prev => [newRow, ...prev]);
    // [공통 C1 2026-08-11] 필터링 상태에서 Insert 시 신규행이 그리드 필터에 걸려 화면에 안 보이는
    //   문제(통합테스트 1st Common) — 활성 필터를 해제해 추가된 행이 즉시 보이게 한다.
    gridFilterRef.current?.clear();
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
      setInsertedRows(prev => prev.filter(r => (r as unknown as WijmoRowItem) !== item));
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

  // ── Save (AS-IS SaveButton — 검증 → MSG00001 확인 → 16 IN '^' bulk → 재조회) ──
  const handleSave = async () => {
    const tracker = editTrackerRef.current;
    if (!tracker) return;
    const allRows = gridRows as unknown as WijmoRowItem[];

    const validationError = validateSaveRows(allRows, editableDayColumns);
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

    const saveRows = buildSaveRows(allRows, tracker, editableDayColumns);
    if (saveRows.length === 0) return;

    const confirmed = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '_Save?') });
    if (!confirmed) return;

    const userId = useSessionStore.getState().session.userId ?? '';
    // '^' bulk payload — useProcMutation 의 array unfold 를 피해 call-proc 직접 (표준 패턴).
    const res = await apiClient.post<{
      o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string; ERR_EVENT?: string }[];
    }>(`/${MENU_ID}/FcstNPrice/SAVE/call-proc`, buildSavePayload(saveRows, userId));
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
    // ⭐ Excel Form(템플릿 다운로드 모달) — division 81 계열에서만 노출 (metal-link 'Excel Form' 이식).
    ...(isExcelDiv
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
    // ⭐ Excel Upload — [2026-08-12 사용자 지시] Excel Form 다음(2번째). division 81 계열 전용(기존 게이트 유지).
    ...(isExcelDiv
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
      />

      {/* Version 선택 (AS-IS SCM0002_VersionByWaterfallPopup — DMF0073 공유 계약) */}
      <VersionSelectModal
        open={versionModalOpen}
        modalClose={() => setVersionModalOpen(false)}
        defaultDivision={searchParams.divisionId}
        defaultPeriod={{ start: searchParams.startYyyymmdd, end: searchParams.endYyyymmdd }}
        onApply={versionIds => setSearchParams({ versionType: versionIds })}
      />

      {/* Measure 설정 (AS-IS btnMeasure — titleSet 'M' 영구 저장 → 재조회) */}
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

      {/* Excel Form — division 40 전용 (isExcelDiv). 조회 = UPLOAD_DATA 배선
          (PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA — 본인 최종 업로드분 Daily 미리보기,
          2026-08-12 조회 구현) + 업로드 양식(M4~M16 원형 헤더) 다운로드. */}
      <ForecastTemplateModal
        open={templateModalOpen}
        modalClose={() => setTemplateModalOpen(false)}
        divisionId={searchParams.divisionId}
        bucketType={searchParams.bucketType}
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
