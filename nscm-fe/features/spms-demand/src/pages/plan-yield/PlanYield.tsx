import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { type EditTracker, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { SampleProcessFlow } from '../../components/sample-process-flow';
import { SampleStatusTree, type SelectedBuild } from '../../components/sample-status-tree';
import { takePendingBuild, usePendingBuildStore } from '../../lib/pendingBuild';

import { RequestPlantPanel } from './components/RequestPlantPanel';
import { YieldLossGrid } from './components/YieldLossGrid';
import { BTN, CURRENT_PROCESS, LBL, MENU_ID, MSG, SHEETS } from './plan-yield.constants';
import type { BuildRow, PlantRow, ProcessRow, TreeRow, YieldRow } from './plan-yield.types';
import styles from './PlanYield.module.scss';
import { usePlanYieldStore } from './usePlanYieldStore';
import { callConfirmYield, callSavePlant } from './utils/plan-yield.api';
import {
  toConfirmYieldPayload,
  toSavePlantPayload,
  toSelectedOperationGroup,
} from './utils/plan-yield.payload';

// SDM2020 계획수율 (샘플 수요 > 샘플제작 요청 > 계획수율 — ROUTE_PATH 'spms-demand/plan-yield').
//   ⭐ 정본 원천 = 계획수율_20260828.xlsx(UI 목업) + 테이블 명세 + 사내 DB PKG_SDM2020 (화면설계서 없음).
//   조회조건(SearchArea) 없음 — 좌측 샘플 현황 Tree(SDM2010 공유)의 빌드 No. 선택이 조회 트리거.
//   선택 시 Process(SDM2010 공유)/빌드(헤더 'data' + 요청법인 그리드 'plant' 커서 2본)를 함께 조회하고,
//   요청법인 패널의 구분(공정 그룹) 선택이 [2. 수율/Loss 계획 점검] 그리드 조회를 확정한다 —
//   우측 그리드는 그 구분에 속한 전 공정의 행을 함께 보여준다.
//   저장(요청법인 — P_SDM2020_SAVE_PJT_SAMPLE_BUILD 요청법인 모드)·확정(수율 — 초안 PKG_SDM2020_YIELD) =
//   '^' 벌크 1건 call-proc (CODE '0'+EVENT 판정, EVENT 0 = 성공 토스트 금지).
//   Excel Form/Upload 는 원천 SP·EXCEL_COLUMNS 부재로 보류(정오표 D4).
export const PlanYield = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const plantGridRef = useRef<FlexGridType<PlantRow>>(null);
  const plantTrackerRef = useRef<EditTracker>(undefined);
  const yieldGridRef = useRef<FlexGridType<YieldRow>>(null);
  const yieldFilterRef = useRef<FlexGridFilter>(undefined);
  const yieldTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const confirmMsg = useCallback(
    (msgId: string, fallback: string) => setAlert({ type: 'confirm', content: t(msgId, fallback) }),
    [setAlert, t]
  );
  const alertMsg = (msgId: string, fallback: string) => {
    void setAlert({ type: 'alert', content: t(msgId, fallback) });
  };

  // Store selector — 개별 selector 로만 구독 (객체 통째 destructuring 금지 규칙)
  const filters = usePlanYieldStore(s => s.filters);
  const selected = usePlanYieldStore(s => s.selected);
  const selectedOperation = usePlanYieldStore(s => s.selectedOperation);
  const inProgressOnly = usePlanYieldStore(s => s.inProgressOnly);
  const staticColumns = usePlanYieldStore(s => s.staticColumns);
  const setTreeFilter = usePlanYieldStore(s => s.setTreeFilter);
  const selectBuild = usePlanYieldStore(s => s.selectBuild);
  const selectOperation = usePlanYieldStore(s => s.selectOperation);
  const refreshSelected = usePlanYieldStore(s => s.refreshSelected);
  const refreshYield = usePlanYieldStore(s => s.refreshYield);
  const setInProgressOnly = usePlanYieldStore(s => s.setInProgressOnly);
  const fetchStaticColumns = usePlanYieldStore(s => s.fetchStaticColumns);

  const sesDivisionId = useSessionStore.getState().session.div ?? '';
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID }); // SPMS Administrator / Planner

  // ===== 조회 — filters 는 store 보관 참조만 (인라인 객체 금지 — 참조 비교 함정) =====
  const { data: treeData } = useTabProcQuery<MENU_ID, SHEETS.TREE>({
    menuId: MENU_ID,
    sheetName: SHEETS.TREE,
    tabId,
    filters: filters[SHEETS.TREE],
    enabled: !!filters[SHEETS.TREE],
  });
  const { data: processData } = useTabProcQuery<MENU_ID, SHEETS.PROCESS>({
    menuId: MENU_ID,
    sheetName: SHEETS.PROCESS,
    tabId,
    filters: filters[SHEETS.PROCESS],
    enabled: !!filters[SHEETS.PROCESS],
  });
  const { data: buildData } = useTabProcQuery<MENU_ID, SHEETS.BUILD>({
    menuId: MENU_ID,
    sheetName: SHEETS.BUILD,
    tabId,
    filters: filters[SHEETS.BUILD],
    enabled: !!filters[SHEETS.BUILD],
  });
  const { data: yieldData } = useTabProcQuery<MENU_ID, SHEETS.YIELD>({
    menuId: MENU_ID,
    sheetName: SHEETS.YIELD,
    tabId,
    filters: filters[SHEETS.YIELD],
    enabled: !!filters[SHEETS.YIELD],
  });
  const treeRows = useMemo<TreeRow[]>(() => treeData?.data ?? [], [treeData]);
  const processRows = useMemo<ProcessRow[]>(() => processData?.data ?? [], [processData]);
  const buildRow: BuildRow | undefined = buildData?.data?.[0];
  const plantRows = useMemo<PlantRow[]>(() => buildData?.plant ?? [], [buildData]); // build 2번째 커서
  const yieldRows = useMemo<YieldRow[]>(() => yieldData?.data ?? [], [yieldData]);

  // 재조회 = EditTracker clear (서버 커서가 새 단일 원천)
  useEffect(() => {
    if (!buildData) return;
    plantTrackerRef.current?.clearChanges();
  }, [buildData]);
  useEffect(() => {
    if (!yieldData) return;
    yieldTrackerRef.current?.clearChanges();
  }, [yieldData]);

  // mount 시 admin 메타 fetch + Tree 조회 (조회 버튼이 없는 화면 — 진입 즉시)
  useEffect(() => {
    void fetchStaticColumns([SHEETS.PLANT, SHEETS.YIELD]);
    setTreeFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 수정 pending — 요청법인/수율 양 그리드 (EditTracker 원본 + CRUD_TYPE 행 스캔)
  const hasPendingChanges = () =>
    (plantTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    GridUtils.isDirty(plantGridRef.current) ||
    (yieldTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    GridUtils.isDirty(yieldGridRef.current);

  const confirmPending = async () =>
    !hasPendingChanges() ||
    confirmMsg(MSG.PENDING_SEARCH_CONFIRM, '_수정 중인 내용이 있습니다. 조회하시겠습니까?');

  // ===== Tree 빌드 No. 선택 — process/build 필터 확정 (요청법인 그리드 = build 2번째 커서) =====
  const handleSelectBuild = (next: SelectedBuild) => {
    if (selected?.dpjtCode === next.dpjtCode && selected?.dpjtBuildNo === next.dpjtBuildNo) return;
    void (async () => {
      if (!(await confirmPending())) return;
      plantTrackerRef.current?.clearChanges();
      yieldTrackerRef.current?.clearChanges();
      selectBuild(next);
    })();
  };

  // ⭐ 다른 단계 화면의 ProcessFlow 클릭으로 인계된 빌드 — 이 화면 앞으로 온 것만 1회 소비해 바로 선택.
  //   MDI keep-alive 라 마운트 시점이 아니라 store 변경마다 본다 (이미 열린 탭으로 돌아오는 경우 포함).
  const pendingBuild = usePendingBuildStore(s => s.pending);
  useEffect(() => {
    const build = takePendingBuild(MENU_ID);
    if (build) handleSelectBuild(build);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pendingBuild]);

  // ===== 요청법인 패널 행 선택 → 그 행의 구분(공정 그룹)으로 수율 그리드 조회 =====
  //   같은 구분 안의 다른 공정 행을 눌러도 조회 키가 같아 재조회하지 않는다.
  const handleSelectPlantRow = (row: PlantRow | undefined) => {
    const next = toSelectedOperationGroup(row);
    if (!next) return;
    if (
      selectedOperation?.operationGroup === next.operationGroup &&
      selectedOperation?.mgmtType === next.mgmtType
    ) {
      return;
    }
    void (async () => {
      const yieldPending =
        (yieldTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
        GridUtils.isDirty(yieldGridRef.current);
      if (yieldPending) {
        const ok = await confirmMsg(
          MSG.PENDING_SEARCH_CONFIRM,
          '_수정 중인 내용이 있습니다. 조회하시겠습니까?'
        );
        if (!ok) return;
        yieldTrackerRef.current?.clearChanges();
      }
      selectOperation(next);
    })();
  };

  // ===== [1. 샘플 요청 법인] 저장 — 전 행 replace-set '^' 벌크 1건 (SAVEPLANT → SAVE_PJT_SAMPLE_BUILD) =====
  const handleSavePlant = () => {
    if (!selected) return;
    const dirty =
      (plantTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
      GridUtils.isDirty(plantGridRef.current);
    if (!dirty) {
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    const rows = (plantGridRef.current?.collectionView?.sourceCollection ??
      plantRows) as unknown as PlantRow[];
    const payload = toSavePlantPayload(rows, { ...selected, sesDivisionId });
    if (!payload) {
      alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
      return;
    }
    void (async () => {
      if (!(await confirmMsg(MSG.SAVE_CONFIRM, '_저장 하시겠습니까?'))) return;
      const result = await callSavePlant(payload);
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message || t(MSG.SAVE_FAIL, '_저장에 실패하였습니다.'),
        });
        return;
      }
      if (result.event === 0) {
        // EVENT 0 — 처리된 건 없음 (허위성공 방지: 성공 토스트 금지)
        alertMsg(MSG.NO_CHANGES, '_수정한 내용이 없습니다.');
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
      refreshSelected(); // 패널 + Process(계획수율 진행) 재조회 — 공정 선택 유지 시 수율도 함께
    })();
  };

  // ===== [2. 수율/Loss 계획 점검] 확정 — 조건행 전수 '^' 벌크 1건 (CONFIRM) =====
  const handleConfirmYield = () => {
    if (!selected) return;
    if (!selectedOperation) {
      alertMsg(MSG.NO_SELECTION, '_선택한 항목이 없습니다.');
      return;
    }
    const rows = (yieldGridRef.current?.collectionView?.sourceCollection ??
      yieldRows) as unknown as YieldRow[];
    const payload = toConfirmYieldPayload(rows, selectedOperation, { ...selected, sesDivisionId });
    if (!payload) {
      alertMsg(MSG.NO_SELECTION, '_선택한 항목이 없습니다.');
      return;
    }
    void (async () => {
      if (!(await confirmMsg(MSG.CONFIRM_CONFIRM, '_계획수율을 확정하시겠습니까?'))) return;
      const result = await callConfirmYield(payload);
      if (!result.ok || result.event === 0) {
        void setAlert({
          type: 'alert',
          content:
            (!result.ok && result.message) ||
            t(MSG.CONFIRM_FAIL, '_계획수율 확정에 실패하였습니다.'),
        });
        return;
      }
      setToast({ type: 'success', message: t(MSG.CONFIRM_DONE, '_계획수율이 확정되었습니다.') });
      refreshYield();
      refreshSelected(); // Process 단계(PLAN_YIELD) 갱신 반영
    })();
  };

  const canSavePlant = !!selected && hasButton(BTN.SAVE_PLANT);
  const canConfirm = !!selected && hasButton(BTN.CONFIRM);

  // 공통 버튼 — Excel/Filter/Sort 자동 활성. 조회조건·행 추가/삭제/일괄 저장 없는 화면이라 나머지는 끈다
  //   (확정은 customButtons — 표준 save 슬롯이 아닌 화면 고유 액션)
  const hotkeyConfig: HotkeyConfig = {
    search: false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
    // 목업에 없는 공통 툴바 버튼 — Excel 만 남긴다
    sort: false,
    filter: false,
    condition: false,
    resetCondition: false,
  };

  const yieldTitle = `2. ${t(LBL.YIELD_TITLE, '_수율/Loss 계획 점검')}`;

  // ⭐ 페이지 최상위 = fragment (래퍼 div 금지 — hook #132)
  return (
    <>
      {/* 조회조건(SearchArea) 없는 화면 — Search Area 토글 자체를 숨긴다 */}
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <div className={styles.content}>
        <SampleStatusTree
          rows={treeRows}
          inProgressOnly={inProgressOnly}
          onToggleProgress={setInProgressOnly}
          onSelectBuild={handleSelectBuild}
          selected={selected ?? undefined}
        />
        <div className={styles.right}>
          <SampleProcessFlow
            rows={processRows}
            currentProcess={CURRENT_PROCESS}
            build={selected ?? undefined}
          />
          <div className={styles.panels}>
            <RequestPlantPanel
              build={buildRow}
              rows={plantRows}
              gridRef={plantGridRef as never}
              editTrackerRef={plantTrackerRef}
              staticColumns={staticColumns[SHEETS.PLANT]}
              divisionId={buildRow?.DIVISION_ID ?? sesDivisionId}
              canSave={canSavePlant}
              onSave={handleSavePlant}
              onSelectRow={handleSelectPlantRow}
            />
            <div className={styles.yieldSection}>
              <div className={styles.yieldHeader}>
                <SubTitle
                  menuId={MENU_ID}
                  title={yieldTitle}
                  grid={yieldGridRef}
                  gridFilter={yieldFilterRef}
                  dataCount={0} // "총 n건" 미표시 (2026-09-04 요청 — SubTitle 은 0 이면 건수 숨김)
                  excelFileName='PlanYield'
                  useHotkey={true}
                  hotkeyConfig={hotkeyConfig}
                  customButtons={
                    canConfirm
                      ? [
                          {
                            label: t(LBL.CONFIRM, '_확정'),
                            action: handleConfirmYield,
                            appearance: 'contained',
                            priority: 'primary',
                          },
                        ]
                      : undefined
                  }
                />
              </div>
              <div className={styles.yieldGrid}>
                <YieldLossGrid
                  rows={yieldRows}
                  gridRef={yieldGridRef as never}
                  gridFilterRef={yieldFilterRef}
                  editTrackerRef={yieldTrackerRef}
                  staticColumns={staticColumns[SHEETS.YIELD]}
                  canEdit={canConfirm}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
