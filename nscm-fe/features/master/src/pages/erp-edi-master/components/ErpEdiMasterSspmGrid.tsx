import { toggleClass } from '@mescius/wijmo';
import {
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ItemByDivisionModal,
  OwnerByDivisionModal,
  ProjectByDivisionModal,
} from '../../../components';
import { MENU_ID, type SHEETS } from '../erp-edi-master.constants';
import { useErpEdiMasterStore } from '../useErpEdiMasterStore';

interface ErpEdiMasterSspmGridProps {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.SSPM>[];
}

// AS-IS .cs L1309~1311 노란색 = 수정 가능 컬럼. 수정 모드에서도 이 3개만 LockRange 대상에서 빠진다
//   (.cs L685~740 — pEDI 잠금은 L722 에서 주석 처리). Yellow 표시와 편집 허용 판정을 같은 집합으로 쓴다.
const EDITABLE_COLUMNS = new Set(['SALES_PLANT', 'EDI', 'VALID_YN']);

// 필수 입력 컬럼(헤더 빨간 점)은 여기서 정하지 않는다 — 공용 formatEditableColumns 가
//   컬럼 메타 inputTpCd(M / IM)로 그리고, 저장 시 빈 값 차단도 같은 메타를 본다.

export const ErpEdiMasterSspmGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: ErpEdiMasterSspmGridProps) => {
  const staticColumns = useErpEdiMasterStore(state => state.staticColumns.sspm);

  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);
  const [openOwnerModal, setOpenOwnerModal] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    setClickedRow(ht.row);

    if (binding === 'PROJECT_CODE') {
      setOpenProjectModal(true);
    } else if (binding === 'ITEM_ID') {
      setOpenItemModal(true);
    } else if (binding === 'USER_ID') {
      setOpenOwnerModal(true);
    }
  };

  // 편집 허용 범위 — 공용 DataGrid 의 setEditableColumns 는 컬럼 메타(_inputEditType) 기준으로
  //   판정하므로, 화면 기준(AS-IS 노란색 집합)을 mount 후에 등록해 덮어쓴다.
  //   Wijmo Event 는 등록 순서대로 호출 → 마지막 등록이 최종 결정 (표준 패턴: CustomerModelMappingGrid).
  // deps 에 data/staticColumns 를 두는 이유: 공용 DataGrid 는 wijmo react 의 initialized(setTimeout)
  //   에서 gridRef 를 채우므로 첫 useEffect 시점엔 grid 가 아직 없다. 조회/컬럼메타 도착 시 다시 걸린다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handleBeginningEdit = (
      sender: FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>,
      e: CellRangeEventArgs
    ) => {
      const binding = GridUtils.getBinding(sender, e.col);
      e.cancel = typeof binding !== 'string' || !EDITABLE_COLUMNS.has(binding);
    };
    grid.beginningEdit.addHandler(handleBeginningEdit);
    // 붙여넣기도 같은 기준 — 안 걸면 타이핑은 되는데 Ctrl+V 만 막히는 상태가 된다.
    grid.pastingCell.addHandler(handleBeginningEdit);
    return () => {
      grid.beginningEdit?.removeHandler(handleBeginningEdit);
      grid.pastingCell?.removeHandler(handleBeginningEdit);
    };
  }, [gridRef, data, staticColumns]);

  const handleFormatItem = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>,
    args: FormatItemEventArgs
  ) => {
    // 헤더는 손대지 않는다 — 필수 빨간 점은 공용 formatEditableColumns 가 메타로 그린다.
    if (args.panel.cellType !== CellType.Cell) return;
    const binding = GridUtils.getBinding(grid, args.col);
    if (typeof binding !== 'string') return;
    // 편집 가능 컬럼 = 표준 Yellow(`wj-cell-editable`). 그 외 = White (클래스 없음). hook #95.
    toggleClass(args.cell, 'wj-cell-editable', EDITABLE_COLUMNS.has(binding));
  };

  const handleCellEditEnded = (
    grid: FlexGrid<ResponseData<MENU_ID, SHEETS.SSPM>>,
    e: CellRangeEventArgs
  ) => {
    const dataItem = GridUtils.getRow(grid, e.row);
    const binding = GridUtils.getBinding(grid, e.col);
    if (!dataItem || !binding) return;
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) return;

    // cascade 안 cascade 방지 (deferUpdate 로 batch — 룰 07 §2.10.8)
    grid.deferUpdate(() => {
      if (binding === 'DEPT_ID') {
        // Team 변경 → 뒤 두 단계(End Customer + SCM Sale Site) 모두 클리어
        dataItem.END_CUSTOMER = '';
        dataItem.END_CUSTOMER40 = '';
        dataItem.SCM_SITE_ID = '';
        dataItem.SCM_SITE_ID40 = '';
      } else if (binding === 'END_CUSTOMER' || binding === 'END_CUSTOMER40') {
        // End Customer 변경 → SCM Sale Site 클리어
        dataItem.SCM_SITE_ID = '';
        dataItem.SCM_SITE_ID40 = '';
      }
    });
    GridUtils.refreshRow(grid, e.row);
  };

  const setProject = (projects: string, projectsNames?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.PROJECT_CODE = projects;
    dataItem.PROJECT_NAME = projectsNames ?? '';
    gridRef.current?.refresh();
  };

  const setItem = (items: string, itemName?: string, itemType?: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.ITEM_ID = items;
    dataItem.ITEM_NAME = itemName ?? '';
    dataItem.ITEM_TYPE = itemType ?? '';
    gridRef.current?.refresh();
  };

  const setOwner = (owners: string) => {
    const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
    if (!dataItem) return;
    dataItem.USER_ID = owners;
    gridRef.current?.refresh();
  };

  const dataItem = GridUtils.getRow(gridRef.current, clickedRow);
  const cascadeDeptId = dataItem?.DEPT_ID || 'ALL';
  const cascadeEndCustomer = dataItem?.END_CUSTOMER40 || dataItem?.END_CUSTOMER || 'ALL';
  const cascadeSalesSite = dataItem?.SCM_SITE_ID40 || dataItem?.SCM_SITE_ID || 'ALL';

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.SSPM>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
        formatItem={handleFormatItem}
        cellEditEnded={handleCellEditEnded}
        isReadOnly={true}
      />
      {openProjectModal && (
        <ProjectByDivisionModal
          open={openProjectModal}
          modalClose={() => setOpenProjectModal(false)}
          setSelectedValue={setProject}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            salesSite: cascadeSalesSite,
            projectCode: '',
          }}
          callFromCell
        />
      )}
      {openItemModal && (
        <ItemByDivisionModal
          open={openItemModal}
          modalClose={() => setOpenItemModal(false)}
          setSelectedValue={setItem}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            salesSite: cascadeSalesSite,
            projectCode: dataItem?.PROJECT_CODE || 'ALL',
            activeFlag: 'ALL',
            itemId: '',
          }}
          callFromCell
          // 그리드 셀 호출은 좁은 조회를 쓴다 - AS-IS 가 셀 팝업만 DM0002_ItembySmallDivPopup
          //   으로 갈랐던 것과 같다(DMF0008_ErpEdiMaster.cs L2367 · L3150. 둘 다 sub grid 의
          //   ITEM_ID 셀, 신규 행에서만). 넓은 쪽은 team/end customer/site 축까지 펼쳐져 있어
          //   같은 Model 이 여러 줄로 보인다. 좁은 쪽은 아이템 마스터 축이라 그 중복이 없다.
          //   위 preSearchParams 의 dept/end customer/site/project 는 좁은 조회에 실리지 않는다 -
          //   팝업이 AS-IS 와 같이 'ALL' 로 덮는다(ItemByDivisionModal queryFilters).
          smallDivision={{ menuId: MENU_ID }}
        />
      )}
      {openOwnerModal && (
        <OwnerByDivisionModal
          open={openOwnerModal}
          modalClose={() => setOpenOwnerModal(false)}
          setSelectedValue={setOwner}
          preSearchParams={{
            divisionId: dataItem?.DIVISION_ID ?? '',
            deptId: cascadeDeptId,
            endCustomer: cascadeEndCustomer,
            projectCode: dataItem?.PROJECT_CODE || 'ALL',
            salesSite: cascadeSalesSite,
            owner: '',
          }}
          multiCheckbox
        />
      )}
    </>
  );
};
