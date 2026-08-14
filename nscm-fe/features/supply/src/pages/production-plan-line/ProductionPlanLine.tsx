import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MeasureMeta, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ProductionPlanLineForm } from './components/ProductionPlanLineForm';
import { ProductionPlanLineGrid } from './components/ProductionPlanLineGrid';
import { BTN, MEASURE_FALLBACK, MENU_ID, MSG, SHEETS } from './production-plan-line.constants';
import type { ProductionPlanLineRow } from './production-plan-line.types';
import styles from './ProductionPlanLine.module.scss';
import { useProductionPlanLineStore } from './useProductionPlanLineStore';

// ⭐ SCP0013 — Production Plan Line (SCP 도메인 1호 화면, AS-IS SCP0013_ProductionPlanLine.cs 4,172줄).
//   Phase A (2026-07-13 사용자 확정): Shell + 레이아웃 + 메타. 조회/편집/저장/팝업은 SP 정식 변환(T19) 후:
//     - 사내 Oracle SCP 계열 SP 전원 INVALID(기계변환 초안) — 차단 handoff
//       `_artifacts/_apply_corporate/A5_scp0013_phase0_sp_blocked_handoff.md` (mock 금지 — 은폐 없이 안내)
//     - Phase B: 셀 편집(PROD_PLAN_AMEND 행)/저장/FIX/UNFIX · Phase C: NEW/Load%/Material 팝업
//   버튼(사용자 지시): SubTitle customButtons = 메저선택 아이콘 + NEW/FIX/UNFIX/LOAD% 텍스트 4종.
export const ProductionPlanLine = ({ title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const gridRef = useRef<FlexGrid<ProductionPlanLineRow>>();
  const gridFilterRef = useRef<FlexGridFilter>(undefined);

  const filters = useProductionPlanLineStore(s => s.filters);
  const setFilter = useProductionPlanLineStore(s => s.setFilter);
  const openSearchArea = useProductionPlanLineStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanLineStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useProductionPlanLineStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useProductionPlanLineStore(s => s.fetchStaticMeasures);
  const staticMeasures = useProductionPlanLineStore(s => s.staticMeasures);
  const visibleMeasures = useProductionPlanLineStore(s => s.visibleMeasures);
  const applyVisibleMeasures = useProductionPlanLineStore(s => s.applyVisibleMeasures);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // admin 동적 속성(Column/Measure) — mount 시 fetch (ui-dynamic-property-management master).
  useEffect(() => {
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // ⭐ 조회 — SCP0013_GET_PRODUCTION_PLAN_LINEBY (22 IN). SP INVALID(T19 변환 대기) 동안
  //   SEARCH_ENABLED=false 로 호출 자체 차단 (변환 완료 시 true 전환 + PROC_M 등록이 활성 조건).
  const SEARCH_ENABLED = false;
  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: 'ProductionPlanLine',
    filters: filters[SHEETS.MAIN],
    enabled: SEARCH_ENABLED && !!filters[SHEETS.MAIN],
  });

  const rows = useMemo<ProductionPlanLineRow[]>(
    () => (data as { o_rc1?: ProductionPlanLineRow[] })?.o_rc1 ?? [],
    [data]
  );

  const handleSearch = () => {
    setFilter();
    if (!SEARCH_ENABLED) {
      // 은폐 금지 — SP 변환 전 조회 불가를 명시 안내 (anti-simplification §5).
      void setAlert({
        type: 'alert',
        content: t(MSG.SEARCH_BLOCKED, '_조회는 SP 변환 적용 후 활성화됩니다.'),
      });
    }
  };

  // Phase B/C 기능 버튼 공통 안내 (기능 은폐 금지 — 후속 단계 명시).
  const notifyPhasePending = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.PHASE_PENDING, '_해당 기능은 후속 단계에서 적용 예정입니다.'),
    });
  };

  // ⭐ #3 — Measure 선택 모달 open state.
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);

  // ⭐ 공용 MeasureSelectModal(hook #132 §2-1 정본)은 fallback 미내장(admin 적재가 정본) —
  //   SCP0013 기존 동작(BE 메타 미적재 시 MEASURE_FALLBACK 6 코드 degrade, 라벨=코드)은
  //   호출부에서 공급해 그대로 보존한다.
  const measureItems = useMemo<MeasureMeta[]>(
    () =>
      staticMeasures[SHEETS.MAIN].length > 0
        ? staticMeasures[SHEETS.MAIN]
        : MEASURE_FALLBACK.map(code => ({ colNm: code, display: true })),
    [staticMeasures]
  );

  // SubTitle 공통버튼 — search 만 활성 (insert/delete/save 는 Phase B. manual/upload 명시 false).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  // ⭐ 커스텀 버튼 (사용자 지시 2026-07-13) — 메저선택 아이콘 + NEW/FIX/UNFIX/LOAD% 텍스트 4종.
  //   AS-IS: btnMeasure(TitleSet)/BtnNew_Click L842/btnFix_Click L993/btnUnfix_Click L1018/BtnLoad_Click L898.
  //   동작: Measure=실동작(메타 실측 6종) / NEW·FIX·UNFIX·LOAD%=Phase B·C 안내 (hasButton 권한 분기).
  const customButtons = [
    ...(hasButton(BTN.MEASURE_SELECT)
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton(BTN.NEW)
      ? [
          {
            label: t('LBL00770', '_New'),
            title: t('LBL00770', '_New'),
            action: notifyPhasePending,
            buttonLabel: t('LBL00770', '_New'),
          },
        ]
      : []),
    ...(hasButton(BTN.FIX)
      ? [
          {
            label: t('LBL00771', '_Fix'),
            title: t('LBL00771', '_Fix'),
            action: notifyPhasePending,
            buttonLabel: t('LBL00771', '_Fix'),
          },
        ]
      : []),
    ...(hasButton(BTN.UNFIX)
      ? [
          {
            label: t('LBL00772', '_Unfix'),
            title: t('LBL00772', '_Unfix'),
            action: notifyPhasePending,
            buttonLabel: t('LBL00772', '_Unfix'),
          },
        ]
      : []),
    ...(hasButton(BTN.LOAD_PERCENT)
      ? [
          {
            label: t('LBL00773', '_Load%'),
            title: t('LBL00773', '_Load%'),
            action: notifyPhasePending,
            buttonLabel: t('LBL00773', '_Load%'),
          },
        ]
      : []),
  ];

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && <ProductionPlanLineForm onSearch={handleSearch} />}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProductionPlanLine'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />

      <div className={styles.gridWrap}>
        <ProductionPlanLineGrid gridRef={gridRef} rows={rows} />
      </div>

      {/* ⭐ Measure 선택 (AS-IS btnMeasure → TitleSetForm 'SCP0013'/'LINE') —
          공용 정본(features/master measureSelectModal, hook #132 §2-1). OK → 표시 measure
          코드 목록(전체 선택 시 null)을 applyVisibleMeasures 로 적용 (titleSet 영구 저장은
          SP 변환(T19) 후 Phase 소관 — 로컬 사본 시절부터 미배선, 동작 동일 보존). */}
      <MeasureSelectModal
        open={openMeasureSelect}
        modalClose={() => setOpenMeasureSelect(false)}
        measures={measureItems}
        visibleMeasures={visibleMeasures[SHEETS.MAIN]}
        onApply={codes => applyVisibleMeasures(SHEETS.MAIN, codes)}
      />
    </div>
  );
};
