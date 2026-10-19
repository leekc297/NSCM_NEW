import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { GlobalPsiForm } from './components/GlobalPsiForm';
import { GlobalPsiGrid } from './components/GlobalPsiGrid';
import { GlobalPsiModals } from './components/GlobalPsiModals';
import {
  LBL,
  MENU_ID,
  MSG,
  PLAN_PERIOD_COL,
  PLAN_PERIOD_COMBO_ID,
  SHEETS,
} from './global-psi.constants';
import type { GlobalPsiRow } from './global-psi.types';
import { useGlobalPsiStore } from './useGlobalPsiStore';

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0031_GlobalPSI (51076B) — 순수 조회(read-only) Global PSI PIVOT 분석.
//   설계: .atlas/gscm-design/SCP0031/design/00~03(DB 실측 PASS). 상세 매핑: __asis-mapping__.md.
//   버튼(design 01 §2 B1~B5, §DB): SEARCH·EXCEL·MEASURE_SELECT 실동작. Delete/Edit/Save = AS-IS 빈 override
//     → DB 미등록·hasButton=false 미노출 + hotkeyConfig false 로 공용 addRow/removeRow 부활 차단.
//   편집모드 상태 신설 금지(convert-core §2.1(11), 근거 __asis-mapping__ §5) — 순수 조회, canEdit 축 불필요.
export const GlobalPsi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // 팝업 open 상태 — Material(ItemByDivisionModal) / Measure(MeasureSelectModal) (design 02 §4.6 / 03 §6 C3).
  const [openItemPopup, setOpenItemPopup] = useState(false);
  const [openMeasurePopup, setOpenMeasurePopup] = useState(false);

  const sc = useGlobalPsiStore(s => s.searchCondition);
  const set = useGlobalPsiStore(s => s.setSearchCondition);
  const filters = useGlobalPsiStore(s => s.filters);
  const setFilter = useGlobalPsiStore(s => s.setFilter);
  const clearFilters = useGlobalPsiStore(s => s.clearFilters);
  const openSearchArea = useGlobalPsiStore(s => s.openSearchArea);
  const setOpenSearchArea = useGlobalPsiStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useGlobalPsiStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useGlobalPsiStore(s => s.fetchStaticMeasures);
  const staticColumns = useGlobalPsiStore(s => s.staticColumns);

  // 메인 조회 — 명시 SEARCH 게이트(enabled=!!filters). 자동조회 금지(nscm-patterns §5-7).
  const mainQuery = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const rows = useMemo<GlobalPsiRow[]>(
    () => (mainQuery.data as { o_rc1?: GlobalPsiRow[] })?.o_rc1 ?? [],
    [mainQuery.data]
  );

  // 동적 pivot 3단 헤더 원천 — GET_SHEET_CALENDAR_3SPAN(design 03 §2). Period(from~to)로 조회. 미입력이면 미조회
  //   → 그리드가 데이터 행 union 으로 폴백(globalPsiColumns).
  const calendarQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: { startYyyymmdd: sc.fromYyyymmdd, endYyyymmdd: sc.toYyyymmdd },
    enabled: !!sc.fromYyyymmdd && !!sc.toYyyymmdd,
  });
  const calendarRows = useMemo<Record<string, unknown>[]>(
    () => (calendarQuery.data as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [],
    [calendarQuery.data]
  );

  // mount — keep-alive 탭에 남은 stale filters 자동발사 차단(clearFilters) + admin 동적 메타 fetch(mount 1회).
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 필수값 검증(design 02 §5.1 checkRequired) — Division*/Plan Date*/Plan Type*/Seq*/Period*. 미충족 시 조회 차단.
  //   기간 범위검증(SCPPlanPeriod_SCP HORIZON_END clamp, design 02 §2.2 검증행/C9)은 확인필요(04, runtime-parity).
  const validateRequired = (): boolean => {
    if (
      !sc.divisionId.trim() ||
      !sc.planStartYyyymmdd.trim() ||
      !sc.planType.trim() ||
      !sc.planSeq.trim() ||
      !sc.fromYyyymmdd.trim() ||
      !sc.toYyyymmdd.trim()
    ) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_CONDITION, '_Please enter the required fields.'),
      });
      return false;
    }
    return true;
  };

  // 기간 horizon clamp(design 02 §2.2 검증행/C9) — AS-IS CheckPlanPeriodRange(SCP0031_GlobalPSI.cs:537~542).
  //   SCPPlanPeriod_SCP(@planName=planDate, @divisionId) 조회 → HORIZON_END_DATE/DIFF_WEEK. 조회 종료일이
  //   horizon 상한을 넘으면 AS-IS 처럼 종료일을 horizon 으로 되돌리고(dCalendar.Text2=plan_end_date) 이번 조회는
  //   중단한다(return). 조회 자체가 무해하도록 AS-IS 도 try/catch 로 감싸므로, 콤보 실패·0행이면 clamp 없이 진행.
  //   반환 true = 초과로 조회 중단.
  const clampPeriodToHorizon = async (): Promise<boolean> => {
    try {
      const periodRows = await apiClient.getCombo({
        comboId: PLAN_PERIOD_COMBO_ID,
        planName: sc.planStartYyyymmdd,
        divisionId: sc.divisionId,
      });
      const row = periodRows?.[0];
      if (!row) return false;
      const horizonEnd = String(row[PLAN_PERIOD_COL.HORIZON_END_DATE] ?? '');
      const diffWeek = String(row[PLAN_PERIOD_COL.DIFF_WEEK] ?? '');
      if (!horizonEnd || !sc.toYyyymmdd) return false;
      if (Number(sc.toYyyymmdd) > Number(horizonEnd)) {
        set({ toYyyymmdd: horizonEnd });
        void useMessageStore.getState().setAlert({
          type: 'alert',
          content: t(MSG.PERIOD_EXCEEDS, {
            defaultValue: 'You can search plans within the SCP section\n(~planning week + {0} weeks = {1})',
          })
            .replace('{0}', diffWeek)
            .replace('{1}', horizonEnd),
        });
        return true;
      }
    } catch {
      // AS-IS CheckPlanPeriodRange try/catch 와 동일 — 검증 조회 실패 시 clamp 없이 조회 진행.
    }
    return false;
  };

  // 조회 — 메타 refetch(admin 동적 속성관리 — mount + Search 시마다). setFilter 참조교체로 useTabProcQuery 발사.
  const handleSearch = async () => {
    if (!validateRequired()) return;
    if (await clampPeriodToHorizon()) return; // horizon 초과 = 종료일 되돌리고 조회 중단(AS-IS return)
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // 조회는 무해 → 항상 허용(design 01 §2 B1). Edit/Save/Insert/Delete = DB 미등록·NO-OP override →
  //   false 로 못박아 공용 SubTitle 기본 addRow/removeRow 부활 차단(design 01 §2 B3~B5, convert-core §2.1(11)).
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // Measure 개인화 버튼(design 01 §2 §DB MEASURE_SELECT / 03 §6 C3) — 표준 7버튼 밖 팝업이라 customButtons.
  //   권한 hasButton('MEASURE_SELECT') 조건부 노출(admin 동적 속성관리). icon-only(자매 SCP0100 선례 동일).
  const customButtons = hasButton('MEASURE_SELECT')
    ? [
        {
          label: t(LBL.MEASURE, '_Measure'),
          title: t(LBL.MEASURE, '_Measure'),
          action: () => setOpenMeasurePopup(true),
          iconComponent: <IcMeasureSelect />,
          buttonLabel: '',
        },
      ]
    : [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <GlobalPsiForm onSearch={handleSearch} onItemSearch={() => setOpenItemPopup(true)} />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='GlobalPsi'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <GlobalPsiGrid
        rows={rows as unknown as Record<string, unknown>[]}
        adminColumns={staticColumns}
        calendarRows={calendarRows}
        bucket={sc.bucket}
        chkSum={sc.chkSum}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
      />

      {/* SCM0002 Material 팝업(design 02 §4.6) — 반환 ItemID → searchCondition.itemId. 취소 시 기존값 유지.
          division 파라미터는 현재 선택 Division 을 넘긴다(AS-IS cboDivision.ControlValues). */}
      <ItemByDivisionModal
        open={openItemPopup}
        modalClose={() => setOpenItemPopup(false)}
        setSelectedValue={items => set({ itemId: items })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />

      {/* Measure 설정 팝업(design 03 §6 C3) — btnMeasure → MeasureSelectModal + titleSet('M') 저장. */}
      <GlobalPsiModals openMeasure={openMeasurePopup} onClose={() => setOpenMeasurePopup(false)} />
    </>
  );
};
