import { useEffect, useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  COMBO,
  DEFAULT_PERIOD_LOOKUP,
  DEFAULT_PERIOD_MONTHS,
  DIVISION_EE_EXCLUDE,
  LBL,
  PLAN_DATE_ALLOWED_PLAN_TYPES,
} from '../integration-psi.constants';
import { useIntegrationPsiStore } from '../useIntegrationPsiStore';

interface Props {
  onSearch: () => void;
  // 팝업 오픈 — btnNickName / btnItemId 는 SCM0002 ItemByDivisionModal(division 기준 Item 조회)을 연다.
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
//   Period(From ~ To)  → 콤보 아님. SCP 공통 PeriodRangePicker(자유 달력, 사용자 지시 2026-10-12).
//                        초기 선택만 AS-IS 와 같다 — from = PlanDate 의 YYYYMM, to = from+(기본기간-1)월(§3.2 cs:293~294).
//                        AS-IS 의 월 목록 조회(CalendarMonth)·목록 상한(HORIZON_END)은 달력에 적용할 곳이 없어 제거.
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

// YYYYMM ↔ YYYYMMDD 환산 — 공통 PeriodRangePicker 는 값이 **일 단위(YYYYMMDD)** 인데 SCP0111 조회 param 은
//   `p_from_yyyymm`/`p_to_yyyymm`(월 단위)다. store 는 SP 계약대로 YYYYMM 을 유지하고 경계에서만 환산한다.
//   From = 해당월 1일, To = 해당월 **말일** — 선택 구간이 그 달 전체를 덮게 해야 달력 표시와 조회범위가 어긋나지 않는다.
const monthStart = (yyyymm: string): string => (/^\d{6}$/.test(yyyymm) ? `${yyyymm}01` : '');
const monthEnd = (yyyymm: string): string => {
  if (!/^\d{6}$/.test(yyyymm)) return '';
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6));
  if (m < 1 || m > 12) return '';
  // Date.UTC(y, m, 0) = "m+1월의 0일" = m월 말일(윤년 포함 자동).
  const lastDay = new Date(Date.UTC(y, m, 0)).getUTCDate();
  return `${yyyymm}${String(lastDay).padStart(2, '0')}`;
};

// AS-IS SCP0111_IntegrationPSI.cs 조회조건 패널(pnlCondition) — design 02 §5.1 SearchArea 매핑.
//   AS-IS 는 _ALL SP 로 소스풀을 한 번 로드하고 DBUtils.Filter 로 클라 후처리(§3.1) — TO-BE 도 동일하게
//   useTabComboQueries 로 소스풀을 받아 FE 후처리로 cascade 를 재현한다(convert-core §2.6, PPL 선례 동일).
export const IntegrationPsiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useIntegrationPsiStore(s => s.searchCondition);
  const set = useIntegrationPsiStore(s => s.setSearchCondition);
  const setDivision = useIntegrationPsiStore(s => s.setDivision);
  const openSearchArea = useIntegrationPsiStore(s => s.openSearchArea);

  const tabId = useTabid();

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

  // Period 는 공통 PeriodRangePicker(자유 달력)로 바뀌어 **선택 가능한 월 목록 자체가 없다**(사용자 지시 2026-10-12).
  //   그래서 AS-IS SetChangedPeriod 의 "목록 상한" 산정(HORIZON_END_DATE via SCPPlanPeriod_SCP, 없으면 시작월+11월,
  //   cs:267~278)과 월 목록 조회(CalendarMonth, cs:287~291)는 함께 제거했다 — 달력에는 적용할 곳이 없다.
  //   남은 것은 **초기 선택값**(아래 기간 기본선택 effect, cs:293~294)뿐이고 그 계산은 horizon 과 무관하다.
  //   divergence: 상한을 넘는 월도 고를 수 있다. SP 는 해당 월을 빈 컬럼으로 돌려주므로 오류는 아니다(__asis-mapping__ U-6).

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

  // Division 기본 바인딩 = **조회된 목록의 첫 항목**. AS-IS 는 cs:235 setListBox 로 DataSource 만 걸고
  //   명시 지정(cs:237 `cboDivision.ControlValues = "81"`)은 주석 처리돼 있어 UsrCombo 가 첫 행을 자동선택한다.
  //   store 초기값이 빈 문자열이라(useIntegrationPsiStore makeInitSearch) 진입 시 이 effect 가 첫 division 을
  //   채우고, 이후에는 "값이 옵션에 없을 때"(권한 변경 등)만 재교정한다 — 사용자가 고른 division 은 보존.
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

  // 기간 기본선택 — From = 시작월(cs:293), To = periodMonth(= 시작월 + Default개월수 - 1, cs:294).
  //   AS-IS 는 PlanDate 가 바뀌면 SetChangedPeriod 로 **무조건 재설정**한다
  //   (cs:1859 CboPlanDate_SelectedIndexChanged → SetChangedPeriod → cs:293~294).
  //   deps 가 [fromMonth, periodMonth] 뿐이라 사용자가 달력으로 고친 값은 PlanDate 가 바뀔 때까지 유지된다
  //   (종전처럼 월 콤보 옵션 포함여부로 판정하지 않는다 — 자유 달력에는 옵션 목록이 없다).
  useEffect(() => {
    if (!fromMonth || !periodMonth) return;
    set({ fromYyyymm: fromMonth, toYyyymm: periodMonth });
  }, [fromMonth, periodMonth, set]);

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

  // Period — SCP 화면 공통 PeriodRangePicker 로 통일한다(사용자 지시 2026-10-12). 같은 feature 의
  //   capa-mobility-it / production-plan / safety-stock 등과 동일한 사용법(@shared/components).
  //   store 는 SP 계약대로 YYYYMM(`p_from_yyyymm`/`p_to_yyyymm`)을 유지하고 picker 경계에서만 일 단위로 환산한다.
  //   `monthOnly` — 표기를 AS-IS 와 같은 `2026-09 ~ 2027-02` 로 맞춘다(cs L841 `ParseExact(...,"yyyy-MM")`).
  //   picker 가 확정값을 월 경계로 정규화해 주므로 되돌려받은 값의 앞 6자리만 취하면 된다.
  const period = (
    <Grid size={3}>
      <PeriodRangePicker
        className={commonStyles.formItem}
        label={t(LBL.PERIOD, '_Period')}
        monthOnly
        start={monthStart(sc.fromYyyymm)}
        end={monthEnd(sc.toYyyymm)}
        onChange={(start, end) =>
          set({ fromYyyymm: start.slice(0, 6), toYyyymm: end.slice(0, 6) })
        }
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
            // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true
          )}
          {/* Model/Nickname — AS-IS 의 txtNickName + txtItemId **2필드를 하나로 통합**(사용자 지시 2026-10-12).
              값은 `itemId`(= SP `P_ITEM_ID`) 한 축으로만 보낸다. `P_NICK_NAME` 은 공백 고정이다 —
              SP 가 두 조건을 **AND** 로 걸기 때문이다(PKG_SCP0111 BODY L317~319 nick / L324~326 item).
              같은 문자열을 양쪽에 넣으면 "코드도 같고 닉네임도 같은 행"을 요구해 0건이 된다.
              Nickname 으로 찾는 경로는 팝업(MaterialByDivisionModal)이 담당한다 — 팝업이 Model·Nickname
              양쪽으로 검색해 **Model 코드**를 돌려주므로 입력칸에는 항상 코드가 들어온다. */}
          {popupField(
            t(LBL.MODEL_NICKNAME, '_Model/Nickname'),
            sc.itemId,
            v => set({ itemId: v }),
            onItemSearch
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

          {/* Row1 — Plan-date* / Period(From ~ To) */}
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
        </>
      }
      // Qty < 0 은 하단 확장영역으로 분리한다(사용자 지시 2026-10-12).
      //   SearchArea 의 extraConditions = 2단 초과 조건을 접어 두는 하단 영역(hook #52, 자매 SSP0021 Sum 선례).
      extraConditions={
        <Grid size={3}>
          <FormItem
            className={commonStyles.formItem}
            label={t(LBL.QTY, '_Qty < 0')}
            labelAlign='right'
            render={() => (
              <Checkbox checked={sc.qtyYn} onChange={checked => set({ qtyYn: checked })} />
            )}
          />
        </Grid>
      }
    />
  );
};
