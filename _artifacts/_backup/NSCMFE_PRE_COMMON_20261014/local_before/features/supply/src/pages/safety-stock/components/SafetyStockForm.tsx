import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL } from '../safety-stock.constants';
import { useSafetyStockStore } from '../useSafetyStockStore';

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 8개 논리조건 중 필드로 노출하는 5건
 * (Division/Plan Group/Period/Item Id+팝업/Valid) + Site/Type/Stage 골격(아래 참조).
 *
 * Division→PlanGroup cascade 는 클라 필터 방식(재조회 아님, §3) — Division 변경 시
 * useSafetyStockStore.setSearchParams 가 하위 선택값을 초기화한다.
 *
 * Site(clbSite)/Type(cboType)/Stage(cboStage) — goal.md v2 ④-1/④-3 실측으로 AS-IS Designer.cs
 * 상 실제 노출 필드임이 확인됐다(cboType(609,12)/cboStage(871,12)/clbSite(324,12) 실좌표 배치).
 * 데이터소스는 화면 전용 SP `SCP.SCP0128_GET_SEARCH_INFO`(반환 6테이블 중 Table[1]/[3]/[2]) 단일
 * 원천으로 확정됐으나(④-1), `PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO` 가 아직 미배포(convert-sp
 * 후속)라 실데이터 배선은 불가하다. 필드 골격(라벨+비활성 드롭다운)만 먼저 노출하고, 임의
 * 목데이터·추측 SQL_ID 로 채우지 않는다(anti-simplification) — SP 배포 후 `useTabComboQueries`
 * 또는 `SCP0128_GET_SEARCH_INFO` 전용 조회 훅으로 교체 예정(TODO: SP 배포 후 배선).
 */
export const SafetyStockForm = () => {
  const { t } = useTranslation();

  const searchParams = useSafetyStockStore(state => state.searchParams);
  const setSearchParams = useSafetyStockStore(state => state.setSearchParams);
  const setFilters = useSafetyStockStore(state => state.setFilters);
  const fetchStaticColumns = useSafetyStockStore(state => state.fetchStaticColumns);
  const openSearchArea = useSafetyStockStore(state => state.isOpenSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions, planGroups] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_GROUP],
  });
  const [validOptions] = useTabComboQueries({ filters: [COMBO.VALID] });

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* 1행(AS-IS y=12): Division/Site/Type/Stage — design 02_search-combo.md §1 좌표 순서. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
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
            {/* Site/Type/Stage — goal.md v2 ④-1/④-3: 데이터소스는 SCP0128_GET_SEARCH_INFO 로
                확정됐으나 PKG_SCP0128 미배포로 실데이터 배선 불가. 골격만 노출(비활성, 빈 옵션),
                임의 목데이터 배선 금지 — SP 배포 후 교체(TODO). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.SITE, '_Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown multiple disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.TYPE, '_Type')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.STAGE, '_Stage')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            {/* 2행(AS-IS y=39~43): Plan Group/Period/Valid — Item Id 는 팝업버튼 포함이라
                extraConditions 로 분리(기존 배치 유지). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupId}
                    options={
                      planGroups
                        ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === searchParams.divisionId)
                        .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                    }
                    onChange={(_, option) => setSearchParams({ planGroupId: option })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <PeriodRangePicker
                label={t(LBL.PERIOD, '_Period')}
                start={searchParams.periodFrom}
                end={searchParams.periodTo}
                onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALID, '_Valid')}
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
        extraConditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ITEM, '_Item')}
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
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: 'SCP0128' }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
