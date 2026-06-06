import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useBodStore } from '../useBodStore';

interface BodFormProps {
  onSubmit: () => void;
}

/**
 * DMF0015 BOD — 조회조건 Form (5 항목)
 * AS-IS: usrConditionPanel1 안 5 컨트롤 (clbDivision/clbBodType/clbFromSite/clbToSite/clbActive)
 * 룰 v2: _tobe/06_search_area.md 표준 + searchFields 카탈로그
 */
export const BodForm = ({ onSubmit }: BodFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useBodStore(state => state.openSearchArea);
  const searchParams = useBodStore(state => state.searchParams);
  const setSearchParams = useBodStore(state => state.setSearchParams);

  const [divisions, bodTypes, fromSites, toSites, yesOrNo] = useTabComboQueries({
    filters: ['MyDivision', 'BodType', 'FromSiteByDivision', 'ToSiteByDivision', 'YesOrNo'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!openSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00378', '_BOD Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.bodType}
                  multiple
                  allOption
                  useClearIcon
                  options={bodTypes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ bodType: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00379', '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.fromSite}
                  multiple
                  allOption
                  useClearIcon
                  options={
                    [
                      ...new Map(
                        fromSites
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => setSearchParams({ fromSite: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00380', '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.toSite}
                  multiple
                  allOption
                  useClearIcon
                  options={
                    [
                      ...new Map(
                        toSites
                          ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                          .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])
                      ).values(),
                    ].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => setSearchParams({ toSite: options })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <Grid size={3}>
          <FormItem
            label={t('LBL00007', '_Active')}
            labelAlign='right'
            render={() => (
              <CustomDropdown
                value={searchParams.activeFlag}
                allOption
                isInput={false}
                options={yesOrNo?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                onChange={(_, option) => setSearchParams({ activeFlag: option })}
              />
            )}
          />
        </Grid>
      }
    />
  );
};
