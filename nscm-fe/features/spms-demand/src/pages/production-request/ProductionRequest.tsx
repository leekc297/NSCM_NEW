import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useRef, useState, useMemo } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { SampleProcessFlow } from '../../components/sample-process-flow';
import { runPerRowProc, toText } from '../../lib/call-proc';

import { SampleBuildPanel } from './components/SampleBuildPanel';
import { SampleDemandGrid } from './components/SampleDemandGrid';
//import { SampleProcessFlow } from './components/SampleProcessFlow';
import { SampleTree } from './components/SampleTree';
import {
  DEMAND_KEY_BINDINGS,
  CURRENT_PROCESS,
  MENU_ID,
  MSG,
  SHEETS,
} from './production-request.constants';
import type {
  BuildFormState,
  BuildRow,
  DemandRow,
  ProcessRow,
  TreeRow,
} from './production-request.types';
import styles from './ProductionRequest.module.scss';
import { useProductionRequestStore } from './useProductionRequestStore';
import {
  callSaveSampleBuild,
  callSaveSampleDemand,
  toSaveDemandPayload,
} from './utils/production-request.api';
import { parseBuildNodeId } from './utils/production-request.tree';

// SDM2010 Production Request (샘플 수요 > 샘플제작 요청 > 생산 요청 — ROUTE_PATH
// 'spms-demand/production-request').
//   ⭐ 정본 원천 = 화면설계서 SDM2010_ProdReq_화면설계서_20260824.xlsx (순수 신규 — AS-IS 부재).
//   조회조건(SearchArea) 없음 — 좌측 샘플 현황 Tree 의 빌드 No. 선택이 곧 조회 트리거
//   (§확인사항 1.1.1). 선택 시 Process/빌드 패널/수요 그리드 3종을 함께 조회한다.
//   샘플 빌드 저장 = 단건 call-proc (P_SDM2010_SAVE_PJT_SAMPLE_BUILD — CODE '0'+EVENT 판정,
//   EVENT 0 = 성공 토스트 금지). 수요 그리드 저장 = 공통 useProcMutation (SP 등재 시 확정 —
//   constants.ts 정오 메모).
export const ProductionRequest = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<DemandRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const confirmMsg = useCallback(
    (msgId: string, fallback: string) => setAlert({ type: 'confirm', content: t(msgId, fallback) }),
    [setAlert, t]
  );

  // Store selector — 개별 selector 로만 구독 (객체 통째 destructuring 금지 규칙)
  const filters = useProductionRequestStore(s => s.filters);
  const selected = useProductionRequestStore(s => s.selected);
  const inProgressOnly = useProductionRequestStore(s => s.inProgressOnly);
  const buildInsertMode = useProductionRequestStore(s => s.buildInsertMode);
  const staticColumns = useProductionRequestStore(s => s.staticColumns);
  const setTreeFilter = useProductionRequestStore(s => s.setTreeFilter);
  const selectBuild = useProductionRequestStore(s => s.selectBuild);
  const refreshSelected = useProductionRequestStore(s => s.refreshSelected);
  const setInProgressOnly = useProductionRequestStore(s => s.setInProgressOnly);
  const setBuildInsertMode = useProductionRequestStore(s => s.setBuildInsertMode);
  const fetchStaticColumns = useProductionRequestStore(s => s.fetchStaticColumns);

  const divisionId = useSessionStore.getState().session.div ?? '';

  // 샘플 빌드 등록 패널 편집 값 — 신규 진입 시 현재 빌드 값으로 초기화되는 일시 상태
  const [buildForm, setBuildForm] = useState<BuildFormState>({
    buildType: '',
    buildSeq: '',
    bindType: '',
    bindSeq: '',
    note: '',
  });

  const { saveWithValidation } = useSaveWithValidation();

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
    // 빌드번호(dpjtBuildNo)가 있을 때만 활성화(Level 3 호출)
    enabled: !!filters[SHEETS.PROCESS] && !!selected?.dpjtBuildNo,
  });
  const { data: buildData } = useTabProcQuery<MENU_ID, SHEETS.BUILD>({
    menuId: MENU_ID,
    sheetName: SHEETS.BUILD,
    tabId,
    filters: filters[SHEETS.BUILD],
    // 빌드번호(dpjtBuildNo)가 있을 때만 활성화(Level 3 호출)
    enabled: !!filters[SHEETS.BUILD] && !!selected?.dpjtBuildNo,
  });
  const { data: demandData } = useTabProcQuery<MENU_ID, SHEETS.DEMAND>({
    menuId: MENU_ID,
    sheetName: SHEETS.DEMAND,
    tabId,
    filters: filters[SHEETS.DEMAND],
    // 빌드번호(dpjtBuildNo)가 있을 때만 활성화(Level 3 호출)
    enabled: !!filters[SHEETS.DEMAND] && !!selected?.dpjtBuildNo,
  });
  //const treeRows = (treeData?.data ?? []) as unknown as TreeRow[];
  const treeRows = useMemo<TreeRow[]>(() => treeData?.data ?? [], [treeData]);
  //const processRows = (processData?.data ?? []) as unknown as ProcessRow[];
  const processRows = useMemo<ProcessRow[]>(() => processData?.data ?? [], [processData]);
  const buildRow = ((buildData?.data ?? []) as unknown as BuildRow[])[0] || undefined;
  //const demandRows = (demandData?.data ?? []) as unknown as DemandRow[];
  const demandRows = useMemo<DemandRow[]>(() => demandData?.data ?? [], [demandData]);

  // 현재 프로젝트 노드의 권한 타입
  const currentAuthType = useMemo(() => {
    if (!selected) return null;

    // 1. buildRow 내부 권한 확인
    if (buildRow?.DPJT_AUTH_TYPE) return String(buildRow.DPJT_AUTH_TYPE).toUpperCase().trim();

    // 2. Level 2 상태인 경우 treeRows 리스트에서 현재 선택된 dpjtCode 행을 정밀 추적
    const matchRow = treeRows.find(
      r => toText(r.DPJT_CODE) === selected.dpjtCode || toText(r.ITEM_ID) === selected.dpjtCode
    );

    // 3. 커서 구조상 DPJT_AUTH_TYPE 컬럼 위치 확인 또는 유추 적용
    const auth = matchRow?.DPJT_AUTH_TYPE || matchRow?.['AUTH_TYPE'];
    return auth ? String(auth).toUpperCase().trim() : null;
  }, [selected, buildRow, treeRows]);

  // 해당 프로젝트가 등록, 수정이 가능한 상태인지
  const isProjectEditable = useMemo(() => {
    return Boolean(selected && (currentAuthType === 'ADMIN' || currentAuthType === 'WRITE'));
  }, [selected, currentAuthType]);

  // 재조회 = EditTracker clear (서버 커서가 새 단일 원천)
  useEffect(() => {
    if (!demandData) return;
    editTrackerRef.current?.clearChanges();
  }, [demandData]);

  // mount 시 admin 메타 fetch + Tree 조회 (조회 버튼이 없는 화면 — 진입 즉시)
  useEffect(() => {
    void fetchStaticColumns([SHEETS.DEMAND]);
    setTreeFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 수요 그리드 수정 pending — Tree 이동 confirm 축
  const hasPendingChanges = () =>
    (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0 ||
    GridUtils.isDirty(gridRef.current);

  // ===== Tree 빌드 No. 선택 — process/build/demand 필터 확정 (§확인사항 1.1.1) =====
  const handleNodeClick = (id: string) => {
    // parseBuildNodeId가 Level 2(프로젝트) 노드 클릭 시에도 dpjtCode를 반환할 수 있어야 합니다.
    const parsed = parseBuildNodeId(id, treeRows);
    if (!parsed || !parsed.dpjtCode) return; // 프로젝트 코드조차 없으면 리턴 (고객 노드 등)
    if (selected?.dpjtCode === parsed.dpjtCode && selected?.dpjtBuildNo === parsed.dpjtBuildNo) {
      return;
    }
    void (async () => {
      if (hasPendingChanges()) {
        const ok = await confirmMsg(
          MSG.PENDING_SEARCH_CONFIRM,
          '_수정 중인 내용이 있습니다. 조회하시겠습니까?'
        );
        if (!ok) return;
      }
      selectBuild(parsed);
    })();
  };

  // ===== 샘플 빌드 등록 패널 (§확인사항 1.1 조회/편집 모드) =====
  const handleBuildInsert = () => {
    // 입력 권한이 없을 경우 편집창 진입 차단
    if (!isProjectEditable) return;
    // 신규 진입 — 현재 빌드 값으로 초기화 (설계서 Insert View: 기존 값이 선택된 채 시작)
    setBuildForm({
      buildType: toText(buildRow?.DPJT_BUILD_TYPE),
      buildSeq: toText(buildRow?.DPJT_BUILD_SEQ),
      bindType: toText(buildRow?.DPJT_BIND_TYPE),
      bindSeq: toText(buildRow?.DPJT_BIND_SEQ),
      note: '',
    });
    setBuildInsertMode(true);
  };
  const handleBuildCancel = () => setBuildInsertMode(false);
  const handleBuildSave = () => {
    // 입력 권한이 없을 경우 편집창 진입 차단
    if (!isProjectEditable || !selected) return;
    // 필수값 검증 (사용자가 입력한 빌드 차수 구분과 시퀀스 필수 체크)
    if (!buildForm.buildType || !buildForm.buildSeq) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_INPUT, '_필수값을 입력하세요.') });
      return;
    }
    void (async () => {
      if (!(await confirmMsg(MSG.SAVE_CONFIRM, '_저장 하시겠습니까?'))) return;
      const result = await callSaveSampleBuild({
        dpjtCode: selected.dpjtCode,
        dpjtBuildNo: selected.dpjtBuildNo || '',
        dpjtBuildType: buildForm.buildType,
        dpjtBuildSeq: buildForm.buildSeq,
        dpjtBindType: 'N', // [임시] 화면에는 없지만 백엔드 전달용 고정값 'N' 주입
        dpjtBindSeq: buildForm.bindSeq,
        note: buildForm.note,
        sesDivisionId: divisionId,
      });
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message || t(MSG.SAVE_FAIL, '_저장에 실패하였습니다.'),
        });
        return;
      }
      if (result.event === 0) {
        // EVENT 0 — 처리된 건 없음 (허위성공 방지: 성공 토스트 금지)
        setToast({ type: 'default', message: t(MSG.NO_CHANGES, '_수정된 내용이 없습니다.') });
        return;
      }
      setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
      setBuildInsertMode(false);
      setTreeFilter(); // 신규 빌드가 Tree 에 나타나도록 재조회
      refreshSelected();
    })();
  };

  // ===== 샘플 수요 등록 그리드 — 추가(F8)/삭제(F9)/저장(F7) =====
  const handleInsert = () => {
    // 입력 권한이 없을 경우 편집창 진입 차단
    if (!isProjectEditable) return;
    const grid = gridRef.current;
    if (!grid || !selected) return;
    // 신규 행 키 — Tree 선택 정보 (저장 SP IN 파라미터 원천)
    GridAction.addRow(grid, {
      [DEMAND_KEY_BINDINGS.DPJT_CODE]: selected.dpjtCode,
      [DEMAND_KEY_BINDINGS.DPJT_BUILD_NO]: selected.dpjtBuildNo,
    });
  };
  const handleDelete = () => {
    // 입력 권한이 없을 경우 편집창 진입 차단
    if (!isProjectEditable) return;
    const grid = gridRef.current;
    if (!grid) return;
    const selectedRows = GridUtils.getSelectedRows(grid) ?? [];
    if (selectedRows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SELECTION, '_No selection') });
      return;
    }
    GridAction.removeRow(grid);
  };
  // ⭐ 저장 = 행별 단건 call-proc (SDM1020 확정 계보 — '^' bulk join 금지) + EVENT 판정
  //   (EVENT 0 = 성공 토스트 금지 — 허위성공 방지. 중도 실패 시 SP 내부 COMMIT 분은 재조회로 정합)
  const handleSave = () => {
    // 입력 권한이 없을 경우 편집창 진입 차단
    if (!isProjectEditable) return;
    const grid = gridRef.current;
    const saveData = GridUtils.getChangedRows(grid) as DemandRow[] | undefined;
    if (!saveData || saveData.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGES, '_수정된 내용이 없습니다.') });
      return;
    }
    void (async () => {
      if (!(await confirmMsg(MSG.SAVE_CONFIRM, '_저장 하시겠습니까?'))) return;
      saveWithValidation(saveData, staticColumns[SHEETS.DEMAND] ?? [], rows => {
        void (async () => {
          const result = await runPerRowProc(
            rows.map(row => () => callSaveSampleDemand(toSaveDemandPayload(row, divisionId)))
          );
          if (!result.ok) {
            void setAlert({
              type: 'alert',
              content: result.message || t(MSG.SAVE_FAIL, '_저장에 실패하였습니다.'),
            });
            if (result.totalEvent > 0) refreshSelected();
            return;
          }
          if (result.totalEvent === 0) {
            setToast({ type: 'default', message: t(MSG.NO_CHANGES, '_수정된 내용이 없습니다.') });
            return;
          }
          setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다!') });
          refreshSelected();
        })();
      });
    })();
  };

  // 공통 버튼 — Insert/Delete/Save/Excel/Filter/Sort. 조회조건 없는 화면이라 Search 는 끈다.
  // 쓰기[WRITE] 권한 공통 적용
  const hotkeyConfig: HotkeyConfig = {
    insert: isProjectEditable && selected ? handleInsert : false,
    delete: isProjectEditable && selected ? handleDelete : false,
    save: isProjectEditable && selected ? handleDelete : false,
    search: false,
    manual: false,
    upload: false,
  };

  // ⭐ 페이지 최상위 = fragment (래퍼 div 금지 — hook #132)
  return (
    <>
      {/* 조회조건(SearchArea) 없는 화면 — Search Area 토글 자체를 숨긴다 */}
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <div className={styles.content}>
        <SampleTree
          rows={treeRows}
          inProgressOnly={inProgressOnly}
          onToggleProgress={setInProgressOnly}
          onNodeClick={handleNodeClick}
        />
        <div className={styles.right}>
          {/* [수정] Level 3 전체 영역 분기: 빌드가 선택되었을 때만 렌더링하도록 변경 */}
          <SampleProcessFlow rows={processRows} currentProcess={CURRENT_PROCESS} />
          <div className={styles.panels}>
            <SampleBuildPanel
              build={buildRow || ({ DPJT_CODE: selected?.dpjtCode ?? '' } as BuildRow)}
              insertMode={buildInsertMode}
              form={buildForm}
              onFormChange={patch => setBuildForm(prev => ({ ...prev, ...patch }))}
              onInsert={handleBuildInsert}
              onCancel={handleBuildCancel}
              onSave={handleBuildSave}
              // [추가] 권한 변수 전달,
              isEditable={isProjectEditable}
            />
            <div className={styles.demandSection}>
              {/* LBL 채번 = SDM2010_META_20260827/sql/03_META §[1] */}
              <SubTitle
                menuId={MENU_ID}
                title={`2. ${t('LBL01023', '_샘플 수요 등록')}`}
                grid={gridRef}
                gridFilter={gridFilterRef}
                dataCount={demandRows.length}
                excelFileName='ProductionRequest'
                // [수정] 권한 연동
                useHotkey={Boolean(selected && selected.dpjtBuildNo && isProjectEditable)}
                hotkeyConfig={hotkeyConfig}
              />
              <div className={styles.demandGrid}>
                <SampleDemandGrid
                  rows={demandRows}
                  gridRef={gridRef as never}
                  gridFilterRef={gridFilterRef}
                  editTrackerRef={editTrackerRef}
                  divisionId={divisionId}
                  staticColumns={staticColumns[SHEETS.DEMAND]}
                  // [추가] 권한 변수 전달, 빌드가 선택되지 않은 상태에서는 그리드 자체를 ReadOnly 모드로 고정
                  isEditable={Boolean(selected && selected.dpjtBuildNo && isProjectEditable)}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
