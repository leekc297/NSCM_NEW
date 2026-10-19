import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useUIStore } from '@shared/stores';

import { ValidationShipmentResultForm } from './components/ValidationShipmentResultForm';
import { ValidationShipmentResultGrid } from './components/ValidationShipmentResultGrid';
import { useValidationShipmentResultStore } from './useValidationShipmentResultStore';
import { MENU_ID, MSG, SHEETS } from './validation-shipment-result.constants';
import type { ValidationShipmentResultRow } from './validation-shipment-result.types';

// AS-IS: SCM0014_ValidationShipmentResult.cs — 읽기전용 조회(Intransit Inventory).
//   Find(Search) + Excel 실동작 / Edit=읽기전용 안내(미노출, R2 옵션 b) / 저장·삽입·삭제 없음.
export const ValidationShipmentResult = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ValidationShipmentResultRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);

  const isOpenSearchArea = useValidationShipmentResultStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useValidationShipmentResultStore(state => state.setOpenSearchArea);
  const searchParams = useValidationShipmentResultStore(state => state.searchParams);
  const setSearchParams = useValidationShipmentResultStore(state => state.setSearchParams);
  const filters = useValidationShipmentResultStore(state => state.filters);
  const setFilters = useValidationShipmentResultStore(state => state.setFilters);
  const clearFilters = useValidationShipmentResultStore(state => state.clearFilters);
  const initialized = useValidationShipmentResultStore(state => state.initialized);
  const fetchStaticColumns = useValidationShipmentResultStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = useValidationShipmentResultStore(
    state => state.restoreSearchConditions
  );
  const noDivisionAuth = useValidationShipmentResultStore(state => state.noDivisionAuth);

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

  // filters[MAIN] 유무로 게이트 — 조회 전(초기·division 변경 후)에는 캐시 stale 이 새어나오지 않도록 빈 배열.
  const rows = useMemo(
    () => (filters[SHEETS.MAIN] ? (data?.o_rc1 ?? []) : []),
    [data, filters]
  );

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // Excel — 클라이언트측 다운로드(GridAction.excelDownload). 조회 0건 시 안내(자매 SCP0085 파리티).
  //   AS-IS BaseForm 표준 Excel export 대응 — 권한 메타 없이 상시 제공(SCP0085 동일).
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EXCEL_NO_DATA, 'No data have been retrieved.'),
      });
      return;
    }
    if (gridRef.current) {
      void GridAction.excelDownload(gridRef.current, 'ValidationShipmentResult', setProgress);
    }
  };

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + 컬럼 메타 1회 fetch +
  //   F6 저장 조회조건 복원(저장분 있으면 적용, 없으면 기본값 유지 — 형제 SCP0039 파리티, basic-check #3).
  //   새로고침/재진입 시 createPersistedStoreWithTab 이 새 store(가드 false) → 재복원.
  useEffect(() => {
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — 읽기전용 조회(design 01 §2):
  //   search = 실동작(hasButton('SEARCH') + R1 무권한 차단) / excel = 실동작(0건 가드, 권한 무관 클라 export)
  //   edit  = 미노출(R2 옵션 b — 읽기전용 화면, edit 키 생략 안전: 공용 SubTitle 에 edit 파괴형 기본핸들러 없음)
  //   insert·delete·save = 미노출(false — AS-IS 미존재, 기본 addRow/removeRow 핸들러 차단) / manual·upload = 미사용.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    excel: handleExcel,
    insert: false,
    delete: false,
    save: false,
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
      <ValidationShipmentResultForm
        onSearch={handleSearch}
        onProjectSearch={() => setOpenProject(true)}
        onItemSearch={() => setOpenItem(true)}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ValidationShipmentResult'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <ValidationShipmentResultGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
      {/* Project 검색 — 공용 ProjectByDivisionModal(SCM0002). division 컨텍스트, 콤마 다중 반환(AS-IS cs:396~409). */}
      <ProjectByDivisionModal
        open={openProject}
        modalClose={() => setOpenProject(false)}
        setSelectedValue={projects => {
          if (projects) setSearchParams({ projectCode: projects });
        }}
        preSearchParams={{ divisionId: searchParams.divisionId, projectCode: searchParams.projectCode }}
        callFromCell={false}
      />
      {/* Model/Nickname 검색 — 공용 MaterialByDivisionModal(COM0013). division 컨텍스트, 콤마 다중.
          scpModuleType=호출 화면 ID(SCM0014) — SP 의 Operation Group 분기 기준. */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          itemId: searchParams.itemId,
          scpModuleType: MENU_ID,
        }}
      />
    </>
  );
};
