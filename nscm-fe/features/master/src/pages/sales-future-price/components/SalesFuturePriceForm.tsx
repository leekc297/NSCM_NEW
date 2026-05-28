import type { KeyboardEvent } from 'react';

import dayjs from '@foundation/dayjs';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION_CODE, type BucketType } from '../sales-future-price.constants';
import { useSalesFuturePriceStore } from '../useSalesFuturePriceStore';

import styles from './SalesFuturePriceForm.module.scss';

interface SalesFuturePriceFormProps {
  onSearch?: () => void;
  onOpenExchangeRate: () => void;
  onOpenSalesPriceRange: () => void;
  onOpenPriceBatchInput: () => void;
  onOpenSalesPriceTemplate: () => void;
  onOpenSalesPriceVersion: () => void;
  onOpenColumnTitleSet: () => void;
  onBatchClick: () => void;
  /** AS-IS .cs:205,2581 — Template 버튼은 ESS(81) 사업부만 표시. 메인에서 isEss() 평가 후 prop 전달 */
  showTemplateButton: boolean;
}

/** CustomDropdown 의 value 는 multiple 모드에서도 쉼표 구분 string (`value?.trim().split(',')`).
 *  store 의 string[] ↔ form 의 string 변환 헬퍼. */
const arrayToCsv = (arr: string[]) => arr.join(',');
const csvToArray = (csv: string | null | undefined): string[] =>
  csv && typeof csv === 'string' ? csv.split(',').filter(Boolean) : [];

export const SalesFuturePriceForm = ({
  onSearch,
  onOpenExchangeRate,
  onOpenSalesPriceRange,
  onOpenPriceBatchInput,
  onOpenSalesPriceTemplate,
  onOpenSalesPriceVersion,
  onOpenColumnTitleSet,
  onBatchClick,
  showTemplateButton,
}: SalesFuturePriceFormProps) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();

  const searchParams = useSalesFuturePriceStore(state => state.searchParams);
  const setSearchParams = useSalesFuturePriceStore(state => state.setSearchParams);
  const onDivisionChanged = useSalesFuturePriceStore(state => state.onDivisionChanged);
  const setFilters = useSalesFuturePriceStore(state => state.setFilters);
  const isOpenSearchArea = useSalesFuturePriceStore(state => state.isOpenSearchArea);

  /** AS-IS .cs:205,2581 — ESS(81) 사업부 여부. 메인이 평가한 showTemplateButton 와 동일 의미.
   *  PlantSite 컬럼도 동일 가드 적용 (사업부 81 만 활성). */
  const isEss = showTemplateButton;

  // 콤보 쿼리 — duplicate 제거 (이전: SalesSite/BucketType 중복). PlantSite/Version 은 정확 콤보 ID 미상으로 임시 동일.
  const [divisions, teams, endCustomers, scmSites, bizTypes, bucketTypes] = useTabComboQueries({
    filters: [
      'MyDivision',
      'UserTeamByDivision',
      'EndCustomerByDivision',
      'SalesSite',
      'BizType',
      'BucketType',
    ],
  });
  // PlantSite / Version 콤보 — 별도 BE 콤보 등록 전 임시 동일 소스 사용 (정확 콤보 ID 등록 후 교체)
  const plantSites = scmSites;
  const versions = bucketTypes;

  const onSearchOnEnter = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      if (onSearch) onSearch();
      else setFilters();
    }
  };

  const onProjectButtonClick = () => {
    if (searchParams.divisionId !== DIVISION_CODE.AUTOMOTIVE) {
      void setAlert({
        type: 'alert',
        content: t('MSG00448', '_해당 사업부에서는 사용 불가합니다.'),
      });
      return;
    }
  };

  /**
   * #70  AS-IS: cboBucketType_Click L3823 — INSERT 행 존재 시 변경 차단 (MSG00227).
   * `if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) MessageBox`
   * TODO: store 의 그리드 데이터 dirty 검사 후 INSERT 행 있으면 차단 alert.
   */
  const onBucketTypeClick = (next: BucketType) => {
    if (next === searchParams.bucketType) return;
    setSearchParams({ bucketType: next });
  };

  /** Version popup 선택 후 store.searchParams.versionId 갱신 */
  const onVersionPopupClick = () => {
    onOpenSalesPriceVersion();
  };

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
          <Grid size={3}>
            <FormItem
              label={t('LBL00050', '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => onDivisionChanged(option as string)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00076', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.deptIds)}
                  options={
                    teams
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ deptIds: csvToArray(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00081', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.endCustomers)}
                  options={
                    endCustomers
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ endCustomers: csvToArray(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00082', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.scmSiteIds)}
                  options={scmSites?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ scmSiteIds: csvToArray(option) })}
                />
              )}
            />
          </Grid>

          <Grid size={3}>
            <FormItem
              label={t('LBL00083', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  disabled={!isEss}
                  value={arrayToCsv(searchParams.plantSiteIds)}
                  options={plantSites?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) =>
                    setSearchParams({ plantSiteIds: csvToArray(option) })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00084', '_Model / Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.nickName ?? ''}
                  onChange={event => setSearchParams({ nickName: event.target.value })}
                  onKeyDown={onSearchOnEnter}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Project')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} sx={{ width: '100%' }}>
                  <InputField
                    fullWidth
                    value={arrayToCsv(searchParams.projectCodes)}
                    onChange={event =>
                      setSearchParams({ projectCodes: csvToArray(event.target.value) })
                    }
                    onKeyDown={onSearchOnEnter}
                  />
                  <Button appearance='outlined' priority='normal' onClick={onProjectButtonClick}>
                    ...
                  </Button>
                </Stack>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00086', '_Period')}
              labelAlign='right'
              render={() => (
                <DatePickerCalendar
                  sx={{ width: '100%' }}
                  usecase='date-range-multi'
                  elevation
                  size='large'
                  value={[
                    searchParams.periodFrom ? dayjs(searchParams.periodFrom) : dayjs(),
                    searchParams.periodTo ? dayjs(searchParams.periodTo) : dayjs(),
                  ]}
                  onChange={date => {
                    const [from, to] = date as [unknown, unknown];
                    setSearchParams({
                      periodFrom: from ? String(from) : '',
                      periodTo: to ? String(to) : '',
                    });
                  }}
                />
              )}
            />
          </Grid>

          <Grid size={3}>
            <FormItem
              label={t('LBL00087', '_Bz.Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  value={arrayToCsv(searchParams.bizTypes)}
                  options={bizTypes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ bizTypes: csvToArray(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00088', '_Owner')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={arrayToCsv(searchParams.owners)}
                  onChange={event =>
                    setSearchParams({ owners: csvToArray(event.target.value) })
                  }
                  onKeyDown={onSearchOnEnter}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00089', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucketType}
                  options={
                    bucketTypes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [
                      { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
                      { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
                    ]
                  }
                  onChange={(_, option) => onBucketTypeClick(option as BUCKET_TYPE)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00090', '_Version')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} sx={{ width: '100%' }}>
                  <InputField
                    fullWidth
                    value={searchParams.versionId ?? ''}
                    onChange={event => setSearchParams({ versionId: event.target.value })}
                    onKeyDown={onSearchOnEnter}
                  />
                  {/* AS-IS btnSPVer L3895 — DMF0073 Version popup 호출 */}
                  <Button appearance='outlined' priority='normal' onClick={onVersionPopupClick}>
                    ...
                  </Button>
                </Stack>
              )}
            />
          </Grid>

          <Grid size={6} sx={{ display: 'flex', alignItems: 'center' }}>
            <Stack direction='row' spacing={2} alignItems='center'>
              <Checkbox
                labelText={t('LBL00091', '_Search over range')}
                checked={searchParams.searchOverRange}
                onChange={checked => setSearchParams({ searchOverRange: checked })}
              />
              <Checkbox
                labelText={t('LBL00092', '_Exclude no price')}
                checked={searchParams.excludeNoPrice}
                onChange={checked => setSearchParams({ excludeNoPrice: checked })}
              />
            </Stack>
          </Grid>
          <Grid size={6}>
            <Stack direction='row' className={styles.popupButtonGroup}>
              {/* AS-IS btnExchangeRate L310,325 (Designer 136×26) */}
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenExchangeRate}
              >
                {t('LBL00093', '_Exchange Rate')}
              </Button>
              {/* AS-IS btnSavePricePeriod L917,932 (Designer 136×25) */}
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenSalesPriceRange}
              >
                {t('LBL00094', '_Sales Price Range')}
              </Button>
              {/* AS-IS Price 일괄입력 — Division 무관 (always visible) */}
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenPriceBatchInput}
              >
                {t('LBL00095', '_Price 일괄입력')}
              </Button>
              {/* AS-IS btnTemplate L1068,1084 (Designer 90×64) — Division 81 (ESS) 만 표시 (L205,211 / L2581,2587)
                  E8 매핑 (룰 25 §4 hook 사고 사례) — 모든 사업부 표시 시 단순화 사고 재발 */}
              {showTemplateButton && (
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='small'
                  onClick={onOpenSalesPriceTemplate}
                >
                  {t('LBL00096', '_Sales Price Template')}
                </Button>
              )}
              {/* AS-IS btnColumn L3792 — Grid 컬럼 표시 설정 (DM0002_TitleSetForm_Popup) */}
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onOpenColumnTitleSet}
              >
                {t('LBL00098', '_Column Setup')}
              </Button>
              {/* AS-IS btnBatch L272,287 (Designer 119×26) */}
              <Button
                appearance='outlined'
                priority='normal'
                size='small'
                onClick={onBatchClick}
              >
                {t('LBL00097', '_Batch')}
              </Button>
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
