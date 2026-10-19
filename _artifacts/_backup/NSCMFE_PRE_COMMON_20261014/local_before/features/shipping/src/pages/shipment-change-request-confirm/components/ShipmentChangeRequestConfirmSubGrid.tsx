import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import {
  CHANGE_TYPE_PLAN,
  MENU_ID,
  SUB_GROUP_LABEL,
  SUB_PLAN_HIDE_COLUMN,
} from '../shipment-change-request-confirm.constants';
import type { SubRow } from '../shipment-change-request-confirm.types';
import { buildColumns } from '../utils/shipmentChangeRequestConfirmColumns';

interface Props {
  rows: SubRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  changeType: string; // 선택 마스터행 CHANGE_TYPE — 'P'(Plan) 시 컬럼세트 분기(design 03 §2)
  adminColumns?: RawFlexGridColumnConfig[];
}

// _sChangeType='P'(Plan): ERP_SO_NO 숨김 + 그룹라벨 "Confirmed"->"Plan"/"Change"->"Confirm"(메타에 없어 FE 오버라이드).
//   else(C/N/A): ERP_SO_NO 표시 + 그룹라벨 "Confirmed"/"Change"(메타 SMALL_CLASS_LABEL_NAME 일치). design 03 §2 R2~R5.
const applyChangeTypeBranch = (
  cols: RawFlexGridColumnConfig[],
  changeType: string
): RawFlexGridColumnConfig[] => {
  const isPlan = changeType === CHANGE_TYPE_PLAN;
  if (!isPlan) return cols; // else 분기 = 메타 그대로(Confirmed/Change), ERP_SO_NO visible 유지
  return cols.map(c => {
    if (c.colNm === SUB_PLAN_HIDE_COLUMN) return { ...c, visible: false };
    if (c.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.confirmed)
      return { ...c, sClsLblNm: SUB_GROUP_LABEL.PLAN.confirmed };
    if (c.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.change)
      return { ...c, sClsLblNm: SUB_GROUP_LABEL.PLAN.change };
    return c;
  });
};

// AS-IS siSub "Shipment Change Request Confirm Detail" (50열, 전열 LockColumn = 조회전용).
//   2단 헤더(Confirmed/Change 또는 Plan/Confirm, SMALL_CLASS_LABEL_NAME, hook #93 48px). 셀콤보 1(FCST_TYPE).
export const ShipmentChangeRequestConfirmSubGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  changeType,
  adminColumns,
}: Props) => {
  const columns = useMemo(
    () => applyChangeTypeBranch(buildColumns(adminColumns, true), changeType),
    [adminColumns, changeType]
  );
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // GAP-02: AS-IS siSub SmartColMerge #38(design 03 §3 R11) — siMain 과 동일 세로 셀 병합.
      //   공용 DataGrid allowMerging=Cells + CustomMergeManager(좌측 누적 키 계층 병합). grid-behavior-parity §1.3.
      allowMerging={AllowMerging.Cells}
    />
  );
};
