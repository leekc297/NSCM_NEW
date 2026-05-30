/**
 * DMF0043_01 Contribute_View — 조회조건 폼
 * AS-IS Designer.cs: usrYear / txtVersion + btnSPVer / usrCust / usrType / usrBiz / chkM / usrChk / btnColumn
 */
import { useTranslation } from 'react-i18next';

import { CustomDropdown, SearchArea } from '@shared/components';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { useContributeViewStore } from '../useContributeViewStore';

import styles from './ContributeViewForm.module.scss';

interface ContributeViewFormProps {
  onSearch?: () => void;
  onOpenContributeRate: () => void;
  onOpenContributeVersion: () => void;
  onOpenColumnTitleSet: () => void;
}

export const ContributeViewForm = ({
  onSearch,
  onOpenContributeRate,
  onOpenContributeVersion,
  onOpenColumnTitleSet,
}: ContributeViewFormProps) => {
  const { t } = useTranslation();

  const searchParams = useContributeViewStore(state => state.searchParams);
  const setSearchParams = useContributeViewStore(state => state.setSearchParams);
  const setFilters = useContributeViewStore(state => state.setFilters);
  const isOpenSearchArea = useContributeViewStore(state => state.isOpenSearchArea);

  const onSearchClick = () => {
    if (onSearch) onSearch();
    else setFilters();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearchClick}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* AS-IS Designer.cs usrYear width=139 → size=2 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL_DMF0043_YEAR', '_Year')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.yearId}
                  onChange={event => setSearchParams({ yearId: event.target.value })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs txtVersion width=100 + btnSPVer width=37 (popup trigger) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL_DMF0043_VERSION', '_Version')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} sx={{ width: '100%' }}>
                  <InputField
                    fullWidth
                    value={searchParams.versionId}
                    readOnly
                  />
                  {/* AS-IS .cs:453 btnSPVer_Click → DMF0043_VersionPopup */}
                  <Button
                    appearance='outlined'
                    priority='normal'
                    onClick={onOpenContributeVersion}
                  >
                    ...
                  </Button>
                </Stack>
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs usrCust width=100 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL_DMF0043_CUST_GROUP', '_고객군')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={searchParams.customerIds.join(',')}
                  options={[]}
                  onChange={(_, option) =>
                    setSearchParams({
                      customerIds:
                        typeof option === 'string' && option ? option.split(',').filter(Boolean) : [],
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs usrType width=109 */}
          <Grid size={2}>
            <FormItem
              label={t('LBL_DMF0043_PRODUCT_TYPE', '_제품군')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.productType}
                  options={[]}
                  onChange={(_, option) => setSearchParams({ productType: option as string })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs usrBiz width=59 → size=1 */}
          <Grid size={1}>
            <FormItem
              label={t('LBL_DMF0043_BIZ', '_Biz')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.bizType}
                  options={[]}
                  onChange={(_, option) => setSearchParams({ bizType: option as string })}
                />
              )}
            />
          </Grid>

          {/* AS-IS Designer.cs btnColumn icon */}
          <Grid size={2}>
            <Stack direction='row' className={styles.buttonGroup}>
              <Button
                /* AS-IS .cs:473 btnColumn_Click → DM0002_TitleSetForm_Popup */
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenColumnTitleSet}
              >
                {t('LBL_DMF0043_COLUMN_SETUP', '_Column Setup')}
              </Button>
              <Button
                /* AS-IS .cs:444 btnCutOff_Click → DMF0043_ContributeRatePopup */
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenContributeRate}
              >
                {t('LBL_DMF0043_CUT_OFF', '_기여율버전관리')}
              </Button>
            </Stack>
          </Grid>

          {/* AS-IS Designer.cs chkM / usrChk (Hidden in As-Is — 우측 정렬) */}
          <Grid size={12} sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
            <Stack direction='row' spacing={2} alignItems='center'>
              <Checkbox
                labelText={t('LBL_DMF0043_CHK_M', '_[M$]')}
                checked={searchParams.isCheckM}
                onChange={checked => setSearchParams({ isCheckM: checked })}
              />
              <Checkbox
                labelText={t('LBL_DMF0043_USR_CHK', '_정합성 체크')}
                checked={searchParams.isUsrCheck}
                onChange={checked => setSearchParams({ isUsrCheck: checked })}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
