import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { COMBO, EXCLUDE_EE_DIVISION, LBL } from '../master-validation.constants';
import { useMasterValidationStore } from '../useMasterValidationStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(design 02) — Division*(Division_SCP + FE EE 제외, 단일 필수) /
//   Plan Group(PlanGroup_SCP_ALL 전량 -> 선택 Division 클라 필터, 다중 ALL) / Model(Item 팝업).
export const MasterValidationForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const searchParams = useMasterValidationStore(state => state.searchParams);
  const setSearchParams = useMasterValidationStore(state => state.setSearchParams);
  const setDivision = useMasterValidationStore(state => state.setDivision);
  const planGroupLocked = useMasterValidationStore(state => state.planGroupLocked);
  const openSearchArea = useMasterValidationStore(state => state.openSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // EE 사업부 제외 — AS-IS BLUtils.GetDivisionWithoutEE 후처리 재현(CMBO SQL 엔 없음, design 02 §2 #1).
  const divisions = useMemo(() => divisionsRaw?.filter(EXCLUDE_EE_DIVISION), [divisionsRaw]);
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;

  // Plan Group 전량 로드 -> 선택 Division 의 DIVISION_ID 로 클라 필터(cascade, 서버 재조회 없음, design 02 §3).
  const [planGroupsRaw] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupOptions = useMemo(
    () =>
      (planGroupsRaw ?? [])
        .filter(row => !searchParams.divisionId || String(row.DIVISION_ID ?? '') === searchParams.divisionId)
        .map(row => ({ label: row.NAME, value: row.CODE })),
    [planGroupsRaw, searchParams.divisionId]
  );

  // Division 기본값 교정 — 권한목록(EE 제외)에 session.div 있으면 그 값, 없으면 첫 행(AS-IS 단일 강제선택).
  const session = useSessionStore(state => state.session);
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setDivision(codes.includes(sessionDiv) ? sessionDiv : codes[0]);
  }, [divisions, searchParams.divisionId, session.div, setDivision]);

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!openSearchArea}
        onSearch={noDivisionAuth ? undefined : onSearch}
        conditions={
          <>
            {/* Division* — 단일 필수, ALL 없음(design 02 §2 #1) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) => setDivision(String(option ?? ''))}
                  />
                )}
              />
            </Grid>
            {/* Plan Group — 다중(ALL sentinel), 선택 Division 하위만(design 02 §3) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_GROUP, '_Plan Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    sortBy='label'
                    disabled={noDivisionAuth || planGroupLocked}
                    value={searchParams.planGroupIds.join(',')}
                    options={planGroupOptions}
                    onChange={(_, picked) =>
                      // 전체선택/해제는 'ALL' sentinel(빈 배열과 동치, payload p_plan_group_id='')로 정규화.
                      setSearchParams({
                        planGroupIds: String(picked ?? '')
                          .split(',')
                          .filter(v => v !== '' && v.toUpperCase() !== 'ALL'),
                      })
                    }
                  />
                )}
              />
            </Grid>
            {/* Model/Item — 텍스트 + 돋보기 팝업(선택적, design 02 §4.6) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL, '_Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={noDivisionAuth}
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={noDivisionAuth}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !noDivisionAuth && setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />

      {/* Item by Division 공용 팝업(AS-IS DM0002_ItembyDivisionPopupEx = COM0008, design 02 §4.6).
          preSearchParams: divisionId + team/endCustomer/salesSite='ALL' / project=''. */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={itemId => setSearchParams({ itemId })}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
        }}
        callFromCell={false}
      />
    </>
  );
};
