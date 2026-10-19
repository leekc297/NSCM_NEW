import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ElecMaterialPopup } from 'features/supply/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { GlobalPsiElecForm } from './components/GlobalPsiElecForm';
import { GlobalPsiElecGrid } from './components/GlobalPsiElecGrid';
import { DRILLDOWN, MENU_ID, MSG, SHEETS } from './global-psi-elec.constants';
import type { GlobalPsiElecRow } from './global-psi-elec.types';
import { useGlobalPsiElecStore } from './useGlobalPsiElecStore';

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SCP.Forms.UIL/Analysis/SCP0095_GlobalPSI_Elec (852줄) — 순수 조회(read-only) 3단 헤더 pivot.
//   설계: .atlas/gscm-design/SCP0095/design/00~03(DB 실측 PASS). 상세 매핑: __asis-mapping__.md.
//   버튼(design 01 §4d DB실측): SEARCH 단일 등록. Edit/Save/Insert/Delete = DB 미등록 → hasButton=false 미노출
//     + hotkeyConfig false 로 공용 addRow/removeRow 부활 차단(design 01 §5 #3 화면 결정 = 숨김).
//   편집모드 상태 신설 금지(convert-core §2.4, 근거는 __asis-mapping__ §5) — 순수조회, 권한은 조회영역 활성 여부로만.
export const GlobalPsiElec = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const findMenuPath = useSessionStore(state => state.findMenuPath);

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // Model(Item) 팝업 — ElecMaterialPopup(선작성, AS-IS SCM0002_ItembyDivisionPopupEE = 전극 전용, 확인필요 #6 확정).
  const [openModelPopup, setOpenModelPopup] = useState(false);

  const sc = useGlobalPsiElecStore(s => s.searchCondition);
  const set = useGlobalPsiElecStore(s => s.setSearchCondition);
  const filters = useGlobalPsiElecStore(s => s.filters);
  const setFilter = useGlobalPsiElecStore(s => s.setFilter);
  const clearFilters = useGlobalPsiElecStore(s => s.clearFilters);
  const openSearchArea = useGlobalPsiElecStore(s => s.openSearchArea);
  const setOpenSearchArea = useGlobalPsiElecStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useGlobalPsiElecStore(s => s.fetchStaticColumns);
  const staticColumns = useGlobalPsiElecStore(s => s.staticColumns);

  // 메인 조회 — 명시 SEARCH 게이트(enabled=!!filters). 자동조회 금지(nscm-patterns §5-7).
  const mainQuery = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  const rows = useMemo<GlobalPsiElecRow[]>(
    () => (mainQuery.data as { o_rc1?: GlobalPsiElecRow[] })?.o_rc1 ?? [],
    [mainQuery.data]
  );

  // 동적 pivot 3단 헤더 원천 — GET_SHEET_CALENDAR_3SPAN(design 03 §2). Period(from~to)로 조회. 미입력이면 미조회
  //   → 그리드가 데이터 행 union 으로 폴백(globalPsiElecColumns).
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 필수값 검증(design 02 §4) — Division*/Plan-date* + Period(from~to) 유효성. 미충족 시 조회 차단.
  const validateRequired = (): boolean => {
    if (!sc.divisionId.trim() || !sc.planStartYyyymmdd.trim() || !sc.fromYyyymmdd.trim() || !sc.toYyyymmdd.trim()) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_CONDITION, '_Please enter the required fields.'),
      });
      return false;
    }
    return true;
  };

  // 조회 — 메타 refetch(admin 동적 속성관리 — mount + Search 시마다). setFilter 참조교체로 useTabProcQuery 발사.
  const handleSearch = () => {
    if (!validateRequired()) return;
    setFilter();
    void fetchStaticColumns();
  };

  // 조회는 무해 → 항상 허용(design 01 §4d B1). Edit/Save/Insert/Delete = DB 미등록·NO-OP override →
  //   false 로 못박아 공용 SubTitle 기본 addRow/removeRow 부활 차단(design 01 §5 #3, __asis-mapping__ 근거).
  //   SubTitle 이 menuId 로 버튼 권한(hasButton)을 내부 판정해 렌더하므로 페이지에서 별도 게이트 불요.
  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(자매 global-psi-report 동일). SEARCH 권한 미보유 계정은 SubTitle 버튼이 숨겨진다.
    search: handleSearch,
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // 드릴다운(design 03 §3.1 buttonGuards 3중 가드 + hook #103) — MEASURE_NAME 열 & 현재행='Prod Plan (Engine)'
  //   더블클릭 → SCP0013 이동. AS-IS 는 5조건(division/operationGroup='E'/plantSite=TO_SITE/itemId=ELEC_MODEL/
  //   planDate)을 openSubMenu 로 전달하나, TO-BE MDI /view 네비게이션은 파라미터 포워딩 경로가 없어 화면만 연다
  //   (확인필요 — 04_react-gap §확인필요, 자매 master-validation 네비게이션 선례 동일).
  const handleCellDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return; // 가드1 — 헤더/푸터 무시
    const binding = g.columns[ht.col]?.binding ?? '';
    if (binding !== DRILLDOWN.TRIGGER_COLUMN) return; // 가드2 — MEASURE_NAME 열만
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row || s(row.MEASURE_NAME) !== DRILLDOWN.TRIGGER_MEASURE) return; // 가드3 — Prod Plan (Engine) 행만
    if (!findMenuPath(DRILLDOWN.TARGET_MENU)) return; // 권한 있는 메뉴만
    void navigate(`/view/${encodeURIComponent(DRILLDOWN.TARGET_MENU)}`);
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <GlobalPsiElecForm onSearch={handleSearch} onModelSearch={() => setOpenModelPopup(true)} />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='GlobalPsiElec'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <GlobalPsiElecGrid
        rows={rows as unknown as Record<string, unknown>[]}
        adminColumns={staticColumns}
        calendarRows={calendarRows}
        bucket={sc.bucket}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onCellDblClick={handleCellDblClick}
      />

      {/* Model(Item) 팝업 — ElecMaterialPopup(전극 전용, division 81,82,40 내부 고정 = AS-IS SCM0002_...EE). 반환
          ItemID → searchParams.itemId. 취소 시 기존값 유지(onSelect 미호출). division 은 표시용으로 현재값 전달. */}
      <ElecMaterialPopup
        open={openModelPopup}
        onClose={() => setOpenModelPopup(false)}
        onSelect={sel => set({ itemId: sel.itemId })}
        params={{ divisionId: sc.divisionId, itemId: sc.itemId }}
      />
    </>
  );
};
