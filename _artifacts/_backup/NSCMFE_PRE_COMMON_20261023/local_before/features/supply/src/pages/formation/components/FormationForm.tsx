import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { LBL, MENU_ID } from '../formation.constants';
import { useFormationStore } from '../useFormationStore';

export const FormationForm = () => {
  const { t } = useTranslation();
  // Div 변경은 그리드를 비우므로 편집중이면 MSG00704 confirm 후 변경(DMF0004 동일). 취소 시 이전 Div 유지.
  const tabId = useTabid();

  const searchParams = useFormationStore(state => state.searchParams);
  const setSearchParams = useFormationStore(state => state.setSearchParams);
  const setFilters = useFormationStore(state => state.setFilters);
  const fetchStaticColumns = useFormationStore(state => state.fetchStaticColumns);
  const openSearchArea = useFormationStore(state => state.openSearchArea);
  const setDivisionAuthorized = useFormationStore(state => state.setDivisionAuthorized);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions, plantSites] = useTabComboQueries({
    // Plant Site — PlantByDivisionOperNonOsp1_SCP_ALL: 파라미터 없이 전체 plant(OSP 제외) 1회 조회.
    //   AS-IS Data_SCP.CommonAll(PlantByDivisionOperNonOsp1) 과 1:1(design 02 §2-2, 반환 CODE=SCM_SITE_ID).
    //   division·OPERATION_GROUP='A' 필터는 이관 CMBO SQL 에 없으므로 아래 plantSiteOptions 에서 FE 클라
    //   필터로 재현한다(convert-core §2.6 — 이름만 맞춘 PlantByDivisionCompany 는 다른 원장 PLANT_ID 오매핑).
    filters: ['MyDivision', 'PlantByDivisionOperNonOsp1_SCP_ALL'],
  });

  const divisionOptions = divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [];

  // division 기본값 = 권한 division 목록 첫 항목(AS-IS 콤보 첫 행 자동선택, design 02 §7 / R3).
  //   store 초기값 session.div 가 권한 목록에 없으면 드롭다운이 빈칸으로 뜨므로 첫 옵션으로 교정한다
  //   (유효한 사용자 선택은 유지). 자매 tact-time 과 동일 규약.
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasCurrentDivision = divisionOptions.some(o => o.value === searchParams.divisionId);
  useEffect(() => {
    if (firstDivision && !hasCurrentDivision) {
      setSearchParams({ divisionId: firstDivision, plantSiteId: 'ALL', itemId: '' });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstDivision, hasCurrentDivision]);

  // Division 권한 가드(AS-IS SetDivisionAuthCheck, R2). 콤보가 로드된 뒤(divisions !== undefined) 후보가
  //   0건이면 권한 division 이 없는 사용자이므로 조회를 차단한다. 로드 전에는 판단을 보류한다.
  const divisionCount = divisions === undefined ? null : divisions.length;
  useEffect(() => {
    if (divisionCount !== null) setDivisionAuthorized(divisionCount > 0);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionCount]);

  // Plant Site 후보 = 선택 division 소속 + OPERATION_GROUP='A' (AS-IS filterCalls#1, design 02 §2-2/§3).
  //   OSP 제외(OSP_YN='N')는 CMBO WHERE 에 이미 baked. division 변경 시 서버 재조회 없이 즉시 좁혀진다.
  const plantSiteOptions =
    plantSites
      ?.filter(row => row.DIVISION_ID === searchParams.divisionId && row.OPERATION_GROUP === 'A')
      .map(item => ({ label: item.NAME, value: item.CODE })) ?? [];

  const onSearch = () => {
    // 권한 division 0건이면 조회 차단 + 안내(AS-IS SetDivisionAuthCheck, R2). MSG00667='No authority assigned.'
    if (divisionCount === 0) {
      void useMessageStore
        .getState()
        .setAlert({ type: 'alert', content: t('MSG00667', '_권한을 가진 Division이 없습니다.') });
      return;
    }
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
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    value={searchParams.divisionId}
                    options={divisionOptions}
                    onChange={(_, option) => {
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (!ok) return;
                        setSearchParams({ divisionId: option, plantSiteId: 'ALL', itemId: '' });
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLANT_SITE, '_Plant Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={searchParams.plantSiteId}
                    options={plantSiteOptions}
                    onChange={(_, options) => setSearchParams({ plantSiteId: options })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MATERIAL, '_Material')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId ?? ''}
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
                    onChange={event => setSearchParams({ itemId: event.target.value })}
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
        setSelectedValue={items => setSearchParams({ itemId: items })}
        // AS-IS SCP0022_Formation.btnItemId_Click 은 화면 ID 앞 7자를 module type 으로 넘긴다.
        //   조회조건 Material 입력값을 팝업 초기 검색어로 넘긴다(팝업이 열릴 때 itemId 로 조회).
        preSearchParams={{
          divisionId: searchParams.divisionId,
          scpModuleType: MENU_ID,
          itemId: searchParams.itemId ?? '',
        }}
      />
    </>
  );
};
