import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField,
  OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField,
  TeamField,
} from 'features/master/src/components/searchFields/SearchFields';
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
          {/* Row 1 — 기본 1단 (Division / Team / End Customer) */}
          <DivisionField value={sc.divisionId} onChange={v => set({ divisionId: v as never })} />
          <TeamField value={sc.teamIds} onChange={v => set({ teamIds: v })} division={sc.divisionId} />
          <EndCustomerField value={sc.endCustomers} onChange={v => set({ endCustomers: v })} division={sc.divisionId} />

          {/* Row 2 — 기본 2단 (Biz Type / Sales Site / Plant Site) */}
          <BizTypeField value={sc.bizTypes} onChange={v => set({ bizTypes: v })} />
          <SalesSiteField value={sc.scmSiteIds} onChange={v => set({ scmSiteIds: v })} division={sc.divisionId} />
          <PlantSiteField value={sc.plantSiteIds} onChange={v => set({ plantSiteIds: v })} />
        </>
      }
      // ⭐ 2026-06-16 — 2단 초과 영역은 extraConditions 로 분리.
      //   SearchArea 가 Search 버튼 우측에 아래 화살표 표시 → 클릭 시 확대/축소 (DMF0006 sample 패턴)
      extraConditions={
        <>
          {/* Row 3 — Period / Bucket */}
          <PeriodField
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <BucketField value={sc.bucketType} onChange={v => set({ bucketType: v as never })} />

          {/* Row 4 — 선택적 Lookup (Project / Item / Owner) */}
          <ProjectField
            value={sc.projectCode ? [sc.projectCode] : []}
            onChange={(v: string[]) => set({ projectCode: v[0] ?? '' })}
            division={sc.divisionId}
            deptIds={sc.teamIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCode ? [sc.projectCode] : []}
          />
          <ItemField
            value={sc.itemId ? [sc.itemId] : []}
            onChange={(v: string[]) => set({ itemId: v[0] ?? '' })}
            division={sc.divisionId}
          />
          <OwnerField
            value={sc.owner ? [sc.owner] : []}
            onChange={(v: string[]) => set({ owner: v[0] ?? '' })}
            division={sc.divisionId}
          />

          {/* Row 5 — 4 Checkbox (Sum / Color / Qty>=0 / Cell Qty) */}
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
        </>
      }
    />
  );
};
