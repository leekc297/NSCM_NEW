// 같은 feature(supply) 밖의 공용 팝업 — baseUrl 기준 비상대 경로(상대경로 import 금지, Top11 #1).
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { NoWorkBatchModal } from './components/modals/NoWorkBatchModal';
import { NoWorkExcelUploadModal } from './components/modals/NoWorkExcelUploadModal';
import { OptCapaForm } from './components/OptCapaForm';
import { OptCapaGrid } from './components/OptCapaGrid';
import { useOptCapaActions } from './hooks/useOptCapaActions';
import { useOptCapaSheets } from './hooks/useOptCapaSheets';
// `SHEETS` 는 `useTabProcQuery` 제네릭 인자에만 쓰여 type-only import 다(no-import-type-side-effects).
import type { SHEETS } from './opt-capa.constants';
import {
  EXCEL_FILE_NAME,
  GRID_SHEETS,
  MENU_ID,
  SHEET_LABEL,
  type GridSheet,
} from './opt-capa.constants';
import type { GridRow } from './opt-capa.types';
import styles from './OptCapa.module.scss';
import { useOptCapaStore } from './useOptCapaStore';
import { str } from './utils/optCapa.candidates';

/**
 * 시트별 ref 저장소 — 8탭 각각의 `DataGrid` 인스턴스를 따로 가리킨다.
 *
 * `TabWrapper persist` 는 비활성 탭을 언마운트하지 않고 children 전건을 **동시 렌더**하므로
 * (`Tab.tsx:76-86`), ref 를 하나만 만들어 8개 `DataGrid` 에 넘기면 `DataGrid.handleInitialized`
 * (`DataGrid.tsx:1091`)가 layout 단계에서 8번 덮어써 **마지막 탭 grid 만** 남는다. 그러면 편집
 * override·저장·Insert/Delete·엑셀이 보이지 않는 그리드에 걸려 전부 조용히 어긋난다
 * (메모리 `tabwrapper-persist-shared-gridref`). 자매 `capa-line-assign` 은 탭 2개라 ref 2개를
 * 직접 선언했고(`CapaLineAssign.tsx:124-125`), 이 화면은 8탭이라 `Record` 로 만든다.
 */
const createSheetRefs = <T,>(): Record<GridSheet, MutableRefObject<T | undefined>> =>
  GRID_SHEETS.reduce(
    (acc, sheet) => {
      acc[sheet] = { current: undefined };
      return acc;
    },
    {} as Record<GridSheet, MutableRefObject<T | undefined>>
  );

/**
 * SCP0126 OPT CAPA — AS-IS `GSCM.SCP.Forms.UIL Master/SCP0126_CAPA/SCP0126_CAPA.cs`.
 *
 * 설계: `.atlas/gscm-design/SCP0126/design/00~03` · 계획: `convert-flow/{goal,plan}.md` ·
 * AS-IS 라인 매핑: `__asis-mapping__.md` · 전환 리포트: `design/04_react-gap.md`.
 *
 * 구조 요약
 *   · 8탭 × 그리드 1벌. 컬럼셋은 `staticColumns[activeSheet]`(admin 메타 131행)로 갈린다.
 *   · **탭 전환은 아무것도 조회하지 않는다** — 8탭이 서로 독립된 마스터 테이블이라 공유 컨텍스트가
 *     없다(hook #81 미적용, design 01 §2.3). Search 가 활성 시트 1건만 조회한다.
 *   · 탭 집합은 Division 별 제외목록(`init` `o_rc4`) 파생이다 — 하드코딩 금지(R13·R14).
 *   · 편집모드는 **시트별 독립**이라 탭을 바꿔도 다른 시트 편집상태가 남는다(R16 / L-17).
 *
 * 이 파일은 **렌더·조회 배선·effect 만** 갖는다(진입 Page ≤400라인, design 01 §7 hook #9).
 * 액션 핸들러·툴바 배선은 `hooks/useOptCapaActions.ts`, 조회조건·콤보 파생은
 * `hooks/useOptCapaSheets.ts` 소관이다.
 *
 * 전환 범위 주의: 정본 AS-IS 리비전은 SVN pristine **4,221행**(사용자 판정 D-5)이고 이 구현은
 * **Day 모드 전용**이다. Week bucket 모드(Bucket Type 콤보 · `noWorkWeek` 조회·저장 분기 ·
 * `WEEK_NAME` 편집 + SingleDatePopup · `NO_WORK_TYPE` 셀 콤보)는 설계 재산출 후 **후속 회차**다.
 */
export const OptCapa = ({ tabId, title }: PageProps<MENU_ID>) => {
  const queryClient = useQueryClient();

  // 시트별 ref 8벌 — 단일 ref 공유 금지({@link createSheetRefs} 주석).
  const gridRefs = useRef(createSheetRefs<FlexGrid>()).current;
  const gridFilterRefs = useRef(createSheetRefs<FlexGridFilter>()).current;
  const editTrackerRefs = useRef(createSheetRefs<EditTracker>()).current;

  const sc = useOptCapaStore(s => s.searchParams);
  const filters = useOptCapaStore(s => s.filters);
  const activeSheet = useOptCapaStore(s => s.activeSheet);
  const editMode = useOptCapaStore(s => s.editMode);
  const staticColumns = useOptCapaStore(s => s.staticColumns);
  const openSearchArea = useOptCapaStore(s => s.openSearchArea);
  const setOpenSearchArea = useOptCapaStore(s => s.setOpenSearchArea);
  const clearFilters = useOptCapaStore(s => s.clearFilters);
  const setActiveSheet = useOptCapaStore(s => s.setActiveSheet);
  const setEditMode = useOptCapaStore(s => s.setEditMode);
  const fetchStaticColumns = useOptCapaStore(s => s.fetchStaticColumns);

  const sheets = useOptCapaSheets({
    tabId,
    divisionId: sc.divisionId,
    plantIds: sc.plantIds,
    activeSheet,
  });

  // 활성 탭이 제외 Division 으로 바뀌면 첫 탭으로 폴백한다(R13 / L-13).
  const sheet = sheets.effectiveSheet;
  useEffect(() => {
    if (sheet && sheet !== activeSheet) setActiveSheet(sheet);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sheet]);

  /**
   * SubTitle(엑셀·필터)이 바라보는 ref — **활성 시트 것**이다.
   * 노출 탭이 0건이면 `effectiveSheet` 가 `undefined` 라 store 의 `activeSheet` 로 폴백한다
   * (ref 객체는 8시트 전건 존재하므로 인덱싱이 항상 성립한다).
   */
  const refSheet = sheet ?? activeSheet;

  // ── 그리드 조회 ──────────────────────────────────────────────────────────────────────
  //   비활성 시트는 `filters` 키가 없어 `enabled:false` 로 발사되지 않는다(탭 전환 자동조회 금지).
  const gridQuery = useTabProcQuery<MENU_ID, SHEETS.NO_WORK>({
    menuId: MENU_ID,
    sheetName: refSheet as SHEETS.NO_WORK,
    tabId,
    filters: sheet ? filters[sheet] : undefined,
    enabled: !!sheet && !!filters[sheet],
  });

  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid) 가 무력화된다(§5-4).
  const rows = useMemo<GridRow[]>(
    () => (gridQuery.data?.o_rc1 ?? []) as unknown as GridRow[],
    [gridQuery.data]
  );

  const actions = useOptCapaActions({
    tabId,
    sheet,
    hasDivisionAuth: sheets.hasDivisionAuth,
    visibleSheets: sheets.visibleSheets,
    isFetching: gridQuery.isFetching,
    refetchGrid: () => void gridQuery.refetch?.(),
    gridRefs,
    editTrackerRefs,
  });

  // ── 진입 / 조건 변경 ────────────────────────────────────────────────────────────────
  useEffect(() => {
    // 진입 자동조회 금지 — MDI keep-alive 로 남은 stale filters 무효화(nscm-patterns §5-7).
    clearFilters();
    // 컬럼 메타는 **매 mount** 재조회한다 — persist 로 복원된 값을 1회 가드로 굳히면 admin 메타
    //   변경이 재진입만으로 반영되지 않는다(hook #65, iter-3 감사 G3-17).
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  /**
   * Division / Plan Group / Plant 변경 → 그리드 비움 + 컬럼 메타 재조회.
   * **Line 변경은 비우지 않는다** — AS-IS `clbLine.SelectedIndexChanged` 미배선(V2-16).
   * 컬럼 메타는 `set()` 커밋 뒤 새 division 을 인자로 넘긴다(nscm-patterns §5-5).
   */
  const prevConditionRef = useRef(`${sc.divisionId}|${sc.planGrId}|${sc.plantIds.join(',')}`);
  const prevDivisionRef = useRef(sc.divisionId);
  useEffect(() => {
    const key = `${sc.divisionId}|${sc.planGrId}|${sc.plantIds.join(',')}`;
    if (prevConditionRef.current === key) return;
    prevConditionRef.current = key;
    const divisionChanged = prevDivisionRef.current !== sc.divisionId;
    prevDivisionRef.current = sc.divisionId;
    actions.clearAllTrackers();
    clearFilters();
    if (divisionChanged) {
      void fetchStaticColumns(sc.divisionId);
      // 전역 staleTime=Infinity + IndexedDB 영속이라 같은 조건 재조회가 옛 rows 를 돌려준다(§5-6).
      //
      // 제거 대상은 **그리드 시트 쿼리로 한정**한다. queryKey 는 `[tabId, sheetName, action, filters]`
      //   (`useCustomQueryClient.ts:76-81`)라 `[tabId]` 만 주면 prefix 매칭으로 조회조건 마스터
      //   (`init`) 캐시까지 지워진다 — SP 가 불필요하게 재호출되고, 재조회가 끝나기 전까지
      //   제외목록(`o_rc4`)이 비어 탭이 8개로 벌어진다(AS-IS 는 Division 변경 시 서버 재호출 0회).
      GRID_SHEETS.forEach(gridSheet => {
        queryClient.removeQueries({ queryKey: [tabId, gridSheet] });
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.planGrId, sc.plantIds]);

  // 조회 성공 시 편집모드 해제 + EditTracker clear — R-02(조회 직후 전 컬럼 잠금) 구현부다.
  useEffect(() => {
    if (!gridQuery.data || !sheet) return;
    editTrackerRefs[sheet].current?.clearChanges();
    setEditMode(sheet, false);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridQuery.data]);

  const comboSources = useMemo(
    () => ({
      plantAll: sheets.plantAll,
      lineAll: sheets.lineAll,
      operationAll: sheets.operationAll,
      lineTypeAll: sheets.lineTypeAll,
      selectedPlantCodes: sheets.selectedPlantCodes,
      plantCandidates: sheets.plantAll,
      lineCandidates: sheets.lineAll,
    }),
    [
      sheets.plantAll,
      sheets.lineAll,
      sheets.operationAll,
      sheets.lineTypeAll,
      sheets.selectedPlantCodes,
    ]
  );

  const activeTabIndex = sheet ? Math.max(sheets.visibleSheets.indexOf(sheet), 0) : 0;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <OptCapaForm
          divisionOptions={sheets.divisionOptions}
          planGroupOptions={sheets.planGroupOptions}
          plantOptions={sheets.plantOptions}
          lineOptions={sheets.lineOptions}
          hasDivisionAuth={sheets.hasDivisionAuth}
          onSearch={actions.handleSearch}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        // 엑셀 다운로드·필터 초기화는 **활성 탭 grid** 를 대상으로 한다(자매 `capa-line-assign:777`).
        grid={gridRefs[refSheet]}
        gridFilter={gridFilterRefs[refSheet]}
        dataCount={rows.length}
        excelFileName={EXCEL_FILE_NAME}
        useHotkey={true}
        hotkeyConfig={actions.hotkeyConfig}
        searchParam={sc}
        customButtons={actions.customButtons}
      />

      {/*
        탭 스트립은 **항상** 보인다 — 시트가 1개로 줄어도 숨기지 않는다(R12, `TabStripPolicy.Always`).
        `persist` 로 비활성 탭을 언마운트하지 않는다(재마운트 시 헤더높이·머지가 타이밍으로 깨진다,
        nscm-patterns §5-8). 탭과 DataGrid 사이에 래퍼 div 를 추가로 끼우지 않는다(flex 계약, hook #132).
      */}
      <div className={styles.tabArea}>
        <TabWrapper
          persist
          activeTabIndex={activeTabIndex}
          setActiveTabIndex={actions.handleTabChange}
        >
          {sheets.visibleSheets.map(visibleSheet => (
            <TabItem key={visibleSheet} label={SHEET_LABEL[visibleSheet]}>
              <OptCapaGrid
                sheet={visibleSheet}
                data={visibleSheet === sheet ? rows : []}
                // 탭마다 **자기 시트 ref** 를 받는다 — 공유 금지({@link createSheetRefs}).
                gridRef={gridRefs[visibleSheet]}
                gridFilterRef={gridFilterRefs[visibleSheet]}
                editTrackerRef={editTrackerRefs[visibleSheet]}
                adminColumns={staticColumns[visibleSheet]}
                editMode={editMode[visibleSheet] === true}
                divisionId={actions.divisionId}
                comboSources={comboSources}
                onItemCellDblClick={actions.openItemPopup}
              />
            </TabItem>
          ))}
        </TabWrapper>
      </div>

      {/* Batch Save — AS-IS 는 `DialogResult.OK` 일 때만 재조회한다(R07). */}
      <NoWorkBatchModal
        open={actions.openBatch}
        divisionId={actions.divisionId}
        plantOptions={sheets.plantOptions}
        lineAll={sheets.lineAll}
        onClose={actions.closeBatch}
        onSaved={actions.refreshAfterExternalSave}
      />

      {/* Excel upload — 완료 후 메인 재조회(AS-IS MSG00265 Yes 재조회 재현). */}
      <NoWorkExcelUploadModal
        open={actions.openUpload}
        modalClose={actions.closeUpload}
        onUploaded={actions.refreshAfterExternalSave}
      />

      {/*
        Item 팝업 — 그리드 `ITEM_ID` 셀 더블클릭 경유(R-11).
        AS-IS `popItem.Form_Load(true, division, "", "", "")` 의 첫 인자가 `cboDivision.ControlValues`
        **원본**이다(cs:3746) — 다른 경로는 `GetCheckedListValue` 를 거치지만 ALL 옵션이 없어 값은 같다.
      */}
      <ItemByDivisionModal
        open={actions.itemPopup !== null}
        modalClose={actions.closeItemPopup}
        // 4번째 인자가 `NICK_NAME` 이다 — 인터페이스의 파라미터명(`itemType`)과 실제 호출 순서가
        //   다르다(`ItemByDivisionModal.tsx:350-360`·`379-383` 실측). 이름이 아니라 위치를 따른다.
        setSelectedValue={(itemId, _itemName, _itemClassName, nickName) =>
          actions.handleItemSelect(str(itemId), str(nickName))
        }
        preSearchParams={
          {
            // AS-IS `popItem.Form_Load(true, division, "", "", "")`(cs:3751) — division 만 싣는다.
            //   나머지 cascade 축은 이 코드베이스의 "필터 없음" sentinel 인 `ALL` 로 둔다.
            divisionId: actions.divisionId,
            deptId: 'ALL',
            endCustomer: 'ALL',
            salesSite: 'ALL',
            projectCode: '',
            itemId: '',
          } as never
        }
        callFromCell={true}
      />
    </>
  );
};
