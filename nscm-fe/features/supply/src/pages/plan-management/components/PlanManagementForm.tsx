import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, LBL, MENU_ID } from '../plan-management.constants';
import { usePlanManagementStore } from '../usePlanManagementStore';

interface Props {
  onSearch: () => void;
  /** Division 권한 0건 — 조회조건 전체 disabled(AS-IS SetDivisionAuthCheck(usrLayoutControl2), design 01 §2 행1) */
  disabled: boolean;
  /** Division 콤보 응답을 페이지와 공유(권한 0건 판정 주체는 페이지) */
  onDivisionRows: (rows: ComboResponse[] | undefined) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 조회조건 3콤보 — 전건 재조회 방식(BIGFILTER_ 접두 없음, filterCalls 0건).
//   Division 변경 하나로 PlanYear+PlanWeek 가 함께 재조회된다(쿼리 파라미터에 division 이 실려
//   참조가 갈리는 방식 — AS-IS SetChangedControl 단일 핸들러 직렬 처리 등가, design 02 §3).
export const PlanManagementForm = ({ onSearch, disabled, onDivisionRows }: Props) => {
  const { t } = useTranslation();

  const sc = usePlanManagementStore(s => s.searchParams);
  const set = usePlanManagementStore(s => s.setSearchParams);
  const openSearchArea = usePlanManagementStore(s => s.openSearchArea);

  // 값 인용은 apiClient.getCombo 가 자동 처리(raw 전달) — mnuId 는 BE 가 인용 주체(nscm-patterns §3.3).
  //   Division: @mnuId 미전달 시 메뉴권한 조건이 통째로 스킵되는 방향으로 조용히 느슨해짐(design 02 §2 #1) — 필수.
  //   Year 는 DB 콤보가 아니라 클라 당해년도 고정(사용자 2026-10-14). PlanWeek(PlanWeekDate_SCP)는
  //   그 당해년도를 @planYear 토큰으로 받는 standalone 콤보 — division/year cascade 없음(design 02 의
  //   PlanWeek cascade 를 교체). AS-IS PlanWeek(division+year 종속)와 다름.
  const currentYear = String(new Date().getFullYear());

  const [divisions, planWeeks] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.PLAN_WEEK, planYear: currentYear },
    ],
  });

  const divisionOptions = toOptions(divisions);
  // Year 는 당해년도 한 건만 노출(사용자 2026-10-14)
  const yearOptions: Option[] = [{ label: currentYear, value: currentYear }];
  // PlanWeekDate_SCP 응답은 CODE/NAME 이 아니라 WEEK_LIST(라벨)/PLAN_WEEK(값=WEEK_NAME) —
  //   AS-IS PlanWeek 의 CODE=WEEK_NAME·NAME=날짜-주차와 의미 동일, 컬럼명만 다르다.
  const planWeekOptions: Option[] = (planWeeks ?? []).map(r => ({
    label: str(r.WEEK_LIST) || str(r.PLAN_WEEK),
    value: str(r.PLAN_WEEK),
  }));

  // 권한 0건 판정(alert 1회 + Engine 툴바 disabled)은 페이지가 담당 — 응답만 올린다
  useEffect(() => {
    onDivisionRows(divisions);
  }, [divisions, onDivisionRows]);

  // 첫 값 자동 선택(AS-IS clsCtrl.setListBox 기본 동작, ALL 옵션 없음 — design 02 §4)
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) set({ divisionId: firstDivision });
  }, [firstDivision, hasDivision, set]);

  // Year 당해년도 고정 — 비었거나(최초·Division 변경 리셋 후) 다른 값이면 당해년도로 복원
  const hasYear = sc.planYear === currentYear;
  useEffect(() => {
    if (!hasYear) set({ planYear: currentYear });
  }, [hasYear, currentYear, set]);

  const firstPlanWeek = planWeekOptions[0]?.value ?? '';
  const hasPlanWeek = planWeekOptions.some(o => o.value === sc.planWeek);
  useEffect(() => {
    if (firstPlanWeek && !hasPlanWeek) set({ planWeek: firstPlanWeek });
  }, [firstPlanWeek, hasPlanWeek, set]);

  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required: boolean
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
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 표준 조회 버튼 라벨 'Search(F5)' (LBL00112) — 미지정 시 SearchArea 기본값 '조회' 가 떠 비표준으로 보임
      searchButtonLabel={t('LBL00112', '_Search')}
      conditions={
        <>
          {/* 캡션·LBL = SCM_ADM_MSG_M 실측(design 02 §4.5). PlanWeek 캡션은 AS-IS 그대로
              "Plan Date*"(필수 표시)이나 실제 필수검증에서는 제외(ConditionNotUseList — design 02 §4 순서1) */}
          {single(t(LBL.DIVISION, '_Div'), sc.divisionId, divisionOptions, v => set({ divisionId: v }), true)}
          {single(t(LBL.YEAR, '_Year'), sc.planYear, yearOptions, v => set({ planYear: v }), true)}
          {single(t(LBL.PLAN_DATE, '_Plan Date'), sc.planWeek, planWeekOptions, v => set({ planWeek: v }), true)}
        </>
      }
    />
  );
};
