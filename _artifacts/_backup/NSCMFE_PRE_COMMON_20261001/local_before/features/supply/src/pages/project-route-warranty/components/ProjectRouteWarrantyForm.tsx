import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  ALL_SENTINEL,
  COMBO,
  EXCLUDE_EE_DIVISION,
  LBL,
  MSG,
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

  const [openItemModal, setOpenItemModal] = useState(false);

  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // BLUtils.GetDivisionWithoutEE 2단계 중 화면측 후처리 — EE 사업부 제외(constants COMBO 주석).
  //   참조 안정화(nscm-patterns §5-4) — 매 렌더 새 배열 방지.
  const divisions = useMemo(() => divisionsRaw?.filter(EXCLUDE_EE_DIVISION), [divisionsRaw]);

  // Plant Site = PlantSiteByDivision @divisionId cascade(design/02 §5 #2). division 값을 넘겨
  //   서버 재조회. 값 raw, 인용은 getCombo funnel(자매 shipment-model-pic 패턴). CODE=SCM_SITE_ID.
  const [plantSitesRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: searchParams.divisionId }],
  });

  // 권한목록 교정형(자매 SCP0006 · design/04 GAP-5) — session.div 가 권한목록(EE 제외)에 있으면 그
  //   값, 없으면 목록 첫 행으로 자동 교정. 기존 값(사용자 선택·F6 복원)은 덮지 않는다.
  const session = useSessionStore(state => state.session);
  useEffect(() => {
    if (searchParams.divisionId) return;
    const codes = (divisions ?? []).map(item => String(item.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    setSearchParams({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [divisions, searchParams.divisionId, session.div, setSearchParams]);

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

  // Plant Site / Valid = 콤보 + 선두 ALL sentinel(design/02 §4, ALL→SP NULL).
  const plantSiteOptions = useMemo(
    () => [
      { label: t('LBL00632', '_ALL'), value: ALL_SENTINEL },
      ...(plantSitesRaw?.map(row => ({ label: row.NAME, value: row.CODE })) ?? []),
    ],
    [plantSitesRaw, t]
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

      {/* Model 픽커(btnItemId, design/02 §4.6) — base ItemByDivisionModal(COM0008). div=81
          SCM_SITE_ID/PROJECT_CODE 반환은 SCP0048Ex 팝업 소관이나 미이관(GAP-1) — 조회조건 Model 은
          품번만 필요하므로 base 팝업으로 충분하다. 셀 팝업(div=81)의 Ex 반환만 문서화 gap. */}
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
