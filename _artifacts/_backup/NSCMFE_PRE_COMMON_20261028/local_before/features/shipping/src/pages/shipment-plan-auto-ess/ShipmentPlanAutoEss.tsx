import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  ItemByDivisionModal,
  MaterialByDivisionModal,
  MeasureSelectModal,
  ProjectByDivisionModal,
} from 'features/master/src/components';
import {
  ConfirmDetailModal,
  OrderDetailModal,
  type OrderDetailContext,
} from 'features/shipping/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation, useQuery } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, saveTitleSet, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import {
  registerDirtyCheck,
  registerDirtyReset,
  useMessageStore,
  useSessionStore,
} from '@shared/stores';

import { ShipmentPlanAutoEssDetailBar } from './components/ShipmentPlanAutoEssDetailBar';
import { ShipmentPlanAutoEssDetailGrid } from './components/ShipmentPlanAutoEssDetailGrid';
import { ShipmentPlanAutoEssForm } from './components/ShipmentPlanAutoEssForm';
import { ShipmentPlanAutoEssMainGrid } from './components/ShipmentPlanAutoEssMainGrid';
import {
  ADMIN_SHEET_NAME,
  CONFIRM_DETAIL_SHEET,
  LBL,
  MENU_ID,
  MSG,
  ORDER_DETAIL_BTN,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  SHEETS,
  STANDARD_MANUAL_URL,
  TITLESET_MEASURE_TYPE,
  USER_CHECK_BTN,
} from './shipment-plan-auto-ess.constants';
import type { MainRow } from './shipment-plan-auto-ess.types';
import styles from './ShipmentPlanAutoEss.module.scss';
import { useShipmentPlanAutoEssStore } from './useShipmentPlanAutoEssStore';
import {
  BOH_DRILLDOWN,
  DETAIL_SHEETS,
  measureDrilldownOf,
} from './utils/shipment-plan-auto-ess.detailSheets';
import {
  collectConfirmSaveRows,
  type ConfirmSaveFolded,
} from './utils/shipment-plan-auto-ess.save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 SP 업무결과 'X'(기준정보 미등록) 센티넬 — assertSaveResult 가 이 메시지로 던지면 handleSaveError 가
//   일반 실패(F)와 구분해 MSG01321(예/아니오)+매뉴얼 열람으로 처리한다(AS-IS SaveData_Detail cs L2736).
const SAVE_RESULT_X = 'SSP_SAVE_RESULT_X';

// AS-IS GSCM.SSP.Plan.UIL SSP0021_ShipmentPlan (Shipment Plan) — 신규 전환(2026-09-27).
//   설계: .atlas/gscm-design/SSP0021/design/00~03. 매핑: __asis-mapping__.md. 자매 SSP0060 패턴 준용.
//   툴바: Find/Save/Insert=실동작, Delete=NO-OP `() => undefined`(design 01 §2 — 노출 유지, false·키생략 금지),
//   Edit=미이식(convert-core §2.4 — 편집 기본 ON, canEdit=hasButton('EDIT')).
//   저장 = Detail Confirm 만(design 01 §2 SaveData_Detail / 03 §4.1) — Main SHIP_PLAN 편집은 Simulation 입력.
//   주의: Drafting 3경로 ERP IF 체인·Hold stock 편집은 SP 미배포 — 04_react-gap.md "확인 필요/SP 후속" 참조.
export const ShipmentPlanAutoEss = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // 알림 메시지 포맷 — 공용 카탈로그(SCM_ADM_MSG_M → locales)에 '{0}' 치환자와 **이스케이프된 '\n\r'**
  //   (JSON 이중 이스케이프라 파싱 후 리터럴 백슬래시-n)이 섞여 있다. 그대로 t() 결과를 알림 content 로
  //   쓰면 (1) i18next 보간은 {{...}} 형식이라 '{0}' 가 글자로 노출되고 (2) 알림창은 white-space:pre-line
  //   이라 리터럴 '\n' 이 개행이 아니라 글자 "\n" 으로 보인다(사용자 신고 2026-10-20 — Shipment Qty 수정 후
  //   저장 시 MSG01289 깨짐). 여기서 {0} 치환 + '\r' 제거 + 리터럴 '\n' → 실제 개행으로 정규화한다.
  const fmtMsg = useCallback(
    (code: string, fallback: string, arg0?: string): string => {
      const raw = arg0 === undefined ? t(code, fallback) : t(code, fallback).replace('{0}', arg0);
      return raw.replace(/\\r/g, '').replace(/\\n/g, '\n');
    },
    [t]
  );

  // ── refs (Main + Detail 7-sheet) ──
  const mainGridRef = useRef<FlexGridType>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const mainEditTrackerRef = useRef<EditTracker>();
  const planDetailGridRef = useRef<FlexGridType>();
  const planDetailGridFilterRef = useRef<FlexGridFilter>();
  const planDetailEditTrackerRef = useRef<EditTracker>();
  const stockDetailGridRef = useRef<FlexGridType>();
  const stockDetailGridFilterRef = useRef<FlexGridFilter>();
  const owmsDetailGridRef = useRef<FlexGridType>();
  const owmsDetailGridFilterRef = useRef<FlexGridFilter>();
  const holdStockGridRef = useRef<FlexGridType>();
  const holdStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockGridRef = useRef<FlexGridType>();
  const mesStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockDetailGridRef = useRef<FlexGridType>();
  const mesStockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanAutoEssStore(s => s.searchCondition);
  const set = useShipmentPlanAutoEssStore(s => s.setSearchCondition);
  const filters = useShipmentPlanAutoEssStore(s => s.filters);
  const setMainFilters = useShipmentPlanAutoEssStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanAutoEssStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanAutoEssStore(s => s.clearFilters);
  const restoreSearchConditions = useShipmentPlanAutoEssStore(s => s.restoreSearchConditions);
  const openSearchArea = useShipmentPlanAutoEssStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanAutoEssStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanAutoEssStore(s => s.realFlag);
  const activeGrid = useShipmentPlanAutoEssStore(s => s.activeGrid);
  const activeDetailSheet = useShipmentPlanAutoEssStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanAutoEssStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanAutoEssStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanAutoEssStore(s => s.fetchStaticColumns);
  const staticMeasures = useShipmentPlanAutoEssStore(s => s.staticMeasures);
  const fetchStaticMeasures = useShipmentPlanAutoEssStore(s => s.fetchStaticMeasures);
  const visibleMeasures = useShipmentPlanAutoEssStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useShipmentPlanAutoEssStore(s => s.applyVisibleMeasures);
  const initialized = useShipmentPlanAutoEssStore(s => s.initialized);

  const session = useSessionStore(st => st.session);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // R7a(Edit 진입 가드① — 자매 SSP0060 에서 이식) — AS-IS EditButton 첫 가드:
  //   `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }`
  //   (SSP0021_ShipmentPlan.cs L2358~2368). GetSSPUserCheck(cs L5836~5858)은
  //   `SSP.SSP0002_GET_USER_INFO_LIST` 를 Search=UserId / Language / SSOUserYN='N' 로 호출해
  //   **0행이면 false**(= GSCM 미등록 사용자)다. 자매 SSP0060(cs L8011~8033)과 의미 동일하다.
  //   TO-BE 등가 = USER_CHECK call-proc(PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST).
  //   판정 전(undefined)에는 낙관적 허용 — 로드 중 불필요한 편집 차단을 만들지 않는다.
  //   비SSP 확정(false) 시에만 편집 차단(canEdit=false). 진입 알럿은 띄우지 않는다(아래 참조).
  const { data: sspUserCheck } = useQuery({
    queryKey: [tabId, 'sspUserCheck', session.userId],
    queryFn: async () => {
      try {
        const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/${USER_CHECK_BTN}/call-proc`, {
          userId: session.userId ?? '',
          language: session.langCd ?? '',
          ssoUserYn: 'N',
        });
        // 403 = USER_CHECK 버튼권한 없음 = 비SSP 사용자(@AuthCheck 차단)
        if (res.status >= 400 || Number(res.data?.code)) return false;
        const rows = (res.data?.result as { o_rc1?: unknown[] })?.o_rc1 ?? [];
        return rows.length > 0;
      } catch {
        return false;
      }
    },
    enabled: !!session.userId,
    staleTime: Infinity,
  });
  // 편집 가드만 유지하고 진입 알럿(MSG01261)은 띄우지 않는다 — 비SSP(예: SSP Viewer)는 EDIT 버튼
  //   권한도 없어 버튼이 뜨지 않고 편집도 막히므로 진입 즉시 알림이 불필요하다(사용자 지시 2026-10-22,
  //   SSP0015 와 동일 방침). AS-IS 도 이 메시지는 Edit 버튼 클릭 시에만 떴다.
  const isSspUser = sspUserCheck !== false;

  // 편집 가능 = 권한(canEdit = hasButton('EDIT'), 마운트 1회) · 최신 Plan(realFlag).
  //   AS-IS EditButton/SwitchLock '수정 모드' 토글은 이식하지 않는다(convert-core §2.4). 편집 기본 ON.
  //   R7a(isSspUser)는 권한 축이라 canEdit 에 합산한다 — AS-IS 가드① 과 동일하게 비SSP 는 전면 읽기전용.
  const canEdit = hasButton('EDIT') && isSspUser;
  // Main(PSI) 그리드는 **읽기전용**이다 — AS-IS 가 하드 차단한다(사용자 확인 2026-10-12).
  //   `SSP0021_ShipmentPlan.cs` EditButton() L2370~2375:
  //       if (fps.Name == "spdMain") {
  //           // jilee 231004
  //           MessageHelper.GMessageBox("MSG00109", null);   // "읽기 전용입니다."
  //           return;                                        // ← 무조건 return
  //           CanModelChange = false;                        // 이하 전부 도달 불가(死코드)
  //           if (bEdit_Auth == true) { ... LockRange(..., false) ... }
  //       }
  //   2023-10-04(jilee)에 들어간 무조건 return 이라 그 아래 `bEdit_Auth` 분기와 unlock 로직은
  //   전부 死코드다. 즉 **어떤 권한/그룹이어도 Main 은 편집 불가**이고, 이 화면은 조회성 화면이다.
  //   (design 03 §1.2 의 "Main SHIP_PLAN 편집 유일"·"편집 → Simulation → Detail Confirm 저장"은
  //    2023-10 차단 이전 기준의 낡은 기술이다.)
  //   Detail 은 그대로 둔다 — 같은 EditButton 의 else 분기(cs L2459~)가 spdDetail 에 대해
  //   `SwitchLock()` + LockColumn/LockRange 로 정상 편집을 연다. 차단은 spdMain 한정이다.
  const mainEditable = false;
  const detailEditable = canEdit && realFlag;

  // ── 모달 open state (페이지 소유) ──
  const [openItemMain, setOpenItemMain] = useState(false); // 1차 Model(btnItemId)
  const [openItemDetailBar, setOpenItemDetailBar] = useState(false); // 2차 Model(btnItemID2)
  const [openRequestor, setOpenRequestor] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false); // TitleSetForm(Measure — btnMeasure)
  const [cellPopupRow, setCellPopupRow] = useState<WijmoRowItem | null>(null);
  const [cellPopupKind, setCellPopupKind] = useState<'item' | 'project' | null>(null);
  // ERP Order Detail 팝업(SSP0300) — Shipment Plan Detail 의 ERP_SO_NO 더블클릭 컨텍스트.
  const [orderDetail, setOrderDetail] = useState<OrderDetailContext | null>(null);
  const [confirmDetailNo, setConfirmDetailNo] = useState(''); // CHANGE_REQ_NO 더블클릭(Request Info 팝업)

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
  const { data: planDetailData } = useTabProcQuery<MENU_ID, SHEETS.PLAN_DETAIL>({
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
  const { data: owmsDetailData } = useTabProcQuery<MENU_ID, SHEETS.OWMS_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.OWMS_DETAIL,
    tabId,
    filters: filters[SHEETS.OWMS_DETAIL],
    enabled: !!filters[SHEETS.OWMS_DETAIL],
  });
  const { data: holdStockData } = useTabProcQuery<MENU_ID, SHEETS.HOLD_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.HOLD_STOCK,
    tabId,
    filters: filters[SHEETS.HOLD_STOCK],
    enabled: !!filters[SHEETS.HOLD_STOCK],
  });
  const { data: mesStockData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK,
    tabId,
    filters: filters[SHEETS.MES_STOCK],
    enabled: !!filters[SHEETS.MES_STOCK],
  });
  const { data: mesStockDetailData } = useTabProcQuery<MENU_ID, SHEETS.MES_STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.MES_STOCK_DETAIL,
    tabId,
    filters: filters[SHEETS.MES_STOCK_DETAIL],
    enabled: !!filters[SHEETS.MES_STOCK_DETAIL],
  });
  const { data: shipmentResultData } = useTabProcQuery<MENU_ID, SHEETS.SHIPMENT_RESULT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SHIPMENT_RESULT,
    tabId,
    filters: filters[SHEETS.SHIPMENT_RESULT],
    enabled: !!filters[SHEETS.SHIPMENT_RESULT],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  const rowsBySheet = useMemo(
    () => ({
      [SHEETS.PLAN_DETAIL]: (planDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.STOCK_DETAIL]: (stockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.OWMS_DETAIL]: (owmsDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.HOLD_STOCK]: (holdStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK]: (mesStockData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.MES_STOCK_DETAIL]: (mesStockDetailData?.o_rc1 ?? []) as WijmoRowItem[],
      [SHEETS.SHIPMENT_RESULT]: (shipmentResultData?.o_rc1 ?? []) as WijmoRowItem[],
    }),
    [
      planDetailData,
      stockDetailData,
      owmsDetailData,
      holdStockData,
      mesStockData,
      mesStockDetailData,
      shipmentResultData,
    ]
  );

  // ── 저장 — Detail Confirm 만(design 01 §2 SaveData_Detail / 03 §4.3) ──
  //   proc P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM(24 IN)은 전건 VARCHAR + SCM_ARR_SPL_CNT('^') WHILE LOOP
  //   다건 처리라, 공용 useProcMutation 의 행 객체 배열({data:[]}) 전송은 전건 null 바인딩 →
  //   P_ACTIVE_FLAG 빈값 → 루프 0회 → 0행 UPDATE 인데 성공 반환(false-success)이었다(사용자 신고
  //   2026-10-20 "저장했는데 재조회하면 그대로"). 그래서 편집 행을 컬럼별 '^'-폴딩 단일 객체
  //   (collectConfirmSaveRows, 키=SCM_ADM_PROC_M COL_NM camelCase)로 조립해 apiClient.post 로 직배선한다
  //   (자매 SSP0060 ShipmentPlan.tsx 동일 처방, memory `save-proc-per-column-caret-fold-fe`).
  //   assertSaveResult 로 업무결과(o_rc1 RESULT_CODE!='S')까지 검사해 false-success 를 2중으로 막는다.
  const assertSaveResult = (data: unknown): void => {
    const result = (
      data as {
        result?: {
          o_rc1?: { RESULT_CODE?: unknown; ERR_MESSAGE?: unknown }[];
          o_rc2?: { ERR_MESSAGE?: unknown }[];
        };
      }
    )?.result;
    const rc = result?.o_rc1?.[0];
    const resultCode = str(rc?.RESULT_CODE);
    // 'X' = 기준정보(BOD/route) 미등록 — AS-IS SaveData_Detail(cs L2736) 는 일반 실패(MSG00284)와 달리
    //   MSG00324(route 미등록)를 예/아니오로 띄우고 '예' 면 매뉴얼을 연다. 센티넬로 구분해 던진다.
    if (resultCode === 'X') {
      throw new Error(SAVE_RESULT_X);
    }
    if (resultCode && resultCode !== 'S') {
      const errMsg = str(rc?.ERR_MESSAGE) || str(result?.o_rc2?.[0]?.ERR_MESSAGE);
      throw new Error(errMsg || t(MSG.SAVE_FAILED, '__Save failed.'));
    }
  };

  // AS-IS AddHelpButton(BaseForm.cs L3501→FileDownLoad L3406) 대응 — 사내 Help 서버의
  //   'Standard Information SSP Manual.pptx'(STANDARD_MANUAL_URL)를 새 탭으로 열어 바로 내려받는다.
  const openStandardManual = (): void => {
    window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer');
  };

  // 저장 결과 오류 공통 처리 — 'X'(기준정보 미등록)는 AS-IS 처럼 MSG01321(예/아니오) 후 '예' 면 매뉴얼
  //   열람, 그 외 실패는 일반 알림(AS-IS MSG00284 대응).
  const handleSaveError = (error: Error): void => {
    if (error.message === SAVE_RESULT_X) {
      void setAlert({
        type: 'confirm',
        content: t(MSG.STD_INFO_NOT_REGISTERED, '_기준정보가 등록되어 있지 않습니다. 참고자료를 열람하시겠습니까?'),
        onConfirm: openStandardManual,
      });
      return;
    }
    void setAlert({ type: 'alert', content: error.message || t(MSG.SAVE_FAILED, '__Save failed.') });
  };
  const { mutate: mutateConfirm } = useMutation({
    mutationKey: [tabId, SHEETS.PLAN_DETAIL, 'SAVE'],
    mutationFn: async (payload: ConfirmSaveFolded) => {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.PLAN_DETAIL}/SAVE/call-proc`, payload);
      // false-success 판별 (np §5-10 — 인터셉터가 500/403 도 resolve)
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      assertSaveResult(res.data);
      return res.data;
    },
    onSuccess: () => {
      planDetailEditTrackerRef.current?.clearChanges();
      // 편집 기본 ON(convert-core §2.4) — 저장 후 조회모드 복귀 없음.
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      setDetailFilter(SHEETS.PLAN_DETAIL, 'N');
    },
    onError: handleSaveError,
  });

  // ── mount — SubTitle F6 저장 조회조건 복원(1회, conditionsRestored 가드) ──
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // 상단(Main) 조회 dirty 가드 전용 키 — 공용 SearchArea/SubTitle 은 기본 tab 전역 키로 "탭 내 아무
  //   그리드나 dirty" 를 묻는데, 상단 조회는 Main 그리드만 재조회(setMainFilters)하므로 Main 만 확인해야
  //   한다(사용자 지시 2026-10-20). Main 그리드를 이 그리드 단위 키에 별도 등록하고, Form/SubTitle 에
  //   searchDirtyKey 로 넘겨 그 키로만 가드하게 한다. tab 키 등록(DataGrid 자동)은 그대로라 탭 닫기 가드는 불변.
  const mainDirtyKey = `grid:${tabId}:main`;
  useEffect(() => {
    const unCheck = registerDirtyCheck([mainDirtyKey], () =>
      GridUtils.isDirty(mainGridRef.current)
    );
    const unReset = registerDirtyReset([mainDirtyKey], () =>
      GridAction.discardChanges(mainGridRef.current, mainEditTrackerRef.current)
    );
    return () => {
      unCheck();
      unReset();
    };
  }, [mainDirtyKey]);

  // ── mount — keep-alive 잔여 filters 무효화 + 컬럼 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    if (!initialized) {
      // 마운트 1회 — Main + **전 Detail 시트** 컬럼 메타를 받아, 조회 전에도 모든 하단 탭에
      //   컬럼 헤더가 보이게 한다(사용자 신고 2026-10-16 "첫 탭 외 다른 탭은 조회 전 헤더 없음").
      //   컬럼 메타(SCM_MST_SHEET_COLUMNS)는 데이터와 무관하므로 탭 자동조회 금지 규칙과 무관.
      void fetchStaticColumns([SHEETS.MAIN, ...DETAIL_SHEETS]);
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Division/Company 변경 = 편집 상태 초기화 (np §5-5). filters 초기화는 store 가 수행 ──
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();
  }, [sc.divisionId, sc.companyId]);

  // ── Find (F5 — FindData_Main) ──
  const runMainSearch = () => {
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
    void fetchStaticMeasures();
  };

  const handleSearch = () => {
    // 필수 4종 (design 02 §4.1 — Division*/Company*/Period*/Plan Date*)
    if (!sc.divisionId || !sc.companyId || !sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 미저장 변경이 있으면 재조회 전 확인(MSG00703)
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

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회, hook #81 lazy) ──
  //   미저장 편집 재조회 가드 — 종전엔 확인 없이 바로 재조회해 편집분이 조용히 날아갔다(사용자 신고
  //   2026-10-20). **조회 대상 그리드만** 확인한다: 2차 Search 는 활성 detail sheet 만 재조회하므로 그
  //   sheet 그리드의 dirty 만 본다 — 상단(main)이나 다른 detail 탭이 수정 중이어도 묻지 않는다.
  //   확인(버림) 시 그 그리드의 변경만 되돌린다(discardChanges) — 다른 그리드 편집은 보존.
  const handleDetailSearch = () => {
    const gridBySheet: Partial<Record<SHEETS, typeof planDetailGridRef>> = {
      [SHEETS.PLAN_DETAIL]: planDetailGridRef,
      [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
      [SHEETS.OWMS_DETAIL]: owmsDetailGridRef,
      [SHEETS.HOLD_STOCK]: holdStockGridRef,
      [SHEETS.MES_STOCK]: mesStockGridRef,
      [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridRef,
      [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
    };
    const run = () => {
      setDetailFilter(activeDetailSheet, 'N');
      void fetchStaticColumns([activeDetailSheet]);
    };
    const grid = gridBySheet[activeDetailSheet]?.current;
    if (!grid || !GridUtils.isDirty(grid)) {
      run();
      return;
    }
    void setAlert({
      type: 'confirm',
      content: t('MSG00704', '_작업중인 데이터가 있습니다. 조회 하시겠습니까?'),
    }).then(ok => {
      if (!ok) return;
      GridAction.discardChanges(
        grid,
        activeDetailSheet === SHEETS.PLAN_DETAIL ? planDetailEditTrackerRef.current : undefined
      );
      run();
    });
  };

  // ── Main 드릴다운 (design 03 §3.7 — BOH_TYPE / MEASURE 분기) ──
  const handleMainDrilldown = (row: MainRow, binding: string) => {
    const overrides = { itemId: str(row.ITEM_ID), fromSite: str(row.FROM_SITE) };
    if (binding === 'BOH_QTY' && str(row.BOH_TYPE) === 'MES') {
      // MES 는 MES Stock Detail + MES Stock 2-sheet 연속 조회, 활성 탭은 MES Stock (AS-IS L2062-2094)
      setDetailFilter(SHEETS.MES_STOCK_DETAIL, 'Y', overrides);
      setActiveDetailSheet(SHEETS.MES_STOCK);
      setDetailFilter(SHEETS.MES_STOCK, 'Y', overrides);
      void fetchStaticColumns([SHEETS.MES_STOCK_DETAIL, SHEETS.MES_STOCK]);
      return;
    }
    const sheet =
      binding === 'BOH_QTY' ? BOH_DRILLDOWN[str(row.BOH_TYPE)] : measureDrilldownOf(str(row.MEASURE));
    if (!sheet) return;
    setActiveDetailSheet(sheet);
    setDetailFilter(sheet, 'Y', overrides);
    void fetchStaticColumns([sheet]);
  };

  // ── Save (F7 — Detail Confirm 만. design 01 §2 SaveData_Detail) ──
  const handleSave = () => {
    // 활성 탭과 무관하게 Shipment Plan Detail 편집분을 Confirm 저장(AS-IS SaveData_Detail 은 shtPlanDetail 대상).
    if (!detailEditable) return; // 편집 불가면 조용히 무시 (AS-IS IsLock 가드)
    const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
    if (dirty.length === 0) {
      // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준)
      setToast({
        type: 'error',
        message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
      });
      return;
    }
    // 행별 필수 (design 03 §3.3): TRANSPORT_MODE 공백 / CHANGE_REASON_CODE 미선택 차단
    for (const row of dirty) {
      // 행번호(1-based) — MSG01289 "{0}열 출하 변경사항..." 의 {0} 치환용(AS-IS 행번호).
      const rowNo = (planDetailGridRef.current?.rows.findIndex(r => r.dataItem === row) ?? -1) + 1;
      if (str(row.TRANSPORT_MODE).trim() === '') {
        // MSG00429 "{0} value is required." — {0}=Trans Mode. fmtMsg 가 치환·개행 정규화.
        void setAlert({
          type: 'alert',
          content: fmtMsg(MSG.REQUIRED_VALUE, '_{0} value is required.', 'Trans Mode'),
        });
        return;
      }
      const reason = str(row.CHANGE_REASON_CODE).trim();
      if (reason === '' || reason === '-') {
        // MSG01289 — {0}=행번호 치환 + 이스케이프 개행 정규화(종전 { defaultValue } 는 카탈로그 값이
        //   우선돼 '{0}'·'\n' 이 글자로 노출됐다 — 사용자 신고 2026-10-20).
        void setAlert({
          type: 'alert',
          content: fmtMsg(
            MSG.ROW_REASON_REQUIRED,
            '_There is a shipment change in {0} row.\nPlease enter Change_Reason.',
            String(rowNo)
          ),
        });
        return;
      }
    }
    // 확인창 (design 03 §4.3 — MSG01201)
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_SAVE, {
        defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
      }),
      onConfirm: () => {
        // 편집 행 → 24 IN '^'-폴딩 단일 객체(collectConfirmSaveRows, 키=PROC_M COL_NM). dirty.length>0 확정.
        //   그리드 행 배열 그대로 전송은 proc(전건 VARCHAR + SCM_ARR_SPL_CNT 루프)에 null 바인딩돼
        //   0행 저장(false-success)이 된다 — 위 mutateConfirm 주석 참조.
        const payload = collectConfirmSaveRows(dirty, session.userId ?? '');
        if (payload) mutateConfirm(payload);
      },
    });
  };

  // ── Insert (F8 — design 01 §2 InsertButton. shtPlanDetail 신규행. Hold stock 은 표시전용이라 미대상) ──
  const handleInsert = () => {
    if (!detailEditable) return; // AS-IS IsLock 가드 — 편집 기본 ON 이라 canEdit·최신Plan 판정
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return; // 편집 시트 한정
    const g = planDetailGridRef.current;
    if (!g) return;
    const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
      | Record<string, unknown>
      | undefined;
    if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4 — 미조회 상태 삽입 결함)
    // 원본 행 STATUS 게이트 (AS-IS L2209/L2284 — RowCount>0 + SHIPMENT_STATUS!='C' return).
    //   공백도 != 'C' 라 삽입 차단(AS-IS 동일 — 공백을 'C' 로 승격하지 않는다, G10).
    const status = str(source.SHIPMENT_STATUS).trim();
    if (status !== 'C') return; // 'C' 아님(공백 포함) — 에러 없이 조용히 중단
    // 복사 필드는 AS-IS defaultData 명시 목록만 (전 필드 스프레드 복사 금지 — ERP_SO_NO/SHIPMENT_STATUS 제외)
    const copied: Record<string, unknown> = {};
    PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
      copied[col] = source[col];
    });
    copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제
    copied.ERP_STATUS = ''; // 항상 공백 강제
    GridAction.addRow(g, { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem, 'above', true);
  };

  // ── Measure (btnMeasure): spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op (design 02 §4.6) ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return;
    setOpenMeasure(true);
  };

  // Simulation 재계산 핸들러 제거 — AS-IS 에서 Main 편집이 하드 차단(EditButton L2370~2375)이라
  //   입력 경로가 없고 버튼도 노출하지 않는다(아래 customButtons 주석). 재계산 본체는
  //   utils/shipment-plan-auto-ess.calc.ts `simulate` 에 그대로 남아 있다.
  // ── 그리드 셀 팝업 (design 03 §3.7 — 신규행 한정 + 필수값 MSG00013 가드) ──
  const openCellPopup = (kind: 'item' | 'project', row: WijmoRowItem) => {
    const division = str(row.DIVISION_ID);
    const fromSite = str(row.FROM_SITE);
    const toSite = str(row.TO_SITE);
    const required =
      kind === 'item' ? [division, fromSite, toSite] : [division, fromSite, toSite, str(row.ITEM_ID)];
    if (required.some(v => v.trim() === '')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    setCellPopupRow(row);
    setCellPopupKind(kind);
  };

  // ── hotkeyConfig (design 01 §2 확정값 — 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS L2354-2356 빈 몸체) — 노출 유지 + 명시적 무동작. 키 생략·false 금지.
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Measure (btnMeasure — 아이콘 순서: GridColumnSet 없음 → Measure, hook #120)
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Simulation 버튼은 노출하지 않는다 (사용자 지시 2026-10-12).
    //   AS-IS 에 버튼 자체는 있다 — `btnSimulation`(Designer) + `BtnSimulation_Click`(cs L1869) +
    //   `Simulation()`(cs L6053). 다만 Form_Load(cs L440~458)가 `PGM_AUTH_ID` 룩업에서
    //   CODE='SSP0021' AND NAME=NowGroupID 행을 찾아 `layoutControlItem12`(= btnSimulation 을 담은
    //   레이아웃 아이템, Designer L756) 의 Visibility 를 Always/Never 로 가른다.
    //   그 룩업에는 SSP0021 행이 **3개 있다**(ADMIN · SCM Viewer · SSP Planner — AS-IS/TO-BE DB 동일
    //   실측). 즉 SSP0060(행 0개 → 전원 비노출)과 달리 **특정 그룹에는 보인다.**
    //
    //   그럼에도 제거하는 이유: 같은 `bEdit_Auth` 게이트가 걸린 Main 편집이 EditButton L2370~2375 의
    //   무조건 return 으로 2023-10-04 부터 하드 차단됐다. Simulation 은 "Main SHIP_PLAN 을 고쳐
    //   재계산"하는 기능이라 입력 경로가 사라졌다 — 읽기전용 그리드 위에서 값만 흔드는 버튼이 된다.
    //   사용자 제공 AS-IS 캡처(2026-10-12)에도 툴바에 Simulation 이 없다.
    //   재계산 본체(utils/shipment-plan-auto-ess.calc.ts `simulate`)는 지우지 않는다 — 되살릴 때
    //   이 버튼 항목만 복구하면 된다.
  ];

  const cellPopupDivision = str(cellPopupRow?.DIVISION_ID);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanAutoEssForm
          tabId={tabId}
          onSearch={handleSearch}
          onItemSearch={() => setOpenItemMain(true)}
          searchDirtyKey={mainDirtyKey}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        searchDirtyKey={mainDirtyKey}
        customButtons={customButtons}
      />

      {/* splitContainer1 — Main(상) / Detail(하) 수직 드래그 분할 (design 01 §1).
          DMF0004(SalesSite) PanelGroup 패턴 참조 — 스플릿 바(.splitBar)를 드래그해 상/하 그리드 높이 조절.
          minSize 는 픽셀(react-resizable-panels v4 — "NNpx")로 드래그 범위를 제한한다(사용자 지시 2026-10-20):
            위로는 상단 그리드 헤더(2행 병합 ~60px)를 가리지 않도록 100px, 아래로는 하단 조회조건 바
            (ShipmentPlanAutoEssDetailBar 실측 44px) + 탭 스트립을 가리지 않도록 92px 이하로는 줄지 않는다.
          초기 비율은 종전 flex 55:45 를 그대로 옮긴 defaultSize 55/45. */}
      <PanelGroup className={styles.gridArea} orientation='vertical'>
        <Panel defaultSize={55} minSize='100px'>
          <div className={styles.mainGrid}>
            <ShipmentPlanAutoEssMainGrid
              rows={mainRows}
              calendar={calendarRows}
              gridRef={mainGridRef}
              gridFilterRef={mainGridFilterRef}
              editTrackerRef={mainEditTrackerRef}
              adminColumns={staticColumns[SHEETS.MAIN]}
              staticMeasures={staticMeasures}
              bucketType={sc.bucketType}
              chkSum={sc.chkSum}
              editable={mainEditable}
              curPlanDate={sc.planDate}
              onDrilldown={handleMainDrilldown}
            />
          </div>
        </Panel>

        <PanelSeparator className={styles.splitBar} />

        <Panel defaultSize={45} minSize='92px'>
          <div className={styles.detailArea}>
            <ShipmentPlanAutoEssDetailBar
              onDetailSearch={handleDetailSearch}
              onModelSearch={() => setOpenItemDetailBar(true)}
              onRequestorSearch={() => setOpenRequestor(true)}
            />
          <ShipmentPlanAutoEssDetailGrid
            onOrderDetail={setOrderDetail}
            onConfirmDetail={setConfirmDetailNo}
            rowsBySheet={rowsBySheet}
            gridRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridRef,
              [SHEETS.HOLD_STOCK]: holdStockGridRef,
              [SHEETS.MES_STOCK]: mesStockGridRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridRef,
            }}
            gridFilterRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailGridFilterRef,
              [SHEETS.STOCK_DETAIL]: stockDetailGridFilterRef,
              [SHEETS.OWMS_DETAIL]: owmsDetailGridFilterRef,
              [SHEETS.HOLD_STOCK]: holdStockGridFilterRef,
              [SHEETS.MES_STOCK]: mesStockGridFilterRef,
              [SHEETS.MES_STOCK_DETAIL]: mesStockDetailGridFilterRef,
              [SHEETS.SHIPMENT_RESULT]: shipmentResultGridFilterRef,
            }}
            editTrackerRefs={{
              [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
            }}
            staticColumns={staticColumns}
            editable={detailEditable}
            onItemCellSearch={row => openCellPopup('item', row)}
            onProjectCellSearch={row => openCellPopup('project', row)}
          />
          </div>
        </Panel>
      </PanelGroup>

      {/* 1차·2차 Model/Nickname 팝업 — MaterialByDivisionModal(COM0013), 사용자 지시 2026-10-12.
          주의(의도적 AS-IS 이탈): AS-IS SSP0021 은 두 자리 모두 `SCM0002_ItembyDivisionPopup`
            (cs L988 btnItemId / L2499 셀)이고 그 TO-BE 대응은 `ModelByDivisionPopup`
            (SCM0002/ModelPopup → PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)이다.
            자매 SSP0060·SSP0015 도 그걸 쓴다. COM0013 은 SP·그리드 컬럼이 다른 별개 팝업이라
            파리티 이탈이며, 사용자 결정으로 채택했다(__asis-mapping__ 해당 절 참조).
          주의(positional 계약): master 계약은 (itemId, itemName, itemClassName, **nickName**) —
            NickName 이 **4번째**다. 종전 ItemByDivisionModal 은 5인자라 자리가 다르다(아래 셀 팝업).
            자리를 잘못 받으면 모델 설명이 NICK_NAME 에 박힌다(자매 SSP0201 실제 사고). */}
      <MaterialByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        setSelectedValue={itemId => set({ itemId: str(itemId) })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />

      {/* 2차 Model/Nickname 팝업 (btnItemID2 — 동일 컴포넌트, 대입 대상만 상이 — 02 §4.6) */}
      <MaterialByDivisionModal
        open={openItemDetailBar}
        modalClose={() => setOpenItemDetailBar(false)}
        setSelectedValue={itemId => set({ model: str(itemId) })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.model,
        }}
      />

      {/* Detail 그리드 ITEM_ID 셀 팝업 (신규행 한정 — 03 §3.7) */}
      <ItemByDivisionModal
        open={cellPopupKind === 'item'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(itemId, _itemName, _itemClassName, _itemType, nickName) => {
          if (cellPopupRow) {
            cellPopupRow.ITEM_ID = str(itemId);
            cellPopupRow.NICK_NAME = str(nickName);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{ divisionId: cellPopupDivision, itemId: str(cellPopupRow?.ITEM_ID) }}
        callFromCell={true}
      />

      {/* Detail 그리드 PROJECT_CODE 셀 팝업 (신규행 한정 — 03 §3.7) */}
      <ProjectByDivisionModal
        open={cellPopupKind === 'project'}
        modalClose={() => setCellPopupKind(null)}
        setSelectedValue={(projects, projectsNames) => {
          if (cellPopupRow) {
            cellPopupRow.PROJECT_CODE = str(projects);
            cellPopupRow.PROJECT_NAME = str(projectsNames);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        preSearchParams={{ divisionId: cellPopupDivision, projectCode: str(cellPopupRow?.PROJECT_CODE) }}
        callFromCell={true}
      />

      {/* Requestor 팝업 — 공용 SsoUserModal(= SSP0014 그리드 User ID 더블클릭 팝업, AS-IS UserInfoPopup).
          사용자 지시(2026-10-20): Requestor 는 유저 팝업으로 통일한다. 팝업 행을 더블클릭하면 그 사용자가
          확정되고, Requestor 입력칸에는 **유저 이름**(언어별 KO/EN)이 표시된다. 조회 파라미터(P_REQUESTOR)는
          requestorId 로 간다(DetailBar value=requestorName||requestorId). ssoUserYn='N'(등록 사용자 기준). */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        ssoUserYn='N'
        setSelectedValue={(userId, userNm, userEngNm) =>
          set({
            requestorId: userId,
            requestorName: (session.langCd === 'KO' ? userNm : userEngNm) ?? '',
          })
        }
      />

      {/* ERP Order Detail 팝업 (AS-IS SSP0300_OrderDetailPopup — cs L1591~1611) */}
      <OrderDetailModal
        open={orderDetail !== null}
        data={orderDetail}
        onClose={() => setOrderDetail(null)}
        menuId={MENU_ID}
        shtNm={SHEETS.MAIN}
        btnId={ORDER_DETAIL_BTN}
      />

      {/* Request Info 팝업 (CHANGE_REQ_NO 더블클릭 — 표시전용). AS-IS SCM0002 를 SSP0060 팝업으로 커버.
          조회 proc 은 SSP0021/confirmDetail 버튼매핑(action=SEARCH)으로 등록 필요(운영 메타, 사용자 실행). */}
      <ConfirmDetailModal
        open={confirmDetailNo !== ''}
        onClose={() => setConfirmDetailNo('')}
        changeReqNo={confirmDetailNo}
        menuId={MENU_ID}
        sheetName={CONFIRM_DETAIL_SHEET}
      />

      {/* Measure 설정 (btnMeasure — AS-IS TitleSetForm(Measure) = D00-1-005).
          종전에는 공용 ColumnSettingModal 에 columnType='M' 만 끼워 썼는데, 그 팝업의 조회 proc
          (DMF0002_GET_TITLESET_POPUP)은 목록 원천이 SCM_MST_SHEET_COLUMNS 라 Measure 를 못 내리고
          division 조건 때문에 SSP0021 에서도 0건이었다(실측 2026-10-12 — 자매 SSP0060 동일 결함).
          공통 MeasureSelectModal(features/master) + /measure 엔드포인트로 교체(형제 SSP0023 동일).
          onApply codes 는 공통본 시그니처상 string[] | null(null=전체표시 복원)이라 ?? [] 로 가드한다. */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          // titleSet 'M' 영구 저장 → fetchStaticMeasures 로 display 플래그 갱신(MainGrid 게이트) +
          //   메인 재조회. 저장 proc 의 DELETE 는 타입별이라 컬럼('C') 개인화는 보존된다.
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
    </>
  );
};
