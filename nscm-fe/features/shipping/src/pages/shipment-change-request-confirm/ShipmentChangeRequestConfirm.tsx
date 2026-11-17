import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ConfirmDetailPanel } from './components/ConfirmDetailPanel';
import { ShipmentChangeRequestConfirmForm } from './components/ShipmentChangeRequestConfirmForm';
import { ShipmentChangeRequestConfirmMainGrid } from './components/ShipmentChangeRequestConfirmMainGrid';
import { ShipmentChangeRequestConfirmSubGrid } from './components/ShipmentChangeRequestConfirmSubGrid';
import { useConfirmDetailFold } from './hooks/useConfirmDetailFold';
import { useShipmentChangeRequestConfirmActions } from './hooks/useShipmentChangeRequestConfirmActions';
import {
  ACTION,
  CHANGE_TYPE_CONFIRM,
  CHANGE_TYPE_NEW,
  DELEGATE_COLUMNS,
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
import { submitConfirmSave } from './utils/shipmentChangeRequestConfirmSave';

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
//   2026-10-14 배선 완료: 승인 저장(SAVE/SAVE_40 division 분기) + 사전체크 3종(SCS_CHECK·PLAN_CHECK·IF_CHECK).
//   **잔여(의도적 미이식)**: ERP 인터페이스 **웹서비스** 호출(AS-IS `CallClient.FN_ERP_UIWebService`,
//     cs:1000~1028). AS-IS 에서도 **전면 주석** 상태라 미이식이 곧 패리티다(사용자 지시 2026-10-14).
//     동명의 DB 프로시저 IF_CHECK 와 혼동하지 말 것 — 그쪽은 배선돼 있다.
export const ShipmentChangeRequestConfirm = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sesUserId = useSessionStore(s => s.session.userId) ?? '';
  const { checkErpBlock, checkScsConfirmId, checkPlanProcessing, checkErpIf } =
    useShipmentChangeRequestConfirmActions();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const savingRef = useRef(false);
  // 공통 툴바 Sort(F3)/Filter(F4)·Excel 대상 = **포커스된 그리드**(상단 main / 하단 sub). DMF0008 패턴:
  //   각 그리드 onGridFocus 로 포커스 시트를 추적하고 SubTitle 의 grid/gridFilter 에 그 그리드 ref 를 넘겨
  //   키보드 F3/F4 가드(grid.containsFocus())까지 포커스 그리드를 보게 한다(버튼·단축키 양쪽 동작,
  //   사용자 요청 2026-11-06). 건수 배지는 main 고정(countGrid). 기본값 main.
  const [focusedSheet, setFocusedSheet] = useState<'main' | 'sub'>('main');
  const focusedGridRef = focusedSheet === 'sub' ? subGridRef : mainGridRef;
  const focusedGridFilterRef = focusedSheet === 'sub' ? subFilterRef : mainFilterRef;

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
  // Request Confirm Detail 접기/펼치기·고정(사용자 지시 2026-11-12 — SSP0200 Request Info 와 같은 형태).
  const confirmDetailFold = useConfirmDetailFold();
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
  // 위임자(Delegate_Load) — 마스터 더블클릭 시 division+approval 로 조회. 반환 DELEGATEE_ID/DEPT_ID(DELEGATE_COLUMNS)로 A1/A7 판정.
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

  // 저장은 `useProcMutation` 을 쓰지 않는다 — 공용 mutation 은 `{ data: [행…] }` 로 보내는데
  //   이 SP 의 PROC_M 에 `JVARCHAR` 가 없어 **33 인자가 전부 NULL 로 바인딩**됐다. SP 가 빈 입력으로
  //   돌고 성공을 돌려줘 "성공 토스트만 뜨고 아무것도 저장 안 되는" 상태였다(사용자 신고 2026-10-14,
  //   SCM_COM_SQL_LOG 실측). 평탄 객체 `apiClient.post` 경로다 — utils/shipmentChangeRequestConfirmSave.ts.

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + Period 기본값(D-14) + 컬럼메타 1회 fetch.
    clearFilters();
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // 개인화 조회조건 복원(F6 저장분, 1회) — initPeriodDefault 뒤에 비동기로 적용된다.
    //   Request Date 도 저장/복원 대상이다(SubTitle conditionIncludeKeys opt-in). restore 가
    //   initPeriodDefault 뒤에 적용되고 periodRestored 가드가 기본값 재클로버를 막아 복원값이 이긴다.
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
  const delegateRow = (delegateData as { o_rc1?: Record<string, unknown>[] } | undefined)?.o_rc1?.[0];
  // 위임자 2값 — 위임자 SP 우선, 없으면 마스터 행. 두 원천의 **커서 컬럼명이 다르다**:
  //   위임자 SP(body 514-516)는 DELEGATEE_ID / DEPT_ID, 마스터 GET(body 280-289)은
  //   DELEGATEE_USER / DELEGATEE_DEPT. 각각 전용 상수로 읽는다(자매 SSP0003 동일, GAP-14).
  //   마스터 GET 이 서버에서 위임 테이블까지 COALESCE 해소하므로 fallback 이 정본이고,
  //   SP 값은 더블클릭 직후 최신값을 덮는 역할이다. (종전엔 DELEGATEE_USER 키로 읽어 SP 응답이
  //   항상 undefined -> delegate 조회가 사실상 무효였다.)
  const delegatee =
    str(delegateRow?.[DELEGATE_COLUMNS.DELEGATEE_USER]) ||
    str(row?.[MASTER_USER_COLUMNS.DELEGATEE_USER]);
  const delegateeDept =
    str(delegateRow?.[DELEGATE_COLUMNS.DELEGATEE_DEPT]) ||
    str(row?.[MASTER_USER_COLUMNS.DELEGATEE_DEPT]);
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

  /**
   * === 액션 저장 (design 01 §2 E/F) ===
   *   AS-IS `BtnApproval_Click`(cs:1372~1413) 가드 순서 그대로:
   *     1 RowCount0 -> 2 SCS체크 -> 3 처리중체크 -> 4 ERP차단 -> 5 확인 -> 6 IF체크 -> 7 저장
   *   2·3 은 **승인 전용**이다(반려/자기반려 핸들러에는 호출이 없다 — cs:1311/1369).
   *
   *   ERP 인터페이스 **웹서비스** 호출(`CallClient.FN_ERP_UIWebService`, cs:1000~1028)은 이식하지
   *   않는다 — AS-IS 도 전면 주석이라 미이식이 곧 패리티다(사용자 지시 2026-10-14 잔여 확정).
   *   6번 IF체크는 그 웹서비스가 아니라 동명의 **DB 프로시저**다.
   */
  const runAction = (action: ACTION, confirmMsg: string) => {
    // E9/E5/E1: 디테일 없으면 무동작(무메시지).
    if (subRows.length === 0) return;
    void (async () => {
      if (savingRef.current) return;
      // GAP-17: 이중 제출 가드를 **진입 즉시** 세팅한다. 종전엔 사전체크·confirm 뒤에 세팅해, 그 사이
      //   await 창(SCS/PLAN/ERP 조회)에서 더블클릭 시 두 흐름이 각자 IF_CHECK(커밋 SP)·SAVE 까지 진행할
      //   수 있었다. 아래 finally 가 모든 return 경로(차단·취소·사유·실패·성공·예외)에서 가드를 해제한다.
      savingRef.current = true;
      try {
        if (action === ACTION.APPROVAL) {
          const changeReqNo = str(row?.[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
          // E10 chkSaveYN: SCS 에 해당 Confirm ID 실적이 생겼으면 승인 불가(MSG00362 -> MSG01356).
          //   fail-closed(GAP-15): 조회 실패·확인 불가는 승인 차단 — "확인 불가"는 MSG01215 로 안내.
          const scs = await checkScsConfirmId(subRows);
          if (scs.blocked) {
            void setAlert({
              type: 'alert',
              content: scs.byError
                ? t(MSG.SYSTEM_ERROR, {
                    defaultValue: 'A system error has occurred. Request No : {0}',
                  }).replace('{0}', changeReqNo)
                : t(MSG.CONFIRM_ID_EXISTS, {
                    defaultValue:
                      'The Shipment performance based on the Confirm ID occurred in SCS. Approval is not possible.',
                  }),
            });
            return;
          }
          // E11 EngProcessingChk: SSP 일일계획 처리중이면 승인 불가. {0}=남은 분(수동 치환).
          //   fail-closed(GAP-15): 조회 실패·확인 불가는 승인 차단 — "확인 불가"는 MSG01215 로 안내.
          const plan = await checkPlanProcessing(sc.divisionId);
          if (plan.blocked) {
            void setAlert({
              type: 'alert',
              content: plan.byError
                ? t(MSG.SYSTEM_ERROR, {
                    defaultValue: 'A system error has occurred. Request No : {0}',
                  }).replace('{0}', changeReqNo)
                : t(MSG.ENGINE_PROCESSING, {
                    defaultValue: 'SSP Daily Plan Processing now. Please, Try again after {0} minutes.',
                  }).replace('{0}', plan.remainMinute),
            });
            return;
          }
        }
        // E2/E6/E12: ERP I/F 차단구간(SSPBlockCheckIF_SCP) — BLOCK_YN='Y'면 차단. 안내에 차단 기간(PERIOD)을
        //   {0} 에 넣어 AS-IS MSG00267 파리티(신규 MSG01498, 사용자 신고 2026-11-06 — 종전 '2분' 오매핑 교체).
        const erp = await checkErpBlock(sc.divisionId);
        if (erp.blocked) {
          void setAlert({
            type: 'alert',
            content: t(MSG.ERP_BLOCK, {
              defaultValue:
                'The SSP shipment request change and approval screen cannot be used due to ERP system interruption during the following period.\n\r period:{0}',
            }).replace('{0}', erp.period),
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
        const changeRequestNo = str(row?.[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
        const changeType = str(row?.[MASTER_USER_COLUMNS.CHANGE_TYPE]);
        // TO-BE UserSession 에 타임존 필드가 없다 — 빈 값(SP 보정). 저장 경로와 같은 규약.
        const timeZone = '';

        // GetErpIFCheck — 저장 직전 ERP I/F 적재 체크(ERP 전송 배치를 쓰고 COMMIT 하는 SP, PKG body 670-691).
        //   AS-IS 호출 조건(cs:1306/1365/1411): Approval 은 항상, Reject/SelfReject 는 changeType∈{C,N} 일 때만.
        //   P/A 는 IF_CHECK 없이 저장한다 — Reject 는 AS-IS bFlag=true(cs:1362), SelfReject 는 Option B
        //   (자매 SSP0003 cs:1841 bFlag=true 와 일치, 사용자 결정 2026-10-28. AS-IS SSP0202 cs:1303 bFlag=false
        //   는 자매가 이미 고친 버그로 판단). 이로써 P/A 반려 시 AS-IS 에 없던 ERP 전송 데이터 과생성(GAP-12)도 막는다.
        const needsIfCheck =
          action === ACTION.APPROVAL ||
          changeType === CHANGE_TYPE_CONFIRM ||
          changeType === CHANGE_TYPE_NEW;
        if (needsIfCheck && !(await checkErpIf({ changeRequestNo, action, changeType, timeZone }))) {
          void setAlert({
            type: 'alert',
            content: t(MSG.SYSTEM_ERROR, {
              defaultValue: 'A system error has occurred. Request No : {0}',
            }).replace('{0}', changeRequestNo),
          });
          return;
        }

        const saved = await submitConfirmSave(subRows, {
          changeRequestNo,
          action,
          rejectReason,
          changeType,
          userId: sesUserId,
          timeZone,
          //   A7 위임 분기 — 위임자일 때만 값을 싣는다(AS-IS cs:925~934).
          delegatee: isDelegate ? delegatee : '',
          delegateeDept: isDelegate ? delegateeDept : '',
        });

        if (saved.outcome !== 'ok') {
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }

        // F4: 저장 성공 후 마스터 재조회 + 하단 디테일 그리드/폼/반려사유 초기화
        //   (AS-IS cs:942~947 FindData_Main + InitSpread(siSub) + SetConfirmInfoClear 등가).
        void setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, { defaultValue: 'Saved successfully.' }) });
        clearDetail();
        await refetchMain?.();
      } finally {
        //   이중 제출 가드는 작업이 완전히 끝난 뒤 해제한다(동기 해제는 in-flight 가드를 무력화).
        savingRef.current = false;
      }
    })();
  };

  const handleApproval = () => runAction(ACTION.APPROVAL, MSG.APPROVE_CONFIRM);
  const handleReject = () => runAction(ACTION.REJECT, MSG.REJECT_CONFIRM);
  const handleSelfReject = () => runAction(ACTION.SELF_REJECT, MSG.SELF_REJECT_CONFIRM);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // D2/D3/D5: 조회 전용 승인 화면 — 표준 툴바 Insert/Delete/Save 는 AS-IS NO-OP(InsertButton/
    //   DeleteButton 본문 공백 cs:533/537, SaveButton 은 //SaveData() 주석뿐 cs:570 = 의도된 비활성).
    //   표준(auth-button AUTH-03 "미사용 버튼은 false")대로 미노출한다(false = SubTitle 이 안 그림).
    //   실제 저장은 커스텀 버튼 3종(Approval/Reject/SelfReject)이 담당하므로 Save 도 숨긴다 —
    //   SAVE/SAVE_40 버튼메타는 그 커스텀 액션의 call-proc 권한용으로 유지(툴바 Save 노출과 무관).
    //   사용자 결정 2026-10-27(종전 () => undefined 노출 유지에서 표준 우선으로 전환).
    insert: false,
    delete: false,
    save: false,
    // Sort(F3)/Filter(F4) 는 SubTitle 기본 동작이 포커스된 그리드(grid prop=focusedGridRef)에 적용되므로
    //   별도 override 불필요 — 포커스 추적은 각 그리드 onGridFocus 가 담당(상단 주석).
    // Excel 은 **상단 main 그리드로 고정**한다 — Sort/Filter 때문에 grid prop 을 focusedGridRef 로 넘기는데,
    //   공용 기본 Excel 이 grid.current 를 쓰면 하단 디테일에 포커스가 있을 때 디테일이 받아져 "엉뚱한 파일"이
    //   된다(사용자 신고 2026-11-06). main 그리드를 명시해 Excel 대상을 고정한다.
    excel: () => {
      const g = mainGridRef.current;
      if (g)
        void GridAction.excelDownload(
          g,
          'ShipmentChangeRequestConfirm',
          useUIStore.getState().setProgress
        );
    },
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
        // Sort/Filter/Excel 은 포커스된 그리드(focusedGridRef)에 적용 — 키보드 F3/F4 가드까지 그 그리드를
        //   본다. 건수 배지는 상단 main 그리드로 고정(countGrid).
        grid={focusedGridRef}
        gridFilter={focusedGridFilterRef}
        countGrid={mainGridRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentChangeRequestConfirm'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        // F6 저장에 Request Date(기간)를 포함한다 — 프레임워크 기본은 날짜를 제외(EXCLUDED_DATE_PARAM)하므로
        //   opt-in 하지 않으면 저장 자체가 안 돼 재진입 시 복원되지 않는다(SSP0201 과 동일 처방).
        conditionIncludeKeys={['fromYyyymmdd', 'toYyyymmdd']}
        // F10(조회조건 저장 초기화) 직후 화면 조회조건도 즉시 기본값으로 되돌린다(사용자 요청 2026-10-28).
        //   프레임워크 기본(false)은 서버 저장분만 지우므로 이 화면만 opt-in.
        resetConditionOnClient
        customButtons={customButtons}
      />

      {/* 상/하 2분할 — 상단 마스터 그리드(리사이즈 대상) / 하단(디테일 폼 + 디테일 그리드).
          종전엔 plain div(고정 %)라 상단 그리드 높이를 조절할 수 없었다(사용자 요청 2026-11-05).
          스플리터로 상단 그리드 ↔ 하단 블록을 리사이즈한다(자매 SSP0201 PanelGroup 패턴). */}
      <div className={styles.splitWrapper}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          <Panel minSize='15%'>
            <div className={styles.mainPane}>
              <ShipmentChangeRequestConfirmMainGrid
                rows={mainRows}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                division={sc.divisionId}
                adminColumns={staticColumns[SHEETS.MAIN]}
                onRowDblClick={handleRowDblClick}
                onGridFocus={() => setFocusedSheet('main')}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          <Panel minSize='20%'>
            <div className={styles.bottomPane}>
              <div className={styles.detailForm}>
                <ConfirmDetailPanel
                  detail={detail}
                  rejectReason={rejectReason}
                  rejectEnabled={rejectEnabled}
                  onRejectReasonChange={setRejectReason}
                  collapsed={confirmDetailFold.collapsed}
                  pinned={confirmDetailFold.pin !== null}
                  onToggleCollapsed={confirmDetailFold.toggleCollapsed}
                  onTogglePin={confirmDetailFold.togglePin}
                />
              </div>

              <div className={styles.subPane}>
                <ShipmentChangeRequestConfirmSubGrid
                  rows={subRows}
                  gridRef={subGridRef}
                  gridFilterRef={subFilterRef}
                  division={sc.divisionId}
                  changeType={str(row?.[MASTER_USER_COLUMNS.CHANGE_TYPE])}
                  adminColumns={staticColumns[SHEETS.SUB]}
                  onGridFocus={() => setFocusedSheet('sub')}
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
