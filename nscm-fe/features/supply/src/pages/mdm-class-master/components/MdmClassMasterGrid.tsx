import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { MAIN_COLUMNS } from '../mdm-class-master.constants';
import type { MainRow } from '../mdm-class-master.types';
import { buildColumns } from '../utils/mdmClassMasterColumns';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

export const MdmClassMasterGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 편집가능 컬럼은 admin 메타 INPUT_TP_CD='O'(ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL) 3컬럼으로 한정 —
  //   공용 DataGrid isEditableCell(inputTpCd 구동)이 그 3컬럼만 default 편집가능으로 열고 나머지 20컬럼은
  //   읽기전용 유지한다(화면단위 편집모드 게이트 없음 — 사용자 지시 default 편집).
  // allowMerging=ColumnHeaders — 2단 헤더에서 같은 값 셀 병합(AS-IS SmartColMerge 재현, design 03 §2):
  //   Level 1~4 그룹은 Code/Name/ID 가로 병합, 단일컬럼은 상/하단 동일 라벨 세로 병합(rowspan 2).
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      allowMerging={AllowMerging.ColumnHeaders}
      gotFocus={onFocus}
    />
  );
};
