import { ItemByDivisionModal, PeriodField, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, isProjectHiddenDivision, MSG } from '../project-route.constants';
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

  // R1(design/01) — 권한 division 0건이면 조회패널 비활성 + MSG00097(04_impl-gap-audit M3).
  //   MyDivision 콤보 자체가 WHERE 절에서 사용자 권한 division 으로 이미 좁혀 반환하므로
  //   (convert-core §2.6 실측), 빈 목록 = 권한 0건과 동치.
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;
  const { setAlert } = useMessageStore.getState();
  useEffect(() => {
    if (!noDivisionAuth) return;
    void setAlert({
      type: 'alert',
      content: t(MSG.REQUIRE_DIVISION, '_조회 가능한 사업부 권한이 없습니다.'),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [noDivisionAuth]);

  // Status = YesOrNo(Y/N) + 선두 ALL sentinel(design/02 C8, isAddALL=true).
  const statusOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: 'ALL' },
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
        onSearch={noDivisionAuth ? undefined : onSearch}
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
                    disabled={noDivisionAuth}
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
                    options={[{ label: t('LBL00632', '_ALL'), value: 'ALL' }]}
                    onChange={() => undefined}
                  />
                )}
              />
            </Grid>
            {/* AS-IS 배치 순서(design/01 §1 Loc): Div → Sales Site → Project → Model → Period → Status */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00617', '_Project')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={projectDisabled || noDivisionAuth}
                    className={commonStyles.popupSearchField}
                    value={searchParams.projectCode ?? ''}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={projectDisabled || noDivisionAuth}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() =>
                                !projectDisabled && !noDivisionAuth && setOpenProjectModal(true)
                              }
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
                label={t('LBL00669', '_Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={noDivisionAuth}
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId ?? ''}
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
            <PeriodField
              gridSize={3}
              mode='month'
              start={searchParams.fromYyyymm}
              end={searchParams.toYyyymm}
              // PeriodField(features/master, 공용) 는 disabled prop 미제공 — Hard Boundary(자기 화면
              //   폴더 밖) 라 확장 불가. noDivisionAuth 시 Search 버튼 자체가 사라져(위 onSearch) 조회는
              //   막히므로 값 입력만 가능한 채로 둔다(부분 비활성 — 04_impl-gap-audit M3 잔여 메모).
              onChange={(from, to) => setSearchParams({ fromYyyymm: from, toYyyymm: to })}
            />
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t('LBL00014', '_Status')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
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

      {/* Model 픽커(design/02 C3/C4) — division + project 사전필터(AS-IS Form_Load L1302 은 division+project
          둘 다 넘긴다. project 미전달 시 후보범위가 넓어지는 드리프트였다 — 04_impl-gap-audit L3). */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={
          { divisionId: searchParams.divisionId, projectCode: searchParams.projectCode ?? '' } as never
        }
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
