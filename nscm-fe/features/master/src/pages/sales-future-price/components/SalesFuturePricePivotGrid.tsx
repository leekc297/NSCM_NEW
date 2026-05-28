/**
 * DMF0020 SalesFuturePrice — Tab2 Wijmo PivotGrid (분석 피벗)
 *
 * 사용자 요구 (2026-05-28): "위즈모 PIVOT 사용하는 것으로 TABPAGE 추가해서 생성".
 *
 * 데이터 소스: Tab1 메인 wide-format 결과 → 클라이언트 측 unpivot (utils/wideToLong.ts) →
 *             PivotEngine 의 rowFields/columnFields/valueFields 입력.
 * 사용자 결정 (2026-05-28 2차): 신규 RAW SP 추가 폐기 → 클라이언트 unpivot 채택.
 *
 * 룰 27 §C 의 PivotGrid React 패턴 정확 준수:
 *   - PivotEngine 1회 생성 보증 (useMemo)
 *   - fields.length === 0 일 때만 fields 설정 (data 변경 시 reset 방지)
 *   - beginUpdate/endUpdate 로 성능 보증
 */
import { PivotEngine } from '@mescius/wijmo.olap';
import { PivotGrid } from '@mescius/wijmo.react.olap';
import { useEffect, useMemo } from 'react';

import type { SalesFuturePriceRow } from '../sales-future-price.types';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';
import { wideToLong } from '../utils/wideToLong';

import styles from './SalesFuturePricePivotGrid.module.scss';

interface SalesFuturePricePivotGridProps {
  data: SalesFuturePriceRow[];
  /** Tab 활성 여부 — 비활성 시 unpivot/PivotEngine 갱신 SKIP (성능) */
  enabled: boolean;
}

export const SalesFuturePricePivotGrid = ({ data, enabled }: SalesFuturePricePivotGridProps) => {
  const { t } = useTranslation();
  const dynamicColumns = useSalesFuturePriceStore(state => state.dynamicColumns);

  /** PivotEngine 1회 생성 (룰 27 §C — Engine 재생성 금지) */
  const engine = useMemo(() => new PivotEngine(), []);

  /** 클라이언트 unpivot — wide → long. Tab 비활성 또는 빈 데이터 시 SKIP. */
  const longRows = useMemo(() => {
    if (!enabled || data.length === 0) return [];
    return wideToLong(data, dynamicColumns);
  }, [enabled, data, dynamicColumns]);

  useEffect(() => {
    if (!enabled) return;

    engine.beginUpdate();
    engine.itemsSource = longRows;

    // fields 초기 설정 — fields.length === 0 일 때만 (룰 27 §C 가드)
    if (engine.rowFields.length === 0 && engine.fields.length > 0) {
      // 기본 회전: Row = (Division × End Customer × Item) / Column = (YYYY-MM × Period) / Value = Sum(PRICE)
      const rowFieldNames = ['DIVISION_ID', 'END_CUSTOMER', 'ITEM_ID'];
      const columnFieldNames = ['YEAR_MONTH', 'PERIOD_LABEL'];
      const valueFieldName = 'PRICE';

      rowFieldNames.forEach(name => {
        const field = engine.fields.getField(name);
        if (field) engine.rowFields.push(field);
      });
      columnFieldNames.forEach(name => {
        const field = engine.fields.getField(name);
        if (field) engine.columnFields.push(field);
      });
      const valueField = engine.fields.getField(valueFieldName);
      if (valueField) {
        valueField.aggregate = 'Sum';
        valueField.format = 'n2';
        engine.valueFields.push(valueField);
      }
    }

    engine.endUpdate();
  }, [enabled, longRows, engine]);

  if (!enabled) {
    return (
      <div className={styles.placeholder}>
        {t('LBL_DMF0020_PIVOT_DISABLED', '_피벗 탭을 활성화하세요.')}
      </div>
    );
  }

  if (longRows.length === 0) {
    return (
      <div className={styles.placeholder}>
        {t('LBL_DMF0020_PIVOT_EMPTY', '_조회된 데이터가 없습니다. 메인 탭에서 먼저 조회하세요.')}
      </div>
    );
  }

  return (
    <div className={styles.container}>
      <PivotGrid
        itemsSource={engine}
        className={styles.pivotGrid}
        showRowFieldSort={true}
        showDetailOnDoubleClick={true}
      />
    </div>
  );
};
