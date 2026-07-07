import dayjs from '@foundation/dayjs';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import { useForecastPriceStore } from '../useForecastPriceStore';

import styles from './ForecastPriceForm.module.scss';

interface ForecastPriceFormProps {
  onSubmit: () => void;
  onOpenItemLookup: () => void;
  onOpenVersionLookup: () => void;
}

export const ForecastPriceForm = ({
  onSubmit,
  onOpenItemLookup,
  onOpenVersionLookup,
}: ForecastPriceFormProps) => {
  const { t } = useTranslation();

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);

  // ComboId — SCM_ADM_CMBO_SQL_M 등록명 사용 (2026-07-02 전수 대조).
  // AS-IS User*(auth-ext) 변형은 TO-BE 미이관 → 비auth 등록명으로 교정:
  //   UserTeamByDivision → TeambyDivision / EndCustomerByDivision → EndCustomer (DIVISION_ID 컬럼 반환 — 클라 필터 가능)
  const [myDivision, userTeamByDivision, endCustomerByDivision, bizType, scmSiteByEndCustomer40] =
    useTabComboQueries({
      filters: [
        'MyDivision',
        'TeambyDivision',
        'EndCustomer',
        'BizType',
        'ScmSitebyEndCustomer40',
      ],
    });

  // TODO(S4): DMF0003_GET_BUCKET_TYPE_CODE SP 호출로 옵션 로드 (spec.md §6.2). 임시 옵션.
  const bucketOptions = [
    { label: 'Daily', value: 'D' },
    { label: 'Weekly', value: 'W' },
    { label: 'Monthly', value: 'M' },
  ];

  return (
    <SearchArea
      isHidden={!isOpenSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      conditions={
        <>
          {/* Row A — Div. / Team / End Customer / Sales Site */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={searchParams.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({
                      divisionId: option,
                      teamId: '',
                      endCustomer: '',
                      salesSite: '',
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={searchParams.teamId}
                  options={
                    userTeamByDivision
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ teamId: option, endCustomer: '', salesSite: '' });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={searchParams.endCustomer}
                  options={
                    endCustomerByDivision
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ endCustomer: option, salesSite: '' });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={searchParams.salesSite}
                  options={
                    scmSiteByEndCustomer40?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ salesSite: option });
                  }}
                />
              )}
            />
          </Grid>

          {/* Row B — Biz. Type / Model/Nickname🔍 / Period / Bucket */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Biz. Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={searchParams.bizType}
                  options={bizType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({ bizType: option });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={clsx(styles.inputWithSearch, styles.input)}
                  value={searchParams.itemId}
                  onChange={event => setSearchParams({ itemId: event.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onOpenItemLookup} />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={onOpenItemLookup}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00013', '_Period')}
              labelAlign='right'
              render={() => (
                <DatePickerCalendar
                  sx={{ width: '100%' }}
                  usecase='date-range-multi'
                  elevation
                  size='large'
                  value={[dayjs(searchParams.period[0]), dayjs(searchParams.period[1])]}
                  onChange={date => {
                    setSearchParams({ period: date });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00032', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // TODO(S4): C# cboBucketType_Click — Insert 행 존재 시 MSG00227 사전 차단
                    setSearchParams({ bucketType: option });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row C — Ver.🔍 + inline checkbox(Sum / Qty ≥ 0) */}
          <Grid size={4}>
            <FormItem
              label={t('LBL00031', '_Ver.')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={clsx(styles.inputWithSearch, styles.input)}
                  value={searchParams.versionType}
                  onChange={event => setSearchParams({ versionType: event.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onOpenVersionLookup} />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={onOpenVersionLookup}
                />
              )}
            />
          </Grid>
          <Grid size={4} sx={{ display: 'flex', alignItems: 'center' }}>
            <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
              <Checkbox
                labelText={t('', '_Sum')}
                checked={searchParams.sumYn}
                onChange={checked => {
                  setSearchParams({ sumYn: checked });
                }}
              />
              <Checkbox
                labelText={t('', '_Qty ≥ 0')}
                checked={searchParams.qtyYn}
                onChange={checked => {
                  setSearchParams({ qtyYn: checked });
                }}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
