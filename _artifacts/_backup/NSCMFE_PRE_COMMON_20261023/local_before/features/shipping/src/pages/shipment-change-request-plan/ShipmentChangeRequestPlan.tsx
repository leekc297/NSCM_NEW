import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { BUTTON_TYPE } from '@foundation/constants';
import type { PageProps } from '@foundation/models';
import { GridAction, GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { ProgressIndicator } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ChangeRequestPlanSubGrid } from './components/ChangeRequestPlanSubGrid';
import { OrderDetailModal, type OrderDetailContext } from './components/modals/OrderDetailModal';
import { RequestActionBar } from './components/RequestActionBar';
import { RequestInfoPanel } from './components/RequestInfoPanel';
import { ShipmentChangeRequestPlanForm } from './components/ShipmentChangeRequestPlanForm';
import { ShipmentChangeRequestPlanMainGrid } from './components/ShipmentChangeRequestPlanMainGrid';
import { ShipmentChangeRequestPlanModals } from './components/ShipmentChangeRequestPlanModals';
import { useShipmentChangeRequestPlanCellCombos } from './hooks/useShipmentChangeRequestPlanCellCombos';
import { useShipmentChangeRequestPlanRequestor } from './hooks/useShipmentChangeRequestPlanRequestor';
import { useShipmentChangeRequestPlanSaveActions } from './hooks/useShipmentChangeRequestPlanSaveActions';
import { useShipmentChangeRequestPlanToolbar } from './hooks/useShipmentChangeRequestPlanToolbar';
import { useShipmentChangeRequestPlanBaseDay } from './hooks/useShipmentChangeRequestPlanValidation';
import {
  COLUMN,
  INJECTED_COMBO,
  ITEM_POPUP_COLUMN,
  LBL,
  MENU_ID,
  MSG,
  PROJECT_POPUP_COLUMN,
  SCREEN_TEXT,
  SHEETS,
  SO_NO_POPUP_COLUMN,
} from './shipment-change-request-plan.constants';
import type { MainRow, SubRow } from './shipment-change-request-plan.types';
import styles from './ShipmentChangeRequestPlan.module.scss';
import { useShipmentChangeRequestPlanStore } from './useShipmentChangeRequestPlanStore';
import { buildMainColumns, buildSubColumns } from './utils/shipmentChangeRequestPlanColumns';
import { str, type GridRowData } from './utils/shipmentChangeRequestPlanDerive';
import { isInsertedRow } from './utils/shipmentChangeRequestPlanEditLock';
import { buildCopiedRow, buildNewRow } from './utils/shipmentChangeRequestPlanInsert';
import {
  draftingNewTargets,
  submitDraftingNewSave,
} from './utils/shipmentChangeRequestPlanSave';

// 요청정보 폼 패널의 고정 높이(px 문자열). min=max 로 이 값에 고정되어 스플리터가 폼을 리사이즈하지 못한다.
//   컴팩트 폼(섹션 헤더 1줄 + 3행 + Reason Detail textarea) + 액션바가 들어갈 높이.
//   패널은 overflow:hidden 이라 모자라면 **조용히 잘린다** — 내용이 늘면 이 값도 함께 올려야 한다.
//   2026-10-08: AS-IS `usrLabel2`("Request Info") 섹션 헤더를 이식하면서 그 한 줄을 반영.
//     헤더 폰트를 16px(가운데 정렬)로 키운 분(lineHeight 1.4 -> 약 22px)까지 포함한 값이다.
const FORM_PANEL_SIZE = '224px';

// AS-IS GSCM.SSP.Forms.UIL/Plan/SSP0200_ShipmentChangeRequest.cs (정본 6,906행).
//   상세 매핑·dead 미이식 근거: __asis-mapping__.md / design/04_react-gap.md.
//   주의: 편집모드 모드토글(EditButton/SwitchLock)은 미이식 — 편집 기본 ON(convert-core §2.4).
//   주의: SP 6건 미이관(convert-sp 후속) — JVFlag·VP From Site·전극 소수자리 재판정·From Site 셀콤보·
//         ERP 오류확정은 런타임 실행체인 미완이다.
// 셀콤보 로딩 중 그리드 표시용 빈 배열 — 안정 참조(매 렌더 새 [] 를 주면 그 자체로 그리드가 리바인드된다).
const EMPTY_MAIN_ROWS: MainRow[] = [];

export const ShipmentChangeRequestPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const session = useSessionStore(s => s.session);
  // 감사·세션 인자는 FE 가 실어야 한다 — /call-proc 은 세션을 주입하지 않는다.

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subGridRef = useRef<FlexGrid>();
  const subFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  const popupTargetRef = useRef<{ row: GridRowData; binding: string } | null>(null);

  const sc = useShipmentChangeRequestPlanStore(s => s.searchParams);
  const setSearchParams = useShipmentChangeRequestPlanStore(s => s.setSearchParams);
  const filters = useShipmentChangeRequestPlanStore(s => s.filters);
  const setFilter = useShipmentChangeRequestPlanStore(s => s.setFilter);
  const clearFilters = useShipmentChangeRequestPlanStore(s => s.clearFilters);
  const openSearchArea = useShipmentChangeRequestPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentChangeRequestPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentChangeRequestPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentChangeRequestPlanStore(s => s.fetchStaticColumns);
  const fetchDayRange = useShipmentChangeRequestPlanStore(s => s.fetchDayRange);
  const singleProcess = useShipmentChangeRequestPlanStore(s => s.singleProcess);
  const requestInfo = useShipmentChangeRequestPlanStore(s => s.requestInfo);
  const setRequestInfo = useShipmentChangeRequestPlanStore(s => s.setRequestInfo);
  const clearRequestInfo = useShipmentChangeRequestPlanStore(s => s.clearRequestInfo);
  const initSessionFields = useShipmentChangeRequestPlanStore(s => s.initSessionFields);
  const fetchRequestorDept = useShipmentChangeRequestPlanStore(s => s.fetchRequestorDept);

  // 편집모드 기본 ON — mount 시 권한만 1회 결정한다. 모드 토글 state 신설 금지(convert-core §2.4).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const canEdit = hasButton('EDIT');

  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  // SO 주문상세 팝업 컨텍스트 — null 이면 닫힘(AS-IS 는 더블클릭 때마다 팝업을 새로 띄운다).
  const [orderDetail, setOrderDetail] = useState<OrderDetailContext | null>(null);
  const [openApproval, setOpenApproval] = useState(false);
  const [openInsertMultiple, setOpenInsertMultiple] = useState(false);
  // 저장/요청확정/요청취소 서버 작업 중 로딩 — 조회 로딩(전역 useIsBusy 스피너)과 동일한 딤 오버레이 +
  //   원형 스피너를 렌더한다. 수동 apiClient post 경로라 전역 스피너가 안 잡혀 액션 훅이 토글한다(2026-10-01).
  const [actionLoading, setActionLoading] = useState(false);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // 신규 전용 조회(`GET_SHIPMENT_CHANGE_REQUEST_N`, change_type='N') — 라우팅 main/SEARCH_NEW
  //   (05_register_search_new.sql). 화면에 상시 표시하지 않고, New 저장 직후 방금 만든 확정행의
  //   서버 부여 CONFIRM_ID(+ATTRIBUTE10='I')를 얻어 2단계 DRAFTING 저장에 넘기는 용도로만 refetch 한다.
  const { refetch: refetchNew } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    procedureAction: BUTTON_TYPE.SEARCH_NEW,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: false,
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

  // 컬럼 가시성 토글·셀콤보는 **조회된 division**(filters) 기준으로 묶는다 — 폼의 sc.divisionId 가 아니다
  //   (사용자 지시 2026-10-07). div 만 바꾸고 조회하지 않으면 이 값이 안 바뀌어 컬럼 재빌드·셀콤보 재조회가
  //   없어 그리드가 깜빡이지 않는다. 조회(setFilter) 시점에만 — 그때는 데이터도 다시 그려지므로 — 한 번 갱신된다.
  //   (AS-IS 는 div 변경 즉시 SetChangeControl 로 토글했으나, 조회 전엔 그리드가 이전 division 데이터를
  //    보여주므로 컬럼도 그 division 에 맞추는 편이 일관적이다 — 의도적 TO-BE 차이.)
  const searchedDivisionId = String(filters[SHEETS.MAIN]?.divisionId ?? '');

  // 셀 콤보 주입 dataMap (design 03 §1.3 D-1/D-2) — 상세 근거는 훅 헤더 주석 참조.
  const {
    mainDataMaps,
    subDataMaps,
    loadTransMode,
    loadEndCustomer,
    isTransModeLoaded,
    cellCombosLoading,
  } = useShipmentChangeRequestPlanCellCombos(searchedDivisionId);

  // 조회 시 "데이터 나왔다 사라졌다" 방지(사용자 지시 2026-10-07): div 로 재조회하는 대용량 셀콤보가
  //   데이터보다 늦게 도착하면 mainColumns 재빌드로 그리드가 한 번 비워졌다 다시 그려진다. 셀콤보가
  //   준비될 때까지 그리드 표시 데이터를 미뤄, 데이터와 컬럼이 한 번에 나타나게 한다(전역 조회 스피너가
  //   대기 구간을 덮는다). 저장·건수(dataCount)는 지연 없이 실제 mainRows 를 그대로 쓴다 — 표시 축만 지연.
  const displayMainRows = cellCombosLoading ? EMPTY_MAIN_ROWS : mainRows;

  // 출하일 상·하한 기준일수(CHANGE_REQ_DAY). 미조회면 undefined -> 해당 검증은 수행하지 않는다.
  const changeReqDay = useShipmentChangeRequestPlanBaseDay();

  /**
   * shtMain 파생 컬럼셋은 **페이지가 소유한다**. 그리드 로컬 useMemo 로 두면 같은 컬럼셋이
   *   `saveWithValidation` 에 닿지 않아 div 분기로 숨긴 필수컬럼까지 필수검증 대상이 된다
   *   (`useSaveWithValidation` 은 `col.visible !== false` 로만 숨김을 제외한다).
   */
  // From/To Site dataMap 은 그리드 effect(MainGrid)가 col.dataMap 으로 부착하므로 컬럼 빌드에서 제외한다
  //   — 포함하면 조회 시 division 재조회로 mainColumns 가 재빌드돼 "컬럼 사라졌다 생김" 깜빡임이 난다.
  //   나머지 주입 콤보(status/fcst/reason/division/transMode/endCustomer)는 조회로 바뀌지 않으므로 그대로
  //   굽는다. 비-site 값에만 메모를 의존시켜 site 콤보가 바뀌어도 이 참조가 안정되게 한다.
  const statusMap = mainDataMaps[INJECTED_COMBO.SHIPMENT_STATUS];
  const fcstMap = mainDataMaps[INJECTED_COMBO.FCST_TYPE];
  const reasonMap = mainDataMaps[INJECTED_COMBO.CHANGE_REASON_CODE];
  const divisionMap = mainDataMaps[INJECTED_COMBO.DIVISION_ID];
  const transModeMap = mainDataMaps[INJECTED_COMBO.TRANSPORT_MODE];
  const endCustomerMap = mainDataMaps[INJECTED_COMBO.END_CUSTOMER];
  const bakedDataMaps = useMemo(
    () => ({
      [INJECTED_COMBO.SHIPMENT_STATUS]: statusMap,
      [INJECTED_COMBO.FCST_TYPE]: fcstMap,
      [INJECTED_COMBO.CHANGE_REASON_CODE]: reasonMap,
      [INJECTED_COMBO.DIVISION_ID]: divisionMap,
      [INJECTED_COMBO.TRANSPORT_MODE]: transModeMap,
      [INJECTED_COMBO.END_CUSTOMER]: endCustomerMap,
    }),
    [statusMap, fcstMap, reasonMap, divisionMap, transModeMap, endCustomerMap]
  );

  const mainColumns = useMemo(
    () =>
      buildMainColumns(staticColumns[SHEETS.MAIN], {
        // 가시성 토글(End Customer ↔ Project)도 조회된 division 기준 — div 만 바꿔도 컬럼 안 바뀜(위 주석).
        divisionId: searchedDivisionId,
        changeType: sc.changeType,
        dataMaps: bakedDataMaps,
      }),
    [staticColumns, searchedDivisionId, sc.changeType, bakedDataMaps]
  );

  // ChangeType='P' 분기 2단 헤더 라벨은 i18n 경유다(영문 하드코딩 금지).
  //   메타 기본값(Confirmed/Change)은 그대로 쓰고 'P' 일 때만 덮어쓴다(§2.1 P5·P6).
  const planLabels = useMemo(
    () => ({
      plan: t(LBL.PLAN, '_Plan'),
      confirm: t(LBL.CONFIRM, '_Confirm'),
    }),
    [t]
  );

  /** shtSub 파생 컬럼셋도 페이지가 소유한다 — 요청확정의 메타 필수검증에 같은 셋이 닿아야 한다. */
  const subColumns = useMemo(
    () => buildSubColumns(staticColumns[SHEETS.SUB], sc.changeType, subDataMaps, planLabels),
    [staticColumns, sc.changeType, subDataMaps, planLabels]
  );

  useEffect(() => {
    // 진입 자동 조회 금지 — keep-alive 잔여 filters 무효화 + 기간 기본값 + 컬럼메타 fetch.
    //   초기 mount 에서 cascade 핸들러를 부르지 않는다(AS-IS InitEvent() 가 마지막, design 02 §4.1-2).
    //   컬럼메타는 mount 마다 **무조건** refetch 한다 — store 가 persist 라서 initialized 로 게이트하면
    //   메타(INPUT_TP_CD/폭/콤보)를 고친 뒤 열려 있던 탭이 낡은 컬럼셋을 계속 쓴다(CLAUDE.md §2 체크 3항).
    clearFilters();
    initSessionFields();
    // 요청부서는 세션 축이다(AS-IS SetUserInfo cs:517~526). detail 조회 o_rc2(모델 담당자)로 채우지 않는다.
    void fetchRequestorDept();
    void fetchDayRange('');
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 요청부서 보완 + 승인자 빈칸 자동채움(o_rc2) — 상세는 훅 헤더 주석.
  useShipmentChangeRequestPlanRequestor(subData);

  const refetchAll = useCallback(() => {
    // 저장 후 재조회 = FindButton 등가(master + detail 동시, hook #131).
    //   filters 가 불변인 저장 후 경로에서만 refetch 를 직접 쓴다.
    void refetchMain?.();
    void refetchSub?.();
  }, [refetchMain, refetchSub]);

  const alert = useCallback(
    (msgId: string, defaultText: string, arg?: string) => {
      // `{0}` 치환은 i18next interpolation 이 아니라 문자열 replace 다 — 공용 i18n 설정이
      //   interpolation prefix 를 바꾸지 않아(기본 `{{}}`) `{ 0: arg }` 로는 치환되지 않고
      //   '{0}' 리터럴이 그대로 노출된다. 정본 관례 = useSaveWithValidation.ts 의 .replace('{0}', …).
      void setAlert({
        type: 'alert',
        content: t(msgId, { defaultValue: defaultText }).replace('{0}', arg ?? ''),
      });
    },
    [setAlert, t]
  );

  // New 저장 성공 직후 2단계 — AS-IS GetNewERPInterface->NewNonSoNo(cs:1111/4180).
  //   `_N` 를 강제 refetch 해 방금 만든 확정행(서버 부여 CONFIRM_ID + ATTRIBUTE10='I')을 얻고,
  //   각 행을 DRAFTING 저장으로 변경요청 초안화(→ 원본 확정 status='D')한 뒤 아래(sub) grid 를 재조회한다.
  //   확정(1단계)은 이미 저장됐으므로 초안 저장 실패만 별도 안내한다(AS-IS "신규 생성 요청 실패").
  const draftNewRowsAfterSave = useCallback(
    async (changeReqNo: string) => {
      const res = await refetchNew();
      const targets = draftingNewTargets((res.data?.o_rc1 ?? []) as GridRowData[]);
      if (targets.length > 0) {
        const result = await submitDraftingNewSave(targets, {
          userId: String(session.userId ?? ''),
          userDeptId: requestInfo.requestDeptId,
          changeReqNo,
        });
        if (!result.ok || result.code !== 'S') {
          // 실패 사유를 드러낸다 — 'X'(BOD/SoldTo·ShipTo)면 SP reason, 그 외는 반환코드/통신오류.
          //   일반 문구로 뭉개면 원인을 알 수 없어 진단이 불가하다(2026-09-30 사용자 보고).
          const detail = result.message || `code=${result.code || 'ERR'}`;
          alert(SCREEN_TEXT.SAVE_REASON_DETAIL, '{0}', `New request creation failed (${detail})`);
        }
      }
      void refetchMain?.();
      void refetchSub?.();
    },
    [refetchNew, refetchMain, refetchSub, session.userId, requestInfo.requestDeptId, alert]
  );

  // FindButton(cs:757) — master + detail 동시 조회(V-09).
  const handleSearch = () => {
    if (!sc.divisionId) {
      // Division 권한 0건 = 조회 차단. TO-BE MSG00097 은 뜻이 달라 쓰지 않는다.
      alert(MSG.NO_AUTH_DIVISION, 'No authority assigned.');
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // InsertButton(cs:765) — 내부 가드 RowCount>0. 빈 그리드에서는 삽입하지 않는다(V-12 / CP-15).
  //   복사원은 호출 시점의 포커스 행 1회 고정이다. 다건 경로에서 매 회차 selection 을 다시 읽으면
  //   GridAction 이 selection 을 옮기지 않아 2건부터 방금 삽입한 빈 행을 복사한다.
  const copySourceRow = (): GridRowData | undefined => {
    const grid = mainGridRef.current;
    if (!grid || mainRows.length === 0) return undefined;
    const source = (grid.collectionView?.sourceCollection ?? []) as GridRowData[];
    return source[Math.max(grid.selection?.row ?? 0, 0)];
  };

  const handleInsert = () => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit) return;
    const base = copySourceRow();
    if (!base) return;
    GridAction.addRow(grid, buildCopiedRow(base, sc.divisionId) as never, 'above', true);
  };

  /**
   * DeleteButton — **저장 전 신규행(CRUD_TYPE='I')만** 그리드에서 걷어낸다(사용자 지시 2026-10-03).
   *   수정중인 행과 기존 조회행은 제거도, `CRUD_TYPE='D'` 마킹도 하지 않는다 —
   *   `GridAction.removeRow` 의 2번째 인자 `deleteOnlyNew=true` 가 그 규약이다
   *   (정본 선례: admin/user-management `onDelete` / master/sales-site-project-model `handleDelete`).
   *
   *   AS-IS 차이: `DeleteButton()`(cs:706~709)은 **본문이 빈 NO-OP** 다. 기존 TO-BE 도 그 패리티를
   *   따라 `delete: () => undefined` 였는데, 넣은 신규행을 되돌릴 방법이 없어 사용자가 개선을 지시했다.
   *   기존행 삭제는 여기서도 열지 않는다 — 확정 출하계획 삭제는 이 화면의 기능이 아니고(변경요청으로만
   *   처리한다), 'D' 마킹을 열면 저장 경로가 그 행을 DRAFTING 으로 보내 ERP 전송까지 번진다.
   */
  const handleDelete = () => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit) return;
    // 편집중 셀을 먼저 커밋해야 방금 찍힌 CRUD_TYPE 이 선택행 판정에 반영된다.
    grid.finishEditing();
    const selected = (GridUtils.getSelectedRows(grid) ?? []) as GridRowData[];
    if (selected.length === 0) return; // 선택 없음 — 공용 removeRow 와 같이 조용히 끝낸다.
    if (!selected.some(isInsertedRow)) {
      alert(
        SCREEN_TEXT.DELETE_INSERT_ONLY,
        'Only rows pending insert can be deleted. Saved rows cannot be removed here.'
      );
      return;
    }
    // preserveMergeManager=true — Insert 계열과 동일하게 화면 전용 머지 매니저를 지킨다.
    GridAction.removeRow(grid, true, true);
  };

  // btnNew(cs:3375) — AS-IS 가 의도적으로 RowCount>0 가드를 뺀 경로다. 빈 그리드에서도 추가된다.
  const handleNew = () => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit) return;
    GridAction.addRow(grid, buildNewRow(sc.divisionId) as never, 'above', true);
  };

  // btnInsertMultiple(cs:2924) — 팝업 건수만큼. ITEM_ID 아이콘 셀이 없는 것이 AS-IS 차이다(CP-15).
  //   세트 삽입으로 한 번에 넣는다 — handleInsert 를 n회 반복하면 2건부터 빈 행을 복사한다(addRowSet 주석).
  const handleInsertMultiple = (count: number) => {
    const grid = mainGridRef.current;
    if (!grid || !canEdit || count <= 0) return;
    const base = copySourceRow();
    if (!base) return;
    const copied = Array.from({ length: count }, () => buildCopiedRow(base, sc.divisionId));
    GridAction.addRowSet(grid, copied as never[], 'above', { preserveMergeManager: true });
  };

  // 팝업 대상 셀 참조 해제 — 셀 팝업을 취소한 뒤 조회조건 돋보기로 열면 결과가 이전 셀에 쓰이는 것을 막는다.
  const clearPopupTarget = useCallback(() => {
    popupTargetRef.current = null;
  }, []);

  const handlePopupCellDblClick = useCallback((row: GridRowData, binding: string) => {
    popupTargetRef.current = { row, binding };
    if (binding === ITEM_POPUP_COLUMN) setOpenItem(true);
    else if (binding === PROJECT_POPUP_COLUMN) setOpenProject(true);
  }, []);

  // ERP_SO_NO 더블클릭 -> SO 주문상세 팝업(AS-IS SSP0300_OrderDetailPopup, cs:4858~4878).
  //   AS-IS 는 값이 있을 때만 열고 Form_Load(Division/ErpSoNo/ConfirmId/ItemId, "N") 를 넘긴다 —
  //   값 유무 가드는 그리드(ShipmentChangeRequestPlanMainGrid)가 이미 수행한다.
  //   CHANGE_REQ_NO(SCM0002_ShipmentPlanRequestPopup) 드릴다운은 여전히 미구현 — 04 확인필요 유지.
  const handleDrillDown = useCallback((row: GridRowData, binding: string) => {
    if (binding !== SO_NO_POPUP_COLUMN) return;
    setOrderDetail({
      divisionId: str(row[COLUMN.DIVISION_ID]),
      erpSoNo: str(row[COLUMN.ERP_SO_NO]),
      confirmId: str(row[COLUMN.CONFIRM_ID]),
      itemId: str(row[COLUMN.ITEM_ID]),
    });
  }, []);

  const handleBlocked = useCallback(
    (msgId: string, defaultText: string, arg?: string) => alert(msgId, defaultText, arg),
    [alert]
  );

  const writeCell = (value: string, nameValue?: string, nameCol?: string) => {
    const target = popupTargetRef.current;
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
      mainGridRef.current?.invalidate();
    }
    popupTargetRef.current = null;
  };

  const { handleSave, handleRequestComplete, handleCancel } =
    useShipmentChangeRequestPlanSaveActions({
      mainGridRef,
      editTrackerRef,
      savingRef,
      // 파생 컬럼셋(숨김 반영본)을 넘긴다 — store raw 를 넘기면 숨긴 필수컬럼이 검증 대상이 된다.
      staticColumns: mainColumns,
      subColumns,
      requestInfo,
      subRows: subRows as unknown as GridRowData[],
      changeType: sc.changeType,
      changeReqDay,
      alert,
      translate: (key, defaultValue) => t(key, { defaultValue }),
      confirm: async (msgId, defaultText) =>
        !!(await setAlert({ type: 'confirm', content: t(msgId, { defaultValue: defaultText }) })),
      refetchAll,
      draftNewRowsAfterSave,
      clearRequestInfo,
      setRequestNo: requestNo => setRequestInfo({ requestNo }),
      setSaving: setActionLoading,
    });

  const { hotkeyConfig } = useShipmentChangeRequestPlanToolbar({
    hasButton,
    onSearch: handleSearch,
    onInsert: handleInsert,
    onSave: handleSave,
    onDelete: handleDelete,
  });

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentChangeRequestPlanForm
          onSearch={handleSearch}
          onItemSearch={() => {
            // 조회조건 경로 — 직전에 셀 팝업을 열고 취소했을 수 있으므로 대상 셀 참조를 먼저 끊는다.
            clearPopupTarget();
            setOpenItem(true);
          }}
        />
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
        // New / Insert Multiple 은 AS-IS 조회영역 우측 버튼(design 01 §5.1)이나, 사용자 지시(2026-09-30)로
        //   BtnArea(SubTitle) 로 이동. INSERT 권한이 있을 때만 노출(Single Process 체크박스는 조회영역 유지).
        customButtons={
          hasButton('INSERT')
            ? [
                { label: t(SCREEN_TEXT.NEW, { defaultValue: 'New' }), action: handleNew },
                {
                  label: t(SCREEN_TEXT.INSERT_MULTIPLE, { defaultValue: 'Insert Multiple' }),
                  action: () => setOpenInsertMultiple(true),
                },
              ]
            : undefined
        }
      />

      {/* 상/하 3분할: Grid1(main) / 요청정보 폼(고정) / Grid2(sub).
          사용자 지시 2026-09-29: 폼은 고정, 스플리터는 두 그리드만 커지고 줄어들게 한다.
          → 폼 Panel 을 px 고정(min=max=FORM_PANEL_SIZE)으로 두면 위·아래 스플리터가 각각 Grid1·Grid2 만
          리사이즈한다(폼 높이 불변). 그리드는 %(숫자) 기본크기 — 나머지 공간을 나눠 갖는다.
          (react-resizable-panels 4.7.1 은 px 문자열 크기를 지원한다.) */}
      <div className={styles.splitWrapper}>
        <PanelGroup className={styles.panelGroup} orientation='vertical'>
          {/* Grid1 (main) — 리사이즈 대상. defaultSize 를 **주지 않는다**: 이 라이브러리는 미지정 패널에
              자동 크기를 배분한다(dist `defaultSize===void 0 && (o[id]=a)`). 폼(196px 고정)을 뺀 나머지를
              Grid1·Grid2 가 자동 균등(50:50) 분배한다. %로 50/50 을 주면 100%+196px 가 넘쳐 Grid2 가
              헤더만 남고 붕괴한다(2026-09-29 실측). minSize 만 %로 제약한다. */}
          <Panel minSize='10%'>
            <div className={styles.mainPane}>
              <ShipmentChangeRequestPlanMainGrid
                rows={displayMainRows}
                gridRef={mainGridRef}
                gridFilterRef={mainFilterRef}
                editTrackerRef={editTrackerRef}
                singleProcess={singleProcess}
                canEdit={canEdit}
                columns={mainColumns}
                dataMaps={mainDataMaps}
                changeReqDay={changeReqDay}
                loadTransMode={loadTransMode}
                loadEndCustomer={loadEndCustomer}
                isTransModeLoaded={isTransModeLoaded}
                onPopupCellDblClick={handlePopupCellDblClick}
                onDrillDown={handleDrillDown}
                onBlocked={handleBlocked}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          {/* 요청정보 폼 + 액션바 — px 고정(리사이즈 비대상). min=max 로 스플리터가 이 패널을 건드리지 못한다. */}
          <Panel defaultSize={FORM_PANEL_SIZE} minSize={FORM_PANEL_SIZE} maxSize={FORM_PANEL_SIZE}>
            <div className={styles.formPane}>
              <div className={styles.requestInfo}>
                <RequestInfoPanel
                  requestInfo={requestInfo}
                  canEdit={canEdit}
                  canSearchApproval={hasButton('EDIT')}
                  onChange={setRequestInfo}
                  onApprovalSearch={() => setOpenApproval(true)}
                />
              </div>
              <RequestActionBar
                canRequestComplete={hasButton('SAVE')}
                canCancel={hasButton('DELETE')}
                onRequestComplete={handleRequestComplete}
                onCancel={handleCancel}
              />
            </div>
          </Panel>

          <PanelSeparator className={styles.splitBar} />

          {/* Grid2 (sub) — 리사이즈 대상. defaultSize 미지정 → Grid1 과 남은 공간 자동 균등(50:50) 분배. */}
          <Panel minSize='10%'>
            <div className={styles.subPane}>
              <ChangeRequestPlanSubGrid
                rows={subRows}
                gridRef={subGridRef}
                gridFilterRef={subFilterRef}
                columns={subColumns}
              />
            </div>
          </Panel>
        </PanelGroup>
      </div>

      <ShipmentChangeRequestPlanModals
        divisionId={sc.divisionId}
        openItem={openItem}
        openProject={openProject}
        openApproval={openApproval}
        openInsertMultiple={openInsertMultiple}
        calledFromCell={!!popupTargetRef.current}
        // 셀에서 열 때 그 행의 기존 Model 값을 사전조회로 넘긴다(값이 있으면 팝업이 그 값으로 필터).
        //   조회조건에서 열 때는 빈 값 — 전체 조회(종전 동작).
        itemSearchValue={
          popupTargetRef.current ? str(popupTargetRef.current.row[ITEM_POPUP_COLUMN]) : ''
        }
        setOpenItem={setOpenItem}
        setOpenProject={setOpenProject}
        setOpenApproval={setOpenApproval}
        setOpenInsertMultiple={setOpenInsertMultiple}
        clearPopupTarget={clearPopupTarget}
        writeCell={writeCell}
        setSearchItemId={itemId => setSearchParams({ itemId })}
        setRequestInfo={setRequestInfo}
        onInsertMultiple={handleInsertMultiple}
      />

      {/* ERP_SO_NO 더블클릭 드릴다운 — SO 주문상세(AS-IS SSP0300_OrderDetailPopup) */}
      <OrderDetailModal
        open={orderDetail !== null}
        data={orderDetail}
        onClose={() => setOrderDetail(null)}
      />

      {/* 저장/요청확정/요청취소 진행 스피너 — 조회 로딩과 동일한 딤 오버레이 + 중앙 원형(기준: 조회 로딩). */}
      {actionLoading && (
        <div className={styles.actionSpinner}>
          <ProgressIndicator shape='circular' open />
        </div>
      )}
    </>
  );
};
