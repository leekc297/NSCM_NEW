import { ItemByDivisionModal, PeriodField, ProjectByDivisionModal } from 'features/master/src/components';
import { useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, isProjectHiddenDivision } from '../project-route.constants';
import { useProjectRouteStore } from '../useProjectRouteStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(design/02) — Division*(cascade 최상위) / Sales Site(항상 ALL·비활성 死필터) / Model(픽커) /
//   Period(월범위) / Project(픽커, 82/40 비활성) / Status(YesOrNo+ALL).
export const ProjectRouteForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const searchParams = useProjectRouteStore(state => state.searchParams);
  const setSearchParams = useProjectRouteStore(state => state.setSearchParams);
  const openSearchArea = useProjectRouteStore(state => state.openSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);
  const [openProjectModal, setOpenProjectModal] = useState(false);

  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const [statusRows] = useTabComboQueries({ filters: [COMBO.STATUS] });

  // Status = YesOrNo(Y/N) + 선두 ALL sentinel(design/02 C8, isAddALL=true).
  const statusOptions = useMemo(
    () => [
      { label: t('LBL00108', '_ALL'), value: 'ALL' },
      ...(statusRows?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [statusRows, t]
  );

  // 82/40 = Project 입력/픽커 비활성 + 값 clear(design/01 R2). Sales Site 는 항상 ALL·비활성(R4).
  const projectDisabled = isProjectHiddenDivision(searchParams.divisionId);

  return (
    <>
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
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) => setSearchParams({ divisionId: String(option ?? '') })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  // 항상 ALL·비활성 死필터(2021.03.30 속도개선, design/02 R4). SP 로는 'ALL' 고정 전달.
                  <CustomDropdown
                    disabled
                    value='ALL'
                    options={[{ label: t('LBL00108', '_ALL'), value: 'ALL' }]}
                    onChange={() => undefined}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00370', '_Model')}
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
            <PeriodField
              gridSize={3}
              mode='month'
              start={searchParams.fromYyyymm}
              end={searchParams.toYyyymm}
              onChange={(from, to) => setSearchParams({ fromYyyymm: from, toYyyymm: to })}
            />
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00013', '_Project')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={projectDisabled}
                    className={commonStyles.popupSearchField}
                    value={searchParams.projectCode ?? ''}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={projectDisabled}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !projectDisabled && setOpenProjectModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ projectCode: event.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00114', '_Status')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.status}
                    options={statusOptions}
                    onChange={(_, option) => setSearchParams({ status: String(option ?? 'ALL') })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />

      {/* Model 픽커(design/02 C3/C4) — division + project 사전필터. 빈 반환 시 기존 유지는 모달이 담당. */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={{ divisionId: searchParams.divisionId } as never}
        callFromCell={false}
      />

      {/* Project 픽커(design/02 C5/C6) — division 사전필터. 82/40 은 비활성이라 열리지 않음. */}
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={project => setSearchParams({ projectCode: project })}
        preSearchParams={{ divisionId: searchParams.divisionId } as never}
        callFromCell={false}
      />
    </>
  );
};
