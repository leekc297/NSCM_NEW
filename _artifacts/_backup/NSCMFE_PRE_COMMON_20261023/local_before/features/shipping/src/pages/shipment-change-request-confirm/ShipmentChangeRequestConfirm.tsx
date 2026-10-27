import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ConfirmDetailPanel } from './components/ConfirmDetailPanel';
import { ShipmentChangeRequestConfirmForm } from './components/ShipmentChangeRequestConfirmForm';
import { ShipmentChangeRequestConfirmMainGrid } from './components/ShipmentChangeRequestConfirmMainGrid';
import { ShipmentChangeRequestConfirmSubGrid } from './components/ShipmentChangeRequestConfirmSubGrid';
import { useShipmentChangeRequestConfirmActions } from './hooks/useShipmentChangeRequestConfirmActions';
import {
  ACTION,
  LBL,
  MASTER_USER_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
  STATUS_REQUESTED,
} from './shipment-change-request-confirm.constants';
import type { ConfirmDetail, MainRow, SubRow } from './shipment-change-request-confirm.types';
import styles from './ShipmentChangeRequestConfirm.module.scss';
import { useShipmentChangeRequestConfirmStore } from './useShipmentChangeRequestConfirmStore';

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

// AS-IS GSCM.SSP.Plan.UIL SSP0202_ShipmentChangeRequestConfirm — 출하요청 변경 승인(조회전용 승인 화면).
//   설계: .atlas/gscm-design/SSP0202/design/00~03. 상세 매핑: __asis-mapping__.md.
//   마스터-디테일 2그리드 + 디테일 폼. 액션 3종(Approval/Reject/SelfReject)은 상시 노출 + 자격 미충족 시 disabled.
//   PKG_SSP0202 는 배포 완료(2026-10-07 ora.py 실측 VALID) — 종전 "미배포" 주석은 stale 이었다.
//   잔여 미배선: IF_CHECK(승인 후 ERP 적재) · PLAN_CHECK · SCS_CHECK · SAVE_40 분기(constants 주석 참조).
export const ShipmentChangeRequestConfirm = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sesUserId = useSessionStore(s => s.session.userId) ?? '';
  const { checkErpBlock } = useShipmentChangeRequestConfirmActions();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const savingRef = useRef(false);

  const sc = useShipmentChangeRequestConfirmStore(s => s.searchCondition);
  const setSearchCondition = useShipmentChangeRequestConfirmStore(s => s.setSearchCondition);
  const filters = useShipmentChangeRequestConfirmStore(s => s.filters);
  const setFilter = useShipmentChangeRequestConfirmStore(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestConfirmStore(s => s.clearFilters);
  const initPeriodDefault = useShipmentChangeRequestConfirmStore(s => s.initPeriodDefault);
  const openSearchArea = useShipmentChangeRequestConfirmStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestConfirmStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestConfirmStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestConfirmStore(s => s.fetchStaticColumns);
  const initialized = useShipmentChangeRequestConfirmStore(s => s.initialized);
  const selectedMasterRow = useShipmentChangeRequestConfirmStore(s => s.selectedMasterRow);
  const loadDetail = useShipmentChangeRequestConfirmStore(s => s.loadDetail);
  const clearDetail = useShipmentChangeRequestConfirmStore(s => s.clearDetail);
  const restoreSearchConditions = useShipmentChangeRequestConfirmStore(
    s => s.restoreSearchConditions
  );
  const rejectReason = useShipmentChangeRequestConfirmStore(s => s.rejectReason);
  const setRejectReason = useShipmentChangeRequestConfirmStore(s => s.setRejectReason);

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
  // 위임자(Delegate_Load) — 마스터 더블클릭 시 division+approval 로 조회. 반환 DELEGATEE_USER 로 A1/A7 판정.
  const { data: delegateData } = useTabProcQuery<MENU_ID, SHEETS.DELEGATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DELEGATE,
    tabId,
    filters: filters[SHEETS.DELEGATE],
    enabled: !!filters[SHEETS.DELEGATE],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  // 디테일 GET SP 2 결과셋: o_rc1=디테일 그리드, o_rc2=디테일 폼 8필드(design 03 §4).
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

  const { mutate: mutateSave } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + Period 기본값(D-14) + 컬럼메타 1회 fetch.
    clearFilters();
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // 개인화 조회조건 복원(F6 저장분, 1회) — initPeriodDefault 뒤에 비동기로 적용된다.
    //   저장분에 날짜는 없으므로(personalizeCondition 이 날짜를 제외 저장) 기간 기본값과 충돌하지 않는다.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns();
  };

  // 마스터행 더블클릭 -> 디테일/위임자 로드 + 선택행 세팅(진입가드 Rows>0 은 그리드가 셀 히트로 보장).
  const handleRowDblClick = (row: Record<string, unknown>) => loadDetail(row);

  // === 액션버튼 동적 Visibility (design 01 §2 A1~A9 — 그룹권한 아님, userId 데이터 비교, hook #128) ===
  const row = selectedMasterRow;
  const delegatee =
    str(
      (delegateData as { o_rc1?: Record<string, unknown>[] } | undefined)?.o_rc1?.[0]
        ?.DELEGATEE_USER
    ) || str(row?.[MASTER_USER_COLUMNS.DELEGATEE_USER]);
  const status = str(row?.[MASTER_USER_COLUMNS.STATUS]);
  const isRequested = status === STATUS_REQUESTED;
  const canApprove =
    !!row &&
    isRequested &&
    (str(row[MASTER_USER_COLUMNS.APPROVAL_USER]) === sesUserId || delegatee === sesUserId);
  const canReject = canApprove; // A3 = A1 동일 조건
  const canSelfReject =
    !!row && isRequested && str(row[MASTER_USER_COLUMNS.REQUEST_USER]) === sesUserId;
  const isDelegate = !!row && delegatee === sesUserId; // A7 _bDelegate_Flag

  // === 액션 저장 (design 01 §2 E/F, 가드 순서 준수) ===
  //   현재 FE 는 클라 가드(RowCount0/사유 필수/확인) + ERP 차단(SSPBlockCheckIF_SCP 콤보)만 수행한다.
  //   미배선: chkSaveYN(SCS_CHECK, MSG01356) · EngProcessingChk(PLAN_CHECK, MSG01294) · 승인 후 IF_CHECK 적재.
  //   SP·버튼메타는 전부 배포돼 있으므로(2026-10-07 실측) 차단 사유는 "미배포"가 아니라 "FE 미배선"이다.
  const runAction = (action: ACTION, confirmMsg: string) => {
    // E9/E5/E1: 디테일 없으면 무동작(무메시지).
    if (subRows.length === 0) return;
    void (async () => {
      if (savingRef.current) return;
      // E2/E6/E12: ERP I/F 차단구간(SSPBlockCheckIF_SCP) — BLOCK_YN='Y'면 차단.
      //   AS-IS 가드 순서(design 01 §2 E1-E8): RowCount0 -> ERP block -> confirm -> 사유필수. ERP 차단 최우선.
      if (await checkErpBlock(sc.divisionId)) {
        void setAlert({
          type: 'alert',
          content: t(MSG.ERP_BLOCK, '__ERP interface is blocked.'),
        });
        return;
      }
      // E13/E7/E3: 확인 다이얼로그(승인 MSG01203 / 반려 MSG01204 / 자기반려 MSG01205).
      const ok = await setAlert({ type: 'confirm', content: t(confirmMsg, { defaultValue: '_Proceed?' }) });
      if (!ok) return;
      // E4/E8: 반려/자기반려 사유 필수(MSG00181) — AS-IS 는 confirm 확인 이후 검증(design 01 §2 E1-E8).
      if (action !== ACTION.APPROVAL && !rejectReason.trim()) {
        void setAlert({
          type: 'alert',
          content: t(MSG.REJECT_REASON_REQUIRED, {
            defaultValue: '_Please enter the reason for rejection.',
          }),
        });
        return;
      }
      savingRef.current = true;
      // SaveData 파라미터(design 01 §F, 34 param 중 핵심) — division 앞2 '40' 런타임 분기(SP 내부).
      const payload = {
        confirmYn: action, // A/R/S
        changeReqNo: str(row?.[MASTER_USER_COLUMNS.CHANGE_REQ_NO]),
        divisionId: sc.divisionId,
        rejectReason: action === ACTION.APPROVAL ? '' : rejectReason,
        delegateYn: isDelegate ? 'Y' : 'N',
        delegatee: isDelegate ? delegatee : '',
        language: useSessionStore.getState().session.langCd ?? '',
      };
      mutateSave([payload] as never, {
        onSuccess: () => {
          void setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '__Saved.') });
          // F4: 저장 성공 후 마스터 재조회 + 하단 디테일 그리드/폼/반려사유 초기화.
          //   처리된 요청의 디테일이 그대로 남아 있으면 아직 승인 대기인 것처럼 보인다(자매 SSP0003 동일 조치).
          clearDetail();
          void refetchMain?.();
        },
        // 저장 실패 surfacing 은 useProcMutation 기본 onError(MSG00003 = SAVE_FAIL alert)로 처리.
        //   F2/F3 세분(SAVE_FAIL vs SYSTEM_ERROR) 은 SAVE SP 응답코드 종속 → convert-sp 후속(미배포).
        //   이중 제출 가드는 뮤테이션이 끝난 뒤에 해제한다(동기 해제는 in-flight 가드를 무력화).
        onSettled: () => {
          savingRef.current = false;
        },
      });
    })();
  };

  const handleApproval = () => runAction(ACTION.APPROVAL, MSG.APPROVE_CONFIRM);
  const handleReject = () => runAction(ACTION.REJECT, MSG.REJECT_CONFIRM);
  const handleSelfReject = () => runAction(ACTION.SELF_REJECT, MSG.SELF_REJECT_CONFIRM);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // D2/D3/D5: 표준 툴바 Insert/Delete/Save = AS-IS NO-OP(본문 공백). 명시적 무동작(키 생략 시 공통
    //   addRow/removeRow 부활 — self-check hotkeyConfig NO-OP 게이트). false 금지(AS-IS 는 버튼 노출).
    insert: () => undefined,
    delete: () => undefined,
    save: () => undefined,
    manual: false,
    upload: false,
  };

  // 커스텀 액션 버튼 3종 — AS-IS(cs:1195)는 자격 미충족 시 Visibility.Never(완전 숨김)이나, 그러면 승인자
  //   본인이 아닌 사용자에게 버튼이 하나도 안 보여 "기능이 없다"고 읽힌다(자매 SSP0003 에서 실사용 신고).
  //   사용자 지시(2026-10-07)로 SSP0003 과 동일하게 **상시 노출 + 자격 미충족 시 disabled** 로 드리프트한다.
  const customButtons = [
    {
      label: t(LBL.APPROVAL, '_Approval'),
      title: t(LBL.APPROVAL, '_Approval'),
      action: handleApproval,
      disabled: !canApprove,
    },
    {
      // GAP-01: LBL01053='Auto' 오매핑 -> LBL00624='Reject'(SCM_ADM_MSG_M/EN.json/KO.json 실측).
      label: t(LBL.REJECT, '_Reject'),
      title: t(LBL.REJECT, '_Reject'),
      action: handleReject,
      disabled: !canReject,
    },
    {
      // GAP-01: LBL01054='BOD Item Valid' 오매핑 -> LBL01113='Self Reject'(실측).
      label: t(LBL.SELF_REJECT, '_Self Reject'),
      title: t(LBL.SELF_REJECT, '_Self Reject'),
      action: handleSelfReject,
      disabled: !canSelfReject,
    },
  ];

  const rejectEnabled = canReject || canSelfReject;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestConfirmForm
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
        <ShipmentChangeRequestConfirmMainGrid
          rows={mainRows}
          gridRef={mainGridRef}
          gridFilterRef={mainFilterRef}
          division={sc.divisionId}
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
        <ShipmentChangeRequestConfirmSubGrid
          rows={subRows}
          gridRef={subGridRef}
          gridFilterRef={subFilterRef}
          division={sc.divisionId}
          changeType={str(row?.[MASTER_USER_COLUMNS.CHANGE_TYPE])}
          adminColumns={staticColumns[SHEETS.SUB]}
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

      {/* Model/Nickname 검색 — 공용 `MaterialByDivisionModal`(COM0013,
          PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)로 교체(사용자 지시 2026-10-08, 4자매 공통).
          AS-IS 는 `SCM0002_ItembyDivisionPopup`(= DM.SCM0002_GET_ITEM_BY_DIVISION_POPUPEx_40_**TEST**)
          이라 **조회 SP 가 달라지는 의도적 드리프트**다(§Q-5 기록).
          Division 은 '40' 고정 단일이라 `multiDivision` 을 쓰지 않는다(자매 SSP0003 과 차이).
          한계: AS-IS scmSite(From Site) 사전필터는 이 모달 계약에 site 축이 없어 전달 불가 —
          종전 `salesSite` 전달분이 사라진다(§Q-5 한계 기록). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemId => setSearchCondition({ itemId: String(itemId ?? '') })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
