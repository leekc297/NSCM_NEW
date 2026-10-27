// 주의: FileExceluploadIcon 은 @shared/lges-icons 배럴에 미포함(FileExceldownloadIcon 만 재export).
//   배럴은 shared 패키지라 수정 범위 밖이므로, 정본 distribution-route 와 동일하게 원 패키지에서 직접 가져온다.
import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  MaterialByDivisionModal,
  MeasureSelectModal,
} from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, saveTitleSet, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ExcelUploadModal } from './components/modals/ExcelUploadModal';
import {
  OrderDetailModal,
  type OrderDetailContext,
} from './components/modals/OrderDetailModal';
import { ShipmentPlanElectrodeDetailBar } from './components/ShipmentPlanElectrodeDetailBar';
import { ShipmentPlanElectrodeDetailGrid } from './components/ShipmentPlanElectrodeDetailGrid';
import { ShipmentPlanElectrodeForm } from './components/ShipmentPlanElectrodeForm';
import { ShipmentPlanElectrodeMainGrid } from './components/ShipmentPlanElectrodeMainGrid';
import {
  ADMIN_SHEET_NAME,
  DEFAULT_CHANGE_REASON_CODE,
  LBL,
  LOOKUP,
  MENU_ID,
  MSG,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  PLAN_DETAIL_REQUIRED_COLUMNS,
  PROGRAM_ID,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-electrode.constants';
import { FORM_COLUMNS, TEMPLATE_EXCEL_PREFIX } from './shipment-plan-electrode.excelForm';
import type { CalendarRow, MainRow } from './shipment-plan-electrode.types';
import styles from './ShipmentPlanElectrode.module.scss';
import { useShipmentPlanElectrodeStore } from './useShipmentPlanElectrodeStore';
import { activeSpanOf } from './utils/shipment-plan-electrode.editLock';
import {
  checkReasonWithoutChange,
  checkShipmentDate,
  collectDetailSaveRows,
  collectMainSaveRows,
  hasZeroQtyPoToDelete,
} from './utils/shipment-plan-electrode.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0023_ShipmentPlanElectrode (Shipment Plan - Electrode / 출하계획-전극) — 신규 전환.
//   설계: .atlas/gscm-design/SSP0023/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지, false 숨김 금지),
//     Edit = SwitchLock 미이식(convert-core §2.4 — 편집 기본 ON, 권한 마운트 1회).
//   이중 pivot: rdButton1/2/3 이 BOH 3칸 + 활성 기간 span(X_/Y_/Z_)을 동시 선택(03 §2.1/§2.2).
//   주의: 초안작성/확정 SAVE SP(PKG_SSP0023 draft/confirm)는 미배포(§6-1) — Detail 저장 경로는
//     배선 보류·미완 안내(convert-sp 후속). siMain 시뮬레이션 저장(SAVE_SHIPMENT_PLAN_SIMU)은 배포됨.
export const ShipmentPlanElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);

  // ── refs (Main + Detail 3-sheet) ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const planDetailGridRef = useRef<FlexGridType>();
  const planDetailGridFilterRef = useRef<FlexGridFilter>();
  const planDetailEditTrackerRef = useRef<EditTracker>();
  const stockDetailGridRef = useRef<FlexGridType>();
  const stockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const setSearchCondition = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const filters = useShipmentPlanElectrodeStore(s => s.filters);
  const setMainFilters = useShipmentPlanElectrodeStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanElectrodeStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanElectrodeStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanElectrodeStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanElectrodeStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanElectrodeStore(s => s.realFlag);
  const activeGrid = useShipmentPlanElectrodeStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanElectrodeStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanElectrodeStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanElectrodeStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentPlanElectrodeStore(s => s.fetchStaticMeasures);
  const staticMeasures = useShipmentPlanElectrodeStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentPlanElectrodeStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useShipmentPlanElectrodeStore(s => s.applyVisibleMeasures);
  const restoreSearchConditions = useShipmentPlanElectrodeStore(s => s.restoreSearchConditions);
  const initialized = useShipmentPlanElectrodeStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 가능 = 편집계 권한(canEdit) · 최신 Plan(realFlag).
  //   canEdit = hasButton('INSERT') || hasButton('SAVE').
  //   주의: AS-IS EditButton 은 권한이 아니라 SwitchLock 잠금토글(roslyn L2060/2244)이라 EDIT 은 권한 개념이 아니었고,
  //   SCM_ADM_MNU_BTN_MPG_M 에도 EDIT 미등록(23행 중 없음)이라 hasButton('EDIT')은 항상 false → 편집 전건 dead.
  //   실제 등록된 편집계 권한(INSERT/SAVE)으로 게이트한다(SCP0048 선례와 동일 해결, 2026-10-03 사용자 결정).
  //   AS-IS SwitchLock '수정 모드' 토글 어포던스는 이식하지 않는다(convert-core §2.4). realFlag 조건은 유지.
  const canEdit = hasButton('INSERT') || hasButton('SAVE');
  const mainEditable = canEdit && realFlag;
  const detailEditable = canEdit && realFlag;

  // ── Measure 설정 모달 (btnMeasure — spdMain 활성일 때만) ──
  const [openMeasure, setOpenMeasure] = useState(false);
  // ── Material 검색 모달 (btnItemId — 공용 MaterialByDivisionModal COM0013) ──
  const [openItem, setOpenItem] = useState(false);
  // ── Model/Nickname 검색 모달 (상단, 공용 MaterialByDivisionModal — 사용자 지시 2026-10-22) ──
  const [openModel, setOpenModel] = useState(false);
  // ── 2차 Material 검색 모달 (btnItemId2 — AS-IS BtnMaterialId2_Click cs:819~838, 상세행 txtItemId2) ──
  const [openDetailItem, setOpenDetailItem] = useState(false);
  // ── 2차 Model/Nickname 검색 모달 (하단, 공용 MaterialByDivisionModal — 사용자 지시 2026-10-22) ──
  const [openDetailModel, setOpenDetailModel] = useState(false);
  // ── Requestor 검색 모달 (btnRequestor — AS-IS UserInfoPopup, PlanDetail 상세행 txtRequestor) ──
  const [openRequestor, setOpenRequestor] = useState(false);
  // ── Excel Upload 모달 (btnExcelUpload — AS-IS ExcelUploadForm2, 정본 SCP0005/distribution-route) ──
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  // 업로드 저장 성공 여부 — 취소로 닫힐 땐 재조회 확인을 띄우지 않는다(2026-10-19 사용자 결정, AS-IS 와 다름).
  const excelUploadSavedRef = useRef(false);
  // ── ERP Order Detail 팝업 (PlanDetail ERP_SO_NO/PO No 더블클릭, AS-IS SSP0300). null=닫힘. ──
  const [orderDetailCtx, setOrderDetailCtx] = useState<OrderDetailContext | null>(null);

  // 주의: My Model 체크박스는 진입 시 기본 해제 상태로 둔다 — AS-IS 도 기본 세팅되지 않아
  //   R09 auto-check(MY_MODEL_DEFAULT_CHECK Company 매칭) 이식은 제거했다(2026-10-14 사용자 확인).
  //   체크 시 "담당 모델만" 필터라 담당 모델이 없는 계정은 전건이 걸러져 빈 조회가 됐다.

  // ── 조회 (React Query — SSOT) ──
  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: !!filters[SHEETS.CALENDAR],
  });
  const { data: planDetailData, refetch: refetchPlanDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.PLAN_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_DETAIL,
    tabId,
    filters: filters[SHEETS.PLAN_DETAIL],
    enabled: !!filters[SHEETS.PLAN_DETAIL],
  });
  const { data: stockDetailData } = useTabProcQuery<MENU_ID, SHEETS.STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.STOCK_DETAIL],
    enabled: !!filters[SHEETS.STOCK_DETAIL],
  });
  const { data: shipmentResultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });

  // 주의: PKG_SSP0023 전 SP 의 OUT 커서 응답 키는 대문자 O_RC1 이다(라이브 네트워크 실측 2026-10-12).
  //   useTabProcQuery(→apiClient.callProc)는 response.result 를 키 정규화 없이 그대로 반환하므로
  //   소문자 o_rc1 로 읽으면 undefined → 그리드(특히 CALENDAR 동적 날짜컬럼) 조용히 빈결과.
  //   [[proc-cursor-key-colnm-vs-fe-read]] 와 같은 계열(커서 래퍼 키 대소문자 축).
  const rd = <T,>(data: unknown): T[] =>
    (data as { O_RC1?: T[] } | undefined)?.O_RC1 ?? [];

  const mainRows = useMemo<MainRow[]>(() => rd<MainRow>(mainData), [mainData]);
  const calendarRows = useMemo(() => rd<CalendarRow>(calendarData), [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.PLAN_DETAIL]: rd<WijmoRowItem>(planDetailData),
      [SHEETS.STOCK_DETAIL]: rd<WijmoRowItem>(stockDetailData),
      [SHEETS.SHIPMENT_RESULT]: rd<WijmoRowItem>(shipmentResultData),
    }),
    [planDetailData, stockDetailData, shipmentResultData]
  );

  // 출하일 D±기간 제한(MSG01206) 기준일수 dDay — CHANGE_REQ_DAY lookup 1행의 NAME(=SEGMENT2) 열.
  //   ora.py 실측 CODE='D'/NAME='-56'. 하드코딩 금지 — lookup 실값만 쓴다(자매 useShipmentChangeRequestValidation).
  //   미조회·비수치면 undefined → 날짜범위 검증 생략(임의 기본값으로 전건 차단 방지). 날짜형식 검증은 무관히 수행.
  const [changeReqDay] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_DAY }] });
  const dDay = useMemo<number | undefined>(() => {
    const first = changeReqDay?.[0] as Record<string, unknown> | undefined;
    if (!first) return undefined;
    const raw = str(first.NAME ?? first.SEGMENT2 ?? '').trim();
    if (raw === '') return undefined;
    const value = Number(raw.replace(/,/g, ''));
    return Number.isFinite(value) ? value : undefined;
  }, [changeReqDay]);

  // ── mount — 개인화 조회조건 복원(SubTitle F6 저장분, 1회). GET /admin/menu/SSP0023/search-conditions
  //   → searchCondition 패치. 형제 화면(shipment-plan-mobility-it) 파리티 — 종전 저장만 되고 복원 미배선이던
  //   것 해소. 복원값은 Division/Company 가 cascade default effect(hasDivision/hasCompany 가드)로 보존되고,
  //   날짜/기간은 저장에서 제외라 PlanDate 최신 재선택으로 재파생된다. ──
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼/measure 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns([SHEETS.MAIN, SHEETS.PLAN_DETAIL, SHEETS.STOCK_DETAIL, SHEETS.SHIPMENT_RESULT]);
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Division/Company 변경 = 그리드·편집 상태 초기화 의무 (hook #5). filters 초기화는 store 담당,
  //    여기서는 EditTracker 잔여 기록 정리. ──
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();

  }, [sc.divisionId, sc.companyId]);

  // ── Find (F5 — 01 R10) ──
  const runMainSearch = () => {
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
    void fetchStaticMeasures();
  };

  const handleSearch = () => {
    // 필수 4종 (02 §3 — Division*/Company*/Plan Date*/Period*)
    if (!sc.divisionId || !sc.companyId || !sc.planDateYyyymmdd || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 미저장 변경이 있으면 재조회 전 확인(MSG00703).
    const hasUnsaved =
      mainEditTrackerRef.current?.hasChanges() === true ||
      planDetailEditTrackerRef.current?.hasChanges() === true;
    if (hasUnsaved) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_RESEARCH_UNSAVED, {
          defaultValue: '_There are unsaved changes. Do you want to search again?',
        }),
        onConfirm: runMainSearch,
      });
      return;
    }
    runMainSearch();
  };

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회) ──
  const handleDetailSearch = () => {
    setDetailFilter(activeDetailSheet, 'N');
    void fetchStaticColumns([activeDetailSheet]);
  };

  const savingRef = useRef(false);

  // ── Simulation (btnSimulation — AS-IS 분리 버튼 복원, cs:1872 BtnSimulation_Click → Simulation() 5931). ──
  //   AS-IS 는 Save(Detail 확정)와 별개 버튼으로, siMain 의 P_SHIP_PLAN_SIMU_ETD 측정치 편집 셀을
  //   SSP0023_SAVE_SHIPMENT_PLAN_SIMU 로 저장한다. activeGrid 무관하게 항상 Main 저장(AS-IS 는 버튼이
  //   siMain 전용이므로 포커스 의존 없음) — SAVE(Detail) 버튼과 역할을 명확히 분리한다.
  const handleSimulation = () => {
    // 편집 사전조건 — 편집 불가면 조용히 무시(AS-IS IsLock 가드). AS-IS 는 realFlag=false(과거 Plan)여도
    //   MSG00292 경고 후 저장을 진행하나(cs:5949~5955 return 없음), TO-BE 는 과거 Plan 편집을 editLock 으로
    //   원천 차단(최신 Plan 만 편집 가능)해 변경 셀이 없으므로 payload 가 비어 저장이 자연 no-op 된다.
    if (!mainEditable) return;
    const rows = (mainGridRef.current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    const tracker = mainEditTrackerRef.current;
    const { payload, negatives } = collectMainSaveRows(
      rows,
      row => tracker?.getOriginalValues().get(row as WijmoRowItem),
      {
        divisionId: sc.divisionId,
        companyId: sc.companyId,
        planStartYyyymmdd: sc.planDateYyyymmdd,
        userId: session.userId ?? '',
        activeSpan: activeSpanOf(sc.bohRadio),
      }
    );
    // 음수 차단 (AS-IS MSG00084 — 저장 abort, SP 미호출)
    if (negatives.length > 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NEGATIVE_QTY, '__Quantity must be 0 or greater.'),
      });
      return;
    }
    if (payload.length === 0) {
      setToast({
        type: 'error',
        // message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.'),
      });
      return;
    }
    if (savingRef.current) return; // in-flight 가드 (np §3.2)
    savingRef.current = true;
    // siMain 시뮬레이션 저장(SAVE_SHIPMENT_PLAN_SIMU — 배포됨). AS-IS btnSimulation 전용 버튼 코드로 call-proc
    //   (SCM_ADM_MNU_BTN_MPG_M: main/SAVE_SHIPMENT_PLAN_SIMU → P_SSP0023_SAVE_SIMU, DB 실측 2026-10-16).
    //   SP IN 14키가 전부 스칼라라 1호출=1건(DATARESULT fold 아님) + 공통 call-proc 엔드포인트가
    //   @RequestBody Map<String,Object>(단일 객체)만 받으므로, 변경 셀(payload 각 건)을 건별 단일
    //   객체로 순차 POST 한다. 배열을 그대로 보내면 START_ARRAY 역직렬화 실패로 500.
    // 기존 로직 주석 보존 (2026-10-19) 시작 - 셀마다 순차 호출(일부만 저장될 수 있음)
    // void (async () => {
    //   try {
    //     for (const row of payload) {
    //       const res = await apiClient.post(
    //         `/${MENU_ID}/${SHEETS.MAIN}/SAVE_SHIPMENT_PLAN_SIMU/call-proc`,
    //         row
    //       );
    //       // false-success 판별 의무 (np §5-10 — 인터셉터가 500/403 도 resolve)
    //       if (res.status >= 400 || Number(res.data?.code)) {
    //         void setAlert({
    //           type: 'alert',
    //           content: t(MSG.SAVE_FAILED, '__Save failed.'),
    //         });
    //         return;
    //       }
    //     }
    //     mainEditTrackerRef.current?.clearChanges();
    //     setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
    //     if (filters[SHEETS.MAIN]) void refetchMain();
    //   } finally {
    //     savingRef.current = false;
    //   }
    // })();
    // 기존 로직 주석 보존 (2026-10-19) 끝
    // SP 가 키별 '^' 구분 문자열을 잘라 반복 저장하고 오류 시 전체 롤백한다 - AS-IS 처럼 1회 호출로 묶는다.
    const keys = Object.keys(payload[0]);
    const batch = Object.fromEntries(keys.map(k => [k, payload.map(r => r[k] ?? '').join('^')]));
    void (async () => {
      try {
        const res = await apiClient.post(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE_SHIPMENT_PLAN_SIMU/call-proc`,
          batch
        );
        // false-success 판별 의무 (np §5-10 — 인터셉터가 500/403 도 resolve)
        if (res.status >= 400 || Number(res.data?.code)) {
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAILED, '__Save failed.'),
          });
          return;
        }
        mainEditTrackerRef.current?.clearChanges();
        setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
        if (filters[SHEETS.MAIN]) void refetchMain();
        // AS-IS 처럼 하위 Plan Detail 도 재조회(조회된 적 있을 때만).
        if (filters[SHEETS.PLAN_DETAIL]) void refetchPlanDetail();
      } finally {
        savingRef.current = false;
      }
    })();
  };

  // ── Save (F7 — Detail(PlanDetail 확정) 저장 전용. Main 시뮬 저장은 handleSimulation 으로 분리). ──
  const handleSave = () => {
    // Detail 저장 — PlanDetail(확정)만 편집 대상. StockDetail/ShipmentResult 는 read-only.
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return;
    const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
    if (dirty.length === 0) {
      // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준)
      setToast({
        type: 'error',
        // message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.'),
      });
      return;
    }
    // 행별 필수 (03 §1.2 PLAN_DETAIL_REQUIRED_COLUMNS 공백검증) + 변경사유 자동 세팅
    for (const row of dirty) {
      for (const col of PLAN_DETAIL_REQUIRED_COLUMNS) {
        if (str(row[col]).trim() === '') {
          // DB 메시지(MSG00429)의 자리표시는 `{0}` 형식이라 i18next 보간(`{{var}}`)이 채우지 않는다 —
          //   `{ 0: col }` 로 넘겨도 그대로 '{0}' 가 남는다(messaging-i18n.md MSG-03, 자매 InventoryRaw:81).
          //   치환값은 바인딩명(SHIPMENT_DATE)이 아니라 그리드 컬럼 헤더(화면 표기)를 쓴다 — 후행 '*'(필수마커)
          //   는 제거(자매 ShipmentMasterElectrode:35). 헤더가 없으면 바인딩명으로 폴백.
          const header = planDetailGridRef.current?.getColumn(col)?.header ?? '';
          const label = (header || col).replace(/\*$/, '').trim();
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', label),
          });
          return;
        }
      }
      // 변경사유코드는 사용자 입력을 강제하지 않는다 — AS-IS 는 MSG00285(변경사유 입력 요구) 검증을
      //   주석으로 완전히 비활성화하고, 변경행의 CHANGE_REASON_CODE 가 비었거나 '-' 면 기본 사유코드
      //   'T07' 을 자동으로 채워 저장한다(cs:2949-2955 "자동 저장으로 변경", cs:298 strChangeReasonCode="T07").
      //   따라서 TO-BE 도 알림·저장차단 없이 자동 세팅만 한다(MSG01289/ROW_REASON_REQUIRED 미사용).
      const reason = str(row.CHANGE_REASON_CODE).trim();
      if (reason === '' || reason === '-') {
        row.CHANGE_REASON_CODE = DEFAULT_CHANGE_REASON_CODE;
      }
    }

    // 출하일 D±기간 제한 + 날짜형식 (AS-IS Validation_Check cs:2895~2901 / GetERPInterface cs:3123~3128).
    //   dDay 미확보면 날짜범위는 생략(형식 검증은 수행). arg(dDay·입력문자열)는 `{0}` 문자열 치환.
    const dateViol = checkShipmentDate(dirty, dDay, {
      INVALID_DATE_FORMAT: MSG.INVALID_DATE_FORMAT,
      DATE_OVER_MAX: MSG.DATE_OVER_MAX,
    });
    if (dateViol) {
      void setAlert({
        type: 'alert',
        content: t(dateViol.msgId, '_Invalid shipment date.').replace('{0}', dateViol.arg ?? ''),
      });
      return;
    }

    // 변경사항 없는데 사유 명시 입력됨 (AS-IS Validation_Check no-change branch cs:2968~3065, MSG00286).
    //   원본 대조는 EditTracker. arg 는 바인딩명 → 그리드 헤더(화면 라벨)로 치환.
    const tracker = planDetailEditTrackerRef.current;
    const reasonViol = checkReasonWithoutChange(
      dirty,
      row => tracker?.getOriginalValues().get(row as WijmoRowItem),
      DEFAULT_CHANGE_REASON_CODE,
      MSG.REASON_WITHOUT_CHANGE
    );
    if (reasonViol) {
      const header = planDetailGridRef.current?.getColumn(reasonViol.arg ?? '')?.header ?? '';
      const label = (header || reasonViol.arg || '').replace(/\*$/, '').trim();
      void setAlert({
        type: 'alert',
        content: t(reasonViol.msgId, '_There is no shipment change.').replace('{0}', label),
      });
      return;
    }

    // 27 IN `^`-fold payload (collectDetailSaveRows). dirty 전건 I/M/D 접지 — null 이면 대상 0건.
    const payload = collectDetailSaveRows(dirty, { userId: session.userId ?? '' });
    if (!payload) {
      setToast({
        type: 'error',
        // message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        message: t(MSG.NO_CHANGES, '_수정한 내용이 없습니다.'),
      });
      return;
    }

    // 실 저장 — PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(27 IN + O_RC1/O_RC2, VALID).
    //   단일 `^`-fold 객체를 call-proc 1회 POST. 성공=O_RC1[0].RESULT_CODE==='S'.
    const runDetailSave = () => {
      if (savingRef.current) return; // in-flight 가드
      savingRef.current = true;
      void (async () => {
        try {
          const res = await apiClient.post(
            `/${MENU_ID}/${SHEETS.PLAN_DETAIL}/SAVE/call-proc`,
            payload
          );
          // false-success 판별 의무 (np §5-10 — 인터셉터가 500/403 도 resolve)
          //   주의: apiClient.post 원본 응답은 {code,message,result:{O_RC1:[...]}} 이므로
          //   O_RC1 은 res.data.result 아래다. 조회 훅(useTabProcQuery)과 달리 result 가 벗겨지지
          //   않아, rd(res.data)로 읽으면 O_RC1=undefined → 상시 실패(저장은 됐는데 실패 알림).
          const ok =
            res.status < 400 &&
            !Number(res.data?.code) &&
            str(rd<{ RESULT_CODE?: string }>(res.data?.result)[0]?.RESULT_CODE) === 'S';
          if (!ok) {
            void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
            return;
          }
          planDetailEditTrackerRef.current?.clearChanges();
          setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
          if (filters[SHEETS.PLAN_DETAIL]) void refetchPlanDetail();
        } finally {
          savingRef.current = false;
        }
      })();
    };

    // Confirm Qty 0 PO 삭제 대상이 있으면 진행 확인(Yes/No) 후 저장 (AS-IS GetERPInterface cs:3136~3139, MSG00325).
    if (hasZeroQtyPoToDelete(dirty)) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.QTY_ZERO_PO_DELETE, '_A PO with Confirm Qty of 0 will be deleted. Proceed?'),
        onConfirm: runDetailSave,
      });
      return;
    }
    runDetailSave();
  };

  // ── Insert (F8 — PlanDetail 신규행. 03 §3.2 — 이전행 명시 필드만 복사) ──
  const handleInsert = () => {
    if (!detailEditable) return;
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return; // 읽기전용 2-sheet — 신규행 없음
    const g = planDetailGridRef.current;
    if (!g) return;
    // 복사 원본 = AS-IS activeRow(ActiveRowIndex+1 = 선택행). 선택이 없으면(조회 직후 미클릭)
    //   마지막 행으로 폴백해 AS-IS 처럼 항상 복제 원본을 확보한다(siDetail.Insert()는 활성셀 기준).
    const selRow = g.selection?.row ?? -1;
    const srcIdx = selRow >= 0 ? selRow : g.rows.length - 1;
    const source = GridUtils.getRow(g, srcIdx) as Record<string, unknown> | undefined;
    if (!source) return; // 그리드에 복제할 행 자체가 없으면 중단 (미조회)
    // 주의: AS-IS SSP0023 InsertRow(cs:1871~1932)는 SHIPMENT_STATUS 를 읽기만 하고 조건으로 쓰지 않는다
    //   (cs:1955 에서 복사도 주석처리). 상태 게이트는 형제 Mobility&IT(cs:7651, 상태 C 전제)에서 잘못 이식된
    //   것이라 제거한다 — 상태 무관 이전행 복제가 Electrode 정합이다.
    // 복사 필드는 AS-IS defaultData 명시 목록만(전 필드 스프레드 복사 금지 — 03 §3.2).
    const copied: Record<string, unknown> = {};
    PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
      copied[col] = source[col];
    });
    // 복사가 아닌 강제값 2개(AS-IS cs:1899/1927). SHIPMENT_CONFIRM_QTY 는 복사 대상이므로
    //   이전행 값이 그대로 들어간다(AS-IS defaultData.Add — 0 강제는 AS-IS 근거 없는 오이식이었다).
    copied.REMARKS = 'I'; // Insert 마커 강제
    copied.ERP_STATUS = ''; // 신규행은 ERP 미생성 — 공백 강제
    GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
  };

  // ── Measure (btnMeasure) — spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return; // 경고 없이 조용히 return
    setOpenMeasure(true);
  };

  // ── hotkeyConfig (00 §4d/01 R10 — hasButton 조건부, 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS 빈 몸체) — 노출 유지 + 명시적 무동작. 키 생략/false 금지(03 §3.5).
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  // Excel Form 다운로드 — AS-IS btnExcelFormDownload_Click → FindData_Plan_Detail_DownLoad(cs:6334~6453).
  //   AS-IS 는 빈 양식이 아니라 현재 조회조건(2차 detail 축: drpPeriod2/txtModel2/txtItemId2/txtNickName2/txtRequestor
  //   + 1차 4체크박스/nonChk)으로 SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL 을 조회해 그 결과를 채운 뒤 다운로드한다.
  //   매핑: main/GET_SHIPMENT_PLAN_DETAIL_EXCEL → P_SSP0023_GET_PLAN_DETAIL_EXCEL → PKG_SSP0023.P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(22 IN + O_RC1).
  //   주의: 같은 proc 을 가리키는 excel/SEARCH 버튼은 SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 권한행이 없어 403.
  //     main/GET_SHIPMENT_PLAN_DETAIL_EXCEL 은 동일 proc 이면서 ADMIN/SSP Planner 에 권한 등록됨(DB 실측 2026-10-15).
  //   응답 커서 o_rc1 행 키(DIVISION_ID/COMPANY_ID/FROM_SITE/ITEM_ID/YYYYMMDD/QTY)가 FORM_COLUMNS.key 와 일치.
  const handleExcelFormDownload = async () => {
    try {
      // AS-IS p_non_chk 파생 — 4체크박스 모두 미선택이면 'Y'(권한없음 숨김 포함, cs:6362~6372).
      const nonChk =
        !sc.chkMyModel && !sc.chkPartLeader && !sc.chkTeamLeader && !sc.chkDelegateeModel
          ? 'Y'
          : 'N';
      const res = await apiClient.post<{
        O_RC1?: Record<string, string | number | null>[];
        o_rc1?: Record<string, string | number | null>[];
      }>(
        `/${MENU_ID}/${SHEETS.MAIN}/GET_SHIPMENT_PLAN_DETAIL_EXCEL/call-proc`,
        {
          divisionId: sc.divisionId,
          companyId: sc.companyId,
          fromSite: sc.fromSite.join(','), // 다중선택 CSV(미선택='')
          itemId: sc.detailItemId, // txtItemId2
          modelId: sc.detailModelId.toUpperCase(), // txtModel2 (AS-IS ToUpper 없음이나 FE detail 축 규약 유지)
          nickName: sc.detailNickName.toUpperCase(), // txtNickName2
          requestor: sc.detailRequestor, // txtRequestor
          planStartYyyymmdd: sc.planDateYyyymmdd,
          fromYyyymmdd: sc.planDetailShipFrom, // drpPeriod2 Text1
          toYyyymmdd: sc.planDetailShipTo, // drpPeriod2 Text2
          dblFlag: 'N', // AS-IS p_dbl_flag="N"
          realFlag: realFlag ? 'Y' : 'N',
          language: session.langCd ?? '',
          programId: PROGRAM_ID,
          sheetName: ADMIN_SHEET_NAME[SHEETS.PLAN_DETAIL] ?? '', // AS-IS "Shipment Plan Detail"
          nonChk,
          myModelChk: sc.chkMyModel ? 'Y' : 'N',
          delegateeChk: sc.chkDelegateeModel ? 'Y' : 'N',
          partLeaderChk: sc.chkPartLeader ? 'Y' : 'N',
          teamLeaderChk: sc.chkTeamLeader ? 'Y' : 'N',
          userId: session.userId ?? '',
          debugMode: 'F',
        }
      );
      // false-success 판별(인터셉터가 500/403 도 resolve) — 실패 시 빈 양식으로 폴백하지 않고 알림.
      if (res.status >= 400 || Number(res.data?.code)) {
        void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred.') });
        return;
      }
      // 주의: 이 call-proc(main/GET_SHIPMENT_PLAN_DETAIL_EXCEL)은 커서 키를 대문자 O_RC1 로 반환한다
      //   (메인/상세 call-proc 은 소문자 o_rc1). 변환 경로가 달라 양쪽 대비(DB 실측 2026-10-15).
      const rows = res.data.result?.O_RC1 ?? res.data.result?.o_rc1 ?? [];
      await GridAction.flatExcelDownload(rows, FORM_COLUMNS, TEMPLATE_EXCEL_PREFIX);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred.') });
    }
  };

  // Excel Upload 저장 콜백(mode=1) — 검증(mode=0) 통과분 DB 적재. 모달이 검증 OK·오류 0건 뒤에만 호출.
  //   UPLOAD_SAVE/call-proc 로 PKG_SSP0023.P_SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD 을 mode>0 으로 재호출한다
  //   (정본 distribution-route onSave). 결과 커서는 SCP0005 동형 CODE/MSG/EVENT — CODE='0' 만 성공.
  const handleExcelUploadSave = async (): Promise<{ ok: boolean; message?: string }> => {
    // P_PROGRAM_ID='SSP0023' · P_SHEET_NAME='Shipment Plan(Electrode)' · P_CREATED_BY=세션 = mode=0 스테이징 키와 동일.
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.MAIN]}/UPLOAD_SAVE/call-proc`,
        {
          mode: 1,
          createdBy: session.userId,
          programId: MENU_ID,
          sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN],
        }
      );
      const code = Number((res.data as { code?: string })?.code ?? 0);
      const inner = (res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] })
        ?.o_result_cursor?.[0];
      // SP 반환 CODE!='0' = 실패(전량 게이트 위반 등) — MSG passthrough
      if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
        return { ok: false, message: inner?.MSG || (res.data as { message?: string })?.message };
      }
      excelUploadSavedRef.current = true;
      return { ok: true };
    } catch (e) {
      return { ok: false, message: e instanceof Error ? e.message : undefined };
    }
  };

  // Excel Upload 팝업 닫힘 — AS-IS btnExcelUpload_Click: 저장 여부와 무관하게 재조회 확인(MSG00265),
  //   Yes 면 하단을 Plan Detail 로 전환해 Detail(FindData_Detail) · Main(FindData_Main) 재조회.
  const handleExcelUploadClose = () => {
    setOpenExcelUpload(false);
    if (!excelUploadSavedRef.current) return;
    excelUploadSavedRef.current = false;
    void setAlert({
      type: 'confirm',
      content: t('MSG00265', '_Excel upload completed. Reloading data.'),
      onConfirm: () => {
        if (!sc.divisionId || !sc.companyId || !sc.planDateYyyymmdd || !sc.periodFrom) return;
        setActiveDetailSheet(SHEETS.PLAN_DETAIL);
        setDetailFilter(SHEETS.PLAN_DETAIL, 'N');
        void fetchStaticColumns([SHEETS.PLAN_DETAIL]);
        runMainSearch();
      },
    });
  };

  const customButtons = [
    // Measure (btnMeasure — hook #120). Edit 버튼 미노출(convert-core §2.4 — SwitchLock 잠금토글 미이식, canEdit 는 편집계 권한 게이트).
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Simulation (btnSimulation — AS-IS 분리 버튼 복원, 2026-10-16 사용자 결정). Main siMain SIMU 저장 전용.
    //   SAVE(F7)=Detail 확정 저장과 역할 분리 — AS-IS 가 Simulation/Save 를 별개 버튼으로 둔 어포던스 1:1 재현.
    //   권한 = main/SAVE_SHIPMENT_PLAN_SIMU 버튼 코드(SCM_ADM_MNU_BTN_MPG_M 기등록, DB 실측).
    ...(hasButton('SAVE_SHIPMENT_PLAN_SIMU')
      ? [
          {
            label: t(LBL.SIMULATION, '_Simulation'),
            title: t(LBL.SIMULATION, '_Simulation'),
            action: handleSimulation,
          },
        ]
      : []),
    // Excel Form(양식 다운로드) → Excel Upload 순 (정본 SCP0005/distribution-route). Excel Form 은 현재 조회조건으로
    //   DETAIL_EXCEL SP 를 조회해 결과를 채워 내려보낸다(AS-IS 파리티). 업로드 권한(UPLOAD)에 함께 게이트.
    //   Excel Upload 는 2-phase 체인(mode=0 검증 → onSave mode=1 적재).
    ...(hasButton('UPLOAD')
      ? [
          {
            label: t(LBL.EXCEL_FORM, '_Excel Form'),
            action: () => void handleExcelFormDownload(),
            iconComponent: <FileExceldownloadIcon />,
            iconPosition: 'leading' as const,
          },
          {
            label: t(LBL.EXCEL_UPLOAD, '_Excel Upload'),
            action: () => setOpenExcelUpload(true),
            iconComponent: <FileExceluploadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanElectrodeForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onModelSearch={() => setOpenModel(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanElectrode'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 분할 (01 §1, 비율 55:45).
          자매 Shipment Plan(Mobility & IT)과 동일하게 경계를 드래그해 상하 크기 조절(react-resizable-panels). */}
      <div className={styles.gridArea}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel defaultSize='55%' minSize='15%'>
            <div className={styles.mainGrid}>
              {/* 단일 master 그리드 — 시트가 1개뿐이라 시트명 탭을 두지 않고 그리드를 직접 렌더한다(사용자 결정 2026-10-11).
                  BOH 3-radio(UOM Type) / Sum / Past Period 토글은 조회조건 영역(Form extraConditions)으로
                  이전 — AS-IS usrConditionPanel1 영역2 복원(01 §1). 재조회 없이 컬럼 표시규칙만 전환(03 §2.2). */}
              <ShipmentPlanElectrodeMainGrid
                rows={mainRows}
                calendar={calendarRows}
                gridRef={mainGridRef}
                gridFilterRef={mainGridFilterRef}
                editTrackerRef={mainEditTrackerRef}
                adminColumns={staticColumns[SHEETS.MAIN]}
                bucketType={sc.bucketType}
                bohRadio={sc.bohRadio}
                chkSum={sc.chkSum}
                chkPastPeriod={sc.chkPastPeriod}
                editable={mainEditable}
                curPlanDate={sc.planDateYyyymmdd}
                periodTo={sc.periodTo}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          <Panel defaultSize='45%' minSize='15%'>
            <div className={styles.detailArea}>
              <ShipmentPlanElectrodeDetailBar
                onDetailSearch={handleDetailSearch}
                onItemSearch2={() => setOpenDetailItem(true)}
                onModelSearch2={() => setOpenDetailModel(true)}
                onRequestorSearch={() => setOpenRequestor(true)}
              />
              <ShipmentPlanElectrodeDetailGrid
                rowsBySheet={rowsBySheet}
                gridRefs={{
                  [SHEETS.PLAN_DETAIL]: planDetailGridRef,
                  [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
                  [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
                }}
                gridFilterRefs={{
                  [SHEETS.PLAN_DETAIL]: planDetailGridFilterRef,
                  [SHEETS.STOCK_DETAIL]: stockDetailGridFilterRef,
                  [SHEETS.SHIPMENT_RESULT]: shipmentResultGridFilterRef,
                }}
                editTrackerRefs={{
                  [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
                }}
                staticColumns={staticColumns}
                editable={detailEditable}
                onOrderDetail={setOrderDetailCtx}
              />
            </div>
          </Panel>
        </PanelGroup>
      </div>

      {/* Material 검색 (btnItemId) — 공용 MaterialByDivisionModal(COM0013, 사용자 지시 2026-10-22, Model/Nickname
          과 동일 팝업). 단건. 빈 반환 시 기존값 유지. Division 단일이라 multiDivision 불요. 한계: 이 모달엔
          Site 축이 없어 기존 팝업이 넘기던 From Site 사전필터는 빠진다(SSP0003 전환 동일 기록). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchCondition({ itemId: items });
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />

      {/* Model/Nickname 검색 (상단, 사용자 지시 2026-10-22) — 공용 MaterialByDivisionModal. Model + NickName
          통합 칸. 선택 → 품번(ITEM_ID)=modelId + 첫 행 NICK_NAME=nickName 둘 다 세팅(메인 GET SP p_model_id +
          p_nick_name 양쪽). 빈 반환 시 기존값 유지. */}
      <MaterialByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        // 칸에 보이는 값만 조회조건으로 쓴다(2026-10-23). 첫 행 닉네임 숨은 조건 제거.
        // setSelectedValue={(items, _itemName, _itemClassName, nickName) => {
        //   if (items) setSearchCondition({ modelId: items, nickName: nickName ?? '' });
        // }}
        setSelectedValue={items => {
          if (items) setSearchCondition({ modelId: items, nickName: '' });
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.modelId,
        }}
      />

      {/* 2차 Material 검색 (btnItemId2 — 상세행 txtItemId2) — 공용 MaterialByDivisionModal(사용자 지시 2026-10-22).
          3-sheet 공통. 단건. 빈 반환 시 기존값 유지. */}
      <MaterialByDivisionModal
        open={openDetailItem}
        modalClose={() => setOpenDetailItem(false)}
        setSelectedValue={items => {
          if (items) setSearchCondition({ detailItemId: items });
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.detailItemId,
        }}
      />

      {/* 2차 Model/Nickname 검색 (하단, 사용자 지시 2026-10-22) — 공용 MaterialByDivisionModal. 선택 → 품번=
          detailModelId + 첫 행 NICK_NAME=detailNickName 둘 다 세팅(PlanDetail 상세 SP p_model_id + p_nick_name).
          주의: StockDetail 조회 SP 엔 model 파라미터가 없어 StockDetail 에선 nickName 만 적용된다(품번은 Material 칸). */}
      <MaterialByDivisionModal
        open={openDetailModel}
        modalClose={() => setOpenDetailModel(false)}
        // 칸에 보이는 값만 조회조건으로 쓴다(2026-10-23). 첫 행 닉네임 숨은 조건 제거.
        // setSelectedValue={(items, _itemName, _itemClassName, nickName) => {
        //   if (items) setSearchCondition({ detailModelId: items, detailNickName: nickName ?? '' });
        // }}
        setSelectedValue={items => {
          if (items) setSearchCondition({ detailModelId: items, detailNickName: '' });
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.detailModelId,
        }}
      />

      {/* Requestor 검색 (btnRequestor — PlanDetail 상세행 txtRequestor) — 공용 SsoUserModal
          (AS-IS UserInfoPopup, SSOUserYN=false → ssoUserYn='N'). 자매 Mobility&IT 와 동일 공통 팝업(2026-10-14).
          AS-IS p_requestor 는 표시명(UserName)을 전달 → 언어별(KO:UserName / EN:UserName_E) 표시명을
          detailRequestor 에 싣는다(cs:1832~1838). */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        initialUser={sc.detailRequestor}
        ssoUserYn='N'
        setSelectedValue={(userId, userNm, userEngNm) => {
          const name = (session.langCd === 'KO' ? userNm : userEngNm) || userId;
          setSearchCondition({ detailRequestor: name });
          setOpenRequestor(false);
        }}
      />

      {/* Measure 설정 (btnMeasure — AS-IS TitleSetForm(Measure)).
          종전에는 공용 ColumnSettingModal 에 columnType='M' 만 끼워 썼는데, 그 팝업의 조회 proc
          (DMF0002_GET_TITLESET_POPUP)은 목록 원천이 SCM_MST_SHEET_COLUMNS 라 Measure 를 못 내리고
          division 조건(C.DIVISION_ID 가 NULL) 때문에 SSP0023 에서는 0건이었다 — 사용자 신고
          "셋팅되는 데이터가 없어". 공통 MeasureSelectModal(features/master) + /measure 엔드포인트로 교체했다.
          데이터 원천이 SCM_MST_SHEET_MEASURE(/admin/menu/{id}/measure)라 Measure 를 그대로 내린다.
          onApply codes 는 공통본 시그니처상 string[] | null(null=전체표시 복원)이라 ?? [] 로 가드한다.
          OK 시 titleSet 'M' 영구 저장 후 spdMain 활성 경로만 재조회 */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? '',
            columnType: TITLESET_MEASURE_TYPE,
            rows: (codes ?? []).map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t(MSG.SAVE_FAILED, '__Save failed.') });
              return;
            }
            void fetchStaticMeasures();
            if (activeGrid === 'main' && filters[SHEETS.MAIN]) void refetchMain();
          });
        }}
      />

      {/* Excel 업로드 팝업 (btnExcelUpload — 검증 mode=0 → onSave mode=1 적재 2-phase, 완료 후 재조회).
          정본 distribution-route(SCP0005). shtNm 은 SHEET_NAME(ADMIN_SHEET_NAME[SHEETS.MAIN]) — 모달 내부에서 사용. */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={handleExcelUploadClose}
        // 이전: 저장 성공 시 Main 만 재조회. AS-IS 는 닫힘 후 MSG00265 확인 → Detail · Main 재조회.
        // onUploaded={() => {
        //   if (filters[SHEETS.MAIN]) void refetchMain();
        // }}
        onSave={handleExcelUploadSave}
      />

      {/* ERP Order Detail 팝업 (PlanDetail ERP_SO_NO/PO No 더블클릭 — 표시전용, AS-IS SSP0300) */}
      <OrderDetailModal
        open={orderDetailCtx !== null}
        data={orderDetailCtx}
        onClose={() => setOrderDetailCtx(null)}
      />
    </>
  );
};
