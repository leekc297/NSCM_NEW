import { Checkbox, FormControlLabel } from '@mui/material';
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';

import {
  BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField,
  OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField,
  TeamField,
} from '../../../components';
import { DIVISION } from '../sales-plan.constants';
import { useSalesPlanStore } from '../useSalesPlanStore';

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0021_SalesPlan.Designer.cs — 15+ 조회조건 (DMF0048 동일 패턴 + Owner/InternalYN 등)
//   Row 1: Division + Team + EndCustomer
//   Row 2: BizType + Period
//   Row 3: SalesSite + PlantSite + Project
//   Row 4: Item + Owner + Bucket
//   Row 5: InternalYN + ShowSum + ShowColor
//
// Division=40 분기: Project / PlantSite disabled (자매 DMF0048 동일)
export const SalesPlanForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useSalesPlanStore(s => s.searchCondition);
  const set = useSalesPlanStore(s => s.setSearchCondition);
  const openSearchArea = useSalesPlanStore(s => s.openSearchArea);

  const isDivision40 = sc.divisionId === DIVISION.MOBILITY;

  useEffect(() => {
    set({ deptIds: [], endCustomers: [], scmSiteIds: [], plantSiteIds: [], bizTypes: [] });
    if (isDivision40) set({ projectCode: '', plantSiteIds: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  useEffect(() => {
    set({ endCustomers: [], scmSiteIds: [] });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.deptIds]);

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
          <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v })} />
          <TeamField value={sc.deptIds} onChange={v => set({ deptIds: v })} division={sc.divisionId} />
          <EndCustomerField
            value={sc.endCustomers}
            onChange={v => set({ endCustomers: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
          />

          <BizTypeField value={sc.bizTypes} onChange={v => set({ bizTypes: v })} division={sc.divisionId} />
          <PeriodField
            startValue={sc.startYyyymmdd}
            endValue={sc.endYyyymmdd}
            onChange={(s, e) => set({ startYyyymmdd: s, endYyyymmdd: e })}
            gridSize={8}
          />

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

          <ItemField value={sc.itemId} onChange={v => set({ itemId: v })} division={sc.divisionId} />
          <OwnerField value={sc.owner} onChange={v => set({ owner: v })} division={sc.divisionId} />
          <BucketField value={sc.bucketType} onChange={v => set({ bucketType: v })} />

          {/* Row 5 — checkbox 3 (render prop 패턴 — @lges FormItem 필수) */}
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
                  label="Include Internal Txn"
                />
                <FormControlLabel
                  control={
                    <Checkbox
                      size="small"
                      checked={sc.showSum}
                      onChange={e => set({ showSum: e.target.checked })}
                    />
                  }
                  label="Sum"
                />
                <FormControlLabel
                  control={
                    <Checkbox
                      size="small"
                      checked={sc.showColor}
                      onChange={e => set({ showColor: e.target.checked })}
                    />
                  }
                  label="Color"
                />
              </>
            )}
          />
        </>
      }
    />
  );
};
