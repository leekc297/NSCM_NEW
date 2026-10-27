import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

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

  // Division ALL/미선택 → 권한 division 코드 전체를 CSV 로 확장해 cascade 에 넘긴다.
  //   AS-IS(SetChangedControl)는 clbDivision='ALL' 을 GetCheckedListValue 가 dtMyDivision 전체
  //   CODE CSV 로 펼친 뒤 dtPlantSiteAll 을 필터한다(=권한 division 하위 plant 전체). PlantSiteByDivision
  //   콤보 SQL 은 GET SP 와 달리 'ALL'→NULL 치환이 없어 리터럴 INSTR(',ALL,', ...) 로 0건이 되므로,
  //   화면에서 AS-IS 와 동일하게 ALL 을 코드 CSV 로 미리 펼쳐 넘긴다.
  const plantSiteDivisionFilter = useMemo(() => {
    const div = searchParams.divisionId;
    if (div && div !== ALL_SENTINEL) return div;
    return (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean).join(',');
  }, [searchParams.divisionId, divisions]);

  // Plant Site = PlantSiteByDivision @divisionId cascade(design/02 §2-2 C1). division 값을 넘겨
  //   서버 재조회. 값 raw, 인용은 getCombo funnel(자매 SCP0048 패턴). CODE=SCM_SITE_ID.
  const [plantSitesRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: plantSiteDivisionFilter }],
  });

  // Operation Group = LookupCommon @lookupType='OPERATION_GROUP'(design/02 §2-3, P/A/E).
  //   C3: OperationGroup 변경은 cascade 아님 — Search 시 grid 재조회만 유발(store 값만 갱신).
  const [operationGroupsRaw] = useTabLookupQueries({ filters: [OPERATION_GROUP_LOOKUP] });

  // Division 기본값 = ALL(권한 division 전체). 초기 빈값이면 ALL sentinel 로 채운다 — 조회 SP·
  //   PlantSite cascade 가 ALL 을 전체로 처리(design/02 §2-1, plantSiteDivisionFilter 참조).
  //   권한목록 로드 후 1회만(divisions === undefined 인 로딩 중엔 건드리지 않는다). 기존 값
  //   (사용자 선택·F6 복원)은 덮지 않는다.
  useEffect(() => {
    if (searchParams.divisionId) return;
    if (divisions === undefined) return;
    setSearchParams({ divisionId: ALL_SENTINEL });
  }, [divisions, searchParams.divisionId, setSearchParams]);

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

  // Operation Group / Valid = 단일 콤보 + 선두 ALL sentinel(design/02 §2-4, ALL→SP NULL).
  // Plant Site 는 다중선택(allOption)이라 ALL 항목을 CustomDropdown 이 자동 제공 → 수동 미포함.
  const plantSiteOptions = useMemo(
    () => plantSitesRaw?.map(row => ({ label: row.NAME, value: row.CODE })) ?? [],
    [plantSitesRaw]
  );
  const operationGroupOptions = useMemo(
    () => [
      { label: t(LBL.ALL, '_ALL'), value: ALL_SENTINEL },
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
      { label: t(LBL.ALL, '_ALL'), value: ALL_SENTINEL },
      ...(validRows?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [validRows, t]
  );

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={noDivisionAuth ? undefined : onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                render={() => (
                  // Division = 다중선택(AS-IS clbDivision = UsrCheckedListBox, design/02 §1).
                  //   값은 CSV(예 '81,82'). 기본값 ALL(권한 division 전체) — allOption 으로 SELECT ALL
                  //   (→ 'ALL' sentinel) 제공, 미선택도 ALL 로 수렴. 조회 SP(P_GET_ProjectRoute_Electrode)는
                  //   FN_STRING_SPLIT(@divisionId,',') IN절로 CSV 다중 처리(DB 실측), ALL→NULL(전체).
                  //   PlantSite 콤보 SQL 도 INSTR CSV 로 cascade(plantSiteDivisionFilter 가 ALL→코드 CSV 확장).
                  <CustomDropdown
                    multiple
                    allOption
                    autoFocus
                    disabled={noDivisionAuth}
                    value={searchParams.divisionId}
                    options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                    onChange={(_, option) =>
                      setSearchParams({ divisionId: String(option ?? ALL_SENTINEL) })
                    }
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
                  // Plant Site = 다중선택(AS-IS clbPlantSite = UsrCheckedListBox, design/02 §1).
                  //   allOption 으로 SELECT ALL(→ 'ALL' sentinel) 자동 제공. 일부 선택은 CSV.
                  //   setFilters 가 ALL_SENTINEL('ALL')→'' 치환, SP 는 CSV 를 FN_STRING_SPLIT IN절 처리.
                  <CustomDropdown
                    multiple
                    allOption
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
