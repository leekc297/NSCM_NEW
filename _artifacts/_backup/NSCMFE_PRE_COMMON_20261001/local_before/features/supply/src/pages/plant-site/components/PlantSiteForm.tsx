import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { LABEL, MSG } from '../plant-site.constants';
import { usePlantSiteStore } from '../usePlantSiteStore';
import { COMBO } from '../utils/plant-site.plantSiteCombo';
import { filterEeDivisions, str, toComboOptions } from '../utils/plant-site.util';

export const PlantSiteForm = () => {
  const { t } = useTranslation();

  const openSearchArea = usePlantSiteStore(state => state.openSearchArea);
  const searchParams = usePlantSiteStore(state => state.searchParams);
  const setSearchParams = usePlantSiteStore(state => state.setSearchParams);
  const setAuthDivisions = usePlantSiteStore(state => state.setAuthDivisions);
  const setPlantSiteFilters = usePlantSiteStore(state => state.setPlantSiteFilters);
  const fetchStaticColumns = usePlantSiteStore(state => state.fetchStaticColumns);

  // Division_SCP + FE EE 필터(design 02 §2-1). OSP/Active 는 YesOrNo(+FE 'ALL' 선두).
  const [divisions, yesOrNo] = useTabComboQueries({ filters: [COMBO.DIVISION, COMBO.YES_OR_NO] });

  const { setAlert } = useMessageStore.getState();

  const divisionOptions = toComboOptions(filterEeDivisions(divisions));
  const yesNoOptions = toComboOptions(yesOrNo);

  // R-01(G5): 권한 division 0건이면 조회영역 전체 비활성 + 조회 차단(AS-IS cs:260-261 SetDivisionAuthCheck).
  //   divisions===undefined 는 로딩 중이므로 제외 — 콤보가 로드된 뒤에도 EE 제외 결과가 0이면 무권한.
  const noAuth = divisions !== undefined && divisionOptions.length === 0;

  // 권한 division(EE 제외) 코드 — 조회 시 'ALL' 콤마 확장 원천(권한 함정 방지, design 02 §2-1).
  useEffect(() => {
    setAuthDivisions(divisionOptions.map(o => o.value));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // 무권한 확정 시 1회 안내(AS-IS 는 init 시 레이아웃 비활성 + 안내).
  useEffect(() => {
    if (noAuth)
      void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_PERMISSION, '_권한이 없습니다.') });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noAuth]);

  const runSearch = () => {
    if (noAuth) {
      void setAlert({ type: 'alert', content: t(MSG.NO_DIVISION_PERMISSION, '_권한이 없습니다.') });
      return;
    }
    setPlantSiteFilters();
    void fetchStaticColumns();
  };

  return (
    <SearchArea
      searchButtonLabel={t(LABEL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={runSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABEL.DIVISION, '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={noAuth}
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  onChange={(_, options) => setSearchParams({ divisionId: options || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABEL.PLANT_VENDOR, '_Plant/Vendor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noAuth}
                  value={searchParams.plantVendor}
                  onChange={e => setSearchParams({ plantVendor: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && runSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABEL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noAuth}
                  value={searchParams.plantSite}
                  onChange={e => setSearchParams({ plantSite: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && runSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABEL.OSP, '_OSP')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  limitTags={1}
                  disabled={noAuth}
                  value={searchParams.ospYn}
                  options={yesNoOptions}
                  onChange={(_, option) => setSearchParams({ ospYn: str(option) || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LABEL.ACTIVE, '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  allOption
                  limitTags={1}
                  disabled={noAuth}
                  value={searchParams.validYn}
                  options={yesNoOptions}
                  onChange={(_, option) => setSearchParams({ validYn: str(option) || 'ALL' })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
