import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO } from '../demand-exception.constants';
import { useDemandExceptionStore } from '../useDemandExceptionStore';

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 7논리조건 중 Division 1건만 데이터 배선
 * 완료, Site/PlanGroup/Stage/ValidYn 4건은 UI 골격만 노출(SCP0128 SafetyStock 선례와 동일 처리).
 *
 * Division→PlanGroup cascade 는 클라 필터 방식(재조회 아님, design 02 §3) — Division 변경 시
 * useDemandExceptionStore.setSearchParams 가 하위 선택값을 초기화한다.
 *
 * Site(clbSite)/PlanGroup(clbPlanGroup)/Stage(cboStage)/ValidYn(cboValid) — design/02_search-combo.md
 * §2-2~2-5 전부 데이터소스 확인 필요(AS-IS `.cs` 원본·AS-IS MSSQL 둘 다 이 세션에서 확보 실패).
 * 필드 골격(라벨+비활성 드롭다운)만 먼저 노출하고, 임의 목데이터·추측 SQL_ID 로 채우지 않는다
 * (anti-simplification) — 데이터소스 확정 후 `useTabComboQueries` 또는 전용 조회 훅으로 교체 예정
 * (TODO: 원본/AS-IS DB 확보 후 배선).
 */
export const DemandExceptionForm = () => {
  const { t } = useTranslation();

  const searchParams = useDemandExceptionStore(state => state.searchParams);
  const setSearchParams = useDemandExceptionStore(state => state.setSearchParams);
  const setFilters = useDemandExceptionStore(state => state.setFilters);
  const fetchStaticColumns = useDemandExceptionStore(state => state.fetchStaticColumns);
  const openSearchArea = useDemandExceptionStore(state => state.isOpenSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });

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
            {/* 1행(design 02 §1 x좌표 순서): Division/Site/Stage/ValidYn. */}
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
            {/* Site/Stage/ValidYn — design 02 §2-2/2-4/2-5: 데이터소스 확인 필요(comboId 미확정).
                골격만 노출(비활성, 빈 옵션), 임의 목데이터 배선 금지 — 데이터소스 확정 후 교체(TODO). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00015', '_Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown multiple disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00061', '_Stage')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00639', '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            {/* 2행: Plan Group/Period — Item Id 는 팝업버튼 포함이라 extraConditions 로 분리
                (design 02 §5 배치, SCP0128 선례와 동일). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00002', '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown multiple disabled value='' options={[]} onChange={() => undefined} />
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
          </>
        }
      />
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: 'SCP0129' }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
