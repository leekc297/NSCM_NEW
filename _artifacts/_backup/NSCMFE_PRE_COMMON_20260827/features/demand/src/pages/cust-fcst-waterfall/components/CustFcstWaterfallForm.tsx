import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PeriodField,
  PlantSiteField,
  ProjectField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE, QTY_DIVISOR_OPTIONS } from '../cust-fcst-waterfall.constants';
import { useCustFcstWaterfallStore } from '../useCustFcstWaterfallStore';

// DMF0053 조회조건 — #112 카탈로그 'Customer FCST Waterfall' 17행 전 행 대조 (Cascade_Filter_전수.md §1).
//   conditions(상시 2단): Div.*/Team/End Customer/Sales Site + Biz.Type/Input Date*/Period*/Bucket
//   extraConditions(펼침): PJT/Model·Nickname/Plant Site/Item Type + Owner/QTY/Sum
//   Version(Date*) 칸 = AS-IS btnVersion 숨김 + Figma·카탈로그 부재 → 미구현 (E21/E22/D-01).
//   division cascade = AS-IS cboDivision_SelectedIndexChanged L928~1028 (하위 클리어 + 텍스트 클리어).

interface CustFcstWaterfallFormProps {
  onSubmit: () => void;
}

export const CustFcstWaterfallForm = ({ onSubmit }: CustFcstWaterfallFormProps) => {
  const { t } = useTranslation();

  const searchParams = useCustFcstWaterfallStore(state => state.searchParams);
  const setSearchParams = useCustFcstWaterfallStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustFcstWaterfallStore(state => state.isOpenSearchArea);

  // AS-IS B-04 (cboDivision L951~983): 81 계열·82 = PJT·Plant Site 활성 / 그 외(40) = 비활성
  const isProjectEnabled =
    searchParams.divisionId.startsWith('81') || searchParams.divisionId === '82';

  const [reportBucketType, qtyType, itemType] = useTabComboQueries({
    filters: ['ReportBucketType', 'QtyType', 'ItemType'],
  });

  const comboOr = (
    rows: Array<{ CODE: string; NAME: string }> | undefined,
    fallback: Array<{ value: string; label: string }>
  ) =>
    rows && rows.length > 0
      ? rows.map(item => ({ label: item.NAME, value: item.CODE }))
      : fallback;

  const bucketOptions = comboOr(reportBucketType, []);
  const qtyOptions = comboOr(qtyType, QTY_DIVISOR_OPTIONS);

  // ONLY_WEEKLY = Sum 비활성·강제 해제 (AS-IS InitSpread L394~398)
  useEffect(() => {
    if (searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY && searchParams.isSumChecked) {
      setSearchParams({ isSumChecked: false });
    }
  }, [searchParams.bucket, searchParams.isSumChecked, setSearchParams]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSubmit}
      sx={{ flexShrink: 0 }}
      conditions={
        <>
          {/* Row 1 — Div.* / Team / End Customer / Sales Site */}
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={option =>
              // AS-IS E02 (L1020~1025): 하위 cascade 클리어 + 텍스트 3칸(PJT/Model/Owner) 클리어
              setSearchParams({
                divisionId: option,
                deptIds: [],
                endCustomers: [],
                salesSiteIds: [],
                bizTypes: [],
                plantSiteIds: [],
                projectCodes: [],
                itemIds: [],
                owners: [],
              })
            }
          />
          <TeamField
            gridSize={3}
            value={searchParams.deptIds}
            onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSiteIds: [] })}
            division={searchParams.divisionId}
          />
          <EndCustomerField
            gridSize={3}
            value={searchParams.endCustomers}
            onChange={v => setSearchParams({ endCustomers: v, salesSiteIds: [] })}
            division={searchParams.divisionId}
          />
          <SalesSiteField
            gridSize={3}
            value={searchParams.salesSiteIds}
            onChange={v => setSearchParams({ salesSiteIds: v })}
            division={searchParams.divisionId}
            comboId='UserSiteByEndCustomer'
            endCustomer={searchParams.endCustomers.join(',')}
            deptId={searchParams.deptIds.join(',')}
          />
          {/* Row 2 — Biz.Type / Input Date* / Period* / Bucket */}
          <BizTypeField
            gridSize={3}
            value={searchParams.bizTypes}
            onChange={v => setSearchParams({ bizTypes: v })}
            division={searchParams.divisionId}
          />
          <PeriodField
            gridSize={3}
            label={t('LBL00302', 'Input Date')}
            start={searchParams.fromCreateYyyymmdd}
            end={searchParams.toCreateYyyymmdd}
            onChange={(start, end) =>
              setSearchParams({ fromCreateYyyymmdd: start, toCreateYyyymmdd: end })
            }
          />
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00710', 'Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucket}
                  options={bucketOptions}
                  onChange={(_, option) => setSearchParams({ bucket: option })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — PJT / Model·Nickname / Plant Site / Item Type */}
          <ProjectField
            gridSize={3}
            value={searchParams.projectCodes}
            onChange={v => setSearchParams({ projectCodes: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
            disabled={!isProjectEnabled} // AS-IS B-04 — 40 은 PJT 비활성 (81*/82 활성)
          />
          <ItemField
            gridSize={3}
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
          />
          <PlantSiteField
            gridSize={3}
            value={searchParams.plantSiteIds}
            onChange={v => setSearchParams({ plantSiteIds: v })}
            division={searchParams.divisionId}
            endCustomer={searchParams.endCustomers.join(',')}
            disabled={!isProjectEnabled} // AS-IS B-04 — 40 은 Plant Site 비활성
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00068', 'Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.itemTypes.join(',')}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) =>
                    setSearchParams({
                      itemTypes: String(options ?? '')
                        .split(',')
                        .filter(Boolean),
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* Row 4 — Owner / QTY / Sum */}
          <OwnerField
            gridSize={3}
            value={searchParams.owners}
            onChange={v => setSearchParams({ owners: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSiteIds}
            projectCodes={searchParams.projectCodes}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('', 'QTY')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.qty}
                  options={qtyOptions}
                  onChange={(_, option) => setSearchParams({ qty: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={' '}
              labelAlign='right'
              render={() => (
                <Checkbox
                  labelText={t('LBL00687', 'Sum')}
                  checked={searchParams.isSumChecked}
                  disabled={searchParams.bucket === BUCKET_TYPE.ONLY_WEEKLY}
                  onChange={checked => setSearchParams({ isSumChecked: checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
