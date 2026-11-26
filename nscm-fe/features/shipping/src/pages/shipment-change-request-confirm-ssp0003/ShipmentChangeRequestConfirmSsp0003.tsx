import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { sessionTimeZone } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ConfirmDetailPanel } from './components/ConfirmDetailPanel';
import { ShipmentChangeRequestConfirmSsp0003Form } from './components/ShipmentChangeRequestConfirmSsp0003Form';
import { ShipmentChangeRequestConfirmSsp0003MainGrid } from './components/ShipmentChangeRequestConfirmSsp0003MainGrid';
import { ShipmentChangeRequestConfirmSsp0003SubGrid } from './components/ShipmentChangeRequestConfirmSsp0003SubGrid';
import { useShipmentChangeRequestConfirmSsp0003Actions } from './hooks/useShipmentChangeRequestConfirmSsp0003Actions';
import {
  ACTION,
  ALL,
  CHANGE_TYPE,
  DELEGATE_COLUMNS,
  ERP_IF_ERROR,
  ERP_IF_NO_DATA,
  ERP_IF_PARTIAL_ERROR,
  ERP_IF_PATH,
  ERP_IF_PI_FAIL,
  LBL,
  MASTER_USER_COLUMNS,
  MENU_ID,
  MSG,
  SAVE_BTN,
  SAVE_STATUS,
  SHEETS,
  STATUS_REQUESTED,
  SUB_COL,
} from './shipment-change-request-confirm-ssp0003.constants';
import type {
  ConfirmDetail,
  MainRow,
  SubRow,
} from './shipment-change-request-confirm-ssp0003.types';
import styles from './ShipmentChangeRequestConfirmSsp0003.module.scss';
import { useShipmentChangeRequestConfirmSsp0003Store } from './useShipmentChangeRequestConfirmSsp0003Store';
import {
  buildConfirmPayload,
  buildDeConfirmPayload,
  checkDraftingData,
  computeInitialCheckedIds,
  countChk,
  decideChangeStatus,
  isChkEditable,
  parseErpErrors,
} from './utils/shipmentChangeRequestConfirmSsp0003Save';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const emptyDetail: ConfirmDetail = {
  requestNo: '',
  title: '',
  requestor: '',
  requestDeptName: '',
  approval: '',
  appDeptName: '',
  changeReason: '',
  reasonDetail: '',
};

// ChkDraftingData 가드 실패 시 영문 fallback(TO-BE MSG00420/421/422 미채번 — Hook #114, constants.MSG 주석 참조).
const GUARD_FALLBACK: Record<string, string> = {
  APPROVE_TARGET_REQUIRED: '_Please check the approval target.',
  REJECT_REASON_REQUIRED: '_Please enter the reason for rejection.',
  REJECT_ALL_REQUIRED:
    '_Check all rows before Reject. For partial approval, check targets and click Approval.',
  SELF_REJECT_ALL_REQUIRED: '_Check all rows before Self Reject.',
};

// AS-IS GSCM.SSP.Plan.UIL SSP0003_ShipmentChangeRequestConfirm — 출하 변경요청 승인(조회전용 승인 화면).
//   설계: .atlas/gscm-design/SSP0003/design/00~03. 상세 매핑: __asis-mapping__.md.
//   마스터-디테일 2그리드 + 디테일 폼. 액션 3종(Approval/Reject/SelfReject)은 마스터 더블클릭 시 userId 비교로 토글.
//   PKG_SSP0003 배포·VALID — 조회/저장 런타임 검증 가능(SP 미배포 아님, convert-plan ② 실측).
export const ShipmentChangeRequestConfirmSsp0003 = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  // 액션(승인/반려) 진행 표시 — 수동 apiClient.post 경로라 react-query 스피너(useIsBusy)가 안 잡힌다.
  //   전역 progress 바는 determinate(값 고정)라 50%에서 "멈춘 것"처럼 보여 오류로 오인될 수 있어,
  //   애니메이션 indeterminate 인디케이터(ProgressIndicator infinite)를 로컬로 띄운다(사용자 보고 2026-10-01).
  const [actionLoading, setActionLoading] = useState(false);
  const sesUserId = useSessionStore(s => s.session.userId) ?? '';
  const tmzCd = useSessionStore(s => s.session.tmzCd);
  const { checkErpBlock, checkEngProcessing, checkShipmentStatus } =
    useShipmentChangeRequestConfirmSsp0003Actions();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const savingRef = useRef(false);

  const sc = useShipmentChangeRequestConfirmSsp0003Store(s => s.searchCondition);
  const setSearchCondition = useShipmentChangeRequestConfirmSsp0003Store(s => s.setSearchCondition);
  const filters = useShipmentChangeRequestConfirmSsp0003Store(s => s.filters);
  const setFilter = useShipmentChangeRequestConfirmSsp0003Store(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestConfirmSsp0003Store(s => s.clearFilters);
  const initPeriodDefault = useShipmentChangeRequestConfirmSsp0003Store(s => s.initPeriodDefault);
  const openSearchArea = useShipmentChangeRequestConfirmSsp0003Store(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestConfirmSsp0003Store(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestConfirmSsp0003Store(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestConfirmSsp0003Store(s => s.fetchStaticColumns);
  const restoreSearchConditions = useShipmentChangeRequestConfirmSsp0003Store(
    s => s.restoreSearchConditions
  );
  const initialized = useShipmentChangeRequestConfirmSsp0003Store(s => s.initialized);
  const selectedMasterRow = useShipmentChangeRequestConfirmSsp0003Store(s => s.selectedMasterRow);
  const loadDetail = useShipmentChangeRequestConfirmSsp0003Store(s => s.loadDetail);
  const clearDetail = useShipmentChangeRequestConfirmSsp0003Store(s => s.clearDetail);
  const rejectReason = useShipmentChangeRequestConfirmSsp0003Store(s => s.rejectReason);
  const setRejectReason = useShipmentChangeRequestConfirmSsp0003Store(s => s.setRejectReason);
  const checkedIds = useShipmentChangeRequestConfirmSsp0003Store(s => s.checkedIds);
  const setCheckedIds = useShipmentChangeRequestConfirmSsp0003Store(s => s.setCheckedIds);
  const toggleCheck = useShipmentChangeRequestConfirmSsp0003Store(s => s.toggleCheck);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [openRequestor, setOpenRequestor] = useState(false);
  const [openItem, setOpenItem] = useState(false);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: subData } = useTabProcQuery<MENU_ID, SHEETS.SUB>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUB,
    tabId,
    filters: filters[SHEETS.SUB],
    enabled: !!filters[SHEETS.SUB],
  });
  // 위임자(Delegate_Load) — 마스터 더블클릭 시 division+approval 로 조회. 반환 DELEGATEE_USER 로 승인/반려 판정(§2-A5).
  const { data: delegateData } = useTabProcQuery<MENU_ID, SHEETS.DELEGATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DELEGATE,
    tabId,
    filters: filters[SHEETS.DELEGATE],
    enabled: !!filters[SHEETS.DELEGATE],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  // 디테일 GET SP 2 결과셋: o_rc1=디테일 그리드, o_rc2=디테일 폼 8필드(design 03 §4.3).
  const subRows = useMemo<SubRow[]>(() => subData?.o_rc1 ?? [], [subData]);
  const detail = useMemo<ConfirmDetail>(() => {
    const r = (subData as { o_rc2?: Record<string, unknown>[] } | undefined)?.o_rc2?.[0];
    if (!r) return emptyDetail;
    return {
      requestNo: str(r.CHANGE_REQ_NO),
      title: str(r.REQUEST_TITLE),
      requestor: str(r.REQUEST_USER),
      requestDeptName: str(r.REQUEST_DEPT),
      approval: str(r.APPROVAL_USER),
      appDeptName: str(r.APPROVAL_DEPT_NAME),
      changeReason: str(r.CHANGE_REASON_CODE),
      reasonDetail: str(r.CHANGE_REASON_DETAIL),
    };
  }, [subData]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + Period 기본값(D-14) + 컬럼메타 1회 fetch.
    clearFilters();
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // 개인화 조회조건 복원(F6 저장분, 1회) — initPeriodDefault 뒤 비동기 적용이라 저장된 기간이 있으면
    //   그 값이 우선, 없으면 D-14 기본 유지. 형제 화면 파리티(SSP0015 등).
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns();
  };

  // 마스터행 더블클릭 -> 디테일/위임자 로드 + 선택행 세팅(진입가드 Rows>0 은 그리드가 셀 히트로 보장, G2/G3).
  const handleRowDblClick = (row: Record<string, unknown>) => loadDetail(row);

  // === 액션버튼 동적 Visibility (design 01 §2-A A1~A5 — 그룹권한 아님, userId 데이터 비교, hook #128) ===
  const row = selectedMasterRow;
  const delegateRow = (delegateData as { o_rc1?: Record<string, unknown>[] } | undefined)
    ?.o_rc1?.[0];
  // 위임자 2값 — 위임자 SP 우선, 없으면 마스터 행. 두 원천의 **커서 컬럼명이 다르다**:
  //   위임자 SP(BODY:664-665)는 DELEGATEE_ID / DEPT_ID, 마스터 GET(BODY:251-268)은
  //   DELEGATEE_USER / DELEGATEE_DEPT. 그래서 각각 전용 상수로 읽는다.
  //   2026-09-30 수정: 이전 코드가 위임자 SP 를 마스터 키(DELEGATEE_USER/DELEGATEE_DEPT)로 읽어
  //   delegateRow 쪽이 항상 undefined 였다. delegatee 는 마스터 fallback 이 있어 무해했지만
  //   delegateeDept 는 fallback 이 없어 **항상 빈 문자열이 SAVE payload 로 나갔다**(Save.ts:253).
  //   마스터 GET 이 이미 위임 테이블까지 해소하므로(status Q/D 일 때 E.DELEGATEE_ID / F.DEPT_ID)
  //   fallback 이 정본이고, SP 값은 더블클릭 직후 최신값을 덮는 역할이다.
  const delegatee =
    str(delegateRow?.[DELEGATE_COLUMNS.DELEGATEE_USER]) ||
    str(row?.[MASTER_USER_COLUMNS.DELEGATEE_USER]);
  const delegateeDept =
    str(delegateRow?.[DELEGATE_COLUMNS.DELEGATEE_DEPT]) ||
    str(row?.[MASTER_USER_COLUMNS.DELEGATEE_DEPT]);
  const status = str(row?.[MASTER_USER_COLUMNS.STATUS]);
  const changeType = str(row?.[MASTER_USER_COLUMNS.CHANGE_TYPE]);
  const isRequested = status === STATUS_REQUESTED;
  const canApprove =
    !!row &&
    isRequested &&
    (str(row[MASTER_USER_COLUMNS.APPROVAL_USER]) === sesUserId || delegatee === sesUserId);
  const canReject = canApprove; // A2 = Approval 동일 조건(승인자/대결자)
  const canSelfReject =
    !!row && isRequested && str(row[MASTER_USER_COLUMNS.REQUEST_USER]) === sesUserId;
  const rowDivision = str(row?.[MASTER_USER_COLUMNS.DIVISION_ID]);
  const chkEditable = isChkEditable(status); // status else(Q) 만 CHK 토글 가능(§3.4)

  // 디테일(subData) 도착 시 CHK 상태머신 초기화(§3.4) — 마스터 status 기준 초기 체크셋.
  //   사용자 토글은 이후 유지(subData 불변이면 effect 미발화). loadDetail 이 checkedIds 를 이미 비운다.
  useEffect(() => {
    setCheckedIds(
      computeInitialCheckedIds(subRows as unknown as Record<string, unknown>[], status)
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [subData]);

  // === 저장(dual-SP) — AS-IS SaveDraftingData(DE_CONFIRM) + SaveData(CONFIRM/_40) per-row (design 03 §4.4) ===
  //   call-proc 결과 false-success 판정(convert-core §2.4).
  //   주의: `code > 0` 으로 판정하면 안 된다 — PKG_SSP0003 의 SAVE SP 들은 실패 시 CODE='**-1**' 을
  //   반환하므로(BODY:3877 등) 양수 비교는 실패를 전부 성공으로 읽는다. 0 이 아닌 유한수면 실패다.
  //   NaN(=code 미포함 응답)은 실패로 보지 않는다 — 정상 응답에 code 가 없는 엔드포인트가 있다.
  //   실무상 이 함수보다 공용 responseInterceptor 가 먼저 throw 하지만(그래서 사고 당시 이 버그는
  //   드러나지 않았다), 인터셉터를 타지 않는 경로가 생기면 조용한 false-success 가 된다.
  const isFail = (res: { status: number; data?: { code?: unknown } }): boolean => {
    if (res.status >= 400) return true;
    const code = Number(res.data?.code);
    return Number.isFinite(code) && code !== 0;
  };

  // AS-IS sChangeType 산출 (cs:1254~1259 / 1326~1331) — 마스터 CHANGE_TYPE 과 액션 status 조합.
  //   'N'(신규) + 승인('A') -> 'P'(Plan) / 'N' + 그 외 -> 'C'(Confirm) / 그 밖은 원값 그대로.
  const erpChangeTypeOf = (masterChangeType: string, saveStatus: string): string => {
    if (masterChangeType !== CHANGE_TYPE.NEW) return masterChangeType;
    return saveStatus === SAVE_STATUS.APPROVED ? CHANGE_TYPE.PLAN : CHANGE_TYPE.CONFIRM;
  };

  /**
   * ERP 실시간 송신 — AS-IS `CallClient.FN_ERP_UIWebService(reqNo, changeType, status)` 의 TO-BE 등가.
   *   BE 공통창구 → nscm-if `POST /api/if/send/NSD0100`. 결과만 돌려준다(안내·보상은 호출부가 한다).
   *   호출 자체 실패는 AS-IS catch 블록과 같이 'C_E' 다.
   */
  const callErpIf = async (
    changeReqNo: string,
    erpChangeType: string,
    shipmentStatus: string
  ): Promise<{ eType: string; eMessage: string }> => {
    try {
      const res = await apiClient.post<{ E_TYPE?: unknown; E_MESSAGE?: unknown }>(ERP_IF_PATH, {
        CHANGE_REQ_NO: changeReqNo,
        CHANGE_TYPE: erpChangeType,
        SHIPMENT_STATUS: shipmentStatus,
      });
      if (isFail(res)) return { eType: ERP_IF_PI_FAIL, eMessage: '' };
      return {
        eType: str(res.data?.result?.E_TYPE),
        eMessage: str(res.data?.result?.E_MESSAGE),
      };
    } catch {
      return { eType: ERP_IF_PI_FAIL, eMessage: '' };
    }
  };

  /** ERP 인터페이스 테이블 적재 — `P_SSP0003_SAVE_REQ_IF_CHECK`. 실패·예외는 false. */
  const stageErpIf = async (
    changeReqNo: string,
    changeStatus: string,
    erpChangeType: string,
    partialApproval: boolean,
    timeZone: string
  ): Promise<boolean> => {
    try {
      const res = await apiClient.post<{ code?: unknown }, Record<string, string>>(
        `/${MENU_ID}/main/${SAVE_BTN.IF_CHECK}/call-proc`,
        {
          changeRequestNo: changeReqNo,
          changeStatus,
          timeZone,
          changeType: erpChangeType,
          partialApproval: partialApproval ? 'T' : 'F',
        }
      );
      return !isFail(res);
    } catch {
      return false;
    }
  };

  /** 보상 SP 호출(초안 되돌림·ERP 거절 내역 적재). 실패해도 흐름은 잇는다 — AS-IS 도 결과를 보지 않는다. */
  const callCompensate = async (btn: string, payload: Record<string, string>): Promise<void> => {
    try {
      await apiClient.post<{ code?: unknown }, Record<string, string>>(
        `/${MENU_ID}/main/${btn}/call-proc`,
        payload
      );
    } catch {
      // 보상 실패는 사용자 안내(MSG01208/MSG01215)에 이미 포함된다.
    }
  };

  /**
   * 승인 경로 ERP 연쇄 — AS-IS `GetErpIFCheckNew("A")`(cs:1317~1492).
   *   ① IF_CHECK('A') 적재 → ② ERP 송신 → ③ 결과 처리. 반환 ok 가 false 면 호출부가 확정을 'E' 로 저장한다(cs:2021~2024).
   *     S·그 외      → ok
   *     S_E          → 거절 CONFIRM 초안 되돌림 + 거절 내역 적재 + MSG00197. ok(거절분은 확정에서 뺀다)
   *     E            → 위와 같고 ok=false
   *     F · C_E      → IF_CHECK('R') 재적재 + 취소 송신('C') + MSG00204. ok=false
   *     적재 실패    → ok=false (AS-IS 는 무안내. TO-BE 는 MSG00204 로 알린다)
   */
  const runApprovalErpChain = async (
    changeReqNo: string,
    masterChangeType: string,
    partialApproval: boolean,
    userId: string,
    timeZone: string
  ): Promise<{ ok: boolean; rejectedIds: string[] }> => {
    const erpChangeType = erpChangeTypeOf(masterChangeType, SAVE_STATUS.APPROVED);
    const systemError = (): void =>
      void setAlert({
        type: 'alert',
        content: t(MSG.ERP_SYSTEM_ERROR, '__System error. Request No : {0}').replace(
          '{0}',
          changeReqNo
        ),
      });

    const staged = await stageErpIf(
      changeReqNo,
      SAVE_STATUS.APPROVED,
      erpChangeType,
      partialApproval,
      timeZone
    );
    if (!staged) {
      systemError();
      return { ok: false, rejectedIds: [] };
    }

    const erp = await callErpIf(changeReqNo, erpChangeType, SAVE_STATUS.APPROVED);

    if (erp.eType === ERP_IF_ERROR || erp.eType === ERP_IF_PARTIAL_ERROR) {
      const errors = parseErpErrors(erp.eMessage);
      if (errors.length > 0) {
        await callCompensate(SAVE_BTN.DELETE_BY_CONFIRM, {
          confirmId: errors.map(e => e.confirmId).join('^'),
          changeRequestNo: changeReqNo,
          delFlag: 'D',
          userId,
          timeZone,
          ifSendFlag: 'Y',
          changeType: CHANGE_TYPE.CONFIRM,
        });
        await callCompensate(SAVE_BTN.ERP_ERROR_CONFIRM, {
          changeRequestNo: errors.map(() => changeReqNo).join('^'),
          confirmId: errors.map(e => e.confirmId).join('^'),
          eType: ERP_IF_ERROR,
          eMessage: errors.map(e => e.message).join('^'),
          userId,
        });
      }
      void setAlert({
        type: 'alert',
        content: t(MSG.ERP_ISSUE, '__ERP cannot be processed due to an ISSUE. {0}').replace(
          '{0}',
          errors.length > 0
            ? errors.map(e => `${e.confirmId}:${e.message}`).join('\n')
            : erp.eMessage
        ),
      });
      return {
        ok: erp.eType === ERP_IF_PARTIAL_ERROR,
        rejectedIds: errors.map(e => e.confirmId),
      };
    }

    if (erp.eType === ERP_IF_NO_DATA || erp.eType === ERP_IF_PI_FAIL) {
      // cs:1416~1440 — 적재를 반려('R')로 다시 돌리고 ERP 로 취소를 보낸 뒤 안내한다.
      await stageErpIf(changeReqNo, SAVE_STATUS.REJECT, erpChangeType, false, timeZone);
      await callErpIf(changeReqNo, CHANGE_TYPE.CONFIRM, '');
      systemError();
      return { ok: false, rejectedIds: [] };
    }

    return { ok: true, rejectedIds: [] };
  };

  /**
   * 반려·자기반려·D/O 반려 경로 ERP 연쇄 — AS-IS `GetErpIFCheck(status)`(cs:1246~1316).
   *   호출 조건은 호출부가 본다(마스터 CHANGE_TYPE 'C' 일 때만, cs:1846/1918/1986).
   *   실패하면 안내만 하고 false — 호출부는 확정을 저장하지 않는다(cs:1848 `if (bFlag) SaveData`).
   */
  const runRejectErpChain = async (
    changeReqNo: string,
    masterChangeType: string,
    saveStatus: string,
    timeZone: string
  ): Promise<boolean> => {
    const erpChangeType = erpChangeTypeOf(masterChangeType, saveStatus);
    const staged = await stageErpIf(changeReqNo, saveStatus, erpChangeType, false, timeZone);
    if (!staged) return false; // AS-IS: result_code 가 'S' 가 아니면 송신·저장 없이 끝난다

    const erp = await callErpIf(changeReqNo, erpChangeType, '');
    if (erp.eType === ERP_IF_ERROR) {
      void setAlert({
        type: 'alert',
        content: t(MSG.ERP_ISSUE, '__ERP cannot be processed due to an ISSUE. {0}').replace(
          '{0}',
          erp.eMessage
        ),
      });
      return false;
    }
    if (erp.eType === ERP_IF_NO_DATA) {
      void setAlert({
        type: 'alert',
        content: t(MSG.ERP_SYSTEM_ERROR, '__System error. Request No : {0}').replace(
          '{0}',
          changeReqNo
        ),
      });
      return false;
    }
    if (erp.eType === ERP_IF_PI_FAIL) {
      void setAlert({
        type: 'alert',
        content: t(MSG.ERP_PI_FAIL, '__An error occurred while transferring data.'),
      });
      return false;
    }
    return true;
  };

  /**
   * 저장 — AS-IS 순서 그대로다(2026-11-25 재배치. 종전은 확정을 먼저 저장해 ERP 송신 실패를 되돌리지 못했다).
   *   승인(cs:2020~2024)        : 상세저장 → IF_CHECK → ERP 송신 → 결과가 좋으면 확정 'A', 아니면 확정 'E'
   *   반려·자기반려·D/O(cs:1845~1849 등): 상세저장 → (CHANGE_TYPE 'C' 일 때만 IF_CHECK → ERP 송신) → 성공일 때만 확정
   */
  const doSave = async (saveStatus: string): Promise<void> => {
    const subList = subRows as unknown as Record<string, unknown>[];
    const checkedSet = new Set(checkedIds);
    const count = countChk(subList, checkedSet);
    const changeStatus = decideChangeStatus(saveStatus, count); // A→A/R/P, 그 외 status
    const changeReqNo = str(row?.[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
    const userId = sesUserId;
    const isApproval = saveStatus === SAVE_STATUS.APPROVED;
    // 사용자 TZ(SCM_ADM_USER_M.TMZ_CD) — AS-IS 가 p_time_zone 으로 넘기던 값.
    //   주의: 이 화면은 값을 넘겨도 **현재 동작 변화가 없다**. PKG_SSP0003 의 FN_MULTY_TIME 호출이
    //   전부 주석 처리(`/*FN_MULTY_TIME(@p_time_zone)*/`)돼 APPROVAL_TIME·LAST_UPDATE_DATE 가 모두
    //   SYSDATE 이고, PR_SSP_ANL_SHIP_CONFIRM_HIST 에 전달되지만 거기서도 미사용이다.
    //   즉 AS-IS 는 승인시각을 사용자 TZ 로 저장했으나 TO-BE 는 한국시간 저장이다(DB 팀 확인 항목).
    //   그래도 AS-IS 와 같은 인자를 싣는다 — 주석이 풀리면 그 즉시 올바르게 동작한다.
    const timeZone = sessionTimeZone({ tmzCd });

    // 1) Drafting(DE_CONFIRM) — 전행 status_detail(A: 체크A/미체크R, 그 외 status) + change_status
    const dePayload = buildDeConfirmPayload(subList, checkedSet, saveStatus, changeStatus, {
      changeReqNo,
      rejectReason,
      userId,
    });
    const resDe = await apiClient.post<{ code?: unknown }, Record<string, string>>(
      `/${MENU_ID}/main/${SAVE_BTN.SAVE_DE}/call-proc`,
      dePayload
    );
    if (isFail(resDe)) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '__Failed to save.') });
      return;
    }

    // 2) ERP 연쇄(IF_CHECK 적재 → 실시간 송신) — 확정 저장보다 **먼저** 한다. 결과가 확정 상태를 정한다.
    let confirmAction: string = saveStatus;
    let rejectedIds = new Set<string>();
    let erpOk = true;
    if (isApproval) {
      const chain = await runApprovalErpChain(
        changeReqNo,
        changeType,
        changeStatus === SAVE_STATUS.PARTIAL,
        userId,
        timeZone
      );
      erpOk = chain.ok;
      rejectedIds = new Set(chain.rejectedIds);
      if (!chain.ok) confirmAction = SAVE_STATUS.ERP_FAIL; // cs:2024 SaveData("E")
    } else if (changeType === CHANGE_TYPE.CONFIRM) {
      const ok = await runRejectErpChain(changeReqNo, changeType, saveStatus, timeZone);
      if (!ok) {
        // AS-IS 는 확정을 저장하지 않고 끝낸다. 상세(DE)만 저장된 상태라 목록을 다시 읽어 보여 준다.
        clearDetail();
        void refetchMain?.();
        return;
      }
    }

    // 3) Confirm(CONFIRM/_40) — 승인은 체크행 NEW_* per-row payload(ERP 가 거절한 CONFIRM 은 뺀다, cs:1055~1066),
    //    'E'·반려 계열은 NEW_* 공란 + division 행0. division 앞2 '40' 라우팅(SAVE vs SAVE_40).
    const confirmCount = countChk(
      subList.filter(r => !rejectedIds.has(str(r[SUB_COL.CONFIRM_ID]))),
      checkedSet
    );
    const { payload, is40 } = buildConfirmPayload(
      subList,
      checkedSet,
      confirmAction,
      decideChangeStatus(confirmAction, confirmCount),
      {
        changeReqNo,
        rejectReason,
        changeType,
        delegatee,
        delegateeDept,
        userId,
        timeZone,
        excludeIds: rejectedIds,
      }
    );
    const resSave = await apiClient.post<{ code?: unknown }, Record<string, string>>(
      `/${MENU_ID}/main/${is40 ? SAVE_BTN.SAVE_40 : SAVE_BTN.SAVE}/call-proc`,
      payload
    );
    if (isFail(resSave)) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '__Failed to save.') });
      return;
    }

    // 성공 안내는 ERP 연쇄가 깨끗이 끝났을 때만 — 실패·일부 거절은 위에서 이미 사유를 알렸다.
    if (erpOk && rejectedIds.size === 0) {
      void setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '__Saved.') });
    }
    // 컨펌(승인/반려) 완료 → 하단 디테일 그리드·폼·체크 초기화(사용자 지시 2026-10-01).
    //   clearDetail 이 SUB/DELEGATE 필터를 undefined 로 비워 디테일 조회가 꺼지고 그리드가 비워진다.
    //   마스터(상단)는 refetch 로 갱신된 status 를 반영한다.
    clearDetail();
    void refetchMain?.(); // filters 불변이라 refetch 허용
  };

  // === 액션 저장 (design 01 §2-E 가드 순서 G2~G17 준수) ===
  const runAction = (action: ACTION, confirmMsg: string) => {
    // G2/G7/G12: 서브그리드 0행이면 무동작(무메시지).
    if (subRows.length === 0) return;
    void (async () => {
      if (savingRef.current) return;
      savingRef.current = true;
      // 서버 작업(사전검증 + doSave) 동안 로딩 인디케이터 표시. 사용자 결정 대기(확인 다이얼로그)
      //   동안은 아래에서 잠시 숨겼다가 재개한다. finally 에서 반드시 해제한다.
      setActionLoading(true);
      try {
        const subList = subRows as unknown as Record<string, unknown>[];
        const checkDiv =
          str(subList[0]?.[SUB_COL.DIVISION_ID]) || rowDivision || sc.divisionIds[0] || '';

        // G13: (승인) SSP Daily Plan 엔진 수행중 체크(MSG00291).
        if (action === ACTION.APPROVAL) {
          const eng = await checkEngProcessing(checkDiv);
          if (eng.blocked) {
            void setAlert({
              type: 'alert',
              // MSG01294 EN="...Try again after {0} minutes." 의 {0} 은 i18next 보간자({{ }})가 아니므로
              //   t() 인자로는 치환되지 않는다 — 남은시간을 수동 치환(자매 shipment-semi-dept-day/shipment-change-request 동일 패턴).
              content: t(MSG.ENGINE_PROCESSING, {
                defaultValue: '_SSP Daily Plan is processing. Please try again after {0} minutes.',
              }).replace('{0}', String(eng.remainMinute)),
            });
            return;
          }
        }

        // G3/G8/G14: ERP I/F 차단구간(SSPBlockCheckIF_SCP) — BLOCK_YN='Y'면 차단.
        if (await checkErpBlock(checkDiv)) {
          void setAlert({
            type: 'alert',
            content: t(MSG.ERP_BLOCK, '__ERP interface is blocked.'),
          });
          return;
        }

        // G15: (승인) D/O 생성 체크 — 생성건 있으면 해당 건 D/O Reject 저장('O') 후 종료(MSG00413).
        if (action === ACTION.APPROVAL) {
          for (const r of subList) {
            const scs = await checkShipmentStatus(
              str(r[SUB_COL.DIVISION_ID]),
              str(r[SUB_COL.CONFIRM_ID])
            );
            if (scs.blocked) {
              void setAlert({
                type: 'alert',
                content: t(MSG.DO_BLOCK, {
                  defaultValue: '_ERP D/O created — SSP plan change not allowed.',
                  confirmId: scs.confirmIds.join(','),
                }),
              });
              await doSave(SAVE_STATUS.DO_REJECT);
              return;
            }
          }
        }

        // G4/G9: (반려/자기반려) 사유 필수(MSG00181).
        if (action !== ACTION.APPROVAL && !rejectReason.trim()) {
          void setAlert({
            type: 'alert',
            content: t(MSG.REJECT_REASON_REQUIRED, {
              defaultValue: '_Please enter the reason for rejection.',
            }),
          });
          return;
        }

        // G5/G10/G16: ChkDraftingData 전체체크/체크0 가드(MSG00420/421/422/181).
        const count = countChk(subList, new Set(checkedIds));
        const chk = checkDraftingData(action, count, rejectReason);
        if (!chk.ok && chk.msg) {
          void setAlert({
            type: 'alert',
            content: t(MSG[chk.msg], { defaultValue: GUARD_FALLBACK[chk.msg] }),
          });
          return;
        }

        // G6/G11/G17: 확인 다이얼로그(승인 MSG01203 / 반려 MSG01204 / 자기반려 MSG01205).
        //   사용자 결정 대기 동안은 로딩을 숨긴다(처리중이 아니라 입력 대기이므로).
        setActionLoading(false);
        const ok = await setAlert({
          type: 'confirm',
          content: t(confirmMsg, { defaultValue: '_Proceed?' }),
        });
        if (!ok) return;

        // 저장(doSave) 진행 — 로딩 재개.
        setActionLoading(true);
        await doSave(action);
      } catch (error) {
        // 필수: catch 가 없으면 이 async IIFE 는 void 로 버려지므로 예외가 조용히 사라진다.
        //   SAVE SP 는 실패 시 RAISE 하지 않고 ROLLBACK TO SAVEPOINT 후 O_RESULT_CURSOR 에
        //   CODE='-1' + MSG=SQLERRM 을 담아 정상 반환하고, 공용 responseInterceptor
        //   (axios-interceptors.ts:29-33)가 그 CODE 를 보고 throw 한다 — 즉 저장 실패는
        //   반환값이 아니라 **예외**로 온다. catch 가 없던 동안 사용자에게는 확인 다이얼로그
        //   이후 아무 일도 일어나지 않는 것으로 보였다(2026-09-30 실사고: 승인이 ORA-01400
        //   PLAN_START_YYYYMMDD 로 롤백됐는데 화면에 아무 메시지도 없었다).
        //   SQLERRM 을 그대로 보여준다 — 원인(어느 컬럼/제약)이 메시지에 들어 있어 삼키면 진단이 불가능하다.
        const reason = error instanceof Error ? error.message?.trim() : '';
        void setAlert({
          type: 'alert',
          content: reason || t(MSG.SAVE_FAIL, { defaultValue: '_Failed to save.' }),
        });
      } finally {
        savingRef.current = false;
        setActionLoading(false); // 성공/실패/취소/예외 어느 경로로 빠져나가도 로딩 해제
      }
    })();
  };

  const handleApproval = () => runAction(ACTION.APPROVAL, MSG.APPROVE_CONFIRM);
  const handleReject = () => runAction(ACTION.REJECT, MSG.REJECT_CONFIRM);
  const handleSelfReject = () => runAction(ACTION.SELF_REJECT, MSG.SELF_REJECT_CONFIRM);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // Insert/Delete/Save = 동작 없는 no-op 버튼이라 전부 제거(false). 사용자 결정 2026-10-20: 무동작 버튼은
    //   노출하지 않는다(AS-IS NO-OP override, design 01 §2-B 는 참고). 키 생략 금지(공용 addRow/removeRow 부활).
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  // 액션 버튼 3종은 BtnArea(SubTitle customButtons)가 렌더한다 — 사용자 지시 2026-09-30
  //   (조회영역 extraButtons 로 옮겼다가 같은 날 다시 BtnArea 로 환원). 조건 미충족 시 '숨김'이
  //   아니라 'disabled'(살아 보이는 죽은 버튼 방지).
  //   AS-IS(design 01 §2-A A1~A4)는 우상단 + 조건부 숨김이었다. 숨김을 버리는 이유는 실측 —
  //   minyonglee1 기준 status='Q' 3,828행 중 APPROVAL_USER/DELEGATEE_USER 가 본인인 행이 0건이라
  //   Approval/Reject 가 구조적으로 도달 불가였고(Self Reject 는 1건), 그래서 "버튼이 다 없다"로
  //   보고됐다. 드리프트는 04_react-gap.md 에 기재한다.
  const rejectEnabled = canReject || canSelfReject;
  const gridDivision = rowDivision || sc.divisionIds[0] || '';

  return (
    <>
      {/* 액션(승인/반려) 진행 표시 — 조회 로딩(전역 useIsBusy 스피너)과 동일한 딤 오버레이 + 중앙 원형
          스피너로 통일한다(사용자 지시 2026-10-01). 수동 apiClient 경로라 전역 스피너가 안 잡혀 로컬로 렌더. */}
      {actionLoading && (
        <div className={styles.actionSpinner}>
          <ProgressIndicator shape='circular' open />
        </div>
      )}
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestConfirmSsp0003Form
          onSearch={handleSearch}
          onRequestorSearch={() => setOpenRequestor(true)}
          onItemSearch={() => setOpenItem(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentChangeRequestConfirm'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        // 액션 3종은 BtnArea(SubTitle) 우측 버튼으로 렌더 — 상시 노출 + 자격 미충족 시 disabled.
        customButtons={[
          {
            label: t(LBL.APPROVAL, '_Approval'),
            action: handleApproval,
            disabled: !canApprove,
          },
          {
            label: t(LBL.REJECT, '_Reject'),
            action: handleReject,
            disabled: !canReject,
          },
          {
            label: t(LBL.SELF_REJECT, '_Self Reject'),
            action: handleSelfReject,
            disabled: !canSelfReject,
          },
        ]}
      />

      {/* 상(마스터 그리드) / 하(Request Confirm Detail 폼 + 디테일 그리드) 2분할 — 경계를 드래그해 상하 크기 조절.
          자매 SSP0200/SSP0201 과 같은 PanelGroup 방식이다. 폼은 하단 패널 안에서 자연 높이로 고정되고
          남는 높이를 디테일 그리드가 갖으므로, 스플리터는 사실상 두 그리드만 늘이고 줄인다.
          상단 그리드를 하단 그리드보다 작게 — SSP0200 과 동일하게 상단만 px(200px) 로 작게 고정하고
          하단은 나머지를 전부 가져간다(사용자 지시 2026-11-13). % 비율이면 화면 높이에 따라 상단이 커 보여
          체감이 어긋나므로 px 고정으로 맞춘다. */}
      <div className={styles.splitWrapper}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel defaultSize='220px' minSize='15%'>
            <div className={styles.mainPane}>
              <ShipmentChangeRequestConfirmSsp0003MainGrid
                rows={mainRows}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                division={gridDivision}
                adminColumns={staticColumns[SHEETS.MAIN]}
                onRowDblClick={handleRowDblClick}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          {/* 하단(폼 + 디테일 그리드) — defaultSize 미지정 → 상단(px 고정)을 뺀 나머지를 전부 가져간다. */}
          <Panel minSize='30%'>
            <div className={styles.detailPane}>
              <div className={styles.detailForm}>
                <ConfirmDetailPanel
                  detail={detail}
                  rejectReason={rejectReason}
                  rejectEnabled={rejectEnabled}
                  onRejectReasonChange={setRejectReason}
                />
              </div>

              <div className={styles.subPane}>
                <ShipmentChangeRequestConfirmSsp0003SubGrid
                  rows={subRows}
                  gridRef={subGridRef}
                  gridFilterRef={subFilterRef}
                  division={gridDivision}
                  changeType={changeType}
                  adminColumns={staticColumns[SHEETS.SUB]}
                  checkedIds={checkedIds}
                  chkEditable={chkEditable}
                  onToggle={toggleCheck}
                  onToggleAll={check => {
                    // 전체선택/해제 — 활성(status else/Q)일 때만. 전체 = 현재 서브행 CONFIRM_ID 전건.
                    const ids = check
                      ? (subRows as unknown as Record<string, unknown>[]).map(r =>
                          str(r[SUB_COL.CONFIRM_ID])
                        )
                      : [];
                    setCheckedIds(ids);
                  }}
                />
              </div>
            </div>
          </Panel>
        </PanelGroup>
      </div>

      {/* Requestor 검색 — 공용 SsoUserModal(AS-IS UserInfoPopup, SSO=false 단일선택). */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        setSelectedValue={(userId: string) => {
          setSearchCondition({ requestId: userId });
          setOpenRequestor(false);
        }}
        ssoUserYn='N'
      />

      {/* Model/Nickname 검색 — 공용 `MaterialByDivisionModal`(COM0013,
          PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)로 교체(사용자 지시 2026-10-08, 4자매 공통).
          AS-IS 는 `SCM0002_ItembyDivisionPopup`(= DM.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx_40_**TEST**)
          이라 **조회 SP 가 달라지는 의도적 드리프트**다(§Q-5 기록).
          `multiDivision` — 이 화면 Division 은 다중선택이라 콤마 결합해 그대로 넘긴다(SP 가
          P_DIVISION_ID 를 콤마 split → IN 처리). 종전엔 `divisionIds[0]` 만 보내 나머지가 버려졌다.
          한계: AS-IS 가 함께 넘기던 scmSite(From Site) 사전필터는 이 모달 계약에 site 축이 없어 전달
          불가다 — 종전 `salesSite` 전달분이 사라진다(§Q-5 한계 기록).
          Division=ALL(divisionIds 빈 배열)이면 'ALL' 센티널을 넘긴다(사용자 신고 2026-10-12):
          빈 문자열이면 모달이 `enabled: !!divisionId` 로 조회를 막아 검색이 안 됐다. 조회 SP
          P_SCM0002_GET_MATERIAL_BY_DIVISION 은 `P_DIVISION_ID='ALL'` 분기로 전체를 돌려주므로
          메인 그리드 조회(joinOrAll)와 동일하게 ALL 을 전송한다. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        multiDivision
        setSelectedValue={itemId => setSearchCondition({ itemId: String(itemId ?? '') })}
        preSearchParams={{
          divisionId: sc.divisionIds.length ? sc.divisionIds.join(',') : ALL,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
