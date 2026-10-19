import { useEffect, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE, COMBO, LBL, MENU_ID } from '../shipment-plan-electrode.constants';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrConditionPanel1 — design 01 §1 / 02 §2). 칸-콤보 대응표(memory search-condition-combo-header):
//   ┌ 칸 ─────────┬ 콤보ID ──────────────┬ cascade 축 ─────────────┬ FE 후필터 ─────────────┐
//   │ Division*   │ MyDivisionInEE       │ @groupId @userId         │ CODE != 'EE' 제거        │
//   │ Company*    │ Div_Company          │ +DIVISION_ID(클라)        │ 선택 Division 으로 좁힘   │
//   │ From Site   │ Com_FromSitePlantEE  │ @divisionId @companyId    │ -                        │
//   │ Plan Date*  │ Plan_InforElectrode  │ @companyId (재조회)        │ index0=최신(realFlag)    │
//   │ Period*     │ (표시전용)            │ PlanDate 파생 FROM~TO     │ -                        │
//   │ Bucket      │ BUCKET_TYPE_CODE     │ 정적 lookup(DAILY/W/M)    │ -                        │
//   └─────────────┴──────────────────────┴──────────────────────────┴──────────────────────────┘
//   BOH 3-radio / Sum / Past Period 토글은 Main 그리드 상단 컨트롤바에 위치(03 §2.1, 재조회 없음).
export const ShipmentPlanElectrodeForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const set = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanElectrodeStore(s => s.setDivision);
  const setCompany = useShipmentPlanElectrodeStore(s => s.setCompany);
  const setPlanDate = useShipmentPlanElectrodeStore(s => s.setPlanDate);
  const openSearchArea = useShipmentPlanElectrodeStore(s => s.openSearchArea);

  // cascade 콤보 (02 §2): Division / Company(전량 → 클라 Division 필터) / FromSite / PlanDate / Bucket.
  //   Division 은 @groupId @userId 가 콤보 레지스트리 내부 축이라 별도 파라미터 불요(02 §2-A).
  const [divisionRows, companyRows, fromSites, planDates, bucketRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.COMPANY, mnuId: MENU_ID, divisionId: sc.divisionId },
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId, companyId: sc.companyId },
      { comboId: COMBO.PLAN_INFOR, mnuId: MENU_ID, companyId: sc.companyId },
      { comboId: COMBO.BUCKET_TYPE, mnuId: MENU_ID },
    ],
  });

  // FE 후필터 1: Division CODE!='EE' 제거 (02 §2 — EE 는 전극 화면 노출 대상 아님).
  const divisionOptions = toOptions((divisionRows ?? []).filter(r => str(r.CODE) !== 'EE'));
  // FE 후필터 2: Company 를 선택 Division 으로 좁힘 (Div_Company 는 전량 반환, DIVISION_ID 축 실측).
  const companyOptions = toOptions(
    (companyRows ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  const fromSiteOptions = toOptions(fromSites);
  const planDateOptions = toOptions(planDates);
  const bucketOptions: Option[] =
    bucketRows && bucketRows.length > 0
      ? toOptions(bucketRows)
      : [
          { label: 'DAILY', value: BUCKET_TYPE.DAILY },
          { label: 'WEEKLY', value: BUCKET_TYPE.WEEKLY },
          { label: 'MONTHLY', value: BUCKET_TYPE.MONTHLY },
        ];

  // Company 기본값 — 첫 행 선택(02 §4). 세션에 Company 필드 부재로 사용자회사 매칭 대신 index0 재현
  //   (SSP0060 과 동일 제약 — gap-audit I7, 04_react-gap.md 확인필요). cascade 최초 1회 자동 실행 유발.
  const companyDefaulted = useRef(false);
  useEffect(() => {
    if (companyDefaulted.current) return;
    if (!sc.divisionId || sc.companyId || companyOptions.length === 0) return;
    companyDefaulted.current = true;
    setCompany(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.companyId, companyOptions]);

  // PlanDate 기본값 — 재조회 결과 index0(최신 Plan) 강제 선택 → realFlag=true (AS-IS L7226~7268).
  useEffect(() => {
    if (!sc.companyId || sc.planDateYyyymmdd || !planDates || planDates.length === 0) return;
    const first = planDates[0];
    setPlanDate(str(first.CODE), str(first.FROM_DATE), str(first.TO_DATE1), true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDateYyyymmdd, planDates]);

  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str(r.CODE) === code);
    const row = (planDates ?? [])[idx] as ComboResponse | undefined;
    setPlanDate(code, str(row?.FROM_DATE), str(row?.TO_DATE1), idx === 0);
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — MyDivisionInEE, 단일선택(사용자 직접 선택 후 cascade 시작) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.DIVISION, '_Div')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => setDivision(str(picked))}
                />
              )}
            />
          </Grid>

          {/* Company* — Div_Company, Division 클라 필터 + 첫 행 기본값 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.COMPANY, '_Company')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.companyId}
                  options={companyOptions}
                  onChange={(_, picked) => setCompany(str(picked))}
                />
              )}
            />
          </Grid>

          {/* From Site — Com_FromSitePlantEE, 단일선택(@divisionId @companyId 재조회) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.fromSite}
                  options={fromSiteOptions}
                  onChange={(_, picked) => set({ fromSite: str(picked) })}
                />
              )}
            />
          </Grid>

          {/* Plan Date* — Plan_InforElectrode 재조회, index0=최신(realFlag) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PLAN_DATE, '_Plan Date')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.planDateYyyymmdd}
                  options={planDateOptions}
                  onChange={(_, picked) => handlePlanDateChange(str(picked))}
                />
              )}
            />
          </Grid>

          {/* Period* — 표시전용(drpPeriod, PlanDate 파생 FROM_DATE~TO_DATE1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PERIOD, '_Period')}*`}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled
                  value={sc.periodFrom ? `${sc.periodFrom} ~ ${sc.periodTo}` : ''}
                />
              )}
            />
          </Grid>

          {/* Bucket — BUCKET_TYPE_CODE (DAILY/WEEKLY/MONTHLY 완전어). 변경 시 컬럼 표시규칙만 전환(03 §2.2 — 재조회 없음) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, picked) => set({ bucketType: str(picked) as BUCKET_TYPE })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
