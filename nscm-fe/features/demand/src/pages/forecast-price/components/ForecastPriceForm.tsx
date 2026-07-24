import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  PeriodField,
  SalesSiteField,
  TeamField,
  VersionField,
} from 'features/master/src/components';

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
  const [bucketTypeCombo] = useTabComboQueries({ filters: ['BucketType'] });
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
                itemIds: [],
              })
            }
          />
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.deptIds}
            onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSites: [] })}
            // ⭐ 2026-07-23 AS-IS 정합 — owner 1번 토큰 부서 기준 (hook #117, 차집합 35/64 실측)
            comboId='UserTeamByDivision'
          />
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.endCustomers}
            onChange={v => setSearchParams({ endCustomers: v, salesSites: [] })}
          />
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.salesSites}
            onChange={v => setSearchParams({ salesSites: v })}
            // ⭐ 2026-07-23 AS-IS 정합(사용자 승인) — 'UserSiteByEndCustomer' 서버 바인드 전환:
            //   EndCustomer/Team cascade + 40 owner-team 필터 + OPERATION_GROUP 'W' 제외 (hook #117).
            comboId='UserSiteByEndCustomer'
            endCustomer={searchParams.endCustomers.join(',')}
            deptId={searchParams.deptIds.join(',')}
          />

          {/* Row 2 — Biz Type / Model·Nickname(팝업) / Period / Bucket */}
          {/* ⭐ 2026-07-23 AS-IS 정합 — AS-IS BigFilter BizType = DM_BIZ_TYPE(40) UNION
              SCM_MST_PROJECT BIZ_TYPE(비40). 공유 'BizType'(lookup 3종)은 81/82 후보 누락 →
              'BizTypebyDivision' + division 필터 (DMF0003 P1 동형, hook #117). */}
          <BizTypeField
            gridSize={3}
            value={searchParams.bizTypes}
            onChange={v => setSearchParams({ bizTypes: v })}
            comboId='BizTypebyDivision'
            division={searchParams.divisionId}
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
                    onBucketChange ? onBucketChange(option) : setSearchParams({ bucketType: option })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Version*(팝업 전용) / Sum·Qty ≥ 0 체크박스 */}
          <VersionField gridSize={3} value={searchParams.versionType} onOpenPopup={onOpenVersionLookup} />
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
