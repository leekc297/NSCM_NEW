import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, SHEETS, type BohMode } from '../shipment-request-electrode.constants';
import type { SearchParamProps, ShipmentPsiRow } from '../shipment-request-electrode.types';
import {
  bohSumColumnVisibility,
  isDynamicColumnVisible,
  parseDynamicColumnTag,
} from '../utils/shipment-request-electrode.dynamicColumn';

interface Props {
  rows: ShipmentPsiRow[];
  gridRef: MutableRefObject<FlexGridType<ShipmentPsiRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  bohMode: BohMode;
  bucketType: SearchParamProps['bucketType'];
  sumChecked: boolean;
  pastPeriodChecked: boolean;
  planDate: string;
  onFocus: () => void;
  onCellDoubleClick?: (row: ShipmentPsiRow) => void;
}

/**
 * spdMain(siMain) — Shipment Request(Electrode) pivot 메인그리드. 표시전용(design 03 §1.1 —
 * 전 칼럼 편집불가, 편집은 Edit 모드 진입 후에만 일부 셀 lock 반전, design 01 R9). 이번 회차는
 * 조회 표시 + BOH 3-way 컬럼셋 파생 + 동적 pivot 컬럼 visible 파생(design 03 §2.2)까지 배선한다.
 *
 * 확인 필요(design 03 §2.3/§6#1 — 임의 해소 금지): `SSP0022_GET_SHEET_CALENDAR_3SPAN`이 반환하는
 * 3-span(월/주/일) 헤더 구조가 SP 미배포로 확정되지 않아, 아래 dynamicColumns 는 행 데이터의
 * `X_/Y_/Z_` 접두 키를 평면 컬럼으로만 노출한다(월/주 단위 헤더 그룹핑은 SP 실측 후 구현). EditButton
 * 편집모드(SwitchLock/행별 CONFIRM_DAY lock, design 01 R9)도 SP 미배포로 검증 불가해 후속(convert-sp
 * 이후)으로 남긴다(04 참조).
 */
export const ShipmentRequestElectrodeMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  staticColumns,
  bohMode,
  bucketType,
  sumChecked,
  pastPeriodChecked,
  planDate,
  onFocus,
  onCellDoubleClick,
}: Props) => {
  // 9칼럼 3-way BOH 표시모드 토글(design 01 R4) — admin 정적컬럼 위에 visible 만 런타임 합성한다.
  //   CLAUDE.md §2 항목4(admin 속성 리터럴 덮어쓰기 금지)는 고정값 하드코딩을 금지하는 것이지,
  //   rdButton 선택이라는 런타임 상태에 따라 매 렌더 다시 계산하는 파생을 금지하지 않는다.
  const mergedColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    const sumVisibility = bohSumColumnVisibility(bohMode);
    return staticColumns.map(col => (col.colNm in sumVisibility ? { ...col, visible: sumVisibility[col.colNm] } : col));
  }, [staticColumns, bohMode]);

  // 동적 pivot 컬럼(design 03 §2.2) — GET SP 가 반환하는 행에서 X_/Y_/Z_ 태그 키만 뽑아 평면 컬럼으로
  //   노출한다. 헤더 3-span(월/주/일) 그룹핑은 SP 반환 스키마 확인 후 구현(§6#1 확인 필요, 임의 구현 금지).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const bindings = new Set<string>();
    rows.forEach(row => {
      Object.keys(row).forEach(key => {
        if (parseDynamicColumnTag(key)) bindings.add(key);
      });
    });
    return [...bindings]
      .filter(binding =>
        isDynamicColumnVisible(binding, { bohMode, bucketType, sumChecked, pastPeriodChecked, planDateYyyymmdd: planDate })
      )
      .sort()
      .map(binding => ({
        binding,
        header: binding,
        align: 'right',
        width: 90,
        allowSorting: false,
        visible: true,
      }));
  }, [rows, bohMode, bucketType, sumChecked, pastPeriodChecked, planDate]);

  // AS-IS SpdMain_CellDoubleClick(cs:1362-1420) — MEASURE-1 컬럼 더블클릭 시 ShipmentRequestPopup 오픈
  //   (bRealFlag 가드, buttonGuards#19-20). 팝업 자체는 이번 회차 미착수(04 미완 항목).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;
    const dataItem = GridUtils.getRow(grid, ht.row);
    if (dataItem) onCellDoubleClick?.(dataItem);
  };

  return (
    <DataGrid<ShipmentPsiRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={rows}
      staticColumns={mergedColumns}
      dynamicColumns={dynamicColumns}
      sheetName={ADMIN_SHEET_NAME[SHEETS.MAIN]}
      isReadOnly
      gotFocus={onFocus}
      dblClick={handleDblClick}
    />
  );
};
