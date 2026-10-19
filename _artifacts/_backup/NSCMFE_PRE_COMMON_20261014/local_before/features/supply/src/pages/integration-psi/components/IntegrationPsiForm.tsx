import { useEffect, useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  COMBO,
  DEFAULT_PERIOD_LOOKUP,
  DEFAULT_PERIOD_MONTHS,
  DIVISION_EE_EXCLUDE,
  LBL,
  PERIOD_LIST_FALLBACK_MONTHS,
  PERIOD_SEP,
  PLAN_DATE_ALLOWED_PLAN_TYPES,
} from '../integration-psi.constants';
import { useIntegrationPsiStore } from '../useIntegrationPsiStore';

import styles from './IntegrationPsiForm.module.scss';

interface Props {
  onSearch: () => void;
  // 팝업 오픈 — btnNickName / btnItemId 는 SCM0002 ItemByDivisionModal(division 기준 Item 조회)을 연다.
  onNickNameSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

// design 02 §2 조회조건 combo 상세 (칸-콤보 대응표 — 검색조건 Form 상단 상시 유지 규칙):
//   Division           → COMBO.DIVISION('Division_SCP') + FE 후처리 EE 제외(ATTRIBUTE3<>'EE', design 02 §2 #1)
//   Plan-date          → COMBO.PLAN_DATE('DATE_WEEKLY1_SCP_ALL') 소스풀 + Division·SE/FN PlanType PLANDATE 교집합(§3.1)
//   Plan-type          → COMBO.PLAN_TYPE('PlanType1_SCP_ALL') 소스풀. AS-IS PlanType.Visibility=Never 라 화면 미표시.
//                        (자동재조회 비활성 + 조회 param "" 고정 §4.4 — store 값만 유지, UI 렌더 없음)
//   Period(From ~ To)  → COMBO.CALENDAR_MONTH('CalendarMonth', from/to) 재조회 방식. AS-IS 는 "Period" 단일 라벨 +
//                        "~" 구분자로 from/to 콤보를 한 묶음으로 표기(Designer layoutControlItem2/5). to = HORIZON
//                        또는 from+(기본기간-1)월(§3.2)
//   Qty < 0            → 체크박스(콤보 아님) → p_qty_yn(§2.1). AS-IS chkQty.Text "Qty < 0"
//   Nick Name / Model  → Text + SCM0002 팝업(§4.6). Cell Model = Text (btnCellItem_Id AS-IS NO-OP §4.6)
//                        AS-IS Designer 라벨: Item ID="Model"(lblItemId), CellItem ID="Cell Model"(lblCellItem)
// DB 실측(SQL_ID 5종)은 design 02 §7 게이트차단으로 미확정 — 이름 유사 재사용 후보로 취급(convert-core §2.6).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMM 문자열에 개월수를 더한다(월 롤오버). '202601' + 5 = '202606'. 기간 To 기본값 산정용(design 02 §3.2).
const addMonths = (yyyymm: string, months: number): string => {
  if (!/^\d{6}$/.test(yyyymm)) return yyyymm;
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6));
  const total = y * 12 + (m - 1) + months;
  const ny = Math.floor(total / 12);
  const nm = (total % 12) + 1;
  return `${ny}${String(nm).padStart(2, '0')}`;
};

// AS-IS SCP0111_IntegrationPSI.cs 조회조건 패널(pnlCondition) — design 02 §5.1 SearchArea 매핑.
//   AS-IS 는 _ALL SP 로 소스풀을 한 번 로드하고 DBUtils.Filter 로 클라 후처리(§3.1) — TO-BE 도 동일하게
//   useTabComboQueries 로 소스풀을 받아 FE 후처리로 cascade 를 재현한다(convert-core §2.6, PPL 선례 동일).
export const IntegrationPsiForm = ({ onSearch, onNickNameSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useIntegrationPsiStore(s => s.searchCondition);
  const set = useIntegrationPsiStore(s => s.setSearchCondition);
  const setDivision = useIntegrationPsiStore(s => s.setDivision);
  const openSearchArea = useIntegrationPsiStore(s => s.openSearchArea);

  // Division / PlanDate 소스풀 / PlanType 소스풀 — AS-IS CommonAll 전량 로드(§2). Division 은 EE 제외 후처리.
  const [divisions, planDatesAll, planTypesAll] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_DATE, COMBO.PLAN_TYPE],
  });

  // 선택 PlanDate 앞 6자리(YYYYMM) 를 시작월로 기간 콤보(CalendarMonth) 재조회 — design 02 §3.2 재조회 방식.
  const fromMonth = sc.planStartYyyymmdd ? sc.planStartYyyymmdd.slice(0, 6) : '';

  // 통합PSI Default 조회기간(개월수) — AS-IS Data.Common(LookupCommon,"INTEGRATION_PSI_DEFAULT_PERIOD") (cs:66).
  //   응답 CODE=개월수. To "선택값" 산정 전용(목록 범위 아님). 부재 시 fallback DEFAULT_PERIOD_MONTHS(cs:256-264).
  const [defaultPeriodRows] = useTabLookupQueries({
    filters: [{ lookupType: DEFAULT_PERIOD_LOOKUP }],
  });
  const periodCode = Number(str(defaultPeriodRows?.[0]?.CODE));
  const periodCount = Number.isFinite(periodCode) && periodCode > 0 ? periodCode : DEFAULT_PERIOD_MONTHS;

  // To "선택값"(periodMonth) = 시작월 + (개월수-1)월 — AS-IS cs:260(있음)/264(없음, 5월=6개월치).
  //   주의: 이 값은 초기 선택만 정한다. From/To 콤보 목록 범위는 아래 horizonTo(HORIZON_END)로 별도 산정.
  const periodMonth = fromMonth ? addMonths(fromMonth, periodCount - 1) : '';

  // From/To 콤보 "목록 상한"(toDate) = HORIZON_END_DATE(SCPPlanPeriod_SCP) 우선, 없으면 시작월+11월(design 02 §3.2 / cs:267-278).
  //   AS-IS SetChangedPeriod: SCPPlanPeriod 행이 있으면 HORIZON_END_DATE(YYYYMMDD) 를, 없으면 시작월+11월.
  //   SCPPlanPeriod_SCP 반환 HORIZON_END_DATE + @planName(=planDate)/@divisionId (SCM_ADM_CMBO_SQL_M 실측).
  const [planPeriodRows] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.SCP_PLAN_PERIOD,
        planName: sc.planStartYyyymmdd,
        divisionId: sc.divisionId,
      },
    ],
    enabled: !!sc.planStartYyyymmdd && !!sc.divisionId,
  });
  const horizonEndYyyymm = str(planPeriodRows?.[0]?.HORIZON_END_DATE).slice(0, 6);
  const horizonTo =
    horizonEndYyyymm || (fromMonth ? addMonths(fromMonth, PERIOD_LIST_FALLBACK_MONTHS - 1) : '');

  const [calendarMonths] = useTabComboQueries({
    filters: [{ comboId: COMBO.CALENDAR_MONTH, from: fromMonth, to: horizonTo }],
    enabled: !!fromMonth && !!horizonTo,
  });

  // Division — EE division(ATTRIBUTE3='EE') FE 후처리 제외(design 02 §2 #1 / convert-core §2.6 4계층).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE)
  );

  // PlanDate — "Division 하위 + PlanType 이 SE/FN 인 PLANDATE" 교집합만 노출(design 02 §3.1). 단순 Division 필터 아님.
  const planDateOptions = useMemo<Option[]>(() => {
    const div = sc.divisionId;
    if (!div) return [];
    // 1단: 소스풀 PlanType 에서 Division·SE/FN 인 PLANDATE 집합 산출(§3.1 line 408).
    const allowed = new Set(PLAN_DATE_ALLOWED_PLAN_TYPES as readonly string[]);
    const sefnPlanDates = new Set(
      (planTypesAll ?? [])
        .filter(r => str(r.DIVISION_ID) === div && allowed.has(str(r.CODE)))
        .map(r => str(r.PLANDATE))
        .filter(Boolean)
    );
    // 2단: PlanDate 소스풀을 Division 하위로 거르되, SE/FN PLANDATE 가 있으면 그 교집합으로 제한(§3.1 line 426).
    //   SE/FN 이 하나도 없으면 fallback = Division 전체 PlanDate(§3.1 line 430).
    const inDivision = (planDatesAll ?? []).filter(r => str(r.DIVISION_ID) === div);
    const filtered =
      sefnPlanDates.size > 0
        ? inDivision.filter(r => sefnPlanDates.has(str(r.CODE)))
        : inDivision;
    return toOptions(filtered);
  }, [planDatesAll, planTypesAll, sc.divisionId]);

  // PlanType 은 AS-IS PlanType.Visibility=Never 라 화면에 렌더하지 않으므로 옵션 목록을 만들지 않는다.
  //   (planTypesAll 소스풀은 PlanDate 산출용으로만 사용 — design 02 §3.1. 조회 param 은 "" 고정 §4.4)

  const monthOptions = toOptions(calendarMonths);

  // Division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 근사, PPL §4.3 선례 동일).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // PlanDate 기본값 = 목록 첫/최신(design 02 §4.2 RefreshPlanDate 후 setListBox 434). 단일 필수 콤보.
  const firstPlanDate = planDateOptions[0]?.value ?? '';
  const hasPlanDate = planDateOptions.some(o => o.value === sc.planStartYyyymmdd);
  useEffect(() => {
    if (firstPlanDate && !hasPlanDate) set({ planStartYyyymmdd: firstPlanDate });
  }, [firstPlanDate, hasPlanDate, set]);

  // 기간 기본선택 — from = 시작월(cs:293), to = periodMonth(=시작월+개월수-1, cs:294). 옵션 로드 후 1회.
  //   주의: to 선택값은 Default 조회기간(periodMonth)이지 목록 상한(horizonTo=HORIZON_END)이 아니다 — AS-IS 는
  //   목록은 HORIZON_END 까지 넓게 바인딩하되 초기 선택만 Default 기간으로 좁게 잡는다(cs:287-294).
  const hasFrom = monthOptions.some(o => o.value === sc.fromYyyymm);
  const hasTo = monthOptions.some(o => o.value === sc.toYyyymm);
  useEffect(() => {
    if (!fromMonth) return;
    const next: { fromYyyymm?: string; toYyyymm?: string } = {};
    if (!hasFrom) next.fromYyyymm = fromMonth;
    if (!hasTo) next.toYyyymm = periodMonth;
    if (next.fromYyyymm !== undefined || next.toYyyymm !== undefined) set(next);
  }, [fromMonth, periodMonth, hasFrom, hasTo, set]);

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // Period 묶음 — AS-IS "Period" 단일 라벨 + "~" 구분자로 from/to 콤보를 한 셀에 나란히(Designer layoutControlItem2/5).
  //   From/To 각각 독립 라벨(design 초판)이 아니라 AS-IS 표기 그대로 재현한다.
  const period = (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(LBL.PERIOD, '_Period')}
        labelAlign='right'
        render={() => (
          <div className={styles.periodField}>
            <CustomDropdown
              value={sc.fromYyyymm}
              options={monthOptions}
              onChange={(_, picked) => set({ fromYyyymm: String(picked ?? '') })}
            />
            <span className={styles.periodSeparator}>{PERIOD_SEP}</span>
            <CustomDropdown
              value={sc.toYyyymm}
              options={monthOptions}
              onChange={(_, picked) => set({ toYyyymm: String(picked ?? '') })}
            />
          </div>
        )}
      />
    </Grid>
  );

  // 팝업버튼 endAdornment 부착 텍스트 필드 — Nick Name / Model(SCM0002 팝업이 채움, design 02 §4.6).
  const popupField = (
    labelText: string,
    value: string,
    onChange: (v: string) => void,
    onPopup: () => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' onClick={onPopup} />}
                />
              ),
            }}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row0 — Division* / Nick Name(팝업) / Cell Model / Model(팝업)
              AS-IS Plan-type 은 PlanType.Visibility=Never 라 화면에 렌더하지 않는다(store 값만 유지, 조회 param "" 고정 §4.4). */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            setDivision,
            true
          )}
          {popupField(
            t(LBL.NICK_NAME, '_Nick Name'),
            sc.nickName,
            v => set({ nickName: v }),
            onNickNameSearch
          )}
          {/* Cell Model — btnCellItem_Id AS-IS NO-OP(§4.6). 텍스트 입력만, 팝업 미배선. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CELL_ITEM_ID, '_Cell Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.cellItemId}
                  onChange={e => set({ cellItemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {popupField(
            t(LBL.ITEM_ID, '_Model'),
            sc.itemId,
            v => set({ itemId: v }),
            onItemSearch
          )}

          {/* Row1 — Plan-date* / Period(From ~ To) / Qty < 0 */}
          {/* Plan Date 는 AS-IS UsrCombo 단일선택. SP p_plan_start_yyyymmdd 에 그대로 TO_DATE 되므로 단일값.
              변경 시 하위 cascade(기간) 재계산 + 그리드 초기화(§3 ClearDataSource) — filters clear 는 handleSearch 재조회로 재현. */}
          {single(
            t(LBL.PLAN_DATE, '_Plan-date'),
            sc.planStartYyyymmdd,
            planDateOptions,
            v => set({ planStartYyyymmdd: v, fromYyyymm: '', toYyyymm: '' }),
            true
          )}
          {period}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(LBL.QTY, '_Qty < 0')}
                checked={sc.qtyYn}
                onChange={checked => set({ qtyYn: checked })}
              />
            </div>
          </Grid>
        </>
      }
    />
  );
};
