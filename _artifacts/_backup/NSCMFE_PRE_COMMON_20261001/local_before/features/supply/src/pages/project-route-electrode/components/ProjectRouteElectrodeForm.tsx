import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ALL_SENTINEL,
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  OPERATION_GROUP_LOOKUP,
} from '../project-route-electrode.constants';
import { useProjectRouteElectrodeStore } from '../useProjectRouteElectrodeStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(design/02 §1·§5) — 1행 6컨트롤:
//   Division*(MyDivision, cascade 최상위, 초기 포커스) / Plant Site(PlantSiteByDivision cascade, ALL) /
//   Operation Group(LookupCommon P/A/E, 전체) / Model(Item 픽커) / Valid(YesOrNo+ALL).
//   MyDivision SQL 이 ATTRIBUTE3<>'EE' + 권한 subquery(@sesUserId/@mnuId)를 내재하므로 화면단 EE
//   필터가 불필요하다(design/02 §2-1, 자매 SCP0048 의 Division_SCP+클라 EE필터와 다른 지점).
export const ProjectRouteElectrodeForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const searchParams = useProjectRouteElectrodeStore(state => state.searchParams);
  const setSearchParams = useProjectRouteElectrodeStore(state => state.setSearchParams);
  const openSearchArea = useProjectRouteElectrodeStore(state => state.openSearchArea);

  const [openItemModal, setOpenItemModal] = useState(false);

  // Division = MyDivision(@sesUserId/@mnuId 권한 subquery + ATTRIBUTE3<>'EE'). mnuId 필수 —
  //   미전달 시 권한조인 0건 → 사업부 전멸(참조: [[mydivision-combo-needs-user-gr-mnu-mpg]]).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });

  // Plant Site = PlantSiteByDivision @divisionId cascade(design/02 §2-2 C1). division 값을 넘겨
  //   서버 재조회. 값 raw, 인용은 getCombo funnel(자매 SCP0048 패턴). CODE=SCM_SITE_ID.
  const [plantSitesRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: searchParams.divisionId }],
  });

  // Operation Group = LookupCommon @lookupType='OPERATION_GROUP'(design/02 §2-3, P/A/E).
  //   C3: OperationGroup 변경은 cascade 아님 — Search 시 grid 재조회만 유발(store 값만 갱신).
  const [operationGroupsRaw] = useTabLookupQueries({ filters: [OPERATION_GROUP_LOOKUP] });

  // 권한목록 교정형(자매 SCP0048 · design/02 §4.4) — session.div 가 권한목록에 있으면 그 값,
  //   없으면 목록 첫 행으로 자동 교정. 기존 값(사용자 선택·F6 복원)은 덮지 않는다.
  const session = useSessionStore(state => state.session);
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchParams({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [divisions, searchParams.divisionId, session.div, setSearchParams]);

  // 권한 division 0건이면 조회패널 비활성 + MSG00097(design/02 §7, R-AUTH). MyDivision 콤보가
  //   WHERE 절에서 권한 division 으로 이미 좁혀 반환하므로 빈 목록 = 권한 0건과 동치.
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

  // Plant Site / Operation Group / Valid = 콤보 + 선두 ALL sentinel(design/02 §2-4, ALL→SP NULL).
  const plantSiteOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: ALL_SENTINEL },
      ...(plantSitesRaw?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [plantSitesRaw, t]
  );
  const operationGroupOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: ALL_SENTINEL },
      ...(operationGroupsRaw?.map(row => {
        const rec = row as Record<string, unknown>;
        return { label: String(rec.NAME ?? ''), value: String(rec.CODE ?? '') };
      }) ?? []),
    ],
    [operationGroupsRaw, t]
  );
  const [validRows] = useTabComboQueries({ filters: [COMBO.VALID] });
  const validOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: ALL_SENTINEL },
      ...(validRows?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [validRows, t]
  );

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
                label={t(LBL.DIVISION, '_Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    autoFocus
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
                label={t(LBL.PLANT_SITE, '_Plant Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.plantSite}
                    options={plantSiteOptions}
                    onChange={(_, option) =>
                      setSearchParams({ plantSite: String(option ?? ALL_SENTINEL) })
                    }
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.OPERATION_GROUP, '_Operation Group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.operationGroup === '' ? ALL_SENTINEL : searchParams.operationGroup}
                    options={operationGroupOptions}
                    onChange={(_, option) => {
                      // ALL sentinel → 저장 시 빈값(전체). setFilters 는 빈값을 그대로 SP 로 넘긴다.
                      const v = String(option ?? ALL_SENTINEL);
                      setSearchParams({ operationGroup: v === ALL_SENTINEL ? '' : v });
                    }}
                  />
                )}
              />
            </Grid>
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
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VALID, '_Valid')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={noDivisionAuth}
                    value={searchParams.validFlag}
                    options={validOptions}
                    onChange={(_, option) =>
                      setSearchParams({ validFlag: String(option ?? ALL_SENTINEL) })
                    }
                  />
                )}
              />
            </Grid>
          </>
        }
      />

      {/* Model 픽커(btnItemId, design/02 §2-6) — SCM0002_ItembyDivisionPopup = base ItemByDivisionModal.
          조회조건 Model 은 품번만 필요하므로 base 팝업으로 충분(div=81 Ex 반환 불요, 이 화면은 전극 전용). */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchParams({ itemId: items })}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          itemId: searchParams.itemId ?? '',
        }}
        callFromCell={false}
      />
    </>
  );
};
