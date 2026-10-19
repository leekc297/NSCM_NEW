import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { OperationLTForm } from './components/OperationLTForm';
import { OperationLTGrid } from './components/OperationLTGrid';
import { useOperationLTValidation } from './hooks/useOperationLTValidation';
import { MENU_ID, MSG, SHEETS, VALID_ALL } from './operation-lt.constants';
import type { OperationLTRow } from './operation-lt.types';
import { isPreInspSelected, useOperationLTStore } from './useOperationLTStore';
import { insertDefaults } from './utils/operation-lt.editLock';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 콤마 다중값의 첫 실코드(ALL/공백 제외) — Insert 기본값 division/LT operation 도출.
const firstToken = (v: unknown): string => {
  const first = s(v)
    .split(',')
    .map(x => x.trim())
    .find(x => x !== '' && x.toUpperCase() !== VALID_ALL);
  return first ?? '';
};

// AS-IS GSCM.SCP.Master.UIL SCP0037_OperationLT — 단일 그리드 마스터 CRUD(pivot 없음).
//   설계: .atlas/gscm-design/SCP0037/design/00~03·07. 상세 매핑: __asis-mapping__.md.
//   NSCM 표준(formation/tact-time): 그리드 상시 편집 — 별도 Edit 토글 없음. 셀별 편집가부는 editLock 이 판정
//   (AS-IS "조회직후 전체 lock -> Edit unlock" 은 셀 white-list 상시 적용으로 대체, hotkey F2 미배선).
export const OperationLT = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSaveRows } = useOperationLTValidation();
  // 필수 컬럼(메타 M/IM) 저장검증 — 전 화면 공통. 이 화면 INPUT_TP_CD 전 'S' 라 필수는 validateSaveRows 가 병행.
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const [openMaterial, setOpenMaterial] = useState(false);

  const sc = useOperationLTStore(st => st.searchCondition);
  const setSearchCondition = useOperationLTStore(st => st.setSearchCondition);
  const filters = useOperationLTStore(st => st.filters);
  const setFilter = useOperationLTStore(st => st.setFilter);
  const clearFilters = useOperationLTStore(st => st.clearFilters);
  const openSearchArea = useOperationLTStore(st => st.openSearchArea);
  const setOpenSearchArea = useOperationLTStore(st => st.setOpenSearchArea);
  const staticColumns = useOperationLTStore(st => st.staticColumns);
  const fetchStaticColumns = useOperationLTStore(st => st.fetchStaticColumns);
  const fetchSearchConditions = useOperationLTStore(st => st.fetchSearchConditions);
  const initialized = useOperationLTStore(st => st.initialized);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo<OperationLTRow[]>(() => data?.o_rc1 ?? [], [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  //   F6 저장 조건 복원(fetchSearchConditions)을 컬럼 메타 fetch 보다 먼저 await 한다 — fetchStaticColumns 가
  //   initialized=true 를 세우므로 복원이 그 전에 돌아야 한다(복원은 initialized 가드로 1회만, SCP0042 패턴).
  useEffect(() => {
    if (!initialized)
      void (async () => {
        await fetchSearchConditions();
        await fetchStaticColumns();
      })();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // INV_FLAG 조건부 Visible — LT Operation=PRE_INSP 단독 선택 시 (design 01 R6 / 03 §2).
  const showInvFlag = isPreInspSelected(sc.ltOperationIds);

  const handleSearch = () => {
    // Division 필수 (design 02 §6 / 07 §2#1, R10 권한 게이트 실질 필수).
    if (sc.divisionIds.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division') });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행(design 01 R4 / 03 §3-3): 확정 조회조건 division/LT operation 기준 기본값.
  //   AS-IS 미조회 상태 빈 행 삽입 금지(tact-time SCP0020 실사고) — 조회(filters) 선행 필수.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const f = filters[SHEETS.MAIN];
    if (!f) {
      void setAlert({ type: 'alert', content: t(MSG.INSERT_GUIDE, '_Edit mode is available after search.') });
      return;
    }
    const division = firstToken((f as Record<string, unknown>).divisionId);
    const ltOperation = firstToken((f as Record<string, unknown>).ltOperation);
    if (division === '') {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division') });
      return;
    }
    GridAction.addRow(grid, insertDefaults(division, ltOperation));
  };

  // 삭제(design 01 R5 / 03 §3-1): 신규행('I')만 클라 제거. 기존행 삭제 불가(무메시지).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selected = grid.selectedItems[0] as Record<string, unknown> | undefined;
    if (!selected || s(selected.CRUD_TYPE) !== CRUD_TYPE.INSERT) return;
    GridAction.removeRow(grid);
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 필수값 + 4키 중복 검증(design 01 R9 / 03 §3-4) — 전 행 대상 스캔.
    if (!validateSaveRows(src).ok) return;
    // 필수 컬럼 메타검증 통과 시 mutate (저장 성공/실패 toast·재조회는 useProcMutation 표준 onSuccess).
    saveWithValidation(dirty as unknown as OperationLTRow[], staticColumns[SHEETS.MAIN], mutate);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
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
        <OperationLTForm onSearch={handleSearch} onItemSearch={() => setOpenMaterial(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='OperationLT'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      <OperationLTGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        editMode={true}
        showInvFlag={showInvFlag}
        adminColumns={staticColumns[SHEETS.MAIN]}
        onFocus={() => undefined}
      />

      {/* 조회영역 Material 팝업 — MaterialByDivisionModal(COM0013). 그리드 셀 ItemByDivisionModal(COM0008)과 대체 금지. */}
      <MaterialByDivisionModal
        open={openMaterial}
        modalClose={() => setOpenMaterial(false)}
        setSelectedValue={items => setSearchCondition({ itemId: items })}
        preSearchParams={{
          divisionId: sc.divisionIds[0] ?? '',
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
