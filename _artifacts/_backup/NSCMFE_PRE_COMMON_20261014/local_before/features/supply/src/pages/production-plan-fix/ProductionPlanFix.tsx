import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import dayjs from 'dayjs';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ProductionPlanFixForm } from './components/ProductionPlanFixForm';
import { ProductionPlanFixGrid } from './components/ProductionPlanFixGrid';
import { useProductionPlanFixValidation } from './hooks/useProductionPlanFixValidation';
import { LBL, MENU_ID, MSG, PRESET_W52, SHEETS } from './production-plan-fix.constants';
import type { MainRow } from './production-plan-fix.types';
import styles from './ProductionPlanFix.module.scss';
import { useProductionPlanFixStore } from './useProductionPlanFixStore';
import { buildUnfixPayload } from './utils/productionPlanFixSave';

// AS-IS GSCM.SCP.Analysis.UIL SCP0024_ProductionPlanFix — measure-행 pivot 그리드(spdMain) + fix/unfix 액션.
//   설계: .atlas/gscm-design/SCP0024/design/00~03 (v2, DB 실측). 상세 매핑: __asis-mapping__.md.
//   AS-IS 소스 확정(gap-resolve iter-2 — GSCM/ 리포 반입 후 정독):
//     FindButton=조회(cs:605) / btnUnfix=선택셀 기반 Unfix(cs:1199→1249 SaveData_FixInfo_U) /
//     InsertButton=빈 본문(cs:1059-1061)·DeleteButton=주석(cs:615-618) = NO-OP 확정 →
//     노출 + 명시적 무동작(insert/delete: ()=>undefined). EditButton=MSG00109("Read-only mode.") 안내 후
//     return(cs:621-634, SwitchLock 주석) — 모드 토글 자체는 asis_to_tobe.md §11 (b) 결정으로 미이식.
//   주의: AS-IS SaveButton 은 본문 주석(`//SaveData()`, cs:636-639)의 NO-OP 이고 시트도 ReadOnly(cs:415)라
//     AS-IS 화면엔 편집·Fix 저장 경로가 없다(확정은 SCP0013 쪽). 사용자 결정(2026-09-26, gap-resolve G20):
//     AS-IS 엄격 재현 채택 — SAVE=NO-OP(노출 유지 무동작), 편집 band·Fix 저장 경로 제거, 시트 전 셀 읽기전용.
//     화면의 유일한 활성 쓰기는 Unfix(선택 셀 기반). DB 메타(main/SAVE→_DS 배선)는 유지하되 FE 가 호출하지 않는다.
//   권한 모델(design 01 R2): Fix/Unfix 는 AS-IS CanUpdate(화면 update 권한) 단일 게이트 — TO-BE 는 SAVE 권한으로 통일
//     (전용 BTN_CD 미등록, 자매 SCP0013/BOD 선례).
export const ProductionPlanFix = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSearch } = useProductionPlanFixValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const sc = useProductionPlanFixStore(s => s.searchCondition);
  const filters = useProductionPlanFixStore(s => s.filters);
  const setFilter = useProductionPlanFixStore(s => s.setFilter);
  const setSearchCondition = useProductionPlanFixStore(s => s.setSearchCondition);
  const openSearchArea = useProductionPlanFixStore(s => s.openSearchArea);
  const setOpenSearchArea = useProductionPlanFixStore(s => s.setOpenSearchArea);
  const staticColumns = useProductionPlanFixStore(s => s.staticColumns);
  const fetchStaticColumns = useProductionPlanFixStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useProductionPlanFixStore(s => s.fetchStaticMeasures);
  const initialized = useProductionPlanFixStore(s => s.initialized);

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

  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);
  const visibilityCtx = useMemo(() => ({ division: sc.divisionId }), [sc.divisionId]);

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 'Model' 12행 + SCM_MST_SHEET_MEASURE 'PRODUCTION_PLAN_FIX' 2행)
  //   — mount 1회 fetch(hook #66). Search 시에도 refetch(handleSearch).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // 필수(Division/OperationGroup/Period — AS-IS checkRequiredOfSearch) + 기간 from<=to
    if (!validateSearch(sc).ok) return;
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // 선택 셀/행 존재 — AS-IS Unfix 전제(design 01 R3 — selCells<1 → MSG00134).
  const hasSelectedCell = (): boolean => {
    const g = gridRef.current;
    return !!g && g.rows.length > 0 && (g.selection?.row ?? -1) >= 0;
  };

  // Unfix(btnUnfix) — R1 조회선행 / R2 권한(CanUpdate→SAVE, MSG00096) / R3 셀선택(MSG00134)+confirm(MSG00016).
  //   payload 는 편집(dirty)이 아니라 선택 셀 기반 — AS-IS SaveData_FixInfo_U(cs:1249-1544)는 선택 range 의
  //   Prod Plan 행 × D_(수량 있는 일자, W_ 는 주 확장) 셀을 편집 없이 ACTIVE_FLAG='D' 로 전송한다
  //   (gap-resolve iter-2 — 종전 dirty 기반은 "편집한 셀만 해제 가능" 불일치. 자매 정본 SCP0025 동일 구조).
  //   수집 0건이면 MSG00046("삭제할 데이터가 없습니다", cs:1535-1539) → TO-BE MSG01078 재매핑.
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
    // R3 — 셀 선택 + confirm(AS-IS 순서: selCells 검사 → confirm → 수집, cs:1311-1319).
    if (!hasSelectedCell()) {
      void setAlert({ type: 'alert', content: t(MSG.SELECT_CELL, '_Select a target cell.') });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_UNFIX, '_Do you want to release?') });
    if (!ok) return;
    gridRef.current?.finishEditing();
    const payload = buildUnfixPayload(gridRef.current, sc.bucket);
    if (payload.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_DELETE_DATA, '_No data to delete.') });
      return;
    }
    mutateMain(payload as unknown as MainRow[]);
  };

  // 기간 프리셋 — GetDayRange(weeks) 등가 클라 산정(from=오늘, to=오늘+weeks*7-1). dayjs 로컬(함정12).
  const handlePreset = (weeks: number) => {
    const from = dayjs();
    const to = from.add(weeks * 7 - 1, 'day');
    setSearchCondition({ fromYyyymmdd: from.format('YYYYMMDD'), toYyyymmdd: to.format('YYYYMMDD') });
  };

  // 진입 시 조회기간 기본값 = W52 — AS-IS InitControls `dCalendar.InitValue = GetDayRange(PeriodType.W52)`
  //   (cs:430) 재현. 탭 저장값(persisted store)이 이미 있으면 유지, 빈 경우에만 세팅(gap-resolve iter-2).
  useEffect(() => {
    if (!sc.fromYyyymmdd && !sc.toYyyymmdd) handlePreset(PRESET_W52);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // btnWLast 텍스트 주차 — AS-IS GetLastRange(division)(GetDayRange periodType 'Last', design 02 §7-4).
  //   자매 SCP0022 와 동일: GetLastRange SP(SCM0001_GET_SCP_DAILY_PLAN_PERIOD) 미배선(convert-sp 후속)이라
  //   ''로 넘겨 W26 fallback(react-gap-audit B1). SP 배선 시 이 값만 채우면 라벨/숨김 규칙이 자동 반영된다.
  const wLastPeriod = '';

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(search 버튼 권한과 무관하게 조회 보장).
    search: handleSearch,
    // Save/Insert/Delete — AS-IS NO-OP 확정(SaveButton 주석 cs:636-639 / InsertRow 빈 본문 cs:1059-1061 /
    //   DeleteButton 주석 cs:615-618). 사용자 결정(2026-09-26 G20): SAVE 도 AS-IS 재현 = NO-OP.
    //   skill §3 규칙: NO-OP 버튼은 노출 + 명시적 무동작(키 생략·false 금지 — 공용 addRow/removeRow 부활 방지).
    save: () => undefined,
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
        <ProductionPlanFixForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onPreset={handlePreset}
          wLastPeriod={wLastPeriod}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ProductionPlanFix'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // btnUnfix — 조회조건 우측 화면 고유 액션 버튼(design 01 §1).
          { label: t(LBL.UNFIX, '_Unfix'), action: () => void handleUnfix() },
        ]}
      />

      <div className={styles.gridWrapper}>
        <ProductionPlanFixGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
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
