import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, MeasureSelectModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { ColumnLayoutModal, MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { PeggingInfoModal } from './components/PeggingInfoModal';
import { PlanProblemModal } from './components/PlanProblemModal';
import { ShipmentPlanFgForm } from './components/ShipmentPlanFgForm';
import { ShipmentPlanFgGrid, type SpreadTitleRow } from './components/ShipmentPlanFgGrid';
import {
  ADMIN_SHEET_NAME,
  type BUCKET_TYPE,
  MEASURE,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './shipment-plan-fg.constants';
import type { FixInfoRow, MainRow } from './shipment-plan-fg.types';
import { useShipmentPlanFgStore } from './useShipmentPlanFgStore';
import { buildSavePayload, buildSaveRows, isSaveResultFailure } from './utils/shipment-plan-fg.save';

// AS-IS GSCM.SCP.Analysis.UIL SCP0009_Shipment_Plan_FG — 3 그리드(spdMain/spdPeggingInfo/spdPlanProblem).
//   설계: .atlas/gscm-design/SCP0009/design/00~03. 상세 매핑: __asis-mapping__.md.
//   Edit(잠금 토글) 버튼은 design 01 §5#5 — 사용자 결정 대기, 표준 DataGrid 상시편집 모델로 임시 구현.
export const ShipmentPlanFg = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();

  const sc = useShipmentPlanFgStore(s => s.searchCondition);
  const set = useShipmentPlanFgStore(s => s.setSearchCondition);
  const latestPlanSeq = useShipmentPlanFgStore(s => s.latestPlanSeq);
  const filters = useShipmentPlanFgStore(s => s.filters);
  const setFilter = useShipmentPlanFgStore(s => s.setFilter);
  const clearFilters = useShipmentPlanFgStore(s => s.clearFilters);
  const setPeggingFilter = useShipmentPlanFgStore(s => s.setPeggingFilter);
  const setProblemFilter = useShipmentPlanFgStore(s => s.setProblemFilter);
  const openSearchArea = useShipmentPlanFgStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanFgStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanFgStore(s => s.staticColumns);
  const staticMeasures = useShipmentPlanFgStore(s => s.staticMeasures);
  const visibleMeasures = useShipmentPlanFgStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useShipmentPlanFgStore(s => s.applyVisibleMeasures);
  const fetchStaticColumns = useShipmentPlanFgStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentPlanFgStore(s => s.fetchStaticMeasures);
  const initialized = useShipmentPlanFgStore(s => s.initialized);
  const appliedPlanStartYyyymmdd = useShipmentPlanFgStore(s => s.appliedPlanStartYyyymmdd);
  const appliedFromYyyymmdd = useShipmentPlanFgStore(s => s.appliedFromYyyymmdd);
  const appliedToYyyymmdd = useShipmentPlanFgStore(s => s.appliedToYyyymmdd);

  const [openItem, setOpenItem] = useState(false);
  const [openProject, setOpenProject] = useState(false);
  const [openPegging, setOpenPegging] = useState(false);
  const [openProblem, setOpenProblem] = useState(false);
  const [openColumnSetup, setOpenColumnSetup] = useState(false);
  const [openMeasureSetup, setOpenMeasureSetup] = useState(false);

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
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_OVER_365, '_Period must not exceed 365 days.') });
      return;
    }
    setFilter();
  };

  // Fix/Unfix/New 공통 가드(design 01 §2 #3-5): CanUpdate 권한 / 조회결과 없음 / 그리드 잠금 상태.
  //   SCP0013_GET_PLAN_TYPE_SAVE_YN(저장가능 판정 SP)은 procedures.d.ts 에 SCP0013 SHEETS 가 아직
  //   없어(convert-sp 후속) 이 activity 범위에서 표준 useTabProcQuery 로 호출할 수 없다 — 배선하면
  //   타입 계약이 깨지므로, 이 가드는 M9 로 확인 필요를 유지하고 나머지 3종만 재현한다.
  const canCreateNew = !(sc.divisionId.startsWith('EE') && sc.operationGroupId === 'A') && sc.planType !== 'FN';
  // design 01 §2 #2 Set_FixButtonEnabled — planType(FN/TE) 배제 OR planSeq 가 최댓값(latestPlanSeq)이
  //   아니면 비활성(gap-resolve iter-1 NEW7 — 이전 구현은 planSeq 최댓값 비교가 누락돼 과거 Seq
  //   상태에서도 Fix/Unfix 가 활성 유지됐다).
  const isLockedPlan =
    sc.planType === 'FN' || sc.planType === 'TE' || (!!sc.planSeq && sc.planSeq !== latestPlanSeq);

  // Fix/Unfix 저장 — iter-2 DB 재조사(ora.py all_arguments) 결과: TVP SP
  //   `P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET(P_SCP0009 IN T_SCP0009_TAB, O_RC1 OUT)` 가
  //   `_WEEKLY`(design 03 §4.4, 이미 등록된 SAVE)와 완전히 동일한 26필드 TVP 형상이다(T_SCP0009_ROW
  //   all_type_attrs 실측) — Fix 전용 필드는 없고 P_FIX_REASON 값 유무로 구분되는 것으로 판단해
  //   이 SP 를 Fix/Unfix 저장 대상으로 확정한다(design 01 §5#6 확인필요 해소).
  //   주의(정직 보고): SCM_ADM_PROC_M 에 이 SP 의 파라미터 메타가 0행이다(ora.py 재확인, iter-2) —
  //   PROC_M 이 비어 있으면 BE PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST 가 더미 COL_TP_CD='NORMAL' 1행을
  //   돌려주고 BaseService.makeProcedure 가 파라미터 0개 호출문을 만들어 Oracle 인자개수 불일치로
  //   즉시 실패한다(.atlas/memory/proc-m-empty-fallback-dummy-row-breaks-callproc.md, SCP0006 실증
  //   동일 사례). PROC_M 등록은 convert-sp 소관(skill.md 2.9)이라 여기서 만들지 않는다 — 아래 호출은
  //   배선은 완료했으나 convert-sp 의 PROC_M 등록 전까지 런타임 미검증(ERROR)이다.
  // mnuBtnCd(URL 3번째 세그먼트)는 BE CustomAuthorizationManager 가 SCM_ADM_USER_GR_MNU_BTN_MPG_M
  //   권한판정에 그대로 쓴다(checkMenuBtnAuth) — Fix/Unfix 는 API_ID(P_SCP0009_FIX_SAVE)는 같아도
  //   호출 세그먼트는 실제 클릭한 버튼(FIX/UNFIX)과 일치시켜야 그룹별 권한이 독립적으로 걸린다.
  const saveFixDataset = async (action: 'FIX' | 'UNFIX', fixReason: string): Promise<boolean> => {
    const tracker = mainTrackerRef.current;
    const rows = buildSaveRows(tracker, useSessionStore.getState().session.userId ?? '', '', fixReason);
    if (rows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return false;
    }
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string }[] }>(
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
    if (result && String(result.RESULT_CODE ?? '') !== '0') {
      void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return false;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    mainTrackerRef.current?.clearChanges();
    setFilter();
    return true;
  };

  const handleFix = () => {
    if (!hasButton('FIX')) return;
    if (mainRows.length === 0) return; // 조회결과 없음 — silent no-op
    if (isLockedPlan) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // Fix 는 Unfix 와 달리 confirm 없이 즉시 실행(design 01 §2 #3 가드체인 ⑤ 통과 후 즉시 저장).
    void saveFixDataset('FIX', 'FIX');
  };

  const handleUnfix = () => {
    if (!hasButton('UNFIX')) return;
    if (mainRows.length === 0) return;
    if (isLockedPlan) {
      void setAlert({ type: 'alert', content: t(MSG.LOCKED_MODE, '_Not in edit mode.') });
      return;
    }
    // Unfix 는 Fix 와 달리 confirm(MSG00016) 필수(design 01 §2 #4) — Yes 선택 시에만 저장.
    void setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_UNFIX, '_Are you sure you want to unfix?'),
      onConfirm: () => {
        void saveFixDataset('UNFIX', 'UNFIX');
      },
    });
  };

  const handleNew = () => {
    if (!hasButton('NEW')) return;
    if (!sc.planStartYyyymmdd) return; // cboPlanDate 미선택 — silent no-op
    if (sc.divisionId.startsWith('EE') && sc.operationGroupId === 'A') return; // EE+A 조합 — 메시지 없이 차단
    // 확인 필요(H2, iter-2 재확인) — SCM0002_ShipmentPlanInsertPopup 은 이 activity 의 design/00~03
    //   분석 범위 밖의 별도 AS-IS 화면이다(자체 필드·내부 Insert SP 미분석). 추측 UI 로 채우면
    //   anti-simplification §1 위반이라 별도 design 서브태스크(그 팝업 화면 전용 분석) 선행이 필요 —
    //   그 전까지는 가드만 재현하고 팝업은 열지 않는다.
    void setAlert({
      type: 'alert',
      content: t('MSG00000', {
        defaultValue: '_New Plan popup requires a dedicated design pass for SCM0002_ShipmentPlanInsertPopup (not yet implemented).',
      }),
    });
  };

  // Weekly 저장(design 03 §4.4, P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY) — SP 는 배포·컴파일
  //   확인됨(goal.md ②, ALL_OBJECTS VALID). Daily Bucket 저장 SP 매핑은 여전히 미확정(M7,
  //   design 03 §6#6) — 이 화면 유일 편집경로가 Bucket=DAILY 일 때 이 SP 로 보내는 것이 맞는지는
  //   확인 필요로 남기고, 우선 이 SP 로 전송한다(WEEKLY 전용 SP 명이나 실제로는 Bucket 무관하게
  //   변경 셀 자체를 받는 단일 저장 엔드포인트일 가능성 — 확정 못함, 정직 보고).
  //   Fix 저장과 동일하게 PROC_M 미등록(0행, iter-2 재확인)이라 런타임 미검증(ERROR) — 배선만 완료.
  const handleSave = async () => {
    const grid = mainGridRef.current;
    grid?.finishEditing();
    const tracker = mainTrackerRef.current;
    if (!tracker?.hasChanges()) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    const rows = buildSaveRows(tracker, useSessionStore.getState().session.userId ?? '', '');
    if (rows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    const res = await apiClient.post<{ o_rc1?: { RESULT_CODE?: string; RESULT_MSG?: string }[] }>(
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
    if (result && String(result.RESULT_CODE ?? '') !== '0') {
      void setAlert({ type: 'alert', content: String(result.RESULT_MSG ?? t(MSG.SAVE_FAIL, '_Save failed.')) });
      return;
    }
    setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved successfully.') });
    tracker.clearChanges();
    setFilter();
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
          hasButton('NEW') && { label: t('LBL01028', { defaultValue: 'New' }), action: handleNew, disabled: !canCreateNew },
          hasButton('FIX') && { label: t('LBL00771', { defaultValue: 'Fix' }), action: handleFix, disabled: isLockedPlan },
          hasButton('UNFIX') && { label: t('LBL00772', { defaultValue: 'Unfix' }), action: handleUnfix, disabled: isLockedPlan },
        ].filter((b): b is Exclude<typeof b, false> => b !== false)}
      />

      <ShipmentPlanFgGrid
        rows={mainRows}
        spreadTitle={spreadTitle}
        fixInfoRows={fixInfoRows}
        gridRef={mainGridRef}
        gridFilterRef={mainFilterRef}
        editTrackerRef={mainTrackerRef}
        adminColumns={staticColumns[SHEETS.MAIN]}
        division={sc.divisionId}
        planStartYyyymmdd={appliedPlanStartYyyymmdd}
        fromYyyymmdd={appliedFromYyyymmdd}
        toYyyymmdd={appliedToYyyymmdd}
        bucketType={sc.bucketType}
        chkSum={sc.chkSum}
        chkAll={sc.chkAll}
        onChangeBucketType={handleChangeBucketType}
        onChangeChkSum={chkSum => set({ chkSum })}
        onOpenColumnSetup={() => setOpenColumnSetup(true)}
        onOpenMeasureSetup={() => setOpenMeasureSetup(true)}
        showColumnButton={hasButton('COLUMN_SETUP')}
        showMeasureButton={hasButton('MEASURE_SELECT')}
        onCellDoubleClick={(row, dueDateYyyymmdd) => {
          // 더블클릭 상세(design 03 §4.5) — Pegging/PlanProblem 둘 다 연다(AS-IS splitContainer2
          //   좌우분할 동시노출 대응. 모달 vs 동시패널 구조 자체는 §6 L6 사용자 결정 대기이나, 그와
          //   무관하게 PlanProblem 모달을 여는 트리거 자체가 없던 건 별개 결함(react-gap-audit H3)).
          setPeggingFilter(row, dueDateYyyymmdd);
          setProblemFilter(row, dueDateYyyymmdd);
          setOpenPegging(true);
          setOpenProblem(true);
        }}
        onFocus={() => undefined}
      />

      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => set({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={projectCode => set({ projectCode })}
        preSearchParams={{ divisionId: sc.divisionId, projectCode: sc.projectCode }}
        callFromCell={false}
      />
      <PeggingInfoModal
        open={openPegging}
        modalClose={() => setOpenPegging(false)}
        tabId={tabId}
        division={sc.divisionId}
      />
      <PlanProblemModal open={openProblem} modalClose={() => setOpenProblem(false)} tabId={tabId} />
      {openColumnSetup && (
        <ColumnLayoutModal
          open={openColumnSetup}
          modalClose={() => setOpenColumnSetup(false)}
          menuId={MENU_ID}
          sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN}
          onSave={() => {
            // TODO(확인 필요): btnColumn_Click 은 AS-IS SCM0002_TitleSetForm_Popup("SCP0009",
            //   "Shipment Request", true) 대응 — 저장 후 InitSpread_2/GetSpdTitle 재호출(그리드
            //   재구성) 배선은 admin fetchStaticColumns 재호출로 대체 가능하나 이번 회차 미검증.
            void fetchStaticColumns();
            setOpenColumnSetup(false);
          }}
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
            setFilter();
          });
        }}
      />
    </>
  );
};
