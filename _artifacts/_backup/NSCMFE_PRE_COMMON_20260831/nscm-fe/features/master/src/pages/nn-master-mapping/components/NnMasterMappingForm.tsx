import { useEffect, useMemo, useState } from 'react';

import { apiClient } from '@foundation/apis';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ItemByDivisionModal, ProjectByDivisionModal, useCascadeFields } from '../../../components';
import { MENU_ID, SEARCH_CASCADE_COMBO_ID, SHEETS } from '../nn-master-mapping.constants';
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

  // Div / Team / End Customer / Sales Site 는 조인 콤보 1건에서 뽑는다.
  // 이 화면은 Project / Model popup 이 End Customer 와 Sales Site 사이에 끼어 배치가 찢어지므로
  // 컴포넌트가 아니라 훅으로 받아 필요한 자리에 하나씩 꽂는다.
  // cascade 계산 순서는 아래 levels 배열 순서를 따르고, 렌더 위치와는 무관하다.
  const cascade = useCascadeFields({
    comboId: SEARCH_CASCADE_COMBO_ID,
    gridSize: 3,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team', field: 'deptId', sortBy: 'label' },
      { key: 'endCustomer', field: 'endCustomer', sortBy: 'label' },
      { key: 'salesSite', field: 'scmSiteId', sortBy: 'label' },
    ],
    value: sc,
    onChange: (next, changed) => {
      // Division / Team 변경은 화면 고유 조회조건까지 초기화한다 — 종전 인라인 동작 그대로.
      // End Customer / Sales Site 는 cascade 하위만 정리되면 되므로 next 만 반영한다.
      if (changed === 'division' || changed === 'team') {
        set({ ...next, projectCode: '', itemId: '', dataTypeCode: 'ALL' });
        return;
      }
      set(next);
    },
  });

  // 표시 형식: ${CODE} (${NAME}) — 단 CODE==NAME 이면 CODE 만 (e.g. 'Excel')
  // SP 가 prepend 하는 `'ALL' AS CODE` 행은 제외 — CustomDropdown 의 `allOption` 으로 위임 (중복 회피)
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

  // Division 필수 — 첫 옵션 자동 선택(AS-IS .cs L460 MSG00097 회피)은 useCascadeFields 가
  // resolveDivisionAutoSelect 로 내부 처리한다. 여기서 따로 보정하지 않는다.

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
          {cascade.field('division')}
          {cascade.field('team')}
          {cascade.field('endCustomer')}
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
          {cascade.field('salesSite')}

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
