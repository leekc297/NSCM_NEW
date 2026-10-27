import dayjs, { type Dayjs } from 'dayjs';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LABEL, MENU_ID } from '../scheduled-receipt-information.constants';
import { useScheduledReceiptInformationStore } from '../useScheduledReceiptInformationStore';

const VALID_OPTIONS = [
  { label: 'All', value: 'All' },
  { label: 'Y', value: 'Y' },
  { label: 'N', value: 'N' },
];

/**
 * 조회조건 — design/02_search-combo.md §1 인벤토리 7논리조건(Division/PlanGroup/Site/
 * ChildMaterial/Valid/FromDate/ItemId), §5 TO-BE 매핑.
 *
 * 2행 7필드(design 01 §3 pnlCondition 배치): Row1(Division/Site/ItemId+팝업/Valid),
 * Row2(PlanGroup/ChildMaterial/FromDate). 7필드는 2단(6필드) 초과라 hook #52(search-area-
 * extra-conditions) 적용 — Row2 전체를 extraConditions 로 분리.
 *
 * Division 변경 = 하위(PlanGroup/Site/ChildMaterial) 클라 필터 초기화(design 02 §3 필터방식,
 * 서버 재조회 없음). Site/ChildMaterial 콤보는 comboId 미확정(확인 필요, AS-IS 원본·DB 둘 다
 * 이 세션에서 확보 불가) — UI 골격만 노출(SafetyStock/DemandException 선례와 동일 처리).
 */
export const ScheduledReceiptInformationForm = () => {
  const { t } = useTranslation();

  const searchParams = useScheduledReceiptInformationStore(state => state.searchParams);
  const setSearchParams = useScheduledReceiptInformationStore(state => state.setSearchParams);
  const setDivision = useScheduledReceiptInformationStore(state => state.setDivision);
  const setFilters = useScheduledReceiptInformationStore(state => state.setFilters);
  const fetchStaticColumns = useScheduledReceiptInformationStore(state => state.fetchStaticColumns);
  const openSearchArea = useScheduledReceiptInformationStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const [planGroupsAll] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });

  // Division 필터방식(재조회 없음, design 02 §3) — 전량 로드 후 클라에서 DIVISION_ID 로 좁힌다.
  const planGroupOptions = (planGroupsAll ?? []).filter(
    row => !searchParams.divisionId || row.DIVISION_ID === searchParams.divisionId
  );

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Row1(design 01 §1 y=0/12 행): Division/Site/ItemId+팝업/Valid. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.DIVISION, '_Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀(commit 51d4e9fa 패턴).
                    onChange={(_, option) => {
                      const next = option ?? '';
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (ok) setDivision(next);
                      });
                    }}
                  />
                )}
              />
            </Grid>
            {/* Site — design 02 §2.3: comboId 미확정(확인 필요). 골격만 노출(비활성), 임의
                목데이터 배선 금지(anti-simplification). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.SITE, '_Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown multiple disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.ITEM_ID, '_Item')}
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
                label={t(LABEL.VALID, '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.valid}
                    options={VALID_OPTIONS}
                    onChange={(_, option) => setSearchParams({ valid: option ?? 'All' })}
                  />
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <>
            {/* Row2(design 01 §1 y=29/41 행): PlanGroup/ChildMaterial/FromDate. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    value={searchParams.planGroupIds}
                    options={planGroupOptions.map(item => ({ label: item.NAME, value: item.CODE }))}
                    onChange={(_, value) => setSearchParams({ planGroupIds: value })}
                  />
                )}
              />
            </Grid>
            {/* Child Material — design 02 §2.4: comboId 미등록(0 rows, 확인 필요). 골격만 노출. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.CHILD_MATERIAL, '_Child Material')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown multiple disabled value='' options={[]} onChange={() => undefined} />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.FROM_DATE, '_From Date')}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    value={searchParams.fromDate ? (dayjs(searchParams.fromDate)) : null}
                    onChange={
                      ((date: Dayjs | null) => {
                        setSearchParams({ fromDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
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
        preSearchParams={{ divisionId: searchParams.divisionId, scpModuleType: MENU_ID }}
        setSelectedValue={items => setSearchParams({ itemId: items })}
      />
    </>
  );
};
