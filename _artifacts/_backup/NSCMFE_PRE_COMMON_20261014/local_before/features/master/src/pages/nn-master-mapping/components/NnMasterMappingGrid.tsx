import {
  AllowMerging,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { CustomerModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import type { MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import type { SearchCondition } from '../nn-master-mapping.types';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';
import { HierarchicalMergeManager } from '../utils/nn-master-mapping.merge';

interface NnMasterMappingGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN>[];
  searchCondition: SearchCondition;
}

// AS-IS .cs L538-602 InsertRow / L515 SmartColMerge / L789~875 Validation 매핑:
//   - column-dependent 머지: HierarchicalMergeManager (utils/nn-master-mapping.merge.ts)
//   - cell edit: EditTracker 표준 (CRUD_TYPE='M' 자동 마킹)
//   - dblClick → Modal 분기: column meta 의 _modalKey 기반
// 행(row)의 DATA_TYPE_CODE='SCM' 일 때만 편집 허용할 컬럼 binding (인라인 편집 + 더블클릭 팝업 공통).
//   ※ 향후 5개까지 확장 시 이 set 에 binding 만 추가하면 beginningEdit / handleGridDblClick 양쪽에 동시 적용됨.
const EDITABLE_ONLY_WHEN_SCM = new Set([
  'MAPPING_ITEM_ID',
  'VALID_START_DATE',
  'VALID_END_DATE',
  'ACTIVE_YN',
  'DC_LEVEL', // 추가
]);

export const NnMasterMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
  searchCondition,
}: NnMasterMappingGridProps) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>(
    undefined
  );
  // admin SHEET_COLUMNS 메타 (BE PR_GET_SHEET_COLUMN_LIST 응답) — 룰 #65 ui-category-setup-column-meta 표준.
  //   080_DMF0072_dynamic_property_management.sql 사내 적용 완료 (2026-06-20) → BE 가 23 row 반환.
  //   admin UI Category Setup 의 VISIBLE_FLAG 변경이 즉시 반영됨 (FE hardcoded fallback 제거 완료).
  const staticColumns = useNnMasterMappingStore(s => s.staticColumns.main);

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);
  // 팝업 조회조건에 시드할 "클릭한 행의 값" — 검색영역(searchCondition) 값이 아니라 그 행 값 기준.
  //   PROJECT_CODE/ITEM_ID 팝업은 해당 행의 END_CUSTOMER 로 필터되어 열려야 함(사용자 요구 2026-07-07).
  const [clickedRowEndCustomer, setClickedRowEndCustomer] = useState<string>('');
  const [openCustomerModal, setOpenCustomerModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  // AS-IS 의 column-dependent 머지 — DataGrid wrapper 의 mergeManager prop 으로 전달 (useEffect 표준).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.mergeManager = new HierarchicalMergeManager();
    g.invalidate();
  }, [staticColumns]); // eslint-disable-line react-hooks/exhaustive-deps

  // 편집 차단 규칙 (모두 "그 행의 DATA_TYPE_CODE 값" 기준 — beginningEdit = cell-level 편집 제어)
  //  (1) DATA_TYPE_CODE='ERP' 행은 편집 불가 (기존)
  //  (2) 대상 컬럼(EDITABLE_ONLY_WHEN_SCM)은 행의 DATA_TYPE_CODE === 'SCM' 일 때만 편집 가능
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handleBeginningEdit = (
      s: FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>,
      e: CellRangeEventArgs
    ) => {
      const rowData = s.rows[e.row].dataItem as (WijmoRowItem & { CRUD_TYPE?: string }) | null;

      // (1) ERP 행 편집 불가
      if (rowData && rowData?.DATA_TYPE_CODE === 'ERP') {
        e.cancel = true;
        return;
      }

      // (2) 행의 DATA_TYPE_CODE 가 SCM 이 아니면 대상 컬럼 편집 차단
      const binding = s.columns[e.col]?.binding;
      if (binding && EDITABLE_ONLY_WHEN_SCM.has(binding) && rowData?.DATA_TYPE_CODE !== 'SCM') {
        e.cancel = true;
      }
    };

    g.beginningEdit.addHandler(handleBeginningEdit);

    return () => {
      g.beginningEdit.removeHandler(handleBeginningEdit);
    };
    // staticColumns 가 채워진(=그리드 초기화 완료) 뒤에 핸들러가 등록되도록 트리거 (머지 useEffect 와 동일 패턴)
  }, [staticColumns]); // eslint-disable-line react-hooks/exhaustive-deps

  // 편집 가능/불가 시각 구분 — 대상 컬럼은 행 DATA_TYPE_CODE='SCM' 일 때만 편집색(wj-cell-editable),
  //   아니면 비편집색(wj-cell-non-editable) + 팝업 아이콘 제거.
  //   formatEditableColumns(컬럼 메타 기준) 뒤에 실행되어 "행 조건"으로 덮어씀.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handleFormatItem = (
      s: FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>,
      e: FormatItemEventArgs
    ) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding || !EDITABLE_ONLY_WHEN_SCM.has(binding)) return;

      const rowData = s.rows[e.row]?.dataItem as WijmoRowItem | null;
      const editable = rowData?.DATA_TYPE_CODE === 'SCM';

      e.cell.classList.toggle('wj-cell-editable', editable);
      e.cell.classList.remove('wj-cell-non-editable'); // 이전 버전 잔재 제거
      if (!editable) e.cell.classList.remove('wj-cell-popup');
    };

    g.formatItem.addHandler(handleFormatItem);
    g.invalidate();

    return () => {
      g.formatItem.removeHandler(handleFormatItem);
    };
  }, [staticColumns]); // eslint-disable-line react-hooks/exhaustive-deps

  // cellEditEnded — 편집한 셀 자체의 수정상태(M) 추적은 화면에서 손대지 않는다.
  //   공용 DataGrid 의 EditTracker 가 cellEditEnded 에 이미 붙어 편집 셀의 원본/최종 비교로
  //   M 마킹·해제를 전담한다. 화면이 편집 셀에 storeChange 를 또 부르면 이중 판정이 되는데,
  //   더구나 이 핸들러는 cellEditEnded "prop" 으로 넘겨져 wijmo-react 가 mount 시점(EditTracker 를
  //   만드는 initialized setTimeout 보다 먼저)에 등록한다. 따라서 화면 핸들러가 EditTracker 보다
  //   앞서 실행되고, 되돌리기(값 넣었다 지움) 때 EditTracker 가 마지막에 자기 _originalValue(이번
  //   편집 시작값=수정된 값)로 M 을 되살린다. DMF0021 은 자체 핸들러를 useEffect(addHandler)로 붙여
  //   EditTracker 뒤에 실행되므로 retrackDyn 이 먹혔지만, 여기(prop 등록)는 순서가 반대라 먹지 않는다.
  //   결론: 편집 셀 추적은 EditTracker 에 일임하고, 화면은 "다른 셀"로의 연쇄만 처리한다.
  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>,
    e: CellRangeEventArgs
  ) => {
    const binding = grid.columns[e.col]?.binding;
    if (!binding || binding === 'CRUD_TYPE') return;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!dataItem) return;

    // 연쇄 컬럼 리셋 — 상위(END_CUSTOMER) 변경 시 하위(SCM_SITE_ID) 초기화.
    //  SCM_SITE_ID 콤보는 그 행의 DIVISION_ID+END_CUSTOMER 로 옵션이 필터되므로(060 combo),
    //  상위가 바뀌면 기존 SCM_SITE_ID 는 새 옵션 집합에 없을 수 있어 반드시 리셋.
    //  이 storeChange 는 편집 셀(END_CUSTOMER)이 아니라 하위 셀(SCM_SITE_ID)이 대상이라
    //  EditTracker 와 겹치지 않는다(EditTracker._cellChanged 는 편집 셀만 본다). 값을 비우는
    //  실제 변경이므로 M 마킹이 맞고, 실행 순서와 무관하게 안전하다.
    if (binding === 'END_CUSTOMER' && dataItem.SCM_SITE_ID !== '') {
      editTrackerRef.current?.storeChange(dataItem, 'SCM_SITE_ID', dataItem.SCM_SITE_ID, '');
      dataItem.SCM_SITE_ID = '';
      // 바뀐 셀(SCM_SITE_ID) 하나만 즉시 갱신 — 전 행 refresh 는 머지 재계산으로 느림.
      const siteCol = grid.columns.getColumn('SCM_SITE_ID')?.index ?? -1;
      if (siteCol >= 0) grid.setCellData(e.row, siteCol, '', false, true);
    }
  };

  // dblClick → Modal 분기 (column binding 기반)
  // AS-IS .cs InsertRow cellTypeImage 매핑:
  //   - SOLDTO_CODE / SHIPTO_CODE: CustomerModal (신규 행만)
  //   - PROJECT_CODE: ProjectByDivisionModal (신규 행만)
  //   - ITEM_ID: ItemByDivisionModal (Model/Nickname Popup, 신규 행만)
  //   - MAPPING_ITEM_ID: ItemByDivisionModal (Mapping Item Popup, 신규+수정 모두)
  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(g, ht.row);
    const binding = GridUtils.getBinding(g, ht.col);
    if (!dataItem || !binding) return;

    // 대상 컬럼은 행의 DATA_TYPE_CODE='SCM' 일 때만 편집(popup) 허용 — beginningEdit 인라인 차단과 일관
    if (
      EDITABLE_ONLY_WHEN_SCM.has(binding as string) &&
      (dataItem as WijmoRowItem).DATA_TYPE_CODE !== 'SCM'
    )
      return;

    const isInsert = dataItem.CRUD_TYPE === CRUD_TYPE.INSERT;
    const isMappingItem = binding === 'MAPPING_ITEM_ID';

    // INSERT row 외에는 MAPPING_ITEM_ID 만 popup 허용
    if (!isInsert && !isMappingItem) return;

    setClickedRow(ht.row);
    setClickedBinding(binding as string);
    // 그 행의 END_CUSTOMER 를 팝업 조회조건 시드로 사용 (없으면 검색영역 값으로 fallback).
    setClickedRowEndCustomer(
      ((dataItem as WijmoRowItem).END_CUSTOMER as string) || searchCondition.endCustomer
    );

    if (binding === 'SOLDTO_CODE' || binding === 'SHIPTO_CODE') {
      setOpenCustomerModal(true);
    } else if (binding === 'PROJECT_CODE') {
      setOpenProjectModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'MAPPING_ITEM_ID') {
      setOpenItemModal(true);
    }
  };

  // Modal 콜백 — EditTracker.storeChange + dataItem 할당 + refreshRange (룰 #66)
  const setRowCell = (binding: string, value: string) => {
    const g = gridRef.current;
    if (!g || clickedRow < 0) return;
    const dataItem = GridUtils.getRow(g, clickedRow);
    if (!dataItem) return;
    editTrackerRef.current?.storeChange(dataItem, binding, dataItem[binding], value);
    dataItem[binding] = value;
    GridUtils.refreshRow(g, clickedRow);
  };

  // CustomerModal 은 SOLDTO + SHIPTO 동시 반환 — clicked binding 기준 분기
  const handleCustomerSelect = (soldTo: string, _soldDesc: string, shipTo: string) => {
    if (clickedBinding === 'SOLDTO_CODE') {
      setRowCell('SOLDTO_CODE', soldTo);
      if (shipTo) setRowCell('SHIPTO_CODE', shipTo);
    } else if (clickedBinding === 'SHIPTO_CODE') {
      setRowCell('SHIPTO_CODE', shipTo || soldTo);
    }
    setOpenCustomerModal(false);
  };

  const handleProjectSelect = (projects: string) => {
    setRowCell('PROJECT_CODE', projects);
    setOpenProjectModal(false);
  };

  const handleItemSelect = (items: string) => {
    if (clickedBinding) setRowCell(clickedBinding, items);
    setOpenItemModal(false);
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.MAIN>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        allowMerging={AllowMerging.Cells}
        cellEditEnded={handleCellEditEnded}
        dblClick={handleGridDblClick}
      />
      <CustomerModal
        open={openCustomerModal}
        modalClose={() => setOpenCustomerModal(false)}
        setSelectedValue={handleCustomerSelect}
        divisionId={searchCondition.divisionId}
      />
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: clickedRowEndCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          etc: 'N',
        }}
        callFromCell={true}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={handleItemSelect}
        preSearchParams={{
          divisionId: searchCondition.divisionId,
          deptId: searchCondition.deptId,
          endCustomer: searchCondition.endCustomer,
          salesSite: searchCondition.scmSiteId,
          projectCode: '',
          itemId: '',
        }}
        callFromCell={true}
        headerTitle={
          clickedBinding === 'MAPPING_ITEM_ID' ? 'Mapping Item Popup' : 'Model/Nickname Popup'
        }
      />
    </>
  );
};
