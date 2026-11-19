import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MdmClassMasterForm } from './components/MdmClassMasterForm';
import { MdmClassMasterGrid } from './components/MdmClassMasterGrid';
import { useMdmClassMasterValidation } from './hooks/useMdmClassMasterValidation';
import { MENU_ID, MSG, SHEETS } from './mdm-class-master.constants';
import type { MainRow } from './mdm-class-master.types';
import styles from './MdmClassMaster.module.scss';
import { useMdmClassMasterStore } from './useMdmClassMasterStore';

// AS-IS GSCM.SCP.Master.UIL SCP0087_MDMClassMaster — 단일 FpSpread "MDM Class Master".
//   설계: .atlas/gscm-design/SCP0087/design/00~03 + 07. 상세 매핑: __asis-mapping__.md.
//   핵심 특성: 조회직후 ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL 3컬럼 default 편집가능(사용자 지시 —
//   AS-IS Edit 버튼/편집모드 제거). 편집 제한은 admin 메타 INPUT_TP_CD='O' 3컬럼 + 공용 DataGrid
//   isEditableCell 이 담당. SAVE=UPDATE-only 3컬럼, Insert 비활성 / Delete no-op(툴바 미노출).
export const MdmClassMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const { validateSaveRows } = useMdmClassMasterValidation();
  // 필수 컬럼(메타 INPUT_TP_CD=M/IM) 저장검증 — 전 화면 공통. SCP0087 편집 3컬럼은 'O'(필수 아님)라 통과.
  const { saveWithValidation } = useSaveWithValidation();
  // admin 버튼 권한(SCM_ADM_USER_GR_MNU_BTN_MPG_M) 동적 반영 — 하드코딩 금지(CLAUDE.md 체크3, 자매 SCP0023 표준).
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const trackerRef = useRef<EditTracker>();

  const sc = useMdmClassMasterStore(s => s.searchCondition);
  const filters = useMdmClassMasterStore(s => s.filters);
  const setFilter = useMdmClassMasterStore(s => s.setFilter);
  const clearFilters = useMdmClassMasterStore(s => s.clearFilters);
  const openSearchArea = useMdmClassMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useMdmClassMasterStore(s => s.setOpenSearchArea);
  const staticColumns = useMdmClassMasterStore(s => s.staticColumns);
  const fetchStaticColumns = useMdmClassMasterStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = useMdmClassMasterStore(s => s.restoreSearchConditions);

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

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  // 진입 자동조회 금지 — keep-alive 탭 stale filters 무효화(clearFilters 게이트, nscm-patterns §5-7 / design 02 §4).
  //   F6 개인화 저장분은 복원(1회)해 폼에 주입 — filters 는 비운 채라 Search 눌러야 발사(자동조회 아님).
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 -> 새 데이터. 조회조건 필수값 없음(Use Flag default Y — 07 §2 L2).
  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns();
  };

  // Save -> 편집 3컬럼(admin 메타 'O')이 default 편집가능이므로 별도 편집모드 가드 없음.
  //   저장대상 0건이면 조용히 안내(false-success 방지는 useProcMutation 표준 판정).
  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const all = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // 저장대상 = CRUD_TYPE 마킹 행만(EditTracker). Insert/Delete 없어 실질 M(수정)만(design 03 §3 R6).
    const dirty = all.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    if (!validateSaveRows(dirty).ok) return;
    // 메타 필수검증(3컬럼 'O'라 통과) 후 mutate. SP 는 3컬럼만 UPDATE(design 03 §4.4).
    saveWithValidation(dirty as unknown as MainRow[], staticColumns[SHEETS.MAIN], mutate);
  };

  // Insert 비활성(R13) / Delete no-op(R14) — 툴바 미노출. Search/Save 만 hasButton 게이트(자매 SCP0023 표준).
  //   Edit 버튼 없음(사용자 지시 — default 편집). 편집가능 컬럼은 admin 메타 INPUT_TP_CD='O' 3컬럼으로 한정.
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
      {openSearchArea && <MdmClassMasterForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='MdmClassMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.tableWrapper}>
        <MdmClassMasterGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={trackerRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>
    </>
  );
};
