import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { OutsourcingCapacityForm } from './components/OutsourcingCapacityForm';
import { OutsourcingCapacityGrid } from './components/OutsourcingCapacityGrid';
import { useOutsourcingCapacityValidation } from './hooks/useOutsourcingCapacityValidation';
import { MENU_ID, MSG, SHEETS } from './outsourcing-capacity.constants';
import type { MainRow } from './outsourcing-capacity.types';
import styles from './OutsourcingCapacity.module.scss';
import { useOutsourcingCapacityStore } from './useOutsourcingCapacityStore';

// AS-IS GSCM.SCP.Master.UIL SCP0023_OutsourcingCapacity — 단일 그리드(spdMain "Outsourcing Capacity").
//   설계: .atlas/gscm-design/SCP0023/design/00~03 + 07. 상세 매핑: __asis-mapping__.md.
//   편집제어: AS-IS SwitchLock 뷰/편집 토글은 NSCM 표준(상시편집 + 셀 화이트리스트 daily_capa_qty)으로 재현.
//   Insert/Delete = AS-IS NO-OP → 툴바 미노출(Search·Save 만).
export const OutsourcingCapacity = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateMainRows } = useOutsourcingCapacityValidation();
  // 필수 컬럼(메타 INPUT_TP_CD=M/IM 또는 라벨 *) 저장검증 — 전 화면 공통.
  const { saveWithValidation } = useSaveWithValidation();
  // admin 버튼 권한(SCM_ADM_USER_GR_MNU_BTN_MPG_M) 동적 반영 — hotkeyConfig 하드코딩 금지(CLAUDE.md 체크3,
  //   screen-completion-gate G2, 자매 bod/production-plan-line/project-route 표준). USE_YN='N' 시 자동 미노출.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const trackerRef = useRef<EditTracker>();

  const sc = useOutsourcingCapacityStore(s => s.searchCondition);
  const setSearchCondition = useOutsourcingCapacityStore(s => s.setSearchCondition);
  const filters = useOutsourcingCapacityStore(s => s.filters);
  const setFilter = useOutsourcingCapacityStore(s => s.setFilter);
  const openSearchArea = useOutsourcingCapacityStore(s => s.openSearchArea);
  const setOpenSearchArea = useOutsourcingCapacityStore(s => s.setOpenSearchArea);
  const staticColumns = useOutsourcingCapacityStore(s => s.staticColumns);
  const fetchStaticColumns = useOutsourcingCapacityStore(s => s.fetchStaticColumns);
  const initialized = useOutsourcingCapacityStore(s => s.initialized);

  const [openItem, setOpenItem] = useState(false);

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

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division 필수 (design 02 §6-7, AS-IS checkRequiredOfSearch Division*).
    if (!sc.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_FIELD, '_Division.') });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  const handleSave = async () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const all = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = all.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes.') });
      return;
    }
    // 저장 확인 (design 01 §2 R4 — AS-IS MSG00012 저장확인).
    const ok = await setAlert({
      type: 'confirm',
      content: t(MSG.CONFIRM_SAVE, '_Would you like to save row {0}?').replace(
        '{0}',
        String(dirty.length)
      ),
    });
    if (!ok) return;
    // 저장 전 검증 — daily_capa_qty 필수·최소1 + Plant Total 필수(MSG00258) (design 03 §4.2).
    if (!validateMainRows(dirty, all).ok) return;
    // 필수 컬럼(메타 M/IM) 검증 통과 시 mutate — 미입력이면 alert 후 차단(전 화면 공통).
    saveWithValidation(dirty as unknown as MainRow[], staticColumns[SHEETS.MAIN], mutate);
  };

  // Insert/Delete = AS-IS NO-OP(빈 본문 cs:233/237) → 등록 안 함(툴바 미노출). Search·Save 만.
  //   버튼권한(hasButton)으로 게이트 — admin USE_YN='N' 이면 자동 미노출(권한 메타 층 enforce).
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
        <OutsourcingCapacityForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='OutsourcingCapacity'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.tableWrapper}>
        <OutsourcingCapacityGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={trackerRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Model 검색 — 공용 표준 ItemByDivisionModal (20+ 화면 공용, 자체 menuId/sheet 조회). design 02 §4.6 */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
