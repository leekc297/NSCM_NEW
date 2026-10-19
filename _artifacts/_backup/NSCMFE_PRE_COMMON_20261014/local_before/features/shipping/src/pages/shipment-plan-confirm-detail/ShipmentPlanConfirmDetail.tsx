import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ColumnSettingModal, ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcGridColumnSetup } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { BodDetailModal } from './components/modals/BodDetailModal';
import { ShipmentRequestDetailModal } from './components/modals/ShipmentRequestDetailModal';
import { ShipmentPlanConfirmDetailForm } from './components/ShipmentPlanConfirmDetailForm';
import { ShipmentPlanConfirmDetailGrid } from './components/ShipmentPlanConfirmDetailGrid';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
} from './shipment-plan-confirm-detail.constants';
import type { DrilldownParams, MainRow } from './shipment-plan-confirm-detail.types';
import styles from './ShipmentPlanConfirmDetail.module.scss';
import { useShipmentPlanConfirmDetailStore } from './useShipmentPlanConfirmDetailStore';

// AS-IS GSCM.SSP.Plan.UIL SSP0012_ShipmentPlanConfirmDetail — 출하계획 확정 상세(읽기전용 조회 + 47컬럼 상세).
//   설계: .atlas/gscm-design/SSP0012/design/00~03. 매핑: __asis-mapping__.md.
//   툴바 5버튼: Find=실동작 / Insert·Delete·Save=NO-OP / Edit=MSG00109 안내. 편집·저장·동적 PIVOT 없음.
//   주의: PKG_SSP0012 미배포(convert-sp 후속) — 실 조회/Period 서버기본값 런타임 검증은 SP 배포 후.
export const ShipmentPlanConfirmDetail = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useShipmentPlanConfirmDetailStore(s => s.searchCondition);
  const setSearchCondition = useShipmentPlanConfirmDetailStore(s => s.setSearchCondition);
  const filters = useShipmentPlanConfirmDetailStore(s => s.filters);
  const setFilter = useShipmentPlanConfirmDetailStore(s => s.setFilter);
  const clearFilters = useShipmentPlanConfirmDetailStore(s => s.clearFilters);
  const initPeriodDefault = useShipmentPlanConfirmDetailStore(s => s.initPeriodDefault);
  const openSearchArea = useShipmentPlanConfirmDetailStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanConfirmDetailStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanConfirmDetailStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanConfirmDetailStore(s => s.fetchStaticColumns);
  const initialized = useShipmentPlanConfirmDetailStore(s => s.initialized);
  const hasDivisionAuth = useShipmentPlanConfirmDetailStore(s => s.hasDivisionAuth);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [openItem, setOpenItem] = useState(false);
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [drilldown, setDrilldown] = useState<DrilldownParams | null>(null);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + Period 기본값 + 컬럼메타 1회 fetch.
    clearFilters();
    initPeriodDefault();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // L6 Find — 필수(Period) 검증 후 조회. refetch 직접호출 금지(setFilter 참조 교체로 자동발사).
  const handleSearch = () => {
    if (!hasDivisionAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_AUTHORITY, '__No authority assigned.'),
      });
      return;
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_PERIOD, '__Please enter the required fields.'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // L5 Edit — 읽기전용 안내(MSG00109). 편집모드 진입 없음. NSCM SubTitle 에 Edit hotkey 가 없어 customButton 으로.
  const handleEdit = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.READ_ONLY, '__Read-only.'),
    });
  };

  // L2~L4 Insert/Delete/Save — NO-OP(버튼 노출 유지 + 명시적 무동작). false/키 생략 금지(기본 addRow/removeRow 살아남 방지).
  //   admin 권한(hasButton)으로 노출을 제어하되, 노출 시에는 무동작 함수를 배선한다(design 01 §2 L2~L4).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    save: hasButton('SAVE') ? () => undefined : false,
    manual: false,
    upload: false,
  };

  const customButtons = [
    // Edit — AS-IS 툴바 Edit(읽기전용 안내). admin EDIT 권한 있을 때만 노출.
    ...(hasButton('EDIT')
      ? [
          {
            label: t(LBL.EDIT, '_Edit'),
            title: t(LBL.EDIT, '_Edit'),
            action: handleEdit,
          },
        ]
      : []),
    // Column Setting — btnColumn(AS-IS 조회영역) 을 SubTitle 아이콘 버튼으로 재배치(#120). 공용 컬럼설정 모달.
    {
      label: t(LBL.COLUMN_SETTING, '_Column Setting'),
      title: t(LBL.COLUMN_SETTING, '_Column Setting'),
      action: () => setOpenColumnSetting(true),
      iconComponent: <IcGridColumnSetup />,
      buttonLabel: '',
    },
  ];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanConfirmDetailForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentPlanConfirmDetail'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <div className={styles.grid}>
        <ShipmentPlanConfirmDetailGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onDrilldown={setDrilldown}
        />
      </div>

      {/* Model 검색 — SCM0002_ItembyDivisionPopup(ItemByDivisionModal). division/model 사전필터. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemId => setSearchCondition({ itemId: String(itemId) })}
        preSearchParams={{ divisionId: sc.divisionIds.join(','), itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* 컬럼설정(L7) — 공용 모달. OK 시 staticColumns refetch → 헤더 재구성(design 01 §2 L7). */}
      <ColumnSettingModal
        open={openColumnSetting}
        modalClose={() => setOpenColumnSetting(false)}
        menuId={MENU_ID}
        sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
        columnType={ADMIN_SHEET_NAME[SHEETS.MAIN]}
        onSave={() => {
          void fetchStaticColumns();
          setOpenColumnSetting(false);
        }}
      />

      {/* 드릴다운(W9/W10) — INCOTERMS→BOD 상세 / CHANGE_REQ_NO→변경요청 상세. 상세 데이터는 convert-sp 후속. */}
      <BodDetailModal
        open={drilldown?.kind === 'BOD'}
        modalClose={() => setDrilldown(null)}
        divisionId={drilldown?.divisionId}
        bodId={drilldown?.bodId}
      />
      <ShipmentRequestDetailModal
        open={drilldown?.kind === 'REQUEST'}
        modalClose={() => setDrilldown(null)}
        changeReqNo={drilldown?.changeReqNo}
      />
    </>
  );
};
