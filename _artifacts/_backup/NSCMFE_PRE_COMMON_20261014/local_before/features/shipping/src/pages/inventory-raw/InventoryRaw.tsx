import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { InventoryRawForm } from './components/InventoryRawForm';
import { InventoryRawGrid } from './components/InventoryRawGrid';
import { LBL, MSG, SHEETS } from './inventory-raw.constants';
import { MENU_ID } from './inventory-raw.constants';
import type { InventoryRawRow } from './inventory-raw.types';
import { useInventoryRawStore } from './useInventoryRawStore';

// AS-IS GSCM.SSP.Plan.UIL SSP0017_InventoryRaw — 단일 FpSpread(spdMain) 조회 전용 화면.
//   설계: .atlas/gscm-design/SSP0017/design/00~03. 상세 매핑: __asis-mapping__.md.
//   핵심 특성: 전 컬럼 조회직후 편집잠금(LockColumn, design 03 §3#8) — 인라인 편집 UI 없음.
//   Insert/Delete/Edit/Save 4버튼은 AS-IS 자체가 NO-OP(design 01 §2#2~#5) — 노출 유지 + 클릭 무동작.
//   SP `SSP.SSP0017_GET_INVENTORY_RAW` 는 MISSING(convert-sp 후속) — 이 activity 는 FE 골격·배선까지.
export const InventoryRaw = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useInventoryRawStore(s => s.searchParams);
  const setSearchParams = useInventoryRawStore(s => s.setSearchParams);
  const filters = useInventoryRawStore(s => s.filters);
  const setFilters = useInventoryRawStore(s => s.setFilters);
  const clearFilters = useInventoryRawStore(s => s.clearFilters);
  const isOpenSearchArea = useInventoryRawStore(s => s.isOpenSearchArea);
  const setOpenSearchArea = useInventoryRawStore(s => s.setOpenSearchArea);
  const staticColumns = useInventoryRawStore(s => s.staticColumns);
  const fetchStaticColumns = useInventoryRawStore(s => s.fetchStaticColumns);
  const openItemModal = useInventoryRawStore(s => s.openItemModal);
  const setOpenItemModal = useInventoryRawStore(s => s.setOpenItemModal);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  const rows = useMemo<InventoryRawRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(nscm-patterns §5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // "Plan-date*" 필수(design 02 §4, DataUtil.checkRequiredOfSearch cs:377) — 공백 시 조회 차단.
  const handleSearch = () => {
    if (!sc.planStartYyyymmdd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_PLAN_DATE, {
          defaultValue: '_The {0} value is required.',
          0: 'Plan Date',
        }),
      });
      return;
    }
    setFilters();
  };

  // Insert/Delete/Save = AS-IS override NO-OP(design 01 §2#2~#5, cs:268-341) — 버튼 노출 유지 +
  //   명시적 무동작 함수로 배선(키 생략=공용 addRow/removeRow 활성화, false=버튼 숨김 둘 다 금지,
  //   CLAUDE.md §2 체크4 / convert-core §2.4). Edit 은 TO-BE Hotkeys 자체에 대응 키가 없다
  //   (F2 는 `_F2_Unused` 로 예약 — asis_to_tobe.md §11 "AS-IS UI 모드토글(EditButton 등) 미이식
  //   결정"과 동일 처리, 이 화면 그리드도 편집모드 전환 없이 처음부터 전 컬럼 잠금이라 정합).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: () => undefined,
    delete: () => undefined,
    save: () => undefined,
    manual: false,
    upload: false,
  };

  // btnMeasure(design 03 §2/§4) — AS-IS 는 이 버튼을 누르면 자기 자신이 아니라 SSP0001의
  //   Measure 설정 팝업을 여는 결함(프로그램 ID 리터럴 "SSP0001")이 있다. 그대로 재현하면 이
  //   화면에서 다른 화면의 컬럼/measure 메타를 실수로 바꾸는 위험이 있어, 사용자 결정 전까지는
  //   버튼만 노출하고 클릭 시 미결정 상태임을 알린다(임의로 열거나 숨기지 않음, anti-simplification §1).
  const customButtons = [
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: () =>
        void setAlert({
          type: 'alert',
          content:
            'AS-IS Measure 설정 버튼은 SSP0001 화면 메타를 여는 결함이 있어 재현 여부가 확정되지 않았습니다. (design/03_grid-columns.md §2 참조)',
        }),
      iconComponent: <IcMeasureSelect />,
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
      {isOpenSearchArea && (
        <InventoryRawForm onSearch={handleSearch} onItemSearch={() => setOpenItemModal(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='InventoryRaw'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
        searchParam={sc}
      />
      <InventoryRawGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        staticColumns={staticColumns}
      />

      {/* Model 검색 — 공용 ItemByDivisionModal(AS-IS SCM0002_ItembyDivisionPopup, design 02 §4.6). */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={itemId => setSearchParams({ itemId })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
