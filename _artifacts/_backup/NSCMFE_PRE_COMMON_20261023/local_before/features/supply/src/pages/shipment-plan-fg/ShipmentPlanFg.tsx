import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal, ProjectByDivisionModal } from 'features/master/src/components';
import { NewPlanModal, type NewPlanContext } from 'features/supply/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import {
  type ColumnLayoutRow,
  ColumnLayoutModal,
  MainTitle,
  saveTitleSet,
  SubTitle,
  toColumnLayoutSettings,
} from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FixReasonModal } from './components/modals/FixReasonModal';
import { ShipmentPlanFgForm } from './components/ShipmentPlanFgForm';
import { ShipmentPlanFgGrid, type SpreadTitleRow } from './components/ShipmentPlanFgGrid';
import { MAIN_COLUMNS } from './shipment-plan-fg.columns';
import {
  ADMIN_SHEET_NAME,
  type BUCKET_TYPE,
  LBL,
  MEASURE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MSG,
  PERIOD_WEEKS,
  SAVE_YN_SHEET,
  SCREEN_TEXT,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-fg.constants';
import type { FixInfoRow, MainRow } from './shipment-plan-fg.types';
import { useShipmentPlanFgStore } from './useShipmentPlanFgStore';
import { collectFixCells, type FixCell, type FixedCellSet, hasUnsavedCell } from './utils/shipment-plan-fg.fix';
import { buildFixRows, buildSavePayload, buildSaveRows, isSaveResultFailure } from './utils/shipment-plan-fg.save';

// AS-IS GSCM.SCP.Analysis.UIL SCP0009_Shipment_Plan_FG — spdMain 단일 그리드(하단 서브그리드는 제외, 사용자 결정).
//   설계: .atlas/gscm-design/SCP0009/design/00~03. 상세 매핑: __asis-mapping__.md.
export const ShipmentPlanFg = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const queryClient = useQueryClient();

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();
  const fixCellsRef = useRef<FixedCellSet>();

  const sc = useShipmentPlanFgStore(s => s.searchCondition);
  const set = useShipmentPlanFgStore(s => s.setSearchCondition);
  const latestPlanSeq = useShipmentPlanFgStore(s => s.latestPlanSeq);
  const filters = useShipmentPlanFgStore(s => s.filters);
  const setFilter = useShipmentPlanFgStore(s => s.setFilter);
  const clearFilters = useShipmentPlanFgStore(s => s.clearFilters);
  const openSearchArea = useShipmentPlanFgStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanFgStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanFgStore(s => s.staticColumns);
  const staticMeasures = useShipmentPlanFgStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentPlanFgStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useShipmentPlanFgStore(s => s.applyVisibleMeasures);
  const fetchStaticColumns = useShipmentPlanFgStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentPlanFgStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useShipmentPlanFgStore(s => s.restoreSearchConditions);
  const initialized = useShipmentPlanFgStore(s => s.initialized);
  const appliedPlanStartYyyymmdd = useShipmentPlanFgStore(s => s.appliedPlanStartYyyymmdd);
  const appliedFromYyyymmdd = useShipmentPlanFgStore(s => s.appliedFromYyyymmdd);
  const appliedToYyyymmdd = useShipmentPlanFgStore(s => s.appliedToYyyymmdd);

  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openColumnSetup, setOpenColumnSetup] = useState(false);
  const [openMeasureSetup, setOpenMeasureSetup] = useState(false);
  const [openFixReason, setOpenFixReason] = useState(false);
  const [openNewPlan, setOpenNewPlan] = useState(false);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
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

  const mainRows = useMemo<MainRow[]>(() => (mainData as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [mainData]);
  const fixInfoRows = useMemo<FixInfoRow[]>(
    () => (mainData as { o_rc3?: FixInfoRow[] })?.o_rc3 ?? [],
    [mainData]
  );
  const spreadTitle = useMemo<SpreadTitleRow[]>(
    () => (calendarData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [],
    [calendarData]
  );

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(nscm-patterns.md §5-7) + 메타 1회 fetch.
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 적용, 없으면 기본값 유지. 형제 화면 파리티.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Bucket 전환(design 03 §2.4 예외) — chkAll 체크 시엔 클라 visible 토글만(그리드는 그대로), chkAll
  //   미체크 시엔 AS-IS InitSpread_2+ClearDataSource 파리티로 재조회가 필요한 상태로 그리드를 비운다.
  const handleChangeBucketType = (bucketType: BUCKET_TYPE) => {
    set({ bucketType });
    if (!sc.chkAll) clearFilters();
  };

  const handleSearch = () => {
    // 필수(design 02 §3): Division/OperationGroup/PlanDate/PlanType/Seq
    if (!sc.divisionId || !sc.operationGroupId || !sc.planStartYyyymmdd || !sc.planType || !sc.planSeq) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Required field missing.') });
      return;
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_FROM_REQUIRED, '_Period is required.') });
      return;
    }
    // 기간 365일 초과(design 02 §3, design 00 §4e #19)
    const from = Number(sc.fromYyyymmdd);
    const to = Number(sc.toYyyymmdd);
    const fromDate = new Date(Math.floor(from / 10000), Math.floor((from % 10000) / 100) - 1, from % 100);
    const toDate = new Date(Math.floor(to / 10000), Math.floor((to % 10000) / 100) - 1, to % 100);
    const diffDays = Math.round((toDate.getTime() - fromDate.getTime()) / 86400000);
    if (diffDays > 365) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_OVER_365, '_The maximum search period is {0} days.').replace('{0}', '365'),
      });
      return;
    }
    setFilter();
  };

  // Fix/Unfix/New 공통 가드(design 01 §2 #3-5): CanUpdate 권한 / 조회결과 없음 / 그리드 잠금 상태 / 서버 저장가능 판정.
  // design 01 §2 #2 Set_FixButtonEnabled — planType(FN/TE) 배제 OR planSeq 가 최댓값(latestPlanSeq)이
  //   아니면 비활성(gap-resolve iter-1 NEW7 — 이전 구현은 planSeq 최댓값 비교가 누락돼 과거 Seq
  //   상태에서도 Fix/Unfix 가 활성 유지됐다).
  const isLockedPlan =
    sc.planType === 'FN' || sc.planType === 'TE' || (!!sc.planSeq && sc.planSeq !== latestPlanSeq);
  // AS-IS Set_FixButtonEnabled(.cs:3985, 4000)가 Fix/Unfix 와 함께 btnNew 도 끄고, 통과 시 btnNewControl(.cs:4231)의
  //   EE+operationGroup A 조합 차단으로 위임한다.
  const canCreateNew = !isLockedPlan && !(sc.divisionId.startsWith('EE') && sc.operationGroupId === 'A');

  // 서버 저장가능 판정 — AS-IS Get_IsSaveYn(.cs:3661-3705). PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN 이 O_RC1.EDIT_YN 으로
  //   'Y' 를 줄 때만 통과한다. division 이 비면 호출·메시지 없이 false(.cs:3670), 호출 실패는 저장 불가로 본다(안전측).
  //   주의: SCP0009/saveYn/SEARCH 라우팅·권한이 DB 에 등록돼 있어야 한다(05_register.sql 끝). 미등록이면 항상 false 다.
  const checkServerSaveYn = async (): Promise<boolean> => {
    if (!sc.divisionId) return false;
    let saveYn = false;
    try {
      const res = await apiClient.post<{ o_rc1?: { EDIT_YN?: string }[] }>(
        `/${MENU_ID}/${SAVE_YN_SHEET}/SEARCH/call-proc`,
        { divisionId: sc.divisionId, planStartYyyymmdd: sc.planStartYyyymmdd, planType: sc.planType }
      );
      saveYn = !isSaveResultFailure(res) && (res.data?.result?.o_rc1 ?? [])[0]?.EDIT_YN === 'Y';
    } catch {
      saveYn = false;
    }
    if (!saveYn) {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_NOT_ALLOWED, '_This Plan can not be modified.') });
    }
    return saveYn;
  };

  // Fix/Unfix 대상 셀 — 그리드 선택 범위 기준(AS-IS GetSelections, .cs:4296). Fix 셀 판정 집합은 그리드가 ref 로 넘긴다.
  const collectSelectedFixCells = (mode: 'FIX' | 'UNFIX') => {
    const grid = mainGridRef.current;
    const fixed = fixCellsRef.current;
    if (!grid || !fixed) return undefined;
    return collectFixCells(grid, mode, fixed);
  };

  // Fix/Unfix 저장 — iter-2 DB 재조사(ora.py all_arguments) 결과: TVP SP
  //   `P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET(P_SCP0009 IN T_SCP0009_TAB, O_RC1 OUT)` 가
  //   `_WEEKLY`(design 03 §4.4, 이미 등록된 SAVE)와 완전히 동일한 26필드 TVP 형상이다(T_SCP0009_ROW
  //   all_type_attrs 실측) — Fix 전용 필드는 없다. SP 본문(PKG_SCP0009.P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET 의
  //   "/* 4. 삭제 */" 블록과 P_ACTIVE_FLAG M/I 재판정 UPDATE) 실측으로 P_ACTIVE_FLAG='D' 일 때만
  //   SCP_ANL_SHIPMENT_PLAN_FIX 를 삭제(Unfix)하고, 그 외는 SP 가 기존 키 유무로 M/I 를 재판정한다(Fix) —
  //   그래서 AS-IS(.cs:4272/4292)처럼 Fix='I', Unfix='D' 를 보낸다.
  //   이 SP 를 Fix/Unfix 저장 대상으로 확정한다(design 01 §5#6 확인필요 해소).
  //   전송: TABLE 파라미터는 nscm-be 가 바인딩하지 못해 API_M 이 CLOB(JSON) 래퍼 `..._FIX_DATASET_JSON` 를 가리킨다
  //   (design/05_register.sql 끝의 G2 블록). 요청 본문은 `{ data: 26필드 행 배열 }` 이다. 실제 저장 왕복은 미검증이다.
  // mnuBtnCd(URL 3번째 세그먼트)는 BE CustomAuthorizationManager 가 SCM_ADM_USER_GR_MNU_BTN_MPG_M
  //   권한판정에 그대로 쓴다(checkMenuBtnAuth) — Fix/Unfix 는 API_ID(P_SCP0009_FIX_SAVE)는 같아도
  //   호출 세그먼트는 실제 클릭한 버튼(FIX/UNFIX)과 일치시켜야 그룹별 권한이 독립적으로 걸린다.
  const saveFixDataset = async (
    action: 'FIX' | 'UNFIX',
    fixReason: string,
    cells: FixCell[]
  ): Promise<boolean> => {
    const rows = buildFixRows(cells, {
      userId: useSessionStore.getState().session.userId ?? '',
      timeZone: '',
      fixReason,
      activeFlag: action === 'FIX' ? 'I' : 'D',
      planStartYyyymmdd: sc.planStartYyyymmdd,
      planType: sc.planType,
      seq: sc.planSeq,
      bucketType: sc.bucketType,
    });
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; ERR_MESSAGE?: string }[] }>(
      `/${MENU_ID}/${SHEETS.MAIN}/${action}/call-proc`,
      buildSavePayload(rows)
    );
    if (isSaveResultFailure(res)) {
      void setAlert({
        type: 'alert',
        content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Save failed.'),
      });
      return false;
    }
    const result = (res.data?.result?.o_rc1 ?? [])[0];
    // _JSON 래퍼 SP 결과: 성공 RESULT_CODE 'S'(+RESULT_CNT), 실패 'F'(+ERR_MESSAGE).
    if (result && String(result.RESULT_CODE ?? '') !== 'S') {
      void setAlert({ type: 'alert', content: String(result.ERR_MESSAGE ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return false;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    mainTrackerRef.current?.clearChanges();
    setFilter();
    return true;
  };

  // 기본 조회기간 W52 — AS-IS InitControls(510행)가 최초 1회, CboPlanDate_SelectedIndexChanged(1231행)가
  //   Plan Date 변경마다 dCalendar.InitValue = GetDayRange(W52) 로 재설정한다(기준일이 cboPlanDate 라
  //   Plan Date 가 정해진 뒤에만 계산 가능). 서버 SP(SCM0001_GET_SCP_DAY_PERIOD)는 호출하지 않고
  //   공용 PeriodRangePicker 의 빠른선택(handleQuickWeeks)과 같은 공식(From + 주수*7-1일)으로 클라이언트에서
  //   계산한다. 탭 재진입 시 이미 있는 기간을 덮어쓰지 않도록, 마운트 시점에 기간이 있으면 그 Plan Date 를
  //   적용 완료로 간주한다.
  const periodAppliedFor = useRef<string | null>(null);
  useEffect(() => {
    if (!sc.planStartYyyymmdd) return;
    if (periodAppliedFor.current === null && sc.fromYyyymmdd) {
      periodAppliedFor.current = sc.planStartYyyymmdd;
      return;
    }
    if (periodAppliedFor.current === sc.planStartYyyymmdd) return;
    periodAppliedFor.current = sc.planStartYyyymmdd;
    const p = sc.planStartYyyymmdd;
    const to = dayjs(`${p.slice(0, 4)}-${p.slice(4, 6)}-${p.slice(6, 8)}`).add(PERIOD_WEEKS.W52 * 7 - 1, 'day');
    set({ fromYyyymmdd: p, toYyyymmdd: to.format('YYYYMMDD') });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.planStartYyyymmdd]);

  const handleFix = async () => {
    if (!hasButton('FIX')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (mainRows.length === 0) return; // 조회결과 없음 — silent no-op
    if (isLockedPlan) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Can not save as it is not in modify mode.') });
      return;
    }
    if (!(await checkServerSaveYn())) return; // 최종 PLAN 상태 체크(.cs:1056)
    // 선택 범위 확인은 사유 팝업보다 먼저 한다(AS-IS 는 팝업 뒤 .cs:4296-4300) — 선택이 없으면 사유부터 묻지 않는다.
    const collected = collectSelectedFixCells('FIX');
    if (!collected?.hasSelection) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a date and enter it.') });
      return;
    }
    if (collected.cells.length === 0) return; // 대상 셀 없음 — AS-IS 도 조용히 끝난다(.cs:4569 iCount > 0)
    if (hasUnsavedCell(collected.touched, mainTrackerRef.current)) {
      void setAlert({ type: 'alert', content: t(MSG.UNSAVED_DATA, '_There are unsaved data.') });
      return;
    }
    // Fix 는 Unfix 와 달리 confirm 없이 사유 팝업(AS-IS SCM0002_RejectReasonPopup)을 연다 — OK 확정 시에만 저장.
    setOpenFixReason(true);
  };

  const handleFixReasonConfirm = (reason: string) => {
    setOpenFixReason(false);
    const collected = collectSelectedFixCells('FIX');
    if (!collected || collected.cells.length === 0) return;
    void saveFixDataset('FIX', reason, collected.cells);
  };

  const handleUnfix = async () => {
    if (!hasButton('UNFIX')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (mainRows.length === 0) return;
    if (isLockedPlan) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Can not save as it is not in modify mode.') });
      return;
    }
    if (!(await checkServerSaveYn())) return; // 최종 PLAN 상태 체크(.cs:1086)
    if (!collectSelectedFixCells('UNFIX')?.hasSelection) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a date and enter it.') });
      return;
    }
    // Unfix 는 Fix 와 달리 confirm(MSG00016) 필수(design 01 §2 #4) — Yes 선택 시에만 저장.
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_UNFIX, '_Do you want to delete it?'),
      onConfirm: () => {
        const collected = collectSelectedFixCells('UNFIX');
        if (!collected || collected.cells.length === 0) {
          // CustomDialog.handleDialogSubmit 가 onConfirm 직후 곧장 handleClose(→closeAlert)를
          //   호출한다 — 같은 틱에서 setAlert 로 새 알림을 띄워도 뒤이은 closeAlert 가 isOpenAlert
          //   를 false 로 되돌려 아무것도 안 뜬 것처럼 보인다(2026-10-13 실측). 한 틱 미뤄서 연다.
          setTimeout(() => {
            void setAlert({ type: 'alert', content: t(MSG.NO_DELETE_DATA, '_No data to delete.') });
          }, 0);
          return;
        }
        void saveFixDataset('UNFIX', '', collected.cells); // AS-IS 는 Unfix 사유가 빈 값(.cs:4291-4293)
      },
    });
  };

  // New Plan 팝업 호출 컨텍스트 — AS-IS BtnNew_Click 이 팝업에 넘기는 값(.cs:1133-1141)이다.
  //   useMemo 로 참조를 고정한다 — 매 렌더 새 객체면 모달의 staticColumns/핸들러 재부착이 저장 대기 중에
  //   재실행돼 그리드 행이 비워지는 레이스를 유발한다(NewPlanModal handleSave 스냅샷 주석 참조).
  const newPlanContext = useMemo<NewPlanContext>(
    () => ({
      divisionId: sc.divisionId,
      operationGroupId: sc.operationGroupId,
      planStartYyyymmdd: sc.planStartYyyymmdd,
      planType: sc.planType,
      planSeq: sc.planSeq,
      programId: 'FG',
    }),
    [sc.divisionId, sc.operationGroupId, sc.planStartYyyymmdd, sc.planType, sc.planSeq]
  );

  // 팝업 저장 성공 후 처리 — 비EE 일 때만 신규 Item 을 조회조건에 채우고 재조회 여부를 묻는다(AS-IS .cs:1147-1162).
  //   EE 는 아무 동작도 하지 않는다(AS-IS 에서 SetChangedControlPart 호출이 주석 처리돼 있다).
  const handleNewPlanSaved = (itemIds: string[]) => {
    if (sc.divisionId.startsWith('EE')) return;
    set({ itemId: itemIds.join(',') });
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_RESEARCH, '_Do you want to re-search?'),
      onConfirm: () => handleSearch(),
    });
  };

  const handleNew = async () => {
    if (!hasButton('NEW')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    if (!sc.planStartYyyymmdd) return; // cboPlanDate 미선택 — silent no-op
    if (!(await checkServerSaveYn())) return; // 최종 PLAN 상태 체크(.cs:1119)
    if (sc.divisionId.startsWith('EE') && sc.operationGroupId === 'A') return; // EE+A 조합 — 메시지 없이 차단
    setOpenNewPlan(true); // AS-IS SCM0002_ShipmentPlanInsertPopup ShowDialog(.cs:1133-1144)
  };

  // Weekly 저장(design 03 §4.4, P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY) — SP 는 배포·컴파일
  //   확인됨(goal.md ②, ALL_OBJECTS VALID). Daily Bucket 저장 SP 매핑은 여전히 미확정(M7,
  //   design 03 §6#6) — 이 화면 유일 편집경로가 Bucket=DAILY 일 때 이 SP 로 보내는 것이 맞는지는
  //   확인 필요로 남기고, 우선 이 SP 로 전송한다(WEEKLY 전용 SP 명이나 실제로는 Bucket 무관하게
  //   변경 셀 자체를 받는 단일 저장 엔드포인트일 가능성 — 확정 못함, 정직 보고).
  //   Fix 저장과 동일하게 API_M 이 CLOB(JSON) 래퍼 `..._WEEKLY_JSON` 를 가리킨다(design/05_register.sql 끝의 G2 블록). 실제 저장 왕복은 미검증이다.
  const handleSave = async () => {
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const tracker = mainTrackerRef.current;
    if (!tracker?.hasChanges()) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    if (!(await checkServerSaveYn())) return; // 최종 PLAN 상태 체크(.cs:2744)
    const rows = buildSaveRows(tracker, useSessionStore.getState().session.userId ?? '', '');
    if (rows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; ERR_MESSAGE?: string }[] }>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      buildSavePayload(rows)
    );
    if (isSaveResultFailure(res)) {
      void setAlert({
        type: 'alert',
        content: String(res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Save failed.'),
      });
      return;
    }
    const result = (res.data?.result?.o_rc1 ?? [])[0];
    // _JSON 래퍼 SP 결과: 성공 RESULT_CODE 'S'(+RESULT_CNT), 실패 'F'(+ERR_MESSAGE).
    if (result && String(result.RESULT_CODE ?? '') !== 'S') {
      void setAlert({ type: 'alert', content: String(result.ERR_MESSAGE ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    tracker.clearChanges();
    setFilter();
  };

  // Column 개인화 저장(AS-IS btnColumn -> SCM0002_TitleSetForm_Popup 'C') — 확정(OK) 시점에만 저장하고
  //   성공하면 titleSet 캐시 무효화 후 컬럼 메타를 다시 가져온다(COL-13).
  const handleSaveColumnLayout = (settings: ColumnLayoutRow[]) => {
    void saveTitleSet({
      menuId: MENU_ID,
      sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN,
      columnType: 'C',
      rows: settings
        .filter(row => row.USER_FLAG === 'Y')
        .map((row, i) => ({
          name: row.COLUMN_NAME,
          sortOrderNo: i + 1,
          colWidth: row.COL_WIDTH,
          cellColor: row.CELL_COLOR,
          textColor: row.TEXT_COLOR,
        })),
    }).then(ok => {
      if (!ok) {
        setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Save failed.') });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      void fetchStaticColumns();
      setOpenColumnSetup(false);
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanFgForm
          onSearch={handleSearch}
          onChangeBucketType={handleChangeBucketType}
          onItemSearch={() => setOpenItem(true)}
          onProjectSearch={() => setOpenProject(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainFilterRef}
        dataCount={mainRows.length}
        excelFileName='ShipmentPlanFg'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          hasButton('NEW') && { label: t(SCREEN_TEXT.NEW, { defaultValue: 'New' }), action: handleNew, disabled: !canCreateNew },
          hasButton('FIX') && { label: t(LBL.FIX, '_Fix'), action: handleFix, disabled: isLockedPlan },
          hasButton('UNFIX') && { label: t(LBL.UNFIX, '_Unfix'), action: handleUnfix, disabled: isLockedPlan },
          hasButton('COLUMN_SETUP') && {
            label: t(LBL.COLUMN, '_Column'),
            title: t(LBL.COLUMN, '_Column'),
            action: () => setOpenColumnSetup(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
          hasButton('MEASURE_SELECT') && {
            label: t(LBL.MEASURE, '_Measure'),
            title: t(LBL.MEASURE, '_Measure'),
            action: () => setOpenMeasureSetup(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ].filter((b): b is Exclude<typeof b, false> => b !== false)}
      />

      <ShipmentPlanFgGrid
        rows={mainRows}
        spreadTitle={spreadTitle}
        fixInfoRows={fixInfoRows}
        gridRef={mainGridRef}
        gridFilterRef={mainFilterRef}
        editTrackerRef={mainTrackerRef}
        fixCellsRef={fixCellsRef}
        adminColumns={staticColumns[SHEETS.MAIN]}
        division={sc.divisionId}
        planStartYyyymmdd={appliedPlanStartYyyymmdd}
        fromYyyymmdd={appliedFromYyyymmdd}
        toYyyymmdd={appliedToYyyymmdd}
        bucketType={sc.bucketType}
        chkSum={sc.chkSum}
        onFocus={() => undefined}
      />

      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => set({ itemId: itemIds })}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={projectCode => set({ projectCode })}
        preSearchParams={{ divisionId: sc.divisionId, projectCode: sc.projectCode }}
        callFromCell={false}
      />
      <FixReasonModal open={openFixReason} onClose={() => setOpenFixReason(false)} onConfirm={handleFixReasonConfirm} />
      <NewPlanModal
        open={openNewPlan}
        modalClose={() => setOpenNewPlan(false)}
        context={newPlanContext}
        menuId={MENU_ID}
        onSaved={handleNewPlanSaved}
      />
      {openColumnSetup && (
        <ColumnLayoutModal
          open={openColumnSetup}
          modalClose={() => setOpenColumnSetup(false)}
          menuId={MENU_ID}
          sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN}
          columnType='C'
          divisionId={sc.divisionId}
          fallbackColumns={MAIN_COLUMNS.map(c => ({ key: c.key, header: c.header, width: c.width }))}
          initialSettings={toColumnLayoutSettings(staticColumns[SHEETS.MAIN])}
          onSave={handleSaveColumnLayout}
        />
      )}
      {/* Measure 커스텀 설정(btnMeasure) — Column 과 동일 SCM0002_TitleSetForm_Popup 대응, measure
          전용 sheetName('Shipment Plan FG')·TitleSet columnType='M'(sales-plan/mkt-fcst 동일 관례).
          메인 SP 가 SCM_MST_TITLESET_USER 를 직접 읽어 Measure 행을 필터하므로(design 03 §1.D) FE는
          영구 저장 후 setFilter() 재조회만 하면 된다(measure 코드 파라미터 전달 불요). */}
      <MeasureSelectModal
        open={openMeasureSetup}
        modalClose={() => setOpenMeasureSetup(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        fallbackCodes={Object.values(MEASURE)}
        onApply={codes => {
          applyVisibleMeasures(codes);
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: MEASURE_SHEET_NAME,
            columnType: TITLESET_MEASURE_TYPE,
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          }).then(ok => {
            if (!ok) {
              setToast({ type: 'error', message: t(MSG.SAVE_FAIL, '_Save failed.') });
              return;
            }
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            setFilter();
          });
        }}
      />
    </>
  );
};
