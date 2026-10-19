import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentRequestPackDetailGrid } from './components/ShipmentRequestPackDetailGrid';
import { ShipmentRequestPackDetailSearch } from './components/ShipmentRequestPackDetailSearch';
import { ShipmentRequestPackForm } from './components/ShipmentRequestPackForm';
import { ShipmentRequestPackMainGrid } from './components/ShipmentRequestPackMainGrid';
import { MEASURE, MENU_ID, SHEETS } from './shipment-request-pack.constants';
import type {
  CellRow,
  PackRow,
  RequestDetailRow,
  ResultDetailRow,
} from './shipment-request-pack.types';
import { useShipmentRequestPackStore } from './useShipmentRequestPackStore';
import {
  buildSaveCellPayload,
  buildSavePackPayload,
  buildSaveRequestDetailPayload,
  collectPivotChanges,
  collectRequestDetailChanges,
} from './utils/shipment-request-pack.save';
import type { SaveResultRow } from './utils/shipment-request-pack.save';

// SSP0026 Shipment Request Pack — AS-IS SSP0026_ShipmentRequestPack(Forms.UIL 정본, controls 76)
//   1:1 골격 전환(iter-1). 조회 = PKG_SSP0026.P_SSP0026_GET_SHIPMENT_REQUEST_PACK/_CELL(Pack/Cell) +
//   GET_REQUEST_DETAIL_PACK/GET_RESULT_DETAIL(상세). 저장 = SAVE_SHIP_REQ_PACK/_CELL/_DETAIL_PACK/_DETAIL_CELL
//   (활성 그리드별 분기, design 01 R12).
//
// 정직 보고(convert-core §4.3): PKG_SSP0026 13개 대상 SP 중 7건(메인 그리드 조회 2 + 저장 4 +
//   Detail Cell 조회 1) 이 TO-BE 미배포(all_objects 0건, 2026-09-26 ora.py 실측, goal.md ②) —
//   메인 그리드 조회/저장 핵심 플로우는 FE 배선만 완비되고 런타임 실행체인이 미완이다(convert-sp 후속).
//   Request/Result Detail 조회·엑셀다운로드·BOD자동세팅·pivot헤더 SP 6건은 배포돼 실행 가능하다.
//
// iter-3(react-gap-audit 재시도 1) 갱신: Bucket Type 콤보 SQL_ID 불일치(신규발견, 고) 해소 —
//   'DM0003_GET_BUCKET_TYPE_CODE'는 미등록 오기재였고 ora.py 재실측으로 'BucketType' 확정(constants.ts).
//   Delete no-op(§6, 고) 해소 — GridAction.removeRow(grid, true)로 활성 그리드의 신규행('I')만 제거하도록
//   배선. Insert도 GridAction.addRow로 Cell Biz/Request Detail 신규행 생성(기본값 Division/SHIP_REQ/'-')까지
//   배선했으나, 행/컬럼 단위 화이트리스트 unlock(R9/R10 세분화)은 여전히 미완(그리드 전체 isEditMode 단위만).
//
// 이번 회차(iter-3) 미완 — 04_react-gap.md 참조(임의 구현 금지, 다음 회차 이월):
//   - Cell Biz 탭 권한 게이트(dtPgmAuthId, R1) DB 실측 미완 — 이번 회차는 항상 2탭 노출
//   - Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20) — 가장 복잡한 로직, 미착수
//   - Measure=="SHIP_REQ" 행 확정구간 이후만 unlock 하는 행/컬럼 세분화(R7), Measure 4색 배경(R18)
//   - Insert 화이트리스트 unlock(R9/R10 컬럼 단위), BOD_ID 자동세팅(R10/R14), 엑셀 업/다운로드(§4.4)
//   - Save 실제 API 호출(SP 미배포로 호출부만 자리표시), Model 팝업(SSP0026_ItembyDivisionPopup) 내부
//     설계·구현(goal.md ①부기, plan.md 1번 항목), 그리드 셀콤보 5종(TransportMode/Incoterms/FCST_TYPE/
//     Measure/FromSite·ToSite·ShipToCode) 배선
//   - 메뉴 등록(2.7)·컬럼/Measure 메타(2.75)·콤보/Lookup 메타(2.76)·권한 입력(2.8) DB 적용
export const ShipmentRequestPack = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRefPack = useRef<FlexGrid<PackRow>>();
  const gridFilterRefPack = useRef<FlexGridFilter>();
  const editTrackerRefPack = useRef<EditTracker<PackRow>>();
  const gridRefCell = useRef<FlexGrid<CellRow>>();
  const gridFilterRefCell = useRef<FlexGridFilter>();
  const editTrackerRefCell = useRef<EditTracker<CellRow>>();
  const gridRefRequest = useRef<FlexGrid<RequestDetailRow>>();
  const gridFilterRefRequest = useRef<FlexGridFilter>();
  const editTrackerRefRequest = useRef<EditTracker<RequestDetailRow>>();
  const gridRefResult = useRef<FlexGrid<ResultDetailRow>>();
  const gridFilterRefResult = useRef<FlexGridFilter>();

  const searchParams = useShipmentRequestPackStore(state => state.searchParams);
  const filters = useShipmentRequestPackStore(state => state.filters);
  const cellFilters = useShipmentRequestPackStore(state => state.cellFilters);
  const requestDetailFilters = useShipmentRequestPackStore(state => state.requestDetailFilters);
  const resultDetailFilters = useShipmentRequestPackStore(state => state.resultDetailFilters);
  const isOpenSearchArea = useShipmentRequestPackStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentRequestPackStore(state => state.setOpenSearchArea);
  const setFilters = useShipmentRequestPackStore(state => state.setFilters);
  const clearFilters = useShipmentRequestPackStore(state => state.clearFilters);
  const staticColumns = useShipmentRequestPackStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentRequestPackStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestPackStore(state => state.fetchStaticMeasures);
  const activeMainSheet = useShipmentRequestPackStore(state => state.activeMainSheet);
  const setActiveMainSheet = useShipmentRequestPackStore(state => state.setActiveMainSheet);
  const activeDetailSheet = useShipmentRequestPackStore(state => state.activeDetailSheet);
  const setActiveDetailSheet = useShipmentRequestPackStore(state => state.setActiveDetailSheet);
  const activeGrid = useShipmentRequestPackStore(state => state.activeGrid);
  const setActiveGrid = useShipmentRequestPackStore(state => state.setActiveGrid);

  // 편집권한은 화면 오픈 시 1회만 판정한다(convert-core §2.4) — AS-IS Edit 모드토글 미이식.
  //   권한 없으면 처음부터 읽기전용으로 열린다. Main/Detail 두 그리드 모두 이 canEdit 하나로 통일.
  const canEdit = hasButton('EDIT');

  // Division 은 고정값이라 실질 변경 없음 — 화면 재진입/탭 전환 시 그리드 초기화 의무만 유지
  // (nscm-patterns.md §5-5 준용).
  const prevKeyRef = useRef(searchParams.divisionId);
  useEffect(() => {
    if (prevKeyRef.current === searchParams.divisionId) return;
    prevKeyRef.current = searchParams.divisionId;
    editTrackerRefRequest.current?.clearChanges();
    clearFilters();
  }, [searchParams.divisionId, clearFilters]);

  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const { data: packData, refetch: refetchPack } = useTabProcQuery<MENU_ID, SHEETS.PACK>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACK,
    tabId,
    filters,
    enabled: filters !== undefined && activeMainSheet === 'pack',
  });
  const { data: cellData, refetch: refetchCell } = useTabProcQuery<MENU_ID, SHEETS.CELL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CELL,
    tabId,
    filters: cellFilters,
    enabled: cellFilters !== undefined && activeMainSheet === 'cell',
  });
  const { data: requestDetailData, refetch: refetchRequestDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.REQUEST_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL,
    tabId,
    filters: requestDetailFilters,
    enabled: requestDetailFilters !== undefined && activeDetailSheet === 'requestDetail',
  });
  const { data: resultDetailData, refetch: refetchResultDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.RESULT_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT_DETAIL,
    tabId,
    filters: resultDetailFilters,
    enabled: resultDetailFilters !== undefined && activeDetailSheet === 'resultDetail',
  });

  const packRows = useMemo(() => (packData as { o_rc1?: PackRow[] })?.o_rc1 ?? [], [packData]);
  const cellRows = useMemo(() => (cellData as { o_rc1?: CellRow[] })?.o_rc1 ?? [], [cellData]);
  const requestDetailRows = useMemo(
    () => (requestDetailData as { o_rc1?: RequestDetailRow[] })?.o_rc1 ?? [],
    [requestDetailData]
  );
  const resultDetailRows = useMemo(
    () => (resultDetailData as { o_rc1?: ResultDetailRow[] })?.o_rc1 ?? [],
    [resultDetailData]
  );
  const activeRows = activeMainSheet === 'pack' ? packRows : cellRows;

  // entryPoints FindButton — 조회조건 종합 → 메인 그리드(Pack/Cell) + 상세 그리드 재조회
  // (design 02 §4.1/§8-5). 최초 자동조회 없음 — Find 버튼 경유로만 실행(AS-IS 동일).
  const handleSearch = () => {
    const isSame = setFilters();
    if (isSame) {
      void refetchPack();
      void refetchCell();
      void refetchRequestDetail();
      void refetchResultDetail();
    }
  };

  // btnSearch — 상세 그리드 전용 보조검색(design 02 §1-#14), 메인 그리드와 무관하게 재조회.
  const handleDetailSearch = () => {
    void refetchRequestDetail();
    void refetchResultDetail();
  };

  // R9/R10: Insert — spdMain Pack Biz 는 no-op(고위험 로직 미착수), Cell Biz/Request Detail만
  //   신규행 대상(design 01 R9/R10). 기본값 Division/Measure="SHIP_REQ"/ShipToCode="-"(goal.md ⑤-4).
  //   행/컬럼 단위 화이트리스트 unlock(INSERT_EDITABLE_COLUMNS_MAIN/REQUEST_DETAIL_EDIT_COLUMNS 셀 단위
  //   isCellEditable 예측자 배선)은 이번 회차 미완 — 04_react-gap.md 이월(그리드 전체 isEditMode 단위만 반영).
  const handleInsert = () => {
    const insertDefaults = {
      CRUD_TYPE: 'I',
      DIVISION_ID: searchParams.divisionId,
      MEASURE: MEASURE.SHIP_REQ,
      SHIP_TO_CODE: '-',
    };
    if (activeGrid === 'spdMain') {
      if (activeMainSheet === 'pack') return; // Pack Biz no-op(R9)
      const grid = gridRefCell.current;
      if (!grid) return;
      GridAction.addRow(grid, insertDefaults as unknown as Partial<CellRow>);
      return;
    }
    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail') {
      const grid = gridRefRequest.current;
      if (!grid) return;
      GridAction.addRow(grid, insertDefaults as unknown as Partial<RequestDetailRow>);
    }
    // Result Detail은 항상 읽기전용이라 Insert 대상이 아니다(R8).
  };

  // R11: Delete — CRUD_TYPE=='I'(신규행)만 즉시 삭제, 기존행은 조용히 무반응(가드 메시지 없음,
  //   convert-core §2.4 그대로 일치. GridAction.removeRow(grid, true)의 deleteOnlyNew 가 기존행을
  //   그대로 건너뛰므로 Pack Biz(Insert no-op라 신규행 자체가 없음)에서 호출해도 부작용이 없다.
  const handleDelete = () => {
    if (activeGrid === 'spdMain') {
      if (activeMainSheet === 'pack') {
        if (gridRefPack.current) GridAction.removeRow(gridRefPack.current, true);
        return;
      }
      if (gridRefCell.current) GridAction.removeRow(gridRefCell.current, true);
      return;
    }
    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail' && gridRefRequest.current) {
      GridAction.removeRow(gridRefRequest.current, true);
    }
  };

  // R12: Save — 활성 그리드(메인/상세)별 저장 API 분기(design 03 §4.2). PKG_SSP0026.
  //   SAVE_SHIP_REQ_PACK/_CELL/_DETAIL_PACK 3종은 배포·PL/SQL 본문 실측 완료(ora.py ALL_SOURCE,
  //   2026-09-26) — 결과코드 계약은 design 문서의 AS-IS S/N/X/Y 서술과 달리 실제 TO-BE 본문 기준
  //   'S'(성공)/'X'(BOD 부적합)/'F'(시스템 예외) + Detail Pack 전용 'Y'(확정구간 경고) 로 확정된다
  //   (shipment-request-pack.save.ts 상단 주석 참조). Detail Cell(SAVE_SHIP_REQ_DETAIL_CELL)은
  //   여전히 미배포라 자리표시 유지.
  //
  //   주의(04_react-gap.md 신규 발견, 2026-09-26): `SCM_ADM_PROC_M`에 SSP0026 전 프로시저(GET 포함)
  //   등록행이 0건이다(ora.py 실측) — call-proc 라우팅(`PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST`)이
  //   이 메타 없이는 파라미터 없는 빈 호출을 만들어 런타임에 실패한다. 이 등록은 convert-sp 소관
  //   (Hard Boundary, convert-core §2.2) — 이 회차는 FE 배선만 완비하고 PROC_M 등록은 손대지 않는다.
  const handleSaveError = async (error: unknown) => {
    const message = error instanceof Error ? error.message : String(error);
    await setAlert({ type: 'alert', content: message || t('MSG00003', '_Save error.') });
  };

  const interpretSaveResult = async (
    result: { o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] } | undefined,
    onSuccess: () => void
  ) => {
    const row = result?.o_rc1?.[0];
    const code = String(row?.RESULT_CODE ?? '');
    if (code === 'S') {
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      onSuccess();
      return;
    }
    if (code === 'X') {
      await setAlert({ type: 'alert', content: t('MSG00293', '_BOD information is not valid.') });
      return;
    }
    if (code === 'Y') {
      const confirmDay = String(row?.CONFIRM_DAY ?? '');
      await setAlert({
        type: 'alert',
        content: t('MSG00323', '_Confirmed until {0}.').replace('{0}', confirmDay),
      });
      return;
    }
    const detail = String(result?.o_rc2?.[0]?.ERR_MESSAGE ?? '');
    await setAlert({ type: 'alert', content: detail || t('MSG00042', '_System error occurred.') });
  };

  const handleSave = async () => {
    const userId = useSessionStore.getState().session.userId ?? '';

    if (activeGrid === 'spdMain' && activeMainSheet === 'pack') {
      const tracker = editTrackerRefPack.current;
      if (!tracker) return;
      const changes = collectPivotChanges(packRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      const confirmed = await setAlert({ type: 'confirm', content: t('MSG00012', '_Save the changes?') });
      if (!confirmed) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/pack/SAVE/call-proc`,
          buildSavePackPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchPack();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    if (activeGrid === 'spdMain' && activeMainSheet === 'cell') {
      const tracker = editTrackerRefCell.current;
      if (!tracker) return;
      const changes = collectPivotChanges(cellRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      const confirmed = await setAlert({ type: 'confirm', content: t('MSG00012', '_Save the changes?') });
      if (!confirmed) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/cell/SAVE/call-proc`,
          buildSaveCellPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchCell();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail') {
      const tracker = editTrackerRefRequest.current;
      if (!tracker) return;
      const changes = collectRequestDetailChanges(requestDetailRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      const confirmed = await setAlert({ type: 'confirm', content: t('MSG00012', '_Save the changes?') });
      if (!confirmed) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/requestDetail/SAVE/call-proc`,
          buildSaveRequestDetailPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchRequestDetail();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    // Result Detail(읽기전용)·Cell Biz Request Detail(SAVE_SHIP_REQ_DETAIL_CELL 미배포) — 자리표시 유지.
    const confirmed = await setAlert({ type: 'confirm', content: t('MSG00012', '_Save the changes?') });
    if (!confirmed) return;
    await setAlert({
      type: 'alert',
      content: 'SP not deployed yet — save execution deferred to convert-sp.',
    });
  };

  // 편집계 버튼(Insert/Delete/Save)은 버튼권한 + 편집권한(canEdit) 둘 다 있어야 노출한다
  //   (convert-core §2.4 — 편집 기본 ON, 권한은 화면 오픈 시 1회).
  const hotkeyConfig: HotkeyConfig = {
    search: () => handleSearch(),
    insert: canEdit && hasButton('INSERT') ? handleInsert : (() => undefined),
    delete: canEdit && hasButton('DELETE') ? handleDelete : (() => undefined),
    save: canEdit && hasButton('SAVE') ? () => void handleSave() : (() => undefined),
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {isOpenSearchArea && <ShipmentRequestPackForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={activeMainSheet === 'pack' ? gridRefPack : gridRefCell}
        gridFilter={activeMainSheet === 'pack' ? gridFilterRefPack : gridFilterRefCell}
        dataCount={activeRows.length}
        excelFileName='Shipment Request Pack'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup orientation='vertical'>
        <Panel defaultSize={40} minSize={20}>
          <TabWrapper persist onTabClick={index => setActiveMainSheet(index === 0 ? 'pack' : 'cell')}>
            <TabItem label={t('LBL_PACK_BIZ', 'Pack Biz')}>
              <ShipmentRequestPackMainGrid<PackRow>
                sheet={SHEETS.PACK}
                rows={packRows}
                gridRef={gridRefPack}
                gridFilterRef={gridFilterRefPack}
                editTrackerRef={editTrackerRefPack}
                staticColumns={staticColumns[SHEETS.PACK]}
                bucketType={searchParams.bucketType}
                isEditMode={canEdit}
                onFocus={() => setActiveGrid('spdMain')}
              />
            </TabItem>
            {/* Cell Biz 탭 권한 게이트(dtPgmAuthId, design 01 R1) — DB 실측 미완, 이번 회차는 항상 노출 */}
            <TabItem label={t('LBL_CELL_BIZ', 'Cell Biz')}>
              <ShipmentRequestPackMainGrid<CellRow>
                sheet={SHEETS.CELL}
                rows={cellRows}
                gridRef={gridRefCell}
                gridFilterRef={gridFilterRefCell}
                editTrackerRef={editTrackerRefCell}
                staticColumns={staticColumns[SHEETS.CELL]}
                bucketType={searchParams.bucketType}
                isEditMode={canEdit}
                onFocus={() => setActiveGrid('spdMain')}
              />
            </TabItem>
          </TabWrapper>
        </Panel>
        <PanelSeparator />
        <Panel defaultSize={60} minSize={20}>
          {/* Pack↔Cell 전환 시 하단영역 표시 토글(design 01 R14) — Cell Biz 활성 시 상세영역 미노출 */}
          {activeMainSheet === 'pack' && (
            <>
              <ShipmentRequestPackDetailSearch onSearch={handleDetailSearch} />
              <TabWrapper
                persist
                onTabClick={index =>
                  setActiveDetailSheet(index === 0 ? 'requestDetail' : 'resultDetail')
                }
              >
                <TabItem label={t('LBL_REQUEST_DETAIL', 'Shipment Request Detail')}>
                  <ShipmentRequestPackDetailGrid<RequestDetailRow>
                    sheet={SHEETS.REQUEST_DETAIL}
                    rows={requestDetailRows}
                    gridRef={gridRefRequest}
                    gridFilterRef={gridFilterRefRequest}
                    editTrackerRef={editTrackerRefRequest}
                    staticColumns={staticColumns[SHEETS.REQUEST_DETAIL]}
                    isEditMode={canEdit}
                    onFocus={() => setActiveGrid('spdDetail')}
                  />
                </TabItem>
                <TabItem label={t('LBL_RESULT_DETAIL', 'Shipment Result Detail')}>
                  <ShipmentRequestPackDetailGrid<ResultDetailRow>
                    sheet={SHEETS.RESULT_DETAIL}
                    rows={resultDetailRows}
                    gridRef={gridRefResult}
                    gridFilterRef={gridFilterRefResult}
                    staticColumns={staticColumns[SHEETS.RESULT_DETAIL]}
                    isEditMode={false}
                    onFocus={() => setActiveGrid('spdDetail')}
                  />
                </TabItem>
              </TabWrapper>
            </>
          )}
        </Panel>
      </PanelGroup>
    </>
  );
};
