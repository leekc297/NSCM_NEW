import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField,
  OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import { useMktForecastMasterStore } from '../useMktForecastMasterStore';

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0003_1_MktFcst.cs L318 Form_Load + InitControls — 18 조회조건 필드:
//   1. Division (단일 ComboBox)
//   2~7. 다중 ListBox (Team / End Customer / Biz Type / Sales Site / Plant Site / Item Type)
//   8. EDI Sender (다중, Phase 6)
//   9~10. Period (DateRange, 최대 3년 — MSG00164)
//   11. Bucket Type (Combo D/W/M — DMF0003_GET_BUCKET_TYPE_CODE)
//   12~14. Project / Item / Owner (TextBox + Popup)
//   15~18. Checkbox (AS / Qty / Cell / Color / Sum)
//
// ⭐ 2026-06-03 표준 카탈로그 (`@master/searchFields`) 사용 (memory feedback_search_fields_catalog):
//   Grid size / FormItem / i18n LBL / combo 키 / popup preSearchParams 자동 적용
//
// Layout (12 column Grid):
//   Row 1: Div(4)        + Team(4)         + End Customer(4)
//   Row 2: Biz.Type(4)   + Sales Site(4)   + Plant Site(4)
//   Row 3: Period(8)     + Bucket(2)       + (2 spacer)
//   Row 4: Project(4)    + Item(4)         + Owner(4)
export const MktForecastMasterForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useMktForecastMasterStore(s => s.searchCondition);
  const set = useMktForecastMasterStore(s => s.setSearchCondition);
  const openSearchArea = useMktForecastMasterStore(s => s.openSearchArea);

  // AS-IS clbDivisions_SelectedIndexChanged — Division 변경 시 종속 reset
  useEffect(() => {
    set({
      teamIds: [],
      endCustomers: [],
      bizTypes: [],
      scmSiteIds: [],
      plantSiteIds: [],
      itemTypes: [],
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00514', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 */}
          <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v as never })} />
          <TeamField value={sc.teamIds} onChange={v => set({ teamIds: v })} division={sc.divisionId} />
          <EndCustomerField value={sc.endCustomers} onChange={v => set({ endCustomers: v })} division={sc.divisionId} />

          {/* Row 2 */}
          <BizTypeField value={sc.bizTypes} onChange={v => set({ bizTypes: v })} />
          <SalesSiteField value={sc.scmSiteIds} onChange={v => set({ scmSiteIds: v })} division={sc.divisionId} />
          <PlantSiteField value={sc.plantSiteIds} onChange={v => set({ plantSiteIds: v })} />

          {/* Row 3 */}
          <PeriodField
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <BucketField value={sc.bucketType} onChange={v => set({ bucketType: v as never })} />

          {/* Row 4 — 선택적 Lookup (Project / Item / Owner) */}
          <ProjectField
            value={sc.projectCode ? [sc.projectCode] : []}
            onChange={v => set({ projectCode: v[0] ?? '' })}
            division={sc.divisionId}
            deptIds={sc.teamIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCode ? [sc.projectCode] : []}
          />
          <ItemField
            value={sc.itemId ? [sc.itemId] : []}
            onChange={v => set({ itemId: v[0] ?? '' })}
            division={sc.divisionId}
          />
          <OwnerField value={sc.owner} onChange={v => set({ owner: v })} division={sc.divisionId} />

          {/* Row 5 — 4 Checkbox (Sum / Color / Qty>=0 / Cell Qty) + AS From Site (AS-IS chk*_CheckedChanged)
              자매 SearchOverRangeField 패턴: native input type='checkbox' + Grid size only (item prop 없음) */}
          <Grid size={2}>
            <FormItem label={t('LBL00540', { defaultValue: 'Sum' })} labelAlign='right' render={() => (
              <input type='checkbox' checked={sc.sumYn} onChange={e => set({ sumYn: e.target.checked })}
                style={{ marginLeft: 8, transform: 'scale(1.2)' }} />
            )} />
          </Grid>
          <Grid size={2}>
            <FormItem label={t('LBL00541', { defaultValue: 'Color' })} labelAlign='right' render={() => (
              <input type='checkbox' checked={sc.colorYn} onChange={e => set({ colorYn: e.target.checked })}
                style={{ marginLeft: 8, transform: 'scale(1.2)' }} />
            )} />
          </Grid>
          <Grid size={2}>
            <FormItem label={t('LBL00542', { defaultValue: 'Qty>=0' })} labelAlign='right' render={() => (
              <input type='checkbox' checked={sc.qtyFilter} onChange={e => set({ qtyFilter: e.target.checked })}
                style={{ marginLeft: 8, transform: 'scale(1.2)' }} />
            )} />
          </Grid>
          <Grid size={2}>
            <FormItem label={t('LBL00543', { defaultValue: 'Cell Qty' })} labelAlign='right' render={() => (
              <input type='checkbox' checked={sc.cellQty} onChange={e => set({ cellQty: e.target.checked })}
                style={{ marginLeft: 8, transform: 'scale(1.2)' }} />
            )} />
          </Grid>
          {/* AS From Site Checkbox 숨김 (사용자 명시 요구 2026-06-07) — store field 유지 */}

          {/* Measure 버튼은 SubTitle 의 Column(⊞) 옆에 아이콘 버튼으로 이동 */}
        </>
      }
    />
  );
};
