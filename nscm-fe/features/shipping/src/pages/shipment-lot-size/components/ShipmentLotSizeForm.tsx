import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, DIVISION_EE_EXCLUDE, LBL, LOOKUP_TYPE, MENU_ID } from '../shipment-lot-size.constants';
import { useShipmentLotSizeStore } from '../useShipmentLotSizeStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void; // Model 옆 Item 팝업(ItemByDivisionModal) 오픈
  // btnInput/btnDelete(일괄입력·삭제 팝업, design 01 R5/R6)는 조회영역이 아니라 BtnArea(SubTitle
  //   customButtons)가 렌더한다 — 사용자 지시 2026-09-30. 여기에 extraButtons 로 되돌리지 마라.
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
//   7필드(7칸)는 2단 8칸 이내 → 전부 conditions 상시표시. extraConditions 접기 기준은 8칸 초과다
//   (SRCH-02, 종전 6필드 기준은 폐기). AS-IS 시각배치 그대로 1단 Division/Operation Group/From/To Site +
//   2단 Model/Valid/Trans Mode(design 01 layout 행2 x=445). Trans Mode 를 extra 로 되돌리지 마라
//   — 사용자 지시 2026-10-07. cascade 는 sc.divisionId 로 콤보 재조회.
export const ShipmentLotSizeForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentLotSizeStore(s => s.searchCondition);
  const set = useShipmentLotSizeStore(s => s.setSearchCondition);
  const setDivision = useShipmentLotSizeStore(s => s.setDivision);
  const openSearchArea = useShipmentLotSizeStore(s => s.openSearchArea);

  const tabId = useTabid();

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
  //   sc.divisionId 를 deps 에 둬서 F10 리셋 등으로 divisionId 가 비면(='') 다시 첫 사업부로 채운다
  //   (리셋은 '초기화'지 '비우기'가 아니다 — 사용자 지시 2026-10-02).
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) {
      set({ divisionId: divisionOptions[0].value });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions.length, sc.divisionId]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
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
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={noAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행하고, 취소 시 controlled 콤보가 이전
                  //   Division 으로 복귀한다(commit 51d4e9fa 패턴 / 정본 SCP0025 ShipmentPlanFixForm).
                  //   조회(Search) 버튼이 이미 타는 공통 가드와 동일 경로('search').
                  onChange={(_, picked) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(String(picked ?? ''));
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Operation Group — 단일 + ALL, division 무관 정적(cascade 아님) (design 02 §2 #2 / LBL00027) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.OPERATION_GROUP, '_Operation Group')}
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
              label={t(LBL.FROM_SITE, '_From Site')}
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
              label={t(LBL.TO_SITE, '_To Site')}
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

          {/* Model/Nickname — 텍스트 + Item 팝업 버튼 (design 02 §4.6, 값=Item ID).
              라벨은 LBL00618(사용자 지시 2026-10-07) — 입력값으로 ITEM_ID 와 NICK_NAME 을 함께 부분검색한다
              (GET SP P_ITEM_ID 조건). Item 팝업이 채우는 'A,B' 콤마 다중은 종전처럼 완전일치로 동작한다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
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
              label={t(LBL.VALID, '_Valid')}
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

          {/* Trans Mode — 다중 + ALL (design 02 §2 #4 / LBL00025). AS-IS 2단 셋째 칸(x=445) 그대로 상시표시 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TRANS_MODE, '_Trans Mode')}
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
