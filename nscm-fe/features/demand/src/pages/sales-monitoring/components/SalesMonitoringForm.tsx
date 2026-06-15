import { Checkbox, FormControlLabel, MenuItem, Select } from '@mui/material';
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';

import {
  BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField,
  OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField,
  TeamField,
} from '../../../components';
import { DIVISION } from '../sales-monitoring.constants';
import { useSalesMonitoringStore } from '../useSalesMonitoringStore';

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0048_SalesMonitoring.Designer.cs 컨테이너 계층:
//   usrConditionPanel2 (width=1543) — usrLayoutControl3 (width=1543)
//   - Row 1: Division(clbDivision) + Team(clbTeam) + End Customer(clbCustomer)
//   - Row 2: Biz.Type(clbBizType) + Period(drpPeriod)
//   - Row 3: Sales Site(clbSalesSite) + Plant Site(clbPlantSite) + Item Type(clbItemType)
//   - Row 4: Project(txtProject+btnProject) + Model(txtItemId+btnItemId) + Bucket(cboBucketType)
//   - Row 5: Owner(txtOwner+btnOwner) + InternalYN(chkInternal) + Sum(chkSum) + Color(chkColor)
//   - Row 6: Currency (cboKRW + cboUSD + cboLOC) — Multi-currency 분기
//
// ⭐ 2026-06-03 표준 카탈로그 (`@master/searchFields`) 사용.
// ⭐ 2026-06-07 정식 완성 보강:
//   - Row 5 추가: InternalYN / chkSum / chkColor (AS-IS .cs L17~19 + L765~770)
//   - Row 6 추가: Multi-currency 콤보 (cboKRW/USD/LOC)
//   - Division=40 분기: Project/PlantSite disabled (AS-IS InitControls L351~356)
export const SalesMonitoringForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useSalesMonitoringStore(s => s.searchCondition);
  const set = useSalesMonitoringStore(s => s.setSearchCondition);
  const openSearchArea = useSalesMonitoringStore(s => s.openSearchArea);

  // AS-IS InitControls L338 — Division=40 (Mobility) 분기: Project / PlantSite 비활성
  const isDivision40 = sc.divisionId === DIVISION.MOBILITY;

  // Division 변경 시 종속 reset (AS-IS clbDivision_SelectedIndexChanged L1855~)
  useEffect(() => {
    set({ deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [], bizTypes: [] });
    // div=40 시 Project / PlantSite 자동 초기화 (AS-IS L355~356)
    if (isDivision40) set({ projectCode: '', plantSiteIds: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  // Team 변경 시 EndCustomer reset (AS-IS clbTeam_SelectedIndexChanged L2021~)
  useEffect(() => {
    set({ endCustomers: [], scmSiteIds: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.deptIds]);

  // EndCustomer 변경 시 SalesSite/PlantSite reset (AS-IS clbCustomer_SelectedIndexChanged)
  useEffect(() => {
    set({ scmSiteIds: [], plantSiteIds: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.endCustomers]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — 사업부/팀/고객 */}
          <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v })} />
          <TeamField value={sc.deptIds} onChange={v => set({ deptIds: v })} division={sc.divisionId} />
          <EndCustomerField
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
          />

          {/* Row 2 — Biz Type / Period */}
          <BizTypeField value={sc.bizTypes} onChange={v => set({ bizTypes: v })} division={sc.divisionId} />
          <PeriodField
            startValue={sc.startYyyymmdd}
            endValue={sc.endYyyymmdd}
            onChange={(s, e) => set({ startYyyymmdd: s, endYyyymmdd: e })}
            gridSize={8}
          />

          {/* Row 3 — Sales/Plant Site, Project (Div=40 시 PlantSite/Project 비활성) */}
          <SalesSiteField
            value={sc.scmSiteIds}
            onChange={v => set({ scmSiteIds: v })}
            division={sc.divisionId}
            endCustomers={sc.endCustomers}
          />
          <PlantSiteField
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomers={sc.endCustomers}
            disabled={isDivision40}
          />
          <ProjectField
            value={sc.projectCode}
            onChange={v => set({ projectCode: v })}
            division={sc.divisionId}
            disabled={isDivision40}
          />

          {/* Row 4 — Item / Owner / Bucket */}
          <ItemField value={sc.itemId} onChange={v => set({ itemId: v })} division={sc.divisionId} />
          <OwnerField value={sc.owner} onChange={v => set({ owner: v })} division={sc.divisionId} />
          <BucketField value={sc.bucketType} onChange={v => set({ bucketType: v })} />

          {/* Row 5 — checkbox 3 (AS-IS L17~19 / L765~770) (render prop 패턴 — @lges FormItem 필수) */}
          <FormItem
            label="Options"
            gridSize={6}
            render={() => (
              <>
                <FormControlLabel
                  control={
                    <Checkbox
                      size="small"
                      checked={sc.internalYn === 'Y'}
                      onChange={e => set({ internalYn: e.target.checked ? 'Y' : 'N' })}
                    />
                  }
                  label={t('LBL_DMF0048_INTERNAL_YN', { defaultValue: 'Include Internal Txn' })}
                />
                <FormControlLabel
                  control={
                    <Checkbox
                      size="small"
                      checked={sc.showSum}
                      onChange={e => set({ showSum: e.target.checked })}
                    />
                  }
                  label={t('LBL_DMF0048_SHOW_SUM', { defaultValue: 'Sum' })}
                />
                <FormControlLabel
                  control={
                    <Checkbox
                      size="small"
                      checked={sc.showColor}
                      onChange={e => set({ showColor: e.target.checked })}
                    />
                  }
                  label={t('LBL_DMF0048_SHOW_COLOR', { defaultValue: 'Color' })}
                />
              </>
            )}
          />

          {/* Row 6 — Multi-currency 콤보 (AS-IS .cs L17~19 cboKRW/USD/LOC)
              ⚠️ 정정 (Option A 2차 — 2026-06-08): AS-IS L2116~2144 cboKRW/USD/LOC_SelectedIndexChanged 가
                **모두 본체 빈 함수** (SetAmountCalculating 주석 처리). AS-IS 에서도 동작 X.
                Form 의 Designer 에는 컨트롤 존재하지만 실 로직 없음 → To-Be 매핑 불필요.
                placeholder 도 제거 검토 (현재 disabled 유지로 layout 일치성만 보존). */}
        </>
      }
    />
  );
};
