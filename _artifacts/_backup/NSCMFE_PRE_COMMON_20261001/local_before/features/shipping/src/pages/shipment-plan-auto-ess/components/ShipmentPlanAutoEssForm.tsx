import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { ALL, BUCKET_TYPE, COMBO, LBL, MENU_ID, SHEETS } from '../shipment-plan-auto-ess.constants';
import { useShipmentPlanAutoEssStore } from '../useShipmentPlanAutoEssStore';

interface Props {
  tabId: string;
  onSearch: () => void;
  onItemSearch: () => void; // btnItemId (1차 Model 팝업)
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrLayoutControl2 — design 01 §1 / 02 §1):
//   1단: Division* / Company* / From Site(다중) / Bucket
//   2단: Plan Date* / Period(표시전용) / Model(txtItemId+btnItemId)
//   3단(extraConditions — hook #52 2단 초과 접기): Sum 체크박스
//   Division/Company = 전용 SP 2-cursor(P_SSP0021_GET_SHIPMENT_DIVISION — 콤보 레지스트리 아님, 02 §2-A).
//   Company 는 O_RC2 를 선택 Division 으로 클라 필터(AS-IS dtCompany LINQ 등가 — SP 결과에 DIVISION_ID 포함).
export const ShipmentPlanAutoEssForm = ({ tabId, onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);

  const sc = useShipmentPlanAutoEssStore(s => s.searchCondition);
  const set = useShipmentPlanAutoEssStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanAutoEssStore(s => s.setDivision);
  const setCompany = useShipmentPlanAutoEssStore(s => s.setCompany);
  const setPlanDate = useShipmentPlanAutoEssStore(s => s.setPlanDate);
  const openSearchArea = useShipmentPlanAutoEssStore(s => s.openSearchArea);

  // Division/Company — 화면 mount 시 1회 조회(Form_Load SetChangedControl 재현, 02 §4.1).
  //   진입 자동 "Main 조회"는 금지 게이트 유지(np §5-7) — 콤보 공급용 전용 SP 만 발사한다.
  const divisionFilters = useMemo(
    () => ({ param1: session.groupId ?? '', param2: session.userId ?? '' }),
    [session.groupId, session.userId]
  );
  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters: divisionFilters,
    enabled: !!session.userId,
  });
  const divisionOptions = useMemo(() => toOptions(divisionData?.o_rc1), [divisionData]);
  // Company = O_RC2 전체를 선택 Division 으로 클라 필터 (AS-IS dtCompany LINQ 등가 — 재조회 없음, 02 §3).
  const companyOptions = useMemo(
    () =>
      toOptions(
        (divisionData?.o_rc2 ?? []).filter(
          r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId
        )
      ),
    [divisionData, sc.divisionId]
  );

  // cascade 재조회 콤보 3종 (02 §2-C — 전량 재조회, 응답에 클라 축 필터 금지):
  //   FromSite(@divisionId @companyId) / PlanDate(@companyId) / Bucket(BucketType lookup).
  const [fromSites, planDates, bucketRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId, companyId: sc.companyId },
      { comboId: COMBO.PLAN_INFOR, mnuId: MENU_ID, companyId: sc.companyId },
      COMBO.BUCKET_TYPE,
    ],
  });

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

  // Company 기본값 — 세션에 company 필드 부재(groupId/langCd/userId/div 뿐)라 첫 행 선택만 재현(02 §4.1-3).
  //   사용자 회사 매칭 재현 수단(세션 확장/전용 콤보)은 확인필요(04_react-gap §확인필요).
  const companyDefaulted = useRef(false);
  useEffect(() => {
    if (companyDefaulted.current) return;
    if (!sc.divisionId || sc.companyId || companyOptions.length === 0) return;
    companyDefaulted.current = true;
    setCompany(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.companyId, companyOptions]);

  // PlanDate 기본값 — 재조회 결과 index0(최신 Plan) 선택 → realFlag=true (AS-IS L7226~7268).
  useEffect(() => {
    if (!sc.companyId || sc.planDate || !planDates || planDates.length === 0) return;
    const first = planDates[0];
    setPlanDate(str(first.CODE), str(first.FROM_DATE), str(first.TO_DATE1), true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDate, planDates]);

  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str(r.CODE) === code);
    const row = (planDates ?? [])[idx] as ComboResponse | undefined;
    setPlanDate(code, str(row?.FROM_DATE), str(row?.TO_DATE1), idx === 0);
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — 단일선택, 자동선택 없음(사용자 직접 선택 후 cascade 시작 — 02 §4.3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.DIVISION, { defaultValue: 'Division' })}*`}
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

          {/* Company* — Division 클라 필터 + 세션 Company 기본값 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.COMPANY, { defaultValue: 'Company' })}*`}
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

          {/* From Site — 다중선택(clbPlantSite), Com_FromSite_SCP 재조회 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, { defaultValue: 'From Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      plantSiteIds: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Bucket — cboBucketType (Daily/Weekly/Monthly). 변경 시 컬럼 표시 규칙만 전환(03 §2.2 — 재조회 없음) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, { defaultValue: 'Bucket' })}
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

          {/* Plan Date* — Plan_Infor_SCP 재조회, index0=최신(realFlag) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PLAN_DATE, { defaultValue: 'Plan Date' })}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.planDate}
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
              label={`${t(LBL.PERIOD, { defaultValue: 'Period' })}*`}
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

          {/* Model — txtItemId + btnItemId (SCM0002_ItembyDivisionPopup, Main 조회 P_ITEM_ID) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, { defaultValue: 'Model' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
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
        </>
      }
      extraConditions={
        <>
          {/* Sum — chkSum (W_/M_ 집계 컬럼 표시 토글, 03 §2.2) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, { defaultValue: 'Sum' })}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkSum} onChange={checked => set({ chkSum: checked })} />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
