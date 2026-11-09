import {
  BucketField,
  buildComboOptions,
  PeriodField,
  ProjectField,
  toSelectedCodes,
} from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import {
  BUCKET_TYPE,
  MSG,
  SCREEN_DIVISION,
  SEARCH_COMBO,
} from '../sales-price-model-group.constants';
import type { SearchParams } from '../sales-price-model-group.types';
import { useSalesPriceModelGroupStore } from '../useSalesPriceModelGroupStore';

import { ModelGroupField } from './ModelGroupField';

interface Props {
  onSearch: () => void;
  hasInsertRows: boolean;
}

// Div 또는 Team 을 바꾸면 아래 조건을 모두 비우고 Bucket 을 Weekly 로 돌린다
//   (설계서 [개요] O10 · O11, 사용자 결정 2026-11-06 — Version · Search over range 는 이 화면에 없다).
const RESET_BELOW_TEAM: Partial<SearchParams> = {
  endCustomers: [],
  scmSiteIds: [],
  projectCodes: [],
  mdlGrs: [],
  bucketType: BUCKET_TYPE.WEEKLY,
};

// 조회조건 (설계서 [개요] 조회 조건 8칸 = 2단, SRCH-02 기준 extraConditions 없음).
//   콤보는 원천 DMF0020 과 같은 필터 방식 — 파라미터 없이 전량을 받고 buildComboOptions 로 좁힌다.
export const SalesPriceModelGroupForm = ({ onSearch, hasInsertRows }: Props) => {
  const { t } = useTranslation();
  const tabId = useTabid();
  const searchParams = useSalesPriceModelGroupStore(s => s.searchParams);
  const setSearchParams = useSalesPriceModelGroupStore(s => s.setSearchParams);
  const openSearchArea = useSalesPriceModelGroupStore(s => s.openSearchArea);

  const [divisions, teams, endCustomers, salesSites] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division,
      SEARCH_COMBO.team,
      SEARCH_COMBO.endCustomer,
      SEARCH_COMBO.salesSite,
    ],
  });

  // 82 전용 화면 — 권한 사업부 목록 중 82 만 보인다. 권한이 없으면 목록이 비어 Div 가 빈 값으로 남는다(설계서 O10).
  const divisionOptions = buildComboOptions(divisions).filter(o => o.value === SCREEN_DIVISION);
  const division = searchParams.divisionId;
  const teamOptions = buildComboOptions(teams, { division });
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division,
    narrow: { column: 'DEPT_ID', codes: searchParams.deptIds },
  });
  // Sales Site 는 Div 와 고른 End Customer 로만 좁힌다(Team 은 걸지 않는다, 설계서 O13).
  const salesSiteOptions = buildComboOptions(salesSites, {
    division,
    narrow: { column: 'END_CUSTOMER', codes: toSelectedCodes(searchParams.endCustomers) },
  });

  // 조회조건을 바꾸면 그리드가 비워지므로 고치던 값이 있으면 먼저 묻는다(MSG00704, 공용 confirm).
  const changeWithConfirm = (patch: Partial<SearchParams>) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) setSearchParams(patch);
    });
  };

  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search(F5)')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={division}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    changeWithConfirm({
                      divisionId: String(picked ?? ''),
                      deptIds: [],
                      ...RESET_BELOW_TEAM,
                    })
                  }
                />
              )}
            />
          </Grid>
          {multiField('LBL00044', '_Team', searchParams.deptIds, teamOptions, deptIds => {
            // 신규 행이 있으면 Bucket 은 그대로 둔다 — 아래 Bucket 변경 차단(MSG00227)과 같은 이유.
            const { bucketType: _bucket, ...resetWithoutBucket } = RESET_BELOW_TEAM;
            setSearchParams({ deptIds, ...(hasInsertRows ? resetWithoutBucket : RESET_BELOW_TEAM) });
          })}
          {multiField(
            'LBL00080',
            '_End Customer',
            searchParams.endCustomers,
            endCustomerOptions,
            codes => setSearchParams({ endCustomers: codes, scmSiteIds: [] })
          )}
          {multiField(
            'LBL00011',
            '_Sales Site',
            searchParams.scmSiteIds,
            salesSiteOptions,
            scmSiteIds => setSearchParams({ scmSiteIds })
          )}

          <ProjectField
            gridSize={3}
            value={searchParams.projectCodes}
            onChange={projectCodes => setSearchParams({ projectCodes })}
            division={division}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.scmSiteIds}
            projectCodes={searchParams.projectCodes}
            multiCheckbox
          />
          <PeriodField
            gridSize={3}
            start={searchParams.fromYyyymmdd}
            end={searchParams.toYyyymmdd}
            onChange={(fromYyyymmdd, toYyyymmdd) => setSearchParams({ fromYyyymmdd, toYyyymmdd })}
          />
          <ModelGroupField
            value={searchParams.mdlGrs}
            onChange={mdlGrs => setSearchParams({ mdlGrs })}
            divisionId={division}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.scmSiteIds}
            projectCodes={searchParams.projectCodes}
            disabled={!division}
          />
          <BucketField
            gridSize={3}
            value={searchParams.bucketType}
            onChange={v => {
              // 신규 행이 있으면 Bucket 을 바꾸지 않는다 — 칸 구성이 바뀌어 입력이 섞인다(원천 DMF0020 MSG00227).
              if (hasInsertRows) {
                void useMessageStore.getState().setAlert({
                  type: 'alert',
                  content: t(MSG.INSERT_ONLY_BUCKET, '_Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.'),
                });
                return;
              }
              setSearchParams({ bucketType: v === 'M' ? BUCKET_TYPE.MONTHLY : BUCKET_TYPE.WEEKLY });
            }}
          />
        </>
      }
    />
  );
};
