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
import { useShipmentChangeRequestBusyTask } from './hooks/useShipmentChangeRequestBusyTask';
import { useShipmentChangeRequestCellCombos } from './hooks/useShipmentChangeRequestCellCombos';
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
import { submitCancelDrafting } from './utils/shipmentChangeRequestCancel';
import {
  resolveAuthGroup,
  submitRequestComplete,
  type CompleteResult,
} from './utils/shipmentChangeRequestComplete';
import { firstReasonWithoutChangeRow } from './utils/shipmentChangeRequestDerive';
import { isEndCustomerDivision, isInsertedRow } from './utils/shipmentChangeRequestEditLock';
import { buildCopiedRow, buildNewRow } from './utils/shipmentChangeRequestInsert';
import {
  runSaveChain,
  type SaveChainResult,
} from './utils/shipmentChangeRequestSaveChain';
import {
  checkShipmentStatus,
  type ShipmentStatusBlock,
} from './utils/shipmentChangeRequestStatusCheck';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * alert/toast 의 `defaultValue` 는 **그 코드 전용 영문 문구**다. `_`/`__` 접두를 붙이지 마라 —
 *   접두는 SCREEN_TEXT 처럼 "의도적 미등록 i18n **키**" 표시용이고, defaultValue 는 **화면에 그대로
 *   렌더되는 문구**라 `__Cancel this request?` 처럼 밑줄이 노출된다(사용자 신고 2026-10-13).
 *   여러 자리가 한 문구를 공유해도 안 된다 — 어느 검증에 걸렸는지 알 수 없다.
 */
// MSG00267(ERP 중단기간)은 TO-BE 등가 미등록이라 이 fallback 이 실제로 쓰인다 — 2곳 공용.
const ERP_BLOCK_TEXT = 'ERP interface is blocked during the maintenance period.';
// MSG00672 EN 실문구. `{0}`=건수(호출부에서 수동 치환).
const SAVED_TEXT = '{0} data saved.';

/**
 * 완료 SP 실패 사유 -> [MSG 코드, 영문 fallback]. AS-IS cs:2305~2320 의 3분기를 그대로 옮긴다.
 *   MSG00316/MSG00353 은 TO-BE 미등록이라 fallback 이 실제로 쓰인다(문구 공유 금지 — 사유가 다르다).
 */
const completeFailMessage = (
  kind: CompleteResult['failKind']
): [string, { defaultValue: string }] => {
  if (kind === 'unauthorized') {
    return [
      MSG.APPROVER_UNAVAILABLE,
      {
        defaultValue:
          'No model owner is registered, so an approver cannot be assigned. Please assign an owner for this model.',
      },
    ];
  }
  if (kind === 'modelPic' || kind === 'modelItem') {
    return [
      MSG.MODEL_PIC_MISMATCH,
      {
        defaultValue:
          kind === 'modelPic'
            ? 'Different Model PICs are included. Requests are possible per the same PIC.'
            : 'Different Models are included. Requests are possible per the same Model.',
      },
    ];
  }
  return [MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }];
};

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
    // 'X' = BOD(Trans mode·Incoterms) 무효 — AS-IS cs:1003-1012 MSG00324. modify 'X' 와 같은 의미라
    //   TO-BE 등가 MSG01296(TRANS_MODE_UNAVAILABLE)로 안내한다(종전 미매핑 → 일반 SAVE_FAIL 로 떨어짐).
    if (chain.failedCode === 'X') return MSG.TRANS_MODE_UNAVAILABLE;
  }
  return MSG.SAVE_FAIL;
};

// 요청정보 폼 패널의 고정 높이(px 문자열). min=max 로 이 값에 고정되어 스플리터가 폼을 리사이즈하지 못한다.
//   자매 SSP0200 과 동일 값 — 섹션 헤더 1줄 + 컴팩트 폼 + 액션바가 들어가는 높이. 조정 시 이 값만 바꾼다.
//   패널은 overflow:hidden 이라 모자라면 **조용히 잘린다** — 내용이 늘면 이 값도 함께 올려야 한다.
//   2026-10-08: `usrLabel2`("Request Info") 섹션 헤더(16px 가운데정렬, lineHeight 1.4) 반영분 포함.
//   2026-10-14: 224 -> 248. Request Complete 버튼 아래쪽이 잘려 보인다는 신고 — 폼+액션바 자연높이
//     합이 224 를 넘어 마지막 요소(액션바)가 clip 되고 있었다. +24 중 4px 은 액션바 하단 여백
//     증가분(8->12, RequestActionBar.module.scss)이고 나머지 20px 이 잘림 여유다. 폰트·확대율이
//     달라져도 버티도록 넉넉히 뒀다 — 그만큼 Grid1/Grid2 가 나눠 갖는 높이가 줄어든다.
const FORM_PANEL_SIZE = '248px';

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
  // 필수값 누락 안내 — MSG00614 'The {0} value is required.' 의 {0} 에 누락 항목명을 넣는다.
  //   `{0}` 은 i18next 보간자({{ }})가 아니라 리터럴이라 수동 replace 다(`{ 0: … }` 로는 안 바뀐다).
  //   종전엔 MSG00013(자리 없음) + `{ 0: missing }` 이라 항목명이 조용히 버려졌다.
  const requiredFieldMessage = (missing: string): string =>
    t(MSG.REQUIRED_FIELD, { defaultValue: 'The {0} value is required.' }).replace('{0}', missing);
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const {
    checkErpBlock,
    checkChangeRequestRequired,
    checkRequiredMainColumns,
    firstModifiedRowMissingSoldtoShipto,
    checkCompleteQtyDate,
    checkShipmentDateInPeriod,
    checkShipDateInRange,
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
  const initSessionFields = useShipmentChangeRequestStore(s => s.initSessionFields);
  const fetchRequestorDept = useShipmentChangeRequestStore(s => s.fetchRequestorDept);

  // 그리드1 셀콤보(From/To Site) dataMap — 신규행 복제값이 코드로 보이던 것을 설명으로 매핑한다.
  const { dataMaps: cellDataMaps, loadEndCustomer, focusEndCustomerRow } =
    useShipmentChangeRequestCellCombos(sc.divisionId);

  /**
   * Save / Request Complete / Cancel 공통 실행 래퍼 — **연타 가드 + 전역 스피너**를 한자리에 모은다.
   *
   *   `savingRef` : 재진입 차단(같은 핸들러 연타 + 서로 다른 핸들러 교차 호출). 조회·Insert·New·
   *                 Delete 도 이 플래그를 읽어 "저장 중"에는 비켜선다.
   *   `runBusy`   : react-query mutation 으로 감싸 `useIsBusy([tabId])` 가 전역 스피너를 켜게 한다
   *                 (조회와 같은 오버레이). 스피너가 화면을 덮어 조작까지 막는다 —
   *                 종전엔 저장 체인이 `apiClient.post` 직호출이라 어느 카운터에도 안 잡혀
   *                 저장 중 화면이 멀쩡해 보였다(사용자 요청 2026-10-13).
   *
   * 지켜야 할 3규약:
   *   1. 가드를 **핸들러 진입 즉시** 켠다 — 확인창(setAlert confirm)보다 **먼저**. 종전 구현은
   *      confirm 뒤에 켜서, 느린 회선에서 Save 를 두 번 누르면 확인창이 두 개 뜨고 둘 다 통과해
   *      SAVE_NEW 가 2회 나갔다(신규행 중복 채번·중복 적재).
   *   2. 작업이 **완전히 끝난 뒤** 끈다(`finally`). 동기 검증 early-return 도 같은 경로를 타므로
   *      가드가 새지 않는다.
   *   3. 비동기는 전부 await 한다 — 실행체인과 그 안의 재조회까지. 체인이 채번·수정·신규를 순차로
   *      돌므로 가드는 **마지막 재조회가 끝난 뒤** 풀린다.
   */
  const runBusy = useShipmentChangeRequestBusyTask(tabId);
  const runExclusive = (task: () => Promise<void>) => {
    if (savingRef.current) return;
    savingRef.current = true;
    void runBusy(task).finally(() => {
      savingRef.current = false;
    });
  };

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
    // 요청정보 세션 축 — AS-IS SetUserInfo(cs:517~526). 이름은 세션, 부서는 콤보 1회 조회다
    //   (UserSession 에 부서 필드가 없다). 종전엔 둘 다 없어 Dept Name 이 상시 빈칸이었다.
    initSessionFields();
    void fetchRequestorDept();
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
        // 종전 리터럴이 escape 깨진 `'__Division is required.\', 0: \'Division'` 한 덩어리였다 —
        //   MSG00097 이 등록돼 있어 안 보였을 뿐 미등록이면 그 문자열이 그대로 떴다.
        content: t(MSG.REQUIRED_DIVISION, { defaultValue: 'Please select Division.' }),
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

  /**
   * End Customer 후보 재조회 + 1건 자동확정 (AS-IS `setEndCustomer` cs:5731~5748).
   *   div40/EE 신규행 전용 — Model 팝업 선택·Insert 복제 직후(여기) + To Site 인라인 편집(MainGrid 콜백)
   *   에서 부른다. 후보가 정확히 1건이면 그 코드를 셀에 넣는다(EditTracker 경유, writeCell 과 동일 규약).
   *   0행이면 훅이 '-' 를 합성해 드롭다운에만 표시하고 셀 자동대입은 하지 않는다(AS-IS 대입은 주석).
   *   콤보 바인드는 @divisionId/@scmSiteId(=To Site)/@itemId/@param5='P' — fromSite 는 콤보 바인드가 아니다.
   */
  const applyEndCustomer = async (row: Record<string, unknown>): Promise<void> => {
    if (!isEndCustomerDivision(row)) return;
    const scmSiteId = str(row.TO_SITE_DESCRIPTION);
    const itemId = str(row.ITEM_ID);
    if (!scmSiteId || !itemId) return; // AS-IS 3키 가드(div 는 40 고정이라 상시 충족)
    const candidates = await loadEndCustomer({
      divisionId: str(row.DIVISION_ID) || sc.divisionId,
      scmSiteId,
      itemId,
    });
    if (candidates?.length !== 1) return;
    const code = str(candidates[0].CODE);
    const prev = row.END_CUSTOMER;
    if (prev === code) return;
    editTrackerRef.current?.storeChange(row as never, 'END_CUSTOMER', prev as never, code as never);
    row.END_CUSTOMER = code;
    mainGridRef.current?.invalidate();
  };

  /**
   * End Customer 셀 포커스 — 그 행 기준으로 드롭다운 슬롯을 **동기 교체**(자동확정 없음).
   *   공유 dataMap 슬롯이 마지막 조회(Insert/New/To Site) 행 후보로 덮여 있어 다른 행에도 그대로
   *   보이던 문제를 포커스마다 맞춰 푼다(AS-IS 행별 셀 콤보 등가, 사용자 신고 2026-10-27).
   *   item/To Site 미설정 행이면 훅이 슬롯을 비운다 — 이전 행 후보가 남지 않는다.
   */
  const focusEndCustomer = (row: Record<string, unknown>): void => {
    if (!isEndCustomerDivision(row)) return;
    focusEndCustomerRow({
      divisionId: str(row.DIVISION_ID) || sc.divisionId,
      scmSiteId: str(row.TO_SITE_DESCRIPTION),
      itemId: str(row.ITEM_ID),
    });
  };

  const handleInsert = () => {
    if (savingRef.current) return; // 저장 중 신규행 추가 금지 — 저장 대상 집합이 전송 중에 바뀐다.
    const g = mainGridRef.current;
    if (!g || !canEdit) return;
    const base = copySourceRow();
    if (!base) return; // RowCount>0 가드 — 조회 전/빈 그리드에서는 조용히 끝낸다(AS-IS 동일)
    const newRow = buildCopiedRow(base, sc.divisionId);
    GridAction.addRow(g, newRow as never, 'above', true);
    // AS-IS cs:2457 — 복제행은 item/toSite 가 채워져 있어 End Customer 후보를 바로 재조회·자동확정한다.
    void applyEndCustomer(newRow);
  };

  /**
   * btnNew(cs:2959) — **빈 행**(DIVISION_ID + div 분기 `'-'`)을 넣는다. 복사하지 않는다.
   *   AS-IS 가 의도적으로 `RowCount>0` 가드를 뺀 경로라 조회 전 빈 그리드에서도 추가된다.
   *   자매 SSP0200 `handleNew` 와 동일 동작(사용자 지시 2026-10-13) — 종전엔 New 가 handleInsert 를
   *   재사용해 Insert 와 구분이 없었다.
   */
  const handleNew = () => {
    if (savingRef.current) return; // 저장 중 신규행 추가 금지 — 저장 대상 집합이 전송 중에 바뀐다.
    const g = mainGridRef.current;
    if (!g || !canEdit) return;
    GridAction.addRow(g, buildNewRow(sc.divisionId) as never, 'above', true);
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

  // 변경 차단·선행값 안내. arg 가 있으면 MSG00098 "먼저 {0}을(를) 선택하십시오" 의 `{0}` 를 치환한다
  //   (`{0}` 은 i18next 보간자가 아니라 리터럴이라 수동 replace — memory i18n-zero-placeholder-needs-manual-replace).
  const onBlockedEdit = (msgKey: string, defaultValue?: string, arg?: string) => {
    const code = (MSG as Record<string, string>)[msgKey] ?? msgKey;
    const text = t(code, { defaultValue: defaultValue ?? 'This change is not allowed.' });
    void setAlert({
      type: 'alert',
      content: arg !== undefined ? text.replace('{0}', arg) : text,
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
      // 요청부서 — 세션에 부서 필드가 없어 `fetchRequestorDept()`(SalesPlanUserDept 콤보)가 채운 값이다.
      //   조회 실패 시에만 빈 값으로 나간다(종전에는 상시 빈 값이었다).
      userDeptId: requestInfo.requestDeptId,
      language: langCd ?? '',
    });

    // 보낼 것이 없었다 — **clearChanges/재조회를 하지 않는다.** 아무것도 보내지 않았는데 화면을
    //   갈아엎으면 사용자가 손댄 'P' 행 편집이 조용히 사라진다.
    if (chain.nothingToSend) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, { defaultValue: 'No modifications have been made.' }) });
      return;
    }

    // 8) 성공·실패 무관하게 변경마킹을 털고 재조회한다 — 중간에 멈췄으면 **앞 단계는 이미 저장돼 있다**.
    //   화면이 저장 전 상태로 남으면 사용자가 같은 행을 다시 보내 ERP 전송행을 중복 적재한다.
    editTrackerRef.current?.clearChanges();
    await refetchAll();

    if (!chain.ok) {
      void setAlert({
        type: 'alert',
        content: t(saveFailMessage(chain), { defaultValue: 'Failed to save.' }),
      });
      return;
    }
    // GAP-13: MSG00672='{0} data saved.' 의 {0} 는 i18next 보간자({{ }})가 아니므로 수동 치환
    //   (memory i18n-zero-placeholder-needs-manual-replace).
    //   건수는 **수정 성공 행 수 + 신규 DRAFTING 성공 행 수**다(전체 행 수가 아니다).
    void setToast({
      type: 'success',
      message: t(MSG.SAVE_SUCCESS, { defaultValue: SAVED_TEXT }).replace(
        '{0}',
        String(chain.savedCount)
      ),
    });
  };

  // R8 ERP 차단게이트 공통 처리 — 저장/변경요청 두 진입이 공유한다(GAP-ERP-BIND 교정).
  //   'blocked' 면 안내 후 차단(false), 'unknown' 이면 고지를 확인시킨 뒤 진행(true), 'clear' 면 진행.
  //   'unknown' 을 차단으로 올리면 콤보 SQL 자체가 실패하는 상태(GAP-ERP-DATEFMT, 공용 콤보)에서
  //   저장이 영구 불가가 된다 — 조용히 통과시키지도 않는다(V-13 정직 판정, 서버 SP 가 최종 방어).
  const passErpBlockGate = async (): Promise<boolean> => {
    const block = await checkErpBlock();
    if (block.status === 'blocked') {
      void setAlert({ type: 'alert', content: t(MSG.ERP_BLOCK, { defaultValue: ERP_BLOCK_TEXT }) });
      return false;
    }
    if (block.status === 'unknown') {
      await setAlert({
        type: 'alert',
        content: t(SCREEN_TEXT.ERP_BLOCK_UNKNOWN, {
          defaultValue:
            'The ERP interface block period could not be verified. Proceeding without the check.',
        }),
      });
    }
    return true;
  };

  // 저장 — R8 ERP 게이트 + 필수검증 -> 확인창 -> 실행체인(runSave).
  //   실행 래퍼는 `runExclusive`(연타 가드 + 전역 스피너) — 위 정의 주석 참조.
  const handleSave = () => {
    runExclusive(async () => {
      {
        const g = mainGridRef.current;
        g?.finishEditing();
        const src = (g?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        // 저장 대상 = CRUD_TYPE(EditTracker) 또는 EDIT_MAIN='Y'(SO그룹 전파 포함).
        const dirty = src.filter(r => str(r.CRUD_TYPE) || str(r.EDIT_MAIN) === 'Y');
        if (dirty.length === 0) {
          setToast({ type: 'error', message: t(MSG.NO_CHANGES, { defaultValue: 'No modifications have been made.' }) });
          return;
        }
        // R14: 이미 요청완료(SHIPMENT_STATUS='R') 행 저장 차단.
        if (dirty.some(r => str(r.SHIPMENT_STATUS) === 'R')) {
          void setAlert({
            type: 'alert',
            content: t(MSG.ALREADY_COMPLETE, {
              defaultValue: 'You have already requested to change your shipment plan',
            }),
          });
          return;
        }
        // GAP-01 라벨 * 9컬럼 필수(INPUT_TP_CD='S' 대체, checkRequiredOfSpread(siMain) L800).
        const missing = checkRequiredMainColumns(dirty);
        if (missing) {
          void setAlert({ type: 'alert', content: requiredFieldMessage(missing) });
          return;
        }
        // SoldTo/ShipTo 빈값 차단 — **수정행만**(AS-IS SSP_Main_Validation_SoldTo_ShipTo cs:3151, 신규행 제외).
        //   잠금/파생 컬럼이라 마스터가 비면 변경요청 자체를 막는다(사용자 확인 2026-10-27).
        const missingSoldtoShipto = firstModifiedRowMissingSoldtoShipto(dirty);
        if (missingSoldtoShipto) {
          void setAlert({ type: 'alert', content: requiredFieldMessage(missingSoldtoShipto) });
          return;
        }
        // C8: 변경 없이 Change_Reason 만 입력된 행 차단(AS-IS SSP_Main_Validation cs:3265-3355, MSG00286
        //   -> TO-BE MSG01290). "변경" 판정은 출하필드 7종(SHIPMENT_CHANGE_FIELDS)을 EditTracker 원본과
        //   대조한다 — 사유만 바꾼 행은 변경 없음으로 보고 막는다(SO그룹 전파 사유분은 제외).
        const originals = editTrackerRef.current?.getOriginalValues();
        const reasonOnlyRow = firstReasonWithoutChangeRow(src, row =>
          Object.keys(originals?.get(row as never) ?? {})
        );
        if (reasonOnlyRow !== null) {
          void setAlert({
            type: 'alert',
            content: t(MSG.REASON_WITHOUT_CHANGE, {
              defaultValue:
                'Row {0} has no shipment change, so Change Reason cannot be entered.',
            }).replace('{0}', String(reasonOnlyRow)),
          });
          return;
        }
        // C7-range: 출하일 허용범위(오늘-'2D-'~오늘+'1D+') 밖이면 저장 차단(AS-IS SSP_Main_Validation
        //   cs:3165 수정행 / cs:3368 신규행, MSG00194 -> TO-BE MSG01206). 조회구간(아래 C7/MSG00359)과
        //   별개 축 — 조회기간을 과거로 넓혀 구간검사를 통과하는 범위밖 출하일을 여기서 막는다(지적 2026-10-27).
        //   AS-IS 와 동일하게 저장 순서상 구간검사보다 먼저 건다.
        const rangeHit = checkShipDateInRange(dirty);
        if (rangeHit) {
          void setAlert({
            type: 'alert',
            content: t(MSG.DATE_OVER_MAX, {
              defaultValue: 'Change requests are possible from the current D + {0} ship date.',
            }).replace('{0}', rangeHit.dDay),
          });
          return;
        }
        // C7: 출하일이 조회구간(Period) 밖이면 저장 차단(AS-IS SSP_Main_Validation cs:3173-3178/3383-3388,
        //   MSG00359 -> TO-BE MSG01353). Period 는 SCM0001_GET_SCP_DAY_PERIOD 산출값(store).
        if (checkShipmentDateInPeriod(dirty, sc.fromYyyymmdd, sc.toYyyymmdd)) {
          void setAlert({
            type: 'alert',
            content: t(MSG.SHIP_DATE_OUT_OF_PERIOD, {
              defaultValue: 'Change request can be made within the inquiry date.',
            }),
          });
          return;
        }
        // R8 화면레벨 ERP 차단 게이트.
        if (!(await passErpBlockGate())) return;
        // GAP-09 저장 확인 다이얼로그(TO-BE MSG00001 "Would you like to save it?", AS-IS BtnSave_Click L2776 MSG00012).
        const ok = await setAlert({
          type: 'confirm',
          content: t(MSG.SAVE_CONFIRM, { defaultValue: 'Would you like to save it?' }),
        });
        if (!ok) return;

        // 저장 전 출하상태 재검사(AS-IS GetShipmentStatusChk cs:3416) — 다른 사용자 변경·확정삭제(Qty:0)·
        //   ERP DO 생성(erp_status='C') CONFIRM_ID 가 있으면 서버 기준으로 저장을 막는다. 동일 SO 전파로
        //   편집 불가 행이 묶여 저장되는 노출을 여기서 차단한다(전파는 AS-IS 처럼 무조건, 차단은 저장 단계).
        let statusBlock: ShipmentStatusBlock | null;
        try {
          statusBlock = await checkShipmentStatus(
            sc.divisionId,
            dirty.map(r => str(r.CONFIRM_ID))
          );
        } catch {
          // 검사 호출 자체가 실패(403·통신)하면 저장 여부를 검증할 수 없다 — 조용히 멈추지 않고 저장
          //   실패를 알린 뒤 중단한다(busyTask 가 미처리 에러를 삼키므로 핸들러가 직접 번역한다, 리뷰 #2).
          void setAlert({ type: 'alert', content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }) });
          return;
        }
        if (statusBlock) {
          void setAlert({
            type: 'alert',
            content: (statusBlock.msgCode
              ? t(statusBlock.msgCode, { defaultValue: statusBlock.defaultText })
              : statusBlock.defaultText
            ).replace('{0}', statusBlock.confirmIds),
          });
          return;
        }

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
      }
    });
  };

  /**
   * R9 취소(btnCancel, AS-IS BtnCancel_Click cs:3021~3040).
   *   하위 그리드 가드 -> MSG00195 확인 -> **DeleteDataDrafting("C")** -> 요청정보 clear -> 재조회.
   *
   *   종전엔 가운데 서버 호출이 빠져 있어 폼만 비우고 재조회했다 — 초안이 DB 에 그대로 남아
   *   하위 그리드에 다시 올라왔다(사용자 신고 2026-10-13). 이제 초안을 실제로 무효화한다.
   *   실패하면 **요청정보를 비우지 않는다** — 서버에 남아 있는데 화면만 비면 사용자가 취소된 줄 안다.
   */
  const handleCancel = () => {
    runExclusive(async () => {
      {
        if (subRows.length === 0) return;
        const ok = await setAlert({
          type: 'confirm',
          content: t(MSG.CANCEL_CONFIRM, { defaultValue: 'Are you sure you want to cancel?' }),
        });
        if (!ok) return;

        const result = await submitCancelDrafting(subRows, {
          userId: useSessionStore.getState().session.userId ?? '',
          // TO-BE UserSession 에 타임존 필드가 없다 — 빈 값으로 보내 SP 기본 처리에 맡긴다
          //   (신규/수정 저장 경로·자매 SSP0200 과 같은 규약).
          timeZone: '',
          changeType: sc.changeType,
        });
        if (result.outcome !== 'ok') {
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAIL, { defaultValue: 'Failed to save.' }),
          });
          return;
        }
        // 무효화에 성공했을 때만 폼을 비우고 재조회한다. nothingToSend(대상 0건)도 ok 지만
        //   서버 상태가 바뀐 게 없으므로 clear 는 해도 무해하다(AS-IS 도 iCount==0 이면 clear 만 한다).
        clearRequestInfo();
        editTrackerRef.current?.clearChanges();
        await refetchAll();
      }
    });
  };

  // R14 변경요청 완료(btnChangeRe2) — 필수 4항목 + ERP 게이트 -> 완료(SP: _SAVE_..._COMPLETE, convert-sp).
  //   완료 **실행체인**(임시 토스트 포함)은 이번에 바꾸지 않는다(다음 단계) — 실행 래퍼만 입힌다.
  const handleChangeRequest = () => {
    runExclusive(async () => {
      {
        const missing = checkChangeRequestRequired(requestInfo);
        if (missing) {
          void setAlert({ type: 'alert', content: requiredFieldMessage(missing) });
          return;
        }
        // GAP-07 수량0 + 출하일 하한/상한 검증(design 01 R14 :2838/2850/2868, 서브그리드 NEW_* 기준).
        //   검증마다 전용 코드·문구를 쓴다 — 종전엔 3종이 `_Invalid.` 하나를 공유해 사유를 알 수 없었다.
        const qd = checkCompleteQtyDate(subRows, sc.changeType);
        if (qd) {
          void setAlert({
            type: 'alert',
            // `{0}` 는 i18next 보간자({{ }})가 아니라 리터럴이라 수동 치환이다
            //   (memory i18n-zero-placeholder-needs-manual-replace). `{ 0: … }` 로는 안 바뀐다.
            content: t(qd.msgId, { defaultValue: qd.defaultText }).replace('{0}', qd.arg ?? ''),
          });
          return;
        }
        if (!(await passErpBlockGate())) return;
        // 완료 실행체인 — AS-IS BtnChangeRe_Click(cs:2801) 통과 후 SAVE_SHIPMENT_REQUEST_COMPLETE.
        //   종전엔 이 호출이 **없었다**: 사전검증만 돌고 성공 토스트를 띄워 "저장된 것처럼" 보였다
        //   (사용자 신고 2026-10-13 — 하위 그리드가 안 비는 것이 그 증상이었다).
        const done = await submitRequestComplete(subRows, {
          requestInfo,
          changeType: sc.changeType,
          userId: useSessionStore.getState().session.userId ?? '',
          // TO-BE UserSession 에 타임존 필드가 없다 — 빈 값(SP 보정). 저장 경로와 같은 규약.
          timeZone: '',
          // p_auth — SP 자가승인 가드가 보는 값이다. `groupId` 는 비어 있는 계정이 많아
          //   `groups`(USER_GR_NM 배열)로 보완한다(resolveAuthGroup 주석 참조).
          groupId: resolveAuthGroup(
            String(useSessionStore.getState().session.groupId ?? ''),
            useSessionStore.getState().session.groups ?? []
          ),
        });

        if (done.invalidDate !== undefined) {
          // AS-IS MSG00049 '유효한 날짜 형식이 아닙니다. {0}' — 조용히 넘기지 않는다(cs:2152~2156).
          void setAlert({
            type: 'alert',
            content: t(MSG.INVALID_DATE_FORMAT, {
              defaultValue: 'This is not a valid date format. {0}',
            }).replace('{0}', done.invalidDate),
          });
          return;
        }
        if (done.outcome !== 'ok') {
          void setAlert({ type: 'alert', content: t(...completeFailMessage(done.failKind)) });
          return;
        }
        if (done.nothingToSend) return; // 하위 행 0건 — AS-IS `if (iCount > 0)` 와 동일하게 무동작

        // 성공 — AS-IS cs:2288~2300: 안내 -> ClearRequestInfo() -> InitSpread(siSub) -> FindButton().
        //   TO-BE 등가: 요청정보 clear + 변경마킹 clear + 재조회(상/하위 동시). 재조회가 하위 그리드를
        //   서버 기준으로 다시 그리므로 InitSpread(siSub) 자리를 대신한다 — 로컬 초기화만 하면
        //   서버 상태와 어긋난 빈 화면이 남는다.
        clearRequestInfo();
        editTrackerRef.current?.clearChanges();
        await refetchAll();
        void setToast({
          type: 'success',
          message: t(MSG.REQUEST_COMPLETED, {
            defaultValue: 'Your confirmed shipment plan change request has been completed.',
          }),
        });
      }
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    // Delete 는 저장 전 신규행 전용 실동작. 키를 생략하면 공용 SubTitle 기본 `removeRow`
    //   (= deleteOnlyNew=false)가 살아나 **기존행까지 'D' 마킹**되므로 생략 금지.
    //   `SSP0201/main/DELETE`(API_ID 없음)는 등록 완료다(ora.py 실측 2026-10-13, 자매 SSP0200 과
    //   동일 모양) — 다른 키와 같은 권한 축으로 둔다. 하드코딩 노출 금지(CLAUDE.md §2 체크3).
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
          // 빈 행 경로다 — 툴바 Insert(복사)와 다른 핸들러를 쓴다(SSP0200 패리티).
          action: handleNew,
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
        <ShipmentChangeRequestForm
          onSearch={handleSearch}
          onItemSearch={() => {
            // 조회조건 경로 — 직전에 셀 팝업을 열고 취소했을 수 있으므로 대상 셀 참조를 먼저 끊는다.
            //   끊지 않으면 stale popupTargetRef 때문에 (1) 그 행의 Model 로 사전필터돼 전체 조회가 안 되고
            //   (2) 선택값이 조회조건이 아니라 이전 셀에 다시 쓰인다(자매 SSP0200 과 동일 처방).
            popupTargetRef.current = null;
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
        // F6 저장에 Shipment Date(기간)를 포함한다 — 프레임워크 기본은 날짜를 제외(EXCLUDED_DATE_PARAM)하므로
        //   opt-in 하지 않으면 저장 자체가 안 돼 재진입 시 복원되지 않았다(사용자 신고 2026-10-28).
        //   복원 측은 store fetchStaticColumns + periodRestored 가드로 mount 기본값이 덮지 않게 처리.
        conditionIncludeKeys={['fromYyyymmdd', 'toYyyymmdd']}
        // F10(조회조건 저장 초기화) 직후 화면 조회조건도 즉시 기본값으로 되돌린다(사용자 요청 2026-10-28).
        //   프레임워크 기본(false)은 서버 저장분만 지우므로 이 화면만 opt-in.
        resetConditionOnClient
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
                cellDataMaps={cellDataMaps}
                onPopupCellDblClick={handlePopupCellDblClick}
                onEndCustomerSourceChanged={applyEndCustomer}
                onEndCustomerCellFocus={focusEndCustomer}
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
          if (target) {
            const row = target.row; // writeCell 이 popupTargetRef 를 비우므로 먼저 잡아둔다
            writeCell(picked, str(nickName), 'NICK_NAME');
            // AS-IS cs:4343 — Model 확정 후 End Customer 후보 재조회·자동확정(div40).
            void applyEndCustomer(row);
          } else setSearchCondition({ itemId: picked }); // 조회조건 Model
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
