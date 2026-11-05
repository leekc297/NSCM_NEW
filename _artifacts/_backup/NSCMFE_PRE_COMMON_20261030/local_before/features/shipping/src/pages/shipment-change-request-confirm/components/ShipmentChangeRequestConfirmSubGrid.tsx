import { AllowMerging, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo } from 'react';

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

  /**
   * 헤더/값 잘림 방지 — 표시 컬럼을 내용(헤더 라벨 + 데이터)에 맞춰 자동 조절한다. extra 8px 여백.
   *   50열 2단 헤더라 메타 폭만으로는 헤더 라벨이 잘린다(사용자 신고 2026-10-07). 자매 SSP0003 과 동일 처방.
   *   `autoSizeColumn(c, header, extra)` 의 `header` 는 "c 가 헤더행 인덱스인지"라 데이터 컬럼은 false 다
   *   (false 로도 헤더 라벨과 데이터 셀을 모두 재어 더 넓은 쪽에 맞춘다).
   *   폭 0·`visible:false`(Plan 분기 ERP_SO_NO) 컬럼은 건드리지 않는다 — autoSize 로 되살리면 안 된다.
   */
  const autoFitColumns = useCallback((grid: FlexGridType) => {
    for (let i = 0; i < grid.columns.length; i += 1) {
      const col = grid.columns[i];
      if (!col?.visible || col.width === 0) continue;
      try {
        grid.autoSizeColumn(i, false, 8);
      } catch {
        /* 렌더 전 측정 실패는 무시 — 다음 트리거에서 다시 맞춘다 */
      }
    }
  }, []);

  const handleInitialized = useCallback(
    (grid: FlexGridType) => {
      grid.loadedRows.addHandler(() => autoFitColumns(grid));
    },
    [autoFitColumns]
  );

  // 컬럼(메타 async 도착·Plan 분기)·행이 바뀐 뒤 렌더가 끝난 다음 프레임에 폭을 맞춘다.
  //   렌더 전에 재면 셀 폭이 0 이라 헤더가 계속 잘린다(빈 그리드는 loadedRows 가 안 와서 이 경로가 필수).
  useEffect(() => {
    const raf = requestAnimationFrame(() => {
      const grid = gridRef.current;
      if (grid) autoFitColumns(grid);
    });
    return () => cancelAnimationFrame(raf);
  }, [columns, rows, autoFitColumns, gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      initialized={handleInitialized}
      /* 2단 헤더 그룹라벨(Confirmed/Change)을 **가로로 병합**하려면 헤더 병합 모드여야 한다.
         종전 `AllowMerging.Cells` 는 데이터 셀 전용이라 헤더 병합 경로가 즉시 null 을 반환했고
         (mergeManager.ts:167~172 — All/AllHeaders/ColumnHeaders 만 허용) 그룹라벨이 열마다 반복돼 보였다
         (사용자 신고 2026-10-07). 자매 SSP0003 sub 와 동일하게 ColumnHeaders 로 맞춘다.
         트레이드오프: AS-IS `siSub.SmartColMerge()`(cs:709) 의 데이터 셀 세로병합은 포기한다 —
         자매 화면과의 헤더 일치를 우선한 사용자 결정이다. 되살리려면 `AllowMerging.All` 로 올린다. */
      allowMerging={AllowMerging.ColumnHeaders}
    />
  );
};
