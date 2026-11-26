import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { queryClient } from '@foundation/query-client';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  GlobalPsiElecDrilldownModal,
  type DrilldownParams,
} from './components/GlobalPsiElecDrilldownModal';
import { GlobalPsiElecForm } from './components/GlobalPsiElecForm';
import { GlobalPsiElecGrid } from './components/GlobalPsiElecGrid';
import {
  DRILLDOWN,
  LBL,
  MEASURE_SHEET_NAME,
  MENU_ID,
  MSG,
  SHEETS,
  TITLESET_MEASURE_TYPE,
} from './global-psi-elec.constants';
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
  const findMenuPath = useSessionStore(state => state.findMenuPath);

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // Material 팝업 — 메1 MaterialByDivisionModal(COM0013, AS-IS SCM0002_MaterialByDivisionPopup).
  //   사용자 지시 2026-10-14: 기존 ElecMaterialPopup → 메1 교체(자매 SCP0013/production-plan 동일 픽커).
  const [openMaterialPopup, setOpenMaterialPopup] = useState(false);
  // Measure 설정 팝업(사용자 지시 2026-10-15) — 자매 SCP0100 패턴. MEASURE_SELECT 버튼 권한 시 노출.
  const [openMeasurePopup, setOpenMeasurePopup] = useState(false);
  // Prod Plan (Engine) 드릴다운 → SCP0013 모달(사용자 지시 2026-10-15, AS-IS openSubMenu 파리티).
  const [drilldownParams, setDrilldownParams] = useState<DrilldownParams | null>(null);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const sc = useGlobalPsiElecStore(s => s.searchCondition);
  const set = useGlobalPsiElecStore(s => s.setSearchCondition);
  const filters = useGlobalPsiElecStore(s => s.filters);
  const setFilter = useGlobalPsiElecStore(s => s.setFilter);
  const clearFilters = useGlobalPsiElecStore(s => s.clearFilters);
  const openSearchArea = useGlobalPsiElecStore(s => s.openSearchArea);
  const setOpenSearchArea = useGlobalPsiElecStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useGlobalPsiElecStore(s => s.fetchStaticColumns);
  const staticColumns = useGlobalPsiElecStore(s => s.staticColumns);
  const staticMeasures = useGlobalPsiElecStore(s => s.staticMeasures);
  const fetchStaticMeasures = useGlobalPsiElecStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useGlobalPsiElecStore(s => s.restoreSearchConditions);

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
  // 필수: filters 는 useMemo 로 참조 고정 — useTabProcQuery 가 filters 를 참조비교로 재조회 판정하므로
  //   렌더 본문 객체 리터럴을 넘기면 매 렌더 새 참조 → 무한 refetch 루프(SCP0031/SCP0100 동일 선례).
  // 그리드 3단 헤더(calendar)는 **조회 확정(setFilter) 시점의 Period** 로만 생성한다. 직전 구현은 live
  //   searchCondition(sc.from/toYyyymmdd)을 읽어, 조회 전에 Period 를 타이핑하기만 해도 헤더가 재생성됐다
  //   (사용자 지적 2026-11-18). 메인 데이터와 동일하게 applied filters[MAIN] 의 기간을 쓴다.
  const appliedFrom = filters[SHEETS.MAIN]?.fromYyyymmdd ?? '';
  const appliedTo = filters[SHEETS.MAIN]?.toYyyymmdd ?? '';
  const calendarFilters = useMemo(
    () => ({ startYyyymmdd: appliedFrom, endYyyymmdd: appliedTo }),
    [appliedFrom, appliedTo]
  );
  const calendarQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: calendarFilters,
    enabled: !!appliedFrom && !!appliedTo,
  });
  const calendarRows = useMemo<Record<string, unknown>[]>(
    () => (calendarQuery.data as { o_rc1?: Record<string, unknown>[] })?.o_rc1 ?? [],
    [calendarQuery.data]
  );

  // mount — keep-alive 탭에 남은 stale filters 자동발사 차단(clearFilters) + admin 동적 메타 fetch(mount 1회).
  //   F6 저장 조회조건 복원도 mount 1회(conditionsRestored 가드). 새로고침 시 새 store → 재복원(scp-bom 파리티).
  useEffect(() => {
    void restoreSearchConditions();
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 필수값 검증(design 02 §4) — Division*/Plan-date* + Period(from~to) 유효성. 미충족 시 조회 차단.
  const validateRequired = (): boolean => {
    if (
      !sc.divisionId.trim() ||
      !sc.planStartYyyymmdd.trim() ||
      !sc.planType.trim() ||
      !sc.fromYyyymmdd.trim() ||
      !sc.toYyyymmdd.trim()
    ) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_CONDITION, '_Please enter the required fields.'),
      });
      return false;
    }
    // 기간 역전(종료일 < 시작일) 차단(사용자 지적 2026-11-18) — 역전 시 조회 금지. 위 필수검증을 통과했으므로
    //   from/to 는 비어 있지 않다(YYYYMMDD 숫자 비교). AS-IS Check_PeriodDate from>to 가드 등가.
    if (Number(sc.toYyyymmdd) < Number(sc.fromYyyymmdd)) {
      void useMessageStore.getState().setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_ORDER, '_The start date can not be later than the end date.'),
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
  //   더블클릭 → SCP0013 모달 오픈(사용자 지시 2026-10-15, AS-IS openSubMenu 파리티). AS-IS 5조건을 현재행·조회조건
  //   에서 수집해 모달 임베드 SCP0013 에 seeding 한다(cs L842~846): division=조회조건 / operationGroup='E' /
  //   plantSite=현재행 TO_SITE / itemId=현재행 ELEC_MODEL / planDate=조회조건 Plan-date.
  const handleCellDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return; // 가드1 — 헤더/푸터 무시
    const binding = g.columns[ht.col]?.binding ?? '';
    if (binding !== DRILLDOWN.TRIGGER_COLUMN) return; // 가드2 — MEASURE_NAME 열만
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row || s(row.MEASURE_NAME) !== DRILLDOWN.TRIGGER_MEASURE) return; // 가드3 — Prod Plan (Engine) 행만
    if (!findMenuPath(DRILLDOWN.TARGET_MENU)) return; // SCP0013 메뉴 권한 없으면 미오픈(AS-IS openSubMenu 권한 동등)
    setDrilldownParams({
      divisionId: sc.divisionId,
      plantSiteId: s(row.TO_SITE),
      itemId: s(row.ELEC_MODEL),
      nickName: s(row.NICK_NAME),
      planStartYyyymmdd: sc.planStartYyyymmdd,
    });
  };

  // SCP0013 드릴다운 모달 제목 — 메뉴 메타(findMenuPath 의 말단 = SCP0013)에서 해석해 페이지·브레드크럼과 동일
  //   문자열(t(mnuMsgId, mnuDesc))로 맞춘다. 메뉴 미보유 계정은 핸들러 가드로 모달이 안 열리므로 폴백은 화면ID.
  const drilldownTitle = useMemo(() => {
    const path = findMenuPath(DRILLDOWN.TARGET_MENU);
    const menu = path?.[path.length - 1];
    return menu ? t(menu.mnuMsgId, menu.mnuDesc || DRILLDOWN.TARGET_MENU) : DRILLDOWN.TARGET_MENU;
  }, [findMenuPath, t]);

  // Measure 설정 커스텀버튼(사용자 지시 2026-10-15) — 자매 SCP0100 btnMeasure 동형. MNU_BTN MEASURE_SELECT 권한 시
  //   icon-only 노출(표준 7버튼 밖 팝업이라 hotkey 공통집합과 별개). 클릭 → MeasureSelectModal.
  const customButtons = hasButton('MEASURE_SELECT')
    ? [
        {
          label: t(LBL.MEASURE, 'Measure'),
          title: t(LBL.MEASURE, 'Measure'),
          action: () => setOpenMeasurePopup(true),
          iconComponent: <IcMeasureSelect />,
          buttonLabel: '',
        },
      ]
    : [];

  // Measure 선택 저장 — titleSet 'M' 영구저장(sheetName='Global PSI Elec' 3점 일치). 저장 성공 시
  //   ① measure 메타 refetch(팝업 재진입 복원) + ② 메인 쿼리 invalidate 로 그리드 즉시 재조회.
  //   메인 SP(PKG_SCP0095)가 조회 시점에 SCM_MST_TITLESET_USER 를 읽어 USER_FLAG='Y' measure 만(+SUM) 반환하므로,
  //   invalidate 없이는 다음 수동 Search 때까지 그리드가 안 바뀐다(자매 SCP0100 Column 저장과 동일 invalidate 패턴).
  const handleMeasureApply = (codes: string[] | null) => {
    const all = staticMeasures.map(m => m.colNm);
    const selected = codes ?? all;
    void saveTitleSet({
      menuId: MENU_ID,
      sheetName: MEASURE_SHEET_NAME,
      columnType: TITLESET_MEASURE_TYPE,
      rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
    }).then(ok => {
      if (!ok) {
        void useMessageStore
          .getState()
          .setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
        return;
      }
      void fetchStaticMeasures();
      // 활성 조회가 있으면 메인 SP 를 재실행 → 저장된 measure 선택이 그리드에 즉시 반영(조회 안 했으면 no-op).
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    });
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <GlobalPsiElecForm onSearch={handleSearch} onMaterialSearch={() => setOpenMaterialPopup(true)} />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='GlobalPsiElec'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
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

      {/* Material 팝업 — 메1 MaterialByDivisionModal(COM0013). 반환 ITEM_ID(csv) → searchCondition.itemId.
          취소 시 기존값 유지(setSelectedValue 미호출). EE division 매핑(EE→81,82,40)은 모달 내부 처리.
          preSearchParams = { divisionId, operationGroup(빈값), scpModuleType=화면ID, itemId(초기검색어) }. */}
      <MaterialByDivisionModal
        open={openMaterialPopup}
        modalClose={() => setOpenMaterialPopup(false)}
        setSelectedValue={items => set({ itemId: items })}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: sc.itemId,
        }}
      />

      {/* Measure 설정 팝업 — 공용 MeasureSelectModal(자매 SCP0100 동형). titleSet 'M' 저장 후 measure 메타 refetch.
          read-only 화면이라 visibleMeasures 로컬 상태 미보유 — null(전체 표시)로 진입, Default 는 defaultFlag 복원. */}
      <MeasureSelectModal
        open={openMeasurePopup}
        modalClose={() => setOpenMeasurePopup(false)}
        measures={staticMeasures}
        visibleMeasures={null}
        onApply={handleMeasureApply}
      />

      {/* Prod Plan (Engine) 드릴다운 — SCP0013(production-plan-line) 모달 임베드(AS-IS openSubMenu 파리티).
          닫히면 임베드 언마운트(무거운 cascade 화면 — 열릴 때만 생성). 5조건 seeding 은 모달 내부 Seeder 가 담당. */}
      <GlobalPsiElecDrilldownModal
        open={!!drilldownParams}
        onClose={() => setDrilldownParams(null)}
        params={drilldownParams}
        title={drilldownTitle}
      />
    </>
  );
};
