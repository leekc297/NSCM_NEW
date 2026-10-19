import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO_ID, LBL, LOOKUP_TYPE, MENU_ID } from '../bod-item.constants';
import { useBodItemStore } from '../useBodItemStore';
import { buildDivisionFilteredOptions } from '../utils/bod-item.util';

import styles from './BodItemForm.module.scss';

interface BodItemFormProps {
  onSearch: () => void;
  /** btnItemId — Item-by-division 검색 팝업 오픈(02 §4.6). */
  onOpenItemSearch: () => void;
}

/**
 * 조회조건 9필드 — AS-IS SCP0030_BOD_ITEM.cs clbDivision/clbFromSite/clbToSite/clbIncoterms/
 * clbTransMode/clbPlanGroup(멀티) + cboValidYN(단일) + txtItemId/txtNickName(텍스트) + btnItemId(팝업).
 *
 * cascade = 필터 방식(02 §3): From/To Site·Plan Group 은 division 종속 client-side 필터
 * (`ToSiteBOD1_SCP_ALL`/`PlanGroup_SCP_ALL` 1회 로드 후 buildDivisionFilteredOptions). 재조회형 아님.
 * Division 은 `Division_SCP`(EE 제외는 CMBO 에 없어 FE 클라 필터로 재현, 02 §2.2).
 * 9필드>6 → 3단째부터 extraConditions 접기(#52): 메인 5(Division/FromSite/ToSite/Incoterms/PlanGroup),
 * 확장 4(TransMode/Model+검색/NickName/BOD Item Valid).
 */
export const BodItemForm = ({ onSearch, onOpenItemSearch }: BodItemFormProps) => {
  const { t } = useTranslation();

  const searchParams = useBodItemStore(state => state.searchParams);
  const setSearchParams = useBodItemStore(state => state.setSearchParams);
  const openSearchArea = useBodItemStore(state => state.isOpenSearchArea);

  const [divisions, sites, planGroups, incoterms, transModes] = useTabComboQueries({
    filters: [
      { comboId: COMBO_ID.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO_ID.SITE, mnuId: MENU_ID },
      { comboId: COMBO_ID.PLAN_GROUP, mnuId: MENU_ID },
      { comboId: COMBO_ID.LOOKUP_COMMON, lookupType: LOOKUP_TYPE.INCOTERMS, mnuId: MENU_ID },
      { comboId: COMBO_ID.LOOKUP_COMMON, lookupType: LOOKUP_TYPE.TRANSPORT_MODE, mnuId: MENU_ID },
    ],
  });

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.divisionId}
                  // Division_SCP 는 EE(전극) 사업부 포함 → ATTRIBUTE3='EE' 제외(AS-IS GetDivisionWithoutEE).
                  options={
                    divisions
                      ?.filter(item => item.ATTRIBUTE3 !== 'EE')
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => setSearchParams({ divisionId: option })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.fromSite}
                  options={buildDivisionFilteredOptions(sites, searchParams.divisionId)}
                  onChange={(_, options) => setSearchParams({ fromSite: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_SITE, '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.toSite}
                  // From/To Site 후보 동일(같은 ToSiteBOD1_SCP_ALL division 필터, 02 §1 주2).
                  options={buildDivisionFilteredOptions(sites, searchParams.divisionId)}
                  onChange={(_, options) => setSearchParams({ toSite: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.INCOTERMS, '_Incoterms')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.incoterms}
                  options={incoterms?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ incoterms: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_GROUP, '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.planGroupId}
                  options={buildDivisionFilteredOptions(planGroups, searchParams.divisionId)}
                  onChange={(_, options) => setSearchParams({ planGroupId: options })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, '_Trans Mode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={searchParams.transMode}
                  options={transModes?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) => setSearchParams({ transMode: options })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            {/* Model(=Item ID, 라벨 "Model" 유지) 콤마 다중 입력 + btnItemId 검색 팝업(02 §4.4/§4.6). */}
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <div className={styles.inputWithButton}>
                  <InputField
                    fullWidth
                    value={searchParams.itemId}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    size='small'
                    buttonLabel='...'
                    onClick={onOpenItemSearch}
                  />
                </div>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.nickName}
                  onChange={e => setSearchParams({ nickName: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BOD_ITEM_VALID, '_BOD Item Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.validYn}
                  options={[
                    { label: 'Y', value: 'Y' },
                    { label: 'N', value: 'N' },
                  ]}
                  onChange={(_, option) => setSearchParams({ validYn: option })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
