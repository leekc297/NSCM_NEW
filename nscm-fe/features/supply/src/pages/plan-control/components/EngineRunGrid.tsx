import { AllowMerging } from '@mescius/wijmo.grid';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS } from '../plan-control.constants';
import type { EngineRunRow } from '../plan-control.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<EngineRunRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: EngineRunRow[];
  // admin SCM_MST_SHEET_COLUMNS 'Status' 7행. 전 컬럼 INPUT_TP_CD='S' 라 메타만으로 전건 잠금이다.
  staticColumns: RawFlexGridColumnConfig[];
  gotFocus?: () => void;
}

// spdSub "Status" — Engine Run 진행 상태 조회 전용. lookup 3행과 LEFT OUTER JOIN 이라 항상 3행이다.
//   AS-IS LockColumn(0, max, true)(G13)은 컬럼 메타 전건 'S' 와 일치해 추가 배선이 없다.
//   병합: 화면 .cs 에는 merge 토큰이 0건이지만 컬럼을 만드는 프레임워크 메타 빌더
//   (SpreadInfo.cs:1706 SetSheetHeaderColumn, 화면 cs:313 이 호출)가 L1797 에서 `merge =
//   FPMerge.Restricted` 를 **무조건** 대입하고 Add*Column 이 그 값을 col.MergePolicy 에 그대로 넣는다
//   (L2605-2617). 즉 Status 7컬럼은 전건 Restricted 계층 병합이다 — grep 0건을 병합 없음으로 읽으면
//   누락된다(guides/grid-behavior-parity.md §1.1). 공용 DataGrid 는 allowMerging 이 켜지면
//   CustomMergeManager(좌측 누적 키 = Restricted 등가)를 자동 설치한다.
export const EngineRunGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  gotFocus,
}: Props) => (
  <DataGrid<EngineRunRow>
    gridRef={gridRef}
    gridFilterRef={gridFilterRef}
    isReadOnly
    itemsSource={data}
    staticColumns={staticColumns}
    sheetName={ADMIN_SHEET_NAME[SHEETS.ENGINE_RUN]}
    allowMerging={AllowMerging.Cells}
    gotFocus={gotFocus}
  />
);
