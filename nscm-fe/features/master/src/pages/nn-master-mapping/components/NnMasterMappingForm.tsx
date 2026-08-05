import { useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabProcQuery, useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { FALLBACK_ALL, MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import type { SearchCondition } from '../nn-master-mapping.types';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';

interface Props {
  onSearch: () => void;
}

// AS-IS DMF0072_NNMasterMapping.cs 조회조건 7 컨트롤 1:1 매핑:
//   DataType (L200) / Division (L154) / Team (L159) / EndCustomer (L165~178) /
//   Project (L457 popup) / Item (L458 popup) / SalesSite (L186)
// 패턴 원천: features/master/src/pages/contribute-view/components/ContributeViewForm.tsx (DMF0043_01)
export const NnMasterMappingForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const sc = useNnMasterMappingStore(s => s.searchCondition);
  const set = useNnMasterMappingStore(s => s.setSearchCondition);

  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });

  // 화면 진입 시 저장된 검색조건 복원 (As-Is Condition 기능 — contribute-view 동일 패턴)
  //   Condition 버튼이 저장한 {paramNm, paramCtn} 들을 searchCondition 으로 셋팅. (자동조회는 하지 않음 — 사용자 Search)
  useEffect(() => {
    void apiClient
      .get<
        { paramNm: keyof SearchCondition; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`)
      .then(res => {
        if (res.data.result?.length > 0) {
          const saved = res.data.result.reduce(
            (acc, curr) => {
              acc[curr.paramNm] = curr.paramCtn;
              return acc;
            },
            {} as Partial<Record<keyof SearchCondition, string>>
          );
          set(saved as Partial<SearchCondition>);
        }
      });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const { data: dtData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.DATA_TYPE,
    tabId: MENU_ID,
    filters: {},
    enabled: true,
  });
  const { data: teamData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.TEAM,
    tabId: MENU_ID,
    filters: { divisionId: sc.divisionId },
    enabled: !!sc.divisionId,
  });
  const { data: ecData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.END_CUSTOMER,
    tabId: MENU_ID,
    filters: { divisionId: sc.divisionId, deptId: sc.deptId },
    enabled: !!sc.divisionId,
  });
  const { data: ssData } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.SALES_SITE,
    tabId: MENU_ID,
    filters: { divisionId: sc.divisionId, endCustomer: sc.endCustomer },
    enabled: !!sc.divisionId,
  });

  // 표시 형식: ${CODE} (${NAME}) — 단 CODE==NAME 이면 CODE 만 (e.g. 'Excel')
  // SP 가 prepend 하는 `'ALL' AS CODE` 행은 제외 — CustomDropdown 의 `allOption` 으로 위임 (중복 회피)
  const divisionOptions = useMemo(
    () => divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? [],
    [divisions]
  );

  const dataTypeOptions = useMemo(
    () =>
      (dtData?.o_rc1 ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code}`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [dtData]
  );

  const teamOptions = useMemo(
    () =>
      (teamData?.o_rc1 ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code} (${name})`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [teamData]
  );
  const endCustomerOptions = useMemo(
    () =>
      (ecData?.o_rc1 ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code} (${name})`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [ecData]
  );

  const salesSiteOptions = useMemo(
    () =>
      (ssData?.o_rc1 ?? [])
        .map(r => {
          const code = String(r.CODE ?? '');
          const name = String(r.NAME ?? code);
          const label = code === name || name === '' ? code : `${code} (${name})`;
          return { value: code, label };
        })
        .filter(o => o.value !== 'ALL' && o.value !== ''),
    [ssData]
  );

  // Division 필수 — 첫 옵션 자동 선택 (AS-IS .cs L460 MSG00097 회피)
  useEffect(() => {
    if (divisionOptions.length === 0) {
      if (!sc.divisionId && FALLBACK_ALL.length > 0) set({ divisionId: FALLBACK_ALL[0].value });
      return;
    }
    if (!divisionOptions.some(o => o.value === sc.divisionId)) {
      set({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00614', 'Data Type')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  allOption
                  options={dataTypeOptions}
                  value={sc.dataTypeCode}
                  onChange={(_, v) => set({ dataTypeCode: v || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00663', 'Div')}
              labelAlign='right'
              labelSize='middle'
              required
              render={() => (
                <CustomDropdown
                  options={divisionOptions}
                  value={sc.divisionId}
                  onChange={(_, v) =>
                    set({ divisionId: v, deptId: 'ALL', endCustomer: 'ALL', scmSiteId: 'ALL' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00044', 'Team')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  options={teamOptions}
                  value={sc.deptId}
                  onChange={(_, v) =>
                    set({ deptId: v || 'ALL', endCustomer: 'ALL', scmSiteId: 'ALL' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00616', 'End Customer')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  options={endCustomerOptions}
                  value={sc.endCustomer}
                  onChange={(_, v) => set({ endCustomer: v || 'ALL', scmSiteId: 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00617', 'Project')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.projectCode}
                  onChange={e => set({ projectCode: e.target.value })}
                  InputProps={{
                    endAdornment: (
                      <Button
                        disabled={sc.divisionId === '40'}
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon
                            appearance='lined'
                            onClick={() => setOpenProjectModal(true)}
                          />
                        }
                      />
                    ),
                  }}
                  onDoubleClick={() => setOpenProjectModal(true)}
                  disabled={sc.divisionId === '40'}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              // Model/Nickname 라벨 2단 표시 — Project 의 검색 button 영역과 시각 분리 (룰: search-area-button-position-and-toggle.md §1)
              // FormItem.label 이 string 만 받음 — JSX 직접 사용 불가. CSS `white-space: pre-wrap` 으로 multilineLabel 효과 처리.
              label={t('LBL00618', 'Model/Nickname').replace('/', '/\n')}
              labelAlign='right'
              labelSize='middle'
              className={commonStyles.formItem}
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  onChange={e => set({ itemId: e.target.value })}
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
                  onDoubleClick={() => setOpenItemModal(true)}
                />
              )}
            />
          </Grid>
          {/* Sales Site 는 extraConditions (3단) 로 분리 — 펼침/닫기 토글 표시 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00619', 'Sales Site')}
              labelAlign='right'
              labelSize='middle'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  options={salesSiteOptions}
                  value={sc.scmSiteId}
                  onChange={(_, v) => set({ scmSiteId: v || 'ALL' })}
                />
              )}
            />
          </Grid>
          {/* Project Popup (COM0005 공용 modal 재사용) */}
          <ProjectByDivisionModal
            open={openProjectModal}
            modalClose={() => setOpenProjectModal(false)}
            setSelectedValue={projects => {
              set({ projectCode: projects });
              setOpenProjectModal(false);
            }}
            preSearchParams={{
              divisionId: sc.divisionId,
              deptId: sc.deptId,
              endCustomer: sc.endCustomer,
              salesSite: sc.scmSiteId,
              projectCode: sc.projectCode,
              etc: 'N',
            }}
            callFromCell={false}
          />

          {/* Model/Nickname Popup (COM0008 ItemByDivisionModal 재사용) */}
          <ItemByDivisionModal
            open={openItemModal}
            modalClose={() => setOpenItemModal(false)}
            setSelectedValue={items => {
              set({ itemId: items });
              setOpenItemModal(false);
            }}
            preSearchParams={{
              divisionId: sc.divisionId,
              deptId: sc.deptId,
              endCustomer: sc.endCustomer,
              salesSite: sc.scmSiteId,
              projectCode: sc.projectCode,
              itemId: sc.itemId,
            }}
            callFromCell={false}
            headerTitle='Model/Nickname Popup'
          />
        </>
      }
    />
  );
};
