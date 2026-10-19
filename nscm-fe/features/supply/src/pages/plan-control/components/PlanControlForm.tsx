import { useEffect, useMemo } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { LBL, MSG } from '../plan-control.constants';
import type { PlanGroupRow } from '../plan-control.types';
import { usePlanControlStore } from '../usePlanControlStore';
import { str, toComboOptions } from '../utils/planControl.activity';

interface Props {
  onSearch: () => void;
  // Division 후보 = 권한 Division ∩ Plan Group 보유 Division(F01). 두 원천이 모두 도착해야 계산되므로
  //   page 가 계산해 내려준다 — Form 이 직접 두 쿼리를 들면 역방향 의존(F01)이 드러나지 않는다.
  divisionOptions: { label: string; value: string }[];
  // 권한 Division 0건(R07 — F01 교집합 적용 **전** 목록 기준). 조회영역 전체 잠금 + 안내 1회.
  //   화면을 숨기지는 않는다. Search 시점 차단(R08)은 교집합 후 후보 수를 보는 별개 축이다.
  noAuthDivision: boolean;
  planGroups: PlanGroupRow[] | undefined;
  planDates: { CODE?: unknown; NAME?: unknown; DIVISION_ID?: unknown }[] | undefined;
  // 일단위 Plan Date 모드(R01~R03) — OPMZ_DIVISION_GM 집합에 현재 Division 이 있으면 true.
  isDailyPlanDateMode: boolean;
}

// yyyyMMdd -> Dayjs (ISO 조립 — customParseFormat 플러그인 비의존, 자매 ending-inventory 선례).
const ymdToDayjs = (ymd: string): ReturnType<typeof dayjs> | null =>
  /^\d{8}$/.test(ymd) ? dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`) : null;

// AS-IS usrConditionPanel1 + usrLayoutControl1 (조건 4개 = 동시 노출 3개).
//   Plan Date 2개(주단위 콤보 / 일단위 DatePicker)는 라벨이 같은 LBL00039 라 **반드시 배타**여야 한다 —
//   동시에 보이면 "Plan Date" 가 2개 뜬다(R02). 동시 노출이 3필드라 extraConditions 접기는 미해당.
export const PlanControlForm = ({
  onSearch,
  divisionOptions,
  noAuthDivision,
  planGroups,
  planDates,
  isDailyPlanDateMode,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const sc = usePlanControlStore(state => state.searchParams);
  const setSearchParams = usePlanControlStore(state => state.setSearchParams);
  const openSearchArea = usePlanControlStore(state => state.openSearchArea);

  const tabId = useTabid();

  // F02 — Plan Group 은 선택 Division 으로 좁히고 중복을 제거한다. 정렬은 SP 순서를 유지한다
  //   (SP 가 UPPER(REPLACE(...)) 로 AS-IS collation 을 재현했다 — sortBy 를 주면 어긋난다).
  const planGroupOptions = useMemo(
    () =>
      sc.divisionId
        ? toComboOptions(
            (planGroups ?? []).filter(
              (row, index, list) =>
                str(row.DIVISION_ID) === sc.divisionId &&
                list.findIndex(item => str(item.CODE) === str(row.CODE)) === index
            )
          )
        : [],
    [planGroups, sc.divisionId]
  );

  // F04 — Plan Date(주단위) 후보도 Division 필터. SP 가 PLAN_NAME DESC 로 내리므로 최신 주가 맨 위다.
  const planDateOptions = useMemo(
    () =>
      sc.divisionId
        ? toComboOptions((planDates ?? []).filter(row => str(row.DIVISION_ID) === sc.divisionId))
        : [],
    [planDates, sc.divisionId]
  );

  // R07 — mount 시 Division 후보 0건이면 안내 1회 + 조회영역 전체 비활성.
  //   AS-IS MSG00097 을 그대로 쓰면 오매핑이다(TO-BE MSG00097 = "Please select Division.").
  useEffect(() => {
    if (noAuthDivision) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH_DIVISION, '_No authority assigned.') });
    }
  }, [noAuthDivision, setAlert, t]);

  // R04 — 일단위 모드로 전이할 때마다 DatePicker 값을 오늘로 리셋한다(전 값 유지 금지).
  useEffect(() => {
    if (!isDailyPlanDateMode) return;
    setSearchParams({ planDate: dayjs().format('YYYYMMDD') });
  }, [isDailyPlanDateMode, sc.divisionId, setSearchParams]);

  // AS-IS 는 setListBox(DataSource 바인딩)라 후보가 실리는 순간 첫 항목이 선택된다(design 02 §4 기본선택:
  //   Division 첫 행 / Plan Group 첫 행 / Plan Date 주단위는 SP DESC 정렬이라 가장 최근 주).
  //   TO-BE CustomDropdown 은 자동 선택을 하지 않으므로 값이 비었을 때만 첫 후보를 채워 파리티를 맞춘다.
  useEffect(() => {
    if (sc.divisionId || divisionOptions.length === 0) return;
    setSearchParams({ divisionId: divisionOptions[0]?.value ?? '' });
  }, [divisionOptions, sc.divisionId, setSearchParams]);

  useEffect(() => {
    if (sc.planGroupId || planGroupOptions.length === 0) return;
    setSearchParams({ planGroupId: planGroupOptions[0]?.value ?? '' });
  }, [planGroupOptions, sc.planGroupId, setSearchParams]);

  useEffect(() => {
    if (isDailyPlanDateMode || sc.planDateCode || planDateOptions.length === 0) return;
    setSearchParams({ planDateCode: planDateOptions[0]?.value ?? '' });
  }, [isDailyPlanDateMode, planDateOptions, sc.planDateCode, setSearchParams]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — 단일 select. 값=DIVISION_ID, 표시=`DIVISION_ID DIVISION_NAME` */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경(싱글 콤보) = 하위 조건(Plan Group/Plan Date) 초기화 + 상·하 그리드 초기화
                  //   (store setSearchParams 가 수행, TO-BE 공통 요건). 편집중(dirty)이면 MSG00704 confirm
                  //   후에만 실행하고, 취소 시 controlled 콤보가 이전 Division 으로 복귀한다(commit 51d4e9fa 패턴,
                  //   정본 SCP0025). Search 버튼 공용 가드와 동일 경로('search').
                  onChange={(_, picked) => {
                    const next = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setSearchParams({ divisionId: next });
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Plan Group — searchInfo SP 의 planGroupList 커서. 콤보 레지스트리가 아니다(X14) —
              이름이 비슷한 PlanGroup/PlanGroup_SCP_ALL 은 owner 필터가 없어 후보가 넓어진다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_GROUP, '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={noAuthDivision}
                  value={sc.planGroupId}
                  options={planGroupOptions}
                  onChange={(_, picked) => setSearchParams({ planGroupId: String(picked ?? '') })}
                />
              )}
            />
          </Grid>

          {/* Plan Date — 배타 1개. 일단위(OPMZ_DIVISION_GM Division)면 DatePicker, 아니면 주단위 콤보 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_DATE, '_Plan Date')}
              labelAlign='right'
              render={() =>
                isDailyPlanDateMode ? (
                  <DatePickerCalendar
                    usecase='date'
                    size='small'
                    elevation
                    disabled={noAuthDivision}
                    value={ymdToDayjs(sc.planDate)}
                    onChange={
                      ((date: ReturnType<typeof dayjs> | null) => {
                        // 표시는 yyyy-MM-dd, SP 전달은 yyyyMMdd (hook #87 §V).
                        setSearchParams({ planDate: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                ) : (
                  <CustomDropdown
                    disabled={noAuthDivision}
                    value={sc.planDateCode}
                    options={planDateOptions}
                    onChange={(_, picked) => setSearchParams({ planDateCode: String(picked ?? '') })}
                  />
                )
              }
            />
          </Grid>
        </>
      }
    />
  );
};
