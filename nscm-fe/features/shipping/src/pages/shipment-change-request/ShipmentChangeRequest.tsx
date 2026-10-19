import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { RequestActionBar } from './components/RequestActionBar';
import { RequestInfoPanel } from './components/RequestInfoPanel';
import { ShipmentChangeRequestForm } from './components/ShipmentChangeRequestForm';
import { ShipmentChangeRequestMainGrid } from './components/ShipmentChangeRequestMainGrid';
import { ShipmentChangeRequestSubGrid } from './components/ShipmentChangeRequestSubGrid';
import { useShipmentChangeRequestValidation } from './hooks/useShipmentChangeRequestValidation';
import {
  ITEM_POPUP_COLUMN,
  MENU_ID,
  MSG,
  PROJECT_POPUP_COLUMN,
  SCREEN_TEXT,
  SHEETS,
} from './shipment-change-request.constants';
import type { MainRow, SubRow } from './shipment-change-request.types';
import styles from './ShipmentChangeRequest.module.scss';
import { useShipmentChangeRequestStore } from './useShipmentChangeRequestStore';
import { isInsertedRow } from './utils/shipmentChangeRequestEditLock';
import { buildCopiedRow } from './utils/shipmentChangeRequestInsert';
import {
  runSaveChain,
  type SaveChainResult,
} from './utils/shipmentChangeRequestSaveChain';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 실패 단계·코드 -> 안내 MSG 코드. 전용 MSG 코드를 임의로 만들지 않는다(CORE-08).
 *   modify 'X' = BOD(Trans mode·Incoterms) 무효 / new 'N' = Model 미조회 / new 'F' = 판가 미입력.
 *   그 밖(채번 실패·unknown·DRAFTING 실패)은 표준 저장실패다. AS-IS 는 신규 DRAFTING 실패에
 *   "신규 생성 요청 실패"(L990)를 쓰지만 TO-BE 에 대응 코드가 없어 표준 문구로 간다.
 */
const saveFailMessage = (chain: SaveChainResult): string => {
  if (chain.failedStage === 'modify') {
    return chain.failedCode === 'X' ? MSG.TRANS_MODE_UNAVAILABLE : MSG.SAVE_FAIL;
  }
  if (chain.failedStage === 'new') {
    if (chain.failedCode === 'N') return MSG.NEW_MODEL_REQUIRED;
    if (chain.failedCode === 'F') return MSG.NEW_PRICE_REQUIRED;
  }
  return MSG.SAVE_FAIL;
};

// 요청정보 폼 패널의 고정 높이(px 문자열). min=max 로 이 값에 고정되어 스플리터가 폼을 리사이즈하지 못한다.
//   자매 SSP0200 과 동일 값 — 섹션 헤더 1줄 + 컴팩트 폼 + 액션바가 들어가는 높이. 조정 시 이 값만 바꾼다.
//   패널은 overflow:hidden 이라 모자라면 **조용히 잘린다** — 내용이 늘면 이 값도 함께 올려야 한다.
//   2026-10-08: `usrLabel2`("Request Info") 섹션 헤더(16px 가운데정렬, lineHeight 1.4) 반영분 포함.
const FORM_PANEL_SIZE = '224px';

// AS-IS GSCM.SSP.Plan.UIL SSP0201_ShipmentChangeRequest — 출하 변경 요청(멀티그리드 + cascade 셀콤보).
//   설계: .atlas/gscm-design/SSP0201/design/00~03. 상세 매핑: __asis-mapping__.md.
//   편집 기본 ON — AS-IS EditButton/SwitchLock 상태기계는 미이식(convert-core §2.4, constants 헤더 주석).
//   레이아웃은 **자매 SSP0200 과 동일 배열**로 맞췄다(사용자 지시 2026-10-07): Grid1(main) /
//     요청정보 폼 + 액션바(196px 고정) / Grid2(sub). AS-IS Designer 는 Grid1/Grid2/panel3 순서지만
//     두 화면의 조작감 일치가 Designer 좌표보다 우선이다 — 의도적 드리프트(__asis-mapping__ P-5).
//   PKG_SSP0201 은 배포 완료(2026-10-07 ora.py 실측 VALID) — 종전 "미배포" 주석은 stale 이었다.
//   잔여 미배선: 저장 실행체인(수정저장 DRAFTING / 신규 2단계 / SEARCH_NEW / 요청완료) · 승인자 권한팝업 ·
//     Period 기본값 SP(GET_SCP_DAY_PERIOD) · Excel. 전부 버튼메타 미등록이 선행조건이다(constants 참조).
export const ShipmentChangeRequest = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const {
    checkErpBlock,
    checkChangeRequestRequired,
    checkRequiredMainColumns,
    checkCompleteQtyDate,
  } = useShipmentChangeRequestValidation();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  // 이미지셀 팝업 대상(더블클릭한 행/컬럼) 기억 — 팝업 setSelectedValue 가 이 셀에 write.
  const popupTargetRef = useRef<{ row: Record<string, unknown>; binding: string } | null>(null);

  const sc = useShipmentChangeRequestStore(s => s.searchCondition);
  const setSearchCondition = useShipmentChangeRequestStore(s => s.setSearchCondition);
  const filters = useShipmentChangeRequestStore(s => s.filters);
  const setFilter = useShipmentChangeRequestStore(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestStore(s => s.clearFilters);
  const initPeriodDefault = useShipmentChangeRequestStore(s => s.initPeriodDefault);
  const openSearchArea = useShipmentChangeRequestStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestStore(s => s.fetchStaticColumns);
  const initialized = useShipmentChangeRequestStore(s => s.initialized);
  const requestInfo = useShipmentChangeRequestStore(s => s.requestInfo);
  const setRequestInfo = useShipmentChangeRequestStore(s => s.setRequestInfo);
  const clearRequestInfo = useShipmentChangeRequestStore(s => s.clearRequestInfo);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 기본 ON — mount 시 EDIT 권한 1회만 확인한다(모드 state 0건, convert-core §2.4).
  const canEdit = hasButton('EDIT');
  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openApproval, setOpenApproval] = useState(false);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: subData, refetch: refetchSub } = useTabProcQuery<MENU_ID, SHEETS.SUB>({
    menuId: MENU_ID,
    sheetName: SHEETS.SUB,
    tabId,
    filters: filters[SHEETS.SUB],
    enabled: !!filters[SHEETS.SUB],
  });

  const mainRows = useMemo<MainRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  const subRows = useMemo<SubRow[]>(() => subData?.o_rc1 ?? [], [subData]);

  // 저장은 `useProcMutation` 을 쓰지 않는다 — 공용 mutation 은 `{ data: [행…] }` 로 보내는데
  //   DRAFTING SP 의 PROC_M 에 `JVARCHAR` 가 없어 37 인자가 전부 NULL 로 바인딩됐다. 저장이 안 됐는데
  //   SP 가 'S' 를 돌려줘 성공 토스트만 뜨는 상태였다(2026-10-12 원인 확정).
  //   신규행·수정행 모두 평탄 객체 `apiClient.post` 경로다 — utils/shipmentChangeRequest{New,Modify}Save.ts.

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    // GAP-08 Period 기본값(30일 범위) 세팅 — AS-IS InitControls GetDayRange("") (design 02 §4-6).
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 재조회는 **await 가능**해야 한다 — 저장 가드(savingRef)가 재조회 완료까지 잡혀 있어야
  //   저장 직후의 두 번째 클릭이 "조회 중인 구 데이터" 위에서 다시 저장을 쏘는 일을 막는다.
  const refetchAll = async (): Promise<void> => {
    await Promise.all([refetchMain?.(), refetchSub?.()]);
  };

  const handleSearch = () => {
    // 저장이 진행 중이면 조회를 무시한다 — 재조회가 저장 체인의 일부라(CONFIRM_ID 수령) 중간에
    //   그리드를 갈아엎으면 DRAFTING 대상 행을 잃는다.
    if (savingRef.current) return;
    // R13 FindButton — master + detail 동시 조회. 편집 기본 ON 이라 조회 후 재잠금은 하지 않는다(R2 미이식).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_DIVISION, '__Division is required.\', 0: \'Division'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // R10/R11 신규행 — Division 40 고정값. 게이트는 EDIT 권한(편집 기본 ON, convert-core §2.4).
  /**
   * InsertButton(cs:683 -> InsertRow cs:2428) — **선택 행의 값을 복사**해 그 위에 신규행을 넣는다.
   *   복사원은 호출 시점의 포커스 행 1회 고정이다(AS-IS `ActiveRowIndex + 1` = 삽입으로 밀린 원래 행).
   *   복사 키/분기 규칙은 `buildCopiedRow` 주석 참조.
   *
   *   가드 `RowCount > 0`(cs:2433) — 빈 그리드에서는 **삽입하지 않는다**. 복사원이 없기 때문이다.
   *   종전 구현은 복사를 전혀 하지 않고 `{DIVISION_ID, EDIT_MAIN}` 2키짜리 빈 행만 넣었다
   *   (사용자 신고 2026-10-08 "선택 행 데이터가 복사되지 않는다").
   */
  const copySourceRow = (): Record<string, unknown> | undefined => {
    const g = mainGridRef.current;
    if (!g || mainRows.length === 0) return undefined;
    const source = (g.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    return source[Math.max(g.selection?.row ?? 0, 0)];
  };

  const handleInsert = () => {
    if (savingRef.current) return; // 저장 중 신규행 추가 금지 — 저장 대상 집합이 전송 중에 바뀐다.
    const g = mainGridRef.current;
    if (!g || !canEdit) return;
    const base = copySourceRow();
    if (!base) return; // RowCount>0 가드 — 조회 전/빈 그리드에서는 조용히 끝낸다(AS-IS 동일)
    GridAction.addRow(g, buildCopiedRow(base, sc.divisionId) as never, 'above', true);
  };

  /**
   * DeleteButton — **저장 전 신규행(CRUD_TYPE='I')만** 그리드에서 걷어낸다(사용자 지시 2026-10-07).
   *   AS-IS `DeleteButton()`(cs:688~691)은 본문이 빈 NO-OP 라 종전 TO-BE 도 `() => undefined` 였는데,
   *   넣은 신규행을 되돌릴 방법이 없어 자매 SSP0200 과 동일한 실동작을 부여했다.
   *   수정행·기존행은 제거도 `CRUD_TYPE='D'` 마킹도 하지 않는다 — `removeRow` 의 2번째 인자
   *   `deleteOnlyNew=true` 가 그 규약이다. 마킹이 새면 저장 경로가 그 행을 DRAFTING 으로 보내
   *   ERP 전송까지 번진다(SSP0200 에서 실증된 함정).
   */
  const handleDelete = () => {
    if (savingRef.current) return; // 저장 중 행 제거 금지 — 전송 중인 행이 그리드에서 사라진다.
    const g = mainGridRef.current;
    if (!g || !canEdit) return;
    // 편집중 셀을 먼저 커밋해야 방금 찍힌 CRUD_TYPE 이 선택행 판정에 반영된다.
    g.finishEditing();
    const selected = (GridUtils.getSelectedRows(g) ?? []) as Record<string, unknown>[];
    if (selected.length === 0) return; // 선택 없음 — 공용 removeRow 와 같이 조용히 끝낸다.
    if (!selected.some(isInsertedRow)) {
      // 조용히 무동작이면 "버튼이 고장났다" 로 읽힌다 — 왜 안 지워지는지 알린다.
      void setAlert({
        type: 'alert',
        content: t(SCREEN_TEXT.DELETE_INSERT_ONLY, {
          defaultValue:
            'Only rows pending insert can be deleted. Saved rows cannot be removed here.',
        }),
      });
      return;
    }
    // preserveMergeManager=true — Insert 계열과 동일하게 화면 전용 머지 매니저를 지킨다.
    GridAction.removeRow(g, true, true);
  };

  // 이미지셀 팝업 오픈(더블클릭 셀 기억) — ITEM_ID/PROJECT_CODE.
  const handlePopupCellDblClick = (row: Record<string, unknown>, binding: string) => {
    popupTargetRef.current = { row, binding };
    if (binding === ITEM_POPUP_COLUMN) setOpenItem(true);
    else if (binding === PROJECT_POPUP_COLUMN) setOpenProject(true);
  };

  const onBlockedEdit = (msgKey: string) => {
    const code = (MSG as Record<string, string>)[msgKey] ?? msgKey;
    void setAlert({
      type: 'alert',
      content: t(code, { defaultValue: '_Not allowed.' }),
    });
  };

  // 셀 팝업 선택 -> 대상 셀 SetValue + EditTracker 'M' 마킹(design 03 §1.1).
  const writeCell = (value: string, nameValue?: string, nameCol?: string) => {
    const target = popupTargetRef.current;
    const g = mainGridRef.current;
    if (!target) return;
    const prev = target.row[target.binding];
    if (prev !== value) {
      editTrackerRef.current?.storeChange(
        target.row as never,
        target.binding,
        prev as never,
        value as never
      );
      target.row[target.binding] = value;
      if (nameCol && nameValue !== undefined) target.row[nameCol] = nameValue;
      g?.invalidate();
    }
    popupTargetRef.current = null;
  };

  // 승인자 팝업(SSP0002_UserInfoPopup) 선택 -> 요청정보 approval/appDept 채움(언어별 KO/EN, R7).
  //   AS-IS 는 4값(UserID/UserName·UserName_E/Dept_Name/Dept_ID)을 돌려준다(cs:2757~2765).
  //   공용 SsoUserModal 도 deptNm/deptId 를 주므로(5-인자) 종전에 비어 있던 Approval Dept Name 을 채운다.
  //   deptId 는 저장 시 APPROVAL_DEPT 로 나가 자매 SSP0202 디테일의 승인부서명 조인을 성립시킨다.
  const handleApprovalSelected = (
    userId: string,
    userNm: string,
    userEngNm: string,
    deptNm?: string,
    deptId?: string
  ) => {
    setRequestInfo({
      approvalId: userId,
      approval: (langCd === 'KO' ? userNm : userEngNm) ?? userId,
      appDeptName: deptNm ?? '',
      appDeptId: deptId ?? '',
    });
    setOpenApproval(false);
  };

  /**
   * 저장 실행 — 수정행·신규행을 **한 흐름**으로 처리한다(utils/shipmentChangeRequestSaveChain.ts).
   *   번호 1회 채번 -> 수정행 DRAFTING -> 신규행(SAVE_NEW/SEARCH_NEW/DRAFTING). 실패하면 그 자리에서 멈춘다.
   *
   *   종전엔 두 체인이 따로 있고 `handleSave` 가 "신규가 있으면 신규만 하고 return" 했다 —
   *   같이 수정한 기존행이 저장되지 않았고, 번호도 경로별로 따로 받아 한 번의 저장이 서로 다른
   *   변경요청번호로 흩어졌다(사용자 신고 2026-10-12).
   *
   *   수정만/신규만 있는 경우도 **같은 함수**가 처리한다 — 분기 중복을 두지 않는다.
   *   실행체인은 UI 를 모르고, 이 함수가 결과를 alert/toast/재조회로 번역한다.
   */
  const runSave = async (rows: Record<string, unknown>[]) => {
    const chain = await runSaveChain(rows, {
      userId: useSessionStore.getState().session.userId ?? '',
      // userDeptId: 세션에 부서 필드가 없다 — 빈 값(SP 는 APPROVAL_DEPT 갱신에만 쓴다).
      userDeptId: '',
      language: langCd ?? '',
    });

    // 보낼 것이 없었다 — **clearChanges/재조회를 하지 않는다.** 아무것도 보내지 않았는데 화면을
    //   갈아엎으면 사용자가 손댄 'P' 행 편집이 조용히 사라진다.
    if (chain.nothingToSend) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '__No changes to save.') });
      return;
    }

    // 8) 성공·실패 무관하게 변경마킹을 털고 재조회한다 — 중간에 멈췄으면 **앞 단계는 이미 저장돼 있다**.
    //   화면이 저장 전 상태로 남으면 사용자가 같은 행을 다시 보내 ERP 전송행을 중복 적재한다.
    editTrackerRef.current?.clearChanges();
    await refetchAll();

    if (!chain.ok) {
      void setAlert({ type: 'alert', content: t(saveFailMessage(chain), '__Save failed.') });
      return;
    }
    // GAP-13: MSG00672='{0} data saved.' 의 {0} 는 i18next 보간자({{ }})가 아니므로 수동 치환
    //   (memory i18n-zero-placeholder-needs-manual-replace).
    //   건수는 **수정 성공 행 수 + 신규 DRAFTING 성공 행 수**다(전체 행 수가 아니다).
    void setToast({
      type: 'success',
      message: t(MSG.SAVE_SUCCESS, '__Saved.').replace('{0}', String(chain.savedCount)),
    });
  };

  // 저장 — R8 ERP 게이트 + 필수검증 -> 확인창 -> 실행체인(runSave).
  /**
   * 연타 방지 가드(savingRef) 규약 — Save / Request Complete / Cancel 3핸들러 공통.
   *
   *   1. **핸들러 진입 즉시** 켠다. 확인창(setAlert confirm)보다 먼저여야 한다 — 종전 구현은 confirm
   *      **뒤에** 켰기 때문에, 느린 회선에서 Save 를 두 번 누르면 확인창이 두 개 떠 둘 다 통과하고
   *      SAVE_NEW 가 2회 나갔다(신규행이 중복 채번·중복 적재된다).
   *   2. `try/finally` 로 **작업이 완전히 끝난 뒤** 끈다. 동기 검증 early-return 도 finally 를 타므로
   *      가드가 새지 않는다.
   *   3. 비동기 작업은 전부 await 한다 — 실행체인(runSave)과 그 안의 재조회까지. 체인은 채번·수정·신규를
   *      순차로 돌므로, 가드는 **마지막 재조회가 끝난 뒤**에 풀린다.
   */
  const handleSave = () => {
    if (savingRef.current) return;
    savingRef.current = true;
    void (async () => {
      try {
        const g = mainGridRef.current;
        g?.finishEditing();
        const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        // 저장 대상 = CRUD_TYPE(EditTracker) 또는 EDIT_MAIN='Y'(SO그룹 전파 포함).
        const dirty = src.filter(r => str(r.CRUD_TYPE) || str(r.EDIT_MAIN) === 'Y');
        if (dirty.length === 0) {
          setToast({ type: 'error', message: t(MSG.NO_CHANGES, '__No changes to save.') });
          return;
        }
        // R14: 이미 요청완료(SHIPMENT_STATUS='R') 행 저장 차단.
        if (dirty.some(r => str(r.SHIPMENT_STATUS) === 'R')) {
          void setAlert({ type: 'alert', content: t(MSG.ALREADY_COMPLETE, '__Already completed.') });
          return;
        }
        // GAP-01 라벨 * 9컬럼 필수(INPUT_TP_CD='S' 대체, checkRequiredOfSpread(siMain) L800).
        const missing = checkRequiredMainColumns(dirty);
        if (missing) {
          void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, { defaultValue: '_Required.', 0: missing }) });
          return;
        }
        // R8 화면레벨 ERP 차단 게이트.
        if (await checkErpBlock(sc.divisionId)) {
          void setAlert({ type: 'alert', content: t(MSG.ERP_BLOCK, '__ERP interface is blocked.') });
          return;
        }
        // GAP-09 저장 확인 다이얼로그(TO-BE MSG00001 "Would you like to save it?", AS-IS BtnSave_Click L2776 MSG00012).
        const ok = await setAlert({ type: 'confirm', content: t(MSG.SAVE_CONFIRM, '__Save?') });
        if (!ok) return;

        // 공통 메타 필수검증(라벨 * 9컬럼은 INPUT_TP_CD 'S'라 staticColumns 기준 M/IM 은 없음 — 배선 유지).
        //   `saveWithValidation` 은 동기 함수이고 콜백도 동기로 호출한다(검증 통과 시 즉시 `mutate(rows)`).
        //   그래서 콜백이 만든 Promise 를 밖으로 올려 await 한다 — 검증에 걸려 콜백이 돌지 않으면
        //   `pending` 은 undefined 로 남고 `await undefined` 는 그대로 통과한다.
        let pending: Promise<void> | undefined;
        saveWithValidation(dirty, staticColumns[SHEETS.MAIN], rows => {
          // 수정/신규/혼재를 가리지 않는 단일 경로다 — 분기는 실행체인 안에 있다.
          pending = runSave(rows);
        });
        await pending;
      } finally {
        savingRef.current = false;
      }
    })();
  };

  // R9 취소(btnCancel) — siSub.RowCount==0 가드 + MSG00195 confirm -> 취소 + 요청정보 clear.
  //   취소 **동작 자체**는 이번에 바꾸지 않는다(다음 단계) — 연타 가드와 재조회 await 만 입힌다.
  const handleCancel = () => {
    if (savingRef.current) return;
    savingRef.current = true;
    void (async () => {
      try {
        if (subRows.length === 0) return;
        const ok = await setAlert({
          type: 'confirm',
          content: t(MSG.CANCEL_CONFIRM, '__Cancel this request?'),
        });
        if (!ok) return;
        clearRequestInfo();
        await refetchAll();
      } finally {
        savingRef.current = false;
      }
    })();
  };

  // R14 변경요청 완료(btnChangeRe2) — 필수 4항목 + ERP 게이트 -> 완료(SP: _SAVE_..._COMPLETE, convert-sp).
  //   완료 **실행체인**(임시 토스트 포함)은 이번에 바꾸지 않는다(다음 단계) — 연타 가드만 입힌다.
  const handleChangeRequest = () => {
    if (savingRef.current) return;
    savingRef.current = true;
    void (async () => {
      try {
        const missing = checkChangeRequestRequired(requestInfo);
        if (missing) {
          void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, { defaultValue: '_Required.', 0: missing }) });
          return;
        }
        // GAP-07 수량0 + 출하일 하한 검증(design 01 R14 :2838/2850/2868, 서브그리드 NEW_* 기준).
        const qd = checkCompleteQtyDate(subRows, sc.changeType);
        if (qd) {
          void setAlert({ type: 'alert', content: t(MSG[qd.msg], { defaultValue: '_Invalid.', 0: qd.args ?? '' }) });
          return;
        }
        if (await checkErpBlock(sc.divisionId)) {
          void setAlert({ type: 'alert', content: t(MSG.ERP_BLOCK, '__ERP interface is blocked.') });
          return;
        }
        // 완료 mutate 배선은 convert-sp(PKG_SSP0201._SAVE_SHIPMENT_REQUEST_COMPLETE) 배포 후 실행체인 확정.
        // GAP-13: MSG00672 {0} 수동 치환(위 handleSave 와 동일).
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '__Requested.').replace('{0}', '1'),
        });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete 는 저장 전 신규행 전용 실동작. 키를 생략하면 공용 SubTitle 기본 `removeRow`
    //   (= deleteOnlyNew=false)가 살아나 **기존행까지 'D' 마킹**되므로 생략 금지.
    //   주의: SSP0201 은 `DELETE` 버튼메타가 아직 미등록이라(ora.py 실측 5행) 권한축이 false 다 —
    //   메타 등록 전에는 버튼이 노출되지 않는다. 하드코딩 노출 금지(CLAUDE.md §2 체크3).
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
    // Excel 도 권한 메타로만 노출한다. 키를 생략하면 공용 기본 엑셀 핸들러가 살아나 admin 에서 끄지 않은
    //   버튼이 남는다 — `EXCEL` 미등록 상태이므로 현재는 명시적으로 끈다.
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
  };

  // BtnArea(SubTitle) 커스텀 버튼 — New(R10)만. Edit(R1)은 편집 기본 ON 으로 제거했고(convert-core §2.4),
  //   Cancel(R9)/Request Complete(R14)는 AS-IS panel3 우측 버튼이라 요청정보 폼 옆 액션바로 내렸다
  //   (Designer 실측: 요청정보 좌 X=0 / 버튼 우 X=760, 같은 panel3).
  //   dead UI 5버튼(btnAdd/btnDel/btnSave/dtDate/상단btnChangeRe)은 미노출(R4).
  const customButtons = hasButton('INSERT')
    ? [
        {
          label: t(SCREEN_TEXT.NEW, { defaultValue: 'New' }),
          title: t(SCREEN_TEXT.NEW, { defaultValue: 'New' }),
          action: handleInsert,
        },
      ]
    : undefined;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentChangeRequest'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      {/* 상/하 3분할 — Grid1(main) / 요청정보 폼 + 액션바(고정) / Grid2(sub).
          **자매 SSP0200 과 동일 배열**(사용자 지시 2026-10-07). AS-IS Designer 는 Grid1/Grid2/panel3
          순서(splitContainer Horizontal, SplitterDistance=253)지만, 두 화면을 같은 조작감으로 쓰는
          사용자 요구가 Designer 좌표보다 우선이다 — 의도적 드리프트로 기록한다(__asis-mapping__ P-5).
          폼 Panel 은 px 고정(min=max)이라 위·아래 스플리터가 각각 Grid1·Grid2 만 리사이즈한다(폼 높이 불변).
          그리드 Panel 에 defaultSize 를 주지 않는다 — 미지정 패널끼리 남은 공간을 자동 균등 분배한다.
          %로 고정값을 주면 100%+196px 를 넘겨 Grid2 가 헤더만 남고 붕괴한다(SSP0200 실측). */}
      <div className={styles.splitWrapper}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          {/* Grid1 (main) — 리사이즈 대상. */}
          <Panel minSize='10%'>
            <div className={styles.mainPane}>
              <ShipmentChangeRequestMainGrid
                rows={mainRows}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                editTrackerRef={editTrackerRef}
                division={sc.divisionId}
                changeType={sc.changeType}
                canEdit={canEdit}
                adminColumns={staticColumns[SHEETS.MAIN]}
                onPopupCellDblClick={handlePopupCellDblClick}
                onBlockedEdit={onBlockedEdit}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          {/* 요청정보 폼 + 액션바 — px 고정(리사이즈 비대상). min=max 로 스플리터가 이 패널을 못 건드린다. */}
          <Panel
            defaultSize={FORM_PANEL_SIZE}
            minSize={FORM_PANEL_SIZE}
            maxSize={FORM_PANEL_SIZE}
          >
            <div className={styles.formPane}>
              <div className={styles.requestInfo}>
                <RequestInfoPanel
                  requestInfo={requestInfo}
                  canEdit={canEdit}
                  onChange={setRequestInfo}
                  onApprovalSearch={() => setOpenApproval(true)}
                />
              </div>
              {/* Cancel 의 권한축: 자매 SSP0200 은 `DELETE` 를 쓰지만 SSP0201 은 그 메타가 아직
                  미등록이라(ora.py 실측 5행) DELETE 로 걸면 버튼이 사라진다 — 종전엔 상시 노출이었다.
                  등록된 `EDIT` 로 잠정 게이트하고, DELETE 등록 회차에 SSP0200 과 맞춘다. */}
              <RequestActionBar
                canRequestComplete={hasButton('SAVE')}
                canCancel={canEdit}
                onRequestComplete={handleChangeRequest}
                onCancel={handleCancel}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          {/* Grid2 (sub) — 리사이즈 대상. defaultSize 미지정 → Grid1 과 남은 공간 자동 균등 분배. */}
          <Panel minSize='10%'>
            <div className={styles.subPane}>
              <ShipmentChangeRequestSubGrid
                rows={subRows}
                gridRef={subGridRef}
                gridFilterRef={subFilterRef}
                division={sc.divisionId}
                changeType={sc.changeType}
                adminColumns={staticColumns[SHEETS.SUB]}
              />
            </div>
          </Panel>
        </PanelGroup>
      </div>

      {/* Model/Nickname 조회조건·셀 팝업 — 공용 `MaterialByDivisionModal`(COM0013,
          PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION)로 교체(사용자 지시 2026-10-08, 4자매 공통).
          AS-IS 는 `SSP0026_ItembyDivisionPopup`(= SSP.SSP0026_GET_ITEM_BY_DIVISION_POPUP) 이라
          **조회 SP 가 달라지는 의도적 드리프트**다(§G-9 기록). `scpModuleType` 에 SSP 화면 ID 는
          SP 에 열거돼 있지 않아 기본 ELSE 분기를 타 기본 Material 목록을 돌려준다(실측). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId, itemName, itemClassName, nickName) => {
          // master 계약 positional: (itemId, itemName, itemClassName, nickName). Nick Name 은 **4번째**다 —
          //   종전 코드는 2번째를 nickName 으로 받아 모델 설명(`MC,M,M,46950,…`)이 NICK_NAME 에 박혔다
          //   (자매 SSP0200 이 같은 함정을 주석으로 남겨둔 자리 — 이번에 함께 교정).
          const picked = String(itemId ?? '');
          if (!picked) return;
          const target = popupTargetRef.current;
          if (target) writeCell(picked, str(nickName), 'NICK_NAME');
          else setSearchCondition({ itemId: picked }); // 조회조건 Model
        }}
        // 셀에서 열 때는 그 행의 기존 Model 값으로 사전조회한다(조회조건 itemId 를 쓰면 엉뚱한 후보가 뜬다).
        //   조회조건 돋보기로 열 때는 조회조건 값 — 자매 SSP0200 과 동일 규약.
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: popupTargetRef.current
            ? str(popupTargetRef.current.row[ITEM_POPUP_COLUMN])
            : sc.itemId,
        }}
      />

      {/* Project 셀 팝업 — SCM0002_ProjectbyDivisionPopup(ProjectByDivisionModal). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={(projectCode, projectName) =>
          writeCell(String(projectCode), str(projectName), 'PROJECT_NAME')
        }
        preSearchParams={{ divisionId: sc.divisionId }}
        callFromCell={true}
      />

      {/* 승인자 검색 — 공용 SsoUserModal(AS-IS SSP0002_UserInfoPopup, SingleSelectYn, R7). */}
      <SsoUserModal
        open={openApproval}
        modalClose={() => setOpenApproval(false)}
        setSelectedValue={handleApprovalSelected}
        ssoUserYn='N'
      />
    </>
  );
};
