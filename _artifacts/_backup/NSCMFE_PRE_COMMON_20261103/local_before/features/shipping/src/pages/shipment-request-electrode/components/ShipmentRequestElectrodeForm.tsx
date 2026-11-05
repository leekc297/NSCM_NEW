import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { BOH_RADIO_ITEMS, BUCKET_TYPE, COMBO, LBL } from '../shipment-request-electrode.constants';
import { useShipmentRequestElectrodeStore } from '../useShipmentRequestElectrodeStore';

import styles from './ShipmentRequestElectrodeForm.module.scss';

interface Props {
  onSearch: () => void;
  // Material 돋보기 → MaterialByDivisionModal(page 소유, SSP0023 동일). AS-IS btnItemId_Click.
  onItemSearch: () => void;
  // Model/Nickname 돋보기 → MaterialByDivisionModal(page 소유, SSP0023 동일, 사용자 지시 2026-10-22).
  onModelSearch: () => void;
}

// Plan_InforElectrode 콤보의 FROM_DATE/TO_DATE 는 'YYYY-MM-DD'(하이픈 10자리)로 온다. PeriodRangePicker 는
//   8자리 YYYYMMDD 만 파싱하고(parseValue: length!==8 → null) 조회 SP P_FROM/TO_YYYYMMDD 도 8자리라, 하이픈을
//   제거해 8자리로 정규화한다(미정규화 시 Period 공란·조회 빈결과 — SSP0023 ymd8 동일).
const ymd8 = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').replace(/\D/g, '');

/**
 * 조회조건(design 02) — cascade 3단: Division(필터)→Company(재조회)→{PlantSite,PlanDate}(재조회).
 * `useCascadeFields`(master 도메인 CASCADE_LEVELS 카탈로그)는 division/team/endCustomer 등
 * 고정 필드셋만 지원해(Hard Boundary — master 패키지 확장 금지) 이 화면의 company/plantSite/
 * planDate 축을 표현할 수 없다. 개별 useTabComboQueries + CustomDropdown 조합으로 배선한다
 * (PlanGroupDashboardForm 선례 패턴).
 *
 * 레이아웃(SSP0023 ShipmentPlanElectrodeForm 동일 구조):
 * - conditions(항상 표시): Division/Company/Plant Site/Cell Type/Bucket · Plan Date/Period/Material/
 *   Model/Nickname · UOM Type
 * - extraConditions(접힘): 체크박스 6종(Sum/Including Past Period/My Model/Part Leader/Team Leader/
 *   Delegatee Model)
 * Material·Model/Nickname 은 MaterialByDivisionModal(COM0013) 팝업으로 열고(page 소유), Model+NickName 은
 *   'Model/Nickname' 한 칸으로 통합(LBL00618) — 상단 standalone Nick Name 제거(사용자 지시 2026-10-22).
 */
export const ShipmentRequestElectrodeForm = ({ onSearch, onItemSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const sp = useShipmentRequestElectrodeStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestElectrodeStore(state => state.setSearchParams);
  const setDivision = useShipmentRequestElectrodeStore(state => state.setDivision);
  const isOpenSearchArea = useShipmentRequestElectrodeStore(state => state.isOpenSearchArea);
  const bohMode = useShipmentRequestElectrodeStore(state => state.bohMode);
  const setBohMode = useShipmentRequestElectrodeStore(state => state.setBohMode);

  const tabId = useTabid();

  // Division→Company: 필터 방식(재조회 없음, design 02 §3) — 전량 1회 조회 후 클라 필터.
  const [divisions, companiesAll] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.COMPANY],
  });
  const companyOptions = (companiesAll ?? [])
    .filter(row => !sp.divisionId || String(row.DIVISION_ID ?? '') === sp.divisionId)
    .map(row => ({ label: String(row.NAME ?? ''), value: String(row.CODE ?? '') }));

  // Company→PlantSite/PlanDate: 재조회 방식(design 02 §3 — 서버가 division/company 파라미터로 필터).
  const plantSiteEnabled = !!sp.companyId;
  const [plantSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLANT_SITE, divisionId: sp.divisionId, companyId: sp.companyId }],
    enabled: plantSiteEnabled,
  });
  const [planDates] = useTabComboQueries({
    filters: [{ comboId: COMBO.PLAN_DATE, companyId: sp.companyId }],
    enabled: plantSiteEnabled,
  });
  const [cellTypes] = useTabComboQueries({ filters: [COMBO.CELL_TYPE] });

  // Bucket(cboBucketType) — Daily/Weekly/Monthly(D/W/M). 메인그리드 열 bucket 전환(재조회 없음, design 03 §2.2).
  const bucketOptions = [
    { label: 'Daily', value: BUCKET_TYPE.DAILY },
    { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
    { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
  ];

  const handleDivisionChange = (divisionId: string) => {
    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
    //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
    //   cascade(Company/PlantSite/PlanDate/기간) 초기화는 setDivision 의 init 리셋에 포함된다(design 02 §4).
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) setDivision(divisionId);
    });
  };

  const handleCompanyChange = (companyId: string) => {
    setSearchParams({ companyId, plantSiteIds: [], planDate: '', fromYyyymmdd: '', toYyyymmdd: '' });
  };

  const handlePlanDateChange = (planDate: string) => {
    // PlanDate 선택 → 기간 자동 세팅(design 02 §3, 클라 파생 — 서버 재조회 없음). 콤보 FROM_DATE/TO_DATE 는
    //   하이픈 포함이라 ymd8 로 8자리 YYYYMMDD 정규화(PeriodRangePicker 표시 + 조회 SP 파라미터 요건).
    const row = (planDates ?? []).find(r => String(r.CODE ?? '') === planDate);
    setSearchParams({
      planDate,
      fromYyyymmdd: ymd8(row?.FROM_DATE),
      toYyyymmdd: ymd8(row?.TO_DATE),
      // Shipment ETA(하단 drpPeriod2) 자동 초기화 — AS-IS cboPlanDate_SelectedIndexChanged(cs:3716-3717):
      //   drpPeriod2.Value1 = planDate(CODE 자체) / Value2 = TO_DATE (drpPeriod 과 From 이 다름: 기간은 FROM_DATE).
      fromYyyymmdd2: planDate,
      toYyyymmdd2: ymd8(row?.TO_DATE),
    });
  };

  // Company 기본값 — 첫 항목 자동 선택(AS-IS Form_Load 은 sUserCompany_NM 매칭이나 세션 Company 축 부재로
  //   index0 재현, SSP0023 동일 제약). Division 세팅 후 options 로드 시 현재값이 목록에 없을 때만 세팅한다
  //   (옵션 불변+값만 비는 F10 류 커버 — hasCompany 플래그를 deps 에). Company 세팅이 PlanDate/Period 를 연쇄 초기화.
  const hasCompany = companyOptions.some(o => o.value === sp.companyId);
  useEffect(() => {
    if (!sp.divisionId || hasCompany || companyOptions.length === 0) return;
    handleCompanyChange(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sp.divisionId, hasCompany, companyOptions]);

  // Plan Date 기본값 / 기간 파생 — Company 세팅 후 기간(fromYyyymmdd)이 비어 있으면 파생한다.
  //   가드를 planDate 공란이 아니라 '기간 공란' 으로 둔다: Condition(F6) 저장은 기간을 제외하므로
  //   (상단=공용 EXCLUDED_DATE_PARAM, 하단=화면 제외) 재진입 시 planDate 는 복원돼도 기간만 비어 들어온다.
  //   그때도 복원된 planDate(목록에 있으면) 기준으로, 없으면 최신(index0, AS-IS cboPlanDate SelectedIndex=0)
  //   기준으로 상·하단 기간을 파생한다.
  useEffect(() => {
    if (!sp.companyId || sp.fromYyyymmdd || !planDates || planDates.length === 0) return;
    const restored =
      sp.planDate && planDates.some(r => String(r.CODE ?? '') === sp.planDate) ? sp.planDate : '';
    handlePlanDateChange(restored || String(planDates[0].CODE ?? ''));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sp.companyId, sp.planDate, sp.fromYyyymmdd, planDates]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIV, '_Division')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.divisionId}
                  // FE 후필터 CODE!='EE': 리터럴 'EE' 디비전만 제거(AS-IS SetChangedControl L532, SSP0023 동일).
                  //   EE_HD/EE_HG/EE_HM/EE_ST/EE_UC 전극 디비전은 유지.
                  options={(divisions ?? [])
                    .filter(r => String(r.CODE ?? '') !== 'EE')
                    .map(r => ({
                      label: String(r.NAME ?? ''),
                      value: String(r.CODE ?? ''),
                    }))}
                  onChange={(_, option) => handleDivisionChange(option)}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.COMPANY, '_Company')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.companyId}
                  options={companyOptions}
                  onChange={(_, option) => handleCompanyChange(option)}
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
                  value={sp.plantSiteIds.join(',')}
                  options={(plantSites ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({
                      plantSiteIds: option.split(',').filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CELL_TYPE, '_Cell Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sp.cellTypes.join(',')}
                  options={(cellTypes ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) =>
                    setSearchParams({ cellTypes: option.split(',').filter(v => v && v !== 'ALL') })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sp.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) =>
                    setSearchParams({ bucketType: option as 'D' | 'W' | 'M' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_DATE, '_Plan Date')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sp.planDate}
                  options={(planDates ?? []).map(r => ({
                    label: String(r.NAME ?? ''),
                    value: String(r.CODE ?? ''),
                  }))}
                  onChange={(_, option) => handlePlanDateChange(option)}
                />
              )}
            />
          </Grid>
          {/* Period — 직접 편집 불가(disabled): AS-IS drpPeriod.Enabled=false(Designer:904). 값은 Plan Date
              파생(handlePlanDateChange)으로만 채워지는 읽기전용 필드다. 자매 화면 SSP0023 동일(PeriodField disabled).
              상세영역 Shipment Date(drpPeriod2)는 AS-IS 가 Enabled 를 끄지 않아 해당 없음. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sp.fromYyyymmdd}
            end={sp.toYyyymmdd}
            disabled
            onChange={(start, end) => setSearchParams({ fromYyyymmdd: start, toYyyymmdd: end })}
          />
          {/* Material — txtItemId + btnItemId 팝업(MaterialByDivisionModal, page 소유, SSP0023 동일).
              빈 반환 시 기존값 유지. 메인조회 SP P_ITEM_ID 로 전달(setFilters). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sp.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => setSearchParams({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {/* Model/Nickname — txtModelId + 돋보기(MaterialByDivisionModal, page 소유). Model + NickName 통합
              (사용자 지시 2026-10-22). 팝업 선택 → 품번(ITEM_ID)=modelId + 닉네임(NICK_NAME)=nickName 둘 다 세팅
              (메인 GET SP p_model_id + p_nick_name). 직접입력은 품번(modelId)만, nickName 은 비운다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sp.modelId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onModelSearch}
                      />
                    ),
                  }}
                  onChange={e => setSearchParams({ modelId: e.target.value, nickName: '' })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {/* UOM Type(BOH 3-radio) — AS-IS rdButton1/2/3(UOM/Cell/Pancake m). 메인그리드 BOH 표시모드(bohMode)만
              전환(재조회 없음, design 03 §2.2). SSP0023 UOM Type 과 동일 마크업(@shared RadioGroup 미제공). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.UOM_TYPE, '_UOM Type')}
              labelAlign='right'
              render={() => (
                <div className={styles.radioGroup}>
                  {BOH_RADIO_ITEMS.map(item => (
                    <label key={item.radio} className={styles.radioOption}>
                      <input
                        type='radio'
                        name='ssp0022-boh-uom-type'
                        value={item.radio}
                        checked={bohMode === item.radio}
                        onChange={() => setBohMode(item.radio)}
                      />
                      <span>{t(item.lbl, item.fallback)}</span>
                    </label>
                  ))}
                </div>
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 체크박스 6종(Sum · Including Past Period · My Model · Part Leader · Team Leader · Delegatee Model) —
              AS-IS 상단 2행. Sum/Past Period 는 메인그리드 열 표시 토글(재조회 없음, design 03 §2.2),
              My Model/Part Leader/Team Leader/Delegate 는 메인조회 SP 필터(P_MY_MODEL_CHK 등 — 4개 모두 미체크면
              파생 P_NON_CHK='Y', setFilters). SSP0023 extraConditions 와 동일 묶음 배치(사용자 지시 2026-10-22). */}
          <Grid size='auto' sx={{ flexShrink: 0 }}>
            <Stack
              direction='row'
              alignItems='center'
              spacing={2}
              sx={{
                flexShrink: 0,
                flexWrap: 'nowrap',
                pl: '70px',
                '& .MuiFormControlLabel-label': { whiteSpace: 'nowrap' },
              }}
            >
              <Checkbox
                labelText={t(LBL.SUM, '_Sum')}
                checked={sp.sumChecked}
                onChange={checked => setSearchParams({ sumChecked: checked })}
              />
              <Checkbox
                labelText={t(LBL.PAST_PERIOD, 'Including Past Period')}
                checked={sp.pastPeriodChecked}
                onChange={checked => setSearchParams({ pastPeriodChecked: checked })}
              />
              <Checkbox
                labelText={t(LBL.MY_MODEL, '_My Model')}
                checked={sp.myModelChk}
                onChange={checked => setSearchParams({ myModelChk: checked })}
              />
              <Checkbox
                labelText={t(LBL.PART_LEADER, '_Part Leader')}
                checked={sp.partLeaderChk}
                onChange={checked => setSearchParams({ partLeaderChk: checked })}
              />
              <Checkbox
                labelText={t(LBL.TEAM_LEADER, '_Team Leader')}
                checked={sp.teamLeaderChk}
                onChange={checked => setSearchParams({ teamLeaderChk: checked })}
              />
              <Checkbox
                labelText={t(LBL.DELEGATE_MODEL, '_Delegatee Model')}
                checked={sp.delegateModelChk}
                onChange={checked => setSearchParams({ delegateModelChk: checked })}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
