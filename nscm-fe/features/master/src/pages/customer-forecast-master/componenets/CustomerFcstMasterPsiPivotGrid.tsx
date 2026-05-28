import { PivotEngine } from '@mescius/wijmo.olap';
import { PivotGrid } from '@mescius/wijmo.react.olap';
import { useEffect, useMemo } from 'react';

import type { MENU_ID, SHEETS } from '../customer-fcst-master.constants';

interface CustomerFcstMasterPsiPivotGridProps {
  data: ResponseData<MENU_ID, SHEETS.CUSTOMER_PSI_PIVOT>[];
}

export const CustomerFcstMasterPsiPivotGrid = ({ data }: CustomerFcstMasterPsiPivotGridProps) => {
  const engine = useMemo(() => {
    const e = new PivotEngine();
    e.autoGenerateFields = true;
    return e;
  }, []);

  useEffect(() => {
    engine.beginUpdate();
    engine.itemsSource = data;

    if (engine.rowFields.length === 0 && engine.fields.length > 0) {
      const has = (name: string) => engine.fields.getField(name) !== null;
      const pushIfExists = (target: { push: (name: string) => void }, name: string) => {
        if (has(name)) target.push(name);
      };

      pushIfExists(engine.rowFields, 'DIVISION_ID');
      pushIfExists(engine.rowFields, 'CUSTOMER_CODE');
      pushIfExists(engine.rowFields, 'SCM_SITE_ID');
      pushIfExists(engine.rowFields, 'MEASURE_GROUP');
      pushIfExists(engine.rowFields, 'MEASURE');

      pushIfExists(engine.columnFields, 'SUMMARY_BUCKET_VALUE');

      pushIfExists(engine.valueFields, 'SUMMARY_BUCKET_YN');
    }
    engine.endUpdate();
  }, [data, engine]);

  return (
    <PivotGrid
      style={{ height: '100%' }}
      itemsSource={engine}
      showRowFieldHeaders={true}
      showColumnFieldHeaders={true}
      showValueFieldHeaders={true}
      collapsibleSubtotals={true}
    />
  );
};
