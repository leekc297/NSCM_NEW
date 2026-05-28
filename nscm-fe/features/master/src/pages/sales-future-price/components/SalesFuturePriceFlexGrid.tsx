/**
 * DMF0020 SalesFuturePrice — Tab1 FlexGrid (wide-format)
 *
 * AS-IS: DMF0020_SalesFuturePrice.cs (spdMain — 1 FpSpread).
 * 메인 SP `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` 가 PIVOT 결과 (시간축 컬럼 펼침) 로 반환 →
 * 그대로 FlexGrid 에 표시 (사용자 요구: "기존 SP 결과 그대로 GRID에서 사용").
 *
 * 4축 매핑:
 *   - Validation #49~#69 (ComboSelChange / Dsdm_Changed / CellDoubleClick / CellClick / Raw_CellClick)
 *   - Expression #1~#2 (SetSpreadHeaderSpan SUM 헤더) + #3~#7 (동적 컬럼 / 3단 헤더 / RowSpan)
 */
import {
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { useSalesFuturePriceExpression } from '../hooks/useSalesFuturePriceExpression';
import { useSalesFuturePriceValidation } from '../hooks/useSalesFuturePriceValidation';
import type { SalesFuturePriceRow } from '../sales-future-price.types';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';
import { buildGroupKey } from '../utils/wideToLong';

interface SalesFuturePriceFlexGridProps {
  gridRef: MutableRefObject<FlexGrid<SalesFuturePriceRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<SalesFuturePriceRow> | undefined>;
  data: SalesFuturePriceRow[];
}

export const SalesFuturePriceFlexGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
}: SalesFuturePriceFlexGridProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const staticColumns = useSalesFuturePriceStore(state => state.staticColumns);
  const dynamicColumns = useSalesFuturePriceStore(state => state.dynamicColumns);
  const selectedGroupKey = useSalesFuturePriceStore(state => state.selectedGroupKey);
  const setSelectedGroupKey = useSalesFuturePriceStore(state => state.setSelectedGroupKey);
  const searchParams = useSalesFuturePriceStore(state => state.searchParams);

  const { onCellEditEnded, onComboSelChange, onCellDblClick, onCellClick, onRawCellClick } =
    useSalesFuturePriceValidation();
  const { buildLargeSumHeader, setExchangeValues } = useSalesFuturePriceExpression();

  /** Expression #3~#5: 좌측 11 고정 컬럼 + 동적 시간축 (3단 헤더 SUM 그룹) */
  const columns = useMemo(() => {
    const dyn = dynamicColumns.filter(c => c.visible);
    return [...staticColumns, ...buildLargeSumHeader(dyn)];
  }, [staticColumns, dynamicColumns, buildLargeSumHeader]);

  /** Expression #7: 동일 그룹 키 행 배경 강조 (RowSpan + 그룹 동시 선택) */
  const handleFormatItem = (s: FlexGrid, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    const row = s.rows[e.row]?.dataItem as SalesFuturePriceRow | undefined;
    if (row && selectedGroupKey && buildGroupKey(row) === selectedGroupKey) {
      e.cell.classList.add('selected-group');
    }
  };

  /** Validation #62~#69: CellClick + Raw_CellClick — 사업부 81/82 분기 + Currency 가드 */
  const handleClick = (e: MouseEvent) => {
    const s = gridRef.current;
    if (!s) return;
    const ht = s.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const row = s.rows[ht.row]?.dataItem as SalesFuturePriceRow | undefined;
    if (!row) return;

    const eArgs = { row: ht.row, col: ht.col } as unknown as CellRangeEventArgs;

    // L3690: Currency 셀 + 빈값 → 안내
    const binding = GridUtils.getBinding(s, ht.col);
    if (binding === 'CURRENCY' && !row.CURRENCY) {
      void setAlert({ type: 'alert', content: t('MSG00447', '_Currency 가 비어 있습니다.') });
    }

    setSelectedGroupKey(buildGroupKey(row));
    onRawCellClick(s, eArgs, searchParams.divisionId);
    onCellClick(s, eArgs);
  };

  /** Validation #57~#59: CellDoubleClick — 헤더 가드 + 사업부 40 RowSpan + Visible 가드 */
  const handleCellDblClick = (e: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(e);
    if (ht.cellType !== CellType.Cell && ht.cellType !== CellType.ColumnHeader) return;
    onCellDblClick(grid, ht, searchParams.divisionId);
  };

  /** Validation #49~#55 + Expression #9: Cell Edit End — CRUD_TYPE 마킹 + Combo/사업부 분기 + 환율 동기 */
  const handleCellEditEnded = (s: FlexGrid, e: CellRangeEventArgs) => {
    const dataItem = s.rows[e.row]?.dataItem as SalesFuturePriceRow | undefined;
    if (!dataItem) return;

    // Expression #9: DataModel.Changed → 자동 EditFlag='U'
    if (dataItem.CRUD_TYPE !== CRUD_TYPE.INSERT && dataItem.CRUD_TYPE !== CRUD_TYPE.DELETE) {
      dataItem.CRUD_TYPE = CRUD_TYPE.MODIFY;
    }

    onCellEditEnded(s, e, searchParams.divisionId);
    onComboSelChange(s, e, searchParams.divisionId);
    setExchangeValues(s, e, searchParams.divisionId);
  };

  return (
    <DataGrid<SalesFuturePriceRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={columns}
      frozenColumns={11}
      allowMerging='Cells'
      formatItem={handleFormatItem}
      cellEditEnded={handleCellEditEnded}
      click={handleClick}
      dblClick={handleCellDblClick}
    />
  );
};
