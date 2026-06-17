import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';

import { ColumnSettingModal } from '../../components';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ContributeVersionModal } from './components/modals/ContributeVersionModal';
import { MENU_ID, SHEETS } from './contribute-view.constants';
import styles from './ContributeView.module.scss';
import { useContributeViewValidation } from './hooks/useContributeViewValidation';
import type { SalesViewRow } from './types';
import { useContributeViewStore } from './useContributeViewStore';

// AS-IS DMF0043_Contribute_View — 기여율 조회 화면 (조회 전용)
//
// 핵심 보강 (2026-06-01 plan):
//   - 4축 100% 매핑 (Event 4 / API 3 / Validation 2 / Expression 2)
//   - POPUP 3종 (ContributeVersionModal / ColumnTitleSetModal / ContributeRatePopup 재사용)
//   - 룰 03/12/14/24/25/27/31 정합
//   - 메모리: no-type-cast / popup-asis-precision / pivot-frozen-columns / runtime-error-prevention 준수
export const ContributeView = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGridType<SalesViewRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useContributeViewStore(s => s.filters);
  const searchCondition = useContributeViewStore(s => s.searchCondition);
  const setSearchCondition = useContributeViewStore(s => s.setSearchCondition);
  const setFilter = useContributeViewStore(s => s.setFilter);
  const openSearchArea = useContributeViewStore(s => s.openSearchArea);
  const setOpenSearchArea = useContributeViewStore(s => s.setOpenSearchArea);

  const versionPopupOpen = useContributeViewStore(s => s.versionPopupOpen);
  const setVersionPopupOpen = useContributeViewStore(s => s.setVersionPopupOpen);
  const columnSetPopupOpen = useContributeViewStore(s => s.columnSetPopupOpen);
  const setColumnSetPopupOpen = useContributeViewStore(s => s.setColumnSetPopupOpen);
  // ⭐ UI 동적 속성관리 (master hook §4) — admin SYS0004 UI Category Setup 메타 동적 fetch
  const fetchStaticColumns = useContributeViewStore(s => s.fetchStaticColumns);
  const staticColumns = useContributeViewStore(s => s.staticColumns);

  // mount 시 admin 메타 fetch (master hook §2.3)
  useEffect(() => {
    void fetchStaticColumns();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const { validateVersionSelected, validateSearchResultEmpty } = useContributeViewValidation();

  // AS-IS Form_Load + FindData (.cs L283): DMF0043_GET_CONTRIBUTION_SALES_LIST
  const { data: mainData, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN] && !!searchCondition.verSeq,
  });

  // AS-IS .cs L285~289: MSG00283 — Version 미선택 차단
  const handleSearch = async () => {
    // AS-IS 의 txtVersion 미선택 (= versionNo 빈 값) 차단
    const ok = await validateVersionSelected(searchCondition.versionNo);
    if (!ok) return;
    setFilter();
    void refetch?.();
    // ⭐ master hook §2.4 — Search 시 admin 메타 refetch (admin 변경 즉시 반영)
    void fetchStaticColumns();
  };

  // AS-IS L466~470: VersionPopup 선택 → txtVersion.Text 채움
  const handleVersionSelect = (versionNo: string) => {
    setSearchCondition({ versionNo });
  };

  // AS-IS L481~482: ColumnSet popup OK → InitSpread() (= title sheet refetch via setFilter)
  const handleColumnApply = () => {
    setFilter();
  };

  // AS-IS Form_Load + Year 자동 선택 직후 자동 조회 trigger
  useEffect(() => {
    if (searchCondition.verSeq && !filters[SHEETS.MAIN]) {
      setFilter();
    }
  }, [searchCondition.verSeq]);

  const rows = (mainData?.p_cursor_main ?? []) as SalesViewRow[];

  // AS-IS .cs L333~336: MSG00307 — 조회 결과 알림
  useEffect(() => {
    if (filters[SHEETS.MAIN] && mainData && rows.length === 0) {
      void validateSearchResultEmpty(rows);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  // AS-IS DMF0043_Contribute_View 재검토 결과 (2026-06-11):
  //   1) InsertButton (L249) → InsertRow() L429~468 본문 전체 주석 + 주석 내 DefColumns 도
  //      DMF0044 컬럼 (CUTOFF_YYYYMMDD/ITEM_NAME/MEASURE/ITEM_ID) 복붙 후 미정리 — dead code
  //   2) SaveButton (L276) → SaveData() L413~426 본문 = ProgressForm Show/Close 만, DB 호출 0
  //   3) DeleteButton (L254~266) → 본문 전체 주석
  //   4) FindData (L392) → `siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true)` 명시적 전체 잠금
  //   5) analysis.md §13.2: SAVE/INSERT/DELETE SP 부재 (GET + TITLE 2종 만)
  //   → AS-IS 가 명백한 조회 전용 (Read-Only). Insert/Save/Delete 비활성화.
  //
  // Figma SVG (DMF0043_01.svg) + figma_link.md + AS-IS button:
  //   F5  = 조회 (handleSearch)
  //   F3  = Sort           (default — SubTitle hotkey)
  //   F4  = Filter         (default)
  //   F6  = Condition      (default — AS-IS UsrConditionPanel 존재)
  //   F10 = ResetCondition (default — AS-IS UsrConditionPanel 존재)
  //   Excel = default
  //   F7/F8/F9 (save/insert/delete) : AS-IS read-only 의도 → false
  //   기여율버전관리 : customButton (AS-IS btnCutOff_Click L444)
  //   컬럼표시설정 : customButton (AS-IS btnColumn_Click L473)
  // ⭐ UI 동적 속성관리 — Menu Button (master hook §3): admin USE_YN 즉시 반영
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? () => void handleSearch() : false,
    save: false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 사용자 요구 (2026-06-01):
  //   - "기여율 버전관리" → SubTitle 에서 제거, Form 의 아이콘 버튼으로 이동
  //   - "컬럼 표시 설정" → SubTitle 의 아이콘형 버튼으로 (Form ⊞ btnColumn 과 동일 아이콘)
  const customButtons = hasButton('COLUMN_SETUP')
    ? [{
        label: '⊞',
        title: '컬럼 표시 설정',
        action: () => setColumnSetPopupOpen(true),
      }]
    : [];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ContributeViewForm
          onSearch={() => void handleSearch()}
          onOpenVersionPopup={() => setVersionPopupOpen(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeView'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchCondition}
        customButtons={customButtons}
      />
      <div className={styles.gridContainer}>
        <ContributeViewGrid gridRef={gridRef} data={rows} staticColumns={staticColumns[SHEETS.MAIN]} />
      </div>
      <ContributeVersionModal
        open={versionPopupOpen}
        onClose={() => setVersionPopupOpen(false)}
        onSelect={handleVersionSelect}
      />
      <ColumnSettingModal
        open={columnSetPopupOpen}
        modalClose={() => setColumnSetPopupOpen(false)}
        menuId='DMF0043'
        sheetName='ContributeSalesList'
        columnType='C'
        divisionId='40'
        onSave={() => { handleColumnApply(); }}
      />
    </div>
  );
};
