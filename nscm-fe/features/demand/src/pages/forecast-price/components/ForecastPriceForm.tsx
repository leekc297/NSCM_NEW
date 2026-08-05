import {
  BizTypeField,
  DivisionField,
  ItemField,
  PeriodField,
  PlantSiteField,
  SalesSiteField,
  TeamField,
  VersionField,
} from 'features/master/src/components';

import type { ComboResponse } from '@foundation/models';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_FALLBACK } from '../forecast-price.constants';
import { useForecastPriceStore } from '../useForecastPriceStore';

interface ForecastPriceFormProps {
  onSubmit: () => void;
  onOpenVersionLookup: () => void;
  // #13 — Bucket 전환은 페이지가 가드(Insert 행 존재 시 MSG00227). 미지정 시 직접 setSearchParams fallback.
  onBucketChange?: (bucket: string) => void;
}

// ⭐ 조회조건 = 표준 카탈로그(@master/searchFields) 전면 사용 (T05 messaging-api-and-search-fields).
//   AS-IS Designer 15 컨트롤 매핑: clbDivision/clbTeam/clbCustomer/clbSalesSite/clbBizType(멀티)
//   → 카탈로그 5필드 / txtItemId+btnItemId → ItemField(팝업) / drpPeriod → PeriodField /
//   cboBucketType → 인라인(D 포함 3버킷 — 카탈로그 BucketField 는 W/M 만) / txtVersion+btnVersion
//   → VersionField(팝업 전용) / cboQty·chkSum → 인라인 체크박스.
//   Figma 1단 4필드 = gridSize 3 (hook #94 — 높이 36px 은 카탈로그/CustomDropdown 자동).
export const ForecastPriceForm = ({
  onSubmit,
  onOpenVersionLookup,
  onBucketChange,
}: ForecastPriceFormProps) => {
  const { t } = useTranslation();

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);

  // Bucket 옵션 = CMBO 'BucketType' 동적 fetch (DMF0003_GET_BUCKET_TYPE_CODE 1:1 — CMBO 등록명).
  //   CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑. 빈 응답 시 정적 fallback 3종.
  // ⭐ End Customer 콤보 = division + 선택 팀(DEPT_ID) cascade 필터용 (MetalLinkPriceForm 동일 패턴).
  //   catalog EndCustomerField 는 division 필터만 지원 → 인라인 CustomDropdown 으로 팀 cascade 처리.
  const [bucketTypeCombo, endCustomerCombo] = useTabComboQueries({
    filters: ['BucketType', 'EndCustomer'],
  });
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0);
            const fb = BUCKET_FALLBACK.find(b => b.value === code);
            return { label: fb ? t(fb.lblKey, fb.label) : String(item.NAME ?? code), value: code };
          })
          .filter(o => ['D', 'W', 'M'].includes(o.value))
      : BUCKET_FALLBACK.map(b => ({ label: t(b.lblKey, b.label), value: b.value }));

  return (
    <SearchArea
      isHidden={!isOpenSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      conditions={
        <>
          {/* Row 1 — Division* / Team / End Customer / Sales Site (Figma 1단 4필드) */}
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={v =>
              setSearchParams({
                divisionId: v,
                deptIds: [],
                endCustomers: [],
                salesSites: [],
                plantSiteIds: [],
                itemIds: [],
              })
            }
          />
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.deptIds}
            onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSites: [] })}
          />
          {/* End Customer — division + 선택 팀(DEPT_ID) cascade 필터 (MetalLinkPriceForm L118~143 1:1).
              팀 변경 시 옵션 재조회 + 하위(Sales Site) clear. */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.endCustomers.join(',')}
                  options={
                    endCustomerCombo
                      ?.filter(
                        (item: ComboResponse) =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          (searchParams.deptIds.length === 0 ||
                            !item.DEPT_ID ||
                            searchParams.deptIds.includes(item.DEPT_ID))
                      )
                      ?.map((item: ComboResponse) => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, selected) =>
                    setSearchParams({
                      endCustomers: String(selected ?? '')
                        .split(',')
                        .filter(Boolean),
                      salesSites: [],
                    })
                  }
                />
              )}
            />
          </Grid>
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.salesSites}
            onChange={v => setSearchParams({ salesSites: v })}
          />

          {/* Row 2 — Biz Type / Model·Nickname(팝업) / Period / Bucket */}
          <BizTypeField
            gridSize={3}
            value={searchParams.bizTypes}
            onChange={v => setSearchParams({ bizTypes: v })}
          />
          <ItemField
            gridSize={3}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSites}
            itemIds={searchParams.itemIds}
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
          />
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) =>
                    onBucketChange
                      ? onBucketChange(option)
                      : setSearchParams({ bucketType: option })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Version*(팝업 전용) / Plant Site(81 전용) / Sum·Qty ≥ 0 체크박스 */}
          <VersionField
            gridSize={3}
            value={searchParams.versionType}
            onOpenPopup={onOpenVersionLookup}
          />
          {/* ⭐ Plant Site — 표준 카탈로그 PlantSiteField (DMF0003 MktFcstForm 1:1 — 콤보
              PlantSitebyEndCustomer, Division+EndCustomer 서버 바인드). 81 계열만 enable, 40/82 비활성. */}
          <PlantSiteField
            gridSize={3}
            value={searchParams.plantSiteIds}
            onChange={v => setSearchParams({ plantSiteIds: v })}
            division={searchParams.divisionId}
            endCustomer={
              searchParams.endCustomers.length > 0
                ? searchParams.endCustomers.join(',')
                : undefined
            }
          />
          <Grid size={3} sx={{ display: 'flex', alignItems: 'center' }}>
            <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
              <Checkbox
                labelText={t('LBL00687', '_Sum')}
                checked={searchParams.sumYn}
                onChange={checked => setSearchParams({ sumYn: checked })}
              />
              <Checkbox
                labelText={t('LBL00689', '_Qty ≥ 0')}
                checked={searchParams.qtyYn}
                onChange={checked => setSearchParams({ qtyYn: checked })}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
