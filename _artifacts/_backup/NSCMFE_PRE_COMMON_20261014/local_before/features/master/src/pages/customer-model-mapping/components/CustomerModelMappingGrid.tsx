import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import {
  CONVERT_QTY_BINDINGS,
  DIVISION_BINDING,
  getConvertQtyEditable,
  isDivisionAllowed,
  MODEL_TYPE_BINDING,
  PROJECT_CODE_BINDING,
  TEAM_BINDING,
  type MENU_ID,
  type SHEETS,
} from '../customer-model-mapping.constants';
import { buildTeamDataMap, TEAM_INSERT_COMBO_ID } from '../customer-model-mapping.gridCombos';
import { useCustomerModelMappingStore } from '../useCustomerModelMappingStore';

type CustomerModelMappingRow = ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>;

/** Convert Qty 3개 컬럼 바인딩 → editable 키 매핑 (Model Type 조건부 편집제어 대상). */
const CONVERT_QTY_EDITABLE_KEY: Record<string, 'pack' | 'module' | 'cell'> = {
  [CONVERT_QTY_BINDINGS.PACK]: 'pack',
  [CONVERT_QTY_BINDINGS.MODULE]: 'module',
  [CONVERT_QTY_BINDINGS.CELL]: 'cell',
};

interface CustomerModelMappingProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>[];
}

export const CustomerModelMappingGrid = ({
  gridRef,
  gridFilterRef,
  data,
}: CustomerModelMappingProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>> | undefined
  >();

  const staticColumn = useCustomerModelMappingStore(state => state.staticColumn);
  const divisionId = useCustomerModelMappingStore(state => state.searchParams.divisionId);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);

  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  // PJT Code 를 쓸 수 있는 Division 목록 — 관리자 UI Category Setup 의 PROJECT_CODE 행 Param1.
  //   미등록(빈 값)이면 제한 없음. 판정 규약은 isDivisionAllowed 주석 참조.
  const projectCodeDivisionAllow = staticColumn?.find(
    column => column.colNm === PROJECT_CODE_BINDING
  )?.attribute1;

  // 행의 Division 이 허용 목록 밖이면 PJT Code 를 잠근다 (인라인 편집 + 팝업 + 색상).
  const isProjectCodeLocked = (row?: CustomerModelMappingRow): boolean =>
    !isDivisionAllowed(projectCodeDivisionAllow, row?.[DIVISION_BINDING]);

  // Team 콤보 — 표시는 메타 콤보, 신규행 후보만 TEAM_INSERT_COMBO_ID (근거는 gridCombos 파일 주석).
  //   표시 콤보 id 는 메타(cellCboDataTp)에서 읽는다 — 하드코딩 금지.
  const teamColumn = staticColumn?.find(column => column.colNm === TEAM_BINDING);
  const teamDisplayComboId = teamColumn?.cellCboDataTp;

  // 표시 콤보는 공용 DataGrid 가 이미 같은 파라미터로 조회한다. 필터 값이 같으면 react-query 키가
  //   같아 캐시를 공유하므로 요청은 늘지 않는다(조회조건 카탈로그 필드와 같은 관용구).
  //   따옴표는 DataGrid comboParams 와 동일한 형태로 맞춘다 — 다르면 키가 갈려 같은 콤보를 두 번 탄다.
  const teamComboFilters = useMemo(
    () =>
      teamDisplayComboId
        ? [
            { comboId: String(teamDisplayComboId), divisionId: `'${divisionId}'` },
            { comboId: TEAM_INSERT_COMBO_ID, divisionId: `'${divisionId}'` },
          ]
        : [],
    [teamDisplayComboId, divisionId]
  );
  const [teamDisplayRows, teamInsertRows] = useTabComboQueries({ filters: teamComboFilters });

  // 재생성 시그니처 — division 을 반드시 포함한다. 빼면 division 전환 후 행수가 우연히 같을 때
  //   useMemo 가 재계산되지 않아 이전 division 의 맵이 남는다(DMF0042 실측).
  const teamComboSig = [
    teamDisplayComboId ?? '',
    teamColumn?.attribute2 ?? '',
    divisionId,
    teamDisplayRows?.length ?? 'x',
    teamInsertRows?.length ?? 'x',
  ].join('#');
  const teamDataMap = useMemo(
    () => buildTeamDataMap(teamDisplayRows ?? [], teamInsertRows ?? [], teamColumn?.attribute2),
    // 시그니처가 바뀔 때만 다시 만든다 — 매 렌더 새 DataMap 을 붙이면 아래 재적용이 무한 반복된다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [teamComboSig]
  );

  // 컬럼에 붙이기 — 공용 DataGrid 는 매 렌더 columnGroups 를 재대입해 Column 객체를 새로 만든다.
  //   한 번만 대입하면 다음 렌더에 메타 콤보 맵으로 되돌아가므로 updatedLayout 마다 다시 건다
  //   (DMF0049 EtcSalesReportsGrid 와 같은 처방).
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !teamDataMap) return;

    const applyTeamDataMap = () => {
      const column = g.columns.getColumn(TEAM_BINDING);
      // 같은 참조면 재대입하지 않는다 — 대입이 invalidate 를 부르므로 그대로 두면 갱신 루프가 된다.
      if (column && column.dataMap !== teamDataMap) column.dataMap = teamDataMap;
    };
    g.updatedLayout.addHandler(applyTeamDataMap);
    applyTeamDataMap();

    return () => {
      g.updatedLayout?.removeHandler(applyTeamDataMap);
    };
    // data 도 deps 에 둔다 — 그리드 인스턴스는 첫 렌더에 아직 없을 수 있고(gridRef 는 자식이 채운다),
    //   조회 때마다 한 번 더 걸어 두면 맵이 안 붙은 채 남는 경로가 없다. 재등록은 멱등이다.
  }, [gridRef, teamDataMap, data]);

  // ⭐ Model Type(ITEM_CLASS_NAME) 별 Convert Qty(Pack/Module/Cell) 조건부 편집제어.
  //   AS-IS DM0006_CustomerModelMapping.cs L289~307 / L1075~1089 재현. 공용 DataGrid wrapper 는
  //   컬럼 메타(_inputEditType)로만 편집여부를 결정하므로 행별(Model Type) 제어는 feature 에서
  //   beginningEdit(lock) + formatItem(gray) 핸들러로 추가한다. (DMF0020 SalesFuturePriceGrid 표준 패턴)
  //   FIFO 마지막 등록 → wrapper setEditableColumns / formatEditableColumns 보다 우선(#70 P7).
  //   Type 변경 시 수량 값은 유지(AS-IS LockRange = 잠금만, 값 초기화 없음).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 시작 시 — Model Type 상 잠긴 Convert Qty 셀이면 편집 차단.
    const beginningEditHandler = (
      s: FlexGrid<CustomerModelMappingRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = s.columns[e.col]?.binding ?? '';
      const key = CONVERT_QTY_EDITABLE_KEY[binding];
      if (!key) return;
      const row = s.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      const editable = getConvertQtyEditable(row?.[MODEL_TYPE_BINDING]);
      if (!editable[key]) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 셀 배경 — 잠긴 Convert Qty 셀 = Gray(wj-cell-non-editable) + wrapper 의 Yellow(wj-cell-editable) 제거.
    //   편집가능 셀의 Yellow 는 wrapper(formatEditableColumns)의 메타 판정에 위임(과잉 채색 방지) → non-editable 만 해제.
    //   backcolor 3색 표준(hook #95): Gray 는 "편집가능하나 조건부 잠금" 특수셀에만. 두 클래스 상호배타 toggle(재활용 잔존 방지).
    const formatHandler = (_s: FlexGrid<CustomerModelMappingRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = e.panel.columns[e.col]?.binding ?? '';
      const key = CONVERT_QTY_EDITABLE_KEY[binding];
      if (!key) return;
      const row = e.panel.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      const editable = getConvertQtyEditable(row?.[MODEL_TYPE_BINDING]);
      const locked = !editable[key];
      toggleClass(e.cell, 'wj-cell-non-editable', locked);
      if (locked) toggleClass(e.cell, 'wj-cell-editable', false); // wrapper 가 부여한 Yellow 제거
    };
    g.formatItem.addHandler(formatHandler);

    return () => {
      g.beginningEdit?.removeHandler(beginningEditHandler);
      g.formatItem?.removeHandler(formatHandler);
    };
  }, [gridRef, data]);

  // Division 별 PJT Code 편집제어 — 허용 Division 은 컬럼 메타 Param1 에서 읽는다(코드 하드코딩 금지).
  //   Convert Qty 제어와 같은 구성: beginningEdit(lock) + formatItem(gray). 팝업 차단은 handleGridDblclick.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      s: FlexGrid<CustomerModelMappingRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (s.columns[e.col]?.binding !== PROJECT_CODE_BINDING) return;
      const row = s.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      if (isProjectCodeLocked(row)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 잠긴 셀은 조회 전용 컬럼과 같은 흰색으로 둔다 — Yellow(편집색)와 팝업 아이콘만 걷어낸다.
    //   Gray(wj-cell-non-editable) 는 쓰지 않는다(사용자 요청). 셀 DOM 은 재활용되므로 Convert Qty
    //   셀에서 넘어온 Gray 가 남지 않도록 잠금 여부와 무관하게 매번 지운다.
    const formatHandler = (_s: FlexGrid<CustomerModelMappingRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      if (e.panel.columns[e.col]?.binding !== PROJECT_CODE_BINDING) return;
      toggleClass(e.cell, 'wj-cell-non-editable', false);
      const row = e.panel.rows[e.row]?.dataItem as CustomerModelMappingRow | undefined;
      if (!isProjectCodeLocked(row)) return;
      toggleClass(e.cell, 'wj-cell-editable', false);
      toggleClass(e.cell, 'wj-cell-popup', false);
    };
    g.formatItem.addHandler(formatHandler);
    g.invalidate();

    return () => {
      g.beginningEdit?.removeHandler(beginningEditHandler);
      g.formatItem?.removeHandler(formatHandler);
    };
    // isProjectCodeLocked 는 매 렌더 재생성이라 deps 에 넣으면 핸들러가 계속 재등록된다 —
    //   판정 입력인 메타(Param1)와 데이터만 본다.
  }, [gridRef, data, projectCodeDivisionAllow]); // eslint-disable-line react-hooks/exhaustive-deps

  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;

    const projectCode = projects?.split(',')[0] ?? '';
    const projectsName = projectsNames?.split(',')[0] ?? '';

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_CODE',
      clickedDataItem.PROJECT_CODE,
      projectCode
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_NAME',
      clickedDataItem.PROJECT_NAME,
      projectsName
    );

    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectsName;

    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  const handleItemSelected = (itemCode: string, itemName?: string, itemType?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_CLASS_NAME',
      clickedDataItem.ITEM_CLASS_NAME,
      itemType ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_NAME',
      clickedDataItem.ITEM_NAME,
      itemName ?? ''
    );

    clickedDataItem.ITEM_ID = itemCode;
    clickedDataItem.ITEM_CLASS_NAME = itemType ?? '';
    clickedDataItem.ITEM_NAME = itemName ?? '';

    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  const handleGridDblclick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    const editable = GridUtils.isEditableCell(grid, ht.row, ht.col);
    if (!editable) return;
    const binding = GridUtils.getBinding(grid, ht.col);
    const dataItem = GridUtils.getRow(grid, ht.row);

    if (!dataItem) return;

    if (binding === PROJECT_CODE_BINDING) {
      // 허용 Division 밖이면 팝업도 열지 않는다 (인라인 편집 차단과 일관).
      if (isProjectCodeLocked(dataItem)) return;
      setClickedRow(ht.row);
      setOpenPrjByDivisionModal(true);
    } else if (binding === 'ITEM_ID' || binding === 'ITEM_CLASS_NAME') {
      setClickedRow(ht.row);
      setOpenModelByDivisionModal(true);
    }
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumn ?? []}
        comboParams={{ divisionId: `'${divisionId}'` }}
        allowMerging={AllowMerging.All}
        dblClick={handleGridDblclick}
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={(projects, projectsNames) => {
          handleProjectSelected(projects, projectsNames);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE,
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={(items, itemName, itemType) => {
          handleItemSelected(items, itemName, itemType);
        }}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID,
          deptId: clickedDataItem?.DEPT_ID || 'ALL',
          endCustomer: clickedDataItem?.END_CUSTOMER || 'ALL',
          salesSite: clickedDataItem?.SCM_SITE_ID || 'ALL',
          projectCode: clickedDataItem?.PROJECT_CODE || 'ALL',
          activeFlag: clickedDataItem?.VALID_YN || 'ALL',
          itemId: clickedDataItem?.ITEM_ID || '',
        }}
        callFromCell={false}
      />
    </>
  );
};
