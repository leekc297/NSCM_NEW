import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { useValidationShipmentResultStore } from '../useValidationShipmentResultStore';
import {
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  RESULT_DATE_FALLBACK,
  RESULT_TYPE_LOOKUP_TYPE,
} from '../validation-shipment-result.constants';

interface Props {
  onSearch: () => void;
  // btnProjectID → ProjectByDivisionModal(page 소유). AS-IS BtnProjectID_Click(cs:396).
  onProjectSearch: () => void;
  // btnItemId → ItemByDivisionModal(page 소유). AS-IS BtnItemId_Click(cs:378).
  onItemSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

export const ValidationShipmentResultForm = ({ onSearch, onProjectSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const sc = useValidationShipmentResultStore(state => state.searchParams);
  const set = useValidationShipmentResultStore(state => state.setSearchParams);
  const openSearchArea = useValidationShipmentResultStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useValidationShipmentResultStore(state => state.setNoDivisionAuth);

  // Division 콤보 — 단일선택. EE 제외 + user-group unit-auth 권한필터 SQL 내장(@sesUserId/@mnuId 세션 자동).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // Result Type 콤보 — LookupCommon(@lookupType='SHIPMENT_RESULT_TYPE'). 후보 I/C/B(VALID='Y'), ALL 없음.
  const [resultTypes] = useTabComboQueries({
    filters: [{ comboId: COMBO.RESULT_TYPE, lookupType: RESULT_TYPE_LOOKUP_TYPE, mnuId: MENU_ID }],
  });

  const divisionOptions = toOptions(divisions);

  // Division 단일 콤보 기본선택 — AS-IS 는 바인딩 첫 행이 선택된다(design 02 §4.4). 옵션 로드 후 미선택이면 첫 값.
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) {
      set({ divisionId: divisionOptions[0].value });
    }
  }, [divisionOptions, sc.divisionId, set]);

  // Division 권한 게이트(R1, cs:142~143) — MyDivision 결과 0건이면 조회영역 disable + MSG00097.
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, 'Please select Division.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle search)도 함께 막도록 store 로 승계.
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — 단일선택, EE 제외+권한필터 SQL 내장(MyDivision). ALL 없음 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ divisionId: str(option) })}
                />
              )}
            />
          </Grid>

          {/* Plant Site — 텍스트 직접입력(콤보 부활 금지, AS-IS clbPlantSite 주석). SP LIKE %..% */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.plantSiteId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ plantSiteId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Sales Site — 텍스트 직접입력(콤보 부활 금지, AS-IS clbSalesSite 주석). SP LIKE %..% */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SALES_SITE, '_Sales Site')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.salesSiteId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ salesSiteId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Project — 텍스트 + 팝업버튼(ProjectByDivisionModal, division 컨텍스트). 콤마 다중 반환 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PROJECT, '_Project')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.projectCode}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noDivisionAuth}
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onProjectSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ projectCode: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Result Date — 날짜범위(From~To, YYYYMMDD). 기본값 어제~1개월전(store initState) */}
          <Grid size={3}>
            {/* Result Date 라벨 — SCM_ADM_MSG_M 에 'Result Date' 결합 LBL 미존재(design 02 §4.5).
                자유형식 t 키 금지(§2.4) + 오문구 코드 재사용 금지(Hook #114) → 영문 fallback 상수 직접 표기.
                LBL 채번·등록은 별도 요청(04 확인필요). 등록되면 t(LBLxxxxx, RESULT_DATE_FALLBACK) 로 교체. */}
            <FormItem
              className={commonStyles.formItem}
              label={RESULT_DATE_FALLBACK}
              labelAlign='right'
              render={() => (
                <PeriodRangePicker
                  start={sc.fromYyyymmdd}
                  end={sc.toYyyymmdd}
                  onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
                />
              )}
            />
          </Grid>

          {/* Result Type — 단일선택, LookupCommon(I/C/B). ALL 없음 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.RESULT_TYPE, '_Result Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.resultType}
                  options={toOptions(resultTypes)}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ resultType: str(option) })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        // 7필드(>6) → 3단째부터 extraConditions 분리(#52). Model 은 division cascade 종속(#52 §2.2 우선순위2).
        <Grid size={3}>
          <FormItem
            className={commonStyles.formItem}
            label={t(LBL.MODEL, '_Model')}
            labelAlign='right'
            render={() => (
              <InputField
                fullWidth
                className={commonStyles.popupSearchField}
                value={sc.itemId}
                disabled={noDivisionAuth}
                InputProps={{
                  endAdornment: (
                    <Button
                      appearance='outlined'
                      priority='normal'
                      disabled={noDivisionAuth}
                      iconComponent={
                        <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                      }
                    />
                  ),
                }}
                onChange={e => set({ itemId: e.target.value })}
                onKeyDown={e => e.key === 'Enter' && onSearch()}
              />
            )}
          />
        </Grid>
      }
    />
  );
};
