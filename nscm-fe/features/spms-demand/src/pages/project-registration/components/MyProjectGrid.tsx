import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { useSessionStore } from '@shared/stores';

import { TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { RESPONSE_SET, SHEET_INDEX } from '../project-registration.constants';
import { formatSopDate } from '../project-registration.grid-utils';
import type { MyProjectRow } from '../project-registration.types';
import gridStyles from '../ProjectRegistration.module.scss';
import { useProjectRegistrationStore } from '../useProjectRegistrationStore';

import { MyWorkPopup } from './myWorkPopup/MyWorkPopup';

interface MyProjectGridProps {
  gridRef: MutableRefObject<FlexGrid<MyProjectRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MyProjectRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
}

const MY_WORK_ICON = renderToStaticMarkup(<FunctionSearchIcon appearance='lined' />);

// 화면설계서 TAB2 "나의 프로젝트 현황" 그리드.
// - 조회 전용(등록/수정 없음 — TAB2 §프로시저: 저장/삭제 모두 <해당없음>이라 isReadOnly)
// - "My Work" 열(아이콘 전용 셀, 화면설계서 "UI컬럼 및 Measure정의" M열="ICON", 컬럼명 MY_WORK)
//   클릭 시 그 row 의 My Work 팝업을 연다.
export const MyProjectGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
}: MyProjectGridProps) => {
  const staticColumns = useProjectRegistrationStore(
    state => state.staticColumns[RESPONSE_SET.MY_PROJECT]
  );
  const searchDivisionId = useProjectRegistrationStore(state => state.searchParams.divisionId);

  const [myWorkOpen, setMyWorkOpen] = useState(false);
  const [myWorkPjtKey, setMyWorkPjtKey] = useState('');
  const [myWorkPjtCode, setMyWorkPjtCode] = useState('');
  const [divisionId, setDivisionId] = useState('');
  const tagLayerRef = useRef<TagLayerHandle>(null);
  const sesUserId = useSessionStore(state => state.session.userId ?? '');

  // 이 그리드에 포커스가 가면 상위에 "지금 MY_PROJECT 탭이 활성"이라고 알린다.
  const handleFocus = () => setActiveTab(SHEET_INDEX.MY_PROJECT);

  const handleInitialized = (grid: FlexGrid<MyProjectRow>) => {
    grid.rowHeaders.columns[0].width = 40;
  };

  const handleGridClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);
    if (!dataItem || binding !== 'MY_WORK') return;

    setMyWorkPjtKey(dataItem.DPJT_KEY);
    setMyWorkPjtCode(dataItem.DPJT_CODE);
    setDivisionId(dataItem.DIVISION_ID);
    setMyWorkOpen(true);
  };

  const handleFormatItem = (grid: FlexGrid<MyProjectRow>, event: FormatItemEventArgs) => {
    if (event.panel.cellType !== CellType.Cell) return;

    const binding = grid.columns[event.col]?.binding;
    const row = GridUtils.getRow(grid, event.row);
    const isMyWork = binding === 'MY_WORK';
    const isRegStatus = binding === 'DPJT_REG_STATUS_NAME';

    if (!isRegStatus) {
      tagLayerRef.current?.clear(event.cell);
    }
    if (binding === 'SOP_DATE') {
      event.cell.textContent = formatSopDate(row?.SOP_DATE);
    }
    if (binding === 'REG_COMP_DATE') {
      event.cell.textContent = formatSopDate(row?.REG_COMP_DATE);
    }
    if (isRegStatus && row?.DPJT_REG_STATUS_NAME) {
      tagLayerRef.current?.apply(
        event.cell,
        row.DPJT_REG_STATUS_NAME,
        row.DPJT_REG_STATUS_COLOR_TYPE
      );
    } else if (isRegStatus) {
      tagLayerRef.current?.clear(event.cell);
    }
    event.cell.classList.toggle(gridStyles.myWorkIcon, isMyWork);
    if (!isMyWork) return;

    event.cell.innerHTML = MY_WORK_ICON;
  };

  return (
    <>
      <TagLayer ref={tagLayerRef} />
      <DataGrid<MyProjectRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        itemsSource={data}
        staticColumns={staticColumns}
        comboParams={{ divisionId: `'${searchDivisionId}'` }}
        isReadOnly
        initialized={handleInitialized}
        gotFocus={handleFocus}
        click={handleGridClick}
        formatItem={handleFormatItem}
      />
      <MyWorkPopup
        open={myWorkOpen}
        pjtKey={myWorkPjtKey}
        pjtCode={myWorkPjtCode}
        sesUserId={sesUserId}
        divisionId={divisionId}
        onClose={() => setMyWorkOpen(false)}
      />
    </>
  );
};
