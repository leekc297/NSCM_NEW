import { useCallback, useEffect, useMemo, useState } from 'react';

import type { PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { useTabComboQueries } from '@shared/hooks';

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
import { COMBO, FIXED_DIVISION, type MENU_ID } from './demand-as-dashboard.constants';
import { buildBaseFilters } from './demand-as-dashboard.filters';
import type { ProductKey } from './demand-as-dashboard.types';
import styles from './DemandAsDashboard.module.scss';
import { useDemandAsDashboardStore } from './useDemandAsDashboardStore';

// DMD0001 (Demand > Demand AS Dashboard) — 무스크롤 고정 레이아웃.
//   조회조건(기준월/BizType/OEM)은 스토어가 들고, buildBaseFilters 로 proc 요청(baseFilters)을 만든다.
//   각 위젯은 자기 필터로 useTabProcQuery 조회 → <widget>.map.ts 로 변환해 렌더한다(PKG_DMD0001 실데이터).
//   필터 객체는 useMemo 로 참조를 고정한다(useTabProcQuery 가 filters 를 참조 비교해 재조회하므로).
//   콤보(헤더 필터·차트 제품)는 선택만 draft 에 담고, 새로고침 버튼에서 한 번에 적용(applied)한다 —
//     선택 즉시 재조회하지 않는다. applied 값(searchParams·demandProduct·invProduct)만 필터를 구동한다.
const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const DemandAsDashboard = ({ tabId }: PageProps<MENU_ID>) => {
  const searchParams = useDemandAsDashboardStore(state => state.searchParams);
  const setSearchParams = useDemandAsDashboardStore(state => state.setSearchParams);

  // 콤보가 편집하는 draft. 표시는 draft, 조회는 applied 로 분리해 선택이 즉시 재조회로 새지 않게 한다.
  const [draft, setDraft] = useState({
    baseMonth: searchParams.baseMonth,
    bizType: searchParams.bizType,
    oem: searchParams.oem,
    demandProduct: 'P30B' as ProductKey,
    invProduct: 'N2.2A' as ProductKey,
  });

  // 기준월 옵션 — SCP0055 gap date 콤보(COMBO.BASE_DATE=DATE_WEEKLY, @divisionId=Div 고정) 로드.
  //   CODE=기준 주차 시작일(YYYYMMDD), NAME='YYYY-MM-DD (W##)'. 라벨만 '기준월'(헤더에서 유지).
  const [baseDateRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.BASE_DATE, divisionId: FIXED_DIVISION }],
  });
  const baseMonthOptions = useMemo(
    () =>
      (baseDateRows ?? []).map(r => ({
        label: str((r as Record<string, unknown>).NAME) || str(r.CODE),
        value: str(r.CODE),
      })),
    [baseDateRows]
  );

  // 콤보 로드 후 기준월 시드 — applied 값이 공란이거나 현재 옵션에 없으면(스테일) 최신 주차(0번)로 맞춘다.
  //   applied·draft 둘 다 세팅해 화면 표시와 조회를 일치시킨다.
  useEffect(() => {
    if (!baseMonthOptions.length) return;
    if (baseMonthOptions.some(o => o.value === searchParams.baseMonth)) return;
    const latest = baseMonthOptions[0].value;
    setSearchParams({ baseMonth: latest });
    setDraft(prev => ({ ...prev, baseMonth: latest }));
  }, [baseMonthOptions, searchParams.baseMonth, setSearchParams]);

  // 조회조건 → proc 요청 파라미터. applied(searchParams) 변경 시에만 재계산되어 재조회 트리거가 된다.
  const baseFilters = useMemo(() => buildBaseFilters(searchParams), [searchParams]);

  // 위젯 필터 객체는 참조가 안정적이어야 한다 — useTabProcQuery 가 filters 를 참조 비교해
  //   재조회를 트리거하므로, 매 렌더 새 객체를 주면 무한 재조회 루프가 된다. useMemo 로 고정한다.
  const forecastFilters = useMemo(
    () => ({ yyyymmdd: baseFilters.yyyymmdd }),
    [baseFilters.yyyymmdd]
  );

  // 차트별 제품 드롭다운(applied) → nickName 필터. 선택은 draft 에 담기고 새로고침에서 여기로 반영된다.
  const [demandProduct, setDemandProduct] = useState<ProductKey>('P30B');
  const [invProduct, setInvProduct] = useState<ProductKey>('N2.2A');

  const demandFilters = useMemo(
    () => ({ ...baseFilters, nickName: demandProduct }),
    [baseFilters, demandProduct]
  );

  const inventoryFilters = useMemo(
    () => ({ ...baseFilters, nickName: invProduct }),
    [baseFilters, invProduct]
  );

  // cover/mape 는 제품 드롭다운이 없다 — nickName 빈값(전체 모델코드).
  const allProductFilters = useMemo(() => ({ ...baseFilters, nickName: '' }), [baseFilters]);

  // 새로고침 — draft 선택을 applied 에 한 번에 반영하고, 이 탭의 모든 위젯 쿼리를 무효화해
  //   재조회한다(queryKey 선두가 tabId). 선택이 그대로여도(무변경 새로고침) invalidate 로 갱신된다.
  const queryClient = useQueryClient();
  const handleRefresh = useCallback(() => {
    setSearchParams({ baseMonth: draft.baseMonth, bizType: draft.bizType, oem: draft.oem });
    setDemandProduct(draft.demandProduct);
    setInvProduct(draft.invProduct);
    void queryClient.invalidateQueries({ queryKey: [tabId] });
  }, [queryClient, tabId, draft, setSearchParams]);

  return (
    <div className={styles.root}>
      <DashboardHeader
        div={FIXED_DIVISION}
        baseMonth={draft.baseMonth}
        baseMonthOptions={baseMonthOptions}
        bizType={draft.bizType}
        oem={draft.oem}
        onDivChange={() => {
          /* Div 는 FIXED_DIVISION 고정(disabled) — 변경 없음 */
        }}
        onBaseMonthChange={value => setDraft(prev => ({ ...prev, baseMonth: value }))}
        onBizTypeChange={value => setDraft(prev => ({ ...prev, bizType: value }))}
        onOemChange={value => setDraft(prev => ({ ...prev, oem: value }))}
        onRefresh={handleRefresh}
      />

      {/* 기준월(COMBO.BASE_DATE)이 시드되기 전(공란)엔 위젯이 빈 날짜로 proc 를 치지 않게 렌더를 보류한다. */}
      {Boolean(baseFilters.yyyymmdd) && (
        <>
          <KpiSummary tabId={tabId} filters={baseFilters} />

          <div className={styles.midRow}>
            <ProductStatusGrid tabId={tabId} filters={baseFilters} />
            <RiskHeatMap tabId={tabId} filters={baseFilters} />
          </div>

          <div className={styles.chartsRow}>
            <DemandForecastChart
              product={draft.demandProduct}
              onProductChange={p => setDraft(prev => ({ ...prev, demandProduct: p }))}
              tabId={tabId}
              filters={demandFilters}
            />
            <InventoryProjectionChart
              product={draft.invProduct}
              onProductChange={p => setDraft(prev => ({ ...prev, invProduct: p }))}
              tabId={tabId}
              filters={inventoryFilters}
            />
            <CoverMonthChart tabId={tabId} filters={allProductFilters} />
          </div>

          <div className={styles.bottomRow}>
            <ExcessStatus tabId={tabId} filters={baseFilters} />
            <MapeChart tabId={tabId} filters={allProductFilters} />
            <ForecastInfo tabId={tabId} filters={forecastFilters} />
          </div>
        </>
      )}
    </div>
  );
};
