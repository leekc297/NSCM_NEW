import { CellType, SelectionMode, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { MENU_ID, RESPONSE_SET } from '../dynamic-query.constants';
import { SHEETS } from '../dynamic-query.constants';
import { useDynamicQueryStore } from '../useDynamicQueryStore';

import { DynamicQueryModal } from './DynamicQueryModal';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>[];
  goViewTab: () => void;
  // SQL Query 팝업이 기존 저장 row 의 columns/parameters 를 DQ_ID 로 조회할 때 사용.
  tabId: string;
}

export const DynamicQueryMainGrid = ({ gridRef, gridFilterRef, data, goViewTab, tabId }: Props) => {
  const setDynamicQueryMeta = useDynamicQueryStore(s => s.setDynamicQueryMeta);
  const setViewColumnsFilters = useDynamicQueryStore(s => s.setViewColumnsFilters);
  const setViewParametersFilters = useDynamicQueryStore(s => s.setViewParametersFilters);
  const setSqlText = useDynamicQueryStore(s => s.setSqlText);
  const setResultGridColumns = useDynamicQueryStore(s => s.setResultGridColumns);
  const clearResultFilter = useDynamicQueryStore(s => s.clearResultFilter);

  const staticColumns = useDynamicQueryStore(s => s.staticColumns[SHEETS.MAIN]);
  const [clickedRow, setClickedRow] = useState<
    ResponseData<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT> | undefined
  >(undefined);

  // 컬럼 헤더 앞에 View탭 이동을 위한 셀 추가!
  const veiwColumn = [
    {
      colNm: 'VIEW',
      colLblNm: 'View',
      cellCtrlObjTpCd: 'FPModal',
      cellCboDataTp: null,
      inputTpCd: 'O',
      horzAlgnCd: 'L',
      scale: null,
      colWth: 60,
      fixed: true,
      uppercase: false,
      visible: true,
      personalizable: false,
      display: true,
    },
  ];
  const columns = [...veiwColumn, ...staticColumns] as RawFlexGridColumnConfig[];

  const [dynamicQueryModalOpen, setDynamicQueryModalOpen] = useState(false);

  const handleSelectionChanged = (g: FlexGrid) => {};
  const handleCellEditEnded = (g: FlexGrid, e: { row: number; col: number }) => {};

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || !binding) return;

    if (binding === 'VIEW' && dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT) {
      const viewFormData = {
        reportName: dataItem.DQ_NAME,
        description: dataItem.DESCRIPTION,
        role: dataItem.GROUP_NAME,
      };
      // view 탭의 검색 폼처럼 보이는 정보 세팅
      setDynamicQueryMeta(viewFormData);
      // view 턥의 내부 데이터 조회 및 세팅
      setViewColumnsFilters({ dqId: Number(dataItem.DQ_ID) });
      // view 턥의 내부 데이터 조회 및 세팅
      setViewParametersFilters({ dqId: Number(dataItem.DQ_ID) });
      // view 탭의 내부 SQL Text 세팅
      setSqlText(dataItem.DQ_TEXT);
      // view 탭의 결과 그리드 컬럼 초기회
      setResultGridColumns([]);
      // 이전 리포트의 실행 결과(Result 건수)가 새 리포트로 넘어와 남아있지 않도록 초기화
      clearResultFilter();

      // 단순 탭 이동
      setTimeout(() => {
        goViewTab();
      }, 0);

      return;
    }

    if (binding === 'DQ_NAME') {
      // AS-IS spdMain_CellDoubleClick(편집 분기): 클릭 row 를 팝업에 넘겨 pre-populate.
      setClickedRow(dataItem);
      setDynamicQueryModalOpen(true);
      return;
    }
    if (GridUtils.isEditableCell(grid, ht.row, ht.col)) return;
  };

  // 그리드가 변경되었을 경우 서버에서 가져온 데이터만 view 탭으로 이동할 수 있도록 처리
  const gridData = useMemo(() => {
    data.forEach(item => {
      if (!item?.CRUD_TYPE || item?.CRUD_TYPE === 'M') {
        item.VIEW = 'View';
      } else if (item?.CRUD_TYPE === 'I') {
        item.EDIT_FLAG = 'N';
      }
      return item;
    });
    return data;
  }, [data]);

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.MAIN>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={gridData}
        staticColumns={columns}
        selectionMode={SelectionMode.Row}
        selectionChanged={handleSelectionChanged}
        cellEditEnded={handleCellEditEnded}
        dblClick={handleDblClick}
      />
      <DynamicQueryModal
        open={dynamicQueryModalOpen}
        initialRow={clickedRow}
        tabId={tabId}
        modalClose={() => {
          setDynamicQueryModalOpen(false);
        }}
        onSaved={() => {
          gridRef.current?.collectionView.refresh();
          gridRef.current?.invalidate();
        }}
      />
    </>
  );
};
