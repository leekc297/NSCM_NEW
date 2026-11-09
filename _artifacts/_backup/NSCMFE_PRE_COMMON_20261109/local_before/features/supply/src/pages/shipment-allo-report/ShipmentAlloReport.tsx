import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcSetting } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery, useProcMutation } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ShipmentAlloReportForm } from './components/ShipmentAlloReportForm';
import { ShipmentAlloReportGrid } from './components/ShipmentAlloReportGrid';
import { MENU_ID, MSG, SHEETS, TAB } from './shipment-allo-report.constants';
import type { PivotMonthMeta, ShipmentAlloRow, TeamRow } from './shipment-allo-report.types';
import { useShipmentAlloReportStore } from './useShipmentAlloReportStore';
import {
  applyGap,
  buildBaseRows,
  buildPivotMonths,
  fillPivotValues,
  insertSummaryRows,
  mergeMainWithGap,
} from './utils/shipment-allo-report.columns';

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0055_Shipment_Allo_Report(1,486줄) — Main/Gap 탭 2그리드
//   피벗 리포트 + 비고(NOTE) 단일 편집. 설계: .atlas/gscm-design/SCP0055/design/00~03.
//   버튼 4종(Search/Edit/Save/Excel) 전부 실동작(design 00 §4d) — NO-OP 없음.
//   확인 필요(상세는 04_react-gap.md): domain 확정(Supply 채택 근거는 result.md), PKG_SCP0055 MISSING
//   (convert-sp 후속), clbTeam SQL_ID 미확정, Excel Yes/No/Cancel 3분기 중 No 분기 단순화(2-way 대체).
const buildRowsFor = (data: unknown, monthsForTab: PivotMonthMeta[]): ShipmentAlloRow[] => {
  const d = data as { o_rc1?: unknown[]; o_rc2?: TeamRow[]; o_rc3?: unknown[] } | undefined;
  if (!d?.o_rc2) return [];
  const base = buildBaseRows(d.o_rc2);
  return fillPivotValues(base, (d.o_rc1 ?? []) as never, (d.o_rc3 ?? []) as never, monthsForTab);
};

export const ShipmentAlloReport = ({ tabId, title }: PageProps<typeof MENU_ID>) => {
  const { t } = useTranslation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const userId = useSessionStore(s => s.session?.userId ?? '');

  const mainGridRef = useRef<FlexGrid>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const mainTrackerRef = useRef<EditTracker>();
  const gapGridRef = useRef<FlexGrid>();
  const gapFilterRef = useRef<FlexGridFilter>();
  const gapTrackerRef = useRef<EditTracker>();

  const [activeTabIndex, setActiveTabIndex] = useState(0);
  const activeTab = activeTabIndex === 0 ? TAB.MAIN : TAB.GAP;

  const sc = useShipmentAlloReportStore(s => s.searchCondition);
  const openSearchArea = useShipmentAlloReportStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentAlloReportStore(s => s.setOpenSearchArea);
  const runSearch = useShipmentAlloReportStore(s => s.runSearch);
  const mainFilter = useShipmentAlloReportStore(s => s.mainFilter);
  const gapFilter = useShipmentAlloReportStore(s => s.gapFilter);
  const editable = useShipmentAlloReportStore(s => s.editable);
  const setEditable = useShipmentAlloReportStore(s => s.setEditable);
  const staticColumns = useShipmentAlloReportStore(s => s.staticColumns);
  const initialized = useShipmentAlloReportStore(s => s.initialized);
  const fetchStaticColumns = useShipmentAlloReportStore(s => s.fetchStaticColumns);
  const restoreSearchCondition = useShipmentAlloReportStore(s => s.restoreSearchCondition);

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // F6 로 저장한 조회조건을 진입 시 1회 복원한다(store 비영속 — 새로고침 생존은 이 GET 뿐).
    //   복원은 searchCondition 만 채우고 filters 는 비운 채라 자동조회 없이 Search 대기 상태가 된다.
    void restoreSearchCondition();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const mainQuery = useTabProcQuery<typeof MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: `${tabId}-main`,
    filters: mainFilter,
    enabled: !!mainFilter,
  });
  const gapQuery = useTabProcQuery<typeof MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId: `${tabId}-gap`,
    filters: gapFilter,
    enabled: !!gapFilter,
  });

  const saveMutation = useProcMutation<typeof MENU_ID, SHEETS.MAIN, 'o_rc2'>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const months = useMemo(
    () => buildPivotMonths(sc.fromYyyymm, sc.toYyyymm, sc.planDate.slice(0, 6)),
    [sc.fromYyyymm, sc.toYyyymm, sc.planDate]
  );
  const gapMonths = useMemo(
    () => buildPivotMonths(sc.fromYyyymm, sc.toYyyymm, sc.gapDate.slice(0, 6)),
    [sc.fromYyyymm, sc.toYyyymm, sc.gapDate]
  );

  const gapRows = useMemo(() => buildRowsFor(gapQuery.data, gapMonths), [gapQuery.data, gapMonths]);
  const mainRowsRaw = useMemo(() => buildRowsFor(mainQuery.data, months), [mainQuery.data, months]);
  // Main⊇Gap 행 보장 + GAP 계산(design 03 §3.1) + 요약행 삽입(RefreshGridGAP).
  const mainRows = useMemo(() => {
    const merged = mergeMainWithGap(mainRowsRaw, gapRows);
    const withGap = applyGap(merged, gapRows);
    return insertSummaryRows(withGap, months, true);
  }, [mainRowsRaw, gapRows, months]);
  const gapRowsWithSummary = useMemo(() => insertSummaryRows(gapRows, gapMonths, false), [gapRows, gapMonths]);

  const activeRowCount = activeTab === TAB.MAIN ? mainRows.length : gapRowsWithSummary.length;
  const hasSearchResult = mainQuery.isSuccess || gapQuery.isSuccess;

  // 사전검증 3건(design 01 §2 #13) — Period From>To / PlanDate<GapDate / PlanDate=GapDate.
  const validateBeforeSearch = (): boolean => {
    const setAlert = useMessageStore.getState().setAlert;
    if (sc.fromYyyymm && sc.toYyyymm && sc.fromYyyymm > sc.toYyyymm) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_RANGE, '_Period From must not be after To.') });
      return false;
    }
    if (sc.planDate && sc.gapDate && sc.planDate < sc.gapDate) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_GAP_ORDER, '_Plan Date must not be before Gap Date.') });
      return false;
    }
    if (sc.planDate && sc.gapDate && sc.planDate === sc.gapDate) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_GAP_EQUAL, '_Plan Date must differ from Gap Date.') });
      return false;
    }
    return true;
  };

  const handleSearch = () => {
    if (!validateBeforeSearch()) return;
    runSearch(userId);
  };

  // EditButton — 조회 결과(fps) 존재 시에만 토글(design 01 §2 #14 가드).
  const handleToggleEdit = () => {
    if (!hasSearchResult) return;
    setEditable(!editable);
  };

  // Save — 비고 값이 실제로 바뀐 행만 전송(design 03 §4.3). 요약행(IS_SUMMARY)은 파생행이라 제외.
  const handleSave = () => {
    const tracker = activeTab === TAB.MAIN ? mainTrackerRef.current : gapTrackerRef.current;
    const rows = activeTab === TAB.MAIN ? mainRows : gapRowsWithSummary;
    const dirtyRowSet = new Set(
      [...(tracker?.getOriginalValues().keys() ?? [])].filter(
        row => 'NOTE' in (tracker?.getOriginalValues().get(row) ?? {})
      )
    );
    // 팀명 공백 행(IS_TEAM_BLANK)은 비고 편집 자체는 막지 않지만(design 03 §3 #29-부속, 시각효과만) 저장
    // 대상에서는 제외한다 — AS-IS 는 이 행을 저장 SP 호출 대상에 포함하지 않는다.
    const changed = rows.filter(r => !r.IS_SUMMARY && !r.IS_TEAM_BLANK && dirtyRowSet.has(r as never));
    const payload = changed.map(r => ({
      SITE_NAME: r.FROM_SITE,
      SITE_ID: r.SITE_ID,
      EXTRA_SPEC: r.EXTRA_SPEC,
      NICK_NAME: r.NICK_NAME,
      DEPT_ID: r.DEPT_ID,
      DEPT_NAME: r.TEAM_NAME,
      PLAN_DATE: sc.planDate,
      GAP_DATE: sc.gapDate,
      NOTE: r.NOTE ?? '',
      PROGRAM_ID: MENU_ID,
      USER_ID: userId,
    }));
    saveMutation.mutate(payload, {
      onSuccess: () => {
        useMessageStore.getState().setToast({
          type: 'success',
          message: t(MSG.SAVE_COUNT, { defaultValue: `${payload.length}건 저장되었습니다.` }),
        });
        runSearch(userId); // 저장 후 자동 재조회 → 그리드 재잠금(design 01 §2 #15)
      },
    });
  };

  // Excel — MSG00100 Yes/No/Cancel 확인(design 01 §2 #16). 확인 필요: 공용 confirm 은 2-way(예/취소)라
  // No(저장 후 export) 분기는 이번 회차에서 재현하지 못함 — 04_react-gap.md 정직 보고 대상.
  const handleExcel = async () => {
    const ok = await useMessageStore.getState().setAlert({
      type: 'confirm',
      content: t(MSG.EXCEL_CONFIRM, '_저장하지 않고 바로 열겠습니까?'),
    });
    if (!ok) return;
    const grid = activeTab === TAB.MAIN ? mainGridRef.current : gapGridRef.current;
    if (!grid) return;
    void GridAction.excelDownload(grid, 'ShipmentAlloReport', useUIStore.getState().setProgress);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    // AS-IS 4버튼(Search/Edit/Save/Excel) 전부 실동작 — Insert/Delete/Upload/Manual 없음(design plan §6).
    insert: false,
    delete: false,
    manual: false,
    upload: false,
    save: handleSave,
    excel: handleExcel,
  };

  const customButtons = hasButton('EDIT')
    ? [
        {
          label: t('', { defaultValue: 'Edit' }),
          title: t('', { defaultValue: 'Edit' }),
          action: handleToggleEdit,
          iconComponent: <IcSetting />,
          buttonLabel: '',
        },
      ]
    : [];

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} openSearchArea={openSearchArea} toggleOpenSearchArea={setOpenSearchArea} />

      <ShipmentAlloReportForm onSearch={handleSearch} />

      <SubTitle
        menuId={MENU_ID}
        grid={activeTab === TAB.MAIN ? mainGridRef : gapGridRef}
        gridFilter={activeTab === TAB.MAIN ? mainFilterRef : gapFilterRef}
        dataCount={activeRowCount}
        excelFileName='ShipmentAlloReport'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <TabWrapper activeTabIndex={activeTabIndex} setActiveTabIndex={setActiveTabIndex} persist>
        <TabItem label={t('', { defaultValue: 'Main' })}>
          <ShipmentAlloReportGrid
            rows={mainRows}
            adminColumns={staticColumns}
            months={months}
            isGapTab={false}
            editable={editable}
            gridRef={mainGridRef}
            gridFilterRef={mainFilterRef}
            editTrackerRef={mainTrackerRef}
          />
        </TabItem>
        <TabItem label={t('', { defaultValue: 'Gap' })}>
          <ShipmentAlloReportGrid
            rows={gapRowsWithSummary}
            adminColumns={staticColumns}
            months={gapMonths}
            isGapTab={true}
            editable={editable}
            gridRef={gapGridRef}
            gridFilterRef={gapFilterRef}
            editTrackerRef={gapTrackerRef}
          />
        </TabItem>
      </TabWrapper>
    </>
  );
};
