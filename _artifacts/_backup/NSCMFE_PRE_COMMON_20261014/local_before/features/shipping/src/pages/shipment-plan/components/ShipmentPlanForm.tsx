import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { ALL, BUCKET_TYPE, COMBO, LBL, MENU_ID, SHEETS } from '../shipment-plan.constants';
import { useShipmentPlanStore } from '../useShipmentPlanStore';

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
//   2단: Plan Date* / Period(표시전용) / Model(txtItemId+btnItemId) / Product Level1(clbProductLevel11)
//   3단(extraConditions — hook #52 2단 초과 접기): Sum / Tot PSI 체크박스
//   Division/Company = 전용 SP 2-cursor(P_SSP0060_GET_SHIPMENT_DIVISION — 콤보 레지스트리 아님, 02 §2-A),
//   Company 는 O_RC2 를 선택 Division 으로 클라 필터(AS-IS LINQ L528-531 등가 — SP 결과에 DIVISION_ID 포함 실측).
export const ShipmentPlanForm = ({ tabId, onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);

  const sc = useShipmentPlanStore(s => s.searchCondition);
  const set = useShipmentPlanStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanStore(s => s.setDivision);
  const setCompany = useShipmentPlanStore(s => s.setCompany);
  const setPlanDate = useShipmentPlanStore(s => s.setPlanDate);
  const openSearchArea = useShipmentPlanStore(s => s.openSearchArea);

  // Division/Company — 화면 mount 시 1회 조회(Form_Load SetChangedControl 재현, 02 §4.1-1).
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
  // Company = O_RC2 전체를 선택 Division 으로 클라 필터 (AS-IS dtCompany LINQ 등가).
  //   주의: GetNERPCode ×4 재필터 경로(02 §2-B)는 PKG_SSP0002 미배포 — 구현 보류.
  //   goal.md 백로그 참조: convert-sp 또는 대체 SQL_ID 등록(사용자 확인) 후 이 필터에 ERP 코드 축 추가.
  const companyOptions = useMemo(
    () =>
      toOptions(
        (divisionData?.o_rc2 ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
      ),
    [divisionData, sc.divisionId]
  );

  // cascade 재조회 콤보 4종 (02 §2-C — 전량 재조회 방식, 응답에 클라 축 필터 금지):
  //   FromSite(@divisionId @companyId) / PlanDate(@companyId) / ProductLevel1(@divisionId) / Bucket.
  //   Bucket = 'BucketType' 재사용 — AS-IS 동일 SP(DM0003_GET_BUCKET_TYPE_CODE) 원천(DMF0021 §1 실측, core §2.6 의미 일치).
  const [fromSites, planDates, cellGroups, bucketRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId, companyId: sc.companyId },
      { comboId: COMBO.PLAN_INFOR, mnuId: MENU_ID, companyId: sc.companyId },
      { comboId: COMBO.CELL_GROUP, mnuId: MENU_ID, divisionId: sc.divisionId },
      'BucketType',
    ],
  });

  const fromSiteOptions = toOptions(fromSites);
  const productLevelOptions = toOptions(cellGroups);
  const planDateOptions = toOptions(planDates);
  const bucketOptions: Option[] =
    bucketRows && bucketRows.length > 0
      ? toOptions(bucketRows)
      : [
          { label: 'DAILY', value: BUCKET_TYPE.DAILY },
          { label: 'WEEKLY', value: BUCKET_TYPE.WEEKLY },
          { label: 'MONTHLY', value: BUCKET_TYPE.MONTHLY },
        ];

  // Company 기본값 — AS-IS 는 세션 사용자 Company 이름(sUserCompany_NM, SSP InnerTable MyCompanyID)
  //   FindString 매칭 후 실패 시 index0(02 §4.1-3). TO-BE 세션(UserSession)에 company 필드가 없어
  //   (실측 — groupId/langCd/userId/div 뿐) 매칭 원천이 없으므로 **첫 행 선택만 재현**한다.
  //   사용자 회사 매칭 재현 수단(세션 확장 또는 MyCompanyID 콤보 등록)은 확인필요(사용자 축,
  //   gap-audit I7 — 04_react-gap.md). 이 대입이 cascade 최초 1회 자동 실행을 유발한다(Form_Load parity).
  const companyDefaulted = useRef(false);
  useEffect(() => {
    if (companyDefaulted.current) return;
    if (!sc.divisionId || sc.companyId || companyOptions.length === 0) return;
    companyDefaulted.current = true;
    setCompany(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.companyId, companyOptions]);

  // PlanDate 기본값 — 재조회 결과 index0(최신 Plan) 강제 선택 → realFlag=true (AS-IS L7226~7268).
  //   재바인딩 무한루프 방지: planDate 가 비었을 때만 1회 대입(이펙트 dep 게이트 = AS-IS detach/attach 등가).
  useEffect(() => {
    if (!sc.companyId || sc.planDate || !planDates || planDates.length === 0) return;
    const first = planDates[0];
    setPlanDate(str(first.CODE), str(first.FROM_DATE), str(first.TO_DATE1), true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDate, planDates]);

  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str((r).CODE) === code);
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
          {/* Division* — 단일선택, 자동선택 없음(사용자 직접 선택 후 cascade 시작 — 02 §4.3) */}
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

          {/* Company* — Division 클라 필터 + 세션 Company 기본값 */}
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

          {/* From Site — 다중선택(clbPlantSite), Com_FromSite_SCP 재조회 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
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

          {/* Bucket — cboBucketType (Daily/Weekly/Monthly). 변경 시 컬럼 표시 규칙만 전환(03 §2.3 — 재조회 없음) */}
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

          {/* Plan Date* — Plan_Infor_SCP 재조회, index0=최신(realFlag) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PLAN_DATE, '_Plan Date')}*`}
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

          {/* Model — txtItemId + btnItemId (SCM0002_ItembyDivisionPopup, Main 조회 P_ITEM_ID) */}
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

          {/* Product Level1 — clbProductLevel11 (CellGroup_SCP), 다중선택. LBL 신규 등록(05_register.sql) 전 영문 fallback */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PRODUCT_LEVEL1, '_Product Level1')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.productLevel11.join(',')}
                  options={productLevelOptions}
                  onChange={(_, picked) =>
                    set({
                      productLevel11: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Sum — chkSum (W_/M_ 집계 컬럼 표시 토글, 01 R9 / 03 §2.3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, '_Sum')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkSum} onChange={checked => set({ chkSum: checked })} />
              )}
            />
          </Grid>

          {/* Tot PSI — chkTotPSI (SEQ<12/21 행 필터 + 재조회 트리거, 03 §2.3). LBL 신규(05_register.sql) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TOT_PSI, '_Tot PSI')}
              labelAlign='right'
              render={() => (
                <Checkbox
                  checked={sc.chkTotPsi}
                  onChange={checked => set({ chkTotPsi: checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
