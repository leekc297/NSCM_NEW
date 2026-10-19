import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BOD_COMBO_ID, INPUT_STATUS_OPTIONS, VALID_YN_OPTIONS } from '../bod.constants';
import { buildDivisionFilteredOptions } from '../bod.util';
import { useBodStore } from '../useBodStore';

/**
 * 조회조건 8종 — AS-IS SCP0007_BOD.cs clbDivision/clbFromSite/clbToSite/clbIncoterms/
 * clbIncotermsSSP/clbTransMode(멀티 checklist) + cboInputStatus/cboValidYN(단일 combo).
 *
 * From/To Site·Incoterms·Incoterms(SSP)·Trans Mode 는 division 종속 client-side 필터
 * (cascade-combo-filter.md §4 — useTabComboQueries 1 round-trip + `.filter()`). AS-IS 는
 * SetChangeControl()(L238-253)로 서버 DIVISION_ID IN(...) 필터를 재조회 없이 재현한다.
 *
 * BOD_COMBO_ID 의 SQL_ID 는 SCM_ADM_CMBO_SQL_M 실측(2026-09-11)으로 확정했다 (bod.constants.ts 참조).
 * FROM_SITE(`FromSiteByDivision1Ex_SCP_ALL`)의 SQL 이 쓰는 `@__GROUP__`는 FE 가 값을 보내지 않아
 * BaseService.makeComboQuery(정규식 `@(\w+)` + params.getOrDefault(key,"''"))에 의해 빈 문자열로
 * 치환된다 — `LIKE '%' || '' || '%'` = `LIKE '%%'`(전체 매칭)이라 0건이 되지는 않는다(단, 그룹별
 * AuthType 필터는 무력화되고 `@sesUserId` 기준으로만 걸러진다. 2026-09-11 BaseService.java:614-628 확인).
 */
export const BodForm = () => {
  const { t } = useTranslation();

  const searchParams = useBodStore(state => state.searchParams);
  const setSearchParams = useBodStore(state => state.setSearchParams);
  const setFilters = useBodStore(state => state.setFilters);
  const fetchStaticColumns = useBodStore(state => state.fetchStaticColumns);
  const openSearchArea = useBodStore(state => state.isOpenSearchArea);

  const [divisions, fromSites, toSites, incotermsRows, transModes] = useTabComboQueries({
    filters: [
      BOD_COMBO_ID.DIVISION,
      BOD_COMBO_ID.FROM_SITE,
      BOD_COMBO_ID.TO_SITE,
      BOD_COMBO_ID.INCOTERMS,
      BOD_COMBO_ID.TRANS_MODE,
    ],
  });

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.divisionId}
                  // Division_SCP 는 EE 사업부를 포함하므로 fetch 후 ATTRIBUTE3='EE' 행을 제외한다
                  // (AS-IS GetDivisionWithoutEE 재현 — 공유 콤보라 SQL 대신 화면에서 필터, bod.constants.ts 참조).
                  options={
                    divisions
                      ?.filter(item => item.ATTRIBUTE3 !== 'EE')
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00022', '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.fromSite}
                  options={buildDivisionFilteredOptions(fromSites, searchParams.divisionId)}
                  onChange={(_, options) => setSearchParams({ fromSite: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00023', '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.toSite}
                  options={buildDivisionFilteredOptions(toSites, searchParams.divisionId)}
                  onChange={(_, options) => setSearchParams({ toSite: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00024', '_Incoterms')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.incoterms}
                  options={incotermsRows?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ incoterms: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00025', '_Trans Mode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.transMode}
                  options={transModes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ transMode: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01083', '_Input Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.inputStatus}
                  options={[...INPUT_STATUS_OPTIONS]}
                  onChange={(_, option) => setSearchParams({ inputStatus: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00639', '_Valid YN')}
              labelAlign='right'
              render={() => (
                // allOption — AS-IS cboValidYN 최초 진입 시 미선택(전체) 상태 재현(useBodStore.ts validYn 기본값 참고).
                <CustomDropdown
                  allOption
                  value={searchParams.validYn}
                  options={[...VALID_YN_OPTIONS]}
                  onChange={(_, option) => setSearchParams({ validYn: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00026', '_Incoterms(SSP)')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.incotermsSsp}
                  options={incotermsRows?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ incotermsSsp: options })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
