import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ShipmentPlanFixForm } from './components/ShipmentPlanFixForm';
import { ShipmentPlanFixGrid } from './components/ShipmentPlanFixGrid';
import { useShipmentPlanFixValidation } from './hooks/useShipmentPlanFixValidation';
import { COMBO, LBL, MENU_ID, MSG, PRESET_W52, SHEETS } from './shipment-plan-fix.constants';
import type { MainRow } from './shipment-plan-fix.types';
import styles from './ShipmentPlanFix.module.scss';
import { useShipmentPlanFixStore } from './useShipmentPlanFixStore';
import { mergeFixReason } from './utils/shipmentPlanFixDerive';
import { buildUnfixPayload } from './utils/shipmentPlanFixSave';

// AS-IS GSCM.SCP.Analysis.UIL SCP0025_ShipmentPlanFix — read-only pivot 그리드(spdMain) + 셀선택→Unfix 액션.
//   설계: .atlas/gscm-design/SCP0025/design/00~03 (v2, DB·SP 실측). 상세 매핑: __asis-mapping__.md.
//   액션 모델(design 01/03 §0·§4.3): FindButton=조회 / SAVE 버튼·btnUnfix=Unfix(확정 해제, ACTIVE_FLAG='D').
//     SAVE SP(P_SCP0025_SAVE_FIX_DATASET) 는 실측상 Unfix 전용(확정 테이블 write = 'D' DELETE 뿐, Fix-insert 없음).
//     그래서 SAVE 버튼과 btnUnfix 둘 다 동일 Unfix 흐름으로 배선(design 03 §0). Edit/Excel 은 §2.4 판정.
//   자매 SCP0024(production-plan-fix)와 차이: SCP0025 는 전 컬럼 read-only(편집·EditTracker 없음) → Unfix 는
//     편집 저장이 아니라 선택 셀 역산 키에 ACTIVE_FLAG='D' 전송(design 03 §3-보강).
//   가드(design 01 R1~R4): R1 조회선행(ViewModel null) / R2 권한(CanUpdate→SAVE, MSG00096) / R3 PlanExecYn
//     PLAN_STATUS='0' 차단(MSG00304) / R4 셀선택(MSG00134)+confirm(MSG00016).
export const ShipmentPlanFix = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSearch } = useShipmentPlanFixValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const sc = useShipmentPlanFixStore(s => s.searchCondition);
  const filters = useShipmentPlanFixStore(s => s.filters);
  const setFilter = useShipmentPlanFixStore(s => s.setFilter);
  const setSearchCondition = useShipmentPlanFixStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentPlanFixStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentPlanFixStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentPlanFixStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentPlanFixStore(s => s.fetchStaticColumns);
  const initialized = useShipmentPlanFixStore(s => s.initialized);

  const [openItem, setOpenItem] = useState(false);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const { mutate: mutateMain } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  // R3 PlanExecYn 게이트 데이터 — division 기준 PLAN_STATUS 조회(design 01 R3, comboCall §4b #5).
  //   콤보(dropdown)가 아니라 unfix 가드용 데이터 조회라 Page 에서 fetch, handleUnfix 가 결과를 판정한다.
  const [planExecRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_EXEC_YN, mnuId: MENU_ID, divisionId: sc.divisionId }],
    enabled: !!sc.divisionId,
  });

  const rc1 = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  const rc2 = useMemo<Record<string, unknown>[]>(
    () => (data as { o_rc2?: Record<string, unknown>[] })?.o_rc2 ?? [],
    [data]
  );
  // O_RC2(Fix Reason 상세)를 Fix Reason 행 D_ 셀에 매핑(design 03 §2.3 R-H).
  const rows = useMemo<MainRow[]>(
    () => mergeFixReason(rc1 as unknown as Record<string, unknown>[], rc2) as unknown as MainRow[],
    [rc1, rc2]
  );
  const visibilityCtx = useMemo(() => ({ division: sc.divisionId }), [sc.divisionId]);

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 'Shipment Plan Fix' 20행) — mount 1회 fetch(hook #66). Search 시에도 refetch.
  //   Measure 레지스트리(SCM_MST_SHEET_MEASURE)는 0행이라 fetch 없음(design 03 §0/§4.1).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 기본 조회기간 시드 — 기간이 비어 있으면(최초 mount) 기본값을 채워 pivot 컬럼 0(빈 그리드)을 막는다(GAP-02).
  //   기본 기간 = W52 — AS-IS CreateSpread(cs L240 `dCalendar.InitValue = GetDayRange(PeriodType.W52)`)의 화면 진입
  //   기본값과 동일하게 오늘~+52주로 시드한다(종전 W26 근사는 AS-IS 기본값 W52 와 불일치 — .cs 로 확정, G21).
  //   division 변경 시에는 기간을 유지하므로(store setDivision) 이 effect 는 실질적으로 mount 1회만 발동한다.
  //   division 별 실제 기간은 GetLastRange SP(SCM0001_GET_SCP_DAILY_PLAN_PERIOD — TO-BE 미배포, convert-sp 후속)
  //   배선 시 btnWLast 로 반영(GAP-04). 현재는 클라 dayjs 근사(정직 보고: SP 미배선).
  useEffect(() => {
    if (sc.divisionId && !sc.fromYyyymmdd && !sc.toYyyymmdd) {
      const from = dayjs();
      const to = from.add(PRESET_W52 * 7 - 1, 'day');
      setSearchCondition({ fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') });
    }
  }, [sc.divisionId, sc.fromYyyymmdd, sc.toYyyymmdd, setSearchCondition]);

  const handleSearch = () => {
    if (!validateSearch(sc).ok) return; // 기간 from<=to
    setFilter();
    void fetchStaticColumns();
  };

  // 선택 셀 존재 — AS-IS Unfix 전제(design 01 R4 — selCells<1 → MSG00134).
  const hasSelectedCell = (): boolean => {
    const g = gridRef.current;
    return !!g && g.rows.length > 0 && (g.selection?.row ?? -1) >= 0 && (g.selection?.col ?? -1) >= 0;
  };

  // R3 — PlanExecYn 조회결과 행 1건 & PLAN_STATUS=='0'(계획 미실행)이면 unfix 차단(design 01 R3, MSG00304).
  //   ComboResponse 는 [key:string]:string 인덱스 시그니처라 PLAN_STATUS 를 직접 읽는다(PlanExecYn_SCP 반환 컬럼).
  const isPlanNotExecuted = (): boolean => {
    const list = planExecRows ?? [];
    return list.length === 1 && list[0].PLAN_STATUS === '0';
  };

  // Unfix(SAVE 버튼 / btnUnfix) — 선택 셀(Ship Plan 행 × D_ 일자)에서 역산한 키에 ACTIVE_FLAG='D' → SAVE SP 전송.
  //   design 01 R1~R4 가드 → design 03 §4.3 JSON 계약. 성공/실패/재조회는 useProcMutation 기본 onSuccess.
  const handleUnfix = async () => {
    // R1 — 미조회(데이터 없음) 상태면 무동작 return(ViewModel null 가드).
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.SEARCH_FIRST, '_Search before unfix.') });
      return;
    }
    // R2 — 권한 게이트(AS-IS CanUpdate → TO-BE SAVE 권한).
    if (!hasButton('SAVE')) {
      void setAlert({ type: 'alert', content: t(MSG.NO_PERMISSION, '_No permission.') });
      return;
    }
    // R3 — 계획 실행상태 게이트(PlanExecYn PLAN_STATUS='0').
    if (isPlanNotExecuted()) {
      void setAlert({ type: 'alert', content: t(MSG.PLAN_NOT_EXEC, '_Plan is not executed; unfix is not allowed.') });
      return;
    }
    // R4 — 셀 선택 + confirm.
    if (!hasSelectedCell()) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    const payload = buildUnfixPayload(gridRef.current);
    if (payload.length === 0) {
      // 선택은 있으나 대상 셀(Ship Plan 행 × D_ 일자)이 아니면 안내(디폴트 셀선택 메시지 재사용).
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a Ship Plan daily cell.') });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, '_Do you want to release?') });
    if (!ok) return;
    mutateMain(payload as unknown as MainRow[]);
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(search 버튼 권한과 무관하게 조회 보장).
    search: handleSearch,
    // SAVE = Unfix — design 03 §0(SAVE SP 는 Unfix 전용). SAVE 권한 게이트, btnUnfix 와 동일 흐름.
    save: hasButton('SAVE') ? () => void handleUnfix() : false,
    // Insert/Delete — AS-IS toolbarOverride 자체가 없다(design 00 §4-2 / 01 §2.4). 공용 SubTitle 기본 addRow/removeRow
    //   부활 방지를 위해 키를 명시적 무동작으로 둔다(skill §3 규칙: 키 생략·false 금지, 명시적 () => undefined).
    insert: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentPlanFixForm onSearch={handleSearch} onItemSearch={() => setOpenItem(true)} />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentPlanFix'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // btnUnfix — 조회조건 우측 화면 고유 액션 버튼(design 01 §1).
          { label: t(LBL.UNFIX, '_Unfix'), action: () => void handleUnfix() },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ShipmentPlanFixGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          bucket={sc.bucket}
          chkSum={sc.chkSum}
          visibilityCtx={visibilityCtx}
          adminColumns={staticColumns[SHEETS.MAIN]}
          onFocus={() => undefined}
        />
      </div>

      {/* Item 검색 — 공용 표준 ItemByDivisionModal (btnItemId → txtItemId, design 02 §4.6). */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={itemIds => setSearchCondition({ itemId: itemIds })}
        preSearchParams={{ divisionId: sc.divisionId, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
