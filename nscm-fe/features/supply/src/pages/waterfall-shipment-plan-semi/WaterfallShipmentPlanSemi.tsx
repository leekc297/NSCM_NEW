import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, saveTitleSet, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { WaterfallShipmentPlanSemiForm } from './components/WaterfallShipmentPlanSemiForm';
import { WaterfallShipmentPlanSemiGrid } from './components/WaterfallShipmentPlanSemiGrid';
import { useWaterfallShipmentPlanSemiStore } from './useWaterfallShipmentPlanSemiStore';
import { BUCKET_TYPE, LBL, MENU_ID, MSG, SHEETS } from './waterfall-shipment-plan-semi.constants';
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
  const visibleMeasures = useWaterfallShipmentPlanSemiStore(state => state.visibleMeasures);
  const applyVisibleMeasures = useWaterfallShipmentPlanSemiStore(state => state.applyVisibleMeasures);
  // F6 저장조건 복원(진입 1회, basic-check #3) — SubTitle searchParam 저장분을 searchParams 로 되살린다.
  const restoreSearchConditions = useWaterfallShipmentPlanSemiStore(state => state.restoreSearchConditions);

  const [measureModalOpen, setMeasureModalOpen] = useState(false);

  // p_sheet_name 파생값 — OperationGroup=='A' ? 'CELL' : 'ELECTRODE' (§4.2, 고정값 전달 금지).
  const sheetName = searchParams.operationGroup === 'A' ? 'CELL' : 'ELECTRODE';

  // Bucket=Only Weekly 는 캘린더 헤더를 ISO 전용 proc(연속 ISO 주차 + 날짜범위 MMDD)으로 받는다
  //   — AS-IS 가 WeeklyISO 일 때만 SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO 를 호출하는 것과 등가(cs:992).
  //   그 외 버킷은 NotISO spreadTitle 사용. 둘 중 bucket 에 맞는 쿼리만 enable 한다.
  const isWeeklyIso = searchParams.bucket === BUCKET_TYPE.WEEKLY_ISO;

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
    enabled: !!filters[SHEETS.SPREAD_TITLE] && !isWeeklyIso,
  });
  const titleIsoQuery = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE_ISO>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE_ISO,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE_ISO],
    enabled: !!filters[SHEETS.SPREAD_TITLE_ISO] && isWeeklyIso,
  });

  const data = (mainQuery.data?.o_rc1 ?? EMPTY_ROWS) as WaterfallRow[];
  const spreadTitle = ((isWeeklyIso ? titleIsoQuery.data?.o_rc1 : titleQuery.data?.o_rc1) ??
    EMPTY_ROWS) as SpreadTitleRow[];

  // Measure 팝업(MeasureSelectModal) 결과로 measure 행 필터(03_grid-columns.md §4.3, 1행=1 measure).
  //   visibleMeasures=null = 전체. 모달 목록(staticMeasures)에 없는 SP 파생 measure 는 항상 표시(면제 규칙,
  //   자매 SCP0016 waterfall-shipment-plan-fg 파리티). Division 변경/reset 시 store 가 null 로 되돌린다.
  const selectableMeasures = useMemo(() => new Set(staticMeasures.map(m => m.colNm)), [staticMeasures]);
  const visibleData = useMemo<WaterfallRow[]>(() => {
    if (visibleMeasures == null) return data;
    return data.filter(row => {
      const measure = String(row.MEASURE ?? '');
      if (!selectableMeasures.has(measure)) return true; // 파생 measure = 필터 면제
      return visibleMeasures.includes(measure);
    });
  }, [data, visibleMeasures, selectableMeasures]);

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

  // F6 저장조건 복원(진입 1회, basic-check #3) — 저장은 SubTitle searchParam, 복원은 여기서 배선.
  //   store 내부 conditionsRestored 가드로 1회만 수행된다(자동 재조회는 하지 않음 — 조건만 주입).
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // Division 변경 시 검색조건 초기화 + 그리드 초기화는 store setDivision(Form onChange)이 수행한다
  //   (TO-BE 공통 요건, SCP0025 선례). clearData 는 Measure 모달 적용 시 재조회 유도로만 쓴다.

  // FindData_Main 이중 필수값 체크 재현 — Division/Version/Period 최소 필수(§6#7).
  //   필수검증을 session 가드보다 먼저 수행해 미입력 시 반드시 알럿(MSG00013)이 뜨게 한다.
  //   Version 은 'ALL' sentinel(allOption 구버전 persist 잔존 가능)을 미선택으로 간주해 거른다
  //   — AS-IS Version 은 addAll=false 라 ALL 이 유효값이 아니다(선택 강제).
  const handleSubmit = () => {
    const selectedVersions = searchParams.versionNos.filter(v => v && v.toUpperCase() !== 'ALL');
    if (
      !searchParams.divisionId ||
      selectedVersions.length === 0 ||
      !searchParams.startYyyymmdd ||
      !searchParams.endYyyymmdd
    ) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_INPUT, '_Please enter the required fields.') });
      return;
    }
    if (!session.userId) return;
    setFilters({ userId: session.userId });
  };

  // 읽기 전용 화면이라 편집 버튼(Add Row/Insert·Delete·Save)을 전부 숨긴다(사용자 지시 2026-10-26 —
  //   AS-IS 는 Delete/Save 를 NO-OP 버튼으로 두지만, 읽기 전용이라 노출 불필요하므로 false 로 override).
  //   Insert/Upload/Manual 은 AS-IS 에 해당 컨트롤 자체가 없어(§1) 원래 false.
  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    insert: false,
    delete: false,
    save: false,
    upload: false,
    manual: false,
  };

  // 읽기 전용이라 Edit 버튼(AS-IS 트리거H, NO-OP+MSG00109)도 숨긴다(사용자 지시 2026-10-26).
  //   주의: 이 버튼은 LBL00109 로 라벨링했는데 DB 실측상 LBL00109="Add Row"(=Edit 아님)라 화면엔 "Add Row"
  //   로 보였다 — 읽기 전용 화면에 add-row 로 오인될 버튼이라 제거가 맞다.
  const customButtons = [
    {
      label: t(LBL.MEASURE, 'Measure'),
      title: t(LBL.MEASURE, 'Measure'),
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
      <WaterfallShipmentPlanSemiForm onSubmit={handleSubmit} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={visibleData.length}
        excelFileName='WaterfallShipmentPlanSemi'
        useHotkey={true}
        searchParam={searchParams}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <WaterfallShipmentPlanSemiGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={visibleData}
        spreadTitle={spreadTitle}
      />

      {/* btnMeasure — SCM0002_TitleSetForm_Popup(SCP0018, measureType) 대응(02_search-combo.md §4.6). */}
      <MeasureSelectModal
        open={measureModalOpen}
        modalClose={() => setMeasureModalOpen(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          const all = staticMeasures.map(m => m.colNm);
          const selected = codes ?? all;
          applyVisibleMeasures(codes); // 클라 즉시 반영(그리드 행 필터 + 팝업 재진입 상태 유지)
          // 공용 saveTitleSet(/admin/menu/{menuId}/titleset) — 메뉴 독립 고정 엔드포인트. 화면별
          //   call-proc 경로는 SCM_ADM_MNU_BTN_MPG_M 미등록 화면에서 403(No Permission) 난다(자매 SCP0016
          //   파리티·titleSetApi 주석). sheetName 은 measure 시트명(CELL/ELECTRODE) — 조회와 일치해야 복원됨.
          void saveTitleSet({
            menuId: MENU_ID,
            sheetName,
            columnType: 'M',
            rows: selected.map((name, i) => ({ name, sortOrderNo: i + 1 })),
          });
          clearData();
        }}
      />
    </>
  );
};
