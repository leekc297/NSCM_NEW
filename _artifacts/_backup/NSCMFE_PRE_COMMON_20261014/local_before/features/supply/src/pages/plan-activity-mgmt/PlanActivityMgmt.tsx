import type { FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { PlanActivityMgmtForm } from './components/PlanActivityMgmtForm';
import { PlanActivityMgmtGrid } from './components/PlanActivityMgmtGrid';
import { MENU_ID, MSG, SHEETS } from './plan-activity-mgmt.constants';
import type { PlanActivityMgmtRow } from './plan-activity-mgmt.types';
import { usePlanActivityMgmtStore } from './usePlanActivityMgmtStore';
import { buildSavePayload, hasDuplicateNewRow, str } from './utils/plan-activity-mgmt.util';

export const PlanActivityMgmt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<TFlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<PlanActivityMgmtRow>>();
  const savingRef = useRef(false);

  const filters = usePlanActivityMgmtStore(state => state.filters);
  const searchParams = usePlanActivityMgmtStore(state => state.searchParams);
  const staticColumns = usePlanActivityMgmtStore(state => state.staticColumns);
  const openSearchArea = usePlanActivityMgmtStore(state => state.openSearchArea);
  const setFilters = usePlanActivityMgmtStore(state => state.setFilters);
  const clearFilters = usePlanActivityMgmtStore(state => state.clearFilters);
  const fetchStaticColumns = usePlanActivityMgmtStore(state => state.fetchStaticColumns);
  const setOpenSearchArea = usePlanActivityMgmtStore(state => state.setOpenSearchArea);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  // 저장 payload userId(감사/HISTORY user) — call-proc 은 세션 자동주입 없음(자매 SCP0006 패턴).
  const sessionUserId = useSessionStore(state => state.session.userId);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo(
    () => (data as { o_rc1?: PlanActivityMgmtRow[] } | undefined)?.o_rc1 ?? [],
    [data]
  );

  // 진입 자동 조회 금지 — keep-alive 로 남은 이전 filters 자동 발사 차단(nscm-patterns §5-7).
  //   컬럼 메타는 mount 시 1회 로드(SCM_MST_SHEET_COLUMNS 15컬럼).
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
  }, [tabId, clearFilters, fetchStaticColumns]);

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // 신규행 기본값 5컬럼 = 확정 searchParams 복사원본(convert-core §2.4 — `?? 기본값` 폴백 금지, design 03 §3-R6).
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      DIVISION_ID: searchParams.divisionId,
      OPMZ_PRS_CD: searchParams.prsCd,
      OPMZ_PRS_NAME: searchParams.prsName,
      OPMZ_PLAN_GR_ID: searchParams.planGroupId,
      OPMZ_PLAN_GR_NAME: searchParams.planGroupName,
    } as Partial<PlanActivityMgmtRow>);
  };

  // 활성그리드 라우팅(hook #97). 신규행('I') 즉시제거 / 기존행 CRUD_TYPE='D' 마킹(design 03 §3-R8).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  const doSave = async (rowsToSave: PlanActivityMgmtRow[]) => {
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const payload = buildSavePayload(rowsToSave, sessionUserId ?? '');
      const res = await apiClient.post<unknown>(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, payload);
      const body = res.data as { code?: string | number; message?: string } | undefined;
      // false-success 판별 — 인터셉터가 500/403 도 resolve(nscm-patterns §5-10).
      if (res.status >= 400 || Number(body?.code)) {
        void useMessageStore.getState().setToast({
          type: 'error',
          message: str(body?.message) || t('MSG00043', '_Save failed.'),
        });
        return;
      }
      void useMessageStore.getState().setToast({
        type: 'success',
        message: t(MSG.SAVE_SUCCESS, '_Saved successfully.'),
      });
      editTrackerRef.current?.clearChanges();
      // 저장 성공 후 재조회 — filters 불변이라 refetch 허용(nscm-patterns §5-1 예외).
      void refetch();
    } finally {
      savingRef.current = false;
    }
  };

  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return;
    grid.finishEditing();

    const source = (grid.collectionView?.sourceCollection ?? []) as PlanActivityMgmtRow[];
    const dirtyRows = source.filter(row => (row as Record<string, unknown>).CRUD_TYPE);
    if (dirtyRows.length === 0) {
      void useMessageStore.getState().setToast({
        type: 'error',
        message: t(MSG.NO_CHANGE, '_No changes to save.'),
      });
      return;
    }

    // 신규행(I) 중복체크 — 직전 조회결과(기존행) 존재 시에만(design 03 §4.4 MSG00443 등가 MSG00428).
    const newRows = dirtyRows.filter(
      row => (row as Record<string, unknown>).CRUD_TYPE === CRUD_TYPE.INSERT
    );
    const existingRows = source.filter(row => !(row as Record<string, unknown>).CRUD_TYPE);
    if (existingRows.length > 0 && newRows.length > 0 && hasDuplicateNewRow(newRows, existingRows)) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.DUPLICATE, '_There are duplicate entries among the newly entered data.'),
      });
      return;
    }

    // 필수검증(useSaveWithValidation, INPUT_TP_CD=M: OPMZ_ACTV_SEQ/OPMZ_ACTV_NAME) 후 캐럿접기 저장.
    saveWithValidation(dirtyRows, staticColumns, saved => void doSave(saved));
  };

  // Edit 키 미배치 — asis_to_tobe §11 전 화면 공통 결정(design 01 §2 L6). Edit 는 공용 기본핸들러가
  //   없어 키 생략이 정답(Insert/Delete 와 달리 default addRow/removeRow 되살아나는 위험 없음).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlanActivityMgmtForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='PlanActivityMgmt'
        useHotkey
        hotkeyConfig={hotkeyConfig}
      />
      <PlanActivityMgmtGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        rows={rows}
      />
    </>
  );
};
