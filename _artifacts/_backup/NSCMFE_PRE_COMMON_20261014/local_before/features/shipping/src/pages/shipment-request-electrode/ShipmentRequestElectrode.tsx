import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { ShipmentRequestElectrodeDetailGrid } from './components/ShipmentRequestElectrodeDetailGrid';
import { ShipmentRequestElectrodeForm } from './components/ShipmentRequestElectrodeForm';
import { ShipmentRequestElectrodeMainGrid } from './components/ShipmentRequestElectrodeMainGrid';
import { ShipmentRequestElectrodeStockGrid } from './components/ShipmentRequestElectrodeStockGrid';
import { INSERT_LOCK_COLUMNS, MENU_ID, SHEETS } from './shipment-request-electrode.constants';
import type {
  RequestDetailRow,
  ShipmentPsiRow,
  StockDetailRow,
} from './shipment-request-electrode.types';
import { useShipmentRequestElectrodeStore } from './useShipmentRequestElectrodeStore';

// SSP0022 Shipment Request(Electrode) — AS-IS SSP0022_ShipmentRequestElectrode 1:1 골격 전환.
//   조회 = PKG_SSP0022.P_SSP0022_GET_SHIPMENT_PSI / GET_REQUEST_DETAIL / GET_STOCK_DETAIL.
//   저장 = PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST(spdMain/spdDetail 공용, 컨텍스트로 분기).
//
// 정직 보고(convert-core §4.3): PKG_SSP0022/PKG_DM0003/PKG_SSP0002 전부 TO-BE 미배포(all_objects
// 0건, 2026-09-26 ora.py 실측) — 이 화면의 조회/저장/Edit 권한체크/Bucket 콤보는 FE 배선만
// 완비되고 런타임 실행체인은 미완이다(convert-sp 후속). 아래 handleSave/handleEdit 등은 SP 응답
// 형상을 검증하지 못한 상태로 design 02/03 문서의 소비부 역산치를 그대로 반영했다.
export const ShipmentRequestElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRefMain = useRef<FlexGrid<ShipmentPsiRow>>();
  const gridFilterRefMain = useRef<FlexGridFilter>();
  const gridRefRequest = useRef<FlexGrid<RequestDetailRow>>();
  const gridFilterRefRequest = useRef<FlexGridFilter>();
  const editTrackerRefRequest = useRef<EditTracker<RequestDetailRow>>();
  const gridRefStock = useRef<FlexGrid<StockDetailRow>>();
  const gridFilterRefStock = useRef<FlexGridFilter>();

  const searchParams = useShipmentRequestElectrodeStore(state => state.searchParams);
  const filters = useShipmentRequestElectrodeStore(state => state.filters);
  const requestDetailFilters = useShipmentRequestElectrodeStore(state => state.requestDetailFilters);
  const stockDetailFilters = useShipmentRequestElectrodeStore(state => state.stockDetailFilters);
  const isOpenSearchArea = useShipmentRequestElectrodeStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentRequestElectrodeStore(state => state.setOpenSearchArea);
  const setFilters = useShipmentRequestElectrodeStore(state => state.setFilters);
  const clearFilters = useShipmentRequestElectrodeStore(state => state.clearFilters);
  const bohMode = useShipmentRequestElectrodeStore(state => state.bohMode);
  const staticColumns = useShipmentRequestElectrodeStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentRequestElectrodeStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestElectrodeStore(state => state.fetchStaticMeasures);
  const activeDetailTab = useShipmentRequestElectrodeStore(state => state.activeDetailTab);
  const setActiveDetailTab = useShipmentRequestElectrodeStore(state => state.setActiveDetailTab);
  const activeGrid = useShipmentRequestElectrodeStore(state => state.activeGrid);
  const setActiveGrid = useShipmentRequestElectrodeStore(state => state.setActiveGrid);

  // Division/Company 변경 = 그리드 초기화 의무(nscm-patterns.md §5-5).
  const prevKeyRef = useRef(`${searchParams.divisionId}:${searchParams.companyId}`);
  useEffect(() => {
    const key = `${searchParams.divisionId}:${searchParams.companyId}`;
    if (prevKeyRef.current === key) return;
    prevKeyRef.current = key;
    editTrackerRefRequest.current?.clearChanges();
    clearFilters();
  }, [searchParams.divisionId, searchParams.companyId, clearFilters]);

  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.divisionId]);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  const { data: requestDetailData, refetch: refetchRequestDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.REQUEST_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL,
    tabId,
    filters: requestDetailFilters,
    enabled: requestDetailFilters !== undefined,
  });
  const { data: stockDetailData } = useTabProcQuery<MENU_ID, SHEETS.STOCK_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_DETAIL,
    tabId,
    filters: stockDetailFilters,
    enabled: stockDetailFilters !== undefined,
  });

  const mainRows = useMemo(() => (mainData as { o_rc1?: ShipmentPsiRow[] })?.o_rc1 ?? [], [mainData]);
  const requestDetailRows = useMemo(
    () => (requestDetailData as { o_rc1?: RequestDetailRow[] })?.o_rc1 ?? [],
    [requestDetailData]
  );
  const stockDetailRows = useMemo(
    () => (stockDetailData as { o_rc1?: StockDetailRow[] })?.o_rc1 ?? [],
    [stockDetailData]
  );

  // R1: Find 버튼 — 가드 없이 항상 전체 재조회(design 01 R1).
  const handleSearch = () => {
    const isSame = setFilters();
    if (isSame) {
      void refetchMain();
      void refetchRequestDetail();
    }
  };

  // R6: Insert — siDetail!=null && Lock아님 && ActiveSheet==요청상세 3중 가드, 미충족 시 조용히 무시
  //   (design 01 R6/03 §3 규칙#8). FROM_SITE/TO_SITE 콤보 런타임 부여는 후속(04 미완 — 셀 콤보 동적 주입 미배선).
  const handleInsert = () => {
    if (activeDetailTab !== 'requestDetail') return;
    const grid = gridRefRequest.current;
    if (!grid) return;
    // TODO(04 미완): GridAction.addRow 배선 — DIVISION_ID 자동세팅 + 5컬럼 lock(INSERT_LOCK_COLUMNS)
    //   + FROM_SITE/TO_SITE 콤보 주입은 SP 응답 형상 확인 후 완성한다. 조용한 무시 원칙만 우선 반영.
    void INSERT_LOCK_COLUMNS;
  };

  // R7: Delete — 완전 NO-OP(명시적 무동작 함수, false/키생략 금지, design 01 R7).
  const handleDelete = () => undefined;

  // R8: Save — 활성그리드 라우팅(spdMain=SaveData 확인창없음 / spdDetail=SaveData_Detail Yes/No 확인창, design 01 R8/R11/R12).
  //   SP 미배포로 실제 저장은 실행 불가 — 배선 형태만 완비(호출부는 apiClient.post 직접 조립 예정, 04 미완).
  const handleSave = async () => {
    if (activeGrid === 'spdDetail') {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00012', '_Save the changes?'),
      });
      if (!confirmed) return;
    }
    // TODO(04 미완): PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST 배포 후 apiClient.post 직접 호출로
    //   완성(결과코드 S/N/X/else 4-way 분기, design 01 R11/R12). 현재는 SP 부재로 호출부만 자리 표시.
    await setAlert({
      type: 'alert',
      content: 'SP not deployed yet — save execution deferred to convert-sp.',
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: () => handleSearch(),
    insert: hasButton('INSERT') ? handleInsert : (() => undefined),
    delete: () => handleDelete(),
    save: hasButton('SAVE') ? () => void handleSave() : (() => undefined),
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
      {isOpenSearchArea && <ShipmentRequestElectrodeForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefMain}
        gridFilter={gridFilterRefMain}
        dataCount={mainRows.length}
        excelFileName='Shipment Request(Electrode)'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          <ShipmentRequestElectrodeMainGrid
            rows={mainRows}
            gridRef={gridRefMain}
            gridFilterRef={gridFilterRefMain}
            staticColumns={staticColumns[SHEETS.MAIN]}
            bohMode={bohMode}
            bucketType={searchParams.bucketType}
            sumChecked={searchParams.sumChecked}
            pastPeriodChecked={searchParams.pastPeriodChecked}
            planDate={searchParams.planDate}
            onFocus={() => setActiveGrid('spdMain')}
          />
        </Panel>
        <PanelSeparator />
        <Panel defaultSize={50} minSize={20}>
          <TabWrapper
            persist
            onTabClick={index => setActiveDetailTab(index === 0 ? 'requestDetail' : 'stockDetail')}
          >
            <TabItem label={t('LBL00669', '_Shipment Request Detail')}>
              <ShipmentRequestElectrodeDetailGrid
                rows={requestDetailRows}
                gridRef={gridRefRequest}
                gridFilterRef={gridFilterRefRequest}
                editTrackerRef={editTrackerRefRequest}
                staticColumns={staticColumns[SHEETS.REQUEST_DETAIL]}
                isEditMode={false}
                onFocus={() => setActiveGrid('spdDetail')}
              />
            </TabItem>
            <TabItem label={t('LBL01090', '_Stock Detail')}>
              <ShipmentRequestElectrodeStockGrid
                rows={stockDetailRows}
                gridRef={gridRefStock}
                gridFilterRef={gridFilterRefStock}
                staticColumns={staticColumns[SHEETS.STOCK_DETAIL]}
                onFocus={() => setActiveGrid('spdDetail')}
              />
            </TabItem>
          </TabWrapper>
        </Panel>
      </PanelGroup>
    </>
  );
};
