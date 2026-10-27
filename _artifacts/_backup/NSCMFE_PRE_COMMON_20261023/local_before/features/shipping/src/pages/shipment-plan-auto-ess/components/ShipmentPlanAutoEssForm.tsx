import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useSessionStore } from '@shared/stores';

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

// Bucket 콤보 CODE → store·그리드가 쓰는 BUCKET_TYPE(D/W/M).
//   룩업 `BUCKET_TYPE_CODE` 의 SEGMENT1(CODE)은 **풀워드** 'DAILY'/'WEEKLY'/'MONTHLY' 인데
//   (ora.py 실측 3행), store 기본값(`bucketType: BUCKET_TYPE.DAILY` = 'D')과 MainGrid 의
//   `isDynVisible(kind, bucket, chkSum)`(L63~)은 **D/W/M** 을 쓴다. 매핑 없이 콤보 CODE 를 그대로
//   value 로 넣으면 'D' 와 'DAILY' 가 안 맞아 (1) 콤보가 **빈 값으로 표시**되고 (2) 사용자가 고른
//   'DAILY' 가 store 에 들어가 D_/W_/M_ 컬럼 토글이 전부 어긋난다.
//   자매 SSP0060 이 2026-10-02 에 같은 증상으로 도입한 매핑과 동일하다(ShipmentPlanForm.tsx L38~43).
const BUCKET_CODE_TO_TYPE: Record<string, BUCKET_TYPE> = {
  DAILY: BUCKET_TYPE.DAILY,
  WEEKLY: BUCKET_TYPE.WEEKLY,
  MONTHLY: BUCKET_TYPE.MONTHLY,
};

// Plan Date 조회기간 상한 오프셋(일) — AS-IS cboPlanDate_SelectedIndexChanged(cs L5943)가
//   `drpPeriod.Value2 = dr["TO_DATE"]` 를 쓰고, 콤보 `Plan_Infor_SCP` 의 TO_DATE 가
//   `plan start + 55` 다(실측: CODE=20260919 → TO_DATE=2026-11-13). 자매 SSP0060 은 같은 자리에서
//   **TO_DATE1(+14)** 을 쓰므로(cs L7241) 오프셋이 다르다 — 숫자를 그대로 베끼지 않는다.
const PERIOD_TO_OFFSET_DAYS = 55;

const toYmd8 = (v: string): string => str(v).replace(/-/g, '');

// yyyymmdd(또는 yyyy-mm-dd) → 'yyyy-mm-dd'. Plan Date 라벨을 AS-IS drpPeriod·cboPlanDate 표기와
//   같은 대시 포맷으로 맞춘다(사용자 지시 2026-10-12). 자매 SSP0060 의 `toDashYmd` 와 동일.
const toDashYmd = (v: string): string => {
  const d = toYmd8(v);
  return d.length === 8 ? `${d.slice(0, 4)}-${d.slice(4, 6)}-${d.slice(6, 8)}` : str(v);
};

/**
 * Plan Date(CODE=YYYYMMDD) → 조회기간 [from, to]. 둘 다 YYYYMMDD 8자로 돌려준다.
 *
 * 콤보 `Plan_Infor_SCP` 의 `FROM_DATE`/`TO_DATE`/`TO_DATE1` 은 **쓰지 않는다.** 그 SQL 이
 *   `TO_CHAR(TO_DATE(...))` 처럼 포맷 인자 없이 날짜를 문자열화해 세션 NLS 를 타기 때문이다 —
 *   실측에서 `FROM_DATE='2026-09-19'`(NLS=YYYY-MM-DD) 또는 `'19-SEP-26'`(기본 DD-MON-RR)로 나오고,
 *   `TO_DATE1` 은 연도가 깨진 값(`00191120`)까지 관측됐다. 자매 SSP0060 이 2026-10-02 에 같은 문제를
 *   겪고 동일한 방식(CODE 기반 직접 계산)으로 해소했다(ShipmentPlanForm.tsx `planPeriodOf` 주석).
 *
 * 대시가 섞인 값을 store 에 넣으면 두 가지가 깨진다:
 *   1) `PeriodField` 의 toDayjs 가 길이 8 이 아니면 오늘로 폴백해 기간 표시가 고정된다.
 *   2) 그대로 SP 파라미터(`fromYyyymmdd`/`toYyyymmdd`)로 흘러간다 — `PKG_SSP0021` L2495 의
 *      `TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD')`(이 패키지에서 유일하게 REPLACE 가 없는 자리)가
 *      **ORA-01843: invalid month** 로 터진다. realFlag='Y'(최신 Plan) 분기에서만 재현된다.
 *   CODE 는 콤보 SQL 이 `REPLACE(PLAN_START_YYYYMMDD,'-','')` 로 만들어 항상 깨끗하므로 이걸 쓴다.
 */
const planPeriodOf = (code: string): { from: string; to: string } => {
  const from = toYmd8(code);
  if (from.length !== 8) return { from, to: '' };
  return {
    from,
    to: dayjs(`${from.slice(0, 4)}-${from.slice(4, 6)}-${from.slice(6, 8)}`)
      .add(PERIOD_TO_OFFSET_DAYS, 'day')
      .format('YYYYMMDD'),
  };
};

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
  // Plan Date 라벨 = yyyy-mm-dd (AS-IS cboPlanDate 표기). **CODE(yyyymmdd)로 포맷**한다 —
  //   콤보 NAME 은 `TO_CHAR(TO_DATE(...))` 처럼 포맷 인자 없이 만들어져 세션 NLS 를 타기 때문이다
  //   (실측: NLS=YYYY-MM-DD 면 '2026-09-19', 기본 DD-MON-RR 이면 '19-SEP-26'). value 는 CODE 유지.
  const planDateOptions: Option[] = (planDates ?? [])
    .filter((r): r is NonNullable<typeof r> => r != null)
    .map(r => ({ label: toDashYmd(str(r.CODE)), value: str(r.CODE) }));
  // Bucket — value 를 D/W/M 로 매핑해 store 기본값 'D'(= 첫 항목 Daily)가 콤보에서 매칭되게 한다.
  //   라벨은 룩업 NAME('Daily' 등)을 그대로 쓴다. 폴백 라벨도 NAME 표기(Title Case)에 맞춘다.
  const bucketOptions: Option[] =
    bucketRows && bucketRows.length > 0
      ? bucketRows
          .filter((r): r is NonNullable<typeof r> => r != null)
          .map(r => ({
            label: str(r.NAME) || str(r.CODE),
            value: (BUCKET_CODE_TO_TYPE[str(r.CODE)] ?? str(r.CODE)) as string,
          }))
      : [
          { label: 'Daily', value: BUCKET_TYPE.DAILY },
          { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
          { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
        ];

  // Division 기본값 — 최초 로드 시 첫 번째 division 자동 선택(자매 SSP0060 과 동일, 사용자 지시 2026-10-12).
  //   AS-IS 파리티 근거: `clbDivision_ID` 는 Designer 실측상 **UsrCombo**(= WinForms ComboBox 파생)이고
  //   Form_Load(cs L502)가 `clsCtrl.setListBox(dtMyDivision, clbDivision_ID, false, "CODE", "NAME")` 로
  //   DataSource 를 바인딩한다(CControl.cs L338 overload — blnAllFlag=false 라 'ALL' 항목 없음).
  //   ComboBox 는 DataSource 바인딩 시 첫 행이 자동 선택되고, 바로 다음 줄(cs L505~508)이 그 선택값으로
  //   Company 목록을 만든다. 즉 AS-IS 도 "첫 division 자동 선택 → Company cascade" 다.
  //   이 effect 가 없으면 divisionId 가 빈 문자열로 남아 **cascade 가 아예 시작되지 않는다** —
  //   아래 Company 기본값이 `!sc.divisionId` 로 return 하고, 이어지는 PlanDate 기본값도 걸리지 않아
  //   조회 전 Main 3단 날짜(주차) 헤더까지 만들어지지 않았다(사용자 신고 2026-10-12). Search 는 수동 유지.
  const divisionDefaulted = useRef(false);
  useEffect(() => {
    if (divisionDefaulted.current) return;
    if (sc.divisionId || divisionOptions.length === 0) return;
    divisionDefaulted.current = true;
    setDivision(divisionOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, divisionOptions]);

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
    const code = str(planDates[0].CODE);
    const { from, to } = planPeriodOf(code);
    setPlanDate(code, from, to, true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDate, planDates]);

  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str(r.CODE) === code);
    const { from, to } = planPeriodOf(code);
    setPlanDate(code, from, to, idx === 0);
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
                  // Division 변경 = 검색조건(Div·기간/날짜 제외) + 그리드 초기화(store setDivision, TO-BE
                  //   공통 요건). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가
                  //   이전 Div 로 복귀(commit 51d4e9fa 패턴).
                  onChange={(_, picked) => {
                    const v = str(picked);
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
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

          {/* Bucket — cboBucketType (Daily/Weekly/Monthly). 변경 시 컬럼 표시 규칙만 전환(03 §2.2 — 재조회 없음) */}
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

          {/* Period* — 자매 SSP0060 과 동일하게 공용 PeriodField 로 표시한다(사용자 지시 2026-10-12).
              종전에는 disabled InputField 에 `20260919 ~ 20261113` 처럼 YYYYMMDD 원문을 이어 붙여
              보여줬다 — AS-IS drpPeriod 는 날짜 피커라 `2026-09-19` 대시 표기다. PeriodField 가
              store 의 8자 값을 받아 그 표기로 렌더하므로 변환 없이 주고받는다.

              다만 **편집은 막는다(`disabled`)** — AS-IS 가 두 화면에서 다르다:
                SSP0021 `Designer.cs:428` `this.drpPeriod.Enabled = false;`  → 표시전용
                SSP0060 Designer 에는 해당 줄이 없다(기본 enabled)           → 편집 가능
              그래서 SSP0060 Form 은 editable PeriodField 를 쓰지만 여기서는 disabled 를 준다.
              (`disabled` 는 SSP0015 Packer 시트 선례가 있는 공용 prop — SearchFields.tsx L1120.) */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.periodFrom}
            end={sc.periodTo}
            onChange={(s, e) => set({ periodFrom: s, periodTo: e })}
            disabled
          />

          {/* Model — txtItemId + btnItemId (SCM0002_ItembyDivisionPopup, Main 조회 P_ITEM_ID) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
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
              label={t(LBL.SUM, '_Sum')}
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
