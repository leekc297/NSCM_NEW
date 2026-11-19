import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { ColumnLayoutModal, MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Checkbox } from '@shared/lges';
import { useMessageStore, useUIStore } from '@shared/stores';

import { InventoryTrendForm } from './components/InventoryTrendForm';
import { InventoryTrendGrid } from './components/InventoryTrendGrid';
import {
  ADMIN_SHEET_NAME,
  DETAIL_LABEL,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './inventory-trend.constants';
import { useInventoryTrendStore } from './useInventoryTrendStore';

// AS-IS: SCP0101_InventoryTrend.cs — 조회 전용 Report. Find + Excel 실동작 / Save NO-OP / 전 컬럼 Lock.
//   EditButton(cs:222~246)은 MEMO 컬럼만 unlock 시도이나 MEMO 가 메타/SP 반환에 부재 → 실효 편집대상 0
//   (사실상 read-only). NSCM 공용 툴바에 Edit 버튼 자체가 없어(HotkeyConfig 에 edit 키 부재) 대응 버튼
//   없음 — 파리티: 편집 불가 동일(04_react-gap.md 확인필요: MEMO 편집 폐기 확정).
export const InventoryTrend = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [openItem, setOpenItem] = useState(false);
  // 컬럼 설정 팝업(AS-IS btnColumn→SCM0002_TitleSetForm_Popup, cs:957~968) open 상태.
  const [columnSettingsOpen, setColumnSettingsOpen] = useState(false);

  const isOpenSearchArea = useInventoryTrendStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useInventoryTrendStore(state => state.setOpenSearchArea);
  const searchParams = useInventoryTrendStore(state => state.searchParams);
  const setSearchParams = useInventoryTrendStore(state => state.setSearchParams);
  const filters = useInventoryTrendStore(state => state.filters);
  const setFilters = useInventoryTrendStore(state => state.setFilters);
  const clearFilters = useInventoryTrendStore(state => state.clearFilters);
  const initialized = useInventoryTrendStore(state => state.initialized);
  const fetchStaticColumns = useInventoryTrendStore(state => state.fetchStaticColumns);
  const staticColumns = useInventoryTrendStore(state => state.staticColumns);
  const restoreSearchConditions = useInventoryTrendStore(state => state.restoreSearchConditions);
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

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + F6 저장조건 복원(1회) + 컬럼 메타 1회 fetch.
  useEffect(() => {
    clearFilters();
    void restoreSearchConditions();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — 조회 전용 Report(01_layout §2):
  //   search = 실동작(hasButton('SEARCH') + Division 권한 게이트) / excel = 실동작(0건 가드) /
  //   save = 숨김(false). AS-IS SaveButton 은 빈 본문 NO-OP(cs:248~249)라 저장 동작이 없고, 저장 SP 도
  //          없는 조회 전용 Report 이므로 버튼을 노출하지 않는다(사용자 지시 2026-10-19).
  //          동일하게 AS-IS SaveButton 이 빈 몸통인 DMF0040(mkt-fcst-comparison)·저장 SP 없는 capa-* 선례와 일치.
  //          주의: insert/delete 와 달리 save 는 공용 SubTitle 기본값이 no-op(F7=()=>undefined)이라 false 로 둬도
  //          부작용(기본 행조작 복귀) 없음 — 숨김만 적용된다.
  //   insert·delete·manual·upload = 미사용(리포트).
  //   R1(cs:153~154): 권한 Division 0건이면 조회영역 전체 Enabled=false — 조회 액션도 차단.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    save: false,
    excel: handleExcel,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 컬럼 설정 버튼 — AS-IS btnColumn(SCM0002_TitleSetForm_Popup) 대응. SubTitle 표준 custom icon 버튼(Save 좌측,
  //   SCP0100 global-psi-report 선례 동형). 클릭 시 공용 ColumnLayoutModal(컬럼 표시/순서/폭·색 개인화) open.
  const customButtons = [
    {
      label: t(LBL.COLUMN, 'Column Setting'),
      action: () => setColumnSettingsOpen(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

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
        customButtons={customButtons}
        // Detail(상세 22컬럼 토글) — 조회조건 폼에서 그리드 건수 툴바로 이동(사용자 지시 2026-11-16).
        //   체크박스(좌) + 'Detail'(우): lges Checkbox labelText 가 박스 뒤 라벨. SCP0085 Devaluation Age 동형.
        afterCount={
          <Checkbox
            labelText={DETAIL_LABEL}
            checked={searchParams.detail}
            disabled={noDivisionAuth}
            onChange={checked => setSearchParams({ detail: checked })}
          />
        }
      />
      <InventoryTrendGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        month={searchParams.month}
        detail={searchParams.detail}
      />
      {/* Material 검색 — 공용 MaterialByDivisionModal(메1, COM0013). division 컨텍스트, 콤마 다중.
          scpModuleType=호출 화면 ID(SCP0101) — SP 의 Operation Group 분기 기준.
          multiDivision: Division 조회조건이 다중선택('81,40' 콤마결합)이라 팝업도 멀티 컨트롤로 표시(disabled 미러).
            끄면 단일 드롭다운에 콤마문자열이 매칭 안 돼 라벨이 비어 보임.
          빈 반환 시 기존값 유지(AS-IS cs:983~988). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        multiDivision
        setSelectedValue={itemIds => {
          if (itemIds) setSearchParams({ itemId: itemIds });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          itemId: searchParams.itemId,
          scpModuleType: MENU_ID,
        }}
      />
      {/* 컬럼 설정 팝업 — AS-IS btnColumn→SCM0002_TitleSetForm_Popup(cs:957~968) 대응. 공용 ColumnLayoutModal
          (표시/순서 + Width/Cell·Text Color) + titleSet 'C' 영구 저장. read-only 리포트라 저장 후 메타 refetch 로만
          반영(SCP0100 global-psi-report 동형). divisionId 는 ALL→'' 정규화(컬럼메타는 division 무관). */}
      <ColumnLayoutModal
        open={columnSettingsOpen}
        modalClose={() => setColumnSettingsOpen(false)}
        menuId={MENU_ID}
        sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
        columnType={TITLESET_COLUMN_TYPE}
        divisionId={searchParams.divisionId === 'ALL' ? '' : searchParams.divisionId}
        // 저장된 개인화가 없으면 모달 beRows 0건 → admin 컬럼메타(staticColumns)를 기본 리스트로 넘긴다(SCP0100 동형).
        fallbackColumns={staticColumns
          .filter(column => column.visible !== false)
          .map(column => ({
            key: column.colNm,
            header: column.colLblNm ?? column.colNm,
            width: column.colWth,
          }))}
        title={t(LBL.COLUMN, 'Column Setting')}
        onSave={settings => {
          // 표시 컬럼만(USER_FLAG='Y') sortOrderNo 1..n 으로 저장 — 행 존재 = 표시(titleSetApi 계약).
          const visible = settings.filter(s => s.USER_FLAG === 'Y');
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN],
            columnType: TITLESET_COLUMN_TYPE,
            rows: visible.map((s, i) => ({
              name: s.COLUMN_NAME,
              sortOrderNo: i + 1,
              colWidth: s.COL_WIDTH,
              cellColor: s.CELL_COLOR,
              textColor: s.TEXT_COLOR,
            })),
          }).then(ok => {
            if (!ok) {
              void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
              return;
            }
            // 팝업 titleSet 조회 캐시 무효화(전역 staleTime=Infinity) + 컬럼 메타 refetch 로 그리드 반영.
            void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            void fetchStaticColumns();
          });
        }}
      />
    </>
  );
};
