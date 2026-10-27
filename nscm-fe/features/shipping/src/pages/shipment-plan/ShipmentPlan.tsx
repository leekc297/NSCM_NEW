import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  MaterialByDivisionModal,
  MeasureSelectModal,
  ModelByDivisionPopup,
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
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation, useQuery } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils, sessionTimeZone } from '@foundation/utils';
import { MainTitle, saveTitleSet, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import {
  registerDirtyCheck,
  registerDirtyReset,
  useMessageStore,
  useSessionStore,
} from '@shared/stores';

import { ShipmentRequestModal } from './components/modals/ShipmentRequestModal';
import { ShipmentPlanDetailBar } from './components/ShipmentPlanDetailBar';
import { ShipmentPlanDetailGrid } from './components/ShipmentPlanDetailGrid';
import { ShipmentPlanForm } from './components/ShipmentPlanForm';
import { ShipmentPlanMainGrid } from './components/ShipmentPlanMainGrid';
import {
  ADMIN_SHEET_NAME,
  DRAFTING_TITLE,
  LBL,
  LOOKUP,
  MENU_ID,
  MSG,
  ORDER_DETAIL_BTN,
  PLAN_DETAIL_INSERT_COPY_COLUMNS,
  SHEETS,
  STANDARD_MANUAL_URL,
  TITLESET_MEASURE_TYPE,
  TOT_PSI_SEQ_LIMIT,
  USER_CHECK_BTN,
} from './shipment-plan.constants';
import type { MainRow, NoteRow } from './shipment-plan.types';
import styles from './ShipmentPlan.module.scss';
import { useShipmentPlanStore } from './useShipmentPlanStore';
import {
  BOH_DRILLDOWN,
  DETAIL_SHEETS,
  measureDrilldownOf,
} from './utils/shipment-plan.detailSheets';
import { markBtnNewRow } from './utils/shipment-plan.editLock';
import { type ErpChainDeps, runDetailErpChain } from './utils/shipment-plan.erpChain';
import {
  collectConfirmSaveRows,
  collectMainSaveRows,
  type ConfirmSaveFolded,
  type MainSaveFolded,
  needsChangeReason,
} from './utils/shipment-plan.save';
import {
  applyTransModeRouteKeys,
  withTransModeRouteKeys,
} from './utils/shipment-plan.transMode';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 저장 SP 업무결과 'X'(기준정보 미등록) 센티넬 — assertSaveResult 가 이 메시지로 던지면 handleSaveError 가
//   일반 실패(F)와 구분해 MSG01321(예/아니오)+매뉴얼 열람으로 처리한다(AS-IS SaveData_Detail cs L2736).
const SAVE_RESULT_X = 'SSP_SAVE_RESULT_X';

// AS-IS GSCM.SSP.Plan.UIL SSP0060_ShipmentPlan (Shipment Plan) — 신규 전환(2026-09-25).
//   설계: .atlas/gscm-design/SSP0060/design/00~03. 매핑: __asis-mapping__.md.
//   툴바: Find/Save/Insert/Edit=실동작, Delete=NO-OP `() => undefined` (00 §4d — 노출 유지, false 숨김 금지).
//   주의: PKG_SSP0002(GetSSPUserCheck/GetNERPCode)·HoldStock 저장 SP 는 TO-BE 미배포 — 04_react-gap.md 참조.
//   하단 Plan Detail 저장의 ERP Drafting IF 연쇄는 utils/shipment-plan.erpChain.ts 로 배선했다(2026-10-27,
//   일부 단계는 01 SQL 메타 적용 전까지 403 — runDetailConfirmSave 주석).
export const ShipmentPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const session = useSessionStore(s => s.session);

  // 알림 메시지 포맷 — 공용 카탈로그에 '{0}' 치환자와 **이스케이프된 '\n\r'**(JSON 이중 이스케이프 →
  //   파싱 후 리터럴 백슬래시-n)이 섞여 있다. t() 결과를 그대로 알림 content 로 쓰면 (1) i18next 보간은
  //   {{...}} 라 '{0}' 가 글자로 노출되고 (2) 알림창은 white-space:pre-line 이라 리터럴 '\n' 이 개행이
  //   아니라 글자로 보인다(사용자 신고 2026-10-20). {0} 치환 + '\r' 제거 + 리터럴 '\n' → 실제 개행 정규화.
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
  const holdStockEditTrackerRef = useRef<EditTracker>();
  const mesStockGridRef = useRef<FlexGridType>();
  const mesStockGridFilterRef = useRef<FlexGridFilter>();
  const mesStockDetailGridRef = useRef<FlexGridType>();
  const mesStockDetailGridFilterRef = useRef<FlexGridFilter>();
  const shipmentResultGridRef = useRef<FlexGridType>();
  const shipmentResultGridFilterRef = useRef<FlexGridFilter>();

  // ── store ──
  const sc = useShipmentPlanStore(s => s.searchCondition);
  const set = useShipmentPlanStore(s => s.setSearchCondition);
  const filters = useShipmentPlanStore(s => s.filters);
  const setMainFilters = useShipmentPlanStore(s => s.setMainFilters);
  const setDetailFilter = useShipmentPlanStore(s => s.setDetailFilter);
  const clearFilters = useShipmentPlanStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanStore(s => s.setOpenSearchArea);
  const realFlag = useShipmentPlanStore(s => s.realFlag);
  const activeGrid = useShipmentPlanStore(s => s.activeGrid);
  const setActiveGrid = useShipmentPlanStore(s => s.setActiveGrid);
  const activeDetailSheet = useShipmentPlanStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanStore(s => s.setActiveDetailSheet);
  const staticColumns = useShipmentPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanStore(s => s.fetchStaticColumns);
  const staticMeasures = useShipmentPlanStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentPlanStore(s => s.visibleMeasures);
  const fetchStaticMeasures = useShipmentPlanStore(s => s.fetchStaticMeasures);
  const applyVisibleMeasures = useShipmentPlanStore(s => s.applyVisibleMeasures);
  const initialized = useShipmentPlanStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // R7a(Edit 진입 가드① — I06, 자매 SSP0015 에서 이식) — AS-IS EditButton 첫 가드:
  //   `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }`
  //   (cs L2714~2722). GetSSPUserCheck(cs L8011~8033)은 SSP0002_GET_USER_INFO_LIST 를
  //   Search=UserId / Language / SSOUserYN='N' 로 호출해 **0행이면 false**(= GSCM 미등록 사용자).
  //   TO-BE 등가 = USER_CHECK call-proc(PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST).
  //   판정 전(undefined)에는 낙관적 허용 — 로드 중 불필요한 편집 차단을 만들지 않는다.
  //   비SSP 확정(false) 시에만 편집 차단 + 1회 알럿(AS-IS 는 Edit 클릭 시점 알럿이나, 편집 기본 ON
  //   전환(convert-core §2.4)에서는 클릭 시점이 없어 판정 완료 시점 1회로 옮긴다).
  const { data: sspUserCheck } = useQuery({
    queryKey: [tabId, 'sspUserCheck', session.userId],
    queryFn: async () => {
      try {
        const res = await apiClient.post(
          `/${MENU_ID}/${SHEETS.MAIN}/${USER_CHECK_BTN}/call-proc`,
          {
            userId: session.userId ?? '',
            language: session.langCd ?? '',
            ssoUserYn: 'N',
          }
        );
        // 판정 불가(403 USER_CHECK 버튼권한 미등록 / 비정상 응답)는 **낙관 허용** — 비SSP 로 단정하지
        //   않는다(gap-audit iter-5 G04). USER_CHECK 버튼권한 범위가 같은 화면 EDIT 권한 범위보다
        //   좁아(FP Planner·SCM PI Admin 단일소속 117명은 EDIT 권한이 있는데 USER_CHECK 미보유)
        //   403 을 '비SSP'로 처리하면 이들을 전면 읽기전용으로 오잠금 + MSG01261 오탐이 난다.
        //   AS-IS 가드①의 '비SSP' 는 SSP0002_GET_USER_INFO_LIST **0행**일 때만이다 — 403 ≠ 0행.
        //   (근본 해소는 admin 메타: USER_CHECK 권한을 EDIT 권한 보유 그룹 집합과 동일하게 — R3.)
        if (res.status >= 400 || Number(res.data?.code)) return true;
        const rows = (res.data?.result as { o_rc1?: unknown[] })?.o_rc1 ?? [];
        return rows.length > 0;
      } catch {
        return true; // 통신·인터셉터 예외 — 판정 불가, 낙관 허용(오잠금 방지)
      }
    },
    enabled: !!session.userId,
    staleTime: Infinity,
  });
  const isSspUser = sspUserCheck !== false;
  const sspAlertShownRef = useRef(false);
  useEffect(() => {
    if (sspUserCheck === false && !sspAlertShownRef.current) {
      sspAlertShownRef.current = true;
      void setAlert({
        type: 'alert',
        content: fmtMsg(
          MSG.NO_AUTHORITY,
          '__This user does not have permission to the SSP Planner.\nUser ID : {0}',
          session.userId ?? ''
        ),
      });
    }
  }, [sspUserCheck, t, session.userId, setAlert, fmtMsg]);

  // 편집 가능 = 권한(canEdit = hasButton('EDIT'), 마운트 1회) · 최신 Plan(realFlag).
  //   AS-IS EditButton/SwitchLock '수정 모드' 토글은 이식하지 않는다(convert-core §2.4 · 전 화면 공통
  //   결정 2026-09-23/25 · 자매 SSP0025). 편집이 기본 ON 이고 권한은 진입 시 1회 판정 — 조회모드 복귀 없음.
  //   realFlag(최신 Plan 아님 → 편집 차단)는 AS-IS 데이터 조건이라 유지(토글 어포던스와 별개).
  //   두 그리드 편집 가능 여부는 동일(활성 그리드로 제한하지 않음) — activeGrid 는 저장 라우팅·Measure 에만
  //   쓴다. AS-IS InsertRow 가 fps 를 안 보는 것(J6)·셀 단위 화이트리스트(editLock)가 실제 편집 범위를 판정.
  //   R7a(isSspUser)는 권한 축이라 canEdit 에 합산한다 — AS-IS 가드① 과 동일하게 비SSP 는 전면 읽기전용.
  const canEdit = hasButton('EDIT') && isSspUser;
  const mainEditable = canEdit && realFlag;
  const detailEditable = canEdit && realFlag;

  // ── 모달 open state (페이지 소유) ──
  const [openItemMain, setOpenItemMain] = useState(false); // 1차 Model(btnItemId)
  const [openItemDetailBar, setOpenItemDetailBar] = useState(false); // 2차 Model(btnItemID2)
  const [openRequestor, setOpenRequestor] = useState(false);
  const [openMeasure, setOpenMeasure] = useState(false); // TitleSetForm(Measure — R2/R3)
  const [openRequest, setOpenRequest] = useState(false); // 저장 후 Request 팝업(R8)
  const [confirmDetailNo, setConfirmDetailNo] = useState(''); // CHANGE_REQ_NO 클릭
  // I13 — ERP_SO_NO 더블클릭 컨텍스트(null 이면 닫힘). AS-IS 는 모달 다이얼로그라 행 컨텍스트를
  //   그대로 들고 열린다(cs L1802~1810 의 4값).
  const [orderDetailCtx, setOrderDetailCtx] = useState<OrderDetailContext | null>(null);
  // I15 — 저장 시 음수로 걸린 일자셀(행객체 -> binding 집합). AS-IS 는 재조회(Re_Design)까지 색이
  //   남으므로 여기서도 재조회·음수해소 저장 때만 비운다.
  const [negativeCells, setNegativeCells] = useState<Map<object, Set<string>>>(
    () => new Map()
  );
  const [cellPopupRow, setCellPopupRow] = useState<WijmoRowItem | null>(null);
  const [cellPopupKind, setCellPopupKind] = useState<'item' | 'project' | null>(null);

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

  // chkTotPSI 행 필터 (03 §2.3 — 미체크 SEQ<12 / 체크 SEQ<21. 서버 전량 반환, 클라 필터)
  const mainRows = useMemo<MainRow[]>(() => {
    const limit = sc.chkTotPsi ? TOT_PSI_SEQ_LIMIT.ON : TOT_PSI_SEQ_LIMIT.OFF;
    return (mainData?.o_rc1 ?? []).filter(r => Number(r.SEQ ?? 0) < limit);
  }, [mainData, sc.chkTotPsi]);
  const calendarRows = useMemo(() => calendarData?.o_rc1 ?? [], [calendarData]);

  // 하단 저장 출하일 허용범위 (AS-IS Validation_Check MSG00194, SSP0060_ShipmentPlan.cs Validation_Check). 상한 오늘+'1D+', 하한 오늘-'2D-',
  //   안내 문구 {0}=CHANGE_REQ_DAY. 종전엔 이 검사가 없어 범위 밖 날짜도 저장됐다(결함 E1).
  //   자매 SSP0015(ShipmentPlanMobilityIt shipDateRange)와 같은 계산. lookup 미도착·비수치면 검사를 생략한다
  //   (임의 기본값으로 전건 차단 방지).
  const [shipPeriodDay, changeReqDay] = useTabLookupQueries({
    filters: [LOOKUP.SHIPMENT_PERIOD_DAY, LOOKUP.CHANGE_REQ_DAY],
  });
  const shipDateRange = useMemo(() => {
    const num = (v: unknown): number | undefined => {
      const s = str(v).trim();
      const n = Number(s);
      return s !== '' && Number.isFinite(n) ? n : undefined;
    };
    const rows = (shipPeriodDay ?? []) as Record<string, unknown>[];
    const dayOf = (code: string) => {
      const r = rows.find(x => str(x.CODE ?? x.SEGMENT1).trim() === code);
      return r ? num(r.NAME ?? r.SEGMENT2) : undefined;
    };
    const plus = dayOf('1D+');
    const minus = dayOf('2D-');
    if (plus === undefined || minus === undefined) return undefined;
    const today = dayjs().startOf('day');
    const first = (changeReqDay ?? [])[0] as Record<string, unknown> | undefined;
    return {
      max: today.add(plus, 'day'),
      min: today.subtract(minus, 'day'),
      dDay: first ? str(first.NAME ?? first.SEGMENT2).trim() : '',
    };
  }, [shipPeriodDay, changeReqDay]);
  // NOTE 행 (o_rc2) — SHIP_PLAN_DETAIL 일자셀 파란 StickyNote(■) 원천. AS-IS dtNote(ds.Tables[1]) 등가.
  const noteRows = useMemo<NoteRow[]>(() => mainData?.o_rc2 ?? [], [mainData]);

  const rowsBySheet = useMemo(
    () => ({
      // I04 — TransMode 셀콤보는 행 route 로 재조회된다(ATTRIBUTE10='D'). EE 치환·site 공백
      //   폴백을 끝낸 파생키를 여기서 심어야 공용 훅이 올바른 바인드 값을 싣는다.
      [SHEETS.PLAN_DETAIL]: withTransModeRouteKeys(
        (planDetailData?.o_rc1 ?? []) as WijmoRowItem[]
      ),
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

  // ── 저장 ──
  //   세 저장 경로(Main/Confirm/Request)는 컬럼별 '^'-폴딩 단일 객체를 apiClient.post 로 보낸다.
  //   SAVE proc 파라미터가 전건 VARCHAR 라 BE 는 폴딩하지 않고(JVARCHAR 전용) SP 본문이 '^'-분해
  //   다건을 돈다 — useProcMutation 의 배열 {data:[]} 전송은 전건 null 바인딩 → false-success 사고
  //   (gap-audit iter-5 G01~G03, 자매 SSP0015 선례). 그래서 useMutation + apiClient.post 로 직배선한다.
  //   mutationKey=[tabId,...] 로 공통 로딩 스피너(useIsBusy)가 저장 중에도 뜨게 한다.

  // 저장 업무결과 검사 (gap-audit G05) — HTTP 200·code:0 이어도 SP 가 예외를 내부 캐치해 커밋 없이
  //   o_rc1 RESULT_CODE!='S'(F/X) + ERR_MESSAGE 로 돌려줄 수 있다(미저장을 성공으로 오인 방지).
  //   AS-IS 는 ds.Tables[0].Rows[0][0]=='S' 로 성립 판정(cs L3332). 자매 SSP0015 와 동일 처리.
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
  //   열람, 그 외 실패는 일반 알림(AS-IS MSG00284 대응). Main/Detail 저장 양쪽 onError 가 공유한다.
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

  // Main 저장 — 편집 D_셀을 15 IN '^'-폴딩 단일 객체로(collectMainSaveRows). R8: 성공 시 Request 팝업 오픈.
  const { mutate: mutateMainSave, isPending: mainSaving } = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, 'SAVE'],
    mutationFn: async (payload: MainSaveFolded) => {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, payload);
      // false-success 판별 (np §5-10 — 인터셉터가 500/403 도 resolve)
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error(t(MSG.SAVE_FAILED, '__Save failed.'));
      }
      assertSaveResult(res.data);
      return res.data;
    },
    onSuccess: () => {
      mainEditTrackerRef.current?.clearChanges();
      // 편집 기본 ON(convert-core §2.4) — 저장 후 조회모드 복귀 없음.
      setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') });
      // R8: 저장 성공 시 Request 팝업 무조건 오픈. 재조회는 팝업 닫힘 시(취소 포함) 무조건 수행.
      setOpenRequest(true);
    },
    onError: handleSaveError,
  });

  // PlanDetail Confirm 저장 — dirty 행을 38 IN '^'-폴딩 단일 객체로(collectConfirmSaveRows).
  const { mutate: mutateConfirm } = useMutation({
    mutationKey: [tabId, SHEETS.PLAN_DETAIL, 'SAVE'],
    mutationFn: async (payload: ConfirmSaveFolded) => {
      const res = await apiClient.post(`/${MENU_ID}/${SHEETS.PLAN_DETAIL}/SAVE/call-proc`, payload);
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
      // AS-IS 저장 성공 후 재조회(SSP0060_ShipmentPlan.cs L3337~3350): 상단에 행이 있으면 상단도 다시 조회하고,
      //   하단은 직전 조회 방식(드릴다운이면 그 행·일자) 그대로 다시 조회한다. 종전엔 하단만
      //   dblFlag 'N' 으로 바꿔 재조회해 드릴다운 조건이 풀렸고 상단 PSI 는 저장 전 값으로 남았다(결함 B7).
      if (filters[SHEETS.MAIN]) void refetchMain();
      if (filters[SHEETS.PLAN_DETAIL]) void refetchPlanDetail();
    },
    onError: handleSaveError,
  });

  // ── 하단 Plan Detail 저장 연쇄 — AS-IS SaveData_Detail(SSP0060_ShipmentPlan.cs 3109~3406) ──
  //   AS-IS 순서: ERP 중단기간(chkERPIFBlockYn cs:3127) → Validation(cs:3139, 위 handleSave 가 수행) →
  //   GetERPInterface(cs:3156 → 3840~4065: 상태 재검증·SO 건수·2분 잠금·DRAFTING·ERP 송신·보상) →
  //   SAVE_SHIPMENT_REQUEST_CONFIRM(cs:3286, planDetail/SAVE). 종전 TO-BE 는 마지막 CONFIRM 1회만 불러
  //   변경요청 초안·ERP 송신이 전혀 일어나지 않았다. 연쇄 본문은 utils/shipment-plan.erpChain.ts.
  //   CONFIRM 은 ERP 가 거절한 CONFIRM_ID 를 빼고 보낸다(AS-IS errConfrimList2, cs:3217~3228).
  const erpDeps = useMemo<ErpChainDeps>(
    () => ({
      post: (url, body) => apiClient.post(url, body),
      getCombo: params => apiClient.getCombo(params),
      t: (key, fallback) => t(key, fallback),
      alert: content => setAlert({ type: 'alert', content }),
      confirm: content => setAlert({ type: 'confirm', content }),
      userId: session.userId ?? '',
      timeZone: sessionTimeZone(session),
    }),
    [t, setAlert, session]
  );
  const detailSavingRef = useRef(false);
  const runDetailConfirmSave = async (dirty: Record<string, unknown>[]): Promise<void> => {
    if (detailSavingRef.current) return; // 연쇄 진행 중 재진입 차단
    detailSavingRef.current = true;
    try {
      const allRows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const { proceed, excludeRows, excludeConfirmIds } = await runDetailErpChain(erpDeps, {
        dirty,
        allRows,
        meta: {
          userId: session.userId ?? '',
          userDeptId: '', // AS-IS Dept_ID — 세션에 부서 없음(B11 보류)
          title: DRAFTING_TITLE.DETAIL,
          programId: MENU_ID,
        },
      });
      if (!proceed) return;
      // CONFIRM 대상 = 성공 단위 행 + 단위를 타지 않는 신규 'I'·CHANGE_TYPE 'P' 행(검토 R3).
      //   실패 단위(DRAFTING 'X'·실패·요청번호 없음, E, F/C_E, 'B' 적재 실패, 예외)의 행 전체와 ERP 거절 CONFIRM_ID
      //   (AS-IS errConfrimList2) 행은 뺀다 — 초안·ERP 없이 확정되면 ERP 와 계획이 어긋난다.
      const targets = dirty.filter(
        r => !excludeRows.has(r) && !excludeConfirmIds.has(str(r.CONFIRM_ID).trim())
      );
      // dirty 행 → 38 IN '^'-폴딩 단일 객체(collectConfirmSaveRows, 키=PROC_M COL_NM).
      //   남은 행이 없으면 AS-IS 처럼 CONFIRM 을 부르지 않는다(cs:3283 iCount>0).
      const payload = collectConfirmSaveRows(targets, session.userId ?? '');
      if (payload) mutateConfirm(payload);
    } finally {
      detailSavingRef.current = false;
    }
  };

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

  // ── mount — keep-alive 잔여 filters 무효화 + Main 컬럼 메타 1회 fetch (np §5-7) ──
  useEffect(() => {
    clearFilters();
    // 마운트 1회 — Main + **전 Detail 시트** 컬럼 메타를 받아 조회 전에도 모든 하단 탭에 헤더가
    //   보이게 한다(사용자 신고 2026-10-16). 컬럼 메타는 데이터와 무관(탭 자동조회 규칙과 무관).
    if (!initialized) void fetchStaticColumns([SHEETS.MAIN, ...DETAIL_SHEETS]);
    // Measure 축 메타 — 팝업을 열 때가 아니라 마운트에 받아 둔다(팝업 open 직후 빈 목록 방지).
    if (staticMeasures.length === 0) void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ── Detail 탭 전환 시 해당 sheet 컬럼 메타 lazy fetch (헤더 생성) ──
  //   AS-IS CreateSpread(L558~)는 mount 에 7개 Detail 시트를 전부 AddSheet+InitSpread 해 헤더를
  //   즉시 만든다. TO-BE 헤더는 admin SCM_MST_SHEET_COLUMNS 메타라, mount 에선 MAIN+PlanDetail 만
  //   받고 나머지 5시트는 Search/드릴다운 전까지 staticColumns 가 비어 "헤더가 안 생기는" 것으로 보였다
  //   (사용자 신고 2026-10-02). 탭에 들어온 시점에 컬럼이 없으면 1회 조회해 빈 그리드라도 헤더를 띄운다.
  useEffect(() => {
    if (!staticColumns[activeDetailSheet]) void fetchStaticColumns([activeDetailSheet]);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeDetailSheet]);

  // ── Division/Company 변경 = 그리드·편집 상태 초기화 의무 (np §5-5 / hook #5, gap-audit I9).
  //    filters 초기화는 store setDivision/setCompany 가 수행 — 여기서는 EditTracker 잔여 기록 정리.
  useEffect(() => {
    mainEditTrackerRef.current?.clearChanges();
    planDetailEditTrackerRef.current?.clearChanges();
    holdStockEditTrackerRef.current?.clearChanges();

  }, [sc.divisionId, sc.companyId]);

  // ── 최신 아닌 Plan 읽기전용 안내 (gap-audit iter-5 G18) ──
  //   AS-IS 는 Edit 가드②/④(MSG00170/00312)로 "최신 아닌 Plan 은 못 고친다"를 알려준다. 편집 기본 ON
  //   전환(convert-core §2.4)에서는 realFlag=false 면 조용히 읽기전용이 되어 사용자가 이유를 몰랐다.
  //   권한(canEdit)은 있으나 realFlag=false 로 편집이 막힌 데이터가 조회되면 1회 안내한다
  //   (최신 Plan 으로 돌아오면 재안내 가능하도록 ref 리셋).
  const oldPlanNoticeRef = useRef(false);
  useEffect(() => {
    if (mainRows.length > 0 && canEdit && !realFlag) {
      if (!oldPlanNoticeRef.current) {
        oldPlanNoticeRef.current = true;
        setToast({
          type: 'warning',
          message: t(MSG.OLD_PLAN_EDIT_BLOCK, '__You can not edit the old Plan.'),
        });
      }
    } else if (realFlag) {
      oldPlanNoticeRef.current = false;
    }
  }, [mainRows.length, canEdit, realFlag, setToast, t]);

  // ── Find (F5 — FindData_Main, 01 R10) ──
  const runMainSearch = () => {
    // validations #58(MSG01315) — 최신 Plan 을 보는 중일 때 서버 최신 Plan 과 불일치 안내(차단 아님).
    //   AS-IS Plan_Current_Check 는 재조회 대조 — TO-BE 는 콤보 캐시(staleTime 0)와 대조가 어렵고
    //   임의 재조회 배선은 과잉이라 보고만 유지(04 확인필요 — 브라우저 축 검증 필요).
    // I15 — 음수 InvalidColor 표시는 재조회로 해제한다(AS-IS 는 Re_Design 이 그리드를 다시 그려
    //   BGColor 가 사라진다). 행 객체가 교체되므로 Map 을 들고 있어도 매칭이 안 되지만,
    //   참조가 남아 메모리를 붙잡지 않도록 명시적으로 비운다.
    if (negativeCells.size > 0) setNegativeCells(new Map());
    setMainFilters();
    void fetchStaticColumns([SHEETS.MAIN]);
  };

  const handleSearch = () => {
    // 필수 4종 (02 §4.1 — Division*/Company*/Period*/Plan Date*)
    if (!sc.divisionId || !sc.companyId || !sc.planDate || !sc.periodFrom) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELDS, '__Please enter the required fields.'),
      });
      return;
    }
    // 미저장 편집 재조회 가드는 공통 SearchArea/SubTitle(MSG00704, tabDirtyKey)에 일임한다 —
    //   화면 자체 MSG00703 confirm 은 그와 중복이라 제거했다(gap-audit iter-5 G13).
    runMainSearch();
  };

  // ── Detail Search (2차 btnSearch — 활성 sheet 재조회, hook #81 lazy) ──
  //   미저장 편집 재조회 가드는 **조회 대상 그리드만** 본다(사용자 지시 2026-10-20). 2차 Search 는 활성
  //   detail sheet 만 재조회(setDetailFilter)하므로 그 sheet 그리드의 dirty 만 확인한다 — 상단(main)이나
  //   다른 detail 탭이 수정 중이어도 묻지 않는다(공통 SubTitle/SearchArea 의 tab 전역 가드와 범위가 다르다).
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
    const trackerBySheet: Partial<Record<SHEETS, typeof planDetailEditTrackerRef>> = {
      [SHEETS.PLAN_DETAIL]: planDetailEditTrackerRef,
      [SHEETS.HOLD_STOCK]: holdStockEditTrackerRef,
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
      GridAction.discardChanges(grid, trackerBySheet[activeDetailSheet]?.current);
      run();
    });
  };

  // ── Main 드릴다운 (03 §3-D — BOH_TYPE / MEASURE 분기) ──
  const handleMainDrilldown = (row: MainRow, binding: string) => {
    const overrides = { itemId: str(row.ITEM_ID), fromSite: str(row.FROM_SITE) };
    // 편집 기본 ON(convert-core §2.4) — 드릴다운 시 별도 편집모드 해제 없음(AS-IS bEdit_Mode=false 미이식).
    if (binding === 'BOH_QTY' && str(row.BOH_TYPE) === 'MES') {
      // MES 는 MES Stock Detail + MES Stock 2-sheet 연속 조회, 활성 탭은 MES Stock
      //   (AS-IS L2356~2366 — Detail 먼저 조회 후 Stock 조회·활성화, gap-audit I10)
      setDetailFilter(SHEETS.MES_STOCK_DETAIL, 'Y', overrides);
      setActiveDetailSheet(SHEETS.MES_STOCK);
      setDetailFilter(SHEETS.MES_STOCK, 'Y', overrides);
      void fetchStaticColumns([SHEETS.MES_STOCK_DETAIL, SHEETS.MES_STOCK]);
      return;
    }
    const sheet =
      binding === 'BOH_QTY'
        ? BOH_DRILLDOWN[str(row.BOH_TYPE)]
        : measureDrilldownOf(str(row.MEASURE), str(row.TO_SITE));
    if (!sheet) return;
    setActiveDetailSheet(sheet);
    if (sheet === SHEETS.PLAN_DETAIL) {
      // AS-IS FindData_Detail(bolDoubleClick=true, cs L5606~5622) — 클릭 행의 route 전체 +
      //   **클릭한 컬럼 일자 하루(from=to)** 로 조회를 고정한다(사용자 신고 2026-10-22: 날짜 미반영).
      //   일자 추출은 AS-IS GetColumnTag().Replace("D_","") 그대로 — W_/M_(Sum) 셀은 'W_...' 가
      //   그대로 전달돼 일자 비교에 안 걸려 0건이 나온다(AS-IS 동일 quirk, 임의 보정하지 않는다).
      const day = binding.replace(/^D_/, '');
      setDetailFilter(sheet, 'Y', {
        ...overrides,
        divisionId: str(row.DIVISION_ID),
        productLevel1: str(row.PRODUCT_LEVEL1),
        toSite: str(row.TO_SITE),
        transportMode: str(row.TRANSPORT_MODE),
        incoterms: str(row.INCOTERMS),
        fcstType: str(row.FCST_TYPE),
        fromYyyymmdd: day,
        toYyyymmdd: day,
      });
    } else {
      setDetailFilter(sheet, 'Y', overrides);
    }
    void fetchStaticColumns([sheet]);
  };

  // Edit 버튼/토글 미이식 (convert-core §2.4 — 전 화면 공통 결정 2026-09-23/25, 자매 SSP0025).
  //   AS-IS EditButton(F2)의 4가드 중 데이터 조건(가드② 최신 Plan=realFlag)은 mainEditable/detailEditable
  //   계산에 흡수했고, 토글·"다른 그리드 편집 중"(가드③) 상태는 개념 자체가 사라졌다(활성 그리드가 곧 편집 대상).
  //   가드①(GetSSPUserCheck/PKG_SSP0002)은 미배포로 fail-open — convert-sp 후속(A01, 04_react-gap 확인필요).

  // ── Save (F7 — fps 분기, 01 R10 / 03 §3-H) ──
  const handleSave = (forceGrid?: 'main' | 'detail') => {
    // 저장 라우팅 = forceGrid 우선, 없으면 렌더시점 activeGrid. 아래 Detail 단축키 effect 가
    //   포커스된 그리드를 알고 'detail' 을 넘겨 올바른 분기를 강제한다(closure 의 activeGrid 는
    //   같은 tick 의 setActiveGrid 를 아직 못 봄). AS-IS SaveButton 의 fps 분기(cs:2933) 등가.
    if ((forceGrid ?? activeGrid) === 'main') {
      // 편집 사전조건 (AS-IS SaveData_Main L2935 `IsLock(shtMain)==false` 가드 — 편집 불가면 조용히 무시,
      //   gap-audit I2). 편집 기본 ON 이므로 canEdit·최신Plan·활성그리드=main 을 mainEditable 로 판정.
      if (!mainEditable) return;
      const rows = (mainGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dayCols = calendarRows
        .map(r => str(r.COLUMN_NAME))
        .filter(b => b.startsWith('D_'))
        .sort();
      const tracker = mainEditTrackerRef.current;
      const { payload, negatives } = collectMainSaveRows(
        rows,
        dayCols,
        row => tracker?.getOriginalValues().get(row as WijmoRowItem),
        {
          divisionId: sc.divisionId,
          companyId: sc.companyId,
          planStartYyyymmdd: sc.planDate,
          userId: session.userId ?? '',
          userDeptId: '', // AS-IS USER_DEPT_ID — 세션에 부서 없음(04 확인필요)
        }
      );
      // 음수 차단 (AS-IS MSG00084 — 저장 abort, SP 미호출) + 해당 셀 InvalidColor 표시(I15).
      //   AS-IS SaveData_Main(cs L2990~2995)은 음수 셀에 `SetBGColor(..., ControlColor.InvalidColor)`
      //   를 칠한 뒤 메시지를 띄우고 return 한다. 종전 TO-BE 는 알럿·abort 만 해서 "어느 셀이
      //   문제인지" 를 못 알려줬다(SSP0015 갭 I15 와 동일 유형).
      //   AS-IS 는 첫 음수에서 즉시 return 하므로 한 셀만 칠해지지만, TO-BE 는 collectMainSaveRows
      //   가 음수를 전건 수집하므로 전부 칠한다 — 사용자가 한 번에 고칠 수 있어 상위호환이고
      //   "차단 + 위치 표시" 라는 AS-IS 의도는 보존된다.
      if (negatives.length > 0) {
        const marks = new Map<object, Set<string>>();
        negatives.forEach(({ row, day }) => {
          const key = row as object;
          const set = marks.get(key) ?? new Set<string>();
          set.add(day);
          marks.set(key, set);
        });
        setNegativeCells(marks);
        mainGridRef.current?.invalidate();
        void setAlert({
          type: 'alert',
          content: t(MSG.NEGATIVE_QTY, '__Quantity must be 0 or greater.'),
        });
        return;
      }
      // 음수가 없으면 종전 표시를 해제한다(고친 뒤 재저장 → 색 잔존 방지).
      if (negativeCells.size > 0) {
        setNegativeCells(new Map());
        mainGridRef.current?.invalidate();
      }
      if (!payload) {
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      if (mainSaving) return; // in-flight 가드
      mutateMainSave(payload); // 성공/실패·R8·false-success·공통 로딩은 mutation 이 담당
      return;
    }

    // Detail 저장 — 활성 sheet 분기
    if (activeDetailSheet === SHEETS.PLAN_DETAIL) {
      const rows = (planDetailGridRef.current?.collectionView?.sourceCollection ??
        []) as Record<string, unknown>[];
      const dirty = rows.filter(r => str(r.EDIT_MAIN) === 'Y' || str(r.CRUD_TYPE));
      if (dirty.length === 0) {
        // 변경 0건 저장 = toast(error) — modal alert 금지 (NSCM 표준, gap-audit J4.
        //   Main 경로와 동일 처리 — memory datagrid-nochange-save-toast-standard)
        setToast({
          type: 'error',
          message: t(MSG.NO_MODIFICATION, '__No modifications have been made.'),
        });
        return;
      }
      // 행별 필수 (validations #3/#34/#35): TRANSPORT_MODE 공백 / CHANGE_REASON_CODE 미선택 차단
      for (const row of dirty) {
        // 행번호(1-based) — MSG01289 "{0}열 출하 변경사항..." 의 {0} 치환용(AS-IS 행번호).
        const rowNo = (planDetailGridRef.current?.rows.findIndex(r => r.dataItem === row) ?? -1) + 1;
        // 출하일 입력 가능 기간 (AS-IS SSP0060_ShipmentPlan.cs Validation_Check, M/I 행) — 범위 밖이면 저장 차단(결함 E1).
        if (shipDateRange) {
          const digits = str(row.SHIPMENT_DATE).replace(/\D/g, '').slice(0, 8);
          const d = digits.length === 8 ? dayjs(`${digits.slice(0, 4)}-${digits.slice(4, 6)}-${digits.slice(6, 8)}`) : undefined;
          if (d?.isValid() && (d.isAfter(shipDateRange.max, 'day') || d.isBefore(shipDateRange.min, 'day'))) {
            void setAlert({
              type: 'alert',
              content: t(
                MSG.SHIP_DATE_OUT_OF_RANGE,
                '__Change requests are possible from the current D + {0} ship date.'
              ).replace('{0}', shipDateRange.dDay),
            });
            return;
          }
        }
        if (str(row.TRANSPORT_MODE).trim() === '') {
          // MSG00429 "{0} value is required." — {0}=Trans Mode. fmtMsg 가 치환·개행 정규화.
          void setAlert({
            type: 'alert',
            content: fmtMsg(MSG.REQUIRED_VALUE, '_{0} value is required.', 'Trans Mode'),
          });
          return;
        }
        const reason = str(row.CHANGE_REASON_CODE).trim();
        const original = planDetailEditTrackerRef.current?.getOriginalValues().get(row as WijmoRowItem);
        if ((reason === '' || reason === '-') && needsChangeReason(row, original)) {
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
      // 확인창 (validations #27 MSG00324 → TO-BE MSG01201). 확인창이 닫힌 뒤(then) 연쇄를 시작한다 —
      //   연쇄 안의 알림이 닫히는 중인 확인창 상태와 겹치지 않게 한다.
      void setAlert({
        type: 'confirm',
        content: t(MSG.CONFIRM_SAVE, {
          defaultValue: '_Are you sure you want to confirm the shipping plan change requests?',
        }),
      }).then(ok => {
        if (ok) void runDetailConfirmSave(dirty);
      });
      return;
    }
    if (activeDetailSheet === SHEETS.HOLD_STOCK) {
      // HoldStock 저장 SP(SSP0060_SAVE_HOLD_STOCK_DATA) — TO-BE/AS-IS DB 공히 미존재(실측).
      //   convert-sp 후속 대상 — 저장 경로 미배선을 명시 안내(04_react-gap.md 확인 필요).
      void setAlert({
        type: 'alert',
        content: t(MSG.SAVE_FAILED, '__Save procedure is not deployed yet.'),
      });
      return;
    }
  };

  // ── Insert (F8 — 03 §3-E 2원천. 활성 sheet 분기, 가드 재현 — 공통 addRow 는 안 막음) ──
  //   주의: AS-IS InsertRow(L2539/L2558)는 fps(활성 그리드)를 참조하지 않고 IsLock 만 가드한다 —
  //   activeGrid 게이트를 걸면 Detail 편집모드 중 Main 셀 클릭 직후 F8 이 무동작이 된다(gap-audit J6).
  const handleInsert = () => {
    // 편집 사전조건 (AS-IS InsertRow 두 분기 공통 `siDetail.IsLock(...)==false` 가드 L2539/L2558 —
    //   편집 불가면 조용히 무시. gap-audit I3). 편집 기본 ON 이라 canEdit·최신Plan 만 판정(fps 미참조 — J6).
    if (!detailEditable) return;
    if (activeDetailSheet === SHEETS.HOLD_STOCK) {
      // 값 원본 = siMain 활성행 (Detail 자신 아님 — 03 §3-E). 활성행 없으면 조용히 중단.
      const g = mainGridRef.current;
      const mainRow = g ? (GridUtils.getRow(g, g.selection?.row ?? -1) as MainRow | undefined) : undefined;
      if (!mainRow) return;
      const target = holdStockGridRef.current;
      if (!target) return;
      GridAction.addRow(
        target,
        {
          CRUD_TYPE: 'I',
          DIVISION_ID: str(mainRow.DIVISION_ID),
          FROM_SITE: str(mainRow.FROM_SITE),
          FROM_SITE_NM: str(mainRow.FROM_SITE_DESCRIPTION),
          ITEM_ID: str(mainRow.ITEM_ID),
          NICK_NAME: str(mainRow.NICK_NAME),
          HOLD_YYYYMMDD: sc.planDate, // cboPlanDate.Text (03 §3-E)
          RELEASE_YYYYMMDD: '',
          HOLD_QTY: 0,
          REMARKS: '',
        } as WijmoRowItem,
        'above',
        true
      );
      return;
    }
    if (activeDetailSheet === SHEETS.PLAN_DETAIL) {
      const g = planDetailGridRef.current;
      if (!g) return;
      const source = GridUtils.getRow(g, g.selection?.row ?? -1) as
        | Record<string, unknown>
        | undefined;
      if (!source) return; // 복사원본 없이 빈 행 생성 금지 (core §2.4 — 미조회 상태 삽입 결함)
      // 원본 행 STATUS 게이트 — 공백은 'C' 간주 허용 (AS-IS L2568~2571, gap-audit I6).
      const status = str(source.SHIPMENT_STATUS).trim() || 'C';
      if (status !== 'C') return; // 'C' 아님 — 에러 없이 조용히 중단 (03 §3-E/§5-5)
      // 복사 필드는 AS-IS defaultData 명시 목록만 (L2644~2692 — 전 필드 스프레드 복사 금지.
      //   ERP_SO_NO/SHIPMENT_STATUS 등은 신규행에 물려주지 않는다. gap-audit I6)
      const copied: Record<string, unknown> = {};
      PLAN_DETAIL_INSERT_COPY_COLUMNS.forEach(col => {
        copied[col] = source[col];
      });
      copied.SHIPMENT_CONFIRM_QTY = 0; // 항상 0 강제(원본 값 무시)
      copied.ERP_STATUS = ''; // 항상 공백 강제
      const inserted = { ...copied, CRUD_TYPE: 'I' } as WijmoRowItem;
      // I04 — 신규행에도 TransMode route 파생키를 심는다(spread 로 만든 새 객체라 원본의
      //   non-enumerable 파생키가 따라오지 않는다). 복사 목록에 ORIGIN_FROM_DIVISION_ID 가
      //   없으므로 EE 행은 DIVISION_ID 폴백이 되는데, AS-IS 도 같은 상태를 읽는다(파리티).
      applyTransModeRouteKeys(inserted);
      GridAction.addRow(g, inserted, 'above', true);
      return;
    }
    // 읽기전용 5-sheet — 신규행 없음 (03 §1.5~1.9)
  };

  // ── 2차 NEW 버튼 (AS-IS BtnNew_Click L7337~7441 — InsertRow 와 별개 본문, gap-audit J1):
  //   가드: PlanDetail 탭(#43 ActiveSheetIndex==0) + Detail 편집모드(IsLock) + RowCount>0.
  //   InsertRow 와 달리 SHIPMENT_STATUS 게이트가 없고, 복사는 DIVISION_ID·MTK_OWNER 2필드뿐
  //   (나머지 defaultData 는 전부 주석 dead code — L7384~7411). 원본행은 활성행의 "다음" 행
  //   (마지막 행이면 자기 자신 — AS-IS activeRow 클램프 quirk L7347~7352 재현).
  //   편집 스팬은 AS-IS LockRange 등가(잠금 DIVISION_ID..PRODUCT_LEVEL1 + MTK_OWNER..
  //   ORIGIN_TO_DIVISION_ID) — markBtnNewRow 마킹으로 editLock 이 판정한다. 신규행
  //   FROM/TO_SITE·DIVISION_ID 셀콤보와 route 재조회 경로(L7421~7434)는 설계 01~03 에 BtnNew
  //   상세 부재 + 셀콤보 메타 갭(03 §0)으로 보류 — 04_react-gap.md 확인필요(설계 축).
  const handleNew = () => {
    if (activeDetailSheet !== SHEETS.PLAN_DETAIL) return;
    if (!detailEditable) return; // AS-IS IsLock 가드 (L7342) — 편집 기본 ON, canEdit·최신Plan 판정
    const g = planDetailGridRef.current;
    if (!g) return;
    if (g.rows.length === 0) return; // AS-IS RowCount>0 가드 (L7344)
    const active = g.selection?.row ?? -1;
    if (active < 0) return;
    const sourceIndex = active + 1 >= g.rows.length ? active : active + 1;
    const source = GridUtils.getRow(g, sourceIndex) as Record<string, unknown> | undefined;
    if (!source) return;
    const added = GridAction.addRow(
      g,
      {
        CRUD_TYPE: 'I',
        DIVISION_ID: str(source.DIVISION_ID),
        // MKT Owner 실제 바인딩은 MTK_OWNER(메타 실측 — 전치 표기). MKT_OWNER 로 쓰면 빈 값 복사.
        MTK_OWNER: str(source.MTK_OWNER),
      } as WijmoRowItem,
      'above',
      true
    ) as WijmoRowItem | undefined;
    if (added) {
      markBtnNewRow(added); // addRow 는 전달 객체를 spread 복사 — 반환 행에 마킹
      // I04 — 같은 이유로 route 파생키도 반환 행에 심는다. 2차 NEW 는 DIVISION_ID·MTK_OWNER 2필드만
      //   복사하므로(AS-IS L7384~7411 나머지는 주석 dead code) FROM/TO_SITE 는 공백이고
      //   파생키도 공백이 된다 — route 미확정 행의 빈 콤보는 AS-IS 와 같은 상태다.
      applyTransModeRouteKeys(added);
    }
  };

  // ── Measure (R2/R3): spdMain 활성일 때만 팝업. spdDetail 이면 조용히 no-op ──
  const handleMeasure = () => {
    if (activeGrid === 'detail') return; // R2 — 경고 없이 조용히 return (AS-IS L2148)
    setOpenMeasure(true);
  };

  // ── 하단(Detail) 그리드 포커스 시 F7(저장)/F8(삽입) — "포커스된 그리드별 단축키"(AS-IS parity) ──
  //   공용 SubTitle 의 단축키 핸들러는 전달된 grid(=Main)의 containsFocus 로만 게이트된다
  //   (SubTitle.tsx:261). 그래서 하단 Detail 그리드에 포커스가 있으면 Main 이 포커스를 안 가져
  //   F7/F8 이 아예 발화하지 않았다(사용자 신고 2026-10-16 — "하단 포커스 + F7 무반응").
  //   AS-IS 는 BaseForm 전역 F7/F8 + SaveButton/InsertRow 이 fps(활성 스프레드)로 분기해
  //   (cs:2933) 포커스된 그리드별로 저장/삽입이 따로 동작한다. 그 동작을 Detail 쪽에서 보강한다:
  //   - Detail 그리드 중 하나가 포커스를 가진 경우에만 실행(Main 포커스는 SubTitle 담당 → 상호배타,
  //     이중 실행 없음). containsFocus 가 곧 "현재 보이는 활성 탭" 판정이라 keep-alive MDI 숨김
  //     탭에서는 발화하지 않는다(SubTitle 의 offsetParent/scope 가드 등가).
  //   - finishEditing 으로 편집 중 셀을 먼저 커밋(SubTitle wrapWithEditCommit 등가).
  //   - setActiveGrid('detail') 를 동기로 선반영 → handleSave 가 getState()로 Detail 분기를 탄다.
  //   - 권한 게이트는 SubTitle 과 동일하게 hasButton('SAVE'/'INSERT').
  const detailHotkeyRef = useRef({ handleSave, handleInsert, hasButton });
  detailHotkeyRef.current = { handleSave, handleInsert, hasButton };
  useEffect(() => {
    const detailRefs = [
      planDetailGridRef,
      stockDetailGridRef,
      owmsDetailGridRef,
      holdStockGridRef,
      mesStockGridRef,
      mesStockDetailGridRef,
      shipmentResultGridRef,
    ];
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'F7' && e.key !== 'F8') return;
      const focused = detailRefs.find(r => r.current?.containsFocus());
      if (!focused) return; // Detail 미포커스 → Main 담당(SubTitle)
      const { handleSave: save, handleInsert: insert, hasButton: has } = detailHotkeyRef.current;
      focused.current?.finishEditing(); // 편집 중 셀 커밋
      setActiveGrid('detail'); // 활성 그리드 동기화(Measure 게이트 등 후속 동작용)
      if (e.key === 'F7') {
        if (!has('SAVE')) return;
        e.preventDefault();
        save('detail'); // 포커스가 Detail 이므로 Detail 저장 분기 강제
      } else {
        if (!has('INSERT')) return;
        e.preventDefault();
        insert();
      }
    };
    globalThis.window.addEventListener('keydown', onKeyDown, true);
    return () => globalThis.window.removeEventListener('keydown', onKeyDown, true);
  }, [setActiveGrid]);

  // Simulation 재계산 핸들러 제거 — AS-IS 에서 버튼이 뜨지 않으므로 호출 경로가 없다
  //   (근거는 아래 customButtons 주석). 재계산 본체는 utils/shipment-plan.calc.ts `simulate`
  //   에 그대로 남아 있고 vitest 12건으로 검증돼 있다 — 버튼만 되살리면 재연결된다.
  // ── 그리드 셀 팝업 (03 §3-D — 신규행 한정 + 필수값 MSG00013 가드) ──
  const openCellPopup = (kind: 'item' | 'project', row: WijmoRowItem) => {
    const division = str(row.DIVISION_ID);
    // AS-IS 전제검사는 FROM_SITE_DESCRIPTION/TO_SITE_DESCRIPTION 을 읽는다(cs L1671~1672/L1734~1735).
    //   신규행 From/To Site 셀콤보는 *_DESCRIPTION 에 코드를 쓰고 code 컬럼(FROM_SITE/TO_SITE)은 공백이라,
    //   code || description 폴백으로 본다(shipment-plan.transMode.ts 와 동일 처방 — gap-resolve iter-4).
    const fromSite = str(row.FROM_SITE) || str(row.FROM_SITE_DESCRIPTION);
    const toSite = str(row.TO_SITE) || str(row.TO_SITE_DESCRIPTION);
    // AS-IS SpdDetail_CellDoubleClick(cs L1693~1783)는 전제 미입력 시 **어느 항목이 비었는지**를
    //   MSG00098(→TO-BE MSG01126 "First, select {0}.")로 항목명과 함께 알린다. 종전엔 MSG00013
    //   generic("Please enter the required fields")으로 뭉쳐 어느 컬럼인지 못 알렸다(사용자 신고
    //   2026-10-16). 검사 순서·대상 필드는 AS-IS 그대로(item: Div→From Site→To Site /
    //   project: + Model). {0} 치환은 i18next 보간({{...}})과 달라 .replace 로 한다.
    const selectFirst = (label: string) => {
      void setAlert({
        type: 'alert',
        content: t(MSG.SELECT_FIRST, '_First, select {0}.').replace('{0}', label),
      });
    };
    if (division.trim() === '') {
      selectFirst(t(LBL.DIVISION, '_Div'));
      return;
    }
    if (fromSite.trim() === '') {
      selectFirst(t(LBL.FROM_SITE, '_From Site'));
      return;
    }
    if (toSite.trim() === '') {
      selectFirst(t(LBL.TO_SITE, '_To Site'));
      return;
    }
    if (kind === 'project' && str(row.ITEM_ID).trim() === '') {
      selectFirst(t(LBL.MODEL_NICKNAME, '_Model'));
      return;
    }
    setCellPopupRow(row);
    setCellPopupKind(kind);
  };

  // ── hotkeyConfig (00 §4d/01 R10 확정값 — 재판단 금지) ──
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete = NO-OP (AS-IS L2708-2710 완전 빈 몸체) — 노출 유지 + 명시적 무동작.
    //   키 생략 금지(공용 removeRow 부활) / false 금지(AS-IS 는 버튼이 보였음).
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Edit 버튼 미노출 (convert-core §2.4 — AS-IS EditButton 토글 미이식). hasButton('EDIT') 은
    //   버튼 노출이 아니라 canEdit(편집 권한) 판정에만 쓴다(자매 SSP0025 선례). EDIT 버튼코드 메타는 유지.
    // Measure (R2 — 아이콘 순서: GridColumnSet 없음 → Measure, hook #120)
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Simulation 버튼은 노출하지 않는다 — AS-IS 에서도 뜨지 않는다(사용자 지시 2026-10-12).
    //   AS-IS Form_Load(cs L464~482)가 `PGM_AUTH_ID` 룩업에서 CODE='SSP0060' AND NAME=NowGroupID
    //   행을 찾아, 있으면 `lcbtnSimulation.Visibility=Always` / 없으면 `Never` 로 둔다.
    //   그 룩업에 **SSP0060 행이 아예 없다** — AS-IS DB(LGCE_SCMDEV)·TO-BE DB(ZIOUI1) 양쪽
    //   `SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='PGM_AUTH_ID'` 실측 25행 전부
    //   SSP0015/0021/0022/0023/0026/0029 이고 SSP0060 은 없다(2026-10-12). 즉 어떤 그룹으로
    //   로그인해도 Never 라서, 종전의 "게이트 재현 수단 미확정 → 항상 노출"(01 §5-3)은 AS-IS 보다
    //   **더 많이 보여주는** 오구현이었다.
    //   재계산 본체(utils/shipment-plan.calc.ts `simulate`, vitest 12건)는 AS-IS L7463~7886 의
    //   검증된 이식분이라 지우지 않는다 — 룩업에 SSP0060 행이 생기면 이 버튼만 되살리면 된다.
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
        <ShipmentPlanForm
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

      {/* splitContainer1 — Main(상) / Detail(하) 수직 드래그 분할 (01 §1).
          DMF0004(SalesSite) PanelGroup 패턴 참조 — 스플릿 바(.splitBar)를 드래그해 상/하 그리드
          높이를 조절한다. 초기 비율은 종전 flex 55:45 를 그대로 옮긴 defaultSize 55/45. */}
      <PanelGroup className={styles.gridArea} orientation='vertical'>
        {/* minSize 는 픽셀(react-resizable-panels v4 — "NNpx" 지원)로, 드래그 범위를 제한한다(사용자 지시 2026-10-20):
            위로는 상단 그리드 헤더(2행 병합 ~60px)를 가리지 않도록 100px, 아래로는 하단 조회조건 바
            (ShipmentPlanDetailBar 실측 44px) + 탭 스트립을 가리지 않도록 92px 이하로는 줄지 않는다. */}
        <Panel defaultSize={55} minSize='100px'>
          {/* R5 sticky — Main 클릭 시 activeGrid 복귀 핸들러는 배선하지 않는다(AS-IS parity) */}
          <div className={styles.mainGrid}>
            <ShipmentPlanMainGrid
              rows={mainRows}
              calendar={calendarRows}
              notes={noteRows}
              gridRef={mainGridRef}
              gridFilterRef={mainGridFilterRef}
              editTrackerRef={mainEditTrackerRef}
              adminColumns={staticColumns[SHEETS.MAIN]}
              bucketType={sc.bucketType}
              chkSum={sc.chkSum}
              editable={mainEditable}
              curPlanDate={sc.planDate}
              negativeCells={negativeCells}
              onDrilldown={handleMainDrilldown}
            />
          </div>
        </Panel>

        <PanelSeparator className={styles.splitBar} />

        <Panel defaultSize={45} minSize='92px'>
          <div className={styles.detailArea}>
            <ShipmentPlanDetailBar
            onDetailSearch={handleDetailSearch}
            onNew={handleNew}
            onModelSearch={() => setOpenItemDetailBar(true)}
            onRequestorSearch={() => setOpenRequestor(true)}
          />
          <ShipmentPlanDetailGrid
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
              [SHEETS.HOLD_STOCK]: holdStockEditTrackerRef,
            }}
            staticColumns={staticColumns}
            editable={detailEditable}
            onItemCellSearch={row => openCellPopup('item', row)}
            onProjectCellSearch={row => openCellPopup('project', row)}
            onConfirmDetail={setConfirmDetailNo}
            onOrderDetail={setOrderDetailCtx}
          />
          </div>
        </Panel>
      </PanelGroup>

      {/* 상단(1차)·하단(2차) Model/Nickname 조회조건 팝업 — MaterialByDivisionModal(COM0013),
          사용자 지시 2026-10-16(자매 SSP0021 과 동일 팝업으로 통일).
          주의(의도적 AS-IS 이탈): AS-IS SSP0060 은 두 자리 모두 `SCM0002_ItembyDivisionPopup`
            (cs:2907 1차 / 1040 2차)이고 그 TO-BE 대응은 `ModelByDivisionPopup`
            (SCM0002/ModelPopup → PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)이다. COM0013 은
            SP·그리드 컬럼이 다른 별개 팝업이라 파리티 이탈이며, SSP0021 과 맞추려는 사용자 결정으로 채택한다.
            셀 팝업(아래)은 조회조건이 아니므로 종전 ModelByDivisionPopup 을 유지한다.
          주의(contract): master 계약은 setSelectedValue(itemId) — scpModuleType=MENU_ID, operationGroup='',
            divisionId/itemId 를 preSearchParams 로 넘긴다(SSP0021 과 동일). */}
      <MaterialByDivisionModal
        open={openItemMain}
        modalClose={() => setOpenItemMain(false)}
        // 조회조건 라벨이 Model/Nickname 이므로 선택 확정 시 Material Code(1번째)가 아니라
        //   Nickname(4번째 = NICK_NAME)을 넣는다(사용자 지시 2026-10-16). 계약: setSelectedValue(
        //   Material Code, Description, Class Name, Nickname).
        setSelectedValue={(_item, _itemName, _itemClassName, nickName) =>
          set({ itemId: str(nickName) })
        }
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />

      {/* 2차 Model/Nickname 조회조건 팝업 (btnItemID2 — 동일 컴포넌트, 대입 대상만 상이 — 02 §4.6) */}
      <MaterialByDivisionModal
        open={openItemDetailBar}
        modalClose={() => setOpenItemDetailBar(false)}
        // 상단과 동일 — Model/Nickname 조회조건이라 Nickname(4번째)을 넣는다(사용자 지시 2026-10-16).
        setSelectedValue={(_item, _itemName, _itemClassName, nickName) =>
          set({ model: str(nickName) })
        }
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.model,
        }}
      />

      {/* Detail 그리드 ITEM_ID 셀 팝업 (신규행 한정 — 03 §3-D. 선택 시 ITEM_ID+NICK_NAME 반영).
          AS-IS 는 EE 사업부면 division 을 ""(=전체)로 풀어서 넘긴다(cs:1709-1710) — 자재가 EE 가 아니라
          실 battery division 으로 태깅돼 있어 'EE' 를 그대로 넘기면 0건이 되기 때문이다. */}
      <ModelByDivisionPopup
        open={cellPopupKind === 'item'}
        onClose={() => setCellPopupKind(null)}
        onSelect={selected => {
          if (cellPopupRow) {
            cellPopupRow.ITEM_ID = str(selected.itemId);
            cellPopupRow.NICK_NAME = str(selected.nickName);
            planDetailGridRef.current?.collectionView?.refresh();
          }
        }}
        params={{
          divisionId: cellPopupDivision === 'EE' ? '' : cellPopupDivision,
          // scmSiteId 는 From Site(플랜트)여야 한다 — 팝업 SP(P_SCM0002_GET_ITEM_BY_DIVISION_POPUP)가
          //   SCM_MST_SITE_ITEM.SCM_SITE_ID(품목이 존재하는 PLANT)로 거르기 때문이다(SSP0014 02 §7 실측
          //   WHERE `I.SCM_SITE_ID IN(@p_scm_site_id)`, 자매 SSP0014 도 clbFromSite 를 넘긴다).
          //   AS-IS SSP0060 은 TO_SITE_DESCRIPTION(목적지)을 넘겨(cs:1672/1712) 신규행에서 0건이 되는
          //   잠재 버그다 — From Site 로 교정한다(gap-resolve iter-4, 사용자 신고 2026-10-14).
          scmSiteId: str(cellPopupRow?.FROM_SITE) || str(cellPopupRow?.FROM_SITE_DESCRIPTION),
          itemId: str(cellPopupRow?.ITEM_ID),
        }}
      />

      {/* Detail 그리드 PROJECT_CODE 셀 팝업 (신규행 한정 — 03 §3-D) */}
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
        preSearchParams={{
          divisionId: cellPopupDivision,
          projectCode: str(cellPopupRow?.PROJECT_CODE),
        }}
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

      {/* Measure 설정 (R2/R3 — AS-IS TitleSetForm(Measure) = D00-4e-006).
          종전에는 공용 ColumnSettingModal 에 columnType='M' 만 끼워 썼는데, 그 팝업의 조회 proc
          (DMF0002_GET_TITLESET_POPUP)은 목록 원천이 SCM_MST_SHEET_COLUMNS 라 Measure 를 못 내리고
          division 조건 때문에 SSP0060 에서는 0건이었다 — 사용자 신고 2026-10-12. 공통
          MeasureSelectModal(features/master) + /measure 엔드포인트로 교체했다(형제 SSP0023 동일).
          onApply codes 는 공통본 시그니처상 string[] | null(null=전체표시 복원)이라 ?? [] 로 가드한다.
          OK 시 spdMain 활성 경로만 재조회(R3 — spdDetail 경로는 AS-IS 주석처리 NO-OP 재현) */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          // titleSet 'M' 영구 저장 → 메인 SP(PKG_SSP0060 가 타입 'M' 으로 측정축 필터)가 재조회로 반영.
          //   폭·색은 Measure 축 대상이 아니라 미전달.
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

      {/* 저장 후 Request 팝업 (R8 — 무조건 오픈, 닫힘(취소 포함) 시 무조건 재조회) */}
      <ShipmentRequestModal
        open={openRequest}
        modalClose={() => {
          setOpenRequest(false);
          if (filters[SHEETS.MAIN]) void refetchMain();
        }}
        tabId={tabId}
      />

      {/* Confirm 상세 팝업 (CHANGE_REQ_NO 클릭 — 표시전용) */}
      <ConfirmDetailModal
        open={confirmDetailNo !== ''}
        onClose={() => setConfirmDetailNo('')}
        changeReqNo={confirmDetailNo}
        menuId={MENU_ID}
        sheetName={SHEETS.CONFIRM_DETAIL}
      />

      {/* ERP Order Detail 팝업 (ERP_SO_NO 더블클릭 — 표시전용, AS-IS SSP0300) */}
      <OrderDetailModal
        open={orderDetailCtx !== null}
        data={orderDetailCtx}
        onClose={() => setOrderDetailCtx(null)}
        menuId={MENU_ID}
        shtNm={SHEETS.MAIN}
        btnId={ORDER_DETAIL_BTN}
      />
    </>
  );
};
