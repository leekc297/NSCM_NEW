import { ModelByDivisionPopup } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  ALL_SENTINEL,
  COMBO,
  EXCLUDE_EE_DIVISION,
  LBL,
  MENU_ID,
  MSG,
  OPERATION_GROUP_LOOKUP_TYPE,
} from '../project-route-warranty.constants';
import { useProjectRouteWarrantyStore } from '../useProjectRouteWarrantyStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(design/02 §5) — Division*(Division_SCP+EE제외, cascade 최상위) / Plant Site
//   (PlantSiteByDivision cascade, ALL) / Model(Item 픽커) / Valid(YesOrNo+ALL).
//   cboOperationGroup(LookupCommon)은 AS-IS 도 UI 숨김·store-only 라 렌더하지 않는다(design/02 §5 #3).
export const ProjectRouteWarrantyForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const searchParams = useProjectRouteWarrantyStore(state => state.searchParams);
  const setSearchParams = useProjectRouteWarrantyStore(state => state.setSearchParams);
  const openSearchArea = useProjectRouteWarrantyStore(state => state.openSearchArea);
  const clearMainFilter = useProjectRouteWarrantyStore(state => state.clearMainFilter);

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });

  // cboOperationGroup = 숨김 콤보(AS-IS Designer Visibility=Never, cs L164-165 setListBox(...,true)로
  //   ALL 항목 포함 로드). UI 엔 렌더하지 않지만 AS-IS 구조와 동일하게 LookupCommon(OPERATION_GROUP)을
  //   로드해 둔다 — 값은 store(기본 ALL)가 보유하고 SP 로 실린다(setFilters ALL→'' 치환).
  useTabComboQueries({
    filters: [{ comboId: COMBO.OPERATION_GROUP, mnuId: MENU_ID, lookupType: OPERATION_GROUP_LOOKUP_TYPE }],
  });

  // cboOperationGroup_SelectedIndexChanged 재현(cs L1012-1017) — operationGroup 변경 시 그리드 비움.
  //   숨김 콤보라 사용자가 직접 바꿀 길은 없지만(=실질 dead-path), AS-IS 구조를 그대로 미러한다.
  useEffect(() => {
    clearMainFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.operationGroup]);
  // BLUtils.GetDivisionWithoutEE 2단계 중 화면측 후처리 — EE 사업부 제외(constants COMBO 주석).
  //   참조 안정화(nscm-patterns §5-4) — 매 렌더 새 배열 방지.
  const divisions = useMemo(() => divisionsRaw?.filter(EXCLUDE_EE_DIVISION), [divisionsRaw]);

  // Division ALL/미선택 → 권한 division(EE 제외) 코드 전체를 CSV 로 확장해 cascade 에 넘긴다.
  //   AS-IS(cs L193 GetCheckedListValue(dtMyDivision, clbDivision))는 체크된 division 을 CODE CSV 로
  //   펼쳐 PlantSiteByDivision 을 재조회한다(=선택 division 하위 plant). PlantSiteByDivision 콤보
  //   SQL 은 'ALL'→NULL 치환이 없어 리터럴 INSTR(',ALL,', ...) 로 0건이 되므로, 화면에서 AS-IS 와
  //   동일하게 ALL 을 코드 CSV 로 미리 펼쳐 넘긴다(자매 SCP0027 plantSiteDivisionFilter 패턴).
  const plantSiteDivisionFilter = useMemo(() => {
    const div = searchParams.divisionId;
    if (div && div !== ALL_SENTINEL) return div;
    return (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean).join(',');
  }, [searchParams.divisionId, divisions]);

  // Plant Site = PlantSiteByDivision @divisionId cascade(design/02 §5 #2). division 값을 넘겨
  //   서버 재조회. 값 raw, 인용은 getCombo funnel(자매 shipment-model-pic 패턴). CODE=SCM_SITE_ID.
  const [plantSitesRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: plantSiteDivisionFilter }],
  });

  // Division 기본값 = ALL(권한 division 전체). 초기 빈값이면 ALL sentinel 로 채운다 — 조회 SP·
  //   PlantSite cascade 가 ALL 을 전체로 처리(plantSiteDivisionFilter 참조). 권한목록 로드 후 1회만
  //   (divisions === undefined 인 로딩 중엔 건드리지 않는다). 기존 값(사용자 선택·F6 복원)은 덮지 않는다.
  useEffect(() => {
    if (searchParams.divisionId) return;
    if (divisions === undefined) return;
    setSearchParams({ divisionId: ALL_SENTINEL });
  }, [divisions, searchParams.divisionId, setSearchParams]);

  // 권한 division 0건이면 조회패널 비활성 + MSG00097(design/02 §7-1, GAP-5). Division_SCP 콤보가
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

  // Valid = 단일 콤보 + 선두 ALL sentinel(design/02 §4, ALL→SP NULL).
  // Plant Site 는 다중선택(allOption)이라 ALL 항목을 CustomDropdown 이 자동 제공 → 수동 미포함.
  const plantSiteOptions = useMemo(
    () => plantSitesRaw?.map(row => ({ label: row.NAME, value: row.CODE })) ?? [],
    [plantSitesRaw]
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
                  // Division = 다중선택(AS-IS clbDivision CheckedListBox, cs L193 GetCheckedListValue).
                  //   값은 CSV(예 '81,82'). 기본값 ALL(권한 division 전체) — allOption 으로 SELECT ALL
                  //   (→ 'ALL' sentinel) 제공, 미선택도 ALL 로 수렴. 조회 SP(P_SCP0048_GET_PROJECTROUTE_
                  //   WARRANTY)는 CSV 다중 처리, ALL→NULL(전체). PlantSite 콤보 SQL 도 INSTR CSV 로 cascade
                  //   (plantSiteDivisionFilter 가 ALL→코드 CSV 확장).
                  <CustomDropdown
                    multiple
                    allOption
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
                  // Plant Site = 다중선택(AS-IS clbPlantSite CheckedListBox, cs L353 GetCheckedListValue).
                  //   allOption 으로 SELECT ALL(→ 'ALL' sentinel) 자동 제공. 일부 선택은 CSV.
                  //   setFilters 가 ALL_SENTINEL('ALL')→'' 치환, SP 는 CSV 를 다중 처리.
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
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => !noDivisionAuth && setOpenItemModal(true)}
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

      {/* Model 픽커(btnItemId, design/02 §4.6) — SCM0002 ModelByDivisionPopup. 조회조건 Model 은
          품번(ITEM_ID)만 필요하므로 onSelect 의 itemId 만 반영한다. */}
      <ModelByDivisionPopup
        open={openItemModal}
        onClose={() => setOpenItemModal(false)}
        onSelect={selected => setSearchParams({ itemId: selected.itemId })}
        params={{
          divisionId: searchParams.divisionId,
          projectCode: '',
          scmSiteId: '',
          itemId: searchParams.itemId ?? '',
        }}
      />
    </>
  );
};
