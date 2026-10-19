import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useUIStore } from '@shared/stores';

import { InventoryTrendForm } from './components/InventoryTrendForm';
import { InventoryTrendGrid } from './components/InventoryTrendGrid';
import { MENU_ID, MSG, SHEETS } from './inventory-trend.constants';
import { useInventoryTrendStore } from './useInventoryTrendStore';

// AS-IS: SCP0101_InventoryTrend.cs — 조회 전용 Report. Find + Excel 실동작 / Save NO-OP / 전 컬럼 Lock.
//   EditButton(cs:222~246)은 MEMO 컬럼만 unlock 시도이나 MEMO 가 메타/SP 반환에 부재 → 실효 편집대상 0
//   (사실상 read-only). NSCM 공용 툴바에 Edit 버튼 자체가 없어(HotkeyConfig 에 edit 키 부재) 대응 버튼
//   없음 — 파리티: 편집 불가 동일(04_react-gap.md 확인필요: MEMO 편집 폐기 확정).
export const InventoryTrend = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [openItem, setOpenItem] = useState(false);

  const isOpenSearchArea = useInventoryTrendStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useInventoryTrendStore(state => state.setOpenSearchArea);
  const searchParams = useInventoryTrendStore(state => state.searchParams);
  const setSearchParams = useInventoryTrendStore(state => state.setSearchParams);
  const filters = useInventoryTrendStore(state => state.filters);
  const setFilters = useInventoryTrendStore(state => state.setFilters);
  const clearFilters = useInventoryTrendStore(state => state.clearFilters);
  const initialized = useInventoryTrendStore(state => state.initialized);
  const fetchStaticColumns = useInventoryTrendStore(state => state.fetchStaticColumns);
  const noDivisionAuth = useInventoryTrendStore(state => state.noDivisionAuth);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setProgress = useUIStore(state => state.setProgress);
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // 표시 행 = 조회결과. filters 가 비면(초기·미조회) 빈 배열(stale payload 방지, nscm-patterns §5-7).
  const rows = useMemo(
    () => (filters[SHEETS.MAIN] ? (data?.o_rc1 ?? []) : []),
    [data, filters]
  );

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // Excel — AS-IS ExportExcelData(cs:251~267) 실동작. AS-IS MSG00100 은 '저장 후 열기' 확인 다이얼로그로
  //   웹 다운로드에선 미재현. TO-BE 는 조회 0건 시 MSG00719('No data have been retrieved.') 가드만 둔다.
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.EXCEL_NO_DATA, 'No data have been retrieved.') });
      return;
    }
    if (gridRef.current) {
      void GridAction.excelDownload(gridRef.current, 'InventoryTrend', setProgress);
    }
  };

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + 컬럼 메타 1회 fetch.
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — 조회 전용 Report(01_layout §2):
  //   search = 실동작(hasButton('SEARCH') + Division 권한 게이트) / excel = 실동작(0건 가드) /
  //   save = AS-IS SaveButton NO-OP(cs:248~249 빈 본문. 노출 + 무동작, false·키 생략 금지 —
  //          생략 시 공용 SubTitle 기본 addRow/removeRow 되살아남, convert-core §3) /
  //   insert·delete·manual·upload = 미사용(리포트).
  //   R1(cs:153~154): 권한 Division 0건이면 조회영역 전체 Enabled=false — 조회 액션도 차단.
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
      <InventoryTrendForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='InventoryTrend'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <InventoryTrendGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        month={searchParams.month}
      />
      {/* Item 검색 — 공용 ItemByDivisionModal(SCM0002). 빈 반환 시 기존값 유지(AS-IS cs:983~988). */}
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
