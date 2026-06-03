import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ColumnSettingModal } from '../../components';
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

  const setAlert = useMessageStore(s => s.setAlert);

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
    refetch?.();
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

  // As-Is .cs L249 InsertButton → InsertRow() 본문 있음 — 화면 의도는 조회 전용 (Figma DMF0043_01) 이지만
  // 룰 25 §1.5.1: As-Is 본문 있음 → function (TODO placeholder). silent fail 방지.
  const handleInsert = () => {
    void setAlert({
      type: 'alert',
      content:
        '미구현 — As-Is DMF0043_Contribute_View.cs L249 InsertRow() 참조. 화면 의도(조회 전용) 와 As-Is 본문 (Insert 가능) 충돌 — 운영 결정 필요.',
    });
  };

  // As-Is .cs L276 SaveButton → SaveData() 본문 있음 — Insert 와 동일 정책
  const handleSave = () => {
    void setAlert({
      type: 'alert',
      content:
        '미구현 — As-Is DMF0043_Contribute_View.cs L276 SaveData() 참조. 화면 의도(조회 전용) 와 As-Is 본문 (Save 가능) 충돌 — 운영 결정 필요.',
    });
  };

  // Figma SVG (DMF0043_01.svg + DMF0043_01_Table.svg) + figma_link.md + AS-IS button:
  //   F5  = 조회 (handleSearch)
  //   F3  = Sort           (default — SubTitle hotkey)
  //   F4  = Filter         (default)
  //   F6  = Condition      (default — As-Is UsrConditionPanel 존재)
  //   F10 = ResetCondition (default — As-Is UsrConditionPanel 존재)
  //   Excel = default
  //   F7  (save) : As-Is .cs L276 SaveData() 본문 있음 → placeholder (조회 전용 의도 vs As-Is 본문 충돌)
  //   F8 (insert) : As-Is .cs L249 InsertRow() 본문 있음 → placeholder
  //   F9 (delete) : As-Is .cs L254 본문 주석만 (빈) → false
  //   기여율버전관리 : customButton (AS-IS btnCutOff_Click L444)
  //   컬럼표시설정 : customButton (AS-IS btnColumn_Click L473)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: handleSave,
    insert: handleInsert,
    delete: false,
    manual: false,
    upload: false,
  };

  // 사용자 요구 (2026-06-01):
  //   - "기여율 버전관리" → SubTitle 에서 제거, Form 의 아이콘 버튼으로 이동
  //   - "컬럼 표시 설정" → SubTitle 의 아이콘형 버튼으로 (Form ⊞ btnColumn 과 동일 아이콘)
  const customButtons = [
    {
      label: '⊞',
      title: '컬럼 표시 설정',
      action: () => setColumnSetPopupOpen(true),
    },
  ];

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
        <ContributeViewGrid gridRef={gridRef} data={rows} />
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
