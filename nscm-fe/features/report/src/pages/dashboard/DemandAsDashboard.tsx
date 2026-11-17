import { useState } from 'react';

import type { PageProps } from '@foundation/models';

import { CoverMonthChart } from './components/CoverMonthChart';
import { DashboardHeader } from './components/DashboardHeader';
import { DemandForecastChart } from './components/DemandForecastChart';
import { ExcessStatus } from './components/ExcessStatus';
import { ForecastInfo } from './components/ForecastInfo';
import { InventoryProjectionChart } from './components/InventoryProjectionChart';
import { KpiSummary } from './components/KpiSummary';
import { MapeChart } from './components/MapeChart';
import { ProductStatusGrid } from './components/ProductStatusGrid';
import { RiskHeatMap } from './components/RiskHeatMap';
import type { MENU_ID } from './demand-as-dashboard.constants';
import { BASE_MONTH, FOOTER_NOTE, type ProductKey } from './demand-as-dashboard.mock';
import styles from './DemandAsDashboard.module.scss';

// DMD0001 (Demand > Demand AS Dashboard) — 목업. 무스크롤 고정 레이아웃.
//   검색조건(기준월/BizType/OEM) 변경 → refreshKey 갱신 → 차트 재생성("재조회").
//   차트별 제품 드롭다운 변경 → 해당 차트 시리즈 스왑. (데이터는 정적 목업)
export const DemandAsDashboard = (_props: PageProps<MENU_ID>) => {
  const [baseMonth, setBaseMonth] = useState(BASE_MONTH);
  const [bizType, setBizType] = useState('전체');
  const [oem, setOem] = useState('전체');
  const [demandProduct, setDemandProduct] = useState<ProductKey>('P30B');
  const [invProduct, setInvProduct] = useState<ProductKey>('N2.2A');

  const refreshKey = `${baseMonth}|${bizType}|${oem}`;

  return (
    <div className={styles.root}>
      <DashboardHeader
        baseMonth={baseMonth}
        bizType={bizType}
        oem={oem}
        onBaseMonthChange={setBaseMonth}
        onBizTypeChange={setBizType}
        onOemChange={setOem}
      />

      <KpiSummary />

      <div className={styles.midRow}>
        <ProductStatusGrid />
        <RiskHeatMap />
      </div>

      <div className={styles.chartsRow}>
        <DemandForecastChart
          product={demandProduct}
          onProductChange={setDemandProduct}
          refreshKey={refreshKey}
        />
        <InventoryProjectionChart
          product={invProduct}
          onProductChange={setInvProduct}
          refreshKey={refreshKey}
        />
        <CoverMonthChart refreshKey={refreshKey} />
      </div>

      <div className={styles.bottomRow}>
        <ExcessStatus />
        <MapeChart />
        <ForecastInfo />
      </div>

      <div className={styles.footer}>{FOOTER_NOTE}</div>
    </div>
  );
};
