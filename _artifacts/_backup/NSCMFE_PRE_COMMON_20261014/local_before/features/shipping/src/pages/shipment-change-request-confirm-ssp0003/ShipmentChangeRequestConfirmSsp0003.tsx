import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ConfirmDetailPanel } from './components/ConfirmDetailPanel';
import { ShipmentChangeRequestConfirmSsp0003Form } from './components/ShipmentChangeRequestConfirmSsp0003Form';
import { ShipmentChangeRequestConfirmSsp0003MainGrid } from './components/ShipmentChangeRequestConfirmSsp0003MainGrid';
import { ShipmentChangeRequestConfirmSsp0003SubGrid } from './components/ShipmentChangeRequestConfirmSsp0003SubGrid';
import { useShipmentChangeRequestConfirmSsp0003Actions } from './hooks/useShipmentChangeRequestConfirmSsp0003Actions';
import {
  ACTION,
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
  const sesUserId = useSessionStore(s => s.session.userId) ?? '';
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
  const initialized = useShipmentChangeRequestConfirmSsp0003Store(s => s.initialized);
  const selectedMasterRow = useShipmentChangeRequestConfirmSsp0003Store(s => s.selectedMasterRow);
  const loadDetail = useShipmentChangeRequestConfirmSsp0003Store(s => s.loadDetail);
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
  const delegateRow = (delegateData as { o_rc1?: Record<string, unknown>[] } | undefined)?.o_rc1?.[0];
  const delegatee =
    str(delegateRow?.DELEGATEE_USER) || str(row?.[MASTER_USER_COLUMNS.DELEGATEE_USER]);
  const delegateeDept = str(delegateRow?.DELEGATEE_DEPT); // AS-IS Delegate_Load [0][1] = _sDelegatee_Dept
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
    setCheckedIds(computeInitialCheckedIds(subRows as unknown as Record<string, unknown>[], status));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [subData]);

  // === 저장(dual-SP) — AS-IS SaveDraftingData(DE_CONFIRM) + SaveData(CONFIRM/_40) per-row (design 03 §4.4) ===
  //   call-proc 결과 false-success 판정(convert-core §2.4): res.status>=400 || code>0.
  const isFail = (res: { status: number; data?: { code?: unknown } }): boolean =>
    res.status >= 400 || Number(res.data?.code) > 0;

  const doSave = async (saveStatus: string): Promise<void> => {
    const subList = subRows as unknown as Record<string, unknown>[];
    const checkedSet = new Set(checkedIds);
    const count = countChk(subList, checkedSet);
    const changeStatus = decideChangeStatus(saveStatus, count); // A→A/R/P, 그 외 status
    const changeReqNo = str(row?.[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
    const userId = sesUserId;
    const timeZone = ''; // TO-BE 세션에 timeZone 없음 → p_time_zone 공란(BE/SP 서버 TZ). 런타임 확정 잔여.

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

    // 2) Confirm(CONFIRM/_40) — 체크행 NEW_* per-row payload, division 앞2 '40' 라우팅(SAVE vs SAVE_40)
    const { payload, is40 } = buildConfirmPayload(subList, checkedSet, saveStatus, changeStatus, {
      changeReqNo,
      rejectReason,
      changeType,
      delegatee,
      delegateeDept,
      userId,
      timeZone,
    });
    const resSave = await apiClient.post<{ code?: unknown }, Record<string, string>>(
      `/${MENU_ID}/main/${is40 ? SAVE_BTN.SAVE_40 : SAVE_BTN.SAVE}/call-proc`,
      payload
    );
    if (isFail(resSave)) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, '__Failed to save.') });
      return;
    }
    void setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '__Saved.') });
    void refetchMain?.(); // filters 불변이라 refetch 허용
  };

  // === 액션 저장 (design 01 §2-E 가드 순서 G2~G17 준수) ===
  const runAction = (action: ACTION, confirmMsg: string) => {
    // G2/G7/G12: 서브그리드 0행이면 무동작(무메시지).
    if (subRows.length === 0) return;
    void (async () => {
      if (savingRef.current) return;
      savingRef.current = true;
      try {
        const subList = subRows as unknown as Record<string, unknown>[];
        const checkDiv = str(subList[0]?.[SUB_COL.DIVISION_ID]) || rowDivision || sc.divisionIds[0] || '';

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
        const ok = await setAlert({
          type: 'confirm',
          content: t(confirmMsg, { defaultValue: '_Proceed?' }),
        });
        if (!ok) return;

        await doSave(action);
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const handleApproval = () => runAction(ACTION.APPROVAL, MSG.APPROVE_CONFIRM);
  const handleReject = () => runAction(ACTION.REJECT, MSG.REJECT_CONFIRM);
  const handleSelfReject = () => runAction(ACTION.SELF_REJECT, MSG.SELF_REJECT_CONFIRM);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // Insert/Delete/Save = AS-IS NO-OP(본문 공백/주석, design 01 §2-B). 명시적 무동작(키 생략 시 공통
    //   addRow/removeRow 부활 — self-check hotkeyConfig NO-OP 게이트). false 금지(AS-IS 는 버튼 노출).
    insert: () => undefined,
    delete: () => undefined,
    save: () => undefined,
    manual: false,
    upload: false,
  };

  // 커스텀 액션 버튼 3종 — 마스터 더블클릭 후 userId 판정으로 조건부 노출(§2-A). 초기(미선택)엔 전부 숨김.
  const customButtons = [
    canApprove && {
      label: t(LBL.APPROVAL, '_Approval'),
      title: t(LBL.APPROVAL, '_Approval'),
      action: handleApproval,
    },
    canReject && {
      label: t(LBL.REJECT, '_Reject'),
      title: t(LBL.REJECT, '_Reject'),
      action: handleReject,
    },
    canSelfReject && {
      label: t(LBL.SELF_REJECT, '_Self Reject'),
      title: t(LBL.SELF_REJECT, '_Self Reject'),
      action: handleSelfReject,
    },
  ].filter(Boolean) as { label: string; title: string; action: () => void }[];

  const rejectEnabled = canReject || canSelfReject;
  const gridDivision = rowDivision || sc.divisionIds[0] || '';

  return (
    <>
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
        customButtons={customButtons}
      />

      <div className={styles.mainGrid}>
        <ShipmentChangeRequestConfirmSsp0003MainGrid
          rows={mainRows}
          gridRef={mainGridRef}
          gridFilterRef={mainFilterRef}
          division={gridDivision}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onRowDblClick={handleRowDblClick}
        />
      </div>

      <div className={styles.detailForm}>
        <ConfirmDetailPanel
          detail={detail}
          rejectReason={rejectReason}
          rejectEnabled={rejectEnabled}
          onRejectReasonChange={setRejectReason}
        />
      </div>

      <div className={styles.subGrid}>
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
              ? (subRows as unknown as Record<string, unknown>[]).map(r => str(r[SUB_COL.CONFIRM_ID]))
              : [];
            setCheckedIds(ids);
          }}
        />
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

      {/* Model 검색 — ItemByDivisionModal(AS-IS SCM0002_ItembyDivisionPopup). */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemId => setSearchCondition({ itemId: String(itemId) })}
        // design 02 §4.6: division=clbDivision.ControlValues, scmSite=clbFromSite.ControlValues 사전필터.
        //   다중선택 중 첫 선택값을 전달(미선택 시 undefined -> 모달 fallback). 다중전달은 후속 확정.
        preSearchParams={{
          divisionId: sc.divisionIds[0],
          itemId: sc.itemId,
          salesSite: sc.fromSiteIds[0],
        }}
        callFromCell={false}
      />
    </>
  );
};
