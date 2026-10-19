import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SalesSitePriorityForm } from './components/SalesSitePriorityForm';
import { SalesSitePriorityGrid } from './components/SalesSitePriorityGrid';
import { useSalesSitePriorityValidation } from './hooks/useSalesSitePriorityValidation';
import { MENU_ID, MSG, SHEETS } from './sales-site-priority.constants';
import type { SalesSitePriorityRow } from './sales-site-priority.types';
import { useSalesSitePriorityStore } from './useSalesSitePriorityStore';
import { insertDefaults, s } from './utils/sales-site-priority.editLock';

// AS-IS GSCM.SCP.Master.UIL SCP0131_SalesSitePriority — 단일 그리드 마스터 CRUD(pivot 없음).
//   설계: .atlas/gscm-design/SCP0131/design/00~03. 상세 매핑: __asis-mapping__.md.
//   NSCM 표준(자매 SCP0037 operation-lt): 그리드 상시 편집 — 별도 Edit 토글(SwitchLock) 미배선.
//   셀별 편집가부는 editLock 화이트리스트가 판정. 2026-09-26 iter-3 AS-IS 원본 확보 후 확정:
//   EditButton(SwitchLock, l369~380)은 실동작이나 TO-BE 등록 버튼(SEARCH/INSERT/SAVE/DELETE 4종)에
//   EDIT 이 없어 이 대체가 최종 설계다(__asis-mapping__.md 근거 갱신).
export const SalesSitePriority = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSaveRows } = useSalesSitePriorityValidation();
  // 필수 컬럼(메타 M/IM) 저장검증 — 전 화면 공통. 이 화면 INPUT_TP_CD 전 'S' 라 필수는 validateSaveRows 가 병행.
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const filters = useSalesSitePriorityStore(st => st.filters);
  const setFilter = useSalesSitePriorityStore(st => st.setFilter);
  const clearFilters = useSalesSitePriorityStore(st => st.clearFilters);
  const openSearchArea = useSalesSitePriorityStore(st => st.openSearchArea);
  const setOpenSearchArea = useSalesSitePriorityStore(st => st.setOpenSearchArea);
  const staticColumns = useSalesSitePriorityStore(st => st.staticColumns);
  const fetchStaticColumns = useSalesSitePriorityStore(st => st.fetchStaticColumns);
  const initialized = useSalesSitePriorityStore(st => st.initialized);
  const searchCondition = useSalesSitePriorityStore(st => st.searchCondition);

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

  const rows = useMemo<SalesSitePriorityRow[]>(() => data?.o_rc1 ?? [], [data]);

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division 필수(design 02 §2-1 조회조건 카탈로그, cascade 트리거이자 GET SP 필수 파라미터).
    if (searchCondition.divisionId === '') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행(design 01 §2#6 / 03 §3.2, AS-IS Insert_Row l503~521 확정): 확정 조회조건 division
  //   기준 기본값(DIVISION_ID 항상잠금, VALID_YN='Y' AS-IS defaultData 그대로).
  //   AS-IS 미조회 상태 빈 행 삽입 금지(tact-time SCP0020 실사고 재발 방지) — 조회(filters) 선행 필수.
  //   InsertButton override 는 AS-IS 원본 확보(2026-09-26)로 실동작(Insert_Row 호출) 확정 —
  //   "조회 후 그리드 상시편집" 모드에서 행 추가를 허용하는 이 배선이 최종 구현이다(__asis-mapping__.md).
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const f = filters[SHEETS.MAIN];
    if (!f) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    const division = s((f as Record<string, unknown>).divisionId);
    if (division === '' || division.includes(',')) {
      // Division 은 단일 선택(design 02 주1) — 콤마 다중이면 신규행 기본값 확정 불가.
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    GridAction.addRow(grid, insertDefaults(division));
  };

  // 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시.
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selected = grid.selectedItems[0] as Record<string, unknown> | undefined;
    if (!selected) return;
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
    // 필수값 + PRIO_RANK>=1 + From<=To 검증(design 00 §4a validations 저장시점분, §3 참조).
    if (!validateSaveRows(src).ok) return;
    // 필수 컬럼 메타검증 통과 시 mutate(저장 성공/실패 toast·재조회는 useProcMutation 표준 onSuccess).
    saveWithValidation(
      dirty as unknown as SalesSitePriorityRow[],
      staticColumns[SHEETS.MAIN],
      mutate
    );
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
      {openSearchArea && <SalesSitePriorityForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesSitePriority'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
      />
      <SalesSitePriorityGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        adminColumns={staticColumns[SHEETS.MAIN]}
        onFocus={() => undefined}
      />
    </>
  );
};
