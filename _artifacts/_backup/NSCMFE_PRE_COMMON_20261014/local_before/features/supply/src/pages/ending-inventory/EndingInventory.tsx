import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useUIStore } from '@shared/stores';

import { EndingInventoryForm } from './components/EndingInventoryForm';
import { EndingInventoryGrid } from './components/EndingInventoryGrid';
import { MENU_ID, MSG, SEARCH_MODE, SHEETS } from './ending-inventory.constants';
import { useEndingInventoryStore } from './useEndingInventoryStore';

// AS-IS: SCP0085_EndingInventory.cs — 조회 전용 Report. Find + Excel 실동작 / Edit·Save NO-OP.
export const EndingInventory = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [openItem, setOpenItem] = useState(false);

  const isOpenSearchArea = useEndingInventoryStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useEndingInventoryStore(state => state.setOpenSearchArea);
  const searchParams = useEndingInventoryStore(state => state.searchParams);
  const setSearchParams = useEndingInventoryStore(state => state.setSearchParams);
  const filters = useEndingInventoryStore(state => state.filters);
  const setFilters = useEndingInventoryStore(state => state.setFilters);
  const clearFilters = useEndingInventoryStore(state => state.clearFilters);
  const initialized = useEndingInventoryStore(state => state.initialized);
  const fetchStaticColumns = useEndingInventoryStore(state => state.fetchStaticColumns);
  const isHeaderViewDetail = useEndingInventoryStore(state => state.isHeaderViewDetail);
  const toggleHeaderViewDetail = useEndingInventoryStore(state => state.toggleHeaderViewDetail);
  const noDivisionAuth = useEndingInventoryStore(state => state.noDivisionAuth);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setProgress = useUIStore(state => state.setProgress);
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 조회 SP 이중화 — 모드별 시트로 갈라 각자 enabled 게이트(다른 SP·기간 파라미터키, design 02 §2.2).
  const { data: monthData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { data: dailyData } = useTabProcQuery<MENU_ID, SHEETS.DAILY>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAILY,
    tabId,
    filters: filters[SHEETS.DAILY],
    enabled: !!filters[SHEETS.DAILY],
  });

  // 표시 행 = 현재 모드의 조회결과. filters[mode] 가 비면(모드 전환 직후·초기) 빈 배열 —
  //   React Query 는 enabled=false 여도 직전 data 를 캐시로 들고 있어, filters 유무로 게이트하지
  //   않으면 모드 재전환 시 이전 결과가 stale 로 새어나온다(AS-IS ClearDataSource 재현, I4).
  const rows = useMemo(() => {
    if (searchParams.mode === SEARCH_MODE.DAILY) {
      return filters[SHEETS.DAILY] ? (dailyData?.o_rc1 ?? []) : [];
    }
    return filters[SHEETS.MAIN] ? (monthData?.o_rc1 ?? []) : [];
  }, [searchParams.mode, monthData, dailyData, filters]);

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // Excel — AS-IS ExportExcelData(cs:666~683) 실동작. 조회 0건 시 MSG00100(→TO-BE MSG00719) 안내(design 03 §5-8).
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.EXCEL_NO_DATA, 'No data have been retrieved.') });
      return;
    }
    if (gridRef.current) {
      void GridAction.excelDownload(gridRef.current, 'EndingInventory', setProgress);
    }
  };

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + 컬럼 메타 1회 fetch.
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — 조회 전용 Report(01_layout §2 R4~R7):
  //   search = 실동작(hasButton('SEARCH') 게이트) / save = AS-IS SaveButton NO-OP(노출 + 무동작,
  //   false·키 생략 금지) / excel = 실동작(0건 가드) / insert·delete = 미노출(report — 기본 addRow/
  //   removeRow 핸들러 차단) / manual·upload = 미사용.
  //   AS-IS EditButton(NO-OP)은 NSCM 공용 툴바에 Edit 버튼 자체가 없어 대응 버튼 없음(파리티: 편집 불가 동일).
  //   R1(cs:188): MyDivision 0건이면 조회영역 전체 Enabled=false — 입력 disable(Form)에 더해 조회 액션도 차단.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    save: () => undefined,
    excel: handleExcel,
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
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <EndingInventoryForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='EndingInventory'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <EndingInventoryGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        mode={searchParams.mode}
        divisionId={searchParams.divisionId}
        isHeaderViewDetail={isHeaderViewDetail}
        onToggleDetail={toggleHeaderViewDetail}
      />
      {/* Model 검색 — 공용 ItemByDivisionModal(SCM0002). 빈 반환 시 기존값 유지(AS-IS cs:444). */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => {
          if (itemIds) setSearchParams({ itemId: itemIds });
        }}
        preSearchParams={{ divisionId: searchParams.divisionId, itemId: searchParams.itemId }}
        callFromCell={false}
      />
    </>
  );
};
