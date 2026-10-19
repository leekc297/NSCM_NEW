import {
  AllowMerging,
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';

import { CustomerModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { LOOKUP, type MENU_ID, type SHEETS } from '../nn-master-mapping.constants';
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
  const rawStaticColumns = useNnMasterMappingStore(s => s.staticColumns.main);
  // AS-IS .cs L1073-1084 clbDivision_SelectedIndexChanged 재현 — division=='40' 이면 PROJECT_CODE 숨김.
  //   메타(SHEET_COLUMNS)엔 division 축이 있지만 DMF0072 PROJECT_CODE row 는 DIVISION_ID 가 비어 있어
  //   서버 재조회로는 걸러지지 않는다. AS-IS 와 동일하게 FE 에서 visible 을 가공한다.
  //   필수: col.visible 을 wijmo 인스턴스에 직접 세팅하면 DataGrid 가 매 렌더 컬럼을 재생성하며 리셋되므로
  //   staticColumns 소스의 visible 자체를 바꿔 재생성 뒤에도 유지되게 한다.
  const staticColumns = useMemo(() => {
    if (searchCondition.divisionId !== '40') return rawStaticColumns;
    return rawStaticColumns.map(col =>
      col.colNm === 'PROJECT_CODE' ? { ...col, visible: false } : col
    );
  }, [rawStaticColumns, searchCondition.divisionId]);

  // COMPANY_ID 셀콤보 — AS-IS InsertRow cs:558 GetLookupValues("DM_EDI_COMPANY_LIST") 재현.
  //   컬럼 메타는 Company 콤보(전사)로 배선돼 후보범위가 AS-IS(MI00/NA00/GM00 3건)와 다르다(design 03 §6).
  //   별도 콤보 SQL 이 없어 lookup 을 직접 조회(useTabLookupQueries)해 신규행 셀에 DataMap 을 주입한다.
  const [companyRows] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.COMPANY }] });

  // 신규행(CRUD_TYPE='I')에만 콤보를 열고 기존행은 저장값 표시만 한다 — AS-IS 가 COMPANY_ID 콤보를
  //   InsertRow 한 곳(cs:559)에서만 세팅하고 기존행엔 재세팅하지 않는 것과 동일.
  //   주의: 이 lookup 응답은 CODE/NAME 별칭이 아니라 COMPANY_CODE 단일 컬럼만 돌아온다(표시명 없음) —
  //   라이브 /admin/lookup 실측(2026-10-06). AS-IS 가 코드만("- - -") 보인 것과 같다. 값=표시=코드로 둔다.
  const companyDataMap = useMemo(() => {
    const rows = (companyRows ?? [])
      .map(r => ({ CODE: String(r.COMPANY_CODE ?? ''), NAME: String(r.COMPANY_CODE ?? '') }))
      .filter(r => !!r.CODE);
    if (rows.length === 0) return null;
    const map = new DataMap(rows, 'CODE', 'NAME');
    const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
    map.getDisplayValues = (item?: unknown): string[] => {
      const all = [...new Set(allDisplayValues(item))];
      // 행 컨텍스트 없는 호출(필터 패널 등)은 전체 유지 — 비우면 필터가 죽는다.
      if (!item) return all;
      return (item as WijmoRowItem).CRUD_TYPE === CRUD_TYPE.INSERT ? all : [];
    };
    return map;
  }, [companyRows]);

  // COMPANY_ID 컬럼에 DataMap 부착 — DataGrid 가 매 렌더 컬럼을 (재)생성하므로 updatedLayout 마다 재부착
  //   (change-effect 는 grid mount 전에 early-return 될 수 있다 — SCP0048 선례).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !companyDataMap) return;
    const attach = () => {
      const col = grid.columns.getColumn('COMPANY_ID');
      if (col && col.dataMap !== companyDataMap) col.dataMap = companyDataMap;
    };
    grid.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        grid.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, companyDataMap]);

  const [clickedRow, setClickedRow] = useState<number>(-1);
  const [clickedBinding, setClickedBinding] = useState<string | null>(null);
  // 팝업 조회조건에 시드할 "클릭한 행의 값" — 검색영역(searchCondition) 값이 아니라 그 행 값 기준.
  //   AS-IS .cs spdMain_CellDoubleClick L1211-1215 가 팝업을 그 행의 END_CUSTOMER / SCM_SITE_ID /
  //   PROJECT_CODE 로 시드한다(Item: 세 값, Project: END_CUSTOMER+PROJECT_CODE, salesSite 는 ""로 비움).
  const [clickedRowSeed, setClickedRowSeed] = useState<{
    endCustomer: string;
    scmSiteId: string;
    projectCode: string;
  }>({ endCustomer: '', scmSiteId: '', projectCode: '' });
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

    // 연쇄 컬럼 클리어 — 상위 cascade 컬럼 변경 시 하위 컬럼들을 초기화(AS-IS ComboSelChange cs1165-1190).
    //  AS-IS 매핑:
    //   - END_CUSTOMER 변경 → SCM_SITE_ID, PROJECT_CODE, CUSTOMER_ITEM_ID, ITEM_ID(MDM CODE) 클리어
    //   - SCM_SITE_ID(Sales Site) 변경 → PROJECT_CODE, CUSTOMER_ITEM_ID, ITEM_ID(MDM CODE) 클리어
    //  SCM_SITE_ID 콤보는 그 행의 DIVISION_ID+END_CUSTOMER 로, PROJECT_CODE 는 SCM_SITE_ID 로 좁혀지므로
    //  상위가 바뀌면 하위 기존값은 새 후보 집합에 없을 수 있어 반드시 리셋한다.
    //  이 storeChange 는 편집 셀이 아니라 하위 셀들이 대상이라 EditTracker 와 겹치지 않는다
    //  (EditTracker._cellChanged 는 편집 셀만 본다). 값을 비우는 실제 변경이므로 M 마킹이 맞다.
    const CASCADE_CLEAR: Record<string, readonly string[]> = {
      END_CUSTOMER: ['SCM_SITE_ID', 'PROJECT_CODE', 'CUSTOMER_ITEM_ID', 'ITEM_ID'],
      SCM_SITE_ID: ['PROJECT_CODE', 'CUSTOMER_ITEM_ID', 'ITEM_ID'],
    };
    const targets = CASCADE_CLEAR[binding];
    if (targets) {
      for (const target of targets) {
        if (dataItem[target] === '' || dataItem[target] == null) continue;
        editTrackerRef.current?.storeChange(dataItem, target, dataItem[target], '');
        dataItem[target] = '';
        // 바뀐 셀 하나만 즉시 갱신 — 전 행 refresh 는 머지 재계산으로 느림.
        const col = grid.columns.getColumn(target)?.index ?? -1;
        if (col >= 0) grid.setCellData(e.row, col, '', false, true);
      }
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
    // 그 행의 END_CUSTOMER / SCM_SITE_ID / PROJECT_CODE 를 팝업 조회조건 시드로 캡처(AS-IS L1211-1215).
    //   END_CUSTOMER 는 비었을 때만 검색영역 값으로 fallback, 나머지는 행 값 그대로(없으면 빈 값).
    const rowItem = dataItem as WijmoRowItem;
    setClickedRowSeed({
      endCustomer: (rowItem.END_CUSTOMER as string) || searchCondition.endCustomer,
      scmSiteId: (rowItem.SCM_SITE_ID as string) || '',
      projectCode: (rowItem.PROJECT_CODE as string) || '',
    });

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
          endCustomer: clickedRowSeed.endCustomer,
          // AS-IS L1261 popProject.Form_Load(..., sScmSite="", sProject) — salesSite 는 비우고
          //   projectCode 는 그 행 값으로 시드한다.
          salesSite: '',
          projectCode: clickedRowSeed.projectCode,
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
          // AS-IS L1235 popItem.Form_Load(..., sEndCustomer, sScmSiteId, sProject, ...) — 세 값 모두
          //   검색영역이 아니라 그 행 값으로 시드한다.
          endCustomer: clickedRowSeed.endCustomer,
          salesSite: clickedRowSeed.scmSiteId,
          projectCode: clickedRowSeed.projectCode,
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
