import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { useValidationShipmentResultStore } from '../useValidationShipmentResultStore';
import {
  COMBO,
  LBL,
  MENU_ID,
  MSG,
  RESULT_TYPE_LOOKUP_TYPE,
} from '../validation-shipment-result.constants';
import { buildDivisionFilteredOptions } from '../validation-shipment-result.util';

interface Props {
  onSearch: () => void;
  // btnProjectID → ProjectByDivisionModal(page 소유). AS-IS BtnProjectID_Click(cs:396).
  onProjectSearch: () => void;
  // btnItemId → MaterialByDivisionModal(page 소유, Model/Nickname 통합 COM0013). AS-IS BtnItemId_Click(cs:378).
  //   주의: ItemByDivisionModal(COM0008) 로 바꾸지 말 것 — Model 선택 팝업은 MaterialByDivisionModal 이 정본(commit f507cc8a).
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
  const setDivision = useValidationShipmentResultStore(state => state.setDivision);
  const openSearchArea = useValidationShipmentResultStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useValidationShipmentResultStore(state => state.setNoDivisionAuth);

  const tabId = useTabid();

  // Division 콤보 — 단일선택. EE 제외 + user-group unit-auth 권한필터 SQL 내장(@sesUserId/@mnuId 세션 자동).
  const [divisions] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // Result Type 콤보 — LookupCommon(@lookupType='SHIPMENT_RESULT_TYPE'). 후보 I/C/B(VALID='Y'), ALL 없음.
  const [resultTypes] = useTabComboQueries({
    filters: [{ comboId: COMBO.RESULT_TYPE, lookupType: RESULT_TYPE_LOOKUP_TYPE, mnuId: MENU_ID }],
  });
  // Plant/Sales Site 콤보 — 사용자 지시로 AS-IS 텍스트입력 → select 교체. BOD(SCP0007) From/To Site 재사용.
  //   전체 1회 로드 후 division 으로 client-side 필터(cascade = 재조회 아님, BOD 화면 규약 동일).
  const [plantSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, mnuId: MENU_ID }],
  });
  const [salesSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.SALES_SITE, mnuId: MENU_ID }],
  });

  const divisionOptions = toOptions(divisions);
  const resultTypeOptions = toOptions(resultTypes);
  const plantSiteOptions = buildDivisionFilteredOptions(plantSites, sc.divisionId);
  const salesSiteOptions = buildDivisionFilteredOptions(salesSites, sc.divisionId);

  // Division 단일 콤보 기본선택 — AS-IS 는 바인딩 첫 행이 선택된다(design 02 §4.4). 옵션 로드 후 미선택이면 첫 값.
  //   setDivision 경유로 공통 리셋 경로를 탄다(초기 상태라 리셋 대상 없음, SCP0025 Form 동형).
  useEffect(() => {
    if (!sc.divisionId && divisionOptions.length > 0) {
      setDivision(divisionOptions[0].value);
    }
  }, [divisionOptions, sc.divisionId, setDivision]);

  // Result Type 단일 콤보 기본선택 — AS-IS setListBox(blnAllFlag=false)는 DataSource 바인딩 시 첫 행(I)이
  //   자동선택된다(Division 과 동일 호출). 옵션 로드 후 미선택이면 첫 값.
  useEffect(() => {
    if (!sc.resultType && resultTypeOptions.length > 0) {
      set({ resultType: resultTypeOptions[0].value });
    }
  }, [resultTypeOptions, sc.resultType, set]);

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
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
                  //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
                  onChange={(_, option) => {
                    const v = str(option);
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Plant Site — 사용자 지시로 select 교체(AS-IS 텍스트입력 대신). BOD From Site 콤보 다중+ALL.
              division 종속 client-side 필터(cascade). 기본 ALL(무필터), division 변경 시 store 가 ALL 리셋 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.plantSiteId}
                  options={plantSiteOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, options) => set({ plantSiteId: str(options) })}
                />
              )}
            />
          </Grid>

          {/* Sales Site — 사용자 지시로 select 교체(AS-IS 텍스트입력 대신). BOD To Site 콤보 다중+ALL.
              division 종속 client-side 필터(cascade). 기본 ALL(무필터), division 변경 시 store 가 ALL 리셋 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SALES_SITE, '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.salesSiteId}
                  options={salesSiteOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, options) => set({ salesSiteId: str(options) })}
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

          {/* Model/Nickname — 텍스트 + 팝업버튼(MaterialByDivisionModal, division 컨텍스트). 콤마 다중 반환.
              AS-IS Designer 좌표상 Project(627,12)와 Period(58,41) 사이에 위치(811,12) — 그 순서를 지킨다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='Model/Nickname'
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

          {/* Period — 날짜범위(From~To, YYYYMMDD). 기본값 From=To=어제(store initState, AS-IS SP 실동작).
              PeriodRangePicker 가 자체 FormItem/label 을 렌더하므로 바깥 FormItem 으로 감싸지 않는다
              (감싸면 라벨이 Period Period 로 중복 — 자매 safety-stock 패턴). */}
          <Grid size={3}>
            <PeriodRangePicker
              label={t(LBL.PERIOD, 'Period')}
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            />
          </Grid>

          {/* Result Type — 단일선택, LookupCommon(I/C/B). ALL 없음 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.RESULT_TYPE, '_Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.resultType}
                  options={resultTypeOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ resultType: str(option) })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
