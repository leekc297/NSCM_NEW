import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, DIVISION_EE_EXCLUDE, LBL, LOOKUP_TYPE, MENU_ID } from '../shipment-lot-size.constants';
import { useShipmentLotSizeStore } from '../useShipmentLotSizeStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void; // Model 옆 Item 팝업(ItemByDivisionModal) 오픈
  onBatchInput: () => void; // btnInput — 일괄입력 팝업(design 01 R5)
  onBatchDelete: () => void; // btnDelete — 일괄삭제 팝업(design 01 R6)
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 콤보 6 + Model(팝업):
//   Division*(단일 필수, Division_SCP + EE 제외 클라필터) / Operation Group(단일+ALL, LookupCommon) /
//   From·To Site(다중+ALL, cascade @divisionId 재조회) / Trans Mode(다중+ALL, LookupCommon) /
//   Valid(단일+ALL, YesOrNo) / Model(txtItemId 텍스트 + Item 팝업).
//   7필드 > 6 → Trans Mode 를 extraConditions 로 분리(hook #52·#83). cascade 는 sc.divisionId 로 콤보 재조회.
export const ShipmentLotSizeForm = ({
  onSearch,
  onItemSearch,
  onBatchInput,
  onBatchDelete,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentLotSizeStore(s => s.searchCondition);
  const set = useShipmentLotSizeStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentLotSizeStore(s => s.openSearchArea);

  // 콤보 6종 — 인용은 apiClient.getCombo funnel 자동(§3.3). cascade: From/To Site 는 divisionId 키로 재조회.
  const [divisionRows, opGroupRows, transModeRows, validRows, fromSiteRows, toSiteRows] =
    useTabComboQueries({
      filters: [
        { comboId: COMBO.DIVISION, mnuId: MENU_ID },
        { comboId: COMBO.LOOKUP_COMMON, lookupType: LOOKUP_TYPE.OPERATION_GROUP },
        { comboId: COMBO.LOOKUP_COMMON, lookupType: LOOKUP_TYPE.TRANSPORT_MODE },
        { comboId: COMBO.VALID },
        { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId },
        { comboId: COMBO.TO_SITE, divisionId: sc.divisionId },
      ],
    });

  // Division — EE 제외 클라필터(ATTRIBUTE3<>'EE') 재현: AS-IS GetDivisionWithoutEE 등가(design 02 §2 #1).
  //   Division_SCP 는 CMBO WHERE 에 EE 제외가 없어 FE 재현이 유일 경로(SCP0006 실사고).
  const divisionOptions: Option[] = (divisionRows ?? [])
    .filter(r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE)
    .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

  // R1 권한 게이트(design 01 R1, AS-IS SetDivisionAuthCheck): Division 콤보가 로드됐는데 권한 사업부가
  //   0건이면 조회영역을 비활성 + 안내. divisionRows 도착 전(undefined)은 로딩이므로 게이트하지 않는다(G6).
  const noAuth = divisionRows !== undefined && divisionOptions.length === 0;

  const opGroupOptions = toOptions(opGroupRows);
  const transModeOptions = toOptions(transModeRows);
  const validOptions = toOptions(validRows);
  const fromSiteOptions = toOptions(fromSiteRows);
  const toSiteOptions = toOptions(toSiteRows);

  // 기본선택: Division = 첫 권한 사업부 (design 02 §4 — setListBox 첫 항목). 진입 자동조회는 없음(명시 Search).
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) {
      set({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions.length]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 조회영역 커스텀 버튼(AS-IS btnInput/btnDelete, design 01 §1·R5/R6) — Search 버튼 좌측 배치.
      //   툴바 Insert(no-op)/Delete(remove-new)와 별개 어포던스. 권한 0건(R1)이면 함께 비활성.
      extraButtons={
        <>
          <Button
            appearance='outlined'
            priority='normal'
            size='medium'
            disabled={noAuth}
            buttonLabel={t('LBL00872', { defaultValue: 'Input' })}
            onClick={onBatchInput}
          />
          <Button
            appearance='outlined'
            priority='normal'
            size='medium'
            disabled={noAuth}
            buttonLabel={t('LBL00108', { defaultValue: 'Delete' })}
            onClick={onBatchDelete}
          />
        </>
      }
      conditions={
        <>
          {/* R1 권한 안내(design 01 R1) — 권한 사업부 0건이면 조회영역 비활성 + 안내(조회 불가) */}
          {noAuth && (
            <Grid size={12}>
              <span className={commonStyles.formItem}>
                {t('MSG00429', '_{0} value is required.').replace('{0}', t(LBL.DIVISION, 'Division'))}
              </span>
            </Grid>
          )}
          {/* Division* — 단일 필수 (design 02 §2 #1 / LBL00641) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={noAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => set({ divisionId: String(picked ?? '') })}
                />
              )}
            />
          </Grid>

          {/* Operation Group — 단일 + ALL, division 무관 정적(cascade 아님) (design 02 §2 #2 / LBL00027) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.OPERATION_GROUP, { defaultValue: 'Operation Group' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  disabled={noAuth}
                  value={sc.operationGroup}
                  options={opGroupOptions}
                  onChange={(_, picked) => set({ operationGroup: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* From Site — 다중 + ALL, cascade 하위(SITE_TYPE='PLANT') (design 02 §2 #5 / LBL00022) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, { defaultValue: 'From Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={noAuth}
                  value={sc.fromSite}
                  options={fromSiteOptions}
                  onChange={(_, picked) => set({ fromSite: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* To Site — 다중 + ALL, cascade 하위(SITE_TYPE 무필터, From 과 후보범위 다름) (design 02 §2 #6 / LBL00023) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TO_SITE, { defaultValue: 'To Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={noAuth}
                  value={sc.toSite}
                  options={toSiteOptions}
                  onChange={(_, picked) => set({ toSite: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model — 텍스트 + Item 팝업 버튼 (design 02 §4.6 / LBL00669, 값=Item ID) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, { defaultValue: 'Model' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noAuth}
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noAuth}
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Valid — 단일 + ALL (design 02 §2 #3 / LBL00639, ALL->SP null) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, { defaultValue: 'Valid' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  disabled={noAuth}
                  value={sc.valid}
                  options={validOptions}
                  onChange={(_, picked) => set({ valid: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Trans Mode — 다중 + ALL (design 02 §2 #4 / LBL00025). 7필드>6 → extraConditions 분리(hook #52·#83) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, { defaultValue: 'Trans Mode' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  disabled={noAuth}
                  value={sc.transMode}
                  options={transModeOptions}
                  onChange={(_, picked) => set({ transMode: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
