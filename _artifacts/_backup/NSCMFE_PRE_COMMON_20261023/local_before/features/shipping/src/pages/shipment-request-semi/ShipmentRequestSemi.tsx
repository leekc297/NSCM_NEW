import { CellRange, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ModelByDivisionPopup } from 'features/master/src/components';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, GridUtils, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { BodItemRouteModal } from './components/modals/BodItemRouteModal';
import { ShipmentRequestSemiForm } from './components/ShipmentRequestSemiForm';
import { ShipmentRequestSemiGrid } from './components/ShipmentRequestSemiGrid';
import { useShipmentRequestSemiSave } from './hooks/useShipmentRequestSemiSave';
import { useShipmentRequestSemiValidation } from './hooks/useShipmentRequestSemiValidation';
import {
  BOD_FILL_MAP,
  COLUMN,
  EDITABLE_MEASURE,
  LBL,
  MENU_ID,
  MODEL_DEPENDENT_CLEAR_COLUMNS,
  MSG,
  NEW_ROW_MEASURE_LABEL,
  SHEETS,
} from './shipment-request-semi.constants';
import type {
  BodItemRow,
  CalendarSpanRow,
  ShipmentRequestRow,
} from './shipment-request-semi.types';
import { useShipmentRequestSemiStore } from './useShipmentRequestSemiStore';
import {
  applyBohSumValues,
  resolvePivotCols,
} from './utils/shipmentRequestSemi.columns';
import { isPivotBinding } from './utils/shipmentRequestSemi.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0045_ShipmentRequest — 반제품(SEMI) 출하요청.
//   설계: .atlas/gscm-design/SSP0045/design/00~03. 상세 매핑: __asis-mapping__.md.
//   이 화면의 특이점 4가지:
//     · Insert(F8) = **명시적 NO-OP**. AS-IS override 본문이 주석 1줄뿐이다(K6) — 버튼은 보이되 아무 일도 없다.
//     · Edit 모드토글 미이식(`asis_to_tobe.md §11`) — 단 **실질 잠금범위는 보존**한다(editLock util).
//     · Delete 는 신규행('I')만 hard remove. 기존행은 **무동작(메시지도 없음)** — SAVE SP 에 DELETE 경로가 없다(K7).
//     · 저장은 **셀 단위** 수집. 행 단위로 전 기간을 보내면 `_H` 이력이 오염된다(K9).
export const ShipmentRequestSemi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSearch } = useShipmentRequestSemiValidation();

  const gridRef = useRef<FlexGrid>(undefined);
  const gridFilterRef = useRef<FlexGridFilter | undefined>(undefined);
  const editTrackerRef = useRef<EditTracker | undefined>(undefined);

  const [modelPopupOpen, setModelPopupOpen] = useState(false);
  const [bodPopupRow, setBodPopupRow] = useState<ShipmentRequestRow | null>(null);
  // R13 / S37 — 저장 시 음수로 판정된 셀(행 객체 → binding 집합). 그리드가 배경으로 표시한다.
  const [negativeCells, setNegativeCells] = useState<ReadonlyMap<object, ReadonlySet<string>>>(
    new Map()
  );

  const sc = useShipmentRequestSemiStore(s => s.searchCondition);
  const set = useShipmentRequestSemiStore(s => s.setSearchCondition);
  const filters = useShipmentRequestSemiStore(s => s.filters);
  const setFilter = useShipmentRequestSemiStore(s => s.setFilter);
  const clearFilters = useShipmentRequestSemiStore(s => s.clearFilters);
  const hasSearched = useShipmentRequestSemiStore(s => s.hasSearched);
  const setHasSearched = useShipmentRequestSemiStore(s => s.setHasSearched);
  const openSearchArea = useShipmentRequestSemiStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentRequestSemiStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentRequestSemiStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentRequestSemiStore(s => s.fetchStaticColumns);
  const fetchPopupColumns = useShipmentRequestSemiStore(s => s.fetchPopupColumns);
  const restoreSearchConditions = useShipmentRequestSemiStore(s => s.restoreSearchConditions);
  const divisionAuthLoaded = useShipmentRequestSemiStore(s => s.divisionAuthLoaded);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — mount 시 clearFilters() 로 keep-alive 잔여 filters 를 무효화한다(nscm-patterns §5-7).
  useEffect(() => {
    clearFilters();
    setHasSearched(false);
    void fetchStaticColumns();
    void fetchPopupColumns();
    // F6 저장 조회조건 복원(1회) — searchCondition 만 패치하므로 filters 불변 → 진입 자동조회 아님.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Division 변경 = 그리드 초기화 의무(nscm-patterns §5-5). 이전 division 의 결과·신규행·편집추적을 비운다.
  //   재조회는 Search 로만 한다. 초기 마운트는 제외(prevDivisionRef 가드).
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === sc.divisionId) return;
    prevDivisionRef.current = sc.divisionId;
    editTrackerRef.current?.clearChanges();
    clearFilters();
    setHasSearched(false);
    void fetchStaticColumns();
    void fetchPopupColumns();
  }, [sc.divisionId, clearFilters, setHasSearched, fetchStaticColumns, fetchPopupColumns]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 3단 헤더 메타 — 조회 기간이 곧 컬럼셋이다(기간이 바뀌면 컬럼이 통째로 재구성된다, design 03 §2.1).
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: hasSearched && !!filters[SHEETS.CALENDAR],
  });

  const calendarRows = useMemo(
    () => ((calendarData as { o_rc1?: CalendarSpanRow[] })?.o_rc1 ?? []),
    [calendarData]
  );

  const rawRows = useMemo<ShipmentRequestRow[]>(
    () => ((data as { o_rc1?: ShipmentRequestRow[] })?.o_rc1 ?? []),
    [data]
  );

  // 동적 기간칼럼 메타 — **이 화면에서 유일한 산출 지점**이다(K2 "판정 1벌").
  //   그리드는 이 값을 prop 으로 받아 쓴다. 두 곳에서 각자 판정하면 CALENDAR SP 가 접두 없는
  //   COLUMN_NAME 을 돌려줄 때 아래 `applyBohSumValues` 만 무동작하는 잠복 결함이 난다(iter-3 N-09).
  const pivotCols = useMemo(() => resolvePivotCols(calendarRows, rawRows), [calendarRows, rawRows]);

  // 조회 후처리 — R16(BOH SUM 값 치환)은 **바인딩 전에** 적용해야 한다(AS-IS cs:611-612 순서).
  //   행 객체를 제자리 변환하고 배열 참조는 유지한다(CollectionView 재생성 방지, nscm-patterns §5-4).
  const rows = useMemo<ShipmentRequestRow[]>(() => {
    applyBohSumValues(rawRows, pivotCols);
    return rawRows;
  }, [rawRows, pivotCols]);

  // 조회 응답이 갱신되면 편집 추적을 비운다(조회 직후는 항상 읽기전용으로 착지 — L-E).
  useEffect(() => {
    editTrackerRef.current?.clearChanges();
  }, [data]);

  // 저장(EP02 / R12 / G05) — 가드·수집·payload·응답 3분기는 전용 훅이 소유한다.
  //   `onSaved` 의 `refetch()` 는 filters 가 불변인 저장 후 경로라 허용된다(nscm-patterns §5-1 예외).
  const { handleSave } = useShipmentRequestSemiSave({
    gridRef,
    editTrackerRef,
    staticColumns,
    onSaved: () => void refetch(),
    onNegativeCells: cells =>
      setNegativeCells(
        cells.reduce<Map<object, Set<string>>>((acc, cell) => {
          const bindings = acc.get(cell.row) ?? new Set<string>();
          bindings.add(cell.binding);
          return acc.set(cell.row, bindings);
        }, new Map())
      ),
  });

  // ── 조회(EP01 / R06) — setFilter 참조 교체만. refetch() 직접 호출 금지(nscm-patterns §5-1) ──
  const handleSearch = () => {
    if (!divisionAuthLoaded) return; // 권한 콤보 미도착 상태의 발사 차단
    if (
      !validateSearch(sc, {
        division: t(LBL.DIVISION, '_Div'),
        operationGroup: t(LBL.OPERATION_GROUP, '_Operation group'),
      })
    ) {
      return;
    }
    setFilter();
    setHasSearched(true);
    void fetchStaticColumns(); // 컬럼 메타는 mount + 매 Search 마다 refetch(CLAUDE.md §2 체크3)
    // 팝업 컬럼 메타도 같은 지점에서 함께 되살린다. F10(Reset Condition)은 페이지 스토어 reset() 으로
    //   `popupColumns` 를 비우는데, 공용 `PRESERVED_ON_CONDITION_RESET` 보존 목록에 없는 화면 로컬 키라
    //   되돌아오지 않는다 — mount effect 한 곳에서만 부르면 F10 이후 BOD 팝업 컬럼이 'No' 하나만
    //   남는다(react-gap-audit iter-2 M-01).
    void fetchPopupColumns();
  };

  // ── 삭제(EP05 / R11 / R17) ──
  //   BG07 선택 행 없으면 무동작 → `CRUD_TYPE!=='I'` 이면 **무동작(메시지 없음)** → 'I' 면 즉시 제거.
  //   금지: 기존행 `CRUD_TYPE='D'` 마킹(AS-IS·SP04 둘 다 삭제 경로가 없다) / 임의 alert 추가.
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const anchorRow = grid.selection.row;
    const row = GridUtils.getRow(grid, anchorRow) as ShipmentRequestRow | undefined;
    if (!row) return; // BG07 — 선택 행이 없으면 무동작
    if (str(row.CRUD_TYPE) !== CRUD_TYPE.INSERT) return;
    // AS-IS DeleteButton 은 `ActiveRow` 1건만 지운다. 공용 `GridAction.removeRow` 는
    //   `GridUtils.getSelectedRows`(= grid.selectedRows, 다중)를 지우므로 여러 'I' 행을 범위 선택한
    //   상태에서 F9 를 누르면 AS-IS 보다 많이 지워진다 — 앵커 셀로 선택을 좁혀 1건으로 맞춘다.
    grid.select(new CellRange(anchorRow, grid.selection.col), false);
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  // ── Model 픽커(PU03) — 반환 ItemID 가 **공백이 아닐 때만** 반영한다(취소 시 기존 입력 보존, cs:1197) ──
  const handleModelSelected = (selected: { itemId: string }) => {
    if (!selected.itemId) return;
    set({ itemId: selected.itemId });
  };

  // ── BOD 팝업(PU04) 확정 — AS-IS 반영 순서 그대로(R09·R10·R12 / L13·L14) ──
  //   ① 첫 건은 클릭한 행에, 2건째부터 행 생성(기본값 3종) → ② 8칸 대입 → ③ 기간셀 null 클리어
  //   → ④ 구간 개방은 editLock 이 BOD_FROM/TO·FROZEN 으로 즉시 재판정한다(별도 lock 조작 불필요).
  //   ③ 을 빠뜨리면 이전 BOD 구간 수량이 남아 저장된다(조용한 데이터 오염) — 반드시 수행한다.
  const handleBodSelected = (picked: BodItemRow[]) => {
    const grid = gridRef.current;
    const target = bodPopupRow;
    if (!grid || !target || picked.length === 0) return;

    // ③ 의 클리어 대상 — **가시 컬럼이 아니라 기간칼럼 전체**다.
    //   `grid.columns` 로 뽑으면 Weekly/Monthly 버킷에서 `D_` 컬럼이 아예 생성되지 않으므로
    //   (`buildPivotColumns` 가 `isVisible` 로 걸러 그룹을 만들지 않는다) 한 칸도 지우지 못한다.
    //   그런데 저장 수집부(`collectSaveCells` → `Object.keys(row).filter(isDayBinding)`)는 가시성과
    //   무관하게 행 객체의 모든 `D_` 키를 담으므로, 이전 BOD 구간 수량이 그대로 payload 에 실려
    //   조용한 데이터 오염이 된다(iter-3 N-03). AS-IS cs:1295 도 `MEASURE+1 ~ ColumnCount-1` 을
    //   **컬럼 인덱스 범위**로 지워 숨김 여부를 보지 않는다.
    //   필수: 저장 수집부와 **같은 집합**을 쓴다 — 행 객체의 키 ∪ 기간칼럼 메타 전체.
    const metaBindings = pivotCols.map(c => c.binding).filter(isPivotBinding);

    const applyTo = (row: ShipmentRequestRow, bod: BodItemRow) => {
      const targets = new Set<string>(metaBindings);
      Object.keys(row).filter(isPivotBinding).forEach(binding => targets.add(binding));
      targets.forEach(binding => {
        row[binding] = null;
      });
      // ② BOD 파생 8칸 대입.
      Object.entries(BOD_FILL_MAP).forEach(([column, prop]) => {
        row[column] = str(bod[prop]);
      });
      // 편집구간 판정 입력 — 팝업이 BOD 기간을 함께 주면 그대로 쓴다(L-D' 3케이스가 실제로 갈린다).
      if (bod.C_BOD_FROM_YYYYMMDD !== undefined) {
        row[COLUMN.BOD_FROM_YYYYMMDD] = str(bod.C_BOD_FROM_YYYYMMDD);
      }
      if (bod.C_BOD_TO_YYYYMMDD !== undefined) {
        row[COLUMN.BOD_TO_YYYYMMDD] = str(bod.C_BOD_TO_YYYYMMDD);
      }
    };

    applyTo(target, picked[0]);
    // ① 2건째부터 새 행 — 기본값 3종의 division 은 **확정 `filters`** 기준이다
    //   (CommonCheckList "Insert 시 확정 searchParams 기준 division"). 입력 중인 `searchCondition` 을
    //   쓰면 조회 후 콤보만 바꾼 상태에서 만든 신규행이 화면 데이터와 다른 division 으로 저장된다.
    //   확정값이 없으면(미조회) 행을 만들지 않는다 — 조회 전 삽입 차단(convert-core §2.4).
    const confirmedDivision = str(filters[SHEETS.MAIN]?.divisionId);
    picked.slice(1).forEach(bod => {
      if (!confirmedDivision) return;
      const added = GridAction.addRow(grid, {
        CRUD_TYPE: CRUD_TYPE.INSERT,
        [COLUMN.DIVISION_ID]: confirmedDivision,
        [COLUMN.MEASURE]: EDITABLE_MEASURE,
        [COLUMN.MEASURE_LABEL]: NEW_ROW_MEASURE_LABEL,
      } as unknown as Partial<WijmoRowItem>) as unknown as ShipmentRequestRow | undefined;
      if (added) applyTo(added, bod);
    });
    grid.invalidate();
  };

  // ── Model(ITEM_ID) 재선택 → 종속 5칸 클리어 + `BOD_ID` 비움으로 자동 재잠금(R11 / L15) ──
  //   AS-IS 는 `FROZEN_YYYYMMDD` 를 지우지 않는다(U4) — 목록에 넣지 않는다.
  //   AS-IS L15 의 시작열(`MEASURE`)은 L13(`MEASURE+1`)과 1칸 다르다(Q5) — TO-BE 는 "BOD_ID 를 비워
  //   재잠금" 으로 등가 구현하고 그 차이를 04 리포트에 기록한다.
  const handleModelChanged = useCallback((row: ShipmentRequestRow) => {
    MODEL_DEPENDENT_CLEAR_COLUMNS.forEach(column => {
      row[column] = '';
    });
    row[COLUMN.BOD_ID] = '';
    gridRef.current?.invalidate();
  }, []);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    // AS-IS InsertButton(cs:530-533) = NO-OP(본문이 주석뿐). 버튼은 노출하되 아무 일도 하지 않는다.
    //   금지: `false`(버튼 숨김) / 키 생략(공용 SubTitle 기본 `GridAction.addRow` 가 부활해 실제로 행이 추가된다).
    //   권한 게이트(`hasButton('INSERT')`)도 **곱하지 않는다** — 메타 미등록 시 false 가 되어 버튼이 사라진다.
    insert: () => undefined,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
    // EXCEL — admin 권한 게이트를 곱한다(CLAUDE.md §2 체크3 / iter-3 N-07).
    //   AS-IS `toolbarOverride`(cs:334-339)에 Excel 항목이 없고 `SCM_ADM_MNU_BTN_MPG_M` 실측도
    //   SEARCH(main/calendar/bodPopup)·SAVE(main)·DELETE(main) **5행뿐 = EXCEL 미등록**이다.
    //   키를 생략하면 공용 SubTitle 기본 액션이 살아 **무조건 노출**되므로(= admin 에서 끈 버튼이
    //   화면에 남는 SCM0008 유형) 미등록 상태에서는 `false` 로 숨긴다. 업무가 엑셀 다운로드를
    //   원하면 05_register.sql 에 EXCEL 을 등록하는 것만으로 이 줄이 자동 노출로 바뀐다.
    excel: hasButton('EXCEL') ? undefined : false,
    // sort(F3)/filter(F4)/condition(F6)/resetCondition(F10) 은 생략 → 공용 기본동작 사용.
    // edit: AS-IS EditButton 모드토글은 미이식(asis_to_tobe.md §11) — HotkeyConfig 에 키 자체가 없다.
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {/* 접기는 `SearchArea isHidden` 한 축으로만 제어한다 — 조건부 언마운트를 겹치면 토글마다
          콤보 쿼리가 재마운트되고 isHidden 경로가 도달하지 않는다(react-gap-audit iter-1 G-22). */}
      <ShipmentRequestSemiForm
        onSearch={handleSearch}
        onModelSearch={() => setModelPopupOpen(true)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentRequestSemi'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      <ShipmentRequestSemiGrid
        rows={rows}
        pivotCols={pivotCols}
        adminColumns={staticColumns}
        bucketType={sc.bucketType}
        showSum={sc.showSum}
        startPeriod={sc.fromYyyymmdd}
        divisionId={sc.divisionId}
        operationGroup={sc.operationGroup}
        negativeCells={negativeCells}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        onBodCellClick={setBodPopupRow}
        onModelRequired={() =>
          void setAlert({
            type: 'alert',
            content: t(MSG.SELECT_FIRST, '_First, select {0}.').replace(
              '{0}',
              t(LBL.MODEL, '_Model')
            ),
          })
        }
        onModelChanged={handleModelChanged}
        onFocus={() => undefined}
      />

      {/* PU03 Model 픽커 — AS-IS `SCM0002_ItembyDivisionPopup` 의 TO-BE 1:1 대응(design 02 §4.6).
          `ItemByDivisionModal`(COM0008)·`MaterialByDivisionModal` 은 SP 가 달라 재사용 금지. */}
      <ModelByDivisionPopup
        open={modelPopupOpen}
        onClose={() => setModelPopupOpen(false)}
        onSelect={handleModelSelected}
        params={{
          divisionId: sc.divisionId,
          projectCode: '',
          scmSiteId: '',
          itemId: sc.itemId,
        }}
      />

      {/* PU04 BOD 팝업 — 신규행 TR_MODE 셀 클릭 진입(가드는 그리드가 선처리). */}
      <BodItemRouteModal
        open={!!bodPopupRow}
        modalClose={() => setBodPopupRow(null)}
        setSelectedValue={handleBodSelected}
        preSearchParams={{
          divisionId: sc.divisionId,
          operationGroup: sc.operationGroup,
          itemId: str(bodPopupRow?.[COLUMN.ITEM_ID]),
          fromYyyymmdd: sc.fromYyyymmdd,
        }}
      />
    </>
  );
};
