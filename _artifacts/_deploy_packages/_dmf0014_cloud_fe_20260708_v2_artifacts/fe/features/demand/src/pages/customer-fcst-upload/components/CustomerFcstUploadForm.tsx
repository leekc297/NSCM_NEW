import type { Dispatch, SetStateAction } from 'react';

import dayjs from '@foundation/dayjs';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import type { BUCKET_TYPE } from '../customer-fcst-upload.constant';
import { useCustomerFcstUploadStore } from '../useCustomerFcstUploadStore';

import styles from './CustomerFcstUploadForm.module.scss';

interface CustomerFcstUploadProps {
  onSubmit: () => void;
  setOpenPrjByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenModelByDivisionModal: Dispatch<SetStateAction<boolean>>;
}
export const CustomerFcstUploadForm = ({
  onSubmit,
  setOpenPrjByDivisionModal,
  setOpenModelByDivisionModal,
}: CustomerFcstUploadProps) => {
  const { t } = useTranslation();

  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstUploadStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);

  // ComboId — SCM_ADM_CMBO_SQL_M 등록명 사용 (2026-07-02 전수 대조).
  //   PlanSite → SalesPlant (PLANT sites + DIVISION_ID 컬럼 반환 — DMF0003 선례) / Bucket → BucketType (BUCKET_TYPE_CODE lookup)
  const [myDivision, teambyDivision, endCustomer, salesSite, customsHandbook, plantSite, bucket] =
    useTabComboQueries({
      filters: [
        'MyDivision',
        'TeambyDivision',
        'EndCustomer',
        'SalesSite',
        'CustomsHandbook',
        'SalesPlant',
        'BucketType',
      ],
    });

  // ⭐ cascade 하위 필터 기준 — 선택된 Team(멀티, 콤마조인). 비어있으면 Team 필터 미적용.
  //   EndCustomer/SalesSite 콤보가 DEPT_ID 를 반환 → Division + Team 클라 cascade.
  const selTeams = searchParams.team ? searchParams.team.split(',').filter(Boolean) : [];
  // ⭐ AS-IS cboDivision_SelectedIndexChanged (.cs L841~864) — division 81*/82 만 활성, 그 외(40 등) 비활성.
  //   AS-IS 는 Project 만이나, 사용자 요구(2026-07-07)로 Plant Site 도 동일 division 기준 enable 처리.
  const isDivRestricted = !(
    searchParams.divisionId.startsWith('81') || searchParams.divisionId === '82'
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  defaultValue='ALL'
                  value={searchParams.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    // AS-IS cboDivision_SelectedIndexChanged (.cs L823~889) — 하위 조건 cascade clear
                    setSearchParams({
                      divisionId: option,
                      team: '',
                      endCustomer: '',
                      salesSite: '',
                      plantSite: '',
                    });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.team}
                  defaultValue='ALL'
                  allOption
                  useClearIcon
                  multiple
                  options={
                    teambyDivision
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    // AS-IS clbTeam_SelectedIndexChanged — 하위(End Customer/Sales Site) cascade clear
                    setSearchParams({ team: option, endCustomer: '', salesSite: '' });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.endCustomer}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    endCustomer
                      // ⭐ cascade: Division + Team(DEPT_ID). EndCustomer 콤보가 DIVISION_ID/DEPT_ID 반환.
                      ?.filter(
                        item =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          (selTeams.length === 0 || !item.DEPT_ID || selTeams.includes(item.DEPT_ID))
                      )
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site) cascade clear
                    setSearchParams({ endCustomer: options, salesSite: '' });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.salesSite}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    salesSite
                      // ⭐ cascade: Division + Team(DEPT_ID). 'SalesSite' 콤보가 DIVISION_ID/DEPT_ID 반환.
                      ?.filter(
                        item =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          (selTeams.length === 0 || !item.DEPT_ID || selTeams.includes(item.DEPT_ID))
                      )
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({ salesSite: options });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00005', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.plantSite}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  disabled={isDivRestricted} // ⭐ division 81*/82 만 활성 (사용자 요구)
                  options={
                    plantSite
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({ plantSite: options });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00617', 'Project')}
              labelAlign='right'
              render={() => (
                // ⭐ 박스 + 돋보기 버튼을 flex 로 나란히 (endAdornment 절대배치 폐기) — master SearchFields
                //   PopupSearchInput 표준 1:1. 컨테이너 .input 폭 + 36px 높이로 상하 조회조건과 우측끝·높이 정합.
                <div className={clsx(styles.inputWithSearch, styles.input)}>
                  <InputField
                    fullWidth
                    // ⭐ AS-IS: Project 는 division 81*/82 만 활성 (40 등 비활성) — 입력/팝업 버튼 모두 잠금
                    disabled={isDivRestricted}
                    value={searchParams.project}
                    onChange={event => setSearchParams({ project: event.target.value })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    disabled={isDivRestricted}
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={() => {
                      if (!isDivRestricted) setOpenPrjByDivisionModal(true);
                    }}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00013', '_Period')}
              labelAlign='right'
              required
              render={() => (
                // ⭐ 일자 잘림 방지 — DMF0048 선례: .datePickerFix 래퍼 + sx width 100% (overflow:hidden/ellipsis 제거)
                <div className={styles.datePickerFix}>
                  <DatePickerCalendar
                    sx={{ width: '100%' }}
                    usecase='date-range-multi'
                    elevation
                    size='large'
                    locale='ko'
                    value={[
                      dayjs(searchParams.startYyyymmdd, 'YYYYMMDD'),
                      dayjs(searchParams.endYyyymmdd, 'YYYYMMDD'),
                    ]}
                    onChange={date => {
                      // dayjs 로컬 날짜 (toISOString UTC 금지 — DMF0048 A-3 선례)
                      const start = date?.[0]
                        ? dayjs(date[0]).format('YYYYMMDD')
                        : searchParams.startYyyymmdd;
                      const end = date?.[1]
                        ? dayjs(date[1]).format('YYYYMMDD')
                        : searchParams.endYyyymmdd;
                      setSearchParams({ startYyyymmdd: start, endYyyymmdd: end });
                    }}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.bucket}
                  options={bucket?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    // AS-IS cboBucketType — 단일 필수 (ALL 없음). CODE = DAILY/WEEKLY/MONTHLY full-word
                    setSearchParams({ bucket: option as BUCKET_TYPE });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <div className={clsx(styles.inputWithSearch, styles.input)}>
                  <InputField
                    fullWidth
                    value={searchParams.modelNickname}
                    onChange={event => setSearchParams({ modelNickname: event.target.value })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={() => setOpenModelByDivisionModal(true)}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00091', 'Customer Handbook')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.customsHandbook}
                  allOption
                  options={
                    customsHandbook?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ customsHandbook: option });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
