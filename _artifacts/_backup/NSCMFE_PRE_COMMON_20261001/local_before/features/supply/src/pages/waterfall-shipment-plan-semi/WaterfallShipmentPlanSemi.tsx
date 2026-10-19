import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { WaterfallShipmentPlanSemiForm } from './components/WaterfallShipmentPlanSemiForm';
import { WaterfallShipmentPlanSemiGrid } from './components/WaterfallShipmentPlanSemiGrid';
import { useWaterfallShipmentPlanSemiStore } from './useWaterfallShipmentPlanSemiStore';
import { saveTitleSet } from './utils/waterfall-shipment-plan-semi.api';
import { MENU_ID, MSG, SHEETS } from './waterfall-shipment-plan-semi.constants';
import type { SpreadTitleRow, WaterfallRow } from './waterfall-shipment-plan-semi.types';

// SCP0018 Waterfall Shipment Plan Semi — 읽기 전용 조회 화면 (보완 회차 v2, index.ts/Page 신설).
//   AS-IS: GSCM.SCP.Forms.UIL/Analysis/SCP0018_WaterfallShipmentPlanSemi.cs — Delete/Save 순수
//   NO-OP, Edit 은 MSG00109 안내 후 NO-OP(01_layout.md §2 트리거H). 정본:
//   `.atlas/gscm-design/SCP0018/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`.
//   PKG_SCP0018/PKG_SCP0009(_ISO 캘린더 멤버) 미배포 — 실 데이터 조회는 convert-sp 후속(§확인필요).

const EMPTY_ROWS: never[] = [];

export const WaterfallShipmentPlanSemi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<TFlexGrid<WaterfallRow> | undefined>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);

  const { t } = useTranslation();
  const session = useSessionStore(state => state.session);
  const { setAlert } = useMessageStore();

  const filters = useWaterfallShipmentPlanSemiStore(state => state.filters);
  const searchParams = useWaterfallShipmentPlanSemiStore(state => state.searchParams);
  const isOpenSearchArea = useWaterfallShipmentPlanSemiStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useWaterfallShipmentPlanSemiStore(state => state.setOpenSearchArea);
  const setFilters = useWaterfallShipmentPlanSemiStore(state => state.setFilters);
  const clearData = useWaterfallShipmentPlanSemiStore(state => state.clearData);
  const fetchStaticColumns = useWaterfallShipmentPlanSemiStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useWaterfallShipmentPlanSemiStore(state => state.fetchStaticMeasures);
  const staticMeasures = useWaterfallShipmentPlanSemiStore(state => state.staticMeasures);

  const [measureModalOpen, setMeasureModalOpen] = useState(false);

  // p_sheet_name 파생값 — OperationGroup=='A' ? 'CELL' : 'ELECTRODE' (§4.2, 고정값 전달 금지).
  const sheetName = searchParams.operationGroup === 'A' ? 'CELL' : 'ELECTRODE';

  const mainQuery = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const titleQuery = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: !!filters[SHEETS.SPREAD_TITLE],
  });

  const data = (mainQuery.data?.o_rc1 ?? EMPTY_ROWS) as WaterfallRow[];
  const spreadTitle = (titleQuery.data?.o_rc1 ?? EMPTY_ROWS) as SpreadTitleRow[];

  // 01_layout.md §2 트리거C(division 권한 0건 → MSG00097)는 Form.tsx 가 자체 배선한다(divisions 콤보를
  //   Form 이 이미 조회하므로 중복 조회를 피한다) — 여기서는 재차 호출하지 않는다.

  // 정적 컬럼 — SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0018') 24행, mount 1회(division 무관 정본).
  useEffect(() => {
    void fetchStaticColumns();
  }, [fetchStaticColumns]);

  // Measure — p_sheet_name(CELL/ELECTRODE) 파생값 변경 시 재fetch(§4.3).
  useEffect(() => {
    void fetchStaticMeasures(sheetName);
  }, [sheetName, fetchStaticMeasures]);

  // Division 변경 = 그리드 초기화(nscm-patterns.md §5-5, 편집 축 없는 화면이라 조회결과만 비움).
  const handleDivisionChange = () => {
    clearData();
  };

  // FindData_Main 이중 필수값 체크 재현 — Division/Version/Period 최소 필수(§6#7).
  const handleSubmit = () => {
    if (!session.userId) return;
    if (
      !searchParams.divisionId ||
      searchParams.versionNos.length === 0 ||
      !searchParams.startYyyymmdd ||
      !searchParams.endYyyymmdd
    ) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_INPUT, '_Please enter the required fields.') });
      return;
    }
    setFilters({ userId: session.userId });
  };

  // 01_layout.md §2 트리거F~I — Delete/Save 순수 NO-OP(명시적 무동작, 키 생략·false 금지).
  //   Insert/Upload/Manual 은 AS-IS 에 해당 컨트롤 자체가 없어(§1) false 유지.
  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: false,
    delete: () => undefined,
    save: () => undefined,
    upload: false,
    manual: false,
  };

  // 트리거H — Edit 버튼은 표준 hotkey 세트에 없는 화면 전용 컨트롤이라 customButton 으로 재현한다.
  //   클릭 시 MSG00109 안내 후 무조건 NO-OP(단순 () => undefined 는 오답 — 메시지 재현 필수).
  const handleEditClick = () => {
    void setAlert({ type: 'alert', content: t(MSG.EDIT_READONLY, '_Read-only mode.') });
  };

  const customButtons = [
    {
      label: t('LBL00109', 'Edit'),
      title: t('LBL00109', 'Edit'),
      action: handleEditClick,
      buttonLabel: t('LBL00109', 'Edit'),
    },
    {
      label: t('LBL00310', '_Measure'),
      title: t('LBL00310', '_Measure'),
      action: () => setMeasureModalOpen(true),
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
      <WaterfallShipmentPlanSemiForm onSubmit={handleSubmit} onDivisionChange={handleDivisionChange} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data.length}
        excelFileName='WaterfallShipmentPlanSemi'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <WaterfallShipmentPlanSemiGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={data}
        spreadTitle={spreadTitle}
      />

      {/* btnMeasure — SCM0002_TitleSetForm_Popup(SCP0018, measureType) 대응(02_search-combo.md §4.6). */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          void saveTitleSet(
            'M',
            selected.map((name, i) => ({ name, sortOrderNo: i + 1 }))
          );
          clearData();
        }}
      />
    </>
  );
};
