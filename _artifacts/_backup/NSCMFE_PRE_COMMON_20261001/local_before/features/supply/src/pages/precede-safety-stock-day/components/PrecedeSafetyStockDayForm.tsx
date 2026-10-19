import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { SEARCH_COMBO_ID, STAGE_LOOKUP_TYPE } from '../precede-safety-stock-day.constants';
import { usePrecedeSafetyStockDayStore } from '../usePrecedeSafetyStockDayStore';
import { buildDivisionFilteredOptions } from '../utils/precede-safety-stock-day.util';

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 9건 중 필드로 노출하는 7건(Division/Plan
 * Group/Stage/Period/Item Id+팝업/Valid) + 필드 미노출 2건(Site/Type, 아래 참조).
 *
 * Division→PlanGroup/Stage cascade 는 병렬 필터 방식(재조회 아님, §3) — Division 변경 시
 * usePrecedeSafetyStockDayStore.setSearchParams 가 하위 선택값을 초기화한다.
 *
 * Site(clbSite)/Type(cboType) 필드는 이번 회차에 노출하지 않는다 — §2-3/§2-5 공급 SQL_ID/
 * 공급원이 확정되지 않아(comboCalls/filterCalls 미포착, DB 후보 특정 불가) 배선하면 오선택
 * 위험(convert-core §2.6 이름-매칭 함정)이 있다. searchParams.scmSiteId/valueType 은 각각
 * 'ALL'/''(필터 없음)로 고정 전송된다 — 확인 필요(§7, 원문 재확인 후 필드 복원 대상).
 */
export const PrecedeSafetyStockDayForm = () => {
  const { t } = useTranslation();

  const searchParams = usePrecedeSafetyStockDayStore(state => state.searchParams);
  const setSearchParams = usePrecedeSafetyStockDayStore(state => state.setSearchParams);
  const setFilters = usePrecedeSafetyStockDayStore(state => state.setFilters);
  const fetchStaticColumns = usePrecedeSafetyStockDayStore(state => state.fetchStaticColumns);
  const openSearchArea = usePrecedeSafetyStockDayStore(state => state.isOpenSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions, planGroups] = useTabComboQueries({
    filters: [SEARCH_COMBO_ID.DIVISION, SEARCH_COMBO_ID.PLAN_GROUP],
  });
  const [validOptions] = useTabComboQueries({ filters: [SEARCH_COMBO_ID.VALID] });
  const [stages] = useTabLookupQueries({ filters: [STAGE_LOOKUP_TYPE] });

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00664', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00641', '_Division')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) => setSearchParams({ divisionId: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00002', '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupId}
                    options={buildDivisionFilteredOptions(
                      planGroups,
                      searchParams.divisionId,
                      'CODE',
                      'NAME'
                    )}
                    onChange={(_, option) => setSearchParams({ planGroupId: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00061', '_Stage')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.stage}
                    options={buildDivisionFilteredOptions(
                      stages?.map(row => ({ ...row, CODE: row.SEGMENT3, NAME: row.SEGMENT3 })),
                      searchParams.divisionId,
                      'CODE',
                      'NAME'
                    )}
                    onChange={(_, option) => setSearchParams({ stage: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <PeriodRangePicker
                label={t('LBL00013', '_Period')}
                start={searchParams.periodFrom}
                end={searchParams.periodTo}
                onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
              />
            </Grid>
          </>
        }
        extraConditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL01142', '_Item')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00639', '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    allOption
                    value={searchParams.validYn}
                    options={
                      validOptions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => setSearchParams({ validYn: option })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: 'SCP0127' }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
